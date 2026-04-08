-- [[ RYUGA HUB V3 - CUSTOM SPEED & PRO UI ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- SETĂRI
_G.SpeedValue = 16
_G.InfJump = false
_G.AutoLeft = false
_G.AutoRight = false
_G.AimBot = false
_G.AutoSteal = false

-- 1. CREARE UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyugaHubPro"
ScreenGui.Parent = game.CoreGui

-- TITLU SUS
local MainTitle = Instance.new("TextLabel")
MainTitle.Parent = ScreenGui
MainTitle.Size = UDim2.new(0, 200, 0, 40)
MainTitle.Position = UDim2.new(0.5, -100, 0.05, 0)
MainTitle.Text = "RYUGA HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 0) -- Galben neon
MainTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextSize = 20
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = MainTitle

-- CONTAINERE BUTOANE
local function CreateContainer(pos)
    local frame = Instance.new("Frame")
    frame.Parent = ScreenGui
    frame.Size = UDim2.new(0, 140, 0, 260)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 8)
    return frame
end

local LeftSide = CreateContainer(UDim2.new(0.02, 0, 0.3, 0))
local RightSide = CreateContainer(UDim2.new(0.85, 0, 0.3, 0))

local function AddBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = parent
    return btn
end

-- --- BUTOANE STÂNGA (CUSTOM SPEED & JUMP) ---
local SpeedDisplay = AddBtn("SPEED: 16", LeftSide, function() end)

-- Butoane mici pentru reglaj viteză
local SpeedControls = Instance.new("Frame")
SpeedControls.Size = UDim2.new(1, 0, 0, 30)
SpeedControls.BackgroundTransparency = 1
SpeedControls.Parent = LeftSide

local btnMinus = Instance.new("TextButton")
btnMinus.Size = UDim2.new(0.45, 0, 1, 0)
btnMinus.Position = UDim2.new(0, 0, 0, 0)
btnMinus.Text = "-"
btnMinus.Parent = SpeedControls
btnMinus.MouseButton1Click:Connect(function()
    _G.SpeedValue = math.max(16, _G.SpeedValue - 5)
    SpeedDisplay.Text = "SPEED: " .. _G.SpeedValue
end)

local btnPlus = Instance.new("TextButton")
btnPlus.Size = UDim2.new(0.45, 0, 1, 0)
btnPlus.Position = UDim2.new(0.55, 0, 0, 0)
btnPlus.Text = "+"
btnPlus.Parent = SpeedControls
btnPlus.MouseButton1Click:Connect(function()
    _G.SpeedValue = _G.SpeedValue + 5
    SpeedDisplay.Text = "SPEED: " .. _G.SpeedValue
end)

AddBtn("INF JUMP: OFF", LeftSide, function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP: OFF"
end)

AddBtn("AIMBOT: OFF", LeftSide, function(btn)
    _G.AimBot = not _G.AimBot
    btn.Text = _G.AimBot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

-- --- BUTOANE DREAPTA (AUTO MOVE & STEAL) ---
AddBtn("LEFT: OFF", RightSide, function(btn)
    _G.AutoLeft = not _G.AutoLeft
    _G.AutoRight = false
    btn.Text = _G.AutoLeft and "LEFT: ON" or "LEFT: OFF"
end)

AddBtn("RIGHT: OFF", RightSide, function(btn)
    _G.AutoRight = not _G.AutoRight
    _G.AutoLeft = false
    btn.Text = _G.AutoRight and "RIGHT: ON" or "RIGHT: OFF"
end)

AddBtn("STEAL: OFF", RightSide, function(btn)
    _G.AutoSteal = not _G.AutoSteal
    btn.Text = _G.AutoSteal and "STEAL: ON" or "STEAL: OFF"
end)

AddBtn("TP DOWN", RightSide, function()
    root.CFrame = root.CFrame * CFrame.new(0, -12, 0)
end)

-- 2. LOGICA (FIXED ANTI-DETECTION)

task.spawn(function()
    while task.wait() do
        if hum and root then
            local moveDir = hum.MoveDirection
            local sideVel = Vector3.new(0,0,0)

            if _G.AutoLeft then sideVel = (workspace.CurrentCamera.CFrame.RightVector * -25)
            elseif _G.AutoRight then sideVel = (workspace.CurrentCamera.CFrame.RightVector * 25) end

            if _G.SpeedValue > 16 or _G.AutoLeft or _G.AutoRight then
                root.Velocity = Vector3.new(
                    (moveDir.X * _G.SpeedValue) + sideVel.X,
                    root.Velocity.Y,
                    (moveDir.Z * _G.SpeedValue) + sideVel.Z
                )
            end
            hum.PlatformStand = false
        end
    end
end)

-- AIMBOT
task.spawn(function()
    while task.wait() do
        if _G.AimBot then
            local target = nil
            local dist = 100
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; target = v.Character.HumanoidRootPart end
                end
            end
            if target then
                root.CFrame = CFrame.new(root.Position, Vector3.new(target.Position.X, root.Position.Y, target.Position.Z))
            end
        end
    end
end)

-- AUTO STEAL
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSteal then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchInterest") and v.Parent then
                    firetouchinterest(root, v.Parent, 0)
                    task.wait()
                    firetouchinterest(root, v.Parent, 1)
                end
            end
        end
    end
end)

-- INF JUMP
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and root then root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) end
end)
