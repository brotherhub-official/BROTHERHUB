-- ====================================================================
-- 👑 BROTHER HUB - UNIVERSAL MASTER LOADER
-- Official Discord: discord.gg/brotherhub
-- Founder: prawiraxliv
-- ====================================================================

local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "👑 BROTHER HUB",
            Text = text or "",
            Duration = duration or 5,
        })
    end)
end

notify("👑 BROTHER HUB", "Mendeteksi game...", 4)

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

            local gName = "Unknown Game"
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

local placeId = game.PlaceId
local gameId = game.GameId
local gameName = ""

pcall(function()
    local info = MarketplaceService:GetProductInfo(placeId)
    if info and info.Name then
        gameName = string.lower(info.Name)
    end
end)

local HUB_ROUTER = {
    {
        Name = "Dig Into Secrets",
        Match = function(pid, gid, gname)
            if pid == 119409763193569 or pid == 86641960184547 then return true end
            if gid == 10685312778 or gid == 7232338573 then return true end
            if string.find(gname, "dig into secrets") or string.find(gname, "dig into") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/ap5f66.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/DigIntoSecrets_BROTHERHUB.lua",
    },
    {
        Name = "My Flower Shop",
        Match = function(pid, gid, gname)
            if pid == 17079556094 or pid == 93028168925975 or gid == 10324001605 or gid == 5873995893 then return true end
            if string.find(gname, "flower shop") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/nvyh0o.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/FlowerShop_BROTHERHUB.lua",
    },
    {
        Name = "Fish an Anime RNG",
        Match = function(pid, gid, gname)
            if pid == 18985160826 or pid == 74729868188364 or gid == 9582986239 or gid == 6473187214 then return true end
            if string.find(gname, "fish an anime") or string.find(gname, "fish anime") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/41z6ty.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/FishanAnime_BROTHERHUB.lua",
    },
    {
        Name = "Sell Ores",
        Match = function(pid, gid, gname)
            if pid == 18519782522 or pid == 122572082932179 or gid == 10336278580 or gid == 6316238641 then return true end
            if string.find(gname, "sellores") or string.find(gname, "sell ores") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/hromq6.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/Sellores_BROTHERHUB.lua",
    },
    {
        Name = "The Mimic",
        Match = function(pid, gid, gname)
            local mimicPlaces = {
                [6243699076] = true,
                [6484544814] = true,
                [6839171747] = true,
                [7402052744] = true,
                [7888764030] = true,
            }
            if mimicPlaces[pid] or gid == 2294168059 or gid == 2396129853 then return true end
            if string.find(gname, "the mimic") or string.find(gname, "mimic") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/ud8m6j.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/TheMimic_BROTHERHUB.lua",
    },
    {
        Name = "Dungeon Lootr",
        Match = function(pid, gid, gname)
            if pid == 106484206883664 or gid == 9656201728 then return true end
            if string.find(gname, "dungeon lootr") or string.find(gname, "lootr") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("GameInfo") and rs.GameInfo:FindFirstChild("DungeonData") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/krdzqt.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/DungeonLootr_BROTHERHUB.lua",
    },
    {
        Name = "Dungeon Quest Reborn",
        Match = function(pid, gid, gname)
            if pid == 77649408247578 or gid == 9931749389 then return true end
            if string.find(gname, "dungeon quest reborn") or string.find(gname, "dungeon quest") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("remotes") and rs.remotes:FindFirstChild("weaponUsed") and rs.remotes:FindFirstChild("abilityUsed") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/416gip.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/DungeonQuestReborn_BROTHERHUB.lua",
    },
    {
        Name = "Idle Mafia Game",
        Match = function(pid, gid, gname)
            if pid == 73897506680154 or gid == 10643795368 then return true end
            if string.find(gname, "idle mafia") or string.find(gname, "mafia wars") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("MW") and rs.MW:FindFirstChild("Remotes") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/vg5h5z.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/IdleMafia_BROTHERHUB.lua",
    },
    {
        Name = "Farm Industry",
        Match = function(pid, gid, gname)
            if pid == 78602687536170 or gid == 10255320035 then return true end
            if string.find(gname, "farm industry") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("RequestStartProduction") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/0ig1wb.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/FarmIndustry_BROTHERHUB.lua",
    },
    {
        Name = "Poly Loot",
        Match = function(pid, gid, gname)
            if pid == 124032631078772 or gid == 10541331578 then return true end
            if string.find(gname, "poly loot") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/q3x8i1.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/PolyLoot_BROTHERHUB.lua",
    },
    {
        Name = "Storage Hunters: Open World",
        Match = function(pid, gid, gname)
            if pid == 98800969324557 or gid == 10261267004 then return true end
            if string.find(gname, "storage hunters") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("Events") and rs.Events:FindFirstChild("Auction") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/zytmnr.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/StorageHunters_BROTHERHUB.lua",
    },
    {
        Name = "Drill to Earth's Core",
        Match = function(pid, gid, gname)
            if pid == 101906032112547 or pid == 74507545904779 or gid == 9796898051 then return true end
            if string.find(gname, "drill to earth") or string.find(gname, "earth's core") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("DrillService") or (rs:FindFirstChild("Packages") and rs.Packages:FindFirstChild("Knit") and rs:FindFirstChild("ToolService")) then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/9zaic2.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/DrillToEarth_BROTHERHUB.lua",
    },
    {
        Name = "Defeat Anime RNG",
        Match = function(pid, gid, gname)
            if pid == 92606991708989 or gid == 10552240401 then return true end
            if string.find(gname, "defeat") or string.find(gname, "defeat anime") or string.find(gname, "defeat 4 anime") then return true end
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("RemoteEvents") and rs.RemoteEvents:FindFirstChild("ConfirmedRollRequestEvent") then return true end
            return false
        end,
        CdnUrl = "https://files.catbox.moe/qxl3sf.lua",
        GitHubUrl = "https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/DefeatAnimeRNG_BROTHERHUB.lua",
    },
}

local selectedGame = nil
for _, entry in ipairs(HUB_ROUTER) do
    if entry.Match(placeId, gameId, gameName) then
        selectedGame = entry
        break
    end
end

if selectedGame then
    sendExecutionLog("Universal Loader -> " .. selectedGame.Name)
    notify("👑 BROTHER HUB", "Memuat: " .. selectedGame.Name .. "...", 6)
    
    local function fetchCode(url)
        if not url or url == "" then return nil end
        local s, res = pcall(function()
            if game.HttpGet then
                return game:HttpGet(url, true)
            elseif httpReq then
                local r = httpReq({ Url = url, Method = "GET" })
                return r and (r.Body or r.body)
            end
        end)
        if s and type(res) == "string" and #res > 50 then
            return res
        end
        return nil
    end

    local scriptCode = fetchCode(selectedGame.GitHubUrl) or fetchCode(selectedGame.CdnUrl)

    if scriptCode then
        local fn, err = (loadstring or load)(scriptCode)
        if fn then
            fn()
        else
            notify("X Script Error", "Gagal meng-compile script: " .. tostring(err), 8)
        end
    else
        notify("X Download Error", "Gagal mengunduh script dari CDN & GitHub!", 8)
    end
else
    sendExecutionLog("Universal Loader -> Unsupported Game (" .. tostring(placeId) .. ")")
    notify("⚠️ BROTHER HUB", "Game ini belum didukung!\nPlaceId: " .. tostring(placeId), 8)
end
