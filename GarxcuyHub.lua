-- Script by ShadowX - GarxCuy Hub with Orion Library (ESP + NoClip + Fly)
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

-- Variabel untuk fitur
local espEnabled = false
local noclipEnabled = false
local flyEnabled = false
local flyBodyVelocity = nil
local noclipConn = nil
local flyConn = nil
local espConnections = {}

-- ===== TAB 1 =====
local Tab = Window:MakeTab({
    Name = "Tab 1",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- ===== SECTION MAIN =====
local MainSection = Tab:AddSection({
    Name = "Main Features"
})

-- 1. Speed & Jump Boost
Tab:AddToggle({
    Name = "Speed & Jump Boost",
    Default = false,
    Callback = function(state)
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if state then
                    humanoid.WalkSpeed = 120
                    humanoid.JumpPower = 120
                else
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end
    end
})

-- 2. Fetch Data Button (contoh)
Tab:AddButton({
    Name = "Fetch Example Data",
    Callback = function()
        local success, result = pcall(function()
            return game:HttpGet("https://httpbin.org/get")
        end)
        if success then
            OrionLib:MakeNotification({
                Name = "Success!",
                Content = "Data fetched, check console",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            print(result)
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Gagal ambil data",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- ===== SECTION ESP =====
local ESPSection = Tab:AddSection({
    Name = "ESP Features"
})

-- Fungsi ESP
local function createHighlight(player)
    if not player.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    -- Warna berdasarkan tim
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
Tab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            -- Bersihkan highlight lama
            for _, v in ipairs(highlightFolder:GetChildren()) do
                v:Destroy()
            end
            
            -- Buat highlight untuk semua player (kecuali diri sendiri)
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createHighlight(player)
                end
            end
            
            -- Koneksi player added
            espConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    if espEnabled and player ~= LocalPlayer then
                        createHighlight(player)
                    end
                end)
            end)
            
            -- Koneksi character added untuk player yang sudah ada
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
            
            -- Koneksi player removing
            espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
                local highlight = highlightFolder:FindFirstChild(player.Name .. "_ESP")
                if highlight then highlight:Destroy() end
            end)
            
            -- Update warna berdasarkan tim
            espConnections.Heartbeat = RunService.Heartbeat:Connect(function()
                if not espEnabled then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local highlight = highlightFolder:FindFirstChild(player.Name .. "_ESP")
                        if highlight then
                            if player.Team then
                                highlight.FillColor = player.Team.TeamColor.Color
                            end
                        end
                    end
                end
            end)
            
        else
            -- Matikan ESP: bersihkan semua highlight dan putuskan koneksi
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

-- ===== SECTION MOVEMENT =====
local MoveSection = Tab:AddSection({
    Name = "Movement Features"
})

-- 3. NoClip
Tab:AddToggle({
    Name = "NoClip (Tembus Tembok)",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then
            -- Loop untuk menonaktifkan collision setiap saat
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
            -- Kembalikan collision ke default (biar game yang ngatur)
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

-- 4. Fly
Tab:AddToggle({
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
            -- Aktifkan fly
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
                    flyBodyVelocity.Velocity = moveDir * 50
                end
            end)
        else
            -- Matikan fly
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

-- Notifikasi startup
OrionLib:MakeNotification({
    Name = "GarxCuy Hub Loaded",
    Content = "ESP, NoClip, Fly siap digunakan!",
    Image = "rbxassetid://4483345998",
    Time = 3
})

-- Init library
OrionLib:Init()
