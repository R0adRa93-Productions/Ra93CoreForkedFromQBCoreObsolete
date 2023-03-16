Ra93Core = Ra93Core or {}
Ra93Core.player = {
 ["checkPlayerData"] = function(source, playerData)
  playerData = playerData or {}
  local Offline = true
  if source then
   playerData.source = source
   playerData.license = playerData.license or Ra93Core.functions.getIdentifier(source, "license")
   playerData.name = GetPlayerName(source)
   Offline = false
  end
  playerData.citizenid = playerData.citizenid or nil
  playerData.cid = playerData.cid or 1
  playerData.currency = playerData.currency or {}
  playerData.optin = playerData.optin or true
  for moneytype, startamount in pairs(Ra93Core.config.location.currency.moneyTypes) do playerData.currency[moneytype] = playerData.currency[moneytype] or startamount end
  playerData.charinfo = playerData.charinfo or {}
  playerData.charinfo.firstname = playerData.charinfo.firstname or "Firstname"
  playerData.charinfo.lastname = playerData.charinfo.lastname or "Lastname"
  playerData.charinfo.birthdate = playerData.charinfo.birthdate or "00-00-0000"
  playerData.charinfo.gender = playerData.charinfo.gender or 0
  playerData.charinfo.backstory = playerData.charinfo.backstory or "placeholder backstory"
  playerData.charinfo.nationality = playerData.charinfo.nationality or Ra93Core.config.location.countryCode
  playerData.charinfo.phone = playerData.charinfo.phone or Ra93Core.functions.createUniqueData("phone")
  playerData.charinfo.account = playerData.charinfo.account or Ra93Core.functions.createUniqueData("account")
  playerData.metadata = playerData.metadata or {}
  playerData.metadata.hunger = playerData.metadata.hunger or 100
  playerData.metadata.thirst = playerData.metadata.thirst or 100
  playerData.metadata.stress = playerData.metadata.stress or 0
  playerData.metadata.isdead = playerData.metadata.isdead or false
  playerData.metadata.inlaststand = playerData.metadata.inlaststand or false
  playerData.metadata.armor = playerData.metadata.armor or 0
  playerData.metadata.ishandcuffed = playerData.metadata.ishandcuffed or false
  playerData.metadata.tracker = playerData.metadata.tracker or false
  playerData.metadata.injail = playerData.metadata.injail or 0
  playerData.metadata.jailitems = playerData.metadata.jailitems or {}
  playerData.metadata.status = playerData.metadata.status or {}
  playerData.metadata.phone = playerData.metadata.phone or {}
  playerData.metadata.fitbit = playerData.metadata.fitbit or {}
  playerData.metadata.commandbinds = playerData.metadata.commandbinds or {}
  playerData.metadata.bloodtype = playerData.metadata.bloodtype or Ra93Core.config.player.Bloodtypes[math.random(1, #Ra93Core.config.player.Bloodtypes)]
  playerData.metadata.dealerrep = playerData.metadata.dealerrep or 0
  playerData.metadata.craftingrep = playerData.metadata.craftingrep or 0
  playerData.metadata.attachmentcraftingrep = playerData.metadata.attachmentcraftingrep or 0
  playerData.metadata.currentapartment = playerData.metadata.currentapartment or nil
  playerData.metadata.jobhistory = playerData.metadata.jobhistory or {}
  playerData.metadata.ganghistory = playerData.metadata.ganghistory or {}
  playerData.metadata.jobs = playerData.metadata.jobs or {}
  playerData.metadata.gangs = playerData.metadata.gangs or {}
  playerData.metadata.jobrep = playerData.metadata.jobrep or {}
  playerData.metadata.gangrep = playerData.metadata.gangrep or {}
  playerData.metadata.callsign = playerData.metadata.callsign or "NO CALLSIGN"
  playerData.metadata.fingerprint = playerData.metadata.fingerprint or Ra93Core.functions.createUniqueData("fingerprint")
  playerData.metadata.walletid = playerData.metadata.walletid or Ra93Core.functions.createUniqueData("walletid")
  playerData.metadata.criminalrecord = playerData.metadata.criminalrecord or {
   ["hasRecord"] = false,
   ["date"] = nil
  }
  playerData.metadata.rapsheet = playerData.metadata.rapsheet or {}
  playerData.metadata.licences = playerData.metadata.licences or {
   ["driver"] = Ra93Core.config.NewPlayerLicenses.driver,
   ["business"] = Ra93Core.config.NewPlayerLicenses.business,
   ["weapon"] = Ra93Core.config.NewPlayerLicenses.weapon
  }
  playerData.metadata.inside = playerData.metadata.inside or {
   ["house"] = nil,
   ["apartment"] = {
    ["apartmentType"] = nil,
    ["apartmentId"] = nil,
   }
  }
  playerData.metadata.phonedata = playerData.metadata.phonedata or {
   serialnumber = Ra93Core.functions.createUniqueData("serialnumber"),
   installedapps = {},
  }
  playerData.metadata.deathinfo = playerData.metadata.deathinfo or {}
  if playerData.job and playerData.job.name and not Ra93Core.shared.jobs[playerData.job.name] then playerData.job = nil end
  playerData.job = playerData.job or {}
  playerData.job.name = playerData.job.name or "unemployed"
  playerData.job.label = playerData.job.label or "Civilian"
  playerData.job.payment = playerData.job.payment or Ra93Core.shared.jobs["unemployed"]["grades"]["0"].payment
  playerData.job.type = playerData.job.type or "none"
  playerData.job.status = playerData.job.status or "available"
  if Ra93Core.config.enforceDefaultDuty or playerData.job.onduty == nil then playerData.job.onduty = Ra93Core.shared.jobs[playerData.job.name].defaultDuty end
  playerData.job.isboss = playerData.job.isboss or false
  playerData.job.grade = playerData.job.grade or {}
  playerData.job.grade.name = playerData.job.grade.name or "Freelancer"
  playerData.job.grade.level = playerData.job.grade.level or "0"
  if playerData.gang and playerData.gang.name and not Ra93Core.shared.gangs[playerData.gang.name] then playerData.gang = nil end
  playerData.gang = playerData.gang or {}
  playerData.gang.name = playerData.gang.name or "none"
  playerData.gang.label = playerData.gang.label or "No Gang Affiliaton"
  playerData.gang.status = playerData.gang.status or "available"
  playerData.gang.isboss = playerData.gang.isboss or false
  playerData.gang.grade = playerData.gang.grade or {}
  playerData.gang.grade.name = playerData.gang.grade.name or "none"
  playerData.gang.grade.level = playerData.gang.grade.level or "0"
  playerData.position = playerData.position or Ra93Core.config.defaultSpawn
  playerData.items = GetResourceState("rcInventory") ~= "missing" and exports["rcInventory"]:LoadInventory(playerData.source, playerData.citizenid) or {}
  return Ra93Core.player.createPlayer(playerData, Offline)
 end,
 ["createPlayer"] = function(playerData, Offline)
  local self = {
   ["functions"] = {
    ["addField"] = function(fieldName, data) self[fieldName] = data end,
    ["addHistory"] = function(jg, type, historyData)
     local status = {}
     if not job or not historyData then
      status.error[0] = {
       ["subject"] = "AddToJobHistory Args Empty",
       ["msg"] = "arguments empty: core >server > player.lua AddToJobHistory",
       ["jsMsg"] = "Failure!",
       ["color"] = "error",
       ["logName"] = "Ra93Core",
       ["src"] = src,
       ["log"] = true,
       ["console"] = true
      }
      return status
     end
     self.playerData.metadata[("%shistory"):format(type)][jg] = historyData
     self.functions.updatePlayerData()
     status.success[0] = {
      ["subject"] = "AddToJobHistory Success",
      ["msg"] = "AddToJobHistory Successful!",
      ["jsMsg"] = "Success!",
      ["color"] = "success",
      ["logName"] = "Ra93Core",
      ["src"] = src,
      ["log"] = true
     }
     return status
    end,
    ["addToJobsGangs"] = function(jg, type, data)
     local status = {}
     if not jg or not data or not type then
      status.error[0] = {
       ["subject"] = "AddToJobsGangs Args Empty",
       ["msg"] = "arguments empty: core >server > player.lua AddToJobsGangs",
       ["jsMsg"] = "Failure!",
       ["color"] = "error",
       ["logName"] = "Ra93Core",
       ["src"] = src,
       ["log"] = true,
       ["console"] = true
      }
      return status
     end
     jg = jg:lower()
     self.playerData.metadata[("%ss"):format(type)][jg] = data
     self.functions.updatePlayerData()
     status.success[0] = {
      ["subject"] = "AddToJobsGangs Success",
      ["msg"] = "AddToJobsGangs Successful!",
      ["jsMsg"] = "Success!",
      ["color"] = "success",
      ["logName"] = "Ra93Core",
      ["src"] = src,
      ["log"] = true
     }
     return status
    end,
    ["addMethod"] = function(methodName, handler) self.Functions[methodName] = handler end,
    ["addMoney"] = function(moneytype, amount, reason)
     reason = reason or "unknown"
     moneytype = moneytype:lower()
     amount = tonumber(amount)
     if amount < 0 then return end
     if not self.playerData.currency[moneytype] then return false end
     self.playerData.currency[moneytype] = self.playerData.currency[moneytype] + amount
     if not self.offline then
      self.functions.updatePlayerData()
      TriggerEvent("rcLog:server:createLog", "playermoney", "AddMoney", "lightgreen", ("**%s (citizenid: %s | id: %s)** %s%s (%s) added, new %s balance: %s reason: %s"):format(GetPlayerName(self.playerData.source), self.playerData.citizenid, self.playerData.source, Ra93Core.config.location.currency.symbol, amount, moneytype, moneytype, self.playerData.currency[moneytype], reason))
      TriggerClientEvent("hud:client:onMoneyChange", self.playerData.source, moneytype, amount, false)
      TriggerClientEvent("Ra93Core:client:onMoneyChange", self.playerData.source, moneytype, amount, "add", reason)
      TriggerEvent("Ra93Core:server:onMoneyChange", self.playerData.source, moneytype, amount, "add", reason)
     end
     return true
    end,
    ["getCardSlot"] = function(cardNumber, cardType)
     local item = tostring(cardType):lower()
     local slots = exports["rcInventory"]:GetSlotsByItem(self.playerData.items, item)
     for _, slot in pairs(slots) do
      if slot then
       if self.playerData.items[slot].info.cardNumber == cardNumber then return slot end
      end
     end
     return nil
    end,
    ["getMetaData"] = function(meta)
     if not meta or type(meta) ~= "string" then return end
     return self.playerData.metadata[meta]
    end,
    ["getMoney"] = function(moneytype)
     if not moneytype then return false end
     moneytype = moneytype:lower()
     return self.playerData.currency[moneytype]
    end,
    ["logout"] = function()
     if self.offline then return end
     Ra93Core.player.logout(self.playerData.source)
    end,
    ["modifyReputation"] = function(amount, jg, type)
     if not amount then return end
     amount = tonumber(amount)
     if not self.playerData.metadata[("%srep"):format(type)][jg] then self.playerData.metadata[("%srep"):format(type)][jg] = "0" end
     self.playerData.metadata[("%srep"):format(type)][jg] += amount or amount
     self.functions.updatePlayerData()
    end,
    ["removeFromJobsGangs"] = function(jg, type)
     if not jg then return end
     jg = jg:lower()
     self.playerData.metadata[("%ss"):format(type)][jg] = nil
     self.functions.updatePlayerData()
    end,
    ["removeMoney"] = function(moneytype, amount, reason)
     reason = reason or "unknown"
     moneytype = moneytype:lower()
     amount = tonumber(amount)
     if amount < 0 then return end
     if not self.playerData.currency[moneytype] then return false end
     for _, mtype in pairs(Ra93Core.config.location.currency.dontAllowMinus) do
      if mtype == moneytype then
       if (self.playerData.currency[moneytype] - amount) < 0 then return false end
      end
     end
     self.playerData.currency[moneytype] = self.playerData.currency[moneytype] - amount
     if not self.offline then
      self.functions.updatePlayerData()
      TriggerEvent("rcLog:server:createLog", "playermoney", "RemoveMoney", "red", ("**%s (citizenid: %s | id: %s)** %s%s (%s) removed, new %s balance: %s  reason: %s"):format(GetPlayerName(self.playerData.source), self.playerData.citizenid, self.playerData.source, Ra93Core.config.location.currency.symbol, amount, moneytype, moneytype, self.playerData.currency[moneytype], reason))
      TriggerClientEvent("hud:client:onMoneyChange", self.playerData.source, moneytype, amount, true)
      if moneytype == "bank" then TriggerClientEvent("rcPhone:client:pemoveBankMoney", self.playerData.source, amount) end
      TriggerClientEvent("Ra93Core:client:onMoneyChange", self.playerData.source, moneytype, amount, "remove", reason)
      TriggerEvent("Ra93Core:server:onMoneyChange", self.playerData.source, moneytype, amount, "remove", reason)
     end
     return true
    end,
    ["save"] = function()
     if self.offline then Ra93Core.player.saveOffline(self.playerData)
     else Ra93Core.player.save(self.playerData.source) end
    end,
    ["setActiveJobGang"] = function(job, type)
     self.playerData[type] = nil
     self.playerData[type] = job
     self.functions.updatePlayerData()
    end,
    ["setCreditCard"] = function(cardNumber)
     self.playerData.charinfo.card = cardNumber
     self.functions.updatePlayerData()
    end,
    ["setJobDuty"] = function(onDuty)
     self.playerData.job.onduty = not not onDuty -- Make sure the value is a boolean if nil is sent
     self.functions.updatePlayerData()
    end,
    ["setJobGang"] = function(jg, grade, type, types)
     local selectType = {
     ["job"] = {
      ["func"] = function()
       self.playerData[type].payment = Ra93Core.shared[types]["unemployed"].grades["0"].payment
       self.playerData[type].payment = jobgrade.payment or Ra93Core.shared[types]["unemployed"].grades[grade].payment
       self.playerData[type].onduty = Ra93Core.shared[types][jg].defaultDuty
       self.playerData[type].type = Ra93Core.shared[types][jg].type or "none"
       if not self.offline then
        self.functions.updatePlayerData()
        TriggerEvent("Ra93Core:server:onJobUpdate", self.playerData.source, self.playerData[type])
        TriggerClientEvent("Ra93Core:client:onJobUpdate", self.playerData.source, self.playerData[type])
       end
      end,
      ["gang"] = {
       ["func"] = function()
        if not self.offline then
         self.functions.updatePlayerData()
         TriggerEvent("Ra93Core:server:onGangUpdate", self.playerData.source, self.playerData.gang)
         TriggerClientEvent("Ra93Core:client:onGangUpdate", self.playerData.source, self.playerData.gang)
        end
       end
      }
     }
     }
     jg = jg:lower()
     grade = tostring(grade) or 0
     if not Ra93Core.shared[types][jg] then return false end
     self.playerData[type].name = jg
     self.playerData[type].label = Ra93Core.shared[types][jg].label
     self.playerData[type].status = "hired"
     if Ra93Core.shared[types][jg].grades[grade] then
      local jobgrade = Ra93Core.shared[types][jg].grades[grade]
      self.playerData[type].grade = {}
      self.playerData[type].grade.name = jobgrade.name
      self.playerData[type].grade.level = tostring(grade)
     else
      self.playerData[type].grade = {}
      self.playerData[type].grade.name = Ra93Core.shared[types]["unemployed"].grades["0"].name
      self.playerData[type].grade.level = 0
     end
     selectType[type].func()
     return true
    end,
    ["setMetaData"] = function(meta, val)
     if not meta or type(meta) ~= "string" then return end
     if meta == "hunger" or meta == "thirst" then val = val > 100 and 100 or val end
     self.playerData.metadata[meta] = val
     self.functions.updatePlayerData()
    end,
    ["setMoney"] = function(moneytype, amount, reason)
     reason = reason or "unknown"
     moneytype = moneytype:lower()
     amount = tonumber(amount)
     if amount < 0 then return false end
     if not self.playerData.currency[moneytype] then return false end
     local difference = amount - self.playerData.currency[moneytype]
     self.playerData.currency[moneytype] = amount
     if not self.offline then
      self.functions.updatePlayerData()
      TriggerEvent("rcLog:server:createLog", "playermoney", "SetMoney", "green", ("**%s (citizenid: %s | id: %s)** %s%s (%s) set, new %s balance: %s reason: %s"):format(GetPlayerName(self.playerData.source), self.playerData.citizenid, self.playerData.source, Ra93Core.config.location.currency.symbol, amount, moneytype, moneytype, self.playerData.currency[moneytype], reason))
      TriggerClientEvent("hud:client:onMoneyChange", self.playerData.source, moneytype, math.abs(difference), difference < 0)
      TriggerClientEvent("Ra93Core:client:onMoneyChange", self.playerData.source, moneytype, amount, "set", reason)
      TriggerEvent("Ra93Core:server:onMoneyChange", self.playerData.source, moneytype, amount, "set", reason)
     end
     return true
    end,
    ["setPlayerData"] = function(key, val)
     if not key or type(key) ~= "string" then return end
     self.playerData[key] = val
     self.functions.updatePlayerData()
    end,
    ["updateJobGang"] = function(jg, type, data)
     local status = {}
     if not data then
      status.error[0] = {
       ["subject"] = ("UpdateJobGang Args Empty"):format(),
       ["msg"] = "arguments empty: core >server > player.lua UpdateJobGang",
       ["jsMsg"] = "Failure!",
       ["color"] = "error",
       ["logName"] = "Ra93Core",
       ["src"] = src,
       ["log"] = true,
       ["console"] = true
      }
      return status
     end
     self.playerData[type] = data
     self.functions.updatePlayerData()
     status.success[0] = {
      ["subject"] = "UpdateJobGang Success",
      ["msg"] = "UpdateJobGang Successful!",
      ["jsMsg"] = "Success!",
      ["color"] = "success",
      ["logName"] = "Ra93Core",
      ["src"] = src,
      ["log"] = true
     }
     return status
    end,
    ["updatePlayerData"] = function()
     if self.offline then return end -- Unsupported for Offline Players
     TriggerEvent("Ra93Core:player:setPlayerData", self.playerData)
     TriggerClientEvent("Ra93Core:player:setPlayerData", self.playerData.source, self.playerData)
    end,
   },
   ["playerData"] = playerData,
   ["offline"] = Offline
  }
  if self.offline then return self
  else
   Ra93Core.players[self.playerData.source] = self
   Ra93Core.player.save(self.playerData.source)
   TriggerEvent("Ra93Core:server:playerLoaded", self)
   self.functions.updatePlayerData()
  end
 end,
 ["deleteCharacter"] = function(source, citizenid)
  local license = Ra93Core.functions.getIdentifier(source, "license")
  local result = MySQL.scalar.await("SELECT license FROM players where citizenid = ?", { citizenid })
  if license == result then
   local query = "DELETE FROM %s WHERE citizenid = ?"
   local tableCount = #Ra93Core.config.playerTables
   local queries = {}
   for i = 1, tableCount do
    local v = Ra93Core.config.playerTables[i]
    queries[i] = {query = query:format(v.table), values = { citizenid }}
   end
   MySQL.transaction(queries, function(result2)
    if result2 then TriggerEvent("rcLog:server:createLog", "joinleave", "Character Deleted", "red", ("**%s** %s deleted **%s**"):format(GetPlayerName(source), license, citizenid)) end
   end)
  else
   output.error = {
    ["subject"] = Lang:t("error.playerKickedTitle"),
    ["msg"] = Lang:t("error.playerDeleteExploit", {value = GetPlayerName(source)}),
    ["color"] = "exploit",
    ["logName"] = "rcCore",
    ["src"] = player.playerData.source,
    ["sys"] = {
     ["log"] = true,
     ["kick"] = true
    }
   }
   Ra93Core.functions.messageHandler(output.error)
  end
 end,
 ["forceDeleteCharacter"] = function(citizenid)
  local result = MySQL.scalar.await("SELECT license FROM players where citizenid = ?", { citizenid })
  if result then
   local query = "DELETE FROM %s WHERE citizenid = ?"
   local tableCount = #Ra93Core.config.playerTables
   local queries = {}
   local player = Ra93Core.functions.getPlayerByCitizenId(citizenid)
   if player then
    output.error = {
     ["subject"] = Lang:t("error.adminDeleteTitle"),
     ["msg"] = Lang:t("error.adminDelete"),
     ["color"] = "exploit",
     ["logName"] = "rcCore",
     ["src"] = player.playerData.source,
     ["sys"] = {
      ["log"] = true,
      ["kick"] = true
     }
    }
    Ra93Core.functions.messageHandler(output.error)
   end
   for i = 1, tableCount do
    local v = Ra93Core.config.playerTables[i]
    queries[i] = {query = query:format(v.table), values = { citizenid }}
   end
   MySQL.transaction(queries, function(result2)
    if result2 then TriggerEvent("rcLog:server:createLog", "joinleave", "Character Force Deleted", "red", ("Character **%s** got deleted"):format(citizenid)) end
   end)
  end
 end,
 ["getFirstSlotByItem"] = function(items, itemName)
  if GetResourceState("rcInventory") == "missing" then return end
  return exports["rcInventory"]:GetFirstSlotByItem(items, itemName)
 end,
 ["getOfflinePlayer"] = function(citizenid)
  local playerData = Ra93Core.player.getPlayerData(citizenid)
  if citizenid then
   playerData = Ra93Core.player.getPlayerData(citizenid)
   return Ra93Core.player.checkPlayerData(nil, playerData)
  end
  return nil
 end,
 ["getPlayerData"] = function(citizenid)
  local pd, result
  result = MySQL.prepare.await("SELECT citizenid, license, playerData FROM players where citizenid = ?", { citizenid })
  pd = json.decode(result.playerData)
  pd.citizenid = result.citizenid
  pd.license = result.license
  result = nil
  return pd
 end,
 ["getSlotsByItem"] = function(items, itemName)
  if GetResourceState("rcInventory") == "missing" then return end
  return exports["rcInventory"]:GetSlotsByItem(items, itemName)
 end,
 ["getTotalWeight"] = function(items)
  if GetResourceState("rcInventory") == "missing" then return end
  return exports["rcInventory"]:GetTotalWeight(items)
 end,
 ["login"] = function(source, citizenid, newData)
  local license, playerData
  if source and source ~= "" then
   if citizenid then
    license = Ra93Core.functions.getIdentifier(source, "license")
    playerData = Ra93Core.player.getPlayerData(citizenid)
    if playerData and license ~= playerData.license then
     playerData = nil
     output.error = {
      ["subject"] = Lang:t("error.playerMultiCharDropTitle"),
      ["msg"] = Lang:t("error.playerMultiCharDrop", {value = GetPlayerName(source)}),
      ["color"] = "exploit",
      ["logName"] = "rcCore",
      ["src"] = player.playerData.source,
      ["sys"] = {
       ["log"] = true,
       ["kick"] = true
      }
     }
     Ra93Core.functions.messageHandler(output.error)
     return false
    end
    Ra93Core.player.checkPlayerData(source, playerData)
   else
    Ra93Core.player.checkPlayerData(source, newData)
   end
   return true
  else
   Ra93Core.showError(GetCurrentResourceName(), "ERROR Ra93Core.player.login - NO SOURCE GIVEN!")
   return false
  end
 end,
 ["logout"] = function(source)
  TriggerClientEvent("Ra93Core:client:onPlayerUnload", source)
  TriggerEvent("Ra93Core:server:onPlayerUnload", source)
  TriggerClientEvent("Ra93Core:player:updatePlayerData", source)
  Wait(200)
  Ra93Core.players[source] = nil
 end,
 ["save"] = function(source)
  local ped = GetPlayerPed(source)
  playerData.position = GetEntityCoords(ped)
  local playerData = Ra93Core.players[source].playerData
  if playerData then
   MySQL.insert("INSERT INTO players (citizenid, cid, license, playerdata) VALUES (:citizenid, :cid, :license, :playerdata) ON DUPLICATE KEY UPDATE cid = :cid, playerdata = :playerdata", {
    citizenid = playerData.citizenid,
    cid = tonumber(playerData.cid),
    license = playerData.license,
    playerdata = json.encode(playerData.name),
   })
   if GetResourceState("rcInventory") ~= "missing" then exports["rcInventory"]:SaveInventory(source) end
   Ra93Core.showSuccess(GetCurrentResourceName(), ("%s player SAVED!"):format(playerData.name))
  else Ra93Core.showError(GetCurrentResourceName(), "ERROR Ra93Core.player.save - playerData IS EMPTY!") end
 end,
 ["saveInventory"] = function(source)
  if GetResourceState("rcInventory") == "missing" then return end
  exports["rcInventory"]:SaveInventory(source, false)
 end,
 ["saveOffline"] = function(playerData)
  if playerData then
   MySQL.Async.insert("INSERT INTO players (citizenid, cid, license, playerdata) VALUES (:citizenid, :cid, :license, :playerdata) ON DUPLICATE KEY UPDATE cid = :cid, playerdata = :playerdata", {
    citizenid = playerData.citizenid,
    cid = tonumber(playerData.cid),
    license = playerData.license,
    playerdata = json.encode(playerData)
   })
   if GetResourceState("rcInventory") ~= "missing" then exports["rcInventory"]:SaveInventory(playerData, true) end
   Ra93Core.showSuccess(GetCurrentResourceName(), ("%s OFFLINE player SAVED!"):format(playerData.name))
  else
   Ra93Core.showError(GetCurrentResourceName(), "ERROR Ra93Core.player.sAVEOFFLINE - playerData IS EMPTY!")
  end
 end,
 ["saveOfflineInventory"] = function(playerData)
  if GetResourceState("rcInventory") == "missing" then return end
  exports["rcInventory"]:SaveInventory(playerData, true)
 end,
}
Ra93Core.players = {}
Ra93Core.functions.payCheckInterval()