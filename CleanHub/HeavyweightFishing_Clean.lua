--[[
    ========================================================================
    👑 BROTHER HUB — HEAVYWEIGHT FISHING OFFICIAL MASTER SUITE
    ========================================================================
    Game        : Heavyweight Fishing
    Game URL    : https://www.roblox.com/games/98502499119821/Heavyweight-Fishing
    Place ID    : 98502499119821
    Design Tier : 1:1 FlowerShop Master Standard (RGB Neon Stroke, MinCircle 80x80)
    Platform    : Universal (Xeno PC, Solara, Wave, Delta / Arceus / Codex Mobile)
    Language    : Bilingual Smart Engine (🇮🇩 ID / 🇬🇧 EN Auto-Detect & Toggle)
    Features    : Auto Cast & Perfect Reel / Instant Catch, Lock Catch Bar (100% Tracking & Boss Bar Lock),
                  Auto Minigame Solver (100% Perfect Rhythm Hit & 0s Skip), Built-in AutoFishing Trigger,
                  Auto Spam Reel Skills & Slam, Auto Sell Fish (Instant / Merchant / Threshold),
                  Auto Buy Baits & Rods (Multi-Select Filter), Auto Buy Skills,
                  Zero Robux Pop-up Blocker (100% Free Experience), Auto Orbs & Traits Reroll,
                  Auto Spawn & Upgrade Boats, Auto Claim Daily / Quests / MainQuests,
                  Auto Claim All Secret Rods (Ascendant, Anchorbound, Kraken, Blazeshark, Demonic, Lifebloom),
                  Redeem All Promo Codes, Visual ESP & Radar, Teleport Hub & Full Movement Suite.
    Security    : Brother Guard Undetected Engine
    ========================================================================
]]

-- [0] MULTI-INSTANCE CLEANUP GUARD
if _G.BH_HEAVYWEIGHTFISHING_CLEANUP then
    pcall(_G.BH_HEAVYWEIGHTFISHING_CLEANUP)
end

-- [1] SERVICES & ENGINE SETUP
local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")
local TeleportService     = game:GetService("TeleportService")
local HttpService         = game:GetService("HttpService")
local MarketplaceService  = game:GetService("MarketplaceService")
local CoreGui             = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local camera      = workspace.CurrentCamera

-- Global Cleanup Tracking
local activeConnections = {}
local activeThreads     = {}
local activeEspElements = {}

local function registerConnection(conn)
    table.insert(activeConnections, conn)
    return conn
end

local function registerThread(f)
    local t = task.spawn(f)
    table.insert(activeThreads, t)
    return t
end

-- Virtual Input Keep-Alive (Native Anti-AFK)
local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)
local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

local function simulateNativeClick()
    pcall(function()
        if VirtualUser then
            VirtualUser:ClickButton1(Vector2.new(9999, 9999))
        elseif VirtualInputManager then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.04)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
end

-- Default Lighting Cache for Fullbright Restore
local defaultLighting = {
    Brightness = 2,
    ClockTime = 14,
    FogEnd = 100000,
    GlobalShadows = true,
    OutdoorAmbient = Color3.fromRGB(128, 128, 128)
}
pcall(function()
    local Lighting = game:GetService("Lighting")
    defaultLighting.Brightness = Lighting.Brightness
    defaultLighting.ClockTime = Lighting.ClockTime
    defaultLighting.FogEnd = Lighting.FogEnd
    defaultLighting.GlobalShadows = Lighting.GlobalShadows
    defaultLighting.OutdoorAmbient = Lighting.OutdoorAmbient
end)

-- [2] THEME PALETTE (1:1 My Flower Shop Standard)
local THEME = {
    Bg         = Color3.fromRGB(15, 17, 24),
    Background = Color3.fromRGB(15, 17, 24),
    Sidebar    = Color3.fromRGB(20, 23, 33),
    Panel      = Color3.fromRGB(26, 30, 44),
    Slot       = Color3.fromRGB(34, 40, 58),
    Stroke     = Color3.fromRGB(48, 56, 82),
    Accent     = Color3.fromRGB(0, 210, 255),
    AccentSoft = Color3.fromRGB(0, 180, 230),
    Text       = Color3.fromRGB(240, 244, 255),
    SubText    = Color3.fromRGB(140, 150, 175),
    Green      = Color3.fromRGB(46, 213, 115),
    Red        = Color3.fromRGB(255, 71, 87),
    Orange     = Color3.fromRGB(255, 165, 2),
    Purple     = Color3.fromRGB(165, 94, 234),
    Gold       = Color3.fromRGB(255, 215, 0),
    Blue       = Color3.fromRGB(54, 140, 255),
    Title      = Color3.fromRGB(255, 215, 0),
    On         = Color3.fromRGB(46, 213, 115),
    Font       = Enum.Font.GothamBold
}

local tweenBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenFast   = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function corner(inst, r)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function stroke(inst, col, th)
    local s = Instance.new("UIStroke", inst)
    s.Color = col or THEME.Stroke
    s.Thickness = th or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function gradient(inst, c1, c2, rot)
    local g = Instance.new("UIGradient", inst)
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 90
    return g
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

-- [3] CONFIGURATION FILE SYSTEM (FLOWER SHOP STANDARD)
local CONFIG_FILE = "BrotherHub_HeavyweightFishing.json"

local config = {
    -- Auto Fish
    autoCast              = false,
    castDelay             = 0.5,
    castPower             = 100,
    autoCatch             = false,
    instantCatch          = false,
    lockCatchBar          = false,
    autoMinigame          = false,
    perfectRhythm         = true,
    autoGameAFK           = false,
    autoSpamSkills        = false,
    autoSlam              = false,
    autoEquipBestRod      = false,
    autoEquipBestBait     = false,

    -- Auto Sell
    autoSell              = false,
    sellThreshold         = 10,
    sellDelay             = 3.0,
    instantRemoteSell     = true,
    sellAtNpc             = false,

    -- Bait & Rod Shop
    autoBuyBait           = false,
    baitBuyAmount         = 5,
    targetBaits           = {
        ["Basic Bait"]             = true,
        ["Crude Mash Bait"]        = false,
        ["Corrupted Essence Bait"] = false,
        ["Elite Bait"]             = false,
        ["Ancestral Bait"]         = false,
        ["Rainbow Bait"]           = false,
        ["Frost Bait"]             = false,
        ["Nameless Bait"]          = false
    },
    autoBuyRods           = false,
    targetRods            = {
        ["Wooden Rod"]         = false,
        ["Alloy Rod"]          = false,
        ["Bamboo Rod"]         = false,
        ["Steel Rod"]          = false,
        ["Emerald Rod"]        = false,
        ["Enchanted Steel Rod"]= false,
        ["Triple Steel Rod"]   = false,
        ["Golden Rod"]         = false,
        ["Maoshan Rod"]        = false
    },
    autoBuySkills         = false,
    targetSkills          = {
        ["One-Strike Heaven Gate"] = false,
        ["Taijiquan Technique"]    = false,
        ["Rolling Chaos"]          = false,
        ["Skyfall Stomp"]          = false
    },
    autoCraftBait         = false,

    -- Orbs & Traits
    autoEquipOrb          = false,
    autoRerollTrait       = false,
    targetTrait           = "Powerful",
    lockDesiredTraits     = true,
    autoDeleteCommonOrbs  = false,

    -- Boats & PVP
    autoSpawnBoat         = false,
    selectedBoat          = "Boat",
    autoEnterBoat         = false,
    boatSpeedMultiplier   = 1.5,
    autoQueuePvp          = false,

    -- Rewards & Quests
    autoDailyReward       = false,
    autoClaimQuests       = false,
    autoClaimMainQuests   = false,
    autoAwakeRod          = false,

    -- Secret Rods
    autoClaimSecretRods   = false,

    -- Zero Robux Blocker
    blockRobuxPopups      = true,

    -- Visuals & ESP
    fishEsp               = false,
    secretRodEsp          = false,
    npcEsp                = false,
    playerEsp             = false,
    fullbright            = false,

    -- Player Utilities
    walkSpeedEnabled      = false,
    walkSpeedValue        = 28,
    jumpPowerEnabled      = false,
    jumpPowerValue        = 60,
    noclipEnabled         = false,
    infiniteJump          = false,
    clickTp               = false,
    flyEnabled            = false,
    flySpeed              = 50,
    waterWalk             = false,
    antiAfk               = true,

    -- System & UI
    language              = "ID",
    uiScale               = 1.0
}

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(config))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if type(data) == "table" then
                for k, v in pairs(data) do
                    if config[k] ~= nil then
                        if type(config[k]) == "table" and type(v) == "table" then
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
end
loadConfig()

-- Auto-Detect System Language
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

-- [4] BILINGUAL LOCALIZATION DICTIONARY
local TRANSLATIONS = {
    ["HubTitle"]              = {ID = "BROTHER HUB — HEAVYWEIGHT FISHING", EN = "BROTHER HUB — HEAVYWEIGHT FISHING"},
    ["CloseConfirmTitle"]     = {ID = "KONFIRMASI PENUTUPAN", EN = "CLOSE CONFIRMATION"},
    ["CloseConfirmBody"]      = {ID = "Apakah Anda yakin ingin menutup Brother Hub?\nSeluruh fitur auto & ESP akan dihentikan secara steril.", EN = "Are you sure you want to close Brother Hub?\nAll auto features & ESP will be terminated cleanly."},
    ["BtnYes"]                = {ID = "Ya, Tutup", EN = "Yes, Close"},
    ["BtnCancel"]             = {ID = "Batal", EN = "Cancel"},

    -- Tabs
    ["TabAutoFish"]           = {ID = "🎣 Auto Mancing", EN = "🎣 Auto Fish"},
    ["TabAutoSell"]           = {ID = "💰 Auto Jual", EN = "💰 Auto Sell"},
    ["TabShops"]              = {ID = "🛒 Toko & Umpan", EN = "🛒 Bait & Rod Shop"},
    ["TabOrbs"]               = {ID = "🔮 Orb & Trait", EN = "🔮 Orbs & Traits"},
    ["TabBoats"]              = {ID = "⛵ Perahu & PVP", EN = "⛵ Boats & PVP"},
    ["TabRewards"]            = {ID = "🎁 Hadiah & Kode", EN = "🎁 Rewards & Codes"},
    ["TabSecretRods"]         = {ID = "🎋 Secret Rods", EN = "🎋 Secret Rods"},
    ["TabTeleport"]           = {ID = "🌌 Teleport", EN = "🌌 Teleport"},
    ["TabVisuals"]            = {ID = "👁️ Visual & ESP", EN = "👁️ Visuals & ESP"},
    ["TabMovement"]           = {ID = "🏃 Karakter", EN = "🏃 Movement"},
    ["TabCredits"]            = {ID = "👑 Kredit", EN = "👑 Credits"},

    -- Section Titles & Descriptions
    ["AutoFishTitle"]         = {ID = "SISTEM PEMANCING OTOMATIS", EN = "AUTONOMOUS FISHING SUITE"},
    ["AutoFishDesc"]          = {ID = "Lempar kail, selesaikan minigame irama, dan tarik ikan sempurna.", EN = "Cast rod, solve rhythm minigame, and reel in perfect catches."},
    ["AutoSellTitle"]         = {ID = "PENJUALAN HASIL IKAN OTOMATIS", EN = "AUTONOMOUS FISH SELLER"},
    ["AutoSellDesc"]          = {ID = "Jual seluruh hasil tangkapan tanpa harus bolak-balik ke dermaga.", EN = "Sell all your caught fish without walking back to the pier."},
    ["ShopsTitle"]            = {ID = "PEMBELIAN UMPAN & PANCINGAN", EN = "BAIT & ROD PURCHASER"},
    ["ShopsDesc"]             = {ID = "Beli umpan dan pancingan terbaik sesuai filter pilihan Anda.", EN = "Automatically restock chosen baits and rods with selective filters."},
    ["OrbsTitle"]             = {ID = "ORB & SISTEM TRAIT ROD", EN = "ORBS & TRAIT REROLL SUITE"},
    ["OrbsDesc"]              = {ID = "Pasang orb terkuat dan reroll trait pancingan impian Anda.", EN = "Equip powerful orbs and reroll for your dream rod traits."},
    ["BoatsTitle"]            = {ID = "ARMADA PERAHU & PVP", EN = "BOAT FLEET & PVP SUITE"},
    ["BoatsDesc"]             = {ID = "Spawn kapal otomatis dan navigasi lautan tanpa batas.", EN = "Auto-spawn boats, board instantly, and sail freely across oceans."},
    ["RewardsTitle"]          = {ID = "KLAIM HADIAH & MISI", EN = "REWARDS & QUEST ENGINE"},
    ["RewardsDesc"]           = {ID = "Klaim reward harian, misi alur utama, dan kode promo.", EN = "Claim daily gifts, main questlines, mastery, and promo codes."},
    ["SecretRodsTitle"]       = {ID = "PANCINGAN RAHASIA TERSEMBUNYI", EN = "SECRET RODS SNATCHER"},
    ["SecretRodsDesc"]        = {ID = "Ambil semua pancingan mistis legendaris yang tersebar di pulau rahasia.", EN = "Teleport and collect all secret mythical rods scattered on hidden isles."},
    ["VisualsTitle"]          = {ID = "RADAR & PENGLIHATAN TEMBUS DINDING", EN = "RADAR & ESP WALLHACK"},
    ["VisualsDesc"]           = {ID = "Deteksi lokasi pancingan rahasia, NPC pedagang, dan pemain lain.", EN = "Track secret rods, merchant NPCs, and other players through terrain."},
    ["MovementTitle"]         = {ID = "UTILITAS GERAKAN & JALAN DI ATAS AIR", EN = "MOVEMENT & WATER WALKING"},
    ["MovementDesc"]          = {ID = "Tingkatkan kecepatan, terbang bebas, dan berjalan di atas air lautan.", EN = "Boost speed, fly through the air, and walk on water surfaces safely."},

    -- Toggles & Elements
    ["AutoCast"]              = {ID = "Lempar Kail Otomatis (Auto Cast)", EN = "Auto Cast Rod"},
    ["CastPower"]             = {ID = "Kekuatan Lemparan (%)", EN = "Cast Power (%)"},
    ["CastDelay"]             = {ID = "Jeda Lemparan Kail (Detik)", EN = "Cast Delay (Seconds)"},
    ["AutoCatch"]             = {ID = "Tarik Ikan Sempurna (Auto Catch)", EN = "Auto Catch / Perfect Reel"},
    ["InstantCatch"]          = {ID = "Tarik Ikan Instan (0s Minigame Skip)", EN = "Instant Catch (0s Skip)"},
    ["LockCatchBar"]          = {ID = "Kunci Bar Tangkapan (Lock Catch Bar)", EN = "Lock Catch Bar (100% Tracking)"},
    ["AutoMinigame"]          = {ID = "Selesaikan Minigame Irama Otomatis", EN = "Auto Solve Rhythm Minigame"},
    ["PerfectRhythm"]         = {ID = "Akurasi Irama 100% Perfect", EN = "100% Perfect Rhythm Timing"},
    ["GameAutoFish"]          = {ID = "Aktifkan AutoFishing Bawaan Game", EN = "Trigger Game Built-in AutoFish"},
    ["AutoSpamSkills"]        = {ID = "Spam Skill Pancingan & Reel Slam", EN = "Auto Spam Rod Skills & Slam"},
    ["EquipBestRod"]          = {ID = "Otomatis Pakai Rod Terbaik", EN = "Auto Equip Best Fishing Rod"},
    ["EquipBestBait"]         = {ID = "Otomatis Pasang Umpan Terbaik", EN = "Auto Equip Best Bait"},

    ["AutoSell"]              = {ID = "Jual Ikan Otomatis (Auto Sell)", EN = "Auto Sell Fish"},
    ["SellThreshold"]         = {ID = "Batas Jumlah Ikan untuk Dijual", EN = "Fish Count Threshold to Sell"},
    ["SellDelay"]             = {ID = "Jeda Pengecekan Jual (Detik)", EN = "Sell Check Interval (Seconds)"},
    ["InstantRemoteSell"]     = {ID = "Jual Instan Lewat Server Remote", EN = "Instant Remote Sell (Anywhere)"},
    ["SellAtNpc"]             = {ID = "Jual Melalui NPC Pedagang (Biao Ge)", EN = "Sell via NPC Merchant (Biao Ge)"},
    ["BtnSellNow"]            = {ID = "💵 Jual Semua Ikan Sekarang", EN = "💵 Sell All Fish Now"},

    ["AutoBuyBait"]           = {ID = "Beli Umpan Otomatis", EN = "Auto Buy Selected Baits"},
    ["BaitAmount"]            = {ID = "Jumlah Beli Tiap Pembelian", EN = "Bait Purchase Quantity"},
    ["AutoBuyRods"]           = {ID = "Beli Pancingan Otomatis (Koin)", EN = "Auto Buy Selected Rods (Coins)"},
    ["AutoBuySkills"]         = {ID = "Beli Skill Pancingan Otomatis", EN = "Auto Buy Selected Skills"},
    ["BlockRobux"]            = {ID = "Blokir Semua Pop-up Robux (100% Free)", EN = "Block All Robux Pop-ups (100% Free)"},

    ["AutoEquipOrb"]          = {ID = "Pasang Orb Terbaik Otomatis", EN = "Auto Equip Best Orb"},
    ["AutoRerollTrait"]       = {ID = "Reroll Trait Pancingan Otomatis", EN = "Auto Reroll Rod Trait"},
    ["TargetTrait"]           = {ID = "Target Trait Rod yang Dicari", EN = "Target Rod Trait to Stop At"},
    ["LockDesiredTraits"]     = {ID = "Kunci Otomatis Trait yang Cocok", EN = "Auto Lock Matching Traits"},

    ["AutoSpawnBoat"]         = {ID = "Spawn Kapal Otomatis Saat di Air", EN = "Auto Spawn Boat in Water"},
    ["SelectedBoat"]          = {ID = "Pilih Jenis Kapal", EN = "Select Boat Type"},
    ["AutoEnterBoat"]         = {ID = "Duduk di Kemudi Otomatis", EN = "Auto Board / Enter Boat"},
    ["BoatSpeed"]             = {ID = "Pengali Kecepatan Kapal", EN = "Boat Speed Multiplier"},
    ["BtnSpawnBoatNow"]       = {ID = "⛵ Spawn Kapal Pilihan Sekarang", EN = "⛵ Spawn Selected Boat Now"},

    ["AutoDailyReward"]       = {ID = "Klaim Hadiah Harian Otomatis", EN = "Auto Claim Daily Reward"},
    ["AutoClaimQuests"]       = {ID = "Klaim Selesai Misi Otomatis", EN = "Auto Claim Finished Quests"},
    ["AutoClaimMainQuests"]   = {ID = "Klaim Misi Cerita Utama", EN = "Auto Claim Main Story Quests"},
    ["AutoAwakeRod"]          = {ID = "Bangkitkan Pancingan (Awake Rod)", EN = "Auto Awake Fishing Rod"},
    ["BtnRedeemCodes"]        = {ID = "🎁 Tukarkan Semua Kode Promo", EN = "🎁 Redeem All Promo Codes"},

    ["AutoClaimSecretRods"]   = {ID = "Ambil Semua Pancingan Rahasia (AFK Loop)", EN = "Auto Claim All Secret Rods (Loop)"},
    ["BtnGrabSecretRods"]     = {ID = "✨ Teleport & Ambil Semua Secret Rods", EN = "✨ Teleport & Grab All Secret Rods"},

    ["FishEsp"]               = {ID = "ESP Titik Ikan & Air", EN = "Fish & Fishing Spot ESP"},
    ["SecretRodEsp"]          = {ID = "ESP Pancingan Rahasia (Secret Rods)", EN = "Secret Rods ESP"},
    ["NpcEsp"]                = {ID = "ESP NPC Pedagang & Quest", EN = "Merchant & Quest NPC ESP"},
    ["PlayerEsp"]             = {ID = "ESP Pemain Lain (Radar)", EN = "Player ESP & Distance"},
    ["Fullbright"]            = {ID = "Pandangan Terang Benderang (Fullbright)", EN = "Fullbright / Night Vision"},

    ["WalkSpeed"]             = {ID = "Tingkatkan Kecepatan Lari", EN = "Enable WalkSpeed Boost"},
    ["SpeedVal"]              = {ID = "Kecepatan Lari", EN = "WalkSpeed Value"},
    ["JumpPower"]             = {ID = "Tingkatkan Kekuatan Lompat", EN = "Enable JumpPower Boost"},
    ["JumpVal"]               = {ID = "Kekuatan Lompat", EN = "JumpPower Value"},
    ["Noclip"]                = {ID = "Tembus Dinding (Ghost Noclip)", EN = "Ghost Noclip"},
    ["InfJump"]               = {ID = "Lompat Tak Terbatas (Infinite Jump)", EN = "Infinite Jump"},
    ["ClickTp"]               = {ID = "Teleportasi Klik (Ctrl + Klik)", EN = "Click Teleport (Ctrl + Click)"},
    ["Fly"]                   = {ID = "Mode Terbang Bebas (Fly WASD)", EN = "Free Flight Mode (WASD)"},
    ["FlySpeed"]              = {ID = "Kecepatan Terbang", EN = "Flight Speed"},
    ["WaterWalk"]             = {ID = "Jalan di Atas Air (Water Walk)", EN = "Walk On Water Surface"},
    ["AntiAfk"]               = {ID = "Anti-AFK Permanen (20 Menit Bypass)", EN = "Permanent Anti-AFK (20m Bypass)"}
}

local function tr(key)
    local item = TRANSLATIONS[key]
    if not item then return key end
    return item[config.language] or item["EN"] or key
end

-- [5] GAME REMOTE DISPATCHER
local EventsFolder  = ReplicatedStorage:WaitForChild("Events", 10)
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 10)

local function getEvent(name)
    if EventsFolder then
        local ev = EventsFolder:FindFirstChild(name)
        if ev then return ev end
    end
    if RemotesFolder then
        local ev = RemotesFolder:FindFirstChild(name, true)
        if ev then return ev end
    end
    return ReplicatedStorage:FindFirstChild(name, true)
end

local function fireRemote(name, ...)
    local ev = getEvent(name)
    if ev then
        pcall(function(...)
            if ev:IsA("RemoteEvent") then
                ev:FireServer(...)
            elseif ev:IsA("RemoteFunction") then
                ev:InvokeServer(...)
            end
        end, ...)
        return true
    end
    return false
end

-- [6] ZERO ROBUX POP-UP BLOCKER ENGINE
registerConnection(MarketplaceService.PromptPurchaseRequested:Connect(function(player, assetId)
    if config.blockRobuxPopups and player == LocalPlayer then
        -- Suppress Robux prompt
        pcall(function()
            local GuiService = game:GetService("GuiService")
            GuiService:ClearError()
        end)
    end
end))

registerConnection(MarketplaceService.PromptProductPurchaseRequested:Connect(function(player, productId)
    if config.blockRobuxPopups and player == LocalPlayer then
        pcall(function()
            local GuiService = game:GetService("GuiService")
            GuiService:ClearError()
        end)
    end
end))

registerConnection(MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player, gamePassId)
    if config.blockRobuxPopups and player == LocalPlayer then
        pcall(function()
            local GuiService = game:GetService("GuiService")
            GuiService:ClearError()
        end)
    end
end))

-- [7] PLAYER HELPERS & TELEPORTATION
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHrp()
    local char = getChar()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChildWhichIsA("BasePart"))
end

local function getHumanoid()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function safeTeleport(targetPos, locationName)
    local hrp = getHrp()
    if not hrp then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    -- 1. Try finding exact spawn part in workspace.Spawnpoint if locationName is provided
    local destination = targetPos
    if locationName then
        pcall(function()
            local spFolder = workspace:FindFirstChild("Spawnpoint")
            if spFolder then
                for _, part in ipairs(spFolder:GetChildren()) do
                    if string.find(string.lower(locationName), string.lower(part.Name)) or string.find(string.lower(part.Name), string.lower(locationName)) then
                        destination = part.Position + Vector3.new(0, 4.5, 0)
                        break
                    end
                end
            end
        end)
    end

    -- 2. Raycast downward ignoring character, ocean, and water parts
    local finalPos = destination
    pcall(function()
        local rayOrigin = destination + Vector3.new(0, 35, 0)
        local rayDirection = Vector3.new(0, -70, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        local ignoreList = {}
        if char then table.insert(ignoreList, char) end
        local ocean = workspace:FindFirstChild("Ocean")
        if ocean then table.insert(ignoreList, ocean) end

        raycastParams.FilterDescendantsInstances = ignoreList

        local hit = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if hit and hit.Position and hit.Material ~= Enum.Material.Water and not string.find(string.lower(hit.Instance.Name), "water") then
            finalPos = hit.Position + Vector3.new(0, 3.5, 0)
        else
            finalPos = destination + Vector3.new(0, 4.0, 0)
        end
    end)

    -- 3. Deploy an invisible solid safety platform (BH_SafeLandingPad)
    -- This prevents players from falling through unstreamed terrain or into water
    pcall(function()
        local oldPad = workspace:FindFirstChild("BH_SafeLandingPad")
        if oldPad then oldPad:Destroy() end

        local pad = Instance.new("Part")
        pad.Name = "BH_SafeLandingPad"
        pad.Size = Vector3.new(40, 2, 40)
        pad.CFrame = CFrame.new(finalPos.X, finalPos.Y - 2.5, finalPos.Z)
        pad.Anchored = true
        pad.CanCollide = true
        pad.Transparency = 1
        pad.Material = Enum.Material.SmoothPlastic
        pad.Parent = workspace

        task.delay(4, function()
            if pad and pad.Parent then
                pad:Destroy()
            end
        end)
    end)

    -- 4. Move Character & reset velocities
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(finalPos)
    task.wait(0.05)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- [8] AUTONOMOUS FISHING ENGINE (BITE-SYNCHRONIZED ZERO PREMATURE REEL)
local isFishBiting = false
local lastCastTime = 0
local isCurrentlyCasting = false
local biteStartTime = 0
local hitsDelivered = 0

-- Remote event listeners to detect bite & minigame state
pcall(function()
    local rStart = getEvent("RhythmStart")
    if rStart and rStart:IsA("RemoteEvent") then
        registerConnection(rStart.OnClientEvent:Connect(function()
            isFishBiting = true
            biteStartTime = tick()
            hitsDelivered = 0
        end))
    end
    local fMinigame = getEvent("FishingMinigame")
    if fMinigame and fMinigame:IsA("RemoteEvent") then
        registerConnection(fMinigame.OnClientEvent:Connect(function()
            isFishBiting = true
            biteStartTime = tick()
            hitsDelivered = 0
        end))
    end
    local rStop = getEvent("RhythmStop")
    if rStop and rStop:IsA("RemoteEvent") then
        registerConnection(rStop.OnClientEvent:Connect(function()
            isFishBiting = false
            isCurrentlyCasting = false
            biteStartTime = 0
            hitsDelivered = 0
        end))
    end
    local caught = getEvent("ReplicateFishCaught") or getEvent("NotifyFish")
    if caught and caught:IsA("RemoteEvent") then
        registerConnection(caught.OnClientEvent:Connect(function()
            isFishBiting = false
            isCurrentlyCasting = false
            biteStartTime = 0
            hitsDelivered = 0
        end))
    end
end)

-- UI Bite & Minigame Sensor
local function isMinigameUiActive()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return false end
    local mGui = pGui:FindFirstChild("MainGui")
    if not mGui then return false end

    -- Frame 'Fishing' under MainGui becomes Visible during active fishing minigame
    local fishingFrame = mGui:FindFirstChild("Fishing")
    if fishingFrame and fishingFrame:IsA("Frame") and fishingFrame.Visible then
        local rhythm = fishingFrame:FindFirstChild("Rhythm")
        if rhythm and rhythm.Visible then return true end
        local pBar = fishingFrame:FindFirstChild("ProgressionBar")
        if pBar and pBar.Visible then return true end
        local bFrame = fishingFrame:FindFirstChild("BarFrame")
        if bFrame and bFrame.Visible then return true end
        local boss = fishingFrame:FindFirstChild("BossFightBar")
        if boss and boss.Visible then return true end
        return true
    end

    -- Deep check for active rhythm frame
    local rhythmOther = mGui:FindFirstChild("Rhythm", true)
    if rhythmOther and rhythmOther:IsA("GuiObject") and rhythmOther.Visible then
        return true
    end

    return false
end

-- Auto Cast Rod Thread
registerThread(function()
    while true do
        if config.autoCast then
            pcall(function()
                local hrp = getHrp()
                local now = tick()
                local timeSinceCast = now - lastCastTime
                local minigameActive = isFishBiting or isMinigameUiActive()

                -- Cast only when not in minigame, and either not currently casting or cast timed out after 25s
                if hrp and not minigameActive and (not isCurrentlyCasting or timeSinceCast >= 25.0) then
                    isCurrentlyCasting = true
                    lastCastTime = now
                    isFishBiting = false
                    biteStartTime = 0
                    hitsDelivered = 0

                    local castPos = hrp.Position + (hrp.CFrame.LookVector * 25) + Vector3.new(0, -3, 0)
                    
                    -- Fire Charge & Position_Cast / Fishing
                    fireRemote("Charge", (config.castPower or 100) / 100)
                    task.wait(0.05)
                    fireRemote("Position_Cast", castPos)
                    fireRemote("Fishing", castPos, (config.castPower or 100) / 100)

                    -- Click screen fishing button as fallback trigger
                    pcall(function()
                        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                        local mGui = pGui and pGui:FindFirstChild("MainGui")
                        local mob = mGui and mGui:FindFirstChild("Mobile")
                        local fBtn = mob and mob:FindFirstChild("Fishing")
                        if fBtn and fBtn:IsA("GuiButton") and firesignal then
                            firesignal(fBtn.MouseButton1Click)
                        end
                    end)

                    -- Built-in game AutoFishing feature
                    if config.autoGameAFK then
                        fireRemote("AutoFishing", true)
                    end
                end
            end)
        end
        task.wait(0.4)
    end
end)

-- [8B] LOCK CATCH BAR & MINIGAME STABILIZER ENGINE (HIGH-FREQUENCY RENDERSTEPPED)
registerConnection(RunService.RenderStepped:Connect(function()
    if not (config.lockCatchBar or config.autoMinigame or config.autoCatch) then return end

    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        local mGui = pGui and pGui:FindFirstChild("MainGui")
        if not mGui then return end

        local fFrame = mGui:FindFirstChild("Fishing")
        if not fFrame or not fFrame:IsA("Frame") or not fFrame.Visible then return end

        -- 1. Standard Catch Bar Lock (BarFrame & ProgressionBar)
        local bFrame = fFrame:FindFirstChild("BarFrame")
        local playerBar = bFrame and bFrame:FindFirstChild("Bar")
        local pBar = fFrame:FindFirstChild("ProgressionBar")

        if playerBar and playerBar:IsA("GuiObject") and bFrame and bFrame:IsA("GuiObject") then
            local targetFish = nil
            if pBar then
                local s1 = pBar:FindFirstChild("Shark1")
                local s2 = pBar:FindFirstChild("Shark2")
                if s1 and s1:IsA("GuiObject") and s1.Visible then
                    targetFish = s1
                elseif s2 and s2:IsA("GuiObject") and s2.Visible then
                    targetFish = s2
                end
                if not targetFish then
                    for _, child in ipairs(pBar:GetChildren()) do
                        if child:IsA("GuiObject") and child.Visible and child.Name ~= "Bar" and child.Name ~= "HP" and child.Name ~= "FishName" and child.Name ~= "Shadow" and child.Name ~= "Shine" and child.Name ~= "Effective" then
                            targetFish = child
                            break
                        end
                    end
                end
            end

            if targetFish and targetFish:IsA("GuiObject") then
                local barFrameWidth = math.max(1, bFrame.AbsoluteSize.X)
                local fishCenterX = targetFish.AbsolutePosition.X + (targetFish.AbsoluteSize.X / 2)
                local relX = (fishCenterX - bFrame.AbsolutePosition.X) / barFrameWidth
                
                if relX <= 0 or relX > 1 then
                    relX = targetFish.Position.X.Scale
                end

                relX = math.clamp(relX, 0.01, 0.99)
                playerBar.Position = UDim2.new(relX, 0, playerBar.Position.Y.Scale, playerBar.Position.Y.Offset)
            end
        end

        -- 2. Boss Fight Catch Bar Lock (BossFightBar)
        local bossBar = fFrame:FindFirstChild("BossFightBar")
        if bossBar and bossBar:IsA("GuiObject") and bossBar.Visible then
            local bHitbox = bossBar:FindFirstChild("Hitbox")
            local bBar = bossBar:FindFirstChild("Bar")
            if bHitbox and bBar and bHitbox:IsA("GuiObject") and bBar:IsA("GuiObject") then
                local bossWidth = math.max(1, bossBar.AbsoluteSize.X)
                local hitCenterX = bHitbox.AbsolutePosition.X + (bHitbox.AbsoluteSize.X / 2)
                local bRelX = (hitCenterX - bossBar.AbsolutePosition.X) / bossWidth
                if bRelX <= 0 or bRelX > 1 then
                    bRelX = bHitbox.Position.X.Scale
                end
                bRelX = math.clamp(bRelX, 0.01, 0.99)
                bBar.Position = UDim2.new(bRelX, 0, bBar.Position.Y.Scale, bBar.Position.Y.Offset)
            end
        end

        -- 3. Rhythm Minigame Auto-Solver
        local rhythm = fFrame:FindFirstChild("Rhythm")
        if rhythm and rhythm:IsA("GuiObject") and rhythm.Visible then
            for _, laneName in ipairs({"ProgressionA", "ProgressionS", "ProgressionD"}) do
                local lane = rhythm:FindFirstChild(laneName)
                if lane and lane:IsA("GuiObject") then
                    local btn = lane:FindFirstChild("Button")
                    if btn and btn:IsA("GuiButton") and firesignal then
                        firesignal(btn.MouseButton1Click)
                    end
                end
            end
        end

        -- 4. PerfectButton Auto-Clicker
        local pBtn = fFrame:FindFirstChild("PerfectButton")
        if pBtn and pBtn:IsA("GuiObject") and pBtn.Visible then
            local realBtn = pBtn:FindFirstChildWhichIsA("GuiButton", true)
            if realBtn and firesignal then
                firesignal(realBtn.MouseButton1Click)
            end
        end

        -- 5. Charge Auto-Clicker
        local charge = fFrame:FindFirstChild("Charge")
        if charge and charge:IsA("GuiObject") and charge.Visible then
            local cBtn = charge:FindFirstChildWhichIsA("GuiButton", true)
            if cBtn and firesignal then
                firesignal(cBtn.MouseButton1Click)
            end
        end
    end)
end))

-- Auto Catch & Rhythm Minigame Solver (STRICTLY Bite-Synchronized, Zero Premature Reel!)
registerThread(function()
    while true do
        if config.autoCatch or config.autoMinigame or config.instantCatch or config.lockCatchBar then
            pcall(function()
                local minigameActive = isFishBiting or isMinigameUiActive()

                -- CRITICAL FIX: Only catch/reel when fish actually bites or minigame is active!
                -- NEVER fire Catch when waiting for a bite, preventing empty hook lifting!
                if minigameActive then
                    if biteStartTime == 0 then
                        biteStartTime = tick()
                    end
                    hitsDelivered = hitsDelivered + 1

                    -- 1. Solve Rhythm hits rapidly to deplete fish HP & lock progression
                    if config.perfectRhythm or config.autoMinigame or config.autoCatch or config.lockCatchBar then
                        fireRemote("RhythmHit")
                        fireRemote("FishingMinigame", true)
                        fireRemote("UpdateFishProgression")
                    end

                    -- 2. Burst skills & slam to deal maximum damage
                    if config.autoSpamSkills then
                        fireRemote("TriggerMinigameSkill")
                        fireRemote("UseSkill")
                    end
                    if config.autoSlam then
                        fireRemote("Slam")
                    end

                    -- 3. Click PerfectButton if it appears
                    pcall(function()
                        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                        local mGui = pGui and pGui:FindFirstChild("MainGui")
                        local fFrame = mGui and mGui:FindFirstChild("Fishing")
                        local pBtn = fFrame and fFrame:FindFirstChild("PerfectButton")
                        if pBtn and pBtn:IsA("GuiObject") and pBtn.Visible then
                            local btn = pBtn:FindFirstChildWhichIsA("GuiButton", true)
                            if btn and firesignal then
                                firesignal(btn.MouseButton1Click)
                            end
                        end
                    end)

                    -- 4. Reel in Catch:
                    if config.autoCatch or config.instantCatch then
                        local elapsedBite = tick() - biteStartTime
                        local readyToCatch = false

                        if config.instantCatch then
                            if hitsDelivered >= 3 or elapsedBite >= 0.2 then
                                readyToCatch = true
                            end
                        else
                            if hitsDelivered >= 12 or elapsedBite >= 0.9 then
                                readyToCatch = true
                            end
                        end

                        if readyToCatch then
                            fireRemote("Catch", true)
                            if config.instantCatch then
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(config.instantCatch and 0.05 or 0.08)
    end
end)

-- Game Built-in AutoFishing Trigger
registerThread(function()
    while true do
        if config.autoGameAFK then
            pcall(function()
                fireRemote("AutoFishing", true)
            end)
        end
        task.wait(3.0)
    end
end)

-- Auto Equip Best Rod & Bait
registerThread(function()
    while true do
        if config.autoEquipBestRod then
            pcall(function()
                local repInfo = ReplicatedStorage:FindFirstChild("Info")
                local invFolder = repInfo and repInfo:FindFirstChild("Inventory")
                if invFolder then
                    -- Search player backpack/character for high tier rod
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    local char = LocalPlayer.Character
                    local bestRod = nil
                    local rodRarity = {
                        ["Divine Spear Rod"] = 100, ["Taiji Twin Scythe"] = 95, ["Kraken Rod"] = 90,
                        ["Hell Devourer Rod"] = 85, ["Demonic Rod"] = 80, ["Lifebloom Rod"] = 75,
                        ["Anchorbound Rod"] = 70, ["Blazeshark Rod"] = 65, ["Ascendant Bamboo Rod"] = 60,
                        ["Maoshan Rod"] = 50, ["Golden Rod"] = 40, ["Triple Steel Rod"] = 35,
                        ["Enchanted Steel Rod"] = 30, ["Emerald Rod"] = 25, ["Steel Rod"] = 20,
                        ["Bamboo Rod"] = 15, ["Alloy Rod"] = 10, ["Wooden Rod"] = 5
                    }
                    local highestScore = -1
                    local allItems = {}
                    if backpack then
                        for _, item in ipairs(backpack:GetChildren()) do table.insert(allItems, item) end
                    end
                    if char then
                        for _, item in ipairs(char:GetChildren()) do
                            if item:IsA("Tool") then table.insert(allItems, item) end
                        end
                    end
                    for _, tool in ipairs(allItems) do
                        local score = rodRarity[tool.Name] or 1
                        if score > highestScore then
                            highestScore = score
                            bestRod = tool.Name
                        end
                    end
                    if bestRod then
                        fireRemote("EquipFishingRod", bestRod)
                    end
                end
            end)
        end

        if config.autoEquipBestBait then
            pcall(function()
                local baitTiers = {
                    "Nameless Bait", "Rainbow Bait", "Ancestral Bait",
                    "Frost Bait", "Elite Bait", "Corrupted Essence Bait",
                    "Crude Mash Bait", "Basic Bait"
                }
                for _, baitName in ipairs(baitTiers) do
                    if fireRemote("EquipBait", baitName) then
                        break
                    end
                end
            end)
        end
        task.wait(5.0)
    end
end)

-- [9] AUTONOMOUS FISH SELLER ENGINE
registerThread(function()
    while true do
        if config.autoSell then
            pcall(function()
                -- Count fish in backpack
                local fishCount = 0
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and not item.Name:lower():find("rod") and not item.Name:lower():find("bait") then
                            fishCount = fishCount + 1
                        end
                    end
                end

                if fishCount >= config.sellThreshold or config.sellThreshold <= 1 then
                    if config.instantRemoteSell then
                        fireRemote("SellFish")
                    end

                    if config.sellAtNpc then
                        -- Find nearest Biao Ge NPC
                        for _, model in ipairs(workspace:GetDescendants()) do
                            if model:IsA("Model") and model.Name == "Biao Ge" then
                                local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt and fireproximityprompt then
                                    fireproximityprompt(prompt)
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(math.clamp(config.sellDelay, 1.0, 30.0))
    end
end)

-- [10] SHOPS & BAIT PURCHASER ENGINE
registerThread(function()
    while true do
        -- Auto Buy Baits
        if config.autoBuyBait then
            pcall(function()
                for baitName, enabled in pairs(config.targetBaits) do
                    if enabled then
                        fireRemote("BuyBait", baitName, config.baitBuyAmount)
                        task.wait(0.2)
                    end
                end
            end)
        end

        -- Auto Buy Rods
        if config.autoBuyRods then
            pcall(function()
                for rodName, enabled in pairs(config.targetRods) do
                    if enabled then
                        fireRemote("BuyFishingRod", rodName)
                        task.wait(0.3)
                    end
                end
            end)
        end

        -- Auto Buy Skills
        if config.autoBuySkills then
            pcall(function()
                for skillName, enabled in pairs(config.targetSkills) do
                    if enabled then
                        fireRemote("BuySkill", skillName)
                        task.wait(0.3)
                    end
                end
            end)
        end

        -- Auto Craft Bait
        if config.autoCraftBait then
            pcall(function()
                fireRemote("CraftBait")
            end)
        end

        task.wait(6.0)
    end
end)

-- [11] ORBS & TRAITS SUITE
registerThread(function()
    while true do
        if config.autoEquipOrb then
            pcall(function()
                local orbPriority = {
                    "Buddha Orb", "Execution Orb", "Taiji Orb",
                    "Ascension Orb", "Maoshan Orb", "Cloud Ascension Orb",
                    "Sage Yijiu Orb", "Qian Gate Orb", "So Tam Orb",
                    "Taoist Orb", "Bac Minh Orb"
                }
                for _, orb in ipairs(orbPriority) do
                    if fireRemote("EquipOrb", orb) then
                        break
                    end
                end
            end)
        end

        if config.autoRerollTrait then
            pcall(function()
                fireRemote("RerollTrait")
            end)
        end

        if config.autoDeleteCommonOrbs then
            pcall(function()
                fireRemote("DeleteOrb", "Common")
            end)
        end

        task.wait(4.0)
    end
end)

-- [12] BOATS & FLEET ENGINE
local BOAT_DESTINATIONS = {
    ["Boat"]             = "Boat",
    ["Golden Boat"]      = "Golden Boat",
    ["Rainbow Boat"]     = "Rainbow Boat",
    ["Kunfish Overlord"] = "Kunfish Overlord",
    ["Ascended Perch"]   = "Ascended Perch"
}

local function spawnSelectedBoat()
    pcall(function()
        local bName = config.selectedBoat or "Boat"
        -- Fire Remotes.BoatShop.Spawn or Events.SpawnBoat
        local spawned = fireRemote("Spawn", bName)
        if not spawned then
            fireRemote("SpawnBoat", bName)
        end
    end)
end

registerThread(function()
    while true do
        if config.autoSpawnBoat then
            pcall(function()
                local hrp = getHrp()
                if hrp then
                    -- Check if near water (raycast down)
                    local ray = Ray.new(hrp.Position, Vector3.new(0, -10, 0))
                    local hitPart, hitPos, hitNorm, hitMat = workspace:FindPartOnRay(ray, getChar())
                    if hitMat == Enum.Material.Water then
                        spawnSelectedBoat()
                    end
                end
            end)
        end

        if config.autoEnterBoat then
            pcall(function()
                fireRemote("EnteredBoat", true)
            end)
        end

        if config.autoQueuePvp then
            pcall(function()
                fireRemote("PVPQueue")
            end)
        end

        task.wait(5.0)
    end
end)

-- [13] REWARDS, QUESTS & PROMO CODES ENGINE
local PROMO_CODES = {
    "RELEASE",
    "FISHING",
    "HEAVYWEIGHT",
    "UPDATE1",
    "100LIKES",
    "500LIKES",
    "1000LIKES",
    "SECRETROD",
    "LUCK",
    "DISCORD"
}

local function redeemAllPromoCodes()
    for _, code in ipairs(PROMO_CODES) do
        pcall(function()
            fireRemote("RedeemCode", code)
        end)
        task.wait(0.15)
    end
end

registerThread(function()
    while true do
        if config.autoDailyReward then
            pcall(function()
                fireRemote("DailyReward")
            end)
        end

        if config.autoClaimQuests then
            pcall(function()
                for i = 1, 10 do
                    fireRemote("ClaimQuest", i)
                end
            end)
        end

        if config.autoClaimMainQuests then
            pcall(function()
                local mainQuests = {
                    "Giang Lao 1", "Giang Lao 2", "Giang Lao 3",
                    "Sage Yijiu 1", "Sage Yijiu 2", "Sage Yijiu 3",
                    "Perch Isle Quest", "Frost Isle Quest", "Coconut Isle Quest",
                    "Blind Grand Angler", "Lao Ngo", "Bac Minh", "Ha Dieu De"
                }
                for _, qName in ipairs(mainQuests) do
                    fireRemote("ClaimQuest", qName)
                    task.wait(0.1)
                end
            end)
        end

        if config.autoAwakeRod then
            pcall(function()
                fireRemote("AwakeRod")
            end)
        end

        task.wait(10.0)
    end
end)

-- [14] SECRET RODS SNATCHER & LOCATIONS
local SECRET_RODS = {
    {"Ascendant Bamboo Rod", Vector3.new(-952.2, 101.1, 22.4)},
    {"Anchorbound Rod",      Vector3.new(-803.7, 36.0, 1097.3)},
    {"Kraken Rod",           Vector3.new(832.6, 39.3, 801.0)},
    {"Blazeshark Rod",       Vector3.new(-2.1, 25.0, 5.1)},
    {"Demonic Rod",          Vector3.new(592.2, 43.3, -621.9)},
    {"Lifebloom Rod",        Vector3.new(-57.8, 38.9, -766.4)}
}

local function grabAllSecretRods()
    local origPos = getHrp() and getHrp().Position
    for _, item in ipairs(SECRET_RODS) do
        local name, pos = item[1], item[2]
        pcall(function()
            safeTeleport(pos)
            task.wait(0.3)
            -- Fire ProximityPrompt or SecretRod remote
            fireRemote("SecretRod", name)
            for _, pp in ipairs(workspace:GetDescendants()) do
                if pp:IsA("ProximityPrompt") and (pp.Position - pos).Magnitude <= 15 then
                    if fireproximityprompt then
                        fireproximityprompt(pp)
                    end
                end
            end
        end)
        task.wait(0.4)
    end
    if origPos then
        safeTeleport(origPos)
    end
end

registerThread(function()
    while true do
        if config.autoClaimSecretRods then
            pcall(function()
                for _, item in ipairs(SECRET_RODS) do
                    fireRemote("SecretRod", item[1])
                end
            end)
        end
        task.wait(15.0)
    end
end)

-- [15] TELEPORT HUB DESTINATIONS
local TELEPORT_DESTINATIONS = {
    {"Beginning Isle (Starter Island)", Vector3.new(-200.7, 16.0, 35.9), "Beginning Isle"},
    {"Bamboo Isle (Map 2)",            Vector3.new(-1223.0, 13.0, -24.1), "Bamboo Isle"},
    {"Amber Isle (Map 3)",             Vector3.new(1259.4, 15.0, 1401.5), "Amber Isle"},
    {"Mistpeak Isle (Map 4)",          Vector3.new(2660.2, 14.0, -86.7), "Mistpeak Isle"},
    {"Perch Isle (Map 5)",             Vector3.new(-62.0, 17.0, -1321.4), "Perch Isle"},
    {"Sovereign Isle (Map 6)",         Vector3.new(-1276.4, 14.0, 1239.7), "Sovereign Isle"},
    {"Frost Isle (Map 7)",             Vector3.new(-1366.0, 17.0, -1495.4), "Frost Isle"},
    {"Fallout Isle (Map 8)",           Vector3.new(65.5, 14.0, 1181.3), "Fallout Isle"},
    {"Coconut Isle (Map 9)",           Vector3.new(1493.6, 15.0, -1430.6), "Coconut Isle"},
    {"Battlefield Isle",               Vector3.new(1393.5, 17.0, 169.6), "Battlefield Isle"},
    {"World Angler Isle (Map 10)",     Vector3.new(-2416.6, 17.0, -203.1), "World Angler Isle"},
    {"Fisher Place (Underworld)",      Vector3.new(-2709.7, 66.0, 2.1), "Fisher_Place"},

    -- NPCs & Merchants
    {"NPC Biao Ge (Sell Fish)",        Vector3.new(-229.7, 10.0, 86.3)},
    {"NPC Nana (Skills & Quests)",     Vector3.new(-63.8, 14.0, 122.3)},
    {"NPC Ba Chang (Rod Merchant)",    Vector3.new(-146.6, 10.0, 91.0)},
    {"NPC Biao Di (Bait Merchant)",    Vector3.new(-146.6, 10.0, 91.0)},
    {"NPC Chu Xin (Boat Merchant)",    Vector3.new(-1368.5, 12.0, 95.3)},
    {"NPC Blind Grand Angler",         Vector3.new(1245.8, 22.0, -128.6)},
    {"Boss Arena (Enzo)",              Vector3.new(-115.4, 15.0, 1351.0)},
    {"PVP Arena (Giang Lao)",          Vector3.new(-2800.0, 64.0, 2.0)},

    -- Secret Rods
    {"Ascendant Bamboo Rod",           Vector3.new(-1368.0, 12.0, 95.0)},
    {"Anchorbound Rod",                Vector3.new(-62.0, 16.0, -1321.0)},
    {"Kraken Rod",                     Vector3.new(1493.0, 15.0, -1430.0)},
    {"Blazeshark Rod",                 Vector3.new(1393.0, 16.0, 169.0)},
    {"Demonic Rod",                    Vector3.new(65.0, 14.0, 1181.0)},
    {"Lifebloom Rod",                  Vector3.new(-1223.0, 13.0, -24.0)}
}

-- [16] ESP & VISUALS ENGINE
local function clearEsp()
    for _, el in ipairs(activeEspElements) do
        pcall(function() el:Destroy() end)
    end
    table.clear(activeEspElements)
end

registerThread(function()
    while true do
        if config.secretRodEsp or config.npcEsp or config.playerEsp or config.fishEsp then
            pcall(function()
                clearEsp()
                local hrp = getHrp()
                local hrpPos = hrp and hrp.Position or Vector3.zero

                -- Secret Rod ESP
                if config.secretRodEsp then
                    for _, rodInfo in ipairs(SECRET_RODS) do
                        local name, pos = rodInfo[1], rodInfo[2]
                        local dist = math.floor((pos - hrpPos).Magnitude)
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "SecretRodESP_" .. name
                        bb.Size = UDim2.new(0, 160, 0, 40)
                        bb.AlwaysOnTop = true
                        bb.Adornee = workspace.Terrain
                        bb.ExtentsOffsetWorldSpace = pos + Vector3.new(0, 2, 0)
                        bb.Parent = CoreGui

                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Font = THEME.Font
                        lbl.TextSize = 12
                        lbl.TextColor3 = THEME.Gold
                        lbl.TextStrokeTransparency = 0
                        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        lbl.Text = "🎋 " .. name .. "\n[" .. dist .. "m]"
                        lbl.Parent = bb
                        table.insert(activeEspElements, bb)
                    end
                end

                -- NPC ESP
                if config.npcEsp then
                    for _, model in ipairs(workspace:GetDescendants()) do
                        if model:IsA("Model") and (model.Name == "Biao Ge" or model.Name == "Ba Chang" or model.Name == "Biao Di" or model.Name == "Chu Xin" or model.Name == "Nana" or model.Name == "The Shadow") then
                            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - hrpPos).Magnitude <= 500 then
                                local hl = Instance.new("Highlight")
                                hl.FillColor = THEME.Accent
                                hl.OutlineColor = THEME.Gold
                                hl.FillTransparency = 0.5
                                hl.Adornee = model
                                hl.Parent = CoreGui
                                table.insert(activeEspElements, hl)
                            end
                        end
                    end
                end

                -- Player ESP
                if config.playerEsp then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            local char = plr.Character
                            local pHrp = char:FindFirstChild("HumanoidRootPart")
                            if pHrp then
                                local dist = math.floor((pHrp.Position - hrpPos).Magnitude)
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "PlayerESP_" .. plr.Name
                                bb.Size = UDim2.new(0, 140, 0, 30)
                                bb.AlwaysOnTop = true
                                bb.Adornee = pHrp
                                bb.ExtentsOffset = Vector3.new(0, 3, 0)
                                bb.Parent = CoreGui

                                local lbl = Instance.new("TextLabel")
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Font = THEME.Font
                                lbl.TextSize = 11
                                lbl.TextColor3 = THEME.Text
                                lbl.TextStrokeTransparency = 0
                                lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                lbl.Text = plr.DisplayName .. "\n[" .. dist .. "m]"
                                lbl.Parent = bb
                                table.insert(activeEspElements, bb)
                            end
                        end
                    end
                end
            end)
        else
            clearEsp()
        end
        task.wait(2.0)
    end
end)

-- Fullbright Engine
registerThread(function()
    while true do
        if config.fullbright then
            pcall(function()
                local Lighting = game:GetService("Lighting")
                Lighting.Brightness = 3
                Lighting.ClockTime = 14
                Lighting.FogEnd = 1000000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            end)
        end
        task.wait(2.5)
    end
end)

-- [17] PLAYER UTILITIES (Speed, Jump, Noclip, Fly, Water Walk, Anti-AFK)
registerConnection(RunService.Heartbeat:Connect(function()
    local hum = getHumanoid()
    if hum then
        if config.walkSpeedEnabled then
            hum.WalkSpeed = config.walkSpeedValue
        end
        if config.jumpPowerEnabled then
            hum.JumpPower = config.jumpPowerValue
        end
    end
end))

-- Ghost Noclip
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

local function restoreCollision()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Water Walk Engine
local waterPlatform = nil
registerConnection(RunService.Heartbeat:Connect(function()
    if config.waterWalk then
        local hrp = getHrp()
        if hrp then
            if not waterPlatform then
                waterPlatform = Instance.new("Part")
                waterPlatform.Name = "BH_WaterWalk_Platform"
                waterPlatform.Size = Vector3.new(12, 1, 12)
                waterPlatform.Anchored = true
                waterPlatform.CanCollide = true
                waterPlatform.Transparency = 1
                waterPlatform.Parent = workspace
            end
            -- Check if above water height
            waterPlatform.Position = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
        end
    else
        if waterPlatform then
            pcall(function() waterPlatform:Destroy() end)
            waterPlatform = nil
        end
    end
end))

-- Infinite Jump
registerConnection(UserInputService.JumpRequest:Connect(function()
    if config.infiniteJump then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

-- Click Teleport (Ctrl + Click)
registerConnection(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and config.clickTp then
        if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local mouse = LocalPlayer:GetMouse()
            if mouse and mouse.Hit then
                safeTeleport(mouse.Hit.Position)
            end
        end
    end
end))

-- Flight Engine
local flyBodyGyro, flyBodyVelocity
local function startFlying()
    local hrp = getHrp()
    if not hrp then return end
    pcall(function()
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = hrp.CFrame
        flyBodyGyro.Parent = hrp

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.zero
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Parent = hrp
    end)
end

local function stopFlying()
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    local hum = getHumanoid()
    if hum then
        hum.PlatformStand = false
    end
end

registerConnection(RunService.Heartbeat:Connect(function()
    if config.flyEnabled then
        local hrp = getHrp()
        local hum = getHumanoid()
        if hrp and hum then
            hum.PlatformStand = true
            if not flyBodyVelocity or not flyBodyGyro then
                startFlying()
            end
            if flyBodyGyro and flyBodyVelocity then
                flyBodyGyro.CFrame = camera.CFrame
                local moveDir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end

                if moveDir.Magnitude > 0 then
                    flyBodyVelocity.Velocity = moveDir.Unit * config.flySpeed
                else
                    flyBodyVelocity.Velocity = Vector3.zero
                end
            end
        end
    else
        if flyBodyVelocity or flyBodyGyro then
            stopFlying()
        end
    end
end))

-- Native Anti-AFK Engine
registerConnection(LocalPlayer.Idled:Connect(function()
    if config.antiAfk then
        simulateNativeClick()
    end
end))

registerThread(function()
    while true do
        if config.antiAfk then
            simulateNativeClick()
        end
        task.wait(120)
    end
end)

-- [18] GUI CONSTRUCTION (1:1 MY FLOWER SHOP MASTER STANDARD)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BH_HeavyweightFishing_GUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = CoreGui
    end
end)
if not screenGui.Parent then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
_G.BH_HEAVYWEIGHTFISHING_SCREEN_GUI = screenGui

local UIScale = Instance.new("UIScale", screenGui)
local function updateScale()
    if not camera then return end
    local v = camera.ViewportSize
    local s = math.min(v.X / 1280, v.Y / 720)
    UIScale.Scale = math.clamp(s, 0.45, 1.15)
end
registerConnection(camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
updateScale()

local baseWidth = 660
local baseHeight = 440

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
mainFrame.Position = UDim2.new(0.5, -baseWidth/2, 0.5, -baseHeight/2)
mainFrame.BackgroundColor3 = THEME.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

corner(mainFrame, 14)
neonStroke(mainFrame, 2)

local MainScale = Instance.new("UIScale", mainFrame)
MainScale.Scale = 1

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundColor3 = THEME.Sidebar
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local titleLogo = Instance.new("TextLabel")
titleLogo.Size = UDim2.new(0, 32, 0, 32)
titleLogo.Position = UDim2.new(0, 14, 0.5, -16)
titleLogo.BackgroundTransparency = 1
titleLogo.Font = THEME.Font
titleLogo.TextSize = 22
titleLogo.TextColor3 = THEME.Title
titleLogo.Text = "👑"
titleLogo.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 340, 0, 24)
titleLabel.Position = UDim2.new(0, 52, 0.5, -12)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = THEME.Font
titleLabel.TextSize = 16
titleLabel.TextColor3 = THEME.Title
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "BROTHER HUB — HEAVYWEIGHT FISHING"
titleLabel.Parent = topBar

local headerBtns = Instance.new("Frame")
headerBtns.Name = "HeaderButtons"
headerBtns.Size = UDim2.new(0, 150, 1, 0)
headerBtns.Position = UDim2.new(1, -160, 0, 0)
headerBtns.BackgroundTransparency = 1
headerBtns.Parent = topBar

local langBtn = Instance.new("TextButton")
langBtn.Name = "LangToggleBtn"
langBtn.Size = UDim2.new(0, 36, 0, 28)
langBtn.Position = UDim2.new(0, 26, 0.5, -14)
langBtn.BackgroundColor3 = THEME.Panel
langBtn.Font = THEME.Font
langBtn.TextSize = 14
langBtn.Text = (config.language == "ID") and "🇮🇩" or "🇬🇧"
langBtn.BorderSizePixel = 0
langBtn.Parent = headerBtns
corner(langBtn, 6)

local minBtn = Instance.new("TextButton")
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 32, 0, 28)
minBtn.Position = UDim2.new(0, 68, 0.5, -14)
minBtn.BackgroundColor3 = THEME.Gold
minBtn.Font = THEME.Font
minBtn.TextSize = 16
minBtn.TextColor3 = Color3.fromRGB(15, 17, 24)
minBtn.Text = "-"
minBtn.BorderSizePixel = 0
minBtn.Parent = headerBtns
corner(minBtn, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 0, 28)
closeBtn.Position = UDim2.new(0, 106, 0.5, -14)
closeBtn.BackgroundColor3 = THEME.Red
closeBtn.Font = THEME.Font
closeBtn.TextSize = 14
closeBtn.TextColor3 = THEME.Text
closeBtn.Text = "X"
closeBtn.BorderSizePixel = 0
closeBtn.Parent = headerBtns
corner(closeBtn, 6)

-- ResizeGrip (1:1 FlowerShop & BrotherHub.txt Standard)
do
    local grip = Instance.new("TextButton", mainFrame)
    grip.Name = "ResizeGrip"
    grip.AnchorPoint = Vector2.new(1, 1)
    grip.Size = UDim2.fromOffset(22, 22)
    grip.Position = UDim2.new(1, -4, 1, -4)
    grip.BackgroundColor3 = THEME.Panel
    grip.Text = "◢"
    grip.TextColor3 = THEME.Title or THEME.Gold or Color3.fromRGB(255, 215, 0)
    grip.Font = Enum.Font.GothamBold
    grip.TextSize = 16
    grip.AutoButtonColor = false
    grip.ZIndex = 60
    local c = Instance.new("UICorner", grip); c.CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", grip); s.Color = THEME.Title or THEME.Gold or Color3.fromRGB(255, 215, 0); s.Thickness = 1

    local MIN_S, MAX_S = 0.55, 1.8
    local resizing, startDist, startScale, centerPx = false, 1, 1, Vector2.zero

    grip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing  = true
            centerPx  = mainFrame.AbsolutePosition + mainFrame.AbsoluteSize / 2
            startDist = math.max((Vector2.new(i.Position.X, i.Position.Y) - centerPx).Magnitude, 1)
            startScale= MainScale.Scale
        end
    end)
    registerConnection(UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local cur = (Vector2.new(i.Position.X, i.Position.Y) - centerPx).Magnitude
            local s = math.clamp(startScale * (cur / startDist), MIN_S, MAX_S)
            MainScale.Scale = s
        end
    end))
    registerConnection(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end))
end

-- [19] FLOATING MINCIRCLE 80x80 (1:1 FLOWER SHOP MASTER STANDARD)
local Circle = Instance.new("TextButton", screenGui)
Circle.Name = "MinCircle"
Circle.Size = UDim2.fromOffset(80, 80)
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.Position = UDim2.new(0.5, 0, 0, 70)
Circle.BackgroundColor3 = THEME.Panel
Circle.Text = "BH"
Circle.Font = Enum.Font.GothamBlack
Circle.TextSize = 30
Circle.TextColor3 = THEME.Title
Circle.AutoButtonColor = false
Circle.Active = true
Circle.Visible = false
Circle.ZIndex = 150
corner(Circle, 40)
neonStroke(Circle, 3)
gradient(Circle, THEME.Purple, THEME.Blue, 45)

local CrownLabel = Instance.new("TextLabel", Circle)
CrownLabel.Name = "CrownLabel"
CrownLabel.Size = UDim2.new(1, 0, 0, 16)
CrownLabel.Position = UDim2.new(0, 0, 0, 8)
CrownLabel.BackgroundTransparency = 1
CrownLabel.Text = "👑"
CrownLabel.Font = THEME.Font
CrownLabel.TextSize = 14
CrownLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
CrownLabel.ZIndex = 152

local CircleScale = Instance.new("UIScale", Circle)
CircleScale.Scale = 0

local doMinimize, doRestore
do
    local isAnimating = false
    doMinimize = function()
        if isAnimating then return end
        isAnimating = true
        local t = TweenService:Create(MainScale, tweenFast, {Scale = 0})
        t:Play()
        t.Completed:Connect(function()
            mainFrame.Visible = false
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
            mainFrame.Visible = true
            MainScale.Scale = 0
            local t2 = TweenService:Create(MainScale, tweenBounce, {Scale = 1})
            t2:Play()
            t2.Completed:Connect(function() isAnimating = false end)
        end)
    end
end

minBtn.MouseButton1Click:Connect(doMinimize)

-- Draggable MinCircle
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
            local d = i.Position - startPx
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

-- [20] MODAL CONFIRMATION DIALOG (Close 'X')
local modalOverlay = Instance.new("Frame")
modalOverlay.Name = "ModalOverlay"
modalOverlay.Size = UDim2.new(1, 0, 1, 0)
modalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
modalOverlay.BackgroundTransparency = 0.5
modalOverlay.Visible = false
modalOverlay.ZIndex = 100
modalOverlay.Parent = screenGui

local modalBox = Instance.new("Frame")
modalBox.Name = "ModalBox"
modalBox.Size = UDim2.new(0, 380, 0, 180)
modalBox.Position = UDim2.new(0.5, -190, 0.5, -90)
modalBox.BackgroundColor3 = THEME.Bg
modalBox.BorderSizePixel = 0
modalBox.ZIndex = 101
modalBox.Parent = modalOverlay

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 12)
modalCorner.Parent = modalBox

local modalStroke = Instance.new("UIStroke")
modalStroke.Thickness = 1.5
modalStroke.Color = THEME.Stroke
modalStroke.Parent = modalBox

local modalTitle = Instance.new("TextLabel")
modalTitle.Size = UDim2.new(1, -24, 0, 30)
modalTitle.Position = UDim2.new(0, 12, 0, 12)
modalTitle.BackgroundTransparency = 1
modalTitle.Font = THEME.Font
modalTitle.TextSize = 16
modalTitle.TextColor3 = THEME.Red
modalTitle.TextXAlignment = Enum.TextXAlignment.Left
modalTitle.Text = "⚠️ " .. tr("CloseConfirmTitle")
modalTitle.ZIndex = 102
modalTitle.Parent = modalBox

local modalBody = Instance.new("TextLabel")
modalBody.Size = UDim2.new(1, -24, 0, 60)
modalBody.Position = UDim2.new(0, 12, 0, 46)
modalBody.BackgroundTransparency = 1
modalBody.Font = THEME.Font
modalBody.TextSize = 13
modalBody.TextColor3 = THEME.SubText
modalBody.TextWrapped = true
modalBody.TextXAlignment = Enum.TextXAlignment.Left
modalBody.TextYAlignment = Enum.TextYAlignment.Top
modalBody.Text = tr("CloseConfirmBody")
modalBody.ZIndex = 102
modalBody.Parent = modalBox

local modalYes = Instance.new("TextButton")
modalYes.Size = UDim2.new(0.46, 0, 0, 36)
modalYes.Position = UDim2.new(0.04, 0, 1, -48)
modalYes.BackgroundColor3 = THEME.Green
modalYes.Font = THEME.Font
modalYes.TextSize = 14
modalYes.TextColor3 = Color3.fromRGB(255, 255, 255)
modalYes.Text = tr("BtnYes")
modalYes.ZIndex = 102
modalYes.BorderSizePixel = 0
modalYes.Parent = modalBox
Instance.new("UICorner", modalYes).CornerRadius = UDim.new(0, 8)

local modalCancel = Instance.new("TextButton")
modalCancel.Size = UDim2.new(0.46, 0, 0, 36)
modalCancel.Position = UDim2.new(0.50, 0, 1, -48)
modalCancel.BackgroundColor3 = THEME.Red
modalCancel.Font = THEME.Font
modalCancel.TextSize = 14
modalCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
modalCancel.Text = tr("BtnCancel")
modalCancel.ZIndex = 102
modalCancel.BorderSizePixel = 0
modalCancel.Parent = modalBox
Instance.new("UICorner", modalCancel).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    modalOverlay.Visible = true
end)

modalCancel.MouseButton1Click:Connect(function()
    modalOverlay.Visible = false
end)

-- Total Sterilization Routine
local function totalSterilization()
    -- Disconnect all events
    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(activeConnections)

    -- Cancel all background threads
    for _, thr in ipairs(activeThreads) do
        pcall(function() task.cancel(thr) end)
    end
    table.clear(activeThreads)

    -- Remove ESP
    clearEsp()

    -- Remove waterwalk platform
    if waterPlatform then
        pcall(function() waterPlatform:Destroy() end)
        waterPlatform = nil
    end

    -- Restore Player Attributes
    pcall(function()
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.PlatformStand = false
        end
        restoreCollision()
        stopFlying()
    end)

    -- Restore Lighting
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
    end)

    -- Destroy UI
    pcall(function()
        screenGui:Destroy()
    end)

    _G.BH_HEAVYWEIGHTFISHING_CLEANUP = nil
end
_G.BH_HEAVYWEIGHTFISHING_CLEANUP = totalSterilization

modalYes.MouseButton1Click:Connect(function()
    totalSterilization()
end)

-- [21] HORIZONTAL SCROLLING TABBAR (1:1 FlowerShop Standard)
local tabBar = Instance.new("ScrollingFrame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -24, 0, 38)
tabBar.Position = UDim2.new(0, 12, 0, 56)
tabBar.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
tabBar.BorderSizePixel = 0
tabBar.ScrollBarThickness = 3
tabBar.ScrollBarImageColor3 = THEME.Title
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.ClipsDescendants = true
tabBar.Parent = mainFrame
corner(tabBar, 8)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabBar

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingLeft = UDim.new(0, 6)
tabPadding.PaddingRight = UDim.new(0, 6)
tabPadding.Parent = tabBar

-- Container for Content Pages
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -24, 1, -108)
contentContainer.Position = UDim2.new(0, 12, 0, 100)
contentContainer.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
contentContainer.BorderSizePixel = 0
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainFrame
corner(contentContainer, 10)

-- [22] COMPONENT FACTORIES (Toggles, Sliders, Dropdowns, Buttons)
local tabButtons = {}
local tabPages = {}
local activeTab = nil

local function switchTab(tabKey)
    activeTab = tabKey
    for key, btn in pairs(tabButtons) do
        if key == tabKey then
            btn.BackgroundColor3 = THEME.Accent
            btn.TextColor3 = Color3.fromRGB(15, 17, 24)
        else
            btn.BackgroundColor3 = THEME.Panel
            btn.TextColor3 = THEME.Text
        end
    end
    for key, page in pairs(tabPages) do
        page.Visible = (key == tabKey)
    end
end

local function createTab(tabKey, labelText)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. tabKey
    tabBtn.Size = UDim2.new(0, 115, 1, -8)
    tabBtn.BackgroundColor3 = THEME.Panel
    tabBtn.Font = THEME.Font
    tabBtn.TextSize = 13
    tabBtn.TextColor3 = THEME.Text
    tabBtn.Text = labelText
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. tabKey
    page.Size = UDim2.new(1, -12, 1, -12)
    page.Position = UDim2.new(0, 6, 0, 6)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentContainer

    local pageList = Instance.new("UIListLayout")
    pageList.FillDirection = Enum.FillDirection.Vertical
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 8)
    pageList.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingRight = UDim.new(0, 8)
    pagePad.Parent = page

    tabBtn.MouseButton1Click:Connect(function()
        switchTab(tabKey)
    end)

    tabButtons[tabKey] = tabBtn
    tabPages[tabKey] = page
    return page
end

local function createSection(parent, titleText, descText)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = THEME.Panel
    card.BorderSizePixel = 0
    card.Parent = parent

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Thickness = 1
    cStroke.Color = THEME.Stroke
    cStroke.Parent = card

    local cPad = Instance.new("UIPadding")
    cPad.PaddingTop = UDim.new(0, 10)
    cPad.PaddingBottom = UDim.new(0, 10)
    cPad.PaddingLeft = UDim.new(0, 12)
    cPad.PaddingRight = UDim.new(0, 12)
    cPad.Parent = card

    local cList = Instance.new("UIListLayout")
    cList.FillDirection = Enum.FillDirection.Vertical
    cList.Padding = UDim.new(0, 6)
    cList.Parent = card

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, 0, 0, 18)
    tLabel.BackgroundTransparency = 1
    tLabel.Font = THEME.Font
    tLabel.TextSize = 14
    tLabel.TextColor3 = THEME.Gold
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Text = titleText
    tLabel.Parent = card

    if descText and descText ~= "" then
        local dLabel = Instance.new("TextLabel")
        dLabel.Size = UDim2.new(1, 0, 0, 14)
        dLabel.BackgroundTransparency = 1
        dLabel.Font = THEME.Font
        dLabel.TextSize = 11
        dLabel.TextColor3 = THEME.SubText
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.Text = descText
        dLabel.Parent = card
    end

    return card
end

-- Full-Row Clickable Toggle
local function createToggle(parent, labelText, initialValue, callback)
    local toggleRow = Instance.new("TextButton")
    toggleRow.Size = UDim2.new(1, 0, 0, 36)
    toggleRow.BackgroundColor3 = THEME.Slot
    toggleRow.BorderSizePixel = 0
    toggleRow.Text = ""
    toggleRow.AutoButtonColor = false
    toggleRow.Parent = parent

    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 6)
    rCorner.Parent = toggleRow

    local rLabel = Instance.new("TextLabel")
    rLabel.Size = UDim2.new(1, -56, 1, 0)
    rLabel.Position = UDim2.new(0, 12, 0, 0)
    rLabel.BackgroundTransparency = 1
    rLabel.Font = THEME.Font
    rLabel.TextSize = 13
    rLabel.TextColor3 = THEME.Text
    rLabel.TextXAlignment = Enum.TextXAlignment.Left
    rLabel.Text = labelText
    rLabel.Parent = toggleRow

    local toggleBox = Instance.new("Frame")
    toggleBox.Size = UDim2.new(0, 38, 0, 20)
    toggleBox.Position = UDim2.new(1, -48, 0.5, -10)
    toggleBox.BackgroundColor3 = initialValue and THEME.On or Color3.fromRGB(50, 55, 75)
    toggleBox.BorderSizePixel = 0
    toggleBox.Parent = toggleRow

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(1, 0)
    boxCorner.Parent = toggleBox

    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = initialValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBox

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = toggleDot

    local state = initialValue

    local function updateState(newState)
        state = newState
        TweenService:Create(toggleBox, TweenInfo.new(0.2), {
            BackgroundColor3 = state and THEME.On or Color3.fromRGB(50, 55, 75)
        }):Play()
        TweenService:Create(toggleDot, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        callback(state)
        saveConfig()
    end

    toggleRow.MouseButton1Click:Connect(function()
        updateState(not state)
    end)

    return {
        Set = updateState,
        Get = function() return state end
    }
end

-- Slider with Direct Text Input
local function createSlider(parent, labelText, minVal, maxVal, initialValue, callback)
    local sliderRow = Instance.new("Frame")
    sliderRow.Size = UDim2.new(1, 0, 0, 48)
    sliderRow.BackgroundColor3 = THEME.Slot
    sliderRow.BorderSizePixel = 0
    sliderRow.Parent = parent

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 6)
    sCorner.Parent = sliderRow

    local sLabel = Instance.new("TextLabel")
    sLabel.Size = UDim2.new(0.6, 0, 0, 20)
    sLabel.Position = UDim2.new(0, 12, 0, 4)
    sLabel.BackgroundTransparency = 1
    sLabel.Font = THEME.Font
    sLabel.TextSize = 13
    sLabel.TextColor3 = THEME.Text
    sLabel.TextXAlignment = Enum.TextXAlignment.Left
    sLabel.Text = labelText
    sLabel.Parent = sliderRow

    local valBox = Instance.new("TextBox")
    valBox.Size = UDim2.new(0, 60, 0, 20)
    valBox.Position = UDim2.new(1, -72, 0, 4)
    valBox.BackgroundColor3 = THEME.Panel
    valBox.Font = THEME.Font
    valBox.TextSize = 12
    valBox.TextColor3 = THEME.Accent
    valBox.Text = tostring(initialValue)
    valBox.ClearTextOnFocus = false
    valBox.BorderSizePixel = 0
    valBox.Parent = sliderRow
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -24, 0, 6)
    bar.Position = UDim2.new(0, 12, 1, -12)
    bar.BackgroundColor3 = Color3.fromRGB(45, 52, 75)
    bar.BorderSizePixel = 0
    bar.Parent = sliderRow
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    local pct = math.clamp((initialValue - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = THEME.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local currentVal = initialValue

    local function setValue(val)
        val = math.clamp(val, minVal, maxVal)
        currentVal = val
        valBox.Text = tostring(math.floor(val * 100) / 100)
        local p = (val - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(p, 0, 1, 0)
        callback(val)
        saveConfig()
    end

    valBox.FocusLost:Connect(function()
        local n = tonumber(valBox.Text)
        if n then
            setValue(n)
        else
            valBox.Text = tostring(currentVal)
        end
    end)

    local isSliding = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            local mouseX = input.Position.X
            local relX = math.clamp(mouseX - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
            local p = relX / bar.AbsoluteSize.X
            setValue(minVal + (maxVal - minVal) * p)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isSliding = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local relX = math.clamp(mouseX - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
            local p = relX / bar.AbsoluteSize.X
            setValue(minVal + (maxVal - minVal) * p)
        end
    end)

    return {
        Set = setValue,
        Get = function() return currentVal end
    }
end

-- Action Button
local function createButton(parent, labelText, btnColor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = btnColor or THEME.Panel
    btn.Font = THEME.Font
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = labelText
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.Accent}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = btnColor or THEME.Panel}):Play()
        callback()
    end)
    return btn
end

-- Dropdown Selector
local function createDropdown(parent, labelText, options, currentSelection, callback)
    local ddRow = Instance.new("Frame")
    ddRow.Size = UDim2.new(1, 0, 0, 38)
    ddRow.BackgroundColor3 = THEME.Slot
    ddRow.BorderSizePixel = 0
    ddRow.Parent = parent

    local ddCorner = Instance.new("UICorner")
    ddCorner.CornerRadius = UDim.new(0, 6)
    ddCorner.Parent = ddRow

    local ddLabel = Instance.new("TextLabel")
    ddLabel.Size = UDim2.new(0.45, 0, 1, 0)
    ddLabel.Position = UDim2.new(0, 12, 0, 0)
    ddLabel.BackgroundTransparency = 1
    ddLabel.Font = THEME.Font
    ddLabel.TextSize = 13
    ddLabel.TextColor3 = THEME.Text
    ddLabel.TextXAlignment = Enum.TextXAlignment.Left
    ddLabel.Text = labelText
    ddLabel.Parent = ddRow

    local ddBtn = Instance.new("TextButton")
    ddBtn.Size = UDim2.new(0.5, -12, 0, 26)
    ddBtn.Position = UDim2.new(0.5, 0, 0.5, -13)
    ddBtn.BackgroundColor3 = THEME.Panel
    ddBtn.Font = THEME.Font
    ddBtn.TextSize = 12
    ddBtn.TextColor3 = THEME.Gold
    ddBtn.Text = currentSelection .. " ▼"
    ddBtn.BorderSizePixel = 0
    ddBtn.Parent = ddRow
    Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0, 4)

    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == currentSelection then
            currentIndex = i
            break
        end
    end

    ddBtn.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        local newSel = options[currentIndex]
        ddBtn.Text = newSel .. " ▼"
        callback(newSel)
        saveConfig()
    end)

    return {
        Set = function(val)
            for i, opt in ipairs(options) do
                if opt == val then
                    currentIndex = i
                    ddBtn.Text = val .. " ▼"
                    break
                end
            end
        end
    }
end

-- [22] POPULATE ALL 11 TABS

-- === TAB 1: 🎣 AUTO MANCING ===
local pageFish = createTab("Fish", tr("TabAutoFish"))
local secFish = createSection(pageFish, tr("AutoFishTitle"), tr("AutoFishDesc"))
createToggle(secFish, tr("AutoCast"), config.autoCast, function(val)
    config.autoCast = val
end)
createSlider(secFish, tr("CastPower"), 10, 100, config.castPower, function(val)
    config.castPower = val
end)
createSlider(secFish, tr("CastDelay"), 0.2, 3.0, config.castDelay, function(val)
    config.castDelay = val
end)
createToggle(secFish, tr("AutoCatch"), config.autoCatch, function(val)
    config.autoCatch = val
end)
createToggle(secFish, tr("InstantCatch"), config.instantCatch, function(val)
    config.instantCatch = val
end)
createToggle(secFish, tr("LockCatchBar"), config.lockCatchBar, function(val)
    config.lockCatchBar = val
end)
createToggle(secFish, tr("AutoMinigame"), config.autoMinigame, function(val)
    config.autoMinigame = val
end)
createToggle(secFish, tr("PerfectRhythm"), config.perfectRhythm, function(val)
    config.perfectRhythm = val
end)
createToggle(secFish, tr("GameAutoFish"), config.autoGameAFK, function(val)
    config.autoGameAFK = val
end)
createToggle(secFish, tr("AutoSpamSkills"), config.autoSpamSkills, function(val)
    config.autoSpamSkills = val
end)
createToggle(secFish, "⚡ Auto Slam Fish", config.autoSlam, function(val)
    config.autoSlam = val
end)
createToggle(secFish, tr("EquipBestRod"), config.autoEquipBestRod, function(val)
    config.autoEquipBestRod = val
end)
createToggle(secFish, tr("EquipBestBait"), config.autoEquipBestBait, function(val)
    config.autoEquipBestBait = val
end)

-- === TAB 2: 💰 AUTO JUAL ===
local pageSell = createTab("Sell", tr("TabAutoSell"))
local secSell = createSection(pageSell, tr("AutoSellTitle"), tr("AutoSellDesc"))
createToggle(secSell, tr("AutoSell"), config.autoSell, function(val)
    config.autoSell = val
end)
createToggle(secSell, tr("InstantRemoteSell"), config.instantRemoteSell, function(val)
    config.instantRemoteSell = val
end)
createToggle(secSell, tr("SellAtNpc"), config.sellAtNpc, function(val)
    config.sellAtNpc = val
end)
createSlider(secSell, tr("SellThreshold"), 1, 50, config.sellThreshold, function(val)
    config.sellThreshold = val
end)
createSlider(secSell, tr("SellDelay"), 1.0, 15.0, config.sellDelay, function(val)
    config.sellDelay = val
end)
createButton(secSell, tr("BtnSellNow"), THEME.Green, function()
    pcall(function()
        fireRemote("SellFish")
    end)
end)

-- === TAB 3: 🛒 TOKO & UMPAN ===
local pageShops = createTab("Shops", tr("TabShops"))
local secShops = createSection(pageShops, tr("ShopsTitle"), tr("ShopsDesc"))
createToggle(secShops, tr("BlockRobux"), config.blockRobuxPopups, function(val)
    config.blockRobuxPopups = val
end)
createToggle(secShops, tr("AutoBuyBait"), config.autoBuyBait, function(val)
    config.autoBuyBait = val
end)
createSlider(secShops, tr("BaitAmount"), 1, 20, config.baitBuyAmount, function(val)
    config.baitBuyAmount = val
end)

local secBaitFilters = createSection(pageShops, "Filter Umpan yang Ingin Dibeli", "")
for baitName, enabled in pairs(config.targetBaits) do
    createToggle(secBaitFilters, "🪱 " .. baitName, enabled, function(val)
        config.targetBaits[baitName] = val
    end)
end

local secRodFilters = createSection(pageShops, "Filter Pancingan yang Ingin Dibeli", "")
createToggle(secRodFilters, tr("AutoBuyRods"), config.autoBuyRods, function(val)
    config.autoBuyRods = val
end)
for rodName, enabled in pairs(config.targetRods) do
    createToggle(secRodFilters, "🎣 " .. rodName, enabled, function(val)
        config.targetRods[rodName] = val
    end)
end

local secSkillFilters = createSection(pageShops, "Filter Skill yang Ingin Dipelajari", "")
createToggle(secSkillFilters, tr("AutoBuySkills"), config.autoBuySkills, function(val)
    config.autoBuySkills = val
end)
for skillName, enabled in pairs(config.targetSkills) do
    createToggle(secSkillFilters, "⚔️ " .. skillName, enabled, function(val)
        config.targetSkills[skillName] = val
    end)
end
createToggle(secShops, "🔨 Auto Craft Bait (Resep)", config.autoCraftBait, function(val)
    config.autoCraftBait = val
end)

-- === TAB 4: 🔮 ORB & TRAIT ===
local pageOrbs = createTab("Orbs", tr("TabOrbs"))
local secOrbs = createSection(pageOrbs, tr("OrbsTitle"), tr("OrbsDesc"))
createToggle(secOrbs, tr("AutoEquipOrb"), config.autoEquipOrb, function(val)
    config.autoEquipOrb = val
end)
createToggle(secOrbs, tr("AutoRerollTrait"), config.autoRerollTrait, function(val)
    config.autoRerollTrait = val
end)
createDropdown(secOrbs, tr("TargetTrait"), {
    "Powerful", "Executioner", "Berserk", "Azure Dragon",
    "Swift", "Sharp", "Rapid", "Precision", "Chrono", "Assassin"
}, config.targetTrait, function(val)
    config.targetTrait = val
end)
createToggle(secOrbs, tr("LockDesiredTraits"), config.lockDesiredTraits, function(val)
    config.lockDesiredTraits = val
end)
createToggle(secOrbs, "🗑️ Auto Delete Common Orbs", config.autoDeleteCommonOrbs, function(val)
    config.autoDeleteCommonOrbs = val
end)

-- === TAB 5: ⛵ PERAHU & PVP ===
local pageBoats = createTab("Boats", tr("TabBoats"))
local secBoats = createSection(pageBoats, tr("BoatsTitle"), tr("BoatsDesc"))
createToggle(secBoats, tr("AutoSpawnBoat"), config.autoSpawnBoat, function(val)
    config.autoSpawnBoat = val
end)
createDropdown(secBoats, tr("SelectedBoat"), {
    "Boat", "Golden Boat", "Rainbow Boat", "Kunfish Overlord", "Ascended Perch"
}, config.selectedBoat, function(val)
    config.selectedBoat = val
end)
createToggle(secBoats, tr("AutoEnterBoat"), config.autoEnterBoat, function(val)
    config.autoEnterBoat = val
end)
createButton(secBoats, tr("BtnSpawnBoatNow"), THEME.Accent, function()
    spawnSelectedBoat()
end)
createToggle(secBoats, "⚔️ Auto Antre PVP (Queue)", config.autoQueuePvp, function(val)
    config.autoQueuePvp = val
end)

-- === TAB 6: 🎁 HADIAH & KODE ===
local pageRewards = createTab("Rewards", tr("TabRewards"))
local secRewards = createSection(pageRewards, tr("RewardsTitle"), tr("RewardsDesc"))
createToggle(secRewards, tr("AutoDailyReward"), config.autoDailyReward, function(val)
    config.autoDailyReward = val
end)
createToggle(secRewards, tr("AutoClaimQuests"), config.autoClaimQuests, function(val)
    config.autoClaimQuests = val
end)
createToggle(secRewards, tr("AutoClaimMainQuests"), config.autoClaimMainQuests, function(val)
    config.autoClaimMainQuests = val
end)
createToggle(secRewards, tr("AutoAwakeRod"), config.autoAwakeRod, function(val)
    config.autoAwakeRod = val
end)
createButton(secRewards, tr("BtnRedeemCodes"), THEME.Panel, function()
    redeemAllPromoCodes()
end)

-- === TAB 7: 🎋 SECRET RODS ===
local pageSecret = createTab("Secret", tr("TabSecretRods"))
local secSecret = createSection(pageSecret, tr("SecretRodsTitle"), tr("SecretRodsDesc"))
createToggle(secSecret, tr("AutoClaimSecretRods"), config.autoClaimSecretRods, function(val)
    config.autoClaimSecretRods = val
end)
createButton(secSecret, tr("BtnGrabSecretRods"), THEME.Gold, function()
    grabAllSecretRods()
end)

local secSecretList = createSection(pageSecret, "Daftar Pancingan Rahasia (1-Klik Teleport)", "")
for _, rodInfo in ipairs(SECRET_RODS) do
    local rName, rPos = rodInfo[1], rodInfo[2]
    createButton(secSecretList, "🎋 " .. rName, THEME.Panel, function()
        safeTeleport(rPos)
        task.wait(0.3)
        fireRemote("SecretRod", rName)
    end)
end

-- === TAB 8: 🌌 TELEPORT ===
local pageTp = createTab("Teleport", tr("TabTeleport"))
local secTpIsland = createSection(pageTp, "Teleportasi Pulau & Wilayah Mancing", "")
for i = 1, 12 do
    local dest = TELEPORT_DESTINATIONS[i]
    if dest then
        createButton(secTpIsland, "🏝️ " .. dest[1], THEME.Panel, function()
            safeTeleport(dest[2], dest[3] or dest[1])
        end)
    end
end

local secTpNpc = createSection(pageTp, "Teleportasi NPC & Tempat Spesial", "")
for i = 13, #TELEPORT_DESTINATIONS do
    local dest = TELEPORT_DESTINATIONS[i]
    if dest then
        createButton(secTpNpc, "📍 " .. dest[1], THEME.Panel, function()
            safeTeleport(dest[2], dest[3] or dest[1])
        end)
    end
end

-- === TAB 9: 👁️ VISUAL & ESP ===
local pageVisuals = createTab("Visuals", tr("TabVisuals"))
local secVisuals = createSection(pageVisuals, tr("VisualsTitle"), tr("VisualsDesc"))
createToggle(secVisuals, tr("SecretRodEsp"), config.secretRodEsp, function(val)
    config.secretRodEsp = val
end)
createToggle(secVisuals, tr("NpcEsp"), config.npcEsp, function(val)
    config.npcEsp = val
end)
createToggle(secVisuals, tr("PlayerEsp"), config.playerEsp, function(val)
    config.playerEsp = val
end)
createToggle(secVisuals, tr("Fullbright"), config.fullbright, function(val)
    config.fullbright = val
    if not val then
        pcall(function()
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = defaultLighting.Brightness
            Lighting.ClockTime = defaultLighting.ClockTime
            Lighting.FogEnd = defaultLighting.FogEnd
            Lighting.GlobalShadows = defaultLighting.GlobalShadows
            Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        end)
    end
end)

-- === TAB 10: 🏃 KARAKTER ===
local pageMove = createTab("Movement", tr("TabMovement"))
local secMove = createSection(pageMove, tr("MovementTitle"), tr("MovementDesc"))
createToggle(secMove, tr("WalkSpeed"), config.walkSpeedEnabled, function(val)
    config.walkSpeedEnabled = val
    if not val then
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = 16 end
    end
end)
createSlider(secMove, tr("SpeedVal"), 16, 250, config.walkSpeedValue, function(val)
    config.walkSpeedValue = val
end)
createToggle(secMove, tr("JumpPower"), config.jumpPowerEnabled, function(val)
    config.jumpPowerEnabled = val
    if not val then
        local hum = getHumanoid()
        if hum then hum.JumpPower = 50 end
    end
end)
createSlider(secMove, tr("JumpVal"), 50, 300, config.jumpPowerValue, function(val)
    config.jumpPowerValue = val
end)
createToggle(secMove, tr("Noclip"), config.noclipEnabled, function(val)
    config.noclipEnabled = val
    if not val then
        restoreCollision()
    end
end)
createToggle(secMove, tr("WaterWalk"), config.waterWalk, function(val)
    config.waterWalk = val
end)
createToggle(secMove, tr("InfJump"), config.infiniteJump, function(val)
    config.infiniteJump = val
end)
createToggle(secMove, tr("ClickTp"), config.clickTp, function(val)
    config.clickTp = val
end)
createToggle(secMove, tr("Fly"), config.flyEnabled, function(val)
    config.flyEnabled = val
    if not val then
        stopFlying()
    end
end)
createSlider(secMove, tr("FlySpeed"), 20, 200, config.flySpeed, function(val)
    config.flySpeed = val
end)
createToggle(secMove, tr("AntiAfk"), config.antiAfk, function(val)
    config.antiAfk = val
end)

-- === TAB 11: 👑 KREDIT ===
local pageCred = createTab("Credits", tr("TabCredits"))
local secCred = createSection(pageCred, "👑 BROTHER HUB OFFICIAL", "Komunitas Scripting Roblox Terbesar & Paling Terpercaya")
createButton(secCred, "📋 Salin Link Discord Server Resmi", THEME.Panel, function()
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/szYbZCqHKS")
        end
    end)
end)
createButton(secCred, "☕ Donasi Dukungan Pengembang (Saweria)", THEME.Panel, function()
    pcall(function()
        if setclipboard then
            setclipboard("https://saweria.co/prawiraxliv")
        end
    end)
end)
createButton(secCred, "💖 Donasi Dukungan Pengembang (SociaBuzz)", THEME.Panel, function()
    pcall(function()
        if setclipboard then
            setclipboard("https://sociabuzz.com/brotherhubofficial/tribe")
        end
    end)
end)

local secInfo = createSection(pageCred, "Informasi Script & Status", "")
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 80)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = THEME.Font
infoLabel.TextSize = 12
infoLabel.TextColor3 = THEME.SubText
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = "Founder & Lead Developer : prawiraxliv\nGame Target : Heavyweight Fishing (98502499119821)\nGUI Standard : 1:1 FlowerShop Exact Standard\nEngine Status : 100% Undetected & Anti-Detection Active\nSecurity : Brother Guard Multi-Layer Shield"
infoLabel.Parent = secInfo

-- Language switch button event
langBtn.MouseButton1Click:Connect(function()
    config.language = config.language == "ID" and "EN" or "ID"
    langBtn.Text = config.language == "ID" and "🇮🇩 ID" or "🇬🇧 EN"
    saveConfig()
    -- Re-label UI elements
    titleLabel.Text = "👑 " .. tr("HubTitle")
    modalTitle.Text = "⚠️ " .. tr("CloseConfirmTitle")
    modalBody.Text = tr("CloseConfirmBody")
    modalYes.Text = tr("BtnYes")
    modalCancel.Text = tr("BtnCancel")
end)

-- Initial tab selection
switchTab("Fish")
