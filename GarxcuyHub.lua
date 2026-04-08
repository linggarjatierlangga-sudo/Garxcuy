local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "INI LINGGAR YANG UNCH BANGET",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "UJI COBA ATAU UJI AJA",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local GameTab = Window:CreateTab("Game Exploits", 7734022041)

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

GameTab:CreateToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    CurrentValue = false,
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
            Rayfield:Notify({Title = "ESP", Content = "Aktif!", Duration = 2})
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

GameTab:CreateToggle({
    Name = "🎯 Aimbot Khusus Murderer (Auto Aim)",
    CurrentValue = false,
    Callback = function(state)
        aimbotActive = state
        if state then
            startAimbotLoop()
            Rayfield:Notify({Title = "Aimbot", Content = "Membidik Murderer!", Duration = 2})
        else
            if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
        end
    end
})

GameTab:CreateSlider({
    Name = "FOV Aimbot (Radius Layar)",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(value)
        aimbotFOV = value
    end
})

-- ========== FLY + NOCLIP ==========
GameTab:CreateButton({
    Name = "🚀 Load Fly + Noclip",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-And-Noclip-GUI-192488"))()
        Rayfield:Notify({Title = "Fly + Noclip", Content = "Loaded!", Duration = 2})
    end
})

-- ========== AUTO STEAL BRAINROT (COSMIC/DIVINE/ETERNAL/SECRET) ==========
local autoStealActive = false
local stealConnection = nil
local currentTargetPart = nil

-- Coba panggil module PositionFinder
local PositionFinder = nil
pcall(function()
    PositionFinder = require(game:GetService("ReplicatedStorage").Library.Client.BrainrotEggCmds.BrainrotEggPositionFinder)
end)

-- Fungsi mencari part brainrot (fallback)
local function findBrainrotPart()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("brainrot") or part.Name:lower():find("egg")) then
            local rarity = part:GetAttribute("Rarity")
            if rarity then
                local rUp = string.upper(rarity)
                if rUp:find("COSMIC") or rUp:find("DIVINE") or rUp:find("ETERNAL") or rUp:find("SECRET") then
                    return part
                end
            else
                return part
            end
        end
    end
    return nil
end

local function teleportToPart(part)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3, 0)
    end
end

local function takeBrainrot(rarity)
    local productId = nil
    local rarityUpper = string.upper(rarity or "")
    if rarityUpper:find("COSMIC") then
        productId = 3569343071
    elseif rarityUpper:find("DIVINE") then
        productId = 3569343474
    elseif rarityUpper:find("ETERNAL") then
        productId = 3569343339
    elseif rarityUpper:find("SECRET") then
        productId = 3569343224
    end
    if productId then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseStealTakeBack", true)
        if remote then
            remote:FireServer(productId)
            print("[AutoSteal] Purchase", productId)
        else
            -- Cari tombol take di GUI
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, btn in ipairs(playerGui:GetDescendants()) do
                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and (btn.Text:lower():find("take") or btn.Name:lower():find("take")) then
                        btn:Click()
                        break
                    end
                end
            end
        end
    end
end

local function startStealLoop()
    if stealConnection then stealConnection:Disconnect() end
    stealConnection = RunService.RenderStepped:Connect(function()
        if not autoStealActive then return end
        local targetPart = nil
        if PositionFinder then
            local success, positions = pcall(function()
                return PositionFinder.ComputePositions(1, nil, nil)
            end)
            if success and positions and #positions > 0 then
                local pos = positions[1]
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Position - pos).Magnitude < 2 then
                        targetPart = part
                        break
                    end
                end
            end
        end
        if not targetPart then
            targetPart = findBrainrotPart()
        end
        if targetPart and targetPart ~= currentTargetPart then
            currentTargetPart = targetPart
            teleportToPart(targetPart)
            task.wait(0.5)
            local rarity = targetPart:GetAttribute("Rarity") or "Secret"
            takeBrainrot(rarity)
            task.wait(1)
            currentTargetPart = nil
        end
    end)
end

-- ========== AUTO STEAL BRAINROT (PER RARITY) - FIXED ==========
local autoSteal = {
    Cosmic = false,
    Divine = false,
    Eternal = false,
    Secret = false
}
local stealConnections = {
    Cosmic = nil,
    Divine = nil,
    Eternal = nil,
    Secret = nil
}
local lastStolen = {
    Cosmic = 0,
    Divine = 0,
    Eternal = 0,
    Secret = 0
}
local stealCooldown = 3 -- cooldown 3 detik per rarity

-- Fungsi mencari part brainrot berdasarkan rarity (lebih fleksibel)
local function findBrainrotPartByRarity(targetRarity)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            -- Cek berdasarkan nama part
            if name:find("brainrot") or name:find("egg") or name:find("brain") then
                -- Cek attribute Rarity
                local rarityAttr = part:GetAttribute("Rarity")
                if rarityAttr and string.upper(rarityAttr) == targetRarity then
                    return part
                end
                -- Cek nama part mengandung rarity (misal "BrainrotCosmic")
                if name:find(targetRarity:lower()) then
                    return part
                end
                -- Cek parent atau child
                local parent = part.Parent
                if parent then
                    local parentName = parent.Name:lower()
                    if parentName:find(targetRarity:lower()) then
                        return part
                    end
                end
            end
        end
    end
    return nil
end

-- Teleport ke part
local function teleportToPart(part)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3, 0)
        return true
    end
    return false
end

-- Fungsi mengambil brainrot (panggil remote)
local function takeBrainrot(rarity)
    local productId = nil
    if rarity == "COSMIC" then
        productId = 3569343071
    elseif rarity == "DIVINE" then
        productId = 3569343474
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
            -- Fallback: cari tombol Take di GUI
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

-- Loop untuk masing-masing rarity
local function startStealLoop(rarity)
    if stealConnections[rarity] then stealConnections[rarity]:Disconnect() end
    stealConnections[rarity] = RunService.RenderStepped:Connect(function()
        if not autoSteal[rarity] then return end
        if tick() - lastStolen[rarity] < stealCooldown then return end
        
        local targetPart = findBrainrotPartByRarity(rarity)
        if targetPart then
            print("[AutoSteal] Found " .. rarity .. " brainrot at", targetPart.Position)
            lastStolen[rarity] = tick()
            teleportToPart(targetPart)
            task.wait(0.5)
            takeBrainrot(rarity)
            task.wait(1)
        end
    end)
end

-- Buat toggle untuk setiap rarity
GameTab:CreateToggle({
    Name = "💀 Auto Steal Brainrot COSMIC",
    CurrentValue = false,
    Callback = function(state)
        autoSteal.Cosmic = state
        if state then
            startStealLoop("COSMIC")
            Rayfield:Notify({Title = "Auto Steal", Content = "Mencari Cosmic...", Duration = 2})
        else
            if stealConnections.Cosmic then stealConnections.Cosmic:Disconnect(); stealConnections.Cosmic = nil end
        end
    end
})

GameTab:CreateToggle({
    Name = "💀 Auto Steal Brainrot DIVINE",
    CurrentValue = false,
    Callback = function(state)
        autoSteal.Divine = state
        if state then
            startStealLoop("DIVINE")
            Rayfield:Notify({Title = "Auto Steal", Content = "Mencari Divine...", Duration = 2})
        else
            if stealConnections.Divine then stealConnections.Divine:Disconnect(); stealConnections.Divine = nil end
        end
    end
})

GameTab:CreateToggle({
    Name = "💀 Auto Steal Brainrot ETERNAL",
    CurrentValue = false,
    Callback = function(state)
        autoSteal.Eternal = state
        if state then
            startStealLoop("ETERNAL")
            Rayfield:Notify({Title = "Auto Steal", Content = "Mencari Eternal...", Duration = 2})
        else
            if stealConnections.Eternal then stealConnections.Eternal:Disconnect(); stealConnections.Eternal = nil end
        end
    end
})

GameTab:CreateToggle({
    Name = "💀 Auto Steal Brainrot SECRET",
    CurrentValue = false,
    Callback = function(state)
        autoSteal.Secret = state
        if state then
            startStealLoop("SECRET")
            Rayfield:Notify({Title = "Auto Steal", Content = "Mencari Secret...", Duration = 2})
        else
            if stealConnections.Secret then stealConnections.Secret:Disconnect(); stealConnections.Secret = nil end
        end
    end
})

-- Tombol teleport manual untuk masing-masing rarity (opsional)
GameTab:CreateButton({
    Name = "📍 Teleport ke Cosmic Terdekat",
    Callback = function()
        local part = findBrainrotPartByRarity("COSMIC")
        if part then
            teleportToPart(part)
            Rayfield:Notify({Title = "Teleport", Content = "Ke Cosmic!", Duration = 1})
        else
            Rayfield:Notify({Title = "Teleport", Content = "Tidak ada Cosmic", Duration = 1})
        end
    end
})

GameTab:CreateButton({
    Name = "📍 Teleport ke Divine Terdekat",
    Callback = function()
        local part = findBrainrotPartByRarity("DIVINE")
        if part then
            teleportToPart(part)
            Rayfield:Notify({Title = "Teleport", Content = "Ke Divine!", Duration = 1})
        else
            Rayfield:Notify({Title = "Teleport", Content = "Tidak ada Divine", Duration = 1})
        end
    end
})

GameTab:CreateButton({
    Name = "📍 Teleport ke Eternal Terdekat",
    Callback = function()
        local part = findBrainrotPartByRarity("ETERNAL")
        if part then
            teleportToPart(part)
            Rayfield:Notify({Title = "Teleport", Content = "Ke Eternal!", Duration = 1})
        else
            Rayfield:Notify({Title = "Teleport", Content = "Tidak ada Eternal", Duration = 1})
        end
    end
})

GameTab:CreateButton({
    Name = "📍 Teleport ke Secret Terdekat",
    Callback = function()
        local part = findBrainrotPartByRarity("SECRET")
        if part then
            teleportToPart(part)
            Rayfield:Notify({Title = "Teleport", Content = "Ke Secret!", Duration = 1})
        else
            Rayfield:Notify({Title = "Teleport", Content = "Tidak ada Secret", Duration = 1})
        end
    end
})

-- Notifikasi awal
Rayfield:Notify({Title = "Eye GPT All-in-One Hub", Content = "Loaded! Buka tab Game Exploits.", Duration = 3})