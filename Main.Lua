-- [[ SAB DUEL MOBILE GUI - DELTA ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

-- Setări ScreenGui
ScreenGui.Name = "SabDuelGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Principal (Meniul)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true -- Poți să-l muți cu degetul

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SAB DUEL VIP"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- FUNCȚIE PENTRU CREAT BUTOANE
local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = MainFrame
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.MouseButton1Click:Connect(callback)
end

-- 1. SPEED CUSTOMIZER
CreateButton("Speed: ON (50)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)

-- 2. INF JUMP
local infJumpActive = false
CreateButton("Inf Jump", function()
    infJumpActive = not infJumpActive
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infJumpActive then
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

-- 3. AIM LOCK (Toggle)
local aimActive = false
CreateButton("Aim Lock: OFF", function(btn)
    aimActive = not aimActive
    if aimActive then
        task.spawn(function()
            while aimActive do
                task.wait()
                local closest = nil
                local dist = 100
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; closest = v.Character.HumanoidRootPart end
                    end
                end
                if closest then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(closest.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, closest.Position.Z))
                end
            end
        end)
    end
end)

-- 4. TP DOWN
CreateButton("TP DOWN", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -10, 0)
end)

-- 5. X-RAY
CreateButton("X-Ray", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
            v.Transparency = 0.5
        end
    end
end)

-- 6. OPTIMIZER
CreateButton("FPS Boost", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)

-- 7. TAUNT
CreateButton("Send Taunt", function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("SAB DUEL VIP ON TOP!", "All")
end)

-- 8. ANTI-RAGDOLL
task.spawn(function()
    while task.wait() do
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

-- BUTON DE ÎNCHIDERE MENIU
CreateButton("CLOSE MENU", function()
    ScreenGui:Destroy()
end)
