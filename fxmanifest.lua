fx_version 'cerulean'
game 'gta5'

author 'Nano Development'
description 'Spawn system by Nano Development.'
version '1.0.0'

ui_page 'build/index.html'
files {
    'build/*',
	'build/**/*'
}

shared_script 'config.lua'
client_script 'client/*.lua'
server_script 'server/*.lua'

lua54 'yes'