-- Auto Fishing + Fast Reel (STABIL)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Auto Fishing", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Fishing"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ===== AMBIL REMOTE (AMAN) =====
local ThrowRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local RetractRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
local CatchRemote = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")
local MinigameEnd = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameEnd")
local ThrowState = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_ThrowState")

-- ===== STATE TRACKING =====
local currentState = "IDLE"
if ThrowState and ThrowState:IsA("BindableEvent") then
    ThrowState.Event:Connect(function(state)
        currentState = state
        print("[State]", state)
    end)
end

-- ===== AUTO FISHING LENGKAP =====
local autoActive = false
local autoConn = nil
local castDelay = 2.0

local function startAutoFishing()
    if not ThrowRemote then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote throw tidak ada", Time = 2})
        return false
    end
    if not RetractRemote and not CatchRemote and not MinigameEnd then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote reel tidak ada", Time = 2})
        return false
    end
    
    autoConn = RunService.Heartbeat:Connect(function()
        if not autoActive then return end
        
        if currentState == "IDLE" or currentState == "idle" then
            pcall(function() ThrowRemote:FireServer() end)
            print("[Auto] Cast")
            wait(castDelay)
        elseif currentState == "MINIGAME" then
            if MinigameEnd then
                pcall(function() MinigameEnd:FireServer() end)
                print("[Auto] Minigame End")
            elseif RetractRemote then
                pcall(function() RetractRemote:FireServer() end)
            elseif CatchRemote then
                pcall(function() CatchRemote:FireServer() end)
            end
            wait(1)
        else
            wait(0.5)
        end
    end)
    return true
end

-- ===== FAST REEL =====
local fastActive = false
local fastConn = nil
local fastSpeed = 1.0
local fastParam = "kosong"
local ReelRemote = RetractRemote or CatchRemote

-- Dropdown parameter (hanya jika remote reel ada)
if ReelRemote then
    Tab:AddDropdown({
        Name = "Parameter Fast Reel",
        Options = {"kosong", "true", "false", "1", "'reel'", "{}"},
        Default = "kosong",
        Callback = function(v) fastParam = v end
    })
    
    Tab:AddToggle({
        Name = "⚡ Fast Reel",
        Default = false,
        Callback = function(state)
            fastActive = state
            if state then
                if fastConn then fastConn:Disconnect() end
                fastConn = RunService.Heartbeat:Connect(function()
                    if not fastActive then return end
                    pcall(function()
                        if fastParam == "kosong" then
                            ReelRemote:FireServer()
                        elseif fastParam == "true" then
                            ReelRemote:FireServer(true)
                        elseif fastParam == "false" then
                            ReelRemote:FireServer(false)
                        elseif fastParam == "1" then
                            ReelRemote:FireServer(1)
                        elseif fastParam == "'reel'" then
                            ReelRemote:FireServer("reel")
                        elseif fastParam == "{}" then
                            ReelRemote:FireServer({})
                        end
                    end)
                    wait(fastSpeed)
                end)
                OrionLib:MakeNotification({Name = "Fast Reel", Content = "Aktif", Time = 2})
            else
                if fastConn then fastConn:Disconnect(); fastConn = nil end
            end
        end
    })
    
    Tab:AddSlider({
        Name = "Kecepatan (detik)",
        Min = 0.1, Max = 10.0, Default = 1.0,
        Callback = function(v) fastSpeed = v end
    })
end

-- ===== TOMBOL AUTO FISHING =====
local afkBtn = Tab:AddButton({
    Name = "▶️ MULAI AUTO FISHING",
    Callback = function()
        autoActive = not autoActive
        if autoActive then
            if startAutoFishing() then
                afkBtn:Set("⏸️ HENTIKAN AUTO FISHING")
                OrionLib:MakeNotification({Name = "Auto Fish", Content = "Berjalan", Time = 2})
            else
                autoActive = false
            end
        else
            afkBtn:Set("▶️ MULAI AUTO FISHING")
            if autoConn then autoConn:Disconnect(); autoConn = nil end
        end
    end
})

-- ===== SLIDER DELAY CAST =====
Tab:AddSlider({
    Name = "Delay Cast (detik)",
    Min = 1.0, Max = 5.0, Default = 2.0,
    Callback = function(v) castDelay = v end
})

-- ===== TOMBOL TEST =====
if ThrowRemote then
    Tab:AddButton({
        Name = "Test Cast",
        Callback = function() ThrowRemote:FireServer() end
    })
end
if RetractRemote then
    Tab:AddButton({
        Name = "Test Retract",
        Callback = function() RetractRemote:FireServer() end
    })
end
if CatchRemote then
    Tab:AddButton({
        Name = "Test CatchSuccess",
        Callback = function() CatchRemote:FireServer() end
    })
end
if MinigameEnd then
    Tab:AddButton({
        Name = "Test MinigameEnd",
        Callback = function() MinigameEnd:FireServer() end
    })
end

-- ===== INFO STATE =====
Tab:AddParagraph({
    Title = "State",
    Content = "Cek console (F9) untuk lihat state"
})

OrionLib:Init()