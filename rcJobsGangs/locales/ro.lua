--[[
Romanian base language translation for qb-jobs
Translation done by wanderrer (Martin Riggs#0807 on Discord)
]]--
local Translations = {
 error = {},
 success = {},
 info = {
  new_job_app = "Your application has been submitted for %{job}",
  new_job = 'Congratulations with your new job! (%{job})',
  on_duty = '[E] - Intra in tura',
  off_duty = '[E] - Iesi din tura',
  onoff_duty = '~g~Intra~s~/~r~Iesi~s~ din tura',
  stash = 'Fiset %{value}',
  store_heli = '[E] Parcheaza elicopterul',
  take_heli = '[E] Foloseste elicopterul',
  store_veh = '[E] - Parcheaza vehicul',
  armory = 'Armurier',
  enter_armory = '[E] Armurier',
  enter_motorworks = '[E] Motorworks', -- English Change
  vehicleLimitReached = "Vehicle Limit Reached", -- English Change
  enter_outfit = '[E] Outfitter', -- English Change
  enter_management = '[E] Manager System', -- English Change
  enter_garage = '[E] Sign Out Vehicle', -- English Change
  trash = 'Gunoi',
  trash_enter = '[E] Cos de gunoi',
  stash_enter = '[E] Vestiar'
 },
 menu = {
  garage_title = 'Vehicule MAI',
  close = '⬅ Inchide meniul',
  impound = 'Vehicule confiscate',
  jobs_garage = ' Garage', -- English Change
  jobs_armory = ' Armory', -- English Change
  jobs_duty_station = "Set Duty Status", -- English Change
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
if GetConvar('qb_locale', 'en') == 'ro' then
 Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
  fallbackLang = Lang,
 })
end