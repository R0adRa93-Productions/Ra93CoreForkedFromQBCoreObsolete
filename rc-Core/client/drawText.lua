local function drawText(action, text, position)
 local data
 if type(position) ~= "string" then position = "left" end
 if text then
  data = {
   ["text"] = text,
   ["position"] = position
  }
 end
 SendNUIMessage({
  action = action,
  data = data
 })
end

local function keyPressed()
 CreateThread(function()
  drawText("KEY_PRESSED", false, false)
  Wait(500)
  drawText("HIDE_TEXT", false, false)
 end)
end

exports('drawText', drawText)
exports('keyPressed', keyPressed)