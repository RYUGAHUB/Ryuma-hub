-- [[ RYUMA HUB - FIXED SPEED & DIRECTIONAL AUTO ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- SETĂRI
_G.WalkSpeed = 16
_G.InfJump = false
_G.AutoLeft = false
_G.AutoRight = false

-- 1. INTERFAȚĂ (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaFixed"
ScreenGui.Parent = game.CoreGui

local function CreateContainer(pos)
    local frame = Instance.new("Frame")
    frame.Parent = ScreenGui
    frame.Size = UDim2.new(0, 150, 0, 220)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 8)
    return frame
end

local LeftSide = CreateContainer(UDim2.new(0.02, 0, 0.3, 0))
local RightSide = CreateContainer(UDim2.new(0.85, 0, 0.3, 0))

local function AddButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = parent
    return btn
end

-- --- BUTOANE STÂNGA (Viteză & Jump) ---
AddButton("SPEED +10", LeftSide, function()
    _G.WalkSpeed = _G.WalkSpeed + 10
end)

AddButton("RESET SPEED", LeftSide, function()
    _G.WalkSpeed = 16
end)

AddButton("INF JUMP: OFF", LeftSide, function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP: OFF"
end)

-- --- BUTOANE DREAPTA (Direcție & Luptă) ---
AddButton("AUTO LEFT: OFF", RightSide, function(btn)
    _G.AutoLeft = not _G.AutoLeft
    _G.AutoRight = false -- Oprește dreapta dacă pornești stânga
    btn.Text = _G.AutoLeft and "AUTO LEFT: ON" or "AUTO LEFT: OFF"
end)

AddButton("AUTO RIGHT: OFF", RightSide, function(btn)
    _G.AutoRight = not _G.AutoRight
    _G.AutoLeft = false -- Oprește stânga dacă pornești dreapta
    btn.Text = _G.AutoRight and "AUTO RIGHT: ON" or "AUTO RIGHT: OFF"
end)

AddButton("TP DOWN", RightSide, function()
    root.CFrame = root.CFrame * CFrame.new(0, -12, 0)
end)

-- 2. LOGICA (FIXED SPEED & AUTO MOVEMENT)

-- Fix pentru Speed (Rulează non-stop ca să nu poată fi resetat de joc)
task.spawn(function()
    while task.wait() do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = _G.WalkSpeed
            -- Anti-Ragdoll
            character.Humanoid.PlatformStand = false
        end
    end
end)

-- Logica pentru Auto Left / Auto Right
task.spawn(function()
    while task.wait() do
        if _G.AutoLeft and root then
            root.CFrame = root.CFrame * CFrame.new(-0.5, 0, 0) -- Te împinge constant la stânga
        end
        if _G.AutoRight and root then
            root.CFrame = root.CFrame * CFrame.new(0.5, 0, 0) -- Te împinge constant la dreapta
        end
    end
end)

-- Inf Jump Safe
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and root then
        root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
    end
end)
