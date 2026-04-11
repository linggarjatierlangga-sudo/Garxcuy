-- ========== ORION LIBRARY ==========
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
    Name = "LINGGAR 💗 ARA",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GAR_CONFIG",
    IntroEnabled = false
})

local GameTab = Window:MakeTab({
    Name = "Game Exploits",
    Icon = "rbxassetid://7734022041"
})

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== ESP ==========
local espActive = false
local espHighlights = {}

local function getPlayerRole(player)
    if player == LocalPlayer then return "Local" end
    
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
                if weaponType == "Knife" then return "Murderer" end
                if weaponType == "Gun" then return "Sheriff" end
                if tool.Name:lower():find("knife") then return "Murderer" end
                if tool.Name:lower():find("gun") then return "Sheriff" end
            end
        end
    end
    
    local char = player.Character
    if char then
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool then
            local weaponType = tool:GetAttribute("MurderMysteryWeaponType")
            if weaponType == "Knife" then return "Murderer" end
            if weaponType == "Gun" then return "Sheriff" end
            if tool.Name:lower():find("knife") then return "Murderer" end
            if tool.Name:lower():find("gun") then return "Sheriff" end
        end
    end
    
    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then return Color3.fromRGB(0, 0, 255)
    else return Color3.fromRGB(0, 255, 0) end
end

local function updateESP()
    if not espActive then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = espHighlights[player]
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Parent = game:GetService("CoreGui")
                espHighlights[player] = highlight
            end
            highlight.Adornee = player.Character
            highlight.FillColor = getRoleColor(getPlayerRole(player))
            highlight.FillTransparency = 0.5
        end
    end
end

GameTab:AddToggle({
    Name = "🔴 ESP (Merah=Murderer, Biru=Sheriff, Hijau=Innocent)",
    Default = false,
    Callback = function(state)
        espActive = state
        if state then
            updateESP()
            RunService.RenderStepped:Connect(updateESP)
            OrionLib:MakeNotification({Name = "ESP", Content = "Aktif!", Time = 2})
        else
            for _, h in pairs(espHighlights) do pcall(function() h:Destroy() end) end
            espHighlights = {}
        end
    end
})

-- ========== AUTO KILL + TELEPORT (MURDERER ONLY) ==========
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
local autoConnection = nil

local function startAutoKill()
    if autoConnection then autoConnection:Disconnect() end
    autoConnection = RunService.RenderStepped:Connect(function()
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

GameTab:AddToggle({
    Name = "🔪 Auto Kill + Teleport (Murderer Only)",
    Default = false,
    Callback = function(state)
        autoActive = state
        if state then
            if not killRemote then
                OrionLib:MakeNotification({Name = "Error", Content = "Remote kill tidak ditemukan!", Time = 2})
                return
            end
            startAutoKill()
            OrionLib:MakeNotification({Name = "Auto Kill", Content = "Aktif! Radius 700", Time = 2})
        else
            if autoConnection then autoConnection:Disconnect(); autoConnection = nil end
        end
    end
})

-- ========== AUTO SHOOT + TELEPORT (SHERIFF ONLY) ==========
local shootRemote = nil
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") and remote.Name == "GunShotVisual" then
        shootRemote = remote
        break
    end
end

local function shootAt(target)
    if not shootRemote then return false end
    if not target or not target.Character then return false end
    
    local char = LocalPlayer.Character
    local gun = char and char:FindFirstChild("Gun")
    if not gun then return false end
    
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local args = {
        [1] = {
            ["tool"] = gun,
            ["userId"] = target.UserId,
            ["endPosition"] = hrp.Position
        }
    }
    
    pcall(function() shootRemote:FireServer(unpack(args)) end)
    return true
end

local function isSheriff()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        if tool:GetAttribute("MurderMysteryWeaponType") == "Gun" then return true end
        if tool.Name:lower():find("gun") then return true end
    end
    return false
end

local function getClosestMurderer()
    local closest = nil
    local minDist = 700
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getPlayerRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myPos.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = p
            end
        end
    end
    return closest
end

local sheriffActive = false
local sheriffConnection = nil
local teleportDistance = 20

GameTab:AddSlider({
    Name = "Jarak Teleport Sheriff (studs)",
    Min = 10,
    Max = 50,
    Default = 20,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "studs",
    Callback = function(value)
        teleportDistance = value
    end
})

local function teleportToMurderer(target)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local myPos = char.HumanoidRootPart.Position
            local targetPos = hrp.Position
            local direction = (myPos - targetPos).Unit
            local teleportPos = targetPos + direction * teleportDistance
            char.HumanoidRootPart.CFrame = CFrame.new(teleportPos, targetPos)
            return true
        end
    end
    return false
end

local function startSheriffAuto()
    if sheriffConnection then sheriffConnection:Disconnect() end
    sheriffConnection = RunService.RenderStepped:Connect(function()
        if not sheriffActive or not isSheriff() then return end
        
        local target = getClosestMurderer()
        if target then
            teleportToMurderer(target)
            task.wait(0.1)
            shootAt(target)
            task.wait(0.5)
        end
    end)
end

GameTab:AddToggle({
    Name = "🔫 Auto Shoot + Teleport (Sheriff Only)",
    Default = false,
    Callback = function(state)
        sheriffActive = state
        if state then
            if not shootRemote then
                OrionLib:MakeNotification({Name = "Error", Content = "Remote GunShotVisual tidak ditemukan!", Time = 2})
                return
            end
            startSheriffAuto()
            OrionLib:MakeNotification({Name = "Auto Shoot", Content = "Aktif! Jarak " .. teleportDistance .. " studs", Time = 2})
        else
            if sheriffConnection then sheriffConnection:Disconnect(); sheriffConnection = nil end
        end
    end
})

-- ========== FLY + NOCLIP ==========
GameTab:AddButton({
    Name = "🚀 Load Fly + Noclip",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-And-Noclip-GUI-192488"))()
        OrionLib:MakeNotification({Name = "Fly + Noclip", Content = "Loaded!", Time = 2})
    end
})

OrionLib:MakeNotification({Name = "GAR N CUY", Content = "Loaded! ESP + Auto Kill + Auto Shoot", Time = 3})
OrionLib:Init()