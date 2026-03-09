-- 🔥 EYE GPT PAUSUS BANANANITA RAYFIELD V2 | Auto Detect AI + Slap Any 🔥
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Pausus Slap Hub",
    LoadingTitle = "Scanning AI Targets...",
    LoadingSubtitle = "GigaChad & Doge Killer",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- Tab Exploits
local ExploitsTab = Window:CreateTab("Exploits", 7733774602)

ExploitsTab:CreateLabel("Pauses Banananita - Slap AI MAX Power!")
ExploitsTab:CreateLabel("Auto detect semua AI di SlapTablesAI")

local powerValue = 100
ExploitsTab:CreateSlider({
    Name = "Power Level (100 - 1e9)",
    Range = {100, 1000000000},
    Increment = 100000,
    CurrentValue = 100,
    Callback = function(Value)
        powerValue = Value
    end,
})

-- Dropdown Target AI (auto fill nanti)
local aiTargets = {"Doge", "GigaChad"}  -- Default, nanti di-update
local selectedTarget = "GigaChad"

local targetDropdown = ExploitsTab:CreateDropdown({
    Name = "Select AI Target",
    Options = aiTargets,
    CurrentOption = selectedTarget,
    Callback = function(Option)
        selectedTarget = Option
    end,
})

-- Button Scan AI Characters
ExploitsTab:CreateButton({
    Name = "Scan All AI Targets",
    Callback = function()
        local newOptions = {}
        pcall(function()
            local slapFolder = workspace.Worlds.World1.SlapTablesAI
            if slapFolder then
                for _, ai in pairs(slapFolder:GetChildren()) do
                    if ai:FindFirstChild("Character") and ai.Character:IsA("Model") then
                        table.insert(newOptions, ai.Name)
                    end
                end
                if #newOptions > 0 then
                    targetDropdown:Refresh(newOptions)
                    Rayfield:Notify({Title = "Scan Done", Content = #newOptions .. " AI ditemukan!", Duration = 4})
                else
                    Rayfield:Notify({Title = "Scan Failed", Content = "Gak nemu AI di SlapTablesAI", Duration = 4})
                end
            else
                Rayfield:Notify({Title = "Path Error", Content = "workspace.Worlds.World1.SlapTablesAI gak ada", Duration = 4})
            end
        end)
    end,
})

-- Button Slap Selected
ExploitsTab:CreateButton({
    Name = "Slap Selected AI",
    Callback = function()
        pcall(function()
            local slapFolder = workspace.Worlds.World1.SlapTablesAI
            local targetAI = slapFolder:FindFirstChild(selectedTarget)
            if targetAI and targetAI:FindFirstChild("Character") then
                local args = {
                    [3] = targetAI.Character
                }
                game:GetService("ReplicatedStorage").Remotes.Animation:FireServer(unpack(args))
                Rayfield:Notify({Title = "Slap Sent", Content = selectedTarget .. " kena slap!", Duration = 2})
            else
                Rayfield:Notify({Title = "Target Not Found", Content = selectedTarget .. " gak ada / Character hilang", Duration = 3})
            end
        end)
    end,
})

-- Button Set Power
ExploitsTab:CreateButton({
    Name = "Set Power to Slider Value",
    Callback = function()
        pcall(function()
            local args = {
                [1] = powerValue,
                [2] = nil
            }
            game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(args))
            Rayfield:Notify({Title = "Power Updated", Content = "Power sekarang " .. powerValue, Duration = 2})
        end)
    end,
})

-- Toggle Auto Slap + Power
local autoEnabled = false
ExploitsTab:CreateToggle({
    Name = "Auto Slap + Power MAX",
    CurrentValue = false,
    Callback = function(Value)
        autoEnabled = Value
        if Value then
            spawn(function()
                while autoEnabled do
                    pcall(function()
                        -- Slap
                        local slapFolder = workspace.Worlds.World1.SlapTablesAI
                        local target = slapFolder:FindFirstChild(selectedTarget)
                        if target and target.Character then
                            local argsSlap = {[3] = target.Character}
                            game:GetService("ReplicatedStorage").Remotes.Animation:FireServer(unpack(argsSlap))
                        end
                        -- Power
                        local argsPower = {[1] = powerValue, [2] = nil}
                        game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(argsPower))
                    end)
                    wait(0.15)  -- Anti lag/detect
                end
            end)
            Rayfield:Notify({Title = "Auto Started", Content = "Spam slap " .. selectedTarget .. " + power " .. powerValue, Duration = 4})
        end
    end,
})

Rayfield:Notify({
    Title = "Hub Loaded",
    Content = "Klik 'Scan All AI Targets' dulu biar dropdown update! Gas slap GigaChad sampe server nangis 😈",
    Duration = 6
})