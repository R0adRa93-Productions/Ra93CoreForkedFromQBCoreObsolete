local onPlayerConnecting = function(name, _, deferrals)
 local src = source
 local license
 local identifiers = GetPlayerIdentifiers(src)
 deferrals.defer()
 Wait(0)
 if Ra93Core.config.server.closed then
  if not IsPlayerAceAllowed(src, "qbadmin.join") then deferrals.done(Ra93Core.config.server.closedReason) end
 end
 for _, v in pairs(identifiers) do
  if string.find(v, "license") then
   license = v
   break
  end
 end
 if GetConvarInt("sv_fxdkMode", false) then license = "license:AAAAAAAAAAAAAAAA" end -- Dummy License
 if not license then deferrals.done(Lang:t("error.no_valid_license"))
 elseif Ra93Core.config.server.checkDuplicateLicense and Ra93Core.functions.isLicenseInUse(license) then deferrals.done(Lang:t("error.duplicate_license")) end
 local databaseTime = os.clock()
 local databasePromise = promise.new()
 CreateThread(function()
  deferrals.update(string.format(Lang:t("info.checking_ban"), name))
  local databaseSuccess, databaseError = pcall(function()
   local isBanned, Reason = Ra93Core.functions.isPlayerBanned(src)
   if isBanned then deferrals.done(Reason) end
  end)
  if Ra93Core.config.server.whitelist then
   deferrals.update(string.format(Lang:t("info.checking_whitelisted"), name))
   databaseSuccess, databaseError = pcall(function()
    if not Ra93Core.functions.isWhitelisted(src) then deferrals.done(Lang:t("error.not_whitelisted")) end
   end)
  end
  if not databaseSuccess then databasePromise:reject(databaseError) end
  databasePromise:resolve()
 end)
 databasePromise:next(function()
  deferrals.update(string.format(Lang:t("info.join_server"), name))
  deferrals.done()
 end, function (databaseError)
  deferrals.done(Lang:t("error.connecting_database_error"))
  print(("^1%s"), databaseError)
 end)
 while databasePromise.state == 0 do
  if os.clock() - databaseTime > 30 then
   deferrals.done(Lang:t("error.connecting_database_timeout"))
   error(Lang:t("error.connecting_database_timeout"))
   break
  end
  Wait(1000)
 end
end

Ra93Core.functions.createCallback("Ra93Core:server:spawnVehicle", function(source, cb, model, coords, warp)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
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
 cb(NetworkGetNetworkIdFromEntity(veh))
end)

Ra93Core.functions.createCallback("Ra93Core:server:createVehicle", function(source, cb, model, coords, warp)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 model = type(model) == "string" and GetHashKey(model) or model
 if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
 local CreateAutomobile = GetHashKey("CREATE_AUTOMOBILE")
 local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, coords.w, true, true)
 while not DoesEntityExist(veh) do Wait(0) end
 if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
 cb(NetworkGetNetworkIdFromEntity(veh))
end)

AddEventHandler("chatMessage", function(_, _, message)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 if string.sub(message, 1, 1) == "/" then
  CancelEvent()
  return
 end
end)

AddEventHandler("playerDropped", function(reason)
 -- need to figure out another way to ensure security on this one.
 local src = source
 if not Ra93Core.players[src] then return end
 local player = Ra93Core.players[src]
 TriggerEvent("rcLog:server:createLog", "joinleave", "Dropped", "red", ("** %s ** (%s) left..\n** Reason: %s **"):format(GetPlayerName(src), player.playerData.license, reason))
 player.functions.save()
 Ra93Core.playerBuckets[player.playerData.license] = nil
 Ra93Core.players[src] = nil
end)

AddEventHandler("playerConnecting", onPlayerConnecting)

RegisterNetEvent("Ra93Core:server:closeServer", function(reason)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 if not Ra93Core.functions.hasPermission(src, "admin") then
  output.error = {
   ["subject"] = Lang:t("error.no_permission"),
   ["msg"] = Lang:t("error.no_permission"),
   ["color"] = "error",
   ["logName"] = "rcCore",
   ["src"] = player.playerData.source,
   ["sys"] = {
    ["log"] = true,
    ["kick"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
 end
 reason = reason or "No reason specified"
 Ra93Core.config.server.closed = true
 Ra93Core.config.server.closedReason = reason
 for k in pairs(Ra93Core.players) do
  if not Ra93Core.functions.hasPermission(k, Ra93Core.config.server.whitelistPermission) then
   output.error = {
    ["subject"] = reason,
    ["msg"] = reason,
    ["color"] = "error",
    ["logName"] = "rcCore",
    ["src"] = player.playerData.source,
    ["sys"] = {
     ["log"] = true,
     ["kick"] = true
    }
   }
   Ra93Core.functions.messageHandler(output.error)
  end
 end
end)

RegisterNetEvent("Ra93Core:server:openServer", function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 if Ra93Core.functions.hasPermission(src, "admin") then Ra93Core.config.server.closed = false
 else
  output.error = {
   ["subject"] = Lang:t("error.no_permission"),
   ["msg"] = Lang:t("error.no_permission"),
   ["color"] = "error",
   ["logName"] = "rcCore",
   ["src"] = player.playerData.source,
   ["sys"] = {
    ["log"] = true,
    ["kick"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
 end
end)

RegisterNetEvent("Ra93Core:server:triggerClientCallback", function(name, ...)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 if Ra93Core.clientCallBacks[name] then
  Ra93Core.clientCallBacks[name](...)
  Ra93Core.clientCallBacks[name] = nil
 end
end)

RegisterNetEvent("Ra93Core:server:triggerCallback", function(name, ...)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 Ra93Core.functions.triggerCallback(name, src, function(...) TriggerClientEvent("Ra93Core:client:triggerCallback", src, name, ...) end, ...)
end)

RegisterNetEvent("Ra93Core:updatePlayer", function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return end
 local newHunger = player.playerData.metadata["hunger"] - Ra93Core.config.player.HungerRate
 local newThirst = player.playerData.metadata["thirst"] - Ra93Core.config.player.ThirstRate
 if newHunger <= 0 then newHunger = 0 end
 if newThirst <= 0 then newThirst = 0 end
 player.functions.setMetaData("thirst", newThirst)
 player.functions.setMetaData("hunger", newHunger)
 TriggerClientEvent("hud:client:updateNeeds", src, newHunger, newThirst)
 player.functions.save()
end)

RegisterNetEvent("Ra93Core:toggleDuty", function()
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return end
 if player.playerData.job.onduty then
  player.functions.setJobDuty(false)
  output.notify = {
   ["subject"] = Lang:t("info.off_duty"),
   ["msg"] = Lang:t("info.off_duty"),
   ["color"] = "notify",
   ["logName"] = "rcCore",
   ["src"] = source,
   ["sys"] = {
    ["log"] = true,
    ["notify"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.notify)
 else
  player.functions.setJobDuty(true)
  output.notify = {
   ["subject"] = Lang:t("info.on_duty"),
   ["msg"] = Lang:t("info.on_duty"),
   ["color"] = "notify",
   ["logName"] = "rcCore",
   ["src"] = source,
   ["sys"] = {
    ["log"] = true,
    ["notify"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.notify)
 end
 TriggerClientEvent("Ra93Core:client:setDuty", src, player.playerData.job.onduty)
end)

RegisterNetEvent("Ra93Core:callCommand", function(command, args)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local src = source
 if not Ra93Core.commands.list[command] then return end
 local player = Ra93Core.functions.getPlayer(src)
 if not player then return end
 local hasPerm = Ra93Core.functions.hasPermission(src, "command."..Ra93Core.commands.list[command].name)
 if hasPerm then
  if Ra93Core.commands.list[command].argsrequired and #Ra93Core.commands.list[command].arguments ~= 0 and not args[#Ra93Core.commands.list[command].arguments] then
   output.error = {
    ["subject"] = Lang:t("error.missing_args2"),
    ["msg"] = Lang:t("error.missing_args2"),
    ["color"] = "error",
    ["logName"] = "rcCore",
    ["src"] = source,
    ["sys"] = {
     ["log"] = true,
     ["notify"] = true
    }
   }
   Ra93Core.functions.messageHandler(output.error)
  else Ra93Core.commands.list[command].callback(src, args) end
 else
  output.error = {
   ["subject"] = Lang:t("error.no_access"),
   ["msg"] = Lang:t("error.no_access"),
   ["color"] = "error",
   ["logName"] = "rcCore",
   ["src"] = source,
   ["sys"] = {
    ["log"] = true,
    ["notify"] = true
   }
  }
  Ra93Core.functions.messageHandler(output.error)
 end
end)

RegisterServerEvent("Ra93Core:server:messageHandler", function(error)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 Ra93Core.functions.messageHandler(error)
end)

RegisterServerEvent("baseevents:enteringVehicle", function(veh,seat,modelName)
-- Need to figure out a way to secure the baseevents
 local src = source
 local data = {
  vehicle = veh,
  seat = seat,
  name = modelName,
  event = "Entering"
 }
 TriggerClientEvent("Ra93Core:client:vehicleInfo", src, data)
end)

RegisterServerEvent("baseevents:enteredVehicle", function(veh,seat,modelName)
-- Need to figure out a way to secure the baseevents
 local src = source
 local data = {
  vehicle = veh,
  seat = seat,
  name = modelName,
  event = "Entered"
 }
 TriggerClientEvent("Ra93Core:client:vehicleInfo", src, data)
end)

RegisterServerEvent("baseevents:enteringAborted", function()
-- Need to figure out a way to secure the baseevents
 local src = source
 TriggerClientEvent("Ra93Core:client:abortVehicleEntering", src)
end)

RegisterServerEvent("baseevents:leftVehicle", function(veh,seat,modelName)
-- Need to figure out a way to secure the baseevents
 local src = source
 local data = {
  vehicle = veh,
  seat = seat,
  name = modelName,
  event = "Left"
 }
 TriggerClientEvent("Ra93Core:client:vehicleInfo", src, data)
end)