-- Gar xcuy Hub
-- No Key System

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("GarxcuyHub") then
    player.PlayerGui.GarxcuyHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GarxcuyHub"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 200)
Main.Position = UDim2.new(0.5, -160, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Gar xcuy Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main

local Btn1 = Instance.new("TextButton")
Btn1.Size = UDim2.new(0.85, 0, 0, 40)
Btn1.Position = UDim2.new(0.075, 0, 0.35, 0)
Btn1.Text = "Test Button"
Btn1.Font = Enum.Font.Gotham
Btn1.TextSize = 14
Btn1.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn1.Parent = Main

Btn1.MouseButton1Click:Connect(function()
    print("Gar xcuy Hub aktif 🔥")
end)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Parent = Main

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
