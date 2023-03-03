local function hideText()
 SendNUIMessage({
  action = 'HIDE_TEXT',
 })
end

local function drawText(action, text, position)
 if type(position) ~= "string" then position = "left" end
 SendNUIMessage({
  action = action,
  data = {
   text = text,
   position = position
  }
 })
end

local function drawText(text, position)
 if type(position) ~= "string" then position = "left" end
 SendNUIMessage({
  action = 'DRAW_TEXT',
  data = {
   text = text,
   position = position
  }
 })
end

local function changeText(text, position)
 if type(position) ~= "string" then position = "left" end
 SendNUIMessage({
  action = 'CHANGE_TEXT',
  data = {
   text = text,
   position = position
  }
 })
end

local function keyPressed()
 CreateThread(function() -- Not sure if a thread is needed but why not eh?
  SendNUIMessage({
   action = 'KEY_PRESSED',
  })
  Wait(500)
  hideText()
 end)
end

RegisterNetEvent('rcCore:client:DrawText', function(action, text, position)
 drawText(action, text, position)
end)

RegisterNetEvent('rcCore:client:ChangeText', function(text, position)
 changeText(text, position)
end)

RegisterNetEvent('rcCore:client:HideText', function()
 hideText()
end)

RegisterNetEvent('rcCore:client:KeyPressed', function()
 keyPressed()
end)

exports('drawText', drawText)
exports('changeText', changeText)
exports('HideText', hideText)
exports('KeyPressed', keyPressed)