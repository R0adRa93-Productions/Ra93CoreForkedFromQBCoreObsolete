Config = {
 ["enforceDefaultDuty"] = true,
 ["maxPlayers"] = GetConvarInt("sv_maxclients", 48), -- Gets max players from config file, default 48
 ["defaultSpawn"] = vector4(-1035.71, -2731.87, 12.86, 0.0),
 ["updateInterval"] = 5, -- how often to update player data in minutes
 ["statusInterval"] = 5000, -- how often to check hunger/thirst status in milliseconds
 ["player"] = {
  ["hungerRate"] = 4.2, -- Rate at which hunger goes down.
  ["thirstRate"] = 3.8, -- Rate at which thirst goes down.
  ["bloodtypes"] = {
   "A+",
   "A-",
   "B+",
   "B-",
   "AB+",
   "AB-",
   "O+",
   "O-"
  }
 },
 ["server"] = {
  ["closed"] = false, -- Set server closed (no one can join except people with ace permission "qbadmin.join")
  ["closedReason"] = "Server Closed", -- Reason message to display when people can not join the server
  ["uptime"] = 0, -- Time the server has been up.
  ["whitelist"] = false, -- Enable or disable whitelist on the server
  ["whitelistPermission"] = "admin", -- Permission that is able to enter the server when the whitelist is on
  ["pvp"] = true, -- Enable or disable pvp on the server (Ability to shoot other players)
  ["discord"] = "", -- Discord invite link
  ["checkDuplicateLicense"] = true, -- Check for duplicate rockstar license on join
  ["permissions"] = { "god", "admin", "mod" }, -- Add as many groups as you want here after creating them in your server.cfg
 },
 ["notify"] = {
  ["notificationStyling"] = {
   ["group"] = false, -- Allow notifications to stack with a badge instead of repeating
   ["position"] = "right", -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
   ["progress"] = true -- Display Progress Bar
  },
  -- These are how you define different notification variants
  -- The "color" key is background of the notification
  -- The "icon" key is the css-icon code, this project uses `Material Icons` & `Font Awesome`
  --[[ Color Notes
   ["black"] = "^0",
   ["red"] = "^1",
   ["green"] = "^2",
   ["yellow"] = "^3",
   ["blue"] = "^4",
   ["lightBlue"] = "^5",
   ["purple"] = "^6",
   ["white"] = "^7",
   ["orange"] = "^8",
   ["grey"] = "^9"
  ]]--
  ["variantDefinitions"] = {
   ["success"] = {
    ["classes"] = "success",
    ["icon"] = "done",
    ["console"] = "^2",
    ["log"] = "green"
   },
   ["notify"] = {
    ["classes"] = "notify",
    ["icon"] = "info",
    ["console"] = "^4",
    ["log"] = "blue"
   },
   ["error"] = {
    ["classes"] = "error",
    ["icon"] = "dangerous",
    ["console"] = "^1",
    ["log"] = "red"
   },
   ["exploit"] = {
    ["classes"] = "error",
    ["icon"] = "bolt",
    ["console"] = "^8",
    ["log"] = "orange"
   },
   ["police"] = {
    ["classes"] = "police",
    ["icon"] = "local_police"
   },
   ["ambulance"] = {
    ["classes"] = "ambulance",
    ["icon"] = "fas fa-ambulance"
   }
  }
 },
 ["newPlayerLicenses"] = {
  ["driver"] = true,
  ["business"] = false,
  ["weapon"] = false
 },
 ["location"] = {
  ["countryCode"] = "US",
  ["currency"] = {
   ["symbol"] = "$",
   ["types"] = {
    ["cash"] = 500,
    ["bank"] = 5000,
    ["crypto"] = 0
   }, -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
   ["dontAllowMinus"] = {
    "cash",
    "crypto"
   }, -- Money that is not allowed going in minus
   ["payCheckTimeOut"] = 10, -- The time in minutes that it will give the paycheck
   ["payCheckSociety"] = false, -- If true paycheck will come from the society account that the player is employed at, requires rcEconomy
  },
  -- 11-222-333-4444
  -- Each Section is Described as such:
  -- Country Code 11
  -- areaCode 111
  -- exchange 222
  -- subscriberDigits 3333
  ["phone"] = {
   ["countryCode"] = "01",
   ["areaCodeDigits"] = 3,
   ["exchangeDigits"] = 3,
   ["subscriberDigits"] = 4,
  },
 },
 ["playerTables"] = {
  {["table"] = "players"},
  {["table"] = "apartments"},
  {["table"] = "bank_accounts"},
  {["table"] = "crypto_transactions"},
  {["table"] = "phone_invoices"},
  {["table"] = "phone_messages"},
  {["table"] = "playerskins"},
  {["table"] = "player_contacts"},
  {["table"] = "player_houses"},
  {["table"] = "player_mails"},
  {["table"] = "player_outfits"},
  {["table"] = "player_vehicles"}
 }
}