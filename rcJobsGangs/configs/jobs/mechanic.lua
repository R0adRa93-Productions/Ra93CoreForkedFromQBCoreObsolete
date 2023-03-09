Config.Jobs = Config.Jobs or {}
Config.Jobs.mechanic = {
 ["jobGang"] = "job",
 ["label"] = "mechanic",
 ["webHooks"] = {
  ["mechanic"] = ""
 },
 ["defaultDuty"] = true,
 ["offDutyPay"] = false,
 ["inCityHall"] = {
  ["listInCityHall"] = true, -- true he job is sent to city hall | false the job is not in city hall
  ["isManaged"] = true -- true the job is sent to the boss of the job | false the job is automatically assigned
 },
 ["menu"] = {
  ["icons"] = {
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
  },
 },

 ["plate"] = "BRKN", -- 4 Chars Max -- License Plate Prefix
 ["grades"] = {
  ['1'] = {
   ["name"] = "Apprentice",
   ["payment"] = 50
  },
  ['2'] = {
   ["name"] = "Service Tech",
   ["payment"] = 75
  },
  ['3'] = {
   ["name"] = "Mechanic",
   ["payment"] = 100
  },
  ['4'] = {
   ["name"] = "Master Mechanic",
   ["payment"] = 125
  },
  ['5'] = {
   ["name"] = "Manager",
   ["payment"] = 150,
   ["isboss"] = true
  }
 },
 ["Locations"] = {
  ["duty"] = {
   [1] = {
 ["Label"] = "Mechanic Timeclock",
 ["coords"] = vector3(-323.39, -129.6, 39.01),
 ["blipName"] = "Mechanic Timeclock",
 ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 9, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
 ["polyZone"] = {
  ["drawDistance"] = 10.0,
  ["drawColor"] = vector4(127,0,255,255), -- Red, Green, Blue, Transparency use RGB value here https://www.colorspire.com/rgb-color-wheel/
  ["targetIcon"] = "fa fa-power-off", -- Font Awesome Icon https://fontawesome.com/v4/icons/
  ["job"] = "job" -- type or job
 },
 ["marker"] = {
  ["display"] = true, -- true = marker is displayed | false = marker is not displayed
  ["type"] = 0, -- Choose from this list: https://docs.fivem.net/docs/game-references/markers/
  ["scale"] = 0.5, -- Sets the size of the marker
  ["red"] = 255, -- digits 0 to 255 | use R value here https://www.colorspire.com/rgb-color-wheel/
  ["green"] = 127, -- digits 0 to 255 | use G value here https://www.colorspire.com/rgb-color-wheel/
  ["blue"] = 0, -- digits 0 to 255 | use B value here https://www.colorspire.com/rgb-color-wheel/
  ["alpha"] = 255,  -- sets how transparent the marker is. 0 completely transparent 255 not transparent at all
  ["bob"] = true, -- true marker bounces up and down | false marker does not bounce up and down
  ["rotate"] = true, -- true marker spins | false marker does not spin
  ["ents"] = true -- true marker appears over entities | false marker is hidden when entities are around
 }

   }
  },
  ["armories"] = { -- can be used as a supply closet not just weapons
   {
 ["label"] = "Mechanic Supplies - Garage 1",
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
 ["blipName"] = "Mechanic Supplies",
 ["blipNumber"] = 187,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
 },
 ["Items"] = {
  ["armoryLabel"] = "Medical Supply Cabinet", -- name of armory
  ["slots"] = 30, -- how many slots for armory
  ["items"] = {
   {
 ["name"] = "radio", -- item name from items.lua
 ["price"] = 0, -- item price if you wish to charge to take it out
 ["amount"]  = 1, -- quantity in the location
 ["info"] = {}, -- information about the item from items.lua
 ["type"] = "item", -- item or weapon reference items.lua
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"}, -- vehicle, boat, plane, and/or helicopter
 ["locations"] = {'armory','glovebox'}, -- armory, glovebox and/or trunk
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "bandage",
 ["price"] = 0,
 ["amount"]  = 5,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'armory','trunk'},
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "painkillers",
 ["price"] = 0,
 ["amount"]  = 10,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'armory','trunk'},
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "firstaid",
 ["price"] = 0,
 ["amount"]  = 10,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'armory','trunk'},
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "weapon_flashlight",
 ["price"] = 0,
 ["amount"]  = 1,
 ["info"] = {},
 ["type"] = "weapon",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'armory','glovebox'},
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "weapon_fireextinguisher",
 ["price"] = 0,
 ["amount"]  = 1,
 ["info"] = {},
 ["type"] = "weapon",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'armory','trunk'},
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   },
   {
 ["name"] = "heavyarmor",
 ["price"] = 0,
 ["amount"]  = 2,
 ["info"] = {},
 ["type"] = "item",
 ["vehType"] = {"vehicle", "boat", "helicopter", "plane"},
 ["locations"] = {'armory','trunk'},
 ["authorizedJobGrades"] = {1,2,3,4,5,6}
   }
  }
 },
}
