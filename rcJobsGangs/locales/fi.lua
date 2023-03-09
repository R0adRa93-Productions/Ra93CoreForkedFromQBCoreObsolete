local Translations = {
 error = {},
 success = {},
 info = {
  new_job_app = "Your application has been submitted for %{job}",
  new_job = 'Congratulations with your new job! (%{job})',
  on_duty = '[E] - Mene virkaajalle',
  off_duty = '[E] - Mene virkavapaalle',
  onoff_duty = '~g~Päälle~s~/~r~Pois~s~ Virka',
  stash = 'Kätkeä %{value}',
  store_heli = '[E] Säilytä helikopteri',
  take_heli = '[E] Ota helikopteri',
  store_veh = '[E] - Tallenna Ajoneuvo',
  armory = 'Asevarasto',
  enter_armory = '[E] Asevarasto',
  enter_motorworks = '[E] Motorworks', -- English Change
  vehicleLimitReached = "Vehicle Limit Reached", -- English Change
  enter_outfit = '[E] Outfitter', -- English Change
  enter_management = '[E] Manager System', -- English Change
  enter_garage = '[E] Sign Out Vehicle', -- English Change
  trash = 'Roskis',
  trash_enter = '[E] Roskis',
  stash_enter = '[E] Pukuhuone'
 },
 menu = {
  garage_title = 'Virkamiesten Autotalli',
  close = '⬅ Sulje valikko',
  jobs_garage = ' Garage', -- English Change
  jobs_armory = ' Armory', -- English Change
  jobs_duty_station = "Set Duty Status" -- English Change
 },
 headings = {
  stash = 'Stash', -- English Change
  trash = 'Trash', -- English Change
  armory = 'Armory', -- English Change
  outfit = 'Outfit', -- English Change
  management = 'Management', -- English Change
  garages = ' Vehicle Selector' -- English Change
 },
 email = {
  jobAppSender = "%{job}",
  jobAppSub = "Thank you for applying to %(job).",
  jobAppMsg = "Hello %{gender} %{lastname}<br /><br />%{job} has received your application.<br /><br />The boss is looking into your request and will reach out to you for an interview at their earliest convienance.<br /><br />Once again, thank you for your application.",
  mr = 'Mr',
  mrs = 'Mrs',
 },
 commands = {
  duty = 'Set Duty On or Off', -- English Change
 }
}
if GetConvar('qb_locale', 'en') == 'fi' then
 Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
  fallbackLang = Lang,
 })
end