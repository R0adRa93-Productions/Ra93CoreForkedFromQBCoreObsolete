--#region Variables

local Ra93Core = exports['rcCore']:getCoreObject()
local drops = {}
local trunks = {}
local gloveboxes = {}
local stashes = {}
local shopItems = {}

--#endregion Variables

--#region Functions

---Loads the inventory for the player with the citizenid that is provided
---@param source number Source of the player
---@param citizenid string CitizenID of the player
---@return { [number]: { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } } loadedInventory Table of items with slot as index
local function loadInventory(source, citizenid)
 local inventory = MySQL.prepare.await('SELECT inventory FROM players WHERE citizenid = ?', { citizenid })
 local loadedInventory = {}
 local missingItems = {}
 if not inventory then return loadedInventory end
 inventory = json.decode(inventory)
 if not next(inventory) then return loadedInventory end
 for _, item in pairs(inventory) do
  if item then
   local itemInfo = QBCore.Shared.Items[item.name:lower()]
   if itemInfo then
    loadedInventory[item.slot] = {
     name = itemInfo['name'],
     quantity = item.quantity,
     info = item.info or '',
     label = itemInfo['label'],
     description = itemInfo['description'] or '',
     weight = itemInfo['weight'],
     type = itemInfo['type'],
     unique = itemInfo['unique'],
     useable = itemInfo['useable'],
     image = itemInfo['image'],
     shouldClose = itemInfo['shouldClose'],
     slot = item.slot,
     combinable = itemInfo['combinable']
    }
   else
    missingItems[#missingItems + 1] = item.name:lower()
   end
  end
 end
 if #missingItems > 0 then print(("The following items were removed for player %s as they no longer exist"):format(GetplayerName(source))) end
 return loadedInventory
end

---Saves the inventory for the player with the provided source or playerData is they're offline
---@param source number | table Source of the player, if offline, then provide the playerData in this argument
---@param offline boolean Is the player offline or not, if true, it will expect a table in source
local function saveInventory(source, offline)
 local playerData, items,  itemsJson
 if not offline then
  local player = Ra93Core.functions.getplayer(source)
  if not player then return end
  playerData = player.playerData
  -- for offline users, the playerdata gets sent over the source variable
 else playerData = source end
 items = playerData.items
 if items and next(items) then
  for slot, item in pairs(items) do
   if items[slot] then
     itemsJson[#itemsJson+1] = {
     name = item.name,
     quantity = item.quantity,
     info = item.info,
     type = item.type,
     slot = slot,
    }
   end
  end
  itemsJson = json.encode( itemsJson)
 else itemsJson = "[]" end
 MySQL.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', {itemsJson, playerData.citizenid})
end

---Gets the totalweight of the items provided
---@param items { [number]: { quantity: number, weight: number } } Table of items, usually the inventory table of the player
---@return number weight Total weight of param items
local function getTotalWeight(items)
 local weight = 0
 if not items then return 0 end
 for _, item in pairs(items) do weight += tonumber(item.weight) * tonumber(item.quantity) end
 return weight
end

---Gets the slots that the provided item is in
---@param items { [number]: { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } } Table of items, usually the inventory table of the player
---@param itemName string Name of the item to the get the slots from
---@return number[] slotsFound Array of slots that were found for the item
local function getSlotsByItem(items, itemName)
 local slotsFound = {}
 if not items then return slotsFound end
 for slot, item in pairs(items) do
  if item.name:lower() == itemName:lower() then slotsFound[#slotsFound+1] = slot end
 end
 return slotsFound
end

---Get the first slot where the item is located
---@param items { [number]: { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } } Table of items, usually the inventory table of the player
---@param itemName string Name of the item to the get the slot from
---@return number | nil slot If found it returns a number representing the slot, otherwise it sends nil
local function getFirstSlotByItem(items, itemName)
 if not items then return nil end
 for slot, item in pairs(items) do
  if item.name:lower() == itemName:lower() then
   return tonumber(slot)
  end
 end
 return nil
end

---Add an item to the inventory of the player
---@param source number The source of the player
---@param item string The item to add to the inventory
---@param quantity? number The quantity of the item to add
---@param slot? number The slot to add the item to
---@param info? table Extra info to add onto the item to use whenever you get the item
---@return boolean success Returns true if the item was added, false it the item couldn't be added
local function addItem(source, item, quantity, slot, info)
 local player = Ra93Core.functions.getplayer(source)
 if not player then return false end
 local totalWeight = getTotalWeight(player.playerData.items)
 local itemInfo = QBCore.Shared.Items[item:lower()]
 if not itemInfo and not player.Offline then
  Ra93Core.functions.notify(source, "Item does not exist", 'error')
  return false
 end
 quantity = tonumber(quantity) or 1
 slot = tonumber(slot) or getFirstSlotByItem(player.playerData.items, item)
 info = info or {}
 if itemInfo['type'] == 'weapon' then
  info.serie = info.serie or tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
  info.quality = info.quality or 100
 end
 if (totalWeight + (itemInfo['weight'] * quantity)) <= Config.MaxInventoryWeight then
  if (slot and player.playerData.items[slot]) and (player.playerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) then
   player.playerData.items[slot].quantity = player.playerData.items[slot].quantity + quantity
   player.Functions.SetplayerData("items", player.playerData.items)
   if player.Offline then return true end
   TriggerEvent('qb-log:server:createLog', 'playerinventory', 'addItem', 'green', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. player.playerData.items[slot].name .. ', added quantity: ' .. quantity .. ', new total quantity: ' .. player.playerData.items[slot].quantity)
   return true
  elseif not itemInfo['unique'] and slot or slot and player.playerData.items[slot] == nil then
   player.playerData.items[slot] = { name = itemInfo['name'], quantity = quantity, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = slot, combinable = itemInfo['combinable'] }
   player.Functions.SetplayerData("items", player.playerData.items)
   if player.Offline then return true end
   TriggerEvent('qb-log:server:createLog', 'playerinventory', 'addItem', 'green', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. player.playerData.items[slot].name .. ', added quantity: ' .. quantity .. ', new total quantity: ' .. player.playerData.items[slot].quantity)
   return true
  elseif itemInfo['unique'] or (not slot or slot == nil) or itemInfo['type'] == 'weapon' then
   for i = 1, Config.MaxInventorySlots, 1 do
    if player.playerData.items[i] == nil then
     player.playerData.items[i] = { name = itemInfo['name'], quantity = quantity, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'] }
     player.Functions.SetplayerData("items", player.playerData.items)
     if player.Offline then return true end
     TriggerEvent('qb-log:server:createLog', 'playerinventory', 'addItem', 'green', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. player.playerData.items[i].name .. ', added quantity: ' .. quantity .. ', new total quantity: ' .. player.playerData.items[i].quantity)
     return true
    end
   end
  end
 elseif not player.Offline then
  Ra93Core.functions.notify(source, "Inventory too full", 'error')
 end
 return false
end

---Remove an item from the inventory of the player
---@param source number The source of the player
---@param item string The item to remove from the inventory
---@param quantity? number The quantity of the item to remove
---@param slot? number The slot to remove the item from
---@return boolean success Returns true if the item was remove, false it the item couldn't be removed
local function removeItem(source, item, quantity, slot)
 local player = Ra93Core.functions.getplayer(source)
 if not player then return false end
 quantity = tonumber(quantity) or 1
 slot = tonumber(slot)
 if slot then
  if player.playerData.items[slot].quantity > quantity then
   player.playerData.items[slot].quantity = player.playerData.items[slot].quantity - quantity
   player.Functions.SetplayerData("items", player.playerData.items)
   if not player.Offline then
    TriggerEvent('qb-log:server:createLog', 'playerinventory', 'removeItem', 'red', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. player.playerData.items[slot].name .. ', removed quantity: ' .. quantity .. ', new total quantity: ' .. player.playerData.items[slot].quantity)
   end

   return true
  elseif player.playerData.items[slot].quantity == quantity then
   player.playerData.items[slot] = nil
   player.Functions.SetplayerData("items", player.playerData.items)

   if player.Offline then return true end

   TriggerEvent('qb-log:server:createLog', 'playerinventory', 'removeItem', 'red', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. item .. ', removed quantity: ' .. quantity .. ', item removed')

   return true
  end
 else
  local slots = getSlotsByItem(player.playerData.items, item)
  local quantityToRemove = quantity

  if not slots then return false end

  for _, _slot in pairs(slots) do
   if player.playerData.items[_slot].quantity > quantityToRemove then
    player.playerData.items[_slot].quantity = player.playerData.items[_slot].quantity - quantityToRemove
    player.Functions.SetplayerData("items", player.playerData.items)

    if not player.Offline then
     TriggerEvent('qb-log:server:createLog', 'playerinventory', 'removeItem', 'red', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. _slot .. '], itemname: ' .. player.playerData.items[_slot].name .. ', removed quantity: ' .. quantity .. ', new total quantity: ' .. player.playerData.items[_slot].quantity)
    end

    return true
   elseif player.playerData.items[_slot].quantity == quantityToRemove then
    player.playerData.items[_slot] = nil
    player.Functions.SetplayerData("items", player.playerData.items)

    if player.Offline then return true end

    TriggerEvent('qb-log:server:createLog', 'playerinventory', 'removeItem', 'red', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. _slot .. '], itemname: ' .. item .. ', removed quantity: ' .. quantity .. ', item removed')

    return true
   end
  end
 end
 return false
end


---Get the item with the slot
---@param source number The source of the player to get the item from the slot
---@param slot number The slot to get the item from
---@return { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } | nil item Returns the item table, if there is no item in the slot, it will return nil
local function getItemBySlot(source, slot)
 local player = Ra93Core.functions.getplayer(source)
 return player.playerData.items[slot]
end


---Get the item from the inventory of the player with the provided source by the name of the item
---@param source number The source of the player
---@param item string The name of the item to get
---@return { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } | nil item Returns the item table, if the item wasn't found, it will return nil
local function getItemByName(source, item)
 local player = Ra93Core.functions.getplayer(source)
 item = tostring(item):lower()
 local slot = getFirstSlotByItem(player.playerData.items, item)
 return player.playerData.items[slot]
end

---Get the item from the inventory of the player with the provided source by the name of the item in an array for all slots that the item is in
---@param source number The source of the player
---@param item string The name of the item to get
---@return { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table }[] item Returns an array of the item tables found, if the item wasn't found, it will return an empty table
local function getItemsByName(source, item)
 local player = Ra93Core.functions.getplayer(source)
 item = tostring(item):lower()
 local items = {}
 local slots = getSlotsByItem(player.playerData.items, item)
 for _, slot in pairs(slots) do
  if slot then
   items[#items+1] = player.playerData.items[slot]
  end
 end
 return items
end

---Clear the inventory of the player with the provided source and filter any items out of the clearing of the inventory to keep (optional)
---@param source number Source of the player to clear the inventory from
---@param filterItems? string | string[] Array of item names to keep
local function clearInventory(source, filterItems)
 local player = Ra93Core.functions.getplayer(source)
 local savedItemData = {}

 if filterItems then
  local filterItemsType = type(filterItems)
  if filterItemsType == "string" then
   local item = getItemByName(source, filterItems)

   if item then
    savedItemData[item.slot] = item
   end
  elseif filterItemsType == "table" and type(filterItems) == "array" then
   for i = 1, #filterItems do
    local item = getItemByName(source, filterItems[i])
    if item then
     savedItemData[item.slot] = item
    end
   end
  end
 end
 player.Functions.SetplayerData("items", savedItemData)
 if player.Offline then return end
 TriggerEvent('qb-log:server:createLog', 'playerinventory', 'clearInventory', 'red', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** inventory cleared')
end

---Sets the items playerdata to the provided items param
---@param source number The source of player to set it for
---@param items { [number]: { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } } Table of items, the inventory table of the player
local function setInventory(source, items)
 local player = Ra93Core.functions.getplayer(source)
 player.Functions.SetplayerData("items", items)
 if player.Offline then return end
 TriggerEvent('qb-log:server:createLog', 'playerinventory', 'setInventory', 'blue', '**' .. GetplayerName(source) .. ' (citizenid: ' .. player.playerData.citizenid .. ' | id: ' .. source .. ')** items set: ' .. json.encode(items))
end

---Set the data of a specific item
---@param source number The source of the player to set it for
---@param itemName string Name of the item to set the data for
---@param key string Name of the data index to change
---@param val any Value to set the data to
---@return boolean success Returns true if it worked
local function setItemData(source, itemName, key, val)
 if not itemName or not key then return false end
 local player = Ra93Core.functions.getplayer(source)
 if not player then return false end
 local item = getItemByName(source, itemName)
 if not item then return false end
 item[key] = val
 player.playerData.items[item.slot] = item
 player.Functions.SetplayerData("items", player.playerData.items)
 return true
end

---Checks if you have an item or not
---@param source number The source of the player to check it for
---@param items string | string[] | table<string, number> The items to check, either a string, array of strings or a key-value table of a string and number with the string representing the name of the item and the number representing the quantity
---@param quantity? number The quantity of the item to check for, this will only have effect when items is a string or an array of strings
---@return boolean success Returns true if the player has the item
local function hasItem(source, items, quantity)
 local player = Ra93Core.functions.getplayer(source)
 if not player then return false end
 local isTable = type(items) == 'table'
 local isArray = isTable and type(items) == 'array' or false
 local totalItems = #items
 local count = 0
 local kvIndex = 2
 if type(items) == "string" then
  local item = getItemByName(source, items)
  if item and (not quantity or (item and quantity and item.quantity >= quantity)) then
   return true
  end
 end
 if isTable and not isArray then
  totalItems = 0
  for _ in pairs(items) do totalItems += 1 end
  kvIndex = 1
 end
 if isTable then
  for k, v in pairs(items) do
   local itemKV = {k, v}
   local item = getItemByName(source, itemKV[kvIndex])
   if item and ((quantity and item.quantity >= quantity) or (not isArray and item.quantity >= v) or (not quantity and isArray)) then
    count += 1
   end
  end
  if count == totalItems then return true end
 else -- Single item as string
 end
 return false
end

---Use an item from the QBCore.UsableItems table if a callback is present
---@param itemName string The name of the item to use
---@param ... any Arguments for the callback, this will be sent to the callback and can be used to get certain values
local function useItem(itemName, ...)
 local itemData = Ra93Core.functions.canuseItem(itemName)
 local callback = type(itemData) == 'table' and (rawget(itemData, '__cfx_functionReference') and itemData or itemData.cb or itemData.callback) or type(itemData) == 'function' and itemData
 if not callback then return end
 callback(...)
end

---Check if a recipe contains the item
---@param recipe table The recipe of the item
---@param fromItem { name: string, quantity: number, info?: table, label: string, description: string, weight: number, type: string, unique: boolean, useable: boolean, image: string, shouldClose: boolean, slot: number, combinable: table } The item to check
---@return boolean success Returns true if the recipe contains the item
local function recipeContains(recipe, fromItem)
 for _, v in pairs(recipe.accept) do
  if v == fromItem.name then
   return true
  end
 end

 return false
end

---Checks if the provided source has the items to craft
---@param source number The source of the player to check it for
---@param CostItems table The item costs
---@param quantity number The quantity of the item to craft
local function hasCraftItems(source, CostItems, quantity)
 for k, v in pairs(CostItems) do
  local item = getItemByName(source, k)

  if not item then return false end

  if item.quantity < (v * quantity) then return false end
 end
 return true
end

---Checks if the vehicle with the provided plate is owned by any player
---@param plate string The plate to check
---@return boolean owned
local function IsVehicleOwned(plate)
 local result = MySQL.scalar.await('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
 return result
end

---Setup the shop items
---@param shopItems table
---@return table items
local function SetupshopItems(shopItems)
 local items = {}
 if shopItems and next(shopItems) then
  for _, item in pairs(shopItems) do
   local itemInfo = QBCore.Shared.Items[item.name:lower()]
   if itemInfo then
    items[item.slot] = {
     name = itemInfo["name"],
     quantity = tonumber(item.quantity),
     info = item.info or "",
     label = itemInfo["label"],
     description = itemInfo["description"] or "",
     weight = itemInfo["weight"],
     type = itemInfo["type"],
     unique = itemInfo["unique"],
     useable = itemInfo["useable"],
     price = item.price,
     image = itemInfo["image"],
     slot = item.slot,
    }
   end
  end
 end
 return items
end

---Get items in a stash
----@param stashId string The id of the stash to get
----@return table items
local function GetStashItems(stashId)
 local items = {}
 local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
 if not result then return items end

 local stashItems = json.decode(result)
 if not stashItems then return items end

 for _, item in pairs(stashItems) do
  local itemInfo = QBCore.Shared.Items[item.name:lower()]
  if itemInfo then
   items[item.slot] = {
    name = itemInfo["name"],
    quantity = tonumber(item.quantity),
    info = item.info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = item.slot,
   }
  end
 end
 return items
end

---Save the items in a stash
---@param stashId string The stash id to save the items from
---@param items table items to save
local function SaveStashItems(stashId, items)
 if stashes[stashId].label == "Stash-None" or not items then return end

 for _, item in pairs(items) do
  item.description = nil
 end

 MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
  ['stash'] = stashId,
  ['items'] = json.encode(items)
 })

 stashes[stashId].isOpen = false
end

---Add items to a stash
---@param stashId string Stash id to save it to
---@param slot number Slot of the stash to save the item to
---@param otherslot number Slot of the stash to swap it to the item isn't unique
---@param itemName string The name of the item
---@param quantity? number The quantity of the item
---@param info? table The info of the item
local function AddToStash(stashId, slot, otherslot, itemName, quantity, info)
 quantity = tonumber(quantity) or 1
 local ItemData = QBCore.Shared.Items[itemName]
 if not ItemData.unique then
  if stashes[stashId].items[slot] and stashes[stashId].items[slot].name == itemName then
   stashes[stashId].items[slot].quantity = stashes[stashId].items[slot].quantity + quantity
  else
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   stashes[stashId].items[slot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = slot,
   }
  end
 else
  if stashes[stashId].items[slot] and stashes[stashId].items[slot].name == itemName then
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   stashes[stashId].items[otherslot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = otherslot,
   }
  else
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   stashes[stashId].items[slot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = slot,
   }
  end
 end
end

---Remove the item from the stash
---@param stashId string Stash id to remove the item from
---@param slot number Slot to remove the item from
---@param itemName string Name of the item to remove
---@param quantity? number The quantity to remove
local function RemoveFromStash(stashId, slot, itemName, quantity)
 quantity = tonumber(quantity) or 1
 if stashes[stashId].items[slot] and stashes[stashId].items[slot].name == itemName then
  if stashes[stashId].items[slot].quantity > quantity then
   stashes[stashId].items[slot].quantity = stashes[stashId].items[slot].quantity - quantity
  else
   stashes[stashId].items[slot] = nil
  end
 else
  stashes[stashId].items[slot] = nil
  if stashes[stashId].items == nil then
   stashes[stashId].items[slot] = nil
  end
 end
end

---Get the items in the trunk of a vehicle
---@param plate string The plate of the vehicle to check
---@return table items
local function GetOwnedVehicleItems(plate)
 local items = {}
 local result = MySQL.scalar.await('SELECT items FROM trunkitems WHERE plate = ?', {plate})
 if not result then return items end

 local trunkItems = json.decode(result)
 if not trunkItems then return items end

 for _, item in pairs(trunkItems) do
  local itemInfo = QBCore.Shared.Items[item.name:lower()]
  if itemInfo then
   items[item.slot] = {
    name = itemInfo["name"],
    quantity = tonumber(item.quantity),
    info = item.info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = item.slot,
   }
  end
 end
 return items
end

---Save the items in a trunk
---@param plate string The plate to save the items from
---@param items table
local function SaveOwnedVehicleItems(plate, items)
 if trunks[plate].label == "Trunk-None" or not items then return end

 for _, item in pairs(items) do
  item.description = nil
 end

 MySQL.insert('INSERT INTO trunkitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
  ['plate'] = plate,
  ['items'] = json.encode(items)
 })

 trunks[plate].isOpen = false
end

---Add items to a trunk
---@param plate string The plate of the car
---@param slot number Slot of the trunk to save the item to
---@param otherslot number Slot of the trunk to swap it to the item isn't unique
---@param itemName string The name of the item
---@param quantity? number The quantity of the item
---@param info? table The info of the item
local function AddToTrunk(plate, slot, otherslot, itemName, quantity, info)
 quantity = tonumber(quantity) or 1
 local ItemData = QBCore.Shared.Items[itemName]

 if not ItemData.unique then
  if trunks[plate].items[slot] and trunks[plate].items[slot].name == itemName then
   trunks[plate].items[slot].quantity = trunks[plate].items[slot].quantity + quantity
  else
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   trunks[plate].items[slot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = slot,
   }
  end
 else
  if trunks[plate].items[slot] and trunks[plate].items[slot].name == itemName then
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   trunks[plate].items[otherslot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = otherslot,
   }
  else
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   trunks[plate].items[slot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = slot,
   }
  end
 end
end

---Remove the item from the trunk
---@param plate string plate of the car to remove the item from
---@param slot number Slot to remove the item from
---@param itemName string Name of the item to remove
---@param quantity? number The quantity to remove
local function RemoveFromTrunk(plate, slot, itemName, quantity)
 quantity = tonumber(quantity) or 1
 if trunks[plate].items[slot] and trunks[plate].items[slot].name == itemName then
  if trunks[plate].items[slot].quantity > quantity then
   trunks[plate].items[slot].quantity = trunks[plate].items[slot].quantity - quantity
  else
   trunks[plate].items[slot] = nil
  end
 else
  trunks[plate].items[slot] = nil
  if trunks[plate].items == nil then
   trunks[plate].items[slot] = nil
  end
 end
end

---Get the items in the glovebox of a vehicle
---@param plate string The plate of the vehicle to check
---@return table items
local function GetOwnedVehicleGloveboxItems(plate)
 local items = {}
 local result = MySQL.scalar.await('SELECT items FROM gloveboxitems WHERE plate = ?', {plate})
 if not result then return items end

 local gloveboxItems = json.decode(result)
 if not gloveboxItems then return items end

 for _, item in pairs(gloveboxItems) do
  local itemInfo = QBCore.Shared.Items[item.name:lower()]
  if itemInfo then
   items[item.slot] = {
    name = itemInfo["name"],
    quantity = tonumber(item.quantity),
    info = item.info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = item.slot,
   }
  end
 end
 return items
end

---Save the items in a glovebox
---@param plate string The plate to save the items from
---@param items table
local function SaveOwnedGloveboxItems(plate, items)
 if gloveboxes[plate].label == "Glovebox-None" or not items then return end

 for _, item in pairs(items) do
  item.description = nil
 end

 MySQL.insert('INSERT INTO gloveboxitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
  ['plate'] = plate,
  ['items'] = json.encode(items)
 })

 gloveboxes[plate].isOpen = false
end

---Add items to a glovebox
---@param plate string The plate of the car
---@param slot number Slot of the glovebox to save the item to
---@param otherslot number Slot of the glovebox to swap it to the item isn't unique
---@param itemName string The name of the item
---@param quantity? number The quantity of the item
---@param info? table The info of the item
local function AddToGlovebox(plate, slot, otherslot, itemName, quantity, info)
 quantity = tonumber(quantity) or 1
 local ItemData = QBCore.Shared.Items[itemName]

 if not ItemData.unique then
  if gloveboxes[plate].items[slot] and gloveboxes[plate].items[slot].name == itemName then
   gloveboxes[plate].items[slot].quantity = gloveboxes[plate].items[slot].quantity + quantity
  else
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   gloveboxes[plate].items[slot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = slot,
   }
  end
 else
  if gloveboxes[plate].items[slot] and gloveboxes[plate].items[slot].name == itemName then
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   gloveboxes[plate].items[otherslot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = otherslot,
   }
  else
   local itemInfo = QBCore.Shared.Items[itemName:lower()]
   gloveboxes[plate].items[slot] = {
    name = itemInfo["name"],
    quantity = quantity,
    info = info or "",
    label = itemInfo["label"],
    description = itemInfo["description"] or "",
    weight = itemInfo["weight"],
    type = itemInfo["type"],
    unique = itemInfo["unique"],
    useable = itemInfo["useable"],
    image = itemInfo["image"],
    slot = slot,
   }
  end
 end
end

---Remove the item from the glovebox
---@param plate string Plate of the car to remove the item from
---@param slot number Slot to remove the item from
---@param itemName string Name of the item to remove
---@param quantity? number The quantity to remove
local function RemoveFromGlovebox(plate, slot, itemName, quantity)
 quantity = tonumber(quantity) or 1
 if gloveboxes[plate].items[slot] and gloveboxes[plate].items[slot].name == itemName then
  if gloveboxes[plate].items[slot].quantity > quantity then
   gloveboxes[plate].items[slot].quantity = gloveboxes[plate].items[slot].quantity - quantity
  else
   gloveboxes[plate].items[slot] = nil
  end
 else
  gloveboxes[plate].items[slot] = nil
  if gloveboxes[plate].items == nil then
   gloveboxes[plate].items[slot] = nil
  end
 end
end

---Add an item to a drop
---@param dropId integer The id of the drop
---@param slot number The slot of the drop inventory to add the item to
---@param itemName string Name of the item to add
---@param quantity? number The quantity of the item to add
---@param info? table Extra info to add to the item
local function AddToDrop(dropId, slot, itemName, quantity, info)
 quantity = tonumber(quantity) or 1
 drops[dropId].createdTime = os.time()
 if drops[dropId].items[slot] and drops[dropId].items[slot].name == itemName then
  drops[dropId].items[slot].quantity = drops[dropId].items[slot].quantity + quantity
 else
  local itemInfo = QBCore.Shared.Items[itemName:lower()]
  drops[dropId].items[slot] = {
   name = itemInfo["name"],
   quantity = quantity,
   info = info or "",
   label = itemInfo["label"],
   description = itemInfo["description"] or "",
   weight = itemInfo["weight"],
   type = itemInfo["type"],
   unique = itemInfo["unique"],
   useable = itemInfo["useable"],
   image = itemInfo["image"],
   slot = slot,
   id = dropId,
  }
 end
end

---Remove an item from a drop
---@param dropId integer The id of the drop to remove it from
---@param slot number The slot of the drop inventory
---@param itemName string The name of the item to remove
---@param quantity? number The quantity to remove
local function RemoveFromDrop(dropId, slot, itemName, quantity)
 quantity = tonumber(quantity) or 1
 drops[dropId].createdTime = os.time()
 if drops[dropId].items[slot] and drops[dropId].items[slot].name == itemName then
  if drops[dropId].items[slot].quantity > quantity then
   drops[dropId].items[slot].quantity = drops[dropId].items[slot].quantity - quantity
  else
   drops[dropId].items[slot] = nil
  end
 else
  drops[dropId].items[slot] = nil
  if drops[dropId].items == nil then
   drops[dropId].items[slot] = nil
  end
 end
end

---Creates a new id for a drop
---@return integer
local function CreateDropId()
 if drops then
  local id = math.random(10000, 99999)
  local dropid = id
  while drops[dropid] do
   id = math.random(10000, 99999)
   dropid = id
  end
  return dropid
 else
  local id = math.random(10000, 99999)
  local dropid = id
  return dropid
 end
end

---Creates a new drop
---@param source number The source of the player
---@param fromSlot number The slot that the item comes from
---@param toSlot number The slot that the item goes to
---@param itemquantity? number The quantity of the item drop to create
local function CreateNewDrop(source, fromSlot, toSlot, itemquantity)
 itemquantity = tonumber(itemquantity) or 1
 local player = Ra93Core.functions.getplayer(source)
 local itemData = getItemBySlot(source, fromSlot)

 if not itemData then return end

 local coords = GetEntityCoords(GetplayerPed(source))
 if removeItem(source, itemData.name, itemquantity, itemData.slot) then
  TriggerClientEvent("inventory:client:checkWeapon", source, itemData.name)
  local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
  local dropId = CreateDropId()
  drops[dropId] = {}
  drops[dropId].coords = coords
  drops[dropId].createdTime = os.time()

  drops[dropId].items = {}

  drops[dropId].items[toSlot] = {
   name = itemInfo["name"],
   quantity = itemquantity,
   info = itemData.info or "",
   label = itemInfo["label"],
   description = itemInfo["description"] or "",
   weight = itemInfo["weight"],
   type = itemInfo["type"],
   unique = itemInfo["unique"],
   useable = itemInfo["useable"],
   image = itemInfo["image"],
   slot = toSlot,
   id = dropId,
  }
  TriggerEvent("qb-log:server:createLog", "drop", "New Item Drop", "red", "**".. GetplayerName(source) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..source.."*) dropped new item; name: **"..itemData.name.."**, quantity: **" .. itemquantity .. "**")
  TriggerClientEvent("inventory:client:dropItemAnim", source)
  TriggerClientEvent("inventory:client:addDropItem", -1, dropId, source, coords)
  if itemData.name:lower() == "radio" then
   TriggerClientEvent('Radio.Set', source, false)
  end
 else
  Ra93Core.functions.notify(source, Lang:t("notify.missitem"), "error")
 end
end

local function openInventory(name, id, other, origin)
 local src = origin
 local ply = player(src)
 local player = Ra93Core.functions.getplayer(src)
 if ply.state.inv_busy then
  return Ra93Core.functions.notify(src, Lang:t("notify.noaccess"), 'error')
 end
 if name and id then
  local secondInv = {}
  if name == "stash" then
   if stashes[id] then
    if stashes[id].isOpen then
     local Target = Ra93Core.functions.getplayer(stashes[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', stashes[id].isOpen, name, id, stashes[id].label)
     else
      stashes[id].isOpen = false
     end
    end
   end
   local maxweight = 1000000
   local slots = 50
   if other then
    maxweight = other.maxweight or 1000000
    slots = other.slots or 50
   end
   secondInv.name = "stash-"..id
   secondInv.label = "Stash-"..id
   secondInv.maxweight = maxweight
   secondInv.inventory = {}
   secondInv.slots = slots
   if stashes[id] and stashes[id].isOpen then
    secondInv.name = "none-inv"
    secondInv.label = "Stash-None"
    secondInv.maxweight = 1000000
    secondInv.inventory = {}
    secondInv.slots = 0
   else
    local stashItems = GetStashItems(id)
    if next(stashItems) then
     secondInv.inventory = stashItems
     stashes[id] = {}
     stashes[id].items = stashItems
     stashes[id].isOpen = src
     stashes[id].label = secondInv.label
    else
     stashes[id] = {}
     stashes[id].items = {}
     stashes[id].isOpen = src
     stashes[id].label = secondInv.label
    end
   end
  elseif name == "trunk" then
   if trunks[id] then
    if trunks[id].isOpen then
     local Target = Ra93Core.functions.getplayer(trunks[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', trunks[id].isOpen, name, id, trunks[id].label)
     else
      trunks[id].isOpen = false
     end
    end
   end
   secondInv.name = "trunk-"..id
   secondInv.label = "Trunk-"..id
   secondInv.maxweight = other.maxweight or 60000
   secondInv.inventory = {}
   secondInv.slots = other.slots or 50
   if (trunks[id] and trunks[id].isOpen) or (QBCore.Shared.SplitStr(id, "PLZI")[2] and (player.playerData.job.name ~= "police" or player.playerData.job.type ~= "leo")) then
    secondInv.name = "none-inv"
    secondInv.label = "Trunk-None"
    secondInv.maxweight = other.maxweight or 60000
    secondInv.inventory = {}
    secondInv.slots = 0
   else
    if id then
     local ownedItems = GetOwnedVehicleItems(id)
     if IsVehicleOwned(id) and next(ownedItems) then
      secondInv.inventory = ownedItems
      trunks[id] = {}
      trunks[id].items = ownedItems
      trunks[id].isOpen = src
      trunks[id].label = secondInv.label
     elseif trunks[id] and not trunks[id].isOpen then
      secondInv.inventory = trunks[id].items
      trunks[id].isOpen = src
      trunks[id].label = secondInv.label
     else
      trunks[id] = {}
      trunks[id].items = {}
      trunks[id].isOpen = src
      trunks[id].label = secondInv.label
     end
    end
   end
  elseif name == "glovebox" then
   if gloveboxes[id] then
    if gloveboxes[id].isOpen then
     local Target = Ra93Core.functions.getplayer(gloveboxes[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', gloveboxes[id].isOpen, name, id, gloveboxes[id].label)
     else
      gloveboxes[id].isOpen = false
     end
    end
   end
   secondInv.name = "glovebox-"..id
   secondInv.label = "Glovebox-"..id
   secondInv.maxweight = 10000
   secondInv.inventory = {}
   secondInv.slots = 5
   if gloveboxes[id] and gloveboxes[id].isOpen then
    secondInv.name = "none-inv"
    secondInv.label = "Glovebox-None"
    secondInv.maxweight = 10000
    secondInv.inventory = {}
    secondInv.slots = 0
   else
    local ownedItems = GetOwnedVehicleGloveboxItems(id)
    if gloveboxes[id] and not gloveboxes[id].isOpen then
     secondInv.inventory = gloveboxes[id].items
     gloveboxes[id].isOpen = src
     gloveboxes[id].label = secondInv.label
    elseif IsVehicleOwned(id) and next(ownedItems) then
     secondInv.inventory = ownedItems
     gloveboxes[id] = {}
     gloveboxes[id].items = ownedItems
     gloveboxes[id].isOpen = src
     gloveboxes[id].label = secondInv.label
    else
     gloveboxes[id] = {}
     gloveboxes[id].items = {}
     gloveboxes[id].isOpen = src
     gloveboxes[id].label = secondInv.label
    end
   end
  elseif name == "shop" then
   secondInv.name = "itemshop-"..id
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = SetupshopItems(other.items)
   shopItems[id] = {}
   shopItems[id].items = other.items
   secondInv.slots = #other.items
  elseif name == "traphouse" then
   secondInv.name = "traphouse-"..id
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = other.items
   secondInv.slots = other.slots
  elseif name == "crafting" then
   secondInv.name = "crafting"
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = other.items
   secondInv.slots = #other.items
  elseif name == "attachment_crafting" then
   secondInv.name = "attachment_crafting"
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = other.items
   secondInv.slots = #other.items
  elseif name == "otherplayer" then
   local Otherplayer = Ra93Core.functions.getplayer(tonumber(id))
   if Otherplayer then
    secondInv.name = "otherplayer-"..id
    secondInv.label = "player-"..id
    secondInv.maxweight = Config.MaxInventoryWeight
    secondInv.inventory = Otherplayer.playerData.items
    if (player.playerData.job.name == "police" or player.playerData.job.type == "leo") and player.playerData.job.onduty then
     secondInv.slots = Config.MaxInventorySlots
    else
     secondInv.slots = Config.MaxInventorySlots - 1
    end
    Wait(250)
   end
  else
   if drops[id] then
    if drops[id].isOpen then
     local Target = Ra93Core.functions.getplayer(drops[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', drops[id].isOpen, name, id, drops[id].label)
     else
      drops[id].isOpen = false
     end
    end
   end
   if drops[id] and not drops[id].isOpen then
    secondInv.coords = drops[id].coords
    secondInv.name = id
    secondInv.label = "Dropped-"..tostring(id)
    secondInv.maxweight = 100000
    secondInv.inventory = drops[id].items
    secondInv.slots = 30
    drops[id].isOpen = src
    drops[id].label = secondInv.label
    drops[id].createdTime = os.time()
   else
    secondInv.name = "none-inv"
    secondInv.label = "Dropped-None"
    secondInv.maxweight = 100000
    secondInv.inventory = {}
    secondInv.slots = 0
   end
  end
  TriggerClientEvent("qb-inventory:client:closeinv", id)
  TriggerClientEvent("inventory:client:openInventory", src, {}, player.playerData.items, secondInv)
 else
  TriggerClientEvent("inventory:client:openInventory", src, {}, player.playerData.items)
 end
end

--#endregion Functions

--#region Events

AddEventHandler('QBCore:server:playerLoaded', function(player)
 Ra93Core.functions.addPlayerMethod(player.playerData.source, "addItem", function(item, quantity, slot, info)
  return addItem(player.playerData.source, item, quantity, slot, info)
 end)

 Ra93Core.functions.addPlayerMethod(player.playerData.source, "removeItem", function(item, quantity, slot)
  return removeItem(player.playerData.source, item, quantity, slot)
 end)

 Ra93Core.functions.addPlayerMethod(player.playerData.source, "getItemBySlot", function(slot)
  return getItemBySlot(player.playerData.source, slot)
 end)

 Ra93Core.functions.addPlayerMethod(player.playerData.source, "getItemByName", function(item)
  return getItemByName(player.playerData.source, item)
 end)

 Ra93Core.functions.addPlayerMethod(player.playerData.source, "getItemsByName", function(item)
  return getItemsByName(player.playerData.source, item)
 end)

 Ra93Core.functions.addPlayerMethod(player.playerData.source, "clearInventory", function(filterItems)
  clearInventory(player.playerData.source, filterItems)
 end)

 Ra93Core.functions.addPlayerMethod(player.playerData.source, "setInventory", function(items)
  setInventory(player.playerData.source, items)
 end)
end)

AddEventHandler('onResourceStart', function(resourceName)
 if resourceName ~= GetCurrentResourceName() then return end
 local players = Ra93Core.functions.getQBplayers()
 for k in pairs(players) do
  Ra93Core.functions.addPlayerMethod(k, "addItem", function(item, quantity, slot, info)
   return addItem(k, item, quantity, slot, info)
  end)

  Ra93Core.functions.addPlayerMethod(k, "removeItem", function(item, quantity, slot)
   return removeItem(k, item, quantity, slot)
  end)

  Ra93Core.functions.addPlayerMethod(k, "getItemBySlot", function(slot)
   return getItemBySlot(k, slot)
  end)

  Ra93Core.functions.addPlayerMethod(k, "getItemByName", function(item)
   return getItemByName(k, item)
  end)

  Ra93Core.functions.addPlayerMethod(k, "getItemsByName", function(item)
   return getItemsByName(k, item)
  end)

  Ra93Core.functions.addPlayerMethod(k, "clearInventory", function(filterItems)
   clearInventory(k, filterItems)
  end)

  Ra93Core.functions.addPlayerMethod(k, "setInventory", function(items)
   setInventory(k, items)
  end)
 end
end)

RegisterNetEvent('QBCore:server:updateObject', function()
 if source ~= '' then return end -- Safety check if the event was not called from the server.
 Ra93Core = exports['rcCore']:getCoreObject()
end)

function addTrunkItems(plate, items)
 trunks[plate] = {}
 trunks[plate].items = items
end

function addGloveboxItems(plate, items)
 gloveboxes[plate] = {}
 gloveboxes[plate].items = items
end

RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
 local src = source

 -- Check that inputs are not nil
 -- Most commonly when abusing this exploit, this values are left as
 if fromItem == nil  then return end
 if toItem == nil then return end

 -- Check that they have the items
 fromItem = getItemByName(src, fromItem)
 toItem = getItemByName(src, toItem)

 if fromItem == nil  then return end
 if toItem == nil then return end

 -- Check the recipe is valid
 local recipe = QBCore.Shared.Items[toItem.name].combinable

 if recipe and recipe.reward ~= item then return end
 if not recipeContains(recipe, fromItem) then return end

 TriggerClientEvent('inventory:client:itemBox', src, QBCore.Shared.Items[item], 'add')
 addItem(src, item, 1)
 removeItem(src, fromItem.name, 1)
 removeItem(src, toItem.name, 1)
end)

RegisterNetEvent('inventory:server:craftItems', function(itemName, itemCosts, quantity, toSlot, points)
 local src = source
 local player = Ra93Core.functions.getplayer(src)

 quantity = tonumber(quantity)

 if not itemName or not itemCosts then return end

 for k, v in pairs(itemCosts) do
  removeItem(src, k, (v*quantity))
 end
 addItem(src, itemName, quantity, toSlot)
 player.Functions.SetMetaData("craftingrep", player.playerData.metadata["craftingrep"] + (points * quantity))
 TriggerClientEvent("inventory:client:updateplayerInventory", src, false)
end)

RegisterNetEvent('inventory:server:craftAttachment', function(itemName, itemCosts, quantity, toSlot, points)
 local src = source
 local player = Ra93Core.functions.getplayer(src)

 quantity = tonumber(quantity)

 if not itemName or not itemCosts then return end

 for k, v in pairs(itemCosts) do
  removeItem(src, k, (v*quantity))
 end
 addItem(src, itemName, quantity, toSlot)
 player.Functions.SetMetaData("attachmentcraftingrep", player.playerData.metadata["attachmentcraftingrep"] + (points * quantity))
 TriggerClientEvent("inventory:client:updateplayerInventory", src, false)
end)

RegisterNetEvent('inventory:server:setIsOpenState', function(IsOpen, type, id)
 if IsOpen then return end

 if type == "stash" then
  stashes[id].isOpen = false
 elseif type == "trunk" then
  trunks[id].isOpen = false
 elseif type == "glovebox" then
  gloveboxes[id].isOpen = false
 elseif type == "drop" then
  drops[id].isOpen = false
 end
end)

RegisterNetEvent('inventory:server:openInventory', function(name, id, other)
-- print('inventory:server:openInventory is deprecated use exports[\'qb-inventory\']:openInventory() instead.')
 local src = source
 local ply = player(src)
 local player = Ra93Core.functions.getplayer(src)
 if ply.state.inv_busy then
  return Ra93Core.functions.notify(src, Lang:t("notify.noaccess"), 'error')
 end
 if name and id then
  local secondInv = {}
  if name == "stash" then
   if stashes[id] then
    if stashes[id].isOpen then
     local Target = Ra93Core.functions.getplayer(stashes[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', stashes[id].isOpen, name, id, stashes[id].label)
     else
      stashes[id].isOpen = false
     end
    end
   end
   local maxweight = 1000000
   local slots = 50
   if other then
    maxweight = other.maxweight or 1000000
    slots = other.slots or 50
   end
   secondInv.name = "stash-"..id
   secondInv.label = "Stash-"..id
   secondInv.maxweight = maxweight
   secondInv.inventory = {}
   secondInv.slots = slots
   if stashes[id] and stashes[id].isOpen then
    secondInv.name = "none-inv"
    secondInv.label = "Stash-None"
    secondInv.maxweight = 1000000
    secondInv.inventory = {}
    secondInv.slots = 0
   else
    local stashItems = GetStashItems(id)
    if next(stashItems) then
     secondInv.inventory = stashItems
     stashes[id] = {}
     stashes[id].items = stashItems
     stashes[id].isOpen = src
     stashes[id].label = secondInv.label
    else
     stashes[id] = {}
     stashes[id].items = {}
     stashes[id].isOpen = src
     stashes[id].label = secondInv.label
    end
   end
  elseif name == "trunk" then
   if trunks[id] then
    if trunks[id].isOpen then
     local Target = Ra93Core.functions.getplayer(trunks[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', trunks[id].isOpen, name, id, trunks[id].label)
     else
      trunks[id].isOpen = false
     end
    end
   end
   secondInv.name = "trunk-"..id
   secondInv.label = "Trunk-"..id
   secondInv.maxweight = other.maxweight or 60000
   secondInv.inventory = {}
   secondInv.slots = other.slots or 50
   if (trunks[id] and trunks[id].isOpen) or (QBCore.Shared.SplitStr(id, "PLZI")[2] and (player.playerData.job.name ~= "police" or player.playerData.job.type ~= "leo")) then
    secondInv.name = "none-inv"
    secondInv.label = "Trunk-None"
    secondInv.maxweight = other.maxweight or 60000
    secondInv.inventory = {}
    secondInv.slots = 0
   else
    if id then
     local ownedItems = GetOwnedVehicleItems(id)
     if IsVehicleOwned(id) and next(ownedItems) then
      secondInv.inventory = ownedItems
      trunks[id] = {}
      trunks[id].items = ownedItems
      trunks[id].isOpen = src
      trunks[id].label = secondInv.label
     elseif trunks[id] and not trunks[id].isOpen then
      secondInv.inventory = trunks[id].items
      trunks[id].isOpen = src
      trunks[id].label = secondInv.label
     else
      trunks[id] = {}
      trunks[id].items = {}
      trunks[id].isOpen = src
      trunks[id].label = secondInv.label
     end
    end
   end
  elseif name == "glovebox" then
   if gloveboxes[id] then
    if gloveboxes[id].isOpen then
     local Target = Ra93Core.functions.getplayer(gloveboxes[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', gloveboxes[id].isOpen, name, id, gloveboxes[id].label)
     else
      gloveboxes[id].isOpen = false
     end
    end
   end
   secondInv.name = "glovebox-"..id
   secondInv.label = "Glovebox-"..id
   secondInv.maxweight = 10000
   secondInv.inventory = {}
   secondInv.slots = 5
   if gloveboxes[id] and gloveboxes[id].isOpen then
    secondInv.name = "none-inv"
    secondInv.label = "Glovebox-None"
    secondInv.maxweight = 10000
    secondInv.inventory = {}
    secondInv.slots = 0
   else
    local ownedItems = GetOwnedVehicleGloveboxItems(id)
    if gloveboxes[id] and not gloveboxes[id].isOpen then
     secondInv.inventory = gloveboxes[id].items
     gloveboxes[id].isOpen = src
     gloveboxes[id].label = secondInv.label
    elseif IsVehicleOwned(id) and next(ownedItems) then
     secondInv.inventory = ownedItems
     gloveboxes[id] = {}
     gloveboxes[id].items = ownedItems
     gloveboxes[id].isOpen = src
     gloveboxes[id].label = secondInv.label
    else
     gloveboxes[id] = {}
     gloveboxes[id].items = {}
     gloveboxes[id].isOpen = src
     gloveboxes[id].label = secondInv.label
    end
   end
  elseif name == "shop" then
   secondInv.name = "itemshop-"..id
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = SetupshopItems(other.items)
   shopItems[id] = {}
   shopItems[id].items = other.items
   secondInv.slots = #other.items
  elseif name == "traphouse" then
   secondInv.name = "traphouse-"..id
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = other.items
   secondInv.slots = other.slots
  elseif name == "crafting" then
   secondInv.name = "crafting"
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = other.items
   secondInv.slots = #other.items
  elseif name == "attachment_crafting" then
   secondInv.name = "attachment_crafting"
   secondInv.label = other.label
   secondInv.maxweight = 900000
   secondInv.inventory = other.items
   secondInv.slots = #other.items
  elseif name == "otherplayer" then
   local Otherplayer = Ra93Core.functions.getplayer(tonumber(id))
   if Otherplayer then
    secondInv.name = "otherplayer-"..id
    secondInv.label = "player-"..id
    secondInv.maxweight = Config.MaxInventoryWeight
    secondInv.inventory = Otherplayer.playerData.items
    if (player.playerData.job.name == "police" or player.playerData.job.type == "leo") and player.playerData.job.onduty then
     secondInv.slots = Config.MaxInventorySlots
    else
     secondInv.slots = Config.MaxInventorySlots - 1
    end
    Wait(250)
   end
  else
   if drops[id] then
    if drops[id].isOpen then
     local Target = Ra93Core.functions.getplayer(drops[id].isOpen)
     if Target then
      TriggerClientEvent('inventory:client:checkOpenState', drops[id].isOpen, name, id, drops[id].label)
     else
      drops[id].isOpen = false
     end
    end
   end
   if drops[id] and not drops[id].isOpen then
    secondInv.coords = drops[id].coords
    secondInv.name = id
    secondInv.label = "Dropped-"..tostring(id)
    secondInv.maxweight = 100000
    secondInv.inventory = drops[id].items
    secondInv.slots = 30
    drops[id].isOpen = src
    drops[id].label = secondInv.label
    drops[id].createdTime = os.time()
   else
    secondInv.name = "none-inv"
    secondInv.label = "Dropped-None"
    secondInv.maxweight = 100000
    secondInv.inventory = {}
    secondInv.slots = 0
   end
  end
  TriggerClientEvent("qb-inventory:client:closeinv", id)
  TriggerClientEvent("inventory:client:openInventory", src, {}, player.playerData.items, secondInv)
 else
  TriggerClientEvent("inventory:client:openInventory", src, {}, player.playerData.items)
 end
end)

RegisterNetEvent('inventory:server:saveInventory', function(type, id)
 if type == "trunk" then
  if IsVehicleOwned(id) then
   SaveOwnedVehicleItems(id, trunks[id].items)
  else
   trunks[id].isOpen = false
  end
 elseif type == "glovebox" then
  if (IsVehicleOwned(id)) then
   SaveOwnedGloveboxItems(id, gloveboxes[id].items)
  else
   gloveboxes[id].isOpen = false
  end
 elseif type == "stash" then
  SaveStashItems(id, stashes[id].items)
 elseif type == "drop" then
  if drops[id] then
   drops[id].isOpen = false
   if drops[id].items == nil or next(drops[id].items) == nil then
    drops[id] = nil
    TriggerClientEvent("inventory:client:removeDropItem", -1, id)
   end
  end
 end
end)

RegisterNetEvent('inventory:server:useItemSlot', function(slot)
 local src = source
 local itemData = getItemBySlot(src, slot)
 if not itemData then return end
 local itemInfo = QBCore.Shared.Items[itemData.name]
 if itemData.type == "weapon" then
  TriggerClientEvent("inventory:client:useWeapon", src, itemData, itemData.info.quality and itemData.info.quality > 0)
  TriggerClientEvent('inventory:client:itemBox', src, itemInfo, "use")
 elseif itemData.useable then
  useItem(itemData.name, src, itemData)
  TriggerClientEvent('inventory:client:itemBox', src, itemInfo, "use")
 end
end)

RegisterNetEvent('inventory:server:useItem', function(inventory, item)
 local src = source
 if inventory ~= "player" and inventory ~= "hotbar" then return end
 local itemData = getItemBySlot(src, item.slot)
 if not itemData then return end
 local itemInfo = QBCore.Shared.Items[itemData.name]
 if itemData.type == "weapon" then
  TriggerClientEvent("inventory:client:useWeapon", src, itemData, itemData.info.quality and itemData.info.quality > 0)
  TriggerClientEvent('inventory:client:itemBox', src, itemInfo, "use")
 else
  useItem(itemData.name, src, itemData)
  TriggerClientEvent('inventory:client:itemBox', src, itemInfo, "use")
 end
end)

RegisterNetEvent('inventory:server:setInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromquantity, toquantity)
 local src = source
 local player = Ra93Core.functions.getplayer(src)
 fromSlot = tonumber(fromSlot)
 toSlot = tonumber(toSlot)

 if (fromInventory == "player" or fromInventory == "hotbar") and (QBCore.Shared.SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting") then
  return
 end

 if fromInventory == "player" or fromInventory == "hotbar" then
  local fromItemData = getItemBySlot(src, fromSlot)
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    removeItem(src, fromItemData.name, fromquantity, fromSlot)
    TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(src, toItemData.name, toquantity, toSlot)
      addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
     end
    end
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "otherplayer" then
    local playerId = tonumber(QBCore.Shared.SplitStr(toInventory, "-")[2])
    local Otherplayer = Ra93Core.functions.getplayer(playerId)
    local toItemData = Otherplayer.playerData.items[toSlot]
    removeItem(src, fromItemData.name, fromquantity, fromSlot)
    TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(playerId, itemInfo["name"], toquantity, fromSlot)
      addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "robbing", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** with name: **" .. fromItemData.name .. "**, quantity: **" .. fromquantity.. "** with player: **".. GetplayerName(Otherplayer.playerData.source) .. "** (citizenid: *"..Otherplayer.playerData.citizenid.."* | id: *"..Otherplayer.playerData.source.."*)")
     end
    else
     local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
     TriggerEvent("qb-log:server:createLog", "robbing", "Dropped Item", "red", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, quantity: **" .. fromquantity .. "** to player: **".. GetplayerName(Otherplayer.playerData.source) .. "** (citizenid: *"..Otherplayer.playerData.citizenid.."* | id: *"..Otherplayer.playerData.source.."*)")
    end
    local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    addItem(playerId, itemInfo["name"], fromquantity, toSlot, fromItemData.info)
   elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "trunk" then
    local plate = QBCore.Shared.SplitStr(toInventory, "-")[2]
    local toItemData = trunks[plate].items[toSlot]
    removeItem(src, fromItemData.name, fromquantity, fromSlot)
    TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      RemoveFromTrunk(plate, fromSlot, itemInfo["name"], toquantity)
      addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "trunk", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** with name: **" .. fromItemData.name .. "**, quantity: **" .. fromquantity .. "** - plate: *" .. plate .. "*")
     end
    else
     local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
     TriggerEvent("qb-log:server:createLog", "trunk", "Dropped Item", "red", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, quantity: **" .. fromquantity .. "** - plate: *" .. plate .. "*")
    end
    local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromquantity, fromItemData.info)
   elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "glovebox" then
    local plate = QBCore.Shared.SplitStr(toInventory, "-")[2]
    local toItemData = gloveboxes[plate].items[toSlot]
    removeItem(src, fromItemData.name, fromquantity, fromSlot)
    TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], toquantity)
      addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "glovebox", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** with name: **" .. fromItemData.name .. "**, quantity: **" .. fromquantity .. "** - plate: *" .. plate .. "*")
     end
    else
     local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
     TriggerEvent("qb-log:server:createLog", "glovebox", "Dropped Item", "red", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, quantity: **" .. fromquantity .. "** - plate: *" .. plate .. "*")
    end
    local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromquantity, fromItemData.info)
   elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "stash" then
    local stashId = QBCore.Shared.SplitStr(toInventory, "-")[2]
    local toItemData = stashes[stashId].items[toSlot]
    removeItem(src, fromItemData.name, fromquantity, fromSlot)
    TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      --RemoveFromStash(stashId, fromSlot, itemInfo["name"], toquantity)
      RemoveFromStash(stashId, toSlot, itemInfo["name"], toquantity)
      addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "stash", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** with name: **" .. fromItemData.name .. "**, quantity: **" .. fromquantity .. "** - stash: *" .. stashId .. "*")
     end
    else
     local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
     TriggerEvent("qb-log:server:createLog", "stash", "Dropped Item", "red", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, quantity: **" .. fromquantity .. "** - stash: *" .. stashId .. "*")
    end
    local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromquantity, fromItemData.info)
   elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "traphouse" then
    -- Traphouse
    local traphouseId = QBCore.Shared.SplitStr(toInventory, "_")[2]
    local toItemData = exports['qb-traphouse']:getInventoryData(traphouseId, toSlot)
    local IsItemValid = exports['qb-traphouse']:canItemBeSaled(fromItemData.name:lower())
    if IsItemValid then
     removeItem(src, fromItemData.name, fromquantity, fromSlot)
     TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
     if toItemData  then
      local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      toquantity = tonumber(toquantity) or toItemData.quantity
      if toItemData.name ~= fromItemData.name then
       exports['qb-traphouse']:removeHouseItem(traphouseId, fromSlot, itemInfo["name"], toquantity)
       addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
       TriggerEvent("qb-log:server:createLog", "traphouse", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** with name: **" .. fromItemData.name .. "**, quantity: **" .. fromquantity .. "** - traphouse: *" .. traphouseId .. "*")
      end
     else
      local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
      TriggerEvent("qb-log:server:createLog", "traphouse", "Dropped Item", "red", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, quantity: **" .. fromquantity .. "** - traphouse: *" .. traphouseId .. "*")
     end
     local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
     exports['qb-traphouse']:addHouseItem(traphouseId, toSlot, itemInfo["name"], fromquantity, fromItemData.info, src)
    else
     Ra93Core.functions.notify(src, Lang:t("notify.nosell"), 'error')
    end
   else
    -- drop
    toInventory = tonumber(toInventory)
    if toInventory == nil or toInventory == 0 then
     CreateNewDrop(src, fromSlot, toSlot, fromquantity)
    else
     local toItemData = drops[toInventory].items[toSlot]
     removeItem(src, fromItemData.name, fromquantity, fromSlot)
     TriggerClientEvent("inventory:client:checkWeapon", src, fromItemData.name)
     if toItemData then
      local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      toquantity = tonumber(toquantity) or toItemData.quantity
      if toItemData.name ~= fromItemData.name then
       addItem(src, toItemData.name, toquantity, fromSlot, toItemData.info)
       RemoveFromDrop(toInventory, fromSlot, itemInfo["name"], toquantity)
       TriggerEvent("qb-log:server:createLog", "drop", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** with name: **" .. fromItemData.name .. "**, quantity: **" .. fromquantity .. "** - dropid: *" .. toInventory .. "*")
      end
     else
      local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
      TriggerEvent("qb-log:server:createLog", "drop", "Dropped Item", "red", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, quantity: **" .. fromquantity .. "** - dropid: *" .. toInventory .. "*")
     end
     local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
     AddToDrop(toInventory, toSlot, itemInfo["name"], fromquantity, fromItemData.info)
     if itemInfo["name"] == "radio" then
      TriggerClientEvent('Radio.Set', src, false)
     end
    end
   end
  else
   Ra93Core.functions.notify(src, Lang:t("notify.missitem"), "error")
  end
 elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "otherplayer" then
  local playerId = tonumber(QBCore.Shared.SplitStr(fromInventory, "-")[2])
  local Otherplayer = Ra93Core.functions.getplayer(playerId)
  local fromItemData = Otherplayer.playerData.items[fromSlot]
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    removeItem(playerId, itemInfo["name"], fromquantity, fromSlot)
    TriggerClientEvent("inventory:client:checkWeapon", Otherplayer.playerData.source, fromItemData.name)
    if toItemData then
     itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(src, toItemData.name, toquantity, toSlot)
      addItem(playerId, itemInfo["name"], toquantity, fromSlot, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "robbing", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** with item; **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** from player: **".. GetplayerName(Otherplayer.playerData.source) .. "** (citizenid: *"..Otherplayer.playerData.citizenid.."* | *"..Otherplayer.playerData.source.."*)")
     end
    else
     TriggerEvent("qb-log:server:createLog", "robbing", "Retrieved Item", "green", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) took item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity .. "** from player: **".. GetplayerName(Otherplayer.playerData.source) .. "** (citizenid: *"..Otherplayer.playerData.citizenid.."* | *"..Otherplayer.playerData.source.."*)")
    end
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   else
    local toItemData = Otherplayer.playerData.items[toSlot]
    removeItem(playerId, itemInfo["name"], fromquantity, fromSlot)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      removeItem(playerId, itemInfo["name"], toquantity, toSlot)
      addItem(playerId, itemInfo["name"], toquantity, fromSlot, toItemData.info)
     end
    end
    itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    addItem(playerId, itemInfo["name"], fromquantity, toSlot, fromItemData.info)
   end
  else
   Ra93Core.functions.notify(src, "Item doesn't exist", "error")
  end
 elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "trunk" then
  local plate = QBCore.Shared.SplitStr(fromInventory, "-")[2]
  local fromItemData = trunks[plate].items[fromSlot]
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromquantity)
    if toItemData then
     itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(src, toItemData.name, toquantity, toSlot)
      AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toquantity, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "trunk", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** with item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** plate: *" .. plate .. "*")
     else
      TriggerEvent("qb-log:server:createLog", "trunk", "Stacked Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** from plate: *" .. plate .. "*")
     end
    else
     TriggerEvent("qb-log:server:createLog", "trunk", "Received Item", "green", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity.. "** plate: *" .. plate .. "*")
    end
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   else
    local toItemData = trunks[plate].items[toSlot]
    RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromquantity)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      RemoveFromTrunk(plate, toSlot, itemInfo["name"], toquantity)
      AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toquantity, toItemData.info)
     end
    end
    itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromquantity, fromItemData.info)
   end
  else
   Ra93Core.functions.notify(src, Lang:t("notify.itemexist"), "error")
  end
 elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "glovebox" then
  local plate = QBCore.Shared.SplitStr(fromInventory, "-")[2]
  local fromItemData = gloveboxes[plate].items[fromSlot]
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromquantity)
    if toItemData then
     itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(src, toItemData.name, toquantity, toSlot)
      AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toquantity, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "glovebox", "Swapped", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src..")* swapped item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** with item; name: **"..itemInfo["name"].."**, quantity: **" .. toquantity .. "** plate: *" .. plate .. "*")
     else
      TriggerEvent("qb-log:server:createLog", "glovebox", "Stacked Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** from plate: *" .. plate .. "*")
     end
    else
     TriggerEvent("qb-log:server:createLog", "glovebox", "Received Item", "green", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity.. "** plate: *" .. plate .. "*")
    end
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   else
    local toItemData = gloveboxes[plate].items[toSlot]
    RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromquantity)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      RemoveFromGlovebox(plate, toSlot, itemInfo["name"], toquantity)
      AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toquantity, toItemData.info)
     end
    end
    itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromquantity, fromItemData.info)
   end
  else
   Ra93Core.functions.notify(src, Lang:t("notify.itemexist"), "error")
  end
 elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "stash" then
  local stashId = QBCore.Shared.SplitStr(fromInventory, "-")[2]
  local fromItemData = stashes[stashId].items[fromSlot]
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromquantity)
    if toItemData then
     itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(src, toItemData.name, toquantity, toSlot)
      AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toquantity, toItemData.info)
      TriggerEvent("qb-log:server:createLog", "stash", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** with item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity .. "** stash: *" .. stashId .. "*")
     else
      TriggerEvent("qb-log:server:createLog", "stash", "Stacked Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** from stash: *" .. stashId .. "*")
     end
    else
     TriggerEvent("qb-log:server:createLog", "stash", "Received Item", "green", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity.. "** stash: *" .. stashId .. "*")
    end
    SaveStashItems(stashId, stashes[stashId].items)
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   else
    local toItemData = stashes[stashId].items[toSlot]
    RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromquantity)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      RemoveFromStash(stashId, toSlot, itemInfo["name"], toquantity)
      AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toquantity, toItemData.info)
     end
    end
    itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromquantity, fromItemData.info)
   end
  else
   Ra93Core.functions.notify(src, Lang:t("notify.itemexist"), "error")
  end
 elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "traphouse" then
  local traphouseId = QBCore.Shared.SplitStr(fromInventory, "-")[2]
  local fromItemData = exports['qb-traphouse']:getInventoryData(traphouseId, fromSlot)
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    exports['qb-traphouse']:removeHouseItem(traphouseId, fromSlot, itemInfo["name"], fromquantity)
    if toItemData then
     itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      removeItem(src, toItemData.name, toquantity, toSlot)
      exports['qb-traphouse']:addHouseItem(traphouseId, fromSlot, itemInfo["name"], toquantity, toItemData.info, src)
      TriggerEvent("qb-log:server:createLog", "stash", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** with item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity .. "** stash: *" .. traphouseId .. "*")
     else
      TriggerEvent("qb-log:server:createLog", "stash", "Stacked Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** from stash: *" .. traphouseId .. "*")
     end
    else
     TriggerEvent("qb-log:server:createLog", "stash", "Received Item", "green", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity.. "** stash: *" .. traphouseId .. "*")
    end
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   else
    local toItemData = exports['qb-traphouse']:getInventoryData(traphouseId, toSlot)
    exports['qb-traphouse']:removeHouseItem(traphouseId, fromSlot, itemInfo["name"], fromquantity)
    if toItemData then
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      exports['qb-traphouse']:removeHouseItem(traphouseId, toSlot, itemInfo["name"], toquantity)
      exports['qb-traphouse']:addHouseItem(traphouseId, fromSlot, itemInfo["name"], toquantity, toItemData.info, src)
     end
    end
    itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    exports['qb-traphouse']:addHouseItem(traphouseId, toSlot, itemInfo["name"], fromquantity, fromItemData.info, src)
   end
  else
   Ra93Core.functions.notify(src, "Item doesn't exist??", "error")
  end
 elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "itemshop" then
  local shopType = QBCore.Shared.SplitStr(fromInventory, "-")[2]
  local itemData = shopItems[shopType].items[fromSlot]
  local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
  local bankBalance = player.playerData.money["bank"]
  local price = tonumber((itemData.price*fromquantity))

  if QBCore.Shared.SplitStr(shopType, "_")[1] == "Dealer" then
   if QBCore.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
    price = tonumber(itemData.price)
    if player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
     itemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
     itemData.info.quality = 100
     addItem(src, itemData.name, 1, toSlot, itemData.info)
     TriggerClientEvent('qb-drugs:client:updateDealerItems', src, itemData, 1)
     Ra93Core.functions.notify(src, itemInfo["label"] .. " bought!", "success")
     TriggerEvent("qb-log:server:createLog", "dealers", "Dealer item bought", "green", "**"..GetplayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
    else
     Ra93Core.functions.notify(src, Lang:t("notify.notencash"), "error")
    end
   else
    if player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
     addItem(src, itemData.name, fromquantity, toSlot, itemData.info)
     TriggerClientEvent('qb-drugs:client:updateDealerItems', src, itemData, fromquantity)
     Ra93Core.functions.notify(src, itemInfo["label"] .. " bought!", "success")
     TriggerEvent("qb-log:server:createLog", "dealers", "Dealer item bought", "green", "**"..GetplayerName(src) .. "** bought a " .. itemInfo["label"] .. "  for $"..price)
    else
     Ra93Core.functions.notify(src, "You don't have enough cash..", "error")
    end
   end
  elseif QBCore.Shared.SplitStr(shopType, "_")[1] == "Itemshop" then
   if player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
    if QBCore.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
     itemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
     itemData.info.quality = 100
    end
    addItem(src, itemData.name, fromquantity, toSlot, itemData.info)
    TriggerClientEvent('qb-shops:client:updateShop', src, QBCore.Shared.SplitStr(shopType, "_")[2], itemData, fromquantity)
    Ra93Core.functions.notify(src, itemInfo["label"] .. " bought!", "success")
    TriggerEvent("qb-log:server:createLog", "shops", "Shop item bought", "green", "**"..GetplayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
   elseif bankBalance >= price then
    player.Functions.RemoveMoney("bank", price, "itemshop-bought-item")
    if QBCore.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
     itemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
     itemData.info.quality = 100
    end
    addItem(src, itemData.name, fromquantity, toSlot, itemData.info)
    TriggerClientEvent('qb-shops:client:updateShop', src, QBCore.Shared.SplitStr(shopType, "_")[2], itemData, fromquantity)
    Ra93Core.functions.notify(src, itemInfo["label"] .. " bought!", "success")
    TriggerEvent("qb-log:server:createLog", "shops", "Shop item bought", "green", "**"..GetplayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
   else
    Ra93Core.functions.notify(src, "You don't have enough cash..", "error")
   end
  else
   if player.Functions.RemoveMoney("cash", price, "unkown-itemshop-bought-item") then
    addItem(src, itemData.name, fromquantity, toSlot, itemData.info)
    Ra93Core.functions.notify(src, itemInfo["label"] .. " bought!", "success")
    TriggerEvent("qb-log:server:createLog", "shops", "Shop item bought", "green", "**"..GetplayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
   elseif bankBalance >= price then
    player.Functions.RemoveMoney("bank", price, "unkown-itemshop-bought-item")
    addItem(src, itemData.name, fromquantity, toSlot, itemData.info)
    Ra93Core.functions.notify(src, itemInfo["label"] .. " bought!", "success")
    TriggerEvent("qb-log:server:createLog", "shops", "Shop item bought", "green", "**"..GetplayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
   else
    Ra93Core.functions.notify(src, Lang:t("notify.notencash"), "error")
   end
  end
 elseif fromInventory == "crafting" then
  local itemData = Config.CraftingItems[fromSlot]
  if hasCraftItems(src, itemData.costs, fromquantity) then
   TriggerClientEvent("inventory:client:craftItems", src, itemData.name, itemData.costs, fromquantity, toSlot, itemData.points)
  else
   TriggerClientEvent("inventory:client:updateplayerInventory", src, true)
   Ra93Core.functions.notify(src, Lang:t("notify.noitem"), "error")
  end
 elseif fromInventory == "attachment_crafting" then
  local itemData = Config.AttachmentCrafting["items"][fromSlot]
  if hasCraftItems(src, itemData.costs, fromquantity) then
   TriggerClientEvent("inventory:client:craftAttachment", src, itemData.name, itemData.costs, fromquantity, toSlot, itemData.points)
  else
   TriggerClientEvent("inventory:client:updateplayerInventory", src, true)
   Ra93Core.functions.notify(src, Lang:t("notify.noitem"), "error")
  end
 else
  -- drop
  fromInventory = tonumber(fromInventory)
  local fromItemData = drops[fromInventory].items[fromSlot]
  fromquantity = tonumber(fromquantity) or fromItemData.quantity
  if fromItemData and fromItemData.quantity >= fromquantity then
   local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
   if toInventory == "player" or toInventory == "hotbar" then
    local toItemData = getItemBySlot(src, toSlot)
    RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromquantity)
    if toItemData then
     toquantity = tonumber(toquantity) and tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      removeItem(src, toItemData.name, toquantity, toSlot)
      AddToDrop(fromInventory, toSlot, itemInfo["name"], toquantity, toItemData.info)
      if itemInfo["name"] == "radio" then
       TriggerClientEvent('Radio.Set', src, false)
      end
      TriggerEvent("qb-log:server:createLog", "drop", "Swapped Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** with item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity .. "** - dropid: *" .. fromInventory .. "*")
     else
      TriggerEvent("qb-log:server:createLog", "drop", "Stacked Item", "orange", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, quantity: **" .. toquantity .. "** - from dropid: *" .. fromInventory .. "*")
     end
    else
     TriggerEvent("qb-log:server:createLog", "drop", "Received Item", "green", "**".. GetplayerName(src) .. "** (citizenid: *"..player.playerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, quantity: **" .. fromquantity.. "** -  dropid: *" .. fromInventory .. "*")
    end
    addItem(src, fromItemData.name, fromquantity, toSlot, fromItemData.info)
   else
    toInventory = tonumber(toInventory)
    local toItemData = drops[toInventory].items[toSlot]
    RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromquantity)
    --player.playerData.items[toSlot] = fromItemData
    if toItemData then
     --player.playerData.items[fromSlot] = toItemData
     toquantity = tonumber(toquantity) or toItemData.quantity
     if toItemData.name ~= fromItemData.name then
      itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
      RemoveFromDrop(toInventory, toSlot, itemInfo["name"], toquantity)
      AddToDrop(fromInventory, fromSlot, itemInfo["name"], toquantity, toItemData.info)
      if itemInfo["name"] == "radio" then
       TriggerClientEvent('Radio.Set', src, false)
      end
     end
    end
    itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
    AddToDrop(toInventory, toSlot, itemInfo["name"], fromquantity, fromItemData.info)
    if itemInfo["name"] == "radio" then
     TriggerClientEvent('Radio.Set', src, false)
    end
   end
  else
   Ra93Core.functions.notify(src, "Item doesn't exist??", "error")
  end
 end
end)

RegisterServerEvent("inventory:server:giveItem", function(target, name, quantity, slot)
 local src = source
 local player = Ra93Core.functions.getplayer(src)
 target = tonumber(target)
 local Otherplayer = Ra93Core.functions.getplayer(target)
 local dist = #(GetEntityCoords(GetplayerPed(src))-GetEntityCoords(GetplayerPed(target)))
 if player == Otherplayer then return Ra93Core.functions.notify(src, Lang:t("notify.gsitem")) end
 if dist > 2 then return Ra93Core.functions.notify(src, Lang:t("notify.tftgitem")) end
 local item = getItemBySlot(src, slot)
 if not item then Ra93Core.functions.notify(src, Lang:t("notify.infound")); return end
 if item.name ~= name then Ra93Core.functions.notify(src, Lang:t("notify.iifound")); return end

 if quantity <= item.quantity then
  if quantity == 0 then
   quantity = item.quantity
  end
  if removeItem(src, item.name, quantity, item.slot) then
   if addItem(target, item.name, quantity, false, item.info) then
    TriggerClientEvent('inventory:client:itemBox',target, QBCore.Shared.Items[item.name], "add")
    Ra93Core.functions.notify(target, Lang:t("notify.gitemrec")..quantity..' '..item.label..Lang:t("notify.gitemfrom")..player.playerData.charinfo.firstname.." "..player.playerData.charinfo.lastname)
    TriggerClientEvent("inventory:client:updateplayerInventory", target, true)
    TriggerClientEvent('inventory:client:itemBox',src, QBCore.Shared.Items[item.name], "remove")
    Ra93Core.functions.notify(src, Lang:t("notify.gitemyg") .. Otherplayer.playerData.charinfo.firstname.." "..Otherplayer.playerData.charinfo.lastname.. " " .. quantity .. " " .. item.label .."!")
    TriggerClientEvent("inventory:client:updateplayerInventory", src, true)
    TriggerClientEvent('qb-inventory:client:giveAnim', src)
    TriggerClientEvent('qb-inventory:client:giveAnim', target)
   else
    addItem(src, item.name, quantity, item.slot, item.info)
    Ra93Core.functions.notify(src, Lang:t("notify.gitinvfull"), "error")
    Ra93Core.functions.notify(target, Lang:t("notify.giymif"), "error")
    TriggerClientEvent("inventory:client:updateplayerInventory", src, false)
    TriggerClientEvent("inventory:client:updateplayerInventory", target, false)
   end
  else
   Ra93Core.functions.notify(src, Lang:t("notify.gitydhei"), "error")
  end
 else
  Ra93Core.functions.notify(src, Lang:t("notify.gitydhitt"))
 end
end)

RegisterNetEvent('inventory:server:snowball', function(action)
 if action == "add" then
  addItem(source, "weapon_snowball")
 elseif action == "remove" then
  removeItem(source, "weapon_snowball")
 end
end)

RegisterNetEvent('inventory:server:addTrunkItems', function()
 print('inventory:server:addTrunkItems has been deprecated please use exports[\'qb-inventory\']:addTrunkItems(plate, items)')
end)

RegisterNetEvent('inventory:server:addGloveboxItems', function()
 print('inventory:server:addGloveboxItems has been deprecated please use exports[\'qb-inventory\']:addGloveboxItems(plate, items)')
end)
--#endregion Events

--#region Callbacks

Ra93Core.functions.createCallback('qb-inventory:server:getStashItems', function(_, cb, stashId)
 cb(GetStashItems(stashId))
end)

Ra93Core.functions.createCallback('inventory:server:getCurrentdrops', function(_, cb)
 cb(drops)
end)

Ra93Core.functions.createCallback('QBCore:hasItem', function(source, cb, items, quantity)
 print("^3QBCore:hasItem is deprecated, please use Ra93Core.functions.hasItem, it can be used on both server- and client-side and uses the same arguments.^0")
 local retval = false
 local player = Ra93Core.functions.getplayer(source)
 if not player then return cb(false) end
 local isTable = type(items) == 'table'
 local isArray = isTable and table.type(items) == 'array' or false
 local totalItems = #items
 local count = 0
 local kvIndex = 2
 if isTable and not isArray then
  totalItems = 0
  for _ in pairs(items) do totalItems += 1 end
  kvIndex = 1
 end
 if isTable then
  for k, v in pairs(items) do
   local itemKV = {k, v}
   local item = getItemByName(source, itemKV[kvIndex])
   if item and ((quantity and item.quantity >= quantity) or (not quantity and not isArray and item.quantity >= v) or (not quantity and isArray)) then
    count += 1
   end
  end
  if count == totalItems then
   retval = true
  end
 else -- Single item as string
  local item = getItemByName(source, items)
  if item and not quantity or (item and quantity and item.quantity >= quantity) then
   retval = true
  end
 end
 cb(retval)
end)

--#endregion Callbacks

--#region Commands

QBCore.Commands.Add("resetinv", "Reset Inventory (Admin Only)", {{name="type", help="stash/trunk/glovebox"},{name="id/plate", help="ID of stash or license plate"}}, true, function(source, args)
 local invType = args[1]:lower()
 table.remove(args, 1)
 local invId = table.concat(args, " ")
 if invType and invId then
  if invType == "trunk" then
   if trunks[invId] then
    trunks[invId].isOpen = false
   end
  elseif invType == "glovebox" then
   if gloveboxes[invId] then
    gloveboxes[invId].isOpen = false
   end
  elseif invType == "stash" then
   if stashes[invId] then
    stashes[invId].isOpen = false
   end
  else
   Ra93Core.functions.notify(source,  Lang:t("notify.navt"), "error")
  end
 else
  Ra93Core.functions.notify(source,  Lang:t("notify.anfoc"), "error")
 end
end, "admin")

QBCore.Commands.Add("rob", "Rob player", {}, false, function(source, _)
 TriggerClientEvent("police:client:robplayer", source)
end)

QBCore.Commands.Add("giveitem", "Give An Item (Admin Only)", {{name="id", help="player ID"},{name="item", help="Name of the item (not a label)"}, {name="quantity", help="quantity of items"}}, false, function(source, args)
 local id = tonumber(args[1])
 local player = Ra93Core.functions.getplayer(id)
 local quantity = tonumber(args[3]) or 1
 local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
 if player then
   if itemData then
    -- check iteminfo
    local info = {}
    if itemData["name"] == "id_card" then
     info.citizenid = player.playerData.citizenid
     info.firstname = player.playerData.charinfo.firstname
     info.lastname = player.playerData.charinfo.lastname
     info.birthdate = player.playerData.charinfo.birthdate
     info.gender = player.playerData.charinfo.gender
     info.nationality = player.playerData.charinfo.nationality
    elseif itemData["name"] == "driver_license" then
     info.firstname = player.playerData.charinfo.firstname
     info.lastname = player.playerData.charinfo.lastname
     info.birthdate = player.playerData.charinfo.birthdate
     info.type = "Class C Driver License"
    elseif itemData["type"] == "weapon" then
     quantity = 1
     info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
     info.quality = 100
    elseif itemData["name"] == "harness" then
     info.uses = 20
    elseif itemData["name"] == "markedbills" then
     info.worth = math.random(5000, 10000)
    elseif itemData["name"] == "labkey" then
     info.lab = exports["qb-methlab"]:generateRandomLab()
    elseif itemData["name"] == "printerdocument" then
     info.url = "https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png"
    end

    if addItem(id, itemData["name"], quantity, false, info) then
     Ra93Core.functions.notify(source, Lang:t("notify.yhg") ..GetplayerName(id).." "..quantity.." "..itemData["name"].. "", "success")
    else
     Ra93Core.functions.notify(source,  Lang:t("notify.cgitem"), "error")
    end
   else
    Ra93Core.functions.notify(source,  Lang:t("notify.idne"), "error")
   end
 else
  Ra93Core.functions.notify(source,  Lang:t("notify.pdne"), "error")
 end
end, "admin")

QBCore.Commands.Add("randomitems", "Give Random Items (God Only)", {}, false, function(source, _)
 local filteredItems = {}
 for k, v in pairs(QBCore.Shared.Items) do
  if QBCore.Shared.Items[k]["type"] ~= "weapon" then
   filteredItems[#filteredItems+1] = v
  end
 end
 for _ = 1, 10, 1 do
  local randitem = filteredItems[math.random(1, #filteredItems)]
  local quantity = math.random(1, 10)
  if randitem["unique"] then
   quantity = 1
  end
  if addItem(source, randitem["name"], quantity) then
   TriggerClientEvent('inventory:client:itemBox', source, QBCore.Shared.Items[randitem["name"]], 'add')
   Wait(500)
  end
 end
end, "god")

QBCore.Commands.Add('clearinv', 'Clear players Inventory (Admin Only)', { { name = 'id', help = 'player ID' } }, false, function(source, args)
 local playerId = args[1] ~= '' and tonumber(args[1]) or source
 local player = Ra93Core.functions.getplayer(playerId)
 if player then
  clearInventory(playerId)
 else
  Ra93Core.functions.notify(source, "player not online", 'error')
 end
end, 'admin')

--#endregion Commands

--#region Items

Ra93Core.functions.createUseableItem("driver_license", function(source, item)
 local playerPed = GetplayerPed(source)
 local playerCoords = GetEntityCoords(playerPed)
 local players = Ra93Core.functions.getplayers()
 for _, v in pairs(players) do
  local targetPed = GetplayerPed(v)
  local dist = #(playerCoords - GetEntityCoords(targetPed))
  if dist < 3.0 then
   TriggerClientEvent('chat:addMessage', v,  {
     template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>First Name:</strong> {1} <br><strong>Last Name:</strong> {2} <br><strong>Birth Date:</strong> {3} <br><strong>Licenses:</strong> {4}</div></div>',
     args = {
      "Drivers License",
      item.info.firstname,
      item.info.lastname,
      item.info.birthdate,
      item.info.type
     }
    }
   )
  end
 end
end)

Ra93Core.functions.createUseableItem("id_card", function(source, item)
 local playerPed = GetplayerPed(source)
 local playerCoords = GetEntityCoords(playerPed)
 local players = Ra93Core.functions.getplayers()
 for _, v in pairs(players) do
  local targetPed = GetplayerPed(v)
  local dist = #(playerCoords - GetEntityCoords(targetPed))
  if dist < 3.0 then
   local gender = "Man"
   if item.info.gender == 1 then
    gender = "Woman"
   end
   TriggerClientEvent('chat:addMessage', v,  {
     template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Civ ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birthdate:</strong> {4} <br><strong>Gender:</strong> {5} <br><strong>Nationality:</strong> {6}</div></div>',
     args = {
      "ID Card",
      item.info.citizenid,
      item.info.firstname,
      item.info.lastname,
      item.info.birthdate,
      gender,
      item.info.nationality
     }
    }
   )
  end
 end
end)

--#endregion Items

--#region Threads

CreateThread(function()
 while true do
  for k, v in pairs(drops) do
   if v and (v.createdTime + Config.CleanupDropTime < os.time()) and not drops[k].isOpen then
    drops[k] = nil
    TriggerClientEvent("inventory:client:removeDropItem", -1, k)
   end
  end
  Wait(60 * 1000)
 end
end)

--#endregion Threads

--#region Exports

exports('addGloveboxItems',addGloveboxItems)
exports('addTrunkItems',addTrunkItems)
exports('openInventory',openInventory)
exports("useItem", useItem)
exports("hasItem", hasItem)
exports("setItemData", setItemData)
exports("setInventory", setInventory)
exports("clearInventory", clearInventory)
exports("getItemsByName", getItemsByName)
exports("getItemByName", getItemByName)
exports("getItemBySlot", getItemBySlot)
exports("removeItem", removeItem)
exports("addItem", addItem)
exports("getFirstSlotByItem", getFirstSlotByItem)
exports("getSlotsByItem", getSlotsByItem)
exports("getTotalWeight", getTotalWeight)
exports("saveInventory", saveInventory)
exports("loadInventory", loadInventory)

--#endregion Exports