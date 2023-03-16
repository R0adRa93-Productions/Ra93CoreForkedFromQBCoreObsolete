Ra93Core.playerBuckets = {}
Ra93Core.entityBuckets = {}
Ra93Core.usableItems = {}
Ra93Core.functions = {
 ["addPermission"] = function(source, permission)
  if not IsPlayerAceAllowed(source, permission) then
   ExecuteCommand(("add_principal player.%s Ra93Core.%s"):format(source, permission))
   Ra93Core.commands.refresh(source)
  end
 end,
 ["addPlayerField"] = function(ids, fieldName, data)
  local idType = type(ids)
  if idType == "number" then
   if ids == -1 then
   for _, v in pairs(Ra93Core.players) do v.functions.addField(fieldName, data) end
   else
    if not Ra93Core.players[ids] then return end
    Ra93Core.players[ids].functions.addField(fieldName, data)
   end
  elseif idType == "table" and type(ids) == "array" then
   for i = 1, #ids do Ra93Core.functions.addPlayerField(ids[i], fieldName, data) end
  end
 end,
 ["addPlayerMethod"] = function(ids, methodName, handler)
  local idType = type(ids)
  if idType == "number" then
   if ids == -1 then
    for _, v in pairs(Ra93Core.players) do v.functions.addMethod(methodName, handler) end
   else
    if not Ra93Core.players[ids] then return end
    Ra93Core.players[ids].functions.addMethod(methodName, handler)
   end
  elseif idType == "table" and type(ids) == "array" then
   for i = 1, #ids do Ra93Core.functions.addPlayerMethod(ids[i], methodName, handler) end
  end
 end,
 ["canUseItem"] = function(item) return Ra93Core.usableItems[item] end,
 ["createUseableItem"] = function(item, data) Ra93Core.usableItems[item] = data end,
 ["createUniqueData"] = function(uniqueKey)
  local uniqueValue
  local isUnique = false
  local unique = {
   ["account"] = {
    ["func"] = function() return ("%s0%s%s%s%s"):format(Ra93Core.location.countryCode,math.random(1, 9),math.random(1111, 9999),math.random(1111, 9999),math.random(11, 99)) end,
    ["sql"] =  "JSON_VALUE(`playerData`, '$.charinfo.account')"
   },
   ["phone"] = {
    ["func"] = function()
     local min = {
      ["areaCode"] = tonumber(string.rep("1", Ra93Core.config.areaCodeDigits)),
      ["exchange"] = tonumber(string.rep("1", Ra93Core.config.exchangeDigits)),
      ["subscriber"] = tonumber(string.rep("1", Ra93Core.config.subscriberDigits))
     }
     local max = {
      ["areaCode"] = tonumber(string.rep("9", Ra93Core.config.areaCodeDigits)),
      ["exchange"] = tonumber(string.rep("9", Ra93Core.config.exchangeDigits)),
      ["subscriber"] = tonumber(string.rep("9", Ra93Core.config.subscriberDigits))
     }
     return tonumber(("%s%s%s%s"):format(Ra93Core.config.countryCode, math.random(min.areaCode, max.areaCode), math.random(min.exchange, max.exchange), math.random(min.subscriber, max.subscriber)))
    end,
    ["sql"] =  "JSON_VALUE(`playerData`, '$.charinfo.phone')"
   },
   ["fingerprint"] = {
    ["func"] = function() return ("%s%d%s%d%s%d"):format(Ra93Core.shared.randomStr(2), Ra93Core.shared.randomInt(3), Ra93Core.shared.randomStr(1), Ra93Core.shared.randomInt(2), Ra93Core.shared.randomStr(3), Ra93Core.shared.randomInt(4)) end,
    ["sql"] =  "JSON_VALUE(`playerData`, '$.metadata.fingerprint')"
   },
   ["walletid"] = {
    ["func"] = function() return ("RCW-"):format(math.random(11111111, 99999999)) end,
    ["sql"] =  "JSON_VALUE(`playerData`, '$.metadata.walletid')"
   },
   ["serialnumber"] = {
    ["func"] = function() return math.random(11111111, 99999999) end,
    ["sql"] =  "JSON_VALUE(`playerData`, '$.metadata.phonedata.serialnumber')"
   }
  }
  while not isUnique do
   uniqueValue = unique[uniqueKey].func()
   local result = MySQL.prepare.await(("SELECT citizenid FROM players WHERE %s = ?"):format(unique[uniqueKey].sql), { uniqueValue })
   if result == 0 then isUnique = true end
  end
  return uniqueValue
 end,
 ["createVehicle"] = function(source, model, coords, warp)
  model = type(model) == "string" and joaat(model) or model
  if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
  local createAutomobile = `CREATE_AUTOMOBILE`
  local veh = Citizen.InvokeNative(createAutomobile, model, coords, coords.w, true, true)
  while not DoesEntityExist(veh) do Wait(0) end
  if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
  return veh
 end,
 ["createCallback"] = function(name, cb) Ra93Core.serverCallbacks[name] = cb end,
 ["getBucketObjects"] = function() return Ra93Core.playerBuckets, Ra93Core.entityBuckets end,
 ["getCoords"] = function(entity)
  local coords = GetEntityCoords(entity, false)
  local heading = GetEntityHeading(entity)
  return vector4(coords.x, coords.y, coords.z, heading)
 end,
 ["getDutyCount"] = function(job)
  local count = 0
  for _, player in pairs(Ra93Core.players) do
   if player.playerData.job.name == job then
 if player.playerData.job.onduty then count += 1 end
   end
  end
  return count
 end,
 ["setEntityBucket"] = function(entity --[[ int ]], bucket --[[ int ]])
  if entity and bucket then
   SetEntityRoutingBucket(entity, bucket)
   Ra93Core.entityBuckets[entity] = {id = entity, bucket = bucket}
   return true
  else return false end
 end,
 ["getEntitiesInBucket"] = function(bucket --[[ int ]])
  local curr_bucket_pool = {}
  if Ra93Core.entityBuckets and next(Ra93Core.entityBuckets) then
   for _, v in pairs(Ra93Core.entityBuckets) do
 if v.bucket == bucket then curr_bucket_pool[#curr_bucket_pool + 1] = v.id end
   end
   return curr_bucket_pool
  else return false end
 end,
 ["getIdentifier"] = function(source, idtype)
  local identifiers = GetPlayerIdentifiers(source)
  for _, identifier in pairs(identifiers) do
   if string.find(identifier, idtype) then return identifier end
  end
  return nil
 end,
 ["getOfflinePlayerByCitizenId"] = function(citizenid) return Ra93Core.player.getOfflinePlayer(citizenid) end,
 ["getPermission"] = function(source)
  local src = source
  local perms = {}
  for _, v in pairs (Ra93Core.config.server.permissions) do
   if IsPlayerAceAllowed(src, v) then perms[v] = true end
  end
  return perms
 end,
 ["getPlayer"] = function(source)
  if type(source) == "number" then return Ra93Core.players[source]
  else return Ra93Core.players[Ra93Core.functions.getSource(source)] end
 end,
 ["getPlayerByCitizenId"] = function(citizenid)
  for src in pairs(Ra93Core.players) do
   if Ra93Core.players[src].playerData.citizenid == citizenid then return Ra93Core.players[src] end
  end
  return nil
 end,
 ["getPlayerByPhone"] = function(number)
  for src in pairs(Ra93Core.players) do
   if Ra93Core.players[src].playerData.charinfo.phone == number then return Ra93Core.players[src] end
  end
  return nil
 end,
 ["getPlayers"] = function()
  local sources = {}
  for k in pairs(Ra93Core.players) do sources[#sources+1] = k end
  return sources
 end,
 ["getPlayersInBucket"] = function(bucket)
  local curr_bucket_pool = {}
  if Ra93Core.playerBuckets and next(Ra93Core.playerBuckets) then
   for _, v in pairs(Ra93Core.playerBuckets) do
    if v.bucket == bucket then curr_bucket_pool[#curr_bucket_pool + 1] = v.id end
   end
   return curr_bucket_pool
  else return false end
 end,
 ["getPlayersOnDuty"] = function(job)
  local players = {}
  local count = 0
  for src, player in pairs(Ra93Core.players) do
   if player.playerData.job.name == job then
    if player.playerData.job.onduty then
     players[#players + 1] = src
     count += 1
    end
   end
  end
  return players, count
 end,
 ["getSource"] = function(identifier)
  for src, _ in pairs(Ra93Core.players) do
   local idens = GetPlayerIdentifiers(src)
   for _, id in pairs(idens) do
    if identifier == id then return src end
   end
  end
  return 0
 end,
 ["getQBPlayers"] = function() return Ra93Core.players end,
 ["hasItem"] = function(source, items, amount)
  if GetResourceState("rcInventory") == "missing" then return end
  return exports["rcInventory"]:HasItem(source, items, amount)
 end,
 ["hasPermission"] = function(source, permission)
  if type(permission) == "string" then
   if IsPlayerAceAllowed(source, permission) then return true end
   elseif type(permission) == "table" then
    for _, permLevel in pairs(permission) do
    if IsPlayerAceAllowed(source, permLevel) then return true end
   end
  end
  return false
 end,
 ["isLicenseInUse"] = function(license)
  local players = GetPlayers()
  for _, player in pairs(players) do
   local identifiers = GetPlayerIdentifiers(player)
   for _, id in pairs(identifiers) do
    if string.find(id, "license") and id == license then return true end
   end
  end
  return false
 end,
 ["isOptin"] = function(source)
  local license = Ra93Core.functions.getIdentifier(source, "license")
  if not license or not Ra93Core.functions.hasPermission(source, "admin") then return false end
  local player = Ra93Core.functions.getPlayer(source)
  return player.playerData.optin
 end,
 ["isPlayerBanned"] = function(source)
  local pLicense = Ra93Core.functions.getIdentifier(source, "license")
  local result = MySQL.single.await("SELECT * FROM bans WHERE license = ?", { pLicense })
  if not result then return false end
  if os.time() < result.expire then
   local timeTable = os.date("*t", tonumber(result.expire))
   return true, ("You have been banned from the server:\n%s\nYour ban expires %s/%s/%s %s:%s\n"):format(result.reason, timeTable.day, timeTable.month, timeTable.year, timeTable.hour, timeTable.min)
  else MySQL.query("DELETE FROM bans WHERE id = ?", { result.id }) end
  return false
 end,
 ["isWhitelisted"] = function(source)
  if not Ra93Core.config.server.whitelist then return true end
  if Ra93Core.functions.hasPermission(source, Ra93Core.config.server.whitelistPermission) then return true end
  return false
 end,
 ["messageHandler"] = function(data)
  data.color = data.color or "default"
  data.banExpire = data.banExpire or 2147483647
  data.resource = data.resource or "rcCore"
  local messageSystems = {
   ["notify"] = function() TriggerClientEvent('Ra93Core:Notify', data.src, data.msg) end,
   ["log"] = function() TriggerEvent('rcLog:server:CreateLog', data.logName, data.subject, Ra93Config.notify.variantDefinitions[data.color].log, data.msg) end,
   ["console"] = function()
    data.msg = ("%s%s"):format(Ra93Config.notify.variantDefinitions[data.color], data.msg)
    print(msg)
   end,
   ["kick"] = function() DropPlayer(data.src, data.msg) end,
   ["ban"] = function() Ra93Core.functions.banPlayer(data.src, data.msg, data.banExpire, data.logName) end
  }
  for k in pairs(data.sys) do messageSystems[k]() end
 end,
 ["prepForSQL"] = function(source,data,pattern)
  data = tostring(data)
  local src = source
  local player = Ra93Core.functions.getPlayer(src)
  local result = string.match(data, pattern)
  if not result or string.len(result) ~= string.len(data)  then
   TriggerEvent("rcSmallResources:server:createLog", "anticheat", "SQL Exploit Attempted", "red", ("%s attempted to exploit SQL!"):format(player.playerData.license))
   return false
  end
  return true
 end,
 ["setPlayerBucket"] = function(source, bucket)
  if source and bucket then
   local license = tostring(Ra93Core.functions.getIdentifier(source, "license"))
   SetPlayerRoutingBucket(source, bucket)
   Ra93Core.playerBuckets[license] = {id = source, bucket = bucket}
   return true
  else return false end
 end,
 ["spawnVehicle"] = function(source, model, coords, warp)
  local ped = GetPlayerPed(source)
  model = type(model) == "string" and joaat(model) or model
  if not coords then coords = GetEntityCoords(ped) end
  local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
  while not DoesEntityExist(veh) do Wait(0) end
  if warp then
   while GetVehiclePedIsIn(ped) ~= veh do
    Wait(0)
    TaskWarpPedIntoVehicle(ped, veh, -1)
   end
  end
  while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
  return veh
 end,
 ["payCheckInterval"] = function()
  if next(Ra93Core.players) then
   for _, player in pairs(Ra93Core.players) do
    if player then
     local payment = player.playerData.job.payment
     if not payment then payment = Config.jobs[player.playerData.job.name]["grades"][tostring(player.playerData.job.grade.level)].payment end
     if player.playerData.job and payment > 0 and (Config.jobs[player.playerData.job.name].offDutyPay or player.playerData.job.onduty) then
      if Ra93Core.config.location.currency.payCheckSociety then
       local account = exports["rcEconomy"]:getAccount(player.playerData.job.name)
       if account ~= 0 then
        if account < payment then
         output.error = {
          ["subject"] = Lang:t("error.company_too_poor"),
          ["msg"] = Lang:t("error.company_too_poor"),
          ["color"] = "error",
          ["logName"] = "rcCore",
          ["src"] = player.playerData.source,
          ["sys"] = {
           ["log"] = true,
           ["notify"] = true
          }
         }
         Ra93Core.functions.messageHandler(output.error)
        else
         player.functions.addMoney("bank", payment)
         exports["rcEconomy"]:removeMoney(player.playerData.job.name, payment)
         output.notify = {
          ["subject"] = Lang:t("info.received_paycheck", {value = payment}),
          ["msg"] = Lang:t("info.received_paycheck", {value = payment}),
          ["color"] = "notify",
          ["logName"] = "rcCore",
          ["src"] = player.playerData.source,
          ["sys"] = {
           ["log"] = true,
           ["notify"] = true
          }
         }
         Ra93Core.functions.messageHandler(output.notify)
        end
       else
        player.functions.addMoney("bank", payment)
        output.notify = {
         ["subject"] = Lang:t("info.received_paycheck", {value = payment}),
         ["msg"] = Lang:t("info.received_paycheck", {value = payment}),
         ["color"] = "notify",
         ["logName"] = "rcCore",
         ["src"] = player.playerData.source,
         ["sys"] = {
          ["log"] = true,
          ["notify"] = true
         }
        }
        Ra93Core.functions.messageHandler(output.notify)
       end
      else
       player.functions.addMoney("bank", payment)
       output.notify = {
        ["subject"] = Lang:t("info.received_paycheck", {value = payment}),
        ["msg"] = Lang:t("info.received_paycheck", {value = payment}),
        ["color"] = "notify",
        ["logName"] = "rcCore",
        ["src"] = player.playerData.source,
        ["sys"] = {
         ["log"] = true,
         ["notify"] = true
        }
       }
       Ra93Core.functions.messageHandler(output.notify)
      end
     end
    end
   end
  end
  SetTimeout(Ra93Core.config.location.currency.payCheckTimeOut * (60 * 1000), Ra93Core.functions.payCheckInterval)
 end,
 ["removePermission"] = function(source, permission)
  if permission then
   if IsPlayerAceAllowed(source, permission) then
    ExecuteCommand(("remove_principal player.%s Ra93Core.%s"):format(source, permission))
    Ra93Core.commands.refresh(source)
   end
  else
   for _, v in pairs(Ra93Core.config.server.permissions) do
    if IsPlayerAceAllowed(source, v) then
     ExecuteCommand(("remove_principal player.%s Ra93Core.%s"):format(source, v))
     Ra93Core.commands.refresh(source)
    end
   end
  end
 end,
 ["toggleOptin"] = function(source)
  local license = Ra93Core.functions.getIdentifier(source, "license")
  if not license or not Ra93Core.functions.hasPermission(source, "admin") then return end
  local player = Ra93Core.functions.getPlayer(source)
  player.playerData.optin = not player.playerData.optin
  player.functions.setPlayerData("optin", player.playerData.optin)
 end,
 ["triggerCallback"] = function(name, source, cb, ...)
  if not Ra93Core.serverCallbacks[name] then return end
  Ra93Core.serverCallbacks[name](source, cb, ...)
 end,
 ["triggerClientCallback"] = function(name, source, cb, ...)
  Ra93Core.clientCallBacks[name] = cb
  TriggerClientEvent("Ra93Core:client:triggerClientCallback", source, name, ...)
 end,
 ["useItem"] = function(source, item)
  if GetResourceState("rcInventory") == "missing" then return end
  exports["rcInventory"]:useItem(source, item)
 end
}