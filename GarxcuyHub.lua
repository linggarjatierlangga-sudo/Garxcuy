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

-- ========== AUTO STEAL BRAINROT PER RARITY (BERDASARKAN NAMA ASSET) ==========
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

-- Mapping nama asset ke rarity
local assetRarityMap = {
    -- Cosmic
    ["Cocofanto Elefanto"] = "COSMIC",
    ["Tralalero Tralala"] = "COSMIC",
    ["Odin Din Din Dun"] = "COSMIC",
    -- Eternal
    ["Garama and Madundung"] = "ETERNAL",
    -- Secret
    ["Graipuss Medussi"] = "SECRET",
    ["La Vacca Saturno Saturnita"] = "SECRET",
    ["Karkerkar Kurkur"] = "SECRET",
}

local function findBrainrotPartByRarity(targetRarity)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local rarityAttr = obj:GetAttribute("Rarity")
            if rarityAttr and string.upper(rarityAttr) == targetRarity then
                return obj
            end
            local mappedRarity = assetRarityMap[obj.Name]
            if mappedRarity and mappedRarity == targetRarity then
                return obj
            end
            local parent = obj.Parent
            if parent then
                local parentRarity = assetRarityMap[parent.Name]
                if parentRarity and parentRarity == targetRarity then
                    return obj
                end
            end
        end
    end
    return nil
end

local function getBasePart(obj)
    if obj:IsA("BasePart") then
        return obj
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart end
        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                return part
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
    if rarity == "COSMIC" then
        productId = 3569343071
    elseif rarity == "ETERNAL" then
        productId = 3569343339
    elseif rarity == "SECRET" then
        productId = 3569343224
    end
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
                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
                        local text = (btn.Text or btn.Name or ""):lower()
                        if text:find("take") or text:find("claim") or text:find("collect") then
                            btn:Click()
                            print("[AutoSteal] Clicked take button")
                            return true
                        end
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
            print("[AutoSteal] Found " .. rarity .. " brainrot:", target.Name)
            lastStolen[rarity] = tick()
            teleportToBrainrot(target)
            task.wait(0.5)
            takeBrainrot(rarity)
            task.wait(1)
        end
    end)
end

-- Toggle untuk Cosmic
GameTab:AddToggle({
    Name = "💀 Auto Steal Brainrot COSMIC",
    Default = false,
    Callback = function(state)
        autoSteal.Cosmic = state
        if state then
            startStealLoop("COSMIC")
            OrionLib:MakeNotification({Name = "Auto Steal", Content = "Mencari Cosmic...", Time = 2})
        else
            if stealConnections.Cosmic then stealConnections.Cosmic:Disconnect(); stealConnections.Cosmic = nil end
        end
    end
})

-- Toggle untuk Eternal
GameTab:AddToggle({
    Name = "💀 Auto Steal Brainrot ETERNAL",
    Default = false,
    Callback = function(state)
        autoSteal.Eternal = state
        if state then
            startStealLoop("ETERNAL")
            OrionLib:MakeNotification({Name = "Auto Steal", Content = "Mencari Eternal...", Time = 2})
        else
            if stealConnections.Eternal then stealConnections.Eternal:Disconnect(); stealConnections.Eternal = nil end
        end
    end
})

-- Toggle untuk Secret
GameTab:AddToggle({
    Name = "💀 Auto Steal Brainrot SECRET",
    Default = false,
    Callback = function(state)
        autoSteal.Secret = state
        if state then
            startStealLoop("SECRET")
            OrionLib:MakeNotification({Name = "Auto Steal", Content = "Mencari Secret...", Time = 2})
        else
            if stealConnections.Secret then stealConnections.Secret:Disconnect(); stealConnections.Secret = nil end
        end
    end
})

-- Tombol teleport manual untuk Cosmic
GameTab:AddButton({
    Name = "📍 Teleport ke Cosmic Terdekat",
    Callback = function()
        local target = findBrainrotPartByRarity("COSMIC")
        if target then
            teleportToBrainrot(target)
            OrionLib:MakeNotification({Name = "Teleport", Content = "Ke Cosmic!", Time = 1})
        else
            OrionLib:MakeNotification({Name = "Teleport", Content = "Tidak ada Cosmic", Time = 1})
        end
    end
})

-- Tombol teleport manual untuk Eternal
GameTab:AddButton({
    Name = "📍 Teleport ke Eternal Terdekat",
    Callback = function()
        local target = findBrainrotPartByRarity("ETERNAL")
        if target then
            teleportToBrainrot(target)
            OrionLib:MakeNotification({Name = "Teleport", Content = "Ke Eternal!", Time = 1})
        else
            OrionLib:MakeNotification({Name = "Teleport", Content = "Tidak ada Eternal", Time = 1})
        end
    end
})

-- Tombol teleport manual untuk Secret
GameTab:AddButton({
    Name = "📍 Teleport ke Secret Terdekat",
    Callback = function()
        local target = findBrainrotPartByRarity("SECRET")
        if target then
            teleportToBrainrot(target)
            OrionLib:MakeNotification({Name = "Teleport", Content = "Ke Secret!", Time = 1})
        else
            OrionLib:MakeNotification({Name = "Teleport", Content = "Tidak ada Secret", Time = 1})
        end
    end
})

-- Notifikasi awal
OrionLib:MakeNotification({Name = "Eye GPT Hub", Content = "Loaded! Buka tab Game Exploits.", Time = 3})

-- Init Orion
OrionLib:Init()