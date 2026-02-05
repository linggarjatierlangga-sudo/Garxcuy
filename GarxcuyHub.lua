-- ============================================
-- GARXCUY HUB v2.0 | SHADOWX EDITION
-- Created by: Linggar Jati Erlangga
-- Contact: 0895-2007-1068
-- Game: GET FISH (Place ID: 78632820802305)
-- ============================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- NOTIFIKASI AWAL
print("========================================")
print("GARXCUY HUB v2.0 | SHADOWX EDITION")
print("Creator: Linggar Jati Erlangga")
print("Loading Interface...")
print("========================================")

-- LOAD RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- CREATE MAIN WINDOW
local Window = Rayfield:CreateWindow({
    Name = "🔱 GARXCUY HUB v2.0 | SHADOWX",
    LoadingTitle = "Initializing ShadowX System...",
    LoadingSubtitle = "Powered by Linggar Jati Erlangga",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- VARIABLES
local AutoFarm = false
local AutoSell = false
local SpeedHack = false
local JumpHack = false

-- ====================
-- AUTO FISH FUNCTION
-- ====================
local function StartAutoFarm()
    spawn(function()
        while AutoFarm do
            pcall(function()
                -- MENCARI FISHING SPOT
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if not AutoFarm then break end
                    
                    if obj.Name:lower():find("fish") or 
                       obj.Name:lower():find("spot") or 
                       obj.Name:lower():find("pond") or
                       (obj:IsA("Part") and obj.BrickColor == BrickColor.new("Bright blue")) then
                       
                        local Character = LocalPlayer.Character
                        if Character and Character:FindFirstChild("HumanoidRootPart") then
                            -- TELEPORT KE SPOT
                            Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                            wait(0.3)
                            
                            -- SIMULATE CLICK
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            wait(0.1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end
                end
            end)
            wait(0.8)
        end
    end)
end

-- ====================
-- AUTO SELL FUNCTION
-- ====================
local function StartAutoSell()
    spawn(function()
        while AutoSell do
            pcall(function()
                -- MENCARI NPC SELLER
                for _, npc in pairs(Workspace:GetChildren()) do
                    if not AutoSell then break end
                    
                    if npc:FindFirstChild("Head") and 
                       (npc.Name:lower():find("sell") or 
                        npc.Name:lower():find("merchant") or 
                        npc.Name:lower():find("shop") or
                        (npc:FindFirstChild("BillboardGui") and npc.BillboardGui:FindFirstChild("TextLabel"))) then
                        
                        local Character = LocalPlayer.Character
                        if Character and Character:FindFirstChild("HumanoidRootPart") then
                            -- TELEPORT KE NPC
                            Character.HumanoidRootPart.CFrame = npc.Head.CFrame + Vector3.new(0, -2, 0)
                            wait(0.5)
                            
                            -- MENCARI REMOTE EVENT UNTUK JUAL
                            for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                                if remote:IsA("RemoteEvent") then
                                    if remote.Name:lower():find("sell") or 
                                       remote.Name:lower():find("trade") or 
                                       remote.Name:lower():find("exchange") then
                                        remote:FireServer("all")
                                        remote:FireServer("sell_all")
                                        remote:FireServer("sell")
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            wait(3)
        end
    end)
end

-- ====================
-- MAIN TAB
-- ====================
local MainTab = Window:CreateTab("Main Features", "🎣")

MainTab:CreateSection("🎮 GET FISH Hack")

-- AUTO FARM TOGGLE
MainTab:CreateToggle({
    Name = "Auto Farm Fish",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        AutoFarm = Value
        if Value then
            Rayfield:Notify({
                Title = "✅ AUTO FARM ENABLED",
                Content = "Mulai menangkap ikan otomatis!",
                Duration = 3,
                Image = "rbxassetid://4483345998"
            })
            StartAutoFarm()
        else
            Rayfield:Notify({
                Title = "❌ AUTO FARM DISABLED",
                Content = "Berhenti menangkap ikan!",
                Duration = 3,
                Image = "rbxassetid://4483345998"
            })
        end
    end
})

-- AUTO SELL TOGGLE
MainTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        AutoSell = Value
        if Value then
            Rayfield:Notify({
                Title = "✅ AUTO SELL ENABLED",
                Content = "Mulai menjual ikan otomatis!",
                Duration = 3,
                Image = "rbxassetid://4483345998"
            })
            StartAutoSell()
        else
            Rayfield:Notify({
                Title = "❌ AUTO SELL DISABLED",
                Content = "Berhenti menjual ikan!",
                Duration = 3,
                Image = "rbxassetid://4483345998"
            })
        end
    end
})

-- SPEED HACK
MainTab:CreateToggle({
    Name = "Speed Hack (WalkSpeed 100)",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        SpeedHack = Value
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            if Value then
                Character.Humanoid.WalkSpeed = 100
                Rayfield:Notify({
                    Title = "⚡ SPEED HACK ON",
                    Content = "WalkSpeed: 100",
                    Duration = 3
                })
            else
                Character.Humanoid.WalkSpeed = 16
                Rayfield:Notify({
                    Title = "🐢 SPEED HACK OFF",
                    Content = "WalkSpeed: 16 (Normal)",
                    Duration = 3
                })
            end
        end
    end
})

-- ====================
-- PLAYER TAB
-- ====================
local PlayerTab = Window:CreateTab("Player Mods", "⚡")

PlayerTab:CreateSection("Movement Modifiers")

-- WALKSPEED SLIDER
PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 300},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
    end
})

-- JUMP POWER SLIDER
PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        pcall(function()
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end)
    end
})

-- INFINITE JUMP
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        JumpHack = Value
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if JumpHack then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
            Rayfield:Notify({
                Title = "🦘 INFINITE JUMP ON",
                Content = "Tekan spasi untuk jump tanpa batas!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "🦘 INFINITE JUMP OFF",
                Content = "Jump kembali normal",
                Duration = 3
            })
        end
    end
})

-- ====================
-- OTHER SCRIPTS TAB
-- ====================
local ScriptsTab = Window:CreateTab("Other Scripts", "🔧")

ScriptsTab:CreateSection("Popular Scripts")

-- INFINITE YIELD
ScriptsTab:CreateButton({
    Name = "🛡️ Infinite Yield Admin",
    Callback = function()
        Rayfield:Notify({
            Title = "Loading...",
            Content = "Loading Infinite Yield...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- SIMPLE SPY
ScriptsTab:CreateButton({
    Name = "👁️ SimpleSpy v3",
    Callback = function()
        Rayfield:Notify({
            Title = "Loading...",
            Content = "Loading SimpleSpy...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/master/SimpleSpySource.lua"))()
    end
})

-- ANTI AFK
ScriptsTab:CreateButton({
    Name = "⏰ Anti AFK System",
    Callback = function()
        Rayfield:Notify({
            Title = "ANTI AFK ACTIVATED",
            Content = "Kamu tidak akan di-kick karena AFK!",
            Duration = 5
        })
        
        local VirtualInputManager = game:GetService("VirtualInputManager")
        spawn(function()
            while true do
                wait(30)
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, "Space", false, game)
                    wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "Space", false, game)
                end)
            end
        end)
    end
})

-- ====================
-- INFO TAB
-- ====================
local InfoTab = Window:CreateTab("Info & Credits", "📌")

InfoTab:CreateSection("Creator Info")
InfoTab:CreateLabel("👑 Creator: Linggar Jati Erlangga")
InfoTab:CreateLabel("📞 Contact: 0895-2007-1068")
InfoTab:CreateLabel("🐱 GitHub: linggarjatierlangga-sudo")

InfoTab:CreateSection("Script Info")
InfoTab:CreateLabel("✨ Version: Garxcuy Hub v2.0")
InfoTab:CreateLabel("🔧 Engine: ShadowX System 1.21")
InfoTab:CreateLabel("🎮 Game: GET FISH")
InfoTab:CreateLabel("📍 Place ID: 78632820802305")

InfoTab:CreateSection("Controls")
InfoTab:CreateButton({
    Name = "🔄 Refresh Script",
    Callback = function()
        Rayfield:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/linggarjatierlangga-sudo/Garxcuy/main/GarxcuyHub.lua"))()
    end
})

InfoTab:CreateButton({
    Name = "❌ Destroy UI",
    Callback = function()
        Rayfield:Destroy()
        AutoFarm = false
        AutoSell = false
        SpeedHack = false
        JumpHack = false
    end
})

-- ====================
-- WATERMARK & CREDITS
-- ====================
Rayfield:Notify({
    Title = "🔱 GARXCUY HUB v2.0 LOADED",
    Content = "Created by Linggar Jati Erlangga | Powered by ShadowX",
    Duration = 8,
    Image = "rbxassetid://4483345998"
})

-- PRINT CONSOLE MESSAGE
print("========================================")
print("GARXCUY HUB v2.0 SUCCESSFULLY LOADED!")
print("Game: GET FISH")
print("Creator: Linggar Jati Erlangga")
print("Enjoy the script! 😎")
print("========================================")

-- LOAD SUCCESS SOUND (Optional)
pcall(function()
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://4590662766"
    Sound.Volume = 0.3
    Sound.Parent = game:GetService("SoundService")
    Sound:Play()
    game:GetService("Debris"):AddItem(Sound, 3)
end)
