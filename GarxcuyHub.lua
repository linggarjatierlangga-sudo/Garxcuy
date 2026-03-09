-- 🔥 EYE GPT PAUSES BANANANITA HUB + INFINITY YIELD 🔥
-- Slap AI, Power Barbel, & Admin Tools (Infinity Yield)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Pauses Hub + IY",
    LoadingTitle = "Loading Full Power...",
    LoadingSubtitle = "Slap + Barbel + Admin",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- Tab 1: Slap AI
local SlapTab = Window:CreateTab("Slap AI", 7733774602)

SlapTab:CreateLabel("Slap Ninja / BuffNoob / All AI")
local animID = "88479667457361"
SlapTab:CreateInput({
    Name = "Anim ID",
    PlaceholderText = "88479667457361",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        animID = Text
    end,
})

local selectedAI = "Ninja"
local aiDropdown = SlapTab:CreateDropdown({
    Name = "Select AI Target",
    Options = {"Ninja", "BuffNoob", "Doge", "GigaChad"},
    CurrentOption = {"Ninja"},
    Callback = function(Option)
        selectedAI = Option[1]
    end,
})

SlapTab:CreateButton({
    Name = "SCAN AI Targets",
    Callback = function()
        local newOptions = {}
        pcall(function()
            local slapFolder = workspace.Worlds and workspace.Worlds.World1 and workspace.Worlds.World1.SlapTablesAI
            if slapFolder then
                for _, ai in pairs(slapFolder:GetChildren()) do
                    if ai:FindFirstChild("Character") then
                        table.insert(newOptions, ai.Name)
                    end
                end
                if #newOptions > 0 then
                    aiDropdown:Refresh(newOptions)
                    Rayfield:Notify({Title = "Scan OK", Content = #newOptions .. " AI ditemukan!", Duration = 4})
                end
            end
        end)
    end,
})

SlapTab:CreateButton({
    Name = "Slap Mode 1 (Anim ID + Char)",
    Callback = function()
        pcall(function()
            local slapFolder = workspace.Worlds.World1.SlapTablesAI
            local target = slapFolder:FindFirstChild(selectedAI)
            if target and target.Character then
                local args = {
                    [1] = tonumber(animID) or 88479667457361,
                    [3] = target.Character
                }
                game:GetService("ReplicatedStorage").Remotes.Animation:FireServer(unpack(args))
            end
        end)
    end,
})

SlapTab:CreateButton({
    Name = "Slap Mode 2 (Char Only)",
    Callback = function()
        pcall(function()
            local slapFolder = workspace.Worlds.World1.SlapTablesAI
            local target = slapFolder:FindFirstChild(selectedAI)
            if target and target.Character then
                local args = {
                    [2] = target.Character
                }
                game:GetService("ReplicatedStorage").Remotes.Animation:FireServer(unpack(args))
            end
        end)
    end,
})

-- Tab 2: Power Barbel
local PowerTab = Window:CreateTab("Power Barbel", 4483362458)

local powerValue = 100
PowerTab:CreateSlider({
    Name = "Power Value",
    Range = {100, 1000000000},
    Increment = 100000,
    CurrentValue = 100,
    Callback = function(Value)
        powerValue = Value
    end,
})

PowerTab:CreateButton({
    Name = "Boost Power Barbel",
    Callback = function()
        pcall(function()
            local args = {
                [1] = powerValue,
                [2] = nil
            }
            game:GetService("ReplicatedStorage").Remotes.Power:FireServer(unpack(args))
        end)
    end,
})

-- Tab 3: Admin Tools (Infinity Yield)
local AdminTab = Window:CreateTab("Admin Tools", 4483345998)

AdminTab:CreateLabel("Infinity Yield Admin Panel")
AdminTab:CreateLabel("Load IY buat command god-tier (fly, noclip, speed, dll)")
AdminTab:CreateLabel("Setelah load, tekan ; buat buka command bar")

AdminTab:CreateButton({
    Name = "Load Infinity Yield",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            Rayfield:Notify({
                Title = "Infinity Yield Loaded",
                Content = "Tekan ; buat open command bar! Coba ;fly, ;noclip, ;god, ;speed 100",
                Duration = 6
            })
        end)
    end,
})

AdminTab:CreateLabel("Command berguna:")
AdminTab:CreateLabel(";fly - terbang")
AdminTab:CreateLabel(";noclip - tembus tembok")
AdminTab:CreateLabel(";god - immortal")
AdminTab:CreateLabel(";speed 500 - lari cepet")
AdminTab:CreateLabel(";tp playername - teleport ke player/AI")

Rayfield:Notify({
    Title = "Hub + IY Loaded",
    Content = "SCAN AI dulu → slap target → boost power barbel → load IY buat god mode!",
    Duration = 6
})