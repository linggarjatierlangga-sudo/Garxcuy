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
end, true) -- true enables multi-select

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
    -- Add infinite jump logic here
end)

localTab:InputBox("Player Name", "Enter player name...", function(text)
    print("Looking for player:", text)
    -- Add player search logic here
end)

-- Settings Tab Elements
settingsTab:Label("UI Settings")

settingsTab:Toggle('Dark Mode', true, function(state)
    print("Dark Mode:", state)
    -- Add dark mode logic here
end)

settingsTab:Slider("UI Transparency", 0, 100, 100, function(value)
    print("UI Transparency:", value)
    -- Apply transparency to UI elements
end)

settingsTab:Keybind("Toggle Menu", Enum.KeyCode.Insert, function(key)
    print("Menu key changed to:", key.Name)
    -- Update menu toggle key here
end)

settingsTab:InputBox("Custom Title", "Enter title...", function(text)
    print("Custom title:", text)
    -- Update UI title here
end)

-- ===== TAB AUTO FISH (LANGSUNG DI DALAM UI) =====
local autoFishTab = window:Tab({"Auto Fish", "rbxassetid://4483345998"})

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Remote fishing (ambil dengan aman)
local Throw = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow") or 
              (ReplicatedStorage:FindFirstChild("Fishing") and ReplicatedStorage.Fishing:FindFirstChild("ToServer") and ReplicatedStorage.Fishing.ToServer:FindFirstChild("CastReleased"))

local Retract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract") or 
                (ReplicatedStorage:FindFirstChild("Fishing") and ReplicatedStorage.Fishing:FindFirstChild("ToServer") and ReplicatedStorage.Fishing.ToServer:FindFirstChild("ReelFinished"))

local Catch = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")

-- Auto fishing resmi
local LevelSystem = ReplicatedStorage:FindFirstChild("LevelSystem")
local LevelToServer = LevelSystem and LevelSystem:FindFirstChild("ToServer")
local StartAuto = LevelToServer and LevelToServer:FindFirstChild("StartAutoFishing")
local StopAuto = LevelToServer and LevelToServer:FindFirstChild("StopAutoFishing")

-- Variabel status
local autoActive = false
local fastActive = false
local fastConn = nil
local fastSpeed = 1.0

-- ===== SECTION: STATUS REMOTE =====
autoFishTab:Label("📡 Remote Status")

if Throw then
    autoFishTab:Label("✅ Throw: " .. Throw.Name)
else
    autoFishTab:Label("❌ Throw: Tidak ditemukan")
end

if Retract then
    autoFishTab:Label("✅ Retract: " .. Retract.Name)
else
    autoFishTab:Label("❌ Retract: Tidak ditemukan")
end

if Catch then
    autoFishTab:Label("✅ Catch: " .. Catch.Name)
else
    autoFishTab:Label("❌ Catch: Tidak ditemukan")
end

if StartAuto then
    autoFishTab:Label("✅ StartAutoFishing: Ditemukan")
else
    autoFishTab:Label("❌ StartAutoFishing: Tidak ditemukan")
end

-- ===== SECTION: AUTO FISHING RESMI =====
autoFishTab:Label("🎣 Auto Fishing Resmi")

autoFishTab:Toggle('Aktifkan Auto Fishing', false, function(state)
    autoActive = state
    if state then
        if StartAuto then
            StartAuto:FireServer()
            print("[Auto] StartAutoFishing fired")
        else
            warn("StartAutoFishing tidak ditemukan")
        end
    else
        if StopAuto then
            StopAuto:FireServer()
        elseif StartAuto then
            StartAuto:FireServer() -- mungkin toggle
        end
    end
end)

-- ===== SECTION: FAST REEL =====
autoFishTab:Label("⚡ Fast Reel (Berisiko)")

autoFishTab:Toggle('Aktifkan Fast Reel', false, function(state)
    fastActive = state
    if state then
        if not Retract and not Catch then
            warn("Tidak ada remote reel")
            return
        end
        fastConn = RunService.Heartbeat:Connect(function()
            if not fastActive then return end
            if Retract then
                pcall(function() Retract:FireServer() end)
            end
            if Catch then
                pcall(function() Catch:FireServer() end)
            end
            task.wait(fastSpeed)
        end)
    else
        if fastConn then
            fastConn:Disconnect()
            fastConn = nil
        end
    end
end)

autoFishTab:Slider("Kecepatan (detik)", 0.1, 3, 1, function(value)
    fastSpeed = value
end)

-- ===== SECTION: TEST MANUAL =====
autoFishTab:Label("🛠️ Test Manual")

autoFishTab:Button('Test Throw', function()
    if Throw then
        Throw:FireServer()
        print("[Test] Throw fired")
    end
end)

autoFishTab:Button('Test Retract', function()
    if Retract then
        Retract:FireServer()
        print("[Test] Retract fired")
    end
end)

autoFishTab:Button('Test Catch', function()
    if Catch then
        Catch:FireServer(true) -- coba dengan parameter true
        print("[Test] Catch fired")
    end
end)

-- ===== SECTION: SIMULASI =====
autoFishTab:Label("🔄 Simulasi Loop")

local simulActive = false
local simulConn = nil

autoFishTab:Toggle('Loop Cast → Reel', false, function(state)
    simulActive = state
    if state then
        simulConn = RunService.Heartbeat:Connect(function()
            if not simulActive then return end
            if Throw then Throw:FireServer() end
            task.wait(2)
            if Retract then Retract:FireServer() end
            if Catch then Catch:FireServer() end
            task.wait(1)
        end)
    else
        if simulConn then
            simulConn:Disconnect()
            simulConn = nil
        end
    end
end)

-- ===== SECTION: INFO =====
autoFishTab:Label("⚠️ Informasi")
autoFishTab:Label("Game ini punya anti-cheat ketat.")
autoFishTab:Label("Gunakan akun alt untuk testing.")
autoFishTab:Label("Fast reel sangat berisiko banned.")