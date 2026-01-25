-- Garxcuy Hub | Full Lynx Style UI
-- UI First (Safe) | Delta Friendly

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

pcall(function()
    player.PlayerGui:FindFirstChild("GarxcuyHub"):Destroy()
end)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "GarxcuyHub"
ScreenGui.ResetOnSpawn = false

-- ===== LOADER =====
local Loader = Instance.new("Frame", ScreenGui)
Loader.Size = UDim2.new(0, 320, 0, 200)
Loader.Position = UDim2.new(0.5, -160, 0.5, -100)
Loader.BackgroundColor3 = Color3.fromRGB(15,15,15)
Loader.BorderSizePixel = 0
Loader.AnchorPoint = Vector2.new(0.5,0.5)

Instance.new("UICorner", Loader).CornerRadius = UDim.new(0,18)

local Logo = Instance.new("ImageLabel", Loader)
Logo.Size = UDim2.new(0,90,0,90)
Logo.Position = UDim2.new(0.5,-45,0,25)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6031068421" -- public asset (aman)

local LoadText = Instance.new("TextLabel", Loader)
LoadText.Size = UDim2.new(1,0,0,40)
LoadText.Position = UDim2.new(0,0,1,-50)
LoadText.BackgroundTransparency = 1
LoadText.Text = "Garxcuy Hub Loading..."
LoadText.Font = Enum.Font.GothamBold
LoadText.TextSize = 14
LoadText.TextColor3 = Color3.fromRGB(255,255,255)

TweenService:Create(Loader, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
task.wait(1.6)
Loader:Destroy()

-- ===== MAIN UI =====
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 280)
Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "🐺 Garxcuy Hub | Fish It"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)

-- Tabs
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0,110,1,-45)
TabBar.Position = UDim2.new(0,0,0,45)
TabBar.BackgroundColor3 = Color3.fromRGB(18,18,18)
TabBar.BorderSizePixel = 0

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-110,1,-45)
Content.Position = UDim2.new(0,110,0,45)
Content.BackgroundTransparency = 1

-- Helper
local function createTab(name, order)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Position = UDim2.new(0,0,0,(order-1)*45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    return btn
end

local function createPage()
    local page = Instance.new("Frame", Content)
    page.Size = UDim2.new(1,0,1,0)
    page.Visible = false
    page.BackgroundTransparency = 1
    return page
end

-- Tabs
local MainTab = createTab("Main",1)
local FishTab = createTab("Fishing",2)
local MiscTab = createTab("Misc",3)

-- Pages
local MainPage = createPage()
local FishPage = createPage()
local MiscPage = createPage()
MainPage.Visible = true

local function switch(page)
    MainPage.Visible = false
    FishPage.Visible = false
    MiscPage.Visible = false
    page.Visible = true
end

MainTab.MouseButton1Click:Connect(function() switch(MainPage) end)
FishTab.MouseButton1Click:Connect(function() switch(FishPage) end)
MiscTab.MouseButton1Click:Connect(function() switch(MiscPage) end)

-- Toggle template
local function createToggle(parent, text, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85,0,0,40)
    btn.Position = UDim2.new(0.075,0,0,y)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON" or " : OFF")
    end)
end

-- MAIN PAGE
createToggle(MainPage, "UI Toggle", 20)
createToggle(MainPage, "ESP (UI)", 70)

-- FISH PAGE (LYNX STYLE FEATURE LIST)
createToggle(FishPage, "Auto Fish", 20)
createToggle(FishPage, "Instant Reel", 70)
createToggle(FishPage, "Auto Sell", 120)

-- MISC
createToggle(MiscPage, "Anti AFK", 20)
createToggle(MiscPage, "FPS Boost", 70)
