-- ====================================================
-- GARXCUY HUB v2.0 - Delta Executor Optimized
-- Compatible with Delta Android/Windows
-- ====================================================

if not (executor or identifyexecutor) then
    game:GetService("Players").LocalPlayer:Kick("Please use Delta Executor")
    return
end

local GarxcuyHub = {Version = "2.0-Delta"}

-- DELTA SPECIFIC FUNCTIONS
local DeltaCompatible = {
    -- Delta support check
    IsDelta = (identifyexecutor and identifyexecutor():lower():find("delta")) or false,
    
    -- Delta-safe GUI creation
    CreateScreenGui = function(name)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = name
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Delta Android/Windows safe parent
        if gethui then
            screenGui.Parent = gethui()
        else
            screenGui.Parent = game:GetService("CoreGui")
        end
        
        return screenGui
    end,
    
    -- Delta HTTP compatibility
    HttpGet = function(url)
        local success, result = pcall(function()
            return game:HttpGetAsync(url)
        end)
        return success and result or ""
    end
}

-- SIMPLE TOGGLE GUI (DELTA OPTIMIZED)
function GarxcuyHub:CreateDeltaGUI()
    -- Create GUI dengan metode Delta-safe
    local screenGui = DeltaCompatible.CreateScreenGui("GarxcuyHubDelta")
    
    -- Main Window
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "🎣 GARXCUY HUB"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(0, 50, 80)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.Parent = mainFrame
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    closeBtn.Parent = mainFrame
    
    -- TOGGLE CONTAINER
    local toggleContainer = Instance.new("ScrollingFrame")
    toggleContainer.Size = UDim2.new(1, -10, 1, -80)
    toggleContainer.Position = UDim2.new(0, 5, 0, 50)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.ScrollBarThickness = 5
    toggleContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
    toggleContainer.Parent = mainFrame
    
    -- TOGGLE STATES
    local Toggles = {
        AutoCast = {Name = "Auto Cast Rod", State = true, Y = 10},
        AutoReel = {Name = "Auto Reel Fish", State = true, Y = 60},
        AutoSell = {Name = "Auto Sell Fish", State = false, Y = 110},
        Speed2x = {Name = "2x Fishing Speed", State = true, Y = 160},
        AntiAFK = {Name = "Anti-AFK", State = true, Y = 210}
    }
    
    -- CREATE TOGGLES
    for toggleName, toggleData in pairs(Toggles) do
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -10, 0, 40)
        toggleFrame.Position = UDim2.new(0, 5, 0, toggleData.Y)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = toggleContainer
        
        -- Toggle Label
        local label = Instance.new("TextLabel")
        label.Text = "  " .. toggleData.Name
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Parent = toggleFrame
        
        -- Toggle Button (INILAH YANG PASTI MUNCUL)
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = toggleName
        toggleBtn.Text = toggleData.State and "ON" or "OFF"
        toggleBtn.Size = UDim2.new(0, 60, 0, 25)
        toggleBtn.Position = UDim2.new(1, -65, 0.5, -12.5)
        toggleBtn.BackgroundColor3 = toggleData.State and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextScaled = true
        
        -- TOGGLE FUNCTIONALITY
        toggleBtn.MouseButton1Click:Connect(function()
            toggleData.State = not toggleData.State
            toggleBtn.Text = toggleData.State and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = toggleData.State and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
            
            -- Notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Garxcuy Hub",
                Text = toggleData.Name .. ": " .. (toggleData.State and "Enabled" or "Disabled"),
                Duration = 2
            })
            
            -- Action based on toggle
            if toggleName == "AutoCast" then
                GarxcuyHub:ToggleAutoCast(toggleData.State)
            elseif toggleName == "AutoReel" then
                GarxcuyHub:ToggleAutoReel(toggleData.State)
            elseif toggleName == "Speed2x" then
                GarxcuyHub:ToggleSpeed(toggleData.State)
            end
        end)
        
        toggleBtn.Parent = toggleFrame
    end
    
    -- CONTROL BUTTONS
    local startBtn = Instance.new("TextButton")
    startBtn.Text = "▶ START ALL"
    startBtn.Size = UDim2.new(1, -20, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 1, -160)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    startBtn.TextColor3 = Color3.new(1, 1, 1)
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextScaled = true
    
    startBtn.MouseButton1Click:Connect(function()
        -- Start all enabled features
        for toggleName, toggleData in pairs(Toggles) do
            if toggleData.State then
                if toggleName == "AutoCast" then
                    GarxcuyHub:StartAutoCast()
                elseif toggleName == "AutoReel" then
                    GarxcuyHub:StartAutoReel()
                end
            end
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Garxcuy Hub",
            Text = "All features started",
            Duration = 2
        })
    end)
    
    startBtn.Parent = toggleContainer
    
    local stopBtn = Instance.new("TextButton")
    stopBtn.Text = "⏹ STOP ALL"
    stopBtn.Size = UDim2.new(1, -20, 0, 40)
    stopBtn.Position = UDim2.new(0, 10, 1, -110)
    stopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    stopBtn.TextColor3 = Color3.new(1, 1, 1)
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextScaled = true
    
    stopBtn.MouseButton1Click:Connect(function()
        -- Stop all features
        GarxcuyHub:StopAll()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Garxcuy Hub",
            Text = "All features stopped",
            Duration = 2
        })
    end)
    
    stopBtn.Parent = toggleContainer
    
    -- Status Display
    local status = Instance.new("TextLabel")
    status.Text = "Delta Executor | GET FISH"
    status.Size = UDim2.new(1, -10, 0, 30)
    status.Position = UDim2.new(0, 5, 1, -60)
    status.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    status.TextColor3 = Color3.fromRGB(0, 255, 200)
    status.TextScaled = true
    status.Parent = toggleContainer
    
    return screenGui
end

-- FISHING FUNCTIONS
function GarxcuyHub:ToggleAutoCast(state)
    self.AutoCastRunning = state
    if state then
        self:StartAutoCast()
    end
end

function GarxcuyHub:StartAutoCast()
    spawn(function()
        while self.AutoCastRunning do
            pcall(function()
                -- GET FISH specific remote
                local events = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents")
                if events and events:FindFirstChild("CastRod") then
                    events.CastRod:FireServer()
                end
            end)
            wait(2) -- Cast every 2 seconds
        end
    end)
end

function GarxcuyHub:ToggleAutoReel(state)
    self.AutoReelRunning = state
    if state then
        self:StartAutoReel()
    end
end

function GarxcuyHub:StartAutoReel()
    spawn(function()
        while self.AutoReelRunning do
            -- Check for fish bite
            local gui = game:GetService("Players").LocalPlayer.PlayerGui
            local biteText = gui:FindFirstChild("BiteIndicator", true)
            
            if biteText and biteText.Visible then
                pcall(function()
                    local events = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents")
                    if events and events:FindFirstChild("ReelRod") then
                        events.ReelRod:FireServer()
                    end
                end)
            end
            wait(0.1) -- Fast detection
        end
    end)
end

function GarxcuyHub:ToggleSpeed(state)
    if state then
        -- Speed hack sederhana
        local originalWait = wait
        wait = function(seconds)
            return originalWait(seconds / 2) -- 2x faster
        end
    end
end

function GarxcuyHub:StopAll()
    self.AutoCastRunning = false
    self.AutoReelRunning = false
end

-- ANTI-AFK (Delta compatible)
function GarxcuyHub:StartAntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- INITIALIZE
function GarxcuyHub:Init()
    print("Garxcuy Hub v2.0 for Delta Executor")
    print("Game: GET FISH")
    print("Place ID: 78632820802305")
    
    -- Start Anti-AFK
    self:StartAntiAFK()
    
    -- Create GUI (PASTI MUNCUL)
    task.wait(1)
    self.GUI = self:CreateDeltaGUI()
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Garxcuy Hub",
        Text = "Delta Edition Loaded!",
        Duration = 3,
        Icon = "rbxassetid://4483345998"
    })
    
    return self
end

-- EXECUTE
GarxcuyHub:Init()

return GarxcuyHub
