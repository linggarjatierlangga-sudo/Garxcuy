-- ========== RAYFIELD LIBRARY ==========
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "GAR N CUY BOCAH EPEP",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "ESP + Auto Kill + Teleport",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GARConfig",
        FileName = "Config"
    },
    KeySystem = false
})

-- ========== TABS ==========
local GameTab = Window:CreateTab("Game Exploits", 7734022041)
local TeleportTab = Window:CreateTab("Teleport Player", 4483345998)

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== ESP MURDERER & SHERIFF ==========
local espObjects = {}
local espActive = false
local espConnection = nil

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    
    -- 1. Cek dari atribut player
    local roleAttr = player:GetAttribute("Role") or player:GetAttribute("PlayerRole")
    if roleAttr then
        local roleUpper = string.upper(tostring(roleAttr))
        if roleUpper:find("MURDER") then return "Murderer" end
        if roleUpper:find("SHERIFF") then return "Sheriff" end
    end
    
    -- 2. Cek dari leaderstats
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

-- Toggle ESP
GameTab:CreateToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    CurrentValue = false,
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
            Rayfield:Notify({Title = "ESP", Content = "Aktif!", Duration = 2})
        else
            if espConnection then espConnection:Disconnect(); espConnection = nil end
            for player, _ in pairs(espObjects) do
                removeESPForPlayer(player)
            end
        end
    end
})

-- ========== AUTO KILL + TELEPORT ==========
local killRemotes = {}
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        local name = remote.Name:lower()
        if name:find("stab") or name:find("kill") or name:find("attack") or name:find("murder") or name:find("knife") then
            table.insert(killRemotes, remote)
        end
    end
end

local function killPlayer(target)
    if #killRemotes == 0 then return false end
    for _, remote in ipairs(killRemotes) do
        pcall(function() remote:FireServer(target) end)
        pcall(function() remote:FireServer(target.Character) end)
        pcall(function() remote:FireServer(target.UserId) end)
        pcall(function() remote:FireServer({target = target, userId = target.UserId}) end)
    end
    return true
end

local function teleportToTarget(target)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            char.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(2, 0, 2)
            return true
        end
    end
    return false
end

local function isMurderer()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
        if weaponType == "Knife" then return true end
        if tool.Name:lower():find("knife") then return true end
    end
    local role = LocalPlayer:GetAttribute("Role") or LocalPlayer:GetAttribute("PlayerRole")
    if role and string.upper(tostring(role)):find("MURDER") then return true end
    return false
end

local autoActive = false
local autoConnection = nil

local function startAutoKill()
    if autoConnection then autoConnection:Disconnect() end
    autoConnection = RunService.RenderStepped:Connect(function()
        if not autoActive or not isMurderer() then return end
        
        local target = nil
        local minDist = 30
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
            teleportToTarget(target)
            task.wait(0.1)
            killPlayer(target)
            task.wait(0.5)
        end
    end)
end

GameTab:CreateToggle({
    Name = "🔪 Auto Kill + Teleport (Murderer Only)",
    CurrentValue = false,
    Callback = function(state)
        autoActive = state
        if state then
            if #killRemotes == 0 then
                Rayfield:Notify({Title = "Error", Content = "Tidak ada remote kill ditemukan!", Duration = 3})
                return
            end
            startAutoKill()
            Rayfield:Notify({Title = "Auto Kill", Content = "Aktif! Jarak 30 studs", Duration = 2})
        else
            if autoConnection then autoConnection:Disconnect(); autoConnection = nil end
        end
    end
})

-- ========== TELEPORT PLAYER ==========
TeleportTab:CreateParagraph("📌 Teleport Player", "Klik nama player untuk teleport.")

local playerSection = nil
local playerButtons = {}

local function updatePlayerListUI()
    if playerSection then
        for _, btn in ipairs(playerButtons) do
            pcall(function() btn:Destroy() end)
        end
        playerButtons = {}
        playerSection:Destroy()
    end
    
    playerSection = TeleportTab:CreateSection("Daftar Player")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = playerSection:CreateButton({
                Name = player.Name .. " [" .. (player.DisplayName or player.Name) .. "]",
                Callback = function()
                    local char = LocalPlayer.Character
                    local targetChar = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
                        Rayfield:Notify({Title = "Teleport", Content = "Ke " .. player.Name, Duration = 1})
                    else
                        Rayfield:Notify({Title = "Error", Content = "Gagal teleport!", Duration = 1})
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
Rayfield:Notify({Title = "GAR N CUY", Content = "Loaded! Buka tab Game Exploits.", Duration = 3})