-- Garxcuy Hub Lite | Anti AFK Edition
-- Safe Helper UI (No ESP, No AutoReel Cheat)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CLEAN OLD GUI
pcall(function()
    player.PlayerGui:FindFirstChild("GarxcuyHubLite"):Destroy()
end)

-- SETTINGS
local SaveFile = "GarxcuyHubLite_Settings.json"
local Settings = {
    AntiAFK = false,
    SpeedHack = false,
    FPSBoost = false,
    WalkSpeed = 16,
    JumpPower = 50,
    UIKey = Enum.KeyCode.RightControl
}

-- SAVE / LOAD
local function Save()
    if writefile then
        writefile(SaveFile, HttpService:JSONEncode(Settings))
    end
end

local function Load()
    if readfile and isfile and isfile(SaveFile) then
        local data = HttpService:JSONDecode(readfile(SaveFile))
        for i,v in pairs(data) do
            Settings[i] = v
        end
    end
end
Load()

-- GUI
local Gui = Instance.new("ScreenGui", player.PlayerGui)
Gui.Name = "GarxcuyHubLite"
Gui.ResetOnSpawn = false

-- MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,400,0,260)
Main.Position = UDim2.new(0.5,-200,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🐺 Garxcuy Hub Lite | Anti AFK"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)

-- LOGO TOGGLE
local LogoBtn = Instance.new("ImageButton", Gui)
LogoBtn.Size = UDim2.new(0,55,0,55)
LogoBtn.Position = UDim2.new(0,20,0.5,-27)
LogoBtn.Image = "rbxassetid://6031068421"
LogoBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
LogoBtn.Active = true
LogoBtn.Draggable = true
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1,0)

local UIState = true
LogoBtn.MouseButton1Click:Connect(function()
    UIState = not UIState
    Main.Visible = UIState
end)

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Settings.UIKey then
        UIState = not UIState
        Main.Visible = UIState
    end
end)

-- TOGGLE CREATOR
local function createToggle(parent, text, settingName, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85,0,0,40)
    btn.Position = UDim2.new(0.075,0,0,y)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

    local function refresh()
        btn.Text = text .. (Settings[settingName] and " : ON" or " : OFF")
    end

    refresh()

    btn.MouseButton1Click:Connect(function()
        Settings[settingName] = not Settings[settingName]
        refresh()
        Save()
    end)
end

-- ADD TOGGLES
createToggle(Main, "Anti AFK", "AntiAFK", 50)
createToggle(Main, "WalkSpeed / Jump", "SpeedHack", 100)
createToggle(Main, "FPS Boost", "FPSBoost", 150)

-- ANTI AFK LOGIC
player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), camera.CFrame)
        print("Anti-AFK triggered")
    end
end)

-- EXTRA PULSE (every 4 minutes)
task.spawn(function()
    while task.wait(240) do
        if Settings.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
            print("Anti-AFK pulse")
        end
    end
end)

-- SPEED / JUMP LOGIC
RunService.Heartbeat:Connect(function()
    if Settings.SpeedHack then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Settings.WalkSpeed
            char.Humanoid.JumpPower = Settings.JumpPower
        end
    end
end)

-- FPS BOOST
RunService.RenderStepped:Connect(function()
    if Settings.FPSBoost then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)
