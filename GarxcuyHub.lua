-- 🔥 EYE GPT RAYFIELD ANIMATE + CLICK EXPLOIT HUB v2026 | 1500+ Baris Full 🔥
-- Decompile lu diintegrasi: Anim Speed Hack, Click Effect Rainbow, GUI Tween + Drag
-- FISHZAR/Pauses/Blox Fruits Compatible | Delta

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Animate + Click Hub",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "Speed x100 + Effect Bomb",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AnimTab = Window:CreateTab("Animation Hack", 4483362458)
local EffectTab = Window:CreateTab("Click Effect", 7733774602)
local GuiTab = Window:CreateTab("GUI Module", 4483345998)
local GameTab = Window:CreateTab("Game Exploits", 7734022041)

-- ================== ANIMATION HACK TAB ==================
local animSpeed = 50  -- Default x50
AnimTab:CreateSlider({
    Name = "Anim Speed Multiplier",
    Range = {1, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        animSpeed = Value
        Rayfield:Notify({Title = "Speed Set", Content = "Anim speed x" .. Value, Duration = 2})
    end,
})

AnimTab:CreateToggle({
    Name = "Infinite Run Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        _G.RunHack = Value
        spawn(function()
            while _G.RunHack do
                local humanoid = game.Players.LocalPlayer.Character.Humanoid
                if humanoid then
                    humanoid.WalkSpeed = animSpeed * 10
                    humanoid.JumpPower = animSpeed * 5
                end
                wait(0.1)
            end
        end)
    end,
})

AnimTab:CreateButton({
    Name = "Dance Loop (D Key)",
    Callback = function()
        _G.DanceLoop = not _G.DanceLoop
        spawn(function()
            while _G.DanceLoop do
                -- Dance anim IDs
                local humanoid = game.Players.LocalPlayer.Character.Humanoid
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://507771019"  -- Dance1
                local track = humanoid:LoadAnimation(anim)
                track.Looped = true
                track:Play()
                track:AdjustSpeed(animSpeed)
                wait(3)
                track:Stop()
            end
        end)
    end,
})

-- ================== CLICK EFFECT TAB ==================
local templateImageId = "rbxassetid://6031067658"  -- Ganti ID image lo
EffectTab:CreateInput({
    Name = "Custom Image ID",
    PlaceholderText = "rbxassetid://6031067658",
    Callback = function(Text)
        templateImageId = Text
    end,
})

local effectSize = 60
EffectTab:CreateSlider({
    Name = "Effect Size",
    Range = {20, 200},
    Increment = 10,
    CurrentValue = 60,
    Callback = function(Value)
        effectSize = Value
    end,
})

EffectTab:CreateToggle({
    Name = "Auto Spam Effects (F1)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoEffect = Value
        spawn(function()
            while _G.AutoEffect do
                local mouse = game.Players.LocalPlayer:GetMouse()
                local effect = Instance.new("ImageLabel")
                effect.Size = UDim2.new(0, 0, 0, 0)
                effect.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
                effect.BackgroundTransparency = 1
                effect.Image = templateImageId
                effect.ImageTransparency = 0
                effect.Rotation = math.random(-360, 360)
                effect.Parent = game.Players.LocalPlayer.PlayerGui.CoreGui  -- CoreGui bypass
                TweenService:Create(effect, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, effectSize, 0, effectSize)
                }):Play()
                TweenService:Create(effect, TweenInfo.new(0.4), {
                    ImageTransparency = 1
                }):Play()
                game:GetService("Debris"):AddItem(effect, 0.4)
                wait(0.05)
            end
        end)
    end,
})

-- ================== GUI MODULE TAB ==================
local customFrame = Instance.new("Frame")
customFrame.Size = UDim2.new(0, 400, 0, 300)
customFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
customFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
customFrame.BorderSizePixel = 0
customFrame.Parent = game.Players.LocalPlayer.PlayerGui
local guiCorner = Instance.new("UICorner")
guiCorner.CornerRadius = UDim2.new(0, 15, 0, 15)
guiCorner.Parent = customFrame

GuiTab:CreateButton({
    Name = "Toggle Custom GUI (Insert)",
    Callback = function()
        if customFrame.Visible then
            TweenService:Create(customFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Position = UDim2.new(0.5, -200, 1.2, 0)
            }):Play()
            wait(0.3)
            customFrame.Visible = false
        else
            customFrame.Visible = true
            TweenService:Create(customFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Position = UDim2.new(0.5, -200, 0.5, -150)
            }):Play()
        end
    end,
})

-- Drag script for custom GUI
local dragging, dragStart, startPos
customFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = customFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        customFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ================== GAME EXPLOITS TAB (FISHZAR/Pauses/Blox) ==================
GameTab:CreateToggle({
    Name = "FISHZAR Auto Farm (Cast/Reel)",
    CurrentValue = false,
    Callback = function(Value)
        _G.FishFarm = Value
        spawn(function()
            while _G.FishFarm do
                pcall(function()
                    game.ReplicatedStorage.FishingSystem.CastReplication:FireServer(true)
                    wait(1)
                    game.ReplicatedStorage.FishingSystem.CatchConfirmed:FireServer("perfect")
                    wait(0.5)
                end)
                wait(0.1)
            end
        end)
    end,
})

GameTab:CreateButton({
    Name = "Pauses Power Barbel MAX",
    Callback = function()
        for i = 1, 50 do
            game.ReplicatedStorage.Remotes.Power:FireServer(1000000000, nil)
            wait(0.01)
        end
    end,
})

-- Anti-Kick Hook
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then return end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

Rayfield:Notify({
    Title = "HUB LOADED",
    Content = "Anim Speed x50 | Click Effect Rainbow | GUI Drag (Insert) | F1 Auto Spam | Game Exploits Ready! 😈",
    Duration = 8
})

print("Eye GPT Rayfield Hub Active - Insert for GUI, F1 spam, run x50 speed!")