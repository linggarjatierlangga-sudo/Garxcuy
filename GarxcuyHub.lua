-- GarxCuy Hub for Mobile + ALL FITUR + AUTO FISH (FIXED)
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

-- ===== TAB AUTO FISH (BERDASARKAN KODE ASLI) =====
local AutoFishTab = Window:MakeTab({Name = "AUTO FISH", Icon = "rbxassetid://4483345998"})

-- Variabel auto fish
local autoFishing = false
local autoFishConn = nil
local fishingRod = nil
local castRemote = nil
local reelRemote = nil
local stateRemote = nil
local castDelay = 1.0
local useFallback = true
local fallbackTime = 8
local currentState = "UNKNOWN"

-- Fungsi cari fishing rod
local function findFishingRod()
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod") or tool.Name:lower():find("pancing")) then
                return tool
            end
        end
    end
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod") or tool.Name:lower():find("pancing")) then
            return tool
        end
    end
    return nil
end

-- Fungsi scan remote events
local function scanRemotes()
    local remotes = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("cast") or name:find("reel") or name:find("fish") or name:find("catch") then
                table.insert(remotes, obj)
            end
        end
    end
    return remotes
end

-- Ambil state dari BindableEvent (dari kode asli)
local function getFishingState()
    local stateEvent = ReplicatedStorage:FindFirstChild("FishingState_"..LocalPlayer.UserId)
    if stateEvent then
        -- Kalo bisa dapet nilai terakhir, tapi karena ini event, kita perlu listener
        -- Buat sementara, kita pantau lewat perubahan
    end
    -- Coba cek dari tool
    if fishingRod then
        local clientState = fishingRod:FindFirstChild("ClientState")
        if clientState then
            return clientState:GetAttribute("state") or "IDLE"
        end
    end
    return "IDLE"
end

-- Tombol scan
AutoFishTab:AddButton({
    Name = "🔍 Scan Fishing Rod & Remotes",
    Callback = function()
        fishingRod = findFishingRod()
        local remotes = scanRemotes()
        local msg = ""
        if fishingRod then
            msg = "✅ Rod: "..fishingRod.Name.."\n"
        else
            msg = "❌ Rod tidak ditemukan! Equip dulu.\n"
        end
        if #remotes > 0 then
            msg = msg.."📡 Remotes: "..#remotes
            for i, r in ipairs(remotes) do
                print("Remote "..i..": "..r.Name)
            end
            -- Auto-assign remote pertama sebagai cast, kedua sebagai reel
            if #remotes >= 1 then castRemote = remotes[1] end
            if #remotes >= 2 then reelRemote = remotes[2] end
        else
            msg = msg.."❌ Tidak ada remote fishing"
        end
        OrionLib:MakeNotification({Name = "Scan Result", Content = msg, Time = 5})
    end
})

-- Dropdown untuk cast remote (akan diisi manual)
local dropdownCast = AutoFishTab:AddDropdown({
    Name = "Pilih Cast Remote",
    Options = {},
    Default = "",
    Callback = function(value)
        castRemote = ReplicatedStorage:FindFirstChild(value, true)
    end
})

-- Dropdown untuk reel remote
local dropdownReel = AutoFishTab:AddDropdown({
    Name = "Pilih Reel Remote",
    Options = {},
    Default = "",
    Callback = function(value)
        reelRemote = ReplicatedStorage:FindFirstChild(value, true)
    end
})

-- Tombol refresh dropdown
AutoFishTab:AddButton({
    Name = "Refresh Remote List",
    Callback = function()
        local remotes = scanRemotes()
        local names = {}
        for _, r in ipairs(remotes) do table.insert(names, r.Name) end
        dropdownCast:Refresh(names, true)
        dropdownReel:Refresh(names, true)
        OrionLib:MakeNotification({Name = "Refreshed", Content = #names.." remote ditemukan", Time = 2})
    end
})

-- Slider delay
AutoFishTab:AddSlider({
    Name = "Cast Delay (detik)",
    Min = 0.1, Max = 5.0, Default = 1.0, Increment = 0.1, ValueName = "dtk",
    Callback = function(v) castDelay = v end
})

-- Toggle fallback
AutoFishTab:AddToggle({
    Name = "Gunakan Fallback 8s (dari kode asli)",
    Default = true,
    Callback = function(v) useFallback = v end
})

-- Toggle auto fish
AutoFishTab:AddToggle({
    Name = "🎣 Auto Fishing ON",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            fishingRod = findFishingRod()
            if not fishingRod then
                OrionLib:MakeNotification({Name = "Error", Content = "Fishing rod tidak ditemukan! Equip dulu.", Time = 3})
                autoFishing = false
                return
            end
            if not castRemote or not reelRemote then
                OrionLib:MakeNotification({Name = "Error", Content = "Pilih cast & reel remote dulu!", Time = 3})
                autoFishing = false
                return
            end
            
            -- Equip rod
            LocalPlayer.Character.Humanoid:EquipTool(fishingRod)
            wait(0.5)
            
            autoFishConn = RunService.Heartbeat:Connect(function()
                if not autoFishing then return end
                
                -- Simulasi state machine dari kode asli
                local state = getFishingState()
                currentState = state
                
                if state == "IDLE" then
                    pcall(function() castRemote:FireServer() end)
                    print("[AutoFish] Cast")
                    wait(castDelay)
                elseif state == "WAITING" and useFallback then
                    wait(fallbackTime)
                    pcall(function() reelRemote:FireServer() end)
                    print("[AutoFish] Fallback reel")
                    wait(1)
                elseif state == "MINIGAME" then
                    pcall(function() reelRemote:FireServer() end)
                    print("[AutoFish] Force reel minigame")
                    wait(1)
                else
                    wait(0.5)
                end
            end)
            
            OrionLib:MakeNotification({Name = "Auto Fish", Content = "Dimulai!", Time = 2})
        else
            if autoFishConn then autoFishConn:Disconnect(); autoFishConn = nil end
        end
    end
})

-- Info state sekarang
AutoFishTab:AddButton({
    Name = "🔍 Cek State Sekarang",
    Callback = function()
        local state = getFishingState()
        OrionLib:MakeNotification({Name = "Current State", Content = state, Time = 2})
    end
})

AutoFishTab:AddParagraph({
    Title = "Petunjuk",
    Content = "1. Equip pancing dulu!\n2. Klik 'Scan Fishing Rod & Remotes'\n3. Pilih cast & reel remote\n4. Atur delay, nyalakan toggle\n5. Fitur fallback 8s dari kode asli"
})

-- Notifikasi Selesai & Init
OrionLib:MakeNotification({Name = "GarxCuy Mobile", Content = "Loaded! Semua fitur + Auto Fish", Time = 3})
OrionLib:Init()
