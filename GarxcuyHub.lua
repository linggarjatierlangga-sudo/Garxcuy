-- Ambil data tool dari ReplicatedStorage
local toolData = game:GetService("ReplicatedStorage"):FindFirstChild("ToolData")
if not toolData then
    warn("ToolData not found! Mungkin beda game.")
    toolData = {} -- fallback
else
    toolData = require(toolData) -- karena ToolData kemungkinan ModuleScript
end

-- ==================== TAB 3: TOOL DATABASE ====================
local ToolTab = Window:CreateTab("🔧 Tools", nil)
local ToolSection = ToolTab:CreateSection("Tool Database")

-- Sort tools by power descending
local sortedTools = {}
for name, data in pairs(toolData) do
    table.insert(sortedTools, {name = name, power = data.Power, cooldown = data.Cooldown})
end
table.sort(sortedTools, function(a, b) return a.power > b.power end)

-- Dropdown buat milih tool (opsional)
local toolNames = {}
for i, v in ipairs(sortedTools) do
    table.insert(toolNames, v.name)
end

local ToolDropdown = ToolTab:CreateDropdown({
    Name = "Pilih Tool",
    Options = toolNames,
    CurrentOption = {"Excaliboulder"},
    MultipleOptions = false,
    Callback = function(option)
        print("Tool dipilih:", option[1])
        -- Bisa dipake buat nampilin detail
    end,
})

-- Label buat nampilin top 5 tool terkuat
local top5 = "Top 5 Tools:\n"
for i = 1, math.min(5, #sortedTools) do
    top5 = top5 .. i .. ". " .. sortedTools[i].name .. " (Power: " .. sortedTools[i].power .. ")\n"
end

ToolTab:CreateLabel(top5)

-- Auto-equip tool terkuat dari inventory (kalo ada)
ToolTab:CreateButton({
    Name = "Auto-Equip Tool Terkuat",
    Callback = function()
        local backpack = player.Backpack
        local character = player.Character
        local highestPower = 0
        local bestTool = nil

        -- Cek di backpack
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and toolData[child.Name] then
                local power = toolData[child.Name].Power
                if power > highestPower then
                    highestPower = power
                    bestTool = child
                end
            end
        end

        -- Cek di tangan (character)
        if character then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") and toolData[child.Name] then
                    local power = toolData[child.Name].Power
                    if power > highestPower then
                        highestPower = power
                        bestTool = child
                    end
                end
            end
        end

        if bestTool then
            -- Pindahin tool ke tangan
            if bestTool.Parent == backpack then
                bestTool.Parent = character
            end
            Rayfield:Notify({
                Title = "Auto-Equip",
                Content = "Equipped: " .. bestTool.Name .. " (Power: " .. highestPower .. ")",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Auto-Equip",
                Content = "Tidak ada tool di inventory!",
                Duration = 2
            })
        end
    end,
})

-- (Opsional) Fitur override power lokal (cuma visual)
local OverrideToggle = ToolTab:CreateToggle({
    Name = "Override Power Visual (Client Only)",
    CurrentValue = false,
    Callback = function(value)
        if value then
            -- Loop semua tool dan ubah nilai Power di memory (local)
            -- TAPI hati-hati: ini cuma ngaruh ke tabel lokal, bukan ke server.
            -- Bisa dipake buat ngecoh tampilan info tool.
            for name, data in pairs(toolData) do
                data.Power = 999999 -- semua tool jadi power raksasa
            end
            Rayfield:Notify({Title="Visual Only", Content="Power semua tool diubah jadi 999999 (client-side)", Duration=3})
        else
            -- Reload data asli (perlu require ulang atau simpan backup)
            -- Sederhananya, kita reload dari ReplicatedStorage
            toolData = require(game:GetService("ReplicatedStorage").ToolData)
            Rayfield:Notify({Title="Visual Only", Content="Data tool dikembalikan ke asli", Duration=3})
        end
    end,
})