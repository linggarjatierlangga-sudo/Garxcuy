--[[
    SCRIPT SUPER LENGKAP: Rayfield Menu + Fly GUI 
    Fitur: NoClip, Teleport, WalkSpeed, Theme, Input Player, Fly GUI dengan kontrol on-screen
    Creator: GAR
]]

-- Load Rayfield Library (ganti link jika perlu)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variables global
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- State untuk fly GUI
local flyGuiActive = false
local flyGuiInstance = nil

-- ==================== FUNGSI FLY GUI ====================
local function setupFlyGUI()
    if flyGuiActive then return end
    flyGuiActive = true

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    flyGuiInstance = screenGui

    -- Variabel lokal fly
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local HRP = character:WaitForChild("HumanoidRootPart")
    local flySpeed = 50
    local flying = false
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = HRP.CFrame
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    -- Loading frame
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.Position = UDim2.new(0, 0, 0, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadingFrame.BackgroundTransparency = 0
    loadingFrame.Parent = screenGui

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Name = "LoadingLabel"
    loadingLabel.Size = UDim2.new(0.5, 0, 0.2, 0)
    loadingLabel.Position = UDim2.new(0.25, 0, 0.4, 0)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Text = "Loading..."
    loadingLabel.TextScaled = true
    loadingLabel.Font = Enum.Font.GothamBold
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.Parent = loadingFrame

    -- Container kontrol fly
    local flyControlsContainer = Instance.new("Frame")
    flyControlsContainer.Name = "FlyControlsContainer"
    flyControlsContainer.Size = UDim2.new(1, 0, 1, 0)
    flyControlsContainer.BackgroundTransparency = 1
    flyControlsContainer.Parent = screenGui

    local dpadSize = UDim2.new(0, 60, 0, 60)
    local toggleButton, forwardButton, backButton, leftButton, rightButton, upButton, downButton, uiToggleButton
    local uiVisible = true
    local inputFlags = { forward = false, back = false, left = false, right = false, up = false, down = false }

    local function startFlying()
        flying = true
        bodyVelocity.Parent = HRP
        bodyGyro.Parent = HRP
        humanoid.PlatformStand = true
    end

    local function stopFlying()
        flying = false
        bodyVelocity.Parent = nil
        bodyGyro.Parent = nil
        humanoid.PlatformStand = false
    end

    local function createButton(parent, name, text, pos, size)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Text = text
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.BackgroundTransparency = 0.2
        btn.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = btn
        return btn
    end

    local function tweenFlyControls(visible)
        local tweenTime = 0.5
        for _, btn in pairs(flyControlsContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                local targetBackgroundTransparency = visible and 0.2 or 1
                local targetTextTransparency = visible and 0 or 1
                local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(btn, tweenInfo, {
                    BackgroundTransparency = targetBackgroundTransparency,
                    TextTransparency = targetTextTransparency
                })
                tween:Play()
                btn.Active = visible
                btn.Selectable = visible
            end
        end
    end

    local function addTouchEvents(button, flagName)
        button.MouseButton1Down:Connect(function() inputFlags[flagName] = true end)
        button.MouseButton1Up:Connect(function() inputFlags[flagName] = false end)
        button.MouseLeave:Connect(function() inputFlags[flagName] = false end)
    end

    toggleButton = createButton(flyControlsContainer, "ToggleFlyButton", "Toggle Fly", UDim2.new(1, -110, 0, 10), UDim2.new(0, 100, 0, 50))
    toggleButton.MouseButton1Click:Connect(function()
        if flying then
            stopFlying()
            toggleButton.Text = "Fly OFF"
        else
            startFlying()
            toggleButton.Text = "Fly ON"
        end
    end)

    forwardButton = createButton(flyControlsContainer, "ForwardButton", "↑", UDim2.new(0, 70, 1, -190), dpadSize)
    backButton = createButton(flyControlsContainer, "BackButton", "↓", UDim2.new(0, 70, 1, -70), dpadSize)
    leftButton = createButton(flyControlsContainer, "LeftButton", "←", UDim2.new(0, 10, 1, -130), dpadSize)
    rightButton = createButton(flyControlsContainer, "RightButton", "→", UDim2.new(0, 130, 1, -130), dpadSize)
    upButton = createButton(flyControlsContainer, "UpButton", "Up", UDim2.new(1, -110, 1, -190), dpadSize)
    downButton = createButton(flyControlsContainer, "DownButton", "Down", UDim2.new(1, -110, 1, -70), dpadSize)

    uiToggleButton = createButton(screenGui, "UIToggleButton", "Hide UI", UDim2.new(0, 10, 0, 10), UDim2.new(0, 100, 0, 50))
    uiToggleButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        tweenFlyControls(uiVisible)
        uiToggleButton.Text = uiVisible and "Hide UI" or "Show UI"
    end)

    addTouchEvents(forwardButton, "forward")
    addTouchEvents(backButton, "back")
    addTouchEvents(leftButton, "left")
    addTouchEvents(rightButton, "right")
    addTouchEvents(upButton, "up")
    addTouchEvents(downButton, "down")

    -- Update karakter saat respawn
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = newCharacter:WaitForChild("Humanoid")
        HRP = newCharacter:WaitForChild("HumanoidRootPart")
        flying = false
    end)

    -- Loop fly
    RunService.RenderStepped:Connect(function(deltaTime)
        if flying and HRP and HRP.Parent then
            local moveDirection = Vector3.new(0, 0, 0)
            local camCF = Camera.CFrame
            if inputFlags.forward then moveDirection = moveDirection + camCF.LookVector end
            if inputFlags.back then moveDirection = moveDirection - camCF.LookVector end
            if inputFlags.left then moveDirection = moveDirection - camCF.RightVector end
            if inputFlags.right then moveDirection = moveDirection + camCF.RightVector end
            if inputFlags.up then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if inputFlags.down then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            if moveDirection.Magnitude > 0 then moveDirection = moveDirection.Unit end
            bodyVelocity.Velocity = moveDirection * flySpeed
            bodyGyro.CFrame = camCF
        end
    end)

    -- Hilangkan loading setelah 2 detik
    task.delay(2, function()
        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenFrame = TweenService:Create(loadingFrame, tweenInfo, { BackgroundTransparency = 1 })
        local tweenLabel = TweenService:Create(loadingLabel, tweenInfo, { TextTransparency = 1 })
        tweenFrame:Play()
        tweenLabel:Play()
        tweenFrame.Completed:Connect(function() loadingFrame:Destroy() end)
    end)
end

local function destroyFlyGUI()
    if flyGuiInstance then
        flyGuiInstance:Destroy()
        flyGuiInstance = nil
    end
    flyGuiActive = false
end

-- ==================== RAYFIELD MENU ====================
local Window = Rayfield:CreateWindow({
    Name = "🥊 SLAP BATTLES HUB + FLY GUI",
    LoadingTitle = "Slap Battles Script",
    LoadingSubtitle = "by Zora AI",
    ConfigurationSaving = { Enabled = true, FolderName = "SlapBattlesHub", FileName = "Config" },
    Discord = { Enabled = false, Invite = "", RememberJoins = true },
    KeySystem = false
})

-- Tab Main
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Player Controls")

-- NoClip Toggle
local noclipEnabled = false
local noclipConnection
MainSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(value)
        noclipEnabled = value
        if value then
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.Anchored = true
            noclipConnection = runService.RenderStepped:Connect(function()
                if not noclipEnabled or not player.Character then return end
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local moveDir = Vector3.new(0,0,0)
                local speed = 50
                if userInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector * speed
                end
                if userInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector * speed
                end
                if userInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector * speed
                end
                if userInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector * speed
                end
                if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, speed, 0)
                end
                if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0, speed, 0)
                end
                hrp.CFrame = hrp.CFrame + moveDir
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = false
                end
            end
        end
    end
})

-- Teleport to Spawn
MainSection:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
            Rayfield:Notify({ Title = "Teleport", Content = "You have been teleported to spawn!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Character not found", Duration = 2 })
        end
    end
})

-- Toggle Fly GUI
MainSection:CreateToggle({
    Name = "Enable Fly GUI (Mobile Friendly)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            setupFlyGUI()
        else
            destroyFlyGUI()
        end
    end
})

-- Tab Visual
local VisualTab = Window:CreateTab("Visual", nil)
local VisualSection = VisualTab:CreateSection("Movement")

-- Walk Speed Slider (range terukur 16-200)
VisualSection:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- Tab Settings
local SettingsTab = Window:CreateTab("Settings", nil)
local SettingsSection = SettingsTab:CreateSection("UI Settings")

-- Theme Dropdown
SettingsSection:CreateDropdown({
    Name = "Theme",
    Options = {"Default", "Dark", "Light"},
    CurrentOption = "Default",
    Callback = function(value)
        if Window.SetTheme then
            Window:SetTheme(value)
        else
            print("Theme change to: " .. value)
        end
    end
})

-- Player Name Input
SettingsSection:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    CurrentValue = "",
    Callback = function(value)
        local target = game.Players:FindFirstChild(value)
        if target then
            Rayfield:Notify({ Title = "Player Found", Content = "Target: " .. target.Name, Duration = 2 })
        else
            Rayfield:Notify({ Title = "Not Found", Content = "Player " .. value .. " not in server", Duration = 2 })
        end
    end
})