-- GarxCuy Hub for Mobile + EMOJI Tab + AUTO FISH
-- Cocok buat Delta / executor HP

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

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
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998"
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
            if hum then hum.WalkSpeed = value end
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
local infinityJump = false
PlayerTab:AddToggle({
    Name = "Infinity Jump",
    Default = false,
    Callback = function(state)
        infinityJump = state
    end
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
        OrionLib:MakeNotification({
            Name = "Reset",
            Content = "WalkSpeed normal",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- ===== TAB FREECAM =====
local FreecamTab = Window:MakeTab({
    Name = "Freecam",
    Icon = "rbxassetid://4483345998"
})
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

-- ===== TAB ESP =====
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998"
})

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
        p.CharacterAdded:Connect(function(char)
            highlight.Adornee = char
        end)
    end
end

ESPTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            espFolder:ClearAllChildren()
            for _, p in ipairs(Players:GetPlayers()) do
                createESP(p)
            end
            espConnections.PlayerAdded = Players.PlayerAdded:Connect(createESP)
            espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p)
                local h = espFolder:FindFirstChild(p.Name)
                if h then h:Destroy() end
            end)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    espConnections["Char_"..p.Name] = p.CharacterAdded:Connect(function()
                        createESP(p)
                    end)
                end
            end
        else
            for _, conn in pairs(espConnections) do
                if conn then conn:Disconnect() end
            end
            espConnections = {}
            espFolder:ClearAllChildren()
        end
    end
})

-- ===== TAB OTHER =====
local OtherTab = Window:MakeTab({
    Name = "Other",
    Icon = "rbxassetid://4483345998"
})

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
    Name = "Show FPS",
    Default = false,
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

-- ===== TAB EMOJI (UNIVERSAL, TANPA ID) =====
local EmojiTab = Window:MakeTab({
    Name = "EMOJI",
    Icon = "rbxassetid://4483345998"
})

-- Variabel buat nyimpen data emoji
local emojiData = {}
local selectedEmoji = nil

-- Fungsi buat scan semua kemungkinan data emoji
local function scanEmojiData()
    emojiData = {}
    
    -- Scan di ReplicatedStorage
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("Folder") or obj:IsA("Configuration") then
            local name = obj.Name:lower()
            if name:find("emoji") or name:find("emote") or name:find("sticker") then
                table.insert(emojiData, {
                    Source = "ReplicatedStorage",
                    Name = obj.Name,
                    Path = obj:GetFullName(),
                    Object = obj
                })
            end
        end
    end
    
    -- Scan di Player
    for _, obj in ipairs(LocalPlayer:GetDescendants()) do
        if obj:IsA("Folder") or obj:IsA("Configuration") or obj:IsA("StringValue") or obj:IsA("BoolValue") then
            local name = obj.Name:lower()
            if name:find("emoji") or name:find("emote") or name:find("sticker") then
                table.insert(emojiData, {
                    Source = "Player",
                    Name = obj.Name,
                    Path = obj:GetFullName(),
                    Object = obj
                })
            end
        end
    end
    
    return #emojiData > 0
end

-- Tombol buat scan data
EmojiTab:AddButton({
    Name = "🔍 Scan Emoji Data",
    Callback = function()
        local count = scanEmojiData()
        if count then
            -- Update dropdown dengan hasil scan
            local options = {}
            for i, data in ipairs(emojiData) do
                table.insert(options, string.format("[%d] %s (%s)", i, data.Name, data.Source))
            end
            emojiDropdown:Refresh(options, true)
            
            OrionLib:MakeNotification({
                Name = "Scan Complete",
                Content = "Ditemukan "..#emojiData.." data terkait emoji",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Scan Failed",
                Content = "Tidak ada data emoji yang ditemukan",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Dropdown buat milih data yang ditemukan
local emojiDropdown = EmojiTab:AddDropdown({
    Name = "Pilih Data Emoji",
    Options = {},
    Default = "",
    Callback = function(value)
        local index = tonumber(value:match("%[(%d+)%]"))
        if index and emojiData[index] then
            selectedEmoji = emojiData[index]
            
            local obj = selectedEmoji.Object
            local details = string.format("Path: %s\nType: %s", selectedEmoji.Path, obj.ClassName)
            
            if obj:IsA("StringValue") then
                details = details .. "\nValue: " .. obj.Value
            elseif obj:IsA("BoolValue") then
                details = details .. "\nValue: " .. tostring(obj.Value)
            elseif obj:IsA("NumberValue") then
                details = details .. "\nValue: " .. obj.Value
            elseif obj:IsA("Folder") then
                local children = obj:GetChildren()
                details = details .. "\nChildren: " .. #children
                for i, child in ipairs(children) do
                    if i <= 5 then
                        details = details .. "\n  - " .. child.Name .. " (" .. child.ClassName .. ")"
                    end
                end
                if #children > 5 then
                    details = details .. "\n  ... dan " .. (#children-5) .. " lainnya"
                end
            end
            
            detailLabel:Set(details)
        end
    end
})

-- Label buat nampilin detail
local detailLabel = EmojiTab:AddParagraph({
    Title = "Detail Data",
    Content = "Pilih data dari dropdown untuk melihat detail"
})

-- Tombol buat coba unlock berdasarkan data yang dipilih
EmojiTab:AddButton({
    Name = "🔓 Coba Unlock dari Data Ini",
    Callback = function()
        if not selectedEmoji then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Pilih dulu data dari dropdown",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            return
        end
        
        local obj = selectedEmoji.Object
        local success = false
        
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer("UnlockAll")
                obj:FireServer("UnlockEmoji")
                obj:FireServer("BuyAll")
                obj:FireServer("Unlock", "All")
                obj:FireServer("Emoji", "Unlock")
                success = true
            end)
        elseif obj:IsA("RemoteFunction") then
            pcall(function()
                obj:InvokeServer("UnlockAll")
                obj:InvokeServer("UnlockEmoji")
                success = true
            end)
        elseif obj:IsA("Folder") then
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    pcall(function()
                        child:FireServer("UnlockAll")
                        child:FireServer("UnlockEmoji")
                        success = true
                    end)
                end
            end
        end
        
        if success then
            OrionLib:MakeNotification({
                Name = "Unlock Attempt",
                Content = "Mencoba unlock dari data terpilih",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- Tombol unlock semua remote (brutal)
EmojiTab:AddButton({
    Name = "⚡ Unlock All Remote (Brutal)",
    Callback = function()
        local successCount = 0
        for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("emoji") or name:find("emote") or name:find("unlock") or name:find("purchase") then
                    pcall(function()
                        remote:FireServer("UnlockAll")
                        remote:FireServer("UnlockEmoji")
                        remote:FireServer("BuyAll")
                        remote:FireServer("Unlock", "All")
                        remote:FireServer("Emoji", "Unlock")
                        successCount = successCount + 1
                    end)
                end
            end
        end
        
        OrionLib:MakeNotification({
            Name = "Brutal Unlock",
            Content = "Mencoba "..successCount.." remote",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

EmojiTab:AddParagraph({
    Title = "Info Universal",
    Content = "1. Klik 'Scan Emoji Data' untuk mencari semua data terkait emoji di game.\n2. Pilih data dari dropdown untuk melihat detail.\n3. Coba unlock dari data spesifik atau pakai brutal unlock.\n4. Fitur ini spekulatif, tergantung struktur game."
})

-- ===== TAB AUTO FISH =====
local AutoFishTab = Window:MakeTab({
    Name = "AUTO FISH",
    Icon = "rbxassetid://4483345998"
})

