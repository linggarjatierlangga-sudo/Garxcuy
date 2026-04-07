-- ESP MURDER MYSTERY F B R (Dengan Cache Role & Deteksi Backpack)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "GAR N CUY KUNYUK",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "INI UJI COBA YA KUNYUKKKK",
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

local highlightFolder = nil
local espActive = false
local connection = nil
local roleCache = {} -- Cache role pemain

-- Fungsi untuk mendapatkan role pemain (lebih stabil)
local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end

    -- Cek dari cache dulu (biar tidak berubah-ubah)
    if roleCache[player] and (tick() - (roleCache[player].time or 0)) < 1.5 then
        return roleCache[player].role
    end

    local char = player.Character
    local role = "Innocent"

    -- Cek tool yang dipegang
    if char then
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool then
            local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
            if weaponType == "Knife" then
                role = "Murderer"
            elseif weaponType == "Gun" then
                role = "Sheriff"
            end
        end
    end

    -- Jika tidak ditemukan di tangan, cek backpack (inventory)
    if role == "Innocent" then
        local backpack = player:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
                    if weaponType == "Knife" then
                        role = "Murderer"
                        break
                    elseif weaponType == "Gun" then
                        role = "Sheriff"
                        break
                    end
                end
            end
        end
    end

    -- Update cache
    roleCache[player] = {role = role, time = tick()}
    return role
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
                highlight.Adornee = player.Character
            end
            if role == "Murderer" then
                highlight.FillColor = Color3.fromRGB(255, 0, 0)    -- Merah
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            elseif role == "Sheriff" then
                highlight.FillColor = Color3.fromRGB(0, 0, 255)    -- Biru
                highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
            else
                highlight.FillColor = Color3.fromRGB(0, 255, 0)    -- Hijau
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
            if not highlightFolder then
                highlightFolder = Instance.new("Folder")
                highlightFolder.Name = "MM2_ESP"
                highlightFolder.Parent = game:GetService("CoreGui")
            end
            for _, child in ipairs(highlightFolder:GetChildren()) do
                child:Destroy()
            end
            roleCache = {} -- reset cache
            if connection then connection:Disconnect() end
            connection = RunService.RenderStepped:Connect(updateESP)
            Rayfield:Notify({Title = "ESP", Content = "Aktif! Murderer merah, Sheriff biru.", Duration = 3})
        else
            if connection then connection:Disconnect(); connection = nil end
            if highlightFolder then
                for _, child in ipairs(highlightFolder:GetChildren()) do
                    child:Destroy()
                end
            end
            roleCache = {}
            Rayfield:Notify({Title = "ESP", Content = "Dimatikan.", Duration = 2})
        end
    end
})

-- Notifikasi selesai
Rayfield:Notify({Title = "Eye GPT Hub", Content = "Loaded! Buka tab Game Exploits.", Duration = 3})