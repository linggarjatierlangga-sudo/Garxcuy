--==================================================
--              GARXCUY HUB - BETA
--==================================================

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ===== CLEAN GUI =====
pcall(function()
    player.PlayerGui:FindFirstChild("GarxcuyHub"):Destroy()
end)

-- ===== SETTINGS =====
local SaveFile = "GarxcuyHub_Settings.json"
local Settings = {
    AutoFish = false,
    InstantReel = false,
    AutoSell = false,
    AntiAFK = false,
    UIKey = Enum.KeyCode.RightControl
}

-- ===== SAVE / LOAD =====
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

-- ===== GUI =====
local Gui = Instance.new("ScreenGui", player.PlayerGui)
Gui.Name = "GarxcuyHub"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,420,0,260)
Main.Position = UDim2.new(0.5,-210,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🐺 Garxcuy Hub | Auto Fishing"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.new(1,1,1)

-- ===== TOGGLE FUNCTION =====
local function createToggle(text, y, setting)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85,0,0,40)
    btn.Position = UDim2.new(0.075,0,0,y)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

    local function refresh()
        btn.Text = text.." : "..(Settings[setting] and "ON" or "OFF")
    end
    refresh()

    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        refresh()
        Save()
    end)
end

-- ===== TOGGLES =====
createToggle("Auto Fish", 50, "AutoFish")
createToggle("Instant Reel", 100, "InstantReel")
createToggle("Auto Sell", 150, "AutoSell")
createToggle("Anti AFK", 200, "AntiAFK")

-- ===== KEYBIND =====
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Settings.UIKey then
        Main.Visible = not Main.Visible
    end
end)

--==================================================
--                 CORE LOGIC
--==================================================

-- ===== AUTO FISH =====
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoFish then
            local char = player.Character
            if not char then continue end

            local hum = char:FindFirstChildOfClass("Humanoid")
            local tool = char:FindFirstChildOfClass("Tool")
                or player.Backpack:FindFirstChildOfClass("Tool")

            -- Equip rod
            if tool and tool.Parent ~= char then
                hum:EquipTool(tool)
                task.wait(0.3)
            end

            -- Cast / Fish
            if tool then
                -- 🔧 kalau game pakai RemoteEvent, ganti di sini
                tool:Activate()
            end
        end
    end
end)

-- ===== INSTANT REEL =====
task.spawn(function()
    while task.wait(0.4) do
        if Settings.InstantReel then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

-- ===== AUTO SELL (UNIVERSAL TRY) =====
task.spawn(function()
    while task.wait(5) do
        if Settings.AutoSell then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then
                    v:FireServer()
                end
            end
        end
    end
end)

-- ===== ANTI AFK =====
player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

print("✅ Garxcuy Hub Loaded Successfully")
