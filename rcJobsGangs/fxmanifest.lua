fx_version "cerulean"
game "gta5"

description "QB-Jobs"
version "0.0.25"

ui_page "nui/index.html"

shared_scripts {
	"configs/*.lua",
	"configs/jobs/*.lua",
	"configs/gangs/*.lua",
 "@qb-core/shared/locale.lua",
 "locales/en.lua",
 "locales/*.lua"
}

client_scripts {
	"@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/ComboZone.lua",
	"client/*.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/*.lua"
}


files {
	"nui/*.html",
	"nui/*.js",
	"nui/*.css"
}

lua54 "yes"