Config.Jobs = Config.Jobs or {}
Config.Jobs.cardealer = {
 ["jobGang"] = "job",
 ["label"] = "Vehicle Dealer",
 ["webHooks"] = {
  ["cardealer"] = ""
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
 ["plate"] = "DRV2", -- 4 Chars Max -- License Plate Prefix
 ["grades"] = {
  ['1'] = {
   ["name"] = "Recruit",
   ["payment"] = 50
  },
  ['2'] = {
   ["name"] = "Showroom Sales",
   ["payment"] = 75
  },
  ['3'] = {
   ["name"] = "Commercial Sales",
   ["payment"] = 100
  },
  ['4'] = {
   ["name"] = "Finance",
   ["payment"] = 125
  },
  ['5'] = {
   ["name"] = "Manager",
   ["payment"] = 150,
   ["isboss"] = true
  }
 },
 ["Locations"] = {
  ["management"] = {
   [1] = {
 ["Label"] = "Vehicle Dealer Management",
 coords = vector4(1214.51, 2744.16, 38.41, 324.68),
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
  ["stashes"] = {
   [1] = {
 ["label"] = "Vehicle Dealer Stash",
 ["coords"] = vector4(1226.37, 2742.82, 38.01, 205.11),
 ["blipName"] = "Vehicle Dealer Stash",
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
 ["label"] = "Vehicle Dealer Trash",
 ["coords"] = vector4(1211.82, 2745.88, 38.56, 351.34),
 ["blipName"] = "Vehicle Dealer Trash",
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
 ["isGang"] = false,
 ["coords"] = vector4(1228.2, 2741.99, 38.01, 178.82),
 ["width"] = 2,
 ["length"] = 2,
 ["cameraLocation"] = vector4(454.42, -990.52, 30.69, 358.48),
 ["blipName"] = "Vehicle Dealer Clothing",
 ["blipNumber"] = 366,
 ["blipColor"] = 81,
 ["blipDisplay"] = 5,
 ["blipScale"] = 0.4,
 ["blipShortRange"] = true
   }
  },
  ["stations"] = {
   [1] = {
 ["label"] = "Vehicle Dealer",
 ["public"] = true,
 ["coords"] = vector4(428.23, -984.28, 29.76, 3.5),
 ["blipName"] = "Vehicle Dealer",
 ["blipNumber"] = 225, -- https://docs.fivem.net/docs/game-references/blips/#blips
 ["blipColor"] = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
 ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
 ["blipScale"] = 0.6, -- set the size of the blip on the full size map
 ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
   }
  }
 },
 ["Outfits"] = {
  ['male'] = { -- Gender
   [0] = { -- Grade Level
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 28, texture = 0},  -- Pants
  ["arms"]  = { item = 1, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 31, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 294, texture = 0},  -- Jacket
  ["shoes"] = { item = 10, texture = 0},  -- Shoes
  ["accessory"]   = { item = 0, texture = 0},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = 12, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [1] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 28, texture = 0},  -- Pants
  ["arms"]  = { item = 1, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 31, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 294, texture = 0},  -- Jacket
  ["shoes"] = { item = 10, texture = 0},  -- Shoes
  ["accessory"]   = { item = 0, texture = 0},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = 12, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [2] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 28, texture = 0},  -- Pants
  ["arms"]  = { item = 1, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 31, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 294, texture = 0},  -- Jacket
  ["shoes"] = { item = 10, texture = 0},  -- Shoes
  ["accessory"]   = { item = 0, texture = 0},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = 12, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [3] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 28, texture = 0},  -- Pants
  ["arms"]  = { item = 1, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 31, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 294, texture = 0},  -- Jacket
  ["shoes"] = { item = 10, texture = 0},  -- Shoes
  ["accessory"]   = { item = 0, texture = 0},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = 12, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [4] = {
 [1] = {
  outfitLabel = 'Short Sleeve',
  outfitData = {
  ["pants"] = { item = 28, texture = 0},  -- Pants
  ["arms"]  = { item = 1, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 31, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 294, texture = 0},  -- Jacket
  ["shoes"] = { item = 10, texture = 0},  -- Shoes
  ["accessory"]   = { item = 0, texture = 0},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = 12, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   }
  },
  ['female'] = {
   [0] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 57, texture = 2},  -- Pants
  ["arms"]  = { item = 0, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 34, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 105, texture = 7},  -- Jacket
  ["shoes"] = { item = 8, texture = 5},  -- Shoes
  ["accessory"]   = { item = 11, texture = 3},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = -1, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [1] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 57, texture = 2},  -- Pants
  ["arms"]  = { item = 0, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 34, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 105, texture = 7},  -- Jacket
  ["shoes"] = { item = 8, texture = 5},  -- Shoes
  ["accessory"]   = { item = 11, texture = 3},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = -1, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [2] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 57, texture = 2},  -- Pants
  ["arms"]  = { item = 0, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 34, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 105, texture = 7},  -- Jacket
  ["shoes"] = { item = 8, texture = 5},  -- Shoes
  ["accessory"]   = { item = 11, texture = 3},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = -1, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [3] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 57, texture = 2},  -- Pants
  ["arms"]  = { item = 0, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 34, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 105, texture = 7},  -- Jacket
  ["shoes"] = { item = 8, texture = 5},  -- Shoes
  ["accessory"]   = { item = 11, texture = 3},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = -1, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   },
   [4] = {
 [1] = {
  outfitLabel = 'Worker',
  outfitData = {
  ["pants"] = { item = 57, texture = 2},  -- Pants
  ["arms"]  = { item = 0, texture = 0},  -- Arms
  ["t-shirt"]  = { item = 34, texture = 0},  -- T Shirt
  ["vest"]  = { item = 0, texture = 0},  -- Body Vest
  ["torso2"]   = { item = 105, texture = 7},  -- Jacket
  ["shoes"] = { item = 8, texture = 5},  -- Shoes
  ["accessory"]   = { item = 11, texture = 3},  -- Neck Accessory
  ["bag"]   = { item = 0, texture = 0},  -- Bag
  ["hat"]   = { item = -1, texture = -1},  -- Hat
  ["glass"] = { item = 0, texture = 0},  -- Glasses
  ["mask"]  = { item = 0, texture = 0},  -- Mask
  }
 }
   }
  }
 }
}