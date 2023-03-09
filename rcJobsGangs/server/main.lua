-- Variables
--- populates QBCore table
local Ra93Core = exports['qb-core']:GetCoreObject()
--- NUI Vehicle Button List Table
local vehBtnList = {}
local printColors = {
 --[[ Color Notes
  ["black"] = "^0",
  ["red"] = "^1",
  ["green"] = "^2",
  ["yellow"] = "^3",
  ["blue"] = "^4",
  ["lightBlue"] = "^5",
  ["purple"] = "^6",
  ["white"] = "^7",
  ["orange"] = "^8",
  ["grey"] = "^9"
 ]]--
 ["error"] = {
  ["console"] = "^1",
  ["log"] = "red"
 },
 ["success"] = {
  ["console"] = "^2",
  ["log"] = "green"
 },
 ["notice"] = {
  ["console"] = "^4",
  ["log"] = "blue"
 },
 ["exploit"] = {
  ["console"] = "^8",
  ["log"] = "orange"
 },
}
--- Counts Number of Vehicles a given Job has assigned.
local vehCount = {}
--- Tracks all vehicles spawned by players
local vehTrack = {}
-- local jobsList = {}
--- Populates  the server side Ra93Core.shared.Jobs table at resource start
exports['qb-core']:AddJobs(Config.Jobs)
exports['qb-core']:AddGangs(Config.Gangs)
-- Functions
--- places commas into numbers | credit https://lua-users.org/wiki/FormattingNumbers
local comma_value = function(amount)
 local k
 amount = tostring(amount)
 while true do
  amount, k = string.gsub(amount, "^(-?%d+)(%d%d%d)", '%1, %2')
  if (k==0) then
   break
  end
 end
 return string.format("%s%s", Config.currencySymbol, amount)
end
--- SQL handler
local sqlHandler = function(sql)
 local output = {}
 local queryResult = MySQL.query.await(sql.query,{},function(result)
  if next(result) then cb(result)
  else cb(nil) end
 end)
 if not queryResult then
  output.error = {
   ["subject"] = "SQL Query Failed",
   ["msg"] = string.format("SQL Query Failed, from: %s", sql.from),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["sys"] = {
    ["log"] = true,
    ["console"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 output.result = queryResult
 return output.result
end
--- switches between job or gang
local selectJobGang = function(jobGangType, playerJob, playerGang)
 local output = {
  ["Jobs"] = {
   ["conf"] = Config[jobGangType][playerJob.name],
   ["jgd"] = playerJob,
   ["pd"] = {
    ["type"] = "job",
    ["types"] = "jobs",
    ["history"] = "jobhistory",
    ["current"] = "currentJob",
    ["currentName"] = "currentJobName",
    ["label"] = "employees",
    ["pastLabel"] = "pastEmployees",
    ["prev"] = "jgPrev",
    ["set"] = "SetJob",
    ["add"] = "AddToJobs",
    ["addHistory"] = "AddToJobHistory",
    ["remove"] = "RemoveFromJobs",
    ["civilian"] = "unemployed",
    ["active"] = "SetActiveJob"
   }
  },
  ["Gangs"] = {
   ["conf"] = Config[jobGangType][playerGang.name],
   ["jgd"] = playerGang,
   ["pd"] =  {
    ["type"] = "gang",
    ["types"] = "gangs",
    ["history"] = "ganghistory",
    ["current"] = "currentGang",
    ["currentName"] = "currentGangName",
    ["label"] = "members",
    ["pastLabel"] = "pastMembers",
    ["prev"] = "prevGang",
    ["set"] = "SetGang",
    ["add"] = "AddToGangs",
    ["addHistory"] = "AddToGangHistory",
    ["remove"] = "RemoveFromGangs",
    ["civilian"] = "none",
    ["active"] = "SetActiveGang"
   }
  }
 }
 return output[jobGangType]
end
--- Populates the server side Ra93Core.shared.Jobs table
local populateJobsNGangs = function(src)
 CreateThread(function()
  exports['qb-core']:AddJobs(Config.Jobs)
  for k, v in pairs(Config.Jobs) do
   TriggerClientEvent('QBCore:Client:OnSharedUpdate', src, "Jobs", k,v)
  end
 end)
 CreateThread(function()
  exports['qb-core']:AddGangs(Config.Gangs)
  for k, v in pairs(Config.Gangs) do TriggerClientEvent('QBCore:Client:OnSharedUpdate', src, "Gangs", k,v) end
 end)
end
--- Sends webhook from config to qb-smallresources
local sendWebHooks = function()
 for _,v in pairs(Config.Jobs) do
  if v.webHooks then exports['qb-smallresources']:addToWebhooks(v.webHooks) end
 end
end
--- Checks if underling is online
local setUnderlingStatus = function(res)
 local src = res.src
 local citid = res.citid
 local output = {
  ["isOnline"] = true,
  ["player"] = {}
 }
 output.player = Ra93Core.functions.getPlayer(src)
 if not output.player or not next(output.player) then output.player = Ra93Core.functions.getPlayerByCitizenId(citid) end
 if not output.player or not next(output.player) then
  output.player = Ra93Core.player.GetOfflinePlayer(citid)
  output.isOnline = false
 end
 if not output.player or not next(output.player) then
  output.error = {
   ["subject"] = "Player Does Not Exist!",
   ["msg"] = string.format("player does not exist in setUnderlingStatus! #msg001"),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["sys"] = {
    ["log"] = true,
    ["console"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 return output
end
--- Prepares data for the buildJobHistory function for the current player
local processHistory = function(hData, jobGangType)
 local output, history
 --- Builds the Job History metadata table.
 local buildHistory = function(res)
  local pd = res.pd
  pd.name = res[pd.type]
  if not res[pd.name] then res[pd.name] = {} end
  if pd.name == "unemployed" or pd.name == "none" then return nil end
  local jgd, status
  local history = {}
  if res.player.playerData.metadata[pd.history] then history = res.player.playerData.metadata[pd.history] end
  if history and history[pd.name] and history[pd.name].status then status = history[pd.name].status end
  local hList = {
   ["status"] = "available",
   ["awards"] = {},
   ["details"] = {},
   ["grades"] = {},
   ["reprimands"] = {},
   ["applycount"] = 0,
   ["denycount"] = 0,
   ["firedcount"] = 0,
   ["gradechangecount"] = 0,
   ["hiredcount"] = 0,
   ["quitcount"] = 0,
  }
  local index = {
   ["reprimands"] = 1,
   ["awards"] = 1,
   ["details"] = 1,
   ["grades"] = 1
  }
  for k in pairs(Config[jobGangType]) do
   if not history[k] then history[k] = hList end
  end
  history["none"] = nil
  history["unemployed"] = nil
  jgd = history[pd.name]
  for kp, vp in pairs(hList) do
   if type(vp) == "table"  then
    if res[pd.name][kp] then
     if jgd[kp] then
      for _ in pairs(jgd[kp]) do index[kp] += 1 end
     end
     if index[kp] == 0 then index[kp] = 1 end
     for _,v in pairs(res[pd.name][kp]) do
      jgd[kp][index[kp]] = v
      index[kp] += 1
     end
    end
   elseif type(vp) == "number" then
    if not res[pd.name][kp] then res[pd.name][kp] = 0 end
    jgd[kp] += res[pd.name][kp]
   elseif kp == "status" then
    if res[pd.name][kp] then jgd[kp] = res[pd.name][kp] end
   end
  end
  if pd.name == "none" then jgd = nil end
  if pd.name == "unemployed" then jgd = nil end
  return jgd
 end
 if not hData.player then
  output = setUnderlingStatus(hData)
  hData.isOnline = output.isOnline
  hData.player = output.player
 end
 if not hData.player then return output end
 local playerJob = hData.player.playerData.job
 local playerGang = hData.player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 hData.pd = pd
 hData.error = {}
 hData.success = {}
 if not Config[jobGangType][hData[pd.type]] then
  output.error = {
   ["subject"] = "Job Does Not Exist",
   ["msg"] = "Job Does Not Exist in processHistory, msg001",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["sys"] = {
    ["log"] = true,
    ["console"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 history = buildHistory(hData)
 return history
end
--- Sets the job or gang up for the underling
local setJobGang = function(res, jobGangType)
 local output = setUnderlingStatus(res)
 if output.error and next(output.error) then return output end
 local player = output.player
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata = selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local jgd = cdata.jgd
 local pd = cdata.pd
 local jgPrev = res.jgPrev:lower() -- Boss Job
 local jgNew = res.jgNew:lower() -- Staff/Member Job
 local jg = res.jg:lower() -- Boss Job
 local grade = tostring(res.grade) -- Employee's Grade
 local citid = res.citid -- Employee's Citizen ID
 local metaData = player.playerData.metadata
 local src = res.src -- Manager's Source
 local queryResult, sql
 output[pd.type] = jg
 output[jg] = res[jg]
 output[pd.types] = metaData[pd.types]
 output[pd.history] = metaData[pd.history]
 local pD = {
  ["Jobs"] = {
   ["job"] = {
    ["name"] = jgNew,
    ["label"] = Config[jobGangType][jgNew].label,
    ["onduty"] = Config[jobGangType][jgNew].defaultDuty,
    ["type"] = Config[jobGangType][jgNew].type,
    ["grade"] = {
     ["name"] = Config[jobGangType][jgNew].grades[grade].name,
     ["level"] = tostring(grade),
     ["payment"] = Config[jobGangType][jgNew].grades[grade].payment
    }
   },
   ["jobs"] = {
    [jg] = nil,
    [jgNew] = jgNew
   },
   ["jgData"] = metaData.jobs,
   ["metadata"] = metaData
  },
  ["Gangs"] = {
   ["gang"] = {
    ["name"] = jgNew,
    ["label"] = Config[jobGangType][jgNew].label,
    ["onduty"] = Config[jobGangType][jgNew].defaultDuty,
    ["type"] = Config[jobGangType][jgNew].type,
    ["grade"] = {
     ["name"] = Config[jobGangType][jgNew].grades[grade].name,
     ["level"] = tostring(grade),
    }
   },
   ["gangs"] = {
    [jg] = nil,
    [jgNew] = jgNew
   },
   ["jgData"] = metaData.gangs,
   ["metadata"] = metaData
  },
  ["citid"] = res.citid
 }
 local jgSel = {
  ["Jobs"] = {
   ["job"] = jg,
   [jg] = res[jg],
   ["jobs"] = metaData.jobs,
   ["history"] = metaData.jobhistory,
   ["grade"] = Config[jobGangType][jgNew].grades[grade]
  },
  ["Gangs"] = {
   ["gang"] = jg,
   [jg] = res[jg],
   ["gangs"] = metaData.gangs,
   ["history"] = metaData.ganghistory,
   ["grade"] = Config[jobGangType][jgNew].grades[grade]
  }
 }
 local jgs = jgSel[jobGangType]
 for k, v in pairs(jgs) do output[k] = v end
 local history = processHistory(output,jobGangType)
 if not jgs[jg] then
  output.error = {
   ["subject"] = "Job does not exist!",
   ["msg"] = string.format("%s attempted to set a job that didn't exist in setJobGang msg#003", player.playerData.license),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["sys"] = {
    ["log"] = true,
    ["console"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if output.isOnline then
  player.Functions[pd.set](jgNew, grade)
  player = Ra93Core.functions.getPlayerByCitizenId(citid)
  player.Functions[pd.addHistory](jgPrev,history)
  player.Functions[pd.add](jgPrev, nil)
  player.Functions[pd.add](player.playerData[pd.type].name, player.playerData[pd.type])
  player = Ra93Core.functions.getPlayerByCitizenId(citid)
  output.player = player
 else
  pD[jobGangType].metadata[pd.types][jgNew] = nil
  pD[jobGangType].metadata[pd.types][jgNew] = pD[jobGangType][pd.type]
  if not jgs.history then jgs.history = {} end
  sql = {
   ["query"] = string.format("UPDATE `players` SET `%s` = '%s', `metadata` = '%s' WHERE `citizenid` = '%s'", pd.type, json.encode(pD[jobGangType][pd.type]), json.encode(pD[jobGangType].metadata), pD.citid),
   ["from"] = "qb-jobs/server/main.lua > function > setJob"
  }
  queryResult = sqlHandler(sql)
  if queryResult.error and next(queryResult.error) then return queryResult end
  output.success = {
   ["subject"] = "User Data Saved",
   ["msg"] = string.format("JobHistory Update Success"),
   ["jsMsg"] = "User Saved!",
   ["color"] = "success",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["sys"] = {
    ["log"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.success)
  output.player = Ra93Core.player.GetOfflinePlayer(citid)
 end
 return output
end
--- Checks for Duplicate Jobs / Gangs
local checkUniqueJobGang = function()
 local output = {["counter"] = {}}
 local countPop = function(conf)
  for k in pairs(conf) do
   if output.counter[k] then
    output.error = {
     ["subject"] = "Duplicate Job & Gang",
     ["msg"] = string.format("%s is a dupe! Job & gang names must be unique.", k),
     ["color"] = "error",
     ["logName"] = "qbjobs",
     ["src"] = src,
     ["sys"] = {
      ["log"] = true,
      ["console"] = true
     }
    }
    Ra93Core.functions.messageHandler(output.error)
   end
   output.counter[k] = 0
  end
  return output
 end
 countPop(Config.Jobs)
 countPop(Config.Gangs)
 return output
end
--- Prepares keys for the vehPop table
local countVehPop = function()
 local countPop = function(conf)
  local output = {}
  for k in pairs(conf) do vehCount[k] = 0 end
 end
 countPop(Config.Jobs)
 countPop(Config.Gangs)
end
--- Updates Duty Blips
local updateBlips = function()
 local dutyPlayers = {}
 local publicPlayers = {}
 local players = Ra93Core.functions.getQBPlayers()
 for _,v in pairs(players) do
  if Config.Jobs[v.PlayerData.job.name] and Config.Jobs[v.PlayerData.job.name].DutyBlips then
   local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
   local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
   if Config.Jobs[v.PlayerData.job.name].DutyBlips.type == "service" and v.PlayerData.job.onduty then
    dutyPlayers[#dutyPlayers+1] = {
     ["source"] = v.PlayerData.source,
     ["label"] = v.PlayerData.metadata["callsign"],
     ["job"] = v.PlayerData.job.name,
     ["location"] = {
      ["x"] = coords.x,
      ["y"] = coords.y,
      ["z"] = coords.z,
      ["w"] = heading
     }
    }
   elseif Config.Jobs[v.PlayerData.job.name].DutyBlips.type == "public" then
    publicPlayers[#publicPlayers+1] = {
     ["source"] = v.PlayerData.source,
     ["label"] = v.PlayerData.metadata["callsign"],
     ["job"] = v.PlayerData.job.name,
     ["location"] = {
      ["x"] = coords.x,
      ["y"] = coords.y,
      ["z"] = coords.z,
      ["w"] = heading
     }
    }
   end
  end
 end
 TriggerClientEvent("qb-jobs:client:updateBlips",-1, dutyPlayers, publicPlayers)
end
--- Sends Email to Phones
local sendEmail = function(mail)
 local mailData = {}
 mailData.sender = mail.sender
 mailData.subject = mail.subject
 mailData.message = mail.message
 mailData.button = {}
 exports["rcPhone"]:sendNewMailToOffline(mail.recCitID, mailData)
end
--- Submits Job Applications
local submitApplication = function(res, jobGangType)
 local msg, history
 local src = res.src
 local player = Ra93Core.functions.getPlayer(src)
 local metaData = player.playerData.metadata
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local citid = player.playerData.citizenid
 local charInfo = player.playerData.charinfo
 local output = {}
 local jgd = {
  [pd.type] = res[pd.type]:lower(),
  ["newGradeLevel"] = 0,
  ["newGradeLevelName"] = "No Grades",
  ["history"] = nil
 }
 if metaData[pd.history][jgd[pd.type]] then jgd.history = metaData[pd.history][jgd[pd.type]] end
 local jgInfo = Config[jobGangType][res[pd.type]]
 local gender = Lang:t('email.mr')
 if charInfo.gender == 1 then gender = Lang:t('email.mrs') end
 local hData = {
  ["src"] = res.src,
  ["citid"] = citid,
  [pd.type] = jgd[pd.type],
  [jgd[pd.type]] = {
   ["details"] = {},
   ["grades"] = {},
   ["status"] = "available",
   ["gradechange"] = 0,
   ["applycount"] = 0,
   ["hiredcount"] = 0,
  },
  ["player"] = player,
  ["index"] = {
   ["details"] = 1,
   ["grades"] = 1
  },
  [pd.history] = metaData[pd.history],
  ["isOnline"] = true
 }
 if metaData[pd.types][jgd[pd.type]] then
  output.error = {
   ["subject"] = "Already Employed",
   ["msg"] = string.format("%s %s is already employed in %s", charInfo.firstname, charInfo.firstname, jgd[pd.type]),
   ["jsMsg"] = "Already Employed!",
   ["src"] = src,
   ["color"] = "notice",
   ["logName"] = "qbjobs",
   ["sys"] = {
    ["log"] = true,
    ["notify"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if jgd.history and jgd.history.status == "pending" then
  output.error[0] = {
   ["subject"] = "Application Pending",
   ["msg"] = string.format("%s %s is application pending in %s", charInfo.firstname, charInfo.lastname, jgd[pd.type]),
   ["jsMsg"] = "Application Pending!",
   ["src"] = src,
   ["color"] = "notice",
   ["logName"] = "qbjobs",
   ["log"] = true,
   ["notify"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if jgd.history and jgd.history.status == "blacklisted" then
  output.error[0] = {
   ["subject"] = "Application Refused",
   ["msg"] = string.format("%s %s is blacklisted in %s", charInfo.firstname, charInfo.lastname, jgd[pd.type]),
   ["jsMsg"] = "Application Refused!",
   ["src"] = src,
   ["color"] = "notice",
   ["logName"] = "qbjobs",
   ["log"] = true,
   ["notify"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if jgInfo then
  if res.grade then jgd.newGradeLevel = res.grade end
  if tonumber(jgd.newGradeLevel) ~= 0 then jgd.newGradeLevelName = jgInfo.grades[jgd.newGradeLevel].name end
  if jgInfo.bosses and not jgInfo.bosses[citid] then
   hData[hData[pd.type]].applycount += 1
   hData[hData[pd.type]].status = "pending"
   hData[hData[pd.type]].details[hData.index.details] = string.format("applied for %s", jgd[pd.type])
   hData.index.details += 1
   output.citid = citid
   output.sender = Lang:t('email.jobAppSender',{firstname = charInfo.firstname, lastname = charInfo.lastname})
   output.subject = Lang:t('email.jobAppSub',{lastname = charInfo.lastname, job = res.job})
   output.message = Lang:t('email.jobAppMsg',{gender = gender, lastname = charInfo.lastname, job = res.job, firstname = charInfo.firstname, phone = charInfo.phone})
   output.success[0] = {
    ["subject"] = "Application Submitted",
    ["msg"] = Lang:t('info.new_job_app',{job = jgInfo.label}),
    ["jsMsg"] = "Application Submitted!",
    ["src"] = src,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
   for k in pairs(jgInfo.bosses) do
    CreateThread(function()
     SetTimeout(math.random(1000, 2000),function()
      output.recCitID = k
      sendEmail(output)
     end)
    end)
   end
  elseif not jgInfo.bosses or jgInfo.bosses[citid] then
   jgd.newGradeLevel = "1"
   jgd.newGradeLevelName = Config[jobGangType][jgd[pd.type]].grades[jgd.newGradeLevel].name
   if jgInfo.bosses then
    local tmp = 1
    while jgInfo.grades[tostring(tmp)] do
     jgd.newGradeLevel = tmp
     tmp += 1
    end
    jgd.newGradeLevel = tostring(jgd.newGradeLevel)
    jgd.newGradeLevelName = jgInfo.grades[jgd.newGradeLevel].name
   end
   hData[hData[pd.type]].status = "hired"
   hData[hData[pd.type]].hiredcount += 1
   hData[hData[pd.type]].grades[hData.index.grades] = jgd.newGradeLevel
   hData.index.grades += 1
   hData[hData[pd.type]].details[hData.index.details] = string.format("Hired on as %s", jgd.newGradeLevelName)
   hData.index.details += 1
   player.Functions[pd.set](jgd[pd.type], jgd.newGradeLevel)
   player = Ra93Core.functions.getPlayer(src)
   player.Functions[pd.add](player.playerData[pd.type].name, player.playerData[pd.type])
   player = Ra93Core.functions.getPlayer(src)
   output.success[0] = {
    ["subject"] = string.format("%s New Hire!", jgd[pd.type]),
    ["msg"] = string.format("Hired onto %s as %s", jgd[pd.type], jgd.newGradeLevelName),
    ["jsMsg"] = string.format("Hired onto %s as %s", jgd[pd.type], jgd.newGradeLevelName),
    ["src"] = src,
    ["color"] = "success",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  else
   output.error[0] = {
    ["subject"] = "Exploit Attempt: Boss Menu!",
    ["msg"] = string.format("%s attempted to exploit the Boss Menu through attempting of submitting insufficent data. submitApplication0001", player.playerData.license),
    ["jsMsg"] = "Exploit Failed!",
    ["color"] = "exploit",
    ["logName"] = "exploit",
    ["src"] = src,
    ["log"] = true,
    ["console"] = true
   }
   Ra93Core.functions.messageHandler(output.error)
   return output
  end
 end
 history = processHistory(hData, jobGangType)
 if history and history.error then return history end
 player.Functions[pd.addHistory](hData[pd.type], history)
 player = Ra93Core.functions.getPlayer(src)
 output.player = player
 return output
end
--- Send jobs to city hall
local sendToCityHall = function()
 local isManaged, toCH
 for k, v in pairs(Config.Jobs) do
  isManaged = false
  if v.bosses then isManaged = true end
  if v.listInCityHall then
   toCH = {
    ["label"] = v.label,
    ["isManaged"] = isManaged
   }
   exports['rcGovernment']:AddCityJob(k, toCH)
  end
 end
end
--- sends MotorworksConfig table to qb-customs
local sendToCustoms = function()
 local output = {}
 for k, v in pairs(Config.Jobs) do output[k] = v.motorworksConfig end
 exports["rcMotorworks"]:buildLocations(output)
end
--- Generates list to pupulate the boss menu
local buildManagementData = function(src, jobGangType)
 local personal, hList, sql, queryResult
 local player = Ra93Core.functions.getPlayer(src)
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local jgd = cdata.jgd
 local players = Ra93Core.functions.getQBPlayers()
 local jobCheck = {}
 local plist = {}
 local hData = {}
 local societyAccounts = exports["qb-banking"]:sendSocietyAccounts(src, pd.name)
 local mgrBtnList = {
  ["players"] = {},
  ["jobs"] = {},
  ["gangs"] = {},
  ["error"] = {},
  ["success"] = {},
  ["jg"] = jgd,
  ["pd"] = pd
 }
 local pending = function(v, k1)
  mgrBtnList[pd.types][k1].applicants[v.citid] = {}
  mgrBtnList[pd.types][k1].applicants[v.citid].personal = personal
  mgrBtnList[pd.types][k1].applicants[v.citid].history = hList
  if v.metadata.rapsheet then mgrBtnList[pd.types][k1].applicants[v.citid].rapSheet = v.metadata.rapsheet end
 end
 local hired = function(v, k1)
  personal.position = v.metadata[pd.types][k1].grade
  if k1 == pd.name and v.metadata[pd.types] and v.metadata[pd.types][k1] then
   if pd.type == "job" then personal.payRate = v.metadata[pd.types][k1].payment end
  end
  mgrBtnList[pd.types][k1][pd.label][v.citid] = {}
  mgrBtnList[pd.types][k1][pd.label][v.citid].personal = personal
  mgrBtnList[pd.types][k1][pd.label][v.citid].history = hList
  if v.metadata.rapsheet then mgrBtnList[pd.types][k1][pd.label][v.citid].rapSheet = v.metadata.rapsheet end
 end
 local quit = function(v, k1)
  mgrBtnList[pd.types][k1][pd.pastLabel][v.citid] = {}
  mgrBtnList[pd.types][k1][pd.pastLabel][v.citid].personal = personal
  mgrBtnList[pd.types][k1][pd.pastLabel][v.citid].history = hList
  if v.metadata.rapsheet then mgrBtnList[pd.types][k1][pd.pastLabel][v.citid].rapSheet = v.metadata.rapsheet end
 end
 local denied = function(v, k1)
  mgrBtnList[pd.types][k1].deniedApplicants[v.citid] = {}
  mgrBtnList[pd.types][k1].deniedApplicants[v.citid].personal = personal
  mgrBtnList[pd.types][k1].deniedApplicants[v.citid].history = hList
  if v.metadata.rapsheet then mgrBtnList[pd.types][k1].deniedApplicants[v.citid].rapSheet = v.metadata.rapsheet end
 end
 local blacklist = function(v, k1)
  mgrBtnList[pd.types][k1].blacklist[v.citid] = {}
  mgrBtnList[pd.types][k1].blacklist[v.citid].personal = personal
  mgrBtnList[pd.types][k1].blacklist[v.citid].history = hList
  if v.metadata.rapsheet then mgrBtnList[pd.types][k1].blacklist[v.citid].rapSheet = v.metadata.rapsheet end
 end
 local buildSQL = function()
  sql = {
   ["query"] = string.format("SELECT `citizenid` AS 'citid',`charinfo`,`metadata`,`license` FROM `players` WHERE JSON_VALUE(`metadata`,'$.%shistory.%s.status') != 'available'", pd.type, jgd.name),
   ["from"] = "qb-jobs/server/main.lua > function > buildManagementData"
  }
  return sql
 end
 local status = {
  ["pending"] = {["func"] = pending},
  ["hired"] = {["func"] = hired},
  ["quit"] = {["func"] = quit},
  ["fired"] = {["func"] = quit},
  ["blacklisted"] = {["func"] = blacklist},
  ["denied"] = {["func"] = denied}
 }
 sql = buildSQL()
 queryResult = sqlHandler(sql)
 if queryResult.error and next(queryResult.error) then return queryResult end
 for _,v in pairs(players) do
  plist[v.PlayerData.citizenid] = {
   ["PlayerData"] = {
    ["metadata"] = v.PlayerData.metadata,
    ["charinfo"] = v.PlayerData.charinfo,
    ["source"] = v.PlayerData.source,
    ["license"] = v.PlayerData.license
   }
  }
 end
 if queryResult then
  for _,v in pairs(queryResult) do
   hData.citid = v.citid
   mgrBtnList.players[v.citid] = {["PlayerData"] = {}}
   if plist[v.citid] then
    v.metadata = nil
    v.metadata = plist[v.citid].PlayerData.metadata
    v.charinfo = nil
    v.charinfo = plist[v.citid].PlayerData.charinfo
    v.source = nil
    v.source = plist[v.citid].PlayerData.source
    v.license = nil
    v.license = plist[v.citid].PlayerData.license
   else
    v.metadata = json.decode(v.metadata)
    v.charinfo = json.decode(v.charinfo)
   end
   hList = v.metadata[pd.history]
   if not hList or not next(hList) then hList = processHistory(hData, jobGangType) end
   if Config.hideAvailableJobs then
    hList = nil
    hList = {}
    for k1, v1 in pairs(v.metadata[pd.history]) do
     --hList[k1] = v1
     --if v1.status == "available" then hList[k1] = nil end
     if v1.status ~= "available" then hList[k1] = v1 end
    end
   end
   mgrBtnList.players[v.citid].PlayerData.metadata = v.metadata
   mgrBtnList.players[v.citid].PlayerData.charinfo = v.charinfo
   mgrBtnList.players[v.citid].PlayerData.license = v.license
   personal = {
    ["firstName"] = v.charinfo.firstname,
    ["lastName"] = v.charinfo.lastname,
    ["gender"] = "male",
    ["phone"] = v.charinfo.phone
   }
   if v.charinfo.gender > 0 then personal.gender = "female" end
   if v.metadata and v.metadata[pd.history] then
    for k1, v1 in pairs(v.metadata[pd.history]) do
     if not jobCheck[k1] then
      jobCheck[k1] = true
      mgrBtnList[pd.types][k1] = {
       ["applicants"] = {},
       [pd.label] = {},
       [pd.pastLabel] = {},
       ["deniedApplicants"] = {},
       ["blacklist"] = {},
       ["society"] = {["balance"] = comma_value(societyAccounts.accounts[k1])},
       ["config"] = {["currencySymbol"] = Ra93Core.config.Money.CurrencySymbol}
      }
     end
     if v1.status ~= "available" then status[v1.status].func(v, k1) end
    end
   end
  end
 else
  mgrBtnList.error[0] = {
   ["subject"] = "Management Data Not Found",
   ["msg"] = string.format("Management Data Select Failure, buildManagementData msg#001"),
   ["jsMsg"] = "Select Error!",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(data.error)
 end
 return mgrBtnList
end
--- Staff / Member Manager for Gang and Job Boss
local manageStaff = function(res, jobGangType)
 local src = res.manager.src
 local manager = Ra93Core.functions.getPlayer(src)
 local managerJob = manager.PlayerData.job
 local managerGang = manager.PlayerData.gang
 local mcdata =  selectJobGang(jobGangType, managerJob, managerGang)
 local mconf = mcdata.conf
 local mjgd = mcdata.jgd
 local md = mcdata.pd -- employer job (also employee job)
 if not Config[jobGangType][mjgd.name].bosses[manager.PlayerData.citizenid] then
  local output = {
   ["error"] = {
    [0] = {
     ["subject"] = "Not a Manager",
     ["msg"] = string.format("Player is not a manager! %s", manager.PlayerData.license),
     ["jsMsg"] = "Not a Manager!",
     ["color"] = "exploit",
     ["logName"] = "qbjobs",
     ["src"] = src,
     ["log"] = true,
     ["console"] = true
    }
   }
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 local awrep = tonumber(1)
 if res.awrep then
  awrep = tonumber(res.awrep)
  if not Ra93Core.functions.prepForSQL(src, awrep, "^%d+$") then
   output.error[0] = true
   return output
  end
  awrep += 1
 end
 local citid = res.appcid
 local mgrBtnList = buildManagementData(src, jobGangType)
 if not mgrBtnList then
  output.error[0] = {
   ["subject"] = "Jobs Boss Menu Error",
   ["msg"] = "Unable to Build Mgmt Data in function: manageStaff",
   ["jsMsg"] = "Failure!",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if not mgrBtnList.players[citid] then
  output.error[0] = {
   ["subject"] = "Player Does not Exist",
   ["msg"] = string.format("%s does not exist in %s", citid, managerJob.name),
   ["jsMsg"] = string.format("%s does not exist!", citid),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 local sql, queryResult
 local staff = setUnderlingStatus(res)
 local metaData = staff.player.playerData.metadata
 local staffData = metaData[md.types][mjgd.name]
 if not staffData or not next(staffData) then
  staffData = {
   ["name"] = mjgd.name,
   ["label"] = mjgd.label,
   ["grade"] = {
    ["level"] = 1,
    ["name"] = Config[jobGangType][mjgd.name].grades["1"].name
   }
  }
 end
 local output = {
  ["citid"] = citid,
  ["jg"] = mjgd.name,
  ["staff"] = {
   ["data"] = staff,
   ["citid"] = citid,
   ["jg"] = mjgd.name
  },
  ["manager"] = {
   ["data"] = manager,
   ["src"] = src,
   ["citid"] = manager.PlayerData.citizenid,
   ["jg"] = mjgd.name,
  }
 }
 local approveManagerAction = function(info)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("Approval Alert"),
    ["msg"] = string.format("%s was approved with %s.", citid, mjgd.name),
    ["jsMsg"] = string.format("%s was approved.", citid),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  local grade = info.approve.grade
  local gradeName = mconf.grades[grade].name
  local deets = "hired onto"
  output.jgPrev = mjgd.name
  output.jgNew = mjgd.name
  if md.type == "gang" then
   deets = "jumped into"
   output.jgPrev = mjgd.name
   output.jgNew = mjgd.name
  end
  output.grade = grade
  output.gradeName = gradeName
  output[mjgd.name] = {
   ["hiredcount"] = 1,
   ["details"] = {string.format("was %s %s", deets, mjgd.name)},
   ["status"] = "hired"
  }
  output = setJobGang(output, jobGangType)
  if output.error and next(output.error) then return output end
  msgLoop(src)
  if staff.isOnline then msgLoop(staff.player.playerData.source) end
  return output
 end
 local awrepManagerAction = function(info)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("%s Alert", info[res.action].subject),
    ["msg"] = string.format('%s was %s: "%s" in %s', citid, info[res.action].details, info[res.action].awrep, mjgd.label),
    ["jsMsg"] = string.format('was %s: "%s"', info[res.action].details, info[res.action].awrep),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  output[md.type] = mjgd.name
  output[mjgd.name] = {
   ["details"] = {string.format('%s was %s: %s in %s', citid, info[res.action].details, info[res.action].awrep, mjgd.label)},
   [info[res.action].confs] = {info[res.action].awrep},
   ["status"] = "hired"
  }
  local history = processHistory(output, jobGangType)
  if staff.isOnline then
   output = staff.player.Functions[md.addHistory](mjgd.name, history)
   if output.error and next(output.error) then return output end
   msgLoop(src)
   msgLoop(staff.player.playerData.source)
   output = setUnderlingStatus(res)
   return output
  else
   metaData[md.history][md.type] = history
   sql = {
    ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
    ["from"] = "qb-jobs/server/main.lua > function > manageStaff > awrepManagerAction"
   }
   queryResult = sqlHandler(sql)
   if queryResult.error and next(queryResult.error) then return queryResult end
   output.player = Ra93Core.player.GetOfflinePlayer(citid)
  end
  if output.error and next(output.error) then return output end
  msgLoop(src)
  return output
 end
 local blacklistManagerAction = function(_)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("Blacklist Alert"),
    ["msg"] = string.format("%s was blacklisted with %s.", citid, mjgd.label),
    ["jsMsg"] = string.format("%s was blacklisted with %s.", citid, mjgd.label),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  output[md.type] = mjgd.name
  output[mjgd.name] = {
   ["denycount"] = 1,
   ["details"] = {string.format("was blacklisted in %s", mjgd.name)},
   ["status"] = "blacklisted"
  }
  local history = processHistory(output, jobGangType)
  if staff.isOnline then
   output = staff.player.Functions[md.addHistory](mjgd.name, history)
   msgLoop(src)
   msgLoop(staff.player.playerData.source)
   return output
  end
  metaData[md.history][mjgd.name] = history
  sql = {
   ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
   ["from"] = "qb-jobs/server/main.lua > function > manageStaff > denyManagerAction > "
  }
  queryResult = sqlHandler(sql)
  if queryResult.error and next(queryResult.error) then return queryResult end
  if output.error and next(output.error) then return output end
  msgLoop(src)
  return output
 end
 local denyManagerAction = function(_)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("Denial Alert"),
    ["msg"] = string.format("%s was denied with %s.", citid, mjgd.label),
    ["jsMsg"] = string.format("%s was denied with %s.", citid, mjgd.label),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  output[md.type] = mjgd.name
  output[mjgd.name] = {
   ["denycount"] = 1,
   ["details"] = {string.format("was denied in %s", mjgd.label)},
   ["status"] = "denied"
  }
  local history = processHistory(output, jobGangType)
  if staff.isOnline then
   output = staff.player.Functions[md.addHistory](mjgd.name, history)
   msgLoop(src)
   msgLoop(staff.player.playerData.source)
   return output
  end
  metaData[md.history][mjgd.name] = history
  sql = {
   ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
   ["from"] = "qb-jobs/server/main.lua > function > manageStaff > denyManagerAction > "
  }
  queryResult = sqlHandler(sql)
  if queryResult.error and next(queryResult.error) then return queryResult end
  if output.error and next(output.error) then return output end
  msgLoop(src)
  return output
 end
 local gradeManagerAction = function(info)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("%s Alert", info[res.action].subject),
    ["msg"] = string.format("%s in %s.", info[res.action].details, mjgd.label),
    ["jsMsg"] = info[res.action].subject,
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  local prevGrade = info[res.action].prevGrade
  local newGrade = info[res.action].newGrade
  local grade = tostring(newGrade)
  if not mconf.grades[grade] then
   output.notice[0] = {
    ["subject"] = string.format("Can't %s Any Further", res.action),
    ["msg"] = string.format("%s can not be %s any further in %s.", citid, res.action, mjgd.name),
    ["jsMsg"] = "Highest grade reached!",
    ["src"] = src,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.notice)
  end
  local gradeName = mconf.grades[grade].name
  local prevGradeName = mconf.grades[prevGrade].name
  output[md.type] = mjgd.name
  output.grade = grade
  output.gradeName = gradeName
  output.jgPrev = mjgd.name
  output.jgNew = mjgd.name
  output[mjgd.name] = {
   ["gradechangecount"] = 1,
   ["details"] = {string.format("was %s from %s to %s", info[res.action].details, prevGradeName, gradeName)}
  }
  if not next(output.notice) then
   output = setJobGang(output, jobGangType)
   if next(output.error) then return output end
   msgLoop(src)
   msgLoop(staff.player.playerData.source)
  end
  return output
 end
 local payManagerAction = function(_)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("Pay Adjustment Alert"),
    ["msg"] = string.format("%s pay was adjusted to %s in %s.", output.citid, payRate, mjgd.label),
    ["jsMsg"] = string.format("%s pay was adjusted to %s in %s.", output.citid, payRate, mjgd.label),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  local payRate = res.payRate
  if not Ra93Core.functions.prepForSQL(src, payRate, "^%d+$") then
   output.error[0] = true
   return output
  end
  local history = processHistory(output, jobGangType)
  local jgd = metaData[md.types][mjgd.name]
  jgd.payment = payRate
  if staff.isOnline then
   output = staff.player.Functions[pd.addHistory](mjgd.name, history)
   if output.error and next(output.error) then return output end
   output = staff.player.Functions.AddToJobs(mjgd.name, jgd)
   if output.error and next(output.error) then return output end
   if staffData.name == mjgd.name then staff.player.Functions.UpdateJob(jgd) end
   if output.error and next(output.error) then return output end
   msgLoop(src)
   msgLoop(staff.player.playerData.source)
   output = setUnderlingStatus(res)
   return output
  else
   metaData[md.history][mjgd.name] = history
   metaData[md.types][mjgd.name] = jgd
   if staffData.name == mjgd.name then
    staffData = nil
    staffData = jgd
   end
   sql = {
    ["query"] = string.format("UPDATE `players` SET `job` = '%s',`metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(staffData),json.encode(metaData),citid),
    ["from"] = "qb-jobs/server/main.lua > function > manageStaff > payMangerAction"
   }
   queryResult = sqlHandler(sql)
   if queryResult.error and next(queryResult.error) then return queryResult end
   output.player = Ra93Core.player.GetOfflinePlayer(citid)
  end
  if output.error and next(output.error) then return output end
  msgLoop(src)
  return output
 end
 local reconsiderManagerAction = function(info)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("Reconsideration Alert"),
    ["msg"] = string.format("%s was reconsidered with %s.", citid, mjgd.label),
    ["jsMsg"] = string.format("%s was reconsidered with %s.", citid, mjgd.label),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  output[md.type] = mjgd.name
  output[mjgd.name] = {
   ["details"] = {string.format("was reconsidered in %s", mjgd.name)},
   ["status"] = info.reconsider.status
  }
  local history = processHistory(output, jobGangType)
  if staff.isOnline then
   output = staff.player.Functions[md.addHistory](mjgd.name, history)
   msgLoop(src)
   msgLoop(staff.player.playerData.source)
  else
   metaData[md.history][mjgd.name] = history
   sql = {
    ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
    ["from"] = "qb-jobs/server/main.lua > function > > manageStaff > reconsiderManagerAction"
   }
   queryResult = sqlHandler(sql)
   if queryResult.error and next(queryResult.error) then return queryResult end
   msgLoop(src)
  end
  if output.error and next(output.error) then return output end
  return output
 end
 local terminateManagerAction = function(_)
  local msgLoop = function(srce)
   output.success[0] = {
    ["subject"] = string.format("Termination Alert"),
    ["msg"] = string.format("%s was Terminated from %s", citid, mjgd.label),
    ["jsMsg"] = string.format("Terminated from %s", mjgd.label),
    ["src"] = srce,
    ["color"] = "notice",
    ["logName"] = "qbjobs",
    ["log"] = true,
    ["notify"] = true
   }
   Ra93Core.functions.messageHandler(output.success)
  end
  local grade = "0"
  local new = {[md.type] = md.civilian}
  local prev = {[md.type] = mjgd.name}
  local gradeName = Config[jobGangType][md.civilian].grades[grade].name
  output.jgPrev = prev[md.type]
  output.jgNew = new[md.type]
  prev[md.type] = mjgd.name
  output.grade = grade
  output.gradeName = gradeName
  output[md.type] = prev[md.type]
  output[prev[md.type]] = {
   ["firedcount"] = 1,
   ["details"] = {string.format("was terminated from %s", prev[md.type])},
   ["status"] = "fired"
  }
  output = setJobGang(output, jobGangType)
  if output.error and next(output.error) then return output end
  staff.player.Functions[md.remove](mjgd.name)
  msgLoop(src)
  if staff.isOnline then msgLoop(staff.player.playerData.source) end
  return output
 end
 local action = {
  ["approve"] = {
   ["grade"] = "1",
   ["func"] = approveManagerAction
  },
  ["award"] = {
   ["awrep"] = mconf.management.awards[awrep].title,
   ["details"] = "awarded",
   ["subject"] = "Award",
   ["confs"] = "awards",
   ["func"] = awrepManagerAction
  },
  ["blacklist"] = {
   ["status"] = "blacklisted",
   ["func"] = blacklistManagerAction
  },
  ["demote"] = {
   ["status"] = "demote",
   ["prevGrade"] = staffData.grade.level,
   ["newGrade"] = tonumber(staffData.grade.level) - 1,
   ["details"] = "demoted",
   ["subject"] = "Demotion",
   ["func"] = gradeManagerAction
  },
  ["deny"] = {
   ["status"] = "denied",
   ["func"] = denyManagerAction
  },
  ["pay"] = {
   ["status"] = "pay",
   ["func"] = payManagerAction
  },
  ["promote"] = {
   ["status"] = "promote",
   ["prevGrade"] = staffData.grade.level,
   ["newGrade"] = tonumber(staffData.grade.level) + 1,
   ["grade"] = tonumber(staffData.grade.level) + 1,
   ["details"] = "promoted",
   ["subject"] = "Promotion",
   ["func"] = gradeManagerAction
  },
  ["reconsider"] = {
   ["status"] = "pending",
   ["func"] = reconsiderManagerAction
  },
  ["reprimand"] = {
   ["awrep"] = mconf.management.reprimands[awrep].title,
   ["details"] = "reprimanded",
   ["subject"] = "Reprimand",
   ["confs"] = "reprimands",
   ["func"] = awrepManagerAction
  },
  ["resign"] = {
   ["status"] = "quit",
   ["grade"] = 0,
   ["job"] = "unemployed"
  },
  ["terminate"] = {
   ["status"] = "fired",
   ["grade"] = 0,
   ["job"] = "unemployed",
   ["func"] = terminateManagerAction
  }
 }
 output = action[res.action].func(action)
 return output
end
--- Function to add player to job or gang using command /setjob or /setgang
local commandJobGang = function(src, res, jobGangType)
 local jg = res.jg
 local grade = tostring(res.grade)
 local player = Ra93Core.functions.getPlayer(tonumber(res.pid))
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local conf = selectJobGang(jobGangType, playerJob, playerGang)
 local citid = player.playerData.citizenid
 local output = {
  ["manager"] = {["src"] = src},
  ["jg"] = jg,
  ["grade"] = grade,
  ["citid"] = citid,
  ["appcid"] = citid,
  ["action"] = "approve",
 }
 if player then
  local deets = {
   ["Jobs"] = {
    ["deet"] = "hired onto",
    ["prevKey"] = "jgPrev",
    ["newKey"] = "jgNew"
   },
   ["Gangs"] = {
    ["deet"] = "jumped onto",
    ["prevKey"] = "prevGang",
    ["newKey"] = "newGang"
   },
  }
  local data = {
   ["jgPrev"] = jg,
   ["jgNew"] = jg,
   ["jg"] = jg,
   ["grade"] = grade,
   ["gradeName"] = Config[jobGangType][jg].grades[grade].name,
   ["citid"] = citid,
   ["appcid"] = citid,
   ["action"] = "approve",
   [jg] = {
    ["hiredcount"] = 1,
    ["details"] = {string.format("was %s %s", deets[jobGangType].deet, jg)},
    ["status"] = "hired"
   }
  }
  output = setJobGang(data, jobGangType)
  if output.error and next(output.error) then return output end
  output.success[0] = {
   ["subject"] = string.format("Approval Alert"),
   ["msg"] = string.format("%s was approved with %s.", citid, jg),
   ["jsMsg"] = string.format("%s was approved.", citid),
   ["src"] = src,
   ["color"] = "notice",
   ["logName"] = "qbjobs",
   ["log"] = true,
   ["notify"] = true
  }
   Ra93Core.functions.messageHandler(output.success)
  return output
 else TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'),'error') end
end
--- function to verify data coming in for /setjob and /setgang
local verifyCommandSetJobGangVars = function(src, args, jobGangType)
 local admin = Ra93Core.functions.getPlayer(tonumber(src))
 local license = admin.PlayerData.license
 local output = {
  ["Jobs"] = {
   ["gradeMsg"] = "/setjob",
   ["jgInvalid"] = "Job Name is Invalid",
   ["jgMsg"] = "Job Name is Invalid /setjob",
   ["jgMiss"] = "Job does not exist!",
   ["jgMissMsg"] = "Job does not exist /setjob",
   ["perm"] = "setJob"
  },
  ["Gangs"] = {
   ["gradeMsg"] = "/setjob",
   ["jgInvalid"] = "Job Name is Invalid",
   ["jgMsg"] = "Job Name is Invalid /setjob",
   ["jgMiss"] = "Job does not exist!",
   ["jgMissMsg"] = "Job does not exist /setjob",
   ["perm"] = "setGang"
  },
  ["success"] = {},
  ["error"] = {},
 }
 if not Ra93Core.functions.prepForSQL(src, args[1], "^%d+$") then
  output.error[0] = {
   ["subject"] = "Player ID is Invalid",
   ["msg"] = string.format("Player ID is invalid /setjob used by: %s", license),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if not Ra93Core.functions.prepForSQL(src, args[2], "^%a+$") then
  output.error[0] = {
   ["subject"] = output[jobGangType].jgInvalid,
   ["msg"] = string.format("%s used by: %s", output[jobGangType].jgMsg, license),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if not Ra93Core.functions.prepForSQL(src, args[3], "^%d+$") then
  output.error[  0] = {
   ["subject"] = "Grade is Invalid",
   ["msg"] = string.format("Grade is invalid %s used by: %s", output[jobGangType].gradeMsg, license),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if not Config[jobGangType][args[2]] or not next(Config[jobGangType][args[2]]) then
  output.error[  0] = {
   ["subject"] = output[jobGangType].jgMiss,
   ["msg"] = string.format("%s used by: %s", output[jobGangType].jgMissMsg, license),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if not Config[jobGangType][args[2]].grades[args[3]] or not next(Config[jobGangType][args[2]].grades[args[3]]) then
  output.error[  0] = {
   ["subject"] = "Grade does not Exist",
   ["msg"] = string.format("Grade does not exist %s used by: %s", output[jobGangType].gradeMsg, license),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 if Ra93Core.functions.hasPermission(Config.perms[output[jobGangType].perm]) then
  output.error[0] = {
   ["subject"] = "Player is Not Admin",
   ["msg"] = string.format("%s is not an admin and attempted to add player to job: %s", license, args[2]),
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 local player = Ra93Core.functions.getPlayer(tonumber(args[1]))
 if not player and not next(player) then
  output.error[0] = {
   ["subject"] = "Player is Not Online!",
   ["msg"] = "Player is not online!",
   ["color"] = "notify",
   ["notify"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  return output
 end
 output.pid = args[1]
 output.jg = args[2]
 output.grade = args[3]
 output.citid = player.playerData.citizenid
 output.appcid = output.citid
 return output
end
--- functions to run at resource start
local kickOff = function()
 CreateThread(function() checkUniqueJobGang() end)
 CreateThread(function() sendWebHooks() end)
 CreateThread(function() countVehPop() end)
 CreateThread(function() sendToCityHall() end)
 CreateThread(function() sendToCustoms() end)
 CreateThread(function() MySQL.query("DELETE FROM stashitems WHERE stash LIKE '%trash%'") end)
 CreateThread(function()
  while true do
   Wait(5000)
   updateBlips()
  end
 end)
end
-- Events
--- onResourceStart fiveM native
RegisterServerEvent('onResourceStart', function(resourceName)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 if resourceName == GetCurrentResourceName() then CreateThread(function() kickOff() end) end
end)
--- UpdateObject QBCore Event
RegisterServerEvent('QBCore:Server:UpdateObject', function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
	if source ~= '' then return false end
	Ra93Core = exports['qb-core']:GetCoreObject()
end)
--- Jobs Alert Event
RegisterServerEvent('qb-jobs:server:Alert', function(text)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local ped = GetPlayerPed(src)
 local coords = GetEntityCoords(ped)
 local players = Ra93Core.functions.getQBPlayers()
 for _,v in pairs(players) do
  if v and v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
   local alertData = {title = Lang:t('info.new_call'),coords = {x = coords.x, y = coords.y, z = coords.z},description = text}
   TriggerClientEvent("qb-phone:client:Alert", v.PlayerData.source, alertData)
   TriggerClientEvent('qb-jobs:client:Alert', v.PlayerData.source, coords, text)
  end
 end
end)
--- Event to Build History Data
RegisterServerEvent("qb-jobs:server:BuildHistory", function(jobGangType)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local output = {["src"] = source}
 local player = Ra93Core.functions.getPlayer(output.src)
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local conf = selectJobGang(jobGangType, playerJob, playerGang)
 local pd = conf.pd
 local ph = {
  ["Jobs"] = player.playerData.metadata.jobhistory,
  ["Gangs"] = player.playerData.metadata.ganghistory,
 }
 local history
 for k in pairs(Config[jobGangType]) do
  if not ph[jobGangType] or not ph[jobGangType][k] or not next(ph[jobGangType][k]) then
   output[pd.type] = k
   history = {
    ["firedcount"] = 0,
    ["applycount"] = 0,
    ["denycount"] = 0,
    ["hiredcount"] = 0,
    ["gradechangecount"] = 0,
    ["quitcount"] = 0,
    ["reprimands"] = {},
    ["awards"] = {},
    ["grades"] = {},
    ["details"] = {},
    ["status"] = "available"
   }
   player.Functions[pd.addHistory](k, history)
  end
 end
end)
--- Event to call the populateJobsNGangs function from client
RegisterServerEvent('qb-jobs:server:populateJobsNGangs', function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 populateJobsNGangs(src)
end)
--- Event to add items to vehicle
RegisterServerEvent('qb-jobs:server:addVehItems', function(data, jobGangType)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local player = Ra93Core.functions.getPlayer(source)
 if not player then return false end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local SetCarItemsInfo = function(data)
  local items = {}
  local index = 1
  if cdata.Items[data.inv] then
   for _,v in pairs(cdata.Items[data.inv]) do
    local vehType = false
    local authGrade = false
    for _,v1 in pairs(v.vehType) do
     if v1 == cdata.Vehicles.vehicles[data.vehicle].type then vehType = true end
    end
    for _,v1 in pairs(v.authGrade) do
     if v1 == playerJob.grade.level then authGrade = true end
    end
    if vehType and authGrade then
     local itemInfo = Ra93Core.shared.Items[v.name:lower()]
     items[index] = {
      name = itemInfo["name"],
      amount = tonumber(v.amount),
      info = v.info,
      label = itemInfo["label"],
      description = itemInfo["description"] and itemInfo["description"] or "",
      weight = itemInfo["weight"],
      type = itemInfo["type"],
      unique = itemInfo["unique"],
      useable = itemInfo["useable"],
      image = itemInfo["image"],
      slot = index,
     }
     index = index + 1
    end
   end
  end
  return items
 end
 data.inv = "trunk"
 local trunkItems = SetCarItemsInfo(data)
 data.inv = "glovebox"
 local gloveboxItems = SetCarItemsInfo(data)
 if trunkItems then exports['rcInventory']:addTrunkItems(data.plate, trunkItems) end
 if gloveboxItems then exports['rcInventory']:addGloveboxItems(data.plate, gloveboxItems) end
end)
--- Event to open the shop by eventually calling an export
RegisterServerEvent('qb-jobs:server:openShop', function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return false end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 populateJobsNGangs(src) -- ensures client has latest Ra93Core.shared.Jobs table.
 local index = 1
 local inv = {
  label = cdata.Items.shopLabel,
  slots = 30,
  items = {}
 }
 local items = cdata.Items.items
 for key = 1,#items do
  for key2 = 1,#items[key].authorizedJobGrades do
   for key3 = 1,#items[key].locations do
    if items[key].locations[key3] == "shop" and items[key].authorizedJobGrades[key2] == playerJob.grade.level then
     if items[key].type == "weapon" then items[key].info.serie = tostring(Ra93Core.shared.RandomInt(2) .. Ra93Core.shared.RandomStr(3) .. Ra93Core.shared.RandomInt(1) .. Ra93Core.shared.RandomStr(2) .. Ra93Core.shared.RandomInt(3) .. Ra93Core.shared.RandomStr(4)) end
     inv.items[index] = items[key]
     inv.items[index].slot = index
     index = index + 1
    end
   end
  end
 end
 TriggerEvent("inventory:server:OpenInventory", "shop", playerJob.name, inv)
end)
--- Event to open the stashes by calling an export
RegisterServerEvent("qb-jobs:server:openStash", function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return false end
 local playerJob = player.playerData.job
 local stashHeading = string.format("%s%s", playerJob.name, player.playerData.citizenid)
 exports['rcInventory']:OpenInventory("stash", stashHeading, false, source)
 TriggerClientEvent("inventory:client:SetCurrentStash", stashHeading)
end)
--- Event to open the trash by calling an export
RegisterServerEvent('qb-jobs:server:openTrash', function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return false end
 local playerJob = player.playerData.job
 local options = {
  ["maxweight"] = 4000000,
  ["slots"] = 300
 }
 local stashHeading = string.format("%s-%s-%s", playerJob.name, Lang:t('headings.trash'),player.playerData.citizenid)
 exports['rcInventory']:OpenInventory("stash", stashHeading, options, source)
 TriggerClientEvent("inventory:client:SetCurrentStash", stashHeading)
end)
--- Initilizes the Vehicle Tracker for the client.
RegisterServerEvent('qb-jobs:server:initilizeVehicleTracker', function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return false end
 vehTrack = {[player.playerData.citizenid] = {}}
end)
--- adds vehicles to job total
RegisterServerEvent('qb-jobs:server:addVehicle', function(jobGangType)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return false end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local jgd = cdata.jgd
 vehCount[jgd.name] += 1
end)
-- Deletes Vehicle from the server
RegisterServerEvent("qb-jobs:server:deleteVehicleProcess", function(result, jobGangType)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local citid = player.playerData.citizenid
 local vehList = cdata.Vehicles
 if not vehTrack[citid][result.plate].selGar == "motorpool" and vehTrack[citid][result.plate].veh and not DoesEntityExist(NetworkGetEntityFromNetworkId(vehTrack[citid][result.plate].veh)) then
  TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Fake Refund Attempt', 'red', string.format('%s attempted to obtain a refund for returned vehicle!', GetPlayerName(src)))
  return false
 end
 if vehTrack[citid][result.plate].selGar == "motorpool" and vehList.config.depositFees and not result.noRefund and vehList.vehicles[result.vehicle].depositPrice then
  if player.Functions.AddMoney("cash", vehList.vehicles[result.vehicle].depositPrice, pd.name .. Lang:t("success.depositFeesPaid",{value = vehList.vehicles[result.vehicle].depositPrice})) then
   TriggerClientEvent('QBCore:Notify', src, Lang:t("success.depositReturned",{value = vehList.vehicles[result.vehicle].depositPrice}),"success")
   TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Refund Deposit Success', 'green', string.format('%s received a refund of %s for returned vehicle!', GetPlayerName(src),vehList.vehicles[result.vehicle].depositPrice))
   exports['qb-management']:RemoveMoney(pd.name, vehList.vehicles[result.vehicle].depositPrice)
  end
 end
 vehCount[pd.name] -= 1
 vehTrack[citid][result.plate] = nil
end)
-- Callbacks
--- Verifies the vehicle count
Ra93Core.functions.createCallback("qb-jobs:server:verifyMaxVehicles", function(source, cb, jobGangType)
 local test = true
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then cb(false) end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local jgd = cdata.jgd
 if conf.Vehicles.config.maxVehicles > 0 and conf.Vehicles.config.maxVehicles <= vehCount[jgd.name] then
  Ra93Core.functions.notify(Lang:t("info.vehicleLimitReached"))
  test = false
 end
 cb(test)
end)
--- Processes Vehicles to be issued
Ra93Core.functions.createCallback("qb-jobs:server:spawnVehicleProcessor", function(source, cb, result, jobGangType)
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return false end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local vehList = conf.Vehicles
 local total = 0
 local message = {}
 local ownGarage = function()
  if vehList.config.ownedParkingFee and vehList.vehicles[result.vehicle].parkingPrice then
   total += vehList.vehicles[result.vehicle].parkingPrice
   message.msg = Lang:t("success.parkingFeesPaid",{value = vehList.vehicles[result.vehicle].parkingPrice})
  end
 end
 local jobStore = function()
  local output = {
   ["src"] = src,
   ["vehicle"] = result.vehicle,
   ["plate"] = result.plate,
   ["type"] = type
  }
  exports['qb-vehicleshop']:BuyJobsVehicle(output)
 end
 local motorpool = function()
  if vehList.config.rentalFees and vehList.vehicles[result.vehicle].rentPrice then
   total += vehList.vehicles[result.vehicle].rentPrice
   message.rent = Lang:t("success.rentalFeesPaid",{value = vehList.vehicles[result.vehicle].rentPrice})
  end
  if vehList.config.depositFees and vehList.vehicles[result.vehicle].depositPrice then
   total += vehList.vehicles[result.vehicle].depositPrice
   message.deposit = Lang:t("success.depositFeesPaid",{value = vehList.vehicles[result.vehicle].depositPrice})
  end
  if message.rent and message.deposit then message.msg = message.rent .. " " .. message.deposit
  elseif message.rent then message.msg = message.rent
  elseif message.deposit then message.msg = message.deposit end
 end
 local default = function()
  TriggerClientEvent('QBCore:Notify', source, Lang.t("denied.invalidGarage"),"denied")
  TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Intrusion Attempted', 'red', string.format('%s attempted to obtain a vehicle!', GetPlayerName(source)))
  return false
 end
 local selGar = {
  ["ownGarage"] = ownGarage,
  ["jobStore"] = jobStore,
  ["motorpool"] = motorpool,
  ["default"] = default,
 }
 selGar[result.selGar]()
 if total > 0 then
  if not player.Functions.RemoveMoney("bank", total, message.msg) then
   if not player.Functions.RemoveMoney("cash", total, message.msg) then
    TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_enough",{value = total}),"error")
    return false
   end
  end
  exports['qb-management']:AddMoney(pd.name, total)
 end
 TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Money Received!', 'green', string.format('%s received money!', GetPlayerName(source)))
 if(not vehTrack[player.playerData.citizenid]) then vehTrack[player.playerData.citizenid] = {} end
 vehTrack[player.playerData.citizenid][result.plate] = {
  ["veh"] = result.veh,
  ["netid"] = result.netid,
  ["vehicle"] = result.vehicle,
  ["selGar"] = result.selGar
 }
 cb(true)
end)
--- Creates plates and ensures they are not in-use
Ra93Core.functions.createCallback("qb-jobs:server:vehiclePlateCheck", function(source, cb, res, jobGangType)
 local player = Ra93Core.functions.getPlayer(source)
 if not player then return false end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local plate, vehProps, ppl, sql, queryResult
 local pplMax = 4
 res.platePrefix = conf.Vehicles.config.plate
 ppl = string.len(res.platePrefix)
 if ppl > pplMax then
  res.platePrefix = string.sub(res.platePrefix, 1,pplMax)
  print("^1Your plate prefix is " .. ppl .. " must be less than ".. pplMax .. " chracters at: qb-jobs/jobs/" .. pd.name .. ".lua >>> VehicleConfig > Plate^7")
 end
 ppl = 7 - ppl
 res.min = 1 .. string.rep("0", ppl)
 res.max = 9 .. string.rep("9", ppl)
 res.vehTrack = vehTrack[player.playerData.citizenid]
 plate = exports["qb-vehicleshop"]:JobsPlateGen(res)
 if res.selGar == "ownGarage" then
  sql = {
   ["query"] = string.format("SELECT `mods` FROM `player_vehicles` WHERE `plate` = '%s'", plate),
   ["from"] = "qb-jobs/server/main.lua > callback > vehiclePlateCheck"
  }
  queryResult = sqlHandler(sql)
  if queryResult.error and next(queryResult.error) then return queryResult end
  if queryResult[1] then vehProps = json.decode(queryResult[1].mods) end
 end
 cb(plate, vehProps)
end)
--- Generates list to populate the vehicle selector menu
Ra93Core.functions.createCallback('qb-jobs:server:sendGaragedVehicles', function(source, cb, data, jobGangType)
 local player = Ra93Core.functions.getPlayer(source)
 if not player then return false end
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local jgd = cdata.jgd
 local grade = tonumber(jgd.grade.level)
 local vehShort, queryResult, sql
 local vehList = {
  ["vehicles"] = {},
  ["vehiclesForSale"] = {},
  ["ownedVehicles"] = {},
 }
 local typeList = {}
 local index = {
  ["boat"] = 1,
  ["helicopter"] = 1,
  ["plane"] = 1,
  ["vehicle"] = 1
 }
 vehList.uiColors = conf.uiColors
 vehList.label = pd.label
 vehList.icons = conf.menu.icons
 vehList.garage = data
 vehList.header = pd.label .. Lang:t('headings.garages')
 for _,v in pairs(conf.Locations.garages[data].spawnPoint) do typeList[v.type] = true end
 for k, v in pairs(conf.Vehicles.vehicles) do
  for _,v1 in pairs(v.authGrades) do
   if(v1 == grade and typeList[v.type]) then
   vehList.vehicles[v.type] = {
    [index[v.type]] = {
     ["spawn"] = k,
     ["label"] = v.label,
     ["icon"] = v.icon,
    }
   }
   if conf.Vehicles.config.depositFees then vehList.vehicles[v.type][index[v.type]].depositPrice = v.depositPrice  end
   if conf.Vehicles.config.rentalFees then vehList.vehicles[v.type][index[v.type]].rentPrice = v.rentPrice  end
   if v.purchasePrice and conf.Vehicles.config.allowPurchase then
    vehList.vehicles[v.type][index[v.type]].purchasePrice = v.purchasePrice
    vehList.vehiclesForSale[v.type] = {
     [index[v.type]] = {
      ["spawn"] = k,
      ["label"] = v.label,
      ["icon"] = v.icon,
      ["purchasePrice"] = v.purchasePrice
     }
    }
   end
   if v.parkingPrice and conf.Vehicles.config.allowPurchase and conf.Vehicles.config.ownedParkingFee then
    vehList.vehicles[v.type][index[v.type]].parkingPrice = v.parkingPrice
    vehList.vehiclesForSale[v.type][index[v.type]].parkingPrice = v.parkingPrice
   end
   index[v.type] += 1
   end
  end
 end
 index.boat = 1
 index.helicopter = 1
 index.plane = 1
 index.vehicle = 1
 if conf.Vehicles.config.ownedVehicles then vehList.allowPurchase = true end
 sql = {
  ["query"] = string.format("SELECT `plate`,`vehicle` FROM `player_vehicles` WHERE `citizenid` = '%s' AND `state` = '%s' AND `%s` = '%s'", player.playerData.citizenid, 0,pd.type, pd.name),
  ["from"] = "qb-jobs/server/main.lua > callback > sendGaragedVehicles"
 }
 queryResult = sqlHandler(sql)
 if queryResult.error and next(queryResult.error) then
  cb(queryResult)
  return queryResult
 end
 for _,v in pairs(queryResult) do
  vehShort = conf.Vehicles.vehicles[v.vehicle]
  for _,v1 in pairs(vehShort.authGrades) do
   if(v1 == grade and typeList[vehShort.type]) then
    if not vehList.ownedVehicles[vehShort.type] then vehList.ownedVehicles[vehShort.type] = {} end
    vehList.ownedVehicles[vehShort.type][index[vehShort.type]] = {
     ["plate"] = v.plate,
     ["spawn"] = v.vehicle,
     ["label"] = conf.Vehicles.vehicles[v.vehicle].label,
     ["icon"] = conf.Vehicles.vehicles[v.vehicle].icon
    }
    if(vehShort.parkingPrice) then vehList.ownedVehicles[vehShort.type][index[vehShort.type]].parkingPrice = vehShort.parkingPrice end
    index[vehShort.type] += 1
   end
  end
 end
 cb(vehList)
end)
--- Sends Management Data to populate the boss menu
Ra93Core.functions.createCallback('qb-jobs:server:sendManagementData', function(source, cb, data, jobGangType)
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local pd = cdata.pd
 local jgd = cdata.jgd
 local mgrBtnList = buildManagementData(src, jobGangType)
 cb(mgrBtnList[pd.types][jgd.name])
 return mgrBtnList
end)
--- Processes management actions from the boss menu
Ra93Core.functions.createCallback("qb-jobs:server:processManagementSubMenuActions", function(source, cb, res)
 Ra93Core.debug(res)
 local src = source
 local manager = Ra93Core.functions.getPlayer(src)
 local managerJob = manager.PlayerData.job
 local managerGang = manager.PlayerData.gang
 local jobGangType = res.jobGangType
 local cdata =  selectJobGang(jobGangType, managerJob, managerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local mjg = cdata.jgd
 local managerLicense = manager.PlayerData.license
 local output = {}
 local mgrBtnList = buildManagementData(src, jobGangType)
 res.manager = {["src"] = src}
 if not mgrBtnList.players[res.appcid] then
  output.error = {[0] = {
   ["subject"] = "Player Data Missing",
   ["msg"] = string.format("Player data missing; Boss Menu used by: ?", res.appcid),
   ["jsMsg"] = "Player Data Missing",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }}
  Ra93Core.functions.messageHandler(output.error)
  cb(output)
  return output
 end
 res.citid = res.appcid
 if not Ra93Core.functions.prepForSQL(src, res.action, "^%a+$") then
  output.error[0] = {
   ["subject"] = "Action Data Invalid",
   ["msg"] = string.format("Action data Invalid Boss Menu used by: ?", managerLicense),
   ["jsMsg"] = "Action Data Invalid",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  cb(output)
  return output
 end
 output = manageStaff(res, jobGangType)
 if not output or next(output.error) then
  cb(output)
  return output
 end
 mgrBtnList = buildManagementData(src, jobGangType)
 if not mgrBtnList or mgrBtnList.error and next(mgrBtnList.error) then
  cb(mgrBtnList)
  return mgrBtnList
 end
 cb(mgrBtnList[pd.types][mjg.name])
 return mgrBtnList
end)
--- Processes society actions from the boss menu
Ra93Core.functions.createCallback("qb-jobs:server:processManagementSocietyActions", function(source, cb, res, jobGangType)
 local src = source
 local manager = Ra93Core.functions.getPlayer(src)
 local managerJob = manager.PlayerData.job
 local managerGang = manager.PlayerData.gang
 local cdata =  selectJobGang(jobGangType, managerJob, managerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local mgrBtnList = buildManagementData(src, jobGangType)
 local managerLicense = manager.PlayerData.license
 local output = {
  ["error"] = {}
 }
 if not Ra93Core.functions.prepForSQL(src, res.depwit, "^%d+$") then
  output.error[0] = {
   ["subject"] = "Amount is Invalid",
   ["msg"] = string.format("Amount is invalid boss menu used by: %s", managerLicense),
   ["jsMsg"] = "Amount is Invalid",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
   Ra93Core.functions.messageHandler(output.error)
  cb(output)
  return output
 end
 output = exports["qb-banking"]:societyDepwit(src, jobGangType, Config.currencySymbol, res.depwit, res.selector)
 if not mgrBtnList or mgrBtnList.error and next(mgrBtnList.error) then
  cb(mgrBtnList)
  return mgrBtnList
 end
 cb(mgrBtnList[pd.types][pd.name])
 return mgrBtnList
end)
--- Processes multiJob menu items
Ra93Core.functions.createCallback("qb-jobs:server:processMultiJob", function(source, cb, res)
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 local playerJob = player.playerData.job
 local playerGang = player.playerData.gang
 local jobGangType = res.jobGangType
 local cdata =  selectJobGang(jobGangType, playerJob, playerGang)
 local conf = cdata.conf
 local pd = cdata.pd
 local jgd = cdata.jgd
 local playerJobs = player.playerData.metadata.jobs
 local playerGangs = player.playerData.metadata.gangs
 local jobCheck = function(data)
  local output = {
   ["job"] = playerJobs[data.job],
   ["success"] = {},
   ["error"] = {}
  }
  if not output.job or not next(output.job) then
   output.error[0] = {
    ["subject"] = "Does Not Work Here!",
    ["msg"] = string.format("player does not exist in processMultiJob Callback! #msg001"),
    ["jsMsg"] = "Player Does Not Exist!",
    ["color"] = "error",
    ["logName"] = "qbjobs",
    ["src"] = src,
    ["log"] = true,
    ["console"] = true
   }
   Ra93Core.functions.messageHandler(output.error)
   cb(output)
   return false
  end
  return output
 end
 local gangCheck = function(data)
  local output = {
   ["gang"] = playerGangs[data.gang],
   ["success"] = {},
   ["error"] = {}
  }
  if not output.gang or not next(output.gang) then
   output.error[0] = {
    ["subject"] = "Is not a Member!!",
    ["msg"] = string.format("player does not exist in processMultiJob Callback! #msg002"),
    ["jsMsg"] = "Player Does Not Exist!",
    ["color"] = "error",
    ["logName"] = "qbjobs",
    ["src"] = src,
    ["log"] = true,
    ["console"] = true
   }
   Ra93Core.functions.messageHandler(output.error)
   cb(output)
   return false
  end
  return output
 end
 pd.job = {["check"] = jobCheck}
 pd.gang = {["check"] = gangCheck}
 local activate = function(data)
  local output = pd[pd.type].check(data)
  if next(output.error) then return output end
  player.Functions[pd.active](output.job)
  return output
 end
 local quit = function(data)
  local output = {
   ["src"] = src,
   ["citid"] = data.citid,
   [pd.type] = data[pd.type],
   [data[pd.type]] = {
    ["status"] = "quit",
    ["details"] = {[1] = "Resigned"},
    ["quitcount"] = 1
   },
   ["error"] = {},
   ["success"] = {}
  }
  local history = processHistory(output, jobGangType)
  if not pd[pd.type].check(data) then return false end
  player.Functions[pd.addHistory](data[pd.type], history)
  if data[pd.type] == jgd.name then
   player.Functions[pd.set](pd.civilian, "0")
   player = Ra93Core.functions.getPlayer(src)
   player.Functions[pd.active](player.playerData[pd.type])
  end
  player.Functions[pd.remove](res[pd.type])
  output.success[0] = {
   ["subject"] = "User Resigned",
   ["msg"] = string.format("%s resigned from %s", player.playerData.citizenid, pd.name),
   ["jsMsg"] = "User Resigned!",
   ["color"] = "success",
   ["logName"] = conf.webHooks[playerJob.name],
   ["src"] = src,
   ["log"] = true,
   ["notify"] = true
  }
  player = Ra93Core.functions.getPlayer(src)
  return output
 end
 local apply = function(data)
  local output = {
   ["src"] = data.src,
   [pd.type] = data[pd.type],
   ["citid"] = data.citid,
   ["grade"] = 0,
   ["error"] = {},
   ["success"] = {}
  }
  output = submitApplication(output, jobGangType)
  return output
 end
 local rescind = function(data)
  player.playerData.metadata[pd.history][data[pd.type]].status = "available"
  player.Functions[pd.addHistory](data[pd.type],player.playerData.metadata[pd.history][data[pd.type]])
 end
 local output = {
  ["error"] = {},
  ["success"] = {}
 }
 local action = {
  ["activate"] = {["func"] = activate},
  ["apply"] = {["func"] = apply},
  ["quit"] = {["func"] = quit},
  ["rescind"] = {["func"] = rescind},
 }
 if not Ra93Core.functions.prepForSQL(src, res.action, "^%a+$") then
  output.error[0] = {
   ["subject"] = "Action is Invalid",
   ["msg"] = string.format("Action is invalid multi-job menu used by: %s", player.playerData.license),
   ["jsMsg"] = "Action is Invalid",
   ["color"] = "error",
   ["logName"] = "qbjobs",
   ["src"] = src,
   ["log"] = true,
   ["console"] = true
  }
  Ra93Core.functions.messageHandler(output.error)
  cb(output)
  return output
 end
 if not Ra93Core.functions.prepForSQL(src, res[pd.type], "^%a+$") then
   output.error[0] = {
    ["subject"] = "Job is Invalid",
    ["msg"] = string.format("Job is invalid multiJob menu used by: %s", player.playerData.license),
    ["jsMsg"] = "Job is Invalid",
    ["color"] = "error",
    ["logName"] = "qbjobs",
    ["src"] = src,
    ["log"] = true,
    ["console"] = true
   }
   Ra93Core.functions.messageHandler(output.error)
   cb(output)
   return output
 end
 output[pd.type] = res[pd.type]
 output.src = src
 output.citid = player.playerData.citizenid
 action[res.action].func(output)
 cb(output)
 Ra93Core = exports['qb-core']:GetCoreObject()
 kickOff()
 return output
end)
-- Commands
--- Creates the /duty command to go on and off duty
Ra93Core.commands.Add("duty", Lang:t("command.duty"),{},false, function(source)
 local src = source
 TriggerClientEvent('qb-jobs:client:toggleDuty', src)
end, Config.perms.duty)
--- Creates the /jobs command to open the multi-jobs menu.
Ra93Core.commands.Add("jobs", Lang:t("command.jobs"),{},false, function(source)
 local src = source
 TriggerClientEvent('qb-jobs:client:multiJobMenu', src)
end, Config.perms.jobs)
--- Checks Job Status of Player
Ra93Core.commands.Add('job', Lang:t("command.job.help"),{},false, function(source)
 local PlayerJob = Ra93Core.functions.getPlayer(source).PlayerData.job
 TriggerClientEvent('QBCore:Notify', source, Lang:t('info.job_info',{value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}))
end, Config.perms.job)
--- Assigns a Player to a job and grade
Ra93Core.commands.Add('setjob', Lang:t("command.setjob.help"),{ { name = Lang:t("command.setjob.params.id.name"),help = Lang:t("command.setjob.params.id.help") },{ name = Lang:t("command.setjob.params.job.name"),help = Lang:t("command.setjob.params.job.help") },{ name = Lang:t("command.setjob.params.grade.name"),help = Lang:t("command.setjob.params.grade.help") } },true, function(source, args)
 local src = source
 local jobGangType = "Jobs"
 local output = verifyCommandSetJobGangVars(src, args, jobGangType)
 if not output.error or not next(output.error) then commandJobGang(src, output, jobGangType) end
 return true
end, Config.perms.setJob)
--- Creates the /gangs command to open the multi-gangs menu.
Ra93Core.commands.Add("gangs", Lang:t("command.gangs"),{},false, function(source)
 local src = source
 TriggerClientEvent('qb-jobs:client:multiJobMenu', src)
end, Config.perms.gangs)
--- Checks Gang Status of Player
Ra93Core.commands.Add('gang', Lang:t("command.gang.help"),{},false, function(source)
 local PlayerGang = Ra93Core.functions.getPlayer(source).PlayerData.gang
 TriggerClientEvent('QBCore:Notify', source, Lang:t('info.gang_info',{value = PlayerGang.label, value2 = PlayerGang.grade.name}))
end, Config.perms.gang)
--- Assigns a Player to a gang and grade
Ra93Core.commands.Add('setgang', Lang:t("command.setgang.help"),{ { name = Lang:t("command.setgang.params.id.name"),help = Lang:t("command.setgang.params.id.help") },{ name = Lang:t("command.setgang.params.gang.name"),help = Lang:t("command.setgang.params.gang.help") },{ name = Lang:t("command.setgang.params.grade.name"),help = Lang:t("command.setgang.params.grade.help") } },true, function(source, args)
 local src = source
 local jobGangType = "Gangs"
 local output = verifyCommandSetJobGangVars(src, args, jobGangType)
 if not output.error or not next(output.error) then commandJobGang(src, output, jobGangType) end
 return true
end, Config.perms.setGang)
-- Exports
exports("populateJobsNGangs",populateJobsNGangs)
exports("processHistory",processHistory)
exports("selectJobGang",selectJobGang)
exports("submitApplication",submitApplication)
exports("selectJobGang",selectJobGang)