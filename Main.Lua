-- [[ RYUMA HUB PRO - KWARTA STYLE UI ]] --
local Library = {}
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- SETARI DEFAULT (Ca in imaginea Settings)
_G.DuelSpeed = 60
_G.AimSpeed = 60
_G.InfJump = false
_G.AntiRagdoll = false
_G.AimBot = false

-- 1. CREARE UI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaKwarta"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- TITLU (KWARTA STYLE)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "RYUMA HUB - DUELS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- TAB-URI
local TabHolder = Instance.new("Frame")
TabHolder.Parent = MainFrame
TabHolder.Size = UDim2.new(1, 0, 0, 30)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabHolder
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 10)

local ContentHolder = Instance.new("ScrollingFrame")
ContentHolder.Parent = MainFrame
ContentHolder.Size = UDim2.new(1, -20, 1, -80)
ContentHolder.Position = UDim2.new(0, 10, 0, 75)
ContentHolder.BackgroundTransparency = 1
ContentHolder.ScrollBarThickness = 2

local ContentList = Instance.new("UIListLayout")
ContentList.Parent = ContentHolder
ContentList.Padding = UDim.new(0, 8)

-- FUNCTIE PENTRU TOGGLE (INTRERUPATOR)
local function AddToggle(text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 0.9
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.Parent = ContentHolder
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(0.8, 0, 0.25, 0)
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(50, 50, 50)
    Btn.Text = ""
    Btn.Parent = Frame
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = Btn

    local enabled = default
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(50, 50, 50)
        callback(enabled)
    end)
end

-- 2. ADAUGARE FUNCTII (Din pozele tale)
AddToggle("Anti-Ragdoll", false, function(v) _G.AntiRagdoll = v end)
AddToggle("Inf Jump", false, function(v) _G.InfJump = v end)
AddToggle("Aim Bat", false, function(v) _G.AimBot = v end)
AddToggle("Auto Play", false, function() print("Auto Play Search...") end)
AddToggle("Optimizer", false, function(v) 
    if v then for _, x in pairs(game:GetDescendants()) do if x:IsA("Decal") then x.Transparency = 1 end end end
end)

-- 3. LOGICA DIN SPATE
task.spawn(function()
    while task.wait() do
        if _G.AntiRagdoll and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
        -- SPEED CUSTOMIZER LOGIC
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local moveDir = player.Character.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                player.Character.HumanoidRootPart.Velocity = Vector3.new(moveDir.X * _G.DuelSpeed, player.Character.HumanoidRootPart.Velocity.Y, moveDir.Z * _G.DuelSpeed)
            end
        end
    end
end)

-- AIMBOT ROTATION
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

-- JUMP REQUEST
UIS.JumpRequest:Connect(function()
    if _G.InfJump then player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
