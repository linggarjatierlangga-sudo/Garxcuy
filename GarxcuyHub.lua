local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "INI GAR N CUYY YA KUNYUKK",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "MATAMUU PICEKK",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AnimTab = Window:CreateTab("Animation Hack", 4483362458)
local EffectTab = Window:CreateTab("Click Effect", 7733774602)
local GuiTab = Window:CreateTab("GUI Module", 4483345998)
local GameTab = Window:CreateTab("Game Exploits", 7734022041)

-- ========== ESP MURDER MYSTERY 2 (STABIL) ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local highlightFolder = nil
local espActive = false
local connection = nil
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
            if connection then connection:Disconnect() end
            connection = RunService.RenderStepped:Connect(updateESP)
            Rayfield:Notify({Title = "ESP", Content = "Aktif!", Duration = 2})
        else
            if connection then connection:Disconnect(); connection = nil end
            if highlightFolder then
                for _, child in ipairs(highlightFolder:GetChildren()) do child:Destroy() end
            end
            roleCache = {}
        end
    end
})

-- ========== AIMBOT (HANYA KE MURDERER) ==========
local aimbotActive = false
local aimbotConnection = nil
local aimbotFOV = 100

local function getClosestMurderer()
    local closest = nil
    local shortestDist = aimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Hanya target jika role-nya Murderer
            local role = getPlayerRole(player)
            if role == "Murderer" then
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

local function aimAtTarget(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.Character.HumanoidRootPart.Position
        local screenPos = Camera:WorldToViewportPoint(targetPos)
        if screenPos.Z > 0 then
            mousemoveabs(screenPos.X, screenPos.Y)
        end
    end
end

local function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotActive then return end
        local target = getClosestMurderer()
        if target then
            aimAtTarget(target)
        end
    end)
end

GameTab:CreateToggle({
    Name = "🎯 Aimbot (Hanya ke Murderer)",
    CurrentValue = false,
    Callback = function(state)
        aimbotActive = state
        if state then
            startAimbot()
            Rayfield:Notify({Title = "Aimbot", Content = "Hanya membidik Murderer!", Duration = 2})
        else
            if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
        end
    end
})

GameTab:CreateSlider({
    Name = "FOV Aimbot (Radius)",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(value)
        aimbotFOV = value
    end
})

-- ========== FLY + NOCLIP SCRIPT ==========
GameTab:CreateButton({
    Name = "🚀 Load Fly + Noclip",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-And-Noclip-GUI-192488"))()
        Rayfield:Notify({Title = "Fly + Noclip", Content = "Script loaded!", Duration = 3})
    end
})

-- Notifikasi selesai
Rayfield:Notify({Title = "Eye GPT Hub", Content = "Loaded! Buka tab Game Exploits.", Duration = 3})