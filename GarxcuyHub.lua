-- ============================================
-- GARXCUY HUB ULTIMATE v7.0 WITH FAST REEL
-- BY: LINGGAR JATI ERLANGGAsudo
-- LOADSTRING: loadstring(game:HttpGet("https://raw.githubusercontent.com/linggarjatierlangga-sudo/Garxcuy/main/GarxcuyHub.lua"))()
-- ============================================

getgenv().GarxcuyHub = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(3)

print("=================================================================")
print("🔱 GARXCUY HUB v7.0 | GET FISH")
print("👑 Creator: Linggar Jati Erlangga")
print("📞 Contact: 0895-2007-1068")
print("=================================================================")

-- VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- CREATE GUI (PASTI MUNCUL)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarxcuyHub_Main"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui or LocalPlayer.PlayerGui

-- MAIN WINDOW
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 550) -- DIPANJANGKAN KARENA ADA TAMBAHAN FITUR
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- TITLE BAR
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleBar.Text = "🔱 GARXCUY HUB v7.0 | By Linggar"
titleBar.TextColor3 = Color3.white
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 16
titleBar.Parent = mainFrame

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- SCROLL FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = mainFrame

-- FUNCTION CREATE TOGGLE
local toggles = {}
function CreateToggle(name, description, defaultState, callback)
    local index = #toggles + 1
    local yPos = (index-1) * 55
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.Parent = scrollFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.Position = UDim2.new(0, 5, 0, 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.white
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 25)
    label.Position = UDim2.new(0, 50, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.white
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -50, 0, 20)
    desc.Position = UDim2.new(0, 50, 0, 25)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = toggleFrame
    
    local state = defaultState
    if defaultState then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleBtn.Text = "ON"
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            toggleBtn.Text = "OFF"
        end
        callback(state)
    end)
    
    table.insert(toggles, {frame = toggleFrame, state = state})
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, index * 55)
    
    return toggleBtn
end

-- FUNCTION CREATE BUTTON
function CreateButton(name, callback)
    local index = #toggles + 1
    local yPos = (index-1) * 55
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
    btn.Text = name
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = scrollFrame
    
    btn.MouseButton1Click:Connect(callback)
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, index * 55)
end

-- ===============================
-- FITUR FAST REEL (BARU)
-- ===============================
local fastReelEnabled = false
local fastReelToggle = CreateToggle("⚡ FAST REEL", "Reel fish super fast", false, function(state)
    fastReelEnabled = state
    if state then
        spawn(function()
            while fastReelEnabled do
                -- KLIK SUPER CEPAT UNTUK REEL
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                wait(0.02) -- SUPER FAST INTERVAL
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                wait(0.02)
            end
        end)
        print("⚡ Fast Reel Activated!")
    else
        print("⚡ Fast Reel Stopped")
    end
end)

-- ===============================
-- FITUR AUTO FISH (WORKING)
-- ===============================
local autoFishToggle = CreateToggle("🎣 AUTO FISH", "Auto teleport & fish at spots", false, function(state)
    if state then
        spawn(function()
            while autoFishToggle.Text == "ON" do
                wait(3)
                
                -- FIND FISHING SPOTS
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        -- DETECT FISHING SPOT
                        if obj.BrickColor == BrickColor.new("Bright blue") or
                           obj.BrickColor == BrickColor.new("Cyan") or
                           obj.Material == Enum.Material.Water or
                           obj.Name:find("Fish") or
                           obj.Name:find("Spot") then
                           
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                -- TELEPORT
                                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                                wait(0.5)
                                
                                -- CLICK TO FISH
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                
                                -- JALANKAN FAST REEL OTOMATIS KALAU NYALA
                                if fastReelEnabled then
                                    for i = 1, 20 do
                                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                        wait(0.02)
                                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                    end
                                end
                                
                                print("🎣 Fishing at: " .. obj.Name)
                                break
                            end
                        end
                    end
                end
            end
        end)
    else
        print("❌ Auto Fish stopped")
    end
end)

-- ===============================
-- INSTANT CATCH BUTTON (BARU)
-- ===============================
CreateButton("🎯 INSTANT CATCH", function()
    -- SIMULASI CATCH SUPER CEPAT
    for i = 1, 50 do
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
        wait(0.01)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
    print("🎯 Instant Catch Activated!")
end)

-- ===============================
-- SPEED HACK
-- ===============================
CreateToggle("🏃 SPEED HACK", "WalkSpeed 100", false, function(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.WalkSpeed = 100
        else
            char.Humanoid.WalkSpeed = 16
        end
    end
end)

-- ===============================
-- INFINITE JUMP
-- ===============================
CreateToggle("🦘 INFINITE JUMP", "Jump forever", false, function(state)
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- ===============================
-- NO CLIP
-- ===============================
CreateToggle("👻 NO CLIP", "Walk through walls", false, function(state)
    if state then
        spawn(function()
            while wait() do
                pcall(function()
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
            end
        end)
    else
        pcall(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
    end
end)

-- ===============================
-- BUTTON FEATURES LAIN
-- ===============================
CreateButton("💰 CLAIM DAILY REWARD", function()
    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if gui:IsA("TextButton") and gui.Text:find("DAILY") then
            fireclickdetector(gui)
            print("✅ Claimed daily reward")
            break
        end
    end
end)

CreateButton("📍 TELEPORT TO BEST SPOT", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:find("LAUT") then
            LocalPlayer.Character:SetPrimaryPartCFrame(obj.CFrame + Vector3.new(0, 10, 0))
            print("📍 Teleported to: " .. obj.Name)
            break
        end
    end
end)

CreateButton("📈 INCREASE CF +50K", function()
    if LocalPlayer:FindFirstChild("leaderstats") then
        for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
            if stat.Name == "CF" then
                stat.Value = stat.Value + 50000
                print("💰 CF: " .. stat.Value)
            end
        end
    end
end)

CreateButton("🛡️ LOAD INFINITE YIELD", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

CreateButton("🔍 DEBUG GAME INFO", function()
    print("=== DEBUG INFO ===")
    print("Game: GET FISH")
    print("Player: " .. LocalPlayer.Name)
    
    -- SHOW WORKSPACE OBJECTS
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Part") then
            print("📦 " .. obj.Name .. " | Color: " .. tostring(obj.BrickColor))
        end
    end
end)

-- ===============================
-- FAST REEL HOTKEY (BARU)
-- ===============================
CreateButton("🔘 FAST REEL HOTKEY (PRESS R)", function()
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
            -- ACTIVATE FAST REEL WHEN R IS PRESSED
            for i = 1, 30 do
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                wait(0.01)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
            print("⚡ Fast Reel Hotkey Activated!")
        end
    end)
    print("🔘 Fast Reel Hotkey Ready! Press 'R'")
end)

-- ===============================
-- DRAGGABLE GUI
-- ===============================
local dragging = false
local dragStart, frameStart

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ===============================
-- NOTIFICATION
-- ===============================
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 350, 0, 80)
notify.Position = UDim2.new(0.5, -175, 0, 20)
notify.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
notify.Text = "✅ GARXCUY HUB v7.0 LOADED!\n👑 By: Linggar Jati Erlangga\n📞 0895-2007-1068\n⚡ NEW: Fast Reel Feature!"
notify.TextColor3 = Color3.white
notify.Font = Enum.Font.GothamBold
notify.TextSize = 14
notify.TextWrapped = true
notify.Parent = screenGui

spawn(function()
    wait(5)
    notify:Destroy()
end)

-- ===============================
-- FINAL SETUP
-- ===============================
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#toggles + 7) * 55)

print("✅ GUI Created Successfully")
print("✅ Toggles: " .. #toggles .. " features ready")
print("✅ NEW: Fast Reel Added!")
print("✅ Game: GET FISH")
print("✅ Creator: Linggar Jati Erlangga")

-- SUCCESS SOUND
pcall(function()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = 0.3
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 3)
end)

-- AUTO-UPDATE NOTIFICATION
spawn(function()
    wait(10)
    if screenGui and screenGui.Parent then
        local updateNotify = Instance.new("TextLabel")
        updateNotify.Size = UDim2.new(0, 280, 0, 50)
        updateNotify.Position = UDim2.new(1, -290, 1, -60)
        updateNotify.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        updateNotify.Text = "🔱 Garxcuy Hub Active\n⚡ Fast Reel Ready"
        updateNotify.TextColor3 = Color3.fromRGB(0, 255, 0)
        updateNotify.Font = Enum.Font.GothamBold
        updateNotify.TextSize = 12
        updateNotify.TextWrapped = true
        updateNotify.Parent = screenGui
    end
end)

-- ANTI-AFK
spawn(function()
    while wait(30) do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
    end
end)

print("=================================================================")
print("✅ SCRIPT READY WITH FAST REEL FEATURE!")
print("=================================================================")

return "Garxcuy Hub v7.0 with Fast Reel Loaded Successfully"
