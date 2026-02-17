-- ===== AUTO FISH (Perbaikan) =====
local AutoFishTab = Window:MakeTab({Name = "AUTO FISH", Icon = "rbxassetid://4483345998"})

-- Ambil remote (sudah dari script lo)
local Fishing_RemoteThrow = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local Fishing_RemoteRetract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
local ThrowState = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_ThrowState")
local Fishing_RemoteParked = ReplicatedStorage:FindFirstChild("Fishing_RemoteParked")
local Fishing_RemoteReset = ReplicatedStorage:FindFirstChild("Fishing_RemoteReset")
local MinigameStart = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameStart")
local MinigameEnd = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_MinigameEnd")
local StartMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StartMeter")
local StopMeter = ReplicatedStorage:FindFirstChild("FishingRod_9883448335_7441d396-e015-4ea6-993f-757ca7d42bbb_StopMeter")

-- Variabel state
local currentState = "IDLE"
local autoFishing = false
local fishTask = nil

-- Listener untuk ThrowState
if ThrowState then
    ThrowState.Event:Connect(function(newState)
        currentState = newState
        print("[ThrowState]", newState)
    end)
end

-- Fungsi utama auto fishing (dijalankan di coroutine)
local function autoFishLoop()
    while autoFishing do
        -- Pastikan pancing masih di-equip
        local rod = nil
        if LocalPlayer.Character then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
                    rod = tool
                    break
                end
            end
        end
        if not rod then
            OrionLib:MakeNotification({Name="Auto Fish", Content="Equip pancing dulu!", Time=2})
            break
        end

        -- State machine
        if currentState == "IDLE" or currentState == "idle" then
            -- Cast pancing
            if Fishing_RemoteThrow then
                Fishing_RemoteThrow:FireServer()
                print("[Auto] Cast")
            end
            -- Tunggu sampai state berubah (misal jadi PARKED atau WAITING)
            local timeout = 0
            while autoFishing and currentState == "IDLE" and timeout < 10 do
                task.wait(0.5)
                timeout = timeout + 0.5
            end

        elseif currentState == "PARKED" or currentState == "WAITING" then
            -- Ikan sudah menggigit, saatnya reel
            -- Bisa coba Fishing_RemoteRetract atau FishingCatchSuccess
            if Fishing_RemoteRetract then
                Fishing_RemoteRetract:FireServer()
                print("[Auto] Reel")
            elseif FishingCatchSuccess then
                FishingCatchSuccess:FireServer()
            end
            -- Tunggu sebentar, lalu reset state (mungkin butuh Fishing_RemoteReset)
            task.wait(1)
            if Fishing_RemoteReset then
                Fishing_RemoteReset:FireServer()
            end
            -- Setelah reset, state akan kembali IDLE

        elseif currentState == "MINIGAME" then
            -- Masuk minigame, perlu menangani dengan cepat
            -- Bisa langsung panggil MinigameEnd (asumsi menang) atau lakukan sesuatu
            if MinigameEnd then
                MinigameEnd:FireServer()
                print("[Auto] Minigame ended")
            end
            task.wait(0.5)

        else
            -- State lain, tunggu
            task.wait(0.5)
        end
    end
end

-- Toggle Auto Fishing
AutoFishTab:AddToggle({
    Name = "🎣 Auto Fishing (State-Based)",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            -- Jalankan loop di coroutine terpisah
            task.spawn(function()
                autoFishLoop()
            end)
        else
            -- Hentikan loop (akan keluar karena while autoFishing)
        end
    end
})

-- Tombol test manual (seperti sebelumnya)
AutoFishTab:AddButton({ Name = "Test Throw", Callback = function() if Fishing_RemoteThrow then Fishing_RemoteThrow:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test Retract", Callback = function() if Fishing_RemoteRetract then Fishing_RemoteRetract:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test Parked", Callback = function() if Fishing_RemoteParked then Fishing_RemoteParked:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test Reset", Callback = function() if Fishing_RemoteReset then Fishing_RemoteReset:FireServer() end end })
AutoFishTab:AddButton({ Name = "Test MinigameEnd", Callback = function() if MinigameEnd then MinigameEnd:FireServer() end end })