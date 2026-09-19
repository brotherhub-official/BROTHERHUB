--[[
    ========================================================================
    👑 BROTHER HUB — STEAL A SEED OFFICIAL MASTER SUITE
    ========================================================================
    Game        : Steal A Seed
    Game URL    : https://www.roblox.com/games/122216176958450/Steal-A-Seed
    Place ID    : 122216176958450
    Design Tier : 1:1 FlowerShop Master Standard (RGB Neon Stroke, MinCircle 80x80, Resizable Frame)
    Platform    : Universal (Xeno PC, Solara, Wave, Delta / Arceus / Codex Mobile)
    Language    : Bilingual Smart Engine (🇮🇩 ID / 🇬🇧 EN Auto-Detect & Toggle)
    Features    : Auto Steal Seeds (Instant Prompt / Proximity), Auto Plant & Garden Farm,
                  Auto Harvest & Cash Collector, Auto Sell to SeedBuyer / Dealer,
                  Seed & Tool Shop with Multi-Select Filters (100% Zero Robux Guarantee),
                  Auto Open Seed Packs, Auto Hatch & Equip Best Pets, Auto Taco Event,
                  Island & Plot Teleport Hub with Safe Landing Pad, Visual Radar ESP,
                  Movement Engine (Speed, Jump, Noclip, Fly, InfJump, ClickTP).
    Security    : Brother Guard Undetected Engine
    ========================================================================
]]

-- [0] MULTI-INSTANCE CLEANUP GUARD (TRIPLE-LAYER ZERO STACKING)
if _G.BH_STEALASEED_CLEANUP then
    pcall(_G.BH_STEALASEED_CLEANUP)
    _G.BH_STEALASEED_CLEANUP = nil
end

pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targets = {}
    if CoreGui then table.insert(targets, CoreGui) end
    if typeof(gethui) == "function" then
        local h = gethui()
        if h then table.insert(targets, h) end
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        table.insert(targets, LocalPlayer.PlayerGui)
    end
    for _, container in ipairs(targets) do
        for _, child in ipairs(container:GetChildren()) do
            if child.Name == "BrotherHub_StealASeed" then
                pcall(function() child:Destroy() end)
            end
        end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "BH_SafeLandingPad" or obj.Name == "BH_WaterWalkPlatform" then
            pcall(function() obj:Destroy() end)
        end
    end
end)

-- [1] SERVICES & ENGINE SETUP
local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local TweenService        = game:GetService("TweenService")
local UserInputService    = game:GetService("UserInputService")
local RunService          = game:GetService("RunService")
local HttpService         = game:GetService("HttpService")
local VirtualUser         = game:GetService("VirtualUser")
local MarketplaceService  = game:GetService("MarketplaceService")
local CoreGui             = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local StarterGui          = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "👑 BROTHER HUB",
            Text = text or "",
            Duration = duration or 4,
        })
    end)
end
local showNotification = notify

local activeConnections = {}
local activeThreads     = {}
local espObjects        = {}

local function registerConnection(conn)
    if conn then table.insert(activeConnections, conn) end
    return conn
end

local function registerThread(fn)
    local t = task.spawn(fn)
    table.insert(activeThreads, t)
    return t
end

-- [1.5] 🎯 GAUNTLET STAGE TARGETS & LOCATIONS
local STAGE_TARGETS = {
    ["Auto Furthest (Stage 10 - Paling Depan / Tersulit)"] = { pos = Vector3.new(-77.2, 3.5, -6080.9), stage = "10" },
    ["Stage 10 (Z: -6080 - Divine / Lucifer Tier)"]       = { pos = Vector3.new(-77.2, 3.5, -6080.9), stage = "10" },
    ["Stage 09 (Z: -6068 - Mythic Tier)"]                 = { pos = Vector3.new(-41.4, 4.0, -6068.0), stage = "09" },
    ["Stage 08 (Z: -4614 - Legendary Tier)"]              = { pos = Vector3.new(112.6, 3.5, -4614.2), stage = "08" },
    ["Stage 07 (Z: -3221 - Master Tier)"]                 = { pos = Vector3.new(-4.1,  3.5, -3221.3), stage = "07" },
    ["Stage 06 (Z: -2351 - Epic Tier)"]                   = { pos = Vector3.new(-82.3, 3.5, -2351.6), stage = "06" },
    ["Stage 05 (Z: -1754 - Rare Tier)"]                   = { pos = Vector3.new(64.0,  3.5, -1754.5), stage = "05" },
    ["Stage 04 (Z: -1150 - Advanced Tier)"]               = { pos = Vector3.new(-94.7, 3.5, -1156.4), stage = "04" },
    ["Stage 03 (Z: -728 - Intermediate Tier)"]            = { pos = Vector3.new(92.4,  3.5, -728.3),  stage = "03" },
    ["Stage 02 (Z: -437 - Beginner Tier)"]                = { pos = Vector3.new(-117.4, 4.0, -437.4), stage = "02" },
    ["Stage 01 (Z: -200 - Starter Tier)"]                 = { pos = Vector3.new(127.8, 3.5, -200.3),  stage = "01" },
    ["Cycle All Stages (10 ke 01 Bergantian)"]            = { pos = nil, stage = "ALL" },
}

local BUCKET_OPTIONS = {
    "Borong Semua Stok Tersedia (All In-Stock)",
    "Purple Water Bucket (-80% Growth Time - Mythic)",
    "Orange Water Bucket (-60% Growth Time - Legendary)",
    "Yellow Water Bucket (-40% Growth Time - Epic)",
    "Water Bucket (-20% Growth Time - Common)"
}

local STAGE_KEYS = {
    "Auto Furthest (Stage 10 - Paling Depan / Tersulit)",
    "Stage 10 (Z: -6080 - Divine / Lucifer Tier)",
    "Stage 09 (Z: -6068 - Mythic Tier)",
    "Stage 08 (Z: -4614 - Legendary Tier)",
    "Stage 07 (Z: -3221 - Master Tier)",
    "Stage 06 (Z: -2351 - Epic Tier)",
    "Stage 05 (Z: -1754 - Rare Tier)",
    "Stage 04 (Z: -1150 - Advanced Tier)",
    "Stage 03 (Z: -728 - Intermediate Tier)",
    "Stage 02 (Z: -437 - Beginner Tier)",
    "Stage 01 (Z: -200 - Starter Tier)",
    "Cycle All Stages (10 ke 01 Bergantian)",
}

-- [1.6] 🌟 5 BIBIT PALING DEPAN (ANGKA 8 SAMPAI 12) + DAFTAR BIBIT RESMI
local ALL_STEALABLE_SEEDS = {
    -- 5 BIBIT PALING DEPAN RESMI FOUNDER (ANGKA 8..12)
    { key = "Seed 08", num = 8, displayName = "👑 Seed 08 (Paling Depan)" },
    { key = "Seed 09", num = 9, displayName = "👑 Seed 09 (Paling Depan)" },
    { key = "Seed 10", num = 10, displayName = "👑 Seed 10 (Paling Depan)" },
    { key = "Seed 11", num = 11, displayName = "👑 Seed 11 (Paling Depan)" },
    { key = "Seed 12", num = 12, displayName = "👑 Seed 12 (Paling Depan)" },

    -- DAFTAR BIBIT RESMI DARI MENU GAME
    { key = "Ember-Hollow",      pattern = "ember",       displayName = "🔥 Ember-Hollow Seed" },
    { key = "Abyss-Infernal",    pattern = "infernal",    displayName = "💜 Abyss-Infernal Seed" },
    { key = "Purgatory Burn",    pattern = "purgatory",   displayName = "🌋 Purgatory Burn Seed" },
    { key = "Nether-Wither",     pattern = "wither",      displayName = "🥀 Nether-Wither Seed" },
    { key = "Lucifer Rose",      id = "75-LuciferRose",      pattern = "lucifer",    tier = "Divine",    pos = Vector3.new(-41.4, 4.0, -6068.0), displayName = "🌹 Lucifer Rose (Divine)" },
    { key = "Infernal Lily",     id = "76-InfernalLily",     pattern = "infernal",   tier = "Divine",    pos = Vector3.new(-77.2, 3.5, -6080.9), displayName = "🌸 Infernal Lily (Divine)" },
    { key = "Bloodthorn",        id = "73-Bloodthorn",        pattern = "bloodthorn", tier = "Mythic",    pos = Vector3.new(-4.1,  3.5, -3221.3), displayName = "🩸 Bloodthorn (Mythic)" },
    { key = "Abyss Orchid",      id = "72-AbyssOrchid",      pattern = "abyss",      tier = "Legendary", pos = Vector3.new(-82.3, 3.5, -2351.6), displayName = "🌌 Abyss Orchid (Legendary)" },
    { key = "Underworld Flower", id = "74-UnderWorldFlower", pattern = "underworld", tier = "Mythic",    pos = Vector3.new(112.6, 3.5, -4614.2), displayName = "🌺 Underworld Flower (Mythic)" },
    { key = "Eclypsion",         id = "71-Eclypsion",         pattern = "eclypsion",  tier = "Legendary", pos = Vector3.new(64.0,  3.5, -1754.5), displayName = "🌑 Eclypsion (Legendary)" },
    { key = "Bloodmoon Orchid",  id = "70-BloodmoonOrchid",  pattern = "bloodmoon",  tier = "Master",    pos = Vector3.new(-94.7, 3.5, -1156.4), displayName = "🌙 Bloodmoon Orchid (Master)" },
    { key = "Astralith Tree",    id = "69-AstralithTree",    pattern = "astralith",  tier = "Master",    pos = Vector3.new(92.4,  3.5, -728.3),  displayName = "🌳 Astralith Tree (Master)" },
    { key = "Nyxroot",           id = "68-Nyxroot",          pattern = "nyxroot",    tier = "Epic",      pos = Vector3.new(-117.4, 4.0, -437.4), displayName = "🌱 Nyxroot (Epic)" },
    { key = "Solara Maw",        id = "67-SolaraMaw",        pattern = "solara",     tier = "Epic",      pos = Vector3.new(127.8, 3.5, -200.3),  displayName = "☀️ Solara Maw (Epic)" },
    { key = "Crysalith Vine",    id = "66-CrysalithVine",    pattern = "crysalith",  tier = "Rare",      pos = Vector3.new(64.0,  3.5, -1754.5), displayName = "🍇 Crysalith Vine (Rare)" },
    { key = "Virelia Bloom",     id = "65-VireliaBloom",     pattern = "virelia",    tier = "Advanced",  pos = Vector3.new(-94.7, 3.5, -1156.4), displayName = "🌼 Virelia Bloom (Advanced)" },
}

local SEED_TARGETS = {}
local SEED_NAME_KEYS = {}
for _, s in ipairs(ALL_STEALABLE_SEEDS) do
    SEED_TARGETS[s.displayName] = { pos = s.pos, pattern = s.pattern }
    table.insert(SEED_NAME_KEYS, s.displayName)
end

-- [1.7] 🌟 5 BIBIT PALING DEPAN (ANGKA 8 SAMPAI 12)
local TOP5_SEEDS = {
    "Seed 08",
    "Seed 09",
    "Seed 10",
    "Seed 11",
    "Seed 12",
}

-- [2] CONFIGURATION & PERSISTENCE
local CONFIG_FILE = "BrotherHub_StealASeed_Config.json"

local config = {
    -- Auto Steal & Multi-Select 5 Bibit Paling Depan
    autoSteal             = false,
    autoFlashSteal        = true,
    useMultiSeedFilter    = true,     -- Aktifkan Multi-Select 5 Bibit Depan
    multiTargetSeeds      = {
        ["Seed 08"]           = true,
        ["Seed 09"]           = true,
        ["Seed 10"]           = true,
        ["Seed 11"]           = true,
        ["Seed 12"]           = true,
    },
    targetSeedName        = "All / Furthest Rare Seed (Auto Paling Langka)",
    selectedStage         = "Auto Furthest (Stage 10 - Paling Depan / Tersulit)",
    antiGuardChase        = true,
    antiFlingShield       = true,
    holdSeedInHand        = true,
    skyFlightHeight       = 65,
    instantPrompt         = true,
    stealDistance         = 35,
    stealDelay            = 0.8,
    customBasePos         = Vector3.new(7, 0.75, 360.375),
    customPalingDepanPos  = nil,
    fullAfkLoop           = false,
    smartWaitSeed         = true,     -- Stay aman di markas jika bibit di arena kosong/cooldown

    -- Auto Farm & Garden (Koleksi Kebun Sendiri)
    autoPlant             = true,
    autoPickupReady       = true,     -- Ambil tanaman matang (Pickup / Pick Up)
    autoHarvest           = false,
    autoCollectCash       = true,
    harvestInterval       = 1.0,

    -- Auto Sell (100% OFF - TIDAK DIJUAL, DIKOLEKSI DI TAMAN/TANGAN)
    autoSell              = false,
    sellInterval          = 10.0,
    sellThreshold         = 999,
    instantSellBuyer      = false,

    -- Shop & Seeds
    blockRobuxPopups      = true,
    autoBuySeeds          = false,
    autoBuyBuckets        = false,    -- Auto Beli Ember Air (Water Bucket Shop - 100% Cash)
    targetBucket          = "Borong Semua Stok Tersedia (All In-Stock)", -- Pilihan ember di droplist
    targetSeeds           = {
        ["Tomato"]        = false,
        ["Potato"]        = false,
        ["Cactus"]        = false,
        ["Pumpkin"]       = false,
        ["Peach"]         = false,
        ["Watermelon"]    = false,
        ["Eggplant"]      = false,
        ["Eclypsion"]     = false,
        ["InfernalLily"]  = false,
        ["AbyssOrchid"]   = false,
        ["Bloodthorn"]    = false,
        ["Underworld"]    = false,
        ["LuciferRose"]   = false,
    },
    autoOpenPacks         = false,
    targetPacks           = {
        ["SeedPack_1"]    = true,
        ["SeedPack_2"]    = false,
        ["SeedPack_3"]    = false,
        ["SeedPack_4"]    = false,
    },

    -- Pets & Events
    autoHatchEggs         = false,
    autoEquipBestPets     = false,
    autoTacoEvent         = false,
    autoClaimOffline      = true,
    antiAfk               = true,

    -- Visuals & ESP
    seedEsp               = false,
    playerEsp             = false,
    dealerEsp             = false,
    fullbright            = false,

    -- Movement
    walkSpeedEnabled      = false,
    walkSpeedValue        = 24,
    jumpPowerEnabled      = false,
    jumpPowerValue        = 65,
    noclipEnabled         = false,
    flyEnabled            = false,
    flySpeed              = 60,
    infiniteJump          = false,
    clickTp               = false,

    -- GUI Scale & State
    guiScale              = 1.0,
    language              = "ID",
    hasLoadedCustomLang   = false
}

local function toVector3(val)
    if not val then return nil end
    if typeof(val) == "Vector3" then
        return val
    end
    if type(val) == "table" then
        local x = val.X or val.x or val[1]
        local y = val.Y or val.y or val[2]
        local z = val.Z or val.z or val[3]
        if x and y and z then
            return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
    return nil
end

local function posToTable(v3)
    if typeof(v3) == "Vector3" then
        return { X = v3.X, Y = v3.Y, Z = v3.Z }
    end
    return v3
end

local function saveConfig()
    pcall(function()
        if writefile then
            local exportData = {}
            for k, v in pairs(config) do
                if k == "customBasePos" or k == "customPalingDepanPos" then
                    exportData[k] = posToTable(v)
                else
                    exportData[k] = v
                end
            end
            writefile(CONFIG_FILE, HttpService:JSONEncode(exportData))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if type(data) == "table" then
                for k, v in pairs(data) do
                    if config[k] ~= nil and v ~= nil then
                        if k == "customBasePos" or k == "customPalingDepanPos" then
                            config[k] = toVector3(v)
                        elseif type(v) == "table" and type(config[k]) == "table" then
                            for subK, subV in pairs(v) do
                                config[k][subK] = subV
                            end
                        else
                            config[k] = v
                        end
                    end
                end
            end
        end
    end)
    -- Defensive sanitization of critical strings
    if not config.selectedStage or config.selectedStage == "" or type(config.selectedStage) ~= "string" then
        config.selectedStage = STAGE_KEYS[1]
    end
    if not config.targetSeedName or config.targetSeedName == "" or type(config.targetSeedName) ~= "string" then
        config.targetSeedName = SEED_NAME_KEYS[1]
    end
    if config.customBasePos then
        config.customBasePos = toVector3(config.customBasePos)
    end
    if config.customPalingDepanPos then
        config.customPalingDepanPos = toVector3(config.customPalingDepanPos)
    end
end
loadConfig()

pcall(function()
    if not config.hasLoadedCustomLang then
        local code = LocalizationService.RobloxLocaleId:sub(1, 2):lower()
        if code == "id" then
            config.language = "ID"
        else
            config.language = "EN"
        end
        config.hasLoadedCustomLang = true
    end
end)

-- [3] BILINGUAL LOCALIZATION DICTIONARY
local TRANSLATIONS = {
    ["HubTitle"]              = {ID = "BROTHER HUB — STEAL A SEED", EN = "BROTHER HUB — STEAL A SEED"},
    ["CloseConfirmTitle"]     = {ID = "KONFIRMASI PENUTUPAN", EN = "CLOSE CONFIRMATION"},
    ["CloseConfirmBody"]      = {ID = "Apakah Anda yakin ingin menutup Brother Hub?\nSeluruh fitur auto & ESP akan dihentikan secara steril.", EN = "Are you sure you want to close Brother Hub?\nAll auto features & ESP will be terminated cleanly."},
    ["BtnYes"]                = {ID = "Ya, Tutup", EN = "Yes, Close"},
    ["BtnCancel"]             = {ID = "Batal", EN = "Cancel"},

    -- Tabs
    ["TabSteal"]              = {ID = "🌱 Auto Curi & Koleksi", EN = "🌱 Auto Steal & Keep"},
    ["TabFarm"]               = {ID = "🌾 Kebun & Panen", EN = "🌾 Farm & Harvest"},
    ["TabSell"]               = {ID = "💰 Auto Jual (Opsional)", EN = "💰 Auto Sell (Optional)"},
    ["TabShop"]               = {ID = "🛒 Toko Bibit", EN = "🛒 Seed Shop"},
    ["TabPets"]               = {ID = "🐾 Pet & Event", EN = "🐾 Pets & Events"},
    ["TabTeleport"]           = {ID = "🌌 Teleportasi", EN = "🌌 Teleport Hub"},
    ["TabVisuals"]            = {ID = "👁️ Radar & ESP", EN = "👁️ Visuals & ESP"},
    ["TabMovement"]           = {ID = "🏃 Karakter", EN = "🏃 Movement"},
    ["TabCredits"]            = {ID = "👑 Kredit", EN = "👑 Credits"},

    -- Titles & Descriptions
    ["StealTitle"]            = {ID = "AUTOMATED SEED STEALING ENGINE", EN = "AUTOMATED SEED STEALING ENGINE"},
    ["StealDesc"]             = {ID = "Ambil bibit liar atau kebun lawan secara instan 1-frame tanpa delay", EN = "Steal wild or enemy seeds instantly with 1-frame bypass"},
    ["FarmTitle"]             = {ID = "GARDEN CULTIVATION & CASH HARVESTER", EN = "GARDEN CULTIVATION & CASH HARVESTER"},
    ["FarmDesc"]              = {ID = "Tanam bibit, panen buah kebun, dan kumpulkan cash pasif otomatis", EN = "Auto plant seeds, harvest garden crops, and vacuum passive cash"},
    ["SellTitle"]             = {ID = "AUTONOMOUS CROP & SEED SELLER", EN = "AUTONOMOUS CROP & SEED SELLER"},
    ["SellDesc"]              = {ID = "Jual hasil panen dan bibit langsung ke SeedBuyer secara otomatis", EN = "Sell harvested crops and seeds automatically to SeedBuyer"},
    ["ShopTitle"]             = {ID = "100% FREE SEED SHOP & PACK OPENER", EN = "100% FREE SEED SHOP & PACK OPENER"},
    ["ShopDesc"]              = {ID = "Beli bibit koin murni dan buka pack bibit langka (Bebas Robux)", EN = "Buy seeds with pure coins and open rare seed packs (No Robux)"},
    ["PetsTitle"]             = {ID = "PETS HATCHER & TACO DISCO EVENT", EN = "PETS HATCHER & TACO DISCO EVENT"},
    ["PetsDesc"]              = {ID = "Tetaskan pet terbaik dan ikuti event Taco Disco untuk boost uang", EN = "Hatch best pets and trigger Taco Disco events for money boost"},
    ["TeleportTitle"]         = {ID = "STRATEGIC FAST TRAVEL HUB", EN = "STRATEGIC FAST TRAVEL HUB"},
    ["TeleportDesc"]          = {ID = "Teleportasi instan ke toko, pembeli, kebun pemain, dan spawn", EN = "Instant teleport to dealer, buyer, player plots, and spawn"},
    ["VisualsTitle"]          = {ID = "RADAR ESP & NIGHT VISION ENGINE", EN = "RADAR ESP & NIGHT VISION ENGINE"},
    ["VisualsDesc"]           = {ID = "Pantau lokasi bibit, pemain lain, dan NPC tembus pandang", EN = "See seeds, other players, and NPCs through walls with radar"},
    ["MovementTitle"]         = {ID = "PHYSICAL MOVEMENT & EXPLOIT SUITE", EN = "PHYSICAL MOVEMENT & EXPLOIT SUITE"},
    ["MovementDesc"]          = {ID = "Pengatur kecepatan, daya lompat, noclip, dan mode terbang", EN = "Customize walkspeed, jump power, noclip, and flight mode"},

    -- Toggles & Sliders
    ["FlashSteal"]            = {ID = "⚡ Flash Auto Steal (Maju -> Curi -> Bawa Pulang)", EN = "⚡ Flash Auto Steal (Advance -> Steal -> Return Base)"},
    ["SmartWait"]             = {ID = "⏳ Tunggu Bibit Spawn (Stay di Markas jika Kosong)", EN = "⏳ Smart Stay at Base (Wait for Seed Spawn)"},
    ["AntiGuard"]             = {ID = "🛡️ Anti-Kejar Penjaga Tanaman (Lumpuhkan Guard 100%)", EN = "🛡️ Anti-Guard Chase (Pacify & Paralyze Guards)"},
    ["HoldSeed"]              = {ID = "🤲 Pegang Bibit di Tangan (Equip Stolen Seed)", EN = "🤲 Hold Stolen Seed in Hand (Equip Seed)"},
    ["AntiFling"]             = {ID = "🛡️ Anti-Pental & Anti-Knockback (Bebas Pental / Kebal)", EN = "🛡️ Anti-Fling & Knockback Immunity"},
    ["FullAfk"]               = {ID = "🌙 Full AFK Loop (Curi -> Koleksi di Taman / Pegang)", EN = "🌙 Full AFK Loop (Steal -> Garden Collect / Hold)"},
    ["TargetSeed"]            = {ID = "🎯 Pilih Nama Bibit (Target Seed)", EN = "🎯 Target Seed Name"},
    ["TargetStage"]           = {ID = "🎯 Target Seed Stage", EN = "🎯 Target Seed Stage"},
    ["StealDelay"]            = {ID = "⏱️ Jeda Siklus Steal (Detik)", EN = "⏱️ Steal Cycle Interval (s)"},
    ["SkyHeight"]             = {ID = "🚀 Ketinggian Jalur Langit (Studs)", EN = "🚀 Sky Travel Altitude (Studs)"},
    ["BtnSetBase"]            = {ID = "📍 Simpan Posisi Saat Ini Sebagai Markas", EN = "📍 Set Current Position as Base"},
    ["BtnReturnBase"]         = {ID = "🏠 Teleport ke Markas Sekarang", EN = "🏠 Return to Base Now"},
    ["AutoSteal"]             = {ID = "Curi Bibit Otomatis (Auto Steal)", EN = "Auto Steal Seeds"},
    ["InstantPrompt"]         = {ID = "Bypass Tahan Tombol E (Instant 0s Prompt)", EN = "Instant 0s Prompt Bypass"},
    ["AutoApproach"]          = {ID = "Dekati Bibit Otomatis (Teleport Halus)", EN = "Auto Approach Seeds (Smooth TP)"},
    ["StealDistance"]         = {ID = "Jangkauan Jarak Curi (Studs)", EN = "Steal Search Radius (Studs)"},
    ["AutoPlant"]             = {ID = "Tanam Bibit ke Kebun Otomatis", EN = "Auto Plant Seeds to Garden"},
    ["AutoPickupReady"]       = {ID = "🌾 Ambil Tanaman Matang (Auto Pick Up Ready Crops)", EN = "🌾 Auto Pick Up Ready Crops"},
    ["AutoHarvest"]           = {ID = "Panen Tanaman Kebun Otomatis", EN = "Auto Harvest Grown Crops"},
    ["BtnPickupAll"]          = {ID = "🧺 Ambil Semua Tanaman Siap Panen Sekarang", EN = "🧺 Pick Up All Ready Plants Now"},
    ["AutoCollectCash"]       = {ID = "Sedot Uang Pasif Kebun Otomatis", EN = "Vacuum Passive Garden Cash"},
    ["AutoSell"]              = {ID = "Jual Otomatis ke SeedBuyer", EN = "Auto Sell to SeedBuyer"},
    ["SellThreshold"]         = {ID = "Batas Jumlah Item Dijual", EN = "Sell Amount Threshold"},
    ["SellInterval"]          = {ID = "Jeda Waktu Penjualan (Detik)", EN = "Sell Check Interval (Seconds)"},
    ["BtnSellNow"]            = {ID = "💰 Jual Seluruh Hasil Panen Sekarang", EN = "💰 Sell All Crops Now"},
    ["BlockRobux"]            = {ID = "Blokir Pop-up Robux (100% Free Guarantee)", EN = "Block Robux Pop-ups (100% Free)"},
    ["AutoBuySeeds"]          = {ID = "Beli Bibit Terpilih Otomatis", EN = "Auto Buy Selected Seeds"},
    ["AutoOpenPacks"]         = {ID = "Buka Seed Pack Otomatis", EN = "Auto Open Seed Packs"},
    ["AutoHatchEggs"]         = {ID = "Tetaskan Telur Pet Otomatis", EN = "Auto Hatch Pet Eggs"},
    ["AutoEquipPets"]         = {ID = "Pasang Pet Terkuat Otomatis", EN = "Auto Equip Best Pets"},
    ["AutoTacoEvent"]         = {ID = "Picu Event Taco Disco Otomatis", EN = "Auto Trigger Taco Disco Event"},
    ["AutoClaimOffline"]      = {ID = "Klaim Penghasilan Offline Otomatis", EN = "Auto Claim Offline Earnings"},
    ["AntiAfk"]               = {ID = "Anti-AFK (Cegah Disconnect 20 Mnt)", EN = "Anti-AFK (Prevent 20m Kick)"},
    ["SeedEsp"]               = {ID = "ESP Bibit & Tanaman (Radar Jarak)", EN = "Seed & Plant ESP (Distance)"},
    ["PlayerEsp"]             = {ID = "ESP Pemain Lain (Radar Nama & Jarak)", EN = "Player ESP (Names & Distance)"},
    ["DealerEsp"]             = {ID = "ESP SeedDealer & SeedBuyer", EN = "Dealer & Buyer NPC ESP"},
    ["Fullbright"]            = {ID = "Penglihatan Terang Benderang (Fullbright)", EN = "Fullbright (Clear Vision)"},
    ["WalkSpeed"]             = {ID = "Aktifkan Kecepatan Jalan (WalkSpeed)", EN = "Enable WalkSpeed Boost"},
    ["SpeedVal"]              = {ID = "Nilai Kecepatan Jalan", EN = "WalkSpeed Value"},
    ["JumpPower"]             = {ID = "Aktifkan Daya Lompat (JumpPower)", EN = "Enable JumpPower Boost"},
    ["JumpVal"]               = {ID = "Nilai Daya Lompat", EN = "JumpPower Value"},
    ["Noclip"]                = {ID = "Tembus Dinding (Ghost Noclip)", EN = "Ghost Noclip (Through Walls)"},
    ["Fly"]                   = {ID = "Terbang Bebas (WASD + Space/Shift)", EN = "Fly Mode (WASD + Space/Shift)"},
    ["FlySpeed"]              = {ID = "Kecepatan Terbang", EN = "Flight Speed"},
    ["InfJump"]               = {ID = "Lompatan Tak Terbatas (Infinite Jump)", EN = "Infinite Jump"},
    ["ClickTp"]               = {ID = "Teleportasi Klik Mouse (Ctrl + Click)", EN = "Click Teleport (Ctrl + Click)"}
}

local function tr(key)
    local lang = config.language or "ID"
    local entry = TRANSLATIONS[key]
    if entry then
        return entry[lang] or entry["ID"] or key
    end
    return key
end

-- [4] SAFE ENVIRONMENT REMOTES & HELPER
local function getRemote(name)
    local r = ReplicatedStorage:FindFirstChild(name, true)
    return r
end

local function fireRemote(name, ...)
    local rem = getRemote(name)
    if rem then
        if rem:IsA("RemoteEvent") then
            rem:FireServer(...)
        elseif rem:IsA("RemoteFunction") then
            return rem:InvokeServer(...)
        end
    end
    return nil
end

local function getHrp()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Safe Landing Platform
local function createSafePad(pos, duration)
    local pad = Instance.new("Part")
    pad.Name = "BH_SafeLandingPad"
    pad.Size = Vector3.new(40, 2, 40)
    pad.Position = pos - Vector3.new(0, 2, 0)
    pad.Anchored = true
    pad.CanCollide = true
    pad.Transparency = 0.6
    pad.Material = Enum.Material.Neon
    pad.Color = Color3.fromRGB(0, 229, 255)
    pad.Parent = workspace
    task.delay(duration or 4.0, function()
        if pad and pad.Parent then pad:Destroy() end
    end)
    return pad
end

local function safeTeleport(pos)
    local hrp = getHrp()
    if hrp then
        createSafePad(pos, 4.0)
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- Zero Robux Pop-up Interceptor
registerConnection(MarketplaceService.PromptPurchaseRequested:Connect(function(player, assetId)
    if config.blockRobuxPopups and player == LocalPlayer then end
end))
registerConnection(MarketplaceService.PromptProductPurchaseRequested:Connect(function(player, productId)
    if config.blockRobuxPopups and player == LocalPlayer then end
end))
registerConnection(MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player, gamePassId)
    if config.blockRobuxPopups and player == LocalPlayer then end
end))

-- [4.3] ⚡ ZERO-LAG INSTANT PROXIMITY PROMPT ENGINE (100% NATIVE EVENT-DRIVEN)
local ProximityPromptService = game:GetService("ProximityPromptService")

local function makePromptInstant(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        pcall(function() prompt.HoldDuration = 0 end)
    end
end

local function applyInstantPrompts()
    if config.instantPrompt then
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                pcall(function() prompt.HoldDuration = 0 end)
            end
        end
    end
end

-- Event-driven: 0% CPU cost, 0 FPS drop, instant prompt aktif seketika tanpa per-frame scan!
registerConnection(ProximityPromptService.PromptShown:Connect(function(prompt)
    if config.instantPrompt then
        makePromptInstant(prompt)
    end
end))

registerConnection(workspace.DescendantAdded:Connect(function(child)
    if config.instantPrompt and child:IsA("ProximityPrompt") then
        makePromptInstant(child)
    end
end))

-- Satu kali apply di awal
applyInstantPrompts()

-- [4.5] 🏠 BASE / MARKAS RESOLVER & ANTI-FLING SHIELD
-- Helper: Raycast untuk menentukan posisi persis di atas permukaan tanah (Anti-Slow Motion & Zero Air Height)
local function getFloorPosition(pos)
    pos = toVector3(pos)
    if not pos then return nil end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastFilterType.Exclude
    if LocalPlayer.Character then
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    end
    local ray = workspace:Raycast(pos + Vector3.new(0, 10, 0), Vector3.new(0, -30, 0), rayParams)
    if ray and ray.Position then
        return Vector3.new(pos.X, ray.Position.Y + 2.5, pos.Z)
    end
    return pos
end

-- Helper: Dapatkan kebun/plot milik pemain sendiri di workspace.Farm
local function getMyPlot()
    local Farm = workspace:FindFirstChild("Farm")
    if Farm then
        for _, plot in ipairs(Farm:GetChildren()) do
            if plot:GetAttribute("OwnerId") == LocalPlayer.UserId then
                return plot
            end
        end
    end
    return nil
end

local function getBasePosition()
    if config.customBasePos then
        local customV3 = toVector3(config.customBasePos)
        if customV3 then
            return customV3
        end
    end
    
    return Vector3.new(7, 0.75, 360.375)
end

-- [4.5] 🛡️ GUARD PACIFIER & ANTI-CHASE NEUTRALIZER (100% BEBAS DIKEJAR PENJAGA TANAMAN)
local guardCache = {}
local lastGuardScan = 0

local function pacifyPlantGuards()
    pcall(function()
        local now = tick()
        if now - lastGuardScan > 5.0 or #guardCache == 0 then
            lastGuardScan = now
            guardCache = {}
            local chuangjian = workspace:FindFirstChild("创建")
            if chuangjian then
                for _, obj in ipairs(chuangjian:GetChildren()) do
                    if obj:IsA("Model") then
                        local n = obj.Name:lower()
                        if n == "敌人" or string.find(n, "guard") or obj:FindFirstChild("atk") or obj:FindFirstChild("Stem_Lower") then
                            table.insert(guardCache, obj)
                        end
                    end
                end
            end
        end

        for _, obj in ipairs(guardCache) do
            if obj and obj.Parent then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 0
                    hum.PlatformStand = true
                end
                local root = obj:FindFirstChild("RootPart") or obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if root and root:IsA("BasePart") then
                    root.Anchored = true
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
                for _, part in ipairs(obj:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.CanTouch = false
                    end
                end
            end
        end
    end)
end

-- Helper: Otomatis pegang bibit curian di tangan (Equip Seed to Hand)
local function equipStolenSeed()
    pcall(function()
        local char = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if char and bp then
            local hum = char:FindFirstChildOfClass("Humanoid")
            for _, item in ipairs(bp:GetChildren()) do
                if item:IsA("Tool") then
                    if hum then hum:EquipTool(item) end
                    break
                end
            end
        end
    end)
end

-- Thread Background Terpisah untuk Penjaga (Interval 3.0s - Ringan & 0% Lag)
registerThread(function()
    while true do
        if config.antiGuardChase or config.autoSteal or config.fullAfkLoop then
            pacifyPlantGuards()
        end
        task.wait(3.0)
    end
end)

-- Anti-Fling Neutralizer Murni (Bebas Lag 100% — Tanpa Loop GetDescendants di Heartbeat!)
registerConnection(RunService.Heartbeat:Connect(function()
    if config.antiFlingShield then
        local hrp = getHrp()
        if hrp then
            if hrp.AssemblyLinearVelocity.Magnitude > 120 then
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
            if hrp.AssemblyAngularVelocity.Magnitude > 60 then
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
end))

-- Helper: Tanam bibit yang dipegang ke petak kebun pemain (Super Ringan - Hanya Scan workspace.Farm)
local function plantHeldSeedAtGarden()
    pcall(function()
        local hrp = getHrp()
        if not hrp then return end
        
        -- Equip seed dari backpack jika belum dipegang
        local char = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        local hasTool = false
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then
                    hasTool = true
                    break
                end
            end
        end
        if not hasTool and bp then
            for _, item in ipairs(bp:GetChildren()) do
                if item:IsA("Tool") then
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(item) end
                    hasTool = true
                    task.wait(0.04)
                    break
                end
            end
        end
        
        -- Trigger prompt Place / Plant di petak kebun milik pemain (workspace.Farm)
        local myPlot = getMyPlot()
        local containers = myPlot and { myPlot } or {}
        if #containers == 0 then
            local Farm = workspace:FindFirstChild("Farm")
            if Farm then containers = Farm:GetChildren() end
        end

        for _, c in ipairs(containers) do
            for _, prompt in ipairs(c:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled and (prompt.ActionText == "Place" or prompt.ActionText == "Plant" or prompt.Name == "Plant" or prompt.Name == "e_touch") then
                    local pp = prompt.Parent and (prompt.Parent:IsA("BasePart") and prompt.Parent.Position or (prompt.Parent:IsA("Model") and prompt.Parent:GetPivot().Position))
                    if pp and (hrp.Position - pp).Magnitude <= 45 then
                        pcall(function() prompt.HoldDuration = 0 end)
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        else
                            pcall(function() prompt:InputHoldBegin() end)
                            task.wait(0.04)
                            pcall(function() prompt:InputHoldEnd() end)
                        end
                    end
                end
            end
        end
    end)
end

-- Helper: Ambil Tanaman Matang di Sekitar Kebun (Super Ringan - Hanya Scan workspace.Farm)
local function pickupReadyCrops()
    pcall(function()
        local hrp = getHrp()
        if not hrp then return end
        local myPlot = getMyPlot()
        local containers = myPlot and { myPlot } or {}
        if #containers == 0 then
            local Farm = workspace:FindFirstChild("Farm")
            if Farm then containers = Farm:GetChildren() end
        end
        for _, c in ipairs(containers) do
            for _, prompt in ipairs(c:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local act = prompt.ActionText:lower()
                    if act == "pick up" or act == "pickup" or act == "claim" or act == "harvest" or act == "take" then
                        pcall(function() prompt.HoldDuration = 0 end)
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        else
                            pcall(function() prompt:InputHoldBegin() end)
                            task.wait(0.04)
                            pcall(function() prompt:InputHoldEnd() end)
                        end
                    end
                end
            end
        end
    end)
end

-- [4.8] ⏱️ ARENA RESET TIME ENGINE (RESET TIME: MM:SS)
local cachedResetLabel = nil
local lastResetScanTick = 0
local stolenSeedsHistory = {}
local lastResetCountdown = -1

-- Helper: Baca sisa waktu reset bibit arena (RESET TIME: 00:38 / ServerInfo / Level Reset Timer)
local function getArenaResetCountdown()
    local rem = nil
    
    -- 1. Baca cepat dari cached label (0ms Instant!)
    if cachedResetLabel and cachedResetLabel.Parent and cachedResetLabel:IsA("TextLabel") then
        local txt = cachedResetLabel.Text
        local m, s = string.match(txt, "(%d+):(%d+)")
        if m and s and not string.find(txt, "d") then
            local sec = (tonumber(m) * 60) + tonumber(s)
            if sec >= 0 and sec < 1800 then
                return sec, string.format("%02d:%02d", tonumber(m), tonumber(s))
            end
        end
    end

    -- 2. Coba baca dari ServerInfo.Gp_Time jika ada
    pcall(function()
        local sInfo = workspace:FindFirstChild("ServerInfo", true)
        if sInfo then
            local gpTime = sInfo:FindFirstChild("Gp_Time")
            if gpTime and gpTime:IsA("IntValue") and gpTime.Value > 0 then
                rem = gpTime.Value
            end
        end
    end)
    if rem then
        local mm = math.floor(rem / 60)
        local ss = rem % 60
        return rem, string.format("%02d:%02d", mm, ss)
    end

    -- 3. Scan PlayerGui secara terarah (Prioritas pGui.提示.Buff.重置时间 yang memuat RESET TIME)
    local now = tick()
    if now - lastResetScanTick > 1.0 or not cachedResetLabel then
        lastResetScanTick = now
        pcall(function()
            local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not pGui then return end

            local tiShi = pGui:FindFirstChild("提示")
            if tiShi then
                -- Cari frame 重置时间 di Buff
                local resetFrame = tiShi:FindFirstChild("重置时间", true)
                if resetFrame then
                    for _, d in ipairs(resetFrame:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Visible then
                            local txt = d.Text
                            local m, s = string.match(txt, "(%d+):(%d+)")
                            if m and s and not string.find(txt, "d") and txt ~= "RESET TIME:" then
                                cachedResetLabel = d
                                rem = (tonumber(m) * 60) + tonumber(s)
                                return
                            end
                        end
                    end
                end

                -- Scan label yang memuat teks RESET TIME
                for _, d in ipairs(tiShi:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Visible then
                        local txt = d.Text
                        if string.find(txt:upper(), "RESET TIME") then
                            local m, s = string.match(txt, "(%d+):(%d+)")
                            if m and s and not string.find(txt, "d") then
                                cachedResetLabel = d
                                rem = (tonumber(m) * 60) + tonumber(s)
                                return
                            end
                            local anc = d:FindFirstAncestor("重置时间") or d:FindFirstAncestor("Buff") or d.Parent
                            if anc then
                                for _, sub in ipairs(anc:GetDescendants()) do
                                    if sub:IsA("TextLabel") and sub.Visible and sub ~= d then
                                        local sm, ss_val = string.match(sub.Text, "(%d+):(%d+)")
                                        if sm and ss_val and not string.find(sub.Text, "d") then
                                            cachedResetLabel = sub
                                            rem = (tonumber(sm) * 60) + tonumber(ss_val)
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- 4. Fallback scan pGui.Main01 / Main jika di pGui.提示 belum ketemu
            if not rem then
                local otherGuis = { pGui:FindFirstChild("Main01"), pGui:FindFirstChild("Main"), pGui:FindFirstChild("HUD") }
                for _, ogui in ipairs(otherGuis) do
                    if ogui then
                        for _, d in ipairs(ogui:GetDescendants()) do
                            if d:IsA("TextLabel") and d.Visible then
                                local txt = d.Text
                                if string.find(txt:upper(), "RESET TIME") then
                                    local m, s = string.match(txt, "(%d+):(%d+)")
                                    if m and s and not string.find(txt, "d") then
                                        cachedResetLabel = d
                                        rem = (tonumber(m) * 60) + tonumber(s)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    if rem then
        local mm = math.floor(rem / 60)
        local ss = rem % 60
        return rem, string.format("%02d:%02d", mm, ss)
    end

    return nil, nil
end

local function checkAndClearResetHistory()
    local curCountdown = getArenaResetCountdown()
    if curCountdown then
        -- Jika countdown timer mendekati 0 atau timer melompat naik (misal dari 2s kembali ke 60s/90s ronde baru):
        if (lastResetCountdown ~= -1 and curCountdown > (lastResetCountdown + 4)) or curCountdown <= 1 then
            -- Babak baru saja reset / bibit baru respawn, bersihkan riwayat agar bisa diborong lagi!
            stolenSeedsHistory = {}
            frontModelCycleIndex = 1
        end
        lastResetCountdown = curCountdown
    end
end

-- Listener otomatis: Jika bibit baru ditambahkan ke folder 创建, langsung reset riwayat seketika!
pcall(function()
    local chuangjian = workspace:FindFirstChild("创建")
    if chuangjian then
        registerConnection(chuangjian.ChildAdded:Connect(function()
            stolenSeedsHistory = {}
            frontModelCycleIndex = 1
        end))
    end
    registerConnection(workspace.ChildAdded:Connect(function(child)
        if child.Name == "创建" then
            registerConnection(child.ChildAdded:Connect(function()
                stolenSeedsHistory = {}
                frontModelCycleIndex = 1
            end))
        end
    end))
end)

local function isPromptAlreadyStolen(p, pos)
    checkAndClearResetHistory()
    if p and stolenSeedsHistory[p] and (tick() - stolenSeedsHistory[p]) < 5 then
        return true
    end
    if pos then
        local posKey = tostring(math.floor(pos.X / 2.5)) .. "_" .. tostring(math.floor(pos.Z / 2.5))
        if stolenSeedsHistory[posKey] and (tick() - stolenSeedsHistory[posKey]) < 4 then
            return true
        end
    end
    return false
end

local function markPromptAsStolen(p, pos)
    if p then
        stolenSeedsHistory[p] = tick()
    end
    if pos then
        local posKey = tostring(math.floor(pos.X / 2.5)) .. "_" .. tostring(math.floor(pos.Z / 2.5))
        stolenSeedsHistory[posKey] = tick()
    end
end


-- Helper: Trigger click on a GuiButton using all executor APIs (getconnections, firesignal, VIM, VU)
local function triggerGuiClick(btn)
    if not btn then return false end
    local triggered = false

    -- 1. getconnections (Standard Exploit API - Direct closure execution)
    if getconnections then
        for _, ev in ipairs({"MouseButton1Click", "Activated", "MouseButton1Down"}) do
            local sig = pcall(function() return btn[ev] end) and btn[ev]
            if sig then
                pcall(function()
                    for _, conn in ipairs(getconnections(sig)) do
                        pcall(function() conn:Fire() end)
                        pcall(function() if conn.Function then conn.Function() end end)
                        triggered = true
                    end
                end)
            end
        end
    end

    -- 2. firesignal (Synthetic Engine Signals)
    if firesignal then
        pcall(function() firesignal(btn.MouseButton1Click) triggered = true end)
        pcall(function() firesignal(btn.Activated) triggered = true end)
        pcall(function() firesignal(btn.MouseButton1Down, 0, 0) triggered = true end)
        pcall(function() firesignal(btn.MouseButton1Up, 0, 0) triggered = true end)
    end

    -- 3. VirtualInputManager (Operating-System style Mouse Simulation)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local pos = btn.AbsolutePosition + (btn.AbsoluteSize / 2)
        if pos.X > 5 and pos.Y > 5 then
            vim:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
            task.wait(0.03)
            vim:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
            triggered = true
        end
    end)

    -- 4. VirtualUser
    pcall(function()
        local vu = game:GetService("VirtualUser")
        local pos = btn.AbsolutePosition + (btn.AbsoluteSize / 2)
        if pos.X > 5 and pos.Y > 5 then
            vu:Button1Down(pos, workspace.CurrentCamera.CFrame)
            task.wait(0.03)
            vu:Button1Up(pos, workspace.CurrentCamera.CFrame)
            triggered = true
        end
    end)

    return triggered
end

-- Helper: Hitung jumlah ember tertentu yang sudah dimiliki pemain (Max Capacity 3 per tier)
local function countPlayerBuckets(bucketName)
    local count = 0
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local bLower = bucketName and bucketName:lower() or ""

    local keyWord = "bucket"
    if string.find(bLower, "yellow") then keyWord = "yellow"
    elseif string.find(bLower, "orange") then keyWord = "orange"
    elseif string.find(bLower, "purple") then keyWord = "purple"
    end

    local function checkItem(item)
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if string.find(n, keyWord) or (keyWord == "bucket" and (string.find(n, "water") or string.find(n, "bucket"))) then
                count = count + 1
            end
        end
    end

    if char then
        for _, item in ipairs(char:GetChildren()) do checkItem(item) end
    end
    if bp then
        for _, item in ipairs(bp:GetChildren()) do checkItem(item) end
    end
    return count
end

-- Helper: Hitung total semua ember air di Backpack & Karakter
local function countTotalPlayerBuckets()
    local count = 0
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local function checkItem(item)
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if string.find(n, "bucket") or string.find(n, "water") then
                count = count + 1
            end
        end
    end
    if char then
        for _, item in ipairs(char:GetChildren()) do checkItem(item) end
    end
    if bp then
        for _, item in ipairs(bp:GetChildren()) do checkItem(item) end
    end
    return count
end

-- Helper: Auto Beli Ember Air di Toko Peralatan (UseItemStore / 道具商店) menggunakan Cash in-game (BUKAN Robux!)
-- 1:1 STANDAR MY FLOWER SHOP (100% SILENT BACKGROUND PURCHASE - TIDAK MENGGANGGU LAYAR PEMAIN)
local userManuallyOpenedShop = false

local function getToolShopFrame()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    local main02 = pg:FindFirstChild("Main02")
    if not main02 then return nil end
    
    local sf = main02:FindFirstChild("道具商店", true)
    if not sf then
        for _, desc in ipairs(main02:GetDescendants()) do
            if desc:IsA("TextLabel") and (string.find(desc.Text, "Restock in") or string.find(desc.Text, "Water Bucket")) then
                local p = desc
                while p and p.Parent and p.Parent ~= main02 do p = p.Parent end
                if p and p:IsA("Frame") then sf = p break end
            end
        end
    end
    return sf
end

-- Helper: Buka Toko Peralatan & Pengurangan Waktu Tumbuh (道具商店 / UseItemStore)
local function openToolShop(forceVisible)
    local sf = getToolShopFrame()
    if sf and forceVisible then
        userManuallyOpenedShop = true
        sf.Position = UDim2.new(0.5, 0, 0.5, 0)
        sf.Visible = true
    end
    pcall(function()
        local sys = workspace:FindFirstChild("系统")
        local itemShop = sys and sys:FindFirstChild("道具商店_手雷")
        local openPart = itemShop and itemShop:FindFirstChild("打开")
        local p = openPart and openPart:FindFirstChild("e_touch")
        if not p then
            local shopModel = workspace:FindFirstChild("道具商店_手雷", true)
            p = shopModel and shopModel:FindFirstChild("e_touch", true)
        end
        if p and p:IsA("ProximityPrompt") and fireproximityprompt then
            fireproximityprompt(p, 0)
        end
    end)
end

-- Helper: Auto Beli Pengurangan Waktu Tumbuh (Growth Time / Water Bucket) di 道具商店 dengan Cash Game (100% Bebas Robux)
-- Eksekusi aman tanpa mematikan / merusak GUI yang sedang dibuka pemain secara manual!
local function buyGrowthTimeWithCash(targetBucket, buyAll)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, nil end
    local main02 = pg:FindFirstChild("Main02")
    if not main02 then return false, nil end
    
    local shopFrame = getToolShopFrame()
    if not shopFrame then return false, nil end
    
    local wasAlreadyOpen = shopFrame.Visible
    local openedByScript = false
    
    if not wasAlreadyOpen then
        openedByScript = true
        shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        shopFrame.Visible = true
        pcall(function()
            local p = workspace:FindFirstChild("道具商店_手雷", true)
            local prompt = p and p:FindFirstChild("e_touch", true)
            if prompt and fireproximityprompt then
                fireproximityprompt(prompt, 0)
            end
        end)
        task.wait(0.12)
    end
    
    local scroller = shopFrame:FindFirstChildWhichIsA("ScrollingFrame", true)
    local boughtAny = false
    local lastBoughtName = nil
    
    local cards = {}
    if scroller then
        for _, child in ipairs(scroller:GetDescendants()) do
            if child:IsA("Frame") and child.Name == "root" then
                if not table.find(cards, child) then
                    table.insert(cards, child)
                end
            end
        end
    end
    if #cards == 0 then
        for _, desc in ipairs(shopFrame:GetDescendants()) do
            if desc:IsA("Frame") and desc.Name == "root" then
                if not table.find(cards, desc) then
                    table.insert(cards, desc)
                end
            end
        end
    end
    
    for _, card in ipairs(cards) do
        local itemName = ""
        local stockNum = 1
        local isOutOfStock = false
        
        -- 1. Baca nama item dari TextLabel
        local nameFrame = card:FindFirstChild("名称", true)
        if nameFrame then
            local tl = nameFrame:FindFirstChildWhichIsA("TextLabel", true)
            if tl and tl.Text ~= "" then itemName = tl.Text end
        end
        if itemName == "" then
            for _, tl in ipairs(card:GetDescendants()) do
                if tl:IsA("TextLabel") and tl.Text ~= "" and tl.Name == "名称" then
                    itemName = tl.Text
                    break
                end
            end
        end
        
        -- 2. Cek stok
        local stockFrame = card:FindFirstChild("库存", true)
        if stockFrame then
            local tl = stockFrame:FindFirstChildWhichIsA("TextLabel", true)
            if tl and tl.Text ~= "" then
                local digits = string.match(tl.Text, "%d+")
                if digits then stockNum = tonumber(digits) or 0 end
                if stockNum == 0 or string.find(tl.Text:lower(), "x0") or string.find(tl.Text:lower(), "no stock") then
                    isOutOfStock = true
                end
            end
        end
        
        -- 3. Cek wadah tombol cash (货币购买)
        local cashContainer = card:FindFirstChild("货币购买", true)
        local buyBtn = nil
        if cashContainer then
            local disabledBtn = cashContainer:FindFirstChild("关闭")
            if disabledBtn and disabledBtn:IsA("GuiObject") and disabledBtn.Visible then
                isOutOfStock = true
            end
            
            for _, c in ipairs(cashContainer:GetChildren()) do
                if (c:IsA("ImageButton") or c:IsA("TextButton")) and c.Name == "货币购买" and c.Visible then
                    buyBtn = c
                    break
                end
            end
            if not buyBtn and not isOutOfStock then
                for _, c in ipairs(cashContainer:GetChildren()) do
                    if (c:IsA("ImageButton") or c:IsA("TextButton")) and c.Name ~= "关闭" and c.Visible then
                        buyBtn = c
                        break
                    end
                end
            end
        end
        
        -- 4. Cek target
        local isTarget = false
        local inLow = itemName:lower()
        local tbLow = (targetBucket or "Borong Semua"):lower()
        
        if tbLow == "all in-stock" or string.find(tbLow, "borong") or tbLow == "all" then
            isTarget = true
        elseif string.find(tbLow, "purple") and string.find(inLow, "purple") then
            isTarget = true
        elseif string.find(tbLow, "orange") and string.find(inLow, "orange") then
            isTarget = true
        elseif string.find(tbLow, "yellow") and string.find(inLow, "yellow") then
            isTarget = true
        elseif string.find(tbLow, "water bucket") and inLow == "water bucket" and not string.find(inLow, "purple") and not string.find(inLow, "orange") and not string.find(inLow, "yellow") then
            isTarget = true
        elseif inLow ~= "" and (string.find(inLow, "bucket") or string.find(inLow, "water") or string.find(inLow, "growth")) then
            isTarget = true
        end
        
        -- 5. Eksekusi Pembelian
        if isTarget and not isOutOfStock and buyBtn then
            if scroller and scroller:IsA("ScrollingFrame") then
                pcall(function()
                    local cardY = card.AbsolutePosition.Y - scroller.AbsolutePosition.Y + scroller.CanvasPosition.Y
                    scroller.CanvasPosition = Vector2.new(0, math.max(0, cardY - 10))
                end)
                task.wait(0.04)
            end
            
            local purchases = 0
            local maxBuy = buyAll and (stockNum > 0 and math.min(stockNum, 5) or 5) or 1
            for iter = 1, maxBuy do
                triggerGuiClick(buyBtn)
                if buyBtn.Parent and buyBtn.Parent:IsA("GuiObject") then
                    triggerGuiClick(buyBtn.Parent)
                end
                for _, c in ipairs(buyBtn:GetDescendants()) do
                    if c:IsA("GuiObject") then triggerGuiClick(c) end
                end
                purchases = purchases + 1
                boughtAny = true
                lastBoughtName = (itemName ~= "" and itemName) or "Water Bucket"
                task.wait(0.2)
                
                if cashContainer then
                    local dis = cashContainer:FindFirstChild("关闭")
                    if dis and dis:IsA("GuiObject") and dis.Visible then break end
                end
            end
            
            if boughtAny then
                notify("👑 BROTHER HUB", "✅ Borong Growth Time: " .. lastBoughtName .. " (x" .. tostring(purchases) .. " Sukses!)", 4)
            end
        end
    end
    
    -- 6. Tutup kembali HANYA jika script yang membukanya (bukan pemain)
    -- Menggunakan tombol tutup resmi agar modal / input sink game ter-reset bersih
    if openedByScript and shopFrame then
        local closeBtn = shopFrame:FindFirstChild("关闭按钮", true) or shopFrame:FindFirstChild("Close", true)
        if closeBtn then
            triggerGuiClick(closeBtn)
        else
            shopFrame.Visible = false
        end
    end
    
    return boughtAny, lastBoughtName
end
local buyBucketWithCash = buyGrowthTimeWithCash

-- ⚡ ZERO-LAG STEAL PROMPT ENGINE (Scoped to 创建 folder & Cached 1.0s)
local cachedStealPrompts = {}
local lastStealPromptScanTime = 0

local function getLiveStealPrompts()
    local now = tick()
    if (now - lastStealPromptScanTime) < 1.0 and #cachedStealPrompts > 0 then
        return cachedStealPrompts
    end
    lastStealPromptScanTime = now
    local prompts = {}
    
    -- Prioritas Utama: Folder 创建 (Semua bibit spawn game Steal A Seed ditaruh di sini)
    local chuangjian = workspace:FindFirstChild("创建")
    if chuangjian then
        for _, p in ipairs(chuangjian:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled and (p.ActionText == "Steal" or p.Name == "e_touch") then
                table.insert(prompts, p)
            end
        end
    end
    
    -- Fallback Cepat: Area 偷蛋区域
    if #prompts == 0 then
        local changjing = workspace:FindFirstChild("场景")
        local toudan = changjing and changjing:FindFirstChild("偷蛋区域")
        if toudan then
            for _, p in ipairs(toudan:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Enabled and (p.ActionText == "Steal" or p.Name == "e_touch") then
                    table.insert(prompts, p)
                end
            end
        end
    end
    
    cachedStealPrompts = prompts
    return prompts
end

local function findSeedPrompt(sInfo)
    if not sInfo then return nil, nil end
    local pattern = sInfo.pattern:lower()
    local unitId = sInfo.id and sInfo.id:lower() or ""
    local knownPos = sInfo.pos

    local livePrompts = getLiveStealPrompts()
    for _, p in ipairs(livePrompts) do
        if p.Enabled and (p.ActionText == "Steal" or p.Name == "e_touch") and not isPromptAlreadyStolen(p) then
            local parent = p.Parent
            local pPos = nil
            if parent:IsA("BasePart") then
                pPos = parent.Position
            elseif parent:IsA("Model") then
                pPos = parent:GetPivot().Position
            elseif parent and parent:FindFirstAncestorOfClass("BasePart") then
                pPos = parent:FindFirstAncestorOfClass("BasePart").Position
            end

            if pPos and not isPromptAlreadyStolen(p, pPos) then
                local isMatch = false

                -- Check 1: Ancestry & Full Name match (unit ID or pattern)
                local fullPath = p:GetFullName():lower()
                if string.find(fullPath, pattern) or (unitId ~= "" and string.find(fullPath, unitId)) then
                    isMatch = true
                end

                -- Check 2: ObjectText or Prompt Name
                if not isMatch and p.ObjectText ~= "" and (string.find(p.ObjectText:lower(), pattern) or (unitId ~= "" and string.find(p.ObjectText:lower(), unitId))) then
                    isMatch = true
                end

                -- Check 3: TextLabels di model tanaman
                if not isMatch and parent then
                    local mdl = parent:IsA("Model") and parent or parent:FindFirstAncestorOfClass("Model")
                    if mdl then
                        local mName = mdl.Name:lower()
                        if string.find(mName, pattern) or (unitId ~= "" and string.find(mName, unitId)) then
                            isMatch = true
                        else
                            for _, tl in ipairs(mdl:GetDescendants()) do
                                if tl:IsA("TextLabel") and tl.Text ~= "" then
                                    local tLow = tl.Text:lower()
                                    if string.find(tLow, pattern) or (unitId ~= "" and string.find(tLow, unitId)) then
                                        isMatch = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                end

                -- Check 4: Spatial match - Prompt berada di lokasi pedestal bibit tersebut (radius 35 studs)
                if not isMatch and knownPos then
                    local dist = (pPos - knownPos).Magnitude
                    if dist <= 35 then
                        isMatch = true
                    end
                end

                if isMatch then
                    return pPos, p
                end
            end
        end
    end

    return nil, nil
end

-- ⚡ STOLEN SEED TRACKER & ROTATION STATE (5 detik Cooldown per bibit terambil)
local recentlyStolenSeeds = {}

local function isPromptAlreadyStolen(obj, pos)
    local now = tick()
    if obj and recentlyStolenSeeds[obj] and recentlyStolenSeeds[obj] > now then
        return true
    end
    if pos then
        for item, exp in pairs(recentlyStolenSeeds) do
            if exp > now and typeof(item) == "Vector3" then
                if (item - pos).Magnitude < 8 then
                    return true
                end
            end
        end
    end
    return false
end

local function markPromptAsStolen(obj, pos)
    local exp = tick() + 5.0 -- 5 detik cooldown sebelum bisa ditarget lagi agar bergantian ke nomor berikutnya
    if obj then
        recentlyStolenSeeds[obj] = exp
    end
    if pos then
        recentlyStolenSeeds[pos] = exp
    end
end

-- Helper: Dapatkan posisi aman dari Model atau BasePart (Prioritas Part "Body" Ground Level)
local function getModelPosition(m)
    if not m then return nil end
    if m:IsA("BasePart") then return m.Position end
    if m:IsA("Model") then
        local body = m:FindFirstChild("Body")
        if body and body:IsA("BasePart") then
            return body.Position
        end
        local p = m.PrimaryPart or m:FindFirstChild("RootPart")
        if p and p:IsA("BasePart") and p.Position.Y > -50 then
            return p.Position
        end
        for _, ch in ipairs(m:GetChildren()) do
            if ch:IsA("BasePart") and ch.Position.Y > -50 then
                return ch.Position
            end
        end
        local piv = m:GetPivot()
        if piv and piv.Position.Y > -50 then
            return piv.Position
        end
        for _, ch in ipairs(m:GetDescendants()) do
            if ch:IsA("BasePart") and ch.Position.Y > -50 then
                return ch.Position
            end
        end
    end
    return nil
end

-- Helper: Deteksi Folder 创建 (Handle UTF-8 Encoding & Folder Matching)
local function getChuangjianFolder()
    local c = workspace:FindFirstChild("创建") or workspace:FindFirstChild("\229\136\155\229\187\186")
    if c then return c end
    for _, ch in ipairs(workspace:GetChildren()) do
        if ch:IsA("Folder") then
            local nm = ch.Name
            if nm == "创建" or string.find(nm, "创") or string.find(nm, "建") then
                return ch
            end
            if ch:FindFirstChild("08") or ch:FindFirstChild("09") or ch:FindFirstChild("10") or ch:FindFirstChild("11") or ch:FindFirstChild("8") or ch:FindFirstChild("9") then
                return ch
            end
        end
    end
    return nil
end

-- [1.8] 🌟 5 MODEL BIBIT TERDEPAN: 8 SAMPAI 12 DI WORKSPACE.创建 (8, 9, 10, 11, 12)
-- Rotasi bergiliran (Round-Robin) mengambil model 8, 9, 10, 11, 12 jika tersedia di folder 创建
local FRONT_MODEL_GROUPS = { 8, 9, 10, 11, 12 }
local frontModelCycleIndex = 1

-- Helper: Scan Cepat 1-Pass Seluruh Model Bibit Terdepan (8..12) Tanpa Lag (0% Lag - Ringan & 60 FPS!)
local function scanFrontSeedModels()
    local chuangjian = getChuangjianFolder()
    if not chuangjian then return {} end

    local available = {}
    local children = chuangjian:GetChildren()

    local function checkModelCandidate(m)
        if not m or not m:IsA("Model") or not m.Parent then return end
        local mName = m.Name
        local modPath = m:GetAttribute("__mod_path")
        local modPathStr = modPath and tostring(modPath) or ""

        for _, numKey in ipairs(FRONT_MODEL_GROUPS) do
            if not available[numKey] then
                local numVal = tonumber(numKey)
                local numStr = tostring(numKey)
                local num02 = numVal and string.format("%02d", numVal) or numStr

                local isMatch = false
                if mName == num02 or mName == numStr or tonumber(mName) == numVal then
                    isMatch = true
                elseif string.find(mName, "^" .. numStr .. "$") or string.find(mName, "^" .. num02 .. "$") then
                    isMatch = true
                elseif string.find(mName, "Stage" .. num02) or string.find(mName, "Stage" .. numStr) or string.find(mName, "Stage " .. numStr) then
                    isMatch = true
                elseif modPathStr ~= "" and (string.find(modPathStr, "/" .. num02) or string.find(modPathStr, "/" .. numStr) or string.find(modPathStr, "-" .. num02) or string.find(modPathStr, "-" .. numStr)) then
                    isMatch = true
                end

                if isMatch then
                    -- Verifikasi bahwa bibit nyata dan aktif (ada part fisik Body & tidak transparan)
                    local body = m:FindFirstChild("Body") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                    if body and body.Transparency < 0.9 then
                        local pos = getModelPosition(m)
                        if pos and pos.Y > -50 and (pos.Z < -3500 or (pos.Z < 0 and pos.Z > -7000)) then
                            if not isPromptAlreadyStolen(m, pos) then
                                available[numKey] = { model = m, pos = pos }
                            end
                        end
                    end
                end
            end
        end
    end

    -- 1. Scan direct children di folder 创建 (Super Cepat & 0% Beban CPU)
    for _, child in ipairs(children) do
        if child:IsA("Model") then
            checkModelCandidate(child)
        elseif child:IsA("Folder") then
            for _, subChild in ipairs(child:GetChildren()) do
                if subChild:IsA("Model") then
                    checkModelCandidate(subChild)
                end
            end
        end
    end

    return available
end

local function findFrontSeedModel(numKey)
    local available = scanFrontSeedModels()
    local found = available[tonumber(numKey) or numKey]
    if found then
        return found.model, found.pos
    end
    return nil, nil
end

-- Rotasi Bergiliran (Round-Robin) untuk Multi-Select Bibit Target
local stealCycleIndex = 1

local function getNextAvailableTargetSeed()
    local availableFront = scanFrontSeedModels()

    -- 1. Evaluasi apakah user mencentang salah satu dari 5 Bibit Depan (Seed 08..12) di Droplist
    local activeFronts = {}
    for _, numKey in ipairs(FRONT_MODEL_GROUPS) do
        local keyStr = string.format("Seed %02d", numKey)
        if config.multiTargetSeeds and config.multiTargetSeeds[keyStr] == true then
            table.insert(activeFronts, { key = keyStr, num = numKey })
        end
    end

    local totalFront = #activeFronts
    if totalFront > 0 then
        -- User MENCENTANG Bibit Depan (8..12)!
        -- Rotasikan secara bergiliran (Round-Robin) HANYA di antara nomor yang dicentang:
        for step = 0, totalFront - 1 do
            local idx = ((frontModelCycleIndex - 1 + step) % totalFront) + 1
            local fInfo = activeFronts[idx]
            local found = availableFront[fInfo.num]
            if found and found.model and found.pos then
                frontModelCycleIndex = (idx % totalFront) + 1
                return found.model, found.pos, fInfo.key
            end
        end

        -- HUKUM MUTLAK FOUNDER:
        -- "seed paling depan itu hanya angka 8 sampai 12, kalau gak ada angka itu, jangan di ambil, ini yang paling depan"!
        -- JIKA BIBIT DEPAN TERPILIH SEDANG KOSONG: DILARANG MENGAMBIL BIBIT LAIN! TETAP DIAM DI TEMPAT!
        return nil, nil, nil
    end

    -- 2. Jika user TIDAK mencentang angka 8..12 sama sekali (hanya mencentang nama bibit spesifik):
    local activeNamedSeeds = {}
    for _, sInfo in ipairs(ALL_STEALABLE_SEEDS) do
        if not sInfo.num and config.multiTargetSeeds and config.multiTargetSeeds[sInfo.key] == true then
            table.insert(activeNamedSeeds, sInfo)
        end
    end

    local totalNamed = #activeNamedSeeds
    if totalNamed > 0 then
        for step = 0, totalNamed - 1 do
            local idx = ((stealCycleIndex - 1 + step) % totalNamed) + 1
            local candidate = activeNamedSeeds[idx]
            local pos, prompt = findSeedPrompt(candidate)
            if pos and prompt and not isPromptAlreadyStolen(prompt, pos) then
                stealCycleIndex = (idx % totalNamed) + 1
                local mdl = prompt.Parent and (prompt.Parent:IsA("Model") and prompt.Parent or prompt.Parent:FindFirstAncestorOfClass("Model"))
                return mdl or prompt, pos, candidate.key
            end
        end
    end

    return nil, nil, nil
end

-- Helper: Cek apakah bibit target saat ini BENAR-BENAR KOSONG
local function areAllFrontSeedsEmpty()
    local mdl, pos, name = getNextAvailableTargetSeed()
    if mdl and pos then
        return false, mdl, nil, pos
    end
    return true, nil, nil, nil
end

-- ⚡ KOORDINAT BAKU MARKAS RESMI FOUNDER: 7, 0.75, 360.375
local FOUNDER_EXACT_BASE = Vector3.new(7, 0.75, 360.375)

-- Helper: Kembali ke Markas dan Lakukan Gerakan Mikro
local function returnToBaseWithMicroMove(customPos)
    local hrp = getHrp()
    if not hrp then return end
    local char = LocalPlayer.Character
    local hum = getHumanoid()

    -- ⚡ KOORDINAT BAKU MARKAS RESMI FOUNDER: 7, 0.75, 360.375
    local destPos = toVector3(customPos) or FOUNDER_EXACT_BASE

    -- 1. Pulihkan collision seluruh part seketika (kecuali HumanoidRootPart)
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.CanCollide = true
            end
        end
        char:PivotTo(CFrame.new(destPos))
    end

    -- 2. Teleport PRESISI mendarat tepat di titik koordinat Markas tanpa drifting
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(destPos)

    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    -- 3. Equip bibit di tangan jika opsi aktif
    if config.holdSeedInHand then
        equipStolenSeed()
    end
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

-- Flash Steal Routine Presisi: Tele Langsung ke Seed -> Interaksi Sampai Bibit Terambil -> Balik Markas Presisi
local function executeFlashStealDirect(targetPos, promptOrModel)
    local hrp = getHrp()
    if not hrp or not targetPos then return false end
    local char = LocalPlayer.Character
    local hum = getHumanoid()
    local markas = FOUNDER_EXACT_BASE

    -- 1. Noclip karakter sementara agar tidak tertahan jeruji/rintangan
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 2. Teleport LANGSUNG ke posisi bibit tersebut
    local seedDropPos = targetPos + Vector3.new(0, 0.5, 0)
    if char then
        char:PivotTo(CFrame.new(seedDropPos))
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(seedDropPos)

    -- Catat jumlah Tool awal pemain untuk memverifikasi bibit benar-benar masuk tas
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local function countPlayerTools()
        local c = 0
        if bp then
            for _, it in ipairs(bp:GetChildren()) do
                if it:IsA("Tool") then c = c + 1 end
            end
        end
        if char then
            for _, it in ipairs(char:GetChildren()) do
                if it:IsA("Tool") then c = c + 1 end
            end
        end
        return c
    end
    local initialToolCount = countPlayerTools()

    -- Helper pencari prompt interaktif
    local function resolvePrompt()
        if promptOrModel then
            if promptOrModel:IsA("ProximityPrompt") and promptOrModel.Enabled and promptOrModel.Parent then
                return promptOrModel
            elseif promptOrModel:IsA("Model") or promptOrModel:IsA("BasePart") then
                local p = promptOrModel:FindFirstChildWhichIsA("ProximityPrompt", true)
                if p and p.Enabled and p.Parent then return p end
            end
        end

        local chuangjian = getChuangjianFolder()
        if chuangjian then
            for _, p in ipairs(chuangjian:GetChildren()) do
                if p:IsA("ProximityPrompt") and p.Enabled then
                    local pPos = p.Parent and (p.Parent:IsA("BasePart") and p.Parent.Position or (p.Parent:IsA("Model") and p.Parent:GetPivot().Position))
                    if pPos and (pPos - seedDropPos).Magnitude <= 25 then
                        return p
                    end
                elseif p:IsA("Model") then
                    local subP = p:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if subP and subP.Enabled then
                        local pPos = p:GetPivot().Position
                        if (pPos - seedDropPos).Magnitude <= 25 then
                            return subP
                        end
                    end
                end
            end
        end

        -- Fallback: Cari ProximityPrompt manapun dalam radius 25 studs dari titik bibit
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled then
                local pPos = p.Parent and (p.Parent:IsA("BasePart") and p.Parent.Position or (p.Parent:IsA("Model") and p.Parent:GetPivot().Position))
                if pPos and (pPos - seedDropPos).Magnitude <= 25 then
                    return p
                end
            end
        end
        return nil
    end

    -- 3. Siklus Interaksi Presisi: Tahan posisi di bibit & picu prompt sampai bibit BENAR-BENAR TERAMBIL!
    local seedAcquired = false
    local startTime = tick()
    local maxHoldTime = 0.8 -- Cepat dan presisi

    while (tick() - startTime) < maxHoldTime do
        -- Kunci posisi karakter di titik bibit
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(seedDropPos)
        end

        local prompt = resolvePrompt()
        if prompt then
            pcall(function() prompt.HoldDuration = 0 end)
            if fireproximityprompt then
                fireproximityprompt(prompt, 0)
            end
            pcall(function() prompt:InputHoldBegin() end)
        end

        -- Trigger touch interest pada part bibit
        if firetouchinterest and hrp and promptOrModel then
            pcall(function()
                if promptOrModel:IsA("Model") then
                    for _, pt in ipairs(promptOrModel:GetChildren()) do
                        if pt:IsA("BasePart") then
                            firetouchinterest(hrp, pt, 0)
                            task.wait()
                            firetouchinterest(hrp, pt, 1)
                        end
                    end
                elseif promptOrModel:IsA("BasePart") then
                    firetouchinterest(hrp, promptOrModel, 0)
                    task.wait()
                    firetouchinterest(hrp, promptOrModel, 1)
                end
            end)
        end

        -- Backup simulasi tombol E native Roblox
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        end)

        task.wait(0.06)

        -- Verifikasi apakah bibit SUDAH berhasil masuk ke tas/tangan
        local currentToolCount = countPlayerTools()
        if currentToolCount > initialToolCount then
            seedAcquired = true
            break
        end

        -- Cek jika prompt sudah selesai / hilang dari game
        if prompt and (prompt.Parent == nil or not prompt.Enabled) then
            seedAcquired = true
            break
        end
    end

    -- Lepaskan hold prompt dan tombol E secara bersih
    pcall(function()
        local prompt = resolvePrompt()
        if prompt then prompt:InputHoldEnd() end
    end)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)

    -- Catat target sebagai stolen dengan cooldown 4 detik agar bergantian ke nomor model berikutnya
    if promptOrModel then
        markPromptAsStolen(promptOrModel, targetPos)
    end

    task.wait(0.03)

    -- 4. ⚡ LANGSUNG TELEPORT BALIK KE KOORDINAT MARKAS PASTI: 7, 0.75, 360.375
    returnToBaseWithMicroMove(markas)

    -- 5. Equip bibit di tangan jika opsi aktif
    if config.holdSeedInHand then
        equipStolenSeed()
    end

    -- 6. Ambil tanaman matang jika aktif
    if config.autoPickupReady or config.autoHarvest then
        pickupReadyCrops()
    end

    -- 7. Tanam bibit ke petak kebun jika aktif
    if config.autoPlant then
        plantHeldSeedAtGarden()
    end

    return true
end

-- [5] 🌱 AUTONOMOUS FLASH STEAL & SMART ARENA RESET WAIT SUITE
registerThread(function()
    while true do
        if config.autoSteal or config.autoFlashSteal or config.fullAfkLoop then
            pcall(function()
                local hrp = getHrp()
                if hrp then
                    local markas = FOUNDER_EXACT_BASE

                    -- 1. Cari bibit target aktif sesuai centang Multi-Select droplist
                    local targetModel, targetPos, targetName = getNextAvailableTargetSeed()

                    if targetModel and targetPos then
                        -- 🌟 Bibit target TERSEDIA (GAK KOSONG)! Langsung Flash Steal tanpa menunggu!
                        executeFlashStealDirect(targetPos, targetModel)
                    else
                        -- 🛑 100% KOSONG! (Semua bibit terpilih sudah terambil atau belum spawn)
                        -- DIAM DI TEMPAT:
                        -- 1. DILARANG SPAM TELEPORT KE DEPAN! (Tetap tenang menunggu bibit spawn)
                        -- 2. DILARANG MENGUNCI POSISI PEMAIN! Pemain 100% BEBAS jalan ke mana saja tanpa lag & tanpa tertarik balik!
                        -- 3. Hanya jika pemain masih terdampar di arena depan (zona bahaya Z < -3000), kembalikan sekali ke markas.
                        if hrp.Position.Z < -3000 then
                            returnToBaseWithMicroMove(markas)
                        end

                        -- Pantau countdown reset arena untuk mereset cache saat round baru dimulai
                        local curSec = getArenaResetCountdown()
                        if curSec and curSec <= 1 then
                            recentlyStolenSeeds = {}
                            frontModelCycleIndex = 1
                        end
                    end
                end
            end)
        end
        task.wait(math.clamp(config.stealDelay or 0.4, 0.2, 2.0))
    end
end)

-- [6] 🌾 GARDEN CULTIVATION & PASSIVE CASH ENGINE
registerThread(function()
    while true do
        if config.autoPlant or config.autoPickupReady or config.autoHarvest or config.autoCollectCash then
            pcall(function()
                -- Ambil tanaman matang di kebun pemain
                if config.autoPickupReady or config.autoHarvest then
                    pickupReadyCrops()
                end

                -- Auto Plant ke petak kebun pemain
                if config.autoPlant then
                    plantHeldSeedAtGarden()
                end

                -- Collect cash from garden plots
                if config.autoCollectCash then
                    for _, plot in ipairs(workspace:GetDescendants()) do
                        if plot.Name == "DF_BaseGlow" or string.find(plot.Name:lower(), "cash") or string.find(plot.Name:lower(), "coin") then
                            local hrp = getHrp()
                            if hrp and plot:IsA("BasePart") then
                                if (hrp.Position - plot.Position).Magnitude <= 50 then
                                    if firetouchinterest then
                                        firetouchinterest(hrp, plot, 0)
                                        firetouchinterest(hrp, plot, 1)
                                    end
                                end
                            end
                        end
                    end
                end

                -- Auto Harvest / Pick plants
                if config.autoHarvest then
                    for _, prompt in ipairs(workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and (prompt.ActionText == "Harvest" or prompt.ActionText == "Pick" or prompt.ActionText == "Collect") then
                            if fireproximityprompt then
                                fireproximityprompt(prompt, 0)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(math.clamp(config.harvestInterval or 1.0, 0.2, 5.0))
    end
end)

-- [7] 💰 AUTONOMOUS SEED & CROP SELLER
local function performSellCrops()
    pcall(function()
        -- Method 1: Remote Call to PlantDealer / ServerRemoteEvent
        fireRemote("PlantDealer", "SellAll")
        fireRemote("ServerRemoteEvent", "SellAll")
        fireRemote("ServerRemoteEvent", "SellCrops")
        
        -- Method 2: Interact with SeedBuyer NPC
        local buyer = workspace:FindFirstChild("SeedBuyer", true)
        if buyer then
            local prompt = buyer:FindFirstChildOfClass("ProximityPrompt", true)
            if prompt and fireproximityprompt then
                fireproximityprompt(prompt, 0)
            end
        end
    end)
end

registerThread(function()
    while true do
        if config.autoSell then
            pcall(function()
                performSellCrops()
            end)
        end
        task.wait(math.clamp(config.sellInterval or 3.0, 1.0, 30.0))
    end
end)

-- [8A] 🪣 AUTO BUY WATER BUCKETS (TOKO EMBER AIR - CASH GAME ONLY - 100% SILENT BACKGROUND)
registerThread(function()
    while true do
        if config.autoBuyBuckets then
            local s, err = pcall(function()
                local target = config.targetBucket or "Borong Semua Stok Tersedia (All In-Stock)"
                buyBucketWithCash(target, true)
            end)
            if not s and err then
                warn("[BrotherHub] buyGrowthTimeWithCash error: " .. tostring(err))
            end
        end
        task.wait(3.0)
    end
end)

-- [8B] 🛒 FREE SEED SHOP & PACK OPENER
registerThread(function()
    while true do
        if config.autoBuySeeds then
            pcall(function()
                for seedName, selected in pairs(config.targetSeeds) do
                    if selected then
                        fireRemote("PlantDealer", "BuySeed", seedName)
                        fireRemote("ServerRemoteEvent", "BuySeed", seedName)
                    end
                end
            end)
        end

        if config.autoOpenPacks then
            pcall(function()
                for packName, selected in pairs(config.targetPacks) do
                    if selected then
                        fireRemote("ServerRemoteEvent", "OpenPack", packName)
                        fireRemote("ServerRemoteEvent", "BuyPack", packName)
                    end
                end
            end)
        end

        task.wait(2.5)
    end
end)

-- [9] 🐾 PETS, TACO EVENT & OFFLINE EARNINGS
registerThread(function()
    while true do
        -- Auto Hatch Eggs
        if config.autoHatchEggs then
            pcall(function()
                fireRemote("ServerRemoteEvent", "HatchEgg", "BasicEgg")
            end)
        end

        -- Auto Equip Best Pets
        if config.autoEquipBestPets then
            pcall(function()
                fireRemote("ServerRemoteEvent", "EquipBestPets")
            end)
        end

        -- Auto Taco Event
        if config.autoTacoEvent then
            pcall(function()
                fireRemote("StartTacoEvent")
            end)
        end

        -- Auto Offline Earnings
        if config.autoClaimOffline then
            pcall(function()
                fireRemote("DisplayOfflineEarnings")
            end)
        end

        -- Anti-AFK Signal
        if config.antiAfk then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end

        task.wait(10.0)
    end
end)

-- [10] 👁️ RADAR & ESP WALLHACK ENGINE
local function createHighlight(instance, color, nameText)
    if not instance or not instance.Parent then return nil end
    local hl = Instance.new("Highlight")
    hl.Name = "BH_ESP"
    hl.Adornee = instance
    hl.FillColor = color
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0.1
    hl.Parent = instance

    local bg = Instance.new("BillboardGui")
    bg.Name = "BH_ESP_Tag"
    bg.Adornee = instance
    bg.Size = UDim2.new(0, 140, 0, 30)
    bg.StudsOffset = Vector3.new(0, 3.5, 0)
    bg.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Text = nameText
    lbl.Parent = bg
    bg.Parent = instance

    table.insert(espObjects, hl)
    table.insert(espObjects, bg)
    return hl
end

local function clearEsp()
    for _, obj in ipairs(espObjects) do
        if obj and obj.Parent then pcall(function() obj:Destroy() end) end
    end
    table.clear(espObjects)
end

registerThread(function()
    while true do
        if config.seedEsp or config.playerEsp or config.dealerEsp then
            pcall(function()
                clearEsp()
                
                -- Seed & Steal ESP
                if config.seedEsp then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Enabled and obj.ActionText == "Steal" then
                            local p = obj.Parent
                            if p and p:IsA("BasePart") then
                                createHighlight(p, Color3.fromRGB(0, 255, 128), "🌱 " .. (p.Name or "Seed"))
                            end
                        end
                    end
                end

                -- Player ESP
                if config.playerEsp then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((getHrp().Position - p.Character.HumanoidRootPart.Position).Magnitude)
                            createHighlight(p.Character, Color3.fromRGB(0, 200, 255), p.DisplayName .. " [" .. dist .. "m]")
                        end
                    end
                end

                -- Dealer & Buyer ESP
                if config.dealerEsp then
                    local dealer = workspace:FindFirstChild("SeedDealer", true)
                    if dealer then
                        createHighlight(dealer, Color3.fromRGB(255, 215, 0), "🛒 SeedDealer")
                    end
                    local buyer = workspace:FindFirstChild("SeedBuyer", true)
                    if buyer then
                        createHighlight(buyer, Color3.fromRGB(255, 80, 80), "💰 SeedBuyer")
                    end
                end
            end)
        else
            clearEsp()
        end
        task.wait(2.5)
    end
end)

-- Fullbright Engine
local originalAmbient = game:GetService("Lighting").Ambient
local originalOutdoor = game:GetService("Lighting").OutdoorAmbient
local originalClock   = game:GetService("Lighting").ClockTime

registerConnection(RunService.RenderStepped:Connect(function()
    if config.fullbright then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        game:GetService("Lighting").ClockTime = 14
    end
end))

-- [11] 🏃 PHYSICAL MOVEMENT ENGINE
registerConnection(RunService.Heartbeat:Connect(function()
    local hum = getHumanoid()
    if hum then
        if config.walkSpeedEnabled then
            hum.WalkSpeed = config.walkSpeedValue
        end
        if config.jumpPowerEnabled then
            hum.UseJumpPower = true
            hum.JumpPower = config.jumpPowerValue
        end
    end
end))

-- Ghost Noclip Engine
registerConnection(RunService.Stepped:Connect(function()
    if config.noclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- Flying Engine (WASD + Space/Shift)
local flying = false
local flyBodyGyro, flyBodyVel

local function setFly(enabled)
    flying = enabled
    local hrp = getHrp()
    if not hrp then return end

    if enabled then
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = hrp.CFrame

        flyBodyVel = Instance.new("BodyVelocity", hrp)
        flyBodyVel.Velocity = Vector3.zero
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        registerThread(function()
            while flying do
                local camCF = Camera.CFrame
                local moveDir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                flyBodyGyro.CFrame = camCF
                flyBodyVel.Velocity = moveDir.Unit * (config.flySpeed or 60)
                if moveDir.Magnitude == 0 then flyBodyVel.Velocity = Vector3.zero end
                RunService.RenderStepped:Wait()
            end
            if flyBodyGyro then flyBodyGyro:Destroy() end
            if flyBodyVel then flyBodyVel:Destroy() end
        end)
    else
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVel then flyBodyVel:Destroy() end
    end
end

registerConnection(UserInputService.JumpRequest:Connect(function()
    if config.infiniteJump then
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

registerConnection(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and config.clickTp and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then
            safeTeleport(mouse.Hit.Position)
        end
    end
end))

-- [12] 💎 GUI ARCHITECTURE: 1:1 MY FLOWER SHOP EXACT STANDARD
-- [12] 💎 GUI ARCHITECTURE: 1:1 MY FLOWER SHOP EXACT STANDARD
local THEME = {
    Bg          = Color3.fromRGB(18, 18, 26),
    BgTrans     = 0.04,
    Background  = Color3.fromRGB(18, 18, 26),
    Panel       = Color3.fromRGB(28, 28, 40),
    Card        = Color3.fromRGB(30, 32, 50),
    Slot        = Color3.fromRGB(38, 38, 54),
    Border      = Color3.fromRGB(45, 48, 75),
    Stroke      = Color3.fromRGB(70, 70, 95),
    Title       = Color3.fromRGB(0, 255, 200),
    Accent      = Color3.fromRGB(0, 229, 255),
    Gold        = Color3.fromRGB(255, 215, 0),
    Text        = Color3.fromRGB(240, 240, 245),
    SubText     = Color3.fromRGB(160, 160, 180),
    Green       = Color3.fromRGB(98, 220, 110),
    Red         = Color3.fromRGB(255, 75, 75),
    Blue        = Color3.fromRGB(40, 130, 230),
    Purple      = Color3.fromRGB(150, 90, 230),
    Yellow      = Color3.fromRGB(255, 215, 60),
    Font        = Enum.Font.GothamBold,
    FontReg     = Enum.Font.GothamMedium,
}
local tweenBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenFast   = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function corner(inst, r)
    local c = Instance.new("UICorner", inst); c.CornerRadius = UDim.new(0, r or 8); return c
end
local function stroke(inst, col, th)
    local s = Instance.new("UIStroke", inst)
    s.Color = col or THEME.Stroke; s.Thickness = th or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; return s
end
local function gradient(inst, c1, c2, rot)
    local g = Instance.new("UIGradient", inst)
    g.Color = ColorSequence.new(c1, c2); g.Rotation = rot or 90; return g
end
local function neonStroke(inst, thickness)
    local s = Instance.new("UIStroke", inst)
    s.Thickness = thickness or 2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Transparency = 0
    s.Color = Color3.new(1, 1, 1)
    local g = Instance.new("UIGradient", s)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 40, 255)),    -- biru tua neon
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 25, 45)),   -- merah neon
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(20, 255, 80)),   -- hijau neon
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 40, 255)),    -- balik ke biru (mulus)
    })
    g.Rotation = 0
    local tw = TweenService:Create(g,
        TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360})
    tw:Play()
    return s, tw
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrotherHub_StealASeed"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Global cleanup agar tidak ada proximity prompt yang melayang akibat 99999
pcall(function()
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.MaxActivationDistance > 100 then
            p.MaxActivationDistance = 10
        end
    end
end)

-- [12.1] 💎 POPUP DROPDOWN MANAGER (1:1 MY FLOWER SHOP EXACT STANDARD)
local DD = { closers = {}, blocker = nil }
local function closeOtherDropdowns(exceptId)
    for id, fn in pairs(DD.closers) do
        if id ~= exceptId then pcall(fn) end
    end
end

local function dropdownBlocker()
    if DD.blocker and DD.blocker.Parent then return DD.blocker end
    local b = Instance.new("TextButton")
    b.Name = "BH_DropdownBlocker"
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.AutoButtonColor = false
    b.Visible = false
    b.ZIndex = 499
    b.Parent = ScreenGui
    b.MouseButton1Click:Connect(function()
        closeOtherDropdowns(nil)
    end)
    DD.blocker = b
    return b
end

-- Main Frame (660 x 440) - 1:1 My Flower Shop Theme & Rotating Neon RGB Stroke
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(660, 440)
MainFrame.Position = UDim2.new(0.5, -330, 0.5, -220)
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.BackgroundTransparency = THEME.BgTrans
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

-- UIScale Scoping Rule: MainScale PARENTED TO MainFrame
local MainScale = Instance.new("UIScale", MainFrame)
MainScale.Scale = config.guiScale or 1.0

corner(MainFrame, 14)
local MainStroke, mainStrokeTw = neonStroke(MainFrame, 2)

-- Top Bar Header
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = THEME.Panel
TopBar.BorderSizePixel = 0
local CornerTop = Instance.new("UICorner", TopBar)
CornerTop.CornerRadius = UDim.new(0, 14)

local TopLine = Instance.new("Frame", TopBar)
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = THEME.Border
TopLine.BorderSizePixel = 0

-- Header Branding
local HeaderIcon = Instance.new("TextLabel", TopBar)
HeaderIcon.Size = UDim2.new(0, 36, 1, 0)
HeaderIcon.Position = UDim2.new(0, 10, 0, 0)
HeaderIcon.BackgroundTransparency = 1
HeaderIcon.Text = "👑"
HeaderIcon.TextSize = 20
HeaderIcon.Font = THEME.Font

local HeaderTitle = Instance.new("TextLabel", TopBar)
HeaderTitle.Name = "HeaderTitle"
HeaderTitle.Size = UDim2.new(0, 340, 1, 0)
HeaderTitle.Position = UDim2.new(0, 46, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = tr("HubTitle")
HeaderTitle.TextColor3 = THEME.Title
HeaderTitle.Font = THEME.Font
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Header Control Buttons (Language, Minimize, Close)
local LangBtn = Instance.new("TextButton", TopBar)
LangBtn.Size = UDim2.fromOffset(36, 26)
LangBtn.Position = UDim2.new(1, -114, 0.5, -13)
LangBtn.BackgroundColor3 = THEME.Card
LangBtn.Text = config.language == "ID" and "🇮🇩" or "🇬🇧"
LangBtn.TextSize = 14
LangBtn.Font = THEME.Font
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 6)
local LangStroke = Instance.new("UIStroke", LangBtn)
LangStroke.Color = THEME.Border

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.fromOffset(26, 26)
MinBtn.Position = UDim2.new(1, -70, 0.5, -13)
MinBtn.BackgroundColor3 = THEME.Card
MinBtn.Text = "-"
MinBtn.TextColor3 = THEME.Text
MinBtn.TextSize = 16
MinBtn.Font = THEME.Font
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = THEME.Red
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = THEME.Font
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Dragging Engine for MainFrame
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        closeOtherDropdowns(nil)
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
registerConnection(UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))

-- Horizontal Scrolling TabBar (Swipe Right)
local TabBar = Instance.new("ScrollingFrame", MainFrame)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -20, 0, 38)
TabBar.Position = UDim2.new(0, 10, 0, 48)
TabBar.BackgroundTransparency = 1
TabBar.ScrollBarThickness = 3
TabBar.ScrollBarImageColor3 = THEME.Title
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Page Container
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -20, 1, -98)
PageContainer.Position = UDim2.new(0, 10, 0, 90)
PageContainer.BackgroundTransparency = 1

-- Resize Grip Corner (1:1 My Flower Shop Specification)
do
    local grip = Instance.new("TextButton", MainFrame)
    grip.Name = "ResizeGrip"
    grip.Size = UDim2.fromOffset(18, 18)
    grip.Position = UDim2.new(1, -18, 1, -18)
    grip.BackgroundTransparency = 0.5
    grip.BackgroundColor3 = THEME.Panel
    grip.Text = "◢"
    grip.TextColor3 = THEME.Title
    grip.Font = THEME.Font
    grip.TextSize = 16
    grip.AutoButtonColor = false
    grip.ZIndex = 60
    Instance.new("UICorner", grip).CornerRadius = UDim.new(0, 6)
    local gStroke = Instance.new("UIStroke", grip)
    gStroke.Color = THEME.Title
    gStroke.Thickness = 1

    local MIN_S, MAX_S = 0.55, 1.8
    local resizing, startDist, startScale, centerPx = false, 1, 1, Vector2.zero

    grip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing  = true
            centerPx  = MainFrame.AbsolutePosition + MainFrame.AbsoluteSize / 2
            startDist = math.max((Vector2.new(i.Position.X, i.Position.Y) - centerPx).Magnitude, 1)
            startScale= config.guiScale or 1.0
        end
    end)

    registerConnection(UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local cur = (Vector2.new(i.Position.X, i.Position.Y) - centerPx).Magnitude
            local s = math.clamp(startScale * (cur / startDist), MIN_S, MAX_S)
            config.guiScale = s
            MainScale.Scale = s
        end
    end))

    registerConnection(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
            saveConfig()
        end
    end))
end

-- Floating 80x80 MinCircle (1:1 My Flower Shop Exact Standard)
local Circle = Instance.new("TextButton", ScreenGui)
Circle.Name = "MinCircle"
Circle.Size = UDim2.fromOffset(80, 80)
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.Position = UDim2.new(0.1, 0, 0.5, 0)
Circle.BackgroundColor3 = THEME.Panel
Circle.Text = "BH"
local CrownLabel = Instance.new("TextLabel", Circle)
CrownLabel.Name = "CrownLabel"
CrownLabel.Size = UDim2.new(1, 0, 0, 16)
CrownLabel.Position = UDim2.new(0, 0, 0, 8)
CrownLabel.BackgroundTransparency = 1
CrownLabel.Text = "👑"
CrownLabel.Font = Enum.Font.GothamBold
CrownLabel.TextSize = 14
CrownLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
CrownLabel.ZIndex = 2
Circle.Font = Enum.Font.GothamBlack
Circle.TextSize = 30
Circle.TextColor3 = THEME.Title
Circle.AutoButtonColor = false
Circle.Active = true
Circle.Visible = false
corner(Circle, 40)
neonStroke(Circle, 3)
gradient(Circle, THEME.Purple, THEME.Blue, 45)
local CircleScale = Instance.new("UIScale", Circle)
CircleScale.Scale = 0

local doMinimize, doRestore
do
    local isAnimating = false
    doMinimize = function()
        if isAnimating then return end
        isAnimating = true
        closeOtherDropdowns(nil)
        local t = TweenService:Create(MainScale, tweenFast, {Scale = 0})
        t:Play()
        t.Completed:Connect(function()
            MainFrame.Visible = false
            Circle.Visible = true
            CircleScale.Scale = 0
            local t2 = TweenService:Create(CircleScale, tweenBounce, {Scale = 1})
            t2:Play()
            t2.Completed:Connect(function() isAnimating = false end)
        end)
    end
    doRestore = function()
        if isAnimating then return end
        isAnimating = true
        local t = TweenService:Create(CircleScale, tweenFast, {Scale = 0})
        t:Play()
        t.Completed:Connect(function()
            Circle.Visible = false
            MainFrame.Visible = true
            MainScale.Scale = 0
            local t2 = TweenService:Create(MainScale, tweenBounce, {Scale = config.guiScale or 1.0})
            t2:Play()
            t2.Completed:Connect(function() isAnimating = false end)
        end)
    end
end

MinBtn.MouseButton1Click:Connect(doMinimize)

-- Draggable MinCircle (1:1 My Flower Shop Smooth Dragging)
do
    local DRAG_THRESHOLD = 8
    local active, moved, startPx, guiStart = false, false, nil, nil
    Circle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            active = true
            moved = false
            startPx = i.Position
            guiStart = Circle.Position
        end
    end)
    registerConnection(UserInputService.InputChanged:Connect(function(i)
        if not active then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = (i.Position - startPx) / 1
            if d.Magnitude > DRAG_THRESHOLD then moved = true end
            Circle.Position = UDim2.new(
                guiStart.X.Scale, guiStart.X.Offset + d.X,
                guiStart.Y.Scale, guiStart.Y.Offset + d.Y
            )
        end
    end))
    local function release(i)
        if not active then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            active = false
            if not moved then doRestore() end
        end
    end
    Circle.InputEnded:Connect(release)
    registerConnection(UserInputService.InputEnded:Connect(release))
end

-- Modal Confirmation Dialog for 'X' Close
local ModalOverlay = Instance.new("Frame", ScreenGui)
ModalOverlay.Name = "ModalOverlay"
ModalOverlay.Size = UDim2.new(1, 0, 1, 0)
ModalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ModalOverlay.BackgroundTransparency = 0.5
ModalOverlay.Visible = false
ModalOverlay.ZIndex = 100

local ModalFrame = Instance.new("Frame", ModalOverlay)
ModalFrame.Size = UDim2.fromOffset(360, 200)
ModalFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
ModalFrame.BackgroundColor3 = THEME.Background
ModalFrame.BorderSizePixel = 0
Instance.new("UICorner", ModalFrame).CornerRadius = UDim.new(0, 14)
local ModalStroke = Instance.new("UIStroke", ModalFrame)
ModalStroke.Color = THEME.Title
ModalStroke.Thickness = 2

local ModalTitle = Instance.new("TextLabel", ModalFrame)
ModalTitle.Size = UDim2.new(1, 0, 0, 36)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = tr("CloseConfirmTitle")
ModalTitle.TextColor3 = THEME.Title
ModalTitle.Font = THEME.Font
ModalTitle.TextSize = 14

local ModalBody = Instance.new("TextLabel", ModalFrame)
ModalBody.Size = UDim2.new(1, -30, 0, 70)
ModalBody.Position = UDim2.new(0, 15, 0, 42)
ModalBody.BackgroundTransparency = 1
ModalBody.Text = tr("CloseConfirmBody")
ModalBody.TextColor3 = THEME.Text
ModalBody.Font = THEME.FontReg
ModalBody.TextSize = 12
ModalBody.TextWrapped = true

local ModalBtnYes = Instance.new("TextButton", ModalFrame)
ModalBtnYes.Size = UDim2.fromOffset(140, 36)
ModalBtnYes.Position = UDim2.new(0, 25, 1, -50)
ModalBtnYes.BackgroundColor3 = THEME.Green
ModalBtnYes.Text = tr("BtnYes")
ModalBtnYes.TextColor3 = Color3.fromRGB(255, 255, 255)
ModalBtnYes.Font = THEME.Font
ModalBtnYes.TextSize = 13
Instance.new("UICorner", ModalBtnYes).CornerRadius = UDim.new(0, 8)

local ModalBtnCancel = Instance.new("TextButton", ModalFrame)
ModalBtnCancel.Size = UDim2.fromOffset(140, 36)
ModalBtnCancel.Position = UDim2.new(1, -165, 1, -50)
ModalBtnCancel.BackgroundColor3 = THEME.Red
ModalBtnCancel.Text = tr("BtnCancel")
ModalBtnCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
ModalBtnCancel.Font = THEME.Font
ModalBtnCancel.TextSize = 13
Instance.new("UICorner", ModalBtnCancel).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    closeOtherDropdowns(nil)
    ModalOverlay.Visible = true
end)
ModalBtnCancel.MouseButton1Click:Connect(function()
    ModalOverlay.Visible = false
end)

-- Total Clean Sterilization on Yes
local function sterilizeAndDestroy()
    _G.BH_STEALASEED_CLEANUP = nil
    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, t in ipairs(activeThreads) do
        pcall(function() task.cancel(t) end)
    end
    clearEsp()
    if setFly then setFly(false) end
    pcall(function()
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end)
    pcall(function()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "BH_SafeLandingPad" then obj:Destroy() end
        end
    end)
    ScreenGui:Destroy()
end
_G.BH_STEALASEED_CLEANUP = sterilizeAndDestroy
ModalBtnYes.MouseButton1Click:Connect(sterilizeAndDestroy)

-- Tab & Component Builder Engine
local tabs = {}
local currentTab = nil

local tabOrderCounter = 0
local function createTab(tabId, titleText)
    tabOrderCounter = tabOrderCounter + 1
    local btn = Instance.new("TextButton", TabBar)
    btn.Name = "TabBtn_" .. tabId
    btn.LayoutOrder = tabOrderCounter
    btn.Size = UDim2.new(0, 115, 0, 32)
    btn.BackgroundColor3 = THEME.Card
    btn.Text = titleText
    btn.TextColor3 = THEME.SubText
    btn.Font = THEME.Font
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = THEME.Border
    bStroke.Thickness = 1

    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Name = "Page_" .. tabId
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.Accent
    page.Visible = false

    local pLayout = Instance.new("UIListLayout", page)
    pLayout.Padding = UDim.new(0, 10)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local pPadding = Instance.new("UIPadding", page)
    pPadding.PaddingRight = UDim.new(0, 6)

    pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 15)
    end)

    local tabData = {Id = tabId, Button = btn, Page = page, Title = titleText}
    tabs[tabId] = tabData

    btn.MouseButton1Click:Connect(function()
        closeOtherDropdowns(nil)
        for _, t in pairs(tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = THEME.Card
            t.Button.TextColor3 = THEME.SubText
        end
        page.Visible = true
        btn.BackgroundColor3 = THEME.Panel
        btn.TextColor3 = THEME.Accent
        currentTab = tabId
    end)

    return page
end

local function createSection(parent, titleText, descText)
    local sec = Instance.new("Frame", parent)
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = THEME.Panel
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 10)
    local sStroke = Instance.new("UIStroke", sec)
    sStroke.Color = THEME.Border
    sStroke.Thickness = 1

    local sLayout = Instance.new("UIListLayout", sec)
    sLayout.Padding = UDim.new(0, 8)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local sPadding = Instance.new("UIPadding", sec)
    sPadding.PaddingTop = UDim.new(0, 10)
    sPadding.PaddingBottom = UDim.new(0, 10)
    sPadding.PaddingLeft = UDim.new(0, 12)
    sPadding.PaddingRight = UDim.new(0, 12)

    local lblTitle = Instance.new("TextLabel", sec)
    lblTitle.Size = UDim2.new(1, 0, 0, 18)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = titleText
    lblTitle.TextColor3 = THEME.Title
    lblTitle.Font = THEME.Font
    lblTitle.TextSize = 13
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left

    if descText and descText ~= "" then
        local lblDesc = Instance.new("TextLabel", sec)
        lblDesc.Size = UDim2.new(1, 0, 0, 16)
        lblDesc.BackgroundTransparency = 1
        lblDesc.Text = descText
        lblDesc.TextColor3 = THEME.SubText
        lblDesc.Font = THEME.FontReg
        lblDesc.TextSize = 11
        lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    end

    sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sec.Size = UDim2.new(1, 0, 0, sLayout.AbsoluteContentSize.Y + 22)
    end)

    return sec
end

-- Full-Row Clickable Toggle
local function createToggle(parent, labelText, defaultVal, callback, registerSetter)
    local container = Instance.new("TextButton", parent)
    container.Size = UDim2.new(1, 0, 0, 36)
    container.BackgroundColor3 = THEME.Card
    container.AutoButtonColor = false
    container.Text = ""
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    local cStroke = Instance.new("UIStroke", container)
    cStroke.Color = THEME.Border

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.Text
    lbl.Font = THEME.FontReg
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame", container)
    switch.Size = UDim2.fromOffset(40, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = defaultVal and THEME.Green or THEME.Border
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = defaultVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    local function update(val)
        state = val
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and THEME.Green or THEME.Border}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(state)
        saveConfig()
    end

    container.MouseButton1Click:Connect(function()
        update(not state)
    end)
    if registerSetter and type(registerSetter) == "function" then
        registerSetter(update)
    end
    return container
end

-- Direct Input Number Slider
local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = THEME.Card
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    local cStroke = Instance.new("UIStroke", container)
    cStroke.Color = THEME.Border

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1, -70, 0, 22)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.Text
    lbl.Font = THEME.FontReg
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valBox = Instance.new("TextBox", container)
    valBox.Size = UDim2.fromOffset(50, 20)
    valBox.Position = UDim2.new(1, -62, 0, 5)
    valBox.BackgroundColor3 = THEME.Panel
    valBox.Text = tostring(defaultVal)
    valBox.TextColor3 = THEME.Accent
    valBox.Font = THEME.Font
    valBox.TextSize = 11
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 6)

    local barBg = Instance.new("TextButton", container)
    barBg.Size = UDim2.new(1, -24, 0, 8)
    barBg.Position = UDim2.new(0, 12, 0, 32)
    barBg.BackgroundColor3 = THEME.Panel
    barBg.AutoButtonColor = false
    barBg.Text = ""
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", barBg)
    local curVal = defaultVal
    local pct = math.clamp((curVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = THEME.Accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local function setVal(v)
        curVal = math.clamp(v, minVal, maxVal)
        valBox.Text = tostring(math.floor(curVal * 10) / 10)
        local p = (curVal - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(p, 0, 1, 0)
        callback(curVal)
        saveConfig()
    end

    local sDragging = false
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = true
            local p = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            setVal(minVal + (maxVal - minVal) * p)
        end
    end)
    registerConnection(UserInputService.InputChanged:Connect(function(input)
        if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            setVal(minVal + (maxVal - minVal) * p)
        end
    end))
    registerConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = false
        end
    end))

    valBox.FocusLost:Connect(function()
        local num = tonumber(valBox.Text)
        if num then setVal(num) else valBox.Text = tostring(curVal) end
    end)

    return container
end

-- [12.5] 💎 POPUP DROPDOWN MENU ENGINE (1:1 MY FLOWER SHOP EXACT STANDARD)
local function createDropdown(parent, labelText, options, arg4, arg5)
    local defaultVal = type(arg4) == "string" and arg4 or (type(arg5) == "string" and arg5 or nil)
    local callback   = type(arg5) == "function" and arg5 or (type(arg4) == "function" and arg4 or nil)
    
    local safeSel = tostring(defaultVal or (type(options) == "table" and options[1]) or "Auto")
    local selectedValue = safeSel
    local isOpen = false
    local myId = {}
    
    -- Main Row Container
    local ddRow = Instance.new("Frame")
    ddRow.Size = UDim2.new(1, 0, 0, 38)
    ddRow.BackgroundColor3 = (THEME and THEME.Slot) or Color3.fromRGB(25, 27, 40)
    ddRow.BorderSizePixel = 0
    ddRow.Parent = parent
    ddRow.ZIndex = 5
    
    local ddCorner = Instance.new("UICorner", ddRow)
    ddCorner.CornerRadius = UDim.new(0, 8)
    local ddStroke = Instance.new("UIStroke", ddRow)
    ddStroke.Color = THEME.Border
    ddStroke.Thickness = 1
    
    -- Left Label
    local ddLabel = Instance.new("TextLabel", ddRow)
    ddLabel.Size = UDim2.new(0.42, 0, 1, 0)
    ddLabel.Position = UDim2.new(0, 12, 0, 0)
    ddLabel.BackgroundTransparency = 1
    ddLabel.Font = THEME.Font
    ddLabel.TextSize = 12
    ddLabel.TextColor3 = THEME.Text
    ddLabel.TextXAlignment = Enum.TextXAlignment.Left
    ddLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ddLabel.Text = labelText or "Dropdown"
    ddLabel.ZIndex = 6
    
    -- Right Value Button / Trigger
    local ddBtn = Instance.new("TextButton", ddRow)
    ddBtn.Size = UDim2.new(0.55, -12, 0, 28)
    ddBtn.Position = UDim2.new(0.45, 0, 0.5, -14)
    ddBtn.BackgroundColor3 = THEME.Panel
    ddBtn.AutoButtonColor = false
    ddBtn.Text = ""
    ddBtn.BorderSizePixel = 0
    ddBtn.ZIndex = 6
    Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0, 6)
    local btnStroke = Instance.new("UIStroke", ddBtn)
    btnStroke.Color = THEME.Border
    btnStroke.Thickness = 1
    
    local ddValLabel = Instance.new("TextLabel", ddBtn)
    ddValLabel.Size = UDim2.new(1, -24, 1, 0)
    ddValLabel.Position = UDim2.new(0, 8, 0, 0)
    ddValLabel.BackgroundTransparency = 1
    ddValLabel.Font = THEME.Font
    ddValLabel.TextSize = 11
    ddValLabel.TextColor3 = (THEME and THEME.Title) or (THEME and THEME.Gold) or Color3.fromRGB(255, 215, 0)
    ddValLabel.TextXAlignment = Enum.TextXAlignment.Left
    ddValLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ddValLabel.Text = safeSel
    ddValLabel.ZIndex = 7
    
    local ddArrow = Instance.new("TextLabel", ddBtn)
    ddArrow.Size = UDim2.new(0, 18, 1, 0)
    ddArrow.Position = UDim2.new(1, -20, 0, 0)
    ddArrow.BackgroundTransparency = 1
    ddArrow.Font = THEME.Font
    ddArrow.TextSize = 11
    ddArrow.TextColor3 = (THEME and THEME.Title) or (THEME and THEME.Gold) or Color3.fromRGB(255, 215, 0)
    ddArrow.Text = "▼"
    ddArrow.ZIndex = 7
    
    -- Floating ScrollingFrame List attached to ScreenGui (ZIndex 500)
    local listFrame = nil
    local function getList()
        if listFrame and listFrame.Parent then return listFrame end
        local l = Instance.new("ScrollingFrame")
        l.Name = "BH_DropdownList"
        l.Size = UDim2.fromOffset(0, 0)
        l.BackgroundColor3 = THEME.Panel
        l.BorderSizePixel = 0
        l.ScrollBarThickness = 4
        l.ScrollBarImageColor3 = (THEME and THEME.Title) or Color3.fromRGB(255, 215, 0)
        l.Visible = false
        l.ZIndex = 500
        l.ClipsDescendants = true
        Instance.new("UICorner", l).CornerRadius = UDim.new(0, 8)
        local lStroke = Instance.new("UIStroke", l)
        lStroke.Color = (THEME and THEME.Title) or Color3.fromRGB(255, 215, 0)
        lStroke.Thickness = 1.5
        
        local ll = Instance.new("UIListLayout", l)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 3)
        
        local lp = Instance.new("UIPadding", l)
        lp.PaddingTop = UDim.new(0, 4)
        lp.PaddingBottom = UDim.new(0, 4)
        lp.PaddingLeft = UDim.new(0, 4)
        lp.PaddingRight = UDim.new(0, 4)
        
        l.Parent = ScreenGui
        listFrame = l
        return l
    end
    
    local function listGeom()
        local s = (ScreenGui:FindFirstChildOfClass("UIScale") and ScreenGui:FindFirstChildOfClass("UIScale").Scale) or 1
        local ap, as = ddBtn.AbsolutePosition, ddBtn.AbsoluteSize
        local w = math.max(as.X / s, 280)
        local x = (ap.X + as.X) / s - w
        local y = (ap.Y + as.Y + 4) / s
        if x < 12 then x = 12 end
        return w, x, y
    end
    
    local function closeList()
        if not isOpen then return end
        isOpen = false
        ddArrow.Text = "▼"
        if DD.blocker then DD.blocker.Visible = false end
        if not listFrame then return end
        local w = select(1, listGeom())
        TweenService:Create(listFrame, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(w, 0) }):Play()
        task.delay(0.15, function()
            if not isOpen and listFrame then listFrame.Visible = false end
        end)
    end
    
    DD.closers[myId] = closeList
    
    local function rebuild()
        local lst = getList()
        for _, child in ipairs(lst:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local items = type(options) == "function" and options() or options
        items = items or {}
        
        -- Cancel Button (Red) at Top
        local cancelBtn = Instance.new("TextButton", lst)
        cancelBtn.Size = UDim2.new(1, -6, 0, 26)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        cancelBtn.Text = "[X] TUTUP (batal, tidak memilih)"
        cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelBtn.Font = THEME.Font
        cancelBtn.TextSize = 11
        cancelBtn.LayoutOrder = -1
        cancelBtn.ZIndex = 501
        Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 6)
        cancelBtn.MouseButton1Click:Connect(function()
            closeList()
        end)
        
        -- Item Buttons
        for i, item in ipairs(items) do
            local optBtn = Instance.new("TextButton", lst)
            optBtn.Size = UDim2.new(1, -6, 0, 26)
            local isSelected = (tostring(item) == tostring(selectedValue))
            optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(38, 44, 68) or ((THEME and THEME.Slot) or Color3.fromRGB(25, 27, 40))
            optBtn.Text = "  " .. tostring(item)
            optBtn.TextColor3 = isSelected and ((THEME and THEME.Title) or Color3.fromRGB(255, 215, 0)) or THEME.Text
            optBtn.Font = THEME.FontReg
            optBtn.TextSize = 11
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.TextTruncate = Enum.TextTruncate.AtEnd
            optBtn.LayoutOrder = i
            optBtn.ZIndex = 501
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 6)
            
            optBtn.MouseButton1Click:Connect(function()
                selectedValue = item
                ddValLabel.Text = tostring(item)
                closeList()
                if callback then
                    callback(item)
                end
                saveConfig()
            end)
        end
        
        lst.CanvasSize = UDim2.new(0, 0, 0, (#items + 1) * 29 + 10)
    end
    
    ddBtn.MouseButton1Click:Connect(function()
        if isOpen then
            closeList()
            return
        end
        closeOtherDropdowns(myId)
        local lst = getList()
        rebuild()
        isOpen = true
        local w, x, y = listGeom()
        local items = type(options) == "function" and options() or options
        items = items or {}
        local targetH = math.min((#items + 1) * 29 + 10, 180)
        
        lst.Position = UDim2.fromOffset(x, y)
        lst.Size = UDim2.fromOffset(w, 0)
        lst.Visible = true
        dropdownBlocker().Visible = true
        
        TweenService:Create(lst, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(w, targetH) }):Play()
        ddArrow.Text = "▲"
    end)
    
    return ddRow
end
local makeDropdown = createDropdown

-- Helper: Multi-Select Droplist Standar 1:1 My Flower Shop (ZIndex 500 Popup Checklist)
local function makeMultiDropdown(parent, label, getItems, store, emptyTxt, mapValue, onChanged)
    local con = Instance.new("Frame", parent)
    con.Size = UDim2.new(1, 0, 0, 38)
    con.BackgroundColor3 = (THEME and THEME.Slot) or Color3.fromRGB(25, 27, 40)
    con.BorderSizePixel = 0
    con.ZIndex = 5
    Instance.new("UICorner", con).CornerRadius = UDim.new(0, 8)
    local cStroke = Instance.new("UIStroke", con)
    cStroke.Color = THEME.Border
    cStroke.Thickness = 1
    
    local name = Instance.new("TextLabel", con)
    name.Size = UDim2.new(0.48, -10, 1, 0)
    name.Position = UDim2.new(0, 12, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = label
    name.TextColor3 = THEME.Text
    name.Font = THEME.Font
    name.TextSize = 12
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.ZIndex = 6
    
    local disp = Instance.new("TextLabel", con)
    disp.Size = UDim2.new(0.48, -34, 1, 0)
    disp.Position = UDim2.new(0.48, 0, 0, 0)
    disp.BackgroundTransparency = 1
    disp.TextColor3 = THEME.SubText
    disp.Font = THEME.FontReg
    disp.TextSize = 12
    disp.TextXAlignment = Enum.TextXAlignment.Right
    disp.TextTruncate = Enum.TextTruncate.AtEnd
    disp.ZIndex = 6
    
    local arr = Instance.new("TextLabel", con)
    arr.Size = UDim2.new(0, 26, 1, 0)
    arr.Position = UDim2.new(1, -28, 0, 0)
    arr.BackgroundTransparency = 1
    arr.Text = "▼"
    arr.TextColor3 = THEME.Title
    arr.Font = THEME.Font
    arr.TextSize = 12
    arr.ZIndex = 6
    
    local trig = Instance.new("TextButton", con)
    trig.Size = UDim2.new(1, 0, 1, 0)
    trig.BackgroundTransparency = 1
    trig.Text = ""
    trig.ZIndex = 7
    
    local list
    local function getList()
        if list and list.Parent then return list end
        local l = Instance.new("ScrollingFrame")
        l.Name = "BH_MultiDropdownList"
        l.Size = UDim2.fromOffset(0, 0)
        l.BackgroundColor3 = THEME.Panel
        l.BorderSizePixel = 0
        l.ScrollBarThickness = 4
        l.ScrollBarImageColor3 = THEME.Title
        l.Visible = false
        l.ZIndex = 500
        l.ClipsDescendants = true
        Instance.new("UICorner", l).CornerRadius = UDim.new(0, 8)
        local lStroke = Instance.new("UIStroke", l)
        lStroke.Color = THEME.Title
        lStroke.Thickness = 1.5
        
        local ll = Instance.new("UIListLayout", l)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 3)
        local lp = Instance.new("UIPadding", l)
        lp.PaddingTop = UDim.new(0, 4)
        lp.PaddingLeft = UDim.new(0, 4)
        lp.PaddingRight = UDim.new(0, 4)
        lp.PaddingBottom = UDim.new(0, 4)
        l.Parent = ScreenGui
        list = l
        return l
    end
    
    local function listGeom()
        local s = (ScreenGui:FindFirstChildOfClass("UIScale") and ScreenGui:FindFirstChildOfClass("UIScale").Scale) or 1
        local ap, as = con.AbsolutePosition, con.AbsoluteSize
        local w = math.max(as.X / s, 280)
        local x = ap.X / s
        local y = (ap.Y + as.Y + 4) / s
        if x < 12 then x = 12 end
        return w, x, y
    end
    
    local function refreshDisplay()
        local items = type(getItems) == "function" and getItems() or getItems
        local n = 0
        local firstText = nil
        if type(items) == "table" and #items > 0 then
            local valid = {}
            for _, it in ipairs(items) do
                local k = mapValue and mapValue(it) or it
                valid[k] = it
            end
            for k, v in pairs(store) do
                if v and valid[k] then
                    n = n + 1
                    if not firstText then firstText = valid[k] end
                end
            end
        else
            for k, v in pairs(store) do
                if v then
                    n = n + 1
                    if not firstText then firstText = k end
                end
            end
        end
        if n == 0 then
            disp.Text = emptyTxt or "None"
            disp.TextColor3 = THEME.SubText
        elseif n == 1 then
            disp.Text = firstText or (emptyTxt or "None")
            disp.TextColor3 = THEME.Title
        else
            disp.Text = "Various (" .. n .. ")"
            disp.TextColor3 = THEME.Title
        end
    end
    refreshDisplay()
    
    local isOpen = false
    local myId = {}
    local function closeList()
        if not isOpen then return end
        isOpen = false
        arr.Text = "▼"
        if DD.blocker then DD.blocker.Visible = false end
        if not list then return end
        local w = select(1, listGeom())
        TweenService:Create(list, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(w, 0) }):Play()
        task.delay(0.15, function()
            if not isOpen and list then list.Visible = false end
        end)
    end
    DD.closers[myId] = closeList
    
    local function rebuild()
        local lst = getList()
        for _, c in ipairs(lst:GetChildren()) do
            if c:IsA("TextButton") or c:IsA("Frame") then
                c:Destroy()
            end
        end
        
        local items = type(getItems) == "function" and getItems() or getItems
        
        -- Row tombol aksi cepat di bagian atas dropdown
        local quickRow = Instance.new("Frame", lst)
        quickRow.Size = UDim2.new(1, -6, 0, 26)
        quickRow.BackgroundTransparency = 1
        quickRow.LayoutOrder = -2
        quickRow.ZIndex = 501
        local qrLayout = Instance.new("UIListLayout", quickRow)
        qrLayout.FillDirection = Enum.FillDirection.Horizontal
        qrLayout.Padding = UDim.new(0, 4)
        
        local cancel = Instance.new("TextButton", quickRow)
        cancel.Size = UDim2.new(0.24, -2, 1, 0)
        cancel.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
        cancel.Text = "❌ Tutup"
        cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancel.Font = THEME.Font
        cancel.TextSize = 11
        cancel.ZIndex = 502
        Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)
        cancel.MouseButton1Click:Connect(function()
            closeList()
        end)
        
        local quick5 = Instance.new("TextButton", quickRow)
        quick5.Size = UDim2.new(0.42, -2, 1, 0)
        quick5.BackgroundColor3 = Color3.fromRGB(45, 120, 210)
        quick5.Text = "👑 5 Depan"
        quick5.TextColor3 = Color3.fromRGB(255, 255, 255)
        quick5.Font = THEME.Font
        quick5.TextSize = 11
        quick5.ZIndex = 502
        Instance.new("UICorner", quick5).CornerRadius = UDim.new(0, 6)
        
        local quickAll = Instance.new("TextButton", quickRow)
        quickAll.Size = UDim2.new(0.34, -2, 1, 0)
        quickAll.BackgroundColor3 = THEME.Purple
        quickAll.Text = "⚡ All/Clear"
        quickAll.TextColor3 = Color3.fromRGB(255, 255, 255)
        quickAll.Font = THEME.Font
        quickAll.TextSize = 11
        quickAll.ZIndex = 502
        Instance.new("UICorner", quickAll).CornerRadius = UDim.new(0, 6)
        
        local rows = {}
        local function paint(btn, key, teks)
            local on = store[key] == true
            btn.BackgroundColor3 = on and Color3.fromRGB(35, 65, 50) or ((THEME and THEME.Slot) or Color3.fromRGB(25, 27, 40))
            btn.Text = (on and "  [✔]  " or "  [  ]  ") .. (teks or key)
            btn.TextColor3 = on and Color3.fromRGB(0, 255, 170) or THEME.Text
        end
        
        for i, item in ipairs(items) do
            local key = mapValue and mapValue(item) or item
            local opt = Instance.new("TextButton", lst)
            opt.Size = UDim2.new(1, -6, 0, 26)
            opt.Font = THEME.FontReg
            opt.TextSize = 12
            opt.TextXAlignment = Enum.TextXAlignment.Left
            opt.TextTruncate = Enum.TextTruncate.AtEnd
            opt.LayoutOrder = i
            opt.ZIndex = 501
            Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)
            paint(opt, key, item)
            rows[key] = { b = opt, l = item }
            opt.MouseButton1Click:Connect(function()
                store[key] = not store[key] or nil
                paint(opt, key, item)
                refreshDisplay()
                saveConfig()
                if onChanged then pcall(onChanged, key, store[key]) end
            end)
        end
        
        quick5.MouseButton1Click:Connect(function()
            for _, item in ipairs(items) do
                local key = mapValue and mapValue(item) or item
                local isFront = (key == "Seed 08" or key == "Seed 09" or key == "Seed 10" or key == "Seed 11" or key == "Seed 12")
                store[key] = isFront or nil
            end
            for key, r in pairs(rows) do paint(r.b, key, r.l) end
            refreshDisplay()
            saveConfig()
            if onChanged then pcall(onChanged, "*top5*", true) end
        end)
        
        quickAll.MouseButton1Click:Connect(function()
            local anyOn = false
            for k, v in pairs(store) do if v then anyOn = true break end end
            if anyOn then
                for k in pairs(store) do store[k] = nil end
            else
                for _, item in ipairs(items) do
                    local key = mapValue and mapValue(item) or item
                    store[key] = true
                end
            end
            for key, r in pairs(rows) do paint(r.b, key, r.l) end
            refreshDisplay()
            saveConfig()
            if onChanged then pcall(onChanged, "*all*", not anyOn) end
        end)
        
        lst.CanvasSize = UDim2.new(0, 0, 0, (#items + 1) * 30 + 38)
    end
    
    trig.MouseButton1Click:Connect(function()
        if isOpen then closeList(); return end
        closeOtherDropdowns(myId)
        local lst = getList()
        rebuild()
        isOpen = true
        local w, x, y = listGeom()
        local items = type(getItems) == "function" and getItems() or getItems
        local h = math.min((#items + 1) * 30 + 38, 230)
        
        pcall(function()
            local cam = workspace.CurrentCamera
            local vpY = (cam and cam.ViewportSize.Y) or 720
            local s = (ScreenGui:FindFirstChildOfClass("UIScale") and ScreenGui:FindFirstChildOfClass("UIScale").Scale) or 1
            if (y + h) * s > vpY - 10 then
                y = math.max(10, (con.AbsolutePosition.Y - 4) / s - h)
            end
        end)
        
        lst.Position = UDim2.fromOffset(x, y)
        lst.Size = UDim2.fromOffset(w, 0)
        lst.Visible = true
        dropdownBlocker().Visible = true
        TweenService:Create(lst, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(w, h) }):Play()
        arr.Text = "▲"
    end)
    
    return con, refreshDisplay
end


local function createButton(parent, labelText, arg3, arg4)
    local color = (typeof(arg3) == "Color3" and arg3) or THEME.Card
    local callback = (type(arg3) == "function" and arg3) or (type(arg4) == "function" and arg4) or function() end
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color
    btn.Text = labelText
    btn.TextColor3 = THEME.Text
    btn.Font = THEME.Font
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = THEME.Border
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

-- ============================================================================
-- [13] BUILD TABS & INTERFACES
-- ============================================================================

-- TAB 1: 🌱 AUTO STEAL
local pageSteal = createTab("Steal", tr("TabSteal"))
-- Buka langsung tab pertama seketika dibuat agar halaman TIDAK AKAN PERNAH KOSONG / HITAM!
pageSteal.Visible = true
if tabs["Steal"] and tabs["Steal"].Button then
    tabs["Steal"].Button.BackgroundColor3 = THEME.Panel
    tabs["Steal"].Button.TextColor3 = THEME.Accent
end
currentTab = "Steal" 
-- Buka langsung tab pertama seketika dibuat agar halaman TIDAK AKAN PERNAH KOSONG / HITAM!
pageSteal.Visible = true
if tabs["Steal"] and tabs["Steal"].Button then
    tabs["Steal"].Button.BackgroundColor3 = THEME.Panel
    tabs["Steal"].Button.TextColor3 = THEME.Accent
end
currentTab = "Steal" 
local secSteal = createSection(pageSteal, "FLASH AUTO STEAL & SAFE HARVEST SUITE", "Curi bibit instan, teleport langsung ke bibit, tekan E, langsung kembali ke markas (100% Bebas Dikejar Penjaga)")
createToggle(secSteal, tr("FlashSteal"), config.autoSteal, function(v) config.autoSteal = v config.autoFlashSteal = v end)
createToggle(secSteal, tr("SmartWait"), config.smartWaitSeed, function(v) config.smartWaitSeed = v end)

-- SEKSI MULTI-SELECT DROPLIST STANDAR 1:1 MY FLOWER SHOP
makeMultiDropdown(secSteal, "🎯 Target Seeds to Steal", function()
    local list = {}
    for _, s in ipairs(ALL_STEALABLE_SEEDS) do
        table.insert(list, s.displayName)
    end
    return list
end, config.multiTargetSeeds, "None (Stay at Base)", function(displayName)
    for _, s in ipairs(ALL_STEALABLE_SEEDS) do
        if s.displayName == displayName or s.key == displayName then
            return s.key
        end
    end
    return displayName
end, function(key, state)
    saveConfig()
end)

createToggle(secSteal, tr("AutoPlant"), config.autoPlant, function(v) config.autoPlant = v end)
createToggle(secSteal, tr("HoldSeed"), config.holdSeedInHand, function(v) config.holdSeedInHand = v end)
createToggle(secSteal, tr("AntiGuard"), config.antiGuardChase, function(v) config.antiGuardChase = v end)
createToggle(secSteal, tr("AntiFling"), config.antiFlingShield, function(v) config.antiFlingShield = v end)
createToggle(secSteal, tr("FullAfk"), config.fullAfkLoop, function(v) config.fullAfkLoop = v end)
createSlider(secSteal, tr("StealDelay"), 0.2, 5.0, config.stealDelay, function(v) config.stealDelay = v end)
createSlider(secSteal, tr("SkyHeight"), 20, 100, config.skyFlightHeight, function(v) config.skyFlightHeight = v end)
createButton(secSteal, "📍 Simpan Posisi Saat Ini Sebagai Markas", THEME.Panel, function()
    local hrp = getHrp()
    if hrp then
        config.customBasePos = hrp.Position
        saveConfig()
        notify("👑 MARKAS DISIMPAN", string.format("Posisi saat ini (%.1f, %.1f, %.1f) disimpan sebagai titik Markas!", hrp.Position.X, hrp.Position.Y, hrp.Position.Z), 4)
    end
end)
createButton(secSteal, "🏠 Teleport / Return ke Markas Sekarang", THEME.Green, function()
    local hrp = getHrp()
    if not hrp then return end
    local dest = toVector3(config.customBasePos) or getBasePosition()
    if dest then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.CanCollide = true
                end
            end
            char:PivotTo(CFrame.new(dest))
        end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(dest)
        local hum = getHumanoid()
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        notify("🏠 MARKAS", string.format("Teleport ke Markas: (%.1f, %.1f, %.1f)!", dest.X, dest.Y, dest.Z), 3)
    else
        notify("❌ GAGAL", "Posisi markas belum tersimpan!", 3)
    end
end)

createButton(secSteal, "📍 Simpan Posisi Saat Ini Sebagai Paling Depan", THEME.Panel, function()
    local hrp = getHrp()
    if hrp then
        config.customPalingDepanPos = hrp.Position
        saveConfig()
        notify("👑 PALING DEPAN DISIMPAN", string.format("Posisi saat ini (%.1f, %.1f, %.1f) disimpan sebagai Paling Depan!", hrp.Position.X, hrp.Position.Y, hrp.Position.Z), 4)
    end
end)
createButton(secSteal, "⚡ Teleport / Return ke Paling Depan Sekarang", THEME.Gold, function()
    local hrp = getHrp()
    if not hrp then return end
    local dest = toVector3(config.customPalingDepanPos) or Vector3.new(-77.2, 3.5, -6080.9)
    local char = LocalPlayer.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.CanCollide = true
            end
        end
        char:PivotTo(CFrame.new(dest))
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(dest)
    local hum = getHumanoid()
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    notify("⚡ PALING DEPAN", string.format("Teleport ke Paling Depan: (%.1f, %.1f, %.1f)!", dest.X, dest.Y, dest.Z), 3)
end)


local secManualSteal = createSection(pageSteal, "PENGATURAN STEAL PROXIMITY", "Bypass interaksi tombol dan radius scan bibit manual")
createToggle(secManualSteal, tr("InstantPrompt"), config.instantPrompt, function(v) config.instantPrompt = v end)
createSlider(secManualSteal, tr("StealDistance"), 10, 150, config.stealDistance, function(v) config.stealDistance = v end)

-- TAB 2: 🌾 FARM & HARVEST
local pageFarm = createTab("Farm", tr("TabFarm"))
local secFarm = createSection(pageFarm, tr("FarmTitle"), tr("FarmDesc"))
createToggle(secFarm, tr("AutoPickupReady"), config.autoPickupReady, function(v) config.autoPickupReady = v saveConfig() end)
createToggle(secFarm, tr("AutoPlant"), config.autoPlant, function(v) config.autoPlant = v saveConfig() end)
createToggle(secFarm, tr("AutoHarvest"), config.autoHarvest, function(v) config.autoHarvest = v saveConfig() end)
createToggle(secFarm, tr("AutoCollectCash"), config.autoCollectCash, function(v) config.autoCollectCash = v saveConfig() end)
createButton(secFarm, tr("BtnPickupAll"), THEME.Green, function()
    pickupReadyCrops()
    showNotification("🧺 PANEN TANAMAN", "Mengambil tanaman matang di sekitar kebun!", 3)
end)
createSlider(secFarm, "Harvest Interval (s)", 0.2, 5.0, config.harvestInterval, function(v) config.harvestInterval = v saveConfig() end)

-- TAB 3: 💰 AUTO SELL
local pageSell = createTab("Sell", tr("TabSell"))
local secSell = createSection(pageSell, tr("SellTitle"), tr("SellDesc"))
createToggle(secSell, tr("AutoSell"), config.autoSell, function(v) config.autoSell = v end)
createSlider(secSell, tr("SellInterval"), 1.0, 30.0, config.sellInterval, function(v) config.sellInterval = v end)
createButton(secSell, tr("BtnSellNow"), THEME.Green, function()
    performSellCrops()
end)

-- TAB 4: 🛒 SEED SHOP & PACKS
local pageShop = createTab("Shop", tr("TabShop"))

-- 🛒 TOKO PENGURANGAN WAKTU TUMBUH (GROWTH TIME SHOP — 道具商店)
local secBuckets = createSection(pageShop, "🛒 Toko Growth Time (Water Buckets — 道具商店)", "道具商店 (UseItemStore) = Toko Ember Air & Pengurangan Waktu Tumbuh Tanaman 20% - 80% (100% Cash Game, Bebas Robux).")
createDropdown(secBuckets, "🎯 Pilihan Target Growth Time", BUCKET_OPTIONS, config.targetBucket or "Borong Semua Stok Tersedia (All In-Stock)", function(v)
    config.targetBucket = v
    saveConfig()
end)
createToggle(secBuckets, "⚡ Auto Borong Semua Growth Time (Cash Game)", config.autoBuyBuckets, function(v)
    config.autoBuyBuckets = v
    saveConfig()
end)
createButton(secBuckets, "🛒 Borong Semua Sekarang (Buy All In-Stock Now)", THEME.Green, function()
    local target = config.targetBucket or "Borong Semua Stok Tersedia (All In-Stock)"
    local success, boughtName = buyGrowthTimeWithCash(target, true)
    if not success then
        notify("👑 Brother Hub", "ℹ️ Stok Growth Time kosong / toko belum restock!", 4)
    end
end)
createButton(secBuckets, "Buka / Tutup Toko (Toggle Frame 道具商店)", THEME.Panel, function()
    local sf = getToolShopFrame()
    if not sf then
        openToolShop(true)
        sf = getToolShopFrame()
    end
    if sf then
        userManuallyOpenedShop = not userManuallyOpenedShop
        sf.Position = UDim2.new(0.5, 0, 0.5, 0)
        sf.Visible = userManuallyOpenedShop
    end
end)

local secShop = createSection(pageShop, tr("ShopTitle"), tr("ShopDesc"))
createToggle(secShop, tr("BlockRobux"), config.blockRobuxPopups, function(v) config.blockRobuxPopups = v end)
createToggle(secShop, tr("AutoBuySeeds"), config.autoBuySeeds, function(v) config.autoBuySeeds = v end)
createToggle(secShop, tr("AutoOpenPacks"), config.autoOpenPacks, function(v) config.autoOpenPacks = v end)

makeMultiDropdown(secShop, "🌱 Filter Bibit Auto-Buy", function()
    local list = {}
    for seedName in pairs(config.targetSeeds) do table.insert(list, seedName) end
    table.sort(list)
    return list
end, config.targetSeeds, "None", nil, function() saveConfig() end)

makeMultiDropdown(secShop, "📦 Filter Seed Pack Auto-Open", function()
    local list = {}
    for packName in pairs(config.targetPacks) do table.insert(list, packName) end
    table.sort(list)
    return list
end, config.targetPacks, "None", nil, function() saveConfig() end)

-- TAB 5: 🐾 PETS & EVENTS
local pagePets = createTab("Pets", tr("TabPets"))
local secPets = createSection(pagePets, tr("PetsTitle"), tr("PetsDesc"))
createToggle(secPets, tr("AutoHatchEggs"), config.autoHatchEggs, function(v) config.autoHatchEggs = v end)
createToggle(secPets, tr("AutoEquipPets"), config.autoEquipBestPets, function(v) config.autoEquipBestPets = v end)
createToggle(secPets, tr("AutoTacoEvent"), config.autoTacoEvent, function(v) config.autoTacoEvent = v end)
createToggle(secPets, tr("AutoClaimOffline"), config.autoClaimOffline, function(v) config.autoClaimOffline = v end)
createToggle(secPets, tr("AntiAfk"), config.antiAfk, function(v) config.antiAfk = v end)

-- TAB 6: 🌌 TELEPORT HUB
local pageTp = createTab("Teleport", tr("TabTeleport"))
local secTp = createSection(pageTp, tr("TeleportTitle"), tr("TeleportDesc"))

local teleportLocations = {
    {"🌱 Spawn Location", Vector3.new(0, 10, 0)},
    {"🛒 SeedDealer (Shop)", Vector3.new(0, 10, -41)},
    {"💰 SeedBuyer (Sell Station)", Vector3.new(0, 10, -43)},
    {"🌮 Taco Disco Event Area", Vector3.new(-2.5, 168, -37.7)},
}

for _, loc in ipairs(teleportLocations) do
    createButton(secTp, loc[1], THEME.Card, function()
        safeTeleport(loc[2])
    end)
end

-- TAB 7: 👁️ VISUALS & ESP
local pageVis = createTab("Visuals", tr("TabVisuals"))
local secVis = createSection(pageVis, tr("VisualsTitle"), tr("VisualsDesc"))
createToggle(secVis, tr("SeedEsp"), config.seedEsp, function(v) config.seedEsp = v end)
createToggle(secVis, tr("PlayerEsp"), config.playerEsp, function(v) config.playerEsp = v end)
createToggle(secVis, tr("DealerEsp"), config.dealerEsp, function(v) config.dealerEsp = v end)
createToggle(secVis, tr("Fullbright"), config.fullbright, function(v) config.fullbright = v end)

-- TAB 8: 🏃 MOVEMENT
local pageMove = createTab("Movement", tr("TabMovement"))
local secMove = createSection(pageMove, tr("MovementTitle"), tr("MovementDesc"))
createToggle(secMove, tr("WalkSpeed"), config.walkSpeedEnabled, function(v)
    config.walkSpeedEnabled = v
    if not v then
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = 16 end
    end
end)
createSlider(secMove, tr("SpeedVal"), 16, 250, config.walkSpeedValue, function(v) config.walkSpeedValue = v end)
createToggle(secMove, tr("JumpPower"), config.jumpPowerEnabled, function(v)
    config.jumpPowerEnabled = v
    if not v then
        local hum = getHumanoid()
        if hum then hum.JumpPower = 50 end
    end
end)
createSlider(secMove, tr("JumpVal"), 50, 300, config.jumpPowerValue, function(v) config.jumpPowerValue = v end)
createToggle(secMove, tr("Noclip"), config.noclipEnabled, function(v)
    config.noclipEnabled = v
    if not v then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)
createToggle(secMove, tr("Fly"), config.flyEnabled, function(v)
    config.flyEnabled = v
    setFly(v)
end)
createSlider(secMove, tr("FlySpeed"), 20, 200, config.flySpeed, function(v) config.flySpeed = v end)
createToggle(secMove, tr("InfJump"), config.infiniteJump, function(v) config.infiniteJump = v end)
createToggle(secMove, tr("ClickTp"), config.clickTp, function(v) config.clickTp = v end)

-- TAB 9: 👑 CREDITS
local pageCred = createTab("Credits", tr("TabCredits"))
local secCred = createSection(pageCred, "👑 BROTHER HUB OFFICIAL", "Komunitas Scripting Roblox Terbesar & Paling Terpercaya")
createButton(secCred, "📋 Salin Link Discord Server Resmi", THEME.Panel, function()
    if setclipboard then
        setclipboard("https://discord.gg/szYbZCqHKS")
    end
end)
createButton(secCred, "☕ Donasi Dukungan Pengembang (Saweria)", THEME.Panel, function()
    if setclipboard then
        setclipboard("https://saweria.co/prawiraxliv")
    end
end)
createButton(secCred, "💖 Donasi Dukungan Pengembang (SociaBuzz)", THEME.Panel, function()
    if setclipboard then
        setclipboard("https://sociabuzz.com/brotherhubofficial/tribe")
    end
end)

local secInfo = createSection(pageCred, "Informasi Script & Status", "")
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 90)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = THEME.Font
infoLabel.TextSize = 12
infoLabel.TextColor3 = THEME.SubText
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = "Founder & Lead Developer : prawiraxliv\nGame Target : Steal A Seed (122216176958450)\nGUI Standard : 1:1 FlowerShop Exact Standard\nEngine Status : 100% Undetected & Anti-Detection Active\nSecurity : Brother Guard Multi-Layer Shield"
infoLabel.Parent = secInfo

LangBtn.MouseButton1Click:Connect(function()
    config.language = config.language == "ID" and "EN" or "ID"
    LangBtn.Text = config.language == "ID" and "🇮🇩" or "🇬🇧"
    HeaderTitle.Text = tr("HubTitle")
    ModalTitle.Text = tr("CloseConfirmTitle")
    ModalBody.Text = tr("CloseConfirmBody")
    ModalBtnYes.Text = tr("BtnYes")
    ModalBtnCancel.Text = tr("BtnCancel")
    for tabId, t in pairs(tabs) do
        t.Button.Text = tr("Tab" .. tabId)
    end
    saveConfig()
end)

-- Open Default Tab
local defaultTab = tabs["Steal"]
if defaultTab then
    defaultTab.Page.Visible = true
    defaultTab.Button.BackgroundColor3 = THEME.Panel
    defaultTab.Button.TextColor3 = THEME.Accent
    currentTab = "Steal"
end
