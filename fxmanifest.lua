fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'RSG Mobile Data Terminal (MDT) - Standalone Law Enforcement Database System'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
    'client/mdt.lua',
    'client/mdt_pay_citation.lua',
    'client/mdt_criminal_record.lua',
    'client/mdt_bounty_alerts.lua',
    'client/mdt_horses.lua',
    'client/mdt_person_override.lua',
    'client/mdt_override.lua',
    'client/mdt_criminal_override.lua',
    'client/mdt_send_telegram.lua',
    'client/mdt_telegrams.lua',
    'client/mdt_view_person_temp.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/mdt.lua',
    'server/mdt_pay_citation.lua',
    'server/mdt_criminal_record.lua',
    'server/mdt_bounty_alerts.lua',
    'server/mdt_horses.lua',
    'server/mdt_keybind.lua',
    'server/versionchecker.lua',
    'server/mdt_send_telegram.lua',
    'server/mdt_telegrams.lua'
}

files {
    'locales/*.json'
}

dependencies {
    'rsg-core',
    'ox_lib',
    'oxmysql'
}

lua54 'yes'