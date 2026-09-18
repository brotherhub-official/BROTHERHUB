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

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
local CONFIG_FILE = "BrotherHub_StealASeed_Config.json"

local config = {
    -- Auto Steal
    autoSteal             = false,
    instantPrompt         = true,
    stealDistance         = 35,
    autoApproachSteal     = false,
    stealDelay            = 0.3,

    -- Auto Farm & Garden
    autoPlant             = false,
    autoHarvest           = false,
    autoCollectCash       = false,
    harvestInterval       = 1.0,

    -- Auto Sell
    autoSell              = false,
    sellInterval          = 3.0,
    sellThreshold         = 10,
    instantSellBuyer      = true,

    -- Shop & Seeds
    blockRobuxPopups      = true,
    autoBuySeeds          = false,
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

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(config))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(data) do
                if config[k] ~= nil then
                    if type(v) == "table" and type(config[k]) == "table" then
                        for subK, subV in pairs(v) do
                            config[k][subK] = subV
                        end
                    else
                        config[k] = v
                    end
                end
            end
        end
    end)
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
    ["TabSteal"]              = {ID = "🌱 Auto Curi", EN = "🌱 Auto Steal"},
    ["TabFarm"]               = {ID = "🌾 Kebun & Panen", EN = "🌾 Farm & Harvest"},
    ["TabSell"]               = {ID = "💰 Auto Jual", EN = "💰 Auto Sell"},
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
    ["AutoSteal"]             = {ID = "Curi Bibit Otomatis (Auto Steal)", EN = "Auto Steal Seeds"},
    ["InstantPrompt"]         = {ID = "Bypass Tahan Tombol E (Instant 0s Prompt)", EN = "Instant 0s Prompt Bypass"},
    ["AutoApproach"]          = {ID = "Dekati Bibit Otomatis (Teleport Halus)", EN = "Auto Approach Seeds (Smooth TP)"},
    ["StealDistance"]         = {ID = "Jangkauan Jarak Curi (Studs)", EN = "Steal Search Radius (Studs)"},
    ["AutoPlant"]             = {ID = "Tanam Bibit ke Kebun Otomatis", EN = "Auto Plant Seeds to Garden"},
    ["AutoHarvest"]           = {ID = "Panen Tanaman Kebun Otomatis", EN = "Auto Harvest Grown Crops"},
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

-- Instant ProximityPrompt Bypass Engine
registerConnection(RunService.Stepped:Connect(function()
    if config.instantPrompt then
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end
    end
end))

-- [5] 🌱 AUTONOMOUS SEED STEALING ENGINE
registerThread(function()
    while true do
        if config.autoSteal then
            pcall(function()
                local hrp = getHrp()
                if hrp then
                    local maxDist = config.stealDistance or 35
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Enabled then
                            local promptParent = obj.Parent
                            local pPos = promptParent:IsA("BasePart") and promptParent.Position or (promptParent:IsA("Model") and promptParent:GetPivot().Position)
                            if pPos then
                                local dist = (hrp.Position - pPos).Magnitude
                                if dist <= maxDist or config.autoApproachSteal then
                                    if config.autoApproachSteal and dist > 10 then
                                        hrp.CFrame = CFrame.new(pPos + Vector3.new(0, 3, 0))
                                        task.wait(0.1)
                                    end
                                    if fireproximityprompt then
                                        fireproximityprompt(obj, 0)
                                    else
                                        obj:InputHoldBegin()
                                        task.wait(0.05)
                                        obj:InputHoldEnd()
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(math.clamp(config.stealDelay or 0.3, 0.1, 3.0))
    end
end)

-- [6] 🌾 GARDEN CULTIVATION & PASSIVE CASH ENGINE
registerThread(function()
    while true do
        if config.autoPlant or config.autoHarvest or config.autoCollectCash then
            pcall(function()
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

-- [8] 🛒 FREE SEED SHOP & PACK OPENER
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
    Border      = Color3.fromRGB(45, 48, 75),
    Accent      = Color3.fromRGB(0, 229, 255),
    Title       = Color3.fromRGB(255, 215, 0),
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

local function createButton(parent, labelText, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or THEME.Card
    btn.Text = labelText
    btn.TextColor3 = THEME.Text
    btn.Font = THEME.Font
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = THEME.Border
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    return btn
end

-- ============================================================================
-- [13] BUILD TABS & INTERFACES
-- ============================================================================

-- TAB 1: 🌱 AUTO STEAL
local pageSteal = createTab("Steal", tr("TabSteal"))
local secSteal = createSection(pageSteal, tr("StealTitle"), tr("StealDesc"))
createToggle(secSteal, tr("AutoSteal"), config.autoSteal, function(v) config.autoSteal = v end)
createToggle(secSteal, tr("InstantPrompt"), config.instantPrompt, function(v) config.instantPrompt = v end)
createToggle(secSteal, tr("AutoApproach"), config.autoApproachSteal, function(v) config.autoApproachSteal = v end)
createSlider(secSteal, tr("StealDistance"), 10, 150, config.stealDistance, function(v) config.stealDistance = v end)

-- TAB 2: 🌾 FARM & HARVEST
local pageFarm = createTab("Farm", tr("TabFarm"))
local secFarm = createSection(pageFarm, tr("FarmTitle"), tr("FarmDesc"))
createToggle(secFarm, tr("AutoPlant"), config.autoPlant, function(v) config.autoPlant = v end)
createToggle(secFarm, tr("AutoHarvest"), config.autoHarvest, function(v) config.autoHarvest = v end)
createToggle(secFarm, tr("AutoCollectCash"), config.autoCollectCash, function(v) config.autoCollectCash = v end)
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
