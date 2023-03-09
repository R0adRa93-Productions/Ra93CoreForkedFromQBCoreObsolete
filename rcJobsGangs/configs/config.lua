Config = {
 ["useTarget"] = GetConvar('UseTarget', 'false') == 'true',
 ["perms"] = {
  -- sets minimum who can see job status
  ["job"] = "user",
  -- sets minimum who can open the multiJob Menu
  ["jobs"] = "user",
  -- sets minimum who can use /setjob
  ["setJob"] = "admin",
  -- sets minimum who can see gang status
  ["gang"] = "user",
  -- sets minimum who can open the multiJob Menu
  ["gangs"] = "user",
  -- sets minimum who can use /setgang
  ["setGang"] = "admin",
   -- sets minimum who can use /duty
  ["duty"] = "user"
 },
 ["Jobs"] = {},
 ["Gangs"] = {},
 ["showGangsHistory"] = false,
 ["multiJobKey"] = "j", -- choose key to activate multi-job menu
 ["debugPoly"] = true, -- true = shows polyZone Aeas | false = hides polyZone areas
 ["fuel"] = "LegacyFuel",
 ["keys"] = "qb-vehiclekeys:server:AcquireVehicleKeys",
 ["hideAvailableJobs"] = true, -- true = does not display unworked jobs | false = displays unworked jobs.
 ["currencySymbol"] = "$", -- Sets the currency symbol.
 ["menu"] = {
  ["headerMultiJob"] = "Multi-Job Menu",
  ["icons"] = {
   ["activate"] = "fa-solid fa-toggle-on",
   ["active"] = "fa-solid fa-land-mine-on",
   ["apply"] = "fa-regular fa-clipboard",
   ["available"] = "fa-solid fa-laptop-file",
   ["blacklisted"] = "fa-solid fa-ban",
   ["close"] = "fa-solid fa-x",
   ["hiredOn"] = "fa-solid fa-check-to-slot",
   ["pending"] = "fa-solid fa-file-circle-question",
   ["quit"] = "fa-regular fa-circle-xmark",
   ["rescind"] = "fa-solid fa-recycle",
   ["retract"] = "fa-solid fa-angles-left"
  }
 }
}