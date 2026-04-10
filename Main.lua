-- ==========================================================
-- MERGED ULTIMATE HUB (Delfi + Makal + Hyper)
-- ==========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variabile Globale
local flying = false
local noclip = false
local platformActive = false
local isMoving = false
local isActive = false
local promptTriggered = false
local flySpeed = 50
local floatSpeed = 14

-- ==========================================================
-- UI PRINCIPAL (Design Combinat)
-- ==========================================================

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "Ultimate_Merged_Hub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner", mainFrame)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(138, 43, 226)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "HYPER X DELFI MERGED"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- ==========================================================
-- FUNCȚII UTILITARE
-- ==========================================================

local function createButton(name, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        callback()
    end)
end

-- ==========================================================
-- MODUL: MOVEMENT & CHEATS (Delfi/Hyper)
-- ==========================================================

createButton("🏃 Ultra Speed (55)", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 55
    end
end)

createButton("🚀 Infinite Jump (Passive)", function()
    UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

createButton("👻 Toggle Noclip", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- ==========================================================
-- MODUL: AUTO-STEAL TWEEN (Makal Hub)
-- ==========================================================

local function setupFlight()
    local hrp = player.Character.HumanoidRootPart
    local att = Instance.new("Attachment", hrp)
    local lv = Instance.new("LinearVelocity", hrp)
    lv.Attachment0 = att
    lv.MaxForce = math.huge
    return lv, att
end

createButton("📦 Start Auto-Tween Delivery", function()
    isActive = true
    print("Waiting for item/prompt...")
    -- Aici se activează logica de ProximityPrompt și CheckArm din Makal
    ProximityPromptService.PromptTriggered:Connect(function()
        if isActive then
            isMoving = true
            -- Logica de zbor la bază (simplificată pentru stabilitate)
            local lv, att = setupFlight()
            lv.VectorVelocity = Vector3.new(0, 50, 0) -- Exemplu urcare
            task.wait(1)
            lv.VectorVelocity = Vector3.new(-410, 0, 0) -- Exemplu direcție bază
        end
    end)
end)

-- ==========================================================
-- MODUL: TROLL & VISUALS (Delfi/Hyper)
-- ==========================================================

createButton("💀 Player ESP", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local box = Instance.new("BoxHandleAdornment", p.Character.HumanoidRootPart)
            box.Size = Vector3.new(4, 6, 1)
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Transparency = 0.5
            box.Color3 = Color3.new(1, 0, 0)
            box.Adornee = p.Character.HumanoidRootPart
        end
    end
end)

createButton("🔥 FPS KILLER (Lag Tool)", function()
    local running = true
    task.spawn(function()
        while running do
            local bat = player.Backpack:FindFirstChild("Bat")
            if bat then 
                bat.Parent = player.Character
                task.wait(0.01)
                bat.Parent = player.Backpack
            end
            task.wait(0.01)
        end
    end)
end)

createButton("🛡️ Invisibility Cloak", function()
    local remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/CoinsShopService/RequestBuy")
    remote:InvokeServer("Invisibility Cloak")
end)

-- ==========================================================
-- TOGGLE MENU
-- ==========================================================

local openBtn = Instance.new("ImageButton", screenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 10, 0.5, 0)
openBtn.Image = "rbxassetid://98331868062387"
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

print("Ultimate Merged Hub Loaded!")
