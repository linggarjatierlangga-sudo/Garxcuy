-- Garxcuy Hub | Fish It
-- No Key | Delta Supported

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Anti duplicate
if player.PlayerGui:FindFirstChild("GarxcuyHub") then
    player.PlayerGui.GarxcuyHub:Destroy()
end

-- UI
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "GarxcuyHub"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,360,0,220)
Main.Position = UDim2.new(0.5,-180,0.5,-110)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "Garxcuy Hub | Fish It"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Button creator
local function Btn(text,y)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local AutoFishBtn = Btn("Auto Fish [OFF]", 60)
local AutoSellBtn = Btn("Auto Sell [OFF]", 110)
local CloseBtn = Btn("Close", 160)

-- STATES
local autofish = false
local autosell = false

-- AUTO FISH
task.spawn(function()
    while task.wait(1) do
        if autofish then
            for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("fish") then
                    pcall(function()
                        v:FireServer()
                    end)
                end
            end
        end
    end
end)

-- AUTO SELL
task.spawn(function()
    while task.wait(2) do
        if autosell then
            for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then
                    pcall(function()
                        v:FireServer()
                    end)
                end
            end
        end
    end
end)

AutoFishBtn.MouseButton1Click:Connect(function()
    autofish = not autofish
    AutoFishBtn.Text = autofish and "Auto Fish [ON]" or "Auto Fish [OFF]"
end)

AutoSellBtn.MouseButton1Click:Connect(function()
    autosell = not autosell
    AutoSellBtn.Text = autosell and "Auto Sell [ON]" or "Auto Sell [OFF]"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
