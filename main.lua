-- ================= ANTI-AFK / ANTI-IDLE SYSTEM =================
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Koneksi Anti-Idle (Langsung Aktif)
if _G.AntiAFKConn then _G.AntiAFKConn:Disconnect() end
_G.AntiAFKConn = LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("BE A LUCKY BLOCK - RHDXP Hub", "Midnight")

-- ================= VARIABEL KONTROL & SERVICE =================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local moneyCollected = 0
_G.AutoCollect = false
_G.AutoFarm = false
_G.AutoEventShop = false
_G.AutoClaimSpecial = false
local questRunning = false
_G.AutoCollectEgg = false

-- Knit Remotes
local knitServices = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services")
local runningRF = knitServices:WaitForChild("RunningService"):WaitForChild("RF")
local eventRF = knitServices:WaitForChild("EventService"):WaitForChild("RF")
local playerRF = knitServices:WaitForChild("PlayerService"):WaitForChild("RF")
local upgradeRemote = knitServices:WaitForChild("ContainerService"):WaitForChild("RF"):WaitForChild("UpgradeBrainrot")

-- Data Priority Event
local priorityEvents = {"ZEUS", "DEVIL", "DOJO", "MAGIA", "I2PERFECT", "ALIEN", "INK", "CIRCUS"}

local function getBestTarget()
    local collectZones = workspace:WaitForChild("CollectZones")
    for _, eventName in ipairs(priorityEvents) do
        local eventZone = collectZones:FindFirstChild(eventName)
        if eventZone then return eventZone end
    end
    return collectZones:FindFirstChild("base15")
end

-- ================= PAGE: MAIN =================
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Automation")
local StatsLabel = MainSection:NewLabel("Total Collect: 0")

local function updateCounter()
    moneyCollected = moneyCollected + 1
    StatsLabel:UpdateLabel("Total Collect: " .. tostring(moneyCollected))
end

MainSection:NewToggle("Auto Collect Money", "Collects from all 30 plots", function(state)
    _G.AutoCollect = state
    if state then
        task.spawn(function()
            while _G.AutoCollect do
                pcall(function()
                    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        for _, plot in pairs(workspace.Plots:GetChildren()) do
                            for _, obj in pairs(plot:GetDescendants()) do
                                if obj.Name == "CollectionPad" and obj:IsA("BasePart") then
                                    firetouchinterest(rootPart, obj, 0)
                                    task.wait()
                                    firetouchinterest(rootPart, obj, 1)
                                end
                            end
                        end
                        updateCounter()
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

MainSection:NewToggle("Auto Farm Best Brainrot Base15", "Priority: Event > Base15", function(state)
    _G.AutoFarm = state
    if state then
        task.spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    local player = LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    local humanoid = character:WaitForChild("Humanoid")
                    local modelsFolder = workspace:WaitForChild("RunningModels")
                    local target = getBestTarget()
                    
                    if not target then task.wait(1) return end
                    
                    root.CFrame = CFrame.new(715, 39, -2122)
                    task.wait(0.3)
                    humanoid:MoveTo(Vector3.new(710, 39, -2122))
                    
                    local ownedModel = nil
                    local timeout = 0
                    repeat
                        task.wait(0.3)
                        timeout = timeout + 1
                        for _, obj in ipairs(modelsFolder:GetChildren()) do
                            if obj:IsA("Model") and obj:GetAttribute("OwnerId") == player.UserId then
                                ownedModel = obj; break
                            end
                        end
                    until ownedModel ~= nil or not _G.AutoFarm or timeout > 20
                    
                    if not _G.AutoFarm or not ownedModel then return end
                    
                    if ownedModel.PrimaryPart then 
                        ownedModel:SetPrimaryPartCFrame(target.CFrame)
                    else 
                        local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                        if part then part.CFrame = target.CFrame end
                    end
                    
                    task.wait(0.5)
                    
                    if ownedModel and ownedModel.Parent == modelsFolder then
                        if ownedModel.PrimaryPart then 
                            ownedModel:SetPrimaryPartCFrame(target.CFrame * CFrame.new(0, -5, 0))
                        else 
                            local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                            if part then part.CFrame = target.CFrame * CFrame.new(0, -5, 0) end
                        end
                    end
                    
                    repeat task.wait(0.5) until not _G.AutoFarm or (ownedModel == nil or ownedModel.Parent ~= modelsFolder)
                    
                    if not _G.AutoFarm then return end
                    
                    local oldCharacter = player.Character
                    repeat task.wait(0.2) until not _G.AutoFarm or (player.Character ~= oldCharacter and player.Character ~= nil)
                    
                    task.wait(0.5)
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(737, 39, -2118)
                    end
                end)
                task.wait(1.5)
            end
        end)
    end
end)

-- ================= PAGE: EVENT =================
local EventPage = Window:NewTab("Events")
local EventSection = EventPage:NewSection("Event Management")

EventSection:NewToggle("Auto Buy Event Shop", "Otomatis beli item dari Event Shop", function(state)
    _G.AutoEventShop = state
    if state then
        task.spawn(function()
            while _G.AutoEventShop do
                local shopRemote = ReplicatedStorage:FindFirstChild("EventShopRemote", true)
                if shopRemote then shopRemote:InvokeServer("BuyAll") end
                task.wait(10)
            end
        end)
    end
end)

EventSection:NewToggle("Auto Claim Special Rewards", "Claim reward dari Special Event", function(state)
    _G.AutoClaimSpecial = state
    if state then
        task.spawn(function()
            while _G.AutoClaimSpecial do
                local specialRemote = ReplicatedStorage:FindFirstChild("SpecialEventRemote", true)
                if specialRemote then specialRemote:FireServer("Claim") end
                task.wait(30)
            end
        end)
    end
end)

-- ================= PAGE: QUESTS =================
local QuestTab = Window:NewTab("Quests")
local QuestSection = QuestTab:NewSection("BP Quest Automation")

-- ================= PAGE: EVENT EGGS =================
local EggTab = Window:NewTab("Event Eggs")
local EggSection = EggTab:NewSection("Auto Cycle Egg")

EggSection:NewToggle("Auto Collect Eggs", "Start Run -> Collect 10x -> Reload", function(state)
    _G.AutoCollectEgg = state
    if state then
        task.spawn(function()
            while _G.AutoCollectEgg do
                pcall(function()
                    runningRF.StartRun:InvokeServer()
                    runningRF.StartMove:InvokeServer()
                    for i = 1, 10 do
                        if not _G.AutoCollectEgg then break end
                        eventRF.CollectEgg:InvokeServer()
                        --task.wait(0.01)
                    end
                    runningRF.Collected:InvokeServer("10063799191")
                    task.wait(0.000001)
                    playerRF.ReloadCharacter:InvokeServer()
                end)
                LocalPlayer.CharacterAdded:Wait()
                --task.wait(0.1)
            end
        end)
    end
end)

-- ================= PAGE: SETTINGS =================
local Settings = Window:NewTab("Settings")
local SettingsSection = Settings:NewSection("UI Settings")

-- Tambahan Feature Anti AFK Toggle
SettingsSection:NewToggle("Anti-AFK System", "Mencegah Kick dari server saat idle", function(state)
    if state then
        if _G.AntiAFKConn then _G.AntiAFKConn:Disconnect() end
        _G.AntiAFKConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if _G.AntiAFKConn then 
            _G.AntiAFKConn:Disconnect() 
            _G.AntiAFKConn = nil
        end
    end
end)

SettingsSection:NewKeybind("Toggle UI", "RightControl to Hide/Show", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

SettingsSection:NewButton("Destroy Script", "Safety Exit", function()
    _G.AutoCollect = false
    _G.AutoFarm = false
    _G.AutoEventShop = false
    _G.AutoClaimSpecial = false
    _G.AutoCollectEgg = false
    questRunning = false
    if _G.AntiAFKConn then _G.AntiAFKConn:Disconnect() end
    Library:Destroy()
end)
