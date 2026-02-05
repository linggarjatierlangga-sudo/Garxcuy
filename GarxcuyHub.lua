-- ============================================
-- GARXCUY HUB v2.2 | VENYX UI EDITION
-- Created by: Linggar Jati Erlangga
-- Contact: 0895-2007-1068
-- Game: GET FISH (Place ID: 78632820802305)
-- ============================================

wait(2) -- Wait for game to fully load

print("=================================================================")
print("🔱 GARXCUY HUB v2.2 | By LINGGAR JATI ERLANGGA 🔱")
print("=================================================================")

-- LOAD VENYX UI LIBRARY (MORE STABLE)
local VenusLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source.lua"))()

-- CREATE MAIN WINDOW
local Window = VenusLibrary.new("GARXCUY HUB v2.2", 5013109572)

-- CREDITS PAGE
local creditsTab = Window:NewTab("👑 Credits")
local creditsSection = creditsTab:NewSection("Creator Information")
creditsSection:NewLabel("✨ Creator: Linggar Jati Erlangga")
creditsSection:NewLabel("📞 Contact: 0895-2007-1068")
creditsSection:NewLabel("🐱 GitHub: linggarjatierlangga-sudo")
creditsSection:NewLabel("🎮 Game: GET FISH")
creditsSection:NewLabel("📍 Place ID: 78632820802305")
creditsSection:NewLabel("🔧 UI: Venyx Library v1.0")

-- MAIN FEATURES TAB
local mainTab = Window:NewTab("🎣 Main Features")
local autoSection = mainTab:NewSection("Auto Farming")

-- AUTO FARM TOGGLE
local farmEnabled = false
autoSection:NewToggle("Auto Farm Fish", "Automatically catch fish", function(state)
    farmEnabled = state
    if state then
        VenusLibrary:Notify("AUTO FARM", "Started fishing automatically!", "rbxassetid://4483345998")
        spawn(function()
            while farmEnabled and wait(0.8) do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- FIND FISHING SPOTS
                        for _, obj in pairs(workspace:GetChildren()) do
                            if not farmEnabled then break end
                            
                            if obj.Name:lower():find("fish") or 
                               obj.Name:lower():find("spot") or 
                               obj.Name:lower():find("pond") then
                               
                                -- TELEPORT TO SPOT
                                character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                                wait(0.3)
                                
                                -- CLICK TO FISH
                                mouse1click()
                            end
                        end
                    end
                end)
            end
        end)
    else
        VenusLibrary:Notify("AUTO FARM", "Stopped fishing!", "rbxassetid://4483345998")
    end
end)

-- AUTO SELL TOGGLE
local sellEnabled = false
autoSection:NewToggle("Auto Sell Fish", "Automatically sell fish", function(state)
    sellEnabled = state
    if state then
        VenusLibrary:Notify("AUTO SELL", "Started auto selling!", "rbxassetid://4483345998")
        spawn(function()
            while sellEnabled and wait(3) do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- FIND SELLER NPC
                        for _, npc in pairs(workspace:GetChildren()) do
                            if not sellEnabled then break end
                            
                            if npc:FindFirstChild("Head") and 
                               (npc.Name:lower():find("sell") or 
                                npc.Name:lower():find("merchant")) then
                                
                                -- TELEPORT TO NPC
                                character.HumanoidRootPart.CFrame = npc.Head.CFrame + Vector3.new(0, -2, 0)
                                wait(0.5)
                                
                                -- SELL ALL FISH
                                for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") and remote.Name:lower():find("sell") then
                                        remote:FireServer("all")
                                        remote:FireServer("sell_all")
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    else
        VenusLibrary:Notify("AUTO SELL", "Stopped selling!", "rbxassetid://4483345998")
    end
end)

-- PLAYER MODS TAB
local playerTab = Window:NewTab("⚡ Player Mods")
local movementSection = playerTab:NewSection("Movement")

-- WALKSPEED SLIDER
movementSection:NewSlider("Walk Speed", "Change walking speed", 300, 16, function(value)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)

-- JUMP POWER SLIDER
movementSection:NewSlider("Jump Power", "Change jump power", 300, 50, function(value)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end)
end)

-- INFINITE JUMP
local infiniteJump = false
movementSection:NewToggle("Infinite Jump", "Jump forever", function(state)
    infiniteJump = state
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if infiniteJump then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
        VenusLibrary:Notify("INFINITE JUMP", "Enabled! Press space to fly!", "rbxassetid://4483345998")
    end
end)

-- OTHER SCRIPTS TAB
local scriptsTab = Window:NewTab("🔧 Other Scripts")
local scriptsSection = scriptsTab:NewSection("Popular Scripts")

-- LOAD INFINITE YIELD
scriptsSection:NewButton("Infinite Yield Admin", "Load Infinite Yield", function()
    VenusLibrary:Notify("LOADING", "Loading Infinite Yield...", "rbxassetid://4483345998")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- LOAD SIMPLE SPY
scriptsSection:NewButton("SimpleSpy v3", "Load SimpleSpy", function()
    VenusLibrary:Notify("LOADING", "Loading SimpleSpy...", "rbxassetid://4483345998")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/master/SimpleSpySource.lua"))()
end)

-- ANTI AFK
scriptsSection:NewButton("Anti AFK", "Prevent AFK kick", function()
    VenusLibrary:Notify("ANTI AFK", "Enabled! You won't be kicked.", "rbxassetid://4483345998")
    loadstring(game:HttpGet("https://pastebin.com/raw/uwP0cJ6y"))()
end)

-- UTILITIES TAB
local utilTab = Window:NewTab("⚙️ Utilities")
local utilSection = utilTab:NewSection("Game Utilities")

-- REFRESH CHARACTER
utilSection:NewButton("Refresh Character", "Reset your character", function()
    local player = game.Players.LocalPlayer
    player.Character:BreakJoints()
    VenusLibrary:Notify("CHARACTER", "Character refreshed!", "rbxassetid://4483345998")
end)

-- SERVER HOP
utilSection:NewButton("Server Hop", "Join new server", function()
    VenusLibrary:Notify("SERVER HOP", "Finding new server...", "rbxassetid://4483345998")
    loadstring(game:HttpGet("https://pastebin.com/raw/1vv6xSX2"))()
end)

-- DESTROY UI
utilSection:NewButton("Destroy UI", "Remove Garxcuy Hub", function()
    VenusLibrary:Notify("GOODBYE", "Garxcuy Hub destroyed!", "rbxassetid://4483345998")
    wait(1)
    Window:Destroy()
end)

-- SUCCESS MESSAGE
VenusLibrary:Notify(
    "🔱 GARXCUY HUB v2.2 LOADED!",
    "Created by Linggar Jati Erlangga\nEnjoy the script! 😎",
    "rbxassetid://4483345998"
)

print("=================================================================")
print("✅ GARXCUY HUB SUCCESSFULLY LOADED!")
print("✅ UI: Venyx Library (Stable)")
print("✅ Creator: Linggar Jati Erlangga")
print("✅ Ready to use!")
print("=================================================================")

-- PLAY LOAD SOUND
pcall(function()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = 0.3
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game.Debris:AddItem(sound, 3)
end)
