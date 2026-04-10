-- ========== ORION LIBRARY ==========
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
    Name = "GAR N CUY",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GAR_CONFIG",
    IntroEnabled = false
})

local GameTab = Window:MakeTab({
    Name = "Game Exploits",
    Icon = "rbxassetid://7734022041"
})

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== ESP SIMPLE (DRAWING TEXT) ==========
local espObjects = {}
local espActive = false
local espConnection = nil

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    
    -- 1. CEK BACKPACK (INVENTORY)
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
                if weaponType == "Knife" then return "Murderer" end
                if weaponType == "Gun" then return "Sheriff" end
                if tool.Name:lower():find("knife") then return "Murderer" end
                if tool.Name:lower():find("gun") then return "Sheriff" end
            end
        end
    end
    
    -- 2. CEK TANGAN (YANG SEDANG DIPEGANG)
    local char = player.Character
    if char then
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool then
            local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
            if weaponType == "Knife" then return "Murderer" end
            if weaponType == "Gun" then return "Sheriff" end
            if tool.Name:lower():find("knife") then return "Murderer" end
            if tool.Name:lower():find("gun") then return "Sheriff" end
        end
    end
    
    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then return Color3.fromRGB(0, 0, 255)
    else return Color3.fromRGB(0, 255, 0) end
end

local function createESP(player)
    if player == LocalPlayer then return end
    local text = Drawing.new("Text")
    text.Center = true
    text.Size = 14
    text.Font = 2
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    text.Visible = false
    espObjects[player] = text
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player]:Remove()
        espObjects[player] = nil
    end
end

local function updateESP()
    if not espActive then return end
    for player, text in pairs(espObjects) do
        local char = player.Character
        local role = getPlayerRole(player)
        if char and char:FindFirstChild("HumanoidRootPart") then
            local rootPart = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                text.Text = player.Name .. " [" .. role .. "]"
                text.Position = Vector2.new(pos.X, pos.Y - 30)
                text.Color = getRoleColor(role)
                text.Visible = true
            else
                text.Visible = false
            end
        else
            text.Visible = false
        end
    end
end

GameTab:AddToggle({
    Name = "🔴 ESP Murderer & Sheriff",
    Default = false,
    Callback = function(state)
        espActive = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not espObjects[player] then
                    createESP(player)
                end
            end
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.RenderStepped:Connect(updateESP)
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif!", Time = 2})
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            for player, _ in pairs(espObjects) do removeESP(player) end
        end
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

-- ========== AUTO KILL + TELEPORT ==========
local killRemotes = {}
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        local name = remote.Name:lower()
        if name:find("stab") or name:find("kill") or name:find("attack") then
            table.insert(killRemotes, remote)
        end
    end
end

local function teleportTo(target)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            char.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 2, 2)
            return true
        end
    end
    return false
end

local function killTarget(target)
    if #killRemotes == 0 then return false end
    for _, remote in ipairs(killRemotes) do
        pcall(function() remote:FireServer(target) end)
        pcall(function() remote:FireServer(target.UserId) end)
    end
    return true
end

local function isMurderer()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        if tool:GetAttribute("MurderMysteryWeaponType") == "Knife" then return true end
        if tool.Name:lower():find("knife") then return true end
    end
    return false
end

local autoActive = false
local autoConnection = nil

local function startAutoKill()
    if autoConnection then autoConnection:Disconnect() end
    autoConnection = RunService.RenderStepped:Connect(function()
        if not autoActive or not isMurderer() then return end
        
        local target = nil
        local minDist = 700
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myPos then return end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - myPos.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = p
                end
            end
        end
        
        if target then
            teleportTo(target)
            task.wait(0.1)
            killTarget(target)
            task.wait(0.5)
        end
    end)
end

GameTab:AddToggle({
    Name = "🔪 Auto Kill + Teleport (Murderer Only)",
    Default = false,
    Callback = function(state)
        autoActive = state
        if state then
            if #killRemotes == 0 then
                OrionLib:MakeNotification({Name = "Error", Content = "Tidak ada remote kill!", Time = 2})
                return
            end
            startAutoKill()
            OrionLib:MakeNotification({Name = "Auto Kill", Content = "Aktif! Radius 700", Time = 2})
        else
            if autoConnection then autoConnection:Disconnect(); autoConnection = nil end
        end
    end
})

GameTab:AddButton({
    Name = "🔪 Test Kill Terdekat",
    Callback = function()
        if not isMurderer() then
            OrionLib:MakeNotification({Name = "Error", Content = "Bukan Murderer!", Time = 1})
            return
        end
        
        local target = nil
        local minDist = 700
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myPos then return end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - myPos.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = p
                end
            end
        end
        
        if target then
            teleportTo(target)
            task.wait(0.1)
            killTarget(target)
            OrionLib:MakeNotification({Name = "Kill", Content = "Terbunuh!", Time = 1})
        end
    end
})

OrionLib:MakeNotification({Name = "GAR N CUY", Content = "Loaded!", Time = 3})
OrionLib:Init()