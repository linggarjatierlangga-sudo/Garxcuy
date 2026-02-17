-- GarxCuy Hub - Simple Version (Kavo UI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GarxCuy Hub", "DarkTheme")

-- Variabel
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESP_Highlights"
highlightFolder.Parent = game.CoreGui

-- ===== TAB UTAMA =====
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Movement")

-- Speed & Jump Boost
local speedEnabled = false
MainSection:NewToggle("Speed & Jump Boost", "Naikin speed", function(state)
    speedEnabled = state
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and 120 or 16
            humanoid.JumpPower = state and 120 or 50
        end
    end
end)

-- NoClip
local noclipEnabled = false
local noclipConn
MainSection:NewToggle("NoClip", "Tembus tembok", function(state)
    noclipEnabled = state
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            if not noclipEnabled then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        -- Balikin collide (opsional, game biasanya ngatur sendiri)
    end
end)

-- Fly
local flyEnabled = false
local flyConn, flyBV
MainSection:NewToggle("Fly Mode", "Terbang pake WASD + Spasi + Ctrl", function(state)
    flyEnabled = state
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    
    if state then
        humanoid.PlatformStand = true
        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.MaxForce = Vector3.new(10000,10000,10000)
        flyBV.Parent = root
        
        flyConn = RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                move = move - Vector3.new(0,1,0)
            end
            flyBV.Velocity = move * 50
        end)
    else
        if flyConn then flyConn:Disconnect() end
        if flyBV then flyBV:Destroy() end
        humanoid.PlatformStand = false
    end
end)

-- ===== TAB ESP =====
local ESPTab = Window:NewTab("ESP")
local ESPSection = ESPTab:NewSection("Player ESP")

-- Fungsi bikin highlight
local function createHighlight(plr)
    if plr == LocalPlayer then return end
    if not plr.Character then return end
    local hl = Instance.new("Highlight")
    hl.Name = plr.Name.."_ESP"
    hl.FillColor = plr.Team and plr.Team.TeamColor.Color or Color3.new(1,0,0)
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.5
    hl.Parent = highlightFolder
    hl.Adornee = plr.Character
end

-- Toggle ESP
ESPSection:NewToggle("Enable ESP", "Lihat player tembus tembok", function(state)
    if state then
        -- Hapus semua highlight lama
        for _, v in pairs(highlightFolder:GetChildren()) do v:Destroy() end
        
        -- Buat highlight untuk semua player
        for _, plr in pairs(Players:GetPlayers()) do
            createHighlight(plr)
        end
        
        -- Koneksi player added
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                createHighlight(plr)
            end)
        end)
        
        -- Koneksi player removing
        Players.PlayerRemoving:Connect(function(plr)
            local hl = highlightFolder:FindFirstChild(plr.Name.."_ESP")
            if hl then hl:Destroy() end
        end)
        
    else
        -- Matikan ESP
        for _, v in pairs(highlightFolder:GetChildren()) do v:Destroy() end
    end
end)

-- Notifikasi
wait(1)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GarxCuy Hub",
    Text = "Loaded! Fitur ESP, NoClip, Fly siap",
    Duration = 3
})
