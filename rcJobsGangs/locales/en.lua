local Translations = {
 error = {
  notEnough = "Not Enough Money ($%{value})"
 },
 success = {
  parkingFeesPaid = "Parking Fees Paid ($%{value})",
  rentalFeesPaid = "Rental Fees Paid ($%{value})",
  depositFeesPaid = "Deposit Fees Paid ($%{value})",
  depositReturned = "Deposit Fees Refunded ($%{value})",
  purchasedVehicle = "Vehicle has been purchased!"
 },
 info = {
  enter_garage = '[E] Fleet Manager',
  enter_locker = '[E] Patient Belongings Clerk',
  enter_management = '[E] Personal Assistant',
  enter_motorworks = '[E] Motorworks',
  enter_outfit = '[E] Outfitter',
  enter_shop = '[E] Equipment Manager',
  enter_stash = '[E] Locker Room Manager',
  enter_trash = '[E] Custodian',
  keysReturned = "Keys have been returned!",
  lockerSlot = "Locker Slot",
  new_job = 'Congratulations with your new job! (%{job})',
  new_job_app = "Your application has been submitted for %{job}",
  job_info = 'Job: %{value} | Grade: %{value2} | Duty: %{value3}',
  gang_info = 'Gang: %{value} | Grade: %{value2}',
  onoff_duty = '[E] - Payroll Manager',
  shop = 'Shop',
  stash = 'Stash %{value}',
  store_heli = '[E] Store Helicopter',
  store_veh = '[E] - Store Vehicle',
  take_heli = '[E] Take Helicopter',
  trash = 'Trash',
  vehicleLimitReached = "Vehicle Limit Reached"
 },
 menu = {
  garage_title = ' Vehicles',
  close = '⬅ Close Menu',
  jobs_garage = ' Garage',
  jobs_shop = ' Shop',
  jobs_duty_station = "Set Duty Status",
 },
 headings = {
  stash = 'Stash',
  trash = 'Trash',
  shop = 'Shop',
  locker = "Patient_Belongings_Locker",
  outfit = 'Outfit',
  management = ' Boss Menu',
  garages = ' Vehicle Manager'
 },
 email = {
  jobAppSender = "%{firstname} %{lastname}",
  jobAppSub = "%{job} Application",
  jobAppMsg = "Hello Boss!<br /><br />An application is pending for %{job}.<br /><br />Please review the application with your Personal Assistant at your earliest convienance.<br /><br />Follwing Info Submitted:<br /><br />Full Name: %{firstname} %{lastname}<br />Phone: %{phone}<br />",
  mr = 'Mr',
  mrs = 'Mrs',
 },
 command = {
  duty = 'Set Duty On or Off',
  job = { help = 'Check Your Job' },
  jobs = "Open Multi Job Menu",
  setjob = {
   help = 'Set A Players Job (Admin Only)',
   params = {
 id = { name = 'id', help = 'Player ID' },
 job = { name = 'job', help = 'Job name' },
 grade = { name = 'grade', help = 'Job grade' },
   },
  },
  gang = { help = 'Check Your Gang' },
  gangs = "Open Multi Job Menu",
  setgang = {
   help = 'Set A Players Gang (Admin Only)',
   params = {
 id = { name = 'id', help = 'Player ID' },
 gang = { name = 'gang', help = 'Gang name' },
 grade = { name = 'grade', help = 'Gang grade' },
   },
  },
 },
 denied = {
  noVehicle = "Vehicle Spawn is Missing",
  noGarageSelected = "No Garage Selected",
  invalidGarage = "Invalid Garage"
 },
 nui = {
  buttonOwnGarage = "My Garage",
  buttonMotorpool = "Motorpool",
  buttonJobStore = "Vehicle Shop",
  buttonreturnVehicle = "Return Vehicles"
 }
}
Lang = Lang or Locale:new({
 phrases = Translations,
 warnOnMissing = true
})
