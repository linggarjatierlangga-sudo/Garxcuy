-- 🔥 EYE GPT ROBLOX REMOTE LOGGER + UI v2.0 | Delta Compatible 🔥
-- Spy remotes + UI Rayfield | Block kick | Log real-time

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Load Rayfield UI (library stabil 2026)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window UI
local Window = Rayfield:CreateWindow({
    Name = "Eye GPT Remote Logger",
    LoadingTitle = "Logger Activated",
    LoadingSubtitle = "Spying remotes for " .. player.Name,
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Tab utama
local LoggerTab = Window:CreateTab("Logger", 4483362458) -- icon logger

-- Status label
local StatusLabel = LoggerTab:CreateLabel("Logger Status: Active | Waiting for remote calls...")

-- Log Box (scrollable textbox)
local LogBox = LoggerTab:CreateTextbox({
    Name = "Live Log",
    PlaceholderText = "All remote calls will appear here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) end
})
LogBox:SetEditable(false) -- read-only

-- Log buffer (biar gak overload UI)
local logBuffer = {}
local maxLines = 200

local function addLog(msg)
    table.insert(logBuffer, os.date("%H:%M:%S") .. " | " .. msg)
    if #logBuffer > maxLines then
        table.remove(logBuffer, 1)
    end
    
    -- Update UI
    local displayText = table.concat(logBuffer, "\n")
    LogBox:SetText(displayText)
    
    -- Update status
    StatusLabel:Set("Logger Status: Active | Lines: " .. #logBuffer)
    
    -- Print ke console juga (backup)
    print(msg)
end

-- Toggle spy
local spyEnabled = true
LoggerTab:CreateToggle({
    Name = "Enable Remote Spy",
    CurrentValue = true,
    Callback = function(Value)
        spyEnabled = Value
        addLog("Remote Spy: " .. (Value and "ENABLED" or "DISABLED"))
    end
})

-- Toggle block kick
local blockKick = true
LoggerTab:CreateToggle({
    Name = "Block Kick Attempts",
    CurrentValue = true,
    Callback = function(Value)
        blockKick = Value
        addLog("Kick Blocker: " .. (Value and "ENABLED" or "DISABLED"))
    end
})

-- Button clear log
LoggerTab:CreateButton({
    Name = "Clear Log",
    Callback = function()
        logBuffer = {}
        LogBox:SetText("")
        addLog("Log cleared by user")
    end
})

-- Button copy log
LoggerTab:CreateButton({
    Name = "Copy All Log to Clipboard",
    Callback = function()
        local fullLog = table.concat(logBuffer, "\n")
        setclipboard(fullLog)
        Rayfield:Notify({
            Title = "Logger",
            Content = "All logs copied to clipboard!",
            Duration = 3
        })
    end
})

-- HOOK NAMECALL (spy + block kick)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if spyEnabled and (method == "FireServer" or method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        local remoteName = self:GetFullName()
        local argStr = HttpService:JSONEncode(args)
        local callType = (method == "InvokeServer") and "InvokeServer" or "FireServer"
        
        addLog("[" .. callType .. "] " .. remoteName .. " | Args: " .. argStr)
    end
    
    if blockKick and method == "Kick" and self == player then
        addLog("[BLOCKED KICK] Attempted kick: " .. tostring(args[1] or "No reason"))
        return -- block kick
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Initial log
addLog("Logger + UI Activated by Eye GPT")
addLog("Spying all remote calls | Press F9 for backup console log")
addLog("Game: " .. game.PlaceId .. " | Player: " .. player.Name)

-- Optional: Dump remotes awal
spawn(function()
    addLog("Scanning remotes...")
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            count = count + 1
        end
    end
    addLog("Found " .. count .. " remotes in game")
end)

Rayfield:Notify({
    Title = "Logger Ready",
    Content = "UI loaded! Check tab Logger for live remote spy.",
    Duration = 5
})