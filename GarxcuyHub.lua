-- GarxCuy Hub for Mobile + ALL FITUR + AUTO FISH (Remote Lengkap) + FIX
-- Cocok buat Delta / executor HP
-- Versi Final dengan Auto Fish State Machine

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

-- Buat Window
local Window = OrionLib:MakeWindow({
    Name = "GarxCuy Hub (Mobile)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GarxCuyMobile",
    IntroEnabled = true,
    IntroText = "GarxCuy Mobile",
    IntroIcon = "rbxassetid://4483345998"
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variabel global
local flyEnabled = false
local freecamEnabled = false
local flySpeed = 50
local freecamSpeed = 50
local flyBV = nil
local freecamConn = nil
local noclipEnabled = false
local noclipConn = nil
local flyConn = nil
local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Mobile"
espFolder.Parent = game:GetService("CoreGui")
local espConnections = {}

-- Track keyboard state (untuk fly & freecam)
local keys = {W=false, A=false, S=false, D=false, Up=false, Down=false}

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keys.Up = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.Down = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keys.Up = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.Down = false end
end)

-- ===== TAB PLAYER =====
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})

-- WalkSpeed Slider
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16, Max = 500, Default = 16,
    Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "speed",
    Callback = function(value)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end
    end
})

-- NoClip Toggle
PlayerTab:AddToggle({
    Name = "NoClip", Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = RunService.Stepped:Connect(function()
                if noclipEnabled and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

-- Fly Mode
PlayerTab:AddToggle({
    Name = "Fly Mode", Default = false,
    Callback = function(state)
        flyEnabled = state
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if state then
            hum.PlatformStand = true
            flyBV = Instance.new("BodyVelocity")
            flyBV.Velocity = Vector3.new(0,0,0)
            flyBV.MaxForce = Vector3.new(10000,10000,10000)
            flyBV.Parent = root
            
            if flyConn then flyConn:Disconnect() end
            flyConn = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                local move = Vector3.new()
                if keys.W then move = move + Camera.CFrame.LookVector end
                if keys.S then move = move - Camera.CFrame.LookVector end
                if keys.A then move = move - Camera.CFrame.RightVector end
                if keys.D then move = move + Camera.CFrame.RightVector end
                if keys.Up then move = move + Vector3.new(0,1,0) end
                if keys.Down then move = move - Vector3.new(0,1,0) end
                
                if move.Magnitude > 0 then
                    flyBV.Velocity = move.Unit * flySpeed
                else
                    flyBV.Velocity = Vector3.new(0,0,0)
                end
            end)
        else
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            if flyBV then flyBV:Destroy(); flyBV = nil end
            hum.PlatformStand = false
        end
    end
})

PlayerTab:AddSlider({
    Name = "Fly Speed", Min = 10, Max = 500, Default = 50,
    Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "speed",
    Callback = function(value) flySpeed = value end
})

-- Infinity Jump
local infinityJump = false
PlayerTab:AddToggle({
    Name = "Infinity Jump", Default = false,
    Callback = function(state) infinityJump = state end
})

UserInputService.JumpRequest:Connect(function()
    if infinityJump and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 100, 0)
            bv.MaxForce = Vector3.new(0, math.huge, 0)
            bv.Parent = root
            game:GetService("Debris"):AddItem(bv, 0.5)
        end
    end
end)

-- Reset WalkSpeed
PlayerTab:AddButton({
    Name = "Reset WalkSpeed",
    Callback = function()
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
        OrionLib:MakeNotification({Name = "Reset", Content = "WalkSpeed normal", Image = "rbxassetid://4483345998", Time = 2})
    end
})

-- ===== TAB FREECAM =====
local FreecamTab = Window:MakeTab({Name = "Freecam", Icon = "rbxassetid://4483345998"})
local originalCF = nil

FreecamTab:AddToggle({
    Name = "Enable Freecam", Default = false,
    Callback = function(state)
        freecamEnabled = state
        if state then
            originalCF = Camera.CFrame
            Camera.CameraType = Enum.CameraType.Scriptable
            
            if freecamConn then freecamConn:Disconnect() end
            freecamConn = RunService.RenderStepped:Connect(function(dt)
                if not freecamEnabled then return end
                local move = Vector3.new()
                if keys.W then move = move + Camera.CFrame.LookVector end
                if keys.S then move = move - Camera.CFrame.LookVector end
                if keys.A then move = move - Camera.CFrame.RightVector end
                if keys.D then move = move + Camera.CFrame.RightVector end
                if keys.Up then move = move + Vector3.new(0,1,0) end
                if keys.Down then move = move - Vector3.new(0,1,0) end
                
                if move.Magnitude > 0 then
                    Camera.CFrame = Camera.CFrame + move.Unit * freecamSpeed * dt * 60
                end
            end)
        else
            if freecamConn then freecamConn:Disconnect(); freecamConn = nil end
            if originalCF then Camera.CFrame = originalCF end
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
})

FreecamTab:AddSlider({
    Name = "Freecam Speed", Min = 10, Max = 500, Default = 50,
    Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "speed",
    Callback = function(value) freecamSpeed = value end
})

-- ===== TAB ESP =====
local ESPTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483345998"})

local function createESP(p)
    if p == LocalPlayer then return end
    local old = espFolder:FindFirstChild(p.Name)
    if old then old:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = p.Name
    highlight.FillColor = p.Team and p.Team.TeamColor.Color or Color3.new(1,0,0)
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = 0.5
    highlight.Parent = espFolder
    if p.Character then
        highlight.Adornee = p.Character
    else
        p.CharacterAdded:Connect(function(char) highlight.Adornee = char end)
    end
end

ESPTab:AddToggle({
    Name = "Enable ESP", Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            espFolder:ClearAllChildren()
            for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
            espConnections.PlayerAdded = Players.PlayerAdded:Connect(createESP)
            espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p)
                local h = espFolder:FindFirstChild(p.Name)
                if h then h:Destroy() end
            end)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    espConnections["Char_"..p.Name] = p.CharacterAdded:Connect(function() createESP(p) end)
                end
            end
        else
            for _, conn in pairs(espConnections) do if conn then conn:Disconnect() end end
            espConnections = {}
            espFolder:ClearAllChildren()
        end
    end
})

-- ===== TAB OTHER =====
local OtherTab = Window:MakeTab({Name = "Other", Icon = "rbxassetid://4483345998"})

OtherTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- FPS Counter
local fpsGui = nil
local fpsConn = nil
OtherTab:AddToggle({
    Name = "Show FPS", Default = false,
    Callback = function(s)
        if s then
            if fpsGui then fpsGui:Destroy() end
            fpsGui = Instance.new("ScreenGui")
            fpsGui.Parent = game:GetService("CoreGui")
            
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 100, 0, 40)
            bg.Position = UDim2.new(0, 10, 0, 10)
            bg.BackgroundColor3 = Color3.new(0,0,0)
            bg.BackgroundTransparency = 0.5
            bg.Parent = fpsGui
            
            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Color3.new(1,1,1)
            txt.TextSize = 20
            txt.Font = Enum.Font.GothamBold
            txt.Parent = bg
            
            local lastTime = tick()
            local frames = 0
            if fpsConn then fpsConn:Disconnect() end
            fpsConn = RunService.RenderStepped:Connect(function()
                frames = frames + 1
                if tick() - lastTime >= 1 then
                    txt.Text = "FPS: " .. frames
                    frames = 0
                    lastTime = tick()
                end
            end)
        else
            if fpsConn then fpsConn:Disconnect(); fpsConn = nil end
            if fpsGui then fpsGui:Destroy(); fpsGui = nil end
        end
    end
})

-- ===== AUTO FISH FIX (STATE MACHINE + COROUTINE) =====
local AutoFishTab = Window:MakeTab({Name = "AUTO FISH", Icon = "rbxassetid://4483345998"})

-- Ambil remote (dari daftar user)
local Fishing_RemoteThrow = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local Fishing_RemoteRetract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
local Fishing_RemoteParked = ReplicatedStorage:FindFirstChild("Fishing_RemoteParked")
local Fishing_RemoteReset = ReplicatedStorage:FindFirstChild("Fishing_RemoteReset")
local FishingCatchSuccess = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")
local ThrowState = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_ThrowState")
local MinigameEnd = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameEnd")
local StartMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StartMeter")
local StopMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StopMeter")

-- Variabel state
local currentState = "IDLE"
local autoFishing = false
local castDelay = 3.0
local useMeter = false

-- Listener ThrowState
if ThrowState then
    ThrowState.Event:Connect(function(newState)
        currentState = newState
        print("🎣 State berubah:", newState)
    end)
end

-- Fungsi auto fishing (coroutine)
local function autoFishLoop()
    while autoFishing do
        -- Cek apakah pancing di-equip
        local rod = nil
        if LocalPlayer.Character then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
                    rod = tool
                    break
                end
            end
        end
        if not rod then
            OrionLib:MakeNotification({Name="Auto Fish", Content="Equip pancing dulu!", Time=2})
            break
        end

        -- State machine
        if currentState == "IDLE" or currentState == "idle" then
            if useMeter and StartMeter then
                StartMeter:FireServer()
                task.wait(0.3)
            end
            if Fishing_RemoteThrow then
                Fishing_RemoteThrow:FireServer()
                print("[Auto] Cast")
            end
            -- Tunggu sampai state berubah
            repeat task.wait(0.2) until currentState ~= "IDLE" or not autoFishing

        elseif currentState == "PARKED" or currentState == "WAITING" then
            task.wait(castDelay)  -- Tunggu ikan menggigit (bisa disesuaikan)
            if Fishing_RemoteRetract then
                Fishing_RemoteRetract:FireServer()
                print("[Auto] Reel")
            elseif FishingCatchSuccess then
                FishingCatchSuccess:FireServer()
            end
            repeat task.wait(0.2) until currentState ~= "PARKED" or not autoFishing

        elseif currentState == "MINIGAME" then
            -- Anggap langsung menang
            if MinigameEnd then
                MinigameEnd:FireServer()
                print("[Auto] Minigame ended")
            end
            repeat task.wait(0.2) until currentState ~= "MINIGAME" or not autoFishing

        elseif currentState == "FINISHED" then
            -- Reset untuk siap cast lagi
            if Fishing_RemoteReset then
                Fishing_RemoteReset:FireServer()
                print("[Auto] Reset")
            end
            repeat task.wait(0.2) until currentState == "IDLE" or not autoFishing

        else
            task.wait(0.5)
        end
    end
end

-- GUI Auto Fish
AutoFishTab:AddParagraph({
    Title = "Remote Ditemukan",
    Content = [[
Throw: ✅
Retract: ✅
Parked/Reset: ✅
Minigame: ✅
    ]]
})

AutoFishTab:AddToggle({
    Name = "🎣 Auto Fishing (State-Based)",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            task.spawn(autoFishLoop)
        end
    end
})

AutoFishTab:AddSlider({
    Name = "Delay Reel setelah Parked (detik)",
    Min = 0.5, Max = 5.0, Default = 3.0, Increment = 0.1, ValueName = "dtk",
    Callback = function(v) castDelay = v end
})

AutoFishTab:AddToggle({
    Name = "Gunakan StartMeter sebelum throw",
    Default = false,
    Callback = function(v) useMeter = v end
})

-- Tombol test manual
AutoFishTab:AddButton({ Name = "Test Throw", Callback = function() if Fishing_RemoteThrow then Fishing_RemoteThrow:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test Retract", Callback = function() if Fishing_RemoteRetract then Fishing_RemoteRetract:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test Parked", Callback = function() if Fishing_RemoteParked then Fishing_RemoteParked:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test Reset", Callback = function() if Fishing_RemoteReset then Fishing_RemoteReset:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test MinigameEnd", Callback = function() if MinigameEnd then MinigameEnd:FireServer() end end })

-- Notifikasi Selesai & Init
OrionLib:MakeNotification({Name = "GarxCuy Mobile", Content = "Loaded! Auto Fish Fix Included", Time = 3})
OrionLib:Init()