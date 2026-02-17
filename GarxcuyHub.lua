-- GarxCuy Hub for Mobile + AUTO FISH (Remote Asli)
-- Cocok buat Delta / executor HP

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

-- Buat Window
local Window = OrionLib:MakeWindow({
    Name = "GarxCuy Hub (Mobile)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GarxCuyMobile",
    IntroEnabled = true,
    IntroText = "GarxCuy Mobile",
    IntroIcon = "rbxassetid://4483345998"
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variabel global fitur lain (Player, Freecam, ESP, Other) tetap sama, tapi untuk hemat tempat kita tulis ulang nanti.
-- ... (semua fitur lama seperti sebelumnya) ...

-- ===== TAB AUTO FISH (REMOTE ASLI) =====
local AutoFishTab = Window:MakeTab({Name = "AUTO FISH", Icon = "rbxassetid://4483345998"})

-- Ambil remote dari folder Fishing.ToServer
local Fishing = ReplicatedStorage:FindFirstChild("Fishing")
local ToServer = Fishing and Fishing:FindFirstChild("ToServer")
if not ToServer then
    warn("[AutoFish] Folder Fishing.ToServer tidak ditemukan!")
end

local CastReleased = ToServer and ToServer:FindFirstChild("CastReleased")
local ReelFinished = ToServer and ToServer:FindFirstChild("ReelFinished")
local ReelInput = ToServer and ToServer:FindFirstChild("ReelInput")
local BobberHitWater = ToServer and ToServer:FindFirstChild("BobberHitWater")
local ThrowingStateSync = ToServer and ToServer:FindFirstChild("ThrowingStateSync")

-- Variabel auto fish
local autoFishing = false
local autoFishConn = nil
local castDelay = 2.0      -- waktu antara cast dan reel
local useBobber = false     -- apakah perlu mengirim BobberHitWater setelah cast

-- Fungsi auto fishing
local function startAutoFishing()
    if not CastReleased or not ReelFinished then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote Cast/Reel tidak ditemukan!", Time = 2})
        return false
    end
    
    -- Equip rod (pastikan rod di tangan)
    local rod = nil
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
                rod = tool; break
            end
        end
    end
    if not rod then
        OrionLib:MakeNotification({Name = "Error", Content = "Equip pancing dulu!", Time = 2})
        return false
    end
    
    autoFishConn = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        pcall(function()
            -- Cast pancing
            CastReleased:FireServer()
            print("[Auto] CastReleased fired")
            
            -- Opsional: kirim BobberHitWater setelah jeda (simulasi kail kena air)
            if useBobber and BobberHitWater then
                wait(0.5)
                BobberHitWater:FireServer()
                print("[Auto] BobberHitWater fired")
            end
            
            -- Tunggu sesuai delay
            wait(castDelay)
            
            -- Reel (tarik ikan)
            ReelFinished:FireServer()
            print("[Auto] ReelFinished fired")
        end)
    end)
    
    OrionLib:MakeNotification({Name = "Auto Fish", Content = "Dimulai dengan delay "..castDelay.." dtk", Time = 2})
    return true
end

-- GUI
AutoFishTab:AddParagraph({
    Title = "Remote Ditemukan",
    Content = "CastReleased, ReelFinished, dll. Pilih yang mau dipakai."
})

AutoFishTab:AddToggle({
    Name = "🎣 Auto Fishing (Cast → Reel)",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            if not startAutoFishing() then
                autoFishing = false
            end
        else
            if autoFishConn then autoFishConn:Disconnect(); autoFishConn = nil end
        end
    end
})

AutoFishTab:AddSlider({
    Name = "Delay Cast → Reel (detik)",
    Min = 0.5,
    Max = 5.0,
    Default = 2.0,
    Increment = 0.1,
    ValueName = "dtk",
    Callback = function(v) castDelay = v end
})

AutoFishTab:AddToggle({
    Name = "Kirim BobberHitWater setelah cast",
    Default = false,
    Callback = function(v) useBobber = v end
})

-- Tombol test manual
AutoFishTab:AddButton({
    Name = "Test CastReleased",
    Callback = function()
        if CastReleased then CastReleased:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test ReelFinished",
    Callback = function()
        if ReelFinished then ReelFinished:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test BobberHitWater",
    Callback = function()
        if BobberHitWater then BobberHitWater:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test ThrowingStateSync",
    Callback = function()
        if ThrowingStateSync then ThrowingStateSync:FireServer() end
    end
})

AutoFishTab:AddParagraph({
    Title = "Info",
    Content = "Gunakan test manual untuk memastikan remote bekerja.\nSetelah itu nyalakan auto fishing."
})

-- Notifikasi Selesai & Init
OrionLib:MakeNotification({Name = "GarxCuy Mobile", Content = "Loaded! + Auto Fish Remote Asli", Time = 3})
OrionLib:Init()