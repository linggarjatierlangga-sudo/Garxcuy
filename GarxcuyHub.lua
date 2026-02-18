-- Auto Fishing CERDAS (Berdasarkan State Game)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Auto Fishing Cerdas", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Fishing"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ===== AMBIL REMOTE PENTING =====
local ThrowRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local RetractRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
local CatchRemote = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")
local MinigameEnd = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameEnd")
local ThrowState = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_ThrowState")
local AutoFishingState = ReplicatedStorage:FindFirstChild("AutoFishingState_9883448335")

-- ===== STATE TRACKING =====
local currentState = "IDLE"
if ThrowState and ThrowState:IsA("BindableEvent") then
    ThrowState.Event:Connect(function(state)
        currentState = state
        print("[State]", state)
    end)
elseif AutoFishingState and AutoFishingState:IsA("BindableEvent") then
    AutoFishingState.Event:Connect(function(state)
        currentState = state
        print("[AutoState]", state)
    end)
end

-- ===== AUTO FISHING BERBASIS STATE =====
local autoActive = false
local autoConn = nil

local function startAutoFishing()
    if not ThrowRemote then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote throw tidak ada!", Time = 2})
        return false
    end
    if not MinigameEnd and not RetractRemote and not CatchRemote then
        OrionLib:MakeNotification({Name = "Error", Content = "Remote reel/minigame tidak ada!", Time = 2})
        return false
    end

    autoConn = RunService.Heartbeat:Connect(function()
        if not autoActive then return end

        if currentState == "IDLE" or currentState == "idle" then
            -- Cast pancing
            ThrowRemote:FireServer()
            print("[Auto] Cast")
            wait(1) -- jeda biar state berubah
        elseif currentState == "MINIGAME" then
            -- Saat minigame, langsung selesaikan
            if MinigameEnd then
                MinigameEnd:FireServer()
                print("[Auto] MinigameEnd")
            elseif RetractRemote then
                RetractRemote:FireServer()
                print("[Auto] Retract (fallback)")
            elseif CatchRemote then
                CatchRemote:FireServer()
                print("[Auto] CatchSuccess")
            end
            wait(0.5)
        elseif currentState == "WAITING" or currentState == "waiting" then
            -- Lagi nunggu gigitan, gak usah ngapa-ngapain
            wait(1)
        else
            wait(0.5)
        end
    end)
    return true
end

-- ===== GUI =====
Tab:AddButton({
    Name = "Test Cast",
    Callback = function()
        if ThrowRemote then ThrowRemote:FireServer() end
    end
})

Tab:AddButton({
    Name = "Test Reel",
    Callback = function()
        if RetractRemote then RetractRemote:FireServer()
        elseif CatchRemote then CatchRemote:FireServer() end
    end
})

Tab:AddButton({
    Name = "Test MinigameEnd",
    Callback = function()
        if MinigameEnd then MinigameEnd:FireServer() end
    end
})

local toggleBtn = Tab:AddButton({
    Name = "▶️ MULAI AUTO FISHING",
    Callback = function()
        autoActive = not autoActive
        if autoActive then
            if startAutoFishing() then
                toggleBtn:Set("⏸️ HENTIKAN AUTO FISHING")
                OrionLib:MakeNotification({Name = "Auto Fish", Content = "Berjalan!", Time = 2})
            else
                autoActive = false
            end
        else
            toggleBtn:Set("▶️ MULAI AUTO FISHING")
            if autoConn then autoConn:Disconnect(); autoConn = nil end
        end
    end
})

Tab:AddParagraph({
    Title = "Info",
    Content = "Script mendengarkan state dari ThrowState/AutoFishingState. Pastikan state muncul di console (F9)."
})

OrionLib:Init()