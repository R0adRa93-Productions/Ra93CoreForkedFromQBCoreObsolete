ra93Core.Commands = {}
ra93Core.Commands.List = {}
ra93Core.Commands.IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
 ['god'] = true, -- We don't need to create an ace because god is allowed all commands
 ['user'] = true -- We don't need to create an ace because builtin.everyone
}

CreateThread(function() -- Add ace to node for perm checking
 local permissions = ra93Config.Server.Permissions
 for i=1, #permissions do
  local permission = permissions[i]
  ExecuteCommand(('add_ace ra93Core.%s %s allow'):format(permission, permission))
 end
end)

-- Register & Refresh Commands

function ra93Core.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
 local restricted = true -- Default to restricted for all commands
 if not permission then permission = 'user' end -- some commands don't pass permission level
 if permission == 'user' then restricted = false end -- allow all users to use command

 RegisterCommand(name, function(source, args, rawCommand) -- Register command within fivem
  if argsrequired and #args < #arguments then
   return TriggerClientEvent('chat:addMessage', source, {
    color = {255, 0, 0},
    multiline = true,
    args = {"System", Lang:t("error.missing_args2")}
   })
  end
  callback(source, args, rawCommand)
 end, restricted)

 local extraPerms = ... and table.pack(...) or nil
 if extraPerms then
  extraPerms[extraPerms.n + 1] = permission -- The `n` field is the number of arguments in the packed table
  extraPerms.n += 1
  permission = extraPerms
  for i = 1, permission.n do
   if not ra93Core.Commands.IgnoreList[permission[i]] then -- only create aces for extra perm levels
    ExecuteCommand(('add_ace ra93Core.%s command.%s allow'):format(permission[i], name))
   end
  end
  permission.n = nil
 else
  permission = tostring(permission:lower())
  if not ra93Core.Commands.IgnoreList[permission] then -- only create aces for extra perm levels
   ExecuteCommand(('add_ace ra93Core.%s command.%s allow'):format(permission, name))
  end
 end

 ra93Core.Commands.List[name:lower()] = {
  name = name:lower(),
  permission = permission,
  help = help,
  arguments = arguments,
  argsrequired = argsrequired,
  callback = callback
 }
end

function ra93Core.Commands.Refresh(source)
 local src = source
 local Player = ra93Core.functions.GetPlayer(src)
 local suggestions = {}
 if Player then
  for command, info in pairs(ra93Core.Commands.List) do
   local hasPerm = IsPlayerAceAllowed(tostring(src), 'command.'..command)
   if hasPerm then
    suggestions[#suggestions + 1] = {
     name = '/' .. command,
     help = info.help,
     params = info.arguments
    }
   else
    TriggerClientEvent('chat:removeSuggestion', src, '/'..command)
   end
  end
  TriggerClientEvent('chat:addSuggestions', src, suggestions)
 end
end

-- Teleport
ra93Core.Commands.Add('tp', Lang:t("command.tp.help"), { { name = Lang:t("command.tp.params.x.name"), help = Lang:t("command.tp.params.x.help") }, { name = Lang:t("command.tp.params.y.name"), help = Lang:t("command.tp.params.y.help") }, { name = Lang:t("command.tp.params.z.name"), help = Lang:t("command.tp.params.z.help") } }, false, function(source, args)
 if args[1] and not args[2] and not args[3] then
  if tonumber(args[1]) then
  local target = GetPlayerPed(tonumber(args[1]))
  if target ~= 0 then
   local coords = GetEntityCoords(target)
   TriggerClientEvent('ra93Core:Command:TeleportToPlayer', source, coords)
  else
   TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
  end
 else
   local location = ra93Config.Locations[args[1]]
   if location then
    TriggerClientEvent('ra93Core:Command:TeleportToCoords', source, location.x, location.y, location.z, location.w)
   else
    TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.location_not_exist'), 'error')
   end
  end
 else
  if args[1] and args[2] and args[3] then
   local x = tonumber((args[1]:gsub(",",""))) + .0
   local y = tonumber((args[2]:gsub(",",""))) + .0
   local z = tonumber((args[3]:gsub(",",""))) + .0
   if x ~= 0 and y ~= 0 and z ~= 0 then
    TriggerClientEvent('ra93Core:Command:TeleportToCoords', source, x, y, z)
   else
    TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.wrong_format'), 'error')
   end
  else
   TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.missing_args'), 'error')
  end
 end
end, 'admin')

ra93Core.Commands.Add('tpm', Lang:t("command.tpm.help"), {}, false, function(source)
 TriggerClientEvent('ra93Core:Command:GoToMarker', source)
end, 'admin')

ra93Core.Commands.Add('togglepvp', Lang:t("command.togglepvp.help"), {}, false, function()
 ra93Config.Server.PVP = not ra93Config.Server.PVP
 TriggerClientEvent('ra93Core:Client:PvpHasToggled', -1, ra93Config.Server.PVP)
end, 'admin')

-- Permissions

ra93Core.Commands.Add('addpermission', Lang:t("command.addpermission.help"), { { name = Lang:t("command.addpermission.params.id.name"), help = Lang:t("command.addpermission.params.id.help") }, { name = Lang:t("command.addpermission.params.permission.name"), help = Lang:t("command.addpermission.params.permission.help") } }, true, function(source, args)
 local Player = ra93Core.functions.GetPlayer(tonumber(args[1]))
 local permission = tostring(args[2]):lower()
 if Player then
  ra93Core.functions.AddPermission(Player.PlayerData.source, permission)
 else
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
 end
end, 'god')

ra93Core.Commands.Add('removepermission', Lang:t("command.removepermission.help"), { { name = Lang:t("command.removepermission.params.id.name"), help = Lang:t("command.removepermission.params.id.help") }, { name = Lang:t("command.removepermission.params.permission.name"), help = Lang:t("command.removepermission.params.permission.help") } }, true, function(source, args)
 local Player = ra93Core.functions.GetPlayer(tonumber(args[1]))
 local permission = tostring(args[2]):lower()
 if Player then
  ra93Core.functions.RemovePermission(Player.PlayerData.source, permission)
 else
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
 end
end, 'god')

-- Open & Close Server

ra93Core.Commands.Add('openserver', Lang:t("command.openserver.help"), {}, false, function(source)
 if not ra93Core.config.Server.Closed then
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.server_already_open'), 'error')
  return
 end
 if ra93Core.functions.HasPermission(source, 'admin') then
  ra93Core.config.Server.Closed = false
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('success.server_opened'), 'success')
 else
  ra93Core.functions.Kick(source, Lang:t("error.no_permission"), nil, nil)
 end
end, 'admin')

ra93Core.Commands.Add('closeserver', Lang:t("command.closeserver.help"), {{ name = Lang:t("command.closeserver.params.reason.name"), help = Lang:t("command.closeserver.params.reason.help")}}, false, function(source, args)
 if ra93Core.config.Server.Closed then
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.server_already_closed'), 'error')
  return
 end
 if ra93Core.functions.HasPermission(source, 'admin') then
  local reason = args[1] or 'No reason specified'
  ra93Core.config.Server.Closed = true
  ra93Core.config.Server.ClosedReason = reason
  for k in pairs(ra93Core.Players) do
   if not ra93Core.functions.HasPermission(k, ra93Core.config.Server.WhitelistPermission) then
    ra93Core.functions.Kick(k, reason, nil, nil)
   end
  end
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('success.server_closed'), 'success')
 else
  ra93Core.functions.Kick(source, Lang:t("error.no_permission"), nil, nil)
 end
end, 'admin')

-- Vehicle

ra93Core.Commands.Add('car', Lang:t("command.car.help"), {{ name = Lang:t("command.car.params.model.name"), help = Lang:t("command.car.params.model.help") }}, true, function(source, args)
 TriggerClientEvent('ra93Core:Command:SpawnVehicle', source, args[1])
end, 'admin')

ra93Core.Commands.Add('dv', Lang:t("command.dv.help"), {}, false, function(source)
 TriggerClientEvent('ra93Core:Command:DeleteVehicle', source)
end, 'admin')

-- Money

ra93Core.Commands.Add('givemoney', Lang:t("command.givemoney.help"), { { name = Lang:t("command.givemoney.params.id.name"), help = Lang:t("command.givemoney.params.id.help") }, { name = Lang:t("command.givemoney.params.moneytype.name"), help = Lang:t("command.givemoney.params.moneytype.help") }, { name = Lang:t("command.givemoney.params.amount.name"), help = Lang:t("command.givemoney.params.amount.help") } }, true, function(source, args)
 local Player = ra93Core.functions.GetPlayer(tonumber(args[1]))
 if Player then
  Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
 else
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
 end
end, 'admin')

ra93Core.Commands.Add('setmoney', Lang:t("command.setmoney.help"), { { name = Lang:t("command.setmoney.params.id.name"), help = Lang:t("command.setmoney.params.id.help") }, { name = Lang:t("command.setmoney.params.moneytype.name"), help = Lang:t("command.setmoney.params.moneytype.help") }, { name = Lang:t("command.setmoney.params.amount.name"), help = Lang:t("command.setmoney.params.amount.help") } }, true, function(source, args)
 local Player = ra93Core.functions.GetPlayer(tonumber(args[1]))
 if Player then
  Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
 else
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
 end
end, 'admin')

-- Job

--using this route to disable the command completely for qb-jobs support
if not ra93Core.shared.QBJobsStatus then

 ra93Core.Commands.Add('job', Lang:t("command.job.help"), {}, false, function(source)
  local PlayerJob = ra93Core.functions.GetPlayer(source).PlayerData.job
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('info.job_info', {value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}))
 end, 'user')

 ra93Core.Commands.Add('setjob', Lang:t("command.setjob.help"), { { name = Lang:t("command.setjob.params.id.name"), help = Lang:t("command.setjob.params.id.help") }, { name = Lang:t("command.setjob.params.job.name"), help = Lang:t("command.setjob.params.job.help") }, { name = Lang:t("command.setjob.params.grade.name"), help = Lang:t("command.setjob.params.grade.help") } }, true, function(source, args)
  -- by placing if ra93Core.shared.QBJobsStatus then return false end here will still make people think the command still exists and is broken.
  local Player = ra93Core.functions.GetPlayer(tonumber(args[1]))
  if Player then
   Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
  else
   TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
  end
 end, 'admin')

 ra93Core.Commands.Add('gang', Lang:t("command.gang.help"), {}, false, function(source)
  local PlayerGang = ra93Core.functions.GetPlayer(source).PlayerData.gang
  TriggerClientEvent('ra93Core:Notify', source, Lang:t('info.gang_info', {value = PlayerGang.label, value2 = PlayerGang.grade.name}))
 end, 'user')

 ra93Core.Commands.Add('setgang', Lang:t("command.setgang.help"), { { name = Lang:t("command.setgang.params.id.name"), help = Lang:t("command.setgang.params.id.help") }, { name = Lang:t("command.setgang.params.gang.name"), help = Lang:t("command.setgang.params.gang.help") }, { name = Lang:t("command.setgang.params.grade.name"), help = Lang:t("command.setgang.params.grade.help") } }, true, function(source, args)
  -- by placing if ra93Core.shared.QBJobsStatus then return false end here will still make people think the command still exists and is broken.
  local Player = ra93Core.functions.GetPlayer(tonumber(args[1]))
  if Player then
   Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
  else
   TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.not_online'), 'error')
  end
 end, 'admin')
end

-- Out of Character Chat

ra93Core.Commands.Add('ooc', Lang:t("command.ooc.help"), {}, false, function(source, args)
 local message = table.concat(args, ' ')
 local Players = ra93Core.functions.GetPlayers()
 local Player = ra93Core.functions.GetPlayer(source)
 local playerCoords = GetEntityCoords(GetPlayerPed(source))
 for _, v in pairs(Players) do
  if v == source then
   TriggerClientEvent('chat:addMessage', v, {
    color = { 0, 0, 255},
    multiline = true,
    args = {'OOC | '.. GetPlayerName(source), message}
   })
  elseif #(playerCoords - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
   TriggerClientEvent('chat:addMessage', v, {
    color = { 0, 0, 255},
    multiline = true,
    args = {'OOC | '.. GetPlayerName(source), message}
   })
  elseif ra93Core.functions.HasPermission(v, 'admin') then
   if ra93Core.functions.IsOptin(v) then
    TriggerClientEvent('chat:addMessage', v, {
     color = { 0, 0, 255},
     multiline = true,
     args = {'Proxmity OOC | '.. GetPlayerName(source), message}
    })
    TriggerEvent('qb-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(source) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') **Message:** ' .. message, false)
   end
  end
 end
end, 'user')

-- Me command

ra93Core.Commands.Add('me', Lang:t("command.me.help"), {{name = Lang:t("command.me.params.message.name"), help = Lang:t("command.me.params.message.help")}}, false, function(source, args)
 if #args < 1 then TriggerClientEvent('ra93Core:Notify', source, Lang:t('error.missing_args2'), 'error') return end
 local ped = GetPlayerPed(source)
 local pCoords = GetEntityCoords(ped)
 local msg = table.concat(args, ' '):gsub('[~<].-[>~]', '')
 local Players = ra93Core.functions.GetPlayers()
 for i=1, #Players do
  local Player = Players[i]
  local target = GetPlayerPed(Player)
  local tCoords = GetEntityCoords(target)
  if target == ped or #(pCoords - tCoords) < 20 then
   TriggerClientEvent('ra93Core:Command:ShowMe3D', Player, source, msg)
  end
 end
end, 'user')
