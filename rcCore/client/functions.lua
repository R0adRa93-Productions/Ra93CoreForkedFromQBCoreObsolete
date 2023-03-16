RegisterNUICallback("getNotifyConfig", function(_, cb)
 cb(Ra93Core.config.notify)
end)

Ra93Core.client.debug = function(resource, obj, depth) TriggerServerEvent("Ra93Core:debugSomething", obj, depth, resource) end

Ra93Core.functions = {
 ["attachProp"] = function(ped, model, boneId, x, y, z, xR, yR, zR, vertex)
  local modelHash = type(model) == "string" and GetHashKey(model) or model
  local bone = GetPedBoneIndex(ped, boneId)
  Ra93Core.functions.loadModel(modelHash)
  local prop = CreateObject(modelHash, 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(prop, ped, bone, x, y, z, xR, yR, zR, 1, 1, 0, 1, not vertex and 2 or 0, 1)
  SetModelAsNoLongerNeeded(modelHash)
  return prop
 end,
 ["createClientCallback"] = function(name, cb)
  Ra93Core.clientCallBacks[name] = cb
 end,
 ["deleteVehicle"] = function(vehicle)
  SetEntityAsMissionEntity(vehicle, true, true)
  DeleteVehicle(vehicle)
 end,
 ["drawText"] = function(x, y, width, height, scale, r, g, b, a, text)
  SetTextFont(4)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(2, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width / 2, y - height / 2 + 0.005)
 end,
 ["drawText3D"] = function(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x, y, z, 0)
  DrawText(0.0, 0.0)
  local factor = (string.len(text)) / 370
  DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
  ClearDrawOrigin()
 end,
 ["getBoneDistance"] = function(entity, boneType, boneIndex)
  local bone = GetEntityBoneIndexByName(entity, boneIndex)
  if boneType == 1 then bone = GetPedBoneIndex(entity, boneIndex) end
  local boneCoords = GetWorldPositionOfEntityBone(entity, bone)
  local playerCoords = GetEntityCoords(PlayerPedId())
  return #(boneCoords - playerCoords)
 end,
 ["getCardinalDirection"] = function(entity)
  entity = DoesEntityExist(entity) and entity or PlayerPedId()
  if not DoesEntityExist(entity) then return "Cardinal Direction Error" end
  local heading = GetEntityHeading(entity)
  if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then return "North"
  elseif (heading >= 45 and heading < 135) then return "East"
  elseif (heading >= 135 and heading < 225) then return "South"
  else return "West" end
 end,
 ["getClosestBone"] = function(entity, list)
  local playerCoords, bone, coords, distance = GetEntityCoords(PlayerPedId())
  for _, element in pairs(list) do
   local boneCoords = GetWorldPositionOfEntityBone(entity, element.id or element)
   local boneDistance = #(playerCoords - boneCoords)
   if not coords or  distance > boneDistance then bone, coords, distance = element, boneCoords, boneDistance end
  end
  if not bone then
   bone = {id = GetEntityBoneIndexByName(entity, "bodyshell"), type = "remains", name = "bodyshell"}
   coords = GetWorldPositionOfEntityBone(entity, bone.id)
   distance = #(coords - playerCoords)
  end
  return bone, coords, distance
 end,
 ["getClosestObject"] = function(coords)
  local ped = PlayerPedId()
  local objects = GetGamePool("CObject")
  local closestDistance = -1
  local closestObject = -1
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(ped) end
  for i = 1, #objects, 1 do
   local objectCoords = GetEntityCoords(objects[i])
   local distance = #(objectCoords - coords)
   if closestDistance == -1 or closestDistance > distance then
    closestObject = objects[i]
    closestDistance = distance
   end
  end
  return closestObject, closestDistance
 end,
 ["getClosestPed"] = function(coords, ignoreList)
  local ped = PlayerPedId()
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(ped) end
  ignoreList = ignoreList or {}
  local peds = Ra93Core.functions.getPeds(ignoreList)
  local closestDistance = -1
  local closestPed = -1
  for i = 1, #peds, 1 do
   local pedCoords = GetEntityCoords(peds[i])
   local distance = #(pedCoords - coords)
   if closestDistance == -1 or closestDistance > distance then
    closestPed = peds[i]
    closestDistance = distance
   end
  end
  return closestPed, closestDistance
 end,
 ["getClosestPlayer"] = function(coords)
  local ped = PlayerPedId()
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(ped) end
  local closestPlayers = Ra93Core.functions.getPlayersFromCoords(coords)
  local closestDistance = -1
  local closestPlayer = -1
  for i = 1, #closestPlayers, 1 do
   if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
    local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
    local distance = #(pos - coords)
    if closestDistance == -1 or closestDistance > distance then
     closestPlayer = closestPlayers[i]
     closestDistance = distance
    end
   end
  end
  return closestPlayer, closestDistance
 end,
 ["getCurrentTime"] = function()
  local obj = {}
  obj.min = GetClockMinutes()
  obj.hour = GetClockHours()
  obj.ampm = "AM"
  if obj.hour >= 13 then
   obj.ampm = "PM"
   obj.hour12 = obj.hour - 12
  end
  if obj.min <= 9 then obj.min = string.format("0%s",obj.min) end
   obj.clock12 = string.format("%s:%s %s",obj.hour12,obj.min,obj.ampm)
   obj.clock24 = string.format("%s:%s",obj.hour,obj.min)
  return obj
 end,
 ["getClosestVehicle"] = function(coords)
  local ped = PlayerPedId()
  local vehicles = GetGamePool("CVehicle")
  local closestDistance = -1
  local closestVehicle = -1
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(ped) end
  for i = 1, #vehicles, 1 do
   local vehicleCoords = GetEntityCoords(vehicles[i])
   local distance = #(vehicleCoords - coords)
   if closestDistance == -1 or closestDistance > distance then
    closestVehicle = vehicles[i]
    closestDistance = distance
   end
  end
  return closestVehicle, closestDistance
 end,
 ["getCoords"] = function(entity)
  local coords = GetEntityCoords(entity)
  return vector4(coords.x, coords.y, coords.z, GetEntityHeading(entity))
 end,
 ["getGroundZCoord"] = function(coords)
  if not coords then return end
  local retval, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
  if retval then return vector3(coords.x, coords.y, groundZ)
  else
   print("Could not find Ground Z Coordinates given 3D Coordinates")
   print(coords)
   return coords
  end
 end,
 ["getPeds"] = function(ignoreList)
  local pedPool = GetGamePool("CPed")
  local peds = {}
  ignoreList = ignoreList or {}
  for i = 1, #pedPool, 1 do
   local found = false
   for j = 1, #ignoreList, 1 do
    if ignoreList[j] == pedPool[i] then found = true end
   end
   if not found then peds[#peds + 1] = pedPool[i] end
  end
  return peds
 end,
 ["getPlate"] = function(vehicle)
  if vehicle == 0 then return end
  return Ra93Core.shared.trim(GetVehicleNumberPlateText(vehicle))
 end,
 ["getplayerData"] = function(cb)
  if not cb then return Ra93Core.playerData end
  cb(Ra93Core.playerData)
 end,
 ["getPlayersFromCoords"] = function(coords, distance)
  local players = GetActivePlayers()
  local ped = PlayerPedId()
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(ped) end
  distance = distance or 5
  local closePlayers = {}
  for _, player in pairs(players) do
   local target = GetPlayerPed(player)
   local targetCoords = GetEntityCoords(target)
   local targetdistance = #(targetCoords - coords)
   if targetdistance <= distance then closePlayers[#closePlayers + 1] = player end
  end
  return closePlayers
 end,
 ["getStreetNametAtCoords"] = function(coords)
  local streetname1, streetname2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
  return {
   main = GetStreetNameFromHashKey(streetname1),
   cross = GetStreetNameFromHashKey(streetname2)
  }
 end,
 ["getVehicleLabel"] = function(vehicle)
  if vehicle == nil or vehicle == 0 then return end
  return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
 end,
 ["getVehicleProperties"] = function(vehicle)
  if DoesEntityExist(vehicle) then
   local extras = {}
   local modLivery = GetVehicleMod(vehicle, 48)
   local doorStatus = {}
   local tireBurstState = {}
   local tireBurstCompletely = {}
   local tireHealth = {}
   local windowStatus = {}
   local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
   local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
   if GetIsVehiclePrimaryColourCustom(vehicle) then
    local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
    colorPrimary = {r, g, b}
   end
   if GetIsVehicleSecondaryColourCustom(vehicle) then
    local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
    colorSecondary = {r, g, b}
   end
   for extraId = 0, 12 do
    if DoesExtraExist(vehicle, extraId) then
     local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
     extras[tostring(extraId)] = state
    end
   end
   if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= 0 then modLivery = GetVehicleLivery(vehicle) end
   for i = 0, 7 do
    if i <= 3 then tireHealth[i] = GetVehicleWheelHealth(vehicle, i) end
    if i <= 5 then
     doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1
     tireBurstState[i] = IsVehicleTyreBurst(vehicle, i, false)
     tireBurstCompletely[i] = IsVehicleTyreBurst(vehicle, i, true)
    end
    windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1
   end
   return {
    bodyHealth = Ra93Core.shared.round(GetVehicleBodyHealth(vehicle), 0.1),
    color1 = colorPrimary,
    color2 = colorSecondary,
    dashboardColor = GetVehicleDashboardColour(vehicle),
    dirtLevel = Ra93Core.shared.round(GetVehicleDirtLevel(vehicle), 0.1),
    doorStatus = doorStatus,
    engineHealth = Ra93Core.shared.round(GetVehicleEngineHealth(vehicle), 0.1),
    extras = extras,
    fuelLevel = Ra93Core.shared.round(GetVehicleFuelLevel(vehicle), 0.1),
    headlightColor = GetVehicleHeadlightsColour(vehicle),
    interiorColor = GetVehicleInteriorColour(vehicle),
    liveryRoof = GetVehicleRoofLivery(vehicle),
    modAPlate = GetVehicleMod(vehicle, 35),
    modAerials = GetVehicleMod(vehicle, 43),
    modAirFilter = GetVehicleMod(vehicle, 40),
    modArchCover = GetVehicleMod(vehicle, 42),
    modArmor = GetVehicleMod(vehicle, 16),
    modBackWheels = GetVehicleMod(vehicle, 24),
    modBrakes = GetVehicleMod(vehicle, 12),
    modCustomTiresF = GetVehicleModVariation(vehicle, 23),
    modCustomTiresR = GetVehicleModVariation(vehicle, 24),
    modDashboard = GetVehicleMod(vehicle, 29),
    modDial = GetVehicleMod(vehicle, 30),
    modDoorSpeaker = GetVehicleMod(vehicle, 31),
    modEngine = GetVehicleMod(vehicle, 11),
    modEngineBlock = GetVehicleMod(vehicle, 39),
    modExhaust = GetVehicleMod(vehicle, 4),
    modFender = GetVehicleMod(vehicle, 8),
    modFrame = GetVehicleMod(vehicle, 5),
    modFrontBumper = GetVehicleMod(vehicle, 1),
    modFrontWheels = GetVehicleMod(vehicle, 23),
    modGrille = GetVehicleMod(vehicle, 6),
    modHood = GetVehicleMod(vehicle, 7),
    modHorns = GetVehicleMod(vehicle, 14),
    modHydrolic = GetVehicleMod(vehicle, 38),
    modKit17 = GetVehicleMod(vehicle, 17),
    modKit19 = GetVehicleMod(vehicle, 19),
    modKit21 = GetVehicleMod(vehicle, 21),
    modKit47 = GetVehicleMod(vehicle, 47),
    modKit49 = GetVehicleMod(vehicle, 49),
    modLivery = modLivery,
    modOrnaments = GetVehicleMod(vehicle, 28),
    modPlateHolder = GetVehicleMod(vehicle, 25),
    modRearBumper = GetVehicleMod(vehicle, 2),
    modRightFender = GetVehicleMod(vehicle, 9),
    modRoof = GetVehicleMod(vehicle, 10),
    modSeats = GetVehicleMod(vehicle, 32),
    modShifterLeavers = GetVehicleMod(vehicle, 34),
    modSideSkirt = GetVehicleMod(vehicle, 3),
    modSmokeEnabled = IsToggleModOn(vehicle, 20),
    modSpeakers = GetVehicleMod(vehicle, 36),
    modSpoilers = GetVehicleMod(vehicle, 0),
    modSteeringWheel = GetVehicleMod(vehicle, 33),
    modStruts = GetVehicleMod(vehicle, 41),
    modSuspension = GetVehicleMod(vehicle, 15),
    modTank = GetVehicleMod(vehicle, 45),
    modTransmission = GetVehicleMod(vehicle, 13),
    modTrimA = GetVehicleMod(vehicle, 27),
    modTrimB = GetVehicleMod(vehicle, 44),
    modTrunk = GetVehicleMod(vehicle, 37),
    modTurbo = IsToggleModOn(vehicle, 18),
    modVanityPlate = GetVehicleMod(vehicle, 26),
    modWindows = GetVehicleMod(vehicle, 46),
    modXenon = IsToggleModOn(vehicle, 22),
    model = GetEntityModel(vehicle),
    neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
    neonEnabled = {
     IsVehicleNeonLightEnabled(vehicle, 0),
     IsVehicleNeonLightEnabled(vehicle, 1),
     IsVehicleNeonLightEnabled(vehicle, 2),
     IsVehicleNeonLightEnabled(vehicle, 3)
    },
    oilLevel = Ra93Core.shared.round(GetVehicleOilLevel(vehicle), 0.1),
    pearlescentColor = pearlescentColor,
    plate = Ra93Core.functions.getPlate(vehicle),
    plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
    tankHealth = Ra93Core.shared.round(GetVehiclePetrolTankHealth(vehicle), 0.1),
    tireBurstCompletely = tireBurstCompletely,
    tireBurstState = tireBurstState,
    tireHealth = tireHealth,
    tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
    wheelColor = wheelColor,
    wheelSize = GetVehicleWheelSize(vehicle),
    wheelWidth = GetVehicleWheelWidth(vehicle),
    wheels = GetVehicleWheelType(vehicle),
    windowStatus = windowStatus,
    windowTint = GetVehicleWindowTint(vehicle),
    xenonColor = GetVehicleXenonLightsColour(vehicle),
   }
  else return end
 end,
 ["getZoneAtCoords"] = function(coords)
  return GetLabelText(GetNameOfZone(coords))
 end,
 ["isWearingGloves"] = function()
  local ped = PlayerPedId()
  local armIndex = GetPedDrawableVariation(ped, 3)
  local model = GetEntityModel(ped)
  if model == `mp_m_freemode_01` and Ra93Core.shared.maleNoGloves[armIndex] then return false
  elseif model ~= `mp_m_freemode_01` and Ra93Core.shared.femaleNoGloves[armIndex] then return false end
  return true
 end,
 ["loadAnimSet"] = function(animSet)
  if HasAnimSetLoaded(animSet) then return end
  RequestAnimSet(animSet)
  while not HasAnimSetLoaded(animSet) do Wait(0) end
 end,
 ["loadModel"] = function(model)
  if HasModelLoaded(model) then return end
  RequestModel(model)
  while not HasModelLoaded(model) do Wait(0) end
 end,
 ["loadParticleDictionary"] = function(dictionary)
  if HasNamedPtfxAssetLoaded(dictionary) then return end
  RequestNamedPtfxAsset(dictionary)
  while not HasNamedPtfxAssetLoaded(dictionary) do Wait(0) end
 end,
 ["messageHandler"] = function(error)
  TriggerServerEvent("Ra93Core:server:messageHandler", error)
 end,
 ["notify"] = function(text, textType, length)
  if type(text) == "table" then
   local tText = text.text or "Placeholder"
   local caption = text.caption or "Placeholder"
   textType = textType or "primary"
   length = length or 5000
   SendNUIMessage({
    action = "notify",
    type = textType,
    length = length,
    text = tText,
    caption = caption
   })
  else
   textType = textType or "primary"
   length = length or 5000
   SendNUIMessage({
    action = "notify",
    type = textType,
    length = length,
    text = text
   })
  end
 end,
 ["playAnim"] = function(animDict, animName, upperbodyOnly, duration)
  local flags = upperbodyOnly and 16 or 0
  local runTime = duration or -1
  Ra93Core.functions.requestAnimDict(animDict)
  TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 1.0, runTime, flags, 0.0, false, false, true)
  RemoveAnimDict(animDict)
 end,
 ["prepForSQL"] = function(source,data,pattern)
  data = tostring(data)
  local src = source
  local player = Ra93Core.functions.getPlayer(src)
  local result = string.match(data, pattern)
  if not result or string.len(result) ~= string.len(data)  then
   TriggerEvent("rcLog:server:CreateLog", "anticheat", "SQL Exploit Attempted", "red", ("%s attempted to exploit SQL!"):format(player.playerData.license))
   return false
  end
  return true
 end,
 ["progressbar"] = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
  if GetResourceState("progressbar") ~= "started" then error("progressbar needs to be started in order for Ra93Core.functions.progressbar to work") end
  exports["progressbar"]:Progress({
   name = name:lower(),
   duration = duration,
   label = label,
   useWhileDead = useWhileDead,
   canCancel = canCancel,
   controlDisables = disableControls,
   animation = animation,
   prop = prop,
   propTwo = propTwo,
  }, function(cancelled)
   if not cancelled then
    if onFinish then onFinish() end
   else
    if onCancel then onCancel() end
   end
  end)
 end,
 ["requestAnimDict"] = function(animDict)
  if HasAnimDictLoaded(animDict) then return end
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do Wait(0) end
 end,
 ["setVehicleProperties"] = function(vehicle, props)
  local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
  local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
  local propNatives = {
   ["bodyHealth"] = SetVehicleBodyHealth(vehicle, v + 0.0),
   ["color1"] = function(prop)
    if type(prop) == "number" then SetVehicleColours(vehicle, prop, colorSecondary)
    else SetVehicleCustomPrimaryColour(vehicle, prop[1], prop[2], prop[3]) end
   end,
   ["color2"] = function(prop)
    if type(prop) == "number" then SetVehicleColours(vehicle, prop or colorPrimary, prop)
    else SetVehicleCustomSecondaryColour(vehicle, prop[1], prop[2], prop[3]) end
   end,
   ["dashboardColor"] = function(prop) VehicleDashboardColour(vehicle, prop) end,
   ["dirtLevel"] = function(prop) VehicleDirtLevel(vehicle, prop + 0.0) end,
   ["engineHealth"] = function(prop) VehicleEngineHealth(vehicle, prop + 0.0) end,
   ["fuelLevel"] = function(prop) VehicleFuelLevel(vehicle, prop + 0.0) end,
   ["headlightColor"] = function(prop) VehicleHeadlightsColour(vehicle, prop) end,
   ["interiorColor"] = function(prop) VehicleInteriorColour(vehicle, prop) end,
   ["liveryRoof"] = function(prop) VehicleRoofLivery(vehicle, prop) end,
   ["modAPlate"] = function(prop) VehicleMod(vehicle, 35, prop, false) end,
   ["modAerials"] = function(prop) VehicleMod(vehicle, 43, prop, false) end,
   ["modAirFilter"] = function(prop) VehicleMod(vehicle, 40, prop, false) end,
   ["modArchCover"] = function(prop) VehicleMod(vehicle, 42, prop, false) end,
   ["modArmor"] = function(prop) VehicleMod(vehicle, 16, prop, false) end,
   ["modBackWheels"] = function(prop) VehicleMod(vehicle, 24, prop, false) end,
   ["modBrakes"] = function(prop) VehicleMod(vehicle, 12, prop, false) end,
   ["modCustomTiresF"] = function(prop) VehicleMod(vehicle, 23, prop, false) end,
   ["modCustomTiresR"] = function(prop) VehicleMod(vehicle, 24, prop, false) end,
   ["modDashboard"] = function(prop) VehicleMod(vehicle, 29, prop, false) end,
   ["modDial"] = function(prop) VehicleMod(vehicle, 30, prop, false) end,
   ["modDoorSpeaker"] = function(prop) VehicleMod(vehicle, 31, prop, false) end,
   ["modEngine"] = function(prop) VehicleMod(vehicle, 11, prop, false) end,
   ["modEngineBlock"] = function(prop) VehicleMod(vehicle, 39, prop, false) end,
   ["modExhaust"] = function(prop) VehicleMod(vehicle, 4, prop, false) end,
   ["modFender"] = function(prop) VehicleMod(vehicle, 8, prop, false) end,
   ["modFrame"] = function(prop) VehicleMod(vehicle, 5, prop, false) end,
   ["modFrontBumper"] = function(prop) VehicleMod(vehicle, 1, prop, false) end,
   ["modFrontWheels"] = function(prop) VehicleMod(vehicle, 23, prop, false) end,
   ["modGrille"] = function(prop) VehicleMod(vehicle, 6, prop, false) end,
   ["modHood"] = function(prop) VehicleMod(vehicle, 7, prop, false) end,
   ["modHorns"] = function(prop) VehicleMod(vehicle, 14, prop, false) end,
   ["modHydrolic"] = function(prop) VehicleMod(vehicle, 38, prop, false) end,
   ["modKit17"] = function(prop) VehicleMod(vehicle, 17, prop, false) end,
   ["modKit19"] = function(prop) VehicleMod(vehicle, 19, prop, false) end,
   ["modKit21"] = function(prop) VehicleMod(vehicle, 21, prop, false) end,
   ["modKit47"] = function(prop) VehicleMod(vehicle, 47, prop, false) end,
   ["modKit49"] = function(prop) VehicleMod(vehicle, 49, prop, false) end,
   ["modOrnaments"] = function(prop) VehicleMod(vehicle, 28, prop, false) end,
   ["modPlateHolder"] = function(prop) VehicleMod(vehicle, 25, prop, false) end,
   ["modRearBumper"] = function(prop) VehicleMod(vehicle, 2, prop, false) end,
   ["modRightFender"] = function(prop) VehicleMod(vehicle, 9, prop, false) end,
   ["modRoof"] = function(prop) VehicleMod(vehicle, 10, prop, false) end,
   ["modSeats"] = function(prop) VehicleMod(vehicle, 32, prop, false) end,
   ["modShifterLeavers"] = function(prop) VehicleMod(vehicle, 34, prop, false) end,
   ["modSideSkirt"] = function(prop) VehicleMod(vehicle, 3, prop, false) end,
   ["modSmokeEnabled"]= function(prop) ToggleVehicleMod(vehicle, 20, prop) end,
   ["modSpeakers"] = function(prop) VehicleMod(vehicle, 36, prop, false) end,
   ["modSpoilers"] = function(prop) VehicleMod(vehicle, 0, prop, false) end,
   ["modSteeringWheel"] = function(prop) VehicleMod(vehicle, 33, prop, false) end,
   ["modStruts"] = function(prop) VehicleMod(vehicle, 41, prop, false) end,
   ["modSuspension"] = function(prop) VehicleMod(vehicle, 15, prop, false) end,
   ["modTank"] = function(prop) VehicleMod(vehicle, 45, prop, false) end,
   ["modTransmission"] = function(prop) VehicleMod(vehicle, 13, prop, false) end,
   ["modTrimA"] = function(prop) VehicleMod(vehicle, 27, prop, false) end,
   ["modTrimB"] = function(prop) VehicleMod(vehicle, 44, prop, false) end,
   ["modTrunk"] = function(prop) VehicleMod(vehicle, 37, prop, false) end,
   ["modTurbo"]= function(prop) ToggleVehicleMod(vehicle, 18, prop) end,
   ["modVanityPlate"] = function(prop) VehicleMod(vehicle, 26, prop, false) end,
   ["modWindows"] = function(prop) VehicleMod(vehicle, 46, prop, false) end,
   ["modXenon"]= function(prop) ToggleVehicleMod(vehicle, 22, prop) end,
   ["neonColor"] = function(prop) VehicleNeonLightsColour(vehicle, prop[1], prop[2], prop[3]) end,
   ["oilLevel"] = function(prop) VehicleOilLevel(vehicle, prop) end,
   ["pearlescentColor"] = function(prop) VehicleExtraColours(vehicle, prop, wheelColor) end,
   ["plate"] = function(prop) VehicleNumberPlateText(vehicle, prop) end,
   ["plateIndex"] = function(prop) VehicleNumberPlateTextIndex(vehicle, prop) end,
   ["tankHealth"] = function(prop) VehiclePetrolTankHealth(vehicle, prop) end,
   ["tyreSmokeColor"] = function(prop) VehicleTyreSmokeColor(vehicle, prop[1], prop[2], prop[3]) end,
   ["wheelColor"] = function(prop) VehicleExtraColours(vehicle, prop or pearlescentColor, prop) end,
   ["wheelSize"] = function(prop) VehicleWheelSize(vehicle, prop) end,
   ["wheelWidth"] = function(prop) VehicleWheelWidth(vehicle, prop) end,
   ["wheels"] = function(prop) VehicleWheelType(vehicle, prop) end,
   ["windowTint"] = function(prop) VehicleWindowTint(vehicle, prop) end,
   ["xenonColor"] = function(prop) VehicleXenonLightsColor(vehicle, prop) end,
  }
  if DoesEntityExist(vehicle) then
   setVehicleModKit(vehicle, 0)
   for k,v in pairs(props) do propNatives[k](v) end
  end
 end,
 ["spawnClear"] = function(coords, radius)
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(PlayerPedId()) end
  local vehicles = GetGamePool("CVehicle")
  local closeVeh = {}
  for i = 1, #vehicles, 1 do
   local vehicleCoords = GetEntityCoords(vehicles[i])
   local distance = #(vehicleCoords - coords)
   if distance <= radius then closeVeh[#closeVeh + 1] = vehicles[i] end
  end
  if #closeVeh > 0 then return false end
  return true
 end,
 ["spawnVehicle"] = function(model, cb, coords, isnetworked, teleportInto)
  local ped = PlayerPedId()
  model = type(model) == "string" and GetHashKey(model) or model
  if not IsModelInCdimage(model) then return end
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(ped) end
  isnetworked = isnetworked == nil or isnetworked
  Ra93Core.functions.loadModel(model)
  local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
  local netid = NetworkGetNetworkIdFromEntity(veh)
  SetVehicleHasBeenOwnedByPlayer(veh, true)
  SetNetworkIdCanMigrate(netid, true)
  SetVehicleNeedsToBeHotwired(veh, false)
  SetVehRadioStation(veh, "OFF")
  SetVehicleFuelLevel(veh, 100.0)
  SetModelAsNoLongerNeeded(model)
  if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end
  if cb then cb(veh) end
 end,
 ["triggerCallback"] = function(name, cb, ...)
  Ra93Core.serverCallbacks[name] = cb
  TriggerServerEvent("Ra93Core:server:triggerCallback", name, ...)
 end,
 ["triggerClientCallback"] = function(name, cb, ...)
  if not Ra93Core.clientCallBacks[name] then return end
  Ra93Core.clientCallBacks[name](cb, ...)
 end,
 ["startParticleAtCoord"] = function(dict, ptName, looped, coords, rot, scale, alpha, color, duration)
  if coords then coords = type(coords) == "table" and vec3(coords.x, coords.y, coords.z) or coords
  else coords = GetEntityCoords(PlayerPedId()) end
  Ra93Core.functions.loadParticleDictionary(dict)
  UseParticleFxAssetNextCall(dict)
  SetPtfxAssetNextCall(dict)
  local particleHandle
  if looped then
   particleHandle = StartParticleFxLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
   if color then SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false) end
   SetParticleFxLoopedAlpha(particleHandle, alpha or 10.0)
   if duration then
    Wait(duration)
    StopParticleFxLooped(particleHandle, 0)
   end
  else
   SetParticleFxNonLoopedAlpha(alpha or 10.0)
   if color then SetParticleFxNonLoopedColour(color.r, color.g, color.b) end
   StartParticleFxNonLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
  end
  return particleHandle
 end,
 ["startParticleOnEntity"] = function(dict, ptName, looped, entity, bone, offset, rot, scale, alpha, color, evolution, duration)
  Ra93Core.functions.loadParticleDictionary(dict)
  UseParticleFxAssetNextCall(dict)
  local particleHandle, boneID
  if bone and GetEntityType(entity) == 1 then boneID = GetPedBoneIndex(entity, bone)
  elseif bone then boneID = GetEntityBoneIndexByName(entity, bone) end
  if looped then
   if bone then particleHandle = StartParticleFxLoopedOnEntityBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
   else particleHandle = StartParticleFxLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale) end
   if evolution then SetParticleFxLoopedEvolution(particleHandle, evolution.name, evolution.amount, false) end
   if color then SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false) end
   SetParticleFxLoopedAlpha(particleHandle, alpha)
   if duration then
    Wait(duration)
    StopParticleFxLooped(particleHandle, 0)
   end
  else
   SetParticleFxNonLoopedAlpha(alpha or 10.0)
   if color then SetParticleFxNonLoopedColour(color.r, color.g, color.b) end
   if bone then StartParticleFxNonLoopedOnPedBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
   else StartParticleFxNonLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale) end
  end
  return particleHandle
 end
}