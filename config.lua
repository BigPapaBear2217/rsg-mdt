Config = {}

-- debug
Config.Debug = false

-- MDT settings
Config.MDTKeybind = 'M'
Config.MDTCommand = 'mdt'

-- Law enforcement jobs that can access MDT
Config.AllowedJobs = {
    'vallaw',
    'rholaw', 
    'blklaw',
    'strlaw',
    'stdenlaw'
}

-- Database table names
Config.DBTables = {
    criminal_records = 'mdt_criminal_records',
    warrants = 'mdt_warrants',
    bolos = 'mdt_bolos',
    incidents = 'mdt_incidents',
    citations = 'mdt_citations',
    horses = 'mdt_horses',
    reports = 'mdt_reports',
    logs = 'mdt_logs'
}

-- Feature toggles
Config.Features = {
    criminal_records = true,
    warrants = true,
    bolos = true,
    incidents = true,
    citations = true,
    horses = true,
    telegrams = true,
    bounty_alerts = true
}

-- Telegram integration
Config.TelegramIntegration = true
Config.TelegramResource = 'rsg-telegram'

-- Horse integration
Config.HorseIntegration = true
Config.HorseResource = 'rsg-horses'

-- Sync settings
Config.SyncInterval = 1800 -- 30 minutes in seconds
Config.AutoRegisterHorses = true

-- UI settings
Config.UI = {
    theme = 'rdr2',
    animations = true,
    sound_effects = true
}

-- Search settings
Config.Search = {
    max_results = 100,
    fuzzy_search = true,
    case_sensitive = false
}

-- Notification settings
Config.Notifications = {
    enable = true,
    duration = 5000,
    position = 'top-right'
}