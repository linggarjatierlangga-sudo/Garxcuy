-- Script by ShadowX - GarxCuy Hub (Orion Library) with Movement improvements
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
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
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESP_Highlights"
highlightFolder.Parent = game.CoreGui

-- Variabel fitur
local espEnabled = false
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50  -- default kecepatan terbang
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

-- Section Player Settings
local PlayerSection = PlayerTab:AddSection({
    Name = "Player Settings"
})

-- Slider JumpPower (tetap di Player)
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

-- Reset button (opsional, bisa tetap di sini)
PlayerTab:AddButton({
    Name = "Reset to Defaults",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
        OrionLib:MakeNotification({
            Name = "Reset",
            Content = "Speed dan Jump kembali normal",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- ===== TAB MOVEMENT =====
local MoveTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Section Movement
local MoveSection = MoveTab:AddSection({
    Name = "Movement Features"
})

-- NoClip Toggle
MoveTab:AddToggle({
    Name = "NoClip (Tembus Tembok)",
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
MoveTab:AddToggle({
    Name = "Fly Mode",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        if state then
            humanoid.PlatformStand = true
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            flyBodyVelocity.Parent = rootPart
            
            flyConn = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
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
            humanoid.PlatformStand = false
        end
    end
})

-- Slider WalkSpeed (pindah dari Player ke Movement)
MoveTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

-- Slider Fly Speed (baru)
MoveTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(value)
        flySpeed = value
    end
})

-- ===== TAB ESP =====
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Fungsi ESP (sama seperti sebelumnya)
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

-- Chat Spoofer (simulasi)
OtherTab:AddButton({
    Name = "Chat Spoofers",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Chat Spoofers",
            Content = "Fitur ini hanya simulasi, butuh executor level tinggi",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Typed Text (simulasi)
OtherTab:AddButton({
    Name = "Typed Text",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Typed Text",
            Content = "Fitur ini hanya simulasi",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Notifikasi startup
OrionLib:MakeNotification({
    Name = "GarxCuy Hub Loaded",
    Content = "All features ready!",
    Image = "rbxassetid://4483345998",
    Time = 3
})

-- Init library
OrionLib:Init()
