-- 🔥 EYE GPT PAUSUS BANANANITA POWER BARBEL BOOST 🔥
-- Fokus remote Power: [1] = value, [2] = nil
-- Delta / Executor compatible

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Power Barbel Hub",
    LoadingTitle = "Loading Power Boost...",
    LoadingSubtitle = "Angkat Barbel MAX 1e9",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local PowerTab = Window:CreateTab("Power Boost", 4483362458)

PowerTab:CreateLabel("Pauses Banananita - Power Angkat Barbel")
PowerTab:CreateLabel("Ubah power dari 100 sampe 1.000.000.000")

local powerValue = 100

PowerTab:CreateSlider({
    Name = "Power Value",
    Range = {100, 1000000000},
    Increment = 10000,
    Suffix = "",
    CurrentValue = 100,
    Flag = "PowerSlider",
    Callback = function(Value)
        powerValue = Value
        Rayfield:Notify({
            Title = "Power Updated",
            Content = "Value sekarang: " .. Value,
            Duration = 2.5
        })
    end,
})

PowerTab:CreateButton({
    Name = "Set Power Sekarang",
    Callback = function()
        pcall(function()
            local args = {
                [1] = powerValue,
                [2] = nil
            }
            game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(args))
            Rayfield:Notify({
                Title = "Power Fired",
                Content = "Boost " .. powerValue .. " dikirim!",
                Duration = 3
            })
        end)
    end,
})

local autoBoost = false
PowerTab:CreateToggle({
    Name = "Auto Boost Power (Spam)",
    CurrentValue = false,
    Callback = function(Value)
        autoBoost = Value
        if Value then
            spawn(function()
                while autoBoost do
                    pcall(function()
                        local args = {
                            [1] = powerValue,
                            [2] = nil
                        }
                        game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(args))
                    end)
                    wait(0.08)  -- Cepet tapi aman, jangan terlalu 0 biar gak kick
                end
            end)
            Rayfield:Notify({
                Title = "Auto Boost ON",
                Content = "Spam power " .. powerValue .. " setiap detik!",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Auto Boost OFF",
                Content = "Spam dihentikan",
                Duration = 3
            })
        end
    end,
})

PowerTab:CreateButton({
    Name = "Set MAX Power (1e9)",
    Callback = function()
        powerValue = 1000000000
        pcall(function()
            local args = {
                [1] = 1000000000,
                [2] = nil
            }
            game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(args))
        end)
        Rayfield:Notify({
            Title = "MAX POWER!",
            Content = "Power di-set ke 1.000.000.000",
            Duration = 3
        })
    end,
})

PowerTab:CreateButton({
    Name = "Dump Remotes (Cek Nama)",
    Callback = function()
        print("=== REMOTES DUMP ===")
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                print(obj:GetFullName())
            end
        end
        Rayfield:Notify({Title = "Dump Done", Content = "Cek console F9 buat list remote!", Duration = 3})
    end,
})

Rayfield:Notify({
    Title = "Power Hub Loaded",
    Content = "Angkat barbel lo sekarang MAX! Toggle Auto kalau mau infinite power.",
    Duration = 5
})