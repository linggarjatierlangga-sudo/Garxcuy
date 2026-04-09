-- ========== FLUENT UI LIBRARY ==========
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== FLUENT WINDOW ==========
local Window = Fluent:CreateWindow({
    Title = "GAR N CUY BOCAH EPEP",
    SubTitle = "ESP + Auto Kill + Teleport",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ========== TABS ==========
local Tabs = {
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" })
}

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== ESP VARIABLES ==========
local Drawings = {
    ESP = {},
    Tracers = {},
    Boxes = {},
    Healthbars = {},
    Names = {},
    Distances = {},
    Snaplines = {},
    Skeleton = {}
}

local Colors = {
    Enemy = Color3.fromRGB(255, 25, 25),
    Ally = Color3.fromRGB(25, 255, 25),
    Neutral = Color3.fromRGB(255, 255, 255),
    Selected = Color3.fromRGB(255, 210, 0),
    Health = Color3.fromRGB(0, 255, 0),
    Distance = Color3.fromRGB(200, 200, 200),
    Rainbow = nil
}

local Highlights = {}

local Settings = {
    Enabled = false,
    TeamCheck = false,
    ShowTeam = false,
    VisibilityCheck = true,
    BoxESP = false,
    BoxStyle = "Corner",
    BoxOutline = true,
    BoxFilled = false,
    BoxFillTransparency = 0.5,
    BoxThickness = 1,
    TracerESP = false,
    TracerOrigin = "Bottom",
    TracerStyle = "Line",
    TracerThickness = 1,
    HealthESP = false,
    HealthStyle = "Bar",
    HealthBarSide = "Left",
    HealthTextSuffix = "HP",
    NameESP = false,
    NameMode = "DisplayName",
    ShowDistance = true,
    DistanceUnit = "studs",
    TextSize = 14,
    TextFont = 2,
    RainbowSpeed = 1,
    MaxDistance = 1000,
    RefreshRate = 1/144,
    Snaplines = false,
    SnaplineStyle = "Straight",
    RainbowEnabled = false,
    RainbowBoxes = false,
    RainbowTracers = false,
    RainbowText = false,
    ChamsEnabled = false,
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ChamsFillColor = Color3.fromRGB(255, 0, 0),
    ChamsOccludedColor = Color3.fromRGB(150, 0, 0),
    ChamsTransparency = 0.5,
    ChamsOutlineTransparency = 0,
    ChamsOutlineThickness = 0.1,
    SkeletonESP = false,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    SkeletonThickness = 1.5,
    SkeletonTransparency = 1
}

-- ========== ESP FUNCTIONS ==========
local function CreateESP(player)
    if player == LocalPlayer then return end

    local box = {
        TopLeft = Drawing.new("Line"),
        TopRight = Drawing.new("Line"),
        BottomLeft = Drawing.new("Line"),
        BottomRight = Drawing.new("Line"),
        Left = Drawing.new("Line"),
        Right = Drawing.new("Line"),
        Top = Drawing.new("Line"),
        Bottom = Drawing.new("Line")
    }

    for _, line in pairs(box) do
        line.Visible = false
        line.Color = Colors.Enemy
        line.Thickness = Settings.BoxThickness
    end

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Colors.Enemy
    tracer.Thickness = Settings.TracerThickness

    local healthBar = {
        Outline = Drawing.new("Square"),
        Fill = Drawing.new("Square"),
        Text = Drawing.new("Text")
    }

    for _, obj in pairs(healthBar) do
        obj.Visible = false
        if obj == healthBar.Fill then
            obj.Color = Colors.Health
            obj.Filled = true
        elseif obj == healthBar.Text then
            obj.Center = true
            obj.Size = Settings.TextSize
            obj.Color = Colors.Health
            obj.Font = Settings.TextFont
        end
    end

    local info = {
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }

    for _, text in pairs(info) do
        text.Visible = false
        text.Center = true
        text.Size = Settings.TextSize
        text.Color = Colors.Enemy
        text.Font = Settings.TextFont
        text.Outline = true
    end

    local snapline = Drawing.new("Line")
    snapline.Visible = false
    snapline.Color = Colors.Enemy
    snapline.Thickness = 1

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Settings.ChamsFillColor
    highlight.OutlineColor = Settings.ChamsOutlineColor
    highlight.FillTransparency = Settings.ChamsTransparency
    highlight.OutlineTransparency = Settings.ChamsOutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = Settings.ChamsEnabled

    Highlights[player] = highlight

    Drawings.ESP[player] = {
        Box = box,
        Tracer = tracer,
        HealthBar = healthBar,
        Info = info,
        Snapline = snapline
    }
end

local function RemoveESP(player)
    local esp = Drawings.ESP[player]
    if esp then
        for _, obj in pairs(esp.Box) do obj:Remove() end
        esp.Tracer:Remove()
        for _, obj in pairs(esp.HealthBar) do obj:Remove() end
        for _, obj in pairs(esp.Info) do obj:Remove() end
        esp.Snapline:Remove()
        Drawings.ESP[player] = nil
    end

    local highlight = Highlights[player]
    if highlight then
        highlight:Destroy()
        Highlights[player] = nil
    end
end

local function GetPlayerColor(player)
    if Settings.RainbowEnabled then
        if Settings.RainbowBoxes and Settings.BoxESP then return Colors.Rainbow end
        if Settings.RainbowTracers and Settings.TracerESP then return Colors.Rainbow end
        if Settings.RainbowText and (Settings.NameESP or Settings.HealthESP) then return Colors.Rainbow end
    end
    return player.Team == LocalPlayer.Team and Colors.Ally or Colors.Enemy
end

local function GetTracerOrigin()
    local origin = Settings.TracerOrigin
    if origin == "Bottom" then
        return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
    elseif origin == "Top" then
        return Vector2.new(Camera.ViewportSize.X/2, 0)
    elseif origin == "Mouse" then
        return UserInputService:GetMouseLocation()
    else
        return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
end

local function UpdateESP(player)
    if not Settings.Enabled then return end

    local esp = Drawings.ESP[player]
    if not esp then return end

    local character = player.Character
    if not character then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    local _, isOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
    if not isOnScreen then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

    if not onScreen or distance > Settings.MaxDistance then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    if Settings.TeamCheck and player.Team == LocalPlayer.Team and not Settings.ShowTeam then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    local color = GetPlayerColor(player)
    local size = character:GetExtentsSize()
    local cf = rootPart.CFrame

    local top, top_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, size.Y/2, 0).Position)
    local bottom, bottom_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, -size.Y/2, 0).Position)

    if not top_onscreen or not bottom_onscreen then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        return
    end

    local screenSize = bottom.Y - top.Y
    local boxWidth = screenSize * 0.65
    local boxPosition = Vector2.new(top.X - boxWidth/2, top.Y)
    local boxSize = Vector2.new(boxWidth, screenSize)

    for _, obj in pairs(esp.Box) do
        obj.Visible = false
    end

    if Settings.BoxESP then
        if Settings.BoxStyle == "Corner" then
            local cornerSize = boxWidth * 0.2

            esp.Box.TopLeft.From = boxPosition
            esp.Box.TopLeft.To = boxPosition + Vector2.new(cornerSize, 0)
            esp.Box.TopLeft.Visible = true

            esp.Box.TopRight.From = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.TopRight.To = boxPosition + Vector2.new(boxSize.X - cornerSize, 0)
            esp.Box.TopRight.Visible = true

            esp.Box.BottomLeft.From = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.BottomLeft.To = boxPosition + Vector2.new(cornerSize, boxSize.Y)
            esp.Box.BottomLeft.Visible = true

            esp.Box.BottomRight.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.BottomRight.To = boxPosition + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
            esp.Box.BottomRight.Visible = true

            esp.Box.Left.From = boxPosition
            esp.Box.Left.To = boxPosition + Vector2.new(0, cornerSize)
            esp.Box.Left.Visible = true

            esp.Box.Right.From = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.Right.To = boxPosition + Vector2.new(boxSize.X, cornerSize)
            esp.Box.Right.Visible = true

            esp.Box.Top.From = boxPosition + Vector2.new(0, boxSize.Y - cornerSize)
            esp.Box.Top.To = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.Top.Visible = true

            esp.Box.Bottom.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y - cornerSize)
            esp.Box.Bottom.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.Bottom.Visible = true
        else
            -- Full box (simple)
            esp.Box.TopLeft.From = boxPosition
            esp.Box.TopLeft.To = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.TopLeft.Visible = true

            esp.Box.TopRight.From = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.TopRight.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.TopRight.Visible = true

            esp.Box.BottomLeft.From = boxPosition
            esp.Box.BottomLeft.To = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.BottomLeft.Visible = true

            esp.Box.BottomRight.From = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.BottomRight.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.BottomRight.Visible = true
        end
    end

    if Settings.TracerESP then
        local origin = GetTracerOrigin()
        esp.Tracer.From = origin
        esp.Tracer.To = Vector2.new(top.X, bottom.Y)
        esp.Tracer.Color = color
        esp.Tracer.Visible = true
    end

    if Settings.NameESP then
        local nameText = Settings.NameMode == "DisplayName" and player.DisplayName or player.Name
        esp.Info.Name.Text = nameText
        esp.Info.Name.Position = Vector2.new(top.X, top.Y - 20)
        esp.Info.Name.Color = color
        esp.Info.Name.Visible = true
    end

    if Settings.ShowDistance then
        local distText = math.floor(distance) .. " " .. Settings.DistanceUnit
        esp.Info.Distance.Text = distText
        esp.Info.Distance.Position = Vector2.new(top.X, top.Y - 35)
        esp.Info.Distance.Color = Colors.Distance
        esp.Info.Distance.Visible = true
    end

    if Settings.HealthESP then
        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local healthPercent = health / maxHealth
        
        local healthBarHeight = screenSize
        local healthBarWidth = 4
        local healthBarPos = Settings.HealthBarSide == "Left" and boxPosition.X - 10 or boxPosition.X + boxSize.X + 6
        
        esp.HealthBar.Outline.Position = Vector2.new(healthBarPos, top.Y)
        esp.HealthBar.Outline.Size = Vector2.new(healthBarWidth, healthBarHeight)
        esp.HealthBar.Outline.Visible = true
        
        esp.HealthBar.Fill.Position = Vector2.new(healthBarPos, top.Y + healthBarHeight * (1 - healthPercent))
        esp.HealthBar.Fill.Size = Vector2.new(healthBarWidth, healthBarHeight * healthPercent)
        esp.HealthBar.Fill.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
        esp.HealthBar.Fill.Visible = true
        
        esp.HealthBar.Text.Text = math.floor(health) .. Settings.HealthTextSuffix
        esp.HealthBar.Text.Position = Vector2.new(healthBarPos + healthBarWidth + 5, top.Y + healthBarHeight/2)
        esp.HealthBar.Text.Visible = true
    end

    if Settings.ChamsEnabled and Highlights[player] then
        Highlights[player].Adornee = character
        Highlights[player].Enabled = true
        Highlights[player].FillColor = Settings.ChamsFillColor
        Highlights[player].OutlineColor = Settings.ChamsOutlineColor
        Highlights[player].FillTransparency = Settings.ChamsTransparency
        Highlights[player].OutlineTransparency = Settings.ChamsOutlineTransparency
    end
end

-- ========== AUTO KILL + TELEPORT ==========
local killRemote = nil
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("stab") or remote.Name:lower():find("kill")) then
        killRemote = remote
        break
    end
end

local function teleportTo(target)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            char.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 2, 2)
            return true
        end
    end
    return false
end

local function kill(target)
    if killRemote then
        pcall(function() killRemote:FireServer(target) end)
        pcall(function() killRemote:FireServer(target.UserId) end)
    end
end

local function isMurderer()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
    return tool and (tool:GetAttribute("MurderMysteryWeaponType") == "Knife" or tool.Name:lower():find("knife"))
end

local autoActive = false
local connection = nil

local function startLoop()
    if connection then connection:Disconnect() end
    connection = RunService.RenderStepped:Connect(function()
        if not autoActive or not isMurderer() then return end
        
        local target = nil
        local minDist = 700
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myPos then return end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - myPos.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = p
                end
            end
        end
        
        if target then
            teleportTo(target)
            task.wait(0.1)
            kill(target)
            task.wait(0.5)
        end
    end)
end

-- ========== TELEPORT PLAYER LIST ==========
local function updatePlayerList()
    local playerSection = Tabs.Teleport:AddSection("Daftar Player")
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            playerSection:AddButton({
                Title = player.Name .. " [" .. (player.DisplayName or player.Name) .. "]",
                Callback = function()
                    local char = LocalPlayer.Character
                    local targetChar = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
                    end
                end
            })
        end
    end
end

-- ========== FLUENT UI SETUP ==========
local ESPFolder = Tabs.ESP:AddSection("ESP Settings")
ESPFolder:AddToggle("EnableESP", {
    Title = "Enable ESP",
    Default = false,
    Callback = function(value)
        Settings.Enabled = value
        if value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                RemoveESP(player)
            end
        end
    end
})

ESPFolder:AddToggle("BoxESP", {
    Title = "Box ESP",
    Default = false,
    Callback = function(value)
        Settings.BoxESP = value
    end
})

ESPFolder:AddDropdown("BoxStyle", {
    Title = "Box Style",
    Values = {"Corner", "Full"},
    Default = "Corner",
    Callback = function(value)
        Settings.BoxStyle = value
    end
})

ESPFolder:AddToggle("TracerESP", {
    Title = "Tracer ESP",
    Default = false,
    Callback = function(value)
        Settings.TracerESP = value
    end
})

ESPFolder:AddToggle("NameESP", {
    Title = "Name ESP",
    Default = false,
    Callback = function(value)
        Settings.NameESP = value
    end
})

ESPFolder:AddToggle("HealthESP", {
    Title = "Health ESP",
    Default = false,
    Callback = function(value)
        Settings.HealthESP = value
    end
})

ESPFolder:AddToggle("ShowDistance", {
    Title