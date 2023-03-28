Ra93Core = exports("rcCore"):getCoreObject()
local showDrawText = function(func, action, text, position)
 local funcs = {
  process = function(action, text, position)
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
  end,
  keyPressed = function()
   CreateThread(function()
 drawText("KEY_PRESSED", false, false)
 Wait(500)
 drawText.process("HIDE_TEXT", false, false)
   end)
  end
 }
 funcs[func](action, text, position)
end
exports('showDrawText',showDrawText)
