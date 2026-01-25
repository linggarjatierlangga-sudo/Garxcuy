-- Garxcuy Hub | Full Lynx UI Demo Cheat
-- Aman 100% | Delta Friendly | Save Settings

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== CLEAN OLD GUI =====
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
Title.Text = "🐺 Garxcuy Hub | Lynx Demo"
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
    if g then return end
    if i.KeyCode == Settings.UIKey then
        UIState = not UIState
        Main.Visible = UIState
    elseif i.KeyCode == Enum.KeyCode.Insert then
        UIState = not UIState
        Main.Visible = UIState
        LogoBtn.Visible = UIState
    end
end)

-- ===== TABS & PAGES =====
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0,120,1,-45)
Side.Position = UDim2.new(0,0,0,45)
Side.BackgroundColor3 = Color3.fromRGB(18,18,18)
Side.BorderSizePixel = 0

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1,-120,1,-45)
Pages.Position = UDim2.new(0,120,0,45)
Pages.BackgroundTransparency = 1

local function createPage() 
    local f = Instance.new("Frame", Pages)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1
    f.Visible = false
    return f
end

local MainP = createPage()
local FishP = createPage()
local MiscP = createPage()
MainP.Visible = true

local function switch(page)
    MainP.Visible = false
    FishP.Visible = false
    MiscP.Visible = false
    page.Visible = true
end

local function tab(text, y, pg)
    local b = Instance.new("TextButton", Side)
    b.Size = UDim2.new(1,-10,0,40)
    b.Position = UDim2.new(0,5,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    b.MouseButton1Click:Connect(function() switch(pg) end)
end

tab("Main", 10, MainP)
tab("Fishing", 55, FishP)
tab("Misc", 100, MiscP)

-- ===== TOGGLE FUNCTION =====
local function createToggle(parent, text, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85,0,0,40)
    btn.Position = UDim2.new(0.075,0,0,y)
    btn.Text = text.." : OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = text..(on and " : ON" or " : OFF")
        -- SIMULASI DEMO
        print(text.." = "..tostring(on))
    end)
end

-- ===== ADD DEMO TOGGLES =====
createToggle(MainP, "Walkspeed / Jump", 20)
createToggle(MainP, "Anti AFK", 70)
createToggle(MainP, "FPS Boost", 120)

createToggle(FishP, "Auto Fish", 20)
createToggle(FishP, "Instant Reel", 70)
createToggle(FishP, "Auto Sell", 120)
createToggle(FishP, "ESP Fish / Rare", 170)
createToggle(FishP, "ESP Player", 220)

-- ===== DEMO HEARTBEAT LOGIC (AMAN) =====
RunService.Heartbeat:Connect(function()
    if Settings.AutoFish then
        print("Auto Fish ACTIVE!")
    end
    if Settings.InstantReel then
        print("Instant Reel ACTIVE!")
    end
    if Settings.AutoSell then
        print("Auto Sell ACTIVE!")
    end
end)

-- ===== DEMO ESP LOGIC =====
RunService.RenderStepped:Connect(function()
    if Settings.ESPFish then
        print("ESP Fish ACTIVE!")
    end
    if Settings.ESPPlayer then
        print("ESP Player ACTIVE!")
    end
end)
