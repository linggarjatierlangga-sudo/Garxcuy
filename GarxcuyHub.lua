https://raw.githubusercontent.com/adamowaissi22-boop/Axom-Scripts-/refs/heads/main/Axion%20Ui%20Library
local Window = Axion:CreateWindow({
    Name = "Axion - Demo Script",
    Subtitle = "UI Library Demo",
    Version = "v1.0",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AxionConfig",
        FileName = "DemoConfig"
    }
})
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "⭐"
})

local VisualTab = Window:CreateTab({
    Name = "Visual",
    Icon = "👁️"
})
local noclipToggle = MainSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(value)
        -- Your code here
    end
})
local teleportButton = MainSection:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local player = game.Players.LocalPlayer
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
    end
})
local walkSpeedSlider = VisualSection:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
local themeDropdown = SettingsSection:CreateDropdown({
    Name = "Theme",
    Options = {"Default", "Dark", "Light"},
    CurrentOption = "Default",
    Flag = "Theme",
    Callback = function(value)
        Window:SetTheme(value)
    end
})
local textInput = Section:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    CurrentValue = "",
    Flag = "PlayerName",
    Callback = function(value)
        -- Process input
    end
})
-- ===== AUTO FISHING TAB (AXION LIBRARY) =====
-- Tambahkan ini di bawah script demo Axion

-- Services yang diperlukan
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Remote fishing (ambil dengan aman)
local Throw = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow") or 
              (ReplicatedStorage:FindFirstChild("Fishing") and ReplicatedStorage.Fishing:FindFirstChild("ToServer") and ReplicatedStorage.Fishing.ToServer:FindFirstChild("CastReleased"))

local Retract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract") or 
                (ReplicatedStorage:FindFirstChild("Fishing") and ReplicatedStorage.Fishing:FindFirstChild("ToServer") and ReplicatedStorage.Fishing.ToServer:FindFirstChild("ReelFinished"))

local Catch = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")

-- Auto fishing resmi
local LevelSystem = ReplicatedStorage:FindFirstChild("LevelSystem")
local LevelToServer = LevelSystem and LevelSystem:FindFirstChild("ToServer")
local StartAuto = LevelToServer and LevelToServer:FindFirstChild("StartAutoFishing")
local StopAuto = LevelToServer and LevelToServer:FindFirstChild("StopAutoFishing")

-- Buat tab baru untuk auto fishing
local AutoFishTab = Window:CreateTab({
    Name = "Auto Fish",
    Icon = "🎣"
})

-- ===== SECTION: REMOTE STATUS =====
local RemoteSection = AutoFishTab:CreateSection("Remote Status")
RemoteSection:CreateLabel("Status remote yang ditemukan:")

if Throw then
    RemoteSection:CreateLabel("✅ Throw: " .. Throw.Name)
else
    RemoteSection:CreateLabel("❌ Throw: Tidak ditemukan")
end

if Retract then
    RemoteSection:CreateLabel("✅ Retract: " .. Retract.Name)
else
    RemoteSection:CreateLabel("❌ Retract: Tidak ditemukan")
end

if Catch then
    RemoteSection:CreateLabel("✅ Catch: " .. Catch.Name)
else
    RemoteSection:CreateLabel("❌ Catch: Tidak ditemukan")
end

if StartAuto then
    RemoteSection:CreateLabel("✅ StartAutoFishing: Ditemukan")
else
    RemoteSection:CreateLabel("❌ StartAutoFishing: Tidak ditemukan")
end

-- ===== SECTION: AUTO FISHING RESMI =====
local AutoSection = AutoFishTab:CreateSection("Auto Fishing Resmi")
local autoActive = false

AutoSection:CreateToggle({
    Name = "Aktifkan Auto Fishing",
    CurrentValue = false,
    Callback = function(value)
        autoActive = value
        if value then
            if StartAuto then
                StartAuto:FireServer()
                print("[Auto] StartAutoFishing fired")
            else
                warn("StartAutoFishing tidak ditemukan")
            end
        else
            if StopAuto then
                StopAuto:FireServer()
            elseif StartAuto then
                StartAuto:FireServer() -- Mungkin toggle
            end
        end
    end
})

-- ===== SECTION: FAST REEL =====
local FastSection = AutoFishTab:CreateSection("Fast Reel (Berisiko)")
local fastActive = false
local fastSpeed = 1.0
local fastConn = nil

local fastToggle = FastSection:CreateToggle({
    Name = "Aktifkan Fast Reel",
    CurrentValue = false,
    Callback = function(value)
        fastActive = value
        if value then
            if not Retract and not Catch then
                warn("Tidak ada remote reel")
                return
            end
            fastConn = RunService.Heartbeat:Connect(function()
                if not fastActive then return end
                if Retract then
                    pcall(function() Retract:FireServer() end)
                end
                if Catch then
                    pcall(function() Catch:FireServer() end)
                end
                task.wait(fastSpeed)
            end)
        else
            if fastConn then
                fastConn:Disconnect()
                fastConn = nil
            end
        end
    end
})

FastSection:CreateSlider({
    Name = "Kecepatan (detik)",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 1.0,
    Callback = function(value)
        fastSpeed = value
    end
})

-- ===== SECTION: TEST MANUAL =====
local TestSection = AutoFishTab:CreateSection("Test Manual")

TestSection:CreateButton({
    Name = "Test Throw",
    Callback = function()
        if Throw then
            Throw:FireServer()
            print("[Test] Throw fired")
        end
    end
})

TestSection:CreateButton({
    Name = "Test Retract",
    Callback = function()
        if Retract then
            Retract:FireServer()
            print("[Test] Retract fired")
        end
    end
})

TestSection:CreateButton({
    Name = "Test Catch",
    Callback = function()
        if Catch then
            Catch:FireServer(true) -- Coba dengan parameter true
            print("[Test] Catch fired")
        end
    end
})

-- ===== SECTION: SIMULASI SEDERHANA =====
local SimulSection = AutoFishTab:CreateSection("Simulasi")
local simulActive = false
local simulConn = nil

SimulSection:CreateToggle({
    Name = "Loop Cast → Reel",
    CurrentValue = false,
    Callback = function(value)
        simulActive = value
        if value then
            simulConn = RunService.Heartbeat:Connect(function()
                if not simulActive then return end
                if Throw then Throw:FireServer() end
                task.wait(2) -- Tunggu 2 detik
                if Retract then Retract:FireServer() end
                if Catch then Catch:FireServer() end
                task.wait(1) -- Jeda antar siklus
            end)
        else
            if simulConn then
                simulConn:Disconnect()
                simulConn = nil
            end
        end
    end
})

-- ===== SECTION: INFO =====
local InfoSection = AutoFishTab:CreateSection("Informasi")
InfoSection:CreateLabel("⚠️ Game ini punya anti-cheat ketat")
InfoSection:CreateLabel("Gunakan akun alt untuk testing")
InfoSection:CreateLabel("Fast reel sangat berisiko banned")