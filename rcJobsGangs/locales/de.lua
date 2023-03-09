local Translations = {
 error = {},
 success = {},
 info = {
  new_job_app = "Your application has been submitted for %{job}",
  new_job = 'Congratulations with your new job! (%{job})',
  on_duty = '~b~[~g~E~b~]~w~ Einstempeln',
  off_duty = '~b~[~r~E~b~]~w~ Ausstempeln',
  onoff_duty = '~g~EIN~s~/~r~AUS~s~ Dienst',
  stash = 'Stash %{value}',
  store_heli = '~b~[~r~E~b~]~w~ Helikopter lagern',
  take_heli = '~b~[~r~E~b~]~w~ Helikopter nehmen',
  store_veh = '~b~[~r~E~b~]~w~ Fahrzeug speichern',
  armory = 'Waffenkammer',
  enter_armory = '[~g~E~s~] Waffenkammer',
  enter_motorworks = '[E] Motorworks', -- English Change
  vehicleLimitReached = "Vehicle Limit Reached", -- English Change
  enter_outfit = '[E] Outfitter', -- English Change
  enter_management = '[E] Manager System', -- English Change
  enter_garage = '[E] Sign Out Vehicle', -- English Change
  trash = 'Müll',
  trash_enter = '~b~[~r~E~b~]~w~ Mülleimer',
  stash_enter = '~b~[~r~E~b~]~w~ Stash öffnen'
 },
 menu = {
  garage_title = 'Polizeiwagen',
  close = '⬅ VERLASSEN',
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
if GetConvar('qb_locale', 'en') == 'de' then
 Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
  fallbackLang = Lang,
 })
end