local setMethod = function(methodName, handler)
 if type(methodName) ~= "string" then return false, "invalid_method_name" end
 Ra93Core.functions[methodName] = handler
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local setField = function(fieldName, data)
 if type(fieldName) ~= "string" then return false, "invalid_field_name" end
 Ra93Core[fieldName] = data
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local addJobGang = function(jg, type, data)
 if type(jg) ~= "string" then return false, "invalid_job_name" end
 if Ra93Core.shared.jobs[jg] then return false, "job_exists" end
 Ra93Core.shared.jobs[jg] = job
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Jobs", jg, job)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local addJobs = function(jobs)
 local shouldContinue = true
 local message = "success"
 local errorItem = nil
 for key, value in pairs(jobs) do
  if type(key) ~= "string" then
   message = "invalid_job_name"
   shouldContinue = false
   errorItem = jobs[key]
   break
  end
  if Ra93Core.shared.jobs[key] then
   message = "job_exists"
   shouldContinue = false
   errorItem = jobs[key]
   break
  end
  Ra93Core.shared.jobs[key] = value
 end
 if not shouldContinue then return false, message, errorItem end
 TriggerClientEvent("Ra93Core:client:onSharedUpdateMultiple", -1, "Jobs", jobs)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, message, nil
end

local removeJob = function(jg)
 if type(jg) ~= "string" then return false, "invalid_job_name" end
 if not Ra93Core.shared.jobs[jg] then return false, "job_not_exists" end
 Ra93Core.shared.jobs[jg] = nil
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Jobs", jg, nil)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local updateJob = function(jg, job)
 if type(jg) ~= "string" then return false, "invalid_job_name" end
 if not Ra93Core.shared.jobs[jg] then return false, "job_not_exists" end
 Ra93Core.shared.jobs[jg] = job
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Jobs", jg, job)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local addItem = function(itemName, item)
 if type(itemName) ~= "string" then return false, "invalid_item_name" end
 if Ra93Core.shared.items[itemName] then return false, "item_exists" end
 Ra93Core.shared.items[itemName] = item
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Items", itemName, item)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local updateItem = function(itemName, item)
 if type(itemName) ~= "string" then return false, "invalid_item_name" end
 if not Ra93Core.shared.items[itemName] then return false, "item_not_exists" end
 Ra93Core.shared.items[itemName] = item
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Items", itemName, item)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local addItems = function(items)
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
  if Ra93Core.shared.items[key] then
   message = "item_exists"
   shouldContinue = false
   errorItem = items[key]
   break
  end
  Ra93Core.shared.items[key] = value
 end
 if not shouldContinue then return false, message, errorItem end
 TriggerClientEvent("Ra93Core:client:onSharedUpdateMultiple", -1, "Items", items)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, message, nil
end

local removeItem = function(itemName)
 if type(itemName) ~= "string" then return false, "invalid_item_name" end
 if not Ra93Core.shared.items[itemName] then return false, "item_not_exists" end
 Ra93Core.shared.items[itemName] = nil
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Items", itemName, nil)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local addGang = function(gangName, gang)
 if type(gangName) ~= "string" then return false, "invalid_gang_name" end
 if Ra93Core.shared.gangs[gangName] then return false, "gang_exists" end
 Ra93Core.shared.gangs[gangName] = gang
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Gangs", gangName, gang)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local addGangs = function(gangs)
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
  if Ra93Core.shared.gangs[key] then
   message = "gang_exists"
   shouldContinue = false
   errorItem = gangs[key]
   break
  end
  Ra93Core.shared.gangs[key] = value
 end
 if not shouldContinue then return false, message, errorItem end
 TriggerClientEvent("Ra93Core:client:onSharedUpdateMultiple", -1, "Gangs", gangs)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, message, nil
end

local removeGang = function(gangName)
 if type(gangName) ~= "string" then return false, "invalid_gang_name" end
 if not Ra93Core.shared.gangs[gangName] then return false, "gang_not_exists" end
 Ra93Core.shared.gangs[gangName] = nil
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Gangs", gangName, nil)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local updateGang = function(gangName, gang)
 if type(gangName) ~= "string" then return false, "invalid_gang_name" end
 if not Ra93Core.shared.gangs[gangName] then return false, "gang_not_exists" end
 Ra93Core.shared.gangs[gangName] = gang
 TriggerClientEvent("Ra93Core:client:onSharedUpdate", -1, "Gangs", gangName, gang)
 TriggerEvent("Ra93Core:server:updateObject")
 return true, "success"
end

local getCoreVersion = function(InvokingResource)
 local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
 if InvokingResource and InvokingResource ~= "" then print(("%s called Ra93Core version check: %s"):format(InvokingResource or "Unknown Resource", resourceVersion)) end
 return resourceVersion
end

local banPlayer = function(src,reason,expire,resource)
 local name = GetPlayerName(src)
 MySQL.insert("INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)", {
  name,
  Ra93Core.functions.getIdentifier(src, "license"),
  Ra93Core.functions.getIdentifier(src, "discord"),
  Ra93Core.functions.getIdentifier(src, "ip"),
  reason,
  expire,
  resource
 })
 TriggerEvent("rcLog:server:CreateLog", resource, "Player Banned", "red", string.format("%s was banned by %s for %s", name, resource, reason))
 DropPlayer(src, ("You were permanently banned by the server for: %s"):format(reason))
end

Ra93Core.functions.setMethod = setMethod
Ra93Core.functions.setField = setField
Ra93Core.functions.addJob = addJob
Ra93Core.functions.addJobs = addJobs
Ra93Core.functions.removeJob = removeJob
Ra93Core.functions.updateJob = updateJob
Ra93Core.functions.addItem = addItem
Ra93Core.functions.updateItem = updateItem
Ra93Core.functions.addItems = addItems
Ra93Core.functions.removeItem = removeItem
Ra93Core.functions.addGang = addGang
Ra93Core.functions.addGangs = addGangs
Ra93Core.functions.removeGang = removeGang
Ra93Core.functions.updateGang = updateGang
Ra93Core.functions.getCoreVersion = getCoreVersion
Ra93Core.functions.banPlayer = banPlayer

exports("addGang", addGang)
exports("addGangs", addGangs)
exports("addItem", addItem)
exports("addItems", addItems)
exports("addJob", addJob)
exports("addJobs", addJobs)
exports("banPlayer",banPlayer)
exports("getCoreVersion", getCoreVersion)
exports("removeGang", removeGang)
exports("removeItem", removeItem)
exports("removeJob", removeJob)
exports("setField", setField)
exports("setMethod", setMethod)
exports("updateGang", updateGang)
exports("updateItem", updateItem)
exports("updateJob", updateJob)