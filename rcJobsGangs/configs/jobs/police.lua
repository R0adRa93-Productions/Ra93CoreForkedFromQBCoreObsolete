Config.Jobs = Config.Jobs or {}
Config.Jobs.police = { -- name the job
 ["jobGang"] = "job",
 ["label"] = "Law Enforcement", -- label that display when typing in /job
 ["webHooks"] = {
  ["police"] = ""
 },
 ["type"] = "leo", -- job type
 ["defaultDuty"] = true, -- duty status when logged on
 ["offDutyPay"] = false, -- true get paid even off duty
 ["inCityHall"] = {
  ["listInCityHall"] = true, -- true he job is sent to city hall | false the job is not in city hall
  ["isManaged"] = true -- true the job is sent to the boss of the job | false the job is automatically assigned
 },

 ["plate"] = "POPO", -- 4 Chars Max -- License Plate Prefix
 ["DutyBlips"] = {
  ["enable"] = true, -- Enables the Duty Blip
  ["dynamic"] = true, -- Enables the Dynamic Blips
  ["type"] = "public", -- Service = Only for service members to view or Public for all people to view
  ["blipSpriteOnFoot"] = 1, -- https://docs.fivem.net/docs/game-references/blips/#blips
  ["blipSpriteInVehicle"] = 812, -- https://docs.fivem.net/docs/game-references/blips/#blips -- Dynamic Blipe Sprite
  ["blipSpriteColor"] = 38, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
  ["blipScale"] = 1, -- Size of the Blip on the minimap
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
 ["grades"] = {
  ['1'] = {
   ["name"] = "Recruit",
   ["payment"] = 50
  },
  ['2'] = {
   ["name"] = "Officer",
   ["payment"] = 75
  },
  ['3'] = {
   ["name"] = "Sergeant",
   ["payment"] = 100
  },
  ['4'] = {
   ["name"] = "Lieutenant",
   ["payment"] = 125
  },
  ['5'] = {
   ["name"] = "Chief",
   ["payment"] = 150,
   ["isboss"] = true
  }
 },
 ["Locations"] = {
  ["duty"] = {
   [1] = {
 ["Label"] = "Police Timeclock",
 ["coords"] = vector3(440.085, -974.924, 30.689),
 ["blipName"] = "Police Timeclock",
 ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
 ["polyZone"] = {
  ["drawDistance"] = 10.0,
  ["drawColor"] = vector4(127,0,255,255), -- Red, Green, Blue, Transparency use RGB value here https://www.colorspire.com/rgb-color-wheel/
  ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
  ["job"] = "type" -- type or job
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
  ["management"] = {
   [1] = {
 ["Label"] = "Police Management",
 coords = vector3(447.11, -974.16, 31.47),
 ["blipName"] = "Police Management",
 ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.4, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
 ["polyZone"] = {
  ["drawDistance"] = 10.0,
  ["drawColor"] = vector4(127,0,255,255), -- Red, Green, Blue, Transparency use RGB value here https://www.colorspire.com/rgb-color-wheel/
  ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
  ["job"] = "type" -- type or job
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
  ["garages"] = {
   [1] = {
 ["label"] = "Police Garage - LSPD - Mission Row",
 ["type"] = "vehicle", -- vehicle, boat, plane, helicopter
 ["takeVehicle"] = vector4(448.159, -1017.41, 28.562, 90.654),
 ["spawnPoint"] = vector4(448.159, -1017.41, 28.562, 90.654),
 ["putVehicle"] = vector4(448.159, -1017.41, 28.562, 90.654),
 ["blipName"] = "Police Garage",
 ["blipNumber"] = 357, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 81, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
 ["marker"] = {
  ["display"] = true, -- true = marker is displayed | false = marker is not displayed
  ["type"] = 36, -- Choose from this list: https://docs.fivem.net/docs/game-references/markers/
  ["scale"] = 0.5, -- Sets the size of the marker
  ["red"] = 255, -- digits 0 to 255 | use R value here https://www.colorspire.com/rgb-color-wheel/
  ["green"] = 127, -- digits 0 to 255 | use G value here https://www.colorspire.com/rgb-color-wheel/
  ["blue"] = 0, -- digits 0 to 255 | use B value here https://www.colorspire.com/rgb-color-wheel/
  ["alpha"] = 255,  -- sets how transparent the marker is. 0 completely transparent 255 not transparent at all
  ["bob"] = true, -- true marker bounces up and down | false marker does not bounce up and down
  ["rotate"] = true, -- true marker spins | false marker does not spin
  ["ents"] = true -- true marker appears over entities | false marker is hidden when entities are around
 }
   },
   [2] = {
 ["label"] = "Police Hanger LosSantos Airport",
 ["type"] = "plane",
 ["takeVehicle"] = vector3(-1142.08, -3401.8, 13.29),
 ["spawnPoint"] = vector4(-1133.08, -3368.46, 14.58, 333.24),
 ["putVehicle"] = vector3(-1155.72, -3377.5, 13.29),
 ["blipName"] = "Police Hanger",
 ["blipNumber"] = 359,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 33,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
   [3] = {
 ["label"] = "Police Hanger Grapeseed",
 ["type"] = "plane",
 ["takeVehicle"] = vector3(2146.81, 4811.76, 41.35),
 ["spawnPoint"] = vector4(2133.74, 4807.58, 41.72, 115.16),
 ["putVehicle"] = vector3(2113.41, 4799.07, 41.73),
 ["blipName"] = "Police Hanger",
 ["blipNumber"] = 359,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 33,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
   [4] = {
 ["label"] = "Police Hanger Sandy Shores",
 ["type"] = "plane",
 ["takeVehicle"] = vector3(1721.78, 3255.24, 41.15),
 ["spawnPoint"] = vector4(1710.97, 3252.41, 41.69, 105.83),
 ["putVehicle"] = vector3(1688.43, 3246.0, 41.49),
 ["blipName"] = "Police Hanger",
 ["blipNumber"] = 359,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 33,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
   [5] = {
 ["label"] = "Police Boatlaunch Alamo Sea",
 ["type"] = "boat",
 ["takeVehicle"] = vector3(1338.62, 4225.5, 33.92),
 ["spawnPoint"] = vector4(1339.18, 4233.37, 30.84, 267.0),
 ["putVehicle"] = vector3(1338.52, 4275.05, 30.61),
 ["blipName"] = "Police Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 35,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
   [6] = {
 ["label"] = "Police Boatlaunch Los Santos",
 ["type"] = "boat",
 ["takeVehicle"] = vector3(-932.08, -1477.43, 1.6),
 ["spawnPoint"] = vector4(-935.54, -1479.98, 0.31, 17.01),
 ["putVehicle"] = vector3(-883.38, -1461.01, 0.57),
 ["blipName"] = "Police Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 35,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
   [7] = {
 ["label"] = "Police Boatlaunch Paleto Cove",
 ["type"] = "boat",
 ["takeVehicle"] = vector3(-1605.8, 5257.9, 2.08),
 ["spawnPoint"] = vector4(-1603.61, 5260.97, 0.29, 22.87),
 ["putVehicle"] = vector3(-1622.73, 5228.14, 0.85),
 ["blipName"] = "Police Boatlaunch",
 ["blipNumber"] = 356,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 35,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
   [8] = {
 ["label"] = "Police Pad - LSPD - Mission Row",
 ["type"] = "helicopter",
 ["takeVehicle"] = vector3(449.31, -981.25, 43.69),
 ["spawnPoint"] = vector4(449.31, -981.25, 43.69, 75.32),
 ["putVehicle"] = vector3(449.31, -981.25, 43.69),
 ["blipName"] = "Police Pad",
 ["blipNumber"] = 360,
 ["blipColor"] = 81,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 34,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   },
  },
  ["stashes"] = {
   [1] = {
 ["label"] = "Police Stash - Mission Row - Los Santos Police",
 ["coords"] = vector3(459.78, -993.02, 30.69),
 ["blipName"] = "Police Stash",
 ["blipNumber"] = 187,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 30,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   }
  },
  ["armories"] = {
   [1] = {
 ["label"] = "Police Stash - Mission Row - Los Santos Police",
 ["coords"] = vector3(452.28, -980.15, 30.69),
 ["blipName"] = "Police Stash",
 ["blipNumber"] = 187,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 30,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   }
  },
  ["trash"] = {
   [1] = {
 ["label"] = "Police Trash - Mission Row - Los Santos Police",
 ["coords"] = vector3(439.0907, -976.746, 30.776),
 ["blipName"] = "Police Trash",
 ["blipNumber"] = 728,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true,
 ["marker"] = {
  ["display"] = true,
  ["type"] = 42,
  ["scale"] = 0.5,
  ["red"] = 255,
  ["green"] = 127,
  ["blue"] = 0,
  ["alpha"] = 255,
  ["bob"] = true,
  ["rotate"] = true,
  ["ents"] = true
 }
   }
  },
  ["outfits"] = {
   [1] = {
 ["jobType"] = "leo",
 ["isGang"] = false,
 ["coords"] = vector3(454.43, -988.85, 30.69),
 ["width"] = 2,
 ["length"] = 2,
 ["cameraLocation"] = vector4(454.42, -990.52, 30.69, 358.48),
 ["blipName"] = "Police Clothing",
 ["blipNumber"] = 366,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["stations"] = {
   [1] = {
 ["label"] = "Police Station - LSPD - Mission Row",
 ["public"] = true,
 ["coords"] = vector4(428.23, -984.28, 29.76, 3.5),
 ["blipName"] = "Police Station",
 ["blipNumber"] = 60, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   },
   [2] = {
 ["label"] = "Bolingbroke Penitentiary",
 ["public"] = true,
 ["coords"] = vector4(1845.903, 2585.873, 45.672, 272.249),
 ["blipName"] = "State Prison",
 ["blipNumber"] = 60,
 ["blipColor"] = 3,
 ["blipDisplay"] = 4,
 ["blipScale"] = 0.6,
 ["blipShortRange"] = true,
   }
  }
 },
 ["Vehicles"] = {
  [0] = { -- Job Rank ID
   ["polmav"] = { -- Spawn Code
 ["label"] = "Police Helicopter", -- Label for Spawner
 ["type"] = "helicopter" -- vehicle, boat, plane, helicopter
   },
   ["predator"] = {
 ["label"] = "Police Boat",
 ["type"] = "boat"
   },
   ["police"] = {
 ["label"] = "Police 1",
 ["type"] = "vehicle"
   },
   ["police2"] = {
 ["label"] = "Police 2",
 ["type"] = "vehicle"
   },
   ["police3"] = {
 ["label"] = "Police 3",
 ["type"] = "vehicle"
   },
   ["police4"] = {
 ["label"] = "Police 4",
 ["type"] = "vehicle"
   },
   ["policeb"] = {
 ["label"] = "Police b",
 ["type"] = "vehicle"
   },
   ["policet"] = {
 ["label"] = "Police t",
 ["type"] = "vehicle"
   }
  },
  [1] = {
   ["polmav"] = {
 ["label"] = "Police Helicopter",
 ["type"] = "helicopter"
   },
   ["predator"] = {
 ["label"] = "Police Boat",
 ["type"] = "boat"
   },
   ["police"] = {
 ["label"] = "Police 1",
 ["type"] = "vehicle"
   },
   ["police2"] = {
 ["label"] = "Police 2",
 ["type"] = "vehicle"
   },
   ["police3"] = {
 ["label"] = "Police 3",
 ["type"] = "vehicle"
   },
   ["police4"] = {
 ["label"] = "Police 4",
 ["type"] = "vehicle"
   },
   ["policeb"] = {
 ["label"] = "Police b",
 ["type"] = "vehicle"
   },
   ["policet"] = {
 ["label"] = "Police t",
 ["type"] = "vehicle"
   }
  },
  [2] = {
   ["polmav"] = {
 ["label"] = "Police Helicopter",
 ["type"] = "helicopter"
   },
   ["predator"] = {
 ["label"] = "Police Boat",
 ["type"] = "boat"
   },
   ["police"] = {
 ["label"] = "Police 1",
 ["type"] = "vehicle"
   },
   ["police2"] = {
 ["label"] = "Police 2",
 ["type"] = "vehicle"
   },
   ["police3"] = {
 ["label"] = "Police 3",
 ["type"] = "vehicle"
   },
   ["police4"] = {
 ["label"] = "Police 4",
 ["type"] = "vehicle"
   },
   ["policeb"] = {
 ["label"] = "Police b",
 ["type"] = "vehicle"
   },
   ["policet"] = {
 ["label"] = "Police t",
 ["type"] = "vehicle"
   }
  },
  [3] = {
   ["polmav"] = {
 ["label"] = "Police Helicopter",
 ["type"] = "helicopter"
   },
   ["predator"] = {
 ["label"] = "Police Boat",
 ["type"] = "boat"
   },
   ["police"] = {
 ["label"] = "Police 1",
 ["type"] = "vehicle"
   },
   ["police2"] = {
 ["label"] = "Police 2",
 ["type"] = "vehicle"
   },
   ["police3"] = {
 ["label"] = "Police 3",
 ["type"] = "vehicle"
   },
   ["police4"] = {
 ["label"] = "Police 4",
 ["type"] = "vehicle"
   },
   ["policeb"] = {
 ["label"] = "Police b",
 ["type"] = "vehicle"
   },
   ["policet"] = {
 ["label"] = "Police t",
 ["type"] = "vehicle"
   }
  },
  [4] = {
   ["polmav"] = {
 ["label"] = "Police Helicopter",
 ["type"] = "helicopter"
   },
   ["predator"] = {
 ["label"] = "Police Boat",
 ["type"] = "boat"
   },
   ["police"] = {
 ["label"] = "Police 1",
 ["type"] = "vehicle"
   },
   ["police2"] = {
 ["label"] = "Police 2",
 ["type"] = "vehicle"
   },
   ["police3"] = {
 ["label"] = "Police 3",
 ["type"] = "vehicle"
   },
   ["police4"] = {
 ["label"] = "Police 4",
 ["type"] = "vehicle"
   },
   ["policeb"] = {
 ["label"] = "Police b",
 ["type"] = "vehicle"
   },
   ["policet"] = {
 ["label"] = "Police t",
 ["type"] = "vehicle"
   }
  }
 },
 ["VehicleSettings"] = {
  ["police"] = { -- Spawn name
   ["extras"] = {
 [1] = 1, -- 0 = On | 1 = Off
 [2] = 1,
 [3] = 1,
 [4] = 1,
 [5] = 1,
 [6] = 1,
 [7] = 1,
 [8] = 1,
 [9] = 1,
 [10] = 1,
 [11] = 1,
 [12] = 1,
 [13] = 1
   },
   ["livery"] = 0 -- First Livery Starts At 0
  },
  ["polmav"] = { -- Spawn name
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
   ["livery"] = 0 -- First Livery Starts At 0
  }
 },
 ["Items"] = {
  ["stash"] = {}, -- copy design from one of the other items area.
  ["armory"] = {
   ["label"] = "Police Armory", -- name of armory
   ["slots"] = 30, -- how many slots for armory
   ["items"] = {
 [1] = {
  ["name"] = "weapon_pistol", -- item name from qb-core/shared/items.lua
  ["price"] = 0, -- price to sell to employee (can be set to 0 for free)
  ["amount"] = 1, -- quantity available in armory
  ["info"] = { -- get from qb-core/shared/items.lua
   ["serie"] = "",
   ["attachments"] = {
 {
  ["component"] = "COMPONENT_AT_PI_FLSH",
  ["label"] = "Flashlight",
 },
   }
  },
  ["type"] = "weapon", -- item or weapon
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4} -- Job Grades authorized to obtain item
 },
 [2] = {
  ["name"] = "weapon_stungun",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {
   ["serie"] = "",
  },
  ["type"] = "weapon",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [3] = {
  ["name"] = "weapon_pumpshotgun",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {
   ["serie"] = "",
   ["attachments"] = {
 {
  ["component"] = "COMPONENT_AT_AR_FLSH",
  ["label"] = "Flashlight",
 },
   }
  },
  ["type"] = "weapon",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [4] = {
  ["name"] = "weapon_smg",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {
   ["serie"] = "",
   ["attachments"] = {
 {
  ["component"] = "COMPONENT_AT_SCOPE_MACRO_02",
  ["label"] = "1x Scope",
 },
 {
  ["component"] = "COMPONENT_AT_AR_FLSH",
  ["label"] = "Flashlight",
 },
   }
  },
  ["type"] = "weapon",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [5] = {
  ["name"] = "weapon_carbinerifle",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {
   ["serie"] = "",
   ["attachments"] = {
 {
  ["component"] = "COMPONENT_AT_AR_FLSH",
  ["label"] = "Flashlight",
 },
 {
  ["component"] = "COMPONENT_AT_SCOPE_MEDIUM",
  ["label"] = "3x Scope",
 },
   }
  },
  ["type"] = "weapon",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [6] = {
  ["name"] = "weapon_nightstick",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {},
  ["type"] = "weapon",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [7] = {
  ["name"] = "pistol_ammo",
  ["price"] = 0,
  ["amount"] = 5,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [8] = {
  ["name"] = "smg_ammo",
  ["price"] = 0,
  ["amount"] = 5,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [9] = {
  ["name"] = "shotgun_ammo",
  ["price"] = 0,
  ["amount"] = 5,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [10] = {
  ["name"] = "rifle_ammo",
  ["price"] = 0,
  ["amount"] = 5,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [11] = {
  ["name"] = "handcuffs",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [12] = {
  ["name"] = "weapon_flashlight",
  ["price"] = 0,
  ["amount"] = 1,
  ["info"] = {},
  ["type"] = "weapon",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [13] = {
  ["name"] = "empty_evidence_bag",
  ["price"] = 0,
  ["amount"] = 50,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [14] = {
  ["name"] = "police_stormram",
  ["price"] = 0,
  ["amount"] = 50,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [15] = {
  ["name"] = "armor",
  ["price"] = 0,
  ["amount"] = 50,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [16] = {
  ["name"] = "radio",
  ["price"] = 0,
  ["amount"] = 50,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 },
 [17] = {
  ["name"] = "heavyarmor",
  ["price"] = 0,
  ["amount"] = 50,
  ["info"] = {},
  ["type"] = "item",
  ["authorizedJobGrades"] = {0, 1, 2, 3, 4}
 }
   }
  },
  ["trunk"] = { -- aka boot aka cargo hold aka cargo area aka cargo compartment
   [1] = {
 name = "heavyarmor", -- item name from qb-core/shared/items.lua
 amount = 2, -- Quantity in trunk
 info = {}, -- get from qb-core/shared/items.lua
 type = "item", -- item or weapon
 vehType = {"vehicle", "boat", "helicopter", "plane"}, -- Vehicle, Boat, Helicopter and/or Plane (any combo)
 authGrade = {0,1,2,3,4} -- Job Grades authorized to obtain item
   },
   [2] = {
 name = "empty_evidence_bag",
 amount = 10,
 info = {},
 type = "item",
 vehType = {"vehicle", "boat", "helicopter", "plane"},
 authGrade = {0,1,2,3,4}
   },
   [3] = {
 name = "police_stormram",
 amount = 1,
 info = {},
 type = "item",
 vehType = {"vehicle", "boat", "helicopter", "plane"},
 authGrade = {0,1,2,3,4}
   }
  },
  ["glovebox"] = { -- aka glove compartment
   [1] = {
 name = "empty_evidence_bag", -- item name from qb-core/shared/items.lua
 amount = 10, -- Quantity in trunk
 info = {}, -- get from qb-core/shared/items.lua
 type = "item", -- item or weapon
 vehType = {"vehicle", "boat", "helicopter", "plane"}, -- Vehicle, Boat, Helicopter and/or Plane (any combo)
 authGrade = {0,1,2,3,4} -- Job Grades authorized to obtain item
   }
  }
 },
 ["Outfits"] = {
  -- Job
  ["male"] = {
   -- Gender
   [0] = {
 -- Grade Level
 [1] = {
  -- Outfits
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 19,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 55,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 }
   },
   [1] = {
 -- Grade Level
 [1] = {
  -- Outfits
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 19,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 55,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 }
   },
   [2] = {
 -- Grade Level
 [1] = {
  -- Outfits
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 19,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 55,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [4] = {
  ["outfitLabel"] = "Trooper Black",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 3,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 }
   },
   [3] = {
 -- Grade Level
 [1] = {
  -- Outfits
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 19,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 55,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [4] = {
  ["outfitLabel"] = "Trooper Black",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 3,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [5] = {
  ["outfitLabel"] = "SWAT",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 130,
 ["texture"] = 1,
   },
   ["arms"] = {
 ["item"] = 172,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 15,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 15,
 ["texture"] = 2,
   },
   ["torso2"] = {
 ["item"] = 336,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 150,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 52,
 ["texture"] = 0,
   }
  }
 }
   },
   [4] = {
 -- Grade Level
 [1] = {
  -- Outfits
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 19,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 55,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = -1,
 ["texture"] = -1,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [4] = {
  ["outfitLabel"] = "Trooper Black",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 20,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 58,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 317,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 51,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 58,
 ["texture"] = 3,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [5] = {
  ["outfitLabel"] = "SWAT",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 130,
 ["texture"] = 1,
   },
   ["arms"] = {
 ["item"] = 172,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 15,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 15,
 ["texture"] = 2,
   },
   ["torso2"] = {
 ["item"] = 336,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 24,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 150,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 52,
 ["texture"] = 0,
   }
  }
 }
   }
  },
  ["female"] = {
   -- Gender
   [0] = {
 -- Grade Level
 [1] = {
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 48,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 }
   },
   -- Gender
   [1] = {
 -- Grade Level
 [1] = {
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 48,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 }
   },
   -- Gender
   [2] = {
 -- Grade Level
 [1] = {
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 48,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [4] = {
  ["outfitLabel"] = "Trooper Black",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 }
   },
   -- Gender
   [3] = {
 -- Grade Level
 [1] = {
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 48,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [4] = {
  ["outfitLabel"] = "Trooper Black",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [5] = {
  ["outfitLabel"] = "Swat",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 135,
 ["texture"] = 1,
   },
   ["arms"] = {
 ["item"] = 213,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 17,
 ["texture"] = 2,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 102,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 149,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 35,
 ["texture"] = 0,
   }
  }
 }
   },
   -- Gender
   [4] = {
 -- Grade Level
 [1] = {
  ["outfitLabel"] = "Short Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 48,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [2] = {
  ["outfitLabel"] = "Long Sleeve",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 0,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [3] = {
  ["outfitLabel"] = "Trooper Tan",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 3,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [4] = {
  ["outfitLabel"] = "Trooper Black",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 133,
 ["texture"] = 0,
   },
   ["arms"] = {
 ["item"] = 31,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 35,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 34,
 ["texture"] = 0,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 0,
 ["texture"] = 0,
   }
  }
 },
 [5] = {
  ["outfitLabel"] = "Swat",
  ["outfitData"] = {
   ["pants"] = {
 ["item"] = 135,
 ["texture"] = 1,
   },
   ["arms"] = {
 ["item"] = 213,
 ["texture"] = 0,
   },
   ["t-shirt"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["vest"] = {
 ["item"] = 17,
 ["texture"] = 2,
   },
   ["torso2"] = {
 ["item"] = 327,
 ["texture"] = 8,
   },
   ["shoes"] = {
 ["item"] = 52,
 ["texture"] = 0,
   },
   ["accessory"] = {
 ["item"] = 102,
 ["texture"] = 0,
   },
   ["bag"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["hat"] = {
 ["item"] = 149,
 ["texture"] = 0,
   },
   ["glass"] = {
 ["item"] = 0,
 ["texture"] = 0,
   },
   ["mask"] = {
 ["item"] = 35,
 ["texture"] = 0,
   }
  }
 }
   }
  }
 }
}
