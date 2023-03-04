-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
 if string.sub(message, 1, 1) == '/' then
  CancelEvent()
  return
 end
end)

AddEventHandler('playerDropped', function(reason)
 local src = source
 if not ra93Core.Players[src] then return end
 local Player = ra93Core.Players[src]
 TriggerEvent('qb-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' ..'\n **Reason:** ' .. reason)
 Player.Functions.Save()
 ra93Core.Player_Buckets[Player.PlayerData.license] = nil
 ra93Core.Players[src] = nil
end)

-- Player Connecting

local function onPlayerConnecting(name, _, deferrals)
 local src = source
 local license
 local identifiers = GetPlayerIdentifiers(src)
 deferrals.defer()

 -- Mandatory wait
 Wait(0)

 if ra93Core.config.Server.Closed then
  if not IsPlayerAceAllowed(src, 'qbadmin.join') then
   deferrals.done(ra93Core.config.Server.ClosedReason)
  end
 end

 for _, v in pairs(identifiers) do
  if string.find(v, 'license') then
   license = v
   break
  end
 end

 if GetConvarInt("sv_fxdkMode", false) then
  license = 'license:AAAAAAAAAAAAAAAA' -- Dummy License
 end

 if not license then
  deferrals.done(Lang:t('error.no_valid_license'))
 elseif ra93Core.config.Server.CheckDuplicateLicense and ra93Core.functions.IsLicenseInUse(license) then
  deferrals.done(Lang:t('error.duplicate_license'))
 end

 local databaseTime = os.clock()
 local databasePromise = promise.new()

 -- conduct database-dependant checks
 CreateThread(function()
  deferrals.update(string.format(Lang:t('info.checking_ban'), name))
  local databaseSuccess, databaseError = pcall(function()
   local isBanned, Reason = ra93Core.functions.IsPlayerBanned(src)
   if isBanned then
    deferrals.done(Reason)
   end
  end)

  if ra93Core.config.Server.Whitelist then
   deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
   databaseSuccess, databaseError = pcall(function()
    if not ra93Core.functions.IsWhitelisted(src) then
     deferrals.done(Lang:t('error.not_whitelisted'))
    end
   end)
  end

  if not databaseSuccess then
   databasePromise:reject(databaseError)
  end
  databasePromise:resolve()
 end)

 -- wait for database to finish
 databasePromise:next(function()
  deferrals.update(string.format(Lang:t('info.join_server'), name))
  deferrals.done()
 end, function (databaseError)
  deferrals.done(Lang:t('error.connecting_database_error'))
  print('^1' .. databaseError)
 end)

 -- if conducting checks for too long then raise error
 while databasePromise.state == 0 do
  if os.clock() - databaseTime > 30 then
   deferrals.done(Lang:t('error.connecting_database_timeout'))
   error(Lang:t('error.connecting_database_timeout'))
   break
  end
  Wait(1000)
 end

 -- Add any additional defferals you may need!
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('ra93Core:Server:CloseServer', function(reason)
 local src = source
 if ra93Core.functions.HasPermission(src, 'admin') then
  reason = reason or 'No reason specified'
  ra93Core.config.Server.Closed = true
  ra93Core.config.Server.ClosedReason = reason
  for k in pairs(ra93Core.Players) do
   if not ra93Core.functions.HasPermission(k, ra93Core.config.Server.WhitelistPermission) then
    ra93Core.functions.Kick(k, reason, nil, nil)
   end
  end
 else
  ra93Core.functions.Kick(src, Lang:t("error.no_permission"), nil, nil)
 end
end)

RegisterNetEvent('ra93Core:Server:OpenServer', function()
 local src = source
 if ra93Core.functions.HasPermission(src, 'admin') then
  ra93Core.config.Server.Closed = false
 else
  ra93Core.functions.Kick(src, Lang:t("error.no_permission"), nil, nil)
 end
end)

-- Callback Events --

-- Client Callback

RegisterNetEvent('ra93Core:Server:TriggerClientCallback', function(name, ...)
 if ra93Core.clientCallBacks[name] then
  ra93Core.clientCallBacks[name](...)
  ra93Core.clientCallBacks[name] = nil
 end
end)

-- Server Callback

RegisterNetEvent('ra93Core:Server:TriggerCallback', function(name, ...)
 local src = source
 ra93Core.functions.TriggerCallback(name, src, function(...)
  TriggerClientEvent('ra93Core:Client:TriggerCallback', src, name, ...)
 end, ...)
end)

-- Player

RegisterNetEvent('ra93Core:UpdatePlayer', function()
 local src = source
 local Player = ra93Core.functions.GetPlayer(src)
 if not Player then return end
 local newHunger = Player.PlayerData.metadata['hunger'] - ra93Core.config.Player.HungerRate
 local newThirst = Player.PlayerData.metadata['thirst'] - ra93Core.config.Player.ThirstRate
 if newHunger <= 0 then
  newHunger = 0
 end
 if newThirst <= 0 then
  newThirst = 0
 end
 Player.Functions.SetMetaData('thirst', newThirst)
 Player.Functions.SetMetaData('hunger', newHunger)
 TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
 Player.Functions.Save()
end)

RegisterNetEvent('ra93Core:ToggleDuty', function()
 local src = source
 local Player = ra93Core.functions.GetPlayer(src)
 if not Player then return end
 if Player.PlayerData.job.onduty then
  Player.Functions.SetJobDuty(false)
  TriggerClientEvent('ra93Core:Notify', src, Lang:t('info.off_duty'))
 else
  Player.Functions.SetJobDuty(true)
  TriggerClientEvent('ra93Core:Notify', src, Lang:t('info.on_duty'))
 end
 TriggerClientEvent('ra93Core:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- BaseEvents

-- Vehicles

RegisterServerEvent('baseevents:enteringVehicle', function(veh,seat,modelName)
 local src = source
 local data = {
  vehicle = veh,
  seat = seat,
  name = modelName,
  event = 'Entering'
 }
 TriggerClientEvent('ra93Core:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh,seat,modelName)
 local src = source
 local data = {
  vehicle = veh,
  seat = seat,
  name = modelName,
  event = 'Entered'
 }
 TriggerClientEvent('ra93Core:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
 local src = source
 TriggerClientEvent('ra93Core:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh,seat,modelName)
 local src = source
 local data = {
  vehicle = veh,
  seat = seat,
  name = modelName,
  event = 'Left'
 }
 TriggerClientEvent('ra93Core:Client:VehicleInfo', src, data)
end)

-- Non-Chat Command Calling (ex: qb-adminmenu)

RegisterNetEvent('ra93Core:CallCommand', function(command, args)
 local src = source
 if not ra93Core.Commands.List[command] then return end
 local Player = ra93Core.functions.GetPlayer(src)
 if not Player then return end
 local hasPerm = ra93Core.functions.HasPermission(src, "command."..ra93Core.Commands.List[command].name)
 if hasPerm then
  if ra93Core.Commands.List[command].argsrequired and #ra93Core.Commands.List[command].arguments ~= 0 and not args[#ra93Core.Commands.List[command].arguments] then
   TriggerClientEvent('ra93Core:Notify', src, Lang:t('error.missing_args2'), 'error')
  else
   ra93Core.Commands.List[command].callback(src, args)
  end
 else
  TriggerClientEvent('ra93Core:Notify', src, Lang:t('error.no_access'), 'error')
 end
end)

-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native

ra93Core.functions.CreateCallback('ra93Core:Server:SpawnVehicle', function(source, cb, model, coords, warp)
 local ped = GetPlayerPed(source)
 model = type(model) == 'string' and joaat(model) or model
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

-- Use this for long distance vehicle spawning
-- vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native

ra93Core.functions.CreateCallback('ra93Core:Server:CreateVehicle', function(source, cb, model, coords, warp)
 model = type(model) == 'string' and GetHashKey(model) or model
 if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
 local CreateAutomobile = GetHashKey("CREATE_AUTOMOBILE")
 local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, coords.w, true, true)
 while not DoesEntityExist(veh) do Wait(0) end
 if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
 cb(NetworkGetNetworkIdFromEntity(veh))
end)

-- Security Events

RegisterServerEvent("rcCore:server:secureEvents", function(eventData)
    if not GetInvokingResource() then return false end
    TriggerClientEvent(eventData.destEvent,eventData)
end)