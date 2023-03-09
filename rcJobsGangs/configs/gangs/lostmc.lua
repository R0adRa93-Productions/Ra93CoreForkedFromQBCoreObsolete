Config.Gangs = Config.Gangs or {}
Config.Gangs.lostmc = { -- name the job no spaces ex. Config.Gangs.newJobName
 ["jobGang"] = "Gangs", -- set to Jobs or Gangs
 ["bosses"] = { -- Citizen IDs of the Bosses of this Job
  ["ALA01454"] = "ALA01454"
 },
 ["webHooks"] = {
  ["lostmc"] = ""
 },
 ["label"] = "The Lost MC", -- label that display when typing in /job
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
   ["blacklist"] = "fa-solid fa-ban",
   ["approve"] = "fa-regular fa-circle-check",
   ["award"] = "fa-solid fa-medal",
   ["boat"] = "fa-solid fa-ship",
--   ["close"] = "fa-regular fa-circle-xmark",
   ["close"] = "fa-solid fa-x",
   ["currentGang"] = "fa-solid fa-vest-patches",
   ["demote"] = "fa-regular fa-thumbs-down",
   ["deniedApplicant"] = "fa-solid fa-user-slash",
   ["deniedApplicants"] = "fa-solid fa-users-slash",
   ["deny"] = "fa-regular fa-circle-xmark",
   ["member"] = "fa-solid fa-user",
   ["members"] = "fa-solid fa-users",
   ["fire"] = "fa-solid fa-ban",
   ["helicopter"] = "fa-solid fa-helicopter",
   ["jobGarage"] = "fa-solid fa-square-parking",
   ["jobHistory"] = "fa-regular fa-address-card",
   ["jobStore"] = "fa-solid fa-store",
   ["ownGarage"] = "fa-solid fa-warehouse",
   ["pastMember"] = "fa-solid fa-user-slash",
   ["pastMembers"] = "fa-solid fa-users-slash",
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
   ["vehicle"] = "fa-solid fa-motorcycle",
   ["quit"] = "fa-regular fa-circle-xmark"
  },
  ["text"] = {
   ["members"] = "Members",
   ["pastMembers"] = "Past Members"
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
   [1] = {
 ["label"] = "Lost MC Base",
 ["public"] = true, -- true station is displayed for all players | false = station is displayed just for the player
 ["coords"] = vector4(961.14, -138.92, 74.46, 162.25),
 ["blipName"] = "LostMC",
 ["blipNumber"] = 229, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 56, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  },
  ["management"] = { -- location of boss' management station
   [1] = {
 ["Label"] = "Management",
 ["ped"] = {
  ["model"] = "g_f_y_lost_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(977.1, -105.3, 74.85, 38.71),
  ["targetIcon"] = "fa-solid fa-bars-progress", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "4",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Lost MC Management",
 ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 56, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  },
  ["garages"] = {
   [1] = {
 ["label"] = "Garage",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(959.83, -120.76, 74.96, 138.18),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "4",
   ["width"] = "4"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(961.39, -137.74, 74.46, 147.16), -- spawn vehicle locations
   ["type"] = "vehicle" -- vehicle, boat, plane, helicopter
  },
  {
   ["coords"] = vector4(964.86, -133.03, 74.4, 150.07),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(968.2, -127.53, 74.39, 141.54),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(972.38, -122.62, 74.35, 139.35),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(976.2, -118.25, 74.3, 138.69),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(980.1, -114.19, 74.23, 134.19),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(984.12, -110.07, 74.29, 132.41),
   ["type"] = "vehicle"
  }
 },
 ["blipName"] = "Lost MC Garage",
 ["blipNumber"] = 357, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 56, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   },
   [2] = {
 ["label"] = "LostMC LosSantos Airport",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03",
  ["coords"] = vector4(-1199.99, -2793.35, 13.95, 349.23),
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
 ["blipColor"] = 56,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [3] = {
 ["label"] = "LostMC Hanger Grapeseed",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03",
  ["coords"] = vector4(2142.41, 4834.57, 41.64, 243.01),
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
 ["blipColor"] = 56,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [4] = {
 ["label"] = "LostMC Hanger Sandy Shores",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03",
  ["coords"] = vector4(1692.33, 3294.71, 41.15, 265.55),
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
 ["blipColor"] = 56,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [5] = {
 ["label"] = "LostMC Boatlaunch Alamo Sea",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03",
  ["coords"] = vector4(1327.04, 4228.76, 35.02, 95.4),
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
 ["blipColor"] = 56,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [6] = {
 ["label"] = "LostMC Boatlaunch Los Santos",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03",
  ["coords"] = vector4(-784.32, -1465.93, 5.0, 62.39),
  ["targetIcon"] = "fa-solid fa-warehouse", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["spawnPoint"] = {
  {
   ["coords"] = vector4(-805.02, -1493.07, 0.3, 107.79),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(-803.5, -1499.63, 0.31, 108.79),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(-800.99, -1509.95, 0.3, 109.2),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(-798.55, -1515.55, 0.3, 109.35),
   ["type"] = "boat"
  },
  {
   ["coords"] = vector4(-681.51, -1399.62, 4.77, 86.00),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-681.51, -1403.71, 4.77, 86.00),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-681.51, -1407.9, 4.77, 86.00),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-681.51, -1412.13, 4.77, 86.00),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-681.51, -1416.12, 4.77, 86.00),
   ["type"] = "vehicle"
  },
  {
   ["coords"] = vector4(-724.83, -1443.45, 5.39, 147.9),
   ["type"] = "helicopter"
  },
  {
   ["coords"] = vector4(-699.91, -1448.09, 4.72, 51.08),
   ["type"] = "helicopter"
  },
  {
   ["coords"] = vector4(-763.09, -1452.8, 4.72, 229.94),
   ["type"] = "helicopter"
  },
  {
   ["coords"] = vector4(-746.55, -1433.34, 4.71, 229.47),
   ["type"] = "helicopter"
  },
  {
   ["coords"] = vector4(-745.11, -1468.38, 4.71, 319.6),
   ["type"] = "helicopter"
  }
 },
 ["blipName"] = "Hospital Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 56,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   },
   [7] = {
 ["label"] = "LostMC Boatlaunch Paleto Cove",
 ["ped"] = {
  ["model"] = "g_m_y_lost_03",
  ["coords"] = vector4(-1600.84, 5204.38, 4.31, 32.23),
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
 ["blipName"] = "LostMC Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 56,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true
   }
  },
  ["shops"] = { -- Used to be called Armory but is better used as a shop
   [1] = {
 ["label"] = "Supplier",
 ["ped"] = {
  ["model"] = "g_m_y_lost_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(987.97, -94.93, 74.85, 227.27),
  ["targetIcon"] = "fa-solid fa-shop", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "4",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Lost MC Supplier",
 ["blipNumber"] = 187,
 ["blipColor"] = 56,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["stashes"] = { -- player's personal locker area
   [1] = {
 ["label"] = "Personal Stash",
 ["ped"] = {
  ["model"] = "g_m_y_lost_02", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(984.82, -89.94, 74.85, 193.08),
  ["targetIcon"] = "fa-solid fa-boxes-stacked", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Lost MC Personal Stash",
 ["blipNumber"] = 187,
 ["blipColor"] = 56,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["trash"] = {
   [1] = {
 ["label"] = "Cleaning Lady",
 ["ped"] = {
  ["model"] = "g_f_y_lost_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(980.33, -92.9, 74.85, 179.2),
  ["targetIcon"] = "fa-regular fa-trash-can", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Lost MC Trash",
 ["blipNumber"] = 728,
 ["blipColor"] = 56,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true,
   }
  },
  ["lockers"] = { -- Locker shared with all members in job (great for evidence locker or patient belongings locker)
   {
 ["label"] = "Group Loot",
 ["ped"] = {
  ["model"] = "g_m_y_lost_02", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(974.4, -95.76, 74.85, 249.45),
  ["targetIcon"] = "fa-solid fa-file-shield", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["blipName"] = "Lost MC Loot",
 ["blipNumber"] = 134,
 ["blipColor"] = 56,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["outfits"] = {
   {
 ["jobType"] = "gang",
 ["isGang"] = true,
 ["ped"] = {
  ["model"] = "g_f_y_lost_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
  ["coords"] = vector4(983.98, -97.82, 74.85, 202.39),
  ["targetIcon"] = "fa-solid fa-shirt", -- Font Awesome Icon https://fontawesome.com/icons
  ["drawDistance"] = 2.0,
  ["zoneOptions"] = {
   ["length"] = "2",
   ["width"] = "2"
  }
 },
 ["width"] = 2,
 ["length"] = 2,
 ["cameraLocation"] = vector4(985.38, -97.54, 74.85, 179.97),
 ["blipName"] = "Lost MC Colors",
 ["blipNumber"] = 366,
 ["blipColor"] = 56,
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
   ["plate"] = "MC", -- 4 Chars Max -- License Plate Prefix
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
   ["bati"] = { -- Spawn Code
 ["label"] = "bati", -- Label for Spawner
 ["type"] = "vehicle", -- vehicle, boat, plane, helicopter
 ["depositPrice"] = 250, -- price of the vehicle deposit
 ["rentPrice"] = 250, -- price of the rental
 ["parkingPrice"] = 125, -- price to check out owned vehicle
 ["purchasePrice"] = 4500, -- price to own vehicle
 ["icon"] = "fa-solid fa-truck-medical", -- https://fontawesome.com/icons
 ["authGrades"] = {1,2,3,4}, -- Authorized Grades for Vehicle
 ["settings"] = {
  {
   ["grades"] = {1,2,3,4},
   ["livery"] = 0, -- First Livery Starts At 0
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
  }
 }
   },
   ["frogger"] = {
 ["label"] = "Frogger",
 ["type"] = "helicopter",
 ["rentPrice"] = 250,
 ["parkingPrice"] = 125,
 ["purchasePrice"] = 3000000,
 ["icon"] = "fa-solid fa-helicopter",
 ["authGrades"] = {1,2,3,4},
 ["settings"] = {
  {
   ["grades"] = {1,2,3,4},
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
   },
   ["longfin"] = {
 ["label"] = "Longfin",
 ["type"] = "boat",
 ["rentPrice"] = 250,
 ["parkingPrice"] = 125,
 ["purchasePrice"] = 1593750,
 ["icon"] = "fa-solid fa-ship",
 ["authGrades"] = {1,2,3,4},
 ["settings"] = {
  {
   ["grades"] = {1,2,3,4},
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
   ["livery"] = 0
  }
 }
   },
   ["alphaz1"] = {
 ["label"] = "alphaz1",
 ["type"] = "plane",
 ["rentPrice"] = 250,
 ["parkingPrice"] = 125,
 ["purchasePrice"] = 1593750,
 ["icon"] = "fa-solid fa-ship",
 ["authGrades"] = {1,2,3,4},
 ["settings"] = {
  {
   ["grades"] = {1,2,3,4},
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
   ["livery"] = 0
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