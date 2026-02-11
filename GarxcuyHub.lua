-- ================================================
-- ZURAX ROOT: WINDOW + SPOOF ENGINE
-- Game: GET FISH (ID: 78632820802305)
-- ================================================

print("💀 ZURAX ROOT: MEMBANGUN WINDOW...")

-- VARIABEL GLOBAL
local SpoofStatus = {
    AutoSell = false,
    AutoCast = false,
    InstantCatch = false,
    SpoofMoney = false
}

-- ================================================
-- 1. MEMBUAT WINDOW (PASTI MUNCUL, BISA DI-DRAG)
-- ================================================
local function CreateMainWindow()
    -- Hapus GUI lama
    pcall(function()
        game:GetService("CoreGui"):FindFirstChild("ZuraxSpoofWindow"):Destroy()
    end)

    -- ScreenGui utama
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZuraxSpoofWindow"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    -- Frame utama (window)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0) -- Pojok kiri, agak turun
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 100)
    mainFrame.BorderSizePixel = 2
    mainFrame.Active = true
    mainFrame.Draggable = true -- DRAG ENABLED (Roblox native)
    mainFrame.Parent = screenGui

    -- Shadow / efek glossy
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    -- ========== TITLE BAR ==========
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Text = "💀 ZURAX SPOOF ENGINE v2.0 | GET FISH"
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 100, 255)
    titleText.Font = Enum.Font.GothamBold
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- CLOSE BUTTON (BISA DITEKAN)
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "✕"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextScaled = true
    closeButton.BorderSizePixel = 0
    
    closeButton.MouseButton1Click:Connect(function()
        print("[ZURAX] Window ditutup.")
        screenGui:Destroy()
        -- Matikan semua fitur
        SpoofStatus.AutoSell = false
        SpoofStatus.AutoCast = false
        SpoofStatus.InstantCatch = false
    end)
    closeButton.Parent = titleBar

    -- ========== CONTENT AREA (Scrolling Frame) ==========
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 600) -- Panjang konten
    contentFrame.Parent = mainFrame

    -- Biar smooth scrolling
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = contentFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.Parent = contentFrame

    return screenGui, mainFrame, contentFrame
end

-- ================================================
-- 2. FUNGSI MEMBUAT CARD / PANEL DALAM WINDOW
-- ================================================
local function CreateCard(parent, title, yOffset)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 0, 80)
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(100, 0, 150)
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextScaled = false
    titleLabel.TextSize = 16
    titleLabel.Parent = card

    return card
end

-- ================================================
-- 3. FUNGSI MEMBUAT TOGGLE BUTTON
-- ================================================
local function CreateToggle(parent, posY, text, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.Position = UDim2.new(0, 10, 0, posY)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = "  " .. text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 16
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.Size = UDim2.new(0, 70, 0, 28)
    toggleBtn.Position = UDim2.new(1, -75, 0.5, -14)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = toggleFrame

    local state = defaultValue

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        callback(state)
    end)

    return toggleBtn
end

-- ================================================
-- 4. FUNGSI MEMBUAT ACTION BUTTON
-- ================================================
local function CreateActionButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(80, 80, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ================================================
-- 5. SPOOF ENGINE FUNCTIONS
-- ================================================

-- Hook remote untuk spoof
local function SetupSpoofHooks()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Spoof SellFish
        if self.Name == "SellFish" and method == "FireServer" and SpoofStatus.AutoSell then
            print("[SPOOF] SellFish – Payload diganti")
            for i = 1, 3 do
                oldNamecall(self, "All999999")
            end
            return nil
        end
        
        -- Spoof CastRod (no cooldown)
        if self.Name == "CastRod" and method == "FireServer" and SpoofStatus.AutoCast then
            for i = 1, 2 do
                oldNamecall(self, ...)
            end
            return nil
        end
        
        -- Spoof ReelRod (legendary)
        if self.Name == "ReelRod" and method == "FireServer" and SpoofStatus.InstantCatch then
            local spoofArgs = {rarity = 3, fishId = math.random(10000, 99999)}
            oldNamecall(self, spoofArgs)
            return nil
        end
        
        return oldNamecall(self, ...)
    end)
    print("[ZURAX] Spoof hooks terpasang.")
end

-- Auto Sell loop
local function StartAutoSell()
    task.spawn(function()
        while SpoofStatus.AutoSell do
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents"):FindFirstChild("SellFish")
                if remote then
                    remote:FireServer("All999999")
                    print("[AUTO] Auto Sell dijalankan")
                end
            end)
            task.wait(10)
        end
    end)
end

-- Auto Cast loop
local function StartAutoCast()
    task.spawn(function()
        while SpoofStatus.AutoCast do
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents"):FindFirstChild("CastRod")
                if remote then
                    remote:FireServer()
                end
            end)
            task.wait(1.5)
        end
    end)
end

-- Instant Catch loop
local function StartInstantCatch()
    task.spawn(function()
        while SpoofStatus.InstantCatch do
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents"):FindFirstChild("ReelRod")
                if remote then
                    remote:FireServer({rarity = 3, fishId = math.random(99999)})
                    print("[INSTANT] Ikan legendary ditangkap!")
                end
            end)
            task.wait(0.3)
        end
    end)
end

-- Spoof Leaderstats
local function SpoofMoney()
    pcall(function()
        local ls = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats")
        if ls and ls:FindFirstChild("Money") then
            ls.Money.Value = 999999999
            print("[SPOOF] Uang diset ke 999.999.999")
        end
    end)
end

-- ================================================
-- 6. MEMBANGUN WINDOW + ISI
-- ================================================

-- Buat window utama
local screenGui, mainFrame, contentFrame = CreateMainWindow()

-- Setup spoof hooks (sekali)
SetupSpoofHooks()

-- === CARD 1: AUTO FARM ===
local card1 = CreateCard(contentFrame, "🎣 AUTO FARM", 0)

CreateToggle(card1, 35, "Auto Cast Rod", false, function(state)
    SpoofStatus.AutoCast = state
    if state then StartAutoCast() end
    print("[TOGGLE] Auto Cast:", state)
end)

CreateToggle(card1, 75, "Auto Sell (Spoof 999k)", false, function(state)
    SpoofStatus.AutoSell = state
    if state then StartAutoSell() end
    print("[TOGGLE] Auto Sell:", state)
end)

-- === CARD 2: INSTANT & SPOOF ===
local card2 = CreateCard(contentFrame, "⚡ INSTANT & SPOOF", 0)

CreateToggle(card2, 35, "Instant Catch (Legendary)", false, function(state)
    SpoofStatus.InstantCatch = state
    if state then StartInstantCatch() end
    print("[TOGGLE] Instant Catch:", state)
end)

CreateActionButton(card2, "💰 SPOOF UANG 999M", Color3.fromRGB(255, 200, 0), function()
    SpoofMoney()
end)

-- === CARD 3: MANUAL SPOOF ===
local card3 = CreateCard(contentFrame, "🛠️ MANUAL SPOOF", 0)

CreateActionButton(card3, "💲 JUAL 999 IKAN PALSU", Color3.fromRGB(200, 100, 0), function()
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents"):FindFirstChild("SellFish")
        if remote then
            for i = 1, 5 do
                remote:FireServer("All999999")
                task.wait(0.05)
            end
            print("[MANUAL] Spoof Sell 5x dikirim")
        end
    end)
end)

CreateActionButton(card3, "🎣 CAST 10x SEKALIGUS", Color3.fromRGB(0, 150, 200), function()
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingEvents"):FindFirstChild("CastRod")
        if remote then
            for i = 1, 10 do
                remote:FireServer()
                task.wait(0.02)
            end
            print("[MANUAL] 10x cast dikirim")
        end
    end)
end)

-- === CARD 4: INFO ===
local card4 = CreateCard(contentFrame, "ℹ️ INFO", 0)

local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "Game: GET FISH\nExecutor: Delta\nStatus: Spoof Engine Active"
infoLabel.Size = UDim2.new(1, -10, 0, 60)
infoLabel.Position = UDim2.new(0, 5, 0, 5)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = card4

-- === ANTI AFK ===
local function AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[ANTI-AFK] Prevented idle kick")
    end)
end
AntiAFK()

-- ================================================
-- 7. FINAL
-- ================================================
print("💀 ZURAX WINDOW BERHASIL DIBUAT!")
print("✅ GUI muncul di pojok kiri")
print("✅ Bisa di-drag dari title bar")
print("✅ Tombol close bekerja")
print("✅ Semua fitur spoof siap digunakan")

-- Notifikasi
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZURAX ROOT",
    Text = "Window + Spoof Engine Loaded!",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})
