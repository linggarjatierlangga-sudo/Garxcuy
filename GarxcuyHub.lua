-- ================================================
-- GARXCUY HUB ULTIMATE - GET FISH
-- Fitur: Auto Fishing, Instan Catch, Fly Speed
-- ================================================

print("🎣 Garxcuy Hub Ultimate Loading...")

-- Variabel Penting
local Pemain = game:GetService("Players")
local PemainUtama = Pemain.LocalPlayer
local Karakter = PemainUtama.Character or PemainUtama.CharacterAdded:Wait()
local Penyimpanan = game:GetService("ReplicatedStorage")

-- Cek Remote Event (Inti dari Video)
local EventMemancing = Penyimpanan:FindFirstChild("FishingEvents")
if not EventMemancing then
    error("❌ ERROR: 'FishingEvents' tidak ditemukan!")
    return
end
print("✅ Terhubung ke game!")

-- Status Fitur
local Status = {
    AutoLempar = false,
    AutoTarik = false,
    TangkapInstan = false,
    Terbang = false,
    JualOtomatis = false
}

-- 🎯 FITUR 1: AUTO LEMPAR JORAN (AUTO FISHING)
local function MulaiAutoLempar()
    Status.AutoLempar = true
    task.spawn(function()
        while Status.AutoLempar do
            pcall(function()
                local remoteLempar = EventMemancing:FindFirstChild("CastRod")
                if remoteLempar then
                    remoteLempar:FireServer()
                    print("[AUTO] Joran dilempar")
                end
            end)
            task.wait(2.5) -- Delay bisa diatur
        end
    end)
end

local function HentikanAutoLempar()
    Status.AutoLempar = false
end

-- 🎯 FITUR 2: TANGKAP INSTAN (INSTAN CATCH - dari judul video)
local function MulaiTangkapInstan()
    Status.TangkapInstan = true
    task.spawn(function()
        while Status.TangkapInstan do
            -- Method 1: Deteksi UI "Bite"
            local GUI = PemainUtama.PlayerGui
            local ditemukan = false
            
            for _, elemen in pairs(GUI:GetDescendants()) do
                if (elemen:IsA("TextLabel") or elemen:IsA("TextButton")) and elemen.Visible then
                    local teks = string.lower(elemen.Text)
                    if teks:find("bite") or teks:find("!!!") or teks:find("tarik") then
                        ditemukan = true
                        break
                    end
                end
            end
            
            -- Method 2: Langsung panggil remote (Instan)
            if ditemukan then
                pcall(function()
                    local remoteTarik = EventMemancing:FindFirstChild("ReelRod")
                    if remoteTarik then
                        remoteTarik:FireServer()
                        remoteTarik:FireServer() -- Double fire untuk pastikan
                        print("[INSTAN] Ikan ditangkap!")
                    end
                end)
            end
            task.wait(0.1) -- Cek sangat cepat
        end
    end)
end

-- 🎯 FITUR 3: FLY SPEED (dari judul video)
local function AktifkanTerbang()
    if Status.Terbang then return end
    Status.Terbang = true
    
    local Kendali = Karakter:WaitForChild("Humanoid")
    local asliGravitasi = Kendali.Gravity
    local asliKecepatan = Kendali.WalkSpeed
    
    -- Non-aktifkan gravitasi & tambah speed
    Kendali.Gravity = 0
    Kendali.WalkSpeed = 80
    
    -- Kontrol terbang dengan keyboard
    local UIS = game:GetService("UserInputService")
    local koneksi
    koneksi = UIS.InputBegan:Connect(function(input, diproses)
        if diproses then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            -- Terbang naik
            Karakter.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            -- Terbang turun
            Karakter.HumanoidRootPart.Velocity = Vector3.new(0, -100, 0)
        elseif input.KeyCode == Enum.KeyCode.E then
            -- Matikan terbang
            Kendali.Gravity = asliGravitasi
            Kendali.WalkSpeed = asliKecepatan
            Status.Terbang = false
            if koneksi then koneksi:Disconnect() end
            print("✈️ Mode terbang dimatikan")
        end
    end)
    
    print("✈️ Mode TERBANG diaktifkan! (Space=Naik, Shift=Turun, E=Stop)")
end

-- 🎯 FITUR 4: AUTO JUAL
local function MulaiAutoJual()
    Status.JualOtomatis = true
    task.spawn(function()
        while Status.JualOtomatis do
            task.wait(30) -- Jual setiap 30 detik
            pcall(function()
                local remoteJual = EventMemancing:FindFirstChild("SellFish")
                if remoteJual then
                    remoteJual:FireServer("All")
                    print("💰 Ikan terjual otomatis!")
                end
            end)
        end
    end)
end

-- 🖥️ GUI SEDERHANAN TAPI PASTI BISA CLOSE
local function BuatGUI()
    -- Hapus GUI lama
    local GUI_Lama = game:GetService("CoreGui"):FindFirstChild("GarxcuyGUI")
    if GUI_Lama then GUI_Lama:Destroy() end
    
    -- Buat GUI baru
    local LayarGUI = Instance.new("ScreenGui")
    LayarGUI.Name = "GarxcuyGUI"
    LayarGUI.ResetOnSpawn = false
    
    -- Window Utama
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 300, 0, 350)
    Window.Position = UDim2.new(0.05, 0, 0.3, 0) -- Pojok kiri
    Window.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Window.BorderSizePixel = 2
    Window.BorderColor3 = Color3.fromRGB(0, 150, 200)
    
    -- Title Bar (BISA DI-DRAG)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
    
    local Judul = Instance.new("TextLabel")
    Judul.Text = "GARXCUY HUB - GET FISH"
    Judul.Size = UDim2.new(1, -40, 1, 0)
    Judul.BackgroundTransparency = 1
    Judul.TextColor3 = Color3.new(1,1,1)
    Judul.Font = Enum.Font.GothamBold
    
    -- TOMBOL CLOSE (100% BISA)
    local TombolClose = Instance.new("TextButton")
    TombolClose.Text = "X"
    TombolClose.Size = UDim2.new(0, 35, 0, 35)
    TombolClose.Position = UDim2.new(1, -35, 0, 0)
    TombolClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    TombolClose.TextColor3 = Color3.new(1,1,1)
    TombolClose.Font = Enum.Font.GothamBold
    
    TombolClose.MouseButton1Click:Connect(function()
        print("Menutup GUI...")
        LayarGUI:Destroy()
        -- Hentikan semua fitur
        Status.AutoLempar = false
        Status.TangkapInstan = false
        Status.Terbang = false
        Status.JualOtomatis = false
        print("✅ GUI ditutup, semua fitur dihentikan.")
    end)
    
    -- Container Tombol
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -50)
    Container.Position = UDim2.new(0, 5, 0, 40)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 5
    Container.CanvasSize = UDim2.new(0, 0, 0, 400)
    
    -- Fungsi buat tombol toggle
    local function BuatToggle(nama, yPosisi, fungsiAktif, fungsiMati)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.Position = UDim2.new(0, 5, 0, yPosisi)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        local label = Instance.new("TextLabel")
        label.Text = "  " .. nama
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(0.9,0.9,0.9)
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local tombol = Instance.new("TextButton")
        tombol.Text = "OFF"
        tombol.Size = UDim2.new(0, 70, 0, 25)
        tombol.Position = UDim2.new(1, -75, 0.5, -12.5)
        tombol.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        tombol.TextColor3 = Color3.new(1,1,1)
        tombol.Font = Enum.Font.GothamBold
        
        tombol.MouseButton1Click:Connect(function()
            if tombol.Text == "OFF" then
                tombol.Text = "ON"
                tombol.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                fungsiAktif()
            else
                tombol.Text = "OFF"
                tombol.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
                fungsiMati()
            end
        end)
        
        label.Parent = frame
        tombol.Parent = frame
        frame.Parent = Container
        
        return tombol
    end
    
    -- Buat semua tombol toggle
    local yPosisi = 10
    BuatToggle("AUTO LEMPAR", yPosisi, MulaiAutoLempar, HentikanAutoLempar)
    
    yPosisi = yPosisi + 50
    BuatToggle("TANGKAP INSTAN", yPosisi, MulaiTangkapInstan, function()
        Status.TangkapInstan = false
    end)
    
    yPosisi = yPosisi + 50
    BuatToggle("MODE TERBANG", yPosisi, AktifkanTerbang, function()
        Status.Terbang = false
        if Karakter and Karakter:FindFirstChild("Humanoid") then
            Karakter.Humanoid.Gravity = 196.2 -- Default Roblox
            Karakter.Humanoid.WalkSpeed = 16
        end
    end)
    
    yPosisi = yPosisi + 50
    BuatToggle("AUTO JUAL", yPosisi, MulaiAutoJual, function()
        Status.JualOtomatis = false
    end)
    
    -- Tombol SEMUA AKTIF
    local tombolAktifkanSemua = Instance.new("TextButton")
    tombolAktifkanSemua.Text = "🚀 AKTIFKAN SEMUA"
    tombolAktifkanSemua.Size = UDim2.new(1, -20, 0, 40)
    tombolAktifkanSemua.Position = UDim2.new(0, 10, 0, yPosisi + 60)
    tombolAktifkanSemua.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    tombolAktifkanSemua.TextColor3 = Color3.new(1,1,1)
    tombolAktifkanSemua.Font = Enum.Font.GothamBold
    
    tombolAktifkanSemua.MouseButton1Click:Connect(function()
        print("Mengaktifkan SEMUA fitur...")
        MulaiAutoLempar()
        MulaiTangkapInstan()
        AktifkanTerbang()
        MulaiAutoJual()
        
        -- Update tombol UI
        for _, anak in pairs(Container:GetChildren()) do
            if anak:IsA("Frame") then
                local tombolToggle = anak:FindFirstChildOfClass("TextButton")
                if tombolToggle then
                    tombolToggle.Text = "ON"
                    tombolToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                end
            end
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Garxcuy Hub",
            Text = "Semua fitur AKTIF!",
            Duration = 3
        })
    end)
    
    -- Assembly GUI
    Judul.Parent = TitleBar
    TombolClose.Parent = TitleBar
    TitleBar.Parent = Window
    tombolAktifkanSemua.Parent = Container
    Container.Parent = Window
    Window.Parent = LayarGUI
    LayarGUI.Parent = game:GetService("CoreGui")
    
    print("✅ GUI berhasil dibuat!")
    return LayarGUI
end

-- 🚀 INISIALISASI SCRIPT
task.wait(1) -- Tunggu game load
local GUI = BuatGUI()

-- Hotkey F9 untuk toggle GUI
game:GetService("UserInputService").InputBegan:Connect(function(input, diproses)
    if not diproses and input.KeyCode == Enum.KeyCode.F9 then
        if GUI and GUI.Parent then
            GUI:Destroy()
            print("GUI disembunyikan (F9 untuk tampilkan)")
        else
            GUI = BuatGUI()
        end
    end
end)

-- Notifikasi sukses
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GARXCUY HUB ULTIMATE",
    Text = "Script berhasil dijalankan!\nF9: Toggle GUI",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

print("=================================")
print("GARXCUY HUB ULTIMATE READY")
print("Fitur: Auto Fish, Instan Catch, Fly")
print("Hotkey: F9 (Toggle GUI)")
print("=================================")
