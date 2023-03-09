local Translations = {
 error = {},
 success = {},
 info = {
  new_job_app = "Your application has been submitted for %{job}",
  new_job = 'Congratulations with your new job! (%{job})',
  on_duty = '[~g~E~s~] - ﺔﻣﺪﺨﻟﺍ ﻝﻮﺧﺩ',
  off_duty = '[~r~E~s~] - ﺔﻣﺪﺨﻟﺍ ﻦﻣ ﺝﻭﺮﺨﻟﺍ',
  onoff_duty = 'ﺔﻣﺪﺨﻟﺍ ﺔﻟﺎﺣ',
  stash = '%{value}',
  store_heli = '[~g~E~s~] ﺝﺍﺮﻏ',
  take_heli = '[~g~E~s~] ﺝﺍﺮﻏ',
  store_veh = '[~g~E~s~] - ﺝﺍﺮﻏ',
  armory = 'Armory',
  enter_armory = '[~g~E~s~] ﺔﺤﻠﺳﻻﺍ ﺔﻧﺰﺧ',
  enter_motorworks = '[E] Motorworks', -- English Change
  vehicleLimitReached = "Vehicle Limit Reached", -- English Change
  enter_outfit = '[E] Outfitter', -- English Change
  enter_management = '[E] Manager System', -- English Change
  enter_garage = '[E] Sign Out Vehicle', -- English Change
  trash = 'ﺮﻳﻭﺪﺘﻟﺍ ﺓﺩﺎﻋﺍ',
  trash_enter = '[~g~E~s~] ﺮﻳﻭﺪﺘﻟﺍ ﺓﺩﺎﻋﺍ',
  stash_enter = '[~g~E~s~] ﻞﺧﺩﺃ',
 },
 menu = {
  garage_title = 'سيارات الشرطة',
  close = '⬅ اغلاق',
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
if GetConvar('qb_locale', 'en') == 'ar' then
 Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
  fallbackLang = Lang,
 })
end