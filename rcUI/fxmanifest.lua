fx_version 'cerulean'
game 'gta5'
description 'rcUI'
version '0.0.001'
shared_scripts {
 '@rcCore/shared/locale.lua',
 'locales/en.lua',
 'locales/*.lua',
 'config.lua'
}
client_script 'client/main.lua'
server_script 'server/main.lua'
ui_page 'html/index.html'
files {
 'html/index.html',
 'html/*',
 'html/styles.css',
 'html/responsive.css',
 'html/app.js',
}
lua54 'yes'