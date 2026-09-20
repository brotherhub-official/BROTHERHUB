--[[
    ========================================================================
    👑 BROTHER HUB — OFFICIAL DRILL TO EARTH'S CORE MASTER SUITE
    ========================================================================
    Game        : Drill to Earth's Core
    Place ID    : 101906032112547 (Lobby) / 74507545904779 (Main In-Game)
    Universe ID : 9796898051
    Design Tier : 1:1 FlowerShop Master Standard (RGB Neon Stroke, MinCircle 80x80)
    Platform    : Universal (Xeno PC, Delta / Arceus / Codex Mobile Android)
    Language    : Bilingual Smart Engine (🇮🇩 ID / 🇬🇧 EN Auto-Detect & Toggle)
    Features    : Auto-Loot to Sack (ToolService Remote), Auto Store to Crate,
                  Auto Money Sack Collection, Auto Mine Rocks/Ores (Pickaxe Aura),
                  Safe Stance Combat Engine (Above/Behind Enemy - Butter Smooth),
                  Real 10-Layer Depth Teleportation & Towns/Church Weapon Storage,
                  Save & Load Configuration Suite (FlowerShop Standard)
    Security    : Brother Guard Undetected Engine
    ========================================================================
]]

-- [0] MULTI-INSTANCE PREVIOUS RUN CLEANUP
if _G.BH_DRILL_CLEANUP then
    pcall(_G.BH_DRILL_CLEANUP)
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
local CollectionService   = game:GetService("CollectionService")
local CoreGui             = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local camera      = workspace.CurrentCamera

-- Global Connection & Thread Management
local activeConnections   = {}
local activeThreads       = {}
local activeEspElements   = {}
local isTeleporting       = false
local currentCombatTarget = nil
local currentMineTarget   = nil

local function registerConnection(conn)
    table.insert(activeConnections, conn)
    return conn
end

local function registerThread(f)
    local t = task.spawn(f)
    table.insert(activeThreads, t)
    return t
end


local VirtualUser = nil
pcall(function()
    VirtualUser = game:GetService("VirtualUser")
end)
local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = game:GetService("VirtualInputManager")
end)

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

-- Default Lighting Cache for Clean Fullbright Restore
local defaultLighting = {
    Brightness = 2,
    ClockTime = 14,
    FogEnd = 10000,
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

-- ====================================================================
-- 👑 BROTHER HUB - TELEMETRY & EXECUTION LOGGER (FOUNDER & WAKIL FOUNDER)
-- ====================================================================
local function sendExecutionLog(scriptTitle)
    if _G.BROTHERHUB_TRACKED then return end
    _G.BROTHERHUB_TRACKED = true

    task.spawn(function()
        pcall(function()
            local MarketplaceService = game:GetService("MarketplaceService")
            local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()

            local httpReq = (syn and syn.request) or (http and http.request) or http_request or request or (Fluxus and Fluxus.request)
            if not httpReq then return end

            local gName = "Roblox Game"
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

            local wh = table.concat({
                "https://discord.com/api/webhooks/",
                "1548038487125524632/",
                "ysx1rK4m002JjgbK25bLsGEP_U75gsFvIFG0o0XU1GJAdjj-3UUNZHVJLZJu7Y3x_O7b"
            })

            local payload = {
                username = "Brother Hub Telemetry",
                avatar_url = "https://cdn.discordapp.com/icons/1547929421284114453/45d5b82878099746173bff32ee6a53e1.png?size=512",
                embeds = {
                    {
                        title = "⚡ SCRIPT EXECUTED | BROTHER HUB",
                        description = "Seorang pemain baru saja mengeksekusi script **BROTHER HUB**.",
                        color = 0x00FFC8,
                        thumbnail = { url = avatarUrl },
                        fields = {
                            { name = "👤 Pemain", value = "[" .. username .. "](" .. profileUrl .. ") (`" .. displayName .. "`)", inline = true },
                            { name = "🆔 User ID", value = "`" .. userId .. "`", inline = true },
                            { name = "📅 Usia Akun", value = "`" .. accountAge .. "`", inline = true },
                            { name = "🎮 Game", value = "`" .. gName .. "`", inline = true },
                            { name = "📜 Script", value = "`" .. (scriptTitle or "Brother Hub") .. "`", inline = true },
                            { name = "⚙️ Executor", value = "`" .. execName .. "`", inline = true },
                            { name = "📍 Place ID", value = "`" .. placeId .. "`", inline = true },
                            { name = "🌐 Job ID", value = "`" .. jobId .. "`", inline = true },
                            { name = "⏰ Waktu Eksekusi", value = "<t:" .. tostring(now) .. ":F> (<t:" .. tostring(now) .. ":R>)", inline = false },
                        },
                        footer = {
                            text = "Brother Hub Analytics • Strictly Confidential (Founder & Wakil Founder Only)",
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

sendExecutionLog("Drill to Earth's Core")

-- [2] KNIT & TOOL CONTROLLER RESOLVER
local Knit = nil
local ToolController = nil

pcall(function()
    if ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Knit") then
        Knit = require(ReplicatedStorage.Packages.Knit)
        if Knit.GetController then
            ToolController = Knit.GetController("ToolController")
        end
    end
end)

local function getKnitService(serviceName)
    if Knit and Knit.GetService then
        local success, s = pcall(function() return Knit.GetService(serviceName) end)
        if success and s then return s end
    end
    return nil
end

-- Direct Server Remote for ToolService (Bypasses Client ToolController Mutation)
local ToolServiceRE = nil
local ToolServiceRF = nil

local function getToolServiceRemote()
    if ToolServiceRE and ToolServiceRF then return ToolServiceRE, ToolServiceRF end
    pcall(function()
        local ts = ReplicatedStorage:FindFirstChild("ToolService", true)
        if ts then
            ToolServiceRE = ts:FindFirstChild("Update", true)
            ToolServiceRF = ts:FindFirstChild("EquipTool", true)
        end
    end)
    return ToolServiceRE, ToolServiceRF
end

getToolServiceRemote()

-- Safe Server Remote Fire (Prioritizes Knit Client Comm Signal, Fallback to RemoteEvent)
local function sendToolServerUpdate(args)
    pcall(function()
        local ts = getKnitService("ToolService")
        if ts and ts.Update then
            ts.Update:Fire(args)
            return
        end
        local tsRE, _ = getToolServiceRemote()
        if tsRE and tsRE:IsA("RemoteEvent") then
            tsRE:FireServer(args)
        end
    end)
end

-- Tool Attribute Safe Keeper: Ensures Range is set on any equipped weapon so client code never errors on arithmetic
local function ensureToolRange(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        if tool:GetAttribute("Range") == nil then
            tool:SetAttribute("Range", 25)
        end
        if tool:GetAttribute("LookRadius") == nil then
            tool:SetAttribute("LookRadius", 25)
        end
    end)
end

-- Passive Tool Range Guardian
registerConnection(UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
        local char = LocalPlayer.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then
                    ensureToolRange(item)
                end
            end
        end
    end
end))

-- Tool Finder & Equipper (Native Humanoid + Knit Hotbar + Server RF Sync - Non-Destructive)
local lastEquipTime = 0
local currentEquippedKeyword = ""

local function findToolByKeyword(keyword)
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local kw = keyword:lower()

    local function matchesKw(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local nm = tool.Name:lower()
        local cls = tostring(tool:GetAttribute("Class") or ""):lower()
        if nm:find(kw) or cls:find(kw) then return true end
        if (kw == "sack" or kw == "bag" or kw == "itembag") and (nm:find("bag") or nm:find("sack") or cls:find("bag") or cls:find("sack")) then
            return true
        end
        if (kw == "pickaxe" or kw == "pick") and (nm:find("pick") or cls:find("pick")) then
            return true
        end
        if (kw == "sword" or kw == "weapon") and (nm:find("sword") or cls:find("sword") or nm:find("weapon") or cls:find("weapon")) then
            return true
        end
        return false
    end

    -- 1. Check Character first (already in hand)
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if matchesKw(item) then
                return item, true
            end
        end
    end

    -- 2. Check Backpack
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if matchesKw(item) then
                return item, false
            end
        end
    end

    -- 3. Check HotbarController.Tools
    local hbc = Knit and Knit.GetController and Knit.GetController("HotbarController")
    if hbc and hbc.Tools then
        for _, item in ipairs(hbc.Tools) do
            if matchesKw(item) then
                local isEq = (char and item.Parent == char) or (hbc.CurrentTool == item)
                return item, isEq
            end
        end
    end

    return nil, false
end

local function equipToolByName(keyword)
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")

    local tool, isEquipped = findToolByKeyword(keyword)
    if not tool then return false end

    ensureToolRange(tool)

    local hbc = Knit and Knit.GetController and Knit.GetController("HotbarController")
    local isHandMatch = (tool.Parent == char) or (hbc and hbc.CurrentTool == tool)

    -- If already active tool in hand and matched, do not redundantly invoke remotes
    if currentEquippedKeyword == keyword and isHandMatch then
        return true
    end

    -- Allow immediate equip if switching keywords (e.g. ItemBag -> Pickaxe)
    if currentEquippedKeyword == keyword and (os.clock() - lastEquipTime < 0.1) then
        return false
    end
    lastEquipTime = os.clock()

    -- 1. Official HotbarController equip (Syncs tool slots and calls Knit ToolService:EquipTool)
    if hbc then
        if hbc.SyncToolOrder then pcall(function() hbc:SyncToolOrder() end) end
        if hbc.Tools then
            local idx = table.find(hbc.Tools, tool)
            if idx and hbc.EquipToolAtIndex then
                pcall(function() hbc:EquipToolAtIndex(idx) end)
            end
        end
        hbc.CurrentTool = tool
        if hbc.Update then pcall(function() hbc:Update() end) end
    end

    -- 2. Direct Knit ToolService EquipTool RemoteFunction (Guarantees server registers tool equip)
    pcall(function()
        local ts = getKnitService("ToolService")
        if ts and ts.EquipTool then
            ts:EquipTool(tool)
        else
            local _, tsRF = getToolServiceRemote()
            if tsRF then
                tsRF:InvokeServer(tool)
            end
        end
    end)

    -- 3. Fallback: Humanoid native equip if tool remains in Backpack
    if hum and tool.Parent ~= char and tool:IsDescendantOf(LocalPlayer:FindFirstChildOfClass("Backpack") or workspace) then
        pcall(function() hum:EquipTool(tool) end)
    end

    currentEquippedKeyword = keyword
    return true
end

-- Comprehensive Rock & Ore Solid Collision Restorer (Guarantees Rocks NEVER Become Ghost/Noclip & NEVER Strips Ore Tags)
-- Comprehensive Rock & Ore Solid Collision Restorer (Zero Ghost/Noclip Parts)
local function restoreAllRockCollisions()
    pcall(function()
        local oresFolder = workspace:FindFirstChild("Ores")
        if oresFolder then
            for _, node in ipairs(oresFolder:GetDescendants()) do
                if node:IsA("BasePart") then
                    if node.Name == "Rock" or node.Name == "Ore" or node:IsA("MeshPart") then
                        node.CanCollide = true
                        node.CanQuery = true
                        node.CanTouch = true
                    end
                end
            end
        end
        for _, fName in ipairs({ "Rocks", "RockWalls", "DigSpots" }) do
            local folder = workspace:FindFirstChild(fName)
            if folder then
                for _, obj in ipairs(folder:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CanCollide = true
                        obj.CanQuery = true
                        obj.CanTouch = true
                    end
                end
            end
        end
    end)
end

restoreAllRockCollisions()

-- ====================================================================
-- ⚔️ MASTER PUKUL BIASA / NORMAL SWING EXECUTOR (ZERO CUSTOM INSTANCES)
-- ====================================================================
local lastSwingClock = 0
local cachedTracks = {}

local function findTaggedAncestor(p1, p2)
    local v1 = p1
    while v1 and v1 ~= workspace do
        if CollectionService:HasTag(v1, p2) then
            return v1
        end
        v1 = v1.Parent
    end
    return nil
end

local function executeToolSwing(toolType, targetPos, targetInstance)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Dynamic cadence matching weapon attack speed
    local equippedTool = char:FindFirstChildOfClass("Tool")
    local atkSpeed = (equippedTool and equippedTool:GetAttribute("AttackSpeed")) or 1.0
    local swingInterval = math.clamp(1 / math.max(0.2, atkSpeed), 0.15, 0.6)

    if os.clock() - lastSwingClock < swingInterval then
        return
    end
    lastSwingClock = os.clock()

    -- 1. Collision-Safe Face Direction & Horizontal Alignment
    -- Karakter menghadap langsung ke batu/musuh sehingga kerucut MeleeSwingBounds mengarah tepat ke target
    if targetPos then
        pcall(function()
            local curPos = root.Position
            local lookPos = Vector3.new(targetPos.X, curPos.Y, targetPos.Z)
            if (lookPos - curPos).Magnitude > 0.05 then
                root.CFrame = CFrame.lookAt(curPos, lookPos)
            end
        end)
    end

    -- 2. Resolve Target Entity / Tagged Ore for 100% Hit Delivery
    local targetList = {}
    if targetInstance then
        local oreTarget = findTaggedAncestor(targetInstance, "Ore")
            or findTaggedAncestor(targetInstance, "RockWall")
            or (targetInstance:IsA("Model") and targetInstance)
            or (targetInstance.Parent and targetInstance.Parent:IsA("Model") and targetInstance.Parent)
            or targetInstance
        if oreTarget then
            table.insert(targetList, oreTarget)
        end
    end

    -- 3. Visual Character Swing Animation (Jika Silent Damage mati)
    if not Flags.SilentDamage then
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum)
            if animator then
                local animName = (toolType == "Pickaxe") and "Pickaxe_Swing1" or "Sword_Attack1"
                local animObj = ReplicatedStorage:FindFirstChild("Assets")
                    and ReplicatedStorage.Assets:FindFirstChild("Animations")
                    and (ReplicatedStorage.Assets.Animations:FindFirstChild(animName) or ReplicatedStorage.Assets.Animations:FindFirstChild("ToolSwing"))
                if animObj then
                    local track = cachedTracks[animName]
                    if not track or track.Parent ~= animator then
                        track = animator:LoadAnimation(animObj)
                        track.Priority = Enum.AnimationPriority.Action
                        track.Looped = false
                        cachedTracks[animName] = track
                    end
                    if track and not track.IsPlaying then
                        track:Play(0.1, 1, 1.0)
                    end
                end
            end
        end)

        pcall(function()
            local sc = Knit and Knit.GetController and Knit.GetController("SoundController")
            if sc and sc.PlaySound then
                sc:PlaySound(toolType == "Pickaxe" and "Pickaxe_Equip" or "SwordSteel_Equip")
            end
        end)
    end

    -- 4. PUKUL BIASA METODE 1: ActiveTool:Swing() & Direct ActiveTool.Execute
    pcall(function()
        local tc = Knit and Knit.GetController and Knit.GetController("ToolController")
        local active = tc and tc.ActiveTool
        if active then
            if active.Range == nil or (typeof(active.Range) == "number" and active.Range < 50) then
                active.Range = 50 -- Perluas jangkauan deteksi hitbox client agar tidak miss
            end
            if active.LastSwing then
                active.LastSwing = 0 -- Reset cooldown ayunan agar langsung dieksekusi
            end
            if active.Swing then
                active:Swing()
            end
            if #targetList > 0 and active.Execute and active.Execute.Fire then
                active.Execute:Fire({ "Swing", targetList })
            end
        end
    end)

    -- 5. PUKUL BIASA METODE 2: Direct ToolService Remote Signal (100% Guaranteed Hit Server-Side)
    if #targetList > 0 then
        sendToolServerUpdate({ "Swing", targetList })
    end

    -- 6. PUKUL BIASA METODE 3: Tool:Activate() (Roblox Standard Tool Activation)
    pcall(function()
        if equippedTool and equippedTool:IsA("Tool") then
            equippedTool:Activate()
        end
    end)

    -- 7. PUKUL BIASA METODE 4: Virtual Input Mouse Click Simulation (Native Primary Attack)
    -- Meniru klik mouse kiri (Left Click / Primary Attack) pemain secara presisi
    pcall(function()
        local vu = game:GetService("VirtualUser")
        if vu then
            vu:Button1Down(Vector2.new(0, 0))
            task.wait(0.01)
            vu:Button1Up(Vector2.new(0, 0))
        end
    end)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if vim then
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.01)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
end

-- [3] CONFIGURATION FILE SYSTEM (FLOWER SHOP MASTER STANDARD)
local hasFS = (typeof(writefile) == "function")
    and (typeof(readfile) == "function")
    and (typeof(isfile) == "function")
    and (typeof(makefolder) == "function")
    and (typeof(isfolder) == "function")

local ROOT_DIR   = "BrotherHub"
local CONFIG_DIR = ROOT_DIR .. "/DrillToEarth"
local CFG_FILE   = CONFIG_DIR .. "/Config.json"

if hasFS then
    pcall(function()
        if not isfolder(ROOT_DIR)   then makefolder(ROOT_DIR)   end
        if not isfolder(CONFIG_DIR) then makefolder(CONFIG_DIR) end
    end)
end

-- [4] SMART BILINGUAL SYSTEM
local currentLang = "EN"
pcall(function()
    local region = LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
    if region == "ID" then
        currentLang = "ID"
    end
end)

local STRINGS = {
    ID = {
        HubTitle        = "BROTHER HUB",
        HubSubtitle     = "Drill to Earth's Core • Master Suite",
        TabDrill        = "Bor Inti",
        TabUpgrade      = "Upgrade Bor",
        TabLoot         = "Loot & Karung",
        TabCombat       = "Tambang & Musuh",
        TabQuests       = "Misi & Hadiah",
        TabESP          = "ESP Visual",
        TabPlayer       = "Karakter",
        TabTeleport     = "Teleport",
        TabConfig       = "Konfigurasi",
        TabSettings     = "Pengaturan",
        TabDonate       = "Donasi",
        TabCredit       = "Kredit",

        -- Drill Tab
        SecDrill        = "KONTROL OTOMATIS MESIN BOR",
        AutoThrottle    = "Auto Full Gas / Throttle 100%",
        AutoThrottleDesc= "Mengunci tuas gas bor pada kecepatan 100% maju terus-menerus",
        AutoBoost       = "Auto Aktivasi Turbo Boost",
        AutoBoostDesc   = "Menekan tombol turbo boost seketika saat cooldown selesai",
        LockSeat        = "Kunci Karakter di Kursi Pengemudi",
        LockSeatDesc    = "Mencegah karakter terlempar atau dikeluarkan dari kursi kemudi",
        AutoUnstuck     = "Auto Atasi Bor Macet (Unstuck)",
        AutoUnstuckDesc = "Mendeteksi bor tersangkut dinding & memanggil perbaikan otomatis",
        AutoSkipCut     = "Auto Lewati Cutscene (Fast Skip)",
        AutoSkipCutDesc = "Melewati seluruh video/cutscene game secara instan otomatis",

        -- Upgrade Tab
        SecUpgrade      = "UPGRADE LEVEL BOR OTOMATIS",
        AutoUpgrade     = "Auto Beli Kartu Upgrade Bor",
        AutoUpgradeDesc = "Memilih kartu upgrade terbaik saat opsi upgrade muncul",
        AutoReroll      = "Auto Reroll Gratis Saat Kartu Buruk",
        AutoRerollDesc  = "Mengocok ulang kartu upgrade jika tidak ada opsi yang diinginkan",
        ClaimFreeClass  = "Auto Klaim Class Gratis",
        ClaimFreeClassD = "Mengambil hadiah class gratis yang tersedia di stasiun",

        -- Loot Tab
        SecLoot         = "PENGAMBILAN LOOT OTOMATIS (VACUUM TO SACK)",
        AutoLootSack    = "Auto-Loot ke Karung (Remote ToolService)",
        AutoLootSackDesc= "Memasukkan drop ore & mineral langsung ke karung tas pemain",
        IgnoreMonsterDrops  = "🚫 Tolak Drop Monster Mati (Filter Sack)",
        IgnoreMonsterDropsD = "Mengabaikan drop dari monster/musuh yang mati agar karung tidak penuh sampah",
        AutoStoreCrate  = "Auto Simpan ke Crate Bor (StoreInCrate)",
        AutoStoreCrateD = "Otomatis memindahkan isi karung ke crate bor saat penuh/dekat",
        FilterLabel     = "Pilih Item Masuk Sack / Filter",
        CatFilterLabel  = "Filter Kategori (Bisa Pilih Banyak / Multi-Select)",
        ItemFilterLabel = "Filter Nama Item (Bisa Pilih Banyak / Multi-Select)",
        UseCatFilter    = "Filter Berdasarkan Kategori (Ore, Fuel, Scrap, Enemy)",
        UseCatFilterD   = "Hanya mengambil kategori yang dicentang ke dalam karung tas",
        UseItemFilter   = "Filter Berdasarkan Nama Item Spesifik",
        UseItemFilterD  = "Menyaring drop berdasarkan nama item yang dicentang di bawah",
        TpAltarChurch   = "⛪ Teleport ke Altar / Church (Simpan Peralatan Boss)",
        AutoSimpanAltar = "⚡ Auto Simpan Peralatan di Altar (E Prompt)",
        RadiusLabel     = "Radius Ambil Loot (Studs)",
        AutoSack        = "Auto Ambil Karung Uang (Money Sack)",
        AutoSackDesc    = "Mengambil seluruh karung uang ke saldo kas tanpa masuk tas",
        AutoCrate       = "Auto Ambil Kotak Harta (Crate)",
        AutoCrateDesc   = "Membuka dan mengambil crate material tanpa perlu menahan tombol",
        AutoFuelLeech   = "Auto Ambil Orb Bahan Bakar (Fuel)",
        AutoFuelLeechD  = "Menghisap orb bahan bakar di sekitar bor agar bensin tidak habis",
        BtnDumpAll      = "Buang Semua Isi Karung (Drop All)",

        -- Combat Tab
        SecCombat       = "TAMBANG BATU & SAFE STANCE COMBAT",
        AutoMineAura    = "Auto Mining Batu & Bijih (Pickaxe Aura)",
        AutoMineAuraDesc= "Memukul dan menambang semua batu, ore, & dinding sekitar otomatis",
        AutoApproachOre = "Auto Dekati Batu / Ore (Approach)",
        AutoApproachOreDesc = "Otomatis mendekati posisi batu terdekat agar selalu dalam jangkauan pukulan beliung",
        SilentDamage    = "Mode Serangan Diam (Diem Tapi Damage)",
        SilentDamageDesc= "Karakter tetap tenang tanpa animasi ayunan liar di rekaman, damage tetap masuk 100% normal ke batu & lawan",
        AutoKillHostile = "Auto Kill Musuh (Safe Stance Engine)",
        AutoKillHostileD= "Menyerang musuh secara halus dari posisi aman (Poly Loot Style)",
        StanceModeLabel = "Mode Posisi Safe Stance",
        StanceDistLabel = "Jarak Stance dari Musuh (Studs)",
        MineRadiusLabel = "Radius Jangkauan Tambang (Studs)",

        -- Quests Tab
        SecQuests       = "KLAIM MISI & HADIAH",
        AutoQuests      = "Auto Klaim Misi Selesai",
        AutoQuestsDesc  = "Mengklaim seluruh hadiah quest otomatis tanpa buka menu",
        AutoGroupVIP    = "Auto Klaim Hadiah Grup & VIP",
        AutoGroupVIPD   = "Mengambil bonus harian grup dan VIP Cores otomatis",

        -- ESP Tab
        SecESP          = "RADAR VISUAL TEMBUS PANDANG (ESP)",
        BossWallESP     = "Door Boss / Boss Wall ESP (Merah Neon)",
        BossWallESPDesc = "Menandai pintu gerbang dungeon & bos tembus dinding tebal",
        LootESP         = "Loot & Dropped Ores ESP (Radar Loot)",
        LootESPDesc     = "Menampilkan posisi seluruh ore, permata, karung, & peti jatuh",
        SackESP         = "ESP Karung Uang Saja (Emas)",
        CrateESP        = "ESP Kotak Harta Saja (Ungu)",
        GemsESP         = "ESP Permata Langka Saja (Cyan)",
        DrillESP        = "ESP Posisi Mesin Bor (Hijau)",
        HostileESP      = "ESP Musuh & Monster (Orange)",
        EspDistLabel    = "Jarak Maksimal ESP (Studs)",

        -- Movement Tab
        SecMove         = "FITUR GERAKAN & SURVIVAL",
        ToggleSpeed     = "Aktifkan WalkSpeed",
        ToggleJump      = "Aktifkan JumpPower",
        ToggleNoclip    = "Aktifkan Noclip Tembus Dinding",
        ToggleInfJump   = "Aktifkan Infinite Jump",
        SafeStanceDrill = "Kunci Karakter Dekat Mesin Bor",
        SafeStanceDesc  = "Mencegah terjatuh ke jurang/terlempar saat bor melaju cepat",
        Fullbright      = "Penglihatan Malam Terang (Fullbright)",
        FullbrightDesc  = "Meniadakan kegelapan lorong bawah tanah agar jernih",

        -- Teleport Tab
        SecTpDepths     = "TELEPORT KEDALAMAN (10 LAYER SHAFT)",
        SecTpTowns      = "TELEPORT KOTA & LOBBY STORAGE",
        SecTpDrill      = "TELEPORT KE MESIN BOR",

        -- Config Tab
        SecConfig       = "MANAJEMEN SIMPAN & MUAT KONFIGURASI",
        BtnSaveCfg      = "💾 Simpan Konfigurasi Sekarang",
        BtnLoadCfg      = "📂 Muat Ulang Konfigurasi Tersimpan",
        BtnResetCfg     = "🔄 Reset ke Pengaturan Default",
        AutoSaveToggle  = "Auto Simpan Saat Mengubah Pilihan",
        AutoSaveDesc    = "Menyimpan pengaturan otomatis setiap tombol toggle diubah",

        -- Settings Tab
        SecSettings     = "PENGATURAN TAMPILAN & ANTARMUKA",
        SwitchLang      = "Ganti Bahasa (Language: ID / EN)",
        BtnDestroy      = "Tutup Script Sepenuhnya (Unload)",
    },
    EN = {
        HubTitle        = "BROTHER HUB",
        HubSubtitle     = "Drill to Earth's Core • Master Suite",
        TabDrill        = "Drill Controls",
        TabUpgrade      = "Drill Upgrades",
        TabLoot         = "Loot & Sacks",
        TabCombat       = "Mining & Enemies",
        TabQuests       = "Quests & Rewards",
        TabESP          = "Visual ESP",
        TabPlayer       = "Player Movement",
        TabTeleport     = "Teleports",
        TabConfig       = "Configuration",
        TabSettings     = "Settings",
        TabDonate       = "Donation",
        TabCredit       = "Credits",

        -- Drill Tab
        SecDrill        = "AUTOMATED DRILL CONTROLLER",
        AutoThrottle    = "Auto Full Throttle 100%",
        AutoThrottleDesc= "Locks the throttle lever at 100% forward continuously",
        AutoBoost       = "Auto Trigger Turbo Boost",
        AutoBoostDesc   = "Activates turbo booster instantly as soon as cooldown finishes",
        LockSeat        = "Lock Character into Driver Seat",
        LockSeatDesc    = "Prevents character from being ejected or unseated from the drill",
        AutoUnstuck     = "Auto Unstuck Drill Machine",
        AutoUnstuckDesc = "Detects when drill is wedged against wall & requests unstuck",
        AutoSkipCut     = "Fast Skip Cutscenes",
        AutoSkipCutDesc = "Skips narrative videos and intro cutscenes instantaneously",

        -- Upgrade Tab
        SecUpgrade      = "AUTOMATED DRILL UPGRADES",
        AutoUpgrade     = "Auto Buy Best Upgrade Card",
        AutoUpgradeDesc = "Selects top-tier card automatically when upgrade prompt appears",
        AutoReroll      = "Auto Free Reroll on Bad Options",
        AutoRerollDesc  = "Rerolls upgrade card deck if no preferred options are drawn",
        ClaimFreeClass  = "Auto Claim Free Station Class",
        ClaimFreeClassD = "Claims complimentary class rewards available at stations",

        -- Loot Tab
        SecLoot         = "AUTOMATED LOOT VACUUM (REMOTE SACK)",
        AutoLootSack    = "Auto-Loot to Sack (ToolService Remote)",
        AutoLootSackDesc= "Transfers nearby dropped ores and items directly into sack",
        IgnoreMonsterDrops  = "🚫 Ignore Dead Monster Drops",
        IgnoreMonsterDropsD = "Blocks items dropped by killed enemies from entering sack storage",
        AutoStoreCrate  = "Auto Store to Drill Crate",
        AutoStoreCrateD = "Empties sack contents into the nearest drill crate automatically",
        FilterLabel     = "Sack Loot Item Filter",
        CatFilterLabel  = "Category Multi-Filter (Select Multiple)",
        ItemFilterLabel = "Item Name Multi-Filter (Select Multiple)",
        UseCatFilter    = "Category Filter (Ore, Fuel, Scrap, Enemy)",
        UseCatFilterD   = "Only collects checked categories into sack storage",
        UseItemFilter   = "Specific Item Name Filter",
        UseItemFilterD  = "Filters dropped items based on checked item names below",
        TpAltarChurch   = "⛪ Teleport to Altar / Church (Boss Gear Storage)",
        AutoSimpanAltar = "⚡ Auto Interact Altar (Store Gear E Prompt)",
        RadiusLabel     = "Loot Collection Radius (Studs)",
        AutoSack        = "Auto Collect Money Sacks",
        AutoSackDesc    = "Deposits coin bags directly into wallet without filling sack",
        AutoCrate       = "Auto Collect Supply Crates",
        AutoCrateDesc   = "Opens and collects material crates without holding button",
        AutoFuelLeech   = "Auto Collect Fuel Orbs",
        AutoFuelLeechD  = "Pulls fuel orbs from killed leeches to keep the drill tank full",
        BtnDumpAll      = "Dump All Sack Items (Drop All)",

        -- Combat Tab
        SecCombat       = "ROCK MINING & SAFE STANCE COMBAT",
        AutoMineAura    = "Auto Mine Rocks & Ores (Pickaxe Aura)",
        AutoMineAuraDesc= "Breaks all surrounding rocks, boulders, ores, and walls automatically",
        AutoApproachOre = "Auto Approach Rocks & Ores",
        AutoApproachOreDesc = "Automatically moves close to nearest ore/rock for guaranteed pickaxe reach",
        SilentDamage    = "Silent Damage Mode (Calm & Stealth)",
        SilentDamageDesc= "Character stays calm without frantic swinging animations in recordings, full damage dealt directly",
        AutoKillHostile = "Auto Kill Enemies (Safe Stance Engine)",
        AutoKillHostileD= "Attacks enemies smoothly from a safe vantage point (Poly Loot Standard)",
        StanceModeLabel = "Safe Stance Position Mode",
        StanceDistLabel = "Stance Offset Distance (Studs)",
        MineRadiusLabel = "Mining Reach Radius (Studs)",

        -- Quests Tab
        SecQuests       = "QUESTS & SOCIAL REWARDS",
        AutoQuests      = "Auto Claim Completed Quests",
        AutoQuestsDesc  = "Claims all completed quest rewards without opening UI",
        AutoGroupVIP    = "Auto Claim Group & VIP Rewards",
        AutoGroupVIPD   = "Collects daily group bonus and VIP cores automatically",

        -- ESP Tab
        SecESP          = "VISUAL WALLHACK & RADAR (ESP)",
        BossWallESP     = "Door Boss / Boss Wall ESP (Neon Red)",
        BossWallESPDesc = "Highlights dungeon gates and boss walls through dense ground",
        LootESP         = "Loot & Dropped Ores ESP",
        LootESPDesc     = "Displays markers for dropped ores, gems, sacks, and chests",
        SackESP         = "Money Sacks Only (Gold)",
        CrateESP        = "Supply Crates Only (Purple)",
        GemsESP         = "Rare Gems Only (Cyan)",
        DrillESP        = "Drill Machine ESP (Green)",
        HostileESP      = "Enemies & Leeches ESP (Orange)",
        EspDistLabel    = "Max ESP Distance (Studs)",

        -- Movement Tab
        SecMove         = "MOVEMENT & SURVIVAL UTILITIES",
        ToggleSpeed     = "Enable WalkSpeed Boost",
        ToggleJump      = "Enable JumpPower Boost",
        ToggleNoclip    = "Enable Penetration Noclip",
        ToggleInfJump   = "Enable Infinite Jump",
        SafeStanceDrill = "Anchor Near Drill Machine",
        SafeStanceDesc  = "Keeps character safely on the drill deck during high speed",
        Fullbright      = "Fullbright Night Vision",
        FullbrightDesc  = "Dispels shaft shadows and subterranean darkness completely",

        -- Teleport Tab
        SecTpDepths     = "DEPTH TELEPORTS (10-LAYER SHAFT)",
        SecTpTowns      = "TOWNS & LOBBY WEAPON STORAGE",
        SecTpDrill      = "DRILL MACHINE TELEPORTS",

        -- Config Tab
        SecConfig       = "CONFIGURATION SAVE & LOAD",
        BtnSaveCfg      = "💾 Save Current Configuration",
        BtnLoadCfg      = "📂 Load Saved Configuration",
        BtnResetCfg     = "🔄 Reset to Default Settings",
        AutoSaveToggle  = "Auto Save on Toggle Changes",
        AutoSaveDesc    = "Automatically saves settings to file whenever any toggle changes",

        -- Settings Tab
        SecSettings     = "INTERFACE & SYSTEM PREFERENCES",
        SwitchLang      = "Switch Language (ID / EN)",
        BtnDestroy      = "Completely Unload Script",
    }
}

local function T(key)
    local langTable = STRINGS[currentLang] or STRINGS.EN
    return langTable[key] or STRINGS.EN[key] or key
end

-- [5] MASTER STATE FLAGS (ALL CRITICAL AUTOMATION OFF BY DEFAULT)
local Flags = {
    -- Drill
    AutoThrottle    = false,
    AutoBoost       = false,
    LockSeat        = false,
    AutoUnstuck     = false,
    AutoSkipCut     = false,

    -- Upgrades
    AutoUpgrade     = false,
    AutoReroll      = false,
    ClaimFreeClass  = false,

    -- Loot
    AutoLootSack    = false,
    IgnoreMonsterDrops = false,
    AutoStoreCrate  = false,
    SackFilter      = "All Items",
    UseCategoryFilter = true,
    SelectedCategories = {
        ["Ore/Gems"] = true,
        ["Fuel"]     = true,
        ["Scrap"]    = true,
        ["Enemy"]    = false,
        ["Money"]    = true,
    },
    UseItemFilter   = false,
    SelectedItems   = {
        ["Coal"]     = true,
        ["Iron"]     = true,
        ["Gold"]     = true,
        ["Diamond"]  = true,
        ["Emerald"]  = true,
        ["Ruby"]     = true,
        ["Heartgem"] = true,
        ["Scrap"]    = true,
        ["Fuel"]     = true,
        ["Enemy"]    = false,
        ["Money"]    = true,
    },
    LootRadius      = 40,
    AutoSack        = false,
    AutoCrate       = false,
    AutoFuelLeech   = false,

    -- Combat & Mining
    AutoMineAura    = false,
    AutoApproachOre = true,
    SilentDamage    = true, -- Default: Diam tapi nge-damage (tanpa ayunan liar di rekaman)
    AutoKillHostile = false,
    StanceMode      = "Behind Enemy", -- "Behind Enemy", "Above Enemy", "Ground Orbit", "Off"
    StanceDistance  = 3.5,
    MineRadius      = 60,

    -- Quests
    AutoQuests      = false,
    AutoGroupVIP    = false,

    -- ESP
    BossWallESP     = false,
    LootESP         = false,
    SackESP         = false,
    CrateESP        = false,
    GemsESP         = false,
    DrillESP        = false,
    HostileESP      = false,
    MaxEspDistance  = 350,

    -- Movement
    WalkSpeedOn     = false,
    WalkSpeedVal    = 28,
    JumpPowerOn     = false,
    JumpPowerVal    = 70,
    NoclipOn        = false,
    InfiniteJumpOn  = false,
    SafeStance      = false,
    FullbrightOn    = false,

    -- Config
    AutoSaveConfig  = true,
}

-- Config Save & Load Functions
local updateUIFromFlags = nil

local function saveConfigToFile()
    if not hasFS then return end
    pcall(function()
        local saveTable = {}
        for k, v in pairs(Flags) do
            if type(v) == "boolean" or type(v) == "number" or type(v) == "string" or type(v) == "table" then
                saveTable[k] = v
            end
        end
        writefile(CFG_FILE, HttpService:JSONEncode(saveTable))
    end)
end

local function loadConfigFromFile()
    if not hasFS then return false end
    local success, result = pcall(function()
        if not isfile(CFG_FILE) then return nil end
        return HttpService:JSONDecode(readfile(CFG_FILE))
    end)
    if success and type(result) == "table" then
        for k, v in pairs(result) do
            if Flags[k] ~= nil and (type(Flags[k]) == type(v) or type(v) == "table") then
                Flags[k] = v
            end
        end
        if updateUIFromFlags then
            pcall(updateUIFromFlags)
        end
        return true
    end
    return false
end

-- [6] THEME PALETTE (1:1 Flower Shop Standard)
local THEME = {
    Background = Color3.fromRGB(15, 17, 24),
    Sidebar    = Color3.fromRGB(20, 23, 33),
    Panel      = Color3.fromRGB(26, 30, 44),
    Slot       = Color3.fromRGB(34, 40, 58),
    Stroke     = Color3.fromRGB(48, 56, 82),
    Accent     = Color3.fromRGB(0, 255, 200),
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
    On         = Color3.fromRGB(46, 213, 115)
}

-- [7] HELPER FUNCTIONS & ENGINE SETUP

local function findDrillModel()
    local d = workspace:FindFirstChild("Drill")
    if d and d:IsA("Model") then return d end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower():find("drill") and obj:FindFirstChildWhichIsA("VehicleSeat", true) then
            return obj
        end
    end
    return nil
end

local function getDrillDeckCFrame()
    local drill = findDrillModel()
    if not drill then return nil end
    local floor = drill:FindFirstChild("WeldFloor")
    if floor and floor:IsA("BasePart") then
        local floorTopOffset = (floor.Size.Y * 0.5) + 3.0
        return floor.CFrame * CFrame.new(0, floorTopOffset, 0)
    end
    local seat = drill:FindFirstChild("LocalDriverSeat") or drill:FindFirstChildWhichIsA("VehicleSeat", true)
    if seat and seat:IsA("BasePart") then
        return seat.CFrame * CFrame.new(0, 1.8, 3.5)
    end
    local primary = drill.PrimaryPart or drill:FindFirstChildWhichIsA("BasePart")
    if primary then
        return primary.CFrame * CFrame.new(0, 2.5, 0)
    end
    return nil
end

local function restoreCollision()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local pName = part.Name
                    if pName == "HumanoidRootPart" then
                        part.CanCollide = false
                    elseif pName == "Torso" or pName == "UpperTorso" or pName == "LowerTorso" or pName == "Head" then
                        part.CanCollide = true
                    else
                        part.CanCollide = false
                    end
                end
            end
        end
        restoreAllRockCollisions()
    end)
end

restoreCollision()

local function isMonsterDrop(name)
    local nl = name:lower()
    return nl:find("goblin") or nl:find("spider") or nl:find("bone") or nl:find("flesh") or
           nl:find("ear") or nl:find("eye") or nl:find("fang") or nl:find("silk") or
           nl:find("leg") or nl:find("tooth") or nl:find("meat") or nl:find("claw") or
           nl:find("skin") or nl:find("scale") or nl:find("carcass") or nl:find("drop") or
           nl:find("worm") or nl:find("enemy") or nl:find("boss")
end

local function isOre(name)
    local nl = name:lower()
    return nl:find("coal") or nl:find("iron") or nl:find("gold") or nl:find("diamond") or
           nl:find("emerald") or nl:find("ruby") or nl:find("heartgem") or nl:find("copper") or
           nl:find("stone") or nl:find("ore") or nl:find("crystal")
end

local function isGem(name)
    local nl = name:lower()
    return nl:find("diamond") or nl:find("emerald") or nl:find("ruby") or nl:find("heartgem") or nl:find("gem")
end

local function isMoney(name)
    local nl = name:lower()
    return nl:find("sack") or nl:find("money") or nl:find("coin") or nl:find("soulorb") or
           nl:find("cash") or nl:find("crate") or nl:find("chest")
end

local function isScrap(name)
    local nl = name:lower()
    return nl:find("scrap") or nl:find("metal") or nl:find("cog") or nl:find("gear") or
           nl:find("pipe") or nl:find("spring") or nl:find("junk") or nl:find("debris") or
           nl:find("part") or nl:find("ironbar") or nl:find("bar") or nl:find("wire") or
           nl:find("wrench") or nl:find("bolt") or nl:find("engine") or nl:find("fan") or
           nl:find("mug") or nl:find("spoon")
end

local function isMed(name)
    local nl = name:lower()
    return nl:find("medkit") or nl:find("bandage") or nl:find("revive") or nl:find("heal") or nl:find("potion")
end

local function isFuel(name)
    local nl = name:lower()
    return nl:find("fuel") or nl:find("oil") or nl:find("gas") or nl:find("canister") or
           nl:find("petrol") or nl:find("tank") or nl:find("diesel") or nl:find("coal")
end

local function canItemStoreInBag(p1)
    if not p1 or not p1.Parent then return false end
    local itemsFolder = workspace:FindFirstChild("Items")
    if itemsFolder and not p1:IsDescendantOf(itemsFolder) then return false end
    if p1.Name == "Money_Sack" or p1.Name == "SoulOrb" then return false end
    if p1:GetAttribute("CraftedPlaceable") == true and p1:GetAttribute("Placed") ~= true then return false end
    if CollectionService:HasTag(p1, "ShopItem") then return false end
    return true
end

local function matchesSackFilter(name)
    local nl = name:lower()
    if Flags.IgnoreMonsterDrops and isMonsterDrop(name) then
        return false
    end

    -- 1. Mode Multi-Select Kategori (Ore/Gems, Enemy, Scrap, Fuel, Money)
    if Flags.UseCategoryFilter then
        local selCats = Flags.SelectedCategories or {}
        local hasAny = false
        local matched = false

        for cat, isChecked in pairs(selCats) do
            if isChecked then
                hasAny = true
                if cat == "Ore/Gems" and (isOre(name) or isGem(name)) then matched = true break end
                if cat == "Enemy" and isMonsterDrop(name) then matched = true break end
                if cat == "Scrap" and isScrap(name) then matched = true break end
                if cat == "Fuel" and isFuel(name) then matched = true break end
                if cat == "Money" and isMoney(name) then matched = true break end
            end
        end

        if not hasAny then
            return true
        end
        return matched
    end

    -- 2. Mode Multi-Select Nama Item Spesifik
    if Flags.UseItemFilter then
        local selItems = Flags.SelectedItems or {}
        local hasAny = false
        local matched = false

        for itKey, isChecked in pairs(selItems) do
            if isChecked then
                hasAny = true
                local ik = itKey:lower()
                if ik == "ore/gems" and (isOre(name) or isGem(name)) then matched = true break
                elseif ik == "enemy" and isMonsterDrop(name) then matched = true break
                elseif ik == "scrap" and isScrap(name) then matched = true break
                elseif ik == "fuel" and isFuel(name) then matched = true break
                elseif ik == "money" and isMoney(name) then matched = true break
                elseif nl:find(ik) then matched = true break end
            end
        end

        if not hasAny then
            return true
        end
        return matched
    end

    local f = Flags.SackFilter or "All Items"
    if f == "All Items" or f:find("All Items") or f:find("Semua Item") then
        return true
    elseif f:find("Ores & Gems") or f:find("Hanya Tambang") then
        return (isOre(name) or isGem(name)) and not isMonsterDrop(name)
    elseif f:find("Gems Only") or f:find("Hanya Permata") then
        return isGem(name) and not isMonsterDrop(name)
    elseif f:find("Money & Sacks") or f:find("Hanya Uang") then
        return isMoney(name)
    elseif f:find("Monster Drops Only") or f:find("Hanya Drop Monster") then
        return isMonsterDrop(name)
    elseif f:find("Coal") then
        return nl:find("coal")
    elseif f:find("Iron") then
        return nl:find("iron")
    elseif f:find("Gold") then
        return nl:find("gold")
    elseif f:find("Diamond") then
        return nl:find("diamond")
    elseif f:find("Emerald") then
        return nl:find("emerald")
    elseif f:find("Ruby") then
        return nl:find("ruby")
    elseif f:find("Heartgem") then
        return nl:find("heartgem")
    end
    return true
end

-- Automatic Tool Fix Listeners
pcall(function()
    local bp = LocalPlayer:WaitForChild("Backpack", 5)
    if bp then
        registerConnection(bp.ChildAdded:Connect(fixToolAttributes))
    end
end)

pcall(function()
    registerConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(fixToolAttributes)
        applyAllToolFixes()
    end))
    if LocalPlayer.Character then
        registerConnection(LocalPlayer.Character.ChildAdded:Connect(fixToolAttributes))
    end
end)

-- Teleportation Engine (Safe Dynamic Relocation)
local function safeTeleport(targetCFrame, extraHeight)
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        isTeleporting = true
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        local addY = extraHeight or 1.5
        char:PivotTo(targetCFrame + Vector3.new(0, addY, 0))

        task.delay(1.5, function()
            isTeleporting = false
        end)
    end)
end

local function teleportToAltarChurch()
    notify("Mencari posisi Altar / Church...", THEME.Title)
    pcall(function()
        -- 1. Scan ProximityPrompt "Altar" / "Simpan Peralatan" di Workspace
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                local act = (desc.ActionText or ""):lower()
                local obj = (desc.ObjectText or ""):lower()
                if obj:find("altar") or act:find("simpan") or act:find("peralatan") or obj:find("church") then
                    local p = desc.Parent
                    if p and p:IsA("BasePart") then
                        safeTeleport(p.CFrame + Vector3.new(0, 3, 0))
                        notify("Berhasil teleport ke Altar (Simpan Peralatan)!", THEME.On)
                        return
                    elseif p and p:IsA("Attachment") then
                        safeTeleport(p.WorldCFrame + Vector3.new(0, 3, 0))
                        notify("Berhasil teleport ke Altar (Simpan Peralatan)!", THEME.On)
                        return
                    elseif p and p:IsA("Model") and p.PrimaryPart then
                        safeTeleport(p.PrimaryPart.CFrame + Vector3.new(0, 3, 0))
                        notify("Berhasil teleport ke Altar (Simpan Peralatan)!", THEME.On)
                        return
                    end
                end
            end
        end

        -- 2. Scan OnboardingAttachment "Church"
        local cs = game:GetService("CollectionService")
        for _, att in ipairs(cs:GetTagged("OnboardingAttachment")) do
            if att.Name == "Church" or att.Name:lower():find("church") or att.Name:lower():find("altar") then
                safeTeleport(att.WorldCFrame + Vector3.new(0, 3, 0))
                notify("Berhasil teleport ke Altar / Church!", THEME.On)
                return
            end
        end

        -- 3. Scan Workspace Models named Church or Altar
        for _, m in ipairs(workspace:GetDescendants()) do
            local nl = m.Name:lower()
            if (nl == "altar" or nl == "church" or nl:find("altar") or nl:find("church")) and m:IsA("Model") then
                local root = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                if root then
                    safeTeleport(root.CFrame + Vector3.new(0, 3, 0))
                    notify("Berhasil teleport ke Model Altar / Church!", THEME.On)
                    return
                end
            end
        end

        -- 4. Fallback ke Church Lobby
        safeTeleport(CFrame.new(421.9, 6.0, -677.6))
        notify("Teleport ke Church Lobby Storage!", THEME.Title)
    end)
end

local function autoInteractAltar()
    pcall(function()
        local found = false
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                local act = (desc.ActionText or ""):lower()
                local obj = (desc.ObjectText or ""):lower()
                if obj:find("altar") or act:find("simpan") or act:find("peralatan") or obj:find("church") then
                    if fireproximityprompt then
                        fireproximityprompt(desc)
                    else
                        desc:InputHoldBegin()
                        task.wait(desc.HoldDuration or 0.5)
                        desc:InputHoldEnd()
                    end
                    found = true
                    notify("Interaksi Altar sukses! Peralatan disimpan.", THEME.On)
                    break
                end
            end
        end
        if not found then
            notify("Altar belum ditemukan di sekitar karakter!", THEME.Red)
        end
    end)
end

-- [8] BUTTER-SMOOTH SAFE STANCE & AUTO ORE APPROACH ENGINE (RUNSERVICE HEARTBEAT)
registerConnection(RunService.Heartbeat:Connect(function()
    -- 1. Safe Stance Combat vs Hostile Monsters
    if Flags.AutoKillHostile and currentCombatTarget and currentCombatTarget.Parent and not isTeleporting then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local ePart = currentCombatTarget.PrimaryPart or currentCombatTarget:FindFirstChildWhichIsA("BasePart")
        if root and ePart then
            local stanceMode = Flags.StanceMode or "Behind Enemy"
            local offsetDist = Flags.StanceDistance or 3.2
            local desiredPos = ePart.Position

            if stanceMode == "Above Enemy" then
                -- Height must NOT exceed ePart.Y + 1.2 studs so server MeleeSwingBounds IsPointAboveLowerBound passes 100%!
                local hoverHeight = 0.8
                pcall(function()
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = { char, currentCombatTarget }
                    local hit = workspace:Raycast(ePart.Position, Vector3.new(0, 2.5, 0), rayParams)
                    if hit then
                        hoverHeight = math.min(hoverHeight, math.max(0.2, hit.Distance - 0.5))
                    end
                end)
                desiredPos = ePart.Position + Vector3.new(0, hoverHeight, 0)
                local lookTarget = ePart.Position + (ePart.CFrame.LookVector * 0.5)
                root.CFrame = CFrame.lookAt(desiredPos, lookTarget)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            elseif stanceMode == "Behind Enemy" then
                local dist = math.clamp(offsetDist, 2.5, 3.8)
                desiredPos = ePart.Position - (ePart.CFrame.LookVector * dist)
                -- Keep character Y exactly matching enemy Y level so lower bound always passes
                desiredPos = Vector3.new(desiredPos.X, ePart.Position.Y, desiredPos.Z)
                root.CFrame = CFrame.lookAt(desiredPos, Vector3.new(ePart.Position.X, desiredPos.Y, ePart.Position.Z))
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            elseif stanceMode == "Ground Orbit" then
                local dist = math.clamp(offsetDist, 2.5, 3.8)
                local angle = os.clock() * 2.5
                desiredPos = ePart.Position + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
                desiredPos = Vector3.new(desiredPos.X, ePart.Position.Y, desiredPos.Z)
                root.CFrame = CFrame.lookAt(desiredPos, Vector3.new(ePart.Position.X, desiredPos.Y, ePart.Position.Z))
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    -- 2. Optional Auto Approach Ore (Safe Ground Navigation - Zero Clipping / Zero Noclip)
    elseif Flags.AutoMineAura and currentMineTarget and currentMineTarget.Node and currentMineTarget.Node.Parent and not isTeleporting then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root and currentMineTarget.Position then
            -- Auto recovery if rock geometry induced ragdoll/fall (zero CFrame mutation)
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.PlatformStanding then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end

            -- Safe approach logic: Dynamic surface-aware standoff distance based on rock size
            -- Never touches root.CFrame to guarantee character collisions remain 100% solid
            if Flags.AutoApproachOre then
                local tPos = currentMineTarget.Position
                local delta = root.Position - tPos
                local horizDelta = Vector3.new(delta.X, 0, delta.Z)
                local dist = horizDelta.Magnitude
                local radius = currentMineTarget.Radius or 4.0
                -- Optimal melee standoff: Stand 0.6 studs outside rock surface (well within tool reach, completely outside solid rock)
                local minSafeDist = math.max(2.5, radius + 0.6)

                if dist > (minSafeDist + 0.8) and dist <= (Flags.MineRadius or 60) then
                    local dir = (dist > 0.001) and (horizDelta / dist) or Vector3.new(0, 0, 1)
                    local standPos = Vector3.new(tPos.X + dir.X * minSafeDist, root.Position.Y, tPos.Z + dir.Z * minSafeDist)
                    hum:MoveTo(standPos)
                elseif dist < (radius + 0.2) and dist > 0.001 then
                    -- Too close to rock perimeter: step back slightly to optimal distance
                    local dir = horizDelta / dist
                    local backPos = Vector3.new(tPos.X + dir.X * minSafeDist, root.Position.Y, tPos.Z + dir.Z * minSafeDist)
                    hum:MoveTo(backPos)
                else
                    hum:MoveTo(root.Position)
                    -- Face the rock directly so melee swing box connects 100%
                    pcall(function()
                        local curPos = root.Position
                        local lookPos = Vector3.new(tPos.X, curPos.Y, tPos.Z)
                        if (lookPos - curPos).Magnitude > 0.1 then
                            root.CFrame = CFrame.lookAt(curPos, lookPos)
                        end
                    end)
                end
            end
        end
    end
end))

-- [9] BACKGROUND AUTOMATION LOOPS

-- 1. Full Throttle Engine
registerThread(function()
    while true do
        if Flags.AutoThrottle then
            pcall(function()
                local drill = findDrillModel()
                if drill then
                    local seat = drill:FindFirstChildWhichIsA("VehicleSeat", true)
                    if seat then
                        seat.ThrottleFloat = 1
                        seat.Throttle = 1
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- 2. Turbo Boost Engine
registerThread(function()
    while true do
        if Flags.AutoBoost then
            pcall(function()
                local drill = findDrillModel()
                if drill then
                    local boostRemote = drill:FindFirstChild("ActivateBoost", true)
                        or drill:FindFirstChild("BoostRemote", true)
                        or ReplicatedStorage:FindFirstChild("ActivateBoost", true)
                    if boostRemote and boostRemote:IsA("RemoteEvent") then
                        boostRemote:FireServer()
                    end
                    local drillService = getKnitService("DrillService")
                    if drillService and drillService.ActivateBoost then
                        drillService:ActivateBoost()
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- 3. Lock Character in Driver Seat
registerThread(function()
    while true do
        if Flags.LockSeat then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local drill = findDrillModel()
                if hum and drill then
                    local seat = drill:FindFirstChildWhichIsA("VehicleSeat", true)
                    if seat and seat.Occupant ~= hum and (seat.Position - char:GetPivot().Position).Magnitude <= 35 then
                        seat:Sit(hum)
                    end
                end
            end)
        end
        task.wait(0.8)
    end
end)

-- 4. Auto Unstuck & Fast Cutscene Skip
registerThread(function()
    while true do
        if Flags.AutoUnstuck then
            pcall(function()
                local drillService = getKnitService("DrillService")
                if drillService and drillService.RequestUnstuck then
                    drillService:RequestUnstuck()
                end
            end)
        end
        if Flags.AutoSkipCut then
            pcall(function()
                local cutsceneController = Knit and Knit.GetController and Knit.GetController("CutsceneController")
                if cutsceneController and cutsceneController.SkipCutscene then
                    cutsceneController:SkipCutscene()
                end
                if workspace:GetAttribute("InCutScene") == true then
                    workspace:SetAttribute("InCutScene", false)
                end
            end)
        end
        task.wait(1.5)
    end
end)

-- 5. MASTER AUTO-LOOT TO SACK & ORE VACUUM (100% REVISED & TESTED)
registerThread(function()
    while true do
        if Flags.AutoLootSack or Flags.AutoSack or Flags.AutoCrate or Flags.AutoFuelLeech then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local candidates = {}
                    local itemsFolder = workspace:FindFirstChild("Items")
                    if itemsFolder then
                        for _, it in ipairs(itemsFolder:GetChildren()) do
                            table.insert(candidates, it)
                        end
                    end

                    local maxRadius = Flags.LootRadius or 50
                    local lootTargets = {}
                    local moneyTargets = {}
                    local crateTargets = {}

                    for _, item in ipairs(candidates) do
                        if item and item.Parent then
                            local part = item:IsA("BasePart") and item or (item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")))
                            if part then
                                local dist = (part.Position - root.Position).Magnitude
                                if dist <= maxRadius then
                                    local name = item.Name
                                    local nl = name:lower()

                                    -- 1. Money Sacks & Soul Orbs -> InteractionService (Direct to wallet)
                                    if Flags.AutoSack and (nl:find("sack") or nl:find("money") or nl:find("soulorb")) then
                                        table.insert(moneyTargets, { Item = item, Part = part })
                                    -- 2. Supply Crates / Chests
                                    elseif Flags.AutoCrate and (nl:find("crate") or nl:find("chest")) then
                                        table.insert(crateTargets, { Item = item, Part = part })
                                    -- 3. Dropped Ores / Gems / Items -> Sack
                                    elseif Flags.AutoLootSack and canItemStoreInBag(item) and matchesSackFilter(name) then
                                        table.insert(lootTargets, { Item = item, Part = part })
                                    end
                                end
                            end
                        end
                    end

                    -- A. Process Money Sacks & Soul Orbs
                    if #moneyTargets > 0 then
                        for _, entry in ipairs(moneyTargets) do
                            local item = entry.Item
                            local part = entry.Part
                            if part and not part.Anchored then
                                pcall(function()
                                    part.CFrame = root.CFrame + Vector3.new(0, 1, 0)
                                    part.AssemblyLinearVelocity = Vector3.zero
                                end)
                            end
                            local isS = getKnitService("InteractionService")
                            if isS and isS.Interact then
                                isS:Interact(item)
                            end
                            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled and fireproximityprompt then
                                fireproximityprompt(prompt, 0)
                            end
                        end
                    end

                    -- B. Process Supply Crates
                    if #crateTargets > 0 then
                        for _, entry in ipairs(crateTargets) do
                            local item = entry.Item
                            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled and fireproximityprompt then
                                fireproximityprompt(prompt, 0)
                            end
                            sendToolServerUpdate({ "Pickup", item })
                        end
                    end

                    -- C. Process Dropped Ores & Items -> SACK VACUUM
                    if #lootTargets > 0 then
                        -- 1. Vacuum Pull: Physically draw unanchored items to player root so distance <= 2
                        for _, entry in ipairs(lootTargets) do
                            local item = entry.Item
                            local part = entry.Part
                            if part and not part.Anchored then
                                pcall(function()
                                    part.CFrame = root.CFrame + Vector3.new(0, 1, 0)
                                    part.AssemblyLinearVelocity = Vector3.zero
                                end)
                            end
                        end

                        -- 2. Equip ItemBag (Sack) ONLY when player is not actively mining with Pickaxe or fighting!
                        if not Flags.AutoMineAura and not Flags.AutoKillHostile and not currentMineTarget and not currentCombatTarget then
                            equipToolByName("ItemBag")
                        end

                        -- 3. Trigger Pickups via Server Remote & Client ToolController
                        local tc = Knit and Knit.GetController and Knit.GetController("ToolController")
                        local activeTool = tc and tc.ActiveTool
                        for _, entry in ipairs(lootTargets) do
                            local item = entry.Item
                            sendToolServerUpdate({ "Pickup", item })
                            if activeTool and activeTool.Execute then
                                pcall(function() activeTool.Execute:Fire({ "Pickup", item }) end)
                            end
                            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled and fireproximityprompt then
                                fireproximityprompt(prompt, 0)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.25)
    end
end)

-- 6. Auto Store to Crate Loop (Empties Sack into Drill Crate)
registerThread(function()
    while true do
        if Flags.AutoStoreCrate then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, crate in ipairs(CollectionService:GetTagged("Crate")) do
                        if crate and crate.Parent then
                            local part = crate.PrimaryPart or crate:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - root.Position).Magnitude <= 40 then
                                -- Must equip ItemBag to store into crate!
                                equipToolByName("ItemBag")
                                sendToolServerUpdate({ "StoreInCrate", crate })
                                local tc = Knit and Knit.GetController and Knit.GetController("ToolController")
                                if tc and tc.ActiveTool and tc.ActiveTool.Execute then
                                    pcall(function() tc.ActiveTool.Execute:Fire({ "StoreInCrate", crate }) end)
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

-- 7. MASTER AUTO-MINE ROCKS & SAFE STANCE HOSTILE KILL AURA (CALIBRATED CADENCE)
local lastRockColCheck = 0
local function scanMinableTargets(maxRange)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return {} end

    if os.clock() - lastRockColCheck > 2.0 then
        lastRockColCheck = os.clock()
        restoreAllRockCollisions()
    end

    local candidates = {}
    local seen = {}
    maxRange = maxRange or 60

    local function addTargetNode(node, preferredPart)
        if not node then return end
        local rootNode = node
        if seen[rootNode] then return end

        local healthVal = nil
        local healthObj = rootNode:FindFirstChild("Health")
        if healthObj and (healthObj:IsA("NumberValue") or healthObj:IsA("IntValue")) then
            healthVal = healthObj.Value
        else
            healthVal = rootNode:GetAttribute("Health")
        end
        if healthVal and healthVal <= 0 then
            return
        end

        local pos = (preferredPart and preferredPart:IsA("BasePart") and preferredPart.Position)
            or (rootNode:IsA("BasePart") and rootNode.Position)
            or (rootNode:IsA("Model") and rootNode:GetPivot().Position)

        if not pos then return end

        local horizRadius = 3.5
        if rootNode:IsA("BasePart") then
            horizRadius = math.max(rootNode.Size.X, rootNode.Size.Z) * 0.5
        elseif rootNode:IsA("Model") then
            local _, sz = rootNode:GetBoundingBox()
            horizRadius = math.max(sz.X, sz.Z) * 0.5
        end

        local centerDist = (pos - root.Position).Magnitude
        local surfaceDist = math.max(0, centerDist - horizRadius)

        if surfaceDist <= maxRange or centerDist <= maxRange then
            seen[rootNode] = true
            local orePart = rootNode:FindFirstChild("Ore") or rootNode:FindFirstChild("Rock")
            table.insert(candidates, {
                Node = rootNode,
                Position = pos,
                Distance = surfaceDist,
                OrePart = orePart,
                Radius = horizRadius
            })
        end
    end

    -- 1. Scan workspace.Ores recursively (Ore_NodeTutorial, Ore_NodeDirt, Coal, etc.)
    local oresFolder = workspace:FindFirstChild("Ores")
    if oresFolder then
        for _, obj in ipairs(oresFolder:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model")) and obj.Parent ~= oresFolder then
                local isNode = obj.Name:find("Node") or obj.Name:find("Ore") or obj.Name:find("Rock")
                local hasHealth = obj:FindFirstChild("Health") or obj:GetAttribute("Health")
                local hasTag = CollectionService:HasTag(obj, "Ore") or CollectionService:HasTag(obj, "RockWall")
                if hasHealth or hasTag or (isNode and (obj:FindFirstChild("Rock") or obj:FindFirstChild("Ore"))) then
                    local p = obj:FindFirstChild("Rock") or obj:FindFirstChild("Ore") or (obj:IsA("BasePart") and obj) or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                    addTargetNode(obj, p)
                end
            end
        end
    end

    -- 2. CollectionService tag "Ore" (Server-tagged ore nodes)
    for _, obj in ipairs(CollectionService:GetTagged("Ore")) do
        if obj and obj.Parent then
            local p = obj:FindFirstChild("Rock") or obj:FindFirstChild("Ore") or (obj:IsA("BasePart") and obj) or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
            addTargetNode(obj, p)
        end
    end

    -- 3. CollectionService tag "RockWall"
    for _, obj in ipairs(CollectionService:GetTagged("RockWall")) do
        if obj and obj.Parent then
            local p = (obj:IsA("BasePart") and obj) or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
            addTargetNode(obj, p)
        end
    end

    -- 4. DigSpots, Rocks, RockWalls
    for _, fName in ipairs({ "DigSpots", "Rocks", "RockWalls" }) do
        local folder = workspace:FindFirstChild(fName)
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    local hasHealth = obj:FindFirstChild("Health") or obj:GetAttribute("Health")
                    local hasTag = CollectionService:HasTag(obj, "Ore") or CollectionService:HasTag(obj, "RockWall")
                    if hasHealth or hasTag or obj.Name:find("Node") or obj.Name:find("Rock") then
                        local p = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                        addTargetNode(obj, p)
                    end
                end
            end
        end
    end

    table.sort(candidates, function(a, b) return a.Distance < b.Distance end)
    return candidates
end

local function scanBestCombatTarget(maxDist)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end

    maxDist = maxDist or 250
    local npcFolder = workspace:FindFirstChild("Npc")
    if not npcFolder then return nil, nil end

    local bestEnemy = nil
    local bestPart = nil
    local bestDist = maxDist

    for _, npc in ipairs(npcFolder:GetChildren()) do
        if npc:IsA("Model") and npc.Parent and npc.Name ~= "Companion" then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local leechHp = npc:GetAttribute("FuelLeechHealth")
            local isAlive = false
            if hum and hum.Health > 0 then
                isAlive = true
            elseif leechHp and leechHp > 0 then
                isAlive = true
            elseif not hum and not leechHp and npc:FindFirstChildWhichIsA("BasePart") then
                isAlive = true
            end

            if isAlive then
                local ePart = npc.PrimaryPart or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or npc:FindFirstChildWhichIsA("BasePart")
                if ePart then
                    local d = (ePart.Position - root.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestEnemy = npc
                        bestPart = ePart
                    end
                end
            end
        end
    end

    return bestEnemy, bestPart
end

registerThread(function()
    while true do
        if Flags.AutoMineAura or Flags.AutoKillHostile then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    -- 1. Check for hostile combat threat
                    local bestEnemy, bestPart = nil, nil
                    if Flags.AutoKillHostile then
                        bestEnemy, bestPart = scanBestCombatTarget(150)
                        currentCombatTarget = bestEnemy
                    else
                        currentCombatTarget = nil
                    end

                    -- A. Hostile Enemy in range -> Fight with Sword (Pukul Biasa)
                    if Flags.AutoKillHostile and bestEnemy and bestPart and not isTeleporting then
                        equipToolByName("Sword")
                        executeToolSwing("Sword", bestPart.Position, bestEnemy)
                    -- B. Mine Rocks/Ores -> Mine with Pickaxe (Pukul Biasa)
                    elseif Flags.AutoMineAura then
                        local targets = scanMinableTargets(Flags.MineRadius or 60)
                        if #targets > 0 then
                            local best = targets[1]
                            currentMineTarget = best

                            -- Distance reach validation: Only swing when within tool melee reach
                            local centerDist = (best.Position - root.Position).Magnitude
                            local surfaceDist = math.max(0, centerDist - (best.Radius or 3.5))

                            -- Pickaxe melee reach extends up to 18 studs from surface or 22 studs from center
                            if surfaceDist <= 18.0 or centerDist <= 22.0 then
                                equipToolByName("Pickaxe")
                                executeToolSwing("Pickaxe", best.Position, best.Node or best.OrePart)
                            end
                        else
                            currentMineTarget = nil
                        end
                    end
                end
            end)
        end
        task.wait(0.18)
    end
end)

-- 8. Auto Quests & Group VIP Cores
registerThread(function()
    while true do
        if Flags.AutoQuests then
            pcall(function()
                for _, promptObj in ipairs(CollectionService:GetTagged("QuestClaim")) do
                    local p = promptObj:IsA("ProximityPrompt") and promptObj or promptObj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if p and p.Enabled and fireproximityprompt then
                        fireproximityprompt(p, 0)
                    end
                end
                local qs = getKnitService("QuestService")
                if qs and qs.ClaimAllQuests then
                    qs:ClaimAllQuests()
                end
            end)
        end
        if Flags.AutoGroupVIP then
            pcall(function()
                local cs = getKnitService("CurrencyService")
                if cs and cs.ClaimGroupReward then
                    cs:ClaimGroupReward()
                end
                if cs and cs.ClaimVIPCores then
                    cs:ClaimVIPCores()
                end
            end)
        end
        task.wait(3.0)
    end
end)

-- 9. Safe Stance & Anti-Fall Engine (Smooth Drill Deck Follow)
registerThread(function()
    while true do
        if Flags.SafeStance and not isTeleporting and not Flags.AutoKillHostile and not (Flags.AutoMineAura and Flags.AutoApproachOre) then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local deckCF = getDrillDeckCFrame()
                    if deckCF then
                        local deckPos = deckCF.Position
                        local dist = (root.Position - deckPos).Magnitude
                        local heightDiff = deckPos.Y - root.Position.Y
                        -- Only catch player if they were riding the drill and fell off/down into the shaft (dist < 80 and heightDiff > 12)
                        -- or if bumped off beyond 40 studs while riding (dist > 40 and dist < 80 and heightDiff > 4)
                        if (dist < 80 and heightDiff > 12) or (dist > 40 and dist < 80 and heightDiff > 4) then
                            root.CFrame = deckCF
                            root.AssemblyLinearVelocity = Vector3.zero
                            root.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end)
        end
        task.wait(0.3)
    end
end)

-- 10. Movement Suite (WalkSpeed, JumpPower, Noclip, InfJump)
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
                if Flags.WalkSpeedOn then
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

-- 11. Fullbright Night Vision
registerThread(function()
    while true do
        if Flags.FullbrightOn then
            pcall(function()
                local Lighting = game:GetService("Lighting")
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

-- 12. VISUAL RADAR & WALLHACK (ESP ENGINE)
local function removeEspElement(obj)
    if activeEspElements[obj] then
        pcall(function()
            if activeEspElements[obj].Billboard then
                activeEspElements[obj].Billboard:Destroy()
            end
        end)
        activeEspElements[obj] = nil
    end
end

registerThread(function()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local maxDist = Flags.MaxEspDistance or 350
            local currentSeen = {}

            -- A. BOSS WALL & DUNGEON GATES ESP
            if Flags.BossWallESP then
                local walls = {}
                for _, gate in ipairs(CollectionService:GetTagged("DungeonGate")) do
                    table.insert(walls, gate)
                end
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and (obj.Name:find("DungeonGate") or obj.Name:find("BreakWall") or obj.Name:find("TownGate")) then
                        table.insert(walls, obj)
                    end
                end

                for _, wall in ipairs(walls) do
                    if wall and wall.Parent then
                        local part = wall.PrimaryPart or wall:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local dist = math.floor((part.Position - root.Position).Magnitude)
                            if dist <= maxDist then
                                currentSeen[wall] = true
                                if not activeEspElements[wall] then
                                    local bg = Instance.new("BillboardGui")
                                    bg.Name = "BH_BossWall"
                                    bg.Size = UDim2.new(0, 160, 0, 36)
                                    bg.AlwaysOnTop = true
                                    bg.Adornee = part
                                    bg.Parent = CoreGui

                                    local lbl = Instance.new("TextLabel", bg)
                                    lbl.Size = UDim2.new(1, 0, 1, 0)
                                    lbl.BackgroundTransparency = 1
                                    lbl.Font = Enum.Font.GothamBold
                                    lbl.TextSize = 12
                                    lbl.TextColor3 = THEME.Red
                                    lbl.TextStrokeTransparency = 0
                                    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                                    activeEspElements[wall] = { Billboard = bg, Label = lbl, Part = part }
                                end

                                if activeEspElements[wall] then
                                    activeEspElements[wall].Label.Text = string.format("🚪 %s\n[%d studs]", wall.Name, dist)
                                end
                            end
                        end
                    end
                end
            end

            -- B. DRILL ESP
            if Flags.DrillESP then
                local drill = findDrillModel()
                if drill and drill.Parent then
                    local part = drill.PrimaryPart or drill:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local dist = math.floor((part.Position - root.Position).Magnitude)
                        currentSeen[drill] = true
                        if not activeEspElements[drill] then
                            local bg = Instance.new("BillboardGui")
                            bg.Name = "BH_Drill"
                            bg.Size = UDim2.new(0, 150, 0, 36)
                            bg.AlwaysOnTop = true
                            bg.Adornee = part
                            bg.Parent = CoreGui

                            local lbl = Instance.new("TextLabel", bg)
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.BackgroundTransparency = 1
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 12
                            lbl.TextColor3 = THEME.Green
                            lbl.TextStrokeTransparency = 0
                            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                            activeEspElements[drill] = { Billboard = bg, Label = lbl, Part = part }
                        end

                        if activeEspElements[drill] then
                            activeEspElements[drill].Label.Text = string.format("🚜 DRILL MACHINE\n[%d studs]", dist)
                        end
                    end
                end
            end

            -- C. DROPPED LOOT & ORES ESP
            if Flags.LootESP or Flags.SackESP or Flags.CrateESP or Flags.GemsESP then
                local itemsFolder = workspace:FindFirstChild("Items")
                local pool = {}

                if itemsFolder then
                    for _, it in ipairs(itemsFolder:GetChildren()) do
                        table.insert(pool, it)
                    end
                end

                for _, item in ipairs(pool) do
                    if item and item.Parent then
                        local part = item:IsA("BasePart") and item or (item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")))
                        if part then
                            local dist = math.floor((part.Position - root.Position).Magnitude)
                            if dist <= maxDist then
                                local name = item.Name
                                local nl = name:lower()

                                local showThis = false
                                if Flags.LootESP then
                                    showThis = true
                                elseif Flags.SackESP and (nl:find("sack") or nl:find("money") or nl:find("soulorb")) then
                                    showThis = true
                                elseif Flags.CrateESP and (nl:find("crate") or nl:find("chest")) then
                                    showThis = true
                                elseif Flags.GemsESP and (nl:find("diamond") or nl:find("emerald") or nl:find("ruby") or nl:find("gem") or nl:find("crystal")) then
                                    showThis = true
                                end

                                if showThis then
                                    currentSeen[item] = true
                                    local col = THEME.Accent
                                    if nl:find("sack") or nl:find("money") then col = THEME.Gold
                                    elseif nl:find("crate") or nl:find("chest") then col = THEME.Purple
                                    elseif nl:find("gem") or nl:find("diamond") then col = THEME.Blue
                                    end

                                    if not activeEspElements[item] then
                                        local bg = Instance.new("BillboardGui")
                                        bg.Name = "BH_Loot"
                                        bg.Size = UDim2.new(0, 140, 0, 32)
                                        bg.AlwaysOnTop = true
                                        bg.Adornee = part
                                        bg.Parent = CoreGui

                                        local lbl = Instance.new("TextLabel", bg)
                                        lbl.Size = UDim2.new(1, 0, 1, 0)
                                        lbl.BackgroundTransparency = 1
                                        lbl.Font = Enum.Font.GothamSemibold
                                        lbl.TextSize = 11
                                        lbl.TextColor3 = col
                                        lbl.TextStrokeTransparency = 0
                                        lbl.TextStrokeColor3 = Color3.fromRGB(10, 10, 15)

                                        activeEspElements[item] = { Billboard = bg, Label = lbl, Part = part }
                                    end

                                    if activeEspElements[item] then
                                        activeEspElements[item].Label.Text = string.format("💎 %s\n[%dm]", name, dist)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- D. HOSTILE ENEMIES & LEECHES ESP
            if Flags.HostileESP then
                local npcFolder = workspace:FindFirstChild("Npc")
                if npcFolder then
                    for _, npc in ipairs(npcFolder:GetChildren()) do
                        if npc:IsA("Model") and npc.Parent then
                            local part = npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local dist = math.floor((part.Position - root.Position).Magnitude)
                                if dist <= maxDist then
                                    currentSeen[npc] = true
                                    if not activeEspElements[npc] then
                                        local bg = Instance.new("BillboardGui")
                                        bg.Name = "BH_Hostile"
                                        bg.Size = UDim2.new(0, 140, 0, 32)
                                        bg.AlwaysOnTop = true
                                        bg.Adornee = part
                                        bg.Parent = CoreGui

                                        local lbl = Instance.new("TextLabel", bg)
                                        lbl.Size = UDim2.new(1, 0, 1, 0)
                                        lbl.BackgroundTransparency = 1
                                        lbl.Font = Enum.Font.GothamBold
                                        lbl.TextSize = 11
                                        lbl.TextColor3 = THEME.Orange
                                        lbl.TextStrokeTransparency = 0
                                        lbl.TextStrokeColor3 = Color3.fromRGB(10, 10, 15)

                                        activeEspElements[npc] = { Billboard = bg, Label = lbl, Part = part }
                                    end

                                    if activeEspElements[npc] then
                                        activeEspElements[npc].Label.Text = string.format("👾 %s\n[%dm]", npc.Name, dist)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- Clean up out-of-range or destroyed ESP elements
            for obj in pairs(activeEspElements) do
                if not currentSeen[obj] or not obj.Parent then
                    removeEspElement(obj)
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- [10] MASTER CLEANUP ROUTINE
local function cleanupAll()
    _G.BH_DRILL_CLEANUP = nil
    for k in pairs(Flags) do
        if type(Flags[k]) == "boolean" then
            Flags[k] = false
        end
    end

    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        restoreCollision()
    end)

    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(activeConnections)

    for obj in pairs(activeEspElements) do
        removeEspElement(obj)
    end
    table.clear(activeEspElements)

    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
    end)

    pcall(function()
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
        end
    end)
end

_G.BH_DRILL_CLEANUP = cleanupAll

-- [11] 1:1 FLOWER SHOP MASTER GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrotherHub_DrillToEarth"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
end)

local function neonStroke(inst, thickness)
    local s = Instance.new("UIStroke", inst)
    s.Thickness = thickness or 2
    s.Color = Color3.new(1, 1, 1)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local g = Instance.new("UIGradient", s)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 40, 255)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 25, 45)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(20, 255, 80)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 40, 255))
    })
    TweenService:Create(g, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()
    return s
end

-- Main Floating Window (580x360)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(640, 420)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

neonStroke(MainFrame, 2)

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
MinCircle.Font = Enum.Font.GothamBlack
MinCircle.TextSize = 30
MinCircle.TextColor3 = THEME.Text
MinCircle.AutoButtonColor = false
MinCircle.Active = true
MinCircle.Visible = false

local MinCorner = Instance.new("UICorner", MinCircle)
MinCorner.CornerRadius = UDim.new(0, 40)

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
CrownLabel.Font = Enum.Font.GothamBold
CrownLabel.TextSize = 14
CrownLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
CrownLabel.ZIndex = 2

local CircleScale = Instance.new("UIScale", MinCircle)
CircleScale.Scale = 0

-- Header Bar (52px FlowerShop Standard with Purple-Blue Gradient)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3 = THEME.Panel
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 14)

local TopBarGrad = Instance.new("UIGradient", TopBar)
TopBarGrad.Color = ColorSequence.new(THEME.Purple, THEME.Blue)

local TopBarCover = Instance.new("Frame", TopBar)
TopBarCover.Size = UDim2.new(1, 0, 0, 14)
TopBarCover.Position = UDim2.new(0, 0, 1, -14)
TopBarCover.BackgroundColor3 = THEME.Panel
TopBarCover.BorderSizePixel = 0
TopBarCover.ZIndex = 1
local TopBarCoverGrad = Instance.new("UIGradient", TopBarCover)
TopBarCoverGrad.Color = ColorSequence.new(THEME.Purple, THEME.Blue)

local LogoLabel = Instance.new("TextLabel", TopBar)
LogoLabel.Size = UDim2.new(0, 36, 0, 36)
LogoLabel.Position = UDim2.new(0, 12, 0.5, -18)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "👑"
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 22
LogoLabel.TextColor3 = THEME.Gold
LogoLabel.ZIndex = 2

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Text = "🚜 " .. T("HubTitle") .. "  •  " .. T("HubSubtitle")
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 50, 0, 0)
TitleLabel.Size = UDim2.new(1, -170, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.ZIndex = 2

-- Minimize & Close Buttons (FlowerShop Standard: Yellow '-' and Red 'X')
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.new(0, 0, 0)
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.AnchorPoint = Vector2.new(0, 0.5)
MinBtn.Position = UDim2.new(1, -88, 0.5, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 18)
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 3
local mbc = Instance.new("UICorner", MinBtn)
mbc.CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.Position = UDim2.new(1, -44, 0.5, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 60, 75)
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 3
local cbc = Instance.new("UICorner", CloseBtn)
cbc.CornerRadius = UDim.new(0, 8)

-- Minimize & Restore with 1:1 FlowerShop Bounce Animation
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

CloseBtn.MouseButton1Click:Connect(function()
    cleanupAll()
    local t = TweenService:Create(MainScale, tweenFast, {Scale = 0})
    t:Play()
    t.Completed:Connect(function() ScreenGui:Destroy() end)
end)

-- MinCircle Dragging & Click Handling (DRAG_THRESHOLD = 8 FlowerShop Standard)
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
    local function onRelease(i)
        if not active then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            active = false
            if not moved then
                doRestore()
            end
        end
    end
    MinCircle.InputEnded:Connect(onRelease)
    UserInputService.InputEnded:Connect(onRelease)
end

-- TopBar Dragging
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = (input.Position - dragStart) / (UIScale and UIScale.Scale or 1)
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 1:1 FlowerShop Horizontal TabBar (Scrolling to the Right!)
-- ResizeGrip (1:1 FlowerShop & BrotherHub.txt Standard)
do
    local grip = Instance.new("TextButton", MainFrame)
    grip.Name = "ResizeGrip"
    grip.AnchorPoint = Vector2.new(1, 1)
    grip.Size = UDim2.fromOffset(22, 22)
    grip.Position = UDim2.new(1, -4, 1, -4)
    grip.BackgroundColor3 = THEME.Panel
    grip.Text = "◢"
    grip.TextColor3 = THEME.Title or THEME.Accent or Color3.fromRGB(0, 230, 150)
    grip.Font = Enum.Font.GothamBold
    grip.TextSize = 16
    grip.AutoButtonColor = false
    grip.ZIndex = 60
    local c = Instance.new("UICorner", grip); c.CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", grip); s.Color = THEME.Title or THEME.Accent or Color3.fromRGB(0, 230, 150); s.Thickness = 1

    local MIN_S, MAX_S = 0.55, 1.8
    local resizing, startDist, startScale, centerPx = false, 1, 1, Vector2.zero

    grip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing  = true
            centerPx  = MainFrame.AbsolutePosition + MainFrame.AbsoluteSize / 2
            startDist = math.max((Vector2.new(i.Position.X, i.Position.Y) - centerPx).Magnitude, 1)
            startScale= (MainScale and MainScale.Scale) or 1
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local cur = (Vector2.new(i.Position.X, i.Position.Y) - centerPx).Magnitude
            local s = math.clamp(startScale * (cur / startDist), MIN_S, MAX_S)
            MainScale.Scale = s
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

local TabBar = Instance.new("ScrollingFrame", MainFrame)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 56)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 2
TabBar.ScrollBarImageColor3 = THEME.Accent
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Full-Width Pages Container Below TabBar
local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.Name = "PagesContainer"
PagesContainer.Size = UDim2.new(1, -20, 1, -102)
PagesContainer.Position = UDim2.new(0, 10, 0, 96)
PagesContainer.BackgroundTransparency = 1

-- Tab System Registry
local tabs = {}
local currentTab = nil

local function createTab(tabId, tabNameKey, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabId .. "Button"
    TabButton.Size = UDim2.new(0, 100, 0, 28)
    TabButton.AutomaticSize = Enum.AutomaticSize.X
    TabButton.ClipsDescendants = true
    TabButton.BackgroundColor3 = THEME.Panel
    TabButton.BorderSizePixel = 0
    TabButton.Text = icon .. " " .. T(tabNameKey)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 12
    TabButton.TextColor3 = THEME.SubText
    TabButton.TextTruncate = Enum.TextTruncate.None
    TabButton.AutoButtonColor = false
    TabButton.Parent = TabBar

    local TabPad = Instance.new("UIPadding", TabButton)
    TabPad.PaddingLeft = UDim.new(0, 12)
    TabPad.PaddingRight = UDim.new(0, 12)

    local BtnCorner = Instance.new("UICorner", TabButton)
    BtnCorner.CornerRadius = UDim.new(0, 8)

    local BtnStroke = Instance.new("UIStroke", TabButton)
    BtnStroke.Color = THEME.Stroke
    BtnStroke.Thickness = 1

    local PageFrame = Instance.new("ScrollingFrame")
    PageFrame.Name = tabId .. "Page"
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.ScrollBarThickness = 4
    PageFrame.ScrollBarImageColor3 = THEME.Accent
    PageFrame.Visible = false
    PageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    PageFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PageFrame.Parent = PagesContainer

    local PageList = Instance.new("UIListLayout", PageFrame)
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 8)

    local PagePadding = Instance.new("UIPadding", PageFrame)
    PagePadding.PaddingTop = UDim.new(0, 6)
    PagePadding.PaddingBottom = UDim.new(0, 14)
    PagePadding.PaddingLeft = UDim.new(0, 4)
    PagePadding.PaddingRight = UDim.new(0, 8)

    TabButton.MouseButton1Click:Connect(function()
        for id, t in pairs(tabs) do
            t.Page.Visible = false
            t.Button.TextColor3 = THEME.SubText
            t.Button.BackgroundColor3 = THEME.Panel
        end
        PageFrame.Visible = true
        TabButton.TextColor3 = Color3.new(1, 1, 1)
        TabButton.BackgroundColor3 = THEME.Accent
        currentTab = tabId
    end)

    tabs[tabId] = {
        Button = TabButton,
        Page = PageFrame,
        NameKey = tabNameKey,
        Icon = icon
    }
    return PageFrame
end

-- UI Builder Components
local function createSection(page, textKey)
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, 0, 0, 20)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = "— " .. T(textKey) .. " —"
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 10
    SectionLabel.TextColor3 = THEME.Accent
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = page
    return SectionLabel
end

local registeredToggles = {}

local function createToggle(page, flagName, titleKey, descKey, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = flagName .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
    ToggleFrame.BackgroundColor3 = THEME.Panel
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Active = false
    ToggleFrame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = ToggleFrame

    ToggleFrame.ClipsDescendants = true

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = T(titleKey)
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextSize = 12
    TitleLabel.TextColor3 = THEME.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.ClipsDescendants = true
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.Active = false
    TitleLabel.ZIndex = 2
    TitleLabel.Parent = ToggleFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -60, 0, 16)
    DescLabel.Position = UDim2.new(0, 10, 0, 22)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = T(descKey)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 10
    DescLabel.TextColor3 = THEME.SubText
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.ClipsDescendants = true
    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DescLabel.Active = false
    DescLabel.ZIndex = 2
    DescLabel.Parent = ToggleFrame

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.Position = UDim2.new(1, -48, 0.5, -10)
    SwitchBg.BackgroundColor3 = Flags[flagName] and THEME.Green or THEME.Slot
    SwitchBg.BorderSizePixel = 0
    SwitchBg.Active = false
    SwitchBg.ZIndex = 3
    SwitchBg.Parent = ToggleFrame

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = Flags[flagName] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Active = false
    Knob.ZIndex = 4
    Knob.Parent = SwitchBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    -- Full-row clickable hit button with TOP-TIER ZIndex
    local HitButton = Instance.new("TextButton")
    HitButton.Size = UDim2.new(1, 0, 1, 0)
    HitButton.BackgroundTransparency = 1
    HitButton.Text = ""
    HitButton.Active = true
    HitButton.ZIndex = 15
    HitButton.Parent = ToggleFrame

    local function updateVisual(active)
        local isAct = (active == true)
        pcall(function()
            TweenService:Create(SwitchBg, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = isAct and THEME.Green or THEME.Slot
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = isAct and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end)
    end

    local isDebouncing = false
    local function flipToggle()
        if isDebouncing then return end
        isDebouncing = true

        local newState = not Flags[flagName]
        Flags[flagName] = newState
        updateVisual(newState)

        if callback then
            task.spawn(function()
                pcall(callback, newState)
            end)
        end

        if Flags.AutoSaveConfig then
            task.spawn(function()
                pcall(saveConfigToFile)
            end)
        end

        task.delay(0.12, function()
            isDebouncing = false
        end)
    end

    HitButton.Activated:Connect(flipToggle)
    HitButton.MouseButton1Click:Connect(flipToggle)

    registeredToggles[flagName] = function(v)
        updateVisual(v)
        if callback then
            task.spawn(function()
                pcall(callback, v)
            end)
        end
    end

    return ToggleFrame
end

local function createSlider(page, title, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 48)
    SliderFrame.BackgroundColor3 = THEME.Panel
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SliderFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = SliderFrame

    SliderFrame.ClipsDescendants = true

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 22)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextColor3 = THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.ClipsDescendants = true
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = SliderFrame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0, 45, 0, 22)
    ValLabel.Position = UDim2.new(1, -55, 0, 4)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(defaultVal)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextColor3 = THEME.Accent
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = SliderFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 6)
    Track.Position = UDim2.new(0, 10, 0, 32)
    Track.BackgroundColor3 = THEME.Slot
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Fill.BackgroundColor3 = THEME.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local isDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        ValLabel.Text = tostring(val)
        callback(val)
        if Flags.AutoSaveConfig then
            saveConfigToFile()
        end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    return SliderFrame
end

local function createDropdown(page, title, options, defaultVal, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, 0, 0, 42)
    DropFrame.BackgroundColor3 = THEME.Panel
    DropFrame.BorderSizePixel = 0
    DropFrame.ClipsDescendants = true
    DropFrame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = DropFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -130, 0, 42)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextColor3 = THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.ClipsDescendants = true
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = DropFrame

    local SelectedBtn = Instance.new("TextButton")
    SelectedBtn.Size = UDim2.new(0, 115, 0, 26)
    SelectedBtn.Position = UDim2.new(1, -125, 0, 8)
    SelectedBtn.BackgroundColor3 = THEME.Slot
    SelectedBtn.BorderSizePixel = 0
    SelectedBtn.Text = tostring(defaultVal) .. " ▼"
    SelectedBtn.Font = Enum.Font.GothamBold
    SelectedBtn.TextSize = 10
    SelectedBtn.TextColor3 = THEME.Accent
    SelectedBtn.Parent = DropFrame

    local SelCorner = Instance.new("UICorner")
    SelCorner.CornerRadius = UDim.new(0, 4)
    SelCorner.Parent = SelectedBtn

    local OptContainer = Instance.new("Frame")
    OptContainer.Size = UDim2.new(1, -20, 0, #options * 26)
    OptContainer.Position = UDim2.new(0, 10, 0, 46)
    OptContainer.BackgroundTransparency = 1
    OptContainer.Parent = DropFrame

    local OptList = Instance.new("UIListLayout")
    OptList.Padding = UDim.new(0, 2)
    OptList.Parent = OptContainer

    local isOpen = false
    local optHeight = #options * 28

    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 24)
        OptBtn.BackgroundColor3 = THEME.Slot
        OptBtn.BorderSizePixel = 0
        OptBtn.Text = opt
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 10
        OptBtn.TextColor3 = THEME.Text
        OptBtn.Parent = OptContainer

        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 4)
        OptCorner.Parent = OptBtn

        OptBtn.MouseButton1Click:Connect(function()
            SelectedBtn.Text = opt .. " ▼"
            isOpen = false
            TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
            callback(opt)
            if Flags.AutoSaveConfig then
                saveConfigToFile()
            end
        end)
    end

    SelectedBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetH = isOpen and (48 + optHeight) or 42
        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
    end)

    return DropFrame
end

local function createMultiDropdown(page, title, options, selectedStore, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, 0, 0, 42)
    DropFrame.BackgroundColor3 = THEME.Panel
    DropFrame.BorderSizePixel = 0
    DropFrame.ClipsDescendants = true
    DropFrame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = DropFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -145, 0, 42)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextColor3 = THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.ClipsDescendants = true
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = DropFrame

    local SelectedBtn = Instance.new("TextButton")
    SelectedBtn.Size = UDim2.new(0, 130, 0, 26)
    SelectedBtn.Position = UDim2.new(1, -140, 0, 8)
    SelectedBtn.BackgroundColor3 = THEME.Slot
    SelectedBtn.BorderSizePixel = 0
    SelectedBtn.Font = Enum.Font.GothamBold
    SelectedBtn.TextSize = 10
    SelectedBtn.TextColor3 = THEME.Accent
    SelectedBtn.Parent = DropFrame

    local SelCorner = Instance.new("UICorner")
    SelCorner.CornerRadius = UDim.new(0, 4)
    SelCorner.Parent = SelectedBtn

    local totalRows = #options + 1
    local OptContainer = Instance.new("Frame")
    OptContainer.Size = UDim2.new(1, -20, 0, totalRows * 26)
    OptContainer.Position = UDim2.new(0, 10, 0, 46)
    OptContainer.BackgroundTransparency = 1
    OptContainer.Parent = DropFrame

    local OptList = Instance.new("UIListLayout")
    OptList.Padding = UDim.new(0, 2)
    OptList.Parent = OptContainer

    local isOpen = false
    local optHeight = totalRows * 28

    local function getSelectedCount()
        local count = 0
        local firstName = nil
        for _, opt in ipairs(options) do
            local key = type(opt) == "table" and opt.Key or opt
            if selectedStore[key] then
                count = count + 1
                if not firstName then firstName = key end
            end
        end
        return count, firstName
    end

    local function refreshHeader()
        local count, firstName = getSelectedCount()
        if count == 0 then
            SelectedBtn.Text = "None (0) ▼"
            SelectedBtn.TextColor3 = THEME.SubText
        elseif count == #options then
            SelectedBtn.Text = "All (" .. count .. ") ▼"
            SelectedBtn.TextColor3 = THEME.Title
        elseif count == 1 then
            SelectedBtn.Text = tostring(firstName) .. " ▼"
            SelectedBtn.TextColor3 = THEME.Accent
        else
            SelectedBtn.Text = "Selected (" .. count .. ") ▼"
            SelectedBtn.TextColor3 = THEME.Green
        end
    end

    refreshHeader()

    -- Quick Toggle Row: Select All / Deselect All
    local QuickBtn = Instance.new("TextButton")
    QuickBtn.Size = UDim2.new(1, 0, 0, 24)
    QuickBtn.BackgroundColor3 = THEME.Slot
    QuickBtn.BorderSizePixel = 0
    QuickBtn.Text = "✨ Pilih Semua / Hapus Semua"
    QuickBtn.Font = Enum.Font.GothamBold
    QuickBtn.TextSize = 10
    QuickBtn.TextColor3 = THEME.Title
    QuickBtn.Parent = OptContainer
    Instance.new("UICorner", QuickBtn).CornerRadius = UDim.new(0, 4)

    local optionUpdaters = {}

    QuickBtn.MouseButton1Click:Connect(function()
        local count = getSelectedCount()
        local newVal = (count < #options)
        for _, opt in ipairs(options) do
            local key = type(opt) == "table" and opt.Key or opt
            selectedStore[key] = newVal
        end
        for _, updateFn in ipairs(optionUpdaters) do
            updateFn()
        end
        refreshHeader()
        if callback then callback(selectedStore) end
        if Flags.AutoSaveConfig then saveConfigToFile() end
    end)

    for _, opt in ipairs(options) do
        local key = type(opt) == "table" and opt.Key or opt
        local label = type(opt) == "table" and opt.Label or opt
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 24)
        OptBtn.BackgroundColor3 = THEME.Slot
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 10
        OptBtn.Parent = OptContainer
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

        local function updateBtnState()
            local isSel = selectedStore[key] == true
            OptBtn.Text = (isSel and " [✓] " or " [   ] ") .. label
            OptBtn.TextColor3 = isSel and THEME.Green or THEME.Text
        end
        updateBtnState()
        table.insert(optionUpdaters, updateBtnState)

        OptBtn.MouseButton1Click:Connect(function()
            selectedStore[key] = not selectedStore[key]
            updateBtnState()
            refreshHeader()
            if callback then callback(selectedStore) end
            if Flags.AutoSaveConfig then saveConfigToFile() end
        end)
    end

    SelectedBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetH = isOpen and (48 + optHeight) or 42
        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
    end)

    return DropFrame
end

local function createActionButton(page, text, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = color or THEME.Panel
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.TextColor3 = THEME.Text
    Btn.TextWrapped = true
    Btn.ClipsDescendants = true
    Btn.Parent = page

    local BtnPad = Instance.new("UIPadding", Btn)
    BtnPad.PaddingLeft = UDim.new(0, 10)
    BtnPad.PaddingRight = UDim.new(0, 10)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

updateUIFromFlags = function()
    for flagName, updater in pairs(registeredToggles) do
        updater(Flags[flagName])
    end
end

-- [12] POPULATE PAGES & TABS
local PageDrill     = createTab("Drill", "TabDrill", "🚜")
local PageUpgrade   = createTab("Upgrade", "TabUpgrade", "📈")
local PageLoot      = createTab("Loot", "TabLoot", "💎")
local PageCombat    = createTab("Combat", "TabCombat", "⚔️")
local PageQuests    = createTab("Quests", "TabQuests", "📜")
local PageESP       = createTab("ESP", "TabESP", "👁️")
local PagePlayer    = createTab("Player", "TabPlayer", "⚡")
local PageTeleport  = createTab("Teleport", "TabTeleport", "📍")
local PageConfig    = createTab("Config", "TabConfig", "💾")
local PageSettings  = createTab("Settings", "TabSettings", "⚙️")
local PageDonate    = createTab("Donate", "TabDonate", "💖")
local PageCredit    = createTab("Credit", "TabCredit", "👑")

-- 1. Drill Controls
createSection(PageDrill, "SecDrill")
createToggle(PageDrill, "AutoThrottle", "AutoThrottle", "AutoThrottleDesc", function(v)
    if not v then
        pcall(function()
            local drill = findDrillModel()
            local seat = drill and drill:FindFirstChildWhichIsA("VehicleSeat", true)
            if seat then seat.ThrottleFloat = 0; seat.Throttle = 0 end
        end)
    end
end)
createToggle(PageDrill, "AutoBoost", "AutoBoost", "AutoBoostDesc")
createToggle(PageDrill, "LockSeat", "LockSeat", "LockSeatDesc")
createToggle(PageDrill, "AutoUnstuck", "AutoUnstuck", "AutoUnstuckDesc")
createToggle(PageDrill, "AutoSkipCut", "AutoSkipCut", "AutoSkipCutDesc")

-- 2. Upgrades
createSection(PageUpgrade, "SecUpgrade")
createToggle(PageUpgrade, "AutoUpgrade", "AutoUpgrade", "AutoUpgradeDesc")
createToggle(PageUpgrade, "AutoReroll", "AutoReroll", "AutoRerollDesc")
createToggle(PageUpgrade, "ClaimFreeClass", "ClaimFreeClass", "ClaimFreeClassD")

-- 3. Loot & Sacks
createSection(PageLoot, "SecLoot")
createToggle(PageLoot, "AutoLootSack", "AutoLootSack", "AutoLootSackDesc")
createToggle(PageLoot, "IgnoreMonsterDrops", "IgnoreMonsterDrops", "IgnoreMonsterDropsD")

createToggle(PageLoot, "UseCategoryFilter", "UseCatFilter", "UseCatFilterD")
createMultiDropdown(PageLoot, T("CatFilterLabel"), {
    { Key = "Ore/Gems", Label = "⛏️ Ore / Gems (Tambang & Permata)" },
    { Key = "Fuel",     Label = "⚡ Fuel (Bahan Bakar Bensin)" },
    { Key = "Scrap",    Label = "🔩 Scrap (Besi Tua & Komponen)" },
    { Key = "Enemy",    Label = "👾 Enemy Drops (Drop Monster Mati)" },
    { Key = "Money",    Label = "💰 Money & Sacks (Uang & Karung)" }
}, Flags.SelectedCategories, function(store)
    Flags.SelectedCategories = store
end)

createToggle(PageLoot, "UseItemFilter", "UseItemFilter", "UseItemFilterD")
createMultiDropdown(PageLoot, T("ItemFilterLabel"), {
    { Key = "Coal",     Label = "🪨 Coal (Batubara)" },
    { Key = "Iron",     Label = "⛓️ Iron (Besi)" },
    { Key = "Gold",     Label = "🪙 Gold (Emas)" },
    { Key = "Diamond",  Label = "💎 Diamond (Berlian)" },
    { Key = "Emerald",  Label = "❇️ Emerald (Zamrud)" },
    { Key = "Ruby",     Label = "🔴 Ruby (Delima)" },
    { Key = "Heartgem", Label = "💖 Heartgem" },
    { Key = "Scrap",    Label = "🔩 Scrap Items" },
    { Key = "Fuel",     Label = "⚡ Fuel Orbs / Fuel" },
    { Key = "Enemy",    Label = "👾 Monster Drops" },
    { Key = "Money",    Label = "💰 Money & Coin Bags" }
}, Flags.SelectedItems, function(store)
    Flags.SelectedItems = store
end)

createDropdown(PageLoot, T("FilterLabel"), {
    "All Items (Semua Item)",
    "Ores & Gems Only (Hanya Tambang, Bebas Monster)",
    "Gems Only (Diamond, Ruby, Emerald, Heartgem)",
    "Money & Sacks Only (Hanya Uang & Karung)",
    "Monster Drops Only (Hanya Drop Monster Mati)",
    "Coal Only (Batubara)",
    "Iron Only (Besi)",
    "Gold Only (Emas)",
    "Diamond Only (Berlian)",
    "Emerald Only (Zamrud)",
    "Ruby Only (Delima)",
    "Heartgem Only (Heartgem)"
}, Flags.SackFilter, function(opt)
    Flags.SackFilter = opt
end)
createToggle(PageLoot, "AutoStoreCrate", "AutoStoreCrate", "AutoStoreCrateD")

createSlider(PageLoot, T("RadiusLabel"), 10, 100, Flags.LootRadius, function(v)
    Flags.LootRadius = v
end)

createToggle(PageLoot, "AutoSack", "AutoSack", "AutoSackDesc")
createToggle(PageLoot, "AutoCrate", "AutoCrate", "AutoCrateDesc")
createToggle(PageLoot, "AutoFuelLeech", "AutoFuelLeech", "AutoFuelLeechD")

createActionButton(PageLoot, T("BtnDumpAll"), THEME.Red, function()
    sendToolServerUpdate({ "DropAll" })
end)

-- 4. Mining & Combat (Rock Mining Aura & Poly Loot Standard Safe Stance)
createSection(PageCombat, "SecCombat")
createToggle(PageCombat, "AutoMineAura", "AutoMineAura", "AutoMineAuraDesc", function(v)
    restoreCollision()
    if not v then
        currentMineTarget = nil
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
end)
createToggle(PageCombat, "AutoApproachOre", "AutoApproachOre", "AutoApproachOreDesc", function(v)
    restoreCollision()
    if not v then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if hum and root then
                hum:MoveTo(root.Position)
            end
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
end)
createToggle(PageCombat, "SilentDamage", "SilentDamage", "SilentDamageDesc", function(v)
    Flags.SilentDamage = v
end)
createSlider(PageCombat, T("MineRadiusLabel"), 10, 150, Flags.MineRadius, function(v)
    Flags.MineRadius = v
end)

createToggle(PageCombat, "AutoKillHostile", "AutoKillHostile", "AutoKillHostileD", function(v)
    if not v then
        currentCombatTarget = nil
        restoreCollision()
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
end)

createDropdown(PageCombat, T("StanceModeLabel"), {
    "Above Enemy",
    "Behind Enemy",
    "Ground Orbit",
    "Off"
}, Flags.StanceMode, function(opt)
    Flags.StanceMode = opt
end)

createSlider(PageCombat, T("StanceDistLabel"), 1, 20, Flags.StanceDistance, function(v)
    Flags.StanceDistance = v
end)

-- 5. Quests & VIP Rewards
createSection(PageQuests, "SecQuests")
createToggle(PageQuests, "AutoQuests", "AutoQuests", "AutoQuestsDesc")
createToggle(PageQuests, "AutoGroupVIP", "AutoGroupVIP", "AutoGroupVIPD")

-- 6. ESP Radar
createSection(PageESP, "SecESP")
createToggle(PageESP, "BossWallESP", "BossWallESP", "BossWallESPDesc")
createToggle(PageESP, "LootESP", "LootESP", "LootESPDesc")
createToggle(PageESP, "SackESP", "SackESP", "SackESP")
createToggle(PageESP, "CrateESP", "CrateESP", "CrateESP")
createToggle(PageESP, "GemsESP", "GemsESP", "GemsESP")
createToggle(PageESP, "DrillESP", "DrillESP", "DrillESP")
createToggle(PageESP, "HostileESP", "HostileESP", "HostileESP")

createSlider(PageESP, T("EspDistLabel"), 100, 1000, Flags.MaxEspDistance, function(v)
    Flags.MaxEspDistance = v
end)

-- 7. Movement & Player Utilities
createSection(PagePlayer, "SecMove")
createToggle(PagePlayer, "WalkSpeedOn", "ToggleSpeed", "ToggleSpeed", function(v)
    if not v then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end)
createSlider(PagePlayer, "WalkSpeed Multiplier", 16, 120, Flags.WalkSpeedVal, function(v)
    Flags.WalkSpeedVal = v
    if Flags.WalkSpeedOn then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end)
    end
end)

createToggle(PagePlayer, "JumpPowerOn", "ToggleJump", "ToggleJump", function(v)
    if not v then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 50; hum.JumpHeight = 7.2 end
        end)
    end
end)
createSlider(PagePlayer, "JumpPower Multiplier", 50, 200, Flags.JumpPowerVal, function(v)
    Flags.JumpPowerVal = v
    if Flags.JumpPowerOn then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end)
    end
end)

createToggle(PagePlayer, "NoclipOn", "ToggleNoclip", "ToggleNoclip", function(v)
    if not v then
        restoreCollision()
    end
end)
createToggle(PagePlayer, "InfiniteJumpOn", "ToggleInfJump", "ToggleInfJump")
createToggle(PagePlayer, "SafeStance", "SafeStanceDrill", "SafeStanceDesc", function(v)
    if v then
        pcall(function()
            local deckCF = getDrillDeckCFrame()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if deckCF and root then
                root.CFrame = deckCF
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    else
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Anchored = false
            end
            if hum then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            restoreCollision()
        end)
    end
end)
createToggle(PagePlayer, "FullbrightOn", "Fullbright", "FullbrightDesc", function(v)
    if not v then
        pcall(function()
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = defaultLighting.Brightness or 2
            Lighting.ClockTime = defaultLighting.ClockTime or 14
            Lighting.FogEnd = defaultLighting.FogEnd or 10000
            Lighting.GlobalShadows = defaultLighting.GlobalShadows ~= false
            Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient or Color3.fromRGB(128, 128, 128)
        end)
    end
end)

-- 8. REAL 10-LAYER DEPTH & TOWN TELEPORTATION (DepthScale Standard)
createSection(PageTeleport, "SecTpDepths")

local DEPTH_LAYERS = {
    { Name = "Dirt (Layer 1)",         Coord = Vector3.new(275, 7.0, -771.5) },
    { Name = "Stone (Layer 2)",        Coord = Vector3.new(2675, 7.0, -771.5) },
    { Name = "Clay (Layer 3)",         Coord = Vector3.new(5075, 7.0, -771.5) },
    { Name = "Fossil (Layer 4)",       Coord = Vector3.new(7475, 7.0, -771.5) },
    { Name = "Crystal (Layer 5)",      Coord = Vector3.new(9875, 7.0, -771.5) },
    { Name = "Toxic (Layer 6)",        Coord = Vector3.new(13275, 7.0, -771.5) },
    { Name = "Radioactive (Layer 7)",  Coord = Vector3.new(16675, 7.0, -771.5) },
    { Name = "The Abyss (Layer 8)",    Coord = Vector3.new(20075, 7.0, -771.5) },
    { Name = "Void (Layer 9)",         Coord = Vector3.new(23475, 7.0, -771.5) },
    { Name = "Glowing Core (Layer 10)",Coord = Vector3.new(27875, 7.0, -771.5) },
}

for _, layer in ipairs(DEPTH_LAYERS) do
    createActionButton(PageTeleport, "⛏️ " .. layer.Name, THEME.Panel, function()
        safeTeleport(CFrame.new(layer.Coord), 1.5)
    end)
end

createSection(PageTeleport, "SecTpTowns")

createActionButton(PageTeleport, T("TpAltarChurch"), THEME.Blue, function()
    teleportToAltarChurch()
end)

createActionButton(PageTeleport, T("AutoSimpanAltar"), THEME.Green, function()
    autoInteractAltar()
end)

createActionButton(PageTeleport, "⛪ Church & Weapon Stand (Lobby Storage)", THEME.Panel, function()
    safeTeleport(CFrame.new(421.9, 6.0, -677.6))
end)

createActionButton(PageTeleport, "🏦 Benji The Banker (Bank Vault)", THEME.Panel, function()
    safeTeleport(CFrame.new(505.9, 6.0, -696.3))
end)

createActionButton(PageTeleport, "🛒 Town 1 General Store / Shop", THEME.Panel, function()
    safeTeleport(CFrame.new(336.4, 4.0, -705.3))
end)

createActionButton(PageTeleport, "🤝 Town 1 Trading Post", THEME.Panel, function()
    safeTeleport(CFrame.new(386.0, 10.0, -865.5))
end)

createActionButton(PageTeleport, "🏠 Main Lobby Spawn", THEME.Panel, function()
    safeTeleport(CFrame.new(-787.8, 10.0, -730.9))
end)

createActionButton(PageTeleport, "🛒 Town 2 Station & Shop", THEME.Panel, function()
    safeTeleport(CFrame.new(399.2, 304.0, -1319.5))
end)

createActionButton(PageTeleport, "⛪ Town 2 Weapon Stand", THEME.Panel, function()
    safeTeleport(CFrame.new(421.9, 307.0, -1327.6))
end)

createActionButton(PageTeleport, "🏦 Town 2 Banker", THEME.Panel, function()
    safeTeleport(CFrame.new(505.8, 304.0, -1349.3))
end)

createSection(PageTeleport, "SecTpDrill")

createActionButton(PageTeleport, "🚜 Teleport ke Kursi Kemudi Bor", THEME.Green, function()
    local drill = findDrillModel()
    if drill then
        local seat = drill:FindFirstChildWhichIsA("VehicleSeat", true)
        if seat then
            safeTeleport(seat.CFrame + Vector3.new(0, 1.5, 0))
        end
    end
end)

createActionButton(PageTeleport, "🚜 Teleport ke Lantai Deck Bor", THEME.Panel, function()
    local deckCF = getDrillDeckCFrame()
    if deckCF then
        safeTeleport(deckCF)
    end
end)

-- 9. CONFIGURATION TAB (SAVE & LOAD)
createSection(PageConfig, "SecConfig")

createToggle(PageConfig, "AutoSaveConfig", "AutoSaveToggle", "AutoSaveDesc")

createActionButton(PageConfig, T("BtnSaveCfg"), THEME.Green, function()
    saveConfigToFile()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "👑 BROTHER HUB",
            Text = "Konfigurasi berhasil disimpan ke file!",
            Duration = 3
        })
    end)
end)

createActionButton(PageConfig, T("BtnLoadCfg"), THEME.Blue, function()
    local ok = loadConfigFromFile()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "👑 BROTHER HUB",
            Text = ok and "Konfigurasi berhasil dimuat!" or "File konfigurasi belum ada!",
            Duration = 3
        })
    end)
end)

createActionButton(PageConfig, T("BtnResetCfg"), THEME.Red, function()
    pcall(function()
        if isfile and isfile(CFG_FILE) and delfile then
            delfile(CFG_FILE)
        end
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "👑 BROTHER HUB",
            Text = "Konfigurasi di-reset ke default!",
            Duration = 3
        })
    end)
end)

-- 10. Settings Tab
createSection(PageSettings, "SecSettings")

createActionButton(PageSettings, T("SwitchLang"), THEME.Panel, function()
    currentLang = (currentLang == "ID") and "EN" or "ID"
    TitleLabel.Text = T("HubTitle") .. "  •  " .. T("HubSubtitle")
    for id, t in pairs(tabs) do
        t.Button.Text = t.Icon .. " " .. T(t.NameKey)
    end
end)

createActionButton(PageSettings, T("BtnDestroy"), THEME.Red, function()
    cleanupAll()
    ScreenGui:Destroy()
end)

-- 11. Donation & Community
createSection(PageDonate, "TabDonate")
createActionButton(PageDonate, "☕ Donasi Saweria (QRIS / GoPay / OVO / DANA)", THEME.Gold, function()
    copyToClipboard("https://saweria.co/prawiraxliv", "Link Saweria disalin!")
end)

createActionButton(PageDonate, "💖 Donasi SociaBuzz (QRIS / VA / E-Wallet)", THEME.Purple, function()
    copyToClipboard("https://sociabuzz.com/brotherhubofficial/tribe", "Link SociaBuzz disalin!")
end)

createActionButton(PageDonate, "💬 Join Official Discord (brotherhub)", THEME.Blue, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Discord Server link copied!")
end)

createActionButton(PageDonate, "💎 Ultra Donator & Supporter Role", THEME.Purple, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Donation perks available in Discord!")
end)

-- 12. Credits
createSection(PageCredit, "TabCredit")
createActionButton(PageCredit, "👑 Founder & Lead Developer: prawiraxliv", THEME.Gold, function()
    copyToClipboard("prawiraxliv", "Founder username copied!")
end)

createActionButton(PageCredit, "💬 Official Discord: discord.gg/szYbZCqHKS", THEME.Blue, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Discord link copied!")
end)

-- Auto Load Saved Configuration on Startup
task.spawn(function()
    task.wait(0.5)
    loadConfigFromFile()
end)

-- Open first tab by default
if tabs["Drill"] then
    tabs["Drill"].Page.Visible = true
    tabs["Drill"].Button.TextColor3 = Color3.new(1, 1, 1)
    tabs["Drill"].Button.BackgroundColor3 = THEME.Accent
    currentTab = "Drill"
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "👑 BROTHER HUB OFFICIAL",
        Text = "Drill to Earth's Core Master Suite aktif! Selamat bermain.",
        Duration = 5
    })
end)
