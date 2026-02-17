-- Fast Reel dengan Fishing_RemoteRetract
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Fast Reel Retract", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Retract"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Cari remote Fishing_RemoteRetract
local remote = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")

if not remote then
    Tab:AddParagraph({Title = "Error", Content = "Fishing_RemoteRetract tidak ditemukan!"})
else
    local isActive = false
    local connection = nil
    local speed = 1.0

    -- Toggle fast reel
    Tab:AddToggle({
        Name = "⚡ Fast Reel (Retract)",
        Default = false,
        Callback = function(state)
            isActive = state
            if state then
                if connection then connection:Disconnect() end
                connection = RunService.Heartbeat:Connect(function()
                    if isActive then
                        pcall(function()
                            remote:FireServer()  -- coba tanpa parameter dulu
                        end)
                        wait(speed)
                    end
                end)
                OrionLib:MakeNotification({Name = "Fast Reel", Content = "Aktif!", Time = 2})
            else
                if connection then connection:Disconnect(); connection = nil end
            end
        end
    })

    -- Slider kecepatan
    Tab:AddSlider({
        Name = "Kecepatan (detik)",
        Min = 0.1, Max = 3.0, Default = 1.0, Increment = 0.1,
        Callback = function(v) speed = v end
    })

    -- Tombol test manual
    Tab:AddButton({
        Name = "Test Manual",
        Callback = function()
            remote:FireServer()
            OrionLib:MakeNotification({Name = "Test", Content = "Retract fired", Time = 1})
        end
    })
end

OrionLib:Init()