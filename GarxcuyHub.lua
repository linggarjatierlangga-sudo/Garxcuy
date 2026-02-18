-- Fast Reel dengan Delay Maksimum 10 Detik
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Fast Reel 10s", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "Reel"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Cari remote reel (prioritas Fishing_RemoteRetract)
local remote = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract", true) 
             or ReplicatedStorage:FindFirstChild("ReelFinished", true)
             or ReplicatedStorage:FindFirstChild("FishingCatchSuccess", true)

if not remote then
    Tab:AddParagraph({Title = "Error", Content = "Tidak ada remote reel ditemukan!"})
else
    local isActive = false
    local connection = nil
    local speed = 5.0  -- default 5 detik
    local param = "kosong"

    -- Pilihan parameter
    Tab:AddDropdown({
        Name = "Parameter",
        Options = {"kosong", "true", "false", "1", "'reel'", "{}"},
        Default = "kosong",
        Callback = function(v) param = v end
    })

    -- Toggle fast reel
    Tab:AddToggle({
        Name = "⚡ Fast Reel",
        Default = false,
        Callback = function(state)
            isActive = state
            if state then
                if connection then connection:Disconnect() end
                connection = RunService.Heartbeat:Connect(function()
                    if isActive then
                        pcall(function()
                            if param == "kosong" then
                                remote:FireServer()
                            elseif param == "true" then
                                remote:FireServer(true)
                            elseif param == "false" then
                                remote:FireServer(false)
                            elseif param == "1" then
                                remote:FireServer(1)
                            elseif param == "'reel'" then
                                remote:FireServer("reel")
                            elseif param == "{}" then
                                remote:FireServer({})
                            end
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

    -- Slider kecepatan (0.1 - 10 detik)
    Tab:AddSlider({
        Name = "Kecepatan (detik)",
        Min = 0.1, Max = 10.0, Default = 5.0, Increment = 0.1,
        ValueName = "dtk",
        Callback = function(v) speed = v end
    })

    -- Tombol test manual
    Tab:AddButton({
        Name = "Test Manual",
        Callback = function()
            if param == "kosong" then
                remote:FireServer()
            elseif param == "true" then
                remote:FireServer(true)
            elseif param == "false" then
                remote:FireServer(false)
            elseif param == "1" then
                remote:FireServer(1)
            elseif param == "'reel'" then
                remote:FireServer("reel")
            elseif param == "{}" then
                remote:FireServer({})
            end
            OrionLib:MakeNotification({Name = "Test", Content = "Fired", Time = 1})
        end
    })
end

OrionLib:Init()