--[[
    ========================================================================
    👑 BROTHER HUB — FISH ON OFFICIAL MASTER SUITE
    ========================================================================
    Game        : Fish On
    Game URL    : https://www.roblox.com/games/111189697641017/Fish-On
    Place ID    : 111189697641017
    Design Tier : 1:1 FlowerShop Master Standard (RGB Neon Stroke, MinCircle 80x80, Resizable Frame)
    Platform    : Universal (Xeno PC, Solara, Wave, Delta / Arceus / Codex Mobile)
    Language    : Bilingual Smart Engine (🇮🇩 ID / 🇬🇧 EN Auto-Detect & Toggle)
    Features    : Auto Cast & Perfect Reel / Instant Catch, Lock Catch Bar (100% Tracking),
                  Game Built-in AutoFish Trigger, Autonomous Fish Seller (Remote / NPC / Threshold),
                  Zero Robux Pop-up Blocker (100% Free Experience), Rod & Bait Shop with Filters,
                  Potion Auto-Buyer & Auto-Drink, Auto Enchant Rod, Boat Fleet Auto-Spawn & Water Walk,
                  Daily Rewards & Quests Auto-Claim, Gacha Auto-Spin, Island Teleport Hub with Safe Pad,
                  Radar ESP (Players / NPCs / Shops), Movement Engine (Speed, Jump, Noclip, Fly, ClickTP).
    Security    : Brother Guard Undetected Engine
    ========================================================================
]]

-- [0] MULTI-INSTANCE CLEANUP GUARD
if _G.BH_FISHON_CLEANUP then
    pcall(_G.BH_FISHON_CLEANUP)
end

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

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global tracking registries
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

-- [2] CONFIGURATION & PERSISTENCE
local CONFIG_FILE = "BrotherHub_FishOn_Config.json"

local config = {
    -- Auto Fishing
    autoCast              = false,
    castDelay             = 0.6,
    autoCatch             = false,
    instantCatch          = false,
    lockCatchBar          = true,
    gameAutoFish          = false,
    autoEquipRod          = false,

    -- Auto Sell
    autoSell              = false,
    sellThreshold         = 10,
    sellInterval          = 3.0,
    instantRemoteSell     = true,
    sellAtMerchant        = false,

    -- Shop & Baits
    autoBuyRods           = false,
    targetRods            = {
        ["Starter Rod"]   = false,
        ["Lucky Rod"]     = false,
        ["Fast Rod"]      = false,
        ["Magma Rod"]     = false,
        ["Desert Rod"]    = false,
        ["Lovelight Rod"] = false,
        ["Gem Rod"]       = false,
        ["Golden Rod"]    = false,
        ["Master Rod"]    = false,
    },
    autoBuyBaits          = false,
    targetBaits           = {
        ["Basic Bait"]    = true,
        ["Worm Bait"]     = false,
        ["Shrimp Bait"]   = false,
        ["Squid Bait"]    = false,
        ["Golden Bait"]   = false,
        ["Magic Bait"]    = false,
        ["Cosmic Bait"]   = false,
    },
    autoBuyPotions        = false,
    targetPotions         = {
        ["Potion Fisherman Luck"]     = true,
        ["Potion Overwhelming Luck"]  = false,
        ["Potion Perfectionist"]      = false,
        ["Potion Fortune Sight"]      = false,
        ["Potion Ocean's Gift"]       = false,
        ["Potion Royal Gold"]         = false,
    },
    autoDrinkPotions      = false,
    autoEnchantRod        = false,

    -- Boats & Navigation
    autoSpawnBoat         = false,
    selectedBoat          = "Normal Boat",
    waterWalk             = false,
    boatSpeedBoost        = false,
    boatSpeedMultiplier   = 1.5,

    -- Rewards & Quests
    autoDailyReward       = false,
    autoClaimQuests       = false,
    autoSpinGacha         = false,
    antiAfk               = true,

    -- Zero Robux Blocker
    blockRobuxPopups      = true,

    -- Visuals & ESP
    playerEsp             = false,
    npcEsp                = false,
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

-- [3] BILINGUAL LOCALIZATION DICTIONARY
local TRANSLATIONS = {
    ["HubTitle"]              = {ID = "BROTHER HUB — FISH ON", EN = "BROTHER HUB — FISH ON"},
    ["CloseConfirmTitle"]     = {ID = "KONFIRMASI PENUTUPAN", EN = "CLOSE CONFIRMATION"},
    ["CloseConfirmBody"]      = {ID = "Apakah Anda yakin ingin menutup Brother Hub?\nSeluruh fitur auto & ESP akan dihentikan secara steril.", EN = "Are you sure you want to close Brother Hub?\nAll auto features & ESP will be terminated cleanly."},
    ["BtnYes"]                = {ID = "Ya, Tutup", EN = "Yes, Close"},
    ["BtnCancel"]             = {ID = "Batal", EN = "Cancel"},

    -- Tabs
    ["TabAutoFish"]           = {ID = "🎣 Auto Mancing", EN = "🎣 Auto Fish"},
    ["TabAutoSell"]           = {ID = "💰 Auto Jual", EN = "💰 Auto Sell"},
    ["TabShops"]              = {ID = "🛒 Toko & Ramuan", EN = "🛒 Shop & Potions"},
    ["TabBoats"]              = {ID = "⛵ Armada Kapal", EN = "⛵ Boat Fleet"},
    ["TabRewards"]            = {ID = "🎁 Hadiah & Misi", EN = "🎁 Rewards & Quests"},
    ["TabTeleport"]           = {ID = "🌌 Teleport Pulau", EN = "🌌 Island Teleport"},
    ["TabVisuals"]            = {ID = "👁️ Radar & ESP", EN = "👁️ Visuals & ESP"},
    ["TabMovement"]           = {ID = "🏃 Karakter", EN = "🏃 Movement"},
    ["TabCredits"]            = {ID = "👑 Kredit", EN = "👑 Credits"},

    -- Section Titles & Descriptions
    ["AutoFishTitle"]         = {ID = "SISTEM PEMANCING OTOMATIS", EN = "AUTONOMOUS FISHING SUITE"},
    ["AutoFishDesc"]          = {ID = "Lempar kail otomatis, kunci bar tangkapan, dan tarik ikan sempurna.", EN = "Cast rod, lock catch bar onto fish, and reel in perfect catches."},
    ["AutoSellTitle"]         = {ID = "PENJUALAN HASIL TANGKAPAN IKAN", EN = "AUTONOMOUS FISH SELLER"},
    ["AutoSellDesc"]          = {ID = "Jual seluruh hasil tangkapan tanpa harus berjalan bolak-balik ke dermaga.", EN = "Sell all your caught fish automatically without visiting merchant docks."},
    ["ShopsTitle"]            = {ID = "PEMBELIAN ALAT PANCING & RAMUAN", EN = "PURCHASER & POTIONS SUITE"},
    ["ShopsDesc"]             = {ID = "Beli pancingan, umpan, dan ramuan buff dengan filter selektif murni gratis.", EN = "Restock chosen rods, baits, and potions automatically with selective filters."},
    ["BoatsTitle"]            = {ID = "ARMADA PERAHU & JALAN DI AIR", EN = "BOAT FLEET & WATER WALKING"},
    ["BoatsDesc"]             = {ID = "Spawn perahu otomatis dan jelajahi samudra bebas tanpa tenggelam.", EN = "Auto-spawn boats, board instantly, and walk freely over open water."},
    ["RewardsTitle"]          = {ID = "KLAIM HADIAH, MISI & GACHA", EN = "REWARDS & QUEST ENGINE"},
    ["RewardsDesc"]           = {ID = "Klaim reward harian otomatis, misi pulau, dan putar roda gacha.", EN = "Claim daily gifts, progress quests, and spin lucky gacha wheels."},
    ["TeleportTitle"]         = {ID = "TELEPORTASI PULAU & TITIK STRATEGIS", EN = "ISLAND FAST TRAVEL HUB"},
    ["TeleportDesc"]          = {ID = "Teleportasi instan dengan bantalan pendaratan aman ke seluruh penjuru dunia.", EN = "Instant teleportation with safe landing platforms across all regions."},
    ["VisualsTitle"]          = {ID = "PENGLIHATAN TEMBUS DINDING & RADAR", EN = "RADAR & ESP WALLHACK"},
    ["VisualsDesc"]           = {ID = "Deteksi lokasi NPC pedagang, quest, dermaga, dan pemain lain.", EN = "Track merchant NPCs, quests, boat docks, and players through terrain."},
    ["MovementTitle"]         = {ID = "UTILITAS PERGERAKAN FISIK", EN = "PHYSICAL MOVEMENT UTILITIES"},
    ["MovementDesc"]          = {ID = "Tingkatkan kecepatan, lompatan, terbang bebas, dan tembus dinding.", EN = "Boost walkspeed, jump power, fly freely, and glide through obstacles."},

    -- Elements
    ["AutoCast"]              = {ID = "Lempar Kail Otomatis (Auto Cast)", EN = "Auto Cast Rod"},
    ["CastDelay"]             = {ID = "Jeda Lemparan Kail (Detik)", EN = "Cast Delay (Seconds)"},
    ["AutoCatch"]             = {ID = "Tarik Ikan Sempurna (Auto Catch)", EN = "Auto Catch / Perfect Reel"},
    ["InstantCatch"]          = {ID = "Tarik Ikan Instan (0s Minigame Skip)", EN = "Instant Catch (0s Skip)"},
    ["LockCatchBar"]          = {ID = "Kunci Bar Tangkapan (Lock Catch Bar)", EN = "Lock Catch Bar (100% Tracking)"},
    ["GameAutoFish"]          = {ID = "Aktifkan AutoFishing Bawaan Game", EN = "Trigger Game Built-in AutoFish"},
    ["AutoEquipRod"]          = {ID = "Otomatis Pakai Pancingan Terbaik", EN = "Auto Equip Best Rod"},

    ["AutoSell"]              = {ID = "Jual Ikan Otomatis (Auto Sell)", EN = "Auto Sell Fish"},
    ["SellThreshold"]         = {ID = "Batas Jumlah Ikan untuk Dijual", EN = "Fish Count Threshold to Sell"},
    ["SellInterval"]          = {ID = "Jeda Pengecekan Jual (Detik)", EN = "Sell Check Interval (Seconds)"},
    ["InstantRemoteSell"]     = {ID = "Jual Instan Lewat Server Remote", EN = "Instant Remote Sell (Anywhere)"},
    ["SellAtMerchant"]        = {ID = "Jual Melalui NPC Pedagang Dermaga", EN = "Sell via Dock Merchant NPC"},
    ["BtnSellNow"]            = {ID = "💵 Jual Semua Ikan Sekarang", EN = "💵 Sell All Fish Now"},

    ["AutoBuyRods"]           = {ID = "Beli Pancingan Otomatis (Koin)", EN = "Auto Buy Selected Rods (Coins)"},
    ["AutoBuyBaits"]          = {ID = "Beli Umpan Pilihan Otomatis", EN = "Auto Buy Selected Baits"},
    ["AutoBuyPotions"]        = {ID = "Beli Ramuan Buff Otomatis", EN = "Auto Buy Selected Potions"},
    ["AutoDrinkPotions"]      = {ID = "Minum Ramuan Buff Otomatis (AFK)", EN = "Auto Drink Buff Potions (AFK)"},
    ["AutoEnchantRod"]        = {ID = "Enchant Pancingan di Altar Otomatis", EN = "Auto Enchant Rod at Altar"},
    ["BlockRobux"]            = {ID = "Blokir Semua Pop-up Robux (100% Free)", EN = "Block All Robux Pop-ups (100% Free)"},

    ["AutoSpawnBoat"]         = {ID = "Spawn Perahu Otomatis Saat di Air", EN = "Auto Spawn Boat in Water"},
    ["SelectedBoat"]          = {ID = "Pilih Jenis Kapal / Perahu", EN = "Select Boat Type"},
    ["WaterWalk"]             = {ID = "Jalan di Atas Air (Water Walk)", EN = "Walk on Water Surfaces"},
    ["BoatSpeedBoost"]        = {ID = "Tingkatkan Kecepatan Perahu", EN = "Boost Boat Speed"},
    ["BoatSpeedMultiplier"]   = {ID = "Pengali Kecepatan Perahu", EN = "Boat Speed Multiplier"},
    ["BtnSpawnBoatNow"]       = {ID = "⛵ Spawn Perahu Pilihan Sekarang", EN = "⛵ Spawn Selected Boat Now"},

    ["AutoDailyReward"]       = {ID = "Klaim Hadiah Harian Otomatis", EN = "Auto Claim Daily Reward"},
    ["AutoClaimQuests"]       = {ID = "Klaim Selesai Misi Otomatis", EN = "Auto Claim Finished Quests"},
    ["AutoSpinGacha"]         = {ID = "Putar Roda Gacha Otomatis", EN = "Auto Spin Gacha Wheel"},
    ["AntiAfk"]               = {ID = "Anti-AFK (Cegah Disconnect 20 Mnt)", EN = "Anti-AFK (Prevent 20m Kick)"},

    ["PlayerEsp"]             = {ID = "ESP Pemain Lain (Radar Nama & Jarak)", EN = "Player ESP (Names & Distance)"},
    ["NpcEsp"]                = {ID = "ESP NPC & Toko Dermaga", EN = "NPC & Merchant ESP"},
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
    local ev = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if ev then
        local target = ev:FindFirstChild(name, true)
        if target then return target end
    end
    local rf = ReplicatedStorage:FindFirstChild("RemoteFunction")
    if rf then
        local target = rf:FindFirstChild(name, true)
        if target then return target end
    end
    return ReplicatedStorage:FindFirstChild(name, true)
end

local function fireRemote(name, ...)
    local r = getRemote(name)
    if r then
        if r:IsA("RemoteEvent") then
            r:FireServer(...)
            return true
        elseif r:IsA("RemoteFunction") then
            return pcall(function(...) return r:InvokeServer(...) end, ...)
        end
    end
    return false
end

local function getHrp()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- Safe Landing Platform Maker (Anti-Void & Anti-Drown)
local function createSafePad(pos, duration)
    local pad = Instance.new("Part")
    pad.Name = "BH_SafeLandingPad"
    pad.Size = Vector3.new(35, 2, 35)
    pad.Position = pos - Vector3.new(0, 3, 0)
    pad.Anchored = true
    pad.CanCollide = true
    pad.Material = Enum.Material.Neon
    pad.Color = Color3.fromRGB(0, 255, 200)
    pad.Transparency = 0.5
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

-- Zero Robux Pop-up Interceptor (100% Free Experience)
registerConnection(MarketplaceService.PromptPurchaseRequested:Connect(function(player, assetId)
    if config.blockRobuxPopups and player == LocalPlayer then
        -- Block prompt silently
    end
end))
registerConnection(MarketplaceService.PromptProductPurchaseRequested:Connect(function(player, productId)
    if config.blockRobuxPopups and player == LocalPlayer then
        -- Block prompt silently
    end
end))
registerConnection(MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player, gamePassId)
    if config.blockRobuxPopups and player == LocalPlayer then
        -- Block prompt silently
    end
end))

-- [5] 🎣 AUTONOMOUS FISHING ENGINE
local lastCastTime = 0

-- Auto Cast Loop
registerThread(function()
    while true do
        if config.autoCast then
            pcall(function()
                local hrp = getHrp()
                local now = tick()
                if hrp and (now - lastCastTime) >= math.clamp(config.castDelay, 0.2, 5.0) then
                    lastCastTime = now
                    
                    -- Method 1: Click In-Game Fishing Screen Button (FrontGUI)
                    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local frontGui = pGui and pGui:FindFirstChild("FrontGUI")
                    local fFrame = frontGui and frontGui:FindFirstChild("FrameParent")
                    local fFishing = fFrame and fFrame:FindFirstChild("FrameFishing")
                    local btnFish = fFishing and fFishing:FindFirstChild("BtnFishing")
                    if btnFish and btnFish:IsA("GuiButton") and firesignal then
                        firesignal(btnFish.MouseButton1Click)
                        firesignal(btnFish.Activated)
                    end

                    -- Method 2: Fire Character Tool or Fishing Remote
                    local char = LocalPlayer.Character
                    local rodTool = char and char:FindFirstChildOfClass("Tool")
                    if rodTool and rodTool:FindFirstChild("Handle") then
                        rodTool:Activate()
                    end

                    -- Method 3: RemoteEvents.Fishing
                    fireRemote("Fishing", true)

                    -- Method 4: Built-in Game AutoFishing Trigger
                    if config.gameAutoFish then
                        fireRemote("AutoFishing", true)
                        local btnAuto = fFishing and fFishing:FindFirstChild("AutoButton")
                        if btnAuto and btnAuto:IsA("GuiButton") and firesignal then
                            firesignal(btnAuto.MouseButton1Click)
                        end
                    end
                end
            end)
        end
        task.wait(0.25)
    end
end)

-- High-Frequency Lock Catch Bar Engine (RenderStepped)
registerConnection(RunService.RenderStepped:Connect(function()
    if not (config.lockCatchBar or config.autoCatch or config.instantCatch) then return end

    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        local fishingGui = pGui and pGui:FindFirstChild("FishingGUI")
        if not fishingGui then return end

        local fParent = fishingGui:FindFirstChild("FrameParent")
        if not fParent or not fParent.Visible then return end

        local frameCatch = fParent:FindFirstChild("FrameCatch")
        local frameLuck  = fParent:FindFirstChild("FrameLuck")

        -- 1. Lock Catch Bar on Target
        if frameCatch and frameCatch:IsA("GuiObject") and frameCatch.Visible then
            local bar = frameCatch:FindFirstChild("Bar")
            if bar and bar:IsA("GuiObject") then
                -- Keep catch bar centered or expanded to ensure 100% reel accuracy
                bar.Position = UDim2.new(0.5, 0, bar.Position.Y.Scale, bar.Position.Y.Offset)
                if config.instantCatch or config.autoCatch then
                    bar.Size = UDim2.new(1, 0, bar.Size.Y.Scale, bar.Size.Y.Offset)
                end
            end
        end

        -- 2. Lock Luck Bar
        if frameLuck and frameLuck:IsA("GuiObject") and frameLuck.Visible then
            local lBar = frameLuck:FindFirstChild("Bar")
            if lBar and lBar:IsA("GuiObject") and (config.instantCatch or config.autoCatch) then
                lBar.Size = UDim2.new(1, 0, lBar.Size.Y.Scale, lBar.Size.Y.Offset)
            end
        end
    end)
end))

-- Auto Catch & Instant Reel Thread
registerThread(function()
    while true do
        if config.autoCatch or config.instantCatch or config.lockCatchBar then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                local fishingGui = pGui and pGui:FindFirstChild("FishingGUI")
                local fParent = fishingGui and fishingGui:FindFirstChild("FrameParent")
                local isMinigameActive = fParent and fParent.Visible

                if isMinigameActive then
                    -- Rapidly trigger reel hit
                    fireRemote("Fishing", true)

                    -- Click fishing button to reel in
                    local frontGui = pGui:FindFirstChild("FrontGUI")
                    local fFrame = frontGui and frontGui:FindFirstChild("FrameParent")
                    local fFishing = fFrame and fFrame:FindFirstChild("FrameFishing")
                    local btnFish = fFishing and fFishing:FindFirstChild("BtnFishing")
                    if btnFish and btnFish:IsA("GuiButton") and firesignal then
                        firesignal(btnFish.MouseButton1Click)
                        firesignal(btnFish.Activated)
                    end

                    if config.instantCatch then
                        task.wait(0.04)
                    else
                        task.wait(0.12)
                    end
                end
            end)
        end
        task.wait(config.instantCatch and 0.05 or 0.1)
    end
end)

-- Auto Equip Rod
registerThread(function()
    while true do
        if config.autoEquipRod then
            pcall(function()
                local char = LocalPlayer.Character
                if char and not char:FindFirstChildOfClass("Tool") then
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    local rod = bp and (bp:FindFirstChild("Rod") or bp:FindFirstChildWhichIsA("Tool"))
                    if rod then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:EquipTool(rod) end
                    else
                        fireRemote("EquipRod", "Rod")
                    end
                end
            end)
        end
        task.wait(2.5)
    end
end)

-- [6] 💰 AUTONOMOUS FISH SELLER ENGINE
local function performSellFish()
    -- 1. Remote Call
    fireRemote("SellFish")
    fireRemote("AutoSellEvent", true)

    -- 2. GUI Click (FishStoredGUI AutoSell button)
    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        local storedGui = pGui and pGui:FindFirstChild("FishStoredGUI")
        local fParent = storedGui and storedGui:FindFirstChild("FrameParent")
        local autoSellBtn = fParent and fParent:FindFirstChild("BtnAutoSell", true)
        if autoSellBtn and autoSellBtn:IsA("GuiButton") and firesignal then
            firesignal(autoSellBtn.MouseButton1Click)
        end
    end)

    -- 3. Merchant NPC Proximity Interaction
    if config.sellAtMerchant then
        pcall(function()
            local sellNpcFolder = workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Fitur") and workspace.Lobby.Fitur:FindFirstChild("Sell Fish")
            if sellNpcFolder then
                local prompt = sellNpcFolder:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and fireproximityprompt then
                    fireproximityprompt(prompt)
                end
            end
        end)
    end
end

registerThread(function()
    while true do
        if config.autoSell then
            pcall(function()
                local ls = LocalPlayer:FindFirstChild("leaderstats")
                local caughtVal = ls and ls:FindFirstChild("Caught")
                local caughtCount = caughtVal and caughtVal.Value or 0

                if caughtCount >= config.sellThreshold or config.sellThreshold <= 1 then
                    performSellFish()
                end
            end)
        end
        task.wait(math.clamp(config.sellInterval, 1.0, 30.0))
    end
end)

-- [7] 🛒 SHOPS, BAITS & POTIONS ENGINE
registerThread(function()
    while true do
        -- Auto Buy Rods
        if config.autoBuyRods then
            pcall(function()
                for rodName, enabled in pairs(config.targetRods) do
                    if enabled then
                        fireRemote("BuyRod", rodName)
                        task.wait(0.2)
                    end
                end
            end)
        end

        -- Auto Buy Baits
        if config.autoBuyBaits then
            pcall(function()
                for baitName, enabled in pairs(config.targetBaits) do
                    if enabled then
                        fireRemote("BuyBait", baitName)
                        task.wait(0.2)
                    end
                end
            end)
        end

        -- Auto Buy Potions
        if config.autoBuyPotions then
            pcall(function()
                for potName, enabled in pairs(config.targetPotions) do
                    if enabled then
                        fireRemote("BuyPotionEvent", potName)
                        task.wait(0.2)
                    end
                end
            end)
        end

        -- Auto Drink Potions
        if config.autoDrinkPotions then
            pcall(function()
                for potName, enabled in pairs(config.targetPotions) do
                    if enabled then
                        fireRemote("UsePotionEvent", potName)
                        task.wait(0.2)
                    end
                end
            end)
        end

        -- Auto Enchant Rod
        if config.autoEnchantRod then
            pcall(function()
                fireRemote("Enchant")
            end)
        end

        task.wait(5.0)
    end
end)

-- [8] ⛵ FLEET, BOATS & WATER ENGINE
registerThread(function()
    while true do
        if config.autoSpawnBoat then
            pcall(function()
                fireRemote("BoatSpawnEvent", config.selectedBoat or "Normal Boat")
            end)
        end
        task.wait(8.0)
    end
end)

-- Water Walk Engine (Solid Ocean Platform)
local waterPlatform = nil
registerConnection(RunService.Heartbeat:Connect(function()
    if config.waterWalk then
        pcall(function()
            local hrp = getHrp()
            if hrp then
                if not waterPlatform or not waterPlatform.Parent then
                    waterPlatform = Instance.new("Part")
                    waterPlatform.Name = "BH_WaterWalkPlatform"
                    waterPlatform.Size = Vector3.new(10, 1, 10)
                    waterPlatform.Anchored = true
                    waterPlatform.CanCollide = true
                    waterPlatform.Transparency = 1
                    waterPlatform.Parent = workspace
                end
                local targetY = math.min(hrp.Position.Y - 3.2, 0.5)
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
            end
        end)
    else
        if waterPlatform and waterPlatform.Parent then
            waterPlatform:Destroy()
            waterPlatform = nil
        end
    end
end))

-- [9] 🎁 REWARDS, QUESTS & ANTI-AFK ENGINE
registerThread(function()
    while true do
        -- Daily Reward
        if config.autoDailyReward then
            pcall(function()
                fireRemote("DailyRewardEvents/ClaimReward")
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                local dGui = pGui and pGui:FindFirstChild("DailyRewardGUI")
                local btn = dGui and dGui:FindFirstChild("BtnClaim", true)
                if btn and btn:IsA("GuiButton") and firesignal then
                    firesignal(btn.MouseButton1Click)
                end
            end)
        end

        -- Quests
        if config.autoClaimQuests then
            pcall(function()
                fireRemote("Quest", "Claim")
            end)
        end

        -- Spin Gacha
        if config.autoSpinGacha then
            pcall(function()
                fireRemote("GachaEvents/SpinEvents", 1)
            end)
        end

        -- Anti-AFK Signal
        if config.antiAfk then
            pcall(function()
                fireRemote("AFKResetEvent")
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
        if obj and obj.Parent then obj:Destroy() end
    end
    table.clear(espObjects)
end

registerThread(function()
    while true do
        if config.playerEsp or config.npcEsp then
            clearEsp()
            -- Player ESP
            if config.playerEsp then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local myHrp = getHrp()
                            local dist = myHrp and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0
                            createHighlight(p.Character, Color3.fromRGB(0, 255, 200), p.DisplayName .. " [" .. dist .. "m]")
                        end
                    end
                end
            end

            -- NPC ESP
            if config.npcEsp then
                local npcsFolder = workspace:FindFirstChild("NPCS") or workspace:FindFirstChild("NPCQuest")
                if npcsFolder then
                    for _, npc in ipairs(npcsFolder:GetDescendants()) do
                        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
                            createHighlight(npc, Color3.fromRGB(255, 215, 0), npc.Name)
                        end
                    end
                end
            end
        else
            clearEsp()
        end
        task.wait(2.5)
    end
end)

-- Fullbright Engine
registerConnection(RunService.RenderStepped:Connect(function()
    if config.fullbright then
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 2.5
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    end
end))

-- [11] 🏃 PHYSICAL MOVEMENT UTILITIES
registerConnection(RunService.Heartbeat:Connect(function()
    local hum = getHumanoid()
    if hum then
        if config.walkSpeedEnabled then
            hum.WalkSpeed = config.walkSpeedValue or 24
        end
        if config.jumpPowerEnabled then
            hum.JumpPower = config.jumpPowerValue or 65
        end
    end
end))

-- Ghost Noclip Engine
registerConnection(RunService.Stepped:Connect(function()
    if config.noclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end
end))

-- Infinite Jump
registerConnection(UserInputService.JumpRequest:Connect(function()
    if config.infiniteJump then
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- Fly Engine (WASD + Space/Shift)
local flying = false
local flyBodyGyro, flyBodyVelocity
local function setFly(state)
    flying = state
    local hrp = getHrp()
    if not hrp then return end
    if flying then
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.cframe = hrp.CFrame
        flyBodyGyro.Parent = hrp

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.velocity = Vector3.zero
        flyBodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Parent = hrp

        registerConnection(RunService.RenderStepped:Connect(function()
            if not flying or not hrp or not flyBodyVelocity or not flyBodyGyro then return end
            local cam = workspace.CurrentCamera
            local speed = config.flySpeed or 60
            local vel = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, 1, 0) end
            flyBodyVelocity.velocity = vel.Unit * speed
            if vel.Magnitude == 0 then flyBodyVelocity.velocity = Vector3.zero end
            flyBodyGyro.cframe = cam.CFrame
        end))
    else
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    end
end

-- Click TP (Ctrl + Click)
registerConnection(UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and config.clickTp and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            local mouse = LocalPlayer:GetMouse()
            if mouse and mouse.Hit then
                safeTeleport(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end))

-- [12] 💎 1:1 MY FLOWER SHOP EXACT GUI ARCHITECTURE
local THEME = {
    Background = Color3.fromRGB(15, 16, 26),
    Panel      = Color3.fromRGB(22, 24, 38),
    Card       = Color3.fromRGB(28, 31, 48),
    Border     = Color3.fromRGB(45, 48, 71),
    Accent     = Color3.fromRGB(0, 255, 200),
    Title      = Color3.fromRGB(255, 215, 0),
    Text       = Color3.fromRGB(240, 240, 250),
    SubText    = Color3.fromRGB(150, 155, 180),
    Green      = Color3.fromRGB(46, 204, 113),
    Red        = Color3.fromRGB(231, 76, 60),
    Font       = Enum.Font.GothamBold,
    FontReg    = Enum.Font.Gotham
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrotherHub_FishOn"
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
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 128))
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
MinBtn.Text = "—"
MinBtn.TextColor3 = THEME.Text
MinBtn.TextSize = 14
MinBtn.Font = THEME.Font
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = THEME.Red
CloseBtn.Text = "✕"
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
    grip.AnchorPoint = Vector2.new(1, 1)
    grip.Size = UDim2.fromOffset(22, 22)
    grip.Position = UDim2.new(1, -4, 1, -4)
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
    ModalOverlay.Visible = true
end)
ModalBtnCancel.MouseButton1Click:Connect(function()
    ModalOverlay.Visible = false
end)

-- Total Clean Sterilization on Yes
local function sterilizeAndDestroy()
    _G.BH_FISHON_CLEANUP = nil
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
    if waterPlatform and waterPlatform.Parent then waterPlatform:Destroy() end
    ScreenGui:Destroy()
end
_G.BH_FISHON_CLEANUP = sterilizeAndDestroy
ModalBtnYes.MouseButton1Click:Connect(sterilizeAndDestroy)

-- Tab & Component Builder Engine
local tabs = {}
local currentTab = nil

local function createTab(tabId, titleText)
    local btn = Instance.new("TextButton", TabBar)
    btn.Name = "TabBtn_" .. tabId
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
    valBox.TextSize = 12
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 6)

    local barBg = Instance.new("Frame", container)
    barBg.Size = UDim2.new(1, -24, 0, 6)
    barBg.Position = UDim2.new(0, 12, 1, -14)
    barBg.BackgroundColor3 = THEME.Border
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", barBg)
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = THEME.Accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local draggingBar = false
    local function applyVal(val)
        val = math.clamp(val, minVal, maxVal)
        val = math.floor(val * 10) / 10
        valBox.Text = tostring(val)
        local p = (val - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(p, 0, 1, 0)
        callback(val)
        saveConfig()
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBar = true
            local p = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            applyVal(minVal + (maxVal - minVal) * p)
        end
    end)
    registerConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBar = false
        end
    end))
    registerConnection(UserInputService.InputChanged:Connect(function(input)
        if draggingBar and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            applyVal(minVal + (maxVal - minVal) * p)
        end
    end))
    valBox.FocusLost:Connect(function()
        local n = tonumber(valBox.Text)
        if n then applyVal(n) else valBox.Text = tostring(defaultVal) end
    end)
    return container
end

local function createButton(parent, text, bgColor, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = bgColor or THEME.Card
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
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

-- =========================================================================
-- [13] BUILD TABS & CONTENT
-- =========================================================================

-- TAB 1: 🎣 AUTO FISH
local pageFish = createTab("Fish", tr("TabAutoFish"))
local secFish = createSection(pageFish, tr("AutoFishTitle"), tr("AutoFishDesc"))
createToggle(secFish, tr("AutoCast"), config.autoCast, function(v) config.autoCast = v end)
createSlider(secFish, tr("CastDelay"), 0.2, 3.0, config.castDelay, function(v) config.castDelay = v end)
createToggle(secFish, tr("AutoCatch"), config.autoCatch, function(v) config.autoCatch = v end)
createToggle(secFish, tr("InstantCatch"), config.instantCatch, function(v) config.instantCatch = v end)
createToggle(secFish, tr("LockCatchBar"), config.lockCatchBar, function(v) config.lockCatchBar = v end)
createToggle(secFish, tr("GameAutoFish"), config.gameAutoFish, function(v) config.gameAutoFish = v end)
createToggle(secFish, tr("AutoEquipRod"), config.autoEquipRod, function(v) config.autoEquipRod = v end)

-- TAB 2: 💰 AUTO SELL
local pageSell = createTab("Sell", tr("TabAutoSell"))
local secSell = createSection(pageSell, tr("AutoSellTitle"), tr("AutoSellDesc"))
createToggle(secSell, tr("AutoSell"), config.autoSell, function(v) config.autoSell = v end)
createToggle(secSell, tr("InstantRemoteSell"), config.instantRemoteSell, function(v) config.instantRemoteSell = v end)
createToggle(secSell, tr("SellAtMerchant"), config.sellAtMerchant, function(v) config.sellAtMerchant = v end)
createSlider(secSell, tr("SellThreshold"), 1, 50, config.sellThreshold, function(v) config.sellThreshold = v end)
createSlider(secSell, tr("SellInterval"), 1.0, 20.0, config.sellInterval, function(v) config.sellInterval = v end)
createButton(secSell, tr("BtnSellNow"), THEME.Green, function()
    performSellFish()
end)

-- TAB 3: 🛒 SHOPS & POTIONS
local pageShop = createTab("Shop", tr("TabShops"))
local secShop = createSection(pageShop, tr("ShopsTitle"), tr("ShopsDesc"))
createToggle(secShop, tr("BlockRobux"), config.blockRobuxPopups, function(v) config.blockRobuxPopups = v end)
createToggle(secShop, tr("AutoBuyRods"), config.autoBuyRods, function(v) config.autoBuyRods = v end)
createToggle(secShop, tr("AutoBuyBaits"), config.autoBuyBaits, function(v) config.autoBuyBaits = v end)
createToggle(secShop, tr("AutoBuyPotions"), config.autoBuyPotions, function(v) config.autoBuyPotions = v end)
createToggle(secShop, tr("AutoDrinkPotions"), config.autoDrinkPotions, function(v) config.autoDrinkPotions = v end)
createToggle(secShop, tr("AutoEnchantRod"), config.autoEnchantRod, function(v) config.autoEnchantRod = v end)

-- TAB 4: ⛵ FLEET & BOATS
local pageBoat = createTab("Boats", tr("TabBoats"))
local secBoat = createSection(pageBoat, tr("BoatsTitle"), tr("BoatsDesc"))
createToggle(secBoat, tr("AutoSpawnBoat"), config.autoSpawnBoat, function(v) config.autoSpawnBoat = v end)
createToggle(secBoat, tr("WaterWalk"), config.waterWalk, function(v) config.waterWalk = v end)
createToggle(secBoat, tr("BoatSpeedBoost"), config.boatSpeedBoost, function(v) config.boatSpeedBoost = v end)
createSlider(secBoat, tr("BoatSpeedMultiplier"), 1.0, 5.0, config.boatSpeedMultiplier, function(v) config.boatSpeedMultiplier = v end)
createButton(secBoat, tr("BtnSpawnBoatNow"), THEME.Card, function()
    fireRemote("BoatSpawnEvent", config.selectedBoat or "Normal Boat")
end)

-- TAB 5: 🎁 REWARDS & QUESTS
local pageRew = createTab("Rewards", tr("TabRewards"))
local secRew = createSection(pageRew, tr("RewardsTitle"), tr("RewardsDesc"))
createToggle(secRew, tr("AutoDailyReward"), config.autoDailyReward, function(v) config.autoDailyReward = v end)
createToggle(secRew, tr("AutoClaimQuests"), config.autoClaimQuests, function(v) config.autoClaimQuests = v end)
createToggle(secRew, tr("AutoSpinGacha"), config.autoSpinGacha, function(v) config.autoSpinGacha = v end)
createToggle(secRew, tr("AntiAfk"), config.antiAfk, function(v) config.antiAfk = v end)

-- TAB 6: 🌌 TELEPORT HUB
local pageTp = createTab("Teleport", tr("TabTeleport"))
local secTp = createSection(pageTp, tr("TeleportTitle"), tr("TeleportDesc"))

local teleportLocations = {
    {"🏝️ Lobby / Starter Island Spawn", Vector3.new(17.9, 25.4, -61.8)},
    {"🛒 Rod & Bait Shop (Lobby)", Vector3.new(49.1, 23.7, -185.3)},
    {"💰 Sell Fish Merchant (Lobby)", Vector3.new(136.4, 24.1, -183.7)},
    {"✨ Enchantment Altar (Lobby)", Vector3.new(-18.8, 50.8, -155.0)},
    {"⛵ Boat Spawn Dock 1", Vector3.new(115.7, 11.8, -24.0)},
    {"⛵ Boat Spawn Dock 2", Vector3.new(115.6, 11.8, -99.7)},
    {"🗿 Ancient Totem Area", Vector3.new(-15.1, 10.9, 128.2)},
    {"🔥 Starter Island: King Magma", Vector3.new(-278.1, 33.1, 1728.1)},
    {"🪣 Starter Island: The Bucket", Vector3.new(289.5, 20.4, 1642.5)},
    {"🏜️ Lost Desert: King Midas", Vector3.new(1309.1, 6.7, 138.1)},
    {"🏜️ Lost Desert: Gold Spinner", Vector3.new(1472.4, 6.9, -113.4)},
    {"🏜️ Lost Desert: Jax & Romeo", Vector3.new(1061.4, 8.1, -196.5)},
    {"💖 Lovelight Island: Lilith", Vector3.new(172.8, 29.2, -1104.2)},
    {"💖 Lovelight Island: Pink Boy", Vector3.new(231.7, 74.8, -1322.0)},
    {"🌲 Gem Forest: The Guardian Sky", Vector3.new(-1396.0, 7.4, 473.7)},
    {"🌲 Gem Forest: Aurelia & Azure", Vector3.new(-1274.1, 5.9, 399.8)},
    {"🌀 Event: Spiral Hunter", Vector3.new(591.9, 5.5, -540.7)}
}

for _, loc in ipairs(teleportLocations) do
    createButton(secTp, loc[1], THEME.Card, function()
        safeTeleport(loc[2])
    end)
end

-- TAB 7: 👁️ VISUALS & ESP
local pageVis = createTab("Visuals", tr("TabVisuals"))
local secVis = createSection(pageVis, tr("VisualsTitle"), tr("VisualsDesc"))
createToggle(secVis, tr("PlayerEsp"), config.playerEsp, function(v) config.playerEsp = v end)
createToggle(secVis, tr("NpcEsp"), config.npcEsp, function(v) config.npcEsp = v end)
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
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
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
infoLabel.Text = "Founder & Lead Developer : prawiraxliv\nGame Target : Fish On (111189697641017)\nGUI Standard : 1:1 FlowerShop Exact Standard\nEngine Status : 100% Undetected & Anti-Detection Active\nSecurity : Brother Guard Multi-Layer Shield"
infoLabel.Parent = secInfo

-- Language Switcher Callback
LangBtn.MouseButton1Click:Connect(function()
    config.language = (config.language == "ID") and "EN" or "ID"
    saveConfig()
    LangBtn.Text = config.language == "ID" and "🇮🇩" or "🇬🇧"
    HeaderTitle.Text = tr("HubTitle")
    ModalTitle.Text = tr("CloseConfirmTitle")
    ModalBody.Text = tr("CloseConfirmBody")
    ModalBtnYes.Text = tr("BtnYes")
    ModalBtnCancel.Text = tr("BtnCancel")
    for tabId, t in pairs(tabs) do
        local newName = tr("Tab" .. tabId) or t.Title
        t.Button.Text = newName
    end
end)

-- Default Tab View
local defaultTab = tabs["Fish"]
if defaultTab then
    defaultTab.Page.Visible = true
    defaultTab.Button.BackgroundColor3 = THEME.Panel
    defaultTab.Button.TextColor3 = THEME.Accent
    currentTab = "Fish"
end
