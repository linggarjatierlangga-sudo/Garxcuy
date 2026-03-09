-- 🔥 EYE GPT PAUSUS BANANANITA RAYFIELD UI | Tab Exploits Baru | Delta 2026 🔥
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Pausus Borong UI",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = "Slap Doge MAX Power",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PaususHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Tab Lama (LocalPlayer, Settings, dll)
local LocalTab = Window:CreateTab("LocalPlayer", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483345998)

LocalTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

LocalTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

LocalTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        -- Infinite jump code di sini kalau mau
    end,
})

SettingsTab:CreateToggle({
    Name = "Dark Mode",
    CurrentValue = true,
    Callback = function(Value)
        -- Dark mode toggle
    end,
})

-- ===== TAB BARU: EXPLOITS (Pausus Banananita Slap + Power) =====
local ExploitsTab = Window:CreateTab("Exploits", 7733774602)  -- Icon bomb

ExploitsTab:CreateLabel("Pausus Banananita - Slap Doge MAX!")

local powerValue = 100  -- Default

ExploitsTab:CreateSlider({
    Name = "Power Level",
    Range = {100, 1000000000},
    Increment = 10000,
    CurrentValue = 100,
    Callback = function(Value)
        powerValue = Value
        Rayfield:Notify({
            Title = "Power Set",
            Content = "Power: " .. Value,
            Duration = 2.5,
        })
    end,
})

ExploitsTab:CreateButton({
    Name = "Slap Doge AI",
    Callback = function()
        pcall(function()
            local args = {
                [3] = workspace.Worlds.World1.SlapTablesAI.Doge.Character
            }
            game:GetService("ReplicatedStorage").Remotes.Animation:FireServer(unpack(args))
            Rayfield:Notify({
                Title = "Slap Sent",
                Content = "Doge kena slap!",
                Duration = 2,
            })
        end)
    end,
})

ExploitsTab:CreateButton({
    Name = "Set Power (Slider Value)",
    Callback = function()
        pcall(function()
            local args = {
                [1] = powerValue,
                [2] = nil  -- Color3
            }
            game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(args))
            Rayfield:Notify({
                Title = "Power Set",
                Content = "Power " .. powerValue .. " activated!",
                Duration = 2,
            })
        end)
    end,
})

local autoSpamEnabled = false
ExploitsTab:CreateToggle({
    Name = "Auto Slap + Power Spam",
    CurrentValue = false,
    Callback = function(Value)
        autoSpamEnabled = Value
        if Value then
            spawn(function()
                while autoSpamEnabled do
                    -- Slap
                    pcall(function()
                        local argsSlap = {[3] = workspace.Worlds.World1.SlapTablesAI.Doge.Character}
                        game:GetService("ReplicatedStorage").Remotes.Animation:FireServer(unpack(argsSlap))
                    end)
                    -- Power
                    pcall(function()
                        local argsPower = {[1] = powerValue, [2] = nil}
                        game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(argsPower))
                    end)
                    wait(0.1)  -- Jangan terlalu cepet biar gak detect
                end
            end)
            Rayfield:Notify({Title = "Auto ON", Content = "Spam slap + power MAX!", Duration = 3})
        end
    end,
})

ExploitsTab:CreateButton({
    Name = "Dump Remotes (SimpleSpy Style)",
    Callback = function()
        print("=== SIMPLESPY DUMP ===")
        for _, obj in pairs(game:GetService("ReplicatedStorage").Remotes:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                print(obj:GetFullName())
            end
        end
        Rayfield:Notify({Title = "Dump Done", Content = "Cek console F9!", Duration = 3})
    end,
})

Rayfield:Notify({
    Title = "Eye GPT Hub Loaded",
    Content = "Tab Exploits baru siap borong Doge! Gas pol anjing 😈",
    Duration = 6.5,
    Image = 4483362458
})