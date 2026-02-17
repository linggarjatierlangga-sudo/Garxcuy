-- Script by ShadowX - GarxCuy Hub with Synapse Theme
local Tab = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--[[
Name = <GARXCUY> - The name of the tab.
Icon = <GARXCUY> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GarxCuy Hub", "Synapse")  -- Ganti judul & tema

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Features")

-- Toggle buat speed & jump
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

-- Button buat fetch data (contoh doang)
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
