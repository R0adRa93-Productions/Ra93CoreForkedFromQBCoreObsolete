Config.Gangs = Config.Gangs or {}
Config.Gangs.none = {
 ["label"] = "no gang",
 ["webHooks"] = {
  ["noGang"] = ""
 },
 ["defaultDuty"] = true,
 ["offDutyPay"] = false,
 ["inCityHall"] = {
  ["listInCityHall"] = false, -- true he job is sent to city hall | false the job is not in city hall
  ["isManaged"] = true -- true the job is sent to the boss of the job | false the job is automatically assigned
 },
 ["menu"] = {
  ["icons"] = {
   ["applicant"] = "fa-solid fa-user",
   ["applicants"] = "fa-solid fa-users-rectangle",
   ["approve"] = "fa-regular fa-circle-check",
   ["award"] = "fa-solid fa-medal",
   ["boat"] = "fa-solid fa-ship",
--   ["close"] = "fa-regular fa-circle-xmark",
   ["close"] = "fa-solid fa-x",
   ["currentJob"] = "fa-solid fa-kit-medical",
   ["demote"] = "fa-regular fa-thumbs-down",
   ["deniedApplicant"] = "fa-solid fa-user-slash",
   ["deniedApplicants"] = "fa-solid fa-users-slash",
   ["deny"] = "fa-regular fa-circle-xmark",
   ["employee"] = "fa-solid fa-user",
   ["employees"] = "fa-solid fa-users",
   ["fire"] = "fa-solid fa-ban",
   ["helicopter"] = "fa-solid fa-helicopter",
   ["jobGarage"] = "fa-solid fa-square-parking",
   ["jobHistory"] = "fa-regular fa-address-card",
   ["jobStore"] = "fa-solid fa-store",
   ["ownGarage"] = "fa-solid fa-warehouse",
   ["pastEmployee"] = "fa-solid fa-user-slash",
   ["pastEmployees"] = "fa-solid fa-users-slash",
   ["pay"] = "fa-solid fa-hand-holding-dollar",
   ["personal"] = "fa-solid fa-person-circle-exclamation",
   ["plane"] = "fa-solid fa-plane",
   ["promote"] = "fa-regular fa-thumbs-up",
   ["rapSheet"] = "fa-solid fa-handcuffs",
   ["reconsider"] = "fa-solid fa-person-walking-arrow-loop-left",
   ["reprimand"] = "fa-solid fa-triangle-exclamation",
   ["retract"] = "fa-solid fa-angles-left",
   ["returnVehicle"] = "fa-solid fa-rotate-left",
   ["society"] = "fa-solid fa-money-bill-1-wave",
   ["societyDeposit"] = "fa-solid fa-right-to-bracket",
   ["societyWithdrawl"] = "fa-solid fa-right-from-bracket",
   ["vehicle"] = "fa-solid fa-truck-medical",
  },
 },
 ["grades"] = {
  ["0"] = {
   ["name"] = "Unaffiliated"
  }
 }
}