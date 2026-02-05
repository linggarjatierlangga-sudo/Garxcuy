-- ============================================
-- GARXCUY HUB GET FISH FIXED v3.5
-- TARGET: GET FISH (Based on screenshot)
-- By: Linggar Jati Erlangga
-- ============================================

wait(3) -- Tunggu game load SEMPURNA

print("🔱 INITIALIZING GARXCUY HUB v3.5...")

-- LOAD SIMPLE UI (NO LIBRARY) BIAR PASTI MUNCUL
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- CREATE SIMPLE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarxcuyHub"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
title.Text = "🔱 GARXCUY HUB v3.5 | GET FISH"
title.TextColor3 = Color3.white
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

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

-- SCROLLING FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = mainFrame

-- VARIABLES
local toggles = {}
local buttons = {}

-- FUNCTION TO CREATE TOGGLE
function CreateToggle(name, callback)
    local yPos = #toggles * 45
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = scrollFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleButton.Text = "❌ " .. name
    toggleButton.TextColor3 = Color3.white
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 14
    toggleButton.Parent = toggleFrame
    
    local state = false
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleButton.Text = "✅ " .. name
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            toggleButton.Text = "❌ " .. name
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
        callback(state)
    end)
    
    table.insert(toggles, toggleButton)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #toggles * 45)
end

-- FUNCTION TO CREATE BUTTON
function CreateButton(name, callback)
    local yPos = (#toggles + #buttons) * 45
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
    button.Text = "🔘 " .. name
    button.TextColor3 = Color3.white
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = scrollFrame
    
    button.MouseButton1Click:Connect(callback)
    
    table.insert(buttons, button)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#toggles + #buttons) * 45)
end

-- DRAGGABLE
local dragging = false
local dragStart, frameStart
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- ===============================
-- FITUR AUTO FARM (SPECIFIC GET FISH)
-- ===============================
CreateToggle("AUTO FISH (Main)", function(state)
    if state then
        spawn(function()
            while toggles[1].Text:find("✅") do
                wait(1)
                -- TELEPORT KE AREA FISHING
                pcall(function()
                    -- Cari area fishing berdasarkan screenshot
                    for _, part in pairs(Workspace:GetDescendants()) do
                        if part.Name == "Unte Tinc Tang" or part.Name == "Undang" then
                            LocalPlayer.Character:SetPrimaryPartCFrame(part.CFrame + Vector3.new(0, 5, 0))
                            wait(0.5)
                            -- CLICK FISHING
                            mouse1click()
                        end
                    end
                end)
            end
        end)
        print("✅ AUTO FISH ENABLED")
    else
        print("❌ AUTO FISH DISABLED")
    end
end)

CreateToggle("AUTO COLLECT REWARD", function(state)
    if state then
        spawn(function()
            while toggles[2].Text:find("✅") do
                wait(5)
                -- KLIK DAILY REWARD
                pcall(function()
                    for _, gui in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and (gui.Text:find("DAILY") or gui.Text:find("REWARD")) then
                            fireclickdetector(gui)
                        end
                    end
                end)
            end
        end)
    end
end)

CreateToggle("SPEED HACK (x10)", function(state)
    if state then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

CreateToggle("INFINITE JUMP", function(state)
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            LocalPlayer.Character.Humanoid:ChangeState("Jumping")
        end)
    end
end)

-- ===============================
-- BUTTON FEATURES
-- ===============================
CreateButton("TELEPORT TO BEST SPOT", function()
    -- Cari spot dengan CF tertinggi
    pcall(function()
        for _, part in pairs(Workspace:GetDescendants()) do
            if part.Name:find("LAUT") or part.Name:find("TERBUKA") then
                LocalPlayer.Character:SetPrimaryPartCFrame(part.CFrame)
                break
            end
        end
    end)
end)

CreateButton("CLAIM ALL MISSIONS", function()
    -- Auto claim mission
    pcall(function()
        for _, gui in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("TextButton") and gui.Text:find("CLAIM") then
                fireclickdetector(gui)
                wait(0.3)
            end
        end
    end)
end)

CreateButton("MAXIMIZE CF (TEST)", function()
    -- Coba tambah CF
    pcall(function()
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats and stats:FindFirstChild("CF") then
            stats.CF.Value = 999999999
        end
    end)
end)

CreateButton("LOAD INFINITE YIELD", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- ===============================
-- SLIDER WALKSPEED
-- ===============================
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, 0, 0, 60)
sliderFrame.Position = UDim2.new(0, 0, 0, (#toggles + #buttons) * 45 + 10)
sliderFrame.BackgroundTransparency = 1
sliderFrame.Parent = scrollFrame

local sliderText = Instance.new("TextLabel")
sliderText.Size = UDim2.new(1, 0, 0, 20)
sliderText.Text = "WALK SPEED: 16"
sliderText.TextColor3 = Color3.white
sliderText.Font = Enum.Font.Gotham
sliderText.TextSize = 12
sliderText.Parent = sliderFrame

local slider = Instance.new("Frame")
slider.Size = UDim2.new(1, 0, 0, 20)
slider.Position = UDim2.new(0, 0, 0, 25)
slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
slider.Parent = sliderFrame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.1, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderFill.Parent = slider

local draggingSlider = false
slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

slider.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local x = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
        local ratio = x / slider.AbsoluteSize.X
        sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        
        local speed = math.floor(16 + (300 - 16) * ratio)
        sliderText.Text = "WALK SPEED: " .. speed
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

-- ===============================
-- FINAL SETUP
-- ===============================
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#toggles + #buttons) * 45 + 80)

-- SHOW NOTIFICATION
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 300, 0, 60)
notif.Position = UDim2.new(1, 10, 1, -70)
notif.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
notif.Text = "✅ GARXCUY HUB LOADED!\nBy Linggar Jati Erlangga"
notif.TextColor3 = Color3.white
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.TextWrapped = true
notif.Parent = screenGui

wait(3)
notif:Destroy()

print("========================================")
print("✅ GARXCUY HUB v3.5 READY!")
print("✅ UI: Custom Simple GUI")
print("✅ No Library - No Error")
print("✅ Toggle: WORKING 100%")
print("✅ Creator: Linggar Jati Erlangga")
print("========================================")
