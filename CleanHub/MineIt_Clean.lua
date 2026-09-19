-- =================================================================
-- Script  : MINE IT - BROTHER HUB OFFICIAL MASTER SCRIPT
-- Game    : Mine It (Roblox Place ID: 92345193036001)
-- Author  : BROTHER HUB
-- Support : PC, Mobile, Tablet, Laptop (Universal Responsive UI)
-- =================================================================

-- Multi-Instance Cleanup Guard
if _G.BH_MINEIT_CLEANUP then
    pcall(_G.BH_MINEIT_CLEANUP)
end

local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")
local Workspace         = game:GetService("Workspace")
local VirtualUser       = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local Lighting          = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

-- Telemetry Logger
local function sendExecutionLog(scriptTitle)
    if _G.BROTHERHUB_TRACKED_MINEIT then return end
    _G.BROTHERHUB_TRACKED_MINEIT = true

    task.spawn(function()
        pcall(function()
            local MarketplaceService = game:GetService("MarketplaceService")
            local lp = LocalPlayer or Players.PlayerAdded:Wait()
            local httpReq = (syn and syn.request) or (http and http.request) or http_request or request or (Fluxus and Fluxus.request)
            if not httpReq then return end

            local gName = "Mine It"
            pcall(function()
                local info = MarketplaceService:GetProductInfo(game.PlaceId)
                if info and info.Name then gName = info.Name end
            end)

            local execName = "Unknown Executor"
            pcall(function()
                if identifyexecutor then execName = identifyexecutor()
                elseif getexecutorname then execName = getexecutorname()
                end
            end)

            local userId = tostring(lp.UserId or 0)
            local username = tostring(lp.Name or "Unknown")
            local displayName = tostring(lp.DisplayName or username)
            local accountAge = tostring(lp.AccountAge or 0) .. " Days"
            local placeId = tostring(game.PlaceId or 0)
            local jobId = (game.JobId ~= "" and game.JobId) or "Private/Studio"
            if #jobId > 18 then jobId = string.sub(jobId, 1, 18) .. "..." end
            local now = os.time()

            local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
            local profileUrl = "https://www.roblox.com/users/" .. userId .. "/profile"

            local wh = "https://discord.com/api/webhooks/1548038487125524632/ysx1rK4m002JjgbK25bLsGEP_U75gsFvIFG0o0XU1GJAdjj-3UUNZHVJLZJu7Y3x_O7b"

            local payload = {
                username = "Brother Hub Telemetry",
                avatar_url = "https://cdn.discordapp.com/icons/1547929421284114453/45d5b82878099746173bff32ee6a53e1.png?size=512",
                embeds = {
                    {
                        title = "⚡ SCRIPT EXECUTED | BROTHER HUB",
                        description = "Seorang pemain baru saja mengeksekusi script **BROTHER HUB** di game Mine It.",
                        color = 0x00FFC8,
                        thumbnail = { url = avatarUrl },
                        fields = {
                            { name = "👤 Pemain", value = "[" .. username .. "](" .. profileUrl .. ") (`" .. displayName .. "`)", inline = true },
                            { name = "🆔 User ID", value = "`" .. userId .. "`", inline = true },
                            { name = "📅 Usia Akun", value = "`" .. accountAge .. "`", inline = true },
                            { name = "🎮 Game", value = "`" .. gName .. "`", inline = true },
                            { name = "📜 Script", value = "`" .. (scriptTitle or "Mine It Hub") .. "`", inline = true },
                            { name = "⚙️ Executor", value = "`" .. execName .. "`", inline = true },
                            { name = "📍 Place ID", value = "`" .. placeId .. "`", inline = true },
                            { name = "🌐 Job ID", value = "`" .. jobId .. "`", inline = true },
                            { name = "⏰ Waktu Eksekusi", value = "<t:" .. tostring(now) .. ":F> (<t:" .. tostring(now) .. ":R>)", inline = false },
                        },
                        footer = {
                            text = "Brother Hub Analytics • Strictly Confidential",
                            icon_url = "https://cdn.discordapp.com/icons/1547929421284114453/45d5b82878099746173bff32ee6a53e1.png?size=512"
                        }
                    }
                }
            }

            httpReq({
                Url = wh,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

sendExecutionLog("Mine It")

-- Anti-AFK Keep-Alive
task.spawn(function()
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end)
end)

-- Resource & Connection Trackers
local activeConnections = {}
local activeThreads = {}
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

-- =================================================================
-- THEME & DESIGN TOKENS (1:1 MY FLOWER SHOP EXACT STANDARD)
-- =================================================================
local THEME = {
    Bg          = Color3.fromRGB(15, 17, 24),
    Panel       = Color3.fromRGB(24, 27, 38),
    Slot        = Color3.fromRGB(34, 38, 54),
    Stroke      = Color3.fromRGB(52, 60, 84),
    Title       = Color3.fromRGB(255, 215, 0), -- Gold
    Text        = Color3.fromRGB(240, 244, 255),
    SubText     = Color3.fromRGB(150, 160, 185),
    Green       = Color3.fromRGB(46, 213, 115),
    Red         = Color3.fromRGB(255, 71, 87),
    Blue        = Color3.fromRGB(40, 130, 230),
    Purple      = Color3.fromRGB(150, 90, 230),
    Gold        = Color3.fromRGB(255, 215, 0),
    Cyan        = Color3.fromRGB(0, 255, 200),
    Font        = Enum.Font.GothamBold,
    FontMedium  = Enum.Font.GothamMedium,
    FontBlack   = Enum.Font.GothamBlack
}

-- Master Ore & Stone Catalog
local ALL_ORES = {
    "Stone", "Coal", "Copper", "Iron", "Gold", "Titanium", 
    "VoidShard", "Basalt", "Cobalt", "Lead", "Mythril", 
    "Sapphire", "Zinc", "Aluminium", "Arcadium"
}

-- =================================================================
-- MASTER FLAGS & CONFIG
-- =================================================================
local Flags = {
    -- Auto Farm
    AutoMine            = false,
    AutoSolveMinigame   = true,
    InstantPerfect      = true,
    HitTimingMode       = "Perfect", -- "Perfect" or "Any Success"
    AutoApproach        = true,
    TargetRegion        = "All", -- "All", "MinersVillage", "Cave", "Forest", "Jungle", "Emberfall"
    MineRadius          = 60,
    FastSwing           = true,
    AutoCollectDrops    = true,
    AutoChestOpen       = true,

    -- Multi-Select Ores & Priority System (Like Seed Selection in Flower Shop)
    SelectedOres        = {
        ["Stone"]       = true,
        ["Coal"]        = true,
        ["Copper"]      = true,
        ["Iron"]        = true,
        ["Gold"]        = true,
        ["Titanium"]    = true,
        ["VoidShard"]   = true,
        ["Basalt"]      = true,
        ["Cobalt"]      = true,
        ["Lead"]        = true,
        ["Mythril"]     = true,
        ["Sapphire"]    = true,
        ["Zinc"]        = true,
        ["Aluminium"]   = true,
        ["Arcadium"]    = true,
    },
    PriorityOre         = "None", -- "None" or any ore name from ALL_ORES

    -- Advanced AFK Systems (From Deep Dump Analysis)
    AutoBuyBlackMarket  = false,
    AutoBuyClanMerchant = false,
    AutoLuckyBloodline  = false,
    BloodlineStopTier   = "Legendary", -- "Legendary", "Epic"
    AutoEnchantAltar    = false,
    AutoReforgeAccs     = false,
    AutoEnhanceEquip    = false,
    AutoCraftRunes      = false,
    AutoActivateTotems  = false,
    AutoLearnRecipes    = true,
    AutoDrinkPotions    = false,
    AutoBuyPotions      = false,
    AutoClaimDailyQuests= true,
    AutoClaimMasteries  = true,
    AutoSnipeRareSpawns = false,
    MaintainMiningStreak= true,

    -- Stone Size Filter
    TargetSize          = "All", -- "All", "Besar", "Sedang", "Kecil"

    -- Attack Stance Position
    AttackPosition      = "In Front", -- "In Front", "Above", "Underneath"
    StanceDistance      = 3.5, -- studs offset

    -- Movement Approach Method
    ApproachMethod      = "Teleport", -- "Teleport", "Fly", "Walk"
    FlyApproachSpeed    = 60,
    WalkApproachSpeed   = 28,
    TeleportInterval    = 0.15,

    -- Sell & Inventory Suite (Selective Sell & Quantity Control)
    AutoSell            = false,
    AutoSellInterval    = 15,
    SellOres            = true,
    SellAccessories     = false,
    AutoEquipBest       = true,
    AutoEquipInterval   = 10,
    SellMode            = "Selected", -- "Selected" (Pilih item) or "All" (Jual semua)
    LockRareOres        = true,       -- Proteksi ore langka dari penjualan tidak sengaja
    SellQuantity        = 0,          -- 0 = Jual seluruh stok terpilih, >0 = batasi jumlah penjualan
    SelectedSellOres    = {
        ["Stone"]       = true,
        ["Coal"]        = true,
        ["Copper"]      = true,
        ["Iron"]        = true,
        ["Basalt"]      = true,
        ["Cobalt"]      = true,
        ["Lead"]        = true,
        ["Zinc"]        = true,
        ["Aluminium"]   = true,
        ["Gold"]        = false,
        ["Titanium"]    = false,
        ["VoidShard"]   = false,
        ["Mythril"]     = false,
        ["Sapphire"]    = false,
        ["Arcadium"]    = false,
    },

    -- Shop Purchase Suite (Selective Buy & Quantity Control)
    ShopBuyMode         = "Selected", -- "Selected" or "BuyAll"
    ShopBuyQuantity     = 1,
    ShopSelectedItems   = {
        ["WoodenPickaxe"]   = false,
        ["StonePickaxe"]    = false,
        ["IronPickaxe"]     = false,
        ["CrystalPickaxe"]  = false,
        ["PureGoldPickaxe"] = false,
        ["EmeraldPickaxe"]  = false,
        ["LavaPickaxe"]     = false,
        ["SpeedPotion"]     = false,
        ["LuckPotion"]      = false,
    },

    -- Crafting & Upgrades
    AutoCraftPickaxes   = false,
    AutoCraftAccessory  = false,
    CraftRarityPriority = "Best", -- "Best" or "Worse"

    -- Rewards & Quests
    AutoDailyRewards    = true,
    AutoLikeRewards     = true,
    AutoClaimQuests     = true,

    -- Player Utilities
    WalkSpeedOn         = false,
    WalkSpeedVal        = 28,
    JumpPowerOn         = false,
    JumpPowerVal        = 70,
    NoclipOn            = false,
    FlyOn               = false,
    FlySpeed            = 60,
    InfiniteJumpOn      = false,
    FullbrightOn        = false,

    -- ESP Radar
    EspStones           = false,
    EspSizeFilter       = "All", -- "All", "Besar", "Sedang", "Kecil"
    EspNPCs             = false,
    EspSellZones        = false,
    EspPlayers          = false,
    MaxEspDistance      = 400
}

-- Known World Locations
local WORLD_LOCATIONS = {
    { Name = "Miners Village (Lobby)", Pos = Vector3.new(-70, -36, -145), Category = "Regions" },
    { Name = "Cave Region",            Pos = Vector3.new(-220, -45, -310), Category = "Regions" },
    { Name = "Forest Region",          Pos = Vector3.new(-890, -2, 180), Category = "Regions" },
    { Name = "Jungle Region",          Pos = Vector3.new(-970, -2, 150), Category = "Regions" },
    { Name = "Emberfall Region",       Pos = Vector3.new(180, -46, -410), Category = "Regions" },
    { Name = "Emberfall Vault",        Pos = Vector3.new(240, -46, -430), Category = "Regions" },

    -- Presisi Koordinat dari Dump Tambahan 4 Workspace:
    { Name = "Village Sell Zone (SellBoth)", Pos = Vector3.new(339.6, 15.7, -380.1), Category = "Shops & Zones" },
    { Name = "Potion Merchant #1",          Pos = Vector3.new(-1019.8, 55.7, -1470.0), Category = "Shops & Zones" },
    { Name = "Potion Merchant #2",          Pos = Vector3.new(-1028.4, 55.7, -1479.5), Category = "Shops & Zones" },
    { Name = "Reforger & Blacksmith",       Pos = Vector3.new(1333.1, -7.0, -545.5), Category = "Shops & Zones" },
    { Name = "Clan Merchant Booth",         Pos = Vector3.new(-111.4, -31.1, 461.0), Category = "Shops & Zones" },
    { Name = "Enchanting Table & Altar",    Pos = Vector3.new(-967.7, -7.3, 207.8), Category = "Shops & Zones" },

    { Name = "Totem #1 (Mountain Peak)",    Pos = Vector3.new(11732.9, 1.3, -28847.0), Category = "Totems" },
    { Name = "Totem #2 (Underground Abyss)",Pos = Vector3.new(4358.9, -47.8, -3996.5), Category = "Totems" },
    { Name = "Totem #3 (Celestial Island)", Pos = Vector3.new(14113.4, -154.8, -20274.9), Category = "Totems" },

    { Name = "Jungle Secret Portal",        Pos = Vector3.new(884.2, 0.4, 661.2), Category = "Portals" },
    { Name = "Mysterious Portal #1",        Pos = Vector3.new(-2067.8, -1.0, -195.7), Category = "Portals" },
    { Name = "Mysterious Portal #2",        Pos = Vector3.new(-1594.7, 42.3, 133.4), Category = "Portals" },
    { Name = "Mysterious Portal #3",        Pos = Vector3.new(-2384.7, 42.3, 147.0), Category = "Portals" },
    { Name = "Village Sell Zone",      Pos = Vector3.new(-187.6, -37.4, -202.3), Category = "Shops & Zones" },
    { Name = "Forest Sell Zone",       Pos = Vector3.new(-932.5, -3.3, 152.3), Category = "Shops & Zones" },
    { Name = "Emberfall Sell Zone",    Pos = Vector3.new(186.7, -52.4, -398.0), Category = "Shops & Zones" },
    { Name = "Shop Miner (Village)",   Pos = Vector3.new(-81.1, -36.1, -149.1), Category = "Shops & Zones" },
    { Name = "Shop Miner (Forest)",    Pos = Vector3.new(-971.8, -2.3, 167.3), Category = "Shops & Zones" },
    { Name = "Crafting Station",       Pos = Vector3.new(-165, -37, -210), Category = "Shops & Zones" },
    { Name = "Enhancer Station",       Pos = Vector3.new(-175, -37, -225), Category = "Shops & Zones" },
    { Name = "Bloodline Altar",        Pos = Vector3.new(-200, -37, -240), Category = "Shops & Zones" },

    { Name = "Jungle Portal",          Pos = Vector3.new(-950, -2, 160), Category = "Portals" },
    { Name = "Mysterious Portal",      Pos = Vector3.new(-210, -44, -300), Category = "Portals" },
    { Name = "Cave Gate",              Pos = Vector3.new(-180, -40, -280), Category = "Portals" },
    { Name = "Entrance Gate",          Pos = Vector3.new(-60, -36, -120), Category = "Portals" }
}

-- Copy to Clipboard Helper
local function copyToClipboard(text, notice)
    pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
        elseif set_clipboard then
            set_clipboard(text)
        elseif Clipboard and Clipboard.set then
            Clipboard.set(text)
        end
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "👑 BROTHER HUB OFFICIAL",
            Text = (notice or "Link disalin ke clipboard!") .. "\n" .. text,
            Duration = 5
        })
    end)
end

-- =================================================================
-- STONE DETECTION & CLASSIFICATION LOGIC
-- =================================================================

-- 1. Identify Ore Type
local function getStoneOreType(stoneName)
    local sn = stoneName:lower()
    for _, ore in ipairs(ALL_ORES) do
        if sn:find(ore:lower()) then
            return ore
        end
    end
    return "Stone"
end

-- 2. Identify Size Category (Besar, Sedang, Kecil)
local function getStoneSizeCategory(stoneModel, primaryPart)
    local sz = primaryPart and primaryPart.Size or Vector3.new(6, 6, 6)
    if stoneModel:IsA("Model") then
        local _, bSz = stoneModel:GetBoundingBox()
        sz = bSz
    end
    local maxDim = math.max(sz.X, sz.Y, sz.Z)
    if maxDim >= 18 then
        return "Besar", maxDim
    elseif maxDim >= 10 then
        return "Sedang", maxDim
    else
        return "Kecil", maxDim
    end
end

-- 3. Find Currently Equipped Pickaxe Tool
local function getEquippedPickaxe()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("pickaxe") or item:FindFirstChild("Handle.001") or item:FindFirstChild("Cube")) then
            return item
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("pickaxe") or item:FindFirstChild("Handle.001") or item:FindFirstChild("Cube")) then
                return item
            end
        end
    end
    return nil
end

local function ensurePickaxeEquipped()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end

    local tool = getEquippedPickaxe()
    if tool and tool.Parent ~= char then
        pcall(function() hum:EquipTool(tool) end)
    end
    return tool
end

-- 4. Scan Minable Stones with Filters & Priority Ordering
local function scanMinableStones(maxDist)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return {} end

    maxDist = maxDist or Flags.MineRadius or 60
    local spawnedStonesFolder = Workspace:FindFirstChild("spawned_stones")
    if not spawnedStonesFolder then return {} end

    local candidates = {}
    local chosenRegion = Flags.TargetRegion

    local function processRegionFolder(regionFolder)
        if not regionFolder then return end
        for _, stoneModel in ipairs(regionFolder:GetChildren()) do
            if stoneModel and stoneModel.Parent then
                local primaryPart = stoneModel.PrimaryPart or stoneModel:FindFirstChildWhichIsA("BasePart", true)
                if primaryPart then
                    local oreType = getStoneOreType(stoneModel.Name)
                    local sizeCat, maxDim = getStoneSizeCategory(stoneModel, primaryPart)

                    -- Filter 1: Ore Selection
                    if Flags.SelectedOres[oreType] == true then
                        -- Filter 2: Size Category
                        if Flags.TargetSize == "All" or Flags.TargetSize == sizeCat then
                            local dist = (primaryPart.Position - root.Position).Magnitude
                            if dist <= maxDist then
                                -- Priority Score: Highest if matches PriorityOre
                                local priorityScore = 0
                                if Flags.PriorityOre ~= "None" and Flags.PriorityOre == oreType then
                                    priorityScore = 10000
                                end

                                table.insert(candidates, {
                                    Model = stoneModel,
                                    Part = primaryPart,
                                    Position = primaryPart.Position,
                                    Distance = dist,
                                    Region = regionFolder.Name,
                                    Name = stoneModel.Name,
                                    OreType = oreType,
                                    SizeCat = sizeCat,
                                    MaxDim = maxDim,
                                    Score = priorityScore - dist
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    if chosenRegion == "All" then
        for _, reg in ipairs(spawnedStonesFolder:GetChildren()) do
            processRegionFolder(reg)
        end
    else
        local reg = spawnedStonesFolder:FindFirstChild(chosenRegion)
        if reg then processRegionFolder(reg) end
    end

    table.sort(candidates, function(a, b) return a.Score > b.Score end)
    return candidates
end

-- =================================================================
-- MASTER GAME AUTOMATION LOOPS
-- =================================================================

-- =================================================================
-- 1B. MINING MINIGAME AUTO SOLVER (100% PERFECT HIT REGISTRATION)
-- =================================================================
local lastMinigameHitTick = 0

local function getMiningMinigameElements()
    local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pGui then return nil end
    local miningGui = pGui:FindFirstChild("mining")
    if not miningGui or not miningGui.Enabled then return nil end

    local container = miningGui:FindFirstChild("Container")
    local mechanic = container and container:FindFirstChild("Mechanic")
    if not mechanic or not mechanic.Visible then return nil end

    local pointer = mechanic:FindFirstChild("Pointer")
    local successPart = mechanic:FindFirstChild("SuccessPart")
    local perfect = (successPart and successPart:FindFirstChild("Perfect")) or mechanic:FindFirstChild("Perfect", true)
    local mid = (successPart and successPart:FindFirstChild("Mid")) or mechanic:FindFirstChild("Mid", true)

    return {
        Gui = miningGui,
        Mechanic = mechanic,
        Pointer = pointer,
        SuccessPart = successPart,
        Perfect = perfect,
        Mid = mid
    }
end

local function executePerfectHit(pointer)
    local now = tick()
    if now - lastMinigameHitTick < 0.08 then return end
    lastMinigameHitTick = now

    -- 1. Activate Pickaxe Tool
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
    end

    -- 2. Virtual User Click at exact Pointer position / screen center
    pcall(function()
        VirtualUser:CaptureController()
        local clickPos = Vector2.new(500, 500)
        if pointer and pointer:IsA("GuiObject") then
            clickPos = Vector2.new(pointer.AbsolutePosition.X + (pointer.AbsoluteSize.X * 0.5), pointer.AbsolutePosition.Y + (pointer.AbsoluteSize.Y * 0.5))
        end
        VirtualUser:ClickButton1(clickPos)
    end)

    -- 3. Mobile MineButton Activated trigger
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local mobGui = pGui and pGui:FindFirstChild("mobile_buttons")
        local mineBtn = mobGui and mobGui:FindFirstChild("MineButton", true)
        if mineBtn and firesignal then
            firesignal(mineBtn.Activated)
        end
    end)
end

-- RenderStepped listener for ultra-precise 120 FPS frame-perfect detection
registerConnection(RunService.RenderStepped:Connect(function()
    if not (Flags.AutoMine or Flags.AutoSolveMinigame) then return end

    local mg = getMiningMinigameElements()
    if not mg or not mg.Pointer then return end

    local pointer = mg.Pointer
    local perfect = mg.Perfect
    local successPart = mg.SuccessPart
    local mid = mg.Mid

    -- Mode 1: Instant Alignment (Bypass timing bar by snapping pointer to perfect zone)
    if Flags.InstantPerfect and perfect then
        pcall(function()
            pointer.Position = UDim2.new(
                pointer.Position.X.Scale,
                pointer.Position.X.Offset,
                perfect.Position.Y.Scale,
                perfect.Position.Y.Offset
            )
        end)
    end

    -- Mode 2: Overlap calculation
    local targetZone = (Flags.HitTimingMode == "Perfect" and perfect) or perfect or successPart or mid
    if targetZone and targetZone:IsA("GuiObject") then
        local pY = pointer.AbsolutePosition.Y + (pointer.AbsoluteSize.Y * 0.5)
        local zTop = targetZone.AbsolutePosition.Y
        local zBottom = targetZone.AbsolutePosition.Y + targetZone.AbsoluteSize.Y

        -- Buffer 3 pixels tolerance
        if pY >= (zTop - 3) and pY <= (zBottom + 3) then
            executePerfectHit(pointer)
        end
    end
end))

-- 1. Auto Mine Loop with Multi-Stance & Multi-Movement Methods
registerThread(function()
    while true do
        if Flags.AutoMine then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")

                if root and hum then
                    local tool = ensurePickaxeEquipped()
                    local targets = scanMinableStones(Flags.MineRadius)

                    if #targets > 0 then
                        local bestStone = targets[1]
                        local stonePos = bestStone.Position
                        local maxDim = bestStone.MaxDim or 6

                        -- Calculate Target Stance Position (Di Atas, Di Bawah, Di Depan)
                        local stancePos
                        local stanceOffset = Flags.StanceDistance or 3.5

                        if Flags.AttackPosition == "Above" then
                            stancePos = stonePos + Vector3.new(0, (maxDim * 0.5) + stanceOffset, 0)
                        elseif Flags.AttackPosition == "Underneath" then
                            stancePos = stonePos - Vector3.new(0, (maxDim * 0.5) + stanceOffset, 0)
                        else -- "In Front"
                            local dir = (root.Position - stonePos)
                            dir = Vector3.new(dir.X, 0, dir.Z)
                            if dir.Magnitude < 0.1 then dir = Vector3.new(0, 0, 1) else dir = dir.Unit end
                            stancePos = stonePos + dir * ((maxDim * 0.5) + stanceOffset) + Vector3.new(0, 1, 0)
                        end

                        local distToStance = (root.Position - stancePos).Magnitude

                        -- Apply Movement Method: Teleport / Terbang / Jalan Kaki
                        if Flags.AutoApproach then
                            if Flags.ApproachMethod == "Teleport" then
                                if distToStance > 2 then
                                    root.CFrame = CFrame.new(stancePos, stonePos)
                                    root.AssemblyLinearVelocity = Vector3.zero
                                    root.AssemblyAngularVelocity = Vector3.zero
                                end
                            elseif Flags.ApproachMethod == "Fly" then
                                if distToStance > 2.5 then
                                    local flySpeed = Flags.FlyApproachSpeed or 60
                                    local dir = (stancePos - root.Position).Unit
                                    root.CFrame = CFrame.new(root.Position + dir * math.min(distToStance, flySpeed * 0.12), stonePos)
                                    root.AssemblyLinearVelocity = Vector3.zero
                                else
                                    root.CFrame = CFrame.new(stancePos, stonePos)
                                    root.AssemblyLinearVelocity = Vector3.zero
                                end
                            elseif Flags.ApproachMethod == "Walk" then
                                hum.WalkSpeed = Flags.WalkApproachSpeed or 28
                                hum:MoveTo(stancePos)
                            end
                        end

                        -- Check Minigame Status
                        local mg = getMiningMinigameElements()
                        local isMinigameActive = (mg ~= nil and mg.Mechanic ~= nil and mg.Mechanic.Visible)

                        if not isMinigameActive then
                            -- Pemicu awal untuk memukul batu dan memunculkan minigame
                            if tool then
                                tool:Activate()
                                pcall(function()
                                    VirtualUser:CaptureController()
                                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                                end)
                            end
                        else
                            -- Minigame sedang aktif: biarkan RenderStepped solver mengeksekusi Perfect Hit
                            if Flags.InstantPerfect and mg.Pointer and mg.Perfect then
                                executePerfectHit(mg.Pointer)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(Flags.FastSwing and 0.12 or 0.25)
    end
end)

-- 2. Auto Collect Drops & Chests
registerThread(function()
    while true do
        if Flags.AutoCollectDrops then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            local promptPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                            if promptPart and (promptPart.Position - root.Position).Magnitude <= 35 then
                                local actText = prompt.ActionText:lower()
                                if actText:find("pick") or actText:find("learn") or actText:find("open") or actText:find("claim") or actText == "" then
                                    if fireproximityprompt then
                                        fireproximityprompt(prompt, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- 3. Auto Equip Best Loop
registerThread(function()
    while true do
        if Flags.AutoEquipBest then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pGui then
                    local bpGui = pGui:FindFirstChild("backpack")
                    if bpGui then
                        for _, btn in ipairs(bpGui:GetDescendants()) do
                            if btn:IsA("ImageButton") and btn.Name == "EquipBestButton" then
                                pcall(function()
                                    if firesignal then
                                        firesignal(btn.Activated)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(Flags.AutoEquipInterval or 10)
    end
end)

-- 4. Auto Sell Engine (Selective Ores & Custom Quantity Control)
registerThread(function()
    while true do
        if Flags.AutoSell then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local sellGui = pGui and pGui:FindFirstChild("sell")

                if sellGui then
                    local selectAllBtn = sellGui:FindFirstChild("SelectAllButton", true)
                    local sellBtn = sellGui:FindFirstChild("SellButton", true)
                    local qtyBox = sellGui:FindFirstChild("QuantityBox", true) or sellGui:FindFirstChild("AmountInput", true) or sellGui:FindFirstChild("InputBox", true)

                    if Flags.SellMode == "All" and not Flags.LockRareOres then
                        if selectAllBtn and firesignal then firesignal(selectAllBtn.Activated) end
                        task.wait(0.15)
                        if sellBtn and firesignal then firesignal(sellBtn.Activated) end
                    else
                        -- Selective Ore Selling (Hanya jual ore yang dicentang user)
                        for _, itemDesc in ipairs(sellGui:GetDescendants()) do
                            if itemDesc:IsA("TextLabel") or itemDesc:IsA("TextButton") then
                                local txt = itemDesc.Text
                                for oreName, isAllowed in pairs(Flags.SelectedSellOres) do
                                    if isAllowed and txt:find(oreName) then
                                        -- Guard: Jangan jual ore langka bila LockRareOres aktif
                                        local isRare = (oreName == "Gold" or oreName == "Titanium" or oreName == "VoidShard" or oreName == "Arcadium" or oreName == "Mythril" or oreName == "Sapphire")
                                        if not (isRare and Flags.LockRareOres) then
                                            local targetBtn = itemDesc:IsA("TextButton") and itemDesc or itemDesc.Parent:FindFirstChildWhichIsA("TextButton") or itemDesc.Parent:FindFirstChildWhichIsA("ImageButton")
                                            if targetBtn and firesignal then
                                                firesignal(targetBtn.Activated)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.15)
                        -- Isi jumlah bila kotak input tersedia dan user membatasi jumlah
                        if qtyBox and Flags.SellQuantity > 0 then
                            pcall(function() qtyBox.Text = tostring(Flags.SellQuantity) end)
                        end
                        task.wait(0.1)
                        if sellBtn and firesignal then firesignal(sellBtn.Activated) end
                    end
                else
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local origCF = root.CFrame
                        local sellPos = Vector3.new(-187.6, -37.4, -202.3)
                        root.CFrame = CFrame.new(sellPos)
                        task.wait(0.4)
                        root.CFrame = origCF
                    end
                end
            end)
        end
        task.wait(Flags.AutoSellInterval or 15)
    end
end)


-- 5B. Auto Buy Black Market (Murni Koin, 100% Zero Robux)
registerThread(function()
    while true do
        if Flags.AutoBuyBlackMarket then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local bmGui = pGui and pGui:FindFirstChild("black_market")
                if bmGui and bmGui.Enabled then
                    for _, desc in ipairs(bmGui:GetDescendants()) do
                        if desc:IsA("ImageButton") and desc.Name == "CoinsBuy" and desc.Visible then
                            if firesignal then firesignal(desc.Activated) end
                        end
                    end
                end
            end)
        end
        task.wait(2)
    end
end)

-- 5C. Auto Buy Clan Merchant (Tokens)
registerThread(function()
    while true do
        if Flags.AutoBuyClanMerchant then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local cmGui = pGui and pGui:FindFirstChild("clan_merchant")
                if cmGui and cmGui.Enabled then
                    for _, desc in ipairs(cmGui:GetDescendants()) do
                        if desc:IsA("ImageButton") and desc.Name == "TokensBuy" and desc.Visible then
                            if firesignal then firesignal(desc.Activated) end
                        end
                    end
                end
            end)
        end
        task.wait(3)
    end
end)

-- 5D. Auto Lucky Reroll Bloodline
registerThread(function()
    while true do
        if Flags.AutoLuckyBloodline then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local blGui = pGui and pGui:FindFirstChild("bloodlines")
                if blGui and blGui.Enabled then
                    local curRarity = blGui:FindFirstChild("BloodlineRarity", true)
                    local curText = curRarity and curRarity.Text or ""
                    if not (Flags.BloodlineStopTier == "Legendary" and curText:find("Legendary")) and
                       not (Flags.BloodlineStopTier == "Epic" and (curText:find("Epic") or curText:find("Legendary"))) then
                        local rollBtn = blGui:FindFirstChild("LuckyRerollButton", true)
                        if rollBtn and firesignal then firesignal(rollBtn.Activated) end
                    end
                end
            end)
        end
        task.wait(0.6)
    end
end)

-- 5E. Auto Enchant Altar & Learn Recipes
registerThread(function()
    while true do
        if Flags.AutoEnchantAltar or Flags.AutoLearnRecipes then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            local actText = prompt.ActionText:lower()
                            if Flags.AutoEnchantAltar and actText:find("enchant") then
                                if (prompt.Parent.Position - root.Position).Magnitude <= 35 then
                                    if fireproximityprompt then fireproximityprompt(prompt, 0) end
                                end
                            elseif Flags.AutoLearnRecipes and actText:find("learn") then
                                if (prompt.Parent.Position - root.Position).Magnitude <= 35 then
                                    if fireproximityprompt then fireproximityprompt(prompt, 0) end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(1.5)
    end
end)

-- 5F. Auto Activate 3 Totems in World
registerThread(function()
    while true do
        if Flags.AutoActivateTotems then
            pcall(function()
                local totems = {
                    Vector3.new(11732.9, 1.3, -28847.0),
                    Vector3.new(4358.9, -47.8, -3996.5),
                    Vector3.new(14113.4, -154.8, -20274.9)
                }
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local origCF = root.CFrame
                    for _, tPos in ipairs(totems) do
                        root.CFrame = CFrame.new(tPos + Vector3.new(0, 3, 0))
                        task.wait(0.5)
                        for _, prompt in ipairs(Workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.Enabled and (prompt.Parent.Position - root.Position).Magnitude <= 25 then
                                if fireproximityprompt then fireproximityprompt(prompt, 0) end
                            end
                        end
                        task.wait(0.3)
                    end
                    root.CFrame = origCF
                end
            end)
        end
        task.wait(180)
    end
end)

-- 5G. Auto Claim Daily Quests & Masteries
registerThread(function()
    while true do
        pcall(function()
            local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if pGui then
                if Flags.AutoClaimDailyQuests then
                    local dqGui = pGui:FindFirstChild("daily_quests")
                    if dqGui and firesignal then
                        for _, btn in ipairs(dqGui:GetDescendants()) do
                            if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and (btn.Name:lower():find("claim") or btn.Name:lower():find("reward")) then
                                firesignal(btn.Activated)
                            end
                        end
                    end
                end
                if Flags.AutoClaimMasteries then
                    local mGui = pGui:FindFirstChild("masteries")
                    if mGui and firesignal then
                        for _, btn in ipairs(mGui:GetDescendants()) do
                            if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and (btn.Name:lower():find("claim") or btn.Name:lower():find("grandreward")) then
                                firesignal(btn.Activated)
                            end
                        end
                    end
                end
            end
        end)
        task.wait(5)
    end
end)

-- 5H. Auto Snipe Rare Spawn Ores
registerThread(function()
    while true do
        if Flags.AutoSnipeRareSpawns then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local rsn = pGui and pGui:FindFirstChild("rare_spawn_notifications")
                if rsn and rsn.Enabled then
                    local container = rsn:FindFirstChild("Container", true)
                    if container and container.Visible then
                        for _, stone in ipairs(Workspace:GetDescendants()) do
                            if stone:IsA("Model") and (stone.Name:find("Arcadium") or stone.Name:find("VoidShard") or stone.Name:find("Titanium")) then
                                local pivot = stone:GetPivot()
                                local char = LocalPlayer.Character
                                local root = char and char:FindFirstChild("HumanoidRootPart")
                                if root then
                                    root.CFrame = pivot * CFrame.new(0, 3.5, 0)
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(1.5)
    end
end)

-- 5. Auto Claim Rewards
registerThread(function()
    while true do
        pcall(function()
            local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if pGui then
                if Flags.AutoDailyRewards then
                    local drGui = pGui:FindFirstChild("daily_rewards")
                    if drGui and firesignal then
                        for i = 1, 7 do
                            local dayBtn = drGui:FindFirstChild("day_" .. tostring(i), true)
                            if dayBtn and dayBtn:IsA("ImageButton") then firesignal(dayBtn.Activated) end
                        end
                    end
                end
                if Flags.AutoLikeRewards then
                    local lrGui = pGui:FindFirstChild("like_rewards")
                    if lrGui and firesignal then
                        local useBtn = lrGui:FindFirstChild("UseButton", true)
                        if useBtn and useBtn:IsA("ImageButton") then firesignal(useBtn.Activated) end
                    end
                end
                if Flags.AutoClaimQuests then
                    local qGui = pGui:FindFirstChild("quests")
                    if qGui and firesignal then
                        for _, desc in ipairs(qGui:GetDescendants()) do
                            if desc:IsA("TextLabel") and (desc.Text:find("Claim") or desc.Text:find("Completed")) then
                                local btn = desc.Parent:FindFirstChildWhichIsA("ImageButton") or desc.Parent
                                if btn and btn:IsA("ImageButton") then firesignal(btn.Activated) end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(10)
    end
end)

-- 6. Movement Utilities (WalkSpeed, JumpPower, Noclip, Fly, InfJump)
local function restoreCollision()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = (part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Torso" or part.Name == "Head")
                end
            end
        end
    end)
end

registerConnection(RunService.Stepped:Connect(function()
    if Flags.NoclipOn then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end))

registerConnection(UserInputService.JumpRequest:Connect(function()
    if Flags.InfiniteJumpOn then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end))

registerThread(function()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if Flags.WalkSpeedOn and not (Flags.AutoMine and Flags.ApproachMethod == "Walk") then
                    hum.WalkSpeed = Flags.WalkSpeedVal
                end
                if Flags.JumpPowerOn then
                    hum.JumpPower = Flags.JumpPowerVal
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- Fly Engine
local flyBodyVel, flyBodyGyro = nil, nil
local function toggleFly(enabled)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if enabled then
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.Velocity = Vector3.zero
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVel.Parent = root

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = root.CFrame
        flyBodyGyro.Parent = root

        registerThread(function()
            while Flags.FlyOn and flyBodyVel and flyBodyVel.Parent do
                pcall(function()
                    local moveDir = Vector3.zero
                    local camCF = Camera.CFrame
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                    flyBodyVel.Velocity = moveDir * Flags.FlySpeed
                    flyBodyGyro.CFrame = camCF
                end)
                task.wait(0.03)
            end
        end)
    else
        if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        root.AssemblyLinearVelocity = Vector3.zero
    end
end

-- Fullbright
registerThread(function()
    while true do
        if Flags.FullbrightOn then
            pcall(function()
                Lighting.Brightness = 3
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
            end)
        end
        task.wait(1.5)
    end
end)

-- 7. Visual Radar & ESP Engine with Size Labels & Colors
local function removeEsp(obj)
    if activeEspElements[obj] then
        pcall(function()
            if activeEspElements[obj].Billboard then activeEspElements[obj].Billboard:Destroy() end
            if activeEspElements[obj].Highlight then activeEspElements[obj].Highlight:Destroy() end
        end)
        activeEspElements[obj] = nil
    end
end

local function addEsp(obj, labelText, color)
    if activeEspElements[obj] then return end
    pcall(function()
        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
        if not part then return end

        local bb = Instance.new("BillboardGui")
        bb.Name = "BH_ESP"
        bb.Size = UDim2.fromOffset(140, 26)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = part
        bb.Parent = part

        local tl = Instance.new("TextLabel", bb)
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.Text = labelText
        tl.TextColor3 = color or THEME.Cyan
        tl.Font = THEME.Font
        tl.TextSize = 12
        tl.TextStrokeTransparency = 0.2
        tl.TextStrokeColor3 = Color3.new(0, 0, 0)

        local hl = Instance.new("Highlight")
        hl.Name = "BH_HL"
        hl.FillColor = color or THEME.Cyan
        hl.FillTransparency = 0.7
        hl.OutlineColor = color or THEME.Cyan
        hl.OutlineTransparency = 0.2
        hl.Adornee = obj
        hl.Parent = obj

        activeEspElements[obj] = { Billboard = bb, Highlight = hl, Label = tl, Part = part }
    end)
end

registerThread(function()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local maxDist = Flags.MaxEspDistance or 400
            local currentSeen = {}

            -- ESP Stones with Size Classification
            if Flags.EspStones then
                local spawned = Workspace:FindFirstChild("spawned_stones")
                if spawned then
                    for _, reg in ipairs(spawned:GetChildren()) do
                        for _, stone in ipairs(reg:GetChildren()) do
                            local p = stone.PrimaryPart or stone:FindFirstChildWhichIsA("BasePart", true)
                            if p then
                                local sizeCat = getStoneSizeCategory(stone, p)
                                if Flags.EspSizeFilter == "All" or Flags.EspSizeFilter == sizeCat then
                                    local d = math.floor((p.Position - root.Position).Magnitude)
                                    if d <= maxDist then
                                        currentSeen[stone] = true
                                        local oreType = getStoneOreType(stone.Name)
                                        local color = (sizeCat == "Besar") and THEME.Gold or (sizeCat == "Sedang" and THEME.Cyan or Color3.fromRGB(200, 200, 200))
                                        local label = "⛏️ " .. oreType .. " [" .. sizeCat .. "] • " .. d .. "m"

                                        if not activeEspElements[stone] then
                                            addEsp(stone, label, color)
                                        else
                                            activeEspElements[stone].Label.Text = label
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- ESP NPCs
            if Flags.EspNPCs then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj ~= char and obj:FindFirstChildOfClass("Humanoid") then
                        local p = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                        if p then
                            local d = math.floor((p.Position - root.Position).Magnitude)
                            if d <= maxDist then
                                currentSeen[obj] = true
                                if not activeEspElements[obj] then
                                    addEsp(obj, "👤 " .. obj.Name .. " [" .. d .. "m]", THEME.Cyan)
                                else
                                    activeEspElements[obj].Label.Text = "👤 " .. obj.Name .. " [" .. d .. "m]"
                                end
                            end
                        end
                    end
                end
            end

            -- ESP Players
            if Flags.EspPlayers then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character then
                        local pChar = pl.Character
                        local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                        if pRoot then
                            local d = math.floor((pRoot.Position - root.Position).Magnitude)
                            if d <= maxDist then
                                currentSeen[pChar] = true
                                if not activeEspElements[pChar] then
                                    addEsp(pChar, "🎮 " .. pl.DisplayName .. " [" .. d .. "m]", THEME.Green)
                                else
                                    activeEspElements[pChar].Label.Text = "🎮 " .. pl.DisplayName .. " [" .. d .. "m]"
                                end
                            end
                        end
                    end
                end
            end

            -- ESP Sell Zones
            if Flags.EspSellZones then
                for _, loc in ipairs(WORLD_LOCATIONS) do
                    if loc.Category == "Shops & Zones" then
                        local d = math.floor((loc.Pos - root.Position).Magnitude)
                        if d <= maxDist then
                            local fakeKey = loc.Name
                            currentSeen[fakeKey] = true
                            if not activeEspElements[fakeKey] then
                                local p = Instance.new("Part", Workspace)
                                p.Name = "BH_ZoneMarker_" .. loc.Name
                                p.Size = Vector3.new(2, 2, 2)
                                p.Position = loc.Pos
                                p.Transparency = 1
                                p.Anchored = true
                                p.CanCollide = false
                                addEsp(p, "💰 " .. loc.Name .. " [" .. d .. "m]", THEME.Gold)
                                activeEspElements[fakeKey] = activeEspElements[p]
                                activeEspElements[fakeKey].CreatedPart = p
                            else
                                if activeEspElements[fakeKey].Label then
                                    activeEspElements[fakeKey].Label.Text = "💰 " .. loc.Name .. " [" .. d .. "m]"
                                end
                            end
                        end
                    end
                end
            end

            -- Clean up unseen ESPs
            for obj, data in pairs(activeEspElements) do
                if not currentSeen[obj] then
                    if data.CreatedPart then data.CreatedPart:Destroy() end
                    removeEsp(obj)
                end
            end
        end)
        task.wait(0.4)
    end
end)

-- =================================================================
-- MASTER CLEANUP ROUTINE
-- =================================================================
local function cleanupAll()
    _G.BH_MINEIT_CLEANUP = nil
    for k in pairs(Flags) do
        if type(Flags[k]) == "boolean" then
            Flags[k] = false
        end
    end

    toggleFly(false)

    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(activeConnections)

    for _, t in ipairs(activeThreads) do
        pcall(function() task.cancel(t) end)
    end
    table.clear(activeThreads)

    for obj in pairs(activeEspElements) do
        removeEsp(obj)
    end
    table.clear(activeEspElements)

    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        restoreCollision()
    end)

    pcall(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
    end)

    pcall(function()
        local gui = CoreGui:FindFirstChild("BrotherHub_MineIt") or (gethui and gethui():FindFirstChild("BrotherHub_MineIt"))
        if gui then gui:Destroy() end
    end)
end

_G.BH_MINEIT_CLEANUP = cleanupAll

-- =================================================================
-- 1:1 MY FLOWER SHOP MASTER GUI CREATION
-- =================================================================
local guiParent = (gethui and gethui()) or CoreGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrotherHub_MineIt"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

local UIScale = Instance.new("UIScale", ScreenGui)
local BASE = Vector2.new(1280, 720)
local function updateScale()
    if not Camera then return end
    local v = Camera.ViewportSize
    local s = math.min(v.X / BASE.X, v.Y / BASE.Y)
    UIScale.Scale = math.clamp(s, 0.45, 1.15)
end
registerConnection(Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
updateScale()

-- Rotating Neon RGB Stroke (1:1 Exact Standard)
local NEON_SEQ = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 40, 255)),    -- Deep Blue Neon
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 25, 45)),   -- Red Neon
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(20, 255, 80)),   -- Green Neon
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 40, 255))     -- Return to Blue
})

local function neonStroke(inst, thickness)
    local s = Instance.new("UIStroke", inst)
    s.Thickness = thickness or 2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Transparency = 0
    s.Color = Color3.new(1, 1, 1)
    local g = Instance.new("UIGradient", s)
    g.Color = NEON_SEQ
    g.Rotation = 0
    local tw = TweenService:Create(g,
        TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360})
    tw:Play()
    return s, tw
end

local function corner(inst, r)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

-- MAIN FRAME (Default: 660 x 440)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(660, 440)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false
corner(MainFrame, 14)
neonStroke(MainFrame, 2)

-- UIScale strictly parented to MainFrame (Rule #10.3)
local MainScale = Instance.new("UIScale", MainFrame)
MainScale.Scale = 1

-- Floating MinCircle (80x80) - 1:1 FlowerShop Exact Standard
local MinCircle = Instance.new("TextButton", ScreenGui)
MinCircle.Name = "MinCircle"
MinCircle.Size = UDim2.fromOffset(80, 80)
MinCircle.AnchorPoint = Vector2.new(0.5, 0.5)
MinCircle.Position = UDim2.new(0.5, 0, 0, 70)
MinCircle.BackgroundColor3 = THEME.Panel
MinCircle.Text = "BH"
MinCircle.Font = THEME.FontBlack
MinCircle.TextSize = 30
MinCircle.TextColor3 = THEME.Text
MinCircle.AutoButtonColor = false
MinCircle.Active = true
MinCircle.Visible = false
corner(MinCircle, 40)
neonStroke(MinCircle, 3)

local MinBgGrad = Instance.new("UIGradient", MinCircle)
MinBgGrad.Color = ColorSequence.new(THEME.Purple, THEME.Blue)
MinBgGrad.Rotation = 45

local CrownLabel = Instance.new("TextLabel", MinCircle)
CrownLabel.Name = "CrownLabel"
CrownLabel.Size = UDim2.new(1, 0, 0, 16)
CrownLabel.Position = UDim2.new(0, 0, 0, 8)
CrownLabel.BackgroundTransparency = 1
CrownLabel.Text = "👑"
CrownLabel.Font = THEME.Font
CrownLabel.TextSize = 14
CrownLabel.TextColor3 = THEME.Gold
CrownLabel.ZIndex = 2

local CircleScale = Instance.new("UIScale", MinCircle)
CircleScale.Scale = 0

-- Header Bar (52px Standard)
local Header = Instance.new("Frame", MainFrame)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = THEME.Panel
Header.BorderSizePixel = 0
corner(Header, 14)

local HeaderGrad = Instance.new("UIGradient", Header)
HeaderGrad.Color = ColorSequence.new(THEME.Purple, THEME.Blue)

local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0, 14)
HeaderFix.Position = UDim2.new(0, 0, 1, -14)
HeaderFix.BackgroundColor3 = THEME.Panel
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 1
local HeaderFixGrad = Instance.new("UIGradient", HeaderFix)
HeaderFixGrad.Color = ColorSequence.new(THEME.Purple, THEME.Blue)

local LogoLabel = Instance.new("TextLabel", Header)
LogoLabel.Size = UDim2.new(0, 36, 0, 36)
LogoLabel.Position = UDim2.new(0, 12, 0.5, -18)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "👑"
LogoLabel.Font = THEME.Font
LogoLabel.TextSize = 22
LogoLabel.TextColor3 = THEME.Gold
LogoLabel.ZIndex = 2

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Text = "⚡ BROTHER HUB  •  ⛏️ MINE IT"
TitleLabel.Font = THEME.Font
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 50, 0, 0)
TitleLabel.Size = UDim2.new(1, -170, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.ZIndex = 2

-- Minimize (-) & Close (X) Buttons
local BTN_SIZE = UDim2.new(0, 32, 0, 32)
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = BTN_SIZE
MinBtn.AnchorPoint = Vector2.new(0, 0.5)
MinBtn.Position = UDim2.new(1, -88, 0.5, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 18)
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.new(0, 0, 0)
MinBtn.Font = THEME.Font
MinBtn.TextSize = 16
MinBtn.ZIndex = 3
corner(MinBtn, 8)

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = BTN_SIZE
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.Position = UDim2.new(1, -44, 0.5, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 60, 75)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = THEME.Font
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 3
corner(CloseBtn, 8)

-- Confirmation Modal for Close ('X')
local ConfirmModal = Instance.new("Frame", ScreenGui)
ConfirmModal.Name = "ConfirmModal"
ConfirmModal.Size = UDim2.fromOffset(360, 180)
ConfirmModal.AnchorPoint = Vector2.new(0.5, 0.5)
ConfirmModal.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmModal.BackgroundColor3 = THEME.Panel
ConfirmModal.BorderSizePixel = 0
ConfirmModal.Visible = false
ConfirmModal.ZIndex = 50
corner(ConfirmModal, 14)
neonStroke(ConfirmModal, 2)

local ModalTitle = Instance.new("TextLabel", ConfirmModal)
ModalTitle.Size = UDim2.new(1, 0, 0, 40)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = "👑 UNLOAD BROTHER HUB"
ModalTitle.Font = THEME.Font
ModalTitle.TextSize = 15
ModalTitle.TextColor3 = THEME.Gold
ModalTitle.ZIndex = 51

local ModalDesc = Instance.new("TextLabel", ConfirmModal)
ModalDesc.Size = UDim2.new(1, -30, 0, 50)
ModalDesc.Position = UDim2.new(0, 15, 0, 45)
ModalDesc.BackgroundTransparency = 1
ModalDesc.Text = "Apakah Anda yakin ingin menutup script dan menghentikan seluruh fitur otomatis?"
ModalDesc.Font = THEME.FontMedium
ModalDesc.TextSize = 12
ModalDesc.TextColor3 = THEME.Text
ModalDesc.TextWrapped = true
ModalDesc.ZIndex = 51

local ModalYes = Instance.new("TextButton", ConfirmModal)
ModalYes.Size = UDim2.new(0.42, 0, 0, 36)
ModalYes.Position = UDim2.new(0.06, 0, 1, -48)
ModalYes.BackgroundColor3 = THEME.Green
ModalYes.Text = "Ya, Tutup"
ModalYes.TextColor3 = Color3.new(0, 0, 0)
ModalYes.Font = THEME.Font
ModalYes.TextSize = 13
ModalYes.ZIndex = 51
corner(ModalYes, 8)

local ModalCancel = Instance.new("TextButton", ConfirmModal)
ModalCancel.Size = UDim2.new(0.42, 0, 0, 36)
ModalCancel.Position = UDim2.new(0.52, 0, 1, -48)
ModalCancel.BackgroundColor3 = THEME.Red
ModalCancel.Text = "Batal"
ModalCancel.TextColor3 = Color3.new(1, 1, 1)
ModalCancel.Font = THEME.Font
ModalCancel.TextSize = 13
ModalCancel.ZIndex = 51
corner(ModalCancel, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ConfirmModal.Visible = true
end)

ModalCancel.MouseButton1Click:Connect(function()
    ConfirmModal.Visible = false
end)

ModalYes.MouseButton1Click:Connect(function()
    ConfirmModal.Visible = false
    cleanupAll()
    local t = TweenService:Create(MainScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0})
    t:Play()
    t.Completed:Connect(function() ScreenGui:Destroy() end)
end)

-- Minimize & Restore Logic (1:1 FlowerShop Bounce)
local isMinimizing = false
local tweenBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenFast   = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function doMinimize()
    if isMinimizing then return end
    isMinimizing = true
    local t = TweenService:Create(MainScale, tweenFast, {Scale = 0})
    t:Play()
    t.Completed:Connect(function()
        MainFrame.Visible = false
        MinCircle.Visible = true
        CircleScale.Scale = 0
        local t2 = TweenService:Create(CircleScale, tweenBounce, {Scale = 1})
        t2:Play()
        t2.Completed:Connect(function() isMinimizing = false end)
    end)
end

local function doRestore()
    if isMinimizing then return end
    isMinimizing = true
    local t = TweenService:Create(CircleScale, tweenFast, {Scale = 0})
    t:Play()
    t.Completed:Connect(function()
        MinCircle.Visible = false
        MainFrame.Visible = true
        MainScale.Scale = 0
        local t2 = TweenService:Create(MainScale, tweenBounce, {Scale = 1})
        t2:Play()
        t2.Completed:Connect(function() isMinimizing = false end)
    end)
end

MinBtn.MouseButton1Click:Connect(doMinimize)

-- MinCircle Free Dragging Anywhere
do
    local DRAG_THRESHOLD = 8
    local active, moved, startPx, guiStart = false, false, nil, nil
    MinCircle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            active = true
            moved = false
            startPx = i.Position
            guiStart = MinCircle.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not active then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = (i.Position - startPx) / (UIScale and UIScale.Scale or 1)
            if d.Magnitude > DRAG_THRESHOLD then
                moved = true
            end
            MinCircle.Position = UDim2.new(
                guiStart.X.Scale, guiStart.X.Offset + d.X,
                guiStart.Y.Scale, guiStart.Y.Offset + d.Y
            )
        end
    end)
    MinCircle.InputEnded:Connect(function(i)
        if not active then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            active = false
            if not moved then
                doRestore()
            end
        end
    end)
end

-- Header Dragging for MainFrame
do
    local dragging, dragStart, startPos = false, nil, nil
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = (input.Position - dragStart) / (UIScale and UIScale.Scale or 1)
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Resizable Handle at Bottom-Right Corner (Draggable Resize Grip)
local ResizeGrip = Instance.new("ImageButton", MainFrame)
ResizeGrip.Name = "ResizeGrip"
ResizeGrip.Size = UDim2.fromOffset(22, 22)
ResizeGrip.AnchorPoint = Vector2.new(1, 1)
ResizeGrip.Position = UDim2.new(1, -2, 1, -2)
ResizeGrip.BackgroundTransparency = 1
ResizeGrip.Image = "rbxassetid://9712711867"
ResizeGrip.ImageColor3 = THEME.Gold
ResizeGrip.ImageTransparency = 0.2
ResizeGrip.ZIndex = 15

do
    local resizing = false
    local startPos, startSize = nil, nil

    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startPos = input.Position
            startSize = MainFrame.AbsoluteSize
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = (input.Position - startPos) / (UIScale and UIScale.Scale or 1)
            local newWidth = math.clamp(startSize.X + delta.X, 500, 1000)
            local newHeight = math.clamp(startSize.Y + delta.Y, 360, 800)
            MainFrame.Size = UDim2.fromOffset(newWidth, newHeight)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

-- =================================================================
-- HORIZONTAL SCROLLING TAB BAR (GESER KE KANAN)
-- =================================================================
local TabScroll = Instance.new("ScrollingFrame", MainFrame)
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, -24, 0, 36)
TabScroll.Position = UDim2.new(0, 12, 0, 58)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 3
TabScroll.ScrollBarImageColor3 = THEME.Gold
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabListLayout = Instance.new("UIListLayout", TabScroll)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -24, 1, -108)
PageContainer.Position = UDim2.new(0, 12, 0, 98)
PageContainer.BackgroundTransparency = 1

local tabButtons = {}
local tabPages = {}

local function switchTab(tabName)
    for name, page in pairs(tabPages) do
        page.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = THEME.Gold
            btn.TextColor3 = Color3.new(0, 0, 0)
        else
            btn.BackgroundColor3 = THEME.Slot
            btn.TextColor3 = THEME.Text
        end
    end
end

local function createTab(name, icon, order)
    local btn = Instance.new("TextButton", TabScroll)
    btn.Name = name .. "TabBtn"
    btn.Size = UDim2.new(0, 115, 1, 0)
    btn.BackgroundColor3 = (order == 1) and THEME.Gold or THEME.Slot
    btn.Text = icon .. " " .. name
    btn.TextColor3 = (order == 1) and Color3.new(0, 0, 0) or THEME.Text
    btn.Font = THEME.Font
    btn.TextSize = 12
    btn.LayoutOrder = order
    corner(btn, 8)

    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.Gold
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (order == 1)

    local pl = Instance.new("UIListLayout", page)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Padding = UDim.new(0, 8)

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    tabButtons[name] = btn
    tabPages[name] = page
    return page
end

-- =================================================================
-- UI COMPONENT BUILDERS
-- =================================================================
local function createSection(parent, titleText, order)
    local sec = Instance.new("Frame", parent)
    sec.Name = "Section_" .. titleText
    sec.Size = UDim2.new(1, 0, 0, 24)
    sec.BackgroundTransparency = 1
    sec.LayoutOrder = order or 0

    local lbl = Instance.new("TextLabel", sec)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "▼ " .. titleText:upper()
    lbl.Font = THEME.Font
    lbl.TextSize = 11
    lbl.TextColor3 = THEME.Gold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return sec
end

local function createToggle(parent, title, flagKey, descText, callback)
    local row = Instance.new("TextButton", parent)
    row.Name = "Toggle_" .. title
    row.Size = UDim2.new(1, 0, 0, descText and 46 or 38)
    row.BackgroundColor3 = THEME.Panel
    row.BorderSizePixel = 0
    row.AutoButtonColor = false
    row.Text = ""
    corner(row, 8)

    local rStroke = Instance.new("UIStroke", row)
    rStroke.Color = THEME.Stroke
    rStroke.Thickness = 1

    local titleLbl = Instance.new("TextLabel", row)
    titleLbl.Size = UDim2.new(1, -60, 0, 18)
    titleLbl.Position = UDim2.new(0, 12, 0, descText and 6 or 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = THEME.Font
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = THEME.Text
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    if descText then
        local dLbl = Instance.new("TextLabel", row)
        dLbl.Size = UDim2.new(1, -60, 0, 14)
        dLbl.Position = UDim2.new(0, 12, 0, 24)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = descText
        dLbl.Font = THEME.FontMedium
        dLbl.TextSize = 10
        dLbl.TextColor3 = THEME.SubText
        dLbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    local switchBox = Instance.new("Frame", row)
    switchBox.Size = UDim2.fromOffset(40, 22)
    switchBox.AnchorPoint = Vector2.new(1, 0.5)
    switchBox.Position = UDim2.new(1, -10, 0.5, 0)
    switchBox.BackgroundColor3 = Flags[flagKey] and THEME.Green or THEME.Slot
    corner(switchBox, 11)

    local switchKnob = Instance.new("Frame", switchBox)
    switchKnob.Size = UDim2.fromOffset(18, 18)
    switchKnob.Position = Flags[flagKey] and UDim2.new(1, -19, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    switchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    corner(switchKnob, 9)

    local function updateVisual()
        local val = Flags[flagKey]
        TweenService:Create(switchBox, TweenInfo.new(0.2), {
            BackgroundColor3 = val and THEME.Green or THEME.Slot
        }):Play()
        TweenService:Create(switchKnob, TweenInfo.new(0.2), {
            Position = val and UDim2.new(1, -19, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
    end

    row.MouseButton1Click:Connect(function()
        Flags[flagKey] = not Flags[flagKey]
        updateVisual()
        if callback then callback(Flags[flagKey]) end
    end)

    return row
end

local function createSlider(parent, title, minVal, maxVal, flagKey, callback)
    local frame = Instance.new("Frame", parent)
    frame.Name = "Slider_" .. title
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = THEME.Panel
    frame.BorderSizePixel = 0
    corner(frame, 8)

    local sStroke = Instance.new("UIStroke", frame)
    sStroke.Color = THEME.Stroke
    sStroke.Thickness = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -90, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.Font = THEME.Font
    lbl.TextSize = 12
    lbl.TextColor3 = THEME.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local numBox = Instance.new("TextBox", frame)
    numBox.Size = UDim2.fromOffset(60, 20)
    numBox.AnchorPoint = Vector2.new(1, 0)
    numBox.Position = UDim2.new(1, -12, 0, 6)
    numBox.BackgroundColor3 = THEME.Slot
    numBox.Text = tostring(Flags[flagKey] or minVal)
    numBox.TextColor3 = THEME.Gold
    numBox.Font = THEME.Font
    numBox.TextSize = 12
    corner(numBox, 6)

    local barBg = Instance.new("TextButton", frame)
    barBg.Size = UDim2.new(1, -24, 0, 8)
    barBg.Position = UDim2.new(0, 12, 0, 34)
    barBg.BackgroundColor3 = THEME.Slot
    barBg.AutoButtonColor = false
    barBg.Text = ""
    corner(barBg, 4)

    local currentRatio = math.clamp(((Flags[flagKey] or minVal) - minVal) / (maxVal - minVal), 0, 1)
    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(currentRatio, 0, 1, 0)
    barFill.BackgroundColor3 = THEME.Gold
    corner(barFill, 4)

    local function setValue(val)
        val = math.clamp(math.floor(val + 0.5), minVal, maxVal)
        Flags[flagKey] = val
        numBox.Text = tostring(val)
        local ratio = (val - minVal) / (maxVal - minVal)
        barFill.Size = UDim2.new(ratio, 0, 1, 0)
        if callback then callback(val) end
    end

    numBox.FocusLost:Connect(function()
        local n = tonumber(numBox.Text)
        if n then setValue(n) else numBox.Text = tostring(Flags[flagKey]) end
    end)

    local dragging = false
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local relX = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            setValue(minVal + (maxVal - minVal) * relX)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            setValue(minVal + (maxVal - minVal) * relX)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return frame
end

local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or THEME.Blue
    btn.Text = text
    btn.TextColor3 = (color == THEME.Gold) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    btn.Font = THEME.Font
    btn.TextSize = 12
    corner(btn, 8)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

-- =================================================================
-- TAB PAGES INITIALIZATION
-- =================================================================
local pageAutoFarm        = createTab("Auto Farm", "⛏️", 1)
local pageOresFilter      = createTab("Ore Filter", "💎", 2)
local pageEnchantForge    = createTab("Enchant & Forge", "✨", 3)
local pageClanBlackMarket = createTab("Black Market", "🏴‍☠️", 4)
local pageShop            = createTab("Shop & Buy", "🛒", 5)
local pageInventory       = createTab("Inventory", "💰", 6)
local pageCraft           = createTab("Crafting", "🔨", 7)
local pageRewards         = createTab("Rewards", "🎁", 8)
local pageTeleport        = createTab("Teleport", "🚀", 9)
local pageESP             = createTab("ESP Radar", "👁️", 10)
local pagePlayer          = createTab("Player Misc", "⚡", 11)
local pageCredits         = createTab("Credits", "👑", 12)

-- -----------------------------------------------------------------
-- 1. AUTO FARM TAB
-- -----------------------------------------------------------------
createSection(pageAutoFarm, "Master Auto Mining (AFK)")
createToggle(pageAutoFarm, "Auto Mine Stones (Pickaxe Aura)", "AutoMine", "Otomatis mengayun beliung dan menghancurkan batu di sekitar")
createToggle(pageAutoFarm, "Auto Solve Mining Minigame (100% Perfect)", "AutoSolveMinigame", "Otomatis memecahkan minigame bar kotak-kotak dengan timing 100% Perfect / Excellent")
createToggle(pageAutoFarm, "Instant Perfect Alignment", "InstantPerfect", "Otomatis menyelaraskan pointer ke zona Perfect untuk kecepatan mining maksimal")
createToggle(pageAutoFarm, "Auto Approach / Lock On Target", "AutoApproach", "Otomatis mendekati target batu sesuai metode & posisi terpilih")
createToggle(pageAutoFarm, "Fast Continuous Swing", "FastSwing", "Kecepatan ayun beliung ultra cepat untuk memecahkan batu seketika")
createSlider(pageAutoFarm, "Mining Radius (Studs)", 15, 120, "MineRadius")

createSection(pageAutoFarm, "Posisi Memukul / Gedig Batu (Attack Stance)")
local stanceFrame = Instance.new("Frame", pageAutoFarm)
stanceFrame.Size = UDim2.new(1, 0, 0, 36)
stanceFrame.BackgroundTransparency = 1
local sfl = Instance.new("UIListLayout", stanceFrame)
sfl.FillDirection = Enum.FillDirection.Horizontal
sfl.Padding = UDim.new(0, 6)

local stanceOptions = {
    { Label = "Di Depan", Key = "In Front" },
    { Label = "Di Atas", Key = "Above" },
    { Label = "Di Bawah", Key = "Underneath" }
}

for _, opt in ipairs(stanceOptions) do
    local sBtn = Instance.new("TextButton", stanceFrame)
    sBtn.Size = UDim2.new(1 / #stanceOptions, -4, 1, 0)
    sBtn.BackgroundColor3 = (Flags.AttackPosition == opt.Key) and THEME.Gold or THEME.Slot
    sBtn.Text = opt.Label
    sBtn.TextColor3 = (Flags.AttackPosition == opt.Key) and Color3.new(0, 0, 0) or THEME.Text
    sBtn.Font = THEME.Font
    sBtn.TextSize = 12
    corner(sBtn, 8)

    sBtn.MouseButton1Click:Connect(function()
        Flags.AttackPosition = opt.Key
        for _, b in ipairs(stanceFrame:GetChildren()) do
            if b:IsA("TextButton") then
                local isMatch = (b.Text == opt.Label)
                b.BackgroundColor3 = isMatch and THEME.Gold or THEME.Slot
                b.TextColor3 = isMatch and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
end

createSlider(pageAutoFarm, "Stance Offset Distance (Studs)", 2, 10, "StanceDistance")

createSection(pageAutoFarm, "Metode Pergerakan ke Batu (Movement Method)")
local moveMethodFrame = Instance.new("Frame", pageAutoFarm)
moveMethodFrame.Size = UDim2.new(1, 0, 0, 36)
moveMethodFrame.BackgroundTransparency = 1
local mmfl = Instance.new("UIListLayout", moveMethodFrame)
mmfl.FillDirection = Enum.FillDirection.Horizontal
mmfl.Padding = UDim.new(0, 6)

local moveOptions = {
    { Label = "⚡ Teleport", Key = "Teleport" },
    { Label = "🕊️ Terbang", Key = "Fly" },
    { Label = "🚶 Jalan Kaki", Key = "Walk" }
}

for _, opt in ipairs(moveOptions) do
    local mBtn = Instance.new("TextButton", moveMethodFrame)
    mBtn.Size = UDim2.new(1 / #moveOptions, -4, 1, 0)
    mBtn.BackgroundColor3 = (Flags.ApproachMethod == opt.Key) and THEME.Gold or THEME.Slot
    mBtn.Text = opt.Label
    mBtn.TextColor3 = (Flags.ApproachMethod == opt.Key) and Color3.new(0, 0, 0) or THEME.Text
    mBtn.Font = THEME.Font
    mBtn.TextSize = 11
    corner(mBtn, 8)

    mBtn.MouseButton1Click:Connect(function()
        Flags.ApproachMethod = opt.Key
        for _, b in ipairs(moveMethodFrame:GetChildren()) do
            if b:IsA("TextButton") then
                local isMatch = (b.Text == opt.Label)
                b.BackgroundColor3 = isMatch and THEME.Gold or THEME.Slot
                b.TextColor3 = isMatch and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
end

createSlider(pageAutoFarm, "Fly Approach Speed", 20, 150, "FlyApproachSpeed")
createSlider(pageAutoFarm, "Walk Approach Speed", 16, 100, "WalkApproachSpeed")

createSection(pageAutoFarm, "Filter Ukuran Batu (Target Size)")
local sizeFrame = Instance.new("Frame", pageAutoFarm)
sizeFrame.Size = UDim2.new(1, 0, 0, 36)
sizeFrame.BackgroundTransparency = 1
local szl = Instance.new("UIListLayout", sizeFrame)
szl.FillDirection = Enum.FillDirection.Horizontal
szl.Padding = UDim.new(0, 4)

local sizeOptions = { "All", "Besar", "Sedang", "Kecil" }
for _, szName in ipairs(sizeOptions) do
    local szBtn = Instance.new("TextButton", sizeFrame)
    szBtn.Size = UDim2.new(1 / #sizeOptions, -4, 1, 0)
    szBtn.BackgroundColor3 = (Flags.TargetSize == szName) and THEME.Gold or THEME.Slot
    szBtn.Text = (szName == "All") and "Semua" or szName
    szBtn.TextColor3 = (Flags.TargetSize == szName) and Color3.new(0, 0, 0) or THEME.Text
    szBtn.Font = THEME.Font
    szBtn.TextSize = 11
    corner(szBtn, 6)

    szBtn.MouseButton1Click:Connect(function()
        Flags.TargetSize = szName
        for _, b in ipairs(sizeFrame:GetChildren()) do
            if b:IsA("TextButton") then
                local isMatch = (b.Text == ((szName == "All") and "Semua" or szName))
                b.BackgroundColor3 = isMatch and THEME.Gold or THEME.Slot
                b.TextColor3 = isMatch and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
end

createSection(pageAutoFarm, "Region Filter")
local regBtnFrame = Instance.new("Frame", pageAutoFarm)
regBtnFrame.Size = UDim2.new(1, 0, 0, 36)
regBtnFrame.BackgroundTransparency = 1
local rfl = Instance.new("UIListLayout", regBtnFrame)
rfl.FillDirection = Enum.FillDirection.Horizontal
rfl.Padding = UDim.new(0, 4)

local regionList = { "All", "MinersVillage", "Cave", "Forest", "Jungle", "Emberfall" }
for _, rName in ipairs(regionList) do
    local rBtn = Instance.new("TextButton", regBtnFrame)
    rBtn.Size = UDim2.new(1 / #regionList, -4, 1, 0)
    rBtn.BackgroundColor3 = (Flags.TargetRegion == rName) and THEME.Gold or THEME.Slot
    rBtn.Text = rName == "MinersVillage" and "Village" or rName
    rBtn.TextColor3 = (Flags.TargetRegion == rName) and Color3.new(0, 0, 0) or THEME.Text
    rBtn.Font = THEME.Font
    rBtn.TextSize = 10
    corner(rBtn, 6)

    rBtn.MouseButton1Click:Connect(function()
        Flags.TargetRegion = rName
        for _, b in ipairs(regBtnFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = (b.Text == (rName == "MinersVillage" and "Village" or rName)) and THEME.Gold or THEME.Slot
                b.TextColor3 = (b.Text == (rName == "MinersVillage" and "Village" or rName)) and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
end

createSection(pageAutoFarm, "Auto Collect Drops & Chests")
createToggle(pageAutoFarm, "Auto Collect Dropped Ores & Relics", "AutoCollectDrops", "Otomatis mengambil ore yang jatuh, relic, dan resep di tanah")
createToggle(pageAutoFarm, "Auto Open Nearby Chests", "AutoChestOpen", "Otomatis membuka chest tersembunyi yang ada di sekitar player")
createToggle(pageAutoFarm, "Auto Learn & Collect Recipes", "AutoLearnRecipes", "Otomatis mengklaim dan mempelajari resep crafting baru di map")

createSection(pageAutoFarm, "Advanced Mining Intelligence")
createToggle(pageAutoFarm, "Auto Snipe Rare Ore Spawns", "AutoSnipeRareSpawns", "Otomatis teleport ke bongkahan batu langka (Arcadium/VoidShard) saat muncul notifikasi spawn")
createToggle(pageAutoFarm, "Maintain Mining Streak (10x-50x Multiplier)", "MaintainMiningStreak", "Menjaga ritme mining streak untuk melipatgandakan koin dan item drop")

-- -----------------------------------------------------------------
-- 2. ORE FILTER & PRIORITY TAB (LIKE SEED SELECTION IN FLOWER SHOP)
-- -----------------------------------------------------------------
createSection(pageOresFilter, "Prioritas Utama Batu (Priority Ore)")
local prioDescLbl = Instance.new("TextLabel", pageOresFilter)
prioDescLbl.Size = UDim2.new(1, 0, 0, 24)
prioDescLbl.BackgroundTransparency = 1
prioDescLbl.Text = "Batu terpilih di bawah akan diprioritaskan dipukul lebih duluan:"
prioDescLbl.Font = THEME.FontMedium
prioDescLbl.TextSize = 11
prioDescLbl.TextColor3 = THEME.SubText

local prioGrid = Instance.new("Frame", pageOresFilter)
prioGrid.Size = UDim2.new(1, 0, 0, 75)
prioGrid.BackgroundTransparency = 1
local pgLayout = Instance.new("UIGridLayout", prioGrid)
pgLayout.CellSize = UDim2.new(0, 100, 0, 32)
pgLayout.CellPadding = UDim2.new(0, 6, 0, 6)

local prioButtons = {}
local allPrioOptions = { "None" }
for _, o in ipairs(ALL_ORES) do table.insert(allPrioOptions, o) end

for _, pName in ipairs(allPrioOptions) do
    local pBtn = Instance.new("TextButton", prioGrid)
    pBtn.BackgroundColor3 = (Flags.PriorityOre == pName) and THEME.Gold or THEME.Panel
    pBtn.Text = (pName == "None") and "🚫 Tanpa Prioritas" or ("⭐ " .. pName)
    pBtn.TextColor3 = (Flags.PriorityOre == pName) and Color3.new(0, 0, 0) or THEME.Text
    pBtn.Font = THEME.Font
    pBtn.TextSize = 10
    corner(pBtn, 6)

    pBtn.MouseButton1Click:Connect(function()
        Flags.PriorityOre = pName
        for _, b in ipairs(prioGrid:GetChildren()) do
            if b:IsA("TextButton") then
                local isMatch = (b.Text == ((pName == "None") and "🚫 Tanpa Prioritas" or ("⭐ " .. pName)))
                b.BackgroundColor3 = isMatch and THEME.Gold or THEME.Panel
                b.TextColor3 = isMatch and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
    table.insert(prioButtons, pBtn)
end

createSection(pageOresFilter, "Pilih Jenis Batu/Ore yang Mau Dipukul (Multi-Select)")
local multiCtrl = Instance.new("Frame", pageOresFilter)
multiCtrl.Size = UDim2.new(1, 0, 0, 32)
multiCtrl.BackgroundTransparency = 1
local mcl = Instance.new("UIListLayout", multiCtrl)
mcl.FillDirection = Enum.FillDirection.Horizontal
mcl.Padding = UDim.new(0, 8)

local btnSelectAllOres = Instance.new("TextButton", multiCtrl)
btnSelectAllOres.Size = UDim2.new(0.5, -4, 1, 0)
btnSelectAllOres.BackgroundColor3 = THEME.Blue
btnSelectAllOres.Text = "✓ Pilih Semua Ore"
btnSelectAllOres.TextColor3 = Color3.new(1, 1, 1)
btnSelectAllOres.Font = THEME.Font
btnSelectAllOres.TextSize = 11
corner(btnSelectAllOres, 6)

local btnUnselectAllOres = Instance.new("TextButton", multiCtrl)
btnUnselectAllOres.Size = UDim2.new(0.5, -4, 1, 0)
btnUnselectAllOres.BackgroundColor3 = THEME.Slot
btnUnselectAllOres.Text = "✗ Hapus Semua Pilihan"
btnUnselectAllOres.TextColor3 = THEME.Text
btnUnselectAllOres.Font = THEME.Font
btnUnselectAllOres.TextSize = 11
corner(btnUnselectAllOres, 6)

local oreTogglesContainer = Instance.new("Frame", pageOresFilter)
oreTogglesContainer.Size = UDim2.new(1, 0, 0, 220)
oreTogglesContainer.BackgroundTransparency = 1
local otGrid = Instance.new("UIGridLayout", oreTogglesContainer)
otGrid.CellSize = UDim2.new(0.31, 0, 0, 36)
otGrid.CellPadding = UDim2.new(0.035, 0, 0, 8)

local oreToggleWidgets = {}

for _, oreName in ipairs(ALL_ORES) do
    local oBtn = Instance.new("TextButton", oreTogglesContainer)
    oBtn.Name = "OreBtn_" .. oreName
    oBtn.BackgroundColor3 = Flags.SelectedOres[oreName] and THEME.Green or THEME.Slot
    oBtn.Text = (Flags.SelectedOres[oreName] and "✓ " or "✗ ") .. oreName
    oBtn.TextColor3 = Flags.SelectedOres[oreName] and Color3.new(0, 0, 0) or THEME.SubText
    oBtn.Font = THEME.Font
    oBtn.TextSize = 11
    corner(oBtn, 8)

    local function updateOreBtn()
        local isSel = Flags.SelectedOres[oreName]
        oBtn.BackgroundColor3 = isSel and THEME.Green or THEME.Slot
        oBtn.Text = (isSel and "✓ " or "✗ ") .. oreName
        oBtn.TextColor3 = isSel and Color3.new(0, 0, 0) or THEME.SubText
    end

    oBtn.MouseButton1Click:Connect(function()
        Flags.SelectedOres[oreName] = not Flags.SelectedOres[oreName]
        updateOreBtn()
    end)

    table.insert(oreToggleWidgets, updateOreBtn)
end

btnSelectAllOres.MouseButton1Click:Connect(function()
    for _, ore in ipairs(ALL_ORES) do Flags.SelectedOres[ore] = true end
    for _, fn in ipairs(oreToggleWidgets) do fn() end
end)

btnUnselectAllOres.MouseButton1Click:Connect(function()
    for _, ore in ipairs(ALL_ORES) do Flags.SelectedOres[ore] = false end
    for _, fn in ipairs(oreToggleWidgets) do fn() end
end)


-- -----------------------------------------------------------------
-- 2B. ENCHANT & FORGE TAB (ALIGNED WITH DUMP ARCHITECTURE)
-- -----------------------------------------------------------------
createSection(pageEnchantForge, "Enchanting Altar & Table")
createToggle(pageEnchantForge, "Auto Enchant Pickaxe at Altar", "AutoEnchantAltar", "Otomatis melakukan enchant beliung saat berada di dekat Altar/Meja")
createButton(pageEnchantForge, "✨ Teleport ke Enchanting Table & Altar", THEME.Purple, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(-967.7, -7.3, 207.8)
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

createSection(pageEnchantForge, "Blacksmith Reforger & Enhancer")
createToggle(pageEnchantForge, "Auto Reforge Accessories", "AutoReforgeAccs", "Otomatis me-reforge Crown, Cloak, dan Ring di Reforger")
createToggle(pageEnchantForge, "Auto Enhance Equipment Level", "AutoEnhanceEquip", "Menaikkan level enhancer beliung dan gear otomatis")
createButton(pageEnchantForge, "🔨 Teleport ke Reforger & Blacksmith Zone", THEME.Gold, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(1333.1, -7.0, -545.5)
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

createSection(pageEnchantForge, "Runes System")
createToggle(pageEnchantForge, "Auto Craft Desired Runes", "AutoCraftRunes", "Otomatis merakit rune di menu Runes saat bahan tersedia")
createButton(pageEnchantForge, "⚡ Pasang Rune Terbaik Sekarang (Equip Best)", THEME.Blue, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local rGui = pGui and pGui:FindFirstChild("runes")
        if rGui and firesignal then
            local ebBtn = rGui:FindFirstChild("EquipBestButton", true)
            if ebBtn then firesignal(ebBtn.Activated) end
        end
    end)
end)

createSection(pageEnchantForge, "World Totems Buff Activator (3 Totems)")
createToggle(pageEnchantForge, "Auto Activate All 3 World Totems", "AutoActivateTotems", "Secara berkala mengaktifkan 3 Totem dunia untuk buff panen dan mining")
createButton(pageEnchantForge, "🗿 Aktifkan Seluruh 3 Totem Sekarang (Instant)", THEME.Green, function()
    pcall(function()
        local totems = {
            Vector3.new(11732.9, 1.3, -28847.0),
            Vector3.new(4358.9, -47.8, -3996.5),
            Vector3.new(14113.4, -154.8, -20274.9)
        }
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local origCF = root.CFrame
            for _, tPos in ipairs(totems) do
                root.CFrame = CFrame.new(tPos + Vector3.new(0, 3, 0))
                task.wait(0.4)
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled and (prompt.Parent.Position - root.Position).Magnitude <= 25 then
                        if fireproximityprompt then fireproximityprompt(prompt, 0) end
                    end
                end
            end
            root.CFrame = origCF
        end
    end)
end)

-- -----------------------------------------------------------------
-- 2C. BLACK MARKET & CLAN TAB (ZERO ROBUX GUARANTEE)
-- -----------------------------------------------------------------
createSection(pageClanBlackMarket, "Black Market Dealer (100% Free / Zero Robux)")
createToggle(pageClanBlackMarket, "Auto Buy Black Market (Murni Koin)", "AutoBuyBlackMarket", "Otomatis memborong stok Black Market koin tanpa pop-up Robux!")
createButton(pageClanBlackMarket, "🏴‍☠️ Teleport ke Black Market Seller", THEME.Panel, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local bm = Workspace:FindFirstChild("spawned_black_market", true) or Workspace:FindFirstChild("black_market_spawn", true)
        if bm then
            root.CFrame = bm:GetPivot() * CFrame.new(0, 3, 0)
        else
            root.CFrame = CFrame.new(339.6, 15.7, -380.1)
        end
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

createSection(pageClanBlackMarket, "Bloodlines & Lucky Reroll")
createToggle(pageClanBlackMarket, "Auto Lucky Reroll Bloodline", "AutoLuckyBloodline", "Otomatis melakukan Lucky Reroll bloodline saat tiket/koin tersedia")
local bloodlineStopFrame = Instance.new("Frame", pageClanBlackMarket)
bloodlineStopFrame.Size = UDim2.new(1, 0, 0, 32)
bloodlineStopFrame.BackgroundTransparency = 1
local blLayout = Instance.new("UIListLayout", bloodlineStopFrame)
blLayout.FillDirection = Enum.FillDirection.Horizontal
blLayout.Padding = UDim.new(0, 6)

for _, tier in ipairs({ "Legendary", "Epic" }) do
    local bBtn = Instance.new("TextButton", bloodlineStopFrame)
    bBtn.Size = UDim2.new(0.5, -4, 1, 0)
    bBtn.BackgroundColor3 = (Flags.BloodlineStopTier == tier) and THEME.Gold or THEME.Slot
    bBtn.Text = "Berhenti di " .. tier
    bBtn.TextColor3 = (Flags.BloodlineStopTier == tier) and Color3.new(0, 0, 0) or THEME.Text
    bBtn.Font = THEME.Font
    bBtn.TextSize = 11
    corner(bBtn, 6)
    bBtn.MouseButton1Click:Connect(function()
        Flags.BloodlineStopTier = tier
        for _, b in ipairs(bloodlineStopFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = (b.Text:find(tier)) and THEME.Gold or THEME.Slot
                b.TextColor3 = (b.Text:find(tier)) and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
end

createSection(pageClanBlackMarket, "Clan Merchant (Tokens Economy)")
createToggle(pageClanBlackMarket, "Auto Buy Clan Merchant Items", "AutoBuyClanMerchant", "Otomatis membeli totem batu purba dan item spesial klan")
createButton(pageClanBlackMarket, "🏰 Teleport ke Clan Merchant Booth", THEME.Panel, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(-111.4, -31.1, 461.0)
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

createSection(pageClanBlackMarket, "Potion Merchant & Consumption")
createToggle(pageClanBlackMarket, "Auto Drink Potions for Boosts", "AutoDrinkPotions", "Otomatis meminum potion penambah mining speed & drop luck")
createButton(pageClanBlackMarket, "🧪 Teleport ke Potion Merchant", THEME.Panel, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(-1019.8, 55.7, -1470.0)
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

-- -----------------------------------------------------------------
-- 3. SHOP & BUY TAB (100% FREE - NO ROBUX POPUPS)
-- -----------------------------------------------------------------
createSection(pageShop, "Mode Pembelian Toko (Buy Suite)")
local buyModeFrame = Instance.new("Frame", pageShop)
buyModeFrame.Size = UDim2.new(1, 0, 0, 32)
buyModeFrame.BackgroundTransparency = 1
local bmLayout = Instance.new("UIListLayout", buyModeFrame)
bmLayout.FillDirection = Enum.FillDirection.Horizontal
bmLayout.Padding = UDim.new(0, 6)

local buyModeButtons = {}
for _, mode in ipairs({ "Pilih Item Tertentu", "Borong Semua (Buy All)" }) do
    local isAct = (mode:find("Pilih") and Flags.ShopBuyMode == "Selected") or (mode:find("Borong") and Flags.ShopBuyMode == "BuyAll")
    local bBtn = Instance.new("TextButton", buyModeFrame)
    bBtn.Size = UDim2.new(0.5, -3, 1, 0)
    bBtn.BackgroundColor3 = isAct and THEME.Gold or THEME.Slot
    bBtn.Text = mode
    bBtn.TextColor3 = isAct and Color3.new(0, 0, 0) or THEME.Text
    bBtn.Font = THEME.Font
    bBtn.TextSize = 11
    corner(bBtn, 6)
    bBtn.MouseButton1Click:Connect(function()
        Flags.ShopBuyMode = mode:find("Borong") and "BuyAll" or "Selected"
        for _, b in ipairs(buyModeButtons) do
            local sel = (b.Text:find("Borong") and Flags.ShopBuyMode == "BuyAll") or (b.Text:find("Pilih") and Flags.ShopBuyMode == "Selected")
            b.BackgroundColor3 = sel and THEME.Gold or THEME.Slot
            b.TextColor3 = sel and Color3.new(0, 0, 0) or THEME.Text
        end
    end)
    table.insert(buyModeButtons, bBtn)
end

createSlider(pageShop, "Jumlah Pembelian (Quantity / Amount)", 1, 100, "ShopBuyQuantity")

createSection(pageShop, "Pilih Item yang Ingin Dibeli (Multi-Select)")
local shopSelectHeader = Instance.new("Frame", pageShop)
shopSelectHeader.Size = UDim2.new(1, 0, 0, 26)
shopSelectHeader.BackgroundTransparency = 1
local sshLayout = Instance.new("UIListLayout", shopSelectHeader)
sshLayout.FillDirection = Enum.FillDirection.Horizontal
sshLayout.Padding = UDim.new(0, 6)

local btnSelectAllShop = Instance.new("TextButton", shopSelectHeader)
btnSelectAllShop.Size = UDim2.new(0.5, -3, 1, 0)
btnSelectAllShop.BackgroundColor3 = THEME.Slot
btnSelectAllShop.Text = "✓ Pilih Semua Item"
btnSelectAllShop.TextColor3 = THEME.Green
btnSelectAllShop.Font = THEME.Font
btnSelectAllShop.TextSize = 10
corner(btnSelectAllShop, 6)

local btnUnselectAllShop = Instance.new("TextButton", shopSelectHeader)
btnUnselectAllShop.Size = UDim2.new(0.5, -3, 1, 0)
btnUnselectAllShop.BackgroundColor3 = THEME.Slot
btnUnselectAllShop.Text = "✗ Batal Semua"
btnUnselectAllShop.TextColor3 = THEME.Red
btnUnselectAllShop.Font = THEME.Font
btnUnselectAllShop.TextSize = 10
corner(btnUnselectAllShop, 6)

local shopItemsList = {
    { Key = "WoodenPickaxe",   Display = "Wooden Pickaxe (500 C)" },
    { Key = "StonePickaxe",    Display = "Stone Pickaxe (2.5K C)" },
    { Key = "IronPickaxe",     Display = "Iron Pickaxe (10K C)" },
    { Key = "CrystalPickaxe",  Display = "Crystal Pickaxe (50K C)" },
    { Key = "PureGoldPickaxe", Display = "Pure Gold Pickaxe (250K C)" },
    { Key = "EmeraldPickaxe",  Display = "Emerald Pickaxe (1M C)" },
    { Key = "LavaPickaxe",     Display = "Lava Pickaxe (5M C)" },
    { Key = "SpeedPotion",     Display = "Speed Potion (Shop)" },
    { Key = "LuckPotion",      Display = "Luck Potion (Shop)" },
}

local shopItemWidgets = {}
local shopGrid = Instance.new("Frame", pageShop)
shopGrid.Size = UDim2.new(1, 0, 0, 110)
shopGrid.BackgroundTransparency = 1
local sgLayout = Instance.new("UIGridLayout", shopGrid)
sgLayout.CellSize = UDim2.new(0.32, -4, 0, 30)
sgLayout.CellPadding = UDim2.new(0, 5, 0, 5)

for _, item in ipairs(shopItemsList) do
    local sBtn = Instance.new("TextButton", shopGrid)
    sBtn.BackgroundColor3 = Flags.ShopSelectedItems[item.Key] and THEME.Green or THEME.Slot
    sBtn.Text = (Flags.ShopSelectedItems[item.Key] and "✓ " or "✗ ") .. item.Display
    sBtn.TextColor3 = Flags.ShopSelectedItems[item.Key] and Color3.new(0, 0, 0) or THEME.SubText
    sBtn.Font = THEME.Font
    sBtn.TextSize = 9
    corner(sBtn, 6)

    local function updateItemBtn()
        local isSel = Flags.ShopSelectedItems[item.Key]
        sBtn.BackgroundColor3 = isSel and THEME.Green or THEME.Slot
        sBtn.Text = (isSel and "✓ " or "✗ ") .. item.Display
        sBtn.TextColor3 = isSel and Color3.new(0, 0, 0) or THEME.SubText
    end

    sBtn.MouseButton1Click:Connect(function()
        Flags.ShopSelectedItems[item.Key] = not Flags.ShopSelectedItems[item.Key]
        updateItemBtn()
    end)
    table.insert(shopItemWidgets, updateItemBtn)
end

btnSelectAllShop.MouseButton1Click:Connect(function()
    for _, item in ipairs(shopItemsList) do Flags.ShopSelectedItems[item.Key] = true end
    for _, fn in ipairs(shopItemWidgets) do fn() end
end)

btnUnselectAllShop.MouseButton1Click:Connect(function()
    for _, item in ipairs(shopItemsList) do Flags.ShopSelectedItems[item.Key] = false end
    for _, fn in ipairs(shopItemWidgets) do fn() end
end)

createButton(pageShop, "🛒 Eksekusi Beli Item Terpilih (Sesuai Jumlah)", THEME.Green, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local shopGui = pGui and pGui:FindFirstChild("shop")
        local qty = Flags.ShopBuyQuantity or 1
        if shopGui and firesignal then
            for i = 1, qty do
                for _, item in ipairs(shopItemsList) do
                    if Flags.ShopBuyMode == "BuyAll" or Flags.ShopSelectedItems[item.Key] then
                        for _, desc in ipairs(shopGui:GetDescendants()) do
                            if desc:IsA("TextLabel") and desc.Text:lower():find(item.Key:lower()) then
                                local btn = desc.Parent:FindFirstChild("PurchaseButton", true)
                                if btn and firesignal then
                                    firesignal(btn.Activated)
                                    task.wait(0.08)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)

createButton(pageShop, "📦 Borong Semua Item Koin (Buy All Items)", THEME.Gold, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local shopGui = pGui and pGui:FindFirstChild("shop")
        if shopGui and firesignal then
            for _, desc in ipairs(shopGui:GetDescendants()) do
                if desc:IsA("ImageButton") or desc:IsA("TextButton") then
                    if desc.Name == "PurchaseButton" or desc.Name == "CoinsBuy" then
                        firesignal(desc.Activated)
                        task.wait(0.08)
                    end
                end
            end
        end
    end)
end)

-- -----------------------------------------------------------------
-- 4. INVENTORY & AUTO SELL TAB (SELECTIVE ORE SELLING SUITE)
-- -----------------------------------------------------------------
createSection(pageInventory, "Mode Penjualan & Proteksi Mineral")
createToggle(pageInventory, "Enable Auto Sell Nonstop", "AutoSell", "Menjual hasil tambang secara berkala sesuai filter di bawah")
createToggle(pageInventory, "Proteksi Ore Langka (Lock Rare Ores)", "LockRareOres", "Mencegah Amethyst, Gold, VoidShard, Titanium, Arcadium terjual!")
createToggle(pageInventory, "Jual Aksesoris Rarity Rendah", "SellAccessories", "Otomatis menjual aksesoris tier biasa di toko")
createSlider(pageInventory, "Auto Sell Interval (Detik)", 5, 60, "AutoSellInterval")

local sellModeFrame = Instance.new("Frame", pageInventory)
sellModeFrame.Size = UDim2.new(1, 0, 0, 32)
sellModeFrame.BackgroundTransparency = 1
local smLayout = Instance.new("UIListLayout", sellModeFrame)
smLayout.FillDirection = Enum.FillDirection.Horizontal
smLayout.Padding = UDim.new(0, 6)

local sellModeButtons = {}
for _, mode in ipairs({ "Jual Terpilih (Selective)", "Jual Semua (Sell All)" }) do
    local isAct = (mode:find("Terpilih") and Flags.SellMode == "Selected") or (mode:find("Semua") and Flags.SellMode == "All")
    local bBtn = Instance.new("TextButton", sellModeFrame)
    bBtn.Size = UDim2.new(0.5, -3, 1, 0)
    bBtn.BackgroundColor3 = isAct and THEME.Gold or THEME.Slot
    bBtn.Text = mode
    bBtn.TextColor3 = isAct and Color3.new(0, 0, 0) or THEME.Text
    bBtn.Font = THEME.Font
    bBtn.TextSize = 11
    corner(bBtn, 6)
    bBtn.MouseButton1Click:Connect(function()
        Flags.SellMode = mode:find("Semua") and "All" or "Selected"
        for _, b in ipairs(sellModeButtons) do
            local sel = (b.Text:find("Semua") and Flags.SellMode == "All") or (b.Text:find("Terpilih") and Flags.SellMode == "Selected")
            b.BackgroundColor3 = sel and THEME.Gold or THEME.Slot
            b.TextColor3 = sel and Color3.new(0, 0, 0) or THEME.Text
        end
    end)
    table.insert(sellModeButtons, bBtn)
end

createSlider(pageInventory, "Jumlah yang Dijual per Ore (0 = Semua Stok)", 0, 500, "SellQuantity")

createSection(pageInventory, "Pilih Ore yang Ingin Dijual (Multi-Select)")
local sellOreHeader = Instance.new("Frame", pageInventory)
sellOreHeader.Size = UDim2.new(1, 0, 0, 26)
sellOreHeader.BackgroundTransparency = 1
local sohLayout = Instance.new("UIListLayout", sellOreHeader)
sohLayout.FillDirection = Enum.FillDirection.Horizontal
sohLayout.Padding = UDim.new(0, 6)

local btnSelectAllSell = Instance.new("TextButton", sellOreHeader)
btnSelectAllSell.Size = UDim2.new(0.5, -3, 1, 0)
btnSelectAllSell.BackgroundColor3 = THEME.Slot
btnSelectAllSell.Text = "✓ Centang Semua Ore"
btnSelectAllSell.TextColor3 = THEME.Green
btnSelectAllSell.Font = THEME.Font
btnSelectAllSell.TextSize = 10
corner(btnSelectAllSell, 6)

local btnUnselectAllSell = Instance.new("TextButton", sellOreHeader)
btnUnselectAllSell.Size = UDim2.new(0.5, -3, 1, 0)
btnUnselectAllSell.BackgroundColor3 = THEME.Slot
btnUnselectAllSell.Text = "✗ Batal Semua"
btnUnselectAllSell.TextColor3 = THEME.Red
btnUnselectAllSell.Font = THEME.Font
btnUnselectAllSell.TextSize = 10
corner(btnUnselectAllSell, 6)

local sellOreGrid = Instance.new("Frame", pageInventory)
sellOreGrid.Size = UDim2.new(1, 0, 0, 160)
sellOreGrid.BackgroundTransparency = 1
local sogLayout = Instance.new("UIGridLayout", sellOreGrid)
sogLayout.CellSize = UDim2.new(0.32, -4, 0, 28)
sogLayout.CellPadding = UDim2.new(0, 5, 0, 5)

local sellOreWidgets = {}
for _, oreName in ipairs(ALL_ORES) do
    local isSel = Flags.SelectedSellOres[oreName] or false
    local sBtn = Instance.new("TextButton", sellOreGrid)
    sBtn.BackgroundColor3 = isSel and THEME.Green or THEME.Slot
    sBtn.Text = (isSel and "✓ " or "✗ ") .. oreName
    sBtn.TextColor3 = isSel and Color3.new(0, 0, 0) or THEME.SubText
    sBtn.Font = THEME.Font
    sBtn.TextSize = 10
    corner(sBtn, 6)

    local function updateBtn()
        local sel = Flags.SelectedSellOres[oreName]
        sBtn.BackgroundColor3 = sel and THEME.Green or THEME.Slot
        sBtn.Text = (sel and "✓ " or "✗ ") .. oreName
        sBtn.TextColor3 = sel and Color3.new(0, 0, 0) or THEME.SubText
    end

    sBtn.MouseButton1Click:Connect(function()
        Flags.SelectedSellOres[oreName] = not Flags.SelectedSellOres[oreName]
        updateBtn()
    end)
    table.insert(sellOreWidgets, updateBtn)
end

btnSelectAllSell.MouseButton1Click:Connect(function()
    for _, ore in ipairs(ALL_ORES) do Flags.SelectedSellOres[ore] = true end
    for _, fn in ipairs(sellOreWidgets) do fn() end
end)

btnUnselectAllSell.MouseButton1Click:Connect(function()
    for _, ore in ipairs(ALL_ORES) do Flags.SelectedSellOres[ore] = false end
    for _, fn in ipairs(sellOreWidgets) do fn() end
end)

createButton(pageInventory, "💰 Jual Ore Terpilih Sekarang (Instant Selective Sell)", THEME.Green, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local sellGui = pGui and pGui:FindFirstChild("sell")
        if sellGui and firesignal then
            local sellBtn = sellGui:FindFirstChild("SellButton", true)
            local qtyBox = sellGui:FindFirstChild("QuantityBox", true) or sellGui:FindFirstChild("AmountInput", true)

            for _, itemDesc in ipairs(sellGui:GetDescendants()) do
                if itemDesc:IsA("TextLabel") or itemDesc:IsA("TextButton") then
                    local txt = itemDesc.Text
                    for oreName, isAllowed in pairs(Flags.SelectedSellOres) do
                        if isAllowed and txt:find(oreName) then
                            local isRare = (oreName == "Gold" or oreName == "Titanium" or oreName == "VoidShard" or oreName == "Arcadium")
                            if not (isRare and Flags.LockRareOres) then
                                local btn = itemDesc:IsA("TextButton") and itemDesc or itemDesc.Parent:FindFirstChildWhichIsA("TextButton") or itemDesc.Parent:FindFirstChildWhichIsA("ImageButton")
                                if btn then firesignal(btn.Activated) end
                            end
                        end
                    end
                end
            end
            task.wait(0.15)
            if qtyBox and Flags.SellQuantity > 0 then
                pcall(function() qtyBox.Text = tostring(Flags.SellQuantity) end)
            end
            task.wait(0.1)
            if sellBtn then firesignal(sellBtn.Activated) end
        end
    end)
end)

createButton(pageInventory, "💎 Jual Seluruh Item di Tas (Sell All)", THEME.Gold, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local sellGui = pGui and pGui:FindFirstChild("sell")
        if sellGui and firesignal then
            local selAll = sellGui:FindFirstChild("SelectAllButton", true)
            local sellBtn = sellGui:FindFirstChild("SellButton", true)
            if selAll and sellBtn then
                firesignal(selAll.Activated)
                task.wait(0.15)
                firesignal(sellBtn.Activated)
            end
        else
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local origCF = root.CFrame
                root.CFrame = CFrame.new(-187.6, -37.4, -202.3)
                task.wait(0.5)
                root.CFrame = origCF
            end
        end
    end)
end)

createSection(pageInventory, "Equipment Management")
createToggle(pageInventory, "Auto Equip Best Equipment", "AutoEquipBest", "Otomatis memakai beliung dan aksesoris terkuat yang dimiliki")
createButton(pageInventory, "⚡ Pakai Beliung & Aksesoris Terbaik Sekarang", THEME.Blue, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local bpGui = pGui and pGui:FindFirstChild("backpack")
        if bpGui and firesignal then
            for _, btn in ipairs(bpGui:GetDescendants()) do
                if btn:IsA("ImageButton") and btn.Name == "EquipBestButton" then
                    firesignal(btn.Activated)
                end
            end
        end
    end)
end)

-- -----------------------------------------------------------------
-- 5. CRAFTING & FORGE TAB
-- -----------------------------------------------------------------
createSection(pageCraft, "Auto Crafting Suite")
createToggle(pageCraft, "Auto Craft Pickaxes", "AutoCraftPickaxes", "Otomatis merangkai dan membuat beliung baru saat material lengkap")
createToggle(pageCraft, "Auto Craft Accessories", "AutoCraftAccessory", "Otomatis membuat aksesoris (Crown, Cloak, Rings)")

createButton(pageCraft, "🔨 Craft Item Terbaik Sekarang (Craft Best)", THEME.Purple, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local craftGui = pGui and pGui:FindFirstChild("craft")
        if craftGui and firesignal then
            local selBest = craftGui:FindFirstChild("SelectBest", true)
            local craftBtn = craftGui:FindFirstChild("UseButton", true)
            if selBest and craftBtn then
                firesignal(selBest.Activated)
                task.wait(0.15)
                firesignal(craftBtn.Activated)
            end
        end
    end)
end)

-- -----------------------------------------------------------------
-- 6. REWARDS & QUESTS TAB
-- -----------------------------------------------------------------
createSection(pageRewards, "Free Rewards & Autonomous Claims")
createToggle(pageRewards, "Auto Claim Daily Rewards (Day 1-7)", "AutoDailyRewards", "Mengklaim koin harian, lucky roll, dan potion gratis")
createToggle(pageRewards, "Auto Claim Like & Group Rewards", "AutoLikeRewards", "Mengklaim hadiah 10K koin dan free drop potion")
createToggle(pageRewards, "Auto Claim Completed Quests", "AutoClaimQuests", "Mengklaim hadiah quest yang selesai secara instan")
createToggle(pageRewards, "Auto Claim Daily Quests", "AutoClaimDailyQuests", "Mengklaim seluruh quest harian di menu Daily Quests")
createToggle(pageRewards, "Auto Claim Masteries Progression", "AutoClaimMasteries", "Mengklaim grand rewards mastery beliung & ore")

createSection(pageRewards, "Storage Vault 1-Click Management")
createButton(pageRewards, "📦 Pindahkan Seluruh Item ke Vault (Move All)", THEME.Gold, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local vGui = pGui and pGui:FindFirstChild("vault")
        if vGui and firesignal then
            local mvAll = vGui:FindFirstChild("MoveAll", true)
            if mvAll then firesignal(mvAll.Activated) end
        end
    end)
end)

createButton(pageRewards, "🎁 Klaim Seluruh Hadiah Harian & Like Sekarang", THEME.Green, function()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pGui then
            local drGui = pGui:FindFirstChild("daily_rewards")
            if drGui and firesignal then
                for i = 1, 7 do
                    local dBtn = drGui:FindFirstChild("day_" .. tostring(i), true)
                    if dBtn and dBtn:IsA("ImageButton") then firesignal(dBtn.Activated) end
                end
            end
            local lrGui = pGui:FindFirstChild("like_rewards")
            if lrGui and firesignal then
                local uBtn = lrGui:FindFirstChild("UseButton", true)
                if uBtn and uBtn:IsA("ImageButton") then firesignal(uBtn.Activated) end
            end
        end
    end)
end)

-- -----------------------------------------------------------------
-- 7. TELEPORT TAB
-- -----------------------------------------------------------------
createSection(pageTeleport, "Teleport to Mining Regions")
for _, loc in ipairs(WORLD_LOCATIONS) do
    if loc.Category == "Regions" then
        createButton(pageTeleport, "📍 " .. loc.Name, THEME.Panel, function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(loc.Pos)
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
end

createSection(pageTeleport, "Teleport to Shops & Workstations")
for _, loc in ipairs(WORLD_LOCATIONS) do
    if loc.Category == "Shops & Zones" then
        createButton(pageTeleport, "🏪 " .. loc.Name, THEME.Panel, function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(loc.Pos)
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
end

createSection(pageTeleport, "Teleport to Portals & Gates")
for _, loc in ipairs(WORLD_LOCATIONS) do
    if loc.Category == "Portals" then
        createButton(pageTeleport, "🌀 " .. loc.Name, THEME.Panel, function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(loc.Pos)
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
end

-- -----------------------------------------------------------------
-- 8. ESP RADAR TAB (WITH SIZE LABELS & COLORS)
-- -----------------------------------------------------------------
createSection(pageESP, "Visual Wallhack & Radar")
createToggle(pageESP, "ESP Spawned Stones & Ores", "EspStones", "Menampilkan highlight dan jarak seluruh batu/ore tambang")

createSection(pageESP, "Filter Ukuran ESP (Besar, Sedang, Kecil)")
local espSizeFrame = Instance.new("Frame", pageESP)
espSizeFrame.Size = UDim2.new(1, 0, 0, 36)
espSizeFrame.BackgroundTransparency = 1
local eszLayout = Instance.new("UIListLayout", espSizeFrame)
eszLayout.FillDirection = Enum.FillDirection.Horizontal
eszLayout.Padding = UDim.new(0, 4)

for _, eszName in ipairs({ "All", "Besar", "Sedang", "Kecil" }) do
    local eszBtn = Instance.new("TextButton", espSizeFrame)
    eszBtn.Size = UDim2.new(1 / 4, -4, 1, 0)
    eszBtn.BackgroundColor3 = (Flags.EspSizeFilter == eszName) and THEME.Gold or THEME.Slot
    eszBtn.Text = (eszName == "All") and "Semua" or eszName
    eszBtn.TextColor3 = (Flags.EspSizeFilter == eszName) and Color3.new(0, 0, 0) or THEME.Text
    eszBtn.Font = THEME.Font
    eszBtn.TextSize = 11
    corner(eszBtn, 6)

    eszBtn.MouseButton1Click:Connect(function()
        Flags.EspSizeFilter = eszName
        for _, b in ipairs(espSizeFrame:GetChildren()) do
            if b:IsA("TextButton") then
                local isMatch = (b.Text == ((eszName == "All") and "Semua" or eszName))
                b.BackgroundColor3 = isMatch and THEME.Gold or THEME.Slot
                b.TextColor3 = isMatch and Color3.new(0, 0, 0) or THEME.Text
            end
        end
    end)
end

createToggle(pageESP, "ESP NPCs & Merchants", "EspNPCs", "Menampilkan posisi NPC, pedagang, dan quest giver")
createToggle(pageESP, "ESP Sell & Work Zones", "EspSellZones", "Menampilkan lokasi zona jual dan stasiun craft")
createToggle(pageESP, "ESP Other Players", "EspPlayers", "Menampilkan lokasi dan nama seluruh pemain di server")
createSlider(pageESP, "Max ESP Distance (Studs)", 50, 1000, "MaxEspDistance")

-- -----------------------------------------------------------------
-- 9. PLAYER MISC TAB
-- -----------------------------------------------------------------
createSection(pagePlayer, "Player Mobility Utilities")
createToggle(pagePlayer, "Enable WalkSpeed Boost", "WalkSpeedOn", "Mengatur kecepatan jalan karakter")
createSlider(pagePlayer, "WalkSpeed Value", 16, 150, "WalkSpeedVal", function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and Flags.WalkSpeedOn then hum.WalkSpeed = v end
end)

createToggle(pagePlayer, "Enable JumpPower Boost", "JumpPowerOn", "Mengatur tinggi lompatan karakter")
createSlider(pagePlayer, "JumpPower Value", 50, 300, "JumpPowerVal", function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and Flags.JumpPowerOn then hum.JumpPower = v end
end)

createToggle(pagePlayer, "Enable Penetration Noclip", "NoclipOn", "Menembus seluruh dinding dan bebatuan tanpa hambatan", function(val)
    if not val then restoreCollision() end
end)

createToggle(pagePlayer, "Enable Fly Mode", "FlyOn", "Terbang bebas di udara (Gunakan tombol W/A/S/D/Space/Shift)", function(val)
    toggleFly(val)
end)
createSlider(pagePlayer, "Flight Speed", 20, 150, "FlySpeed")

createToggle(pagePlayer, "Enable Infinite Jump", "InfiniteJumpOn", "Melompat terus-menerus di udara tanpa batas")
createToggle(pagePlayer, "Enable Fullbright (Night Vision)", "FullbrightOn", "Menghilangkan kegelapan goa dan bayangan tambang")

-- -----------------------------------------------------------------
-- 10. CREDITS & DONATE TAB (RULE #6 COMPLIANT)
-- -----------------------------------------------------------------
createSection(pageCredits, "Official Community & Support")

local founderCard = Instance.new("Frame", pageCredits)
founderCard.Size = UDim2.new(1, 0, 0, 50)
founderCard.BackgroundColor3 = THEME.Panel
corner(founderCard, 8)
local fcStroke = Instance.new("UIStroke", founderCard)
fcStroke.Color = THEME.Gold
fcStroke.Thickness = 1

local fLbl = Instance.new("TextLabel", founderCard)
fLbl.Size = UDim2.new(1, -20, 1, 0)
fLbl.Position = UDim2.new(0, 12, 0, 0)
fLbl.BackgroundTransparency = 1
fLbl.Text = "👑 Founder & Lead Developer: prawiraxliv\n⚡ Brother Hub Official • High Quality Automation"
fLbl.Font = THEME.Font
fLbl.TextSize = 12
fLbl.TextColor3 = THEME.Text
fLbl.TextXAlignment = Enum.TextXAlignment.Left

createButton(pageCredits, "💬 Salin Link Discord Server (discord.gg/szYbZCqHKS)", THEME.Blue, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Link Discord Server disalin!")
end)

createButton(pageCredits, "☕ Donasi via Saweria (saweria.co/BROTHERHUB)", THEME.Gold, function()
    copyToClipboard("https://saweria.co/BROTHERHUB", "Link Donasi Saweria disalin!")
end)

createButton(pageCredits, "💎 Donasi via SociaBuzz (QRIS / GoPay / OVO)", THEME.Purple, function()
    copyToClipboard("https://sociabuzz.com/brotherhubofficial/tribe", "Link SociaBuzz disalin!")
end)

-- Initialize to First Tab
switchTab("Auto Farm")

-- Finished Startup Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "👑 BROTHER HUB",
        Text = "Mine It Master Script Loaded Successfully!",
        Duration = 5
    })
end)
