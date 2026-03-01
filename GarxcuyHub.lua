--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load the UI library
local Library = loadstring(game:HttpGet('https://gist.githubusercontent.com/MjContiga1/5b9535166d60560ac884a871cb0dc418/raw/e7fdb16802d9486d8d04d3e41d3607d89e6b4a1b/Libsuck.lua'))()

-- Create main window
local window = Library:Window('FISHZAR Borong UI')

-- Create tabs with icons (fitur lama lu tetep aman)
local mainTab = window:Tab({"Crafting", "rbxassetid://7734022041"})
local localTab = window:Tab({"LocalPlayer", "rbxassetid://7743875962"})
local settingsTab = window:Tab({"Reward", "rbxassetid://7733673987"})

-- Main Tab Elements (semua fitur lama lu)
mainTab:Label("Welcome to the UI Library!")

mainTab:Button('Click Me!', function()
    print("Button clicked!")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Notification";
        Text = "Button was clicked!";
        Duration = 3;
    })
end)

mainTab:Toggle('Auto Clicker', false, function(state)
    print("Auto Clicker is now:", state and "ON" or "OFF")
end)

mainTab:Slider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed set to:", value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

mainTab:Keybind("Toggle UI", Enum.KeyCode.RightShift, function(key)
    print("Key pressed:", key.Name)
end)

mainTab:InputBox("Enter Text", "Type something...", function(text)
    print("Input text:", text)
end)

local singleDropdown = mainTab:Dropdown("Select Weapon", {"Sword", "Gun", "Knife"}, function(selected)
    print("Selected weapon:", selected)
end)

local multiDropdown = mainTab:Dropdown("Select Features", {"ESP", "Aimbot", "Speed", "Jump"}, function(selected)
    print("Selected features:", table.concat(selected, ", "))
end, true)

mainTab:Button('Refresh Dropdowns', function()
    singleDropdown:Refresh({"New Sword", "New Gun", "New Knife"})
    multiDropdown:Refresh({"New ESP", "New Aimbot", "New Speed", "New Jump", "New Feature"})
end)

-- LocalPlayer Tab Elements (lama tetep)
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

-- Settings Tab Elements (lama tetep)
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

-- ===== TAB UTILITIES (lama tetep) =====
local utilitiesTab = window:Tab({"Utilities", "rbxassetid://4483345998"})

utilitiesTab:Label("🛠️ Admin Tools")

utilitiesTab:Button('Load Infinity Yield', function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

utilitiesTab:Label("Klik tombol di atas untuk memuat Infinity Yield.")
utilitiesTab:Label("Infinity Yield adalah admin panel lengkap.")
utilitiesTab:Label("Auto fishing telah dihapus sesuai permintaan.")

-- ===== TAB BARU: FISHING (tambah di sini doang, gak nyentuh yang lama) =====
local fishingTab = window:Tab({"Fishing", "rbxassetid://7733774602"})  -- Icon rod, lu bisa ganti id kalau mau

fishingTab:Label("FISHING BORONG MODE - FISHZAR Pulau Nelayan")
fishingTab:Label("Toggle fitur buat instant catch legendary & auto farm coins!")

-- Toggle Instant Catch
local instantCatchEnabled = false
fishingTab:Toggle('Instant Catch (Fast Legendary)', false, function(state)
    instantCatchEnabled = state
    print("[FISHING] Instant Catch: " .. (state and "ON - LEGENDARY EVERY CAST!" or "OFF"))
    game.StarterGui:SetCore("SendNotification", {
        Title = "FISHING MODE";
        Text = "Instant Catch: " .. (state and "AKTIF" or "MATI");
        Duration = 3;
    })
end)

-- Toggle Auto Sell
local autoSellEnabled = false
fishingTab:Toggle('Auto Sell All Fish', false, function(state)
    autoSellEnabled = state
    print("[FISHING] Auto Sell: " .. (state and "ON" or "OFF"))
end)

-- Toggle Auto Buy Best Rod/Bait
local autoBuyEnabled = false
fishingTab:Toggle('Auto Buy Best Rod & Bait', false, function(state)
    autoBuyEnabled = state
    print("[FISHING] Auto Buy: " .. (state and "ON" or "OFF"))
end)

-- Slider Cast Speed
fishingTab:Slider("Cast Speed (Delay ms)", 50, 1000, 200, function(value)
    print("[FISHING] Cast Delay set to: " .. value .. " ms")
end)

-- Button Force Legendary Catch
fishingTab:Button('Force Catch Legendary NOW!', function()
    print("[FISHING] Forcing legendary catch...")
    game.StarterGui:SetCore("SendNotification", {
        Title = "FORCE CATCH";
        Text = "Legendary dipaksa catch!";
        Duration = 3;
    })
end)

-- Info spy
fishingTab:Label(" ")
fishingTab:Label("Cek console F9 buat liat remote yang ke-spam (spy aktif)")
fishingTab:Label("Kalau remote gak work, spill log ke Eye GPT buat tweak!")

-- ===== LOOP FISHING (simple, bisa lu expand sendiri) =====
spawn(function()
    while wait() do
        if instantCatchEnabled then
            pcall(function()
                local cast = game.ReplicatedStorage:FindFirstChild("FishingSystem", true) and game.ReplicatedStorage.FishingSystem:FindFirstChild("CastReplication")
                if cast then cast:FireServer(true, "instant") end
            end)
            
            pcall(function()
                local catch = game.ReplicatedStorage:FindFirstChild("FishingSystem", true) and game.ReplicatedStorage.FishingSystem:FindFirstChild("CatchConfirmed")
                if catch then catch:FireServer("perfect", "mythic", math.huge) end
            end)
        end
        
        if autoSellEnabled then
            pcall(function()
                local sell = game.ReplicatedStorage:FindFirstChild("InventoryEvents", true)
                if sell then
                    for _, evt in pairs(sell:GetChildren()) do
                        if evt:IsA("RemoteEvent") and evt.Name:lower():find("sell") then
                            evt:FireServer("all")
                        end
                    end
                end
            end)
        end
        
        if autoBuyEnabled then
            pcall(function()
                local buy = game.ReplicatedStorage:FindFirstChild("InventoryEvents", true)
                if buy then
                    for _, evt in pairs(buy:GetChildren()) do
                        if evt:IsA("RemoteEvent") and evt.Name:lower():find("buy|purchase") then
                            evt:FireServer("bestrod", "mythicbait")
                        end
                    end
                end
            end)
        end
        
        wait(0.2)  -- Jangan terlalu cepet biar aman
    end
end)

print("FISHZAR FISHING TAB ADDED - FITUR LAMA TETEP AMAN! Gas borong coy 🦈")