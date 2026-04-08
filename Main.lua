local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "RYUGA HUB | V1", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "RYUGA HUB",
    Icon = "rbxassetid://4483362458"
})

-- TAB-UL PRINCIPAL (Înlocuitor pentru butoanele mari din stânga)
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

MainTab:AddSection({
    Name = "Functii Steal Brainrot"
})

-- TOGGLE PENTRU STEAL (Asemănător cu cel din poză)
_G.AutoSteal = false
MainTab:AddToggle({
    Name = "Auto Steal Brainrot",
    Default = false,
    Callback = function(Value)
        _G.AutoSteal = Value
        if Value then
            print("Steal activat!")
            -- Aici poti adauga logica de teleportare a obiectelor
        end
    end    
})

-- SLIDER PENTRU DISTANTA (Asemănător cu cel portocaliu din poză)
_G.StealRange = 50
MainTab:AddSlider({
    Name = "Steal Range",
    Min = 10,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255, 120, 30), -- Culoare portocalie/roșie
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        _G.StealRange = Value
    end    
})

OrionLib:Init()
