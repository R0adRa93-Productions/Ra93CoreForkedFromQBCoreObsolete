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

local updateShared = function(share, type, action, data, logName)
 local output = {}
 local update = {
  ["add"] = function()
   if Ra93Core.shared[("%ss"):format(type)][share] then
    output.error = {
     ["subject"] = ("%s Exists"):format(type),
     ["msg"] = ("Ra93Core Shared %s Exists"):format(type),
     ["color"] = "error",
     ["logName"] = logName or "rcCore",
     ["sys"] = {
      ["log"] = true
     }
    }
    return false
   end
   Ra93Core.shared[("%ss"):format(type)][share] = data
   return true
  end,
  ["remove"] = function()
   if not Ra93Core.shared[("%ss"):format(type)][share] then
    output.error = {
     ["subject"] = ("%s Does Not Exist"):format(type),
     ["msg"] = ("Ra93Core Shared %s Does Not Exist"):format(type),
     ["color"] = "error",
     ["logName"] = logName or "rcCore",
     ["sys"] = {["log"] = true}
    }
    return false
   end
   Ra93Core.shared[("%ss"):format(type)][share] = nil
   return true
  end,
  ["update"] = function()
   if not Ra93Core.shared[("%ss"):format(type)][share] then
    output.error = {
     ["subject"] = ("%s Does Not Exist"):format(type),
     ["msg"] = ("Ra93Core Shared %s Does Not Exist"):format(type),
     ["color"] = "error",
     ["logName"] = logName or "rcCore",
     ["sys"] = {["log"] = true}
    }
    return false
   end
   Ra93Core.shared[("%ss"):format(type)][share] = data
   return true
  end,
  ["massAdd"] = function()
   for k, v in pairs(share) do
    Ra93Core.shared[("%ss"):format(type)][k] = nil
    Ra93Core.shared[("%ss"):format(type)][k] = v
   end
   return true
  end,
  ["massRemove"] = function()
   for k in pairs(share) do Ra93Core.shared[("%ss"):format(type)][k] = nil end
   return true
  end
 }
 if not update[action]() then
  Ra93Core.functions.messageHandler(output.error)
  return false
 end
 TriggerClientEvent('Ra93Core:client:onSharedUpdate', -1, Ra93Core.shared[("%ss"):format(type)], type)
 TriggerEvent('Ra93Core:server:updateObject')
 output.success = {
  ["subject"] = ("%s Saved"):format(type),
  ["msg"] = ("Ra93Core Shared %s Saved"):format(type),
  ["color"] = "success",
  ["logName"] = logName or "rcCore",
  ["src"] = src,
  ["sys"] = {
   ["log"] = true
  }
 }
 Ra93Core.functions.messageHandler(output.success)
 return true
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
 output.error = {
  ["subject"] = Lang:t("error.playerBannedTitle"),
  ["msg"] = Lang:t("error.playerBannedMessage", {value = reason}),
  ["color"] = "exploit",
  ["logName"] = "rcCore",
  ["src"] = player.playerData.source,
  ["sys"] = {
   ["log"] = true,
   ["kick"] = true,
   ["ban"] = true
  }
 }
 Ra93Core.functions.messageHandler(output.error)
end

Ra93Core.functions.setMethod = setMethod
Ra93Core.functions.setField = setField
Ra93Core.functions.updateShared = updateShared
Ra93Core.functions.getCoreVersion = getCoreVersion
Ra93Core.functions.banPlayer = banPlayer

exports("updateShared", updateShared)
exports("banPlayer",banPlayer)
exports("getCoreVersion", getCoreVersion)
exports("setField", setField)
exports("setMethod", setMethod)