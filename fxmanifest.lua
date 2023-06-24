-- Resource Metadata
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
games        { 'rdr3', 'gta5' }

name 'mor-drugsystem'
author 'morpheus1076'
description 'Drogensystem'
version '0.0.4'

client_script {
			"client.lua",
			"config.lua"
		}

server_script {
			'server.lua',
			'@oxmysql/lib/MySQL.lua'
		}

shared_script {'@ox_lib/init.lua'}
