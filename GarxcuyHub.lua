-- Fast Reel dengan ReelFinished (Fishing.ToServer)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({Name = "Fast Reel Finished", IntroEnabled = false})
local Tab = Window:MakeTab({Name = "ReelFinished"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Cari remote ReelFinished di Fishing.ToServer
local Fishing = ReplicatedStorage:FindFirstChild("Fishing")
local ToServer = Fishing and Fishing:FindFirstChild("ToServer")
local remote = ToServer and ToServer:FindFirstChild("ReelFinished")

if not remote then
    Tab:AddParagraph({Title = "Error", Content = "ReelFinished tidak ditemukan di Fishing.ToServer!"})
else
    local isActive = false
    local connection = nil
    local speed = 1.0
    local paramType = "kosong"

    -- Dropdown pilihan parameter
    Tab:AddDropdown({
        Name = "Parameter",
        Options = {"kosong", "true", "false", "1", "'reel'", "{}"},
        Default = "kosong",
        Callback = function(value)
            paramType = value
        end
    })

    -- Toggle fast reel
    Tab:AddToggle({
        Name = "⚡ Fast Reel (ReelFinished)",
        Default = false,
        Callback = function(state)
            isActive = state
            if state then
                if connection then connection:Disconnect() end
                connection = RunService.Heartbeat:Connect(function()
                    if isActive then
                        pcall(function()
                            if paramType == "kosong" then
                                remote:FireServer()
                            elseif paramType == "true" then
                                remote:FireServer(true)
                            elseif paramType == "false" then
                                remote:FireServer(false)
                            elseif paramType == "1" then
                                remote:FireServer(1)
                            elseif paramType == "'reel'" then
                                remote:FireServer("reel")
                            elseif paramType == "{}" then
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
            if paramType == "kosong" then
                remote:FireServer()
            elseif paramType == "true" then
                remote:FireServer(true)
            elseif paramType == "false" then
                remote:FireServer(false)
            elseif paramType == "1" then
                remote:FireServer(1)
            elseif paramType == "'reel'" then
                remote:FireServer("reel")
            elseif paramType == "{}" then
                remote:FireServer({})
            end
            OrionLib:MakeNotification({Name = "Test", Content = "ReelFinished fired", Time = 1})
        end
    })
end

OrionLib:Init()