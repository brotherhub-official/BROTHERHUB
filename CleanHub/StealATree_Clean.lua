--[[
    ========================================================================
    👑 BROTHER HUB — STEAL A TREE OFFICIAL MASTER SUITE
    ========================================================================
    Game        : Steal A Tree
    Game URL    : https://www.roblox.com/games/132958491990446/Steal-A-Tree
    Place ID    : 132958491990446
    Design Tier : 1:1 FlowerShop Master Standard (RGB Neon Stroke, MinCircle 80x80, Resizable Frame)
    Platform    : Universal (Xeno PC, Solara, Wave, Delta / Arceus / Codex Mobile)
    Language    : Bilingual Smart Engine (🇮🇩 ID / 🇬🇧 EN Auto-Detect & Toggle)
    Features    : Auto Steal Saplings (Instant Prompt / Proximity Bypass),
                  Auto Steal Rival Planted Trees (Player Plot Rob / Heist),
                  Auto Plant & Garden Farm, Auto Instant Skip Growth (Speed up 5h),
                  Auto AFK Treadmill Jump & Speed Farmer,
                  Auto Gear Shop & Merchant Purchases (100% Zero Robux Guarantee),
                  Auto Open Tree Packs, Auto Hatch & Equip Best Pets,
                  Auto Claim Daily & Playtime Rewards & Quests & Redeem Codes,
                  World & Plot Teleport Hub, Visual Radar ESP,
                  Movement Engine (Speed, Jump, Noclip, Fly, InfJump, ClickTP).
    Security    : Brother Guard Undetected Engine
    ========================================================================
]]

-- [0] MULTI-INSTANCE CLEANUP GUARD (TRIPLE-LAYER ZERO STACKING)
if _G.BH_STEALATREE_CLEANUP then
    pcall(_G.BH_STEALATREE_CLEANUP)
    _G.BH_STEALATREE_CLEANUP = nil
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
            if child.Name == "BrotherHub_StealATree" then
                pcall(function() child:Destroy() end)
            end
        end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "BH_SafeLandingPad" or obj.Name == "BH_TreePlatform" then
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

-- [1.5] 🎯 SAPLING SPAWN TARGETS & WORLD CORRIDOR LOCATIONS
local SAPLING_AREAS = {
    ["Clockwork Sapling (Z: -8150 • Zona Terakhir!)"] = { pos = Vector3.new(-261.3, 35.7, -8150.0), name = "Clockwork", area = "Clockwork", tier = 14 },
    ["Void Sapling (Z: -5084 • Celestial)"]           = { pos = Vector3.new(-301.7, 16.0, -5084.6), name = "Void", area = "Void", tier = 13 },
    ["Cosmic Sapling (Z: -4615 • Ultra Rare)"]        = { pos = Vector3.new(-238.0, 14.2, -4615.2), name = "Cosmic", area = "Cosmic", tier = 12 },
    ["Skylands Sapling (Z: -3466 • Mythic)"]          = { pos = Vector3.new(-198.9, 14.2, -3466.8), name = "Skylands", area = "Skylands", tier = 11 },
    ["Candyland Sapling (Z: -3049 • Legendary)"]      = { pos = Vector3.new(-353.4, 14.3, -3049.8), name = "Candyland", area = "Candyland", tier = 10 },
    ["Frozen Sapling (Z: -2465 • Epic)"]              = { pos = Vector3.new(-311.5, 14.3, -2465.7), name = "Frozen", area = "Frozen", tier = 9 },
    ["Crystal Cavern Sapling (Z: -2399 • Rare)"]      = { pos = Vector3.new(-234.5, 22.0, -2399.6), name = "Crystal Cavern", area = "Crystal Cavern", tier = 8 },
    ["Volcano Sapling (Z: -2145 • Epic)"]             = { pos = Vector3.new(-289.3, 32.8, -2145.8), name = "Volcano", area = "Volcano", tier = 7 },
    ["Desert Sapling (Z: -2008 • Rare)"]              = { pos = Vector3.new(-335.1, 14.3, -2008.6), name = "Desert", area = "Desert", tier = 6 },
    ["Abyssal Sea Sapling (Z: -1618 • Uncommon)"]     = { pos = Vector3.new(-362.8, 18.9, -1618.2), name = "Abyssal Sea", area = "Abysall Sea", tier = 5 },
    ["Beach Sapling (Z: -1191 • Uncommon)"]           = { pos = Vector3.new(-262.1, 14.3, -1191.5), name = "Beach", area = "Beach", tier = 4 },
    ["Forest Sapling (Z: -971 • Common)"]             = { pos = Vector3.new(-292.5, 14.8, -971.9), name = "Forest", area = "Forest", tier = 3 },
    ["Flowerfield Sapling (Z: -596 • Starter)"]        = { pos = Vector3.new(-255.2, 14.3, -596.4), name = "Flowerfield", area = "Flowerfield", tier = 2 },
    ["Plains Sapling (Z: -247 • Starter)"]            = { pos = Vector3.new(-202.4, 15.0, -247.5), name = "Plains", area = "Plains", tier = 1 },
}

-- [1.6] 🌟 ALL STEALABLE TREES (URUTAN DARI PALING DEPAN / TERJAUH KE DEKAT • 1:1 STEAL A SEED STANDAR)
local ALL_STEALABLE_TREES = {
    -- 5 POHON PALING DEPAN RESMI FOUNDER (CLOCKWORK, VOID, COSMIC, SKYLANDS, CANDYLAND)
    { key = "Clockwork",     displayName = "👑 Clockwork Sapling (Paling Depan • Z: -8150)", area = "Clockwork", pattern = "clockwork", z = -8150.0, pos = Vector3.new(-261.3, 35.7, -8150.0) },
    { key = "Void",          displayName = "👑 Void Sapling (Paling Depan • Z: -5084)",      area = "Void",      pattern = "void",      z = -5084.6, pos = Vector3.new(-301.7, 16.0, -5084.6) },
    { key = "Cosmic",        displayName = "👑 Cosmic Sapling (Paling Depan • Z: -4615)",    area = "Cosmic",    pattern = "cosmic",    z = -4615.2, pos = Vector3.new(-238.0, 14.2, -4615.2) },
    { key = "Skylands",      displayName = "👑 Skylands Sapling (Paling Depan • Z: -3466)",  area = "Skylands",  pattern = "skyland",   z = -3466.8, pos = Vector3.new(-198.9, 14.2, -3466.8) },
    { key = "Candyland",     displayName = "👑 Candyland Sapling (Paling Depan • Z: -3049)", area = "Candyland", pattern = "candy",     z = -3049.8, pos = Vector3.new(-353.4, 14.3, -3049.8) },

    -- ZONA POHON BERIKUTNYA DI WORLD CORRIDOR
    { key = "Frozen",        displayName = "❄️ Frozen Sapling (Z: -2465)",                  area = "Frozen",    pattern = "frozen",    z = -2465.7, pos = Vector3.new(-311.5, 14.3, -2465.7) },
    { key = "Crystal Cavern",displayName = "💎 Crystal Cavern Sapling (Z: -2399)",          area = "Crystal Cavern", pattern = "crystal", z = -2399.6, pos = Vector3.new(-234.5, 22.0, -2399.6) },
    { key = "Volcano",       displayName = "🌋 Volcano Sapling (Z: -2145)",                 area = "Volcano",   pattern = "volcano",   z = -2145.8, pos = Vector3.new(-289.3, 32.8, -2145.8) },
    { key = "Desert",        displayName = "🏜️ Desert Sapling (Z: -2008)",                  area = "Desert",    pattern = "desert",    z = -2008.6, pos = Vector3.new(-335.1, 14.3, -2008.6) },
    { key = "Abyssal Sea",   displayName = "🌊 Abyssal Sea Sapling (Z: -1618)",             area = "Abysall Sea", pattern = "abys",   z = -1618.2, pos = Vector3.new(-362.8, 18.9, -1618.2) },
    { key = "Beach",         displayName = "🏖️ Beach Sapling (Z: -1191)",                   area = "Beach",     pattern = "beach",     z = -1191.5, pos = Vector3.new(-262.1, 14.3, -1191.5) },
    { key = "Forest",        displayName = "🌲 Forest Sapling (Z: -971)",                   area = "Forest",    pattern = "forest",    z = -971.9,  pos = Vector3.new(-292.5, 14.8, -971.9) },
    { key = "Flowerfield",   displayName = "🌸 Flowerfield Sapling (Z: -596)",              area = "Flowerfield", pattern = "flower",  z = -596.4,  pos = Vector3.new(-255.2, 14.3, -596.4) },
    { key = "Plains",        displayName = "🌱 Plains Sapling (Z: -247)",                   area = "Plains",    pattern = "plain",     z = -247.5,  pos = Vector3.new(-202.4, 15.0, -247.5) },
}

local TOP5_TREES = { "Clockwork", "Void", "Cosmic", "Skylands", "Candyland" }

local function getTreeKeyList()
    local list = {}
    for _, t in ipairs(ALL_STEALABLE_TREES) do
        table.insert(list, t.key)
    end
    return list
end

local function getTreeDisplayLabel(k)
    for _, t in ipairs(ALL_STEALABLE_TREES) do
        if t.key == k or t.displayName == k then return t.displayName end
    end
    return tostring(k)
end

local TYCOON_LOCATIONS = {
    ["Tycoon 1 (Plot 1)"] = Vector3.new(-547.5, 39.2, -35.0),
    ["Tycoon 2 (Plot 2)"] = Vector3.new(35.5, 41.5, 26.5),
    ["Tycoon 3 (Plot 3)"] = Vector3.new(-377.3, 41.5, 161.8),
    ["Tycoon 4 (Plot 4)"] = Vector3.new(-283.8, 41.5, 161.8),
    ["Tycoon 5 (Plot 5)"] = Vector3.new(-190.3, 41.5, 161.8),
    ["Tycoon 6 (Plot 6)"] = Vector3.new(-176.3, 42.5, 148.7),
}

local SHOP_LOCATIONS = {
    ["Merchant Shop"]  = Vector3.new(-203.0, 21.2, -94.9),
    ["Trail Shop"]     = Vector3.new(-381.8, 19.8, -83.3),
    ["Pet Shop"]       = Vector3.new(-415.6, 15.5, -81.3),
    ["Plot Spawns"]    = Vector3.new(-234.8, 16.1, 51.0),
}

-- [2] BILINGUAL SYSTEM (🇮🇩 INDONESIAN & 🇬🇧 ENGLISH)
local function getClientLanguage()
    local code = "en"
    pcall(function() code = string.lower(LocalizationService.RobloxLocaleId) end)
    if string.find(code, "id") or string.find(code, "in") then return "ID" end
    return "EN"
end

local I18N = {
    ID = {
        HubTitle             = "BROTHER HUB — STEAL A TREE",
        TabAutoSteal         = "🌟 Auto Steal",
        TabGardenFarm        = "🌱 Kebun Sendiri",
        TabSpeedTrain        = "🏃 Kecepatan & Latihan",
        TabShopUpgrade       = "🏪 Toko & Upgrade",
        TabPetRewards        = "🐾 Pet & Hadiah",
        TabTeleport          = "🌌 Teleport Hub",
        TabVisualESP         = "👁️ Visual & ESP",
        TabMovement          = "⚡ Pergerakan",
        TabCredit            = "👑 Credit & Donasi",

        -- Auto Steal Tab
        SecStealSapling      = "PENCURIAN BIBIT DI ARENA (WORLD CORRIDOR)",
        AutoStealSaplings    = "Auto Curi Bibit di Seluruh Arena",
        StealMethod          = "Metode Curi (Instant / Teleport)",
        TargetAreasDropdown  = "Pilih Area Bibit Target (Multi-Select)",
        SmartReturnPlot      = "Kembali ke Kebun Sendiri Setelah Curi",
        SecStealRivalTrees   = "PERAMPOKAN POHON PEMAIN LAIN (RIVAL PLOT HEIST)",
        AutoStealRivalTrees  = "Auto Curi Pohon Matang Pemain Lain",
        ProtectFriends       = "Abaikan Plot Sendiri & Teman",
        AutoDisarmTraps      = "Auto Ambil & Lucuti Jebakan Musuh (Bear Trap)",

        -- Garden Farm Tab
        SecGardenPlant       = "PENANAMAN & PERAWATAN KEBUN SENDIRI",
        AutoPlantGarden      = "Auto Tanam Bibit di Kebun Sendiri",
        AutoSkipGrowth       = "Auto Skip Tumbuh 5 Jam (Instant Panen)",
        AutoHarvestTrees     = "Auto Petik Bibit & Pohon Matang",
        AutoJuicer           = "Auto Masukkan Buah ke Juicer",
        SecPlotUpgrades      = "UPGRADE AREA KEBUN & KAPASITAS",
        AutoExpandPlot       = "Auto Beli Perluasan Kebun (Expand Plot)",
        AutoUpgradeJuicer    = "Auto Beli Upgrade Juicer Mixer",

        -- Speed & Training Tab
        SecTreadmill         = "LATIHAN TREADMILL (AFK SPEED BOOSTER)",
        AutoTreadmillJump    = "Auto Jump Treadmill (Spam Speed Points)",
        AutoTreadmillGain    = "Auto Klaim Peningkatan Speed Treadmill",
        SecMinigames         = "BANTUAN MINIGAME & BOS",
        AutoSanzBattleGod    = "Auto Menang Sanz Battle (Melayang Aman)",
        AutoDiscoMania       = "Auto Bantuan Disco Mania & Balapan",

        -- Shop & Upgrades Tab
        SecGearShop          = "TOKO ALAT & PERLENGKAPAN (100% BEBAS ROBUX)",
        AutoBuyGear          = "Auto Beli Alat di Gear Shop",
        TargetGearItems      = "Pilih Barang yang Mau Dibeli (Filter)",
        AutoBuyMerchant      = "Auto Beli Barang Langka Merchant",
        AutoBuyTicketMarket  = "Auto Borong Penawaran Tiket (Ticket Market)",
        BlockRobux           = "Blokir Pop-up Robux (Jaminan 100% Gratis)",

        -- Pet & Rewards Tab
        SecEggs              = "PENETASAN TELUR & HEWAN PELIHARAAN",
        AutoHatchEgg         = "Auto Beli & Tetaskan Telur Pet",
        AutoEquipBest        = "Auto Pasang Pet Terbaik (Equip Best)",
        AutoOpenPacks        = "Auto Buka Pack Pohon (Tree Packs)",
        SecDailyQuests       = "KLAIM HADIAH, QUEST & KODE",
        AutoClaimDaily       = "Auto Klaim Hadiah Harian (Day 1-7)",
        AutoClaimPlaytime    = "Auto Klaim Hadiah Waktu Bermain",
        AutoClaimQuests      = "Auto Selesaikan & Klaim Quest",
        AutoRedeemCodes      = "Auto Tukar Seluruh Kode Promo Aktif",

        -- Teleport Tab
        SecPlotTP            = "TELEPORT KEBUN & MARKAS",
        TPHomePlot           = "Teleport ke Kebun Sendiri",
        SecAreaTP            = "TELEPORT KE 14 ZONA BIBIT POHON (TERLENGKAP)",
        TPWalk               = "TP-Walk (Speed Bypass Bebas Reset Base)",
        TPWalkSpeed          = "Kecepatan TP-Walk (Bypass Speed)",
        SafeSpeedNotice      = "WalkSpeed (Aman: 16-55 | >60 Bisa Reset Server)",
        HarvestNotice        = "Auto Panen Pohon Kebun Sendiri (100% Masuk Tas)",
        StealAllAreas        = "Filter Seluruh 14 Zona Bibit (Clockwork .. Plains)",
        AreaLastZoneNotice   = "Zona Terakhir: Clockwork / Lost World (Z: -8150)", 
        SecShopTP            = "TELEPORT KE TOKO & TIKET",

        -- Visual & ESP Tab
        SecRadar             = "MATA ELANG (RADAR VISUAL & HIGHLIGHT)",
        SaplingESP           = "ESP Bibit di Arena (Nama & Jarak)",
        RivalTreeESP         = "ESP Pohon yang Bisa Dicuri (Rival Plots)",
        PlayerESP            = "ESP Pemain Lain (Nama & Jarak)",
        TrapESP              = "ESP Jebakan Bear Trap Berbahaya",
        Fullbright           = "Fullbright (Penerangan Total Tanpa Gelap)",

        -- Movement Tab
        SecMove              = "PENGATUR KECEPATAN & KEMAMPUAN FISIK",
        WalkSpeed            = "Kecepatan Jalan (WalkSpeed)",
        JumpPower            = "Daya Lompat (JumpPower)",
        Noclip               = "Noclip (Tembus Dinding & Pagar)",
        Fly                  = "Terbang Bebas (Fly Engine)",
        InfJump              = "Lompat Tanpa Batas (Infinite Jump)",
        ClickTP              = "Alat Teleport Klik (Click TP Tool)",
        AntiAfk              = "Anti-AFK (Bebas Disconnect 20 Menit)",

        -- Dialogs
        ConfirmCloseTitle    = "Konfirmasi Tutup Script",
        ConfirmCloseMsg      = "Apakah Anda yakin ingin mematikan Brother Hub?",
        BtnYes               = "Ya, Matikan",
        BtnCancel            = "Batal",
        LangToggle           = "Ganti Bahasa (ID / EN)",
    },
    EN = {
        HubTitle             = "BROTHER HUB — STEAL A TREE",
        TabAutoSteal         = "🌟 Auto Steal",
        TabGardenFarm        = "🌱 Own Garden",
        TabSpeedTrain        = "🏃 Speed & Training",
        TabShopUpgrade       = "🏪 Shop & Upgrade",
        TabPetRewards        = "🐾 Pets & Gifts",
        TabTeleport          = "🌌 Teleport Hub",
        TabVisualESP         = "👁️ Visual & ESP",
        TabMovement          = "⚡ Movement",
        TabCredit            = "👑 Credit & Donate",

        -- Auto Steal Tab
        SecStealSapling      = "ARENA SAPLING HEIST (WORLD CORRIDOR)",
        AutoStealSaplings    = "Auto Steal Arena Saplings (Bypass Prompt)",
        StealMethod          = "Steal Mode (Instant / Teleport)",
        TargetAreasDropdown  = "Select Target Sapling Areas (Multi-Select)",
        SmartReturnPlot      = "Return to Own Farm After Stealing",
        SecStealRivalTrees   = "RIVAL PLOT TREE HEIST (STEAL MATURE TREES)",
        AutoStealRivalTrees  = "Auto Steal Trees From Rival Players",
        ProtectFriends       = "Ignore Own Plot & Friends",
        AutoDisarmTraps      = "Auto Disarm Rival Traps (Bear Trap)",

        -- Garden Farm Tab
        SecGardenPlant       = "OWN GARDEN PLANTING & NURTURING",
        AutoPlantGarden      = "Auto Plant Sapling in Own Plot",
        AutoSkipGrowth       = "Auto Skip 5 Hours Growth (Instant Harvest)",
        AutoHarvestTrees     = "Auto Harvest Mature Saplings & Trees",
        AutoJuicer           = "Auto Deposit Fruit into Juicer",
        SecPlotUpgrades      = "PLOT EXPANSION & CAPACITY UPGRADES",
        AutoExpandPlot       = "Auto Expand Plot Territory",
        AutoUpgradeJuicer    = "Auto Upgrade Juicer Mixer",

        -- Speed & Training Tab
        SecTreadmill         = "TREADMILL TRAINING (AFK SPEED BOOSTER)",
        AutoTreadmillJump    = "Auto Treadmill Jump (Spam Speed Points)",
        AutoTreadmillGain    = "Auto Claim Treadmill Speed Gain",
        SecMinigames         = "MINIGAME ASSISTANTS & BOSSES",
        AutoSanzBattleGod    = "Auto Win Sanz Battle (Safe Hover)",
        AutoDiscoMania       = "Auto Assist Disco Mania & Races",

        -- Shop & Upgrades Tab
        SecGearShop          = "GEAR & TOOL SHOP (100% ZERO ROBUX GUARANTEE)",
        AutoBuyGear          = "Auto Buy Gear from Gear Shop",
        TargetGearItems      = "Select Items to Buy (Multi-Select)",
        AutoBuyMerchant      = "Auto Buy Rare Merchant Items",
        AutoBuyTicketMarket  = "Auto Buy Ticket Market Offers",
        BlockRobux           = "Block Robux Popups (Full Free Guarantee)",

        -- Pet & Rewards Tab
        SecEggs              = "EGG HATCHING & PET COMPANIONS",
        AutoHatchEgg         = "Auto Buy & Hatch Pet Eggs",
        AutoEquipBest        = "Auto Equip Best Pets",
        AutoOpenPacks        = "Auto Open Tree Packs",
        SecDailyQuests       = "CLAIM REWARDS, QUESTS & PROMO CODES",
        AutoClaimDaily       = "Auto Claim Daily Rewards (Day 1-7)",
        AutoClaimPlaytime    = "Auto Claim Playtime Rewards",
        AutoClaimQuests      = "Auto Complete & Claim Quests",
        AutoRedeemCodes      = "Auto Redeem All Active Promo Codes",

        -- Teleport Tab
        SecPlotTP            = "FARM & PLOT TELEPORT",
        TPHomePlot           = "Teleport to Own Farm",
        SecAreaTP            = "TELEPORT TO ALL 14 SAPLING ZONES (COMPLETE)",
        TPWalk               = "TP-Walk (Speed Bypass No Base Reset)",
        TPWalkSpeed          = "TP-Walk Speed (Bypass Speed)",
        SafeSpeedNotice      = "WalkSpeed (Safe: 16-55 | >60 Triggers Base Reset)",
        HarvestNotice        = "Auto Harvest Own Garden Trees (Guaranteed Pickup)",
        StealAllAreas        = "Filter All 14 Sapling Zones (Clockwork .. Plains)",
        AreaLastZoneNotice   = "Last Zone: Clockwork / Lost World (Z: -8150)", 
        SecShopTP            = "TELEPORT TO SHOPS & MARKETS",

        -- Visual & ESP Tab
        SecRadar             = "EAGLE EYE (VISUAL RADAR & HIGHLIGHTS)",
        SaplingESP           = "Arena Sapling ESP (Name & Distance)",
        RivalTreeESP         = "Rival Claimable Tree ESP",
        PlayerESP            = "Player ESP (Name & Distance)",
        TrapESP              = "Bear Trap Danger ESP",
        Fullbright           = "Fullbright (Maximum Vision No Darkness)",

        -- Movement Tab
        SecMove              = "PHYSICAL MOVEMENT & UTILITIES",
        WalkSpeed            = "WalkSpeed Multiplier",
        JumpPower            = "JumpPower Multiplier",
        Noclip               = "Noclip (Walk Through Walls)",
        Fly                  = "Free Flight Engine",
        InfJump              = "Infinite Jump",
        ClickTP              = "Click Teleport Tool",
        AntiAfk              = "Anti-AFK (Bypass 20 Min Idle Kick)",

        -- Dialogs
        ConfirmCloseTitle    = "Confirm Close Script",
        ConfirmCloseMsg      = "Are you sure you want to exit Brother Hub?",
        BtnYes               = "Yes, Exit",
        BtnCancel            = "Cancel",
        LangToggle           = "Change Language (ID / EN)",
    }
}

local currentLang = getClientLanguage()
local function tr(key)
    local dict = I18N[currentLang] or I18N.ID
    return dict[key] or key
end

-- [3] CONFIGURATION STATE
local CONFIG_FILE = "BrotherHub_StealATree_Config.json"
local config = {
    language              = currentLang,
    guiScale              = 1.0,

    -- Auto Steal Saplings (Standar 1:1 Steal A Seed)
    autoStealSaplings     = false,
    stealMethod           = "Teleport",
    smartReturnPlot       = true,
    instantPrompt         = true,
    only5FrontSaplings    = true, -- Default HANYA 5 Pohon Paling Depan (Clockwork, Void, Cosmic, Skylands, Candyland)
    multiTargetTrees      = {
        ["Clockwork"]     = true,
        ["Void"]          = true,
        ["Cosmic"]        = true,
        ["Skylands"]      = true,
        ["Candyland"]     = true,
        ["Frozen"]        = false,
        ["Crystal Cavern"]= false,
        ["Volcano"]       = false,
        ["Desert"]        = false,
        ["Abyssal Sea"]   = false,
        ["Beach"]         = false,
        ["Forest"]        = false,
        ["Flowerfield"]   = false,
        ["Plains"]        = false,
    },
    targetSaplingAreas    = {
        ["Clockwork"]     = true,
        ["Void"]          = true,
        ["Cosmic"]        = true,
        ["Skylands"]      = true,
        ["Candyland"]     = true,
        ["Frozen"]        = true,
        ["Crystal Cavern"]= true,
        ["Volcano"]       = true,
        ["Desert"]        = true,
        ["Abysall Sea"]   = true,
        ["Beach"]         = true,
        ["Forest"]        = true,
        ["Flowerfield"]   = true,
        ["Plains"]        = true,
    },

    -- Auto Steal Rival Trees
    autoStealRivalTrees   = false,
    protectFriends        = true,
    autoDisarmTraps       = true,

    -- Garden & Farm
    autoPlantGarden       = true,
    autoSkipGrowth        = true,
    autoHarvestTrees      = true,
    autoJuicer            = true,
    autoExpandPlot        = false,
    autoUpgradeJuicer     = false,

    -- Speed & Training
    autoTreadmillJump     = false,
    autoTreadmillGain     = false,
    autoSanzBattleGod     = false,
    autoDiscoMania        = false,

    -- Shop & Purchases (100% Free)
    autoBuyGear           = false,
    targetGears           = {
        ["Watering Can"]        = false,
        ["Watering Can Rare"]   = false,
        ["Watering Can Royal"]  = false,
        ["Watering Can Gilded"] = false,
        ["Watering Can Mythic"] = false,
        ["FertilizerC"]         = false,
        ["FertilizerR"]         = false,
        ["FertilizerE"]         = false,
        ["RoyalFertilizer"]     = false,
        ["BigMutationSpray"]    = false,
        ["GoldenMutationSpray"] = false,
        ["BearTrapTool"]        = false,
        ["Bat"]                 = false,
        ["Shovel"]              = false,
    },
    autoBuyMerchant       = false,
    autoBuyTicketMarket   = false,
    blockRobux            = true,

    -- Pets & Rewards
    autoHatchEgg          = false,
    autoEquipBest         = true,
    autoOpenPacks         = false,
    autoClaimDaily        = true,
    autoClaimPlaytime     = true,
    autoClaimQuests       = true,
    autoRedeemCodes       = false,

    -- Visuals
    saplingESP            = false,
    rivalTreeESP          = false,
    playerESP             = false,
    trapESP               = false,
    fullbright            = false,

    -- Movement
    walkSpeedEnabled      = false,
    walkSpeedValue        = 35,
    tpWalk                = false,
    tpWalkSpeed           = 75,
    jumpPowerEnabled      = false,
    jumpPowerValue        = 75,
    noclip                = false,
    fly                   = false,
    flySpeed              = 50,
    infJump               = false,
    antiAfk               = true,
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
                    if type(v) == "table" and type(config[k]) == "table" then
                        for subK, subV in pairs(v) do config[k][subK] = subV end
                    else
                        config[k] = v
                    end
                end
            end
        end
    end)
end
loadConfig()
currentLang = config.language or currentLang

-- [4] HELPER UTILITIES & ROBUST PROMPT ENGINE
local function getRoot(char)
    char = char or (LocalPlayer and LocalPlayer.Character)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getHum(char)
    char = char or (LocalPlayer and LocalPlayer.Character)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function safeTeleport(cframeOrVec)
    local char = LocalPlayer.Character
    local root = getRoot(char)
    if not root or not char then return end
    local targetCF = typeof(cframeOrVec) == "Vector3" and CFrame.new(cframeOrVec) or cframeOrVec
    if not targetCF then return end
    local p = targetCF.Position
    if p.X ~= p.X or p.Y ~= p.Y or p.Z ~= p.Z then return end -- NaN protection

    local currentPos = root.Position
    local dist = (p - currentPos).Magnitude

    -- Nonaktifkan CanCollide agar karakter meluncur mulus tanpa terbentur dinding/gapura
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    if dist > 80 then
        -- Interpolasi cepat di sepanjang lintasan koridor di ketinggian tanah yang wajar
        -- (DILARANG terbang tinggi ke langit Y=39 karena memicu boundary reset server!)
        local stepDist = 70
        local steps = math.clamp(math.ceil(dist / stepDist), 3, 35)
        for i = 1, steps do
            local alpha = i / steps
            local interPos = currentPos:Lerp(p, alpha)
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = CFrame.new(interPos, p)
            end)
            task.wait(0.012)
        end
    end

    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = targetCF
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    task.wait(0.08)
end

-- [4.3] ⚡ ZERO-LAG INSTANT PROXIMITY PROMPT ENGINE (100% NATIVE EVENT-DRIVEN)
local ProximityPromptService = game:GetService("ProximityPromptService")
local function makePromptInstant(p)
    if p and p:IsA("ProximityPrompt") then
        -- JANGAN PERNAH MENGUBAH HoldDuration UNTUK PROMPT BIBIT!
        -- Server Roblox Steal A Tree memverifikasi durasi hold 1.0s. Jika di-set 0 di client,
        -- server akan mendeteksi packet trigger instan dan MENOLAKNYA (rejected)!
        if p.Name == "CollectSaplingPrompt" or string.find(p.Name, "Sapling") or (p.Parent and string.find(p.Parent.Name, "Sapling")) then
            pcall(function()
                p.MaxActivationDistance = 25
                p.RequiresLineOfSight = false
            end)
            return
        end
        pcall(function()
            p.HoldDuration = 0
            p.MaxActivationDistance = 35
            p.RequiresLineOfSight = false
        end)
    end
end

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

-- Teleport ke Plot Sendiri Resmi Server
-- Cek apakah instance berada di dalam plot / kebun pemain (100% Proteksi Plot)
local function isModelInAnyPlot(m)
    if not m then return true end
    local skriptF = workspace:FindFirstChild("SkriptF")
    local plots = (skriptF and skriptF:FindFirstChild("Plots")) or workspace:FindFirstChild("Plots")
    if plots and m:IsDescendantOf(plots) then
        return true
    end
    if m:FindFirstAncestor("Plots") or m:FindFirstAncestor("PlotSkriptF") or m:FindFirstAncestor("PlantedTreeRuntime") or m:FindFirstAncestor("GrowLocation") then
        return true
    end
    return false
end

-- Deteksi Tycoon / Kebun Milik Pemain Sendiri Secara Dinamis
local function getOwnPlot()
    local skriptF = workspace:FindFirstChild("SkriptF")
    local plots = (skriptF and skriptF:FindFirstChild("Plots")) or workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local char = LocalPlayer.Character
    local root = getRoot(char)

    for _, tycoon in ipairs(plots:GetChildren()) do
        local ownerVal = tycoon:FindFirstChild("Owner") or tycoon:FindFirstChild("OwnerValue")
        if ownerVal and (ownerVal.Value == LocalPlayer or ownerVal.Value == LocalPlayer.Name or ownerVal.Value == LocalPlayer.UserId) then
            return tycoon
        end
        local ownerAttr = tycoon:GetAttribute("Owner") or tycoon:GetAttribute("OwnerUserId") or tycoon:GetAttribute("OwnerName")
        if ownerAttr == LocalPlayer.Name or ownerAttr == LocalPlayer.UserId then
            return tycoon
        end
    end

    -- Fallback: Tycoon terdekat dari posisi saat ini (jika baru kembali ke base)
    if root then
        local bestTycoon = nil
        local bestDist = 70
        for _, tycoon in ipairs(plots:GetChildren()) do
            local pPart = tycoon.PrimaryPart or tycoon:FindFirstChildWhichIsA("BasePart") or tycoon:GetPivot()
            local pPos = typeof(pPart) == "CFrame" and pPart.Position or (pPart and pPart.Position)
            if pPos then
                local d = (pPos - root.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    bestTycoon = tycoon
                end
            end
        end
        if bestTycoon then return bestTycoon end
    end
    return nil
end

-- Teleport ke Plot Sendiri Resmi Server
local function returnToOwnPlot()
    local done = false
    pcall(function()
        local tpRemote = ReplicatedStorage:FindFirstChild("RequestFarmTeleport")
        if tpRemote and tpRemote:IsA("RemoteEvent") then
            tpRemote:FireServer()
            done = true
        end
    end)
    if not done then
        local own = getOwnPlot()
        if own then
            local cf = own:GetPivot()
            safeTeleport(cf.Position + Vector3.new(0, 3, 0))
        else
            safeTeleport(TYCOON_LOCATIONS["Tycoon 1 (Plot 1)"] + Vector3.new(0, 3, 0))
        end
    end
end

-- Deteksi apakah pemain sedang membawa bibit (Carried Sapling)
local function isPlayerCarryingSapling()
    local char = LocalPlayer.Character
    if not char then return false end

    -- 1. INDIKATOR RESMI RESMI GAME STEAL A TREE: Tombol Drop di MainGuis
    -- Di Steal A Tree, tombol Drop (TextButton) di MainGuis hanya Visible == true saat pemain sedang membawa bibit!
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        local dropBtn = pGui:FindFirstChild("Drop", true)
        if dropBtn and dropBtn:IsA("GuiObject") and dropBtn.Visible then
            return true
        end
    end

    -- 2. Cek visual sapling di dalam karakter ATAU di SpawnedSaplings dekat karakter
    if char:FindFirstChild("_CarriedSaplingVisual", true) then return true end
    for _, c in ipairs(char:GetChildren()) do
        if c.Name == "_CarriedSaplingVisual" then return true end
        local cName = c.Name:lower()
        if string.find(cName, "sapling") and not string.find(cName, "uprooted") and not string.find(cName, "tree") then
            return true
        end
    end
    local wsSpawned = workspace:FindFirstChild("SpawnedSaplings")
    if wsSpawned then
        local r = getRoot(char)
        if r then
            for _, c in ipairs(wsSpawned:GetChildren()) do
                if c.Name == "_CarriedSaplingVisual" then
                    local piv = c:GetPivot()
                    if piv and (piv.Position - r.Position).Magnitude < 12 then
                        return true
                    end
                end
            end
        end
    end

    -- 3. Cek Tool di tangan karakter atau Backpack (Eksklusif Sapling, DILARANG mencocokkan Uprooted Tree!)
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        local tName = tool.Name:lower()
        if string.find(tName, "sapling") and not string.find(tName, "uprooted") and not string.find(tName, "tree") then
            return true
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                local iName = item.Name:lower()
                if string.find(iName, "sapling") and not string.find(iName, "uprooted") and not string.find(iName, "tree") then
                    return true
                end
            end
        end
    end

    -- 4. Cek Attributes pada LocalPlayer & Character
    if char:GetAttribute("CarriedSapling") or char:GetAttribute("HasSapling") or char:GetAttribute("Claimed") then
        return true
    end
    if LocalPlayer:GetAttribute("CarriedSapling") or LocalPlayer:GetAttribute("HasSapling") or LocalPlayer:GetAttribute("HoldingSapling") then
        return true
    end

    return false
end

local function firePrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    if not prompt.Enabled then return false end
    
    local holdDur = prompt.HoldDuration or 0
    local vim = game:GetService("VirtualInputManager")
    
    pcall(function()
        prompt.MaxActivationDistance = 30
        prompt.RequiresLineOfSight = false
    end)
    
    local ok = false
    if typeof(fireproximityprompt) == "function" then
        pcall(function()
            if holdDur > 0.1 then
                fireproximityprompt(prompt, holdDur + 0.1)
            else
                fireproximityprompt(prompt, 0)
            end
            ok = true
        end)
    end
    
    if holdDur <= 0.1 then
        pcall(function()
            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            ok = true
        end)
    else
        pcall(function()
            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(holdDur + 0.2)
            vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            ok = true
        end)
    end
    
    return ok
end

local recentlyTargetedSaplings = {}

-- [5] 🌟 AUTO STEAL SAPLINGS LOGIC (100% WILD ARENA ONLY • BEBAS KEBUN ORANG LAIN)
local function getAllSaplingModels()
    local models = {}
    local seen = {}
    
    local function addModel(m)
        if m and m:IsA("Model") and not seen[m] and m.Name ~= "_CarriedSaplingVisual" then
            -- Verifikasi ketat: DILARANG KERAS menyentuh bibit di dalam plot/kebun orang lain!
            if not isModelInAnyPlot(m) then
                seen[m] = true
                table.insert(models, m)
            end
        end
    end
    
    -- 1. Folder SpawnedSaplings langsung di Workspace (Sumber utama wild saplings arena!)
    local directSpawned = workspace:FindFirstChild("SpawnedSaplings")
    if directSpawned then
        for _, c in ipairs(directSpawned:GetChildren()) do addModel(c) end
    end
    -- 2. Folder _LocalAreaSaplings di Workspace
    local localSaplings = workspace:FindFirstChild("_LocalAreaSaplings")
    if localSaplings then
        for _, c in ipairs(localSaplings:GetChildren()) do addModel(c) end
    end
    -- 3. Folder Saplings di Workspace
    local directSaplings = workspace:FindFirstChild("Saplings")
    if directSaplings then
        for _, c in ipairs(directSaplings:GetChildren()) do addModel(c) end
    end
    -- 4. SpawnedSaplings di SkriptF (Hanya folder SpawnedSaplings, BUKAN Plots!)
    local skriptF = workspace:FindFirstChild("SkriptF")
    if skriptF then
        local sp = skriptF:FindFirstChild("SpawnedSaplings")
        if sp then
            for _, c in ipairs(sp:GetChildren()) do addModel(c) end
        end
    end
    
    return models
end

local isStealingBusy = false
local function runStealSaplingsCycle()
    if not config.autoStealSaplings or isStealingBusy then return end

    local char = LocalPlayer.Character
    local root = getRoot(char)
    if not char or not root then return end

    -- Guard: Jika karakter sudah memegang bibit, jangan curi lagi, langsung tanam ke kebun!
    if isPlayerCarryingSapling() then
        if config.smartReturnPlot then
            returnToOwnPlot()
            task.wait(0.4)
            pcall(runAutoPlantAndGarden)
        end
        return
    end

    local allModels = getAllSaplingModels()
    local candidates = {}
    local now = tick()
    
    for _, model in ipairs(allModels) do
        -- Lewati target yang sedang dalam cooldown gagal
        if not recentlyTargetedSaplings[model] or now > recentlyTargetedSaplings[model] then
            local anchor = model:FindFirstChild("_CollectSaplingPromptAnchor")
            local prompt = (anchor and anchor:FindFirstChildOfClass("ProximityPrompt")) or model:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            if prompt and prompt.Enabled then
                local modelName = model.Name
                local objText = prompt.ObjectText or ""
                
                -- Cari kecocokan tipe pohon dengan ALL_STEALABLE_TREES
                local matchedTreeInfo = nil
                for _, tInfo in ipairs(ALL_STEALABLE_TREES) do
                    if string.find(modelName:lower(), tInfo.pattern) 
                        or string.find(objText:lower(), tInfo.pattern) 
                        or string.find(modelName:lower(), tInfo.key:lower()) then
                        matchedTreeInfo = tInfo
                        break
                    end
                end
                
                if matchedTreeInfo then
                    local isTop5 = (matchedTreeInfo.key == "Clockwork" or matchedTreeInfo.key == "Void" or matchedTreeInfo.key == "Cosmic" or matchedTreeInfo.key == "Skylands" or matchedTreeInfo.key == "Candyland")
                    local isAllowed = false
                    
                    -- Evaluasi filter droplist multi-select & toggle 5 pohon terdepan
                    if config.only5FrontSaplings then
                        if isTop5 and (config.multiTargetTrees[matchedTreeInfo.key] ~= false) then
                            isAllowed = true
                        end
                    else
                        if config.multiTargetTrees[matchedTreeInfo.key] == true then
                            isAllowed = true
                        end
                    end
                    
                    if isAllowed then
                        local promptPart = prompt.Parent
                        local pPos = (promptPart and promptPart:IsA("BasePart") and promptPart.Position) 
                            or (anchor and anchor.Position) 
                            or (model.PrimaryPart and model.PrimaryPart.Position) 
                            or (model:FindFirstChildWhichIsA("BasePart") and model:FindFirstChildWhichIsA("BasePart").Position)
                        if pPos then
                            table.insert(candidates, {
                                model = model,
                                prompt = prompt,
                                pos = pPos,
                                treeInfo = matchedTreeInfo,
                                z = pPos.Z,
                                dist = (pPos - root.Position).Magnitude
                            })
                        end
                    end
                end
            end
        end
    end

    if #candidates == 0 then
        local nowTick = tick()
        if not lastTargetWaitNotification or (nowTick - lastTargetWaitNotification) > 8 then
            lastTargetWaitNotification = nowTick
            local chosenList = {}
            for k, v in pairs(config.multiTargetTrees) do
                if v then table.insert(chosenList, k) end
            end
            local chosenStr = #chosenList > 0 and table.concat(chosenList, ", ") or "Tidak ada"
            showNotification("🌲 BROTHER HUB", "Menunggu bibit target spawn di arena:\n" .. chosenStr .. "\n(Centang Skylands/Candyland jika ingin ambil yang ada)", 4)
        end
        return
    end

    -- Urutkan dari Z paling negatif (Pohon paling depan / terjauh di arena selalu diprioritaskan!)
    table.sort(candidates, function(a, b)
        return a.z < b.z
    end)

    local target = candidates[1]
    isStealingBusy = true

    task.spawn(function()
        pcall(function()
            local anchorPos = target.pos
            -- Berdiri tepat di depan bibit (2.5 studs) di ketinggian tanah yang pas menghadap ke bibit
            local standPos = Vector3.new(anchorPos.X, anchorPos.Y + 0.5, anchorPos.Z + 2.5)
            local standCF = CFrame.lookAt(standPos, anchorPos)

            -- 1. Noclip karakter sementara & pastikan tangan kosong (unequip tool agar bisa menggendong bibit)
            pcall(function()
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum:UnequipTools()
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)

            -- 2. Teleportasi aman langsung ke depan bibit
            safeTeleport(standCF)

            -- Kunci posisi menghadap bibit secara presisi
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Anchored = false
                root.CFrame = standCF
            end)

            -- Jeda 0.12 detik agar posisi client disinkronisasi server
            task.wait(0.12)

            -- Arahkan Camera langsung menghadap anchor bibit
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.lookAt(standPos + Vector3.new(0, 2, 3), anchorPos)
                end
            end)

            local prompt = target.prompt
            local vim = game:GetService("VirtualInputManager")
            local gotSapling = false

            -- Cek status awal
            if isPlayerCarryingSapling() 
                or target.model.Name == "_CarriedSaplingVisual" 
                or target.model:GetAttribute("Claimed") == true 
                or not target.model:IsDescendantOf(workspace)
                or not prompt.Parent
                or not prompt.Enabled then
                gotSapling = true
            end

            -- =========================================================================
            -- PURE NATURAL INTERACTION ENGINE (100% VALID SERVER REPLICATION)
            -- Membiarkan HoldDuration asli (1.0s) & mengeksekusi penekanan tombol E 
            -- secara native via VirtualInputManager selama 1.20s (1x tekan, 0% spam reset)
            -- =========================================================================
            if not gotSapling and prompt and prompt.Parent then
                -- Pastikan parameter prompt aktif & jangkauan luas tanpa merusak HoldDuration!
                pcall(function()
                    prompt.HoldDuration = 1.0 -- Wajib 1.0s asli agar server menerima validasi hold!
                    prompt.MaxActivationDistance = 25
                    prompt.RequiresLineOfSight = false
                    prompt.Enabled = true
                end)

                local pressedKey = false
                -- 1. Native C++ Engine InputHoldBegin (Roblox Official Custom UI API)
                pcall(function()
                    prompt:InputHoldBegin()
                end)

                -- 2. VirtualInputManager KeyDown
                if vim then
                    pcall(function()
                        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        pressedKey = true
                    end)
                end

                -- 3. Executor fireproximityprompt dengan durasi 1.0s
                if typeof(fireproximityprompt) == "function" then
                    pcall(function() fireproximityprompt(prompt, 1.0) end)
                end

                -- Tunggu hingga 1.15 detik (1.0s durasi asli + 0.15s toleransi jaringan)
                local holdStartTime = tick()
                local holdDuration = 1.15

                while (tick() - holdStartTime) < holdDuration do
                    task.wait(0.05)
                    -- Jaga posisi dan orientasi karakter tetap stabil menghadap bibit
                    pcall(function()
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        root.CFrame = standCF
                    end)

                    -- Verifikasi seketika jika bibit sudah terambil
                    if isPlayerCarryingSapling() 
                        or target.model.Name == "_CarriedSaplingVisual" 
                        or target.model:GetAttribute("Claimed") == true 
                        or not target.model:IsDescendantOf(workspace)
                        or not prompt.Parent
                        or not prompt.Enabled then
                        gotSapling = true
                        break
                    end
                end

                -- Selesaikan sequence hold secara resmi
                pcall(function()
                    prompt:InputHoldEnd()
                end)

                -- Lepaskan tombol E native ke atas
                if pressedKey and vim then
                    pcall(function()
                        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end)
                end

                -- Periode toleransi replikasi server (hingga 0.8s jika ada jeda ping)
                if not gotSapling then
                    local repStart = tick()
                    while (tick() - repStart) < 0.8 do
                        if isPlayerCarryingSapling() 
                            or target.model.Name == "_CarriedSaplingVisual" 
                            or target.model:GetAttribute("Claimed") == true 
                            or not target.model:IsDescendantOf(workspace)
                            or not prompt.Parent
                            or not prompt.Enabled then
                            gotSapling = true
                            break
                        end
                        task.wait(0.08)
                    end
                end
            end

            -- Pulihkan CanCollide karakter setelah interaksi selesai
            pcall(function()
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
                if vim then
                    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
                if root then root.Anchored = false end
            end)

            if gotSapling then
                recentlyTargetedSaplings[target.model] = tick() + 30.0
                showNotification("🌲 BROTHER HUB", "Berhasil mengambil: " .. (target.treeInfo.displayName or target.model.Name), 3)

                -- HANYA KEMBALI KE KEBUN JIKA BIBIT SUDAH BENAR-BENAR BERHASIL TERAMBIL!
                if config.smartReturnPlot then
                    task.wait(0.3)
                    returnToOwnPlot()
                    task.wait(0.5)
                    pcall(runAutoPlantAndGarden)
                end
            else
                -- JIKA BELUM/GAGAL DIAMBIL: DILARANG KERAS MEMULANGKAN PEMAIN KE PLOT!
                -- Beri cooldown 3 detik agar bergantian mencoba bibit berikutnya di arena
                recentlyTargetedSaplings[target.model] = tick() + 3.0
                task.wait(0.2)
            end
        end)
        pcall(function()
            if root then root.Anchored = false end
        end)
        isStealingBusy = false
    end)
end

local function runStealRivalTreesCycle()
    return -- Dinonaktifkan total demi isolasi 100% dari kebun pemain lain
end

-- [7] 🌱 AUTO PLANT & GARDEN FARMING (100% PANEN & TANAM OTOMATIS)
local function runAutoPlantAndGarden()
    -- JIKA SEDANG DALAM PROSES MENCURI DI ARENA, DILARANG KERAS MEMULANGKAN/TELEPORTASI PEMAIN!
    if isStealingBusy then return end

    local char = LocalPlayer.Character
    local root = getRoot(char)
    if not char or not root then return end

    -- 1. Auto Plant carried sapling ke PlantZone tanah kebun
    if config.autoPlantGarden and isPlayerCarryingSapling() then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local carriedTool = char:FindFirstChildWhichIsA("Tool")
        local saplingTool = nil
        if carriedTool and string.find(carriedTool.Name, "Sapling") then
            saplingTool = carriedTool
        elseif bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and string.find(t.Name, "Sapling") then
                    saplingTool = t
                    pcall(function() char.Humanoid:EquipTool(t) end)
                    break
                end
            end
        end

        -- Cari PlantZone terdekat di kebun
        local targetZonePart = nil
        local skriptF = workspace:FindFirstChild("SkriptF")
        local plots = skriptF and skriptF:FindFirstChild("Plots")
        if plots then
            for _, tycoon in ipairs(plots:GetChildren()) do
                local plotSk = tycoon:FindFirstChild("PlotSkriptF")
                if plotSk then
                    for _, child in ipairs(plotSk:GetChildren()) do
                        if string.find(child.Name, "PlantZone") and child:IsA("BasePart") then
                            if (child.Position - root.Position).Magnitude < 120 then
                                targetZonePart = child
                                break
                            end
                        end
                    end
                end
                if targetZonePart then break end
            end
        end

        if targetZonePart then
            safeTeleport(targetZonePart.Position + Vector3.new(0, 2, 0))
            task.wait(0.2)
        end

        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
            local plantRemote = remotes:FindFirstChild("RequestPlantSapling") or ReplicatedStorage:FindFirstChild("RequestPlantSapling", true)
            if plantRemote and plantRemote:IsA("RemoteEvent") then
                plantRemote:FireServer(saplingTool)
            end
        end)
    end

    -- 2. Auto Skip 5 Hours Growth on growing trees
    if config.autoSkipGrowth then
        local skriptF = workspace:FindFirstChild("SkriptF")
        local plots = skriptF and skriptF:FindFirstChild("Plots")
        if plots then
            for _, tycoon in ipairs(plots:GetChildren()) do
                local plotSk = tycoon:FindFirstChild("PlotSkriptF")
                local planted = plotSk and plotSk:FindFirstChild("PlantedTreeRuntime")
                if planted then
                    for _, tree in ipairs(planted:GetChildren()) do
                        local skipPrompt = tree:FindFirstChild("SkipGrowingPrompt", true) or tree:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if skipPrompt and skipPrompt.Enabled and string.find(skipPrompt.ActionText:lower(), "speed up") then
                            local part = skipPrompt.Parent
                            if part and part:IsA("BasePart") and (part.Position - root.Position).Magnitude < 40 then
                                safeTeleport(part.Position + Vector3.new(0, 2, 0))
                                task.wait(0.15)
                                firePrompt(skipPrompt)
                            end
                        end
                    end
                end
            end
        end
    end

    -- 3. Auto Collect Mature Saplings & Trees EKSKLUSIF di Kebun Sendiri (100% Bebas Salah Masuk Kebun Orang Lain!)
    if config.autoHarvestTrees then
        local ownTycoon = getOwnPlot()
        if ownTycoon then
            local plotSk = ownTycoon:FindFirstChild("PlotSkriptF")
            local planted = plotSk and plotSk:FindFirstChild("PlantedTreeRuntime")
            if planted then
                for _, tree in ipairs(planted:GetChildren()) do
                    local collectPrompt = tree:FindFirstChild("CollectSaplingPrompt", true) or tree:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if collectPrompt and collectPrompt.Enabled then
                        local pPart = collectPrompt.Parent
                        if pPart and pPart:IsA("BasePart") then
                            safeTeleport(pPart.Position + Vector3.new(0, 1.5, 0))
                            task.wait(0.2)
                            firePrompt(collectPrompt)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end

    -- 4. Auto Disarm Bear Traps
    if config.autoDisarmTraps then
        local trapsFolder = workspace:FindFirstChild("PlacedBearTraps")
        if trapsFolder then
            for _, trap in ipairs(trapsFolder:GetChildren()) do
                local prompt = trap:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    local pPart = prompt.Parent
                    if pPart and pPart:IsA("BasePart") and (pPart.Position - root.Position).Magnitude < 25 then
                        firePrompt(prompt)
                    end
                end
            end
        end
    end
end

-- [8] 🏃 AUTO TREADMILL SPEED BOOSTER
local function runTreadmillBooster()
    if config.autoTreadmillJump then
        pcall(function()
            local tj = ReplicatedStorage:FindFirstChild("TreadmillJump")
            if tj and tj:IsA("RemoteEvent") then
                tj:FireServer()
            end
        end)
    end
    if config.autoTreadmillGain then
        pcall(function()
            local tg = ReplicatedStorage:FindFirstChild("TreadmillSpeedGain")
            if tg and tg:IsA("RemoteEvent") then
                tg:FireServer()
            end
        end)
    end
end

-- [9] 🏪 AUTO SHOP & PURCHASES (100% FREE ZERO ROBUX GUARANTEE)
local function runShopPurchases()
    -- 1. Gear Shop
    if config.autoBuyGear then
        pcall(function()
            local gearReq = ReplicatedStorage:FindFirstChild("GearShopRequest")
            if gearReq and gearReq:IsA("RemoteEvent") then
                for gearName, isSelected in pairs(config.targetGears) do
                    if isSelected then
                        gearReq:FireServer(gearName)
                    end
                end
            end
        end)
    end

    -- 2. Merchant Shop
    if config.autoBuyMerchant then
        pcall(function()
            local merchantReq = ReplicatedStorage:FindFirstChild("MerchantRequest")
            if merchantReq and merchantReq:IsA("RemoteEvent") then
                merchantReq:FireServer("BuyAll")
            end
        end)
    end

    -- 3. Ticket Market
    if config.autoBuyTicketMarket then
        pcall(function()
            local tmReq = ReplicatedStorage:FindFirstChild("TicketMarketRequest")
            if tmReq and tmReq:IsA("RemoteEvent") then
                for i = 1, 12 do
                    tmReq:FireServer("TicketOffer_" .. tostring(i))
                end
            end
        end)
    end

    -- 4. Plot & Juicer Upgrades
    if config.autoExpandPlot then
        pcall(function()
            local progReq = ReplicatedStorage:FindFirstChild("ProgressionUpgradeRequest")
            if progReq and progReq:IsA("RemoteEvent") then
                progReq:FireServer("ExpandPlot")
            end
        end)
    end
    if config.autoUpgradeJuicer then
        pcall(function()
            local juiceReq = ReplicatedStorage:FindFirstChild("JuicerUpgradeRequest")
            if juiceReq and juiceReq:IsA("RemoteEvent") then
                juiceReq:FireServer("UpgradeIncome")
                juiceReq:FireServer("UpgradeSpeed")
            end
        end)
    end
end

-- [10] 🐾 REWARDS & PETS & CODES
local PROMO_CODES = {
    "RELEASE", "FREE", "TREE", "SPEED", "LUCK", "DISCO", "SANZ", "CANDY", "COSMIC", "UPDATE"
}

local function runRewardsAndCodes()
    -- 1. Daily Rewards
    if config.autoClaimDaily then
        pcall(function()
            local dailyReq = ReplicatedStorage:FindFirstChild("DailyRewardRequest")
            if dailyReq and dailyReq:IsA("RemoteEvent") then
                for day = 1, 7 do
                    dailyReq:FireServer(day)
                end
            end
        end)
    end

    -- 2. Playtime & Free Rewards
    if config.autoClaimPlaytime then
        pcall(function()
            local ptReq = ReplicatedStorage:FindFirstChild("PlaytimeRewardRequest")
            if ptReq and ptReq:IsA("RemoteEvent") then
                for slot = 1, 12 do
                    ptReq:FireServer(slot)
                end
            end
            local freeReq = ReplicatedStorage:FindFirstChild("FreeRewardsEvent")
            if freeReq and freeReq:IsA("RemoteEvent") then
                freeReq:FireServer("Claim")
            end
        end)
    end

    -- 3. Quests
    if config.autoClaimQuests then
        pcall(function()
            local qReq = ReplicatedStorage:FindFirstChild("QuestRequest")
            if qReq and qReq:IsA("RemoteEvent") then
                qReq:FireServer("ClaimAll")
            end
        end)
    end

    -- 4. Pet Eggs & Best Equip
    if config.autoHatchEgg then
        pcall(function()
            local eggReq = ReplicatedStorage:FindFirstChild("PetEggRequest")
            if eggReq and eggReq:IsA("RemoteEvent") then
                eggReq:FireServer("EggCommon", 1)
            end
        end)
    end
    if config.autoEquipBest then
        pcall(function()
            local petReq = ReplicatedStorage:FindFirstChild("PetRequest")
            if petReq and petReq:IsA("RemoteEvent") then
                petReq:FireServer("EquipBest")
            end
        end)
    end

    -- 5. Promo Codes
    if config.autoRedeemCodes then
        pcall(function()
            local codeRemote = ReplicatedStorage:FindFirstChild("CodesRemoteEvent")
            if codeRemote and codeRemote:IsA("RemoteEvent") then
                for _, code in ipairs(PROMO_CODES) do
                    codeRemote:FireServer(code)
                    task.wait(0.1)
                end
            end
        end)
        config.autoRedeemCodes = false
    end
end

-- [11] 👁️ ESP & VISUAL ENGINE
local function cleanESP()
    for _, obj in pairs(espObjects) do
        pcall(function()
            if obj and obj.Destroy then obj:Destroy() end
        end)
    end
    espObjects = {}
end

local function updateESP()
    cleanESP()
    local root = getRoot()
    if not root then return end

    -- 1. Sapling ESP
    if config.saplingESP then
        local spawned = getSpawnedSaplingsFolder()
        if spawned then
            for _, model in ipairs(spawned:GetChildren()) do
                if model:IsA("Model") and model.Name ~= "_CarriedSaplingVisual" then
                    local pPos = (model.PrimaryPart and model.PrimaryPart.Position) or (model:FindFirstChildWhichIsA("BasePart") and model:FindFirstChildWhichIsA("BasePart").Position)
                    if pPos then
                        local bbg = Instance.new("BillboardGui")
                        bbg.Name = "BH_SaplingESP"
                        bbg.AlwaysOnTop = true
                        bbg.Size = UDim2.fromOffset(140, 30)
                        bbg.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                        bbg.Parent = CoreGui

                        local lbl = Instance.new("TextLabel", bbg)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 11
                        lbl.TextColor3 = Color3.fromRGB(0, 255, 200)
                        local dist = math.floor((pPos - root.Position).Magnitude)
                        lbl.Text = string.format("🌲 %s [%dm]", model.Name, dist)
                        table.insert(espObjects, bbg)
                    end
                end
            end
        end
    end

    -- 2. Rival Trees ESP
    if config.rivalTreeESP then
        local skriptF = workspace:FindFirstChild("SkriptF")
        local plots = skriptF and skriptF:FindFirstChild("Plots")
        if plots then
            for _, tycoon in ipairs(plots:GetChildren()) do
                local plotSk = tycoon:FindFirstChild("PlotSkriptF")
                local planted = plotSk and plotSk:FindFirstChild("PlantedTreeRuntime")
                if planted then
                    local claimable = planted:FindFirstChild("_ClaimableTrees")
                    if claimable then
                        for _, tree in ipairs(claimable:GetChildren()) do
                            local hl = Instance.new("Highlight")
                            hl.Name = "BH_RivalTreeHL"
                            hl.FillColor = Color3.fromRGB(255, 215, 0)
                            hl.FillTransparency = 0.4
                            hl.OutlineColor = Color3.fromRGB(255, 50, 50)
                            hl.Adornee = tree
                            hl.Parent = CoreGui
                            table.insert(espObjects, hl)
                        end
                    end
                end
            end
        end
    end

    -- 3. Player ESP
    if config.playerESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local pRoot = getRoot(plr.Character)
                if pRoot then
                    local hl = Instance.new("Highlight")
                    hl.Name = "BH_PlayerHL"
                    hl.FillColor = Color3.fromRGB(0, 229, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Adornee = plr.Character
                    hl.Parent = CoreGui
                    table.insert(espObjects, hl)
                end
            end
        end
    end
end

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
ScreenGui.Name = "BrotherHub_StealATree"
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

-- Global cleanup proximity prompts
pcall(function()
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.MaxActivationDistance > 100 then
            p.MaxActivationDistance = 10
        end
    end
end)

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
LangBtn.Text = currentLang == "ID" and "🇮🇩" or "🇬🇧"
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

-- Resize Grip Corner (1:1 My Flower Shop & Steal A Seed Standard)
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

-- Floating 80x80 MinCircle (1:1 My Flower Shop & Steal A Seed Exact Standard)
local Circle = Instance.new("TextButton", ScreenGui)
Circle.Name = "MinCircle"
Circle.Size = UDim2.fromOffset(80, 80)
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.Position = UDim2.new(0.1, 0, 0.5, 0)
Circle.BackgroundColor3 = THEME.Panel
Circle.Text = "BH"
Circle.TextColor3 = THEME.Title
Circle.TextSize = 22
Circle.Font = THEME.Font
Circle.Visible = false
Circle.ZIndex = 50
corner(Circle, 40)
local circleStroke, circleStrokeTw = neonStroke(Circle, 2.5)

local CrownLabel = Instance.new("TextLabel", Circle)
CrownLabel.Name = "CrownLabel"
CrownLabel.Size = UDim2.new(1, 0, 0, 16)
CrownLabel.Position = UDim2.new(0, 0, 0, 8)
CrownLabel.BackgroundTransparency = 1
CrownLabel.Text = "👑"
CrownLabel.TextSize = 16
CrownLabel.Font = THEME.Font

-- MinCircle Dragging
local cDragging, cDragInput, cDragStart, cStartPos
Circle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        cDragging = true
        cDragStart = input.Position
        cStartPos = Circle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then cDragging = false end
        end)
    end
end)
Circle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        cDragInput = input
    end
end)
registerConnection(UserInputService.InputChanged:Connect(function(input)
    if input == cDragInput and cDragging then
        local delta = input.Position - cDragStart
        Circle.Position = UDim2.new(cStartPos.X.Scale, cStartPos.X.Offset + delta.X, cStartPos.Y.Scale, cStartPos.Y.Offset + delta.Y)
    end
end))

local isMinimized = false
local function doMinimize()
    isMinimized = true
    TweenService:Create(MainScale, tweenFast, {Scale = 0}):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    Circle.Visible = true
    Circle.Size = UDim2.fromOffset(0, 0)
    TweenService:Create(Circle, tweenBounce, {Size = UDim2.fromOffset(80, 80)}):Play()
end

local function doRestore()
    isMinimized = false
    TweenService:Create(Circle, tweenFast, {Size = UDim2.fromOffset(0, 0)}):Play()
    task.wait(0.2)
    Circle.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainScale, tweenBounce, {Scale = config.guiScale or 1.0}):Play()
end

MinBtn.MouseButton1Click:Connect(doMinimize)
Circle.MouseButton1Click:Connect(doRestore)

-- Close Confirmation Modal (1:1 FlowerShop Exact Standard)
local ModalOverlay = Instance.new("Frame", ScreenGui)
ModalOverlay.Name = "ModalOverlay"
ModalOverlay.Size = UDim2.new(1, 0, 1, 0)
ModalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ModalOverlay.BackgroundTransparency = 0.5
ModalOverlay.Visible = false
ModalOverlay.ZIndex = 100

local ModalFrame = Instance.new("Frame", ModalOverlay)
ModalFrame.Size = UDim2.fromOffset(360, 180)
ModalFrame.Position = UDim2.new(0.5, -180, 0.5, -90)
ModalFrame.BackgroundColor3 = THEME.Panel
corner(ModalFrame, 12)
neonStroke(ModalFrame, 2)

local ModalTitle = Instance.new("TextLabel", ModalFrame)
ModalTitle.Size = UDim2.new(1, -20, 0, 30)
ModalTitle.Position = UDim2.new(0, 10, 0, 12)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = tr("ConfirmCloseTitle")
ModalTitle.TextColor3 = THEME.Title
ModalTitle.Font = THEME.Font
ModalTitle.TextSize = 16

local ModalDesc = Instance.new("TextLabel", ModalFrame)
ModalDesc.Size = UDim2.new(1, -30, 0, 50)
ModalDesc.Position = UDim2.new(0, 15, 0, 48)
ModalDesc.BackgroundTransparency = 1
ModalDesc.Text = tr("ConfirmCloseMsg")
ModalDesc.TextColor3 = THEME.Text
ModalDesc.Font = THEME.FontReg
ModalDesc.TextSize = 13
ModalDesc.TextWrapped = true

local ModalYes = Instance.new("TextButton", ModalFrame)
ModalYes.Size = UDim2.fromOffset(140, 36)
ModalYes.Position = UDim2.new(0, 25, 1, -50)
ModalYes.BackgroundColor3 = THEME.Green
ModalYes.Text = tr("BtnYes")
ModalYes.TextColor3 = Color3.fromRGB(255, 255, 255)
ModalYes.Font = THEME.Font
ModalYes.TextSize = 13
corner(ModalYes, 8)

local ModalCancel = Instance.new("TextButton", ModalFrame)
ModalCancel.Size = UDim2.fromOffset(140, 36)
ModalCancel.Position = UDim2.new(1, -165, 1, -50)
ModalCancel.BackgroundColor3 = THEME.Red
ModalCancel.Text = tr("BtnCancel")
ModalCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
ModalCancel.Font = THEME.Font
ModalCancel.TextSize = 13
corner(ModalCancel, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ModalOverlay.Visible = true
end)
ModalCancel.MouseButton1Click:Connect(function()
    ModalOverlay.Visible = false
end)

-- Total Sterilization on Close Yes
local function totalSterilization()
    if _G.BH_STEALATREE_CLEANUP then
        pcall(_G.BH_STEALATREE_CLEANUP)
        _G.BH_STEALATREE_CLEANUP = nil
    end
    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, th in ipairs(activeThreads) do
        pcall(function() task.cancel(th) end)
    end
    cleanESP()

    -- Reset player movement
    pcall(function()
        local hum = getHum()
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end)
    pcall(function() ScreenGui:Destroy() end)
end

ModalYes.MouseButton1Click:Connect(totalSterilization)
_G.BH_STEALATREE_CLEANUP = totalSterilization

-- [13] TAB ENGINE & COMPONENT BUILDERS
local tabs = {}
local pages = {}
local activeTab = nil

local function createTab(tabId, labelText)
    local btn = Instance.new("TextButton", TabBar)
    btn.Name = "Tab_" .. tabId
    btn.Size = UDim2.new(0, 115, 1, 0)
    btn.BackgroundColor3 = THEME.Card
    btn.Text = labelText
    btn.TextColor3 = THEME.SubText
    btn.Font = THEME.Font
    btn.TextSize = 12
    corner(btn, 8)
    local btnStroke = stroke(btn, THEME.Border, 1)

    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Name = "Page_" .. tabId
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = THEME.Title
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    local padding = Instance.new("UIPadding", page)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 14)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 6)

    tabs[tabId] = { btn = btn, stroke = btnStroke }
    pages[tabId] = page

    btn.MouseButton1Click:Connect(function()
        for id, info in pairs(tabs) do
            local isCurrent = (id == tabId)
            info.btn.BackgroundColor3 = isCurrent and THEME.Panel or THEME.Card
            info.btn.TextColor3 = isCurrent and THEME.Title or THEME.SubText
            info.stroke.Color = isCurrent and THEME.Title or THEME.Border
            pages[id].Visible = isCurrent
        end
        activeTab = tabId
    end)

    if not activeTab then
        activeTab = tabId
        btn.BackgroundColor3 = THEME.Panel
        btn.TextColor3 = THEME.Title
        btnStroke.Color = THEME.Title
        page.Visible = true
    end

    return page
end

local function addSection(parent, titleText)
    local sec = Instance.new("Frame", parent)
    sec.Size = UDim2.new(1, 0, 0, 26)
    sec.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", sec)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "— " .. string.upper(titleText) .. " —"
    lbl.TextColor3 = THEME.Title
    lbl.Font = THEME.Font
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return sec
end

local function addToggle(parent, labelText, defaultState, callback)
    local card = Instance.new("TextButton", parent)
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = THEME.Card
    card.Text = ""
    card.AutoButtonColor = false
    corner(card, 8)
    local cStroke = stroke(card, THEME.Border, 1)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.Text
    lbl.Font = THEME.FontReg
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame", card)
    switch.Size = UDim2.fromOffset(44, 22)
    switch.Position = UDim2.new(1, -54, 0.5, -11)
    switch.BackgroundColor3 = defaultState and THEME.Title or THEME.Panel
    corner(switch, 11)

    local dot = Instance.new("Frame", switch)
    dot.Size = UDim2.fromOffset(16, 16)
    dot.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    corner(dot, 8)

    local state = defaultState

    local function setState(newState, skipCallback)
        state = newState
        TweenService:Create(switch, tweenFast, {
            BackgroundColor3 = state and THEME.Title or THEME.Panel
        }):Play()
        TweenService:Create(dot, tweenFast, {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        cStroke.Color = state and THEME.Title or THEME.Border
        if not skipCallback and callback then
            callback(state)
        end
        saveConfig()
    end

    card.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    return { card = card, setState = setState }
end

local function addSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = THEME.Card
    corner(card, 8)
    stroke(card, THEME.Border, 1)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -100, 0, 24)
    lbl.Position = UDim2.new(0, 14, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.Text
    lbl.Font = THEME.FontReg
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valBox = Instance.new("TextBox", card)
    valBox.Size = UDim2.fromOffset(60, 20)
    valBox.Position = UDim2.new(1, -70, 0, 6)
    valBox.BackgroundColor3 = THEME.Slot
    valBox.Text = tostring(defaultVal)
    valBox.TextColor3 = THEME.Title
    valBox.Font = THEME.Font
    valBox.TextSize = 11
    corner(valBox, 4)

    local barBg = Instance.new("Frame", card)
    barBg.Size = UDim2.new(1, -28, 0, 6)
    barBg.Position = UDim2.new(0, 14, 1, -14)
    barBg.BackgroundColor3 = THEME.Slot
    corner(barBg, 3)

    local barFill = Instance.new("Frame", barBg)
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    barFill.Size = UDim2.new(pct, 0, 1, 0)
    barFill.BackgroundColor3 = THEME.Title
    corner(barFill, 3)

    local currentVal = defaultVal
    local draggingSlider = false

    local function updateFromPct(p)
        p = math.clamp(p, 0, 1)
        barFill.Size = UDim2.new(p, 0, 1, 0)
        currentVal = math.floor(minVal + (maxVal - minVal) * p)
        valBox.Text = tostring(currentVal)
        if callback then callback(currentVal) end
        saveConfig()
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            local relX = input.Position.X - barBg.AbsolutePosition.X
            updateFromPct(relX / barBg.AbsoluteSize.X)
        end
    end)
    registerConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end))
    registerConnection(UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relX = input.Position.X - barBg.AbsolutePosition.X
            updateFromPct(relX / barBg.AbsoluteSize.X)
        end
    end))

    valBox.FocusLost:Connect(function()
        local n = tonumber(valBox.Text)
        if n then
            n = math.clamp(n, minVal, maxVal)
            updateFromPct((n - minVal) / (maxVal - minVal))
        else
            valBox.Text = tostring(currentVal)
        end
    end)

    return card
end

local function addButton(parent, labelText, iconText, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = THEME.Card
    btn.Text = (iconText and (iconText .. " ") or "") .. labelText
    btn.TextColor3 = THEME.Text
    btn.Font = THEME.Font
    btn.TextSize = 12
    corner(btn, 8)
    local bStroke = stroke(btn, THEME.Border, 1)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, tweenFast, { BackgroundColor3 = THEME.Slot }):Play()
        bStroke.Color = THEME.Title
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, tweenFast, { BackgroundColor3 = THEME.Card }):Play()
        bStroke.Color = THEME.Border
    end)
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

-- [12.1] 💎 POPUP DROPDOWN MANAGER (1:1 MY FLOWER SHOP / STEAL A SEED EXACT STANDARD)
local openDropdownId = nil
local allDropdownClosers = {}

local function closeOtherDropdowns(exceptId)
    openDropdownId = exceptId
    for id, closer in pairs(allDropdownClosers) do
        if id ~= exceptId then pcall(closer) end
    end
end

local dropdownBlockerFrame = nil
local function dropdownBlocker()
    if dropdownBlockerFrame and dropdownBlockerFrame.Parent then return dropdownBlockerFrame end
    local b = Instance.new("TextButton")
    b.Name = "BH_DropdownBlocker"
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.Visible = false
    b.ZIndex = 490
    b.Parent = ScreenGui
    b.MouseButton1Click:Connect(function()
        closeOtherDropdowns(nil)
        b.Visible = false
    end)
    dropdownBlockerFrame = b
    return b
end

-- [12.2] 💎 POPUP DROPDOWN MENU ENGINE (SINGLE SELECT)
local function createDropdown(parent, labelText, options, defaultVal, callback)
    local selectedValue = tostring(defaultVal or (type(options) == "table" and options[1]) or "Auto")
    local isOpen = false
    local myId = {}

    local ddRow = Instance.new("Frame")
    ddRow.Size = UDim2.new(1, 0, 0, 38)
    ddRow.BackgroundColor3 = THEME.Card
    ddRow.BorderSizePixel = 0
    ddRow.Parent = parent
    ddRow.ZIndex = 5
    corner(ddRow, 8)
    local ddStroke = stroke(ddRow, THEME.Border, 1)

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

    local ddBtn = Instance.new("TextButton", ddRow)
    ddBtn.Size = UDim2.new(0.55, -12, 0, 28)
    ddBtn.Position = UDim2.new(0.45, 0, 0.5, -14)
    ddBtn.BackgroundColor3 = THEME.Panel
    ddBtn.AutoButtonColor = false
    ddBtn.Text = ""
    ddBtn.BorderSizePixel = 0
    ddBtn.ZIndex = 6
    corner(ddBtn, 6)
    stroke(ddBtn, THEME.Border, 1)

    local ddValLabel = Instance.new("TextLabel", ddBtn)
    ddValLabel.Size = UDim2.new(1, -24, 1, 0)
    ddValLabel.Position = UDim2.new(0, 8, 0, 0)
    ddValLabel.BackgroundTransparency = 1
    ddValLabel.Font = THEME.Font
    ddValLabel.TextSize = 11
    ddValLabel.TextColor3 = THEME.Title
    ddValLabel.TextXAlignment = Enum.TextXAlignment.Left
    ddValLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ddValLabel.Text = selectedValue
    ddValLabel.ZIndex = 7

    local ddArrow = Instance.new("TextLabel", ddBtn)
    ddArrow.Size = UDim2.new(0, 18, 1, 0)
    ddArrow.Position = UDim2.new(1, -20, 0, 0)
    ddArrow.BackgroundTransparency = 1
    ddArrow.Font = THEME.Font
    ddArrow.TextSize = 11
    ddArrow.TextColor3 = THEME.Title
    ddArrow.Text = "▼"
    ddArrow.ZIndex = 7

    local listFrame = nil
    local function getList()
        if listFrame and listFrame.Parent then return listFrame end
        local l = Instance.new("ScrollingFrame")
        l.Name = "BH_DropdownList"
        l.Size = UDim2.fromOffset(0, 0)
        l.BackgroundColor3 = THEME.Panel
        l.BorderSizePixel = 0
        l.ScrollBarThickness = 4
        l.ScrollBarImageColor3 = THEME.Title
        l.Visible = false
        l.ZIndex = 500
        l.ClipsDescendants = true
        corner(l, 8)
        stroke(l, THEME.Title, 1.5)

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

    local function closeMenu()
        if not isOpen then return end
        isOpen = false
        ddArrow.Text = "▼"
        ddStroke.Color = THEME.Border
        if listFrame then listFrame.Visible = false end
        dropdownBlocker().Visible = false
    end
    allDropdownClosers[myId] = closeMenu

    local function openMenu()
        closeOtherDropdowns(myId)
        isOpen = true
        ddArrow.Text = "▲"
        ddStroke.Color = THEME.Title

        local l = getList()
        for _, ch in ipairs(l:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end

        local curOptions = type(options) == "function" and options() or options
        local itemH = 26
        local maxVisible = 6
        local totalH = math.min(#curOptions, maxVisible) * (itemH + 3) + 8

        local absPos = ddBtn.AbsolutePosition
        local absSize = ddBtn.AbsoluteSize
        local s = (ScreenGui:FindFirstChildOfClass("UIScale") and ScreenGui:FindFirstChildOfClass("UIScale").Scale) or 1
        l.Size = UDim2.fromOffset(math.max(absSize.X / s, 200), totalH)
        l.Position = UDim2.fromOffset(absPos.X / s, (absPos.Y + absSize.Y + 4) / s)
        l.CanvasSize = UDim2.new(0, 0, 0, #curOptions * (itemH + 3) + 8)

        for i, opt in ipairs(curOptions) do
            local optStr = tostring(opt)
            local itemBtn = Instance.new("TextButton", l)
            itemBtn.Size = UDim2.new(1, 0, 0, itemH)
            itemBtn.BackgroundColor3 = (optStr == selectedValue) and THEME.Slot or THEME.Card
            itemBtn.Text = "  " .. optStr
            itemBtn.TextColor3 = (optStr == selectedValue) and THEME.Title or THEME.Text
            itemBtn.Font = THEME.Font
            itemBtn.TextSize = 11
            itemBtn.TextXAlignment = Enum.TextXAlignment.Left
            itemBtn.TextTruncate = Enum.TextTruncate.AtEnd
            itemBtn.ZIndex = 502
            corner(itemBtn, 4)

            itemBtn.MouseButton1Click:Connect(function()
                selectedValue = optStr
                ddValLabel.Text = optStr
                closeMenu()
                if callback then callback(optStr) end
                saveConfig()
            end)
        end

        l.Visible = true
        dropdownBlocker().Visible = true
    end

    ddBtn.MouseButton1Click:Connect(function()
        if isOpen then closeMenu() else openMenu() end
    end)

    return { row = ddRow, getValue = function() return selectedValue end }
end

-- [12.3] 💎 MULTI-SELECT DROPLIST ENGINE (STANDAR 1:1 STEAL A SEED / MY FLOWER SHOP)
local function makeMultiDropdown(parent, label, getItems, store, emptyTxt, mapValue, onChanged)
    local con = Instance.new("Frame", parent)
    con.Size = UDim2.new(1, 0, 0, 38)
    con.BackgroundColor3 = THEME.Card
    con.BorderSizePixel = 0
    con.ZIndex = 5
    corner(con, 8)
    local cStroke = stroke(con, THEME.Border, 1)

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
        corner(l, 8)
        stroke(l, THEME.Title, 1.5)

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
            for _, v in pairs(store) do if v then n = n + 1 end end
        end

        if n == 0 then
            disp.Text = emptyTxt or "None"
            disp.TextColor3 = THEME.SubText
        elseif n == 1 and firstText then
            disp.Text = firstText
            disp.TextColor3 = THEME.Title
        else
            disp.Text = string.format("%d Dipilih", n)
            disp.TextColor3 = THEME.Title
        end
    end

    local myId = {}
    local open = false
    local function closeMe()
        if not open then return end
        open = false
        arr.Text = "▼"
        cStroke.Color = THEME.Border
        if list then list.Visible = false end
        dropdownBlocker().Visible = false
    end
    allDropdownClosers[myId] = closeMe

    local function buildList()
        local l = getList()
        for _, ch in ipairs(l:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextButton") then ch:Destroy() end
        end

        local items = type(getItems) == "function" and getItems() or getItems
        if type(items) ~= "table" then items = {} end

        local rowCount = #items + 1
        local itemH = 28
        local maxH = 220
        local totalH = math.min(rowCount * (itemH + 3) + 8, maxH)
        local w, x, y = listGeom()
        l.Size = UDim2.fromOffset(w, totalH)
        l.Position = UDim2.fromOffset(x, y)
        l.CanvasSize = UDim2.new(0, 0, 0, rowCount * (itemH + 3) + 8)

        -- Row tombol aksi cepat di bagian atas dropdown
        local actionRow = Instance.new("Frame", l)
        actionRow.Size = UDim2.new(1, 0, 0, 26)
        actionRow.BackgroundTransparency = 1
        actionRow.LayoutOrder = 0

        local btnAll = Instance.new("TextButton", actionRow)
        btnAll.Size = UDim2.new(0.48, 0, 1, 0)
        btnAll.BackgroundColor3 = THEME.Card
        btnAll.Text = "✓ Pilih Semua"
        btnAll.TextColor3 = THEME.Title
        btnAll.Font = THEME.Font
        btnAll.TextSize = 11
        corner(btnAll, 6)

        local btnNone = Instance.new("TextButton", actionRow)
        btnNone.Size = UDim2.new(0.48, 0, 1, 0)
        btnNone.Position = UDim2.new(0.52, 0, 0, 0)
        btnNone.BackgroundColor3 = THEME.Card
        btnNone.Text = "✕ Hapus Semua"
        btnNone.TextColor3 = THEME.SubText
        btnNone.Font = THEME.Font
        btnNone.TextSize = 11
        corner(btnNone, 6)

        btnAll.MouseButton1Click:Connect(function()
            for _, it in ipairs(items) do
                local k = mapValue and mapValue(it) or it
                store[k] = true
            end
            buildList()
            refreshDisplay()
            if onChanged then onChanged() end
            saveConfig()
        end)

        btnNone.MouseButton1Click:Connect(function()
            for _, it in ipairs(items) do
                local k = mapValue and mapValue(it) or it
                store[k] = false
            end
            buildList()
            refreshDisplay()
            if onChanged then onChanged() end
            saveConfig()
        end)

        for i, it in ipairs(items) do
            local k = mapValue and mapValue(it) or it
            local checked = store[k] == true

            local row = Instance.new("TextButton", l)
            row.Size = UDim2.new(1, 0, 0, itemH)
            row.BackgroundColor3 = checked and THEME.Slot or THEME.Card
            row.AutoButtonColor = false
            row.Text = ""
            row.LayoutOrder = i
            corner(row, 6)
            local rStroke = stroke(row, checked and THEME.Title or THEME.Border, 1)

            local box = Instance.new("Frame", row)
            box.Size = UDim2.fromOffset(16, 16)
            box.Position = UDim2.new(0, 8, 0.5, -8)
            box.BackgroundColor3 = checked and THEME.Title or THEME.Panel
            corner(box, 4)
            stroke(box, checked and THEME.Title or THEME.Border, 1)

            local chkMark = Instance.new("TextLabel", box)
            chkMark.Size = UDim2.new(1, 0, 1, 0)
            chkMark.BackgroundTransparency = 1
            chkMark.Text = checked and "✓" or ""
            chkMark.TextColor3 = THEME.Panel
            chkMark.Font = THEME.Font
            chkMark.TextSize = 11

            local txt = Instance.new("TextLabel", row)
            txt.Size = UDim2.new(1, -34, 1, 0)
            txt.Position = UDim2.new(0, 30, 0, 0)
            txt.BackgroundTransparency = 1
            txt.Text = tostring(it)
            txt.TextColor3 = checked and THEME.Title or THEME.Text
            txt.Font = checked and THEME.Font or THEME.FontReg
            txt.TextSize = 11
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.TextTruncate = Enum.TextTruncate.AtEnd

            row.MouseButton1Click:Connect(function()
                checked = not checked
                store[k] = checked
                row.BackgroundColor3 = checked and THEME.Slot or THEME.Card
                rStroke.Color = checked and THEME.Title or THEME.Border
                box.BackgroundColor3 = checked and THEME.Title or THEME.Panel
                stroke(box, checked and THEME.Title or THEME.Border, 1)
                chkMark.Text = checked and "✓" or ""
                txt.TextColor3 = checked and THEME.Title or THEME.Text
                txt.Font = checked and THEME.Font or THEME.FontReg
                refreshDisplay()
                if onChanged then onChanged(k, checked) end
                saveConfig()
            end)
        end
    end

    local function openMe()
        closeOtherDropdowns(myId)
        open = true
        arr.Text = "▲"
        cStroke.Color = THEME.Title
        buildList()
        getList().Visible = true
        dropdownBlocker().Visible = true
    end

    trig.MouseButton1Click:Connect(function()
        if open then closeMe() else openMe() end
    end)

    refreshDisplay()
    return { container = con, refresh = refreshDisplay, close = closeMe }
end


-- [14] POPULATE ALL 9 TABS

-- TAB 1: AUTO STEAL
local pageSteal = createTab("Steal", tr("TabAutoSteal"))
addSection(pageSteal, tr("SecStealSapling"))
addToggle(pageSteal, tr("AutoStealSaplings"), config.autoStealSaplings, function(val)
    config.autoStealSaplings = val
end)
addToggle(pageSteal, tr("SmartReturnPlot"), config.smartReturnPlot, function(val)
    config.smartReturnPlot = val
end)
addToggle(pageSteal, "🏆 Only 5 Front Saplings (Clockwork, Void, Cosmic, Skylands, Candyland)", config.only5FrontSaplings, function(val)
    config.only5FrontSaplings = val
    saveConfig()
end)

-- SEKSI MULTI-SELECT DROPLIST STANDAR 1:1 STEAL A SEED / MY FLOWER SHOP
makeMultiDropdown(pageSteal, "🎯 Target Saplings to Steal", function()
    local list = {}
    for _, s in ipairs(ALL_STEALABLE_TREES) do
        table.insert(list, s.displayName)
    end
    return list
end, config.multiTargetTrees, "None (Stay at Base)", function(displayName)
    for _, s in ipairs(ALL_STEALABLE_TREES) do
        if s.displayName == displayName or s.key == displayName then
            return s.key
        end
    end
    return displayName
end, function(key, state)
    saveConfig()
end)

addSection(pageSteal, "PERTAHANAN JEBAKAN ARENA (TRAP REMOVAL)")
addToggle(pageSteal, tr("AutoDisarmTraps"), config.autoDisarmTraps, function(val)
    config.autoDisarmTraps = val
end)

local pageFarm = createTab("Farm", tr("TabGardenFarm"))
addSection(pageFarm, tr("SecGardenPlant"))
addToggle(pageFarm, tr("AutoPlantGarden"), config.autoPlantGarden, function(val)
    config.autoPlantGarden = val
end)
addToggle(pageFarm, tr("AutoSkipGrowth"), config.autoSkipGrowth, function(val)
    config.autoSkipGrowth = val
end)
addToggle(pageFarm, tr("AutoHarvestTrees"), config.autoHarvestTrees, function(val)
    config.autoHarvestTrees = val
end)
addToggle(pageFarm, tr("AutoJuicer"), config.autoJuicer, function(val)
    config.autoJuicer = val
end)

addSection(pageFarm, tr("SecPlotUpgrades"))
addToggle(pageFarm, tr("AutoExpandPlot"), config.autoExpandPlot, function(val)
    config.autoExpandPlot = val
end)
addToggle(pageFarm, tr("AutoUpgradeJuicer"), config.autoUpgradeJuicer, function(val)
    config.autoUpgradeJuicer = val
end)
addButton(pageFarm, tr("TPHomePlot"), "🏡", returnToOwnPlot)

-- TAB 3: SPEED & TRAINING
local pageSpeed = createTab("Speed", tr("TabSpeedTrain"))
addSection(pageSpeed, tr("SecTreadmill"))
addToggle(pageSpeed, tr("AutoTreadmillJump"), config.autoTreadmillJump, function(val)
    config.autoTreadmillJump = val
end)
addToggle(pageSpeed, tr("AutoTreadmillGain"), config.autoTreadmillGain, function(val)
    config.autoTreadmillGain = val
end)

addSection(pageSpeed, tr("SecMinigames"))
addToggle(pageSpeed, tr("AutoSanzBattleGod"), config.autoSanzBattleGod, function(val)
    config.autoSanzBattleGod = val
end)
addToggle(pageSpeed, tr("AutoDiscoMania"), config.autoDiscoMania, function(val)
    config.autoDiscoMania = val
end)

-- TAB 4: SHOP & PURCHASES (100% FREE ZERO ROBUX)
local pageShop = createTab("Shop", tr("TabShopUpgrade"))
addSection(pageShop, tr("SecGearShop"))
addToggle(pageShop, tr("BlockRobux"), config.blockRobux, function(val)
    config.blockRobux = val
end)
addToggle(pageShop, tr("AutoBuyGear"), config.autoBuyGear, function(val)
    config.autoBuyGear = val
end)

addSection(pageShop, "FILTER ALAT GEAR SHOP (PILIH YANG DIBELI)")
for gearItem, _ in pairs(config.targetGears) do
    local isPicked = config.targetGears[gearItem]
    addToggle(pageShop, "🛒 " .. gearItem, isPicked, function(val)
        config.targetGears[gearItem] = val
    end)
end

addSection(pageShop, "TOKO KHUSUS & PENAWARAN LANGKA")
addToggle(pageShop, tr("AutoBuyMerchant"), config.autoBuyMerchant, function(val)
    config.autoBuyMerchant = val
end)
addToggle(pageShop, tr("AutoBuyTicketMarket"), config.autoBuyTicketMarket, function(val)
    config.autoBuyTicketMarket = val
end)

-- TAB 5: PETS & REWARDS
local pagePet = createTab("Pets", tr("TabPetRewards"))
addSection(pagePet, tr("SecEggs"))
addToggle(pagePet, tr("AutoHatchEgg"), config.autoHatchEgg, function(val)
    config.autoHatchEgg = val
end)
addToggle(pagePet, tr("AutoEquipBest"), config.autoEquipBest, function(val)
    config.autoEquipBest = val
end)
addToggle(pagePet, tr("AutoOpenPacks"), config.autoOpenPacks, function(val)
    config.autoOpenPacks = val
end)

addSection(pagePet, tr("SecDailyQuests"))
addToggle(pagePet, tr("AutoClaimDaily"), config.autoClaimDaily, function(val)
    config.autoClaimDaily = val
end)
addToggle(pagePet, tr("AutoClaimPlaytime"), config.autoClaimPlaytime, function(val)
    config.autoClaimPlaytime = val
end)
addToggle(pagePet, tr("AutoClaimQuests"), config.autoClaimQuests, function(val)
    config.autoClaimQuests = val
end)
addButton(pagePet, tr("AutoRedeemCodes"), "🎁", function()
    config.autoRedeemCodes = true
    runRewardsAndCodes()
    showNotification("👑 BROTHER HUB", "Seluruh kode promo berhasil diklaim!", 4)
end)

-- TAB 6: TELEPORT HUB
local pageTP = createTab("Teleport", tr("TabTeleport"))
addSection(pageTP, tr("SecPlotTP"))
addButton(pageTP, tr("TPHomePlot"), "🏡", returnToOwnPlot)
for tName, tPos in pairs(TYCOON_LOCATIONS) do
    addButton(pageTP, "Plot: " .. tName, "📍", function()
        safeTeleport(tPos)
    end)
end

addSection(pageTP, tr("SecAreaTP"))
for aName, aInfo in pairs(SAPLING_AREAS) do
    addButton(pageTP, "Zona: " .. aName, "🌲", function()
        safeTeleport(aInfo.pos)
    end)
end

addSection(pageTP, tr("SecShopTP"))
for sName, sPos in pairs(SHOP_LOCATIONS) do
    addButton(pageTP, "Toko: " .. sName, "🏪", function()
        safeTeleport(sPos)
    end)
end

-- TAB 7: VISUALS & ESP
local pageVisual = createTab("Visuals", tr("TabVisualESP"))
addSection(pageVisual, tr("SecRadar"))
addToggle(pageVisual, tr("SaplingESP"), config.saplingESP, function(val)
    config.saplingESP = val
    updateESP()
end)
addToggle(pageVisual, tr("RivalTreeESP"), config.rivalTreeESP, function(val)
    config.rivalTreeESP = val
    updateESP()
end)
addToggle(pageVisual, tr("PlayerESP"), config.playerESP, function(val)
    config.playerESP = val
    updateESP()
end)
addToggle(pageVisual, tr("Fullbright"), config.fullbright, function(val)
    config.fullbright = val
    pcall(function()
        local Lighting = game:GetService("Lighting")
        if val then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = true
        end
    end)
end)

-- TAB 8: MOVEMENT & UTILITIES
local pageMove = createTab("Movement", tr("TabMovement"))
addSection(pageMove, tr("SecMove"))

-- TP-Walk Engine (Speed Bypass Bebas Reset Server & Bebas Rubberband)
addToggle(pageMove, tr("TPWalk"), config.tpWalk, function(val)
    config.tpWalk = val
    if val then
        showNotification("⚡ TP-WALK AKTIF", "Bypass Speed aktif! Bebas berlari kencang tanpa rubberband & bebas reset base!", 4)
    else
        pcall(function()
            local root = getRoot()
            if root then
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            end
        end)
    end
end)
addSlider(pageMove, tr("TPWalkSpeed"), 20, 250, config.tpWalkSpeed, function(val)
    config.tpWalkSpeed = val
end)

addToggle(pageMove, "Aktifkan WalkSpeed Klasik", config.walkSpeedEnabled, function(val)
    config.walkSpeedEnabled = val
    if not val then
        pcall(function() getHum().WalkSpeed = 16 end)
    end
end)
addSlider(pageMove, tr("SafeSpeedNotice"), 16, 75, config.walkSpeedValue, function(val)
    config.walkSpeedValue = val
end)

addToggle(pageMove, "Aktifkan JumpPower Kustom", config.jumpPowerEnabled, function(val)
    config.jumpPowerEnabled = val
    if not val then
        pcall(function() getHum().JumpPower = 50 end)
    end
end)
addSlider(pageMove, tr("JumpPower"), 50, 300, config.jumpPowerValue, function(val)
    config.jumpPowerValue = val
end)

addToggle(pageMove, tr("Noclip"), config.noclip, function(val)
    config.noclip = val
    if not val then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end)
    end
end)

addToggle(pageMove, tr("Fly"), config.fly, function(val)
    config.fly = val
end)
addSlider(pageMove, "Kecepatan Terbang (Fly Speed)", 20, 150, config.flySpeed, function(val)
    config.flySpeed = val
end)

addToggle(pageMove, tr("InfJump"), config.infJump, function(val)
    config.infJump = val
end)

addToggle(pageMove, tr("AntiAfk"), config.antiAfk, function(val)
    config.antiAfk = val
end)

-- Click TP Tool
addButton(pageMove, tr("ClickTP"), "🎯", function()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.Name = "👑 BH ClickTP"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local pos = mouse.Hit.Position
        safeTeleport(pos + Vector3.new(0, 3, 0))
    end)
    tool.Parent = LocalPlayer:FindFirstChild("Backpack")
    showNotification("👑 BROTHER HUB", "Alat ClickTP telah dimasukkan ke tas!", 3)
end)

-- TAB 9: CREDIT & DONATE (STANDAR BAKU RESMI BROTHER HUB)
local pageCredit = createTab("Credit", tr("TabCredit"))
addSection(pageCredit, "KOMUNITAS & LINK RESMI BROTHER HUB")
addButton(pageCredit, "Salin Link Discord Server", "💬", function()
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/szYbZCqHKS")
            showNotification("👑 BROTHER HUB", "Link Discord tersalin ke clipboard!", 3)
        end
    end)
end)

addSection(pageCredit, "DUKUNGAN & DONASI FOUNDER")
addButton(pageCredit, "Donasi via Saweria (GoPay / OVO / Dana / QRIS)", "☕", function()
    pcall(function()
        if setclipboard then
            setclipboard("https://saweria.co/prawiraxliv")
            showNotification("👑 BROTHER HUB", "Link Saweria tersalin: saweria.co/prawiraxliv", 4)
        end
    end)
end)
addButton(pageCredit, "Donasi via SociaBuzz (Tribe / QRIS / VA)", "💎", function()
    pcall(function()
        if setclipboard then
            setclipboard("https://sociabuzz.com/brotherhubofficial/tribe")
            showNotification("👑 BROTHER HUB", "Link SociaBuzz tersalin ke clipboard!", 4)
        end
    end)
end)

addSection(pageCredit, "PENGEMBANG UTAMA")
local founderCard = Instance.new("Frame", pageCredit)
founderCard.Size = UDim2.new(1, 0, 0, 45)
founderCard.BackgroundColor3 = THEME.Card
corner(founderCard, 8)
stroke(founderCard, THEME.Border, 1)

local founderLbl = Instance.new("TextLabel", founderCard)
founderLbl.Size = UDim2.new(1, -20, 1, 0)
founderLbl.Position = UDim2.new(0, 10, 0, 0)
founderLbl.BackgroundTransparency = 1
founderLbl.Text = "👑 Founder & Lead Developer: prawiraxliv\n💎 Brother Hub Official Ecosystem • Version 1.0"
founderLbl.TextColor3 = THEME.Gold
founderLbl.Font = THEME.Font
founderLbl.TextSize = 12
founderLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Language Switcher Callback
LangBtn.MouseButton1Click:Connect(function()
    currentLang = (currentLang == "ID") and "EN" or "ID"
    config.language = currentLang
    LangBtn.Text = currentLang == "ID" and "🇮🇩" or "🇬🇧"
    HeaderTitle.Text = tr("HubTitle")
    saveConfig()
    showNotification("👑 BROTHER HUB", currentLang == "ID" and "Bahasa diubah ke Indonesia 🇮🇩" or "Language changed to English 🇬🇧", 3)
end)

-- [15] CORE LOOPS & EVENT HOOKS
registerConnection(RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end

        -- Noclip
        if config.noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        -- WalkSpeed
        local hum = getHum(char)
        if hum then
            if config.walkSpeedEnabled then
                hum.WalkSpeed = math.clamp(config.walkSpeedValue, 16, 60)
            end
            if config.jumpPowerEnabled then
                hum.JumpPower = config.jumpPowerValue
            end
        end
    end)
end))

-- TP-Walk Engine (Zero Rubberband Physics Velocity Bypass • Bebas Blink-Blink & Bebas Reset Base)
registerConnection(RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        if config.tpWalk then
            local char = LocalPlayer.Character
            local root = getRoot(char)
            local hum = getHum(char)
            if root and hum then
                -- Jaga WalkSpeed normal <= 55 agar anti-cheat server TIDAK PERNAH mereset karakter ke base!
                if hum.WalkSpeed > 55 then
                    hum.WalkSpeed = 16
                end
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    local targetVel = md.Unit * config.tpWalkSpeed
                    root.AssemblyLinearVelocity = Vector3.new(targetVel.X, root.AssemblyLinearVelocity.Y, targetVel.Z)
                else
                    -- Saat berhenti bergerak, nolkan velocity horizontal agar tidak tergelincir
                    root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                end
            end
        end
    end)
end))

-- Fly Engine
local flyBodyGyro, flyBodyVel
registerConnection(RunService.Heartbeat:Connect(function()
    pcall(function()
        local root = getRoot()
        local hum = getHum()
        if not root or not hum then return end

        if config.fly then
            if not flyBodyGyro then
                flyBodyGyro = Instance.new("BodyGyro", root)
                flyBodyGyro.P = 9e4
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.CFrame = root.CFrame
            end
            if not flyBodyVel then
                flyBodyVel = Instance.new("BodyVelocity", root)
                flyBodyVel.Velocity = Vector3.zero
                flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            end

            local camCF = Camera.CFrame
            local moveVec = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0, 1, 0) end

            flyBodyVel.Velocity = moveVec * config.flySpeed
            flyBodyGyro.CFrame = camCF
        else
            if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
            if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
        end
    end)
end))

-- Infinite Jump
registerConnection(UserInputService.JumpRequest:Connect(function()
    if config.infJump then
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- Anti-AFK
registerConnection(LocalPlayer.Idled:Connect(function()
    if config.antiAfk then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end))

-- Auto Loop Threads
registerThread(function()
    while true do
        task.wait(0.8)
        pcall(runStealSaplingsCycle)
    end
end)

-- Thread runStealRivalTreesCycle dinonaktifkan total agar tidak pernah menyentuh kebun lawan

registerThread(function()
    while true do
        task.wait(1.0)
        pcall(runAutoPlantAndGarden)
    end
end)

registerThread(function()
    while true do
        task.wait(0.3)
        pcall(runTreadmillBooster)
    end
end)

registerThread(function()
    while true do
        task.wait(5.0)
        pcall(runShopPurchases)
    end
end)

registerThread(function()
    while true do
        task.wait(8.0)
        pcall(runRewardsAndCodes)
    end
end)

registerThread(function()
    while true do
        task.wait(1.5)
        pcall(updateESP)
    end
end)

notify("👑 BROTHER HUB", "Steal A Tree Master Suite Aktif!", 5)
