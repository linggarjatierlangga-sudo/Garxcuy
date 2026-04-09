-- ========== ORION LIBRARY ==========
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
    Name = "GAR N CUY BOCAH EPEP",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GAR CONFIG",
    IntroEnabled = true,
    IntroText = "ASSALAMUALAIKUM MAMANGG",
    IntroIcon = "rbxassetid://4483345998"
})

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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== ESP MURDERER & SHERIFF (FIX) ==========
local espActive = false
local espConnections = {}
local espHighlights = {}

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    local char = player.Character
    if not char then return "Innocent" end
    
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
        if weaponType == "Knife" then return "Murderer" end
        if weaponType == "Gun" then return "Sheriff" end
        if tool.Name:lower():find("knife") then return "Murderer" end
        if tool.Name:lower():find("gun") then return "Sheriff" end
    end
    return "Innocent"
end

local function updateESP()
    if not espActive then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = getPlayerRole(player)
            local highlight = espHighlights[player]
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = player.Name .. "_ESP"
                highlight.Parent = game:GetService("CoreGui")
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                espHighlights[player] = highlight
            end
            highlight.Adornee = player.Character
            
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
    
    -- Hapus highlight untuk player yang sudah gak ada
    for player, highlight in pairs(espHighlights) do
        if not player or not player.Parent or not player.Character then
            pcall(function() highlight:Destroy() end)
            espHighlights[player] = nil
        end
    end
end

-- Toggle ESP
GameTab:AddToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    Default = false,
    Callback = function(state)
        espActive = state
        if state then
            -- Hapus semua highlight lama
            for _, h in pairs(espHighlights) do
                pcall(function() h:Destroy() end)
            end
            espHighlights = {}
            -- Update pertama kali
            updateESP()
            -- Jalankan loop update
            if espConnections.update then espConnections.update:Disconnect() end
            espConnections.update = RunService.RenderStepped:Connect(updateESP)
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif!", Time = 2})
        else
            if espConnections.update then espConnections.update:Disconnect() end
            for _, h in pairs(espHighlights) do
                pcall(function() h:Destroy() end)
            end
            espHighlights = {}
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

-- ========== AUTO KILL + TELEPORT (MURDERER ONLY) ==========
-- Cari remote kill
local killRemote = nil
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("stab") or remote.Name:lower():find("kill")) then
        killRemote = remote
        break
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

local function kill(target)
    if killRemote then
        pcall(function() killRemote:FireServer(target) end)
        pcall(function() killRemote:FireServer(target.UserId) end)
    end
end

local function isMurderer()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
    return tool and (tool:GetAttribute("MurderMysteryWeaponType") == "Knife" or tool.Name:lower():find("knife"))
end

local autoActive = false
local connection = nil

local function startLoop()
    if connection then connection:Disconnect() end
    connection = RunService.RenderStepped:Connect(function()
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
            kill(target)
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
            startLoop()
            OrionLib:MakeNotification({Name = "Auto Kill", Content = "Aktif! Radius 700 studs", Time = 2})
        else
            if connection then connection:Disconnect(); connection = nil end
        end
    end
})

-- ========== SLIDER JUMP POWER ==========
GameTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    ValueName = "power",
    Callback = function(value)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = value
            end
        end
    end
})

-- ========== SLIDER WALK SPEED ==========
GameTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(value)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = value
            end
        end
    end
})

-- ========== INFINITE JUMP ==========
local infiniteJumpActive = false
local infiniteJumpConnection = nil

GameTab:AddToggle({
    Name = "🦘 Infinite Jump",
    Default = false,
    Callback = function(state)
        infiniteJumpActive = state
        if state then
            infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if infiniteJumpActive and LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = Vector3.new(0, 50, 0)
                        bv.MaxForce = Vector3.new(0, math.huge, 0)
                        bv.Parent = root
                        game:GetService("Debris"):AddItem(bv, 0.5)
                    end
                end
            end)
        else
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
        end
    end
})

-- ========== NOTIFIKASI ==========
OrionLib:MakeNotification({Name = "GAR N CUY", Content = "Loaded! Buka tab Game Exploits.", Time = 3})
OrionLib:Init()