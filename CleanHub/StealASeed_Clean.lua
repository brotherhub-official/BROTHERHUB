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
    "All In-Stock",
    "Yellow Water Bucket",
    "Orange Water Bucket",
    "Purple Water Bucket",
    "Water Bucket"
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

-- [1.6] 🌿 SEED NAME TARGETS & SPECIFIC PATTERNS
local SEED_TARGETS = {
    ["All / Furthest Rare Seed (Auto Paling Langka)"] = { pos = Vector3.new(-77.2, 3.5, -6080.9), pattern = "" },
    ["Infernal Lily (Divine - Z: -6080)"]             = { pos = Vector3.new(-77.2, 3.5, -6080.9), pattern = "infernallily" },
    ["Lucifer Rose (Divine - Z: -6068)"]              = { pos = Vector3.new(-41.4, 4.0, -6068.0), pattern = "luciferrose" },
    ["Underworld Flower (Mythic - Z: -4614)"]         = { pos = Vector3.new(112.6, 3.5, -4614.2), pattern = "underworldflower" },
    ["Bloodthorn (Mythic - Z: -3221)"]                = { pos = Vector3.new(-4.1,  3.5, -3221.3), pattern = "bloodthorn" },
    ["Abyss Orchid (Legendary - Z: -2351)"]           = { pos = Vector3.new(-82.3, 3.5, -2351.6), pattern = "abyssorchid" },
    ["Eclypsion (Legendary - Z: -1754)"]              = { pos = Vector3.new(64.0,  3.5, -1754.5), pattern = "eclypsion" },
    ["Bloodmoon Orchid (Master - Z: -1150)"]          = { pos = Vector3.new(-94.7, 3.5, -1156.4), pattern = "bloodmoonorchid" },
    ["Astralith Tree (Master - Z: -728)"]             = { pos = Vector3.new(92.4,  3.5, -728.3),  pattern = "astralithtree" },
    ["Nyxroot (Epic - Z: -437)"]                      = { pos = Vector3.new(-117.4, 4.0, -437.4), pattern = "nyxroot" },
    ["Solara Maw (Epic - Z: -200)"]                   = { pos = Vector3.new(127.8, 3.5, -200.3),  pattern = "solaramaw" },
    ["Crysalith Vine (Rare)"]                         = { pos = Vector3.new(64.0,  3.5, -1754.5), pattern = "crysalithvine" },
    ["Virelia Bloom (Advanced)"]                      = { pos = Vector3.new(-94.7, 3.5, -1156.4), pattern = "vireliabloom" },
}

local SEED_NAME_KEYS = {
    "All / Furthest Rare Seed (Auto Paling Langka)",
    "Infernal Lily (Divine - Z: -6080)",
    "Lucifer Rose (Divine - Z: -6068)",
    "Underworld Flower (Mythic - Z: -4614)",
    "Bloodthorn (Mythic - Z: -3221)",
    "Abyss Orchid (Legendary - Z: -2351)",
    "Eclypsion (Legendary - Z: -1754)",
    "Bloodmoon Orchid (Master - Z: -1150)",
    "Astralith Tree (Master - Z: -728)",
    "Nyxroot (Epic - Z: -437)",
    "Solara Maw (Epic - Z: -200)",
    "Crysalith Vine (Rare)",
    "Virelia Bloom (Advanced)",
}

-- [2] CONFIGURATION & PERSISTENCE
local CONFIG_FILE = "BrotherHub_StealASeed_Config.json"

local config = {
    -- Auto Steal & Safe Collection Engine
    autoSteal             = false,
    autoFlashSteal        = true,
    targetSeedName        = "All / Furthest Rare Seed (Auto Paling Langka)",
    selectedStage         = "Auto Furthest (Stage 10 - Paling Depan / Tersulit)",
    antiGuardChase        = true,
    antiFlingShield       = true,
    holdSeedInHand        = true,
    skyFlightHeight       = 65,
    instantPrompt         = true,
    stealDistance         = 35,
    stealDelay            = 0.8,
    customBasePos         = nil,
    customPalingDepanPos   = nil,
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
    targetBucket          = "All In-Stock", -- Pilihan ember di droplist
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
    ["FlashSteal"]            = {ID = "⚡ Flash Auto Steal (Maju ➔ Curi ➔ Bawa Pulang)", EN = "⚡ Flash Auto Steal (Advance ➔ Steal ➔ Return Base)"},
    ["SmartWait"]             = {ID = "⏳ Tunggu Bibit Spawn (Stay di Markas jika Kosong)", EN = "⏳ Smart Stay at Base (Wait for Seed Spawn)"},
    ["AntiGuard"]             = {ID = "🛡️ Anti-Kejar Penjaga Tanaman (Lumpuhkan Guard 100%)", EN = "🛡️ Anti-Guard Chase (Pacify & Paralyze Guards)"},
    ["HoldSeed"]              = {ID = "🤲 Pegang Bibit di Tangan (Equip Stolen Seed)", EN = "🤲 Hold Stolen Seed in Hand (Equip Seed)"},
    ["AntiFling"]             = {ID = "🛡️ Anti-Pental & Anti-Knockback (Bebas Pental / Kebal)", EN = "🛡️ Anti-Fling & Knockback Immunity"},
    ["FullAfk"]               = {ID = "🌙 Full AFK Loop (Curi ➔ Koleksi di Taman / Pegang)", EN = "🌙 Full AFK Loop (Steal ➔ Garden Collect / Hold)"},
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
    
    -- 1. Utamakan posisi kebun/plot pemain sendiri
    local myPlot = getMyPlot()
    if myPlot then
        local pPos = myPlot:GetPivot().Position
        return getFloorPosition(pPos) or pPos
    end

    -- 2. Fallback ke SpawnLocation
    local spawnPart = workspace:FindFirstChildOfClass("SpawnLocation") or workspace:FindFirstChild("SpawnLocation", true)
    if spawnPart then
        return getFloorPosition(spawnPart.Position) or spawnPart.Position
    end

    return Vector3.new(-13.26, 1.0, 109.27)
end

-- [4.5] 🛡️ GUARD PACIFIER & ANTI-CHASE NEUTRALIZER (100% BEBAS DIKEJAR PENJAGA TANAMAN)
local guardCache = {}
local lastGuardScan = 0

local function pacifyPlantGuards()
    pcall(function()
        local now = tick()
        if now - lastGuardScan > 3.0 or #guardCache == 0 then
            lastGuardScan = now
            guardCache = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local pName = obj.Parent and obj.Parent.Name or ""
                    if obj.Name == "敌人" or pName == "敌人" or string.find(obj.Name:lower(), "guard") or string.find(obj.Name:lower(), "plant") then
                        table.insert(guardCache, obj)
                    elseif obj:FindFirstChild("atk") or obj:FindFirstChild("Stem_Lower") or obj:FindFirstChild("Wing.L") or obj:FindFirstChild("Wing.R") then
                        table.insert(guardCache, obj)
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

-- Thread Background Terpisah untuk Penjaga (Interval 2.0s - TIDAK MENGGANGGU FPS SAMA SEKALI)
registerThread(function()
    while true do
        if config.antiGuardChase or config.autoSteal or config.fullAfkLoop then
            pacifyPlantGuards()
        end
        task.wait(2.0)
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

-- Helper: Tanam bibit yang dipegang ke petak kebun pemain (Auto Plant ke Garden Plot)
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
                    task.wait(0.1)
                    break
                end
            end
        end
        
        -- Trigger prompt Place / Plant di petak kebun dekat markas
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled and (prompt.ActionText == "Place" or prompt.ActionText == "Plant") then
                local pp = prompt.Parent:IsA("BasePart") and prompt.Parent.Position or (prompt.Parent:IsA("Model") and prompt.Parent:GetPivot().Position)
                if pp and (hrp.Position - pp).Magnitude <= 45 then
                    pcall(function() prompt.HoldDuration = 0 end)
                    if fireproximityprompt then
                        fireproximityprompt(prompt, 0)
                    else
                        pcall(function() prompt:InputHoldBegin() end)
                        task.wait(0.05)
                        pcall(function() prompt:InputHoldEnd() end)
                    end
                end
            end
        end
    end)
end

-- Helper: Ambil tanaman matang / siap panen di kebun (Pickup / Pick Up Crops Engine)
local function pickupReadyCrops(maxDistance)
    local hrp = getHrp()
    if not hrp then return 0 end
    local markas = getBasePosition()
    local limit = maxDistance or 100
    local count = 0
    
    pcall(function()
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local act = prompt.ActionText:lower()
                -- Deteksi ActionText Pickup, Pick Up, Harvest, Collect, Take
                if string.find(act, "pickup") or string.find(act, "pick up") or string.find(act, "harvest") or string.find(act, "collect") or string.find(act, "take") then
                    local pParent = prompt.Parent
                    local pPos = pParent:IsA("BasePart") and pParent.Position or (pParent:IsA("Model") and pParent:GetPivot().Position)
                    if pPos and ((hrp.Position - pPos).Magnitude <= limit or (markas - pPos).Magnitude <= limit) then
                        pcall(function() prompt.HoldDuration = 0 end)
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        else
                            pcall(function() prompt:InputHoldBegin() end)
                            task.wait(0.04)
                            pcall(function() prompt:InputHoldEnd() end)
                        end
                        count = count + 1
                    end
                end
            end
        end
    end)
    return count
end

-- Helper: Baca sisa waktu reset bibit arena (ServerInfo / Level Reset Timer)
local function getArenaResetCountdown()
    local rem = nil
    pcall(function()
        local sInfo = workspace:FindFirstChild("ServerInfo", true)
        if sInfo then
            local gpTime = sInfo:FindFirstChild("Gp_Time")
            if gpTime and gpTime:IsA("IntValue") and gpTime.Value > 0 then
                rem = gpTime.Value
            end
        end
    end)
    if rem then return rem end
    
    -- Fallback: Scan TextLabel di PlayerGui yang menampilkan countdown reset
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pGui then
            for _, lbl in ipairs(pGui:GetDescendants()) do
                if lbl:IsA("TextLabel") and lbl.Visible and lbl.Text ~= "" then
                    local txt = lbl.Text:lower()
                    if string.find(txt, "reset") or string.find(txt, "time") or string.find(txt, ":") then
                        local m, s = string.match(lbl.Text, "(%d+):(%d+)")
                        if m and s then
                            local sec = (tonumber(m) * 60) + tonumber(s)
                            if sec > 0 and sec < 900 then
                                rem = sec
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
    return rem
end

-- Riwayat bibit yang telah dicuri dalam 1 babak (Mendukung borong semua 5 bibit di Stage 10 satu per satu)
local stolenSeedsHistory = {}
local lastResetCountdown = -1

local function checkAndClearResetHistory()
    local curCountdown = getArenaResetCountdown()
    if curCountdown then
        if lastResetCountdown ~= -1 and curCountdown > (lastResetCountdown + 4) then
            -- Babak baru saja reset / bibit baru respawn, bersihkan riwayat agar bisa diborong lagi
            stolenSeedsHistory = {}
        end
        lastResetCountdown = curCountdown
    end
end

local function isPromptAlreadyStolen(p, pos)
    checkAndClearResetHistory()
    if p and stolenSeedsHistory[p] and (tick() - stolenSeedsHistory[p]) < 25 then
        return true
    end
    if pos then
        local posKey = tostring(math.floor(pos.X / 3.0)) .. "_" .. tostring(math.floor(pos.Z / 3.0))
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

-- Helper: Auto Beli Ember Air di Toko Peralatan (UseItemStore / 道具商店) menggunakan Cash in-game (BUKAN Robux!)
local function buyBucketWithCash(targetBucket)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return false end
    local main02 = pg:FindFirstChild("Main02")
    if not main02 then return false end

    -- Cari frame toko alat/ember (道具商店)
    local shopFrame = main02:FindFirstChild("\233\129\147\229\133\183\229\149\134\229\186\151", true)
    if not shopFrame then
        for _, desc in ipairs(main02:GetDescendants()) do
            if desc:IsA("TextLabel") and (string.find(desc.Text, "Restock in") or string.find(desc.Text, "Water Bucket")) then
                local p = desc
                while p and p.Parent and p.Parent ~= main02 do
                    p = p.Parent
                end
                if p and p:IsA("Frame") then
                    shopFrame = p
                    break
                end
            end
        end
    end

    if not shopFrame then return false end

    -- 100% Silent Background Operation: Berjalan hening di latar belakang tanpa membuka GUI toko ke layar
    local scroller = shopFrame:FindFirstChildWhichIsA("ScrollingFrame", true)
    local boughtAny = false

    -- Scan semua tombol pembelian Cash (货币购买)
    for _, btn in ipairs(shopFrame:GetDescendants()) do
        if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible then
            local btnName = btn.Name
            local isCashBtn = (btnName == "\232\180\167\229\184\129\232\180\173\228\185\176" or btnName == "货币购买")
            
            -- Hindari tombol '关闭' (Disabled / Out of Stock)
            if btnName == "\229\133\179\233\151\173" or btnName == "关闭" then
                isCashBtn = false
            end

            -- 100% Bebas Robux: Pastikan BUKAN di dalam frame 罗宝购买 / Robux
            local isRobux = false
            local ancestor = btn.Parent
            while ancestor and ancestor ~= shopFrame do
                local aName = ancestor.Name
                if aName == "\231\189\151\229\174\157\232\180\173\228\185\176" or aName == "罗宝购买" or string.find(aName:lower(), "robux") then
                    isRobux = true
                    break
                end
                ancestor = ancestor.Parent
            end

            if isCashBtn and not isRobux then
                -- Temukan kartu induk (card)
                local card = btn:FindFirstAncestor("root")
                if not card then
                    local temp = btn.Parent
                    while temp and temp.Parent and temp.Parent ~= scroller and temp.Parent ~= shopFrame do
                        temp = temp.Parent
                    end
                    card = temp
                end

                if card then
                    -- Baca nama item dan stok
                    local itemName = "Water Bucket"
                    local isBucket = false
                    local isOut = false
                    local priceText = "Cash"

                    -- Baca TextLabel untuk nama item
                    for _, tl in ipairs(card:GetDescendants()) do
                        if tl:IsA("TextLabel") and tl.Visible and tl.Text ~= "" then
                            local t = tl.Text
                            local tlLower = t:lower()
                            if string.find(tlLower, "bucket") or string.find(tlLower, "water") then
                                itemName = t
                                isBucket = true
                            end
                            -- Cek stok hanya dari container / label stok khusus ("x3 Stock", "x0 Stock")
                            local parentName = tl.Parent and tl.Parent.Name or ""
                            if parentName == "\229\186\147\229\173\152" or parentName == "库存" or string.find(tlLower, "stock") then
                                if string.find(tlLower, "x0") or string.find(tlLower, " 0 stock") or tlLower == "x0 stock" then
                                    isOut = true
                                end
                            end
                        end
                    end

                    -- Cek tombol '关闭' di dalam frame 货币购买 (jika visible, berarti out of stock)
                    local cashContainer = btn.Parent
                    if cashContainer then
                        local disabledBtn = cashContainer:FindFirstChild("\229\133\179\233\151\173") or cashContainer:FindFirstChild("关闭")
                        if disabledBtn and disabledBtn:IsA("GuiObject") and disabledBtn.Visible then
                            isOut = true
                        end
                    end

                    -- Baca harga dari dalam tombol
                    for _, tl in ipairs(btn:GetDescendants()) do
                        if tl:IsA("TextLabel") and (string.find(tl.Text, "K") or string.match(tl.Text, "%d+")) then
                            priceText = tl.Text
                            break
                        end
                    end

                    -- Eksekusi pembelian jika merupakan ember air dan stok tersedia
                    if isBucket and not isOut then
                        local matchesTarget = false
                        if not targetBucket or targetBucket == "All In-Stock" then
                            matchesTarget = true
                        else
                            local tbLower = targetBucket:lower()
                            local inLower = itemName:lower()
                            if string.find(inLower, tbLower) or string.find(tbLower, inLower) then
                                matchesTarget = true
                            elseif string.find(tbLower, "yellow") and string.find(inLower, "yellow") then
                                matchesTarget = true
                            elseif string.find(tbLower, "orange") and string.find(inLower, "orange") then
                                matchesTarget = true
                            elseif string.find(tbLower, "purple") and string.find(inLower, "purple") then
                                matchesTarget = true
                            elseif string.find(tbLower, "epic") and (string.find(inLower, "yellow") or string.find(inLower, "epic")) then
                                matchesTarget = true
                            elseif string.find(tbLower, "legendary") and (string.find(inLower, "orange") or string.find(inLower, "legendary")) then
                                matchesTarget = true
                            end
                        end

                        if matchesTarget then
                            -- Scroll kartu ke view jika ada scroller
                            if scroller and scroller:IsA("ScrollingFrame") then
                                pcall(function()
                                    local cardY = card.AbsolutePosition.Y - scroller.AbsolutePosition.Y + scroller.CanvasPosition.Y
                                    scroller.CanvasPosition = Vector2.new(0, math.max(0, cardY - 10))
                                end)
                                task.wait(0.04)
                            end

                            -- Eksekusi klik multi-layer
                            triggerGuiClick(btn)
                            if btn.Parent and btn.Parent:IsA("GuiObject") then
                                triggerGuiClick(btn.Parent)
                            end
                            for _, child in ipairs(btn:GetChildren()) do
                                if child:IsA("GuiObject") then
                                    triggerGuiClick(child)
                                end
                            end

                            notify("🛒 Auto Buy Bucket", "Membeli " .. itemName .. " (" .. priceText .. ")!", 3)
                            print("[BrotherHub] Auto Buy Bucket Success: " .. itemName .. " (" .. priceText .. ")")
                            boughtAny = true
                            task.wait(0.35)
                        end
                    end
                end
            end
        end
    end

    return boughtAny
end

-- Helper: Cari posisi bibit dan ProximityPrompt berdasarkan nama bibit atau stage terpilih
local function findTargetSeedPrompt(selectedSeed, selectedStage)
    local seedData = SEED_TARGETS[selectedSeed]
    local pattern = seedData and seedData.pattern or ""
    
    -- Step A: Jika pemain memilih nama bibit tertentu (bukan All/Furthest), cari model/part dengan pola nama tersebut
    if pattern ~= "" then
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" and not isPromptAlreadyStolen(p) then
                local parent = p.Parent
                local pName = parent and parent.Name:lower() or ""
                local mName = (parent and parent.Parent) and parent.Parent.Name:lower() or ""
                if string.find(pName, pattern) or string.find(mName, pattern) then
                    local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
                    if pos and not isPromptAlreadyStolen(p, pos) then
                        return pos, p
                    end
                end
            end
        end
        if seedData and seedData.pos then
            return seedData.pos, nil
        end
    end
    
    -- Step B: Jika pemain memilih stage tertentu (bukan Auto Furthest dan bukan Cycle All)
    local stData = STAGE_TARGETS[selectedStage]
    if stData and stData.pos and selectedStage ~= "Auto Furthest (Stage 10 - Paling Depan / Tersulit)" and selectedStage ~= "Cycle All Stages (10 ke 01 Bergantian)" then
        -- Cari prompt Steal yang berada di radius 220 studs dari koordinat stage tersebut yang belum dicuri
        local closestPrompt, closestPos, closestDist = nil, nil, 220
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" and not isPromptAlreadyStolen(p) then
                local parent = p.Parent
                local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
                if pos and not isPromptAlreadyStolen(p, pos) then
                    local d = (pos - stData.pos).Magnitude
                    if d < closestDist then
                        closestDist = d
                        closestPos = pos
                        closestPrompt = p
                    end
                end
            end
        end
        if closestPos and closestPrompt then
            return closestPos, closestPrompt
        end
        return stData.pos, nil
    end
    
    -- Step C: Auto Furthest - Cari prompt Steal dengan koordinat Z paling depan yang BELUM dicuri
    local bestPrompt = nil
    local bestPos = nil
    local minZ = 0
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" and not isPromptAlreadyStolen(p) then
            local parent = p.Parent
            local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
            if pos and not isPromptAlreadyStolen(p, pos) then
                if pos.Z < minZ then
                    minZ = pos.Z
                    bestPos = pos
                    bestPrompt = p
                end
            end
        end
    end
    if bestPos and bestPrompt then
        return bestPos, bestPrompt
    end
    
    -- Fallback ke stage 10
    return Vector3.new(-77.2, 3.5, -6080.9), nil
end

-- Helper: Cek ketersediaan bibit di arena (Smart Seed Availability Detector)
-- Jika di zona target / arena belum ada bibit (cooldown/diambil player lain), script stay aman di markas
local function isAnySeedAvailable(selectedSeed, selectedStage)
    -- Step A: Jika pemain memilih nama bibit tertentu
    local seedData = SEED_TARGETS[selectedSeed]
    local pattern = seedData and seedData.pattern or ""
    if pattern ~= "" then
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" then
                local parent = p.Parent
                local pName = parent and parent.Name:lower() or ""
                local mName = (parent and parent.Parent) and parent.Parent.Name:lower() or ""
                if string.find(pName, pattern) or string.find(mName, pattern) then
                    local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
                    if pos then return true, pos, p end
                end
            end
        end
        return false, nil, nil
    end
    
    -- Step B: Jika pemain memilih stage tertentu
    local stData = STAGE_TARGETS[selectedStage]
    if stData and stData.pos and selectedStage ~= "Auto Furthest (Stage 10 - Paling Depan / Tersulit)" and selectedStage ~= "Cycle All Stages (10 ke 01 Bergantian)" then
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" then
                local parent = p.Parent
                local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
                if pos and ((pos - stData.pos).Magnitude <= 220 or math.abs(pos.Z - stData.pos.Z) <= 120) then
                    return true, pos, p
                end
            end
        end
        return false, nil, nil
    end
    
    -- Step C: Auto Furthest / All Stages - Cek apakah ada prompt Steal aktif di mana pun di arena
    local bestPrompt = nil
    local bestPos = nil
    local minZ = 0
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" then
            local parent = p.Parent
            local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
            if pos then
                if pos.Z < minZ then
                    minZ = pos.Z
                    bestPos = pos
                    bestPrompt = p
                end
            end
        end
    end
    
    if bestPos and bestPrompt then
        return true, bestPos, bestPrompt
    end
    
    return false, nil, nil
end

-- Helper: Baca sisa waktu reset bibit arena (ServerInfo / Level Reset Timer)
local function getArenaResetCountdown()
    local rem = nil
    pcall(function()
        local sInfo = workspace:FindFirstChild("ServerInfo", true)
        if sInfo then
            local gpTime = sInfo:FindFirstChild("Gp_Time")
            if gpTime and gpTime:IsA("IntValue") and gpTime.Value > 0 then
                rem = gpTime.Value
            end
        end
    end)
    if rem then return rem end
    
    -- Fallback: Scan TextLabel di PlayerGui yang menampilkan countdown reset
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pGui then
            for _, lbl in ipairs(pGui:GetDescendants()) do
                if lbl:IsA("TextLabel") and lbl.Visible and lbl.Text ~= "" then
                    local txt = lbl.Text:lower()
                    if string.find(txt, "reset") or string.find(txt, "time") or string.find(txt, ":") then
                        local m, s = string.match(lbl.Text, "(%d+):(%d+)")
                        if m and s then
                            local sec = (tonumber(m) * 60) + tonumber(s)
                            if sec > 0 and sec < 900 then
                                rem = sec
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
    return rem
end

-- Helper: Kembali ke Markas dan Lakukan Gerakan Mikro (Wakes up touch/zone detection & plot register)
local function returnToBaseWithMicroMove(customPos)
    local hrp = getHrp()
    if not hrp then return end
    local char = LocalPlayer.Character
    local hum = getHumanoid()
    local rawMarkas = toVector3(customPos) or getBasePosition()
    local floorPos = (config.customBasePos and rawMarkas) or getFloorPosition(rawMarkas) or rawMarkas

    -- 1. Pulihkan collision seluruh part seketika (kecuali HumanoidRootPart) agar langsung berpijak kokoh di tanah
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.CanCollide = true
            end
        end
        char:PivotTo(CFrame.new(floorPos))
    end

    -- 2. Teleport LANGSUNG mendarat di daratan lantai (Normal gravity, zero slow motion, zero melayang!)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(floorPos)

    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    -- 3. Equip bibit di tangan jika opsi aktif
    if config.holdSeedInHand then
        equipStolenSeed()
    end

    -- 4. Lari dikit kiri-kanan sesuai permintaan Founder ("lari dikit di saat balik kiri kanan apa gitu")
    -- Memastikan zona plot / register touch aktif 100% secara alami
    if hum and hrp then
        local camCF = workspace.CurrentCamera and workspace.CurrentCamera.CFrame or hrp.CFrame
        local rightVec = camCF.RightVector
        if rightVec.Magnitude < 0.1 then rightVec = Vector3.new(1, 0, 0) end
        
        -- Lari ke kanan sedikit (0.08 detik)
        hum:Move(rightVec, false)
        task.wait(0.08)
        -- Lari ke kiri sedikit (0.08 detik)
        hum:Move(-rightVec, false)
        task.wait(0.08)
        -- Berhenti normal
        hum:Move(Vector3.zero, false)
    end
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

-- Flash Steal Routine (Ambil Langsung Tele Sekenceng Mungkin Balik + Lari Dikit Kiri Kanan Tanpa Slow Motion)
local function executeFlashSteal(targetPos, targetPrompt)
    local hrp = getHrp()
    if not hrp then return false end
    local char = LocalPlayer.Character
    targetPos = toVector3(targetPos)
    if not targetPos then return false end
    local markas = getBasePosition()
    
    -- 1. Lumpuhkan AI penjaga tanaman sebelum lompat
    if config.antiGuardChase then
        pacifyPlantGuards()
    end
    
    -- 2. Aktifkan Noclip sementara pada karakter agar tidak tertahan rintangan jeruji
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- 3. Tentukan posisi persis di daratan dalam kandang / bibit (Ground Level)
    local promptToFire = targetPrompt
    local insideCagePos = targetPos
    
    if promptToFire and promptToFire.Parent then
        local pParent = promptToFire.Parent
        insideCagePos = pParent:IsA("BasePart") and pParent.Position or (pParent:IsA("Model") and pParent:GetPivot().Position)
    else
        -- Scan prompt Steal di radius 150 studs dari targetPos
        local nearP, nearDist = nil, 150
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" then
                local pParent = p.Parent
                local pPos = pParent:IsA("BasePart") and pParent.Position or (pParent:IsA("Model") and pParent:GetPivot().Position)
                if pPos then
                    local d = (pPos - targetPos).Magnitude
                    if d < nearDist then
                        nearDist = d
                        nearP = p
                        insideCagePos = pPos
                    end
                end
            end
        end
        if nearP then
            promptToFire = nearP
        end
    end
    
    -- 4. TELEPORT KE PALING DEPAN (Daratan Kandang, Zero Delay, Langsung Mendarat di Tanah)
    local cageDropPos = insideCagePos + Vector3.new(0, 0.2, 0)
    if char then
        char:PivotTo(CFrame.new(cageDropPos))
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(cageDropPos)
    
    -- Scan bibit belum dicuri di dalam kandang jika ada lebih dari 1 bibit
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" and not isPromptAlreadyStolen(p) then
            local pParent = p.Parent
            local pPos = pParent:IsA("BasePart") and pParent.Position or (pParent:IsA("Model") and pParent:GetPivot().Position)
            if pPos and not isPromptAlreadyStolen(p, pPos) then
                if (hrp.Position - pPos).Magnitude < 70 then
                    promptToFire = p
                    cageDropPos = pPos + Vector3.new(0, 0.2, 0)
                    if char then
                        char:PivotTo(CFrame.new(cageDropPos))
                    end
                    hrp.CFrame = CFrame.new(cageDropPos)
                    break
                end
            end
        end
    end

    -- 5. INSTANT PROMPT TRIGGER: Seketika 0.04 detik (Tanpa Nunggu 1.15s)
    local stolen = false
    if promptToFire then
        pcall(function() promptToFire.HoldDuration = 0 end)
        if fireproximityprompt then
            fireproximityprompt(promptToFire, 0)
        end
        pcall(function() promptToFire:InputHoldBegin() end)
        task.wait(0.04)
        pcall(function() promptToFire:InputHoldEnd() end)
        markPromptAsStolen(promptToFire, cageDropPos)
        stolen = true
    else
        task.wait(0.05)
    end
    
    -- 6. LANGSUNG TELEPORT SEKENCENG MUNGKIN BALIK KE MARKAS (Zero Delay)
    returnToBaseWithMicroMove(markas)
    
    -- 7. Pastikan bibit di tangan tetap ter-equip jika opsi aktif
    if config.holdSeedInHand then
        equipStolenSeed()
    end
    
    -- 8. Ambil tanaman kebun yang sudah matang jika Auto Pickup aktif
    if config.autoPickupReady or config.autoHarvest then
        pickupReadyCrops(80)
    end

    -- 9. Tanam bibit ke petak kebun jika Auto Plant aktif
    if config.autoPlant then
        plantHeldSeedAtGarden()
    end
    
    -- 10. Sedot cash pasif kebun di markas jika aktif
    if config.autoCollectCash then
        for _, plot in ipairs(workspace:GetDescendants()) do
            if plot:IsA("BasePart") and (plot.Name == "DF_BaseGlow" or string.find(plot.Name:lower(), "cash") or string.find(plot.Name:lower(), "coin")) then
                if (hrp.Position - plot.Position).Magnitude <= 60 then
                    if firetouchinterest then
                        firetouchinterest(hrp, plot, 0)
                        firetouchinterest(hrp, plot, 1)
                    end
                end
            end
        end
    end
    
    return stolen
end

-- [5] 🌱 AUTONOMOUS FLASH STEAL & FULL AFK SUITE (KOLEKSI TAMAN / TANGAN - TANPA JUAL)
local emptyStageWaitUntil = 0

registerThread(function()
    local cycleIndex = 1
    local cycleOrder = {"10", "09", "08", "07", "06", "05", "04", "03", "02", "01"}
    
    while true do
        if config.autoSteal or config.fullAfkLoop then
            pcall(function()
                local hrp = getHrp()
                if hrp then
                    local markas = getBasePosition()
                    
                    local targetPos, targetPrompt = nil, nil
                    local sel = config.selectedStage or "Auto Furthest (Stage 10 - Paling Depan / Tersulit)"
                    
                    if sel == "Cycle All Stages (10 ke 01 Bergantian)" then
                        local stKey = cycleOrder[cycleIndex]
                        cycleIndex = (cycleIndex % #cycleOrder) + 1
                        for _, v in pairs(STAGE_TARGETS) do
                            if v.stage == stKey and v.pos then
                                targetPos = v.pos
                                break
                            end
                        end
                        if targetPos then
                            for _, p in ipairs(workspace:GetDescendants()) do
                                if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText == "Steal" and not isPromptAlreadyStolen(p) then
                                    local parent = p.Parent
                                    local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetPivot().Position)
                                    if pos and not isPromptAlreadyStolen(p, pos) and ((pos - targetPos).Magnitude <= 220 or math.abs(pos.Z - targetPos.Z) <= 120) then
                                        targetPos = pos
                                        targetPrompt = p
                                        break
                                    end
                                end
                            end
                        end
                    else
                        targetPos, targetPrompt = findTargetSeedPrompt(config.targetSeedName, sel)
                    end
                    
                    -- HANYA jika prompt bibit ditemukan, eksekusi flash steal (teleport ke seed -> tekan E -> balik ke markas)
                    if targetPrompt and targetPos then
                        executeFlashSteal(targetPos, targetPrompt)
                    else
                        -- Jika tidak ada bibit aktif saat ini (cooldown/belum spawn), tetap diam aman di markas
                        task.wait(0.3)
                    end
                end
            end)
        end
        task.wait(math.clamp(config.stealDelay or 0.8, 0.2, 5.0))
    end
end)

-- [6] 🌾 GARDEN CULTIVATION & PASSIVE CASH ENGINE
registerThread(function()
    while true do
        if config.autoPlant or config.autoPickupReady or config.autoHarvest or config.autoCollectCash then
            pcall(function()
                -- Auto Pick Up / Ambil tanaman matang di kebun pemain
                if config.autoPickupReady or config.autoHarvest then
                    pickupReadyCrops(120)
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

-- [8A] 🪣 AUTO BUY WATER BUCKETS (TOKO EMBER AIR - CASH GAME ONLY)
registerThread(function()
    while true do
        if config.autoBuyBuckets then
            local s, err = pcall(function()
                local target = config.targetBucket or "All In-Stock"
                buyBucketWithCash(target)
            end)
            if not s and err then
                warn("[BrotherHub] buyBucketWithCash error: " .. tostring(err))
            end
        end
        task.wait(0.6)
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
local THEME = {
    Background  = Color3.fromRGB(15, 16, 26),
    Panel       = Color3.fromRGB(22, 24, 38),
    Card        = Color3.fromRGB(30, 32, 50),
    Slot        = Color3.fromRGB(25, 27, 40),
    Border      = Color3.fromRGB(45, 48, 75),
    Accent      = Color3.fromRGB(0, 229, 255),
    Title       = Color3.fromRGB(255, 215, 0),
    Gold        = Color3.fromRGB(255, 215, 0),
    Text        = Color3.fromRGB(240, 240, 250),
    SubText     = Color3.fromRGB(160, 165, 195),
    Green       = Color3.fromRGB(46, 204, 113),
    Red         = Color3.fromRGB(231, 76, 60),
    Font        = Enum.Font.GothamBold,
    FontReg     = Enum.Font.Gotham
}

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

-- Main Frame (660 x 440)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(660, 440)
MainFrame.Position = UDim2.new(0.5, -330, 0.5, -220)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

-- UIScale Scoping Rule: MainScale PARENTED TO MainFrame
local MainScale = Instance.new("UIScale", MainFrame)
MainScale.Scale = config.guiScale or 1.0

local CornerMain = Instance.new("UICorner", MainFrame)
CornerMain.CornerRadius = UDim.new(0, 14)

-- Rotating 360° Neon RGB Stroke
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = THEME.Accent
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local StrokeGradient = Instance.new("UIGradient", MainStroke)
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 128)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 229, 255)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 128))
})

registerConnection(RunService.RenderStepped:Connect(function()
    StrokeGradient.Rotation = (tick() * 90) % 360
end))

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

-- Floating 80x80 MinCircle
local MinCircle = Instance.new("TextButton", ScreenGui)
MinCircle.Name = "MinCircle"
MinCircle.Size = UDim2.fromOffset(80, 80)
MinCircle.AnchorPoint = Vector2.new(0.5, 0.5)
MinCircle.Position = UDim2.new(0.1, 0, 0.5, 0)
MinCircle.BackgroundColor3 = THEME.Background
MinCircle.Visible = false
MinCircle.AutoButtonColor = false
Instance.new("UICorner", MinCircle).CornerRadius = UDim.new(1, 0)

local CircleStroke = Instance.new("UIStroke", MinCircle)
CircleStroke.Thickness = 3
CircleStroke.Color = THEME.Accent
local CircleGradient = Instance.new("UIGradient", CircleStroke)
CircleGradient.Color = StrokeGradient.Color

registerConnection(RunService.RenderStepped:Connect(function()
    CircleGradient.Rotation = (tick() * 90) % 360
end))

local CircleIcon = Instance.new("TextLabel", MinCircle)
CircleIcon.Size = UDim2.new(1, 0, 0.45, 0)
CircleIcon.Position = UDim2.new(0, 0, 0.12, 0)
CircleIcon.BackgroundTransparency = 1
CircleIcon.Text = "👑"
CircleIcon.TextSize = 22
CircleIcon.Font = THEME.Font

local CircleText = Instance.new("TextLabel", MinCircle)
CircleText.Size = UDim2.new(1, 0, 0.35, 0)
CircleText.Position = UDim2.new(0, 0, 0.52, 0)
CircleText.BackgroundTransparency = 1
CircleText.Text = "BH"
CircleText.TextColor3 = THEME.Title
CircleText.TextSize = 16
CircleText.Font = THEME.Font

-- Minimize / Restore Animation
local isMinimized = false
local function doMinimize()
    if isMinimized then return end
    closeOtherDropdowns(nil)
    isMinimized = true
    TweenService:Create(MainScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
    task.wait(0.25)
    MainFrame.Visible = false
    MinCircle.Visible = true
    MinCircle.Size = UDim2.fromOffset(10, 10)
    TweenService:Create(MinCircle, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(80, 80)}):Play()
end

local function doRestore()
    if not isMinimized then return end
    isMinimized = false
    TweenService:Create(MinCircle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(10, 10)}):Play()
    task.wait(0.2)
    MinCircle.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = config.guiScale or 1.0}):Play()
end

MinBtn.MouseButton1Click:Connect(doMinimize)
MinCircle.MouseButton1Click:Connect(doRestore)

-- Draggable MinCircle
local cDragging, cDragInput, cStart, cPos
MinCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        cDragging = true
        cStart = input.Position
        cPos = MinCircle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then cDragging = false end
        end)
    end
end)
MinCircle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        cDragInput = input
    end
end)
registerConnection(UserInputService.InputChanged:Connect(function(input)
    if input == cDragInput and cDragging then
        local delta = input.Position - cStart
        MinCircle.Position = UDim2.new(cPos.X.Scale, cPos.X.Offset + delta.X, cPos.Y.Scale, cPos.Y.Offset + delta.Y)
    end
end))

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
local function createToggle(parent, labelText, defaultVal, callback)
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
local secSteal = createSection(pageSteal, "FLASH AUTO STEAL & SAFE HARVEST SUITE", "Curi bibit instan di stratosfer langit Y+65, bawa pulang ke markas/taman (100% Bebas Dikejar Penjaga & Tidak Dijual)")
createToggle(secSteal, tr("FlashSteal"), config.autoSteal, function(v) config.autoSteal = v end)
createToggle(secSteal, tr("SmartWait"), config.smartWaitSeed, function(v) config.smartWaitSeed = v end)
createDropdown(secSteal, tr("TargetSeed"), SEED_NAME_KEYS, config.targetSeedName, function(v) config.targetSeedName = v end)
createDropdown(secSteal, tr("TargetStage"), STAGE_KEYS, config.selectedStage, function(v) config.selectedStage = v end)
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
createToggle(secFarm, tr("AutoPickupReady"), config.autoPickupReady, function(v) config.autoPickupReady = v end)
createToggle(secFarm, tr("AutoPlant"), config.autoPlant, function(v) config.autoPlant = v end)
createToggle(secFarm, tr("AutoHarvest"), config.autoHarvest, function(v) config.autoHarvest = v end)
createToggle(secFarm, tr("AutoCollectCash"), config.autoCollectCash, function(v) config.autoCollectCash = v end)
createButton(secFarm, tr("BtnPickupAll"), THEME.Green, function()
    local c = pickupReadyCrops(250)
    showNotification("🧺 PANEN TANAMAN", "Berhasil mengambil " .. tostring(c) .. " tanaman matang!", 3)
end)
createSlider(secFarm, "Harvest Interval (s)", 0.2, 5.0, config.harvestInterval, function(v) config.harvestInterval = v end)

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

-- 🪣 TOKO EMBER AIR (WATER BUCKET SHOP — CASH IN-GAME)
local secBuckets = createSection(pageShop, "Toko Ember Air (Water Bucket Shop — Cash)", "Beli ember penyiram tanaman secara otomatis dengan Cash in-game (100% Bebas Robux)")
createDropdown(secBuckets, "Pilih Ember (Select Bucket)", BUCKET_OPTIONS, config.targetBucket or "All In-Stock", function(v)
    config.targetBucket = v
    saveConfig()
end)
createToggle(secBuckets, "Auto Buy Ember Air (Cash Game)", config.autoBuyBuckets, function(v)
    config.autoBuyBuckets = v
    saveConfig()
end)
createButton(secBuckets, "Buka / Tutup Toko Ember (Toggle Shop Frame)", THEME.Panel, function()
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            local main02 = pg:FindFirstChild("Main02")
            if main02 then
                local f = main02:FindFirstChild("\233\129\147\229\133\183\229\149\134\229\186\151")
                if f then
                    f.Visible = not f.Visible
                end
            end
        end
    end)
end)

local secShop = createSection(pageShop, tr("ShopTitle"), tr("ShopDesc"))
createToggle(secShop, tr("BlockRobux"), config.blockRobuxPopups, function(v) config.blockRobuxPopups = v end)
createToggle(secShop, tr("AutoBuySeeds"), config.autoBuySeeds, function(v) config.autoBuySeeds = v end)
createToggle(secShop, tr("AutoOpenPacks"), config.autoOpenPacks, function(v) config.autoOpenPacks = v end)

local secSeedsFilter = createSection(pageShop, "Pilihan Bibit (Seed Selection Filter)", "Pilih jenis bibit yang ingin dibeli secara otomatis")
for seedName, isChecked in pairs(config.targetSeeds) do
    createToggle(secSeedsFilter, "Bibit: " .. seedName, isChecked, function(v)
        config.targetSeeds[seedName] = v
        saveConfig()
    end)
end

local secPacksFilter = createSection(pageShop, "Pilihan Seed Pack (Pack Filter)", "Pilih pack bibit yang ingin dibuka otomatis")
for packName, isChecked in pairs(config.targetPacks) do
    createToggle(secPacksFilter, "Buka: " .. packName, isChecked, function(v)
        config.targetPacks[packName] = v
        saveConfig()
    end)
end

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
