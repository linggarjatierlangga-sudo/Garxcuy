-- Script by ShadowX - GarxCuy Hub with Synapse Theme
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GarxCuy Hub", "Synapse")

-- Main Tab (seperti sebelumnya)
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Features")

-- Toggle speed & jump
local speedEnabled = false
MainSection:NewToggle("Speed & Jump Boost", "Naikin walkspeed & jump power", function(state)
    speedEnabled = state
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
end)

-- Button fetch data
MainSection:NewButton("Fetch Example Data", "Ambil data dari URL (simulasi)", function()
    local success, result = pcall(function()
        return game:HttpGet("https://httpbin.org/get")
    end)
    if success then
        print("Data fetched:", result)
    else
        warn("Gagal ambil data")
    end
end)

-- ===== TAB BARU: TAB 1 =====
local Tab1 = Window:NewTab("Tab 1")  -- Nama tab sesuai request
local Tab1Section = Tab1:NewSection("Tab 1 Section", "rbxassetid://4483345998")  -- Pake icon sesuai ID

-- Contoh isi section
Tab1Section:NewLabel("Ini adalah tab baru")
Tab1Section:NewButton("Click Me", "Tombol contoh", function()
    print("Tombol di Tab 1 diklik!")
end)
