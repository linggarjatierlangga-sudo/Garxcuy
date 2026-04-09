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

local TeleportTab = Window:MakeTab({
    Name = "Teleport Player",
    Icon = "rbxassetid://4483345998"
})

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== BOX ESP (ALTERNATIF HIGHLIGHT) ==========
local espActive = false
local boxes = {}
local espConnection = nil

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    local char = player.Character
    if not char then return "Innocent" end
    
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
        if weaponType == "Knife" then return "Murderer" end
        if weaponType == "Gun" then return "Sheriff" end
        
        local toolName = tool.Name:lower()
        if toolName:find("knife") then return "Murderer" end
        if toolName:find("gun") or toolName:find("pistol") then return "Sheriff" end
    end
    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)     -- Merah
    elseif role == "Sheriff" then
        return Color3.fromRGB(0, 0, 255)     -- Biru
    else
        return Color3.fromRGB(0, 255, 0)     -- Hijau
    end
end

local function createBox(player)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 60, 0, 80)
    box.BackgroundColor3 = getRoleColor(getPlayerRole(player))
    box.BackgroundTransparency = 0.6
    box.BorderSizePixel = 0
    box.Parent = game:GetService("CoreGui")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = box
    
    boxes[player] = box
end

local function updateBox(player, box)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
        if onScreen then
            box.Visible = true
            box.Position = UDim2.new(0, pos.X - 30, 0, pos.Y - 40)
            -- Update warna berdasarkan role
            box.BackgroundColor3 = getRoleColor(getPlayerRole(player))
        else
            box.Visible = false
        end
    else
        box.Visible = false
    end
end

local function updateAllBoxes()
    if not espActive then return end
    
    for player, box in pairs(boxes) do
        if player and player.Parent then
            updateBox(player, box)
        else
            pcall(function() box:Destroy() end)
            boxes[player] = nil
        end
    end
end

local function setupESP()
    -- Hapus semua box lama
    for _, box in pairs(boxes) do
        pcall(function() box:Destroy() end)
    end
    boxes = {}
    
    -- Buat box untuk setiap player
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createBox(player)
        end
    end
end

GameTab:AddToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    Default = false,
    Callback = function(state)
        espActive = state
        if state then
            setupESP()
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.RenderStepped:Connect(updateAllBoxes)
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif! (BoxESP)", Time = 2})
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            for _, box in pairs(boxes) do
                pcall(function() box:Destroy() end)
            end
            boxes = {}
        end
    end
})

-- Update box saat player masuk/keluar
Players.PlayerAdded:Connect(function(player)
    if espActive and player ~= LocalPlayer then
        createBox(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if boxes[player] then
        pcall(function() boxes[player]:Destroy() end)
        boxes[player] = nil
    end
end)

-- ========== FLY + NOCLIP ==========
GameTab:AddButton({
    Name = "🚀 Load Fly + Noclip",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-And-Noclip-GUI-192488"))()
        OrionLib:MakeNotification({Name = "Fly + Noclip", Content = "Loaded!", Time = 2})
    end
})

-- ========== AUTO KILL + TELEPORT (MURDERER ONLY) ==========
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

-- ========== TELEPORT PLAYER (DAFTAR NAMA) ==========
TeleportTab:AddParagraph("📌 Teleport Player", "Klik nama player untuk teleport.")

local playerSection = TeleportTab:AddSection("Daftar Player")
local playerButtons = {}

local function updatePlayerListUI()
    for _, btn in ipairs(playerButtons) do
        pcall(function() btn:Destroy() end)
    end
    playerButtons = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = playerSection:CreateButton({
                Name = player.Name .. " [" .. (player.DisplayName or player.Name) .. "]",
                Callback = function()
                    local char = LocalPlayer.Character
                    local targetChar = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
                        OrionLib:MakeNotification({Name = "Teleport", Content = "Ke " .. player.Name, Time = 1})
                    else
                        OrionLib:MakeNotification({Name = "Error", Content = "Gagal teleport!", Time = 1})
                    end
                end
            })
            table.insert(playerButtons, btn)
        end
    end
    
    if #playerButtons == 0 then
        playerSection:CreateLabel("Tidak ada player lain.")
    end
end

Players.PlayerAdded:Connect(updatePlayerListUI)
Players.PlayerRemoving:Connect(updatePlayerListUI)
updatePlayerListUI()

-- ========== NOTIFIKASI ==========
OrionLib:MakeNotification({Name = "GAR N CUY", Content = "Loaded! Buka tab Game Exploits.", Time = 3})
OrionLib:Init()