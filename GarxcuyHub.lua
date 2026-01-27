--------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
----------------------------------
local TeleportTab = Window:Tab(
    {
        Title = "Teleport",
        Icon  = "map"
    }
)
----------------------------------
local IslandLocations = {
    ["Sysyphus Lost Isle"] = CFrame.new(-3696.91, -135.07, -887.61) * CFrame.Angles(0.00, 0.35, -0.00)
 --   ["Fishermand Island"] = 
}

local function teleportToIsland(name)
    local cf = IslandLocations[name]
    if not cf then return end

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = cf
end

local IslandNames = {}

for name in pairs(IslandLocations) do
    table.insert(IslandNames, name)
end

table.sort(IslandNames)

local SelectedIsland = nil
---------------------------------------
TeleportTab:Section(
    {
        Title = "Island"
    }
)
---------------------------------------
TeleportTab:Dropdown(
    {
        Title = "Select Island",
        Values = IslandNames,
        Default = nil,
        Callback = function(opt)
            SelectedIsland = opt 
            if opt then
            end
        end
    }
)

TeleportTab:Button(
    {
        Title = "Teleport",
        Callback = function()
            if SelectedIsland and IslandLocations[SelectedIsland] then
                teleportToIsland(SelectedIsland)
            else
            end
        end
    }
)
