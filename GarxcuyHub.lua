local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT All-in-One Hub",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "ESP + Aimbot + Auto Take",
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
        if aimbotActive then
            aimAtMurderer()
        end
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

-- ========== AUTO TAKE BRAINROT COSMIC/SECRET ==========
local autoTakeActive = false

local function findTakeButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    for _, button in ipairs(playerGui:GetDescendants()) do
        if button:IsA("TextButton") or button:IsA("ImageButton") then
            local text = (button.Text or button.Name or ""):lower()
            if text:find("claim") or text:find("take") or text:find("collect") then
                return button
            end
        end
    end
    return nil
end

local function setupAutoTake()
    -- Hook notifikasi jika ada
    if _G.FishNotification then
        local old = _G.FishNotification
        _G.FishNotification = function(fishName, weight, tier)
            if autoTakeActive and fishName and fishName:lower():find("brainrot") then
                local tierUpper = string.upper(tier or "")
                if tierUpper:find("COSMIC") or tierUpper:find("SECRET") then
                    task.wait(0.5)
                    local btn = findTakeButton()
                    if btn then
                        btn:Click()
                        print("[AutoTake] Brainrot " .. tier .. " diambil")
                    end
                end
            end
            if old then return old(fishName, weight, tier) end
        end
    else
        -- Pantau GUI
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        playerGui.DescendantAdded:Connect(function(desc)
            if autoTakeActive and desc:IsA("TextLabel") and desc.Text and desc.Text:lower():find("brainrot") then
                local parent = desc.Parent
                local isCosmicOrSecret = false
                if parent then
                    for _, child in ipairs(parent:GetChildren()) do
                        if child:IsA("TextLabel") then
                            local txt = child.Text:lower()
                            if txt:find("cosmic") or txt:find("secret") then
                                isCosmicOrSecret = true
                                break
                            end
                        end
                    end
                end
                if isCosmicOrSecret then
                    task.wait(0.5)
                    local btn = findTakeButton()
                    if btn then btn:Click() end
                end
            end
        end)
    end
end

GameTab:CreateToggle({
    Name = "⭐ Auto Take Brainrot Cosmic/Secret",
    CurrentValue = false,
    Callback = function(state)
        autoTakeActive = state
        if state then
            setupAutoTake()
            Rayfield:Notify({Title = "Auto Take", Content = "Aktif! Tunggu Brainrot Cosmic/Secret.", Duration = 3})
        else
            Rayfield:Notify({Title = "Auto Take", Content = "Dimatikan.", Duration = 2})
        end
    end
})

-- Notifikasi awal
Rayfield:Notify({Title = "Eye GPT All-in-One Hub", Content = "Loaded! Buka tab Game Exploits.", Duration = 3})