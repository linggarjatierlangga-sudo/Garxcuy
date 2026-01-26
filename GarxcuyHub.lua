--==================================================
--        GARXCUY HUB - FISH IT (FINAL)
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- CLEAN GUI
pcall(function()
    player.PlayerGui:FindFirstChild("GarxcuyHub"):Destroy()
end)

-- SETTINGS
local Settings = {
    AutoFish = false,
    InstantReel = false,
    AutoSell = false,
    AntiAFK = false,
    UIKey = Enum.KeyCode.RightControl
}

-- GUI
local Gui = Instance.new("ScreenGui", player.PlayerGui)
Gui.Name = "GarxcuyHub"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,420,0,260)
Main.Position = UDim2.new(0.5,-210,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🐺 Garxcuy Hub | FISH IT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.new(1,1,1)

-- TOGGLE FUNCTION
local function Toggle(text, y, key)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.85,0,0,40)
    b.Position = UDim2.new(0.075,0,0,y)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

    local function refresh()
        b.Text = text.." : "..(Settings[key] and "ON" or "OFF")
    end
    refresh()

    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        refresh()
    end)
end

-- TOGGLES
Toggle("Auto Fish", 50, "AutoFish")
Toggle("Instant Reel", 100, "InstantReel")
Toggle("Auto Sell", 150, "AutoSell")
Toggle("Anti AFK", 200, "AntiAFK")

-- KEYBIND
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Settings.UIKey then
        Main.Visible = not Main.Visible
    end
end)

--==================================================
--               FISH IT LOGIC
--==================================================

-- GET REMOTES
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local CastRemote = Remotes:WaitForChild("Cast")
local ReelRemote = Remotes:WaitForChild("Reel")
local SellRemote = Remotes:WaitForChild("Sell")

-- AUTO CAST
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoFish then
            CastRemote:FireServer()
        end
    end
end)

-- INSTANT REEL
task.spawn(function()
    while task.wait(0.25) do
        if Settings.InstantReel then
            ReelRemote:FireServer(true)
        end
    end
end)

-- AUTO SELL
task.spawn(function()
    while task.wait(5) do
        if Settings.AutoSell then
            SellRemote:FireServer()
        end
    end
end)

-- ANTI AFK
player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

print("✅ Garxcuy Hub | FISH IT Loaded")
