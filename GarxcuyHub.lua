-- ============================================
-- GARXCUY HUB GET FISH FIXED v4.0
-- POSITION: TOP RIGHT (Tidak nutup game UI)
-- By: Linggar Jati Erlangga
-- ============================================

wait(4) -- Tunggu game FULL LOAD

print("=================================================================")
print("🔱 GARXCUY HUB v4.0 | GET FISH FIXED")
print("=================================================================")

-- VARIABLES UTAMA
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- CEK GAME LOAD
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- ===============================
-- SIMPLE MINIMAL GUI (POSISI ATAS KANAN)
-- ===============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarxcuyHub_Mini"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999 -- PASTI DI ATAS
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") -- PAKE Playergui, BUKAN CoreGui!

-- MAIN MINI FRAME (POSISI ATAS KANAN)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 40) -- MINIMAL SIZE
mainFrame.Position = UDim2.new(1, -260, 0, 10) -- TOP RIGHT (gak nutup game UI)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- TITLE BAR YANG BISA DITARIK
local titleBar = Instance.new("TextButton")
titleBar.Size = UDim2.new(1, 0, 1, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleBar.Text = "🔱 GARXCUY HUB v4.0 (Click to expand)"
titleBar.TextColor3 = Color3.white
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 12
titleBar.TextWrapped = true
titleBar.Parent = mainFrame

-- EXPANDED CONTENT (Sembunyi awal)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0, 0) -- Height 0 = hidden
contentFrame.Position = UDim2.new(0, 0, 1, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame

-- TOGGLE STATE
local isExpanded = false
local cheatsEnabled = {}

-- TOGGLE EXPAND/COLLAPSE
titleBar.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    if isExpanded then
        contentFrame.Size = UDim2.new(1, 0, 0, 300) -- Expand
        mainFrame.Size = UDim2.new(0, 250, 0, 340)  -- Perbesar frame utama
        titleBar.Text = "🔱 GARXCUY HUB v4.0 (Click to collapse)"
    else
        contentFrame.Size = UDim2.new(1, 0, 0, 0)   -- Collapse
        mainFrame.Size = UDim2.new(0, 250, 0, 40)   -- Kecilkan ke ukuran awal
        titleBar.Text = "🔱 GARXCUY HUB v4.0 (Click to expand)"
    end
end)

-- SCROLL FRAME UNTUK CHEATS
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = contentFrame

-- ===============================
-- FITUR UTAMA GET FISH
-- ===============================
local function FindFishingSpot()
    -- CARI SPOT FISHING BERDASARKAN SCREENSHOT LU
    local spots = {}
    
    -- CARI BERDASARKAN NAMA DARI SCREENSHOT
    local targetNames = {
        "Unte Tinc Tang",
        "Undang", 
        "LAUT",
        "TERBUKA",
        "Fish",
        "Spot",
        "Pond",
        "River"
    }
    
    for _, name in pairs(targetNames) do
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Name:find(name) then
                table.insert(spots, obj)
            end
        end
    end
    
    -- KALO GAK KETEMU, CARI PART BIRU (BIASA NYA FISHING SPOT)
    if #spots == 0 then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.BrickColor == BrickColor.new("Bright blue") or 
               obj.BrickColor == BrickColor.new("Cyan") or
               obj.Material == Enum.Material.Water) then
                table.insert(spots, obj)
            end
        end
    end
    
    return spots
end

local function Click()
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
    wait(0.05)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- ===============================
-- CREATE CHEAT TOGGLES
-- ===============================
local function CreateCheatToggle(name, description, cheatFunction)
    local index = #cheatsEnabled + 1
    local yPos = (index-1) * 50
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 45)
    toggleFrame.Position = UDim2.new(0, 5, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggleFrame.Parent = scrollFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 30, 0, 30)
    toggleBtn.Position = UDim2.new(0, 5, 0, 7)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.white
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 30)
    label.Position = UDim2.new(0, 35, 0, 7)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.white
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = toggleFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -10, 0, 12)
    desc.Position = UDim2.new(0, 5, 0, 32)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 10
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = toggleFrame
    
    local enabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        cheatsEnabled[name] = enabled
        
        if enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            toggleBtn.Text = "ON"
            cheatFunction(true)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            toggleBtn.Text = "OFF"
            cheatFunction(false)
        end
    end)
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, index * 50)
    
    return toggleBtn
end

-- ===============================
-- CHEAT DEFINITIONS
-- ===============================

-- 1. AUTO FISH
CreateCheatToggle("🎣 AUTO FISH", "Auto teleport & fish at all spots", function(state)
    if state then
        spawn(function()
            while cheatsEnabled["🎣 AUTO FISH"] do
                pcall(function()
                    local spots = FindFishingSpot()
                    local char = LocalPlayer.Character
                    
                    if char and #spots > 0 then
                        for _, spot in pairs(spots) do
                            if not cheatsEnabled["🎣 AUTO FISH"] then break end
                            
                            -- TELEPORT
                            char:SetPrimaryPartCFrame(spot.CFrame + Vector3.new(0, 5, 0))
                            wait(0.8)
                            
                            -- CLICK TO FISH
                            Click()
                            wait(0.5)
                        end
                    end
                end)
                wait(1)
            end
        end)
    end
end)

-- 2. AUTO SELL
CreateCheatToggle("💰 AUTO SELL", "Auto sell fish every 15s", function(state)
    if state then
        spawn(function()
            while cheatsEnabled["💰 AUTO SELL"] do
                pcall(function()
                    -- CARI NPC SELLER
                    for _, npc in pairs(Workspace:GetDescendants()) do
                        if npc:IsA("Model") and npc.Name:find("Seller") or npc.Name:find("Merchant") then
                            LocalPlayer.Character:SetPrimaryPartCFrame(npc:GetPrimaryPartCFrame())
                            wait(0.5)
                            
                            -- FIRE SELL EVENT
                            for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") then
                                    remote:FireServer("sell_all")
                                end
                            end
                            break
                        end
                    end
                end)
                wait(15)
            end
        end)
    end
end)

-- 3. SPEED HACK
CreateCheatToggle("⚡ SPEED HACK", "WalkSpeed 100 (Toggle)", function(state)
    if state then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 4. INFINITE JUMP
CreateCheatToggle("🦘 INFINITE JUMP", "Jump forever in air", function(state)
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if cheatsEnabled["🦘 INFITE JUMP"] then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- 5. AUTO CLAIM DAILY
CreateCheatToggle("🎁 AUTO DAILY", "Auto claim daily reward", function(state)
    if state then
        spawn(function()
            while cheatsEnabled["🎁 AUTO DAILY"] do
                pcall(function()
                    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and (gui.Text:find("DAILY") or gui.Text:find("CLAIM")) then
                            fireclickdetector(gui)
                        end
                    end
                end)
                wait(60) -- Cek setiap 1 menit
            end
        end)
    end
end)

-- 6. NO FALL DAMAGE
CreateCheatToggle("🛡️ NO FALL DAMAGE", "No damage from falling", function(state)
    if state then
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    else
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
end)

-- ===============================
-- QUICK BUTTONS
-- ===============================
local function CreateQuickButton(name, callback)
    local index = #cheatsEnabled + 1
    local yPos = (index-1) * 40
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
    btn.Text = name
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = scrollFrame
    
    btn.MouseButton1Click:Connect(callback)
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (index * 40) + 50)
end

CreateQuickButton("📈 MAXIMIZE CF", function()
    pcall(function()
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            for _, stat in pairs(stats:GetChildren()) do
                if stat.Name == "CF" then
                    stat.Value = 999999999
                end
            end
        end
    end)
end)

CreateQuickButton("🔧 LOAD INFINITE YIELD", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

CreateQuickButton("🎮 TELEPORT TO BEST SPOT", function()
    local spots = FindFishingSpot()
    if #spots > 0 then
        LocalPlayer.Character:SetPrimaryPartCFrame(spots[1].CFrame + Vector3.new(0, 10, 0))
    end
end)

CreateQuickButton("❌ DESTROY THIS UI", function()
    screenGui:Destroy()
end)

-- ===============================
-- FINAL SETUP
-- ===============================
-- UPDATE SCROLL SIZE
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#cheatsEnabled + 4) * 50)

-- SHOW LOAD MESSAGE
local loadMsg = Instance.new("TextLabel")
loadMsg.Size = UDim2.new(0, 300, 0, 40)
loadMsg.Position = UDim2.new(0.5, -150, 0.5, -20)
loadMsg.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
loadMsg.Text = "✅ GARXCUY HUB v4.0 LOADED!\nBy Linggar Jati Erlangga"
loadMsg.TextColor3 = Color3.white
loadMsg.Font = Enum.Font.GothamBold
loadMsg.TextSize = 14
loadMsg.TextWrapped = true
loadMsg.Parent = screenGui

-- HIDE MESSAGE SETELAH 3 DETIK
spawn(function()
    wait(3)
    loadMsg:Destroy()
end)

print("=================================================================")
print("✅ GARXCUY HUB v4.0 SUCCESS!")
print("✅ Position: Top Right (Safe)")
print("✅ Toggle: Work 100%")
print("✅ Cheats: Ready")
print("✅ Creator: Linggar Jati Erlangga")
print("=================================================================")
