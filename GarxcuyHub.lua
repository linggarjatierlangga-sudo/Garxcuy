-- ============================================
-- GET FISH BOT WITH TOGGLE SYSTEM
-- Full Control Panel + Speed Adjustments
-- ============================================

local ToggleFish = {}
ToggleFish.Toggles = {}
ToggleFish.Config = {
    -- Fishing Toggles
    AutoCast = {Enabled = true, Display = "Auto Cast Rod"},
    AutoReel = {Enabled = true, Display = "Auto Reel Fish"},
    AutoSell = {Enabled = false, Display = "Auto Sell Fish"},
    AutoUpgrade = {Enabled = false, Display = "Auto Upgrade Rod"},
    
    -- Speed Toggles
    SpeedFishing = {Enabled = true, Value = 3, Display = "Fishing Speed", Max = 10},
    NoCooldown = {Enabled = true, Display = "No Cooldowns"},
    InstantBite = {Enabled = false, Display = "Instant Fish Bite"},
    
    -- Visual Toggles
    ESPFish = {Enabled = false, Display = "Fish ESP"},
    Notifications = {Enabled = true, Display = "Notifications"},
    AntiAFK = {Enabled = true, Display = "Anti-AFK"}
}

-- TOGGLE MANAGEMENT SYSTEM
function ToggleFish:ToggleFeature(featureName)
    local feature = self.Config[featureName]
    if feature then
        feature.Enabled = not feature.Enabled
        
        -- Update GUI
        if self.UpdateToggleDisplay then
            self:UpdateToggleDisplay(featureName)
        end
        
        -- Start/Stop feature
        if feature.Enabled then
            self:StartFeature(featureName)
        else
            self:StopFeature(featureName)
        end
        
        return feature.Enabled
    end
    return false
end

-- FEATURE CONTROLLERS
function ToggleFish:StartFeature(featureName)
    if featureName == "AutoCast" then
        self:StartAutoCast()
    elseif featureName == "AutoReel" then
        self:StartAutoReel()
    elseif featureName == "AutoSell" then
        self:StartAutoSell()
    elseif featureName == "AntiAFK" then
        self:EnableAntiAFK()
    elseif featureName == "SpeedFishing" then
        self:ApplySpeedMultiplier(self.Config.SpeedFishing.Value)
    end
end

function ToggleFish:StopFeature(featureName)
    if featureName == "AutoCast" then
        self.Casting = false
    elseif featureName == "AutoReel" then
        self.Reeling = false
    end
end

-- COMPLETE TOGGLE GUI
function ToggleFish:CreateToggleGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FishToggleGUI"
    
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.Parent = screenGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "🎣 GET FISH CONTROLS"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Toggle Container
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -50)
    scrollFrame.Position = UDim2.new(0, 5, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.Config * 45)
    scrollFrame.Parent = mainFrame
    
    -- Create Toggles
    local yPos = 5
    for featureName, config in pairs(self.Config) do
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -10, 0, 40)
        toggleFrame.Position = UDim2.new(0, 5, 0, yPos)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        toggleFrame.Parent = scrollFrame
        
        -- Toggle Label
        local label = Instance.new("TextLabel")
        label.Text = config.Display
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        -- Toggle Button
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = featureName
        toggleBtn.Size = UDim2.new(0, 80, 0, 25)
        toggleBtn.Position = UDim2.new(1, -85, 0.5, -12)
        toggleBtn.Text = config.Enabled and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = config.Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.GothamBold
        
        toggleBtn.MouseButton1Click:Connect(function()
            local newState = self:ToggleFeature(featureName)
            toggleBtn.Text = newState and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = newState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        end)
        
        toggleBtn.Parent = toggleFrame
        
        -- Slider for speed values
        if config.Max then
            local slider = Instance.new("TextBox")
            slider.Size = UDim2.new(0, 50, 0, 20)
            slider.Position = UDim2.new(0.7, 10, 0.5, -10)
            slider.Text = tostring(config.Value)
            slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            slider.TextColor3 = Color3.new(1, 1, 1)
            
            slider.FocusLost:Connect(function()
                local num = tonumber(slider.Text)
                if num and num >= 1 and num <= config.Max then
                    config.Value = num
                    self:ApplySpeedMultiplier(num)
                else
                    slider.Text = tostring(config.Value)
                end
            end)
            
            slider.Parent = toggleFrame
        end
        
        yPos = yPos + 45
    end
    
    -- Status Display
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, -20, 0, 60)
    statusFrame.Position = UDim2.new(0, 10, 1, 70)
    statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    statusFrame.Parent = mainFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.Text = "Active Features: 3/8"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 200)
    statusText.BackgroundTransparency = 1
    statusText.Parent = statusFrame
    
    -- Update function
    self.UpdateToggleDisplay = function()
        local activeCount = 0
        local total = 0
        for _, config in pairs(self.Config) do
            total = total + 1
            if config.Enabled then
                activeCount = activeCount + 1
            end
        end
        statusText.Text = string.format("Active: %d/%d | Speed: %dx", activeCount, total, self.Config.SpeedFishing.Value)
    end
    
    screenGui.Parent = game:GetService("CoreGui")
    return screenGui
end

-- SPEED CONTROL FUNCTIONS
function ToggleFish:ApplySpeedMultiplier(multiplier)
    -- Apply to fishing speed
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents")
    if remotes then
        -- Hook wait times
        local originalWait = task.wait
        task.wait = function(seconds)
            return originalWait(seconds / multiplier)
        end
    end
end

-- INITIALIZE
function ToggleFish:Start()
    self.GUI = self:CreateToggleGUI()
    
    -- Start enabled features
    for featureName, config in pairs(self.Config) do
        if config.Enabled then
            self:StartFeature(featureName)
        end
    end
    
    -- Update status every 5 seconds
    while true do
        self.UpdateToggleDisplay()
        task.wait(5)
    end
end

-- HOTKEY SUPPORT (Toggle dengan keyboard)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.F then -- F untuk auto-cast
            ToggleFish:ToggleFeature("AutoCast")
        elseif input.KeyCode == Enum.KeyCode.R then -- R untuk auto-reel
            ToggleFish:ToggleFeature("AutoReel")
        elseif input.KeyCode == Enum.KeyCode.T then -- T untuk speed toggle
            ToggleFish:ToggleFeature("SpeedFishing")
        end
    end
end)

-- EXECUTE
ToggleFish:Start()

print("[GET FISH] Toggle System Ready")
print("[HOTKEYS] F=AutoCast | R=AutoReel | T=Speed")
