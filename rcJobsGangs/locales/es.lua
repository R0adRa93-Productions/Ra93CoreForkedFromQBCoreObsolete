local Translations = {
 error = {},
 success = {},
 info = {
  new_job_app = "Your application has been submitted for %{job}",
  new_job = 'Congratulations with your new job! (%{job})',
  on_duty = '[E] - Entrar de servicio',
  off_duty = '[E] - Salir de servicio',
  onoff_duty = '~g~On~s~/~r~Fuera~s~ Servicio',
  stash = 'Hueco %{value}',
  store_heli = '[E] Guardar helicoptero',
  take_heli = '[E] Sacar helicpotero',
  store_veh = '[E] - Guardar vehiculo',
  armory = 'Arsenal',
  enter_armory = '[E] Acceder al arsenal',
  enter_motorworks = '[E] Motorworks', -- English Change
  vehicleLimitReached = "Vehicle Limit Reached", -- English Change
  enter_outfit = '[E] Outfitter', -- English Change
  enter_management = '[E] Manager System', -- English Change
  enter_garage = '[E] Sign Out Vehicle', -- English Change
  trash = 'Basura',
  trash_enter = '[E] Papelera',
  stash_enter = '[E] Entrar armario',
 },
 menu = {
  garage_title = 'Vehiculos policia',
  close = '⬅ Cerrar menu',
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
if GetConvar('qb_locale', 'en') == 'es' then
 Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
  fallbackLang = Lang,
 })
end