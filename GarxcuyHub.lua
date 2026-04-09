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

-- ========== ESP DENGAN DETEKSI ROLE MAKSIMAL ==========
local espObjects = {}
local espActive = false
local espConnection = nil

-- Fungsi deteksi role (gabungan dari berbagai sumber)
local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    
    -- 1. Cek dari atribut player
    local roleAttr = player:GetAttribute("Role") or player:GetAttribute("PlayerRole")
    if roleAttr then
        local roleUpper = string.upper(tostring(roleAttr))
        if roleUpper:find("MURDER") then return "Murderer" end
        if roleUpper:find("SHERIFF") then return "Sheriff" end
    end
    
    -- 2. Cek dari leaderstats (jika ada)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local roleStat = leaderstats:FindFirstChild("Role") or leaderstats:FindFirstChild("Team")
        if roleStat then
            local roleValue = tostring(roleStat.Value):upper()
            if roleValue:find("MURDER") then return "Murderer" end
            if roleValue:find("SHERIFF") then return "Sheriff" end
        end
    end
    
    -- 3. Cek dari tool yang dipegang (fallback)
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
                -- Dapatkan ukuran karakter
                local size = char:GetExtentsSize()
                local topPos, _ = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(0, size.Y/2, 0)).Position)
                local bottomPos, _ = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(0, -size.Y/2, 0)).Position)
                
                local screenHeight = bottomPos.Y - topPos.Y
                local screenWidth = screenHeight * 0.6
                local boxLeft = topPos.X - screenWidth/2
                local boxTop = topPos.Y
                
                -- Update Box ESP
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
                
                -- Update Name ESP
                objects.Name.Text = player.Name .. " [" .. role .. "]"
                objects.Name.Position = Vector2.new(topPos.X, topPos.Y - 15)
                objects.Name.Color = color
                objects.Name.Visible = true
                
                -- Update Tracer
                objects.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                objects.Tracer.To = Vector2.new(boxLeft + screenWidth/2, boxTop + screenHeight)
                objects.Tracer.Color = color
                objects.Tracer.Visible = true
            else
                -- Sembunyikan semua
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

-- Toggle ESP
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
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif! (Multi-Detection)", Time = 2})
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            for player, _ in pairs(espObjects) do
                removeESPForPlayer(player)
            end
        end
    end
})

-- Update ESP saat player masuk/keluar
Players.PlayerAdded:Connect(function(player)
    if espActive and player ~= LocalPlayer then
        createESPForPlayer(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        removeESPForPlayer(player)
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
-- ========== TELEPORT PLAYER ==========
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