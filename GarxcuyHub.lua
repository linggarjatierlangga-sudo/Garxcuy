-- Script by ShadowX - GarxCuy Hub with Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "GarxCuy Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GarxCuyConfig",
    IntroEnabled = true,
    IntroText = "GarxCuy Hub",
    IntroIcon = "rbxassetid://4483345998"
})

-- Tab 1
local Tab = Window:MakeTab({
    Name = "Tab 1",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Section
local Section = Tab:AddSection({
    Name = "Main Features"
})

-- Toggle Speed & Jump
Tab:AddToggle({
    Name = "Speed & Jump Boost",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if state then
                    humanoid.WalkSpeed = 120
                    humanoid.JumpPower = 120
                else
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end
    end
})

-- Button Fetch Data
Tab:AddButton({
    Name = "Fetch Example Data",
    Callback = function()
        local success, result = pcall(function()
            return game:HttpGet("https://httpbin.org/get")
        end)
        if success then
            OrionLib:MakeNotification({
                Name = "Success!",
                Content = "Data fetched, check console",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            print(result)
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Gagal ambil data",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Colorpicker contoh (opsional)
Tab:AddColorpicker({
    Name = "Background Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        -- Contoh: ganti warna sesuatu (terserah lo)
        print("Color changed to", color)
    end
})

-- Notifikasi saat script jalan
OrionLib:MakeNotification({
    Name = "GarxCuy Hub Loaded",
    Content = "Welcome, goblok!",
    Image = "rbxassetid://4483345998",
    Time = 3
})

-- Init library
OrionLib:Init()
