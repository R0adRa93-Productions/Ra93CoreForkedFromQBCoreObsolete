fx_version 'cerulean'
game 'gta5'
description 'Ra93Core Core'
version '0.0.001'
shared_scripts {
 'config.lua',
 'shared/locale.lua',
 'locale/en.lua',
 'locale/*.lua',
 'shared/main.lua',
 'shared/*.lua'
}
client_scripts {
 'client/main.lua',
 'client/functions.lua',
 'client/loops.lua',
 'client/events.lua'
}
server_scripts {
 '@oxmysql/lib/MySQL.lua',
 'server/main.lua',
 'server/functions.lua',
 'server/player.lua',
 'server/events.lua',
 'server/commands.lua',
 'server/exports.lua',
 'server/debug.lua'
}
files {
 'html/index.html',
 'html/css/style.css',
 'html/css/drawtext.css',
 'html/js/*.js'
}
dependency 'oxmysql'
lua54 'yes'