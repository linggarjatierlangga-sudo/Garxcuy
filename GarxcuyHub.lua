-- ================================================
-- ZURAX SPOOF ENGINE V3.0 – DETECTIVE MODE
-- Game: GET FISH (78632820802305)
-- Fitur: Auto detect remote, fallback GUI click, bruteforce payload
-- ================================================

print("💀 ZURAX V3 – MEMBEDAH KEBUNTUAN...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ================================================
-- 1. DETEKSI REMOTE OTOMATIS
-- ================================================
local Remotes = {
    Cast = nil,
    Reel = nil,
    Sell = nil,
    Upgrade = nil
}

local function ScanRemotes()
    print("[SCAN] Mencari remote FishingEvents...")
    local fishingEvents = ReplicatedStorage:FindFirstChild("FishingEvents")
    
    if not fishingEvents then
        -- Coba cari di tempat lain
        fishingEvents = ReplicatedStorage:FindFirstChild("Fishing") 
                    or ReplicatedStorage:FindFirstChild("FishSystem")
    end

    if fishingEvents then
        for _, child in pairs(fishingEvents:GetChildren()) do
            local name = child.Name:lower()
            if name:find("cast") or name:find("rod") then Remotes.Cast = child end
            if name:find("reel") or name:find("catch") then Remotes.Reel = child end
            if name:find("sell") or name:find("market") then Remotes.Sell = child end
            if name:find("upgrade") then Remotes.Upgrade = child end
        end
    end

    -- Tampilkan hasil deteksi
    print("🔍 HASIL SCAN:")
    print("  CastRod :", Remotes.Cast and "✅" or "❌")
    print("  ReelRod :", Remotes.Reel and "✅" or "❌")
    print("  SellFish:", Remotes.Sell and "✅" or "❌")
    
    return Remotes
end

-- ================================================
-- 2. FIRE REMOTE DENGAN BRUTEFORCE PAYLOAD
-- ================================================
local function FireRemote(remote, ...)
    if not remote then return false end
    local success, err = pcall(function()
        remote:FireServer(...)
    end)
    if not success then
        print("[ERROR] Gagal fire", remote.Name, err)
    end
    return success
end

-- ================================================
-- 3. FALLBACK: KLIK UI (Jika remote tidak ada)
-- ================================================
local function ClickUIButton(buttonName)
    local gui = LocalPlayer.PlayerGui
    local button = gui:FindFirstChild(buttonName, true)
    if button and button:IsA("TextButton") then
        fireclickdetector(button:FindFirstChildOfType("ClickDetector") or button)
        return true
    end
    return false
end

-- ================================================
-- 4. FITUR AUTO CAST (Dengan fallback)
-- ================================================
local AutoCastState = false
local function AutoCastLoop()
    while AutoCastState do
        if Remotes.Cast then
            FireRemote(Remotes.Cast)
        else
            ClickUIButton("CastButton") or ClickUIButton("CastRod") or ClickUIButton("Fish")
        end
        task.wait(2.5)
    end
end

-- ================================================
-- 5. FITUR INSTANT CATCH (Payload bruteforce)
-- ================================================
local InstantCatchState = false
local function InstantCatchLoop()
    while InstantCatchState do
        if Remotes.Reel then
            -- Coba berbagai payload
            FireRemote(Remotes.Reel, {rarity = 3, fishId = math.random(99999)})
            FireRemote(Remotes.Reel, {rarity = "Legendary"})
            FireRemote(Remotes.Reel, "catch")
            FireRemote(Remotes.Reel, true)
        else
            -- Deteksi bite via UI
            local gui = LocalPlayer.PlayerGui
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Visible then
                    local txt = obj.Text:lower()
                    if txt:find("bite") or txt:find("!!!") or txt:find("reel") then
                        -- Klik di tengah layar (simulasi mouse)
                        mouse1click()
                        break
                    end
                end
            end
        end
        task.wait(0.2)
    end
end

-- ================================================
-- 6. FITUR AUTO SELL (Bruteforce payload)
-- ================================================
local AutoSellState = false
local function AutoSellLoop()
    while AutoSellState do
        if Remotes.Sell then
            -- Coba berbagai kemungkinan payload
            FireRemote(Remotes.Sell, "All")
            FireRemote(Remotes.Sell, "All999999")
            FireRemote(Remotes.Sell, {sell = "all"})
            FireRemote(Remotes.Sell, true)
        end
        task.wait(15)
    end
end

-- ================================================
-- 7. FITUR SPOOF LEADERSTATS (Tanpa remote)
-- ================================================
local function SpoofLeaderstats()
    pcall(function()
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        if ls then
            for _, stat in pairs(ls:GetChildren()) do
                if stat:IsA("IntValue") and stat.Name:lower():find("money") then
                    stat.Value = 999999999
                    print("[SPOOF] Uang diubah menjadi 999.999.999")
                end
            end
        end
    end)
end

-- ================================================
-- 8. GUI YANG MEMBERI FEEDBACK REAL-TIME
-- ================================================
local function CreateDebugWindow()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZuraxV3"
    screenGui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 500)
    frame.Position = UDim2.new(0.05, 0, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
    frame.BorderColor3 = Color3.fromRGB(255, 0, 100)
    frame.Draggable = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Text = "💀 ZURAX V3 - DIAGNOSTIC"
    title.Size = UDim2.new(1, -40, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
    title.TextColor3 = Color3.new(0, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Text = "X"
    close.Size = UDim2.new(0, 40, 0, 40)
    close.Position = UDim2.new(1, -40, 0, 0)
    close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.TextColor3 = Color3.new(1, 1, 1)
    close.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        AutoCastState = false
        InstantCatchState = false
        AutoSellState = false
    end)
    close.Parent = title

    -- Status Remote
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -20, 0, 60)
    statusText.Position = UDim2.new(0, 10, 0, 50)
    statusText.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    statusText.Text = "Mendeteksi remote..."
    statusText.TextWrapped = true
    statusText.TextColor3 = Color3.fromRGB(255, 255, 100)
    statusText.Font = Enum.Font.Gotham
    statusText.TextSize = 14
    statusText.Parent = frame

    -- Tombol SCAN ulang
    local scanBtn = Instance.new("TextButton")
    scanBtn.Text = "🔍 SCAN REMOTE"
    scanBtn.Size = UDim2.new(1, -20, 0, 35)
    scanBtn.Position = UDim2.new(0, 10, 0, 120)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 150)
    scanBtn.TextColor3 = Color3.new(1, 1, 1)
    scanBtn.MouseButton1Click:Connect(function()
        Remotes = ScanRemotes()
        statusText.Text = string.format("Cast: %s | Reel: %s | Sell: %s", 
            Remotes.Cast and "✅" or "❌",
            Remotes.Reel and "✅" or "❌",
            Remotes.Sell and "✅" or "❌"
        )
    end)
    scanBtn.Parent = frame

    -- Toggle Auto Cast
    local castToggle = Instance.new("TextButton")
    castToggle.Text = "⏸️ AUTO CAST: OFF"
    castToggle.Size = UDim2.new(1, -20, 0, 40)
    castToggle.Position = UDim2.new(0, 10, 0, 165)
    castToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    castToggle.TextColor3 = Color3.new(1, 1, 1)
    castToggle.MouseButton1Click:Connect(function()
        AutoCastState = not AutoCastState
        castToggle.Text = AutoCastState and "✅ AUTO CAST: ON" or "⏸️ AUTO CAST: OFF"
        castToggle.BackgroundColor3 = AutoCastState and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(80, 0, 0)
        if AutoCastState then task.spawn(AutoCastLoop) end
    end)
    castToggle.Parent = frame

    -- Toggle Instant Catch
    local catchToggle = Instance.new("TextButton")
    catchToggle.Text = "⚡ INSTANT CATCH: OFF"
    catchToggle.Size = UDim2.new(1, -20, 0, 40)
    catchToggle.Position = UDim2.new(0, 10, 0, 210)
    catchToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    catchToggle.TextColor3 = Color3.new(1, 1, 1)
    catchToggle.MouseButton1Click:Connect(function()
        InstantCatchState = not InstantCatchState
        catchToggle.Text = InstantCatchState and "✅ INSTANT CATCH: ON" or "⚡ INSTANT CATCH: OFF"
        catchToggle.BackgroundColor3 = InstantCatchState and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(80, 0, 0)
        if InstantCatchState then task.spawn(InstantCatchLoop) end
    end)
    catchToggle.Parent = frame

    -- Toggle Auto Sell
    local sellToggle = Instance.new("TextButton")
    sellToggle.Text = "💰 AUTO SELL: OFF"
    sellToggle.Size = UDim2.new(1, -20, 0, 40)
    sellToggle.Position = UDim2.new(0, 10, 0, 255)
    sellToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    sellToggle.TextColor3 = Color3.new(1, 1, 1)
    sellToggle.MouseButton1Click:Connect(function()
        AutoSellState = not AutoSellState
        sellToggle.Text = AutoSellState and "✅ AUTO SELL: ON" or "💰 AUTO SELL: OFF"
        sellToggle.BackgroundColor3 = AutoSellState and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(80, 0, 0)
        if AutoSellState then task.spawn(AutoSellLoop) end
    end)
    sellToggle.Parent = frame

    -- Tombol Spoof Uang
    local moneyBtn = Instance.new("TextButton")
    moneyBtn.Text = "💸 SPOOF UANG 999M"
    moneyBtn.Size = UDim2.new(1, -20, 0, 40)
    moneyBtn.Position = UDim2.new(0, 10, 0, 300)
    moneyBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
    moneyBtn.TextColor3 = Color3.new(0, 0, 0)
    moneyBtn.MouseButton1Click:Connect(SpoofLeaderstats)
    moneyBtn.Parent = frame

    -- Tombol Manual Cast 10x
    local cast10Btn = Instance.new("TextButton")
    cast10Btn.Text = "🎣 CAST 10x (MANUAL)"
    cast10Btn.Size = UDim2.new(1, -20, 0, 40)
    cast10Btn.Position = UDim2.new(0, 10, 0, 345)
    cast10Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    cast10Btn.TextColor3 = Color3.new(1, 1, 1)
    cast10Btn.MouseButton1Click:Connect(function()
        for i = 1, 10 do
            if Remotes.Cast then FireRemote(Remotes.Cast) end
            task.wait(0.05)
        end
    end)
    cast10Btn.Parent = frame

    -- Label status debug
    local debugLabel = Instance.new("TextLabel")
    debugLabel.Size = UDim2.new(1, -20, 0, 40)
    debugLabel.Position = UDim2.new(0, 10, 0, 400)
    debugLabel.BackgroundTransparency = 1
    debugLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    debugLabel.Font = Enum.Font.Gotham
    debugLabel.TextSize = 12
    debugLabel.TextWrapped = true
    debugLabel.Parent = frame

    -- Update status remote setiap 5 detik
    task.spawn(function()
        while screenGui.Parent do
            debugLabel.Text = string.format("Remote: C=%s R=%s S=%s | Loop: A-Cast=%s I-Catch=%s A-Sell=%s",
                Remotes.Cast and "✅" or "❌",
                Remotes.Reel and "✅" or "❌",
                Remotes.Sell and "✅" or "❌",
                AutoCastState and "ON" or "OFF",
                InstantCatchState and "ON" or "OFF",
                AutoSellState and "ON" or "OFF"
            )
            task.wait(5)
        end
    end)

    -- SCAN pertama
    task.wait(1)
    Remotes = ScanRemotes()
    statusText.Text = string.format("Cast: %s | Reel: %s | Sell: %s", 
        Remotes.Cast and "✅" or "❌",
        Remotes.Reel and "✅" or "❌",
        Remotes.Sell and "✅" or "❌"
    )
end

-- ================================================
-- EKSEKUSI
-- ================================================
CreateDebugWindow()
print("💀 ZURAX V3 SIAP – Gunakan tombol SCAN untuk cek remote.")
