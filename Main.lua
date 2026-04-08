-- [[ RYUMA HUB - V2 PRO CUSTOMIZABLE ]] --
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")

-- SETARI DEFAULT
_G.DuelSpeed = 60
_G.StealReturnSpeed = 30 -- Viteza cu care te intorci
_G.StealDistance = 7
_G.InfJump = false
_G.AimBot = false

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RyumaV2"

-- --- FUNCTIE MISCARE AUTO LEFT / RIGHT (FIXED) ---
local function StealMove(direction)
    local originalPos = root.CFrame
    local sideVector = (direction == "Left") and -root.CFrame.RightVector or root.CFrame.RightVector
    
    -- Merge rapid spre lateral
    root.CFrame = root.CFrame + (sideVector * _G.StealDistance)
    task.wait(0.15) -- Timp mic pentru a inregistra brainrot-ul
    
    -- Se intoarce cu viteza customizata (Steal Speed)
    local tweenService = game:GetService("TweenService")
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(root, info, {CFrame = originalPos})
    tween:Play()
end

-- --- INTERFATA (BUTOANE ECRAN) ---
local RightPanel = Instance.new("Frame", ScreenGui)
RightPanel.Size = UDim2.new(0, 160, 0, 350)
RightPanel.Position = UDim2.new(1, -170, 0.5, -150)
RightPanel.BackgroundTransparency = 1
local layout = Instance.new("UIGridLayout", RightPanel)
layout.CellSize = UDim2.new(0, 75, 0, 35)

local function AddBtn(text, callback)
    local btn = Instance.new("TextButton", RightPanel)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Text = text:upper()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

AddBtn("Auto Left", function() StealMove("Left") end)
AddBtn("Auto Right", function() StealMove("Right") end)
AddBtn("Aim Bat", function() _G.AimBot = not _G.AimBot end)
AddBtn("Inf Jump", function() 
    _G.InfJump = not _G.InfJump 
    print("Inf Jump: "..tostring(_G.InfJump))
end)

-- --- MENIU SETARI (CUSTOM SPEED) ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "CUSTOM SETTINGS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- Input pentru Duel Speed
local SpeedInput = Instance.new("TextBox", MainFrame)
SpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
SpeedInput.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedInput.PlaceholderText = "Set Duel Speed (ex: 60)"
SpeedInput.Text = "60"
SpeedInput.FocusLost:Connect(function() _G.DuelSpeed = tonumber(SpeedInput.Text) or 60 end)

-- Input pentru Steal Speed (Return Speed)
local ReturnInput = Instance.new("TextBox", MainFrame)
ReturnInput.Size = UDim2.new(0.8, 0, 0, 30)
ReturnInput.Position = UDim2.new(0.1, 0, 0.5, 0)
ReturnInput.PlaceholderText = "Set Return Speed (ex: 30)"
ReturnInput.Text = "30"
ReturnInput.FocusLost:Connect(function() _G.StealReturnSpeed = tonumber(ReturnInput.Text) or 30 end)

-- --- LOGICA SISTEM ---
-- Infinite Jump Fix
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

task.spawn(function()
    while task.wait() do
        -- WalkSpeed Custom
        if hum.MoveDirection.Magnitude > 0 then
            root.Velocity = Vector3.new(hum.MoveDirection.X * _G.DuelSpeed, root.Velocity.Y, hum.MoveDirection.Z * _G.DuelSpeed)
        end
        
        -- AimBot
        if _G.AimBot then
            local closest = nil
            local dist = 200
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = v.Character.HumanoidRootPart end
                end
            end
            if closest then
                root.CFrame = CFrame.new(root.Position, Vector3.new(closest.Position.X, root.Position.Y, closest.Position.Z))
            end
        end
    end
end)
