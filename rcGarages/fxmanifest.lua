fx_version "cerulean"
game "gta5"
description "Ra93Core Garages"
version "0.0.001"
shared_scripts {
 "config.lua",
 "vehicles/*.lua",
 "locale/en.lua",
 "locale/*.lua",
}
client_scripts {
 "client/main.lua",
}
server_scripts {
 "@oxmysql/lib/MySQL.lua",
 "server/main.lua",
}
dependency "oxmysql"
lua54 "yes"