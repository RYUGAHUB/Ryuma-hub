-- [[ RYUMA HUB HYBRID - SCREEN BUTTONS + TAB MENU ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- SETARI GLOBALE
_G.Speed = 60
_G.AntiRagdoll = false
_G.AutoSteal = false
_G.AimBat = false
_G.InfJump = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaHybrid"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- --- 1. BUTOANELOR DE PE ECRAN (SCREEN BUTTONS) ---
local function CreateBtnHolder(pos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 160, 0, 300)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    frame.Parent = ScreenGui
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 8)
    return frame
end

local LeftPanel = CreateBtnHolder(UDim2.new(0.05, 0, 0.25, 0))
local RightPanel = CreateBtnHolder(UDim2.new(0.82, 0, 0.25, 0))

local function AddScreenBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Text = "        " .. text:upper()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 18) corner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = UDim2.new(0.08, 0, 0.35, 0)
    circle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    circle.Parent = btn
    local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(1,0) cCorner.Parent = circle

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        circle.BackgroundColor3 = active and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(60, 60, 60)
        callback(active)
    end)
end

-- Adăugare butoane ecran
AddScreenBtn("Aim Bat", LeftPanel, function(v) _G.AimBat = v end)
AddScreenBtn("TP Down", LeftPanel, function() root.CFrame = root.CFrame * CFrame.new(0, -12, 0) end)
AddScreenBtn("Taunt", LeftPanel, function() print("Taunt!") end)

AddScreenBtn("Melee Aim", RightPanel, function(v) print("Melee Aim: "..tostring(v)) end)
AddScreenBtn("Drop", RightPanel, function() print("Dropped!") end)
AddScreenBtn("Auto Play", RightPanel, function(v) print("Auto Play: "..tostring(v)) end)

-- --- 2. MENIUL CENTRAL (TAB) ---
local MainTab = Instance.new("Frame")
MainTab.Size = UDim2.new(0, 280, 0, 320)
MainTab.Position = UDim2.new(0.5, -140, 0.5, -160)
MainTab.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainTab.Visible = false
MainTab.Parent = ScreenGui
local tabCorner = Instance.new("UICorner") tabCorner.Parent = MainTab

local TabTitle = Instance.new("TextLabel")
TabTitle.Size = UDim2.new(1, 0, 0, 40)
TabTitle.Text = "RYUMA HUB - SETTINGS"
TabTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
TabTitle.BackgroundTransparency = 1
TabTitle.Font = Enum.Font.GothamBold
TabTitle.Parent = MainTab

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainTab
local layout = Instance.new("UIListLayout") layout.Parent = Content; layout.Padding = UDim.new(0, 5)

-- Buton de deschis/închis Meniul
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleMenuBtn.Position = UDim2.new(0.5, -40, 0.02, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleMenuBtn.Text = "MENU"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Parent = ScreenGui
local tmCorner = Instance.new("UICorner") tmCorner.Parent = ToggleMenuBtn

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainTab.Visible = not MainTab.Visible
end)

local function AddTabToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Content
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.TextColor3 = active and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
        callback(active)
    end)
end

-- Adăugare opțiuni în Tab
AddTabToggle("Optimizer (No Textures)", function(v)
    if v then for _, x in pairs(game:GetDescendants()) do if x:IsA("Decal") then x.Transparency = 1 end end end
end)
AddTabToggle("Anti-Ragdoll", function(v) _G.AntiRagdoll = v end)
AddTabToggle("Auto Steal", function(v) _G.AutoSteal = v end)
AddTabToggle("Inf Jump", function(v) _G.InfJump = v end)

-- --- 3. LOGICA FUNCTIONALA ---
task.spawn(function()
    while task.wait() do
        if _G.AntiRagdoll and hum then hum.PlatformStand = false end
        if _G.AimBat then
            local target = nil
            local dist = 150
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

-- Jump Request
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) end
end)

