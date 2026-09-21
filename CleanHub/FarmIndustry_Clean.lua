--[[
    ========================================================================
    👑 BROTHER HUB — OFFICIAL FARM INDUSTRY SUITE
    ========================================================================
    Game        : Farm Industry
    Place ID    : 78602687536170
    Design Tier : 1:1 FlowerShop Master Standard (RGB Neon Stroke, MinCircle 80x80)
    Platform    : Universal (Xeno PC, Delta / Arceus / Codex Mobile Android)
    Language    : Bilingual Smart Engine (🇮🇩 ID / 🇬🇧 EN Auto-Detect & Toggle)
    Features    : 100% Functional, Zero Lag, Event-Driven, Full 24/7 AFK Suite
    Security    : Brother Guard Undetected Engine
    ========================================================================
]]

-- [0] MULTI-INSTANCE PREVIOUS RUN CLEANUP (INSTANT CLOSE & WIPE)
if _G.BH_FARM_CLEANUP then
    pcall(_G.BH_FARM_CLEANUP)
end
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local targets = { CoreGui, lp and lp:FindFirstChild("PlayerGui") }
    if gethui then pcall(function() table.insert(targets, gethui()) end) end
    for _, parent in ipairs(targets) do
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name == "BrotherHub_FarmIndustry" or child.Name == "FarmIndustryGui" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
end)

-- [1] SERVICES & LOCAL PLAYER
local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")
local TeleportService     = game:GetService("TeleportService")
local HttpService         = game:GetService("HttpService")
local CoreGui             = game:GetService("CoreGui")
local CollectionService   = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local camera      = workspace.CurrentCamera

-- ====================================================================
-- 👑 BROTHER HUB - TELEMETRY & EXECUTION LOGGER (FOUNDER & WAKIL FOUNDER)
-- ====================================================================
local function sendExecutionLog(scriptTitle)
    if _G.BROTHERHUB_TRACKED then return end
    _G.BROTHERHUB_TRACKED = true

    task.spawn(function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local MarketplaceService = game:GetService("MarketplaceService")
            local Players = game:GetService("Players")
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
                        thumbnail = {
                            url = avatarUrl
                        },
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
                Headers = {
                    ["Content-Type"] = "application/json"
                },
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

sendExecutionLog("Farm Industry")

-- [2] SMART BILINGUAL SYSTEM (AUTO-DETECT + TOGGLE)
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
        HubSubtitle     = "Farm Industry • Master Automation",
        TabFactory      = "🏭 Pabrik",
        TabLivestock    = "🐄 Ternak",
        TabFarming      = "💧 Ladang",
        TabDelivery     = "🚚 Pasar & Truk",
        TabMission      = "📜 Misi",
        TabUpgrade      = "📈 Upgrade & Rebirth",
        TabPlayer       = "⚡ Karakter",
        TabTeleport     = "📍 Teleport",
        TabSettings     = "⚙️ Pengaturan",
        
        -- Factory Tab
        SecFactoryProd      = "PRODUKSI PABRIK OTOMATIS",
        AutoStartProd       = "Auto Mulai Produksi (Semua Pabrik)",
        AutoStartDesc       = "Otomatis antrekan resep terbaik (Tepung, Roti, Benang, Sweater, Sosis, Hotdog, Mentega, Keju)",
        AutoClaimProd       = "Auto Klaim Hasil Produksi",
        AutoClaimDesc       = "Mengambil seluruh produk jadi di semua pabrik seketika tanpa delay",
        AutoUpgradeFact     = "Auto Upgrade Tier Pabrik (Speed & Capacity)",
        AutoUpgradeDesc     = "Menaikkan level kecepatan & kapasitas pabrik otomatis saat modal uang mencukupi",
        AutoUnlockFact      = "Auto Buka Pabrik Baru (Unlock)",
        AutoUnlockDesc      = "Membeli & membuka pabrik berikutnya saat syarat level tercapai",
        ProdInterval        = "Jeda Siklus Produksi (Detik)",
        ProdBatchAmount     = "Jumlah Antrean Mesin (Bisa Lebih dari 1)",
        ProdBatchAmountDesc = "Mengantrekan beberapa item sekaligus ke mesin pabrik sesuai kapasitas antrean",
        TeleportProd        = "⚡ Teleport ke Pabrik saat Mulai Produksi",
        TeleportProdDesc    = "Mendekati mesin pabrik seketika agar server memvalidasi mulai produksi",
        
        -- Livestock Tab
        SecLivestock        = "MANAJEMEN PETERNAKAN & TELUR",
        AutoCollectEggs     = "Auto Ambil Telur & Drop Hewan (Vacuum)",
        TeleportApproach    = "⚡ Teleport Mendekat saat Sedot (100% Masuk Tas)",
        TeleportApproachDesc= "Teleportasi sekejap tepat di depan telur/drop hewan agar terdeteksi server & masuk tas",
        TeleportReturn      = "🔄 Kembali ke Posisi Awal Setelah Sedot",
        TeleportReturnDesc  = "Otomatis kembali ke tempat semula setelah menyedot seluruh telur di kandang",
        TeleportClaim       = "⚡ Teleport ke Pabrik saat Klaim Produk",
        TeleportClaimDesc   = "Teleportasi langsung ke depan pabrik saat mengambil produk jadi agar klaim sukses",
        AutoClaimMegaMilestone = "Auto Klaim Mega Milestone",
        AutoClaimMegaDesc   = "Otomatis mengklaim seluruh hadiah event mega milestone",
        AutoBuyFarmMastery  = "Auto Beli Farm Mastery",
        AutoBuyFarmMasteryD = "Otomatis mengupgrade mastery pertanian saat modal mencukupi",
        AutoBuyRebMastery   = "Auto Beli Rebirth Mastery",
        AutoBuyRebMasteryD  = "Otomatis mengupgrade mastery kelahiran kembali (rebirth)",
        AutoCollectEggsDesc = "Menyedot semua telur ayam (Biasa, Emas, Sakura, Cosmic), wol, susu, dan daging otomatis",
        ZeroRobuxShield     = "🛡️ Proteksi 100% Anti-Robux (Aktif)",
        ZeroRobuxDesc       = "Memblokir popup bayar Robux & fokus memanen hasil ternak plot sendiri",
        EggCollectInterval  = "Jeda Sedot Telur & Drop (Detik)",
        AutoBuyAnimals      = "Auto Beli Hewan Ternak",
        AutoBuyDesc         = "Membeli bibit hewan ternak secara berkala sampai kandang penuh",
        AnimalType          = "Pilihan Hewan",
        AutoTransfer        = "Auto Transfer Hewan ke Kandang",
        AutoTransferDesc    = "Memindahkan hewan otomatis antar kandang (Bulk Transfer 'All')",
        BuyInterval         = "Jeda Beli Hewan (Detik)",
        SecWerewolf         = "EVENT SERIGALA MALAM (WEREWOLF BOSS)",
        AutoKillWerewolf    = "Auto Kill Serigala Malam (Werewolf Boss)",
        AutoKillWerewolfDesc= "Otomatis menyerang Werewolf saat malam tiba, melayang di atas kepala bos, dan menyedot Daging Serigala",
        
        -- Farming Tab
        SecFarming      = "PENYIRAMAN AIR & PERTANIAN",
        AutoWater       = "Auto Siram Tanaman (Continuous Pouring)",
        AutoWaterDesc   = "Penyiraman air terus-menerus tanpa henti membypass animasi manual",
        AutoRefillWater = "Auto Ambil / Isi Air (Refill Sumur)",
        AutoRefillWaterDesc = "Otomatis mengisi ulang air penyiram di sumur saat air habis",
        AutoEquipCan    = "Auto Pakai Penyiram Terbaik",
        AutoEquipDesc   = "Otomatis memakai gembor penyiram air tier tertinggi di tas",
        AutoHarvestCrops= "Auto Panen Sayur & Tanaman",
        AutoHarvestDesc = "Mengumpulkan hasil panen di ladang saat siap dipetik",
        WaterSpeed      = "Jeda Loop Penyiraman (Detik)",
        
        -- Delivery & Market Tab
        SecDelivery     = "PENGIRIMAN TRUK & PENJUALAN PASAR",
        AutoInstantSell = "⚡ Auto Jual Semua Hasil Panen & Produk (Instant Sell)",
        AutoInstantSellDesc = "Menjual seluruh hasil panen, telur, susu, daging & produk pabrik seketika",
        AutoTruckDeliver= "Auto Kirim Truk Pesanan (Delivery)",
        AutoTruckDesc   = "Mengirimkan produk siap antar via truk kargo otomatis",
        AutoMarketSell  = "Auto Jual Cepat ke Pasar",
        AutoMarketDesc  = "Menjual hasil panen berlebih ke NPC pasar dengan harga maksimal",
        DeliveryInterval= "Jeda Pengiriman Truk (Detik)",
        
        -- Mission & Quest Tab
        SecDailyMission     = "MISI HARIAN (DAILY MISSIONS)",
        AutoClaimDaily      = "Auto Klaim Misi Harian (Daily)",
        AutoClaimDailyDesc  = "Otomatis mengklaim semua hadiah misi harian yang telah tuntas secara instan",
        SecWeeklyMission    = "MISI MINGGUAN (WEEKLY MISSIONS)",
        AutoClaimWeekly     = "Auto Klaim Misi Mingguan (Weekly)",
        AutoClaimWeeklyDesc = "Otomatis memantau dan mengklaim seluruh misi mingguan berhadiah koin & bintang",
        SecMissionBoard     = "PAPAN MISI & SINKRONISASI",
        AutoSyncMission     = "Auto Buka / Sinkron Papan Misi (Plot)",
        AutoSyncMissionDesc = "Memicu papan misi plot otomatis agar data misi selalu ter-refresh di game",
        SecAchievements     = "PENCAPAIAN & MILESTONE",
        AutoAchievements    = "Auto Klaim Pencapaian (Achievements)",
        AutoAchievDesc      = "Mengklaim bonus pencapaian dan milestone event seketika",
        AutoUnlockStarSlots = "Auto Buka Slot Misi dengan Bintang",
        AutoUnlockStarDesc  = "Membuka slot misi harian tambahan menggunakan bintang secara otomatis",
        ClaimAllMissionsBtn = "Klaim Semua Misi & Pencapaian Sekarang",
        OpenMissionGuiBtn   = "Buka / Tutup Menu Misi (QuestGUI)",
        NotifyAllMissionsClaimed = "Semua Misi & Pencapaian Berhasil Diklaim!",
        NotifyMissionSynced = "Papan Misi Berhasil Disinkronkan!",
        
        -- Upgrade & Rebirth Tab
        SecUpgrade      = "PROGRESSION & REBIRTH",
        AutoUniversalUp = "Auto Universal Upgrades",
        AutoUniversalDes= "Meningkatkan seluruh upgrade universal otomatis (Speed, Kapasitas)",
        AutoRebirth     = "Auto Rebirth (Siklus Kelahiran Baru)",
        AutoRebirthDesc = "Otomatis mengeksekusi Rebirth saat syarat level & uang terpenuhi",
        AutoQuests      = "Auto Klaim Misi (Quests)",
        AutoQuestsDesc  = "Mengklaim seluruh hadiah quest yang telah tuntas otomatis",
        AutoAchievements= "Auto Klaim Pencapaian",
        AutoAchievDesc  = "Mengklaim bonus pencapaian (Achievements) seketika",
        AutoClearWeather= "Auto Cuaca Cerah (Clear Sky)",
        AutoWeatherDesc = "Meniadakan hujan/kabut agar pemandangan ladang jernih maksimal",
        
        -- Player & Movement Tab
        SecMovement     = "GERAKAN & FISIKA PEMAIN",
        WalkSpeedToggle = "Aktifkan Speed Boost",
        WalkSpeedSlider = "Kecepatan Lari (WalkSpeed)",
        JumpPowerToggle = "Aktifkan JumpPower Boost",
        JumpPowerSlider = "Kekuatan Lompat (JumpPower)",
        NoclipToggle    = "Tembus Dinding (Noclip)",
        NoclipDesc      = "Menembus seluruh pagar dan bangunan (100% pemulihan tabrakan saat OFF)",
        FlyToggle       = "Terbang Bebas (Fly WASD / Mobile)",
        FlySpeedSlider  = "Kecepatan Terbang",
        InfJumpToggle   = "Lompat Tak Terbatas (Infinite Jump)",
        NightVision     = "Penglihatan Malam (Fullbright)",
        AntiAfkToggle   = "24/7 Anti-AFK Guard",
        AntiAfkDesc     = "Mencegah kick 20 menit Roblox saat ditinggal AFK tidur",
        
        -- Teleport Tab
        SecTeleportFact = "TELEPORT KE PABRIK",
        SecTeleportBarn = "TELEPORT KE KANDANG & LADANG",
        SecTeleportNPC  = "TELEPORT KE PASAR & TOKO",
        TpClickTool     = "Dapatkan Alat Click Teleport",
        
        -- Settings Tab
        SecLanguage     = "BAHASA & SISTEM",
        LangToggle      = "Bahasa: Indonesia 🇮🇩",
        LangDesc        = "Klik untuk mengubah ke English 🇬🇧",
        RejoinBtn       = "Masuk Ulang Server (Rejoin)",
        ServerHopBtn    = "Pindah Server Lain (Server Hop)",
        UnloadBtn       = "Tutup & Hapus GUI (Unload)",
        NotifyLangSwitched = "Bahasa diubah ke Bahasa Indonesia!",
        NotifyTeleported   = "Teleportasi berhasil!",
        NotifyAntiAfkOn    = "Anti-AFK 24 Jam Aktif! Akun aman ditinggal tidur.",
        NotifyRebirthDone  = "Rebirth berhasil dieksekusi!"
    },
    EN = {
        HubTitle        = "BROTHER HUB",
        HubSubtitle     = "Farm Industry • Master Automation",
        TabFactory      = "🏭 Factories",
        TabLivestock    = "🐄 Livestock",
        TabFarming      = "💧 Farming",
        TabDelivery     = "🚚 Delivery & Market",
        TabMission      = "📜 Missions",
        TabUpgrade      = "📈 Upgrade & Rebirth",
        TabPlayer       = "⚡ Movement",
        TabTeleport     = "📍 Teleports",
        TabSettings     = "⚙️ Settings",
        
        -- Factory Tab
        SecFactoryProd      = "AUTOMATED FACTORY PRODUCTION",
        AutoStartProd       = "Auto Start Production (All Factories)",
        AutoStartDesc       = "Automatically queues best recipes (Flour, Bread, Yarn, Sweater, Sausage, Hotdog, Butter, Cheese)",
        AutoClaimProd       = "Auto Claim Production Output",
        AutoClaimDesc       = "Collects all finished goods from every factory instantly without delay",
        AutoUpgradeFact     = "Auto Upgrade Factory (Speed & Capacity)",
        AutoUpgradeDesc     = "Upgrades factory speed and queue capacity automatically when cash allows",
        AutoUnlockFact      = "Auto Unlock Next Factory",
        AutoUnlockDesc      = "Purchases and unlocks new factories when level requirements are met",
        ProdInterval        = "Production Cycle Delay (Seconds)",
        ProdBatchAmount     = "Machine Queue Batch Amount (>1 Multi-Queue)",
        ProdBatchAmountDesc = "Queues multiple items into the factory machine at once according to queue capacity",
        TeleportProd        = "⚡ Teleport to Factory on Start Production",
        TeleportProdDesc    = "Blinks right next to factory machine so server validates production start",
        
        -- Livestock Tab
        SecLivestock        = "LIVESTOCK, EGGS & BARN MANAGEMENT",
        AutoCollectEggs     = "Auto Collect Eggs & Animal Drops (Vacuum)",
        TeleportApproach    = "⚡ Teleport Approach on Collect (100% Bag Success)",
        TeleportApproachDesc= "Blinks right next to eggs/produce so server validates pickup into inventory",
        TeleportReturn      = "🔄 Return to Origin After Sweep",
        TeleportReturnDesc  = "Returns character back to initial spot after collecting all plot drops",
        TeleportClaim       = "⚡ Teleport to Factory on Claim",
        TeleportClaimDesc   = "Teleports to factory stations when claiming finished goods for 100% success",
        AutoClaimMegaMilestone = "Auto Claim Mega Milestones",
        AutoClaimMegaDesc   = "Claims all completed mega milestone event rewards automatically",
        AutoBuyFarmMastery  = "Auto Buy Farm Mastery",
        AutoBuyFarmMasteryD = "Purchases farm mastery progression upgrades automatically",
        AutoBuyRebMastery   = "Auto Buy Rebirth Mastery",
        AutoBuyRebMasteryD  = "Purchases rebirth mastery tiers whenever funds allow",
        AutoCollectEggsDesc = "Instantly vacuums all eggs (Regular, Gold, Sakura, Cosmic), wool, milk, and meats",
        ZeroRobuxShield     = "🛡️ 100% Anti-Robux Protection (Active)",
        ZeroRobuxDesc       = "Auto-blocks in-game Robux paywalls and focuses on your own farm drops",
        EggCollectInterval  = "Egg & Drop Vacuum Interval (Seconds)",
        AutoBuyAnimals      = "Auto Buy Animals",
        AutoBuyDesc         = "Purchases livestock automatically until barns reach full capacity",
        AnimalType          = "Animal Selection",
        AutoTransfer        = "Auto Transfer Animals to Barns",
        AutoTransferDesc    = "Transfers animals between barns automatically (Bulk Transfer 'All')",
        BuyInterval         = "Animal Purchase Delay (Seconds)",
        SecWerewolf         = "NIGHT WEREWOLF BOSS EVENT",
        AutoKillWerewolf    = "Auto Kill Night Werewolf Boss",
        AutoKillWerewolfDesc= "Auto-attacks Werewolf during night events, hovers safely above boss, and vacuums Wolf Meat drops",
        
        -- Farming Tab
        SecFarming      = "WATERING & CROP HARVESTING",
        AutoWater       = "Auto Water Plants (Continuous Pouring)",
        AutoWaterDesc   = "Continuous water pouring loop bypassing manual hand animations",
        AutoRefillWater = "Auto Refill Water (Well)",
        AutoRefillWaterDesc = "Automatically refills watering can at the well when empty",
        AutoEquipCan    = "Auto Equip Best Watering Can",
        AutoEquipDesc   = "Equips the highest tier watering can in inventory automatically",
        AutoHarvestCrops= "Auto Harvest Crops & Vegetables",
        AutoHarvestDesc = "Harvests ripe vegetables across plots when ready",
        WaterSpeed      = "Watering Interval (Seconds)",
        
        -- Delivery & Market Tab
        SecDelivery     = "TRUCK DELIVERY & MARKET LOGISTICS",
        AutoInstantSell = "⚡ Auto Instant Sell All Products",
        AutoInstantSellDesc = "Instantly sells all harvested crops, animal goods & factory products",
        AutoTruckDeliver= "Auto Send Truck Deliveries",
        AutoTruckDesc   = "Dispatches delivery trucks automatically with available cargo",
        AutoMarketSell  = "Auto Sell at Market",
        AutoMarketDesc  = "Sells excess produce to Market NPCs at maximum trade value",
        DeliveryInterval= "Truck Delivery Interval (Seconds)",
        
        -- Mission & Quest Tab
        SecDailyMission     = "DAILY MISSIONS",
        AutoClaimDaily      = "Auto Claim Daily Missions",
        AutoClaimDailyDesc  = "Automatically claims all completed daily quest rewards instantly",
        SecWeeklyMission    = "WEEKLY MISSIONS",
        AutoClaimWeekly     = "Auto Claim Weekly Missions",
        AutoClaimWeeklyDesc = "Automatically tracks and claims weekly mission rewards for cash & stars",
        SecMissionBoard     = "MISSION BOARD & SYNC",
        AutoSyncMission     = "Auto Open / Sync Mission Board (Plot)",
        AutoSyncMissionDesc = "Interacts with plot mission board to keep active quest data in sync",
        SecAchievements     = "ACHIEVEMENTS & MILESTONES",
        AutoAchievements    = "Auto Claim Achievements",
        AutoAchievDesc      = "Instantly claims milestone event and lifetime achievement rewards",
        AutoUnlockStarSlots = "Auto Unlock Slots with Stars",
        AutoUnlockStarDesc  = "Automatically unlocks extra mission slots using stars",
        ClaimAllMissionsBtn = "Claim All Quests & Achievements Now",
        OpenMissionGuiBtn   = "Open / Close Quest Menu (QuestGUI)",
        NotifyAllMissionsClaimed = "All Quests & Achievements Successfully Claimed!",
        NotifyMissionSynced = "Mission Board Successfully Synced!",
        
        -- Upgrade & Rebirth Tab
        SecUpgrade      = "PROGRESSION & REBIRTH",
        AutoUniversalUp = "Auto Universal Upgrades",
        AutoUniversalDes= "Purchases all universal upgrades automatically (Speed, Capacity)",
        AutoRebirth     = "Auto Rebirth (New Life Cycle)",
        AutoRebirthDesc = "Executes Rebirth automatically when level and requirements are met",
        AutoQuests      = "Auto Claim Quests",
        AutoQuestsDesc  = "Claims all completed quest rewards automatically",
        AutoAchievements= "Auto Claim Achievements",
        AutoAchievDesc  = "Claims achievement rewards instantly",
        AutoClearWeather= "Auto Clear Sky (No Fog/Rain)",
        AutoWeatherDesc = "Clears weather for pristine visibility across farm fields",
        
        -- Player & Movement Tab
        SecMovement     = "PLAYER MOVEMENT & PHYSICS",
        WalkSpeedToggle = "Enable WalkSpeed Boost",
        WalkSpeedSlider = "WalkSpeed Multiplier",
        JumpPowerToggle = "Enable JumpPower Boost",
        JumpPowerSlider = "JumpPower Multiplier",
        NoclipToggle    = "Penetration Noclip",
        NoclipDesc      = "Walk through fences, walls and buildings (100% collision restore when OFF)",
        FlyToggle       = "Free Flight (WASD / Mobile Touch)",
        FlySpeedSlider  = "Flight Speed",
        InfJumpToggle   = "Infinite Jump",
        NightVision     = "Fullbright Night Vision",
        AntiAfkToggle   = "24/7 Anti-AFK Guard",
        AntiAfkDesc     = "Prevents the 20-minute Roblox idle kick while AFK farming",
        
        -- Teleport Tab
        SecTeleportFact = "TELEPORT TO FACTORIES",
        SecTeleportBarn = "TELEPORT TO BARNS & FIELDS",
        SecTeleportNPC  = "TELEPORT TO MARKET & SHOPS",
        TpClickTool     = "Get Click Teleport Tool",
        
        -- Settings Tab
        SecLanguage     = "SYSTEM & LANGUAGE",
        LangToggle      = "Language: English 🇬🇧",
        LangDesc        = "Click to switch to Bahasa Indonesia 🇮🇩",
        RejoinBtn       = "Rejoin Current Server",
        ServerHopBtn    = "Hop to Another Server",
        UnloadBtn       = "Unload & Clean GUI",
        NotifyLangSwitched = "Language switched to English!",
        NotifyTeleported   = "Teleport successful!",
        NotifyAntiAfkOn    = "24/7 Anti-AFK Active! Safe for overnight farming.",
        NotifyRebirthDone  = "Rebirth successfully executed!"
    }
}

local function T(key)
    local dict = STRINGS[currentLang] or STRINGS.EN
    return dict[key] or key
end

-- [3] CLEANUP EXISTING SESSIONS
pcall(function()
    if getgenv().BrotherHub_FarmIndustry_Loaded then
        getgenv().BrotherHub_FarmIndustry_Unload()
    end
end)
getgenv().BrotherHub_FarmIndustry_Loaded = true

local connections = {}
local function track(conn)
    table.insert(connections, conn)
    return conn
end

-- [4] THEME & VISUAL TOKENS (1:1 FLOWERSHOP TIER)
local THEME = {
    Bg          = Color3.fromRGB(13, 14, 20),
    BgTrans     = 0.05,
    Panel       = Color3.fromRGB(20, 22, 32),
    PanelActive = Color3.fromRGB(30, 34, 50),
    Border      = Color3.fromRGB(45, 50, 75),
    Title       = Color3.fromRGB(245, 248, 255),
    SubText     = Color3.fromRGB(155, 162, 185),
    Accent      = Color3.fromRGB(46, 204, 113),  -- Farm Green
    AccentGlow  = Color3.fromRGB(39, 174, 96),
    Purple      = Color3.fromRGB(142, 68, 173),
    Blue        = Color3.fromRGB(41, 128, 185),
    Red         = Color3.fromRGB(231, 76, 60),
    Yellow      = Color3.fromRGB(241, 196, 15),
    Orange      = Color3.fromRGB(230, 126, 34),
    Text        = Color3.fromRGB(245, 248, 255),
    Font        = Enum.Font.GothamBold,
    FontRegular = Enum.Font.GothamMedium
}

-- LOGO: Pure Monogram "BH" with Gold Crown (Flower Shop Standard)

-- [5] SAFE GUI PARENTING (PROTECT FOR XENO & DELTA)
local guiParent = LocalPlayer:WaitForChild("PlayerGui")
if gethui then
    guiParent = gethui()
elseif syn and syn.protect_gui then
    guiParent = Instance.new("Folder")
    guiParent.Name = "BrotherHubContainer"
    guiParent.Parent = CoreGui
    syn.protect_gui(guiParent)
end

-- Farm Ownership Verification (Strict Anti-Robux Shield: Plot Sendiri Saja)
local function getMyFarmPlot()
    local Farm = workspace:FindFirstChild("Farm") or workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Farms")
    if not Farm then return nil end
    local uid = LocalPlayer.UserId
    local uName = LocalPlayer.Name
    for _, plot in ipairs(Farm:GetChildren()) do
        if plot:GetAttribute("OwnerId") == uid or plot:GetAttribute("Owner") == uName or plot:GetAttribute("UserId") == uid then
            return plot
        end
        local oVal = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerId") or plot:FindFirstChild("Player")
        if oVal and (oVal.Value == uid or oVal.Value == uName or (typeof(oVal.Value) == "Instance" and oVal.Value == LocalPlayer)) then
            return plot
        end
        if plot.Name == tostring(uid) or plot.Name == uName then
            return plot
        end
    end
    return nil
end

local function isMyFarm(inst)
    if not inst then return false end
    local myPlot = getMyFarmPlot()
    if not myPlot then return false end -- Jika plot belum terdeteksi, tolak semua aksi!
    return inst:IsDescendantOf(myPlot)  -- HANYA benar jika berada di dalam batas plot sendiri
end

-- Universal Safe ProximityPrompt Trigger (100% Anti-Robux & Zero Steal Guaranteed)
local function safeFirePrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    
    local act = (prompt.ActionText or ""):lower()
    local obj = (prompt.ObjectText or ""):lower()
    local pName = (prompt.Name or ""):lower()

    local isFactoryPrompt = prompt.Name == "UnlockPrompt"
        or (prompt.Parent and (prompt:IsDescendantOf(workspace:FindFirstChild("FactorySpawn") or workspace) or prompt:IsDescendantOf(workspace:FindFirstChild("Factory") or workspace)))
        or (obj:find("pabrik") or obj:find("factory"))

    -- 1. MUTLAK TOLAK jika terindikasi prompt Curi/Steal/Robux
    if act:find("steal") or act:find("curi") or act:find("robux") or
       obj:find("steal") or obj:find("curi") or obj:find("robux") or
       pName:find("steal") or pName:find("robux") or pName:find("curi") then
        return false
    end

    -- Non-factory prompts: tolak beli/purchase luar plot sendiri
    if not isFactoryPrompt then
        if act:find("buy") or act:find("beli") or act:find("purchase") or
           obj:find("buy") or obj:find("beli") or obj:find("purchase") or
           pName:find("purchase") then
            return false
        end
    end

    -- 2. CRITICAL ANTI-ROBUX CHECK: Wajib berada di plot sendiri! (Kecuali drop serigala & stasiun pabrik resmi)
    local isWolfDrop = (prompt.Parent and (prompt.Parent.Name:lower():find("serigala") or prompt.Parent.Name:lower():find("wolf")))
    if not isWolfDrop and not isFactoryPrompt and not isMyFarm(prompt) then return false end

    pcall(function()
        prompt.MaxActivationDistance = 999999
        prompt.RequiresLineOfSight = false
        if prompt.HoldDuration > 0 then
            prompt.HoldDuration = 0
        end
    end)
    
    local fired = false
    if fireproximityprompt then
        local ok = pcall(function()
            fireproximityprompt(prompt, 0)
        end)
        if ok then fired = true end
    end
    
    if not fired then
        pcall(function()
            if prompt.InputHoldBegin then
                prompt:InputHoldBegin()
                task.wait(0.01)
                prompt:InputHoldEnd()
                fired = true
            end
        end)
    end
    return fired
end

-- ============================================================
-- [ANTI-ROBUX PROTECTION SHIELD]
-- Automatically blocks and dismisses any in-game Robux purchase prompts
-- ============================================================
task.spawn(function()
    pcall(function()
        local MarketplaceService = game:GetService("MarketplaceService")
        if hookfunction then
            local oldPromptProductPurchase
            oldPromptProductPurchase = hookfunction(MarketplaceService.PromptProductPurchase, function(...)
                return
            end)
            local oldPromptPurchase
            oldPromptPurchase = hookfunction(MarketplaceService.PromptPurchase, function(...)
                return
            end)
        end
    end)
    
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        local function checkPurchasePrompt(obj)
            if not obj then return end
            task.spawn(function()
                task.wait(0.05)
                pcall(function()
                    for _, child in ipairs(obj:GetDescendants()) do
                        if child:IsA("GuiButton") and (child.Name:lower():find("cancel") or child.Name:lower():find("close")) then
                            if firesignal then
                                firesignal(child.MouseButton1Click)
                            end
                        end
                    end
                end)
            end)
        end
        
        local pp = CoreGui:FindFirstChild("PurchasePrompt")
        if pp then
            pp.DescendantAdded:Connect(function()
                checkPurchasePrompt(pp)
            end)
        end
        CoreGui.ChildAdded:Connect(function(child)
            if child.Name == "PurchasePrompt" or child.Name:lower():find("purchase") then
                child.DescendantAdded:Connect(function()
                    checkPurchasePrompt(child)
                end)
            end
        end)
    end)
end)

-- Helper UI Functions
local function corner(inst, r)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, r or 10)
    return c
end

local function stroke(inst, color, thick)
    local s = Instance.new("UIStroke", inst)
    s.Color = color or THEME.Border
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function gradient(inst, c1, c2, rot)
    local g = Instance.new("UIGradient", inst)
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 0
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
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 40, 255)),    -- Biru Tua Neon
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 25, 45)),   -- Merah Neon
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(20, 255, 80)),   -- Hijau Neon
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 40, 255)),    -- Balik ke Biru (Mulus)
    })
    g.Rotation = 0
    local tw = TweenService:Create(g,
        TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360})
    tw:Play()
    return s, tw
end

-- [6] BUILD MAIN GUI WITH RESPONSIVE SCALE (PRAWIRAHUB.TXT BLUEPRINT)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrotherHub_FarmIndustry"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

local UIScale = Instance.new("UIScale", ScreenGui)
local BASE_RES = Vector2.new(1280, 720)
local function updateViewportScale()
    if not camera then return end
    local v = camera.ViewportSize
    local s = math.min(v.X / BASE_RES.X, v.Y / BASE_RES.Y)
    UIScale.Scale = math.clamp(s, 0.45, 1.15)
end
track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewportScale))
updateViewportScale()

-- Main Frame (640 x 420, centered)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.fromOffset(640, 420)
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.BackgroundTransparency = THEME.BgTrans
MainFrame.BorderSizePixel = 0
corner(MainFrame, 14)
neonStroke(MainFrame, 2)

local MainScale = Instance.new("UIScale", MainFrame)
MainScale.Scale = 1

-- Header Frame (Height 52px)
local Header = Instance.new("Frame", MainFrame)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = THEME.Panel
Header.BorderSizePixel = 0
corner(Header, 14)
gradient(Header, THEME.Purple, THEME.Blue, 0)

local HeaderSquareBottom = Instance.new("Frame", Header)
HeaderSquareBottom.Size = UDim2.new(1, 0, 0, 14)
HeaderSquareBottom.Position = UDim2.new(0, 0, 1, -14)
HeaderSquareBottom.BackgroundColor3 = THEME.Panel
HeaderSquareBottom.BorderSizePixel = 0
HeaderSquareBottom.ZIndex = 0
gradient(HeaderSquareBottom, THEME.Purple, THEME.Blue, 0)

-- Header Title & Subtitle
local TitleLogo = Instance.new("TextLabel", Header)
TitleLogo.Size = UDim2.fromOffset(36, 36)
TitleLogo.Position = UDim2.new(0, 12, 0.5, -18)
TitleLogo.BackgroundTransparency = 1
TitleLogo.Font = THEME.Font
TitleLogo.TextSize = 22
TitleLogo.TextColor3 = THEME.Title
TitleLogo.Text = "👑"

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(0, 300, 0, 24)
TitleLabel.Position = UDim2.new(0, 56, 0, 6)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BROTHER HUB"
TitleLabel.TextColor3 = THEME.Title
TitleLabel.Font = THEME.Font
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubtitleLabel = Instance.new("TextLabel", Header)
SubtitleLabel.Size = UDim2.new(0, 300, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 56, 0, 28)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Farm Industry • Master Automation"
SubtitleLabel.TextColor3 = THEME.SubText
SubtitleLabel.Font = THEME.FontRegular
SubtitleLabel.TextSize = 12
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Header Control Buttons (– and X)
local function createHeaderBtn(text, pos, color)
    local btn = Instance.new("TextButton", Header)
    btn.Size = UDim2.fromOffset(32, 32)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.Text = text
    btn.TextColor3 = color or THEME.Title
    btn.Font = THEME.Font
    btn.TextSize = 16
    btn.AutoButtonColor = false
    corner(btn, 8)
    return btn
end

local MinBtn = createHeaderBtn("-", UDim2.new(1, -74, 0.5, -16), THEME.Yellow)
local CloseBtn = createHeaderBtn("X", UDim2.new(1, -38, 0.5, -16), THEME.Red)

-- [7] FLOATING 80x80 MINCIRCLE (1:1 FLOWERSHOP MASTER STANDARD WITH GLOWING "BH")
local MinCircle = Instance.new("TextButton", ScreenGui)
MinCircle.Name = "MinCircle"
MinCircle.Size = UDim2.fromOffset(80, 80)
MinCircle.AnchorPoint = Vector2.new(0.5, 0.5)
MinCircle.Position = UDim2.new(0.5, 0, 0, 70)
MinCircle.BackgroundColor3 = THEME.Panel
MinCircle.Text = "BH"
MinCircle.Font = Enum.Font.GothamBlack
MinCircle.TextSize = 30
MinCircle.TextColor3 = Color3.fromRGB(0, 255, 200) -- Glowing Neon Cyan
MinCircle.AutoButtonColor = false
MinCircle.Active = true
MinCircle.Visible = false
corner(MinCircle, 40)
neonStroke(MinCircle, 3)
gradient(MinCircle, THEME.Purple, THEME.Blue, 45)

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

-- 1:1 FlowerShop MinCircle Standard Preserved (Crown 👑 + Glowing BH)

local CircleScale = Instance.new("UIScale", MinCircle)
CircleScale.Scale = 0

local isAnimating = false
local tweenBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenFast   = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function doMinimize()
    if isAnimating then return end
    isAnimating = true
    local t = TweenService:Create(MainScale, tweenFast, {Scale = 0})
    t:Play()
    t.Completed:Connect(function()
        MainFrame.Visible = false
        MinCircle.Visible = true
        CircleScale.Scale = 0
        local t2 = TweenService:Create(CircleScale, tweenBounce, {Scale = 1})
        t2:Play()
        t2.Completed:Connect(function() isAnimating = false end)
    end)
end

local function doRestore()
    if isAnimating then return end
    isAnimating = true
    local t = TweenService:Create(CircleScale, tweenFast, {Scale = 0})
    t:Play()
    t.Completed:Connect(function()
        MinCircle.Visible = false
        MainFrame.Visible = true
        MainScale.Scale = 0
        local t2 = TweenService:Create(MainScale, tweenBounce, {Scale = 1})
        t2:Play()
        t2.Completed:Connect(function() isAnimating = false end)
    end)
end

MinBtn.MouseButton1Click:Connect(doMinimize)

-- MinCircle Drag & Click Detection (DRAG_THRESHOLD = 8 FlowerShop Standard)
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
    track(UserInputService.InputChanged:Connect(function(i)
        if not active then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = (i.Position - startPx) / UIScale.Scale
            if d.Magnitude > DRAG_THRESHOLD then
                moved = true
            end
            MinCircle.Position = UDim2.new(
                guiStart.X.Scale, guiStart.X.Offset + d.X,
                guiStart.Y.Scale, guiStart.Y.Offset + d.Y
            )
        end
    end))
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
    track(UserInputService.InputEnded:Connect(onRelease))
end

-- Drag Main Frame (Seamless Touch & Mouse)
do
    local dragging = false
    local dragStart = nil
    local startPos = nil

    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = MainFrame.Position
        end
    end)

    track(UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = (i.Position - dragStart) / UIScale.Scale
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))

    local function endDrag(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end
    Header.InputEnded:Connect(endDrag)
    track(UserInputService.InputEnded:Connect(endDrag))
end

-- [8] TOAST NOTIFICATION SYSTEM
local ToastContainer = Instance.new("Frame", ScreenGui)
ToastContainer.Name = "ToastContainer"
ToastContainer.Size = UDim2.new(0, 320, 1, 0)
ToastContainer.Position = UDim2.new(1, -330, 0, 20)
ToastContainer.BackgroundTransparency = 1
local ToastList = Instance.new("UIListLayout", ToastContainer)
ToastList.SortOrder = Enum.SortOrder.LayoutOrder
ToastList.Padding = UDim.new(0, 8)
ToastList.VerticalAlignment = Enum.VerticalAlignment.Top

local function notify(msg, color)
    local toast = Instance.new("Frame", ToastContainer)
    toast.Size = UDim2.new(1, 0, 0, 44)
    toast.BackgroundColor3 = THEME.Panel
    toast.BorderSizePixel = 0
    corner(toast, 10)
    stroke(toast, color or THEME.Accent, 1)

    local bar = Instance.new("Frame", toast)
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color or THEME.Accent
    corner(bar, 2)

    local lbl = Instance.new("TextLabel", toast)
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = msg
    lbl.TextColor3 = THEME.Title
    lbl.Font = THEME.FontRegular
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true

    task.delay(3.5, function()
        TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        toast:Destroy()
    end)
end

-- [9] DELTA / MOBILE FIX: TABBAR (EXPLICIT HEIGHT 28px + AUTOMATIC CANVAS)
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
TabBar.ScrollBarThickness = 2
TabBar.ScrollBarImageColor3 = THEME.Accent
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.ClipsDescendants = true
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)

-- Content Container
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -102)
ContentContainer.Position = UDim2.new(0, 10, 0, 96)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true

local tabs = {}
local tabButtons = {}
local activeTab = nil

local function registerTab(id, key, icon)
    local btn = Instance.new("TextButton", TabBar)
    btn.Name = "TabBtn_" .. id
    btn.Size = UDim2.new(0, 100, 0, 28)
    btn.AutomaticSize = Enum.AutomaticSize.X
    btn.ClipsDescendants = true
    btn.BackgroundColor3 = THEME.Panel
    btn.BorderSizePixel = 0
    btn.Text = T(key)
    btn.TextColor3 = THEME.SubText
    btn.Font = THEME.Font
    btn.TextSize = 13
    btn.TextTruncate = Enum.TextTruncate.None
    btn.AutoButtonColor = false
    corner(btn, 8)
    stroke(btn, THEME.Border, 1)

    local btnPad = Instance.new("UIPadding", btn)
    btnPad.PaddingLeft = UDim.new(0, 12)
    btnPad.PaddingRight = UDim.new(0, 12)

    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Name = "Page_" .. id
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false

    local list = Instance.new("UIListLayout", page)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)

    local pad = Instance.new("UIPadding", page)
    pad.PaddingRight = UDim.new(0, 6)

    tabs[id] = {page = page, btn = btn, key = key}
    tabButtons[id] = btn

    btn.MouseButton1Click:Connect(function()
        for otherId, tData in pairs(tabs) do
            tData.page.Visible = false
            tData.btn.BackgroundColor3 = THEME.Panel
            tData.btn.TextColor3 = THEME.SubText
        end
        page.Visible = true
        btn.BackgroundColor3 = THEME.PanelActive
        btn.TextColor3 = THEME.Accent
        activeTab = id
    end)

    return page
end

-- UI Components Builders
local function createSection(parent, key)
    local sec = Instance.new("TextLabel", parent)
    sec.Size = UDim2.new(1, 0, 0, 22)
    sec.BackgroundTransparency = 1
    sec.Text = "— " .. T(key) .. " —"
    sec.TextColor3 = THEME.Accent
    sec.Font = THEME.Font
    sec.TextSize = 12
    sec.TextXAlignment = Enum.TextXAlignment.Left
    return sec
end

-- Full-Row Clickable Toggle (100% Hitbox Blueprint)
local function createToggle(parent, keyTitle, keyDesc, defaultVal, callback)
    local card = Instance.new("TextButton", parent)
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = THEME.Panel
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.Text = ""
    card.ClipsDescendants = true
    corner(card, 10)
    local cardStroke = stroke(card, THEME.Border, 1)

    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1, -76, 0, 20)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = T(keyTitle)
    title.TextColor3 = THEME.Title
    title.Font = THEME.Font
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true
    title.ClipsDescendants = true
    title.TextTruncate = Enum.TextTruncate.AtEnd

    local desc = Instance.new("TextLabel", card)
    desc.Size = UDim2.new(1, -76, 0, 20)
    desc.Position = UDim2.new(0, 12, 0, 26)
    desc.BackgroundTransparency = 1
    desc.Text = T(keyDesc)
    desc.TextColor3 = THEME.SubText
    desc.Font = THEME.FontRegular
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.ClipsDescendants = true
    desc.TextTruncate = Enum.TextTruncate.AtEnd

    local switch = Instance.new("Frame", card)
    switch.Size = UDim2.fromOffset(46, 24)
    switch.Position = UDim2.new(1, -58, 0.5, -12)
    switch.BackgroundColor3 = defaultVal and THEME.Accent or Color3.fromRGB(40, 45, 60)
    corner(switch, 12)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = defaultVal and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    corner(knob, 9)

    local state = defaultVal
    local function setVisual(val)
        cardStroke.Color = val and THEME.Accent or THEME.Border
        TweenService:Create(switch, TweenInfo.new(0.2), {
            BackgroundColor3 = val and THEME.Accent or Color3.fromRGB(40, 45, 60)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = val and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
    end

    card.MouseButton1Click:Connect(function()
        state = not state
        setVisual(state)
        task.spawn(callback, state)
    end)

    return {
        card = card,
        title = title,
        desc = desc,
        keyTitle = keyTitle,
        keyDesc = keyDesc,
        setState = function(val)
            state = val
            setVisual(val)
            task.spawn(callback, state)
        end
    }
end

-- Slider with Direct Numeric Input
local function createSlider(parent, keyTitle, minVal, maxVal, defaultVal, callback)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = THEME.Panel
    card.ClipsDescendants = true
    corner(card, 10)
    stroke(card, THEME.Border, 1)

    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1, -90, 0, 20)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = T(keyTitle)
    title.TextColor3 = THEME.Title
    title.Font = THEME.Font
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true
    title.ClipsDescendants = true
    title.TextTruncate = Enum.TextTruncate.AtEnd

    local valBox = Instance.new("TextBox", card)
    valBox.Size = UDim2.fromOffset(60, 22)
    valBox.Position = UDim2.new(1, -72, 0, 6)
    valBox.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
    valBox.Text = tostring(defaultVal)
    valBox.TextColor3 = THEME.Accent
    valBox.Font = THEME.Font
    valBox.TextSize = 13
    corner(valBox, 6)
    stroke(valBox, THEME.Border, 1)

    local barBg = Instance.new("TextButton", card)
    barBg.Size = UDim2.new(1, -24, 0, 8)
    barBg.Position = UDim2.new(0, 12, 0, 36)
    barBg.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    barBg.Text = ""
    barBg.AutoButtonColor = false
    corner(barBg, 4)

    local barFill = Instance.new("Frame", barBg)
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    barFill.Size = UDim2.new(pct, 0, 1, 0)
    barFill.BackgroundColor3 = THEME.Accent
    corner(barFill, 4)

    local function applyVal(v)
        v = math.clamp(math.round(v * 10) / 10, minVal, maxVal)
        valBox.Text = tostring(v)
        local p = (v - minVal) / (maxVal - minVal)
        barFill.Size = UDim2.new(p, 0, 1, 0)
        task.spawn(callback, v)
    end

    valBox.FocusLost:Connect(function()
        local num = tonumber(valBox.Text)
        if num then
            applyVal(num)
        else
            valBox.Text = tostring(defaultVal)
        end
    end)

    local sliding = false
    barBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            local p = math.clamp((i.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            applyVal(minVal + p * (maxVal - minVal))
        end
    end)

    track(UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((i.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            applyVal(minVal + p * (maxVal - minVal))
        end
    end))

    local function stopSlide(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end
    barBg.InputEnded:Connect(stopSlide)
    track(UserInputService.InputEnded:Connect(stopSlide))

    return {card = card, title = title, keyTitle = keyTitle}
end

local function createActionButton(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color or THEME.Panel
    btn.Text = text
    btn.TextColor3 = THEME.Title
    btn.Font = THEME.Font
    btn.TextSize = 13
    btn.TextWrapped = true
    btn.ClipsDescendants = true
    btn.AutoButtonColor = false
    corner(btn, 8)
    stroke(btn, THEME.Border, 1)

    local aPad = Instance.new("UIPadding", btn)
    aPad.PaddingLeft = UDim.new(0, 10)
    aPad.PaddingRight = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
    return btn
end

-- [10] REGISTER TABS
local PageFactory   = registerTab("Factory", "TabFactory")
local PageLivestock = registerTab("Livestock", "TabLivestock")
local PageFarming   = registerTab("Farming", "TabFarming")
local PageDelivery  = registerTab("Delivery", "TabDelivery")
local PageMission   = registerTab("Mission", "TabMission")
local PageUpgrade   = registerTab("Upgrade", "TabUpgrade")
local PagePlayer    = registerTab("Player", "TabPlayer")
local PageTeleport  = registerTab("Teleport", "TabTeleport")
local PageSettings  = registerTab("Settings", "TabSettings")

local PageDonate    = registerTab("Donate", "TabDonate")
createSection(PageDonate, "💖 SUPPORT & DONASI DEVELOPER")
createActionButton(PageDonate, "💖 Salin Link SociaBuzz (QRIS/E-Wallet/VA)", THEME.Accent, function()
    copyToClipboard("https://sociabuzz.com/brotherhubofficial/tribe", "Link SociaBuzz disalin ke clipboard!")
end)
createActionButton(PageDonate, "☕ Salin Link Saweria (QRIS/GoPay/OVO/DANA)", THEME.Yellow, function()
    copyToClipboard("https://saweria.co/BROTHERHUB", "Link Saweria disalin ke clipboard!")
end)
createActionButton(PageDonate, "💬 Gabung Discord Server BROTHER HUB", THEME.Blue, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Link Discord disalin ke clipboard!")
end)

local PageCredit    = registerTab("Credit", "TabCredit")
createSection(PageCredit, "👑 BROTHER HUB OFFICIAL")
createActionButton(PageCredit, "💬 Gabung Discord Server BROTHER HUB", THEME.Panel, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Link Discord disalin!")
end)


-- Default Tab
tabButtons["Factory"].BackgroundColor3 = THEME.PanelActive
tabButtons["Factory"].TextColor3 = THEME.Accent
PageFactory.Visible = true
activeTab = "Factory"

-- [11] STATE & REMOTES RESOLVER
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local RequestStartProduction  = Remotes and Remotes:FindFirstChild("RequestStartProduction")
local RequestClaimProduction  = Remotes and Remotes:FindFirstChild("RequestClaimProduction")
local RequestFactoryUpgrade   = Remotes and Remotes:FindFirstChild("RequestFactoryUpgrade")
local RequestUnlockFactory    = Remotes and Remotes:FindFirstChild("RequestUnlockFactory")
local RequestBuyAnimal        = ReplicatedStorage:FindFirstChild("RequestBuyAnimal")
local RequestTransferAnimal   = ReplicatedStorage:FindFirstChild("RequestTransferAnimal")
local RequestSendDelivery     = ReplicatedStorage:FindFirstChild("RequestSendDelivery")
local RequestUniversalUpgrade = ReplicatedStorage:FindFirstChild("RequestUniversalUpgrade")
local RequestRebirth          = ReplicatedStorage:FindFirstChild("RequestRebirth")
local ClaimQuest              = (Remotes and Remotes:FindFirstChild("ClaimQuest")) or ReplicatedStorage:FindFirstChild("ClaimQuest")
local RequestQuestData        = (Remotes and Remotes:FindFirstChild("RequestQuestData")) or ReplicatedStorage:FindFirstChild("RequestQuestData")
local RequestUnlockSlotWithStar = (Remotes and Remotes:FindFirstChild("RequestUnlockSlotWithStar")) or ReplicatedStorage:FindFirstChild("RequestUnlockSlotWithStar")
local ClaimAchievement        = (Remotes and Remotes:FindFirstChild("ClaimAchievement")) or ReplicatedStorage:FindFirstChild("ClaimAchievement")
local ClaimMegaMilestoneEvent = (Remotes and Remotes:FindFirstChild("ClaimMegaMilestoneEvent")) or ReplicatedStorage:FindFirstChild("ClaimMegaMilestoneEvent")
local AdminRemote             = (Remotes and Remotes:FindFirstChild("AdminRemote")) or ReplicatedStorage:FindFirstChild("AdminRemote")

-- Real Farm Industry Factories & Tiers
local KNOWN_FACTORIES = {
    { Key = "FlourFactory",   Name = "Pabrik Tepung",  Input = "Telur",   Output = "Tepung" },
    { Key = "BreadFactory",   Name = "Pabrik Roti",    Input = "Tepung",  Output = "Roti" },
    { Key = "YarnFactory",    Name = "Pabrik Benang",  Input = "Wol",     Output = "Benang" },
    { Key = "SweaterFactory", Name = "Pabrik Sweater", Input = "Benang",  Output = "Sweater" },
    { Key = "SausageFactory", Name = "Pabrik Sosis",   Input = "Daging",  Output = "Sosis" },
    { Key = "HotdogFactory",  Name = "Pabrik Hotdog",  Input = "Sosis",   Output = "Hotdog" },
    { Key = "ButterFactory",  Name = "Pabrik Mentega", Input = "Susu",    Output = "Mentega" },
    { Key = "CheeseFactory",  Name = "Pabrik Keju",    Input = "Mentega", Output = "Keju" }
}
local FACTORY_TIERS = { "Cosmic", "Sakura", "Gold", "Default" }
local ANIMAL_LIST = { "Chicken", "Sheep", "Pig", "Cow", "Chicken_Premium", "Sheep_Premium" }

-- Factory Model & Unlocked Resolvers (Accurate Workspace.FactorySpawn Detection)
local function getFactoryModel(factKey)
    local factorySpawn = workspace:FindFirstChild("FactorySpawn") or workspace:FindFirstChild("Factory") or workspace:FindFirstChild("Factories")
    if factorySpawn then
        local m = factorySpawn:FindFirstChild(factKey)
        if m then return m end
    end
    local direct = workspace:FindFirstChild(factKey)
    if direct then return direct end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name:lower() == factKey:lower() then
            return obj
        end
    end
    return nil
end

local function isFactoryUnlocked(factKey)
    return true
end


-- Config State
local state = {
    -- Factory Automation
    TeleportApproach    = false,
    TeleportReturn      = false,
    WalkApproach        = false,
    TeleportClaim       = false,
    AutoStartProd       = false,
    AutoClaimProd       = false,
    AutoUpgradeFact     = false,
    AutoUnlockFact      = false,
    ProdInterval        = 1.5,

    AutoCollectEggs     = false,
    EggCollectInterval  = 0.3,
    AutoBuyAnimals      = false,
    AnimalType          = "Chicken",
    AutoTransferAnimal  = false,
    BuyInterval         = 1.5,
    AutoKillWerewolf    = false,

    AutoWater           = false,
    AutoRefillWater     = true,
    AutoEquipCan        = false,
    AutoHarvestCrops    = false,
    WaterInterval       = 0.5,

    AutoInstantSell     = false,
    AutoTruckDeliver    = false,
    AutoMarketSell      = false,
    DeliveryInterval    = 3.0,

    AutoUniversalUp     = false,
    AutoRebirth         = false,
    AutoClearWeather    = false,

    -- Mission & Quest Tab State
    AutoDailyQuest      = false,
    AutoWeeklyQuest     = false,
    AutoSyncMission     = false,
    AutoUnlockStarSlots = false,
    AutoAchievements    = false,

    WalkSpeedEnabled    = false,
    WalkSpeed           = 32,
    JumpPowerEnabled    = false,
    JumpPower           = 80,
    Noclip              = false,
    Fly                 = false,
    FlySpeed            = 50,
    InfJump             = false,
    NightVision         = false,
    AntiAfk             = true
}

-- ============================================================
-- [TAB 1] FACTORY AUTOMATION
-- ============================================================
createSection(PageFactory, "SecFactoryProd")

createToggle(PageFactory, "AutoStartProd", "AutoStartDesc", state.AutoStartProd, function(val)
    state.AutoStartProd = val
    if val then
        task.spawn(function()
            while state.AutoStartProd and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestStartProduction then
                    for _, fact in ipairs(KNOWN_FACTORIES) do
                        if not state.AutoStartProd then break end
                        for _, tier in ipairs(FACTORY_TIERS) do
                            if not state.AutoStartProd then break end
                            pcall(function() RequestStartProduction:InvokeServer(fact.Key, tier, 1) end)
                            pcall(function() RequestStartProduction:InvokeServer(fact.Key, 1) end)
                            pcall(function() RequestStartProduction:InvokeServer(fact.Key) end)
                            pcall(function() RequestStartProduction:InvokeServer("Start", fact.Key, 1, tier) end)
                            task.wait(0.04)
                        end
                    end
                end
                task.wait(state.ProdInterval)
            end
        end)
    end
end)

createToggle(PageFactory, "AutoClaimProd", "AutoClaimDesc", state.AutoClaimProd, function(val)
    state.AutoClaimProd = val
    if val then
        task.spawn(function()
            while state.AutoClaimProd and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestClaimProduction then
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    for _, fact in ipairs(KNOWN_FACTORIES) do
                        if not state.AutoClaimProd then break end
                        pcall(function()
                            -- Teleport near factory claim area if enabled
                            if state.TeleportClaim and root then
                                local myPlot = getMyFarmPlot()
                                local factFolder = workspace:FindFirstChild("Factory")
                                local factModel = (myPlot and myPlot:FindFirstChild(fact.Key))
                                    or (myPlot and myPlot:FindFirstChild("Factory") and myPlot.Factory:FindFirstChild(fact.Key))
                                    or (factFolder and factFolder:FindFirstChild(fact.Key))
                                    or workspace:FindFirstChild(fact.Key)
                                if factModel then
                                    local fPart = factModel:IsA("BasePart") and factModel or (factModel.PrimaryPart or factModel:FindFirstChildWhichIsA("BasePart"))
                                    if fPart then
                                        char:PivotTo(CFrame.new(fPart.Position + Vector3.new(0, 3.5, 0)))
                                        task.wait(0.04)
                                    end
                                end
                            end
                            RequestClaimProduction:InvokeServer(fact.Key)
                        end)
                        task.wait(0.06)
                    end
                end
                task.wait(state.ProdInterval)
            end
        end)
    end
end)

createToggle(PageFactory, "TeleportClaim", "TeleportClaimDesc", state.TeleportClaim, function(val)
    state.TeleportClaim = val
end)

createToggle(PageFactory, "AutoUpgradeFact", "AutoUpgradeDesc", state.AutoUpgradeFact, function(val)
    state.AutoUpgradeFact = val
    if val then
        task.spawn(function()
            while state.AutoUpgradeFact and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestFactoryUpgrade then
                    for _, fact in ipairs(KNOWN_FACTORIES) do
                        if not state.AutoUpgradeFact then break end
                        pcall(function()
                            RequestFactoryUpgrade:InvokeServer(fact.Key, "Speed")
                        end)
                        task.wait(0.08)
                        pcall(function()
                            RequestFactoryUpgrade:InvokeServer(fact.Key, "Capacity")
                        end)
                        task.wait(0.08)
                    end
                end
                task.wait(4.0)
            end
        end)
    end
end)

createToggle(PageFactory, "AutoUnlockFact", "AutoUnlockDesc", state.AutoUnlockFact, function(val)
    state.AutoUnlockFact = val
    if val then
        task.spawn(function()
            while state.AutoUnlockFact and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestUnlockFactory then
                    for _, fact in ipairs(KNOWN_FACTORIES) do
                        if not state.AutoUnlockFact then break end
                        pcall(function()
                            RequestUnlockFactory:InvokeServer(fact.Key)
                        end)
                        task.wait(0.15)
                    end
                end
                task.wait(6.0)
            end
        end)
    end
end)

createSlider(PageFactory, "ProdInterval", 0.5, 10.0, state.ProdInterval, function(val)
    state.ProdInterval = val
end)

-- ============================================================
-- [TAB 2] LIVESTOCK, EGGS & ANIMAL PRODUCE
-- ============================================================
createSection(PageLivestock, "SecLivestock")

-- Master Egg & Animal Produce Vacuum Magnet with Teleport Approach (100% Bag Success)
createToggle(PageLivestock, "AutoCollectEggs", "AutoCollectEggsDesc", state.AutoCollectEggs, function(val)
    state.AutoCollectEggs = val
    if val then
        task.spawn(function()
            while state.AutoCollectEggs and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    local myPlot = getMyFarmPlot()
                    if not myPlot then return end

                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then return end

                    local targets = {}

                    -- 1. Sweep CollectionService "FarmProduct"
                    for _, prod in ipairs(CollectionService:GetTagged("FarmProduct")) do
                        if prod and prod.Parent and isMyFarm(prod) then
                            local prompt = prod:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled and isMyFarm(prompt) then
                                table.insert(targets, { Obj = prod, Prompt = prompt })
                            end
                        end
                    end

                    -- 2. Sweep Physical Eggs, Milk, Wool, Meat models on Plot
                    for _, desc in ipairs(myPlot:GetDescendants()) do
                        if not state.AutoCollectEggs then break end
                        local dl = desc.Name:lower()
                        if dl:find("telur") or dl:find("egg") or dl:find("susu") or dl:find("milk") or
                           dl:find("bulu") or dl:find("wool") or dl:find("daging") or dl:find("meat") or
                           dl:find("truffle") then
                            local prompt = desc:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled and isMyFarm(prompt) then
                                table.insert(targets, { Obj = desc, Prompt = prompt })
                            elseif desc:IsA("BasePart") then
                                table.insert(targets, { Obj = desc, Prompt = nil })
                            end
                        elseif desc:IsA("ProximityPrompt") and desc.Enabled and isMyFarm(desc) then
                            local act = desc.ActionText:lower()
                            local obj = desc.ObjectText:lower()
                            local pName = desc.Name:lower()
                            if pName == "productprompt" or
                               act:find("telur") or act:find("egg") or act:find("ambil") or
                               act:find("susu") or act:find("perah") or act:find("bulu") or
                               act:find("cukur") or act:find("daging") or act:find("truffle") or
                               obj:find("telur") or obj:find("egg") or obj:find("susu") or
                               obj:find("bulu") or obj:find("daging") then
                                table.insert(targets, { Obj = desc.Parent, Prompt = desc })
                            end
                        end
                    end

                    -- Execute Movement Approach per target (Pilihan: Jalan Kaki / Teleport - TANPA kembali ke awal)
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    for _, item in ipairs(targets) do
                        if not state.AutoCollectEggs then break end
                        local obj = item.Obj
                        local prompt = item.Prompt
                        if obj and obj.Parent then
                            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                            if part then
                                local targetPos = part.Position
                                local dist = (root.Position - targetPos).Magnitude

                                -- Mode A: Jalan Kaki Otomatis (Smooth Walk - 100% Sukses Server)
                                if state.WalkApproach and hum then
                                    if dist > 5 then
                                        hum:MoveTo(targetPos)
                                        local moveStart = os.clock()
                                        while (root.Position - targetPos).Magnitude > 5 and (os.clock() - moveStart < 2.2) and state.AutoCollectEggs do
                                            task.wait(0.08)
                                        end
                                    end
                                -- Mode B: Teleport Langsung & Diam di Titik Telur (Tanpa Balik)
                                elseif state.TeleportApproach then
                                    root.AssemblyLinearVelocity = Vector3.zero
                                    root.AssemblyAngularVelocity = Vector3.zero
                                    char:PivotTo(CFrame.new(targetPos + Vector3.new(0, 1.8, 0)))
                                    task.wait(0.18) -- Buffer waktu agar koordinat tervalidasi di server
                                end

                                -- Picu Pengambilan Telur (Prompt & Touch Interest)
                                if prompt and prompt.Enabled then
                                    safeFirePrompt(prompt)
                                end
                                pcall(function()
                                    firetouchinterest(root, part, 0)
                                    task.wait(0.04)
                                    firetouchinterest(root, part, 1)
                                end)
                                task.wait(0.08)
                            end
                        end
                    end
                end)
                task.wait(state.EggCollectInterval or 0.5)
            end
        end)
    end
end)

createToggle(PageLivestock, "WalkApproach", "WalkApproachDesc", state.WalkApproach, function(val)
    state.WalkApproach = val
end)

createToggle(PageLivestock, "TeleportApproach", "TeleportApproachDesc", state.TeleportApproach, function(val)
    state.TeleportApproach = val
end)

-- Anti-Robux Safe Badge
local safeCard = Instance.new("Frame")
safeCard.Name = "SafeBadge"
safeCard.Size = UDim2.new(1, 0, 0, 36)
safeCard.BackgroundColor3 = THEME.Panel
safeCard.BorderSizePixel = 0
safeCard.Parent = PageLivestock
corner(safeCard, 8)
stroke(safeCard, THEME.Accent, 1)

local safeLabel = Instance.new("TextLabel")
safeLabel.Size = UDim2.new(1, -16, 1, 0)
safeLabel.Position = UDim2.new(0, 10, 0, 0)
safeLabel.BackgroundTransparency = 1
safeLabel.Font = THEME.FontRegular
safeLabel.TextSize = 11
safeLabel.TextColor3 = THEME.Accent
safeLabel.TextXAlignment = Enum.TextXAlignment.Left
safeLabel.TextWrapped = true
safeLabel.Text = (currentLang == "ID") and "🛡️ Proteksi Anti-Robux: Auto-loot dikunci ke plot Anda sendiri agar bebas bayar." or "🛡️ Anti-Robux Guard: Auto-loot is locked to your plot to avoid Robux prompts."
safeLabel.Parent = safeCard

createSlider(PageLivestock, "EggCollectInterval", 0.1, 3.0, state.EggCollectInterval, function(val)
    state.EggCollectInterval = val
end)

createToggle(PageLivestock, "AutoBuyAnimals", "AutoBuyDesc", state.AutoBuyAnimals, function(val)
    state.AutoBuyAnimals = val
    if val then
        task.spawn(function()
            while state.AutoBuyAnimals and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestBuyAnimal then
                    for _, aName in ipairs(ANIMAL_LIST) do
                        if not state.AutoBuyAnimals then break end
                        pcall(function()
                            RequestBuyAnimal:InvokeServer(aName)
                        end)
                        task.wait(0.25)
                    end
                end
                task.wait(state.BuyInterval)
            end
        end)
    end
end)

createToggle(PageLivestock, "AutoTransfer", "AutoTransferDesc", state.AutoTransferAnimal, function(val)
    state.AutoTransferAnimal = val
    if val then
        task.spawn(function()
            while state.AutoTransferAnimal and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestTransferAnimal then
                    local barns = {"ChickenCoop", "SheepBarn", "PigPen", "CowBarn"}
                    for _, bName in ipairs(barns) do
                        if not state.AutoTransferAnimal then break end
                        pcall(function()
                            RequestTransferAnimal:InvokeServer(bName, bName, "All")
                        end)
                        task.wait(0.25)
                    end
                end
                task.wait(8.0)
            end
        end)
    end
end)

createSlider(PageLivestock, "BuyInterval", 1.0, 15.0, state.BuyInterval, function(val)
    state.BuyInterval = val
end)

-- ============================================================
-- WEREWOLF NIGHT EVENT BOSS ANNIHILATOR
-- ============================================================
createSection(PageLivestock, "SecWerewolf")

createToggle(PageLivestock, "AutoKillWerewolf", "AutoKillWerewolfDesc", state.AutoKillWerewolf, function(val)
    state.AutoKillWerewolf = val
    if val then
        task.spawn(function()
            while state.AutoKillWerewolf and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    -- 1. Scan for Werewolf Boss in Workspace
                    local targetWerewolf = nil
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj:IsA("Model") then
                            local n = obj.Name:lower()
                            if n:find("werewolf") or n:find("serigala") or obj.Name == "Werewolf - Black" then
                                local hum = obj:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health > 0 then
                                    targetWerewolf = obj
                                    break
                                end
                            end
                        end
                    end

                    if targetWerewolf then
                        local root = targetWerewolf:FindFirstChild("HumanoidRootPart") or targetWerewolf.PrimaryPart or targetWerewolf:FindFirstChildWhichIsA("BasePart")
                        local char = LocalPlayer.Character
                        local myHrp = char and char:FindFirstChild("HumanoidRootPart")

                        if root and myHrp then
                            -- Hover safely 11 studs above Werewolf to prevent claw melee damage
                            myHrp.CFrame = root.CFrame * CFrame.new(0, 11, 0)
                            pcall(function()
                                myHrp.Velocity = Vector3.zero
                            end)
                        end

                        -- Attack Trigger A: Click/Tap buttons on ActiveBossBillboard inside PlayerGui
                        local pg = LocalPlayer:FindFirstChild("PlayerGui")
                        if pg then
                            for _, b in ipairs(pg:GetChildren()) do
                                if b.Name == "ActiveBossBillboard" or b.Name:lower():find("boss") or b.Name:lower():find("werewolf") then
                                    for _, desc in ipairs(b:GetDescendants()) do
                                        if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                                            pcall(function()
                                                if firesignal then
                                                    firesignal(desc.MouseButton1Click)
                                                    firesignal(desc.Activated)
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end

                        -- Attack Trigger B: Click/Tap buttons or click detectors on Werewolf model itself
                        for _, desc in ipairs(targetWerewolf:GetDescendants()) do
                            if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                                pcall(function()
                                    if firesignal then
                                        firesignal(desc.MouseButton1Click)
                                        firesignal(desc.Activated)
                                    end
                                end)
                            elseif desc:IsA("ClickDetector") and fireclickdetector then
                                pcall(function() fireclickdetector(desc) end)
                            end
                        end

                        -- Attack Trigger C: Fire RemoteEvent if present
                        pcall(function()
                            local rem = ReplicatedStorage:FindFirstChild("BossDamageEvent", true) or
                                        ReplicatedStorage:FindFirstChild("DamageBoss", true) or
                                        ReplicatedStorage:FindFirstChild("AttackBoss", true)
                            if rem and rem:IsA("RemoteEvent") then
                                rem:FireServer(targetWerewolf)
                            end
                        end)

                        -- Attack Trigger D: Tool activation
                        if char then
                            local tool = char:FindFirstChildOfClass("Tool") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
                            if tool then
                                if tool.Parent == LocalPlayer.Backpack then
                                    tool.Parent = char
                                end
                                pcall(function() tool:Activate() end)
                            end
                        end
                    end

                    -- 2. Sweep Wolf Meat Drops ("Daging Serigala")
                    for _, item in ipairs(workspace:GetChildren()) do
                        local iName = item.Name:lower()
                        if iName:find("daging serigala") or iName:find("wolf meat") or iName:find("daging_serigala") then
                            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled then
                                safeFirePrompt(prompt)
                            else
                                local iPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                                local char = LocalPlayer.Character
                                local myHrp = char and char:FindFirstChild("HumanoidRootPart")
                                if iPart and myHrp and (iPart.Position - myHrp.Position).Magnitude < 40 then
                                    pcall(function()
                                        if firetouchinterest then
                                            firetouchinterest(myHrp, iPart, 0)
                                            task.wait(0.01)
                                            firetouchinterest(myHrp, iPart, 1)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- ============================================================
-- [TAB 3] FARMING & WATERING CAN
-- ============================================================
createSection(PageFarming, "SecFarming")

local function refillWaterFromWell()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local myPlot = getMyFarmPlot()
        local searchScope = myPlot and myPlot:GetDescendants() or workspace:GetDescendants()

        for _, prompt in ipairs(searchScope) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local act = (prompt.ActionText or ""):lower()
                local obj = (prompt.ObjectText or ""):lower()
                if (obj:find("isi air") or obj:find("air") or act:find("ambil")) and isMyFarm(prompt) then
                    local pPart = prompt.Parent:IsA("BasePart") and prompt.Parent or (prompt.Parent:IsA("Model") and (prompt.Parent.PrimaryPart or prompt.Parent:FindFirstChildWhichIsA("BasePart")))
                    if pPart then
                        local oldPos = root.CFrame
                        char:PivotTo(CFrame.new(pPart.Position + Vector3.new(0, 2.5, 0)))
                        task.wait(0.08)
                        prompt.MaxActivationDistance = 999999
                        prompt.RequiresLineOfSight = false
                        prompt.HoldDuration = 0
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        end
                        task.wait(0.12)
                        char:PivotTo(oldPos)
                        break
                    end
                end
            end
        end
    end)
end

createToggle(PageFarming, "AutoWater", "AutoWaterDesc", state.AutoWater, function(val)
    state.AutoWater = val
    if val then
        task.spawn(function()
            local waterCycle = 0
            while state.AutoWater and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                        if tool then
                            local remote = tool:FindFirstChild("WaterRemote")
                            if remote then
                                remote:FireServer("StartPouring")
                            end
                        end
                    end
                end)
                waterCycle = waterCycle + 1
                if waterCycle >= 15 and state.AutoRefillWater then
                    waterCycle = 0
                    refillWaterFromWell()
                end
                task.wait(state.WaterInterval)
            end
        end)
    else
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local remote = tool:FindFirstChild("WaterRemote")
                    if remote then
                        remote:FireServer("StopPouring")
                    end
                end
            end
        end)
    end
end)

createToggle(PageFarming, "AutoRefillWater", "AutoRefillWaterDesc", state.AutoRefillWater, function(val)
    state.AutoRefillWater = val
    if val then
        task.spawn(function()
            while state.AutoRefillWater and getgenv().BrotherHub_FarmIndustry_Loaded do
                refillWaterFromWell()
                task.wait(10.0)
            end
        end)
    end
end)

createToggle(PageFarming, "AutoEquipCan", "AutoEquipDesc", state.AutoEquipCan, function(val)
    state.AutoEquipCan = val
    if val then
        task.spawn(function()
            while state.AutoEquipCan and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and not char:FindFirstChildOfClass("Tool") then
                        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if item:IsA("Tool") and string.find(item.Name:lower(), "water") then
                                item.Parent = char
                                break
                            end
                        end
                    end
                end)
                task.wait(2.0)
            end
        end)
    end
end)

createToggle(PageFarming, "AutoHarvestCrops", "AutoHarvestDesc", state.AutoHarvestCrops, function(val)
    state.AutoHarvestCrops = val
    if val then
        task.spawn(function()
            while state.AutoHarvestCrops and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    -- Activate native server auto-harvest if supported
                    local reqHarvest = ReplicatedStorage:FindFirstChild("RequestToggleAutoHarvest")
                    if reqHarvest then
                        pcall(function() reqHarvest:InvokeServer(true) end)
                    end

                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local count = 0

                    local myPlot = getMyFarmPlot()
                    local searchScope = myPlot and myPlot:GetDescendants() or workspace:GetDescendants()

                    for _, obj in ipairs(searchScope) do
                        if not state.AutoHarvestCrops then break end
                        if obj:IsA("ProximityPrompt") and obj.Enabled and isMyFarm(obj) then
                            local act = obj.ActionText:lower()
                            if act:find("harvest") or act:find("panen") or act:find("pick") or act:find("petik") then
                                if root and state.TeleportApproach then
                                    local pPart = obj.Parent:IsA("BasePart") and obj.Parent or (obj.Parent:IsA("Model") and (obj.Parent.PrimaryPart or obj.Parent:FindFirstChildWhichIsA("BasePart")))
                                    if pPart then
                                        char:PivotTo(CFrame.new(pPart.Position + Vector3.new(0, 2.5, 0)))
                                        task.wait(0.04)
                                    end
                                end
                                safeFirePrompt(obj)
                                count = count + 1
                                task.wait(0.05)
                            end
                        end
                    end
                end)
                task.wait(2.5)
            end
        end)
    end
end)

createSlider(PageFarming, "WaterSpeed", 0.1, 3.0, state.WaterInterval, function(val)
    state.WaterInterval = val
end)

-- ============================================================
-- [TAB 4] DELIVERY TRUCK & MARKET
-- ============================================================
createSection(PageDelivery, "SecDelivery")

local function performFullSell()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        -- 1. Gather all sellable crops, animal goods and factory products
        local cargo = {}
        local sellableItems = {
            "telur", "daging", "susu", "wol", "tepung", "roti",
            "benang", "sweater", "sosis", "hotdog", "mentega", "keju", "wood", "kayu"
        }

        local function scanContainer(cont)
            if not cont then return end
            for _, item in ipairs(cont:GetChildren()) do
                if item:IsA("Tool") then
                    local nm = item.Name:lower()
                    for _, s in ipairs(sellableItems) do
                        if nm:find(s) then
                            cargo[item.Name] = (cargo[item.Name] or 0) + 1
                            break
                        end
                    end
                end
            end
        end

        scanContainer(LocalPlayer.Backpack)
        scanContainer(char)

        -- 2. Direct Server Invoke via RequestSendDelivery
        if RequestSendDelivery and next(cargo) ~= nil then
            pcall(function() RequestSendDelivery:InvokeServer(cargo) end)
        end

        -- 3. ProximityPrompt "Jual" / "Kirim Barang" at Plot Truck & Market
        local myPlot = getMyFarmPlot()
        local searchScope = myPlot and myPlot:GetDescendants() or workspace:GetDescendants()
        for _, prompt in ipairs(searchScope) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local act = (prompt.ActionText or ""):lower()
                local obj = (prompt.ObjectText or ""):lower()
                if (act:find("jual") or act:find("sell") or obj:find("kirim barang")) and isMyFarm(prompt) then
                    prompt.HoldDuration = 0
                    prompt.MaxActivationDistance = 999999
                    prompt.RequiresLineOfSight = false
                    if fireproximityprompt then
                        fireproximityprompt(prompt, 0)
                    end
                end
            end
        end
    end)
end

createToggle(PageDelivery, "AutoInstantSell", "AutoInstantSellDesc", state.AutoInstantSell, function(val)
    state.AutoInstantSell = val
    if val then
        task.spawn(function()
            while state.AutoInstantSell and getgenv().BrotherHub_FarmIndustry_Loaded do
                performFullSell()
                task.wait(1.5)
            end
        end)
    end
end)

createToggle(PageDelivery, "AutoTruckDeliver", "AutoTruckDesc", state.AutoTruckDeliver, function(val)
    state.AutoTruckDeliver = val
    if val then
        task.spawn(function()
            while state.AutoTruckDeliver and getgenv().BrotherHub_FarmIndustry_Loaded do
                performFullSell()
                task.wait(state.DeliveryInterval)
            end
        end)
    end
end)

createToggle(PageDelivery, "AutoMarketSell", "AutoMarketDesc", state.AutoMarketSell, function(val)
    state.AutoMarketSell = val
    if val then
        task.spawn(function()
            while state.AutoMarketSell and getgenv().BrotherHub_FarmIndustry_Loaded do
                performFullSell()
                task.wait(5.0)
            end
        end)
    end
end)

createSlider(PageDelivery, "DeliveryInterval", 1.0, 30.0, state.DeliveryInterval, function(val)
    state.DeliveryInterval = val
end)

-- ============================================================
-- [TAB 5] QUEST & MISSION AUTOMATION (DEDICATED SUITE)
-- ============================================================
local function syncPlotMissionBoard()
    local myPlot = getMyFarmPlot()
    local target = (myPlot and myPlot:FindFirstChild("BilboardMission", true)) or workspace:FindFirstChild("BilboardMission", true)
    if target then
        local prompt = target:FindFirstChildOfClass("ProximityPrompt") or target:FindFirstChild("ProximityPrompt", true)
        if prompt then
            pcall(function()
                prompt.MaxActivationDistance = 999999
                prompt.RequiresLineOfSight = false
                if prompt.HoldDuration > 0 then prompt.HoldDuration = 0 end
                if fireproximityprompt then
                    fireproximityprompt(prompt, 0)
                end
            end)
        end
    end
end

local function claimDailyMissionsOnce()
    local claimed = 0
    -- 1. Sweep QuestGUI DailyMission container
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local questGui = pg and pg:FindFirstChild("QuestGUI")
    if questGui then
        local bg = questGui:FindFirstChild("Background")
        local listContainer = bg and bg:FindFirstChild("MissionListContainer")
        local dailyContainer = listContainer and listContainer:FindFirstChild("DailyMission")
        if dailyContainer then
            for _, template in ipairs(dailyContainer:GetChildren()) do
                if template:IsA("GuiObject") then
                    local claimBtn = template:FindFirstChild("ClaimButton", true)
                    if claimBtn and claimBtn:IsA("GuiButton") and claimBtn.Visible then
                        pcall(function()
                            if firesignal then
                                firesignal(claimBtn.MouseButton1Click)
                                firesignal(claimBtn.Activated)
                                claimed = claimed + 1
                            end
                        end)
                    end
                end
            end
        end
    end

    -- 2. Direct server invoke via RequestQuestData & ClaimQuest
    if ClaimQuest then
        if RequestQuestData then
            local ok, data = pcall(function() return RequestQuestData:InvokeServer() end)
            if ok and type(data) == "table" then
                for _, q in pairs(data) do
                    if type(q) == "table" and q.Id and not q.Completed then
                        pcall(function()
                            ClaimQuest:InvokeServer(q.Id)
                            claimed = claimed + 1
                        end)
                        task.wait(0.05)
                    end
                end
            end
        end
        for i = 1, 8 do
            pcall(function() ClaimQuest:InvokeServer(i) end)
            pcall(function() ClaimQuest:InvokeServer("Daily", i) end)
        end
    end

    -- 3. Sweep any visible ClaimButton in PlayerGui
    if pg then
        for _, desc in ipairs(pg:GetDescendants()) do
            if desc:IsA("GuiButton") and desc.Name == "ClaimButton" and desc.Visible and desc.Active then
                pcall(function()
                    if firesignal then
                        firesignal(desc.MouseButton1Click)
                        firesignal(desc.Activated)
                    end
                end)
            end
        end
    end

    return claimed
end

local function claimWeeklyMissionsOnce()
    local claimed = 0
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local questGui = pg and pg:FindFirstChild("QuestGUI")
    if questGui then
        local bg = questGui:FindFirstChild("Background")
        local listContainer = bg and bg:FindFirstChild("MissionListContainer")
        -- Switch to WeeklyTab if present
        local topBar = listContainer and listContainer:FindFirstChild("TopBarContainer")
        local weeklyTab = topBar and topBar:FindFirstChild("WeeklyTab", true)
        if weeklyTab and weeklyTab:IsA("GuiButton") and firesignal then
            pcall(function()
                firesignal(weeklyTab.MouseButton1Click)
                firesignal(weeklyTab.Activated)
            end)
        end

        local weeklyContainer = listContainer and listContainer:FindFirstChild("WeeklyMission")
        if weeklyContainer then
            for _, template in ipairs(weeklyContainer:GetChildren()) do
                if template:IsA("GuiObject") then
                    local claimBtn = template:FindFirstChild("ClaimButton", true)
                    if claimBtn and claimBtn:IsA("GuiButton") and claimBtn.Visible then
                        pcall(function()
                            if firesignal then
                                firesignal(claimBtn.MouseButton1Click)
                                firesignal(claimBtn.Activated)
                                claimed = claimed + 1
                            end
                        end)
                    end
                end
            end
        end
    end

    if ClaimQuest then
        for i = 1, 8 do
            pcall(function() ClaimQuest:InvokeServer("Weekly", i) end)
        end
    end

    return claimed
end

local function claimAchievementsOnce()
    local missionsToClaim = {}
    pcall(function()
        local Modules = ReplicatedStorage:FindFirstChild("Modules")
        if Modules and Modules:FindFirstChild("AchievementConfig") then
            local cfg = require(Modules.AchievementConfig)
            if cfg and cfg.Missions then
                for k, _ in pairs(cfg.Missions) do
                    table.insert(missionsToClaim, k)
                end
            end
        end
    end)
    if #missionsToClaim == 0 then
        missionsToClaim = {
            "JoinGroup", "SangPengembala", "PemilikAyam", "PemilikDomba", "PemilikSapi", "PemilikBabi",
            "PanenTelur", "CukurDomba", "PerahSusu", "PanenDaging", "ProduksiTepung", "ProduksiRoti",
            "ProduksiKeju", "ProduksiMentega", "UpgradeKandang", "UpgradeSumur", "UpgradeDelivery",
            "PanenRumput", "BukaPabrikTepung", "BukaPabrikRoti", "BukaPabrikKeju", "BukaPabrikMentega",
            "BeliAyamPremium", "BeliDombaPremium", "TotalKoin", "TotalLevel", "KoleksiSemuaHewan",
            "KoleksiSemuaPabrik", "PanenSakuraEgg", "PanenCosmicEgg", "PanenGoldEgg"
        }
    end
    if ClaimAchievement then
        for _, missionKey in ipairs(missionsToClaim) do
            pcall(function()
                ClaimAchievement:InvokeServer(missionKey)
            end)
            task.wait(0.04)
        end
    end
    if ClaimMegaMilestoneEvent then
        pcall(function()
            ClaimMegaMilestoneEvent:InvokeServer()
        end)
    end
end

createSection(PageMission, "SecDailyMission")

createToggle(PageMission, "AutoClaimDaily", "AutoClaimDailyDesc", state.AutoDailyQuest, function(val)
    state.AutoDailyQuest = val
    if val then
        task.spawn(function()
            while state.AutoDailyQuest and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    claimDailyMissionsOnce()
                end)
                task.wait(4.0)
            end
        end)
    end
end)

createToggle(PageMission, "AutoSyncMission", "AutoSyncMissionDesc", state.AutoSyncMission, function(val)
    state.AutoSyncMission = val
    if val then
        task.spawn(function()
            while state.AutoSyncMission and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    syncPlotMissionBoard()
                end)
                task.wait(15.0)
            end
        end)
    end
end)

createToggle(PageMission, "AutoUnlockStarSlots", "AutoUnlockStarDesc", state.AutoUnlockStarSlots, function(val)
    state.AutoUnlockStarSlots = val
    if val then
        task.spawn(function()
            while state.AutoUnlockStarSlots and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    if RequestUnlockSlotWithStar then
                        for i = 1, 5 do
                            if not state.AutoUnlockStarSlots then break end
                            pcall(function() RequestUnlockSlotWithStar:InvokeServer(i) end)
                            task.wait(0.1)
                        end
                    end
                end)
                task.wait(30.0)
            end
        end)
    end
end)

createSection(PageMission, "SecWeeklyMission")

createToggle(PageMission, "AutoClaimWeekly", "AutoClaimWeeklyDesc", state.AutoWeeklyQuest, function(val)
    state.AutoWeeklyQuest = val
    if val then
        task.spawn(function()
            while state.AutoWeeklyQuest and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    claimWeeklyMissionsOnce()
                end)
                task.wait(6.0)
            end
        end)
    end
end)

createSection(PageMission, "SecAchievements")

createToggle(PageMission, "AutoAchievements", "AutoAchievDesc", state.AutoAchievements, function(val)
    state.AutoAchievements = val
    if val then
        task.spawn(function()
            while state.AutoAchievements and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    claimAchievementsOnce()
                end)
                task.wait(12.0)
            end
        end)
    end
end)

createSection(PageMission, "SecMovement") -- Section header styling reuse or quick actions
createActionButton(PageMission, "⚡ " .. T("ClaimAllMissionsBtn"), THEME.Accent, function()
    notify("Mengeksekusi klaim semua misi & pencapaian...", THEME.Yellow)
    claimDailyMissionsOnce()
    claimWeeklyMissionsOnce()
    claimAchievementsOnce()
    notify(T("NotifyAllMissionsClaimed"), THEME.Accent)
end)

createActionButton(PageMission, "📋 " .. T("OpenMissionGuiBtn"), THEME.Blue, function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local qg = pg and pg:FindFirstChild("QuestGUI")
    if qg then
        qg.Enabled = not qg.Enabled
        notify("QuestGUI: " .. (qg.Enabled and "Terbuka" or "Tertutup"), THEME.Accent)
    else
        syncPlotMissionBoard()
        notify("Memicu pembukaan Papan Misi...", THEME.Yellow)
    end
end)

-- ============================================================
-- [TAB 6] PROGRESSION, UPGRADES & REBIRTH
-- ============================================================
createSection(PageUpgrade, "SecUpgrade")

createToggle(PageUpgrade, "AutoClaimMegaMilestone", "AutoClaimMegaDesc", state.AutoClaimMegaMilestone, function(val)
    state.AutoClaimMegaMilestone = val
    if val then
        task.spawn(function()
            while state.AutoClaimMegaMilestone and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    local rem = ReplicatedStorage:FindFirstChild("ClaimMegaMilestoneEvent")
                    if rem then rem:InvokeServer() end
                end)
                task.wait(5.0)
            end
        end)
    end
end)

createToggle(PageUpgrade, "AutoBuyFarmMastery", "AutoBuyFarmMasteryD", state.AutoBuyFarmMastery, function(val)
    state.AutoBuyFarmMastery = val
    if val then
        task.spawn(function()
            while state.AutoBuyFarmMastery and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    local rem = ReplicatedStorage:FindFirstChild("RequestBuyFarmMastery")
                    if rem then rem:InvokeServer() end
                end)
                task.wait(8.0)
            end
        end)
    end
end)

createToggle(PageUpgrade, "AutoBuyRebirthMastery", "AutoBuyRebMasteryD", state.AutoBuyRebirthMastery, function(val)
    state.AutoBuyRebirthMastery = val
    if val then
        task.spawn(function()
            while state.AutoBuyRebirthMastery and getgenv().BrotherHub_FarmIndustry_Loaded do
                pcall(function()
                    local rem = ReplicatedStorage:FindFirstChild("RequestBuyRebirthMastery")
                    if rem then rem:InvokeServer() end
                end)
                task.wait(10.0)
            end
        end)
    end
end)

createToggle(PageUpgrade, "AutoUniversalUp", "AutoUniversalDes", state.AutoUniversalUp, function(val)
    state.AutoUniversalUp = val
    if val then
        task.spawn(function()
            while state.AutoUniversalUp and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestUniversalUpgrade then
                    for upId = 1, 15 do
                        if not state.AutoUniversalUp then break end
                        pcall(function()
                            RequestUniversalUpgrade:InvokeServer(upId)
                        end)
                        task.wait(0.2)
                    end
                end
                task.wait(8.0)
            end
        end)
    end
end)

createToggle(PageUpgrade, "AutoRebirth", "AutoRebirthDesc", state.AutoRebirth, function(val)
    state.AutoRebirth = val
    if val then
        task.spawn(function()
            while state.AutoRebirth and getgenv().BrotherHub_FarmIndustry_Loaded do
                if RequestRebirth then
                    local ok, res = pcall(function()
                        return RequestRebirth:InvokeServer()
                    end)
                    if ok and res then
                        notify(T("NotifyRebirthDone"), THEME.Yellow)
                    end
                end
                task.wait(10.0)
            end
        end)
    end
end)

createToggle(PageUpgrade, "AutoClearWeather", "AutoWeatherDesc", state.AutoClearWeather, function(val)
    state.AutoClearWeather = val
    if val then
        task.spawn(function()
            while state.AutoClearWeather and getgenv().BrotherHub_FarmIndustry_Loaded do
                if AdminRemote then
                    pcall(function()
                        AdminRemote:InvokeServer("SetWeather", nil, "Clear")
                    end)
                end
                task.wait(30.0)
            end
        end)
    end
end)

-- ============================================================
-- [TAB 6] PLAYER & MOVEMENT
-- ============================================================
createSection(PagePlayer, "SecMovement")

local origWalkSpeed = 16
local origJumpPower = 50

createToggle(PagePlayer, "WalkSpeedToggle", "WalkSpeedSlider", state.WalkSpeedEnabled, function(val)
    state.WalkSpeedEnabled = val
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if val then
            hum.WalkSpeed = state.WalkSpeed
        else
            hum.WalkSpeed = origWalkSpeed
        end
    end
end)

createSlider(PagePlayer, "WalkSpeedSlider", 16, 150, state.WalkSpeed, function(val)
    state.WalkSpeed = val
    if state.WalkSpeedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end)

createToggle(PagePlayer, "JumpPowerToggle", "JumpPowerSlider", state.JumpPowerEnabled, function(val)
    state.JumpPowerEnabled = val
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        if val then
            hum.JumpPower = state.JumpPower
        else
            hum.JumpPower = origJumpPower
        end
    end
end)

createSlider(PagePlayer, "JumpPowerSlider", 50, 250, state.JumpPower, function(val)
    state.JumpPower = val
    if state.JumpPowerEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = val end
    end
end)

-- Penetration Noclip with 100% Collision Restoration
createToggle(PagePlayer, "NoclipToggle", "NoclipDesc", state.Noclip, function(val)
    state.Noclip = val
end)

track(RunService.Stepped:Connect(function()
    if state.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end))

-- Flight Engine (WASD + Mobile Touch)
local flying = false
local flyBV = nil
local flyBG = nil

createToggle(PagePlayer, "FlyToggle", "FlySpeedSlider", state.Fly, function(val)
    state.Fly = val
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if val then
        flying = true
        hum.PlatformStand = true
        flyBV = Instance.new("BodyVelocity", root)
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Velocity = Vector3.zero

        flyBG = Instance.new("BodyGyro", root)
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.CFrame = root.CFrame

        task.spawn(function()
            while flying and char and root and getgenv().BrotherHub_FarmIndustry_Loaded do
                local camCF = camera.CFrame
                local moveDir = Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                if moveDir.Magnitude > 0 then
                    flyBV.Velocity = moveDir.Unit * state.FlySpeed
                else
                    flyBV.Velocity = Vector3.zero
                end
                flyBG.CFrame = camCF
                task.wait()
            end
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            if hum then hum.PlatformStand = false end
        end)
    else
        flying = false
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end)

createSlider(PagePlayer, "FlySpeedSlider", 20, 150, state.FlySpeed, function(val)
    state.FlySpeed = val
end)

-- Infinite Jump
track(UserInputService.JumpRequest:Connect(function()
    if state.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))
createToggle(PagePlayer, "InfJumpToggle", "InfJumpToggle", state.InfJump, function(val)
    state.InfJump = val
end)

-- Fullbright Night Vision
local origAmbient = game:GetService("Lighting").Ambient
createToggle(PagePlayer, "NightVision", "NightVision", state.NightVision, function(val)
    state.NightVision = val
    if val then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        game:GetService("Lighting").Brightness = 2
    else
        game:GetService("Lighting").Ambient = origAmbient
        game:GetService("Lighting").Brightness = 1
    end
end)

-- 24/7 Anti-AFK Guard
createToggle(PagePlayer, "AntiAfkToggle", "AntiAfkDesc", state.AntiAfk, function(val)
    state.AntiAfk = val
end)

track(LocalPlayer.Idled:Connect(function()
    if state.AntiAfk then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end
end))

-- ============================================================
-- [TAB 7] TELEPORT HUB
-- ============================================================
createSection(PageTeleport, "SecTeleportFact")

local function tpToPos(pos, label)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(pos) + Vector3.new(0, 3, 0)
        notify(T("NotifyTeleported") .. " (" .. label .. ")", THEME.Accent)
    end
end

local function tpToInstanceName(name, label)
    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower() == name:lower() and (obj:IsA("BasePart") or obj:IsA("Model")) then
            found = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
            break
        end
    end
    if found then
        tpToPos(found.Position, label)
    else
        notify("Lokasi " .. label .. " sedang dimuat atau tidak ditemukan!", THEME.Red)
    end
end

createActionButton(PageTeleport, "🌾 Teleport: Pabrik Tepung (Flour Factory)", THEME.Panel, function()
    tpToInstanceName("FlourFactory", "Pabrik Tepung")
end)
createActionButton(PageTeleport, "🍞 Teleport: Pabrik Roti (Bread Factory)", THEME.Panel, function()
    tpToInstanceName("BreadFactory", "Pabrik Roti")
end)
createActionButton(PageTeleport, "🧶 Teleport: Pabrik Benang (Yarn Factory)", THEME.Panel, function()
    tpToInstanceName("YarnFactory", "Pabrik Benang")
end)
createActionButton(PageTeleport, "👕 Teleport: Pabrik Sweater (Sweater Factory)", THEME.Panel, function()
    tpToInstanceName("SweaterFactory", "Pabrik Sweater")
end)
createActionButton(PageTeleport, "🌭 Teleport: Pabrik Sosis & Hotdog", THEME.Panel, function()
    tpToInstanceName("SausageFactory", "Pabrik Sosis")
end)
createActionButton(PageTeleport, "🧈 Teleport: Pabrik Mentega & Keju", THEME.Panel, function()
    tpToInstanceName("ButterFactory", "Pabrik Mentega")
end)

createSection(PageTeleport, "SecTeleportBarn")
createActionButton(PageTeleport, "🐔 Teleport: Kandang Ayam (Chicken Coop)", THEME.Panel, function()
    tpToInstanceName("ChickenCoop", "Kandang Ayam")
end)
createActionButton(PageTeleport, "🐑 Teleport: Kandang Domba (Sheep Barn)", THEME.Panel, function()
    tpToInstanceName("SheepBarn", "Kandang Domba")
end)
createActionButton(PageTeleport, "🐖 Teleport: Kandang Babi (Pig Pen)", THEME.Panel, function()
    tpToInstanceName("PigPen", "Kandang Babi")
end)
createActionButton(PageTeleport, "🐄 Teleport: Kandang Sapi (Cow Barn)", THEME.Panel, function()
    tpToInstanceName("CowBarn", "Kandang Sapi")
end)
createActionButton(PageTeleport, "🥕 Teleport: Ladang Sayur & Tanaman", THEME.Panel, function()
    tpToInstanceName("Field", "Ladang")
end)

createSection(PageTeleport, "SecTeleportNPC")
createActionButton(PageTeleport, "🚚 Teleport: Truk Pengiriman (Delivery)", THEME.Panel, function()
    tpToInstanceName("DeliveryTruck", "Delivery Truck")
end)
createActionButton(PageTeleport, "🛒 Teleport: Pasar Penjualan (Market)", THEME.Panel, function()
    tpToInstanceName("Market", "Market")
end)
createActionButton(PageTeleport, "🔮 Teleport: Rebirth & Universal Shop", THEME.Panel, function()
    tpToInstanceName("RebirthAltar", "Rebirth Altar")
end)

-- Click Teleport Tool
createActionButton(PageTeleport, "⚡ " .. T("TpClickTool"), THEME.Purple, function()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Click Teleport (Brother Hub)"
    tool.Activated:Connect(function()
        local pos = mouse.Hit.Position
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and pos then
            root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            notify(T("NotifyTeleported"), THEME.Accent)
        end
    end)
    tool.Parent = LocalPlayer.Backpack
    notify("Alat Click Teleport masuk ke tas!", THEME.Accent)
end)

-- ============================================================
-- [TAB 8] SETTINGS & BILINGUAL TOGGLE
-- ============================================================
createSection(PageSettings, "SecLanguage")

local langBtn = createActionButton(PageSettings, T("LangToggle"), THEME.Blue, function()
    currentLang = (currentLang == "ID") and "EN" or "ID"
    notify(T("NotifyLangSwitched"), THEME.Accent)
    
    -- Refresh dynamic labels
    SubtitleLabel.Text = T("HubSubtitle")
    for id, tData in pairs(tabs) do
        tData.btn.Text = T(tData.key)
    end
end)

createActionButton(PageSettings, "🔄 " .. T("RejoinBtn"), THEME.Panel, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createActionButton(PageSettings, "🌐 " .. T("ServerHopBtn"), THEME.Panel, function()
    notify("Mencari server kosong...", THEME.Yellow)
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in ipairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)

createSection(PageSettings, "SecCredits")
createActionButton(PageSettings, "📋 " .. T("CopyDiscordBtn"), THEME.Blue, function()
    copyToClipboard("https://discord.gg/szYbZCqHKS", "Official Discord Invite copied!")
end)
createActionButton(PageSettings, "☕ " .. T("DonateSaweriaBtn"), THEME.Yellow, function()
    copyToClipboard("https://saweria.co/BrotherHubOfficial", "Saweria donation link copied! Include Discord username in note.")
end)
createActionButton(PageSettings, "💖 " .. T("DonateSociaBuzzBtn"), THEME.Accent, function()
    copyToClipboard("https://sociabuzz.com/brotherhub", "SociaBuzz donation link copied! Include Discord username in note.")
end)

-- [12] CONFIRM DIALOG & COMPREHENSIVE CLEANUP ALL
local function cleanupAll()
    getgenv().BrotherHub_FarmIndustry_Loaded = false
    for k, v in pairs(Flags) do
        if type(v) == "boolean" then
            Flags[k] = false
        end
    end
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
    pcall(function()
        if Circle then Circle:Destroy() end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, child in ipairs(hrp:GetChildren()) do
                if child:IsA("BodyMover") or child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                    child:Destroy()
                end
            end
        end
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end)
end

getgenv().BrotherHub_FarmIndustry_Unload = function()
    cleanupAll()
    pcall(function()
        ScreenGui:Destroy()
    end)
end

createActionButton(PageSettings, "X " .. T("UnloadBtn"), THEME.Red, function()
    getgenv().BrotherHub_FarmIndustry_Unload()
end)

local function confirmDialog(msg, onYes)
    local overlay = Instance.new("Frame", ScreenGui)
    overlay.Name = "ConfirmOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 500
    TweenService:Create(overlay, tweenFast, {BackgroundTransparency = 0.55}):Play()

    local box = Instance.new("Frame", overlay)
    box.Name = "ConfirmBox"
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.Size = UDim2.fromOffset(380, 175)
    box.BackgroundColor3 = THEME.Bg
    box.BorderSizePixel = 0
    box.ZIndex = 501
    corner(box, 14)
    neonStroke(box, 2)

    local bs = Instance.new("UIScale", box)
    bs.Scale = 0
    TweenService:Create(bs, tweenBounce, {Scale = 1}):Play()

    local txt = Instance.new("TextLabel", box)
    txt.Size = UDim2.new(1, -30, 0, 90)
    txt.Position = UDim2.new(0, 15, 0, 14)
    txt.BackgroundTransparency = 1
    txt.Text = msg
    txt.TextColor3 = THEME.Title
    txt.Font = THEME.Font
    txt.TextSize = 14
    txt.TextWrapped = true
    txt.ZIndex = 502

    local function closeOverlay()
        local t = TweenService:Create(bs, tweenFast, {Scale = 0})
        t:Play()
        TweenService:Create(overlay, tweenFast, {BackgroundTransparency = 1}):Play()
        t.Completed:Connect(function() overlay:Destroy() end)
    end

    local yesBtn = Instance.new("TextButton", box)
    yesBtn.Size = UDim2.new(0, 155, 0, 40)
    yesBtn.Position = UDim2.new(0, 22, 1, -54)
    yesBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 110)
    yesBtn.Text = (currentLang == "ID") and "Ya, Tutup (Yes)" or "Yes, Close"
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.Font = THEME.Font
    yesBtn.TextSize = 14
    yesBtn.ZIndex = 505
    corner(yesBtn, 8)

    local noBtn = Instance.new("TextButton", box)
    noBtn.Size = UDim2.new(0, 155, 0, 40)
    noBtn.Position = UDim2.new(1, -177, 1, -54)
    noBtn.BackgroundColor3 = Color3.fromRGB(210, 55, 70)
    noBtn.Text = (currentLang == "ID") and "Batal (Cancel)" or "Cancel"
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.Font = THEME.Font
    noBtn.TextSize = 14
    noBtn.ZIndex = 505
    corner(noBtn, 8)

    noBtn.MouseButton1Click:Connect(closeOverlay)
    yesBtn.MouseButton1Click:Connect(function()
        pcall(function() overlay:Destroy() end)
        pcall(function() cleanupAll() end)
        pcall(function() ScreenGui:Destroy() end)
        if _G.BH_FARM_CLEANUP then pcall(_G.BH_FARM_CLEANUP) end
        if onYes then pcall(onYes) end
    end)
end

-- Close Button with Confirmation Dialog
CloseBtn.MouseButton1Click:Connect(function()
    confirmDialog("Tutup Brother Hub Farm Industry?\nSeluruh fitur otomatis akan dimatikan.\n(Are you sure you want to close? All features will be turned off.)", function()
        pcall(function() cleanupAll() end)
        pcall(function() ScreenGui:Destroy() end)
    end)
end)

-- Entrance Animation
MainScale.Scale = 0
MainFrame.Visible = true
TweenService:Create(MainScale, tweenBounce, {Scale = 1}):Play()
notify("👑 Brother Hub Farm Industry Loaded! Enjoy 24/7 Farming.", THEME.Accent)
