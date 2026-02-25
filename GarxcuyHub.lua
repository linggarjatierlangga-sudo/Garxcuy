--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load the UI library
local Library = loadstring(game:HttpGet('https://gist.githubusercontent.com/MjContiga1/5b9535166d60560ac884a871cb0dc418/raw/e7fdb16802d9486d8d04d3e41d3607d89e6b4a1b/Libsuck.lua'))()

-- Create main window
local window = Library:Window('Example UI')

-- Create tabs with icons replace ur own icon id
local mainTab = window:Tab({"Crafting", "rbxassetid://7734022041"})
local localTab = window:Tab({"LocalPlayer", "rbxassetid://7743875962"})
local settingsTab = window:Tab({"Reward", "rbxassetid://7733673987"})

-- Main Tab Elements
mainTab:Label("Welcome to the UI Library!")

-- Button
mainTab:Button('Click Me!', function()
    print("Button clicked!")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Notification";
        Text = "Button was clicked!";
        Duration = 3;
    })
end)

-- Toggle
mainTab:Toggle('Auto Clicker', false, function(state)
    print("Auto Clicker is now:", state and "ON" or "OFF")
end)

-- Slider
mainTab:Slider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed set to:", value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Keybind
mainTab:Keybind("Toggle UI", Enum.KeyCode.RightShift, function(key)
    print("Key pressed:", key.Name)
end)

-- InputBox
mainTab:InputBox("Enter Text", "Type something...", function(text)
    print("Input text:", text)
end)

-- Single-select dropdown
local singleDropdown = mainTab:Dropdown("Select Weapon", {"Sword", "Gun", "Knife"}, function(selected)
    print("Selected weapon:", selected)
end)

-- Multi-select dropdown
local multiDropdown = mainTab:Dropdown("Select Features", {"ESP", "Aimbot", "Speed", "Jump"}, function(selected)
    print("Selected features:", table.concat(selected, ", "))
end, true)

-- Button to refresh dropdowns
mainTab:Button('Refresh Dropdowns', function()
    singleDropdown:Refresh({"New Sword", "New Gun", "New Knife"})
    multiDropdown:Refresh({"New ESP", "New Aimbot", "New Speed", "New Jump", "New Feature"})
end)

-- LocalPlayer Tab Elements
localTab:Label("Local Player Settings")

localTab:Slider("Jump Power", 50, 200, 50, function(value)
    print("Jump Power set to:", value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

localTab:Toggle("Infinite Jump", false, function(state)
    print("Infinite Jump:", state and "ON" or "OFF")
end)

localTab:InputBox("Player Name", "Enter player name...", function(text)
    print("Looking for player:", text)
end)

-- Settings Tab Elements
settingsTab:Label("UI Settings")

settingsTab:Toggle('Dark Mode', true, function(state)
    print("Dark Mode:", state)
end)

settingsTab:Slider("UI Transparency", 0, 100, 100, function(value)
    print("UI Transparency:", value)
end)

settingsTab:Keybind("Toggle Menu", Enum.KeyCode.Insert, function(key)
    print("Menu key changed to:", key.Name)
end)

settingsTab:InputBox("Custom Title", "Enter title...", function(text)
    print("Custom title:", text)
end)

-- ===== TAB UTILITIES =====
local utilitiesTab = window:Tab({"Utilities", "rbxassetid://4483345998"})

utilitiesTab:Label("🛠️ Admin Tools")

-- Infinity Yield button
utilitiesTab:Button('Load Infinity Yield', function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

utilitiesTab:Label("Klik tombol di atas untuk memuat Infinity Yield.")
utilitiesTab:Label("Infinity Yield adalah admin panel lengkap.")
utilitiesTab:Label("Auto fishing telah dihapus sesuai permintaan.")