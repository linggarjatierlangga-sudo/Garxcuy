-- GET FISH - INSTANT CATCH ULTIMATE SCRIPT
-- By ShadowX
local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cari RemoteEvent fishing
local FishingRemote
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name:lower():find("fish") or v.Name:lower():find("cast") or v.Name:lower():find("reel")) then
        FishingRemote = v
        break
    end
end

if not FishingRemote then
    warn("[⚠️] RemoteEvent tidak ditemukan, scanning seluruh game...")
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name == "FishingEvent" then
            FishingRemote = v
            break
        end
    end
end

if FishingRemote then
    print("[✅] Fishing Remote ditemukan:", FishingRemote:GetFullName())

    -- ==================== INSTANT CATCH LOOP ====================
    local active = false
    spawn(function()
        while true do
            if active then
                pcall(function()
                    -- CAST
                    FishingRemote:FireServer("Cast", {Position = Vector3.new(0, 0, 0)})
                    -- INSTANT REEL (NO WAIT)
                    FishingRemote:FireServer("Reel")
                    -- Optional: kasih delay mikro buat hindari kick
                    task.wait(0.1)
                end)
            else
                task.wait(0.5)
            end
        end
    end)

    -- ==================== GUI KONTROL ====================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 250, 0, 150)
    MainFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Text = "GET FISH - INSTANT CATCH"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = MainFrame
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    ToggleBtn.Text = "START INSTANT CATCH"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        ToggleBtn.Text = active and "STOP [ON]" or "START INSTANT CATCH"
        ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(0, 180, 0)
        print("[🎣] Instant Catch:", active and "AKTIF" or "NONAKTIF")
    end)

    -- ==================== TELEPORT KE IKAN ====================
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Parent = MainFrame
    TeleportBtn.Size = UDim2.new(0.8, 0, 0, 30)
    TeleportBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    TeleportBtn.Text = "TELEPORT TO FISH"
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

    TeleportBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local fish = workspace:FindFirstChild("Fish") or workspace:FindFirstChild("Fishes")
            if fish then
                for _, f in pairs(fish:GetChildren()) do
                    if f:IsA("Model") and f.PrimaryPart then
                        Player.Character:MoveTo(f.PrimaryPart.Position + Vector3.new(0, 5, 0))
                        print("[🐟] Teleport ke ikan!")
                        break
                    end
                end
            end
        end)
    end)

    -- ==================== KEYBINDS ====================
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            active = not active
            ToggleBtn.Text = active and "STOP [ON]" or "START INSTANT CATCH"
            ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(0, 180, 0)
        elseif input.KeyCode == Enum.KeyCode.Insert then
            -- Auto farm mode: cast, instant reel, langsung ulang
            for i = 1, 50 do
                pcall(function()
                    FishingRemote:FireServer("Cast")
                    task.wait(0.05)
                    FishingRemote:FireServer("Reel")
                end)
                task.wait(0.1)
            end
            print("[⚡] Auto Farm 50x selesai!")
        end
    end)

    print("[✅] Script Instant Catch siap! Tekan RightShift untuk toggle.")
    print("[✅] Klik 'TELEPORT TO FISH' untuk cari ikan.")
    print("[✅] Tekan Insert untuk auto farm 50x cepat.")
else
    warn("[❌] GAGAL: RemoteEvent fishing tidak terdeteksi.")
    warn("[💡] Coba cek struktur game dengan perintah ini di executor:")
    print([[
        for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v:IsA("RemoteEvent") then
                print(v.Name, v:GetFullName())
            end
        end
    ]])
end
