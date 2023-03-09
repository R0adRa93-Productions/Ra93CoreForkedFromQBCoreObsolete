local Translations = {
 error = {},
 success = {},
 info = {
  new_job_app = "Your application has been submitted for %{job}",
  new_job = 'Congratulations with your new job! (%{job})',
  on_duty = '[~g~E~s~] - Prendre son service',
  off_duty = '[~r~E~s~] - Quitter son service',
  onoff_duty = '~g~On~s~/~r~Off~s~ Service',
  stash = 'Coffre %{value}',
  store_heli = '[~g~E~s~] Ranger l\'hélicoptère',
  take_heli = '[~g~E~s~] Prendre l\'hélicoptère',
  store_veh = '[~g~E~s~] - Ranger le véhicule',
  armory = 'Armurerie',
  enter_armory = '[~g~E~s~] Armurerie',
  enter_motorworks = '[E] Motorworks', -- English Change
  vehicleLimitReached = "Vehicle Limit Reached", -- English Change
  enter_outfit = '[E] Outfitter', -- English Change
  enter_management = '[E] Manager System', -- English Change
  enter_garage = '[E] Sign Out Vehicle', -- English Change
  trash = 'Poubelle',
  trash_enter = '[~g~E~s~] Poubelle',
  stash_enter = '[~g~E~s~] Entrer dans le Casier'
 },
 menu = {
  garage_title = 'Véhicule de police',
  close = '⬅ Fermer le menu',
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
  duty = 'Set Duty On or Off' -- English Change
 }
}
if GetConvar('qb_locale', 'en') == 'fr' then
 Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
  fallbackLang = Lang,
 })
end