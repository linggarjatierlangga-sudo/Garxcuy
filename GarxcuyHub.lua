-- ========== ORION LIBRARY ==========
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
    Name = "LINGGAR 💗 ARA",
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
    Name = "🔴 ESP Murderer & Sheriff",
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

-- ========== AUTO KILL (MURDERER ONLY) ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cari remote kill
local killRemote = nil
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("stab") or remote.Name:lower():find("kill")) then
        killRemote = remote
        break
    end
end

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
    if killRemote then
        pcall(function() killRemote:FireServer(target) end)
        pcall(function() killRemote:FireServer(target.UserId) end)
    end
end

-- Cek Murderer
local function isMurderer()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
    return tool and (tool:GetAttribute("MurderMysteryWeaponType") == "Knife" or tool.Name:lower():find("knife"))
end

-- Loop auto kill
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

-- Toggle GUI
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

-- ========== TAB TELEPORT PLAYER ==========
local TeleportTab = Window:MakeTab({
    Name = "Teleport Player",
    Icon = "rbxassetid://4483345998"
})

-- Info di tab
TeleportTab:AddParagraph("📌 Teleport Player", "Klik nama player untuk teleport.")

-- Buat frame untuk daftar player (menggunakan elemen Orion)
local playerSection = TeleportTab:AddSection("Daftar Player")

-- Variabel untuk menyimpan tombol-tombol player
local playerButtons = {}

-- Fungsi update daftar player
local function updatePlayerListUI()
    -- Hapus tombol lama
    for _, btn in ipairs(playerButtons) do
        pcall(function() btn:Destroy() end)
    end
    playerButtons = {}
    
    -- Buat tombol untuk setiap player
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

-- Update saat player masuk/keluar
Players.PlayerAdded:Connect(updatePlayerListUI)
Players.PlayerRemoving:Connect(updatePlayerListUI)

-- Update pertama kali
updatePlayerListUI()

-- ========== TAB TELEPORT PLAYER ==========
local TeleportTab = Window:MakeTab({
    Name = "Teleport Player",
    Icon = "rbxassetid://4483345998"
})

-- Load module
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src.lua"))()

-- Fungsi cek apakah pemain adalah Murderer
local function isMurderer(player)
    local char = player.Character
    if char then
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool then
            local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
            if weaponType == "Knife" then return true end
            if tool.Name:lower():find("knife") then return true end
        end
    end
    return false
end

-- Simpan fungsi asli GetClosestPlayer
local originalGetClosestPlayer = Aimbot.GetClosestPlayer

-- Override fungsi GetClosestPlayer
Aimbot.GetClosestPlayer = function()
    -- Cari pemain terdekat yang merupakan Murderer
    local closest = nil
    local shortestDist = Aimbot.FOVSettings.Radius or 2000
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    local camera = workspace.CurrentCamera
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer and isMurderer(player) then
            local char = player.Character
            if char and char:FindFirstChild("Head") then
                local screenPos, onScreen = camera:WorldToViewportPoint(char.Head.Position)
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
    
    Aimbot.Locked = closest
    return closest
end

-- Konfigurasi lain (sama seperti di atas)
Aimbot.Settings = {
    Enabled = true,
    TeamCheck = false,
    AliveCheck = true,
    WallCheck = false,
    Sensitivity = 0,
    Sensitivity2 = 3.5,
    LockMode = 2, -- pake mousemoverel biar lebih stabil
    LockPart = "Head",
    TriggerKey = Enum.UserInputType.MouseButton2,
    Toggle = false
}

Aimbot.FOVSettings = {
    Enabled = true,
    Visible = true,
    Radius = 150,
    Color = Color3.fromRGB(255, 0, 0),
    LockedColor = Color3.fromRGB(0, 255, 0)
}

-- Load aimbot
Aimbot:Load()

print("✅ Aimbot aktif! Hanya membidik Murderer.")

OrionLib:MakeNotification({Name = "GAR N CUY", Content = "Loaded! Buka tab Game Exploits.", Time = 3})
OrionLib:Init()