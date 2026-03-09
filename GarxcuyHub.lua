-- 🔥 EYE GPT UNIVERSAL AUTO REMOTE LOGGER 2026 | Plug & Play - No Setup Needed 🔥
-- Spy semua remote di SEMUA GAME | UI Rayfield | Auto hook | Auto dump

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()
end)

if not success or not Rayfield then
    warn("Rayfield gagal load. Logger tetep jalan tapi tanpa UI fancy. Cek F9 aja.")
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Buffer log
local logBuffer = {}
local maxLines = 200

local function addLog(msg)
    table.insert(logBuffer, os.date("%H:%M:%S") .. " | " .. msg)
    if #logBuffer > maxLines then table.remove(logBuffer, 1) end
    print(msg)  -- Backup ke console
end

-- Hook __namecall (universal, auto jalan)
local hooked = false
local function hookNamecall()
    if hooked then return end
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" or method == "InvokeServer" then
            if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
                local remotePath = self:GetFullName()
                local argJson = HttpService:JSONEncode(args)
                addLog("[" .. method .. "] " .. remotePath .. " | Args: " .. argJson)
            end
        end
        
        -- Auto block kick kalau ada
        if method == "Kick" and self == player then
            addLog("[AUTO BLOCK] Kick attempt: " .. tostring(args[1] or "No reason"))
            return
        end
        
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    
    hooked = true
    addLog("Auto hook __namecall SUCCESS - Spy aktif universal!")
end

-- Auto hook pas load
spawn(function()
    wait(1) -- Tunggu Roblox load
    hookNamecall()
end)

-- Auto dump remotes di awal (universal)
spawn(function()
    wait(3)
    addLog("Auto dumping all remotes di game ini...")
    local count = 0
    local paths = {}
    
    local function scan(parent, prefix)
        for _, obj in pairs(parent:GetChildren()) do
            local full = prefix .. obj.Name
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                table.insert(paths, full)
                count = count + 1
            end
            scan(obj, full .. ".")
        end
    end
    
    scan(game:GetService("ReplicatedStorage"), "ReplicatedStorage.")
    scan(player:WaitForChild("PlayerGui"), "PlayerGui.")
    
    addLog("Ditemukan " .. count .. " remote:")
    for _, p in ipairs(paths) do
        addLog("→ " .. p)
    end
    addLog("Dump selesai. Main game aja, log spy bakal muncul otomatis!")
end)

-- ===== UI (kalau Rayfield load sukses) =====
if Rayfield then
    local Window = Rayfield:CreateWindow({
        Name = "Eye GPT Auto Logger",
        LoadingTitle = "Auto Spy Loading...",
        LoadingSubtitle = "No hook manual needed",
        ConfigurationSaving = {Enabled = false},
        KeySystem = false
    })
    
    local MainTab = Window:CreateTab("Logger", 4483362458)
    
    local LogDisplay = MainTab:CreateTextbox({
        Name = "Live Logs",
        PlaceholderText = "Semua remote call muncul di sini otomatis...",
        RemoveTextAfterFocusLost = false,
        Callback = function() end
    })
    LogDisplay:SetEditable(false)
    
    MainTab:CreateButton({
        Name = "Clear Log",
        Callback = function()
            logBuffer = {}
            LogDisplay:SetText("")
            addLog("Log dibersihkan")
        end
    })
    
    MainTab:CreateButton({
        Name = "Copy All Log",
        Callback = function()
            setclipboard(table.concat(logBuffer, "\n"))
            Rayfield:Notify({Title = "Copied", Content = "Semua log dicopy ke clipboard!", Duration = 4})
        end
    })
    
    -- Auto update UI setiap 0.5 detik
    spawn(function()
        while wait(0.5) do
            if #logBuffer > 0 then
                LogDisplay:SetText(table.concat(logBuffer, "\n"))
            end
        end
    end)
    
    addLog("UI Rayfield loaded - cek tab Logger buat live view!")
else
    addLog("UI Rayfield gagal, tapi spy tetep jalan. Cek console F9 aja bro.")
end

-- Final message
addLog("UNIVERSAL AUTO LOGGER READY!")
addLog("Gak perlu hook manual lagi. Main game aja (cast, sell, apa pun), log muncul sendiri.")
addLog("Kalau masih kosong, berarti game ini gak pake RemoteEvent standard (jarang banget). Spill game-nya, gue bantu alternatif.")