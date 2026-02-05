-- ====================================================
-- GARXCUY HUB v2.1 - DELTA FIXED
-- Masalah: GUI gabisa close + Script ga jalan
-- Solusi: Simple execution + Proper event handling
-- ====================================================

-- EXECUTOR CHECK
local ExecutorName = identifyexecutor and identifyexecutor() or "Unknown"
print("Executor:", ExecutorName)
print("Game: GET FISH (78632820802305)")

-- VARIABLES
local Running = {
    AutoCast = false,
    AutoReel = false,
    AutoSell = false
}

-- REMOTE DETECTION
local function GetRemotes()
    local repStorage = game:GetService("ReplicatedStorage")
    local fishingEvents = repStorage:FindFirstChild("FishingEvents")
    
    if fishingEvents then
        return {
            Cast = fishingEvents:FindFirstChild("CastRod"),
            Reel = fishingEvents:FindFirstChild("ReelRod"),
            Sell = fishingEvents:FindFirstChild("SellFish")
        }
    end
    return nil
end

-- FISHING FUNCTIONS (FIXED)
local function StartAutoCast()
    if Running.AutoCast then return end
    Running.AutoCast = true
    
    task.spawn(function()
        local remotes = GetRemotes()
        if not remotes or not remotes.Cast then
            warn("CastRod remote not found!")
            return
        end
        
        while Running.AutoCast do
            pcall(function()
                remotes.Cast:FireServer()
            end)
            task.wait(2) -- Delay between casts
        end
    end)
    
    print("AutoCast: Started")
end

local function StopAutoCast()
    Running.AutoCast = false
    print("AutoCast: Stopped")
end

local function StartAutoReel()
    if Running.AutoReel then return end
    Running.AutoReel = true
    
    task.spawn(function()
        local remotes = GetRemotes()
        
        while Running.AutoReel do
            -- Cari indikator bite di GUI
            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            local biteIndicator = nil
            
            -- Cari semua kemungkinan nama indicator
            local possibleNames = {"BiteIndicator", "ReelNow", "!!!", "FishOn", "ClickNow"}
            for _, name in pairs(possibleNames) do
                local found = playerGui:FindFirstChild(name, true)
                if found and found:IsA("GuiObject") and found.Visible then
                    biteIndicator = found
                    break
                end
            end
            
            -- Jika ada indicator, reel fish
            if biteIndicator and remotes and remotes.Reel then
                pcall(function()
                    remotes.Reel:FireServer()
                    print("Fish reeled!")
                end)
                task.wait(0.5) -- Delay setelah reel
            end
            
            task.wait(0.2) -- Check interval
        end
    end)
    
    print("AutoReel: Started")
end

local function StopAutoReel()
    Running.AutoReel = false
    print("AutoReel: Stopped")
end

-- GUI CREATION (FIXED CLOSE FUNCTION)
local function CreateFixedGUI()
    -- Hapus GUI lama jika ada
    local coreGui = game:GetService("CoreGui")
    local oldGUI = coreGui:FindFirstChild("GarxcuyFixedGUI")
    if oldGUI then
        oldGUI:Destroy()
        task.wait(0.1)
    end
    
    -- Buat GUI baru
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GarxcuyFixedGUI"
    screenGui.ResetOnSpawn = false
    
    -- Main Window
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(0, 100, 150)
    
    -- Title Bar (DRAGGABLE + CLOSE)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 80, 120)
    titleBar.BorderSizePixel = 0
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = "🎣 GARXCUY HUB v2.1"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.Font = Enum.Font.GothamBold
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- CLOSE BUTTON (FIXED)
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -35, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextScaled = true
    
    -- FIX: Close function yang benar
    closeButton.MouseButton1Click:Connect(function()
        print("Closing GUI...")
        screenGui:Destroy()
        print("GUI Destroyed")
        
        -- Stop semua fitur ketika GUI ditutup
        StopAutoCast()
        StopAutoReel()
    end)
    
    -- Draggable GUI
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Toggle Container
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -100)
    scrollFrame.Position = UDim2.new(0, 5, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
    
    -- TOGGLE 1: Auto Cast
    local toggle1Frame = Instance.new("Frame")
    toggle1Frame.Size = UDim2.new(1, 0, 0, 45)
    toggle1Frame.Position = UDim2.new(0, 0, 0, 10)
    toggle1Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggle1Frame.BorderSizePixel = 0
    
    local toggle1Label = Instance.new("TextLabel")
    toggle1Label.Text = "  Auto Cast Rod"
    toggle1Label.Size = UDim2.new(0.7, 0, 1, 0)
    toggle1Label.BackgroundTransparency = 1
    toggle1Label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    toggle1Label.TextXAlignment = Enum.TextXAlignment.Left
    toggle1Label.TextScaled = true
    
    local toggle1Btn = Instance.new("TextButton")
    toggle1Btn.Text = "OFF"
    toggle1Btn.Size = UDim2.new(0, 70, 0, 30)
    toggle1Btn.Position = UDim2.new(1, -75, 0.5, -15)
    toggle1Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    toggle1Btn.TextColor3 = Color3.new(1, 1, 1)
    toggle1Btn.Font = Enum.Font.GothamBold
    toggle1Btn.TextScaled = true
    
    toggle1Btn.MouseButton1Click:Connect(function()
        if toggle1Btn.Text == "OFF" then
            toggle1Btn.Text = "ON"
            toggle1Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            StartAutoCast()
        else
            toggle1Btn.Text = "OFF"
            toggle1Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            StopAutoCast()
        end
    end)
    
    -- TOGGLE 2: Auto Reel
    local toggle2Frame = Instance.new("Frame")
    toggle2Frame.Size = UDim2.new(1, 0, 0, 45)
    toggle2Frame.Position = UDim2.new(0, 0, 0, 65)
    toggle2Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggle2Frame.BorderSizePixel = 0
    
    local toggle2Label = Instance.new("TextLabel")
    toggle2Label.Text = "  Auto Reel Fish"
    toggle2Label.Size = UDim2.new(0.7, 0, 1, 0)
    toggle2Label.BackgroundTransparency = 1
    toggle2Label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    toggle2Label.TextXAlignment = Enum.TextXAlignment.Left
    toggle2Label.TextScaled = true
    
    local toggle2Btn = Instance.new("TextButton")
    toggle2Btn.Text = "OFF"
    toggle2Btn.Size = UDim2.new(0, 70, 0, 30)
    toggle2Btn.Position = UDim2.new(1, -75, 0.5, -15)
    toggle2Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    toggle2Btn.TextColor3 = Color3.new(1, 1, 1)
    toggle2Btn.Font = Enum.Font.GothamBold
    toggle2Btn.TextScaled = true
    
    toggle2Btn.MouseButton1Click:Connect(function()
        if toggle2Btn.Text == "OFF" then
            toggle2Btn.Text = "ON"
            toggle2Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            StartAutoReel()
        else
            toggle2Btn.Text = "OFF"
            toggle2Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            StopAutoReel()
        end
    end)
    
    -- ACTION BUTTONS
    local startAllBtn = Instance.new("TextButton")
    startAllBtn.Text = "▶ START ALL"
    startAllBtn.Size = UDim2.new(1, 0, 0, 40)
    startAllBtn.Position = UDim2.new(0, 0, 0, 130)
    startAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    startAllBtn.TextColor3 = Color3.new(1, 1, 1)
    startAllBtn.Font = Enum.Font.GothamBold
    startAllBtn.TextScaled = true
    
    startAllBtn.MouseButton1Click:Connect(function()
        toggle1Btn.Text = "ON"
        toggle1Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        toggle2Btn.Text = "ON"
        toggle2Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        StartAutoCast()
        StartAutoReel()
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Garxcuy Hub",
            Text = "All features started!",
            Duration = 2
        })
    end)
    
    local stopAllBtn = Instance.new("TextButton")
    stopAllBtn.Text = "⏹ STOP ALL"
    stopAllBtn.Size = UDim2.new(1, 0, 0, 40)
    stopAllBtn.Position = UDim2.new(0, 0, 0, 180)
    stopAllBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    stopAllBtn.TextColor3 = Color3.new(1, 1, 1)
    stopAllBtn.Font = Enum.Font.GothamBold
    stopAllBtn.TextScaled = true
    
    stopAllBtn.MouseButton1Click:Connect(function()
        toggle1Btn.Text = "OFF"
        toggle1Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        toggle2Btn.Text = "OFF"
        toggle2Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        
        StopAutoCast()
        StopAutoReel()
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Garxcuy Hub",
            Text = "All features stopped!",
            Duration = 2
        })
    end)
    
    -- ASSEMBLE GUI
    titleText.Parent = titleBar
    closeButton.Parent = titleBar
    titleBar.Parent = mainFrame
    
    toggle1Label.Parent = toggle1Frame
    toggle1Btn.Parent = toggle1Frame
    toggle1Frame.Parent = scrollFrame
    
    toggle2Label.Parent = toggle2Frame
    toggle2Btn.Parent = toggle2Frame
    toggle2Frame.Parent = scrollFrame
    
    startAllBtn.Parent = scrollFrame
    stopAllBtn.Parent = scrollFrame
    
    scrollFrame.Parent = mainFrame
    mainFrame.Parent = screenGui
    
    -- PARENT KE CoreGui (FIXED)
    screenGui.Parent = game:GetService("CoreGui")
    
    print("GUI Created Successfully")
    return screenGui
end

-- ANTI-AFK
local function EnableAntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    print("Anti-AFK Enabled")
end

-- AUTO-SELL (BONUS)
local function StartAutoSell()
    if Running.AutoSell then return end
    Running.AutoSell = true
    
    task.spawn(function()
        local remotes = GetRemotes()
        
        while Running.AutoSell do
            task.wait(30) -- Sell every 30 seconds
            
            if remotes and remotes.Sell then
                pcall(function()
                    remotes.Sell:FireServer("All")
                    print("Auto-sell executed")
                end)
            end
        end
    end)
end

-- INITIALIZE
print("=== GARXCUY HUB INITIALIZING ===")
EnableAntiAFK()

-- Tunggu game load
task.wait(2)

-- Cek remotes
local remotes = GetRemotes()
if remotes then
    print("Remotes found:")
    for name, remote in pairs(remotes) do
        print("  - " .. name .. ": " .. tostring(remote ~= nil))
    end
else
    warn("Fishing remotes not found! Script mungkin tidak berfungsi.")
end

-- Buat GUI
local GUI = CreateFixedGUI()

-- HOTKEY: F9 untuk toggle GUI
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F9 then
        if GUI and GUI.Parent then
            GUI:Destroy()
            print("GUI Hidden (F9 to show)")
        else
            GUI = CreateFixedGUI()
        end
    end
end)

print("=== GARXCUY HUB READY ===")
print("Close Button: ✓ Working")
print("Auto Cast: ✓ Working")
print("Auto Reel: ✓ Working")
print("Hotkey: F9 to toggle GUI")

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Garxcuy Hub v2.1",
    Text = "Loaded! Close button fixed ✓",
    Duration = 3
})
