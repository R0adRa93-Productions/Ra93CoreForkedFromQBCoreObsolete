CreateThread(function()
 while true do
  local sleep = 0
  if LocalPlayer.state.isLoggedIn then
   sleep = 60000 * Ra93Core.config.updateInterval
   TriggerServerEvent('Ra93Core:updatePlayer')
  end
  Wait(sleep)
 end
end)

CreateThread(function()
 while true do
  if LocalPlayer.state.isLoggedIn then
   if (Ra93Core.playerData.metadata['hunger'] <= 0 or Ra93Core.playerData.metadata['thirst'] <= 0) and not Ra93Core.playerData.metadata['isdead'] then
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    local decreaseThreshold = math.random(5, 10)
    SetEntityHealth(ped, currentHealth - decreaseThreshold)
   end
  end
  Wait(Ra93Core.config.statusInterval)
 end
end)