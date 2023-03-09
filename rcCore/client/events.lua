RegisterNetEvent('Ra93Core:client:onPlayerLoaded', function()
 ShutdownLoadingScreenNui()
 Localplayer.state:set('isLoggedIn', true, false)
 if not Config.server.pvp then return end
 SetCanAttackFriendly(PlayerPedId(), true, false)
 NetworkSetFriendlyFireOption(true)
end)

RegisterNetEvent('Ra93Core:client:onPlayerUnload', function()
 Localplayer.state:set('isLoggedIn', false, false)
end)

RegisterNetEvent('Ra93Core:client:pvpHasToggled', function(pvp_state)
 SetCanAttackFriendly(PlayerPedId(), pvp_state, false)
 NetworkSetFriendlyFireOption(pvp_state)
end)

RegisterNetEvent('Ra93Core:command:teleportToPlayer', function(coords)
 local ped = PlayerPedId()
 SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('Ra93Core:command:teleportToCoords', function(x, y, z, h)
 local ped = PlayerPedId()
 SetPedCoordsKeepVehicle(ped, x, y, z)
 SetEntityHeading(ped, h or GetEntityHeading(ped))
end)

RegisterNetEvent('Ra93Core:command:goToMarker', function()
 local PlayerPedId = PlayerPedId
 local GetEntityCoords = GetEntityCoords
 local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
 local blipMarker <const> = GetFirstBlipInfoId(8)
 if not DoesBlipExist(blipMarker) then
  Ra93Core.functions.notify(Lang:t("error.no_waypoint"), "error", 5000)
  return 'marker'
 end
 -- Fade screen to hide how clients get teleported.
 DoScreenFadeOut(650)
 while not IsScreenFadedOut() do Wait(0) end
 local ped, coords <const> = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
 local vehicle = GetVehiclePedIsIn(ped, false)
 local oldCoords <const> = GetEntityCoords(ped)
 -- Unpack coords instead of having to unpack them while iterating.
 -- 825.0 seems to be the max a player can reach while 0.0 being the lowest.
 local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
 local found = false
 if vehicle > 0 then FreezeEntityPosition(vehicle, true)
 else FreezeEntityPosition(ped, true) end
 for i = Z_START, 0, -25.0 do
  local z = i
  if (i % 2) ~= 0 then z = Z_START - i end
  NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
  local curTime = GetGameTimer()
  while IsNetworkLoadingScene() do
   if GetGameTimer() - curTime > 1000 then break end
   Wait(0)
  end
  NewLoadSceneStop()
  SetPedCoordsKeepVehicle(ped, x, y, z)
  while not HasCollisionLoadedAroundEntity(ped) do
   RequestCollisionAtCoord(x, y, z)
   if GetGameTimer() - curTime > 1000 then break end
   Wait(0)
  end
  -- Get ground coord. As mentioned in the natives, this only works if the client is in render distance.
  found, groundZ = GetGroundZFor_3dCoord(x, y, z, false);
  if found then
   Wait(0)
   SetPedCoordsKeepVehicle(ped, x, y, groundZ)
   break
  end
  Wait(0)
 end
 -- Remove black screen once the loop has ended.
 DoScreenFadeIn(650)
 if vehicle > 0 then FreezeEntityPosition(vehicle, false)
 else FreezeEntityPosition(ped, false) end
 if not found then
  SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
  Ra93Core.functions.notify(Lang:t("error.tp_error"), "error", 5000)
 end
 -- If Z coord was found, set coords in found coords.
 SetPedCoordsKeepVehicle(ped, x, y, groundZ)
 Ra93Core.functions.notify(Lang:t("success.teleported_waypoint"), "success", 5000)
end)

RegisterNetEvent('Ra93Core:command:spawnVehicle', function(vehName)
 local ped = PlayerPedId()
 local hash = GetHashKey(vehName)
 local veh = GetVehiclePedIsUsing(ped)
 if not IsModelInCdimage(hash) then return end
 RequestModel(hash)
 while not HasModelLoaded(hash) do Wait(0) end
 if IsPedInAnyVehicle(ped) then DeleteVehicle(veh) end
 local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
 TaskWarpPedIntoVehicle(ped, vehicle, -1)
 SetVehicleFuelLevel(vehicle, 100.0)
 SetVehicleDirtLevel(vehicle, 0.0)
 SetModelAsNoLongerNeeded(hash)
 TriggerEvent("vehiclekeys:client:setOwner", Ra93Core.functions.getPlate(vehicle))
end)

RegisterNetEvent('Ra93Core:command:deleteVehicle', function()
 local ped = PlayerPedId()
 local veh = GetVehiclePedIsUsing(ped)
 if veh ~= 0 then
  SetEntityAsMissionEntity(veh, true, true)
  DeleteVehicle(veh)
 else
  local pcoords = GetEntityCoords(ped)
  local vehicles = GetGamePool('CVehicle')
  for _, v in pairs(vehicles) do
   if #(pcoords - GetEntityCoords(v)) <= 5.0 then
    SetEntityAsMissionEntity(v, true, true)
    DeleteVehicle(v)
   end
  end
 end
end)

RegisterNetEvent('Ra93Core:client:vehicleInfo', function(info)
 local plate = Ra93Core.functions.getPlate(info.vehicle)
 local hasKeys = true
 if GetResourceState('rcSmallResources') == 'started' then hasKeys = exports['rcSmallResources']:HasKeys() end
 local data = {
  vehicle = info.vehicle,
  seat = info.seat,
  name = info.modelName,
  plate = plate,
  driver = GetPedInVehicleSeat(info.vehicle, -1),
  inseat = GetPedInVehicleSeat(info.vehicle, info.seat),
  haskeys = hasKeys
 }
 TriggerEvent(string.format("Ra93Core:client:%sVehicle",info.event), data)
end)

RegisterNetEvent('Ra93Core:player:setPlayerData', function(val)
 Ra93Core.playerData = val
end)

RegisterNetEvent('Ra93Core:player:updatePlayerData', function()
 TriggerServerEvent('Ra93Core:updatePlayer')
end)

RegisterNetEvent('Ra93Core:notify', function(text, type, length)
 Ra93Core.functions.notify(text, type, length)
end)

RegisterNetEvent('Ra93Core:client:triggerClientCallback', function(name, ...)
 Ra93Core.functions.triggerClientCallback(name, function(...)
  TriggerServerEvent('Ra93Core:server:triggerClientCallback', name, ...)
 end, ...)
end)

RegisterNetEvent('Ra93Core:client:triggerCallback', function(name, ...)
 if Ra93Core.serverCallbacks[name] then
  Ra93Core.serverCallbacks[name](...)
  Ra93Core.serverCallbacks[name] = nil
 end
end)

RegisterNetEvent('Ra93Core:command:showMe3D', function(senderId, msg)
 local sender = GetPlayerFromServerId(senderId)
 CreateThread(function()
  local displayTime = 5000 + GetGameTimer()
  while displayTime > GetGameTimer() do
   local targetPed = GetPlayerPed(sender)
   local coords = GetEntityCoords(targetPed)
   local onScreen, worldX, worldY = World3dToScreen2d(coords.x, coords.y, coords.z)
   local camCoords = GetGameplayCamCoord()
   local scale = 200 / (GetGameplayCamFov() * #(camCoords - coords))
   if onScreen then
    SetTextScale(1.0, 0.5 * scale)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextProportional(1)
    SetTextOutline()
    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayText(worldX, worldY)
   end
   Wait(0)
  end
 end)
end)

RegisterNetEvent('Ra93Core:client:onSharedUpdate', function(tableName, key, value)
 Ra93Core.shared[tableName][key] = value
 TriggerEvent('Ra93Core:client:updateObject')
end)

RegisterNetEvent('Ra93Core:client:onSharedUpdateMultiple', function(tableName, values)
 for key, value in pairs(values) do Ra93Core.shared[tableName][key] = value end
 TriggerEvent('Ra93Core:client:updateObject')
end)