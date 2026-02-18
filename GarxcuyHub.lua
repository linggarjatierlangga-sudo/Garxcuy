-- Auto Fishing MINIMALIS (PASTI MUNCUL)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Auto Fishing MINI", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "AUTO"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Hanya 2 remote utama yang pasti ada
local CastRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local ReelRemote = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract") 
                 or ReplicatedStorage:FindFirstChild("FishingCatchSuccess")

if not CastRemote then
    Tab:AddParagraph({Title = "ERROR", Content = "Remote throw tidak ditemukan!"})
elseif not ReelRemote then
    Tab:AddParagraph({Title = "ERROR", Content = "Remote reel tidak ditemukan!"})
else
    local isActive = false
    local conn = nil
    local delay = 2.0

    -- Tombol toggle
    local btn = Tab:AddButton({
        Name = "▶️ MULAI AUTO FISH",
        Callback = function()
            isActive = not isActive
            if isActive then
                btn:Set("⏸️ HENTIKAN AUTO FISH")
                if conn then conn:Disconnect() end
                conn = RunService.Heartbeat:Connect(function()
                    if not isActive then return end
                    pcall(function()
                        CastRemote:FireServer()
                        wait(delay)
                        ReelRemote:FireServer()
                        wait(0.5)
                    end)
                end)
                OrionLib:MakeNotification({Name = "Auto Fish", Content = "Berjalan!", Time = 2})
            else
                btn:Set("▶️ MULAI AUTO FISH")
                if conn then conn:Disconnect(); conn = nil end
            end
        end
    })

    -- Slider delay
    Tab:AddSlider({
        Name = "Delay (detik)",
        Min = 1.0, Max = 5.0, Default = 2.0,
        Callback = function(v) delay = v end
    })

    -- Test manual
    Tab:AddButton({
        Name = "Test Cast",
        Callback = function() CastRemote:FireServer() end
    })

    Tab:AddButton({
        Name = "Test Reel",
        Callback = function() ReelRemote:FireServer() end
    })
end

OrionLib:Init()