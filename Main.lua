-- [[ RYUMA HUB - PERFECT KWARTA STYLE UI ]] --
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

-- 1. CREARE UI PRINCIPAL (IDENTIC KWARTA STYLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ryuma PERFECT"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 380) -- Dimensiunea din imagine
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Poti sa-l misti

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- TITLU (FARA TAB-URI, DOAR TEXTUL DE SUS)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "RYUMA HUB - DUELS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17

-- LOGO-UL NINJA (CENTRUL SUS, Ca in imagine)
local NinjaLogo = Instance.new("ImageLabel")
NinjaLogo.Parent = MainFrame
NinjaLogo.Size = UDim2.new(0, 50, 0, 50)
NinjaLogo.Position = UDim2.new(0.5, -25, 0, 50)
NinjaLogo.BackgroundTransparency = 1
NinjaLogo.Image = "rbxassetid://10681313171" -- ID Ninja Logo
local LogoCorner = Instance.new("UICorner") LogoCorner.CornerRadius = UDim.new(1,0) LogoCorner.Parent = NinjaLogo

-- ZONA DE CONTINUT (ScrollingFrame)
local ContentHolder = Instance.new("ScrollingFrame")
ContentHolder.Parent = MainFrame
ContentHolder.Size = UDim2.new(1, -20, 1, -110)
ContentHolder.Position = UDim2.new(0, 10, 0, 105)
ContentHolder.BackgroundTransparency = 1
ContentHolder.ScrollBarThickness = 2
ContentFrame.ClipsDescendants = true

local ContentList = Instance.new("UIListLayout")
ContentList.Parent = ContentHolder
ContentList.Padding = UDim.new(0, 7)

-- BUTONUL DE MINIMIZARE (Buton mic sus-dreapta pentru a ascunde meniul)
local MinimBtn = Instance.new("TextButton")
MinimBtn.Size = UDim2.new(0, 20, 0, 20)
MinimBtn.Position = UDim2.new(1, -25, 0, 5)
MinimBtn.Text = "-"
MinimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimBtn.Parent = MainFrame
local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1,0) c.Parent = MinimBtn

local visible = true
MinimBtn.MouseButton1Click:Connect(function()
    visible = not visible
    ContentHolder.Visible = visible
    Title.Visible = visible
    NinjaLogo.Visible = visible
    MainFrame.Size = visible and UDim2.new(0, 320, 0, 380) or UDim2.new(0, 320, 0, 30)
end)

-- FUNCTIE PENTRU TOGGLE (INTRERUPATOR STIL iPHONE/KWARTA)
local function AddPerfToggle(text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundTransparency = 0.95 -- Foarte transparent
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.Parent = ContentHolder
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.TextColor3 = Color3.fromRGB(180, 180, 180) -- Gri deschis
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.Parent = Frame

    -- Baza Slider-ului
    local SliderBase = Instance.new("Frame")
    SliderBase.Size = UDim2.new(0, 42, 0, 20)
    SliderBase.Position = UDim2.new(0.82, 0, 0.25, 0)
    SliderBase.BackgroundColor3 = default and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(60, 60, 60)
    SliderBase.Parent = Frame
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = SliderBase

    -- Butonul Circular al Slider-ului
    local SliderBall = Instance.new("Frame")
    SliderBall.Size = UDim2.new(0, 16, 0, 16)
    SliderBall.Position = default and UDim2.new(1, -19, 0, 2) or UDim2.new(0, 2, 0, 2)
    SliderBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderBall.Parent = SliderBase
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = SliderBall

    -- Zona clikabila
    local Clickable = Instance.new("TextButton")
    Clickable.Size = UDim2.new(1, 0, 1, 0)
    Clickable.BackgroundTransparency = 1
    Clickable.Text = ""
    Clickable.Parent = Frame

    local enabled = default
    Clickable.MouseButton1Click:Connect(function()
        enabled = not enabled
        -- Animatie simpla
        SliderBase.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(60, 60, 60)
        SliderBall:TweenPosition(enabled and UDim2.new(1, -19, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Linear", 0.1, true)
        callback(enabled)
    end)
end

-- --- 2. ADAUGARE FUNCTII (IDENTICE DIN IMAGINEA TA) ---
AddPerfToggle("Anti-Ragdoll", false, function(v) _G.AntiRagdoll = v end)
AddPerfToggle("Inf Jump", false, function(v) _G.InfJump = v end)
AddPerfToggle("Aim Bat", false, function(v) _G.AimBot = v end)
AddPerfToggle("Auto Play", false, function() print("Auto Play Cautare...") end)
AddPerfToggle("Optimizer (Decals/Textures)", false, function(v) 
    if v then for _, x in pairs(game:GetDescendants()) do if x:IsA("Decal") then x.Transparency = 1 end end end
end)
AddPerfToggle("Float (Optional)", false, function(v) print("Float: "..tostring(v)) end)
AddPerfToggle("Auto Steal (Optional)", false, function(v) print("Auto Steal: "..tostring(v)) end)

-- --- 3. LOGICA DIN SPATE (Fara lag) ---
task.spawn(function()
    while task.wait() do
        -- Anti-Ragdoll
        if _G.AntiRagdoll and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
        -- Speed Fix (Invizibil, bazat pe settings)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local moveDir = player.Character.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                player.Character.HumanoidRootPart.Velocity = Vector3.new(moveDir.X * _G.DuelSpeed, player.Character.HumanoidRootPart.Velocity.Y, moveDir.Z * _G.DuelSpeed)
            end
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

-- INF JUMP
UIS.JumpRequest:Connect(function()
    if _G.InfJump then player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
