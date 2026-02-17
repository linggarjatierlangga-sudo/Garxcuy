-- GarxCuy Hub for Mobile (Dengan Virtual Button) - FIXED
-- Cocok buat Delta / executor HP

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

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
local TweenService = game:GetService("TweenService")

-- Variabel & koneksi
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
local espConnections = {}  -- buat nyimpen semua koneksi ESP

-- ===== VIRTUAL BUTTON (JOYSTICK) =====
local VirtualGui = Instance.new("ScreenGui")
VirtualGui.Name = "VirtualControls"
VirtualGui.ResetOnSpawn = false
VirtualGui.Parent = game:GetService("CoreGui")

-- Fungsi buat bikin tombol
local function makeButton(name, pos, size, color, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(pos.X, 0, pos.Y, 0)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.Draggable = true
    btn.Parent = VirtualGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = btn
    
    return btn
end

-- Buat tombol arah
local btnW = makeButton("W", Vector2.new(0.45, 0.3), 60, Color3.fromRGB(0, 160, 255), "W")
local btnA = makeButton("A", Vector2.new(0.35, 0.4), 60, Color3.fromRGB(0, 160, 255), "A")
local btnS = makeButton("S", Vector2.new(0.45, 0.4), 60, Color3.fromRGB(0, 160, 255), "S")
local btnD = makeButton("D", Vector2.new(0.55, 0.4), 60, Color3.fromRGB(0, 160, 255), "D")
local btnUp = makeButton("Up", Vector2.new(0.8, 0.3), 60, Color3.fromRGB(255, 100, 0), "↑")
local btnDown = makeButton("Down", Vector2.new(0.8, 0.4), 60, Color3.fromRGB(255, 100, 0), "↓")

-- State tombol
local keys = {W=false, A=false, S=false, D=false, Up=false, Down=false}

btnW.MouseButton1Click:Connect(function() keys.W = not keys.W end)
btnW.MouseButton2Click:Connect(function() keys.W = false end)
btnA.MouseButton1Click:Connect(function() keys.A = not keys.A end)
btnA.MouseButton2Click:Connect(function() keys.A = false end)
btnS.MouseButton1Click:Connect(function() keys.S = not keys.S end)
btnS.MouseButton2Click:Connect(function() keys.S = false end)
btnD.MouseButton1Click:Connect(function() keys.D = not keys.D end)
btnD.MouseButton2Click:Connect(function() keys.D = false end)
btnUp.MouseButton1Click:Connect(function() keys.Up = not keys.Up end)
btnUp.MouseButton2Click:Connect(function() keys.Up = false end)
btnDown.MouseButton1Click:Connect(function() keys.Down = not keys.Down end)
btnDown.MouseButton2Click:Connect(function() keys.Down = false end)

-- Update warna tombol sesuai state
RunService.RenderStepped:Connect(function()
    btnW.BackgroundColor3 = keys.W and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 160, 255)
    btnA.BackgroundColor3 = keys.A and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 160, 255)
    btnS.BackgroundColor3 = keys.S and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 160, 255)
    btnD.BackgroundColor3 = keys.D and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 160, 255)
    btnUp.BackgroundColor3 = keys.Up and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 0)
    btnDown.BackgroundColor3 = keys.Down and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 0)
end)

-- ===== TAB PLAYER =====
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})

-- WalkSpeed
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16, Max = 500, Default = 16,
    Callback = function(v)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

-- NoClip
PlayerTab:AddToggle({
    Name = "NoClip",
    Default = false,
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
            if noclipConn then
                noclipConn:Disconnect()
                noclipConn = nil
            end
            -- Kembalikan collide ke true (opsional)
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

-- Fly Mode (pake virtual button)
PlayerTab:AddToggle({
    Name = "Fly Mode",
    Default = false,
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
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            if flyBV then
                flyBV:Destroy()
                flyBV = nil
            end
            hum.PlatformStand = false
        end
    end
})

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 10, Max = 500, Default = 50,
    Callback = function(v) flySpeed = v end
})

-- Infinity Jump
local infinityJump = false
PlayerTab:AddToggle({
    Name = "Infinity Jump",
    Default = false,
    Callback = function(s) infinityJump = s end
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
end)  -- <-- hanya satu kurung tutup

-- Reset WalkSpeed
PlayerTab:AddButton({
    Name = "Reset WalkSpeed",
    Callback = function()
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
        OrionLib:MakeNotification({Name="Reset", Content="WalkSpeed normal", Time=2})
    end
})

-- ===== TAB FREECAM =====
local FreecamTab = Window:MakeTab({Name = "Freecam", Icon = "rbxassetid://4483345998"})
local originalCF = nil

FreecamTab:AddToggle({
    Name = "Enable Freecam",
    Default = false,
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
            if freecamConn then
                freecamConn:Disconnect()
                freecamConn = nil
            end
            if originalCF then Camera.CFrame = originalCF end
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
})

FreecamTab:AddSlider({
    Name = "Freecam Speed",
    Min = 10, Max = 500, Default = 50,
    Callback = function(v) freecamSpeed = v end
})

-- ===== TAB ESP =====
local ESPTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483345998"})

local function createESP(p)
    if p == LocalPlayer then return end
    -- Hapus highlight lama jika ada
    local old = espFolder:FindFirstChild(p.Name)
    if old then old:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = p.Name
    highlight.FillColor = p.Team and p.Team.TeamColor.Color or Color3.new(1,0,0)
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = 0.5
    highlight.Parent = espFolder
    -- Adornee akan otomatis mengikuti karakter jika kita set Adornee ke karakter
    if p.Character then
        highlight.Adornee = p.Character
    else
        p.CharacterAdded:Connect(function(char)
            highlight.Adornee = char
        end)
    end
end

ESPTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(s)
        espEnabled = s
        if s then
            -- Bersihkan folder
            espFolder:ClearAllChildren()
            
            -- Buat ESP untuk semua pemain yang sudah ada
            for _,p in ipairs(Players:GetPlayers()) do
                createESP(p)
            end
            
            -- Koneksi untuk pemain baru
            espConnections.PlayerAdded = Players.PlayerAdded:Connect(createESP)
            
            -- Koneksi untuk pemain yang keluar
            espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p)
                local h = espFolder:FindFirstChild(p.Name)
                if h then h:Destroy() end
            end)
            
            -- Koneksi untuk karakter respawn (CharacterAdded) untuk setiap pemain
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    espConnections["Char_"..p.Name] = p.CharacterAdded:Connect(function()
                        createESP(p) -- recreate highlight untuk karakter baru
                    end)
                end
            end
            
        else
            -- Matikan semua koneksi ESP
            for _,conn in pairs(espConnections) do
                if conn then conn:Disconnect() end
            end
            espConnections = {}
            espFolder:ClearAllChildren()
        end
    end
})

-- ===== TAB OTHER =====
local OtherTab = Window:MakeTab({Name = "Other", Icon = "rbxassetid://4483345998"})

OtherTab:AddButton({
    Name = "Toggle Virtual Buttons",
    Callback = function()
        VirtualGui.Enabled = not VirtualGui.Enabled
    end
})

OtherTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- FPS Counter (fixed)
local fpsGui = nil
local fpsConn = nil
OtherTab:AddToggle({
    Name = "Show FPS",
    Default = false,
    Callback = function(s)
        if s then
            if fpsGui then fpsGui:Destroy() end
            fpsGui = Instance.new("ScreenGui")
            fpsGui.Parent = game:GetService("CoreGui")
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0,100,0,40)
            bg.Position = UDim2.new(0,10,0,10)
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
            if fpsConn then
                fpsConn:Disconnect()
                fpsConn = nil
            end
            if fpsGui then
                fpsGui:Destroy()
                fpsGui = nil
            end
        end
    end
})

OrionLib:MakeNotification({Name="GarxCuy Mobile", Content="Loaded!", Time=3})
OrionLib:Init()

-- Tombol toggle UI (dragable)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,10,0,0.5)
ToggleBtn.BackgroundColor3 = Color3.new(0,0,0)
ToggleBtn.BackgroundTransparency = 0.5
ToggleBtn.Text = "G"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextSize = 25
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Draggable = true
ToggleBtn.Parent = game:GetService("CoreGui")
ToggleBtn.MouseButton1Click:Connect(function() OrionLib:ToggleUi() end)