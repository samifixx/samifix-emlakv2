fx_version 'cerulean'
game 'gta5'

author 'Samifix'
description 'samifix-emlakv2'
version '2.0.2'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', 
    'server.lua',
}

dependencies {
    'qb-core',
    'qb-target',
    'qb-input'
}
