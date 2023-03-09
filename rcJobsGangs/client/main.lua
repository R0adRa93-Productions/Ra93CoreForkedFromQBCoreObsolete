-- Variables
--- populates QBCore table
Ra93Core = exports['qb-core']:GetCoreObject()
--- names variables and tables to be used throughout the script
local player,playerJob,playerGang,playerHistory,playerJsGs,jobGangType,DutyBlips,pedsSpawned,locationsSet,vehExtras
--- list of vehicles assigned to the player
local vehiclesAssigned = {}
--- list of peds that are spawned for an active job
local pedList = {}
--- list of public duty blips
local publicBlips = {}
--- player's duty status
local onDuty = false
--- list of job related map blips
local blipList = {}
--- list of location polys
local polyLocList = {}
--- comboZone for location polys
local locCombo = {}
--- list of Jobs key = job name | value = job label
local jobsList = {}
--- list of Gangs key = gang name | value = gang label
local gangsList = {}
-- Functions
--- switches between job or gang
local selectJobGang = function()
 local sysconf = {
  ["showGangsHistory"] = Config.showGangsHistory
 }
 local output = {
  ["Jobs"] = {
   ["conf"] = Config[jobGangType][playerJob.name],
   ["sysconf"] = sysconf,
   ["jg"] = playerJob,
   ["pd"] = {
 ["type"] = "job",
 ["types"] = "jobs",
 ["jobGangType"] = "Jobs",
 ["history"] = "jobhistory",
 ["current"] = "currentJob",
 ["currentName"] = "currentJobName",
 ["label"] = "employees",
 ["labelSingular"] = "employee",
 ["pastLabel"] = "pastEmployees",
 ["prev"] = "prevJob",
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
   ["sysconf"] = sysconf,
   ["jg"] = playerGang,
   ["pd"] =  {
 ["type"] = "gang",
 ["types"] = "gangs",
 ["jobGangType"] = "Gangs",
 ["history"] = "ganghistory",
 ["current"] = "currentGang",
 ["currentName"] = "currentGangName",
 ["label"] = "members",
 ["labelSingular"] = "member",
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
--- sets the player's player and playerJob tables
local setCurrentPlayerVars = function()
 player = nil
 playerJob = nil
 playerGang = nil
 player = Ra93Core.functions.getPlayerData()
 playerJob = player.job
 playerGang = player.gang
 playerHistory = {
  ["job"] = player.metadata.jobhistory,
  ["gang"] = player.metadata.ganghistory
 }
 playerJsGs = {
  ["jobs"] = player.metadata.jobs,
  ["gangs"] = player.metadata.gangs
 }
 return true
end
--- sets the jobsList
local buildJobsGangsList = function()
 for k,v in pairs(Config.Jobs) do
  jobsList[k] = v.label
 end
 for k,v in pairs(Config.Gangs) do
  gangsList[k] = v.label
 end
end
--- deletes spawned vehicles and refunds deposits
local deleteVehicleProcess = function(plate)
 local data = {}
 data.plate = plate
 data.vehicle = vehiclesAssigned[plate].vehicle
 data.netid = vehiclesAssigned[plate].netid
 data.veh = vehiclesAssigned[plate].veh
 TriggerServerEvent('qb-jobs:server:deleteVehicleProcess', data,jobGangType)
 DeleteVehicle(data.netid)
 vehiclesAssigned[data.plate] = nil
 Ra93Core.functions.notify(Lang:t("info.keysReturned"))
end
--- clears any spawned vehicles after logoff
local clearVehicles = function()
 if next(vehiclesAssigned) then
  for k in pairs(vehiclesAssigned) do
   deleteVehicleProcess(k)
  end
 end
end
--- receives the vehicle list from server and opens the menu
local receiveGaragedVehicles = function(data)
 jobGangType = data.jobGangType
 Ra93Core.functions.triggerCallback('qb-jobs:server:sendGaragedVehicles',function(result)
  if Config[jobGangType][playerJob.name].Vehicles.config.assignVehicles and next(vehiclesAssigned) then
   deleteVehicleProcess()
  end
  result.returnVehicle = vehiclesAssigned;
  result.uiColors = Config.Jobs[playerJob.name].uiColors
  SendNUIMessage({
   action = "garage",
   btnList = result
  })
  SetNuiFocus(true,true)
 end, data.id, jobGangType)
end
--- creates the button list for the boss menu
local processButtonList = function(res)
 setCurrentPlayerVars()
 local cdata = selectJobGang()
 local pd = cdata.pd
 local jg = cdata.jg
 local mgrBtnList = {
  ["header"] = cdata.conf.label .. Lang:t('headings.management'),
  ["sysconf"] = cdata.sysconf,
  ["jg"] = jg.name,
  ["jgName"] = cdata.conf.label,
  ["icons"] = cdata.conf.menu.icons,
  ["status"] = cdata.conf.management.status,
  ["awards"] = cdata.conf.management.awards,
  ["reprimands"] = cdata.conf.management.reprimands,
  ["jobsList"] = jobsList,
  ["gangsList"] = gangsList,
  ["pd"] = pd,
  ["text"] = cdata.conf.menu.text
 }
 if cdata.conf.uiColors then mgrBtnList.uiColors = cdata.conf.uiColors end
 for k, v in pairs(res) do
  mgrBtnList[k] = v
 end
 return mgrBtnList
end
--- receives data for the boss menu from the server and opens the boss menu
local receiveManagementData = function(data)
 local mgrBtnList
 jobGangType = data.jobGangType
 Ra93Core.functions.triggerCallback('qb-jobs:server:sendManagementData',function(res)
  mgrBtnList = processButtonList(res)
  SendNUIMessage({
   action = "management",
   btnList = mgrBtnList
  })
  SetNuiFocus(true,true)
 end, data.id, jobGangType)
end
--- Opens clothing menu
local openOutfits = function()
 exports['qb-clothing']:getOutfits(playerJob.grade.level, Config.Jobs[playerJob.name].Outfits)
end
--- Opens the motorworks aka qb-customs menu
local openMotorworks = function(res)
 local location = Config.Jobs[playerJob.name].MotorworksConfig
 local data = {
  ["spot"] = location.settings.label,
  ["coords"] = vector3(location.zones[res.id].coords.x, location.zones[res.id].coords.y, location.zones[res.id].coords.z),
  ["heading"] = location.zones[res.id].heading,
  ["drawtextui"]  = location.drawtextui.text
 }
 data.location = {}
 data.location[playerJob.name] = location
 data.pj = playerJob.name
 data.jobs = true
 local restrictions = exports["qb-customs"]:CheckRestrictions(playerJob.name)
 if restrictions then exports["qb-customs"]:processExports(data) end
end
--- checks out vehicle from the motorpool
local takeOutVehicle = function(result)
 local spawn = result.vehicle
 local garage = result.garage
 local selGar = result.selgar
 local grade = tonumber(playerJob.grade.level)
 local cdata = selectJobGang()
 local pd = cdata.pd
 if not cdata.conf.Vehicles.vehicles[spawn] then
  Ra93Core.functions.notify(Lang:t("denied.noVehicle"))
  return false
 end
 Ra93Core.functions.triggerCallback("qb-jobs:server:verifyMaxVehicles", function(vehCheck)
  if not vehCheck then return false end
  local vehicleExtras = function(veh,extras)
   local ex
   for i = 0,20 do
 if DoesExtraExist(veh,i) then
  ex = 1
  if extras[i] then ex = extras[i] end
  SetVehicleExtra(veh, i, ex)
 end
   end
  end
  local coords
  local data = {
   ["garage"] = garage,
   ["vehicle"] = spawn,
   ["selGar"] = selGar
  }
  local cbData = { ["selGar"] = selGar }
  if result.plate then cbData["plate"] = result.plate end
  for _,v in pairs(cdata.conf.Locations.garages[garage].spawnPoint) do
   if v.type == cdata.conf.Vehicles.vehicles[spawn].type and not IsAnyVehicleNearPoint(vector3(v.coords.x,v.coords.y,v.coords.z), 2.5) then
 coords = v.coords
 break
   end
  end
  Ra93Core.functions.triggerCallback("qb-jobs:server:vehiclePlateCheck",function(plate,vehicleProps)
   if not plate then return false end
   data.plate = plate
   if coords and data.plate then
 Ra93Core.functions.triggerCallback('QBCore:Server:SpawnVehicle', function(veh)
  data.veh = veh
  data.netid = NetToVeh(veh)
  SetVehicleEngineOn(data.netid, false, true)
  SetVehicleNumberPlateText(data.netid, data.plate)
  data.plate = Ra93Core.functions.getPlate(data.netid)
  SetEntityHeading(data.netid, coords.w)
  exports[Config.fuel]:SetFuel(data.netid, 100.0)
  SetVehicleFixed(data.netid)
  SetEntityAsMissionEntity(data.netid, true, true)
  SetVehicleDoorsLocked(data.netid, 2)
  grade = 1
  for _,v in pairs(cdata.conf.Vehicles.vehicles[spawn].settings) do
   for _,v1 in pairs(v.grades) do
 v1 = tonumber(v1)
 if v1 == grade then
  vehicleExtras(data.netid, v.extras) -- the qbcore native is broken! This Works!
  SetVehicleLivery(data.netid, v.livery)
 end
   end
  end
  if vehicleProps then Ra93Core.functions.setVehicleProperties(data.netid, vehicleProps) end
  TriggerServerEvent(Config.keys, data.plate)
  if cdata.conf.Items and (cdata.conf.Items.trunk or cdata.conf.Items.glovebox) then
   local tseData = {}
   tseData.vehicle = data.vehicle
   tseData.plate = data.plate
   TriggerServerEvent('qb-jobs:server:addVehItems',tseData,jobGangType)
  end
  vehiclesAssigned[data.plate] = {
   ["netid"] = data.netid,
   ["vehicle"] = data.vehicle,
   ["veh"] = data.veh,
   ["selGar"] = data.selGar
  }
  if not (data.selGar) then
   data.noRefund = true
   deleteVehicleProcess(data)
   Ra93Core.functions.notify(Lang:t("denied.noGarageSelected"))
   return
  end
  Ra93Core.functions.triggerCallback("qb-jobs:server:spawnVehicleProcessor", function(res)
   if not res then
 data.noRefund = true
 deleteVehicleProcess(data)
 return
   end
  end,data,jobGangType)
 end, data.vehicle, coords, false)
 TriggerServerEvent('qb-jobs:server:addVehicle',jobGangType)
   end
  end,cbData,jobGangType)
 end,jobGangType)
end
--- toggles duty status
local toggleDuty = function()
 onDuty = not onDuty
 TriggerServerEvent("QBCore:ToggleDuty")
 TriggerServerEvent("qb-jobs:server:updateBlips")
 if playerJob.type == "leo" then
  TriggerServerEvent("police:server:UpdateCurrentCops")
 elseif playerJob.type == "ambulance" then
  TriggerServerEvent("hospital:server:UpdateCurrentDoctors")
 end
 return true
end
--- generates multiJobMenuButtons
local getMultiJobMenuButtons = function()
 setCurrentPlayerVars()
 local buildOutput = function(conf,type,types,invalid)
  local status = "available"
  local output = {
   ["hired"] = {},
   ["available"] = {}
  }
  for k in pairs(conf) do
   if playerHistory[type][k] then status = playerHistory[type][k].status end
   output.available[k] = {
 ["name"] = k,
 ["label"] = conf[k].label,
 ["status"] = status
   }
   if player.metadata[types][k] then
 output.hired[k] = {
  ["name"] = k,
  ["label"] = conf[k].label,
  ["status"] = "hired",
  ["position"] = playerJsGs[types][k].grade.name,
  ["currencySymbol"] = Config.currencySymbol
 }
 if types == "jobs" then output.hired[k].pay = playerJsGs[types][k].payment end
 if player[type].name == k then output.hired[k].active = true end
 output.available[k] = nil
   end
   output.available[invalid] = nil
  end
  return output
 end
 local output = {
  ["jobs"] = {},
  ["gangs"] = {},
  ["icons"] = Config.menu.icons,
  ["header"] = Config.menu.headerMultiJob
 }
 output.jobs = buildOutput(Config.Jobs,"job","jobs","unemployed")
 output.gangs = buildOutput(Config.Gangs,"gang","gangs","none")
 return output
end
--- generates the multi job menu
local getMultiJobMenu = function()
 local output = getMultiJobMenuButtons()
 SendNUIMessage({
  action = "multiJob",
  btnList = output
 })
 SetNuiFocus(true,true)
end
--- handles all inventory related functions
local callInventory = function(invType,invHeader,itemsList)
 TriggerServerEvent("inventory:server:OpenInventory", invType, invHeader, itemsList)
 if invType == "stash" then TriggerEvent("inventory:client:SetCurrentStash", invHeader) end
end
local callStash = function()
 local invType = "stash"
 local invHeader = string.format("%s_%s_%s",playerJob.name,Lang:t('headings.stash'),player.citizenid)
 local itemsList = nil
 callInventory(invType,invHeader,itemsList)
end
local callTrash = function()
 local invType = "stash"
 local invHeader = string.format("%s_%s",playerJob.name,Lang:t('headings.trash'))
 local itemsList = Config.Jobs[playerJob.name].Items.trash.options
 callInventory(invType,invHeader,itemsList)
end
local callLocker = function()
 local invType, itemsList
 local invHeader = Lang:t('headings.locker')
 local drawer = exports['rcInput']:ShowInput({
  header = invHeader,
  submitText = "open",
  inputs = {
   {
 type = 'number',
 isRequired = true,
 name = 'slot',
 text = Lang:t('info.lockerSlot')
   }
  }
 })
 if drawer and drawer.slot then
  invType = "stash"
  invHeader = string.format("%s%s",invHeader,drawer.slot)
  itemsList = Config.Jobs[playerJob.name].Items.trash.options
 end
 callInventory(invType,invHeader,itemsList)
end
local callShop = function()
 local index = 1
 local grade = tonumber(playerJob.grade.level)
 local itemsList = {
  label = Config.Jobs[playerJob.name].Items.shop.shopLabel,
  slots = Config.Jobs[playerJob.name].Items.shop.slots,
  items = {}
 }
 local invType = "shop"
 local invHeader = string.format("%s_Shop",playerJob.name)
 for _, shopItem in pairs(Config.Jobs[playerJob.name].Items.items) do
  for _,v in pairs(shopItem.locations) do
   if v == "shop" then
 for _,v1 in pairs(shopItem.authGrades) do
  if v1 == grade then
   itemsList.items[index] = shopItem
   itemsList.items[index].slot = index
   index += 1
  end
 end
   end
  end
 end
 for k, _ in pairs(Config.Jobs[playerJob.name].Items.items) do
  if k < 6 then
   Config.Jobs[playerJob.name].Items.items[k].info.serie = tostring(Ra93Core.shared.RandomInt(2) .. Ra93Core.shared.RandomStr(3) .. Ra93Core.shared.RandomInt(1) .. Ra93Core.shared.RandomStr(2) .. Ra93Core.shared.RandomInt(3) .. Ra93Core.shared.RandomStr(4))
  end
 end
 callInventory(invType,invHeader,itemsList)
end
--- Listens for actions to interact with job peds
local Listen4Control = function(data)
 local runControl = function()
  if data.fn then data.fn(data)
  elseif data.event then TriggerEvent(data.event)
  elseif data.svrEvent then TriggerServerEvent(data.svrEvent) end
 end
 ControlListen = true
 CreateThread(function()
  while ControlListen do
   if IsControlJustReleased(0, 38) then
 setCurrentPlayerVars() -- refreshes player data so that a freshly departed player can't bypass the menus
 if not player.metadata.isdead and not player.metadata.inlaststand then
  if data.boss then
   if Config[data.jobGangType][data.jg].bosses[player.citizenid] then runControl() end
  else runControl() end
 end
   end
   if multiJobMenu then getMultiJobMenu() end
   Wait(1)
  end
 end)
end
--- spawns the peds for all the job locations
local spawnPeds = function()
 while not playerJob do setCurrentPlayerVars() Wait(5000) end
 local current
 local zones = {}
 local index = {
  zones = 0,
  comboZones = 0
 }
 local data = {
  locs = {},
  job = false,
  gang = false
 }
 local jgPairs = {
  ["Jobs"] = {
   ["type"] = "job",
   ["pjg"] = playerJob,
   ["duty"] = false -- false - npcs are not accessible while off duty | true - npcs are accssible while off duty
  },
  ["Gangs"] = {
   ["type"] = "gang",
   ["pjg"] = playerGang,
   ["duty"] = true -- setting to false will disable all npcs (you don't want this)
  },
 }
 local processPedLocs = function(res)
  -- if duty set to false will disable the feature in gangs
  -- set duty to res.duty for false to enable for gangs
  local pedSet = {
   ["duty"] = {
 ["fn"] = toggleDuty,
 ["label"] = Lang:t('info.onoff_duty'),
 ["duty"] = true, -- do not change this one
 ["jobGangType"] = res.jobGangType
   },
   ["management"] = {
 ["fn"] = receiveManagementData,
 ["label"] = Lang:t('info.enter_management'),
 ["duty"] = true, -- true = enabled while off duty | res.duty = disabled while off duty
 ["jobGangType"] = res.jobGangType,
 ["boss"] = true
   },
   ["garages"] = {
 ["fn"] = receiveGaragedVehicles,
 ["label"] = Lang:t('info.enter_garage'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["stashes"] = {
 ["fn"] = callStash,
 ["label"] = Lang:t('info.enter_stash'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["trash"] = {
 ["fn"] = callTrash,
 ["label"] = Lang:t('info.enter_trash'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["lockers"] = {
 ["fn"] = callLocker,
 ["label"] = Lang:t('info.enter_locker'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["shops"] = {
 ["fn"] = callShop,
 ["label"] = Lang:t('info.enter_shop'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["outfits"] = {
 ["fn"] = openOutfits,
 ["label"] = Lang:t('info.enter_outfit'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["motorworks"] = {
 ["fn"] = openMotorworks,
 ["label"] = Lang:t('info.enter_motorworks'),
 ["duty"] = res.duty,
 ["jobGangType"] = res.jobGangType
   },
   ["turf"] = {["label"] = Lang:t('info.enter_motorworks')}
  }
  for k,v in pairs(res.locs) do
   for k1,v1 in pairs(v) do
 if v1.ped then
  current = v1.ped
  current.id = k1
  current.jg = res.jg
  current.gang = res.gang
  current.job = res.job
  current.model = type(current.model) == 'string' and joaat(current.model) or current.model
  RequestModel(current.model)
  while not HasModelLoaded(current.model) do
   Wait(0)
  end
  local ped = CreatePed(0, current.model, current.coords.x, current.coords.y, current.coords.z -1,false, false)
  pedList[#pedList+1] = ped
  SetEntityHeading(ped,  current.coords.w)
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(ped, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  current.pedHandle = ped
  current.location = k
  current.event = pedSet.event
  current.dataPass = pedSet.dataPass
  current.clntSvr = pedSet.clntSvr
  pedsSpawned = true
  if pedSet then
   for k2,v2 in pairs(pedSet[k]) do
 current[k2] = v2
   end
   if Config.useTarget then
  exports['qb-target']:AddTargetEntity(ped, {
   options = {
 {
  type = "client",
  event = pedSet.event,
  label = pedSet.label,
  data = current
 }
   },
   distance = current.ped.drawDistance
  })
   else
 if current.zoneOptions then
  zones[#zones+1] = BoxZone:Create(
   current.coords.xyz,
   current.zoneOptions.length,
   current.zoneOptions.width,
   {
 name = "zone_qbjobs_" .. ped,
 heading = current.coords.w,
 minZ = current.coords.z - 1,
 maxZ = current.coords.z + 1,
 debugPoly = Config.debugPoly,
 data = current
   }
  )
  polyLocList[#polyLocList+1] = zones[index.zones]
 end
   end
  end
 end
   end
  end
 end
 for k, v in pairs(jgPairs) do
  if Config[k][v.pjg.name].Locations then
   data.locs = Config[k][v.pjg.name].Locations
   data[v.type] = true
   data.duty = v.duty
   data.jobGangType = k
   data.jg = v.pjg.name
  end
  processPedLocs(data)
 end
 if zones then
  locCombo = ComboZone:Create(zones, {name = "JobsCombo", debugPoly = Config.debugPoly})
  locCombo:onPlayerInOut(function(isPointInside,_,zone)
   if onDuty or zone and zone.data.duty then
 if isPointInside then
  ControlListen = true
  exports['qb-core']:DrawText(zone.data.label, 'left')
  Listen4Control(zone.data)
 else
  ControlListen = false
  exports['qb-core']:HideText()
 end
   end
  end)
 end
 return true
end
--- destroys all spawned job peds
local killPeds = function()
 if pedList then
  for _,v in pairs(pedList) do
   DeleteEntity(v)
  end
 end
 if polyLocList then
  for _,v in pairs(polyLocList) do
   v:destroy()
  end
 end
 pedsSpawned = false
end
--- configures all the map blip locations
local setBlip = function(conf)
 local blip = AddBlipForCoord(conf.coords.x, conf.coords.y, conf.coords.z)
 SetBlipSprite(blip, conf.blipNumber)
 SetBlipAsShortRange(blip, conf.blipNumber)
 SetBlipScale(blip, conf.blipScale)
 SetBlipColour(blip, conf.blipColor)
 SetBlipDisplay(blip, conf.blipDisplay)
 BeginTextCommandSetBlipName("STRING")
 AddTextComponentString(conf.blipName)
 EndTextCommandSetBlipName(blip)
 blipList[blip] = blip
end
--- deletes all map blip locations
local removeBlips = function()
 for k in pairs(blipList) do
  RemoveBlip(k)
 end
end
--- creates the duty blips on the minimap
local createDutyBlips = function(playerId, playerLabel, playerJob, playerLocation)
 if not Config.Jobs[playerJob].DutyBlips.enable then return end
 local ped = GetPlayerPed(playerId)
 local blip = GetBlipFromEntity(ped)
 if not DoesBlipExist(blip) and Config.Jobs[playerJob].DutyBlips then
  if NetworkIsPlayerActive(playerId) then
   blip = AddBlipForEntity(ped)
  else
   blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
  end
  SetBlipSprite(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteOnFoot)
  ShowHeadingIndicatorOnBlip(blip, true)
  if IsPedInAnyVehicle(ped) then
   SetBlipSprite(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteInVehicle)
   ShowHeadingIndicatorOnBlip(blip, false)
  end
  SetBlipRotation(blip, math.ceil(playerLocation.w))
  SetBlipScale(blip, Config.Jobs[playerJob].DutyBlips.blipScale)
  SetBlipColour(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteColor)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString(playerLabel)
  EndTextCommandSetBlipName(blip)
  if Config.Jobs[playerJob].DutyBlips.type == "service" then DutyBlips[#DutyBlips+1] = blip
  elseif Config.Jobs[playerJob].DutyBlips.type == "public" then publicBlips[#publicBlips+1] = blip end
 end
 if GetBlipFromEntity(PlayerPedId()) == blip then
  RemoveBlip(blip) -- removes player's blip from their map
 end
end
--- destroys the duty blips on the minimap
local removeDutyBlips = function()
 if playerJob then
  if DutyBlips then
   for _, v in pairs(DutyBlips) do
 RemoveBlip(v)
   end
  end
  DutyBlips = {}
 end
 if publicBlips then
  if publicBlips then
   for _, v in pairs(publicBlips) do
 RemoveBlip(v)
   end
  end
  publicBlips = {}
 end
end
--- creates minimap locations for current job
local setLocations = function()
 local loopLocations = function(data,pd)
  local buildBlips = function(tbl,type,k)
   for _,v1 in pairs(tbl) do
 if v1.ped then v1.coords = v1.ped.coords end
 if (k == pd.name or type == pd.type or v1.public) and v1.coords then setBlip(v1) end
   end
  end
  for k,v in pairs(data) do
   if v.Locations then
 for _,v2 in pairs(v.Locations) do
  buildBlips(v2,v.type,k)
 end
   end
  end
 end
 loopLocations(Config.Jobs,playerJob)
 loopLocations(Config.Gangs,playerGang)
 locationsSet = true
end
--- creates vehicle parking locations for qb-customs
local setCustomsLocations = function()
 local location = {}
 location[playerJob.name] = Config.Jobs[playerJob.name].MotorworksConfig
 location["pj"] = playerJob.name
 exports["qb-customs"]:buildLocations(location)
end
--- all start up functions, tables and threads
local kickOff = function()
 CreateThread(function()
  TriggerServerEvent("qb-jobs:server:BuildHistory","Jobs")
  TriggerServerEvent("qb-jobs:server:BuildHistory","Gangs")
  TriggerServerEvent("qb-jobs:server:populateJobsNGangs")
  TriggerServerEvent("qb-jobs:server:countVehicle")
  setCurrentPlayerVars()
  if not pedsSpawned then
   spawnPeds()
  end
  if not locationsSet then
   setLocations()
  end
  setCustomsLocations()
  onDuty = playerJob.onduty
  buildJobsGangsList()
  TriggerServerEvent('qb-jobs:server:initilizeVehicleTracker')
 end)
end
--- list of functions, tables and threads to run at logout, job change, etc
local wrapUp = function()
 killPeds()
 clearVehicles()
 removeBlips()
end
-- Events
--- fivem native for restart start
AddEventHandler("onResourceStart", function(resource)
 if resource == GetCurrentResourceName() then
  kickOff()
 end
end)
--- fivem native for restart stop
AddEventHandler("onResourceStop", function(resource)
 if resource == GetCurrentResourceName() then
  wrapUp()
 end
end)
--- qbcore native for jobUpdate
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
 if JobInfo.onduty then
  toggleDuty()
  onDuty = false
 else
  toggleDuty()
  onDuty = true
 end
 wrapUp()
 playerJob = JobInfo
 kickOff()
 TriggerServerEvent("qb-jobs:server:updateBlips")
end)
--- qbcore native for object updates
RegisterNetEvent('QBCore:Client:UpdateObject', function()
	Ra93Core = exports['qb-core']:GetCoreObject()
end)
--- qbcore native for on player loaded
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
 Ra93Core = exports['qb-core']:GetCoreObject()
 wrapUp()
 TriggerServerEvent("qb-jobs:server:updateBlips")
 kickOff()
end)
--- qbcore native for on player unloaded
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
 TriggerServerEvent('qb-jobs:server:updateBlips')
 onDuty = false
 wrapUp()
 ClearPedTasks(PlayerPedId())
 DetachEntity(PlayerPedId(), true, false)
end)
--- qb-jobs toggle duty event
RegisterNetEvent('qb-jobs:client:toggleDuty', function()
 toggleDuty()
end)
--- qb-jobs blip update event
RegisterNetEvent('qb-jobs:client:updateBlips', function(dutyPlayers, publicPlayers)
 removeDutyBlips()
 for _,v in pairs(Config.Jobs) do
  if v.DutyBlips and v.DutyBlips.enable then
   if v.DutyBlips.type == "service" and onDuty and dutyPlayers then
 for _, data in pairs(dutyPlayers) do
  local id = GetPlayerFromServerId(data.source)
  createDutyBlips(id, data.label, data.job, data.location)
 end
   elseif v.DutyBlips.type == "public" and publicPlayers then
 for _, data in pairs(publicPlayers) do
  local id = GetPlayerFromServerId(data.source)
  createDutyBlips(id, data.label, data.job, data.location)
 end
   end
  end
 end
end)
RegisterNetEvent('qb-jobs:client:multiJobMenu',function()
 getMultiJobMenu()
end)
-- NUI Callbacks
--- closes the menu
RegisterNUICallback('closeMenu', function(data,cb)
 data = true
 SetNuiFocus(false,false)
 cb(data)
end)
--- begins the process to spawn the selected vehicle
RegisterNUICallback('selectedVehicle', function(data,cb)
 takeOutVehicle(data)
 cb("ok")
end)
--- begins the process to delete a vehicle
RegisterNUICallback('delVeh', function(result,cb)
 deleteVehicleProcess(result)
 cb(vehiclesAssigned)
end)
--- boss menu button actions processor
RegisterNUICallback('managementSubMenuActions', function(res,cb)
 local mgrBtnList
 local data = {}
 Ra93Core.functions.triggerCallback('qb-jobs:server:processManagementSubMenuActions',function(res1)
  mgrBtnList = processButtonList(res1)
  data.btnList = mgrBtnList
  cb(data)
 end,res)
end)
--- boss menu button society actions processor
RegisterNUICallback('managementSocietyActions', function(res,cb)
 local mgrBtnList
 local data = {}
 Ra93Core.functions.triggerCallback('qb-jobs:server:processManagementSocietyActions',function(res1)
  mgrBtnList = processButtonList(res1)
  data.btnList = mgrBtnList
  cb(data)
 end,res,jobGangType)
end)
--- multi-job menu actions processor
RegisterNUICallback('processMultiJob', function(res,cb)
 local output = {
  ["btnList"] = {},
  ["error"] = {},
  ["success"] = {}
 }
 Ra93Core.functions.triggerCallback('qb-jobs:server:processMultiJob',function(res1)
  if res1 and res1.error and next(res1.error) then
   cb(res1)
   return res1
  end
  Ra93Core = exports['qb-core']:GetCoreObject()
  setCurrentPlayerVars()
  wrapUp()
  kickOff()
  Wait(0) -- this is needed for the playerData to popluate
  output.btnList = getMultiJobMenuButtons()
  cb(output)
  return output
 end,res)
end)
-- Commands
--- J to open multiJob menu
RegisterCommand("jobs", function()
 getMultiJobMenu()
end, false)
RegisterKeyMapping("jobs","MultiJob Menu","keyboard",Config.multiJobKey)
-- Exports
exports("setCurrentPlayerVars",setCurrentPlayerVars)