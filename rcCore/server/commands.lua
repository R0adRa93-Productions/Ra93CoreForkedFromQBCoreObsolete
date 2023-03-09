Ra93Core = Ra93Core or {}
Ra93Core.commands = {
 ["list"] = {},
 ["ignoreList"] = { -- Ignore old perm levels while keeping backwards compatibility
  ["god"] = true, -- We do not need to create an ace because god is allowed all commands
  ["user"] = true -- We do not need to create an ace because builtin.everyone
 },
 ["add"] = function(name, help, arguments, argsrequired, callback, permission, ...)
  local restricted = true -- Default to restricted for all commands
  permission = not permission and {"user"} or type(permission) == "string" and {permission} or permission
  if Ra93Core.shared.tableContains(permission, "user") then restricted = false end
  RegisterCommand(name, function(source, args, rawCommand) -- Register command within fivem
   if argsrequired and #args < #arguments then
    return TriggerClientEvent("chat:addMessage", source, {
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
    if not Ra93Core.commands.ignoreList[permission[i]] then -- only create aces for extra perm levels
     ExecuteCommand(("add_ace Ra93Core.%s command.%s allow"):format(permission[i], name))
    end
   end
   permission.n = nil
  else
   permission = tostring(permission:lower())
   if not Ra93Core.commands.ignoreList[permission] then ExecuteCommand(("add_ace Ra93Core.%s command.%s allow"):format(permission, name)) end
  end
  Ra93Core.commands.list[name:lower()] = {
   name = name:lower(),
   permission = permission,
   help = help,
   arguments = arguments,
   argsrequired = argsrequired,
   callback = callback
  }
 end,
 ["refresh"] = function(source)
  local src = source
  local player = Ra93Core.functions.getPlayer(src)
  local suggestions = {}
  if player then
   for command, info in pairs(Ra93Core.commands.list) do
    local hasPerm = IsPlayerAceAllowed(tostring(src), "command."..command)
    if hasPerm then
     suggestions[#suggestions + 1] = {
      name = ("/%s"):format(command),
      help = info.help,
      params = info.arguments
     }
    else TriggerClientEvent("chat:removeSuggestion", src, "/"..command) end
   end
   TriggerClientEvent("chat:addSuggestions", src, suggestions)
  end
 end
}

CreateThread(function()
 local permissions = Config.server.permissions
 for i=1, #permissions do
  local permission = permissions[i]
  ExecuteCommand(("add_ace Ra93Core.%s %s allow"):format(permission, permission))
 end
end)

Ra93Core.commands.add("tp", Lang:t("command.tp.help"), { { name = Lang:t("command.tp.params.x.name"), help = Lang:t("command.tp.params.x.help") }, { name = Lang:t("command.tp.params.y.name"), help = Lang:t("command.tp.params.y.help") }, { name = Lang:t("command.tp.params.z.name"), help = Lang:t("command.tp.params.z.help") } }, false, function(source, args)
 if args[1] and not args[2] and not args[3] then
  if tonumber(args[1]) then
  local target = GetPlayerPed(tonumber(args[1]))
  if target ~= 0 then
   local coords = GetEntityCoords(target)
   TriggerClientEvent("Ra93Core:command:teleportToPlayer", source, coords)
  else
   TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.not_online"), "error")
  end
 else
   local location = Config.Locations[args[1]]
   if location then TriggerClientEvent("Ra93Core:command:teleportToCoords", source, location.x, location.y, location.z, location.w)
   else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.location_not_exist"), "error") end
  end
 else
  if args[1] and args[2] and args[3] then
   local x = tonumber((args[1]:gsub(",",""))) + .0
   local y = tonumber((args[2]:gsub(",",""))) + .0
   local z = tonumber((args[3]:gsub(",",""))) + .0
   if x ~= 0 and y ~= 0 and z ~= 0 then TriggerClientEvent("Ra93Core:command:teleportToCoords", source, x, y, z)
   else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.wrong_format"), "error") end
  else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.missing_args"), "error") end
 end
end, "admin")

Ra93Core.commands.add("tpm", Lang:t("command.tpm.help"), {}, false, function(source) TriggerClientEvent("Ra93Core:command:goToMarker", source) end, "admin")

Ra93Core.commands.add("togglepvp", Lang:t("command.togglepvp.help"), {}, false, function()
 Config.server.pvp = not Config.server.pvp
 TriggerClientEvent("Ra93Core:client:pvpHasToggled", -1, Config.server.pvp)
end, "admin")

Ra93Core.commands.add("addpermission", Lang:t("command.addpermission.help"), { { name = Lang:t("command.addpermission.params.id.name"), help = Lang:t("command.addpermission.params.id.help") }, { name = Lang:t("command.addpermission.params.permission.name"), help = Lang:t("command.addpermission.params.permission.help") } }, true, function(source, args)
 local player = Ra93Core.functions.getPlayer(tonumber(args[1]))
 local permission = tostring(args[2]):lower()
 if player then Ra93Core.functions.addPermission(player.playerData.source, permission)
 else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.not_online"), "error") end
end, "god")

Ra93Core.commands.add("removepermission", Lang:t("command.removepermission.help"), { { name = Lang:t("command.removepermission.params.id.name"), help = Lang:t("command.removepermission.params.id.help") }, { name = Lang:t("command.removepermission.params.permission.name"), help = Lang:t("command.removepermission.params.permission.help") } }, true, function(source, args)
 local player = Ra93Core.functions.getPlayer(tonumber(args[1]))
 local permission = tostring(args[2]):lower()
 if player then Ra93Core.functions.removePermission(player.playerData.source, permission)
 else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.not_online"), "error") end
end, "god")

Ra93Core.commands.add("openserver", Lang:t("command.openserver.help"), {}, false, function(source)
 if not Ra93Core.config.server.closed then
  TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.server_already_open"), "error")
  return
 end
 if Ra93Core.functions.hasPermission(source, "admin") then
  Ra93Core.config.server.closed = false
  TriggerClientEvent("Ra93Core:notify", source, Lang:t("success.server_opened"), "success")
 else Ra93Core.functions.kick(source, Lang:t("error.no_permission"), nil, nil) end
end, "admin")

Ra93Core.commands.add("closeserver", Lang:t("command.closeserver.help"), {{ name = Lang:t("command.closeserver.params.reason.name"), help = Lang:t("command.closeserver.params.reason.help")}}, false, function(source, args)
 if Ra93Core.config.server.closed then
  TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.server_already_closed"), "error")
  return
 end
 if Ra93Core.functions.hasPermission(source, "admin") then
  local reason = args[1] or "No reason specified"
  Ra93Core.config.server.closed = true
  Ra93Core.config.server.closedReason = reason
  for k in pairs(Ra93Core.players) do
   if not Ra93Core.functions.hasPermission(k, Ra93Core.config.server.whitelistPermission) then Ra93Core.functions.kick(k, reason, nil, nil) end
  end
  TriggerClientEvent("Ra93Core:notify", source, Lang:t("success.server_closed"), "success")
 else Ra93Core.functions.kick(source, Lang:t("error.no_permission"), nil, nil) end
end, "admin")

Ra93Core.commands.add("car", Lang:t("command.car.help"), {{ name = Lang:t("command.car.params.model.name"), help = Lang:t("command.car.params.model.help") }}, true, function(source, args) TriggerClientEvent("Ra93Core:command:spawnVehicle", source, args[1]) end, "admin")

Ra93Core.commands.add("dv", Lang:t("command.dv.help"), {}, false, function(source) TriggerClientEvent("Ra93Core:command:deleteVehicle", source) end, "admin")

Ra93Core.commands.add("givemoney", Lang:t("command.givemoney.help"), { { name = Lang:t("command.givemoney.params.id.name"), help = Lang:t("command.givemoney.params.id.help") }, { name = Lang:t("command.givemoney.params.moneytype.name"), help = Lang:t("command.givemoney.params.moneytype.help") }, { name = Lang:t("command.givemoney.params.amount.name"), help = Lang:t("command.givemoney.params.amount.help") } }, true, function(source, args)
 local player = Ra93Core.functions.getPlayer(tonumber(args[1]))
 if player then player.functions.addMoney(tostring(args[2]), tonumber(args[3]))
 else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.not_online"), "error") end
end, "admin")

Ra93Core.commands.add("setmoney", Lang:t("command.setmoney.help"), { { name = Lang:t("command.setmoney.params.id.name"), help = Lang:t("command.setmoney.params.id.help") }, { name = Lang:t("command.setmoney.params.moneytype.name"), help = Lang:t("command.setmoney.params.moneytype.help") }, { name = Lang:t("command.setmoney.params.amount.name"), help = Lang:t("command.setmoney.params.amount.help") } }, true, function(source, args)
 local player = Ra93Core.functions.getPlayer(tonumber(args[1]))
 if player then player.functions.setMoney(tostring(args[2]), tonumber(args[3]))
 else TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.not_online"), "error") end
end, "admin")

Ra93Core.commands.add("ooc", Lang:t("command.ooc.help"), {}, false, function(source, args)
 local message = table.concat(args, " ")
 local Players = Ra93Core.functions.getPlayers()
 local player = Ra93Core.functions.getPlayer(source)
 local playerCoords = GetEntityCoords(GetPlayerPed(source))
 for _, v in pairs(Players) do
  if v == source then
   TriggerClientEvent("chat:addMessage", v, {
    color = { 0, 0, 255},
    multiline = true,
    args = {"OOC | ".. GetPlayerName(source), message}
   })
  elseif #(playerCoords - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
   TriggerClientEvent("chat:addMessage", v, {
    color = { 0, 0, 255},
    multiline = true,
    args = {"OOC | ".. GetPlayerName(source), message}
   })
  elseif Ra93Core.functions.hasPermission(v, "admin") then
   if Ra93Core.functions.isOptin(v) then
    TriggerClientEvent("chat:addMessage", v, {
     color = { 0, 0, 255},
     multiline = true,
     args = {("Proxmity OOC | "):format(GetPlayerName(source)), message}
    })
    TriggerEvent("rcLog:server:createLog", "ooc", "OOC", "white", ("**%s** (CitizenID: %s | ID: %s) **Message:** %s"):format(GetPlayerName(source), player.playerData.citizenid, source, message))
   end
  end
 end
end, "user")

Ra93Core.commands.add("me", Lang:t("command.me.help"), {{name = Lang:t("command.me.params.message.name"), help = Lang:t("command.me.params.message.help")}}, false, function(source, args)
 if #args < 1 then TriggerClientEvent("Ra93Core:notify", source, Lang:t("error.missing_args2"), "error") return end
 local ped = GetPlayerPed(source)
 local pCoords = GetEntityCoords(ped)
 local msg = table.concat(args, " "):gsub("[~<].-[>~]", "")
 local players = Ra93Core.functions.getPlayers()
 for i=1, #players do
  local player = players[i]
  local target = GetPlayerPed(player)
  local tCoords = GetEntityCoords(target)
  if target == ped or #(pCoords - tCoords) < 20 then TriggerClientEvent("Ra93Core:command:showMe3D", player, source, msg) end
 end
end, "user")