-- Auto Fishing LENGKAP (Cast + Minigame + Reel)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Auto Fishing LENGKAP", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Fishing"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== AMBIL SEMUA REMOTE =====
local Fishing_RemoteThrow = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local Fishing_RemoteRetract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
local FishingCatchSuccess = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")
local MinigameStart = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameStart")
local MinigameEnd = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameEnd")
local StartMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StartMeter")
local StopMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StopMeter")
local ThrowState = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_ThrowState")
local AutoFishingState = ReplicatedStorage:FindFirstChild("AutoFishingState_9883448335")

-- ===== STATE TRACKING =====
local currentState = "IDLE"
if ThrowState and ThrowState:IsA("BindableEvent") then
    ThrowState.Event:Connect(function(state)
        currentState = state
        print("[State]", state)
    end)
end

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local autoFishConn = nil
local castDelay = 2.0
local useMeter = false

-- ===== FUNGSI AUTO FISHING =====
local function startAutoFishing()
    if not Fishing_RemoteThrow then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote throw tidak ditemukan!", Time = 2})
        return false
    end
    if not Fishing_RemoteRetract and not FishingCatchSuccess then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote reel tidak ditemukan!", Time = 2})
        return false
    end
    
    autoFishConn = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        
        -- State machine berdasarkan ThrowState
        if currentState == "IDLE" or currentState == "idle" then
            -- Cast pancing
            pcall(function()
                if useMeter and StartMeter then
                    StartMeter:FireServer()
                    wait(0.3)
                end
                Fishing_RemoteThrow:FireServer()
                print("[Auto] Cast")
            end)
            wait(castDelay)
            
        elseif currentState == "WAITING" or currentState == "waiting" or currentState == "PARKED" then
            -- Ikan lagi gigit? Tunggu bentar, mungkin masuk minigame
            wait(1)
            
        elseif currentState == "MINIGAME" then
            -- Otomatis menang minigame dengan fire MinigameEnd
            pcall(function()
                if MinigameEnd then
                    MinigameEnd:FireServer()
                    print("[Auto] Minigame end")
                elseif Fishing_RemoteRetract then
                    Fishing_RemoteRetract:FireServer()
                elseif FishingCatchSuccess then
                    FishingCatchSuccess:FireServer()
                end
            end)
            wait(1)
            
        else
            wait(0.5)
        end
    end)
    
    OrionLib:MakeNotification({Name = "Auto Fish", Content = "Dimulai!", Time = 2})
    return true
end

-- ===== GUI =====
Tab:AddParagraph({
    Title = "Remote Tersedia",
    Content = [[
- Fishing_RemoteThrow (cast)
- Fishing_RemoteRetract (reel)
- FishingCatchSuccess (alternatif)
- MinigameStart/End
- StartMeter/StopMeter
- ThrowState (event state)
    ]]
})

-- Toggle auto fishing
Tab:AddToggle({
    Name = "🎣 Auto Fishing (Lengkap)",
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

-- Slider delay cast
Tab:AddSlider({
    Name = "Delay Cast (detik)",
    Min = 0.5, Max = 5.0, Default = 2.0, Increment = 0.1,
    Callback = function(v) castDelay = v end
})

-- Toggle StartMeter
Tab:AddToggle({
    Name = "Gunakan StartMeter sebelum cast",
    Default = false,
    Callback = function(v) useMeter = v end
})

-- Tombol test manual
Tab:AddButton({
    Name = "Test Throw",
    Callback = function()
        if Fishing_RemoteThrow then
            Fishing_RemoteThrow:FireServer()
            OrionLib:MakeNotification({Name = "Test", Content = "Throw fired", Time = 1})
        end
    end
})

Tab:AddButton({
    Name = "Test Retract",
    Callback = function()
        if Fishing_RemoteRetract then
            Fishing_RemoteRetract:FireServer()
            OrionLib:MakeNotification({Name = "Test", Content = "Retract fired", Time = 1})
        end
    end
})

Tab:AddButton({
    Name = "Test CatchSuccess",
    Callback = function()
        if FishingCatchSuccess then
            FishingCatchSuccess:FireServer()
            OrionLib:MakeNotification({Name = "Test", Content = "CatchSuccess fired", Time = 1})
        end
    end
})

Tab:AddButton({
    Name = "Test MinigameEnd",
    Callback = function()
        if MinigameEnd then
            MinigameEnd:FireServer()
            OrionLib:MakeNotification({Name = "Test", Content = "MinigameEnd fired", Time = 1})
        end
    end
})

Tab:AddButton({
    Name = "Test StartMeter",
    Callback = function()
        if StartMeter then
            StartMeter:FireServer()
            OrionLib:MakeNotification({Name = "Test", Content = "StartMeter fired", Time = 1})
        end
    end
})

-- Info state
Tab:AddParagraph({
    Title = "State Saat Ini",
    Content = "ThrowState akan muncul di console (F9)"
})

OrionLib:Init()