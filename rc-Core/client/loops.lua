CreateThread(function()
 while true do
  local sleep = 0
  if LocalPlayer.state.isLoggedIn then
   sleep = (1000 * 60) * ra93Core.config.UpdateInterval
   TriggerServerEvent('ra93Core:UpdatePlayer')
  end
  Wait(sleep)
 end
end)

CreateThread(function()
 while true do
  if LocalPlayer.state.isLoggedIn then
   if (ra93Core.playerData.metadata['hunger'] <= 0 or ra93Core.playerData.metadata['thirst'] <= 0) and not ra93Core.playerData.metadata['isdead'] then
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    local decreaseThreshold = math.random(5, 10)
    SetEntityHealth(ped, currentHealth - decreaseThreshold)
   end
  end
  Wait(ra93Core.config.StatusInterval)
 end
end)
