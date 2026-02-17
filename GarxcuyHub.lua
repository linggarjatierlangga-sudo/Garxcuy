-- Auto Fishing + Fast Reel (SIMPLE)
-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Remote auto fishing resmi
local LevelSystem = ReplicatedStorage:FindFirstChild("LevelSystem")
local ToServer = LevelSystem and LevelSystem:FindFirstChild("ToServer")
local StartAutoFishing = ToServer and ToServer:FindFirstChild("StartAutoFishing")
local StopAutoFishing = ToServer and ToServer:FindFirstChild("StopAutoFishing")

-- Remote reel (pilih salah satu yang work)
local ReelRemote = ReplicatedStorage:FindFirstChild("ReelFinished", true) 
                 or ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract", true)
                 or ReplicatedStorage:FindFirstChild("FishingCatchSuccess", true)

-- Variabel
local autoFishingActive = false
local fastReelActive = false
local fastReelSpeed = 0.3
local fastReelConn = nil

-- Buat window
local Window = OrionLib:MakeWindow({Name = "Auto Fish + Fast Reel", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Fishing", Icon = "rbxassetid://4483345998"})

-- Tombol Auto Fishing Resmi
local afkBtn = Tab:AddButton({
    Name = "▶️ Mulai Auto Fishing (Resmi)",
    Callback = function()
        if not autoFishingActive and StartAutoFishing then
            StartAutoFishing:FireServer()
            autoFishingActive = true
            afkBtn:Set("⏸️ Hentikan Auto Fishing")
        elseif autoFishingActive and StopAutoFishing then
            StopAutoFishing:FireServer()
            autoFishingActive = false
            afkBtn:Set("▶️ Mulai Auto Fishing (Resmi)")
        end
    end
})

-- Toggle Fast Reel
Tab:AddToggle({
    Name = "⚡ Fast Reel (Manual)",
    Default = false,
    Callback = function(state)
        fastReelActive = state
        if state then
            if not ReelRemote then
                OrionLib:MakeNotification({Name = "Error", Content = "Remote reel tidak ditemukan!", Time = 2})
                fastReelActive = false
                return
            end
            -- Loop fast reel
            if fastReelConn then fastReelConn:Disconnect() end
            fastReelConn = RunService.Heartbeat:Connect(function()
                if fastReelActive and ReelRemote then
                    pcall(function() ReelRemote:FireServer() end)
                    wait(fastReelSpeed)
                end
            end)
            OrionLib:MakeNotification({Name = "Fast Reel", Content = "Aktif!", Time = 2})
        else
            if fastReelConn then fastReelConn:Disconnect() end
        end
    end
})

-- Slider kecepatan fast reel
Tab:AddSlider({
    Name = "Kecepatan Fast Reel (detik)",
    Min = 0.1, Max = 1.0, Default = 0.3,
    Callback = function(v) fastReelSpeed = v end
})

-- Tombol test manual (opsional)
if ReelRemote then
    Tab:AddButton({
        Name = "Test Reel Manual",
        Callback = function() ReelRemote:FireServer() end
    })
end

OrionLib:Init()