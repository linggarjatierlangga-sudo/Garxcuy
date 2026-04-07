local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Animate + Click Hub",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "Speed x100 + Effect Bomb",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AnimTab = Window:CreateTab("Animation Hack", 4483362458)
local EffectTab = Window:CreateTab("Click Effect", 7733774602)
local GuiTab = Window:CreateTab("GUI Module", 4483345998)
local GameTab = Window:CreateTab("Game Exploits", 7734022041)

-- ========== ESP MURDER MYSTERY 2 ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local highlightFolder = nil
local espActive = false
local connection = nil

-- Fungsi untuk mendapatkan role pemain
local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    local char = player.Character
    if not char then return "Unknown" end

    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return "Innocent" end

    local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
    if weaponType == "Knife" then
        return "Murderer"
    elseif weaponType == "Gun" then
        return "Sheriff"
    end

    local toolName = tool.Name:lower()
    if toolName:find("knife") or toolName:find("dagger") then
        return "Murderer"
    elseif toolName:find("gun") or toolName:find("pistol") then
        return "Sheriff"
    end
    return "Innocent"
end

-- Fungsi update ESP
local function updateESP()
    if not espActive then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = getPlayerRole(player)
            local highlight = highlightFolder:FindFirstChild(player.Name)
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = player.Name
                highlight.Parent = highlightFolder
                highlight.Adornee = player.Character
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
            else
                -- Update Adornee jika karakter berubah
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

-- Toggle ESP di tab Game Exploits
GameTab:CreateToggle({
    Name = "🔴 ESP Murderer (Merah) & Sheriff (Biru)",
    CurrentValue = false,
    Callback = function(state)
        espActive = state
        if state then
            -- Buat folder highlight jika belum ada
            if not highlightFolder then
                highlightFolder = Instance.new("Folder")
                highlightFolder.Name = "MM2_ESP"
                highlightFolder.Parent = game:GetService("CoreGui")
            end
            -- Hapus semua highlight lama
            for _, child in ipairs(highlightFolder:GetChildren()) do
                child:Destroy()
            end
            -- Mulai loop update
            if connection then connection:Disconnect() end
            connection = RunService.RenderStepped:Connect(updateESP)
            Rayfield:Notify({Title = "ESP", Content = "Aktif! Murderer merah, Sheriff biru.", Duration = 3})
        else
            -- Matikan ESP, hapus semua highlight
            if connection then connection:Disconnect(); connection = nil end
            if highlightFolder then
                for _, child in ipairs(highlightFolder:GetChildren()) do
                    child:Destroy()
                end
            end
            Rayfield:Notify({Title = "ESP", Content = "Dimatikan.", Duration = 2})
        end
    end
})

-- Notifikasi selesai
Rayfield:Notify({Title = "Eye GPT Hub", Content = "Loaded! Buka tab Game Exploits.", Duration = 3})