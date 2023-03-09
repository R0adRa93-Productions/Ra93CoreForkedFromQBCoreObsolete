Config.Gangs = Config.Gangs or {}
Config.Gangs.triads = { -- name the job no spaces ex. Config.Gangs.newJobName
 ["jobGang"] = "gang",
 ["bosses"] = { -- Citizen IDs of the Bosses of this Job
  ["AAAA0000"] = "AAAA0000"
 },
 ["webHooks"] = {
  ["triads"] = ""
 },
 ["label"] = "Triads", -- label that display when typing in /job
 ["type"] = "gang", -- job type -- leave set to ems as it's part of the ambulancejob
 ["defaultDuty"] = true, -- duty status when logged on
 ["offDutyPay"] = false, -- true get paid even off duty
 ["listInCityHall"] = true, -- true the job is sent to city hall | false the job is not in city hall
 -- future feature ["canBill"] = true, -- true allows the job to use /bill to charge another player immediately | false disables the ability
 -- future feature ["canInvoice"] = true, -- true allows the job to send an invoice to a player to allow a player to pay later | false disables this feature
 ["menu"] = { -- Menu settings for boss and vehicle menus
  ["icons"] = { -- icons for boss and vehicle menus
   ["applicant"] = "fa-solid fa-user",
   ["applicants"] = "fa-solid fa-users-rectangle",
   ["approve"] = "fa-regular fa-circle-check",
   ["award"] = "fa-solid fa-medal",
   ["boat"] = "fa-solid fa-ship",
--   ["close"] = "fa-regular fa-circle-xmark",
   ["close"] = "fa-solid fa-x",
   ["currentJob"] = "fa-solid fa-kit-medical",
   ["demote"] = "fa-regular fa-thumbs-down",
   ["deniedApplicant"] = "fa-solid fa-user-slash",
   ["deniedApplicants"] = "fa-solid fa-users-slash",
   ["deny"] = "fa-regular fa-circle-xmark",
   ["employee"] = "fa-solid fa-user",
   ["employees"] = "fa-solid fa-users",
   ["fire"] = "fa-solid fa-ban",
   ["helicopter"] = "fa-solid fa-helicopter",
   ["jobGarage"] = "fa-solid fa-square-parking",
   ["jobHistory"] = "fa-regular fa-address-card",
   ["jobStore"] = "fa-solid fa-store",
   ["ownGarage"] = "fa-solid fa-warehouse",
   ["pastEmployee"] = "fa-solid fa-user-slash",
   ["pastEmployees"] = "fa-solid fa-users-slash",
   ["pay"] = "fa-solid fa-hand-holding-dollar",
   ["personal"] = "fa-solid fa-person-circle-exclamation",
   ["plane"] = "fa-solid fa-plane",
   ["promote"] = "fa-regular fa-thumbs-up",
   ["rapSheet"] = "fa-solid fa-handcuffs",
   ["reconsider"] = "fa-solid fa-person-walking-arrow-loop-left",
   ["reprimand"] = "fa-solid fa-triangle-exclamation",
   ["retract"] = "fa-solid fa-angles-left",
   ["returnVehicle"] = "fa-solid fa-rotate-left",
   ["society"] = "fa-solid fa-money-bill-1-wave",
   ["societyDeposit"] = "fa-solid fa-right-to-bracket",
   ["societyWithdrawl"] = "fa-solid fa-right-from-bracket",
   ["vehicle"] = "fa-solid fa-truck-medical",
   ["quit"] = "fa-regular fa-circle-xmark"
  }
 },
 ["grades"] = {
--  [0] = {["name"] = "No Grades"}, -- Reserved Do Not Touch
  ["1"] = { -- gang grade starts at 1 (0 is Reserved)
   ["name"] = 'Recruit', -- job title
  },
  ["2"] = {
   ["name"] = 'Enforcer',
  },
  ["3"] = {
   ["name"] = 'Shot Caller',
  },
  ["4"] = {
   ["name"] = 'Boss',
  }
 },
 ["DutyBlips"] = { -- Blips used to show player's location on map
  ["enable"] = true, -- Enables the Duty Blip
  ["type"] = "public", -- Service = Only for service members to view or Public for all people to view
  ["blipSpriteOnFoot"] = 1, -- blip sprite while in player is outside vehicle | https://docs.fivem.net/docs/game-references/blips/#blips
  ["blipSpriteInVehicle"] = 812, -- blip sprite while in player is in vehicle | https://docs.fivem.net/docs/game-references/blips/#blips
  ["blipSpriteColor"] = 5, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
  ["blipScale"] = 1, -- Size of the Blip on the minimap
 },
 ["Locations"] = {
  ["facilities"] = {
   {
 ["label"] = "Hospital - Pillbox",
 ["public"] = true, -- true station is displayed for all players | false = station is displayed just for the player
 ["coords"] = vector4(304.27, -600.33, 43.28, 272.249),
 ["blipName"] = "Hospital",
 ["blipNumber"] = 61, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  },
  ["duty"] = { -- duty station for going on and off duty
   {
 ["Label"] = "Hospital Timeclock", -- Label of the timeclock
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(326.72, -583.02, 43.32, 345.98),
  ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "4",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Hospital Timeclock",
 ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  },
  ["management"] = { -- location of boss' management station
   {
 ["Label"] = "Medical Management",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(324.33, -582.2, 43.32, 345.98),
  ["targetIcon"] = "fa-solid fa-bars-progress", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "4",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Medical Management",
 ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  },
  ["garages"] = {
   [1] = {
 ["label"] = "Hospital Garage - Pillbox",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(305.0, -598.41, 43.29, 77),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "4",
   ["width"] = "4"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(292.02, -569.36, 42.91, 56.58), -- spawn vehicle locations
   ["type"] = "vehicle" -- vehicle, boat, plane, helicopter
  },
  {
   ["coords"] = vector4(296.72, -575.61, 42.92, 11.67),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(296.32, -583.68, 42.92, 340.94),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(293.56, -591.24, 42.86, 341.41),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(290.63, -599.41, 42.91, 335.64),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(285.67, -605.84, 42.93, 301.75),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(277.29, -608.74, 42.76, 277.89),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(352.27, -587.93, 74.17, 91.02),
   ["type"] = "helicopter"
  }
 },
 ["blipName"] = "Hospital Garage",
 ["blipNumber"] = 357, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 81, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   },
   [2] = {
 ["label"] = "Hospital Garage - Paleto Bay",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(-251.38, 6338.43, 32.49, 37.65),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  [0] = {
   ["coords"] = vector4(-257.96, 6347.63, 32.2, 269.57), -- spawn vehicle locations
   ["type"] = "vehicle" -- vehicle, boat, plane, helicopter
  },
  [1] = {
   ["coords"] = vector4(-261.48, 6344.16, 32.2, 268.59),
   ["type"] = "vehicle"
  },
  [2] = {
   ["coords"] = vector4(-264.61, 6340.94, 32.2, 271.83),
   ["type"] = "vehicle"
  },
  [3] = {
   ["coords"] = vector4(-268.09, 6337.3, 32.2, 268.01),
   ["type"] = "vehicle"
  },
  [4] = {
   ["coords"] = vector4(-271.67, 6333.82, 32.2, 269.64),
   ["type"] = "vehicle"
  },
  [5] = {
   ["coords"] = vector4(-274.83, 6330.76, 32.2, 271.92),
   ["type"] = "vehicle"
  },
  [6] = {
   ["coords"] = vector4(-277.81, 6327.54, 32.2, 263.53),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Garage",
 ["blipNumber"] = 357, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 81, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   },
   [3] = {
 ["label"] = "Hospital Hanger LosSantos Airport",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(-1232.29, -2809.43, 13.95, 222.26),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  [0] = {
   ["coords"] = vector4(-1221.33, -2946.33, 14.29, 247.66),
   ["type"] = "plane"
  },
  [1] = {
   ["coords"] = vector4(-1131.8, -2998.63, 14.29, 239.33),
   ["type"] = "plane"
  },
  [2] = {
   ["coords"] = vector4(-1131.8, -2998.63, 14.29, 239.33),
   ["type"] = "plane"
  },
  [3] = {
   ["coords"] = vector4(-1177.39, -2844.51, 13.95, 153.61),
   ["type"] = "helicopter"
  },
  [4] = {
   ["coords"] = vector4(-1146.06, -2864.38, 13.95, 153.35),
   ["type"] = "helicopter"
  },
  [5] = {
   ["coords"] = vector4(-1111.6, -2882.67, 13.95, 154.89),
   ["type"] = "helicopter"
  },
  [6] = {
   ["coords"] = vector4(-1204.88, -2815.36, 13.72, 241.89),
   ["type"] = "vehicle"
  },
  [7] = {
   ["coords"] = vector4(-1201.78, -2808.47, 13.72, 244.87),
   ["type"] = "vehicle"
  },
  [8] = {
   ["coords"] = vector4(-1216.67, -2823.85, 13.72, 181.4),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Hanger",
 ["blipNumber"] = 359,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [4] = {
 ["label"] = "Hospital Hanger Grapeseed",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(2120.9, 4784.06, 40.97, 297.55),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(2133.74, 4807.58, 41.72, 115.16),
   ["type"] = "plane"
  },
  {
   ["coords"] = vector4(2133.74, 4807.58, 41.72, 115.16),
   ["type"] = "helicopter"
  },
  {
   ["coords"] = vector4(2136.61, 4798.74, 40.91, 25.93),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Hanger",
 ["blipNumber"] = 359,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [5] = {
 ["label"] = "Hospital Hanger Sandy Shores",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(1720.09, 3287.05, 41.53, 185.75),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(1710.97, 3252.41, 41.69, 105.83),
   ["type"] = "plane"
  },
  {
   ["coords"] = vector4(1770.41, 3239.77, 42.52, 101.73),
   ["type"] = "helicopter"
  },
  {
   ["coords"] = vector4(1748.53, 3293.51, 40.88, 195.15),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(1726.8, 3287.29, 40.9, 200.19),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Hanger",
 ["blipNumber"] = 359,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [6] = {
 ["label"] = "Hospital Boatlaunch Alamo Sea",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(1302.96, 4226.23, 33.91, 353.23),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(1293.24, 4222.41, 30.8, 174.57),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(1302.1, 4323.88, 38.09, 298.3),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(1310.47, 4309.0, 37.6, 356.87),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [7] = {
 ["label"] = "Hospital Boatlaunch Los Santos",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(-784.0, -1356.02, 5.15, 236.42),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(-761.98, -1373.05, 0.1, 231.48),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(-802.86, -1321.46, 4.77, 171),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-805.91, -1321.46, 4.77, 171),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-809.42, -1321.46, 4.77, 171),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [8] = {
 ["label"] = "Hospital Boatlaunch Paleto Cove",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01",
  ["coords"] = vector4(-1598.24, 5188.34, 4.31, 306.23),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(-1603.61, 5260.97, 0.29, 22.87),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(-1573.75, 5167.36, 19.32, 139.75),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-1577.79, 5171.09, 19.34, 139.27),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Hospital Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   }
  },
  ["shops"] = { -- Used to be called Armory but is better used as a shop
   {
 ["label"] = "Hospital Supplies - Pillbox",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(309.76, -603.13, 43.29, 77),
  ["targetIcon"] = "fa-solid fa-shop", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Hospital Supplies",
 ["blipNumber"] = 187,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["stashes"] = { -- player's personal locker area
   {
 ["label"] = "Hospital Locker - Pillbox",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(316.97, -583.32, 43.28, 251.62),
  ["targetIcon"] = "fa-solid fa-boxes-stacked", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Medical Locker",
 ["blipNumber"] = 187,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["trash"] = {
   {
 ["label"] = "Hospital Trash - Pillbox",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(301.44, -580.94, 43.29, 188.55),
  ["targetIcon"] = "fa-regular fa-trash-can", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Hospital Trash",
 ["blipNumber"] = 728,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true,
   }
  },
  ["lockers"] = { -- Locker shared with all members in job (great for evidence locker or patient belongings locker)
   {
 ["label"] = "Patient Belongings - Pillbox",
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(319.7, -573.66, 43.32, 246.02),
  ["targetIcon"] = "fa-solid fa-file-shield", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Patient Belongings",
 ["blipNumber"] = 134,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["outfits"] = {
   {
 ["jobType"] = "ems",
 ["isGang"] = false,
 ["ped"] = {
  ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(342.72, -586.45, 43.32, 346.32),
  ["targetIcon"] = "fa-solid fa-shirt", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["width"] = 2,
 ["length"] = 2,
 ["cameraLocation"] = vector4(342.72, -586.45, 43.32, 346.32),
 ["blipName"] = "Medical Clothing",
 ["blipNumber"] = 366,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
--[[ Only until the new one is built
  ["motorworks"] = { -- location of the motorworks job garage
   {
 ["jobType"] = "ems",
 ["isGang"] = false,
 ["ped"] = {
  ["model"] = "s_f_y_sweatshop_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(345.33, -564.94, 28.74, 70.42),
  ["targetIcon"] = "fa-solid fa-shirt", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["Label"] = "EMS Motorworks",
 ["blipName"] = "EMS Motorworks",
 ["coords"] = vector3(328.87, -557.93, 28.51),
 ["blipNumber"] = 72, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   },
   {
 ["jobType"] = "ems",
 ["isGang"] = false,
 ["ped"] = {
  ["model"] = "s_f_y_sweatshop_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(322.16, -555.66, 28.74, 254.31),
  ["targetIcon"] = "fa-solid fa-shirt", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["Label"] = "EMS Motorworks",
 ["blipName"] = "EMS Motorworks",
 ["coords"] = vector3(338.61, -561.37, 28.51),
 ["blipNumber"] = 72, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  },
]]--
 },
 ["Vehicles"] = {
  ["config"] = {
   ["plate"] = "EMS", -- 4 Chars Max -- License Plate Prefix
   ["maxVehicles"] = 10, -- 0 = unlimited
   ["assignVehicles"] = false, -- true = the player may only have one vehicle | false = the player may have more than one vehicle.
   ["depositFees"] = true, -- true = refundable deposit due at checkout | false = no refundable deposit due at checkout
   ["rentalFees"] = true, -- true = player is charged rent for vehicle | false = player is not charged rent for vehicle
   ["ownedVehicles"] = true, -- true = player can own the vehicle | false = player can not own the vehicle
   ["ownedParkingFee"] = true, -- true = players are charged when checking out vehicle | false = players are not charged when checking out vehicle
   ["allowPurchase"] = true, -- true = players pay a fee to own vehicle | false = players are not charged a fee to own a vehicle
   ["societyPurchase"] = true, -- true = the job pays the vehicle fees | false = player pays fees to the job
  },
  ["vehicles"] = {
   ["ambulance"] = { -- Spawn Code
 ["label"] = "Ambulance", -- Label for Spawner
 ["type"] = "vehicle", -- vehicle, boat, plane, helicopter
 ["depositPrice"] = 250, -- price of the vehicle deposit
 ["rentPrice"] = 250, -- price of the rental
 ["parkingPrice"] = 125, -- price to check out owned vehicle
 ["purchasePrice"] = 150000, -- price to own vehicle
 ["icon"] = "fa-solid fa-truck-medical", -- https://fontawesome.com/icons
 ["authGrades"] = {1,2,3,4,5,6}, -- Authorized Grades for Vehicle
 ["settings"] = {
  {
   ["grades"] = {1,2,3},
   ["livery"] = 2, -- First Livery Starts At 0
   ["extras"] = {
 [1] = 1, -- 0 = Show | 1 = Hide
 [2] = 0,
 [3] = 0,
 [4] = 0,
 [5] = 0,
 [6] = 0,
 [7] = 0,
 [8] = 0,
 [9] = 0,
 [10] = 0,
 [11] = 0,
 [12] = 0,
 [13] = 0
   }
  },
  {
   ["grades"] = {4,5,6},
   ["livery"] = 1, -- First Livery Starts At 0
   ["extras"] = {
 [1] = 0, -- 0 = Show | 1 = Hide
 [2] = 0,
 [3] = 0,
 [4] = 0,
 [5] = 0,
 [6] = 0,
 [7] = 0,
 [8] = 0,
 [9] = 0,
 [10] = 0,
 [11] = 0,
 [12] = 0,
 [13] = 0
   }
  }
 }
   },
   ["polmav"] = {
 ["label"] = "Air Ambulance",
 ["type"] = "helicopter",
 ["rentPrice"] = 250,
 ["parkingPrice"] = 125,
 ["purchasePrice"] = 3000000,
 ["icon"] = "fa-solid fa-helicopter",
 ["authGrades"] = {1,2,3,4,5,6},
 ["settings"] = {
  {
   ["grades"] = {0,1,2,3,4,5,6},
   ["extras"] = {
 [1] = 0,
 [2] = 0,
 [3] = 0,
 [4] = 0,
 [5] = 0,
 [6] = 0,
 [7] = 0,
 [8] = 0,
 [9] = 0,
 [10] = 0,
 [11] = 0,
 [12] = 0,
 [13] = 0
   },
   ["livery"] = 1
  }
 }
   }
  }
 },
 ["MotorworksConfig"] = {
  ["settings"] = {
   ["label"] = 'EMS Motorworks',
   ["welcomeLabel"] = "Welcome to EMS Motorworks!",
   ["enabled"] = true,
  },
  ["categories"] = {
   ["repair"] = true,
   ["respray"] = true,
   ["liveries"] = true,
   ["tint"] = true,
   ["extras"] = true,
   ["plate"] = true,
   ["cosmetics"] = true,
  },
  ["drawtextui"] = {
   ["text"] = "EMS Motorworks",
  },
  ["restrictions"] = {
   ["job"] = { 'ambulance' },
   ["allowedClasses"] = { 18 },
  },
  ["zones"] = {
   {
  ["coords"] = vector3(338.61, -561.37, 28.51),
  ["length"] = 9.0,
  ["width"] = 4.0,
  ["heading"] = 90.0,
  ["minZ"] = 24.5,
  ["maxZ"] = 28.5
   },
   {
  ["coords"] = vector3(328.87, -557.93, 28.51),
  ["length"] = 9.0,
  ["width"] = 4.0,
  ["heading"] = 90.0,
  ["minZ"] = 24.5,
  ["maxZ"] = 28.5
   }
  }
 },
 ["Items"] = {
  ["items"] = {
   {
 ["name"] = "radio", -- item name from items.lua
 ["price"] = 0, -- item price if you wish to charge to take it out
 ["amount"]  = 1, -- quantity in the location
 ["info"] = {}, -- information about the item from items.lua
 ["type"] = "item", -- item or weapon reference items.lua
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"}, -- vehicle, boat, plane, and/or helicopter
 ["locations"] = {'shop','glovebox'}, -- shop, glovebox and/or trunk
 ["authGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "bandage",
 ["price"] = 0,
 ["amount"]  = 5,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'shop','trunk'},
 ["authGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "painkillers",
 ["price"] = 0,
 ["amount"]  = 10,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'shop','trunk'},
 ["authGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "firstaid",
 ["price"] = 0,
 ["amount"]  = 10,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'shop','trunk'},
 ["authGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "weapon_flashlight",
 ["price"] = 0,
 ["amount"]  = 1,
 ["info"] = {},
 ["type"] = "weapon",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'shop','glovebox'},
 ["authGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "weapon_fireextinguisher",
 ["price"] = 0,
 ["amount"]  = 1,
 ["info"] = {},
 ["type"] = "weapon",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'shop','trunk'},
 ["authGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "heavyarmor",
 ["price"] = 0,
 ["amount"]  = 2,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'shop','trunk'},
 ["authGrades"] = {1,2,3,4,5,6}
   }
  },
  ["shop"] = {
   ["shopLabel"] =  "Medical Supply Cabinet", -- name of shop
   ["slots"] = 30, -- how many slots for shop
  },
  ["locker"] = {
   ["options"] = {
 ["maxweight"] = 4000000,
 ["slots"] = 300
   }
  },
  ["trash"] = {
   ["options"] = {
 ["maxweight"] = 4000000,
 ["slots"] = 300
   }
  }
 },
 ["Outfits"] = {
  ['male'] = { -- Gender
   {
 ["outfitLabel"] = 'T-Shirt', -- Label of Outfit
 ["authGrades"] = {1,2,3,4,5,6}, -- Authorized Grades
 ["outfitData"] = {
  ['arms'] = {item = 85, texture = 0}, -- Arms
  ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
  ['torso2'] = {item = 250, texture = 0}, -- Jackets
  ['vest'] = {item = 0, texture = 0}, -- Vest
  ['decals'] = {item = 58, texture = 0}, -- Decals
  ['accessory'] = {item = 127, texture = 0}, -- Neck
  ['bag'] = {item = 0, texture = 0}, -- Bag
  ['pants'] = {item = 96, texture = 0}, -- Pants
  ['shoes'] = {item = 54, texture = 0}, -- Shoes
  ['mask'] = {item = 121, texture = 0}, -- Mask
  ['hat'] = {item = 122, texture = 0}, -- Hat
  ['glass'] = {item = 0, texture = 0}, -- Glasses
  ['ear'] = {item = 0, texture = 0} -- Ear accessories
 },
   },
   {
 ["outfitLabel"] = 'Polo',
 ["authGrades"] = {3,4,5,6},
 ["outfitData"] = {
  ['arms'] = {item = 90, texture = 0},
  ['t-shirt'] = {item = 15, texture = 0},
  ['torso2'] = {item = 249, texture = 0},
  ['vest'] = {item = 0, texture = 0},
  ['decals'] = {item = 57, texture = 0},
  ['accessory'] = {item = 126, texture = 0},
  ['bag'] = {item = 0, texture = 0},
  ['pants'] = {item = 96, texture = 0},
  ['shoes'] = {item = 54, texture = 0},
  ['mask'] = {item = 121, texture = 0},
  ['hat'] = {item = 122, texture = 0},
  ['glass'] = {item = 0, texture = 0},
  ['ear'] = {item = 0, texture = 0}
 }
   },
   {
 ["outfitLabel"] = 'Doctor',
 ["authGrades"] = {4,5,6},
 ["outfitData"] = {
  ['arms'] = {item = 93, texture = 0},
  ['t-shirt'] = {item = 32, texture = 3},
  ['torso2'] = {item = 31, texture = 7},
  ['vest'] = {item = 0, texture = 0},
  ['decals'] = {item = 0, texture = 0},
  ['accessory'] = {item = 126, texture = 0},
  ['bag'] = {item = 0, texture = 0},
  ['pants'] = {item = 28, texture = 0},
  ['shoes'] = {item = 10, texture = 0},
  ['mask'] = {item = 0, texture = 0},
  ['hat'] = {item = -1, texture = 0},
  ['glass'] = {item = 0, texture = 0},
  ['ear'] = {item = 0, texture = 0}
 }
   }
  },
  ['female'] = { -- Gender
   {
 ["outfitLabel"] = 'T-Shirt', -- Label of Outfit
 ["authGrades"] = {1,2,3,4,5,6}, -- Authorized Grades
 ["outfitData"] = {
  ['arms'] = {item = 109, texture = 0}, -- Arms
  ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
  ['torso2'] = {item = 258, texture = 0}, -- Jackets
  ['vest'] = {item = 0, texture = 0}, -- Vest
  ['decals'] = {item = 66, texture = 0}, -- Decals
  ['accessory'] = {item = 97, texture = 0}, -- Neck
  ['bag'] = {item = 0, texture = 0}, -- Bag
  ['pants'] = {item = 99, texture = 0}, -- Pants
  ['shoes'] = {item = 55, texture = 0}, -- Shoes
  ['mask'] = {item = 121, texture = 0}, -- Mask
  ['hat'] = {item = 121, texture = 0}, -- Hat
  ['glass'] = {item = 0, texture = 0}, -- Glasses
  ['ear'] = {item = 0, texture = 0} -- Ear accessories
 }
   },
   {
 ["outfitLabel"] = 'Polo',
 ["authGrades"] = {3,4,5,6},
 ["outfitData"] = {
  ['arms'] = {item = 105, texture = 0}, -- Arms
  ['t-shirt'] = {item = 13, texture = 0}, -- T-Shirt
  ['torso2'] = {item = 257, texture = 0}, -- Jackets
  ['vest'] = {item = 0, texture = 0}, -- Vest
  ['decals'] = {item = 65, texture = 0}, -- Decals
  ['accessory'] = {item = 96, texture = 0}, -- Neck
  ['bag'] = {item = 0, texture = 0}, -- Bag
  ['pants'] = {item = 99, texture = 0}, -- Pants
  ['shoes'] = {item = 55, texture = 0}, -- Shoes
  ['mask'] = {item = 121, texture = 0}, -- Mask
  ['hat'] = {item = 121, texture = 0}, -- Hat
  ['glass'] = {item = 0, texture = 0}, -- Glasses
  ['ear'] = {item = 0, texture = 0} -- Ear accessories
 }
   },
   {
 ["outfitLabel"] = 'Doctor',
 ["authGrades"] = {4,5,6},
 ["outfitData"] = {
  ['arms'] = {item = 105, texture = 0}, -- Arms
  ['t-shirt'] = {item = 39, texture = 3}, -- T-Shirt
  ['torso2'] = {item = 7, texture = 1}, -- Jackets
  ['vest'] = {item = 0, texture = 0}, -- Vest
  ['decals'] = {item = 0, texture = 0}, -- Decals
  ['accessory'] = {item = 96, texture = 0}, -- Neck
  ['bag'] = {item = 0, texture = 0}, -- Bag
  ['pants'] = {item = 34, texture = 0}, -- Pants
  ['shoes'] = {item = 29, texture = 0}, -- Shoes
  ['mask'] = {item = 0, texture = 0}, -- Mask
  ['hat'] = {item = -1, texture = 0}, -- Hat
  ['glass'] = {item = 0, texture = 0}, -- Glasses
  ['ear'] = {item = 0, texture = 0} -- Ear accessories
 }
   }
  }
 },
 ["management"] = {
  ["status"] = {
   ["pending"] = "Pending", -- this is the pending status
   ["hired"] = "Hired", -- this is the hired status
   ["fired"] = "Fired", -- this is the fired status
   ["quit"] = "Quit", -- this is the quit status
   ["blacklisted"] = "Black Listed", -- this is the black listed status
  },
  ["awards"] = {
   {
 ["title"] = "Award of Excellence",
 ["description"] = "Awarded for going above and beyond service to patients.",
   },
   {
 ["title"] = "Honorable Action",
 ["description"] = "Awarded for saving a life with risk to life and limb. While on duty or off duty."
   },
   {
 ["title"] = "Meritous Action",
 ["description"] = "Awarded for saving a life while off duty. Not looking away when others could be of service."
   },
   {
 ["title"] = "Medical Heart Award",
 ["description"] = "Awarded for being wounded on the mean streets of San Andreas."
   }
  },
  ["reprimands"] = {
   {
 ["title"] = "Malpractice",
 ["description"] = "Making a mistake while treating a patient"
   },
   {
 ["title"] = "Insubordination",
 ["description"] = "Failure to follow directions."
   },
   {
 ["title"] = "Unsafe Behavior",
 ["description"] = "Failure to follow safety guidelines."
   },
   {
 ["title"] = "No Call / No Show",
 ["description"] = "Fails to call out & fails to show up."
   }
  }
 },
--[[ ["uiColors"] = { -- set colors for the menu system
 -- Main Menu Header --
  {
   ["element"] = "h1",
   ["property"] = "background",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = "h1",
   ["property"] = "color",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Side Menu Header --
  {
   ["element"] = "h2",
   ["property"] = "background",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = "h2",
   ["property"] = "color",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Main Menu Buttons --
  {
   ["element"] = ".navButton",
   ["property"] = "background",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".navButton",
   ["property"] = "color",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  -- Main Menu Buttons on Mouse Over --
  {
   ["element"] = ".navButton:hover",
   ["property"] = "background",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".navButton:hover",
   ["property"] = "color",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Main Menu Sub Level Buttons --
  {
   ["element"] = ".navSubButton",
   ["property"] = "background",
   ["value"] = "#CFCFCF" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".navSubButton",
   ["property"] = "color",
   ["value"] = "#940C28" -- Color in Hex see https://www.color-hex.com/
  },
  -- Main Menu Sub Level Buttons on Mouse Over --
  {
   ["element"] = ".navSubButton:hover",
   ["property"] = "background",
   ["value"] = "#940C28" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".navSubButton:hover",
   ["property"] = "color",
   ["value"] = "#CFCFCF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Side Menu Buttons --
  {
   ["element"] = ".pageButton",
   ["property"] = "background",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".pageButton",
   ["property"] = "color",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  -- Side Menu Buttons on Mouse Over --
  {
   ["element"] = ".pageButton:hover",
   ["property"] = "background",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".pageButton:hover",
   ["property"] = "color",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Side Menu Sub Level Buttons --
  {
   ["element"] = ".pageButtonSub",
   ["property"] = "background",
   ["value"] = "#CFCFCF" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".pageButtonSub",
   ["property"] = "color",
   ["value"] = "#940C28" -- Color in Hex see https://www.color-hex.com/
  },
  -- Main Menu Sub Level Buttons on Mouse Over --
  {
   ["element"] = ".pageButtonSub:hover",
   ["property"] = "background",
   ["value"] = "#940C28" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".pageButtonSub:hover",
   ["property"] = "color",
   ["value"] = "#CFCFCF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Cancel Button --
  {
   ["element"] = ".cancel",
   ["property"] = "background",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".cancel",
   ["property"] = "color",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Cancel Button on Mouse Over --
  {
   ["element"] = ".cancel",
   ["property"] = "background",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".cancel",
   ["property"] = "color",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  -- Retract Button --
  {
   ["element"] = ".retract",
   ["property"] = "background",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".retract",
   ["property"] = "color",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  -- Retract Button on Mouse Over --
  {
   ["element"] = ".cancel",
   ["property"] = "background",
   ["value"] = "#EFEFEF" -- Color in Hex see https://www.color-hex.com/
  },
  {
   ["element"] = ".cancel",
   ["property"] = "color",
   ["value"] = "#DC143C" -- Color in Hex see https://www.color-hex.com/
  }
 } --]]
}