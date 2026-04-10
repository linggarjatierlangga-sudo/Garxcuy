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

-- ========== ESP DENGAN DETEKSI BACKPACK ==========
local espObjects = {}
local espActive = false
local espConnection = nil

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    
    -- 1. CEK BACKPACK (INVENTORY) - PALING AKURAT
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
                if weaponType == "Knife" then return "Murderer" end
                if weaponType == "Gun" then return "Sheriff" end
                
                local toolName = tool.Name:lower()
                if toolName:find("knife") then return "Murderer" end
                if toolName:find("gun") or toolName:find("pistol") then return "Sheriff" end
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
            
            local toolName = tool.Name:lower()
            if toolName:find("knife") then return "Murderer" end
            if toolName:find("gun") or toolName:find("pistol") then return "Sheriff" end
        end
    end
    
    -- 3. CEK ATRIBUT PLAYER (FALLBACK)
    local roleAttr = player:GetAttribute("Role") or player:GetAttribute("PlayerRole")
    if roleAttr then
        local roleUpper = string.upper(tostring(roleAttr))
        if roleUpper:find("MURDER") then return "Murderer" end
        if roleUpper:find("SHERIFF") then return "Sheriff" end
    end
    
    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then
        return Color3.fromRGB(0, 0, 255)
    else
        return Color3.fromRGB(0, 255, 0)
    end
end

local function createESPForPlayer(player)
    if player == LocalPlayer then return end
    
    local objects = {
        Box = {
            Top = Drawing.new("Line"),
            Bottom = Drawing.new("Line"),
            Left = Drawing.new("Line"),
            Right = Drawing.new("Line")
        },
        Name = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    for _, line in pairs(objects.Box) do
        line.Visible = false
        line.Thickness = 1
        line.Transparency = 1
    end
    
    objects.Name.Visible = false
    objects.Name.Center = true
    objects.Name.Size = 14
    objects.Name.Font = 2
    objects.Name.Outline = true
    
    objects.Tracer.Visible = false
    objects.Tracer.Thickness = 1
    objects.Tracer.Transparency = 1
    
    espObjects[player] = objects
end

local function removeESPForPlayer(player)
    local objects = espObjects[player]
    if objects then
        for _, line in pairs(objects.Box) do line:Remove() end
        objects.Name:Remove()
        objects.Tracer:Remove()
        espObjects[player] = nil
    end
end

local function updateESP()
    if not espActive then return end
    
    for player, objects in pairs(espObjects) do
        local char = player.Character
        local role = getPlayerRole(player)
        local color = getRoleColor(role)
        
        if char and char:FindFirstChild("HumanoidRootPart") then
            local rootPart = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
            
            if onScreen and distance < 1000 then
                local size = char:GetExtentsSize()
                local topPos, _ = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(0, size.Y/2, 0)).Position)
                local bottomPos, _ = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(0, -size.Y/2, 0)).Position)
                
                local screenHeight = bottomPos.Y - topPos.Y
                local screenWidth = screenHeight * 0.6
                local boxLeft = topPos.X - screenWidth/2
                local boxTop = topPos.Y
                
                objects.Box.Top.From = Vector2.new(boxLeft, boxTop)
                objects.Box.Top.To = Vector2.new(boxLeft + screenWidth, boxTop)
                objects.Box.Top.Color = color
                objects.Box.Top.Visible = true
                
                objects.Box.Bottom.From = Vector2.new(boxLeft, boxTop + screenHeight)
                objects.Box.Bottom.To = Vector2.new(boxLeft + screenWidth, boxTop + screenHeight)
                objects.Box.Bottom.Color = color
                objects.Box.Bottom.Visible = true
                
                objects.Box.Left.From = Vector2.new(boxLeft, boxTop)
                objects.Box.Left.To = Vector2.new(boxLeft, boxTop + screenHeight)
                objects.Box.Left.Color = color
                objects.Box.Left.Visible = true
                
                objects.Box.Right.From = Vector2.new(boxLeft + screenWidth, boxTop)
                objects.Box.Right.To = Vector2.new(boxLeft + screenWidth, boxTop + screenHeight)
                objects.Box.Right.Color = color
                objects.Box.Right.Visible = true
                
                objects.Name.Text = player.Name .. " [" .. role .. "]"
                objects.Name.Position = Vector2.new(topPos.X, topPos.Y - 15)
                objects.Name.Color = color
                objects.Name.Visible = true
                
                objects.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                objects.Tracer.To = Vector2.new(boxLeft + screenWidth/2, boxTop + screenHeight)
                objects.Tracer.Color = color
                objects.Tracer.Visible = true
            else
                for _, line in pairs(objects.Box) do line.Visible = false end
                objects.Name.Visible = false
                objects.Tracer.Visible = false
            end
        else
            for _, line in pairs(objects.Box) do line.Visible = false end
            objects.Name.Visible = false
            objects.Tracer.Visible = false
        end
    end
end

GameTab:AddToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    Default = false,
    Callback = function(state)
        espActive = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not espObjects[player] then
                    createESPForPlayer(player)
                end
            end
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.RenderStepped:Connect(updateESP)
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif! (Deteksi Backpack)", Time = 2})
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            for player, _ in pairs(espObjects) do
                removeESPForPlayer(player)
            end
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

-- ========== AUTO KILL + TELEPORT (MURDERER ONLY) - MOBILE VERSION ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Panel debug buat HP
local debugGui = Instance.new("ScreenGui")
debugGui.Name = "AutoKillDebug"
debugGui.Parent = game:GetService("CoreGui")
debugGui.ResetOnSpawn = false

local debugFrame = Instance.new("Frame")
debugFrame.Size = UDim2.new(0, 200, 0, 80)
debugFrame.Position = UDim2.new(0, 10, 0, 100)
debugFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
debugFrame.BackgroundTransparency = 0.3
debugFrame.BorderSizePixel = 0
debugFrame.Parent = debugGui

local debugText = Instance.new("TextLabel")
debugText.Size = UDim2.new(1, 0, 1, 0)
debugText.BackgroundTransparency = 1
debugText.TextColor3 = Color3.fromRGB(255, 255, 255)
debugText.TextSize = 12
debugText.Font = Enum.Font.Code
debugText.TextWrapped = true
debugText.Text = "Auto Kill: OFF\nStatus: -"
debugText.Parent = debugFrame

local function updateDebug(msg1, msg2)
    debugText.Text = "Auto Kill: " .. (msg1 or "OFF") .. "\nStatus: " .. (msg2 or "-")
end

-- Cari remote kill
local killRemotes = {}
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        local name = remote.Name:lower()
        if name:find("stab") or name:find("kill") or name:find("attack") or name:find("murder") or name:find("knife") then
            table.insert(killRemotes, remote)
        end
    end
end

updateDebug("OFF", "Remote: " .. #killRemotes)

-- Teleport ke target
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

-- Bunuh target
local function kill(target)
    if #killRemotes == 0 then return false end
    local success = false
    for _, remote in ipairs(killRemotes) do
        success = pcall(function() remote:FireServer(target) end) or success
        success = pcall(function() remote:FireServer(target.Character) end) or success
        success = pcall(function() remote:FireServer(target.UserId) end) or success
    end
    return success
end

-- Cek Murderer (deteksi dari tool + backpack)
local function isMurderer()
    local char = LocalPlayer.Character
    if not char then return false end
    
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
        if weaponType == "Knife" then return true end
        if tool.Name:lower():find("knife") then return true end
    end
    
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
                if weaponType == "Knife" then return true end
                if tool.Name:lower():find("knife") then return true end
            end
        end
    end
    return false
end

-- Loop auto kill
local autoActive = false
local connection = nil
local lastKillTime = 0

local function startLoop()
    if connection then connection:Disconnect() end
    connection = RunService.RenderStepped:Connect(function()
        if not autoActive then return
        if not isMurderer() then 
            updateDebug("ON", "Bukan Murderer")
            return 
        end
        if tick() - lastKillTime < 1.5 then return end
        
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
            updateDebug("ON", "Target: " .. target.Name)
            teleportTo(target)
            task.wait(0.1)
            if kill(target) then
                lastKillTime = tick()
                updateDebug("ON", "Killed: " .. target.Name)
            end
            task.wait(0.5)
        else
            updateDebug("ON", "Mencari target...")
        end
    end)
end

-- Toggle GUI
GameTab:AddToggle({
    Name = "🔪 Auto Kill + Teleport (Murderer Only)",
    Default = false,
    Callback = function(state)
        autoActive = state
        if state then
            if #killRemotes == 0 then
                OrionLib:MakeNotification({Name = "Error", Content = "Tidak ada remote kill!", Time = 3})
                updateDebug("OFF", "No remote")
                return
            end
            startLoop()
            updateDebug("ON", "Mencari target...")
            OrionLib:MakeNotification({Name = "Auto Kill", Content = "Aktif! Radius 700", Time = 2})
        else
            if connection then connection:Disconnect(); connection = nil end
            updateDebug("OFF", "Dimatikan")
        end
    end
})

-- Tombol manual
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
            kill(target)
            OrionLib:MakeNotification({Name = "Kill", Content = "Terbunuh!", Time = 1})
        end
    end
})

-- ========== NOTIFIKASI ==========
OrionLib:MakeNotification({Name = "GAR N CUY", Content = "Loaded! Buka tab Game Exploits.", Time = 3})
OrionLib:Init()