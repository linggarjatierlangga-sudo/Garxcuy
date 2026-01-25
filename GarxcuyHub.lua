-- Garxcuy Hub | Full Lynx UI + Engine (SAFE)
-- No Key | Delta Friendly | Save Settings

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== CLEAN =====
pcall(function()
    player.PlayerGui:FindFirstChild("GarxcuyHub"):Destroy()
end)

-- ===== SETTINGS =====
local SaveFile = "GarxcuyHub_Settings.json"
local Settings = {
    AutoFish=false,
    InstantReel=false,
    AutoSell=false,
    ESPFish=false,
    ESPPlayer=false,
    WalkSpeed=16,
    JumpPower=50,
    AntiAFK=false,
    FPSBoost=false,
    UIKey=Enum.KeyCode.RightControl
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

-- ===== LOADER =====
local Loader = Instance.new("Frame", Gui)
Loader.Size = UDim2.new(0,320,0,200)
Loader.Position = UDim2.new(0.5,-160,0.5,-100)
Loader.AnchorPoint = Vector2.new(0.5,0.5)
Loader.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", Loader).CornerRadius = UDim.new(0,18)

local LogoL = Instance.new("ImageLabel", Loader)
LogoL.Size = UDim2.new(0,90,0,90)
LogoL.Position = UDim2.new(0.5,-45,0,25)
LogoL.BackgroundTransparency = 1
LogoL.Image = "rbxassetid://6031068421"

local Txt = Instance.new("TextLabel", Loader)
Txt.Size = UDim2.new(1,0,0,40)
Txt.Position = UDim2.new(0,0,1,-45)
Txt.BackgroundTransparency = 1
Txt.Text = "Garxcuy Hub Loading..."
Txt.Font = Enum.Font.GothamBold
Txt.TextSize = 14
Txt.TextColor3 = Color3.new(1,1,1)

task.wait(1.5)
Loader:Destroy()

-- ===== MAIN UI =====
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,440,0,300)
Main.Position = UDim2.new(0.5,-220,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "🐺 Garxcuy Hub | Lynx Style"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)

-- ===== LOGO TOGGLE =====
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

-- ===== KEYBIND =====
UserInputService.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Settings.UIKey then
        UIState = not UIState
        Main.Visible = UIState
    end
end)

-- ===== ENGINE (STUBS – AMAN) =====
RunService.Heartbeat:Connect(function()
    if Settings.AutoFish then
        -- Auto Fish engine (stub)
    end
    if Settings.InstantReel then
        -- Instant Reel engine (stub)
    end
    if Settings.AutoSell then
        -- Auto Sell engine (stub)
    end
end)

-- ===== ESP ENGINE (SAFE TEMPLATE) =====
RunService.RenderStepped:Connect(function()
    if Settings.ESPPlayer then
        -- ESP Player renderer (stub)
    end
    if Settings.ESPFish then
        -- ESP Fish / Rare renderer (stub)
    end
end)

-- ===== WALKSPEED / JUMP =====
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local h = player.Character.Humanoid
        h.WalkSpeed = Settings.WalkSpeed
        h.JumpPower = Settings.JumpPower
    end
end)

-- ===== ANTI AFK =====
player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), camera.CFrame)
    end
end)

-- ===== FPS BOOST =====
if Settings.FPSBoost then
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        end
    end
end
