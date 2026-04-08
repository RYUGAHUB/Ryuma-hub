-- [[ RYUMA HUB FINAL - ANTI-DETECTION & AIMBOT ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- SETĂRI
_G.Speed = 16
_G.InfJump = false
_G.AutoLeft = false
_G.AutoRight = false
_G.AimBot = false
_G.AutoSteal = false

-- 1. INTERFAȚĂ SPLIT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaPro"
ScreenGui.Parent = game.CoreGui

local function CreateContainer(pos)
    local frame = Instance.new("Frame")
    frame.Parent = ScreenGui
    frame.Size = UDim2.new(0, 150, 0, 250)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 5)
    return frame
end

local LeftSide = CreateContainer(UDim2.new(0.02, 0, 0.25, 0))
local RightSide = CreateContainer(UDim2.new(0.85, 0, 0.25, 0))

local function AddBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = parent
end

-- BUTOANE STÂNGA (Viteză & Jump)
AddBtn("SPEED: 50", LeftSide, function(btn)
    if _G.Speed == 16 then _G.Speed = 50 elseif _G.Speed == 50 then _G.Speed = 100 else _G.Speed = 16 end
    btn.Text = "SPEED: " .. _G.Speed
end)

AddBtn("INF JUMP: OFF", LeftSide, function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP: OFF"
end)

AddBtn("AIMBOT: OFF", LeftSide, function(btn)
    _G.AimBot = not _G.AimBot
    btn.Text = _G.AimBot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

-- BUTOANE DREAPTA (Luptă & Mișcare)
AddBtn("AUTO LEFT: OFF", RightSide, function(btn)
    _G.AutoLeft = not _G.AutoLeft
    _G.AutoRight = false
    btn.Text = _G.AutoLeft and "AUTO LEFT: ON" or "AUTO LEFT: OFF"
end)

AddBtn("AUTO RIGHT: OFF", RightSide, function(btn)
    _G.AutoRight = not _G.AutoRight
    _G.AutoLeft = false
    btn.Text = _G.AutoRight and "AUTO RIGHT: ON" or "AUTO RIGHT: OFF"
end)

AddBtn("AUTO STEAL: OFF", RightSide, function(btn)
    _G.AutoSteal = not _G.AutoSteal
    btn.Text = _G.AutoSteal and "STEAL: ON" or "STEAL: OFF"
end)

AddBtn("TP DOWN", RightSide, function()
    root.CFrame = root.CFrame * CFrame.new(0, -12, 0)
end)

-- 2. LOGICA AVANSATĂ

-- Fix Speed & Anti-Ragdoll (Metoda Velocity pentru a evita moartea)
task.spawn(function()
    while task.wait() do
        if hum and root and _G.Speed > 16 then
            local moveDir = hum.MoveDirection
            root.Velocity = Vector3.new(moveDir.X * _G.Speed, root.Velocity.Y, moveDir.Z * _G.Speed)
        end
        if hum then hum.PlatformStand = false end
    end
end)

-- Auto Left/Right Safe (Mișcare prin CFrame, dar mai lentă să nu mori)
task.spawn(function()
    while task.wait(0.05) do
        if _G.AutoLeft and root then root.CFrame = root.CFrame * CFrame.new(-1.5, 0, 0) end
        if _G.AutoRight and root then root.CFrame = root.CFrame * CFrame.new(1.5, 0, 0) end
    end
end)

-- AimBot (Te rotește spre cel mai apropiat jucător)
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

-- Auto Steal (Colectează obiecte de pe jos/Tools)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSteal then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("BackpackItem") or v:IsA("Tool") or (v:IsA("Part") and v:FindFirstChild("TouchInterest")) then
                    firetouchinterest(root, v:IsA("Tool") and v.Handle or v, 0)
                    task.wait(0.1)
                    firetouchinterest(root, v:IsA("Tool") and v.Handle or v, 1)
                end
            end
        end
    end
end)

-- Inf Jump Safe
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and root then root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) end
end)
