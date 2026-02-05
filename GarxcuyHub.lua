-- ============================================
-- GARXCUY HUB v8.0 - MINIMAL GUI
-- POSITION: BOTTOM RIGHT (Tidak menghalangi)
-- BY: LINGGAR JATI ERLANGGAsudo
-- ============================================

getgenv().GarxcuyHub = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(2)

print("🔱 GARXCUY HUB v8.0 | Minimal Mode")

-- VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- CREATE MINIMAL GUI (DI BAWAH KANAN)
local gui = Instance.new("ScreenGui")
gui.Name = "GarxcuyHub_Minimal"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game.CoreGui

-- COLLAPSIBLE SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 45, 0, 200)
sidebar.Position = UDim2.new(1, -50, 0.5, -100) -- KANAN TENGAH
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30, 0.7) -- TRANSPARAN
sidebar.BorderSizePixel = 0
sidebar.ClipsDescendants = true
sidebar.Parent = gui

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
toggleBtn.Text = "🔱"
toggleBtn.TextColor3 = Color3.white
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.Parent = sidebar

-- EXPANDED PANEL (Sembunyi awal)
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 0, 1, 0)
panel.Position = UDim2.new(1, 0, 0, 0)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 35, 0.9)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Parent = sidebar

-- SCROLL FRAME
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -5, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.Parent = panel

-- STATE
local expanded = false
local cheats = {}

-- TOGGLE EXPAND/COLLAPSE
toggleBtn.MouseButton1Click:Connect(function()
    expanded = not expanded
    if expanded then
        panel.Size = UDim2.new(0, 250, 1, 0)
        sidebar.Size = UDim2.new(0, 295, 0, 300)
        toggleBtn.Text = "✖"
    else
        panel.Size = UDim2.new(0, 0, 1, 0)
        sidebar.Size = UDim2.new(0, 45, 0, 200)
        toggleBtn.Text = "🔱"
    end
end)

-- CREATE MINI BUTTON
function CreateMiniButton(name, icon, callback)
    local idx = #cheats + 1
    local yPos = (idx-1) * 45
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = scroll
    
    btn.MouseButton1Click:Connect(callback)
    
    table.insert(cheats, btn)
    scroll.CanvasSize = UDim2.new(0, 0, 0, idx * 45)
end

-- CREATE MINI TOGGLE
function CreateMiniToggle(name, icon, callback)
    local idx = #cheats + 1
    local yPos = (idx-1) * 45
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.Parent = scroll
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(0, 5, 0, 5)
    toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.white
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 10
    toggle.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 35, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. name
    label.TextColor3 = Color3.white
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggle.Text = "ON"
        else
            toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            toggle.Text = "OFF"
        end
        callback(state)
    end)
    
    table.insert(cheats, frame)
    scroll.CanvasSize = UDim2.new(0, 0, 0, idx * 45)
    
    return toggle
end

-- ===============================
-- MINIMAL FEATURES
-- ===============================

-- FAST REEL TOGGLE
local fastReelToggle = CreateMiniToggle("Fast Reel", "⚡", function(state)
    if state then
        spawn(function()
            while fastReelToggle.Text == "ON" do
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                wait(0.02)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
    end
end)

-- AUTO FISH
CreateMiniToggle("Auto Fish", "🎣", function(state)
    if state then
        spawn(function()
            while wait(3) do
                pcall(function()
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Part") and obj.BrickColor == BrickColor.new("Bright blue") then
                            local char = LocalPlayer.Character
                            if char then
                                char:SetPrimaryPartCFrame(obj.CFrame + Vector3.new(0, 5, 0))
                                wait(0.5)
                                mouse1click()
                                break
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

-- SPEED HACK
CreateMiniToggle("Speed x5", "🏃", function(state)
    if LocalPlayer.Character then
        if state then
            LocalPlayer.Character.Humanoid.WalkSpeed = 80
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- INFINITE JUMP
CreateMiniToggle("Inf Jump", "🦘", function(state)
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- QUICK BUTTONS
CreateMiniButton("Teleport Spot", "📍", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("LAUT") then
            LocalPlayer.Character:SetPrimaryPartCFrame(obj.CFrame)
            break
        end
    end
end)

CreateMiniButton("Claim Daily", "💰", function()
    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if gui:IsA("TextButton") and gui.Text:find("DAILY") then
            fireclickdetector(gui)
            break
        end
    end
end)

CreateMiniButton("+50K CF", "📈", function()
    if LocalPlayer:FindFirstChild("leaderstats") then
        for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
            if stat.Name == "CF" then
                stat.Value = stat.Value + 50000
            end
        end
    end
end)

CreateMiniButton("Load IY", "🛡️", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

CreateMiniButton("Close", "❌", function()
    gui:Destroy()
end)

-- ===============================
-- WATERMARK (TRANSPARAN)
-- ===============================
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 180, 0, 25)
watermark.Position = UDim2.new(0, 10, 1, -35)
watermark.BackgroundTransparency = 0.7
watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
watermark.Text = "🔱 Garxcuy Hub | By Linggar"
watermark.TextColor3 = Color3.fromRGB(0, 255, 0)
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 11
watermark.Parent = gui

-- ===============================
-- HOTKEYS (TANPA GUI)
-- ===============================
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        -- F1: TOGGLE FAST REEL
        if input.KeyCode == Enum.KeyCode.F1 then
            fastReelToggle:MouseButton1Click()
        end
        
        -- F2: TELEPORT TO SPOT
        if input.KeyCode == Enum.KeyCode.F2 then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:find("LAUT") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(obj.CFrame)
                    break
                end
            end
        end
        
        -- F3: SPEED TOGGLE
        if input.KeyCode == Enum.KeyCode.F3 then
            if LocalPlayer.Character then
                if LocalPlayer.Character.Humanoid.WalkSpeed == 16 then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 80
                else
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
    end
end)

-- ===============================
-- DRAGGABLE SIDEBAR
-- ===============================
local dragging = false
local dragStart, frameStart

sidebar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = sidebar.Position
    end
end)

sidebar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        sidebar.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

sidebar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ===============================
-- INITIAL NOTIFICATION
-- ===============================
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 250, 0, 40)
notify.Position = UDim2.new(0.5, -125, 0, 10)
notify.BackgroundColor3 = Color3.fromRGB(0, 100, 0, 0.8)
notify.Text = "Garxcuy Hub Loaded\nPress 🔱 button (right side)"
notify.TextColor3 = Color3.white
notify.Font = Enum.Font.GothamBold
notify.TextSize = 12
notify.TextWrapped = true
notify.Parent = gui

spawn(function()
    wait(4)
    notify:Destroy()
end)

print("✅ Minimal Hub Loaded")
print("✅ Position: Right Side (Collapsible)")
print("✅ Hotkeys: F1 (Fast Reel), F2 (Teleport), F3 (Speed)")
print("✅ Creator: Linggar Jati Erlangga")

-- AUTO-HIDE WATERMARK AFTER 30 SEC
spawn(function()
    wait(30)
    watermark.Visible = false
end)

return "Garxcuy Hub Minimal v8.0 Active"
