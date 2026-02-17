--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
    Name = "GarxCuy Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GarxCuyConfig",
    IntroEnabled = true,
    IntroText = "GarxCuy Hub",
    IntroIcon = "rbxassetid://4483345998"
})

-- Variabel global
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESP_Highlights"
highlightFolder.Parent = game.CoreGui

-- Variabel fitur
local espEnabled = false
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyBodyVelocity = nil
local noclipConn = nil
local flyConn = nil
local espConnections = {}

-- ===== TAB PLAYER =====
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Slider WalkSpeed
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(value)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = value
            end
        end
    end
})

-- NoClip Toggle
PlayerTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                if not noclipEnabled then return end
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then
                noclipConn:Disconnect()
                noclipConn = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Fly Toggle
PlayerTab:AddToggle({
    Name = "Fly Mode",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        if state then
            hum.PlatformStand = true
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            flyBodyVelocity.Parent = rootPart
            
            flyConn = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + Workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - Workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - Workspace.CurrentCamera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + Workspace.CurrentCamera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                if flyBodyVelocity then
                    flyBodyVelocity.Velocity = moveDir * flySpeed
                end
            end)
        else
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            hum.PlatformStand = false
        end
    end
})

-- Infinity Jump
local infinityJumpEnabled = false
local infinityJumpPower = 100
local infinityJumpConnection = nil

PlayerTab:AddToggle({
    Name = "Infinity Jump",
    Default = false,
    Callback = function(state)
        infinityJumpEnabled = state
        if state then
            infinityJumpConnection = UserInputService.JumpRequest:Connect(function()
                if not infinityJumpEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, infinityJumpPower, 0)
                bv.MaxForce = Vector3.new(0, math.huge, 0)
                bv.Parent = rootPart
                game:GetService("Debris"):AddItem(bv, 0.5)
            end)
        else
            if infinityJumpConnection then
                infinityJumpConnection:Disconnect()
                infinityJumpConnection = nil
            end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Infinity Jump Power",
    Min = 50,
    Max = 500,
    Default = 100,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "force",
    Callback = function(value)
        infinityJumpPower = value
    end
})

-- Reset button (WalkSpeed only)
PlayerTab:AddButton({
    Name = "Reset WalkSpeed",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
        OrionLib:MakeNotification({
            Name = "Reset",
            Content = "WalkSpeed kembali normal",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- ===== TAB ESP =====
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Fungsi ESP
local function createHighlight(player)
    if not player.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    if player.Team then
        highlight.FillColor = player.Team.TeamColor.Color
    else
        highlight.FillColor = Color3.new(1, 0, 0)
    end
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = highlightFolder
    highlight.Adornee = player.Character
    return highlight
end

-- Toggle ESP
ESPTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            for _, v in ipairs(highlightFolder:GetChildren()) do
                v:Destroy()
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createHighlight(player)
                end
            end
            espConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    if espEnabled and player ~= LocalPlayer then
                        createHighlight(player)
                    end
                end)
            end)
            espConnections.CharacterAdded = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    espConnections.CharacterAdded[player] = player.CharacterAdded:Connect(function()
                        if espEnabled then
                            createHighlight(player)
                        end
                    end)
                end
            end
            espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
                local highlight = highlightFolder:FindFirstChild(player.Name .. "_ESP")
                if highlight then highlight:Destroy() end
            end)
            espConnections.Heartbeat = RunService.Heartbeat:Connect(function()
                if not espEnabled then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local highlight = highlightFolder:FindFirstChild(player.Name .. "_ESP")
                        if highlight and player.Team then
                            highlight.FillColor = player.Team.TeamColor.Color
                        end
                    end
                end
            end)
        else
            for _, v in ipairs(highlightFolder:GetChildren()) do
                v:Destroy()
            end
            for _, conn in pairs(espConnections) do
                if conn then conn:Disconnect() end
            end
            espConnections = {}
        end
    end
})

-- ===== TAB OTHER =====
local OtherTab = Window:MakeTab({
    Name = "Other",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

OtherTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

OtherTab:AddButton({
    Name = "Chat Spoofers (Simulasi)",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Chat Spoofers",
            Content = "Fitur ini hanya simulasi",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- ===== TAB FREECAM =====
local FreecamTab = Window:MakeTab({
    Name = "FREECAM",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local freecamEnabled = false
local freecamSpeed = 50
local freecamPart = nil
local freecamConnection = nil
local freecamKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}
local originalCF = nil
local originalSubject = nil

-- Input handlers untuk freecam
local function onInputBegan(input, gp)
    if gp then return end
    if not freecamEnabled then return end
    if input.KeyCode == Enum.KeyCode.W then freecamKeys.W = true end
    if input.KeyCode == Enum.KeyCode.A then freecamKeys.A = true end
    if input.KeyCode == Enum.KeyCode.S then freecamKeys.S = true end
    if input.KeyCode == Enum.KeyCode.D then freecamKeys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then freecamKeys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then freecamKeys.Shift = true end
end

local function onInputEnded(input)
    if not freecamEnabled then return end
    if input.KeyCode == Enum.KeyCode.W then freecamKeys.W = false end
    if input.KeyCode == Enum.KeyCode.A then freecamKeys.A = false end
    if input.KeyCode == Enum.KeyCode.S then freecamKeys.S = false end
    if input.KeyCode == Enum.KeyCode.D then freecamKeys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then freecamKeys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then freecamKeys.Shift = false end
end

FreecamTab:AddToggle({
    Name = "Enable Freecam",
    Default = false,
    Callback = function(state)
        freecamEnabled = state
        if state then
            -- Simpan posisi kamera asli
            originalCF = Camera.CFrame
            originalSubject = Camera.CameraSubject
            
            -- Buat part virtual untuk kamera
            freecamPart = Instance.new("Part")
            freecamPart.Name = "FreecamPart"
            freecamPart.Size = Vector3.new(1,1,1)
            freecamPart.Transparency = 1
            freecamPart.Anchored = true
            freecamPart.CFrame = originalCF
            freecamPart.Parent = Workspace
            
            -- Set kamera ke part
            Camera.CameraSubject = freecamPart
            Camera.CameraType = Enum.CameraType.Custom
            
            -- Koneksi input
            UserInputService.InputBegan:Connect(onInputBegan)
            UserInputService.InputEnded:Connect(onInputEnded)
            
            -- Loop gerak kamera
            freecamConnection = RunService.RenderStepped:Connect(function(dt)
                if not freecamEnabled or not freecamPart then return end
                local move = Vector3.new()
                if freecamKeys.W then move = move + Camera.CFrame.LookVector end
                if freecamKeys.S then move = move - Camera.CFrame.LookVector end
                if freecamKeys.A then move = move - Camera.CFrame.RightVector end
                if freecamKeys.D then move = move + Camera.CFrame.RightVector end
                if freecamKeys.Space then move = move + Vector3.new(0,1,0) end
                if freecamKeys.Shift then move = move - Vector3.new(0,1,0) end
                
                if move.Magnitude > 0 then
                    freecamPart.CFrame = freecamPart.CFrame + move.Unit * freecamSpeed * dt * 60
                end
            end)
        else
            -- Kembalikan kamera normal
            if freecamPart then
                freecamPart:Destroy()
                freecamPart = nil
            end
            if freecamConnection then
                freecamConnection:Disconnect()
                freecamConnection = nil
            end
            if originalCF then
                Camera.CFrame = originalCF
            end
            if originalSubject then
                Camera.CameraSubject = originalSubject
            else
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or nil
            end
            Camera.CameraType = Enum.CameraType.Custom
            
            -- Reset keys
            freecamKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}
        end
    end
})

FreecamTab:AddSlider({
    Name = "Freecam Speed",
    Min = 10,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(value)
        freecamSpeed = value
    end
})

-- ===== FPS COUNTER =====
local fpsEnabled = false
local fpsGui = nil

OtherTab:AddToggle({
    Name = "Show FPS",
    Default = false,
    Callback = function(state)
        fpsEnabled = state
        if state then
            fpsGui = Instance.new("ScreenGui")
            fpsGui.Name = "FPSDisplay"
            fpsGui.Parent = game:GetService("CoreGui")
            
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 100, 0, 40)
            bg.Position = UDim2.new(0, 10, 0, 10)
            bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            bg.BackgroundTransparency = 0.5
            bg.BorderSizePixel = 0
            bg.Parent = fpsGui
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextSize = 20
            text.Font = Enum.Font.GothamBold
            text.Parent = bg
            
            local lastTime = tick()
            local frames = 0
            local connection = RunService.RenderStepped:Connect(function()
                frames = frames + 1
                if tick() - lastTime >= 1 then
                    text.Text = "FPS: " .. frames
                    frames = 0
                    lastTime = tick()
                end
            end)
            
            fpsGui.Connection = connection
        else
            if fpsGui then
                if fpsGui.Connection then
                    fpsGui.Connection:Disconnect()
                end
                fpsGui:Destroy()
                fpsGui = nil
            end
        end
    end
})

-- Notifikasi startup
OrionLib:MakeNotification({
    Name = "GarxCuy Hub Loaded",
    Content = "All features ready!",
    Image = "rbxassetid://4483345998",
    Time = 3
})

-- ===== TOGGLE UI BUTTON (DRAGGABLE) =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Toggleui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Toggle.BackgroundTransparency = 0.5
Toggle.Position = UDim2.new(0, 0, 0.454706937, 0)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.2, 0)
Corner.Parent = Toggle

local Image = Instance.new("ImageLabel")
Image.Name = "Icon"
Image.Parent = Toggle
Image.Size = UDim2.new(1, 0, 1, 0)
Image.BackgroundTransparency = 1
Image.Image = "rbxassetid://117239677500065"

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0.2, 0)
Corner2.Parent = Image

Toggle.MouseButton1Click:Connect(function()
    OrionLib:ToggleUi()
end)

-- Init library
OrionLib:Init()