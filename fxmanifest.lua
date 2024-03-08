fx_version 'adamant'

game 'gta5'

name 'LERP-CarLock'
author 'Made by Millxr#0001 on Discord'

lua54 'yes'

shared_script {
	'@ox_lib/init.lua'
}

version '1.0.0'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}

shared_script '@es_extended/imports.lua'
