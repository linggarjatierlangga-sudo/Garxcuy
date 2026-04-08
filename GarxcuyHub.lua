-- ========== ORION LIBRARY ==========
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

-- ========== WINDOW ==========
local Window = OrionLib:MakeWindow({
    Name = "Eye GPT All-in-One Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "EyeGPTConfig",
    IntroEnabled = true,
    IntroText = "Eye GPT Hub",
    IntroIcon = "rbxassetid://4483345998"
})

-- ========== TAB ==========
local GameTab = Window:MakeTab({
    Name = "Game Exploits",
    Icon = "rbxassetid://7734022041"
})

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- ========== ESP MURDERER & SHERIFF ==========
local highlightFolder = nil
local espActive = false
local espConnection = nil
local roleCache = {}

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    if roleCache[player] and (tick() - (roleCache[player].time or 0)) < 1.5 then
        return roleCache[player].role
    end
    local char = player.Character
    local role = "Innocent"
    if char then
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool then
            local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
            if weaponType == "Knife" then role = "Murderer"
            elseif weaponType == "Gun" then role = "Sheriff" end
        end
    end
    if role == "Innocent" then
        local backpack = player:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
                    if weaponType == "Knife" then role = "Murderer"; break
                    elseif weaponType == "Gun" then role = "Sheriff"; break end
                end
            end
        end
    end
    roleCache[player] = {role = role, time = tick()}
    return role
end

local function updateESP()
    if not espActive then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = getPlayerRole(player)
            local highlight = highlightFolder and highlightFolder:FindFirstChild(player.Name)
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = player.Name
                highlight.Parent = highlightFolder
                highlight.Adornee = player.Character
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
            else
                highlight.Adornee = player.Character
            end
            if role == "Murderer" then
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            elseif role == "Sheriff" then
                highlight.FillColor = Color3.fromRGB(0, 0, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
            else
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            end
        end
    end
end

GameTab:AddToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    Default = false,
    Callback = function(state)
        espActive = state
        if state then
            if not highlightFolder then
                highlightFolder = Instance.new("Folder")
                highlightFolder.Name = "MM2_ESP"
                highlightFolder.Parent = game:GetService("CoreGui")
            end
            for _, child in ipairs(highlightFolder:GetChildren()) do child:Destroy() end
            roleCache = {}
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.RenderStepped:Connect(updateESP)
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif!", Time = 2})
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            if highlightFolder then
                for _, child in ipairs(highlightFolder:GetChildren()) do child:Destroy() end
            end
            roleCache = {}
        end
    end
})

-- ========== AIMBOT KHUSUS MURDERER ==========
local aimbotActive = false
local aimbotConnection = nil
local aimbotFOV = 150

local function getClosestMurderer()
    local closest = nil
    local shortestDist = aimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if getPlayerRole(player) == "Murderer" then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

local function aimAtMurderer()
    local target = getClosestMurderer()
    if not target then return end
    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if onScreen then
        local mousePos = UserInputService:GetMouseLocation()
        local deltaX = screenPos.X - mousePos.X
        local deltaY = screenPos.Y - mousePos.Y
        if syn and syn.input then
            syn.input.MoveMouse(deltaX, deltaY)
        elseif mouse1move then
            mouse1move(deltaX, deltaY)
        elseif mousemoverel then
            mousemoverel(deltaX, deltaY)
        end
    end
end

local function startAimbotLoop()
    if aimbotConnection then aimbotConnection:Disconnect() end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if aimbotActive then aimAtMurderer() end
    end)
end

GameTab:AddToggle({
    Name = "🎯 Aimbot Khusus Murderer (Auto Aim)",
    Default = false,
    Callback = function(state)
        aimbotActive = state
        if state then
            startAimbotLoop()
            OrionLib:MakeNotification({Name = "Aimbot", Content = "Membidik Murderer!", Time = 2})
        else
            if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
        end
    end
})

GameTab:AddSlider({
    Name = "FOV Aimbot (Radius Layar)",
    Min = 50,
    Max = 300,
    Default = 150,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 10,
    ValueName = "px",
    Callback = function(value)
        aimbotFOV = value
    end
})

-- ========== FLY + NOCLIP ==========
GameTab:AddButton({
    Name = "🚀 Load Fly + Noclip",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-And-Noclip-GUI-192488"))()
        OrionLib:MakeNotification({Name = "Fly + Noclip", Content = "Loaded!", Time = 2})
    end
})

-- ========== AUTO STEAL BRAINROT (HANYA NPC BERGERAK) ==========
local autoSteal = {
    Cosmic = false,
    Eternal = false,
    Secret = false
}
local stealConnections = {
    Cosmic = nil,
    Eternal = nil,
    Secret = nil
}
local lastStolen = {
    Cosmic = 0,
    Eternal = 0,
    Secret = 0
}
local stealCooldown = 3
local baseRadius = 150
local basePosition = nil

local assetRarityMap = {
    ["Cocofanto Elefanto"] = "COSMIC",
    ["Tralalero Tralala"] = "COSMIC",
    ["Odin Din Din Dun"] = "COSMIC",
    ["Garama and Madundung"] = "ETERNAL",
    ["Graipuss Medussi"] = "SECRET",
    ["La Vacca Saturno Saturnita"] = "SECRET",
    ["Karkerkar Kurkur"] = "SECRET",
}

local function getBasePart(obj)
    if obj:IsA("BasePart") then return obj
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart end
        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then return part end
        end
    end
    return nil
end

local function isInsideBase(pos)
    if not basePosition then return false end
    return (pos - basePosition).Magnitude <= baseRadius
end

local function findBrainrotPartByRarity(targetRarity)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local rarityAttr = obj:GetAttribute("Rarity")
                local matched = false
                if rarityAttr and string.upper(rarityAttr) == targetRarity then
                    matched = true
                else
                    local mappedRarity = assetRarityMap[obj.Name]
                    if mappedRarity and mappedRarity == targetRarity then
                        matched = true
                    else
                        local parent = obj.Parent
                        if parent then
                            local parentRarity = assetRarityMap[parent.Name]
                            if parentRarity and parentRarity == targetRarity then
                                matched = true
                            end
                        end
                    end
                end
                if matched then
                    local part = getBasePart(obj)
                    if part and not isInsideBase(part.Position) then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

local function teleportToBrainrot(obj)
    local part = getBasePart(obj)
    if not part then return false end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3, 0)
        return true
    end
    return false
end

local function takeBrainrot(rarity)
    local productId = nil
    if rarity == "COSMIC" then productId = 3569343071
    elseif rarity == "ETERNAL" then productId = 3569343339
    elseif rarity == "SECRET" then productId = 3569343224 end
    if productId then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseStealTakeBack", true)
        if remote then
            remote:FireServer(productId)
            print("[AutoSteal] " .. rarity .. " - Purchase sent")
            return true
        else
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, btn in ipairs(playerGui:GetDescendants()) do
                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and
                        (btn.Text:lower():find("take") or btn.Name:lower():find("take")) then
                        btn:Click()
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function startStealLoop(rarity)
    if stealConnections[rarity] then stealConnections[rarity]:Disconnect() end
    stealConnections[rarity] = RunService.RenderStepped:Connect(function()
        if not autoSteal[rarity] then return end
        if tick() - lastStolen[rarity] < stealCooldown then return end
        local target = findBrainrotPartByRarity(rarity)
        if target then
            print("[AutoSteal] Found " .. rarity .. " brainrot at " .. tostring(getBasePart(target).Position))
            lastStolen[rarity] = tick()
            teleportToBrainrot(target)
            task.wait(0.5)
            takeBrainrot(rarity)
            task.wait(1)
        end
    end)
end

-- GUI Elements untuk Auto Steal
GameTab:AddButton({
    Name = "🏠 Set Base Position (Berdiri di tengah base lalu tekan)",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            basePosition = char.HumanoidRootPart.Position
            OrionLib:MakeNotification({Name = "Base Set", Content = "Posisi base: " .. tostring(basePosition), Time = 3})
        else
            OrionLib:MakeNotification({Name = "Error", Content = "Karakter tidak ditemukan", Time = 2})
        end
    end
})

GameTab:AddSlider({
    Name = "🏠 Radius Base (studs)",
    Min = 50,
    Max = 500,
    Default = 150,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 10,
    ValueName = "studs",
    Callback = function(value)
        baseRadius = value
    end
})

GameTab:AddToggle({
    Name = "💀 Auto Steal Brainrot COSMIC (Luar Base)",
    Default = false,
    Callback = function(state)
        autoSteal.Cosmic = state
        if state then
            if not basePosition then
                OrionLib:MakeNotification({Name = "Error", Content = "Set base position dulu!", Time = 2})
                autoSteal.Cosmic = false
                return
            end
            startStealLoop("COSMIC")
            OrionLib:MakeNotification({Name = "Auto Steal", Content = "Mencari Cosmic...", Time = 2})
        else
            if stealConnections.Cosmic then stealConnections.Cosmic:Disconnect(); stealConnections.Cosmic = nil end
        end
    end
})

GameTab:AddToggle({
    Name = "💀 Auto Steal Brainrot ETERNAL (Luar Base)",
    Default = false,
    Callback = function(state)
        autoSteal.Eternal = state
        if state then
            if not basePosition then
                OrionLib:MakeNotification({Name = "Error", Content = "Set base position dulu!", Time = 2})
                autoSteal.Eternal = false
                return
            end
            startStealLoop("ETERNAL")
            OrionLib:MakeNotification({Name = "Auto Steal", Content = "Mencari Eternal...", Time = 2})
        else
            if stealConnections.Eternal then stealConnections.Eternal:Disconnect(); stealConnections.Eternal = nil end
        end
    end
})

GameTab:AddToggle({
    Name = "💀 Auto Steal Brainrot SECRET (Luar Base)",
    Default = false,
    Callback = function(state)
        autoSteal.Secret = state
        if state then
            if not basePosition then
                OrionLib:MakeNotification({Name = "Error", Content = "Set base position dulu!", Time = 2})
                autoSteal.Secret = false
                return
            end
            startStealLoop("SECRET")
            OrionLib:MakeNotification({Name = "Auto Steal", Content = "Mencari Secret...", Time = 2})
        else
            if stealConnections.Secret then stealConnections.Secret:Disconnect(); stealConnections.Secret = nil end
        end
    end
})

local function manualTeleport(rarity)
    local target = findBrainrotPartByRarity(rarity)
    if target then
        teleportToBrainrot(target)
        OrionLib:MakeNotification({Name = "Teleport", Content = "Ke " .. rarity, Time = 1})
    else
        OrionLib:MakeNotification({Name = "Teleport", Content = "Tidak ada " .. rarity .. " di luar base", Time = 1})
    end
end

GameTab:AddButton({
    Name = "📍 Teleport ke Cosmic (luar base)",
    Callback = function() manualTeleport("COSMIC") end
})

GameTab:AddButton({
    Name = "📍 Teleport ke Eternal (luar base)",
    Callback = function() manualTeleport("ETERNAL") end
})

GameTab:AddButton({
    Name = "📍 Teleport ke Secret (luar base)",
    Callback = function() manualTeleport("SECRET") end
})

-- Notifikasi awal
OrionLib:MakeNotification({Name = "Eye GPT Hub", Content = "Loaded! Buka tab Game Exploits.", Time = 3})

-- Init Orion
OrionLib:Init()