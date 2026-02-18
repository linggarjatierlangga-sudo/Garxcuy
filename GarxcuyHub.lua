-- Auto Fishing + Inventory Trigger
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Auto Fishing + Inventory", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Fishing"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Remote yang sudah ditemukan
local CastRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow") 
                or ReplicatedStorage:FindFirstChild("CastReleased", true)
local ReelRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract") 
                or ReplicatedStorage:FindFirstChild("ReelFinished", true)
                or ReplicatedStorage:FindFirstChild("FishingCatchSuccess")

-- Inventory event
local InventoryPatch = ReplicatedStorage:FindFirstChild("FishUI") and ReplicatedStorage.FishUI.Bridge:FindFirstChild("InventoryPatch")
local ToggleFishBag = ReplicatedStorage:FindFirstChild("FishUI") and ReplicatedStorage.FishUI.Bridge:FindFirstChild("ToggleFishBag")

if not CastRemote then
    Tab:AddParagraph({Title = "Error", Content = "Cast remote tidak ditemukan!"})
elseif not ReelRemote then
    Tab:AddParagraph({Title = "Error", Content = "Reel remote tidak ditemukan!"})
else
    local isActive = false
    local castDelay = 2.0
    local reelDelay = 1.0
    local autoConn = nil

    -- Listener inventory update
    if InventoryPatch then
        InventoryPatch.OnClientEvent:Connect(function(data)
            if isActive then
                print("[Inventory] Ikan didapat! Data:", data)
                -- Ikan masuk, langsung cast ulang setelah jeda
                wait(1)
                if isActive then
                    CastRemote:FireServer()
                end
            end
        end)
    end

    -- Fungsi auto fishing manual (fallback)
    local function startAutoFishing()
        autoConn = RunService.Heartbeat:Connect(function()
            if not isActive then return end
            pcall(function()
                CastRemote:FireServer()
                wait(castDelay)
                ReelRemote:FireServer()
                wait(reelDelay)
            end)
        end)
    end

    -- GUI
    local toggleBtn = Tab:AddButton({
        Name = "▶️ MULAI AUTO FISH",
        Callback = function()
            isActive = not isActive
            if isActive then
                toggleBtn:Set("⏸️ HENTIKAN AUTO FISH")
                if autoConn then autoConn:Disconnect() end
                startAutoFishing()
                OrionLib:MakeNotification({Name = "Auto Fish", Content = "Berjalan!", Time = 2})
            else
                toggleBtn:Set("▶️ MULAI AUTO FISH")
                if autoConn then autoConn:Disconnect(); autoConn = nil end
            end
        end
    })

    Tab:AddSlider({
        Name = "Delay Cast (detik)",
        Min = 0.5, Max = 5.0, Default = 2.0,
        Callback = function(v) castDelay = v end
    })

    Tab:AddSlider({
        Name = "Delay Reel (detik)",
        Min = 0.5, Max = 5.0, Default = 1.0,
        Callback = function(v) reelDelay = v end
    })

    Tab:AddButton({
        Name = "Test Cast",
        Callback = function() CastRemote:FireServer() end
    })

    Tab:AddButton({
        Name = "Test Reel",
        Callback = function() ReelRemote:FireServer() end
    })

    if ToggleFishBag then
        Tab:AddButton({
            Name = "Toggle Fish Bag",
            Callback = function() ToggleFishBag:FireServer() end
        })
    end
end

OrionLib:Init()