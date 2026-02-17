-- Auto Fishing untuk Game GET FISH (berdasarkan kode asli)
-- Cocok buat Delta/Arceus/Codex

-- Load Orion Library (opsional, buat GUI keren)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua'))()
local Window = OrionLib:MakeWindow({Name = "Auto Fishing GET FISH", IntroEnabled = false})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Variabel global
local autoFishing = false
local fishingConn = nil
local fishingRod = nil
local ClientState = nil
local castDelay = 0.5
local useFallbackTimer = true  -- Pakai fallback 8 detik
local fallbackTime = 8

-- Cari fishing rod di karakter atau backpack
local function findFishingRod()
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
                return tool
            end
        end
    end
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
            return tool
        end
    end
    return nil
end

-- Ambil ClientState dari fishing rod
local function getClientState()
    if not fishingRod then return nil end
    -- Dari kode: tbl_62_upvr.ClientState
    return fishingRod:FindFirstChild("ClientState") or fishingRod:GetAttribute("ClientState")
end

-- Scan remote events yang mungkin dipakai
local castRemote = ReplicatedStorage:FindFirstChild("CastEvent", true)
local reelRemote = ReplicatedStorage:FindFirstChild("ReelEvent", true)
if not castRemote then castRemote = ReplicatedStorage:FindFirstChild("Cast", true) end
if not reelRemote then reelRemote = ReplicatedStorage:FindFirstChild("Reel", true) end

-- State dari kode asli: "IDLE", "CHARGING", "THROWING", "WAITING", "MINIGAME", "REELING", "RETRACTING"
local function getCurrentState()
    if ClientState and ClientState.state then
        return ClientState.state
    end
    -- Fallback: cek dari BindableEvent
    local stateEvent = ReplicatedStorage:FindFirstChild("FishingState_"..LocalPlayer.UserId)
    return nil
end

-- Broadcast state (dari kode: broadcastFishingState)
local function broadcastState(state)
    local event = ReplicatedStorage:FindFirstChild("FishingState_"..LocalPlayer.UserId)
    if event then
        event:Fire({state = state, isActive = true, toolId = "auto"})
    end
end

-- Fungsi auto fishing utama
local function startAutoFishing()
    fishingRod = findFishingRod()
    if not fishingRod then
        OrionLib:MakeNotification({Name = "Error", Content = "Fishing rod tidak ditemukan!", Time = 2})
        return false
    end
    
    -- Aktifkan rod (equip)
    LocalPlayer.Character.Humanoid:EquipTool(fishingRod)
    wait(0.5)
    
    ClientState = getClientState()
    
    fishingConn = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        
        -- Prioritaskan dari ClientState kalo ada
        local state = ClientState and ClientState.state or getCurrentState()
        
        if state == "IDLE" then
            -- Cast pancing
            pcall(function()
                if castRemote then
                    castRemote:FireServer()
                    print("[AutoFish] Casting...")
                end
            end)
            broadcastState("THROWING")
            wait(castDelay)
            
        elseif state == "WAITING" then
            -- Kalo pakai fallback timer, nunggu 8 detik lalu reel
            if useFallbackTimer then
                wait(fallbackTime)
                pcall(function()
                    if reelRemote then
                        reelRemote:FireServer()
                        print("[AutoFish] Fallback reel after 8s")
                    end
                end)
                broadcastState("REELING")
                wait(1)
            end
            
        elseif state == "MINIGAME" then
            -- Coba langsung reel (bypass minigame)
            pcall(function()
                if reelRemote then
                    reelRemote:FireServer()
                    print("[AutoFish] Force reel in minigame")
                end
            end)
            broadcastState("REELING")
            wait(1)
            
        elseif state == "REELING" or state == "RETRACTING" then
            -- Tunggu sampai kembali ke IDLE
            wait(2)
            
        elseif state == "THROWING" then
            -- Lagi lempar, tunggu
            wait(1)
        end
    end)
    
    return true
end

-- GUI dengan OrionLib (opsional)
local Tab = Window:MakeTab({Name = "Auto Fish", Icon = "rbxassetid://4483345998"})

Tab:AddToggle({
    Name = "🎣 Auto Fishing",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            if not startAutoFishing() then
                autoFishing = false
            else
                OrionLib:MakeNotification({Name = "Auto Fish", Content = "Dimulai!", Time = 2})
            end
        else
            if fishingConn then
                fishingConn:Disconnect()
                fishingConn = nil
            end
        end
    end
})

Tab:AddSlider({
    Name = "Cast Delay (detik)",
    Min = 0.1, Max = 3.0, Default = 0.5,
    Callback = function(v) castDelay = v end
})

Tab:AddToggle({
    Name = "Gunakan Fallback 8s",
    Default = true,
    Callback = function(v) useFallbackTimer = v end
})

Tab:AddButton({
    Name = "🔍 Cek State Sekarang",
    Callback = function()
        local state = getCurrentState()
        OrionLib:MakeNotification({Name = "Current State", Content = state or "Unknown", Time = 2})
    end
})

OrionLib:Init()