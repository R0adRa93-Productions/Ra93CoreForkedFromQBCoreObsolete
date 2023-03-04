-- Add or change (a) method(s) in the ra93Core.functions table
local function SetMethod(methodName, handler)
 if type(methodName) ~= "string" then
  return false, "invalid_method_name"
 end

 ra93Core.functions[methodName] = handler

 TriggerEvent('ra93Core:Server:UpdateObject')

 return true, "success"
end

ra93Core.functions.SetMethod = SetMethod
exports("SetMethod", SetMethod)

-- Add or change (a) field(s) in the ra93Core table
local function SetField(fieldName, data)
 if type(fieldName) ~= "string" then
  return false, "invalid_field_name"
 end

 ra93Core[fieldName] = data

 TriggerEvent('ra93Core:Server:UpdateObject')

 return true, "success"
end

ra93Core.functions.SetField = SetField
exports("SetField", SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
 if type(jobName) ~= "string" then
  return false, "invalid_job_name"
 end

 if ra93Core.shared.Jobs[jobName] then
  return false, "job_exists"
 end

 ra93Core.shared.Jobs[jobName] = job

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
 local shouldContinue = true
 local message = "success"
 local errorItem = nil

 for key, value in pairs(jobs) do
  if type(key) ~= "string" then
   message = 'invalid_job_name'
   shouldContinue = false
   errorItem = jobs[key]
   break
  end

  if ra93Core.shared.Jobs[key] then
   message = 'job_exists'
   shouldContinue = false
   errorItem = jobs[key]
   break
  end

  ra93Core.shared.Jobs[key] = value
 end

 if not shouldContinue then return false, message, errorItem end
 TriggerClientEvent('ra93Core:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, message, nil
end

ra93Core.functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
 if type(jobName) ~= "string" then
  return false, "invalid_job_name"
 end

 if not ra93Core.shared.Jobs[jobName] then
  return false, "job_not_exists"
 end

 ra93Core.shared.Jobs[jobName] = nil

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
 if type(jobName) ~= "string" then
  return false, "invalid_job_name"
 end

 if not ra93Core.shared.Jobs[jobName] then
  return false, "job_not_exists"
 end

 ra93Core.shared.Jobs[jobName] = job

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
 if type(itemName) ~= "string" then
  return false, "invalid_item_name"
 end

 if ra93Core.shared.Items[itemName] then
  return false, "item_exists"
 end

 ra93Core.shared.Items[itemName] = item

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Items', itemName, item)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
 if type(itemName) ~= "string" then
  return false, "invalid_item_name"
 end
 if not ra93Core.shared.Items[itemName] then
  return false, "item_not_exists"
 end
 ra93Core.shared.Items[itemName] = item
 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Items', itemName, item)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
 local shouldContinue = true
 local message = "success"
 local errorItem = nil

 for key, value in pairs(items) do
  if type(key) ~= "string" then
   message = "invalid_item_name"
   shouldContinue = false
   errorItem = items[key]
   break
  end

  if ra93Core.shared.Items[key] then
   message = "item_exists"
   shouldContinue = false
   errorItem = items[key]
   break
  end

  ra93Core.shared.Items[key] = value
 end

 if not shouldContinue then return false, message, errorItem end
 TriggerClientEvent('ra93Core:Client:OnSharedUpdateMultiple', -1, 'Items', items)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, message, nil
end

ra93Core.functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
 if type(itemName) ~= "string" then
  return false, "invalid_item_name"
 end

 if not ra93Core.shared.Items[itemName] then
  return false, "item_not_exists"
 end

 ra93Core.shared.Items[itemName] = nil

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
 if type(gangName) ~= "string" then
  return false, "invalid_gang_name"
 end

 if ra93Core.shared.Gangs[gangName] then
  return false, "gang_exists"
 end

 ra93Core.shared.Gangs[gangName] = gang

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
 local shouldContinue = true
 local message = "success"
 local errorItem = nil

 for key, value in pairs(gangs) do
  if type(key) ~= "string" then
   message = "invalid_gang_name"
   shouldContinue = false
   errorItem = gangs[key]
   break
  end

  if ra93Core.shared.Gangs[key] then
   message = "gang_exists"
   shouldContinue = false
   errorItem = gangs[key]
   break
  end

  ra93Core.shared.Gangs[key] = value
 end

 if not shouldContinue then return false, message, errorItem end
 TriggerClientEvent('ra93Core:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, message, nil
end

ra93Core.functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
 if type(gangName) ~= "string" then
  return false, "invalid_gang_name"
 end

 if not ra93Core.shared.Gangs[gangName] then
  return false, "gang_not_exists"
 end

 ra93Core.shared.Gangs[gangName] = nil

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
 if type(gangName) ~= "string" then
  return false, "invalid_gang_name"
 end

 if not ra93Core.shared.Gangs[gangName] then
  return false, "gang_not_exists"
 end

 ra93Core.shared.Gangs[gangName] = gang

 TriggerClientEvent('ra93Core:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
 TriggerEvent('ra93Core:Server:UpdateObject')
 return true, "success"
end

ra93Core.functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local function GetCoreVersion(InvokingResource)
 local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
 if InvokingResource and InvokingResource ~= '' then
  print(("%s called ra93Core version check: %s"):format(InvokingResource or 'Unknown Resource', resourceVersion))
 end
 return resourceVersion
end

ra93Core.functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
 local name = GetPlayerName(playerId)
 MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
  name,
  ra93Core.functions.GetIdentifier(playerId, 'license'),
  ra93Core.functions.GetIdentifier(playerId, 'discord'),
  ra93Core.functions.GetIdentifier(playerId, 'ip'),
  origin,
  2147483647,
  'Anti Cheat'
 })
 DropPlayer(playerId, Lang:t('info.exploit_banned', {discord = ra93Core.config.Server.Discord}))
 TriggerEvent("qb-log:server:CreateLog", "anticheat", "Anti-Cheat", "red", name .. " has been banned for exploiting " .. origin)
end

exports('ExploitBan', ExploitBan)
