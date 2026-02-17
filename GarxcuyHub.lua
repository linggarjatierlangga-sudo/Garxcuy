--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
    Name = "GarxCuy Hub V3",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GarxCuyConfig",
    IntroEnabled = true,
    IntroText = "GarxCuy Hub",
    IntroIcon = "rbxassetid://4483345998"
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESP_Highlights"
highlightFolder.Parent = game.CoreGui

-- Global variables
local espEnabled = false
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyBodyVelocity = nil
local noclipConn = nil
local flyConn = nil
local espConnections = {}

-- Key tracking for movement
local keys = {
    W = false, A = false, S = false, D = false,
    Space = false, Shift = false
}

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = false end
end)

-- ===== TAB PLAYER =====
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- WalkSpeed Slider
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

-- NoClip Toggle (dipindah ke Player)
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

-- FLY MODE (FIXED)
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
                if keys.W then moveDir = moveDir + Camera.CFrame.LookVector end
                if keys.S then moveDir = moveDir - Camera.CFrame.LookVector end
                if keys.A then moveDir = moveDir - Camera.CFrame.RightVector end
                if keys.D then moveDir = moveDir + Camera.CFrame.RightVector end
                if keys.Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if keys.Shift then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
                else
                    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
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

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(value)
        flySpeed = value
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

-- Reset WalkSpeed
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

-- ===== TARGET SECTION (LOCK PLAYER) =====
local TargetSection = ESPTab:AddSection({
    Name = "Target"
})

local selectedPlayer = nil
local playerNames = {}
local function updatePlayerList()
    playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
end
updatePlayerList()

-- Dropdown
local playerDropdown = ESPTab:AddDropdown({
    Name = "Select Player",
    Options = playerNames,
    Default = "",
    Callback = function(value)
        selectedPlayer = Players:FindFirstChild(value)
    end
})

-- Update dropdown on player join/leave
Players.PlayerAdded:Connect(function()
    updatePlayerList()
    playerDropdown:Refresh(playerNames, true)
end)
Players.PlayerRemoving:Connect(function()
    updatePlayerList()
    playerDropdown:Refresh(playerNames, true)
end)

-- Spectate toggle
local spectating = false
local spectateConn = nil
ESPTab:AddToggle({
    Name = "Spectate Player",
    Default = false,
    Callback = function(state)
        spectating = state
        if spectating and selectedPlayer then
            local function update()
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    Camera.CameraSubject = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
                    Camera.CameraType = Enum.CameraType.Custom
                end
            end
            update()
            spectateConn = selectedPlayer.CharacterAdded:Connect(update)
        else
            if spectateConn then
                spectateConn:Disconnect()
                spectateConn = nil
            end
            -- Kembalikan ke localplayer
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
})

-- Teleport button
ESPTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                OrionLib:MakeNotification({
                    Name = "Teleport",
                    Content = "Teleported to " .. selectedPlayer.Name,
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Player tidak valid atau tidak memiliki karakter",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- ===== TAB FREECAM (FIXED) =====
local FreecamTab = Window:MakeTab({
    Name = "FREECAM",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local freecamEnabled = false
local freecamSpeed = 50
local freecamConnection = nil
local originalCF = nil
local originalSubject = nil
local originalType = nil

FreecamTab:AddToggle({
    Name = "Enable Freecam",
    Default = false,
    Callback = function(state)
        freecamEnabled = state
        if state then
            -- Simpan state asli
            originalCF = Camera.CFrame
            originalSubject = Camera.CameraSubject
            originalType = Camera.CameraType
            
            -- Set kamera ke scriptable agar bisa dikontrol
            Camera.CameraType = Enum.CameraType.Scriptable
            
            -- Loop gerak
            freecamConnection = RunService.RenderStepped:Connect(function(dt)
                if not freecamEnabled then return end
                local move = Vector3.new()
                if keys.W then move = move + Camera.CFrame.LookVector end
                if keys.S then move = move - Camera.CFrame.LookVector end
                if keys.A then move = move - Camera.CFrame.RightVector end
                if keys.D then move = move + Camera.CFrame.RightVector end
                if keys.Space then move = move + Vector3.new(0, 1, 0) end
                if keys.Shift then move = move - Vector3.new(0, 1, 0) end
                
                if move.Magnitude > 0 then
                    Camera.CFrame = Camera.CFrame + move.Unit * freecamSpeed * dt * 60
                end
            end)
        else
            if freecamConnection then
                freecamConnection:Disconnect()
                freecamConnection = nil
            end
            -- Kembalikan kamera
            if originalCF then
                Camera.CFrame = originalCF
            end
            if originalSubject then
                Camera.CameraSubject = originalSubject
            end
            if originalType then
                Camera.CameraType = originalType
            else
                Camera.CameraType = Enum.CameraType.Custom
            end
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
    Name = "Unlock All Emotes (Coba)",
    Callback = function()
        local attempts = 0
        pcall(function()
            for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("emote") or remote.Name:lower():find("emotes")) then
                    remote:FireServer("UnlockAll")
                    remote:FireServer("BuyAll")
                    attempts = attempts + 1
                end
            end
            for _, remote in ipairs(LocalPlayer:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("emote") or remote.Name:lower():find("emotes")) then
                    remote:FireServer("UnlockAll")
                    attempts = attempts + 1
                end
            end
        end)
        if attempts > 0 then
            OrionLib:MakeNotification({
                Name = "Unlock Emotes",
                Content = "Mencoba " .. attempts .. " remote. Cek apakah emotes terbuka.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Unlock Emotes",
                Content = "Tidak menemukan remote emote.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- FPS Counter
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
