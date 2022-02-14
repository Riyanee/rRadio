fx_version 'adamant'
game 'gta5'

author 'Riyane#7779'
description 'rRadio'
version '1.0.0'

shared_scripts {
    "@es_extended/imports.lua",
    'config.lua'
}

client_scripts {
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/UIHeritage.lua",
	'client/functions.lua',
    'client/menu.lua'
}

server_script 'server/main.lua'