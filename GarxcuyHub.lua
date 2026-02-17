-- GarxCuy Hub for Mobile + ALL FITUR + AUTO FISH (Remote Lengkap)
-- Cocok buat Delta / executor HP

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

-- Track keyboard state
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

-- ===== TAB AUTO FISH (Remote Lengkap) =====
local AutoFishTab = Window:MakeTab({Name = "AUTO FISH", Icon = "rbxassetid://4483345998"})

-- Ambil semua remote dari daftar user
local FishingCatchSuccess = ReplicatedStorage:FindFirstChild("FishingCatchSuccess")
local BroadcastRemote = ReplicatedStorage:FindFirstChild("BroadcastRemote")
local AutoFishingState = ReplicatedStorage:FindFirstChild("AutoFishingState_9883448335")
local AutoFishing_ToolEquipped = ReplicatedStorage:FindFirstChild("AutoFishing_ToolEquipped_9883448335")
local AutoFishing_ToolUnequipped = ReplicatedStorage:FindFirstChild("AutoFishing_ToolUnequipped_9883448335")
local Fishing_RemoteParked = ReplicatedStorage:FindFirstChild("Fishing_RemoteParked")
local Fishing_RemoteReset = ReplicatedStorage:FindFirstChild("Fishing_RemoteReset")
local Fishing_RemoteThrow = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local Fishing_RemoteRetract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")

-- Remote dengan ID tool spesifik (ganti ID sesuai tool lo nanti)
local MinigameEnd = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameEnd")
local MinigameStart = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameStart")
local StartMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StartMeter")
local StopMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StopMeter")
local ThrowState = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_ThrowState")

-- Juga remote generik dengan ID player
local StartMeter2 = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_FishingRod_StartMeter")
local StopMeter2 = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_FishingRod_StopMeter")

-- Variabel auto fish
local autoFishing = false
local autoFishConn = nil
local currentState = "IDLE"
local castDelay = 2.0
local useMeter = false  -- apakah perlu StartMeter dulu

-- Fungsi untuk mendapatkan tool ID dinamis
local function getCurrentToolId()
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
                return tool:GetAttribute("ToolUniqueId") or "7441d396-e015-4ea6-993f-757ca7d42bbb" -- fallback
            end
        end
    end
    return nil
end

-- Listener untuk ThrowState
if ThrowState then
    ThrowState.Event:Connect(function(state)
        currentState = state
        print("[ThrowState]", state)
    end)
end

-- Fungsi auto fishing
local function startAutoFishing()
    local toolId = getCurrentToolId()
    if not toolId then
        OrionLib:MakeNotification({Name = "Error", Content = "Tidak bisa mendapatkan Tool ID. Equip pancing dulu!", Time = 2})
        return false
    end
    
    -- Pastikan remote yang diperlukan ada
    if not Fishing_RemoteThrow then
        OrionLib:MakeNotification({Name = "Error", Content = "Fishing_RemoteThrow tidak ditemukan!", Time = 2})
        return false
    end
    if not Fishing_RemoteRetract and not FishingCatchSuccess then
        OrionLib:MakeNotification({Name = "Error", Content = "Tidak ada remote untuk reel!", Time = 2})
        return false
    end
    
    autoFishConn = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        
        -- State machine sederhana
        if currentState == "IDLE" or currentState == "idle" then
            -- Cast pancing
            pcall(function()
                if useMeter and StartMeter then
                    StartMeter:FireServer()
                    wait(0.3)  -- simulasi charge
                end
                Fishing_RemoteThrow:FireServer()
                print("[Auto] Fishing_RemoteThrow fired")
            end)
            wait(castDelay)
            
        elseif currentState == "WAITING" or currentState == "waiting" or currentState == "PARKED" then
            -- Reel
            pcall(function()
                if Fishing_RemoteRetract then
                    Fishing_RemoteRetract:FireServer()
                    print("[Auto] Fishing_RemoteRetract fired")
                elseif FishingCatchSuccess then
                    FishingCatchSuccess:FireServer()
                    print("[Auto] FishingCatchSuccess fired")
                end
            end)
            wait(1)
            
        elseif currentState == "MINIGAME" then
            -- Otomatis menang? Bisa coba langsung reel
            pcall(function()
                if MinigameEnd then
                    MinigameEnd:FireServer()
                elseif Fishing_RemoteRetract then
                    Fishing_RemoteRetract:FireServer()
                end
            end)
            wait(1)
        end
    end)
    
    OrionLib:MakeNotification({Name = "Auto Fish", Content = "Dimulai dengan state machine", Time = 2})
    return true
end

-- GUI
AutoFishTab:AddParagraph({
    Title = "Remote Ditemukan",
    Content = [[
- Fishing_RemoteThrow (lempar)
- Fishing_RemoteRetract (tarik)
- FishingCatchSuccess (alternatif reel)
- Fishing_RemoteParked, Fishing_RemoteReset (state)
- ThrowState (event state)
- StartMeter, StopMeter (untuk charge)
- MinigameStart, MinigameEnd (minigame)
    ]]
})

AutoFishTab:AddToggle({
    Name = "🎣 Auto Fishing (State-Based)",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            if not startAutoFishing() then
                autoFishing = false
            end
        else
            if autoFishConn then autoFishConn:Disconnect(); autoFishConn = nil end
        end
    end
})

AutoFishTab:AddSlider({
    Name = "Delay Cast → Reel (detik)",
    Min = 0.5, Max = 5.0, Default = 2.0, Increment = 0.1, ValueName = "dtk",
    Callback = function(v) castDelay = v end
})

AutoFishTab:AddToggle({
    Name = "Gunakan StartMeter sebelum throw",
    Default = false,
    Callback = function(v) useMeter = v end
})

-- Tombol test manual
AutoFishTab:AddButton({
    Name = "Test Fishing_RemoteThrow",
    Callback = function()
        if Fishing_RemoteThrow then Fishing_RemoteThrow:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test Fishing_RemoteRetract",
    Callback = function()
        if Fishing_RemoteRetract then Fishing_RemoteRetract:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test FishingCatchSuccess",
    Callback = function()
        if FishingCatchSuccess then FishingCatchSuccess:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test StartMeter",
    Callback = function()
        if StartMeter then StartMeter:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test StopMeter",
    Callback = function()
        if StopMeter then StopMeter:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test Fishing_RemoteParked",
    Callback = function()
        if Fishing_RemoteParked then Fishing_RemoteParked:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test Fishing_RemoteReset",
    Callback = function()
        if Fishing_RemoteReset then Fishing_RemoteReset:FireServer() end
    end
})

AutoFishTab:AddButton({
    Name = "Test MinigameEnd",
    Callback = function()
        if MinigameEnd then MinigameEnd:FireServer() end
    end
})

AutoFishTab:AddParagraph({
    Title = "Info",
    Content = "Gunakan test manual untuk memastikan remote bekerja. Auto fishing menggunakan state machine dari ThrowState."
})

-- Notifikasi Selesai & Init
OrionLib:MakeNotification({Name = "GarxCuy Mobile", Content = "Loaded! Semua fitur + Auto Fish Remote Lengkap", Time = 3})
OrionLib:Init()