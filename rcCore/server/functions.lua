ra93Core.functions = {}
ra93Core.Player_Buckets = {}
ra93Core.Entity_Buckets = {}
ra93Core.UsableItems = {}

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = ra93Core.functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

function ra93Core.functions.GetCoords(entity)
 local coords = GetEntityCoords(entity, false)
 local heading = GetEntityHeading(entity)
 return vector4(coords.x, coords.y, coords.z, heading)
end

function ra93Core.functions.GetIdentifier(source, idtype)
 local identifiers = GetPlayerIdentifiers(source)
 for _, identifier in pairs(identifiers) do
  if string.find(identifier, idtype) then
   return identifier
  end
 end
 return nil
end

function ra93Core.functions.GetSource(identifier)
 for src, _ in pairs(ra93Core.Players) do
  local idens = GetPlayerIdentifiers(src)
  for _, id in pairs(idens) do
   if identifier == id then
    return src
   end
  end
 end
 return 0
end

function ra93Core.functions.GetPlayer(source)
 if type(source) == 'number' then
  return ra93Core.Players[source]
 else
  return ra93Core.Players[ra93Core.functions.GetSource(source)]
 end
end

function ra93Core.functions.GetPlayerByCitizenId(citizenid)
 for src in pairs(ra93Core.Players) do
  if ra93Core.Players[src].PlayerData.citizenid == citizenid then
   return ra93Core.Players[src]
  end
 end
 return nil
end

function ra93Core.functions.GetOfflinePlayerByCitizenId(citizenid)
 return ra93Core.Player.GetOfflinePlayer(citizenid)
end

function ra93Core.functions.GetPlayerByPhone(number)
 for src in pairs(ra93Core.Players) do
  if ra93Core.Players[src].PlayerData.charinfo.phone == number then
   return ra93Core.Players[src]
  end
 end
 return nil
end

function ra93Core.functions.GetPlayers()
 local sources = {}
 for k in pairs(ra93Core.Players) do
  sources[#sources+1] = k
 end
 return sources
end

-- Will return an array of QB Player class instances
-- unlike the GetPlayers() wrapper which only returns IDs
function ra93Core.functions.GetQBPlayers()
 return ra93Core.Players
end

--- Gets a list of all on duty players of a specified job and the number
function ra93Core.functions.GetPlayersOnDuty(job)
 local players = {}
 local count = 0
 for src, Player in pairs(ra93Core.Players) do
  if Player.PlayerData.job.name == job then
   if Player.PlayerData.job.onduty then
    players[#players + 1] = src
    count += 1
   end
  end
 end
 return players, count
end

-- Returns only the amount of players on duty for the specified job
function ra93Core.functions.GetDutyCount(job)
 local count = 0
 for _, Player in pairs(ra93Core.Players) do
  if Player.PlayerData.job.name == job then
   if Player.PlayerData.job.onduty then
    count += 1
   end
  end
 end
 return count
end

-- Routing buckets (Only touch if you know what you are doing)

-- Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
function ra93Core.functions.GetBucketObjects()
 return ra93Core.Player_Buckets, ra93Core.Entity_Buckets
end

-- Will set the provided player id / source into the provided bucket id
function ra93Core.functions.SetPlayerBucket(source --[[ int ]], bucket --[[ int ]])
 if source and bucket then
  local plicense = ra93Core.functions.GetIdentifier(source, 'license')
  SetPlayerRoutingBucket(source, bucket)
  ra93Core.Player_Buckets[plicense] = {id = source, bucket = bucket}
  return true
 else
  return false
 end
end

-- Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
function ra93Core.functions.SetEntityBucket(entity --[[ int ]], bucket --[[ int ]])
 if entity and bucket then
  SetEntityRoutingBucket(entity, bucket)
  ra93Core.Entity_Buckets[entity] = {id = entity, bucket = bucket}
  return true
 else
  return false
 end
end

-- Will return an array of all the player ids inside the current bucket
function ra93Core.functions.GetPlayersInBucket(bucket --[[ int ]])
 local curr_bucket_pool = {}
 if ra93Core.Player_Buckets and next(ra93Core.Player_Buckets) then
  for _, v in pairs(ra93Core.Player_Buckets) do
   if v.bucket == bucket then
    curr_bucket_pool[#curr_bucket_pool + 1] = v.id
   end
  end
  return curr_bucket_pool
 else
  return false
 end
end

-- Will return an array of all the entities inside the current bucket (not for player entities, use GetPlayersInBucket for that)
function ra93Core.functions.GetEntitiesInBucket(bucket --[[ int ]])
 local curr_bucket_pool = {}
 if ra93Core.Entity_Buckets and next(ra93Core.Entity_Buckets) then
  for _, v in pairs(ra93Core.Entity_Buckets) do
   if v.bucket == bucket then
    curr_bucket_pool[#curr_bucket_pool + 1] = v.id
   end
  end
  return curr_bucket_pool
 else
  return false
 end
end

-- Server side vehicle creation with optional callback
-- the CreateVehicle RPC still uses the client for creation so players must be near
function ra93Core.functions.SpawnVehicle(source, model, coords, warp)
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
 return veh
end

-- Server side vehicle creation with optional callback
-- the CreateAutomobile native is still experimental but doesn't use client for creation
-- doesn't work for all vehicles!
function ra93Core.functions.CreateVehicle(source, model, coords, warp)
 model = type(model) == 'string' and joaat(model) or model
 if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
 local CreateAutomobile = `CREATE_AUTOMOBILE`
 local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, coords.w, true, true)
 while not DoesEntityExist(veh) do Wait(0) end
 if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
 return veh
end

-- Paychecks (standalone - don't touch)
function PaycheckInterval()
 if next(ra93Core.Players) then
  for _, Player in pairs(ra93Core.Players) do
   if Player then
    local payment = Player.PlayerData.job.payment
    if not payment then payment = ra93Config.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment end
    if Player.PlayerData.job and payment > 0 and (ra93Config.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
     if ra93Core.config.Money.PayCheckSociety then
      local account = exports['qb-management']:GetAccount(Player.PlayerData.job.name)
      if account ~= 0 then -- Checks if player is employed by a society
       if account < payment then -- Checks if company has enough money to pay society
        TriggerClientEvent('ra93Core:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
       else
        Player.Functions.AddMoney('bank', payment)
        exports['qb-management']:RemoveMoney(Player.PlayerData.job.name, payment)
        TriggerClientEvent('ra93Core:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
       end
      else
       Player.Functions.AddMoney('bank', payment)
       TriggerClientEvent('ra93Core:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
      end
     else
      Player.Functions.AddMoney('bank', payment)
      TriggerClientEvent('ra93Core:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
     end
    end
   end
  end
 end
 SetTimeout(ra93Core.config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end

-- Callback Functions --

-- Client Callback
function ra93Core.functions.TriggerClientCallback(name, source, cb, ...)
 ra93Core.clientCallBacks[name] = cb
 TriggerClientEvent('ra93Core:Client:TriggerClientCallback', source, name, ...)
end

-- Server Callback
function ra93Core.functions.CreateCallback(name, cb)
 ra93Core.serverCallbacks[name] = cb
end

function ra93Core.functions.TriggerCallback(name, source, cb, ...)
 if not ra93Core.serverCallbacks[name] then return end
 ra93Core.serverCallbacks[name](source, cb, ...)
end

-- Items

function ra93Core.functions.CreateUseableItem(item, data)
 ra93Core.UsableItems[item] = data
end

function ra93Core.functions.CanUseItem(item)
 return ra93Core.UsableItems[item]
end

function ra93Core.functions.UseItem(source, item)
 if GetResourceState('qb-inventory') == 'missing' then return end
 exports['qb-inventory']:UseItem(source, item)
end

-- Kick Player

function ra93Core.functions.Kick(source, reason, setKickReason, deferrals)
 reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. ra93Core.config.Server.Discord
 if setKickReason then
  setKickReason(reason)
 end
 CreateThread(function()
  if deferrals then
   deferrals.update(reason)
   Wait(2500)
  end
  if source then
   DropPlayer(source, reason)
  end
  for _ = 0, 4 do
   while true do
    if source then
     if GetPlayerPing(source) >= 0 then
      break
     end
     Wait(100)
     CreateThread(function()
      DropPlayer(source, reason)
     end)
    end
   end
   Wait(5000)
  end
 end)
end

-- Check if player is whitelisted, kept like this for backwards compatibility or future plans

function ra93Core.functions.IsWhitelisted(source)
 if not ra93Core.config.Server.Whitelist then return true end
 if ra93Core.functions.HasPermission(source, ra93Core.config.Server.WhitelistPermission) then return true end
 return false
end

-- Setting & Removing Permissions

function ra93Core.functions.AddPermission(source, permission)
 if not IsPlayerAceAllowed(source, permission) then
  ExecuteCommand(('add_principal player.%s ra93Core.%s'):format(source, permission))
  ra93Core.Commands.Refresh(source)
 end
end

function ra93Core.functions.RemovePermission(source, permission)
 if permission then
  if IsPlayerAceAllowed(source, permission) then
   ExecuteCommand(('remove_principal player.%s ra93Core.%s'):format(source, permission))
   ra93Core.Commands.Refresh(source)
  end
 else
  for _, v in pairs(ra93Core.config.Server.Permissions) do
   if IsPlayerAceAllowed(source, v) then
    ExecuteCommand(('remove_principal player.%s ra93Core.%s'):format(source, v))
    ra93Core.Commands.Refresh(source)
   end
  end
 end
end

-- Checking for Permission Level

function ra93Core.functions.HasPermission(source, permission)
 if type(permission) == "string" then
  if IsPlayerAceAllowed(source, permission) then return true end
 elseif type(permission) == "table" then
  for _, permLevel in pairs(permission) do
   if IsPlayerAceAllowed(source, permLevel) then return true end
  end
 end

 return false
end

function ra93Core.functions.GetPermission(source)
 local src = source
 local perms = {}
 for _, v in pairs (ra93Core.config.Server.Permissions) do
  if IsPlayerAceAllowed(src, v) then
   perms[v] = true
  end
 end
 return perms
end

-- Opt in or out of admin reports

function ra93Core.functions.IsOptin(source)
 local license = ra93Core.functions.GetIdentifier(source, 'license')
 if not license or not ra93Core.functions.HasPermission(source, 'admin') then return false end
 local Player = ra93Core.functions.GetPlayer(source)
 return Player.PlayerData.optin
end

function ra93Core.functions.ToggleOptin(source)
 local license = ra93Core.functions.GetIdentifier(source, 'license')
 if not license or not ra93Core.functions.HasPermission(source, 'admin') then return end
 local Player = ra93Core.functions.GetPlayer(source)
 Player.PlayerData.optin = not Player.PlayerData.optin
 Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
end

-- Check if player is banned

function ra93Core.functions.IsPlayerBanned(source)
 local plicense = ra93Core.functions.GetIdentifier(source, 'license')
 local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', { plicense })
 if not result then return false end
 if os.time() < result.expire then
  local timeTable = os.date('*t', tonumber(result.expire))
  return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
 else
  MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
 end
 return false
end

-- Check for duplicate license

function ra93Core.functions.IsLicenseInUse(license)
 local players = GetPlayers()
 for _, player in pairs(players) do
  local identifiers = GetPlayerIdentifiers(player)
  for _, id in pairs(identifiers) do
   if string.find(id, 'license') then
    if id == license then
     return true
    end
   end
  end
 end
 return false
end

-- Utility functions

function exports["rcInventory"]:HasItem(source, items, amount)
 if GetResourceState('qb-inventory') == 'missing' then return end
 return exports["rcInventory"]:HasItem(source, items, amount)
end

function ra93Core.functions.Notify(source, text, type, length)
 TriggerClientEvent('ra93Core:Notify', source, text, type, length)
end

--- SQL Pattern Matching
function ra93Core.functions.PrepForSQL(source,data,pattern)
 data = tostring(data)
 local src = source
 local player = ra93Core.functions.GetPlayer(src)
 local result = string.match(data, pattern)
 if not result or string.len(result) ~= string.len(data)  then
  TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
  return false
 end
 return true
end