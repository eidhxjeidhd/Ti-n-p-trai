-- =============================================
-- AIM PRO - FLUENT UI (FULL CHỨC NĂNG)
-- =============================================

-- =============================================
-- ICON MỞ MENU
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.106, 0, 0.162, 0)
ImageButton.Size = UDim2.new(0, 40, 0, 40)
ImageButton.Draggable = true
ImageButton.Image = "http://www.roblox.com/asset/?id=83190276951914"

UICorner.CornerRadius = UDim.new(1, 10)
UICorner.Parent = ImageButton

ImageButton.MouseButton1Down:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)

-- =============================================
-- FLUENT UI
-- =============================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
repeat wait() until game:IsLoaded()

local Window = Fluent:CreateWindow({
    Title = "AIM PRO",
    SubTitle = "Auto Aim - ESP - Fly - Speed",
    TabWidth = 157,
    Size = UDim2.fromOffset(450, 400),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.End
})

-- =============================================
-- TABS
-- =============================================

local Tabs = {
    Aim = Window:AddTab({ Title = "Aim" }),
    ESP = Window:AddTab({ Title = "ESP" }),
    Movement = Window:AddTab({ Title = "Movement" }),
    Setting = Window:AddTab({ Title = "Setting" }),
}

-- =============================================
-- VARIABLES
-- =============================================

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local mouse = player:GetMouse()

local settings = {
    aim = false,
    smoothness = 0.3,
    bone = "Head",
    fov = 200,
    distance = 500,
    showCircle = false,
    circleColor = Color3.fromRGB(0, 255, 0),
    esp = false,
    espColor = Color3.fromRGB(255, 0, 0),
    fly = false,
    speed = false,
    speedValue = 50,
    noclip = false,
    god = false,
    autoshoot = false,
    silentaim = false,
}

-- =============================================
-- CIRCLE
-- =============================================

local circle = nil
local targetIndicator = nil

local function createCircle()
    if circle then circle:Destroy() end
    circle = Instance.new("Part")
    circle.Name = "AimCircle"
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(settings.fov * 2, 0.2, settings.fov * 2)
    circle.BrickColor = BrickColor.new("Bright green")
    circle.Material = Enum.Material.Neon
    circle.Transparency = 0.4
    circle.Anchored = true
    circle.CanCollide = false
    circle.Parent = workspace
    
    local border = Instance.new("Part")
    border.Name = "CircleBorder"
    border.Shape = Enum.PartType.Cylinder
    border.Size = Vector3.new(settings.fov * 2 + 1, 0.3, settings.fov * 2 + 1)
    border.BrickColor = BrickColor.new("Bright green")
    border.Material = Enum.Material.Neon
    border.Transparency = 0.6
    border.Anchored = true
    border.CanCollide = false
    border.Parent = circle
    return circle
end

local function createTargetIndicator()
    if targetIndicator then targetIndicator:Destroy() end
    targetIndicator = Instance.new("Part")
    targetIndicator.Name = "TargetIndicator"
    targetIndicator.Shape = Enum.PartType.Ball
    targetIndicator.Size = Vector3.new(4, 4, 4)
    targetIndicator.BrickColor = BrickColor.new("Bright red")
    targetIndicator.Material = Enum.Material.Neon
    targetIndicator.Transparency = 0.3
    targetIndicator.Anchored = true
    targetIndicator.CanCollide = false
    targetIndicator.Parent = workspace
    return targetIndicator
end

local function updateCircle()
    if not circle or not settings.showCircle then
        if circle then circle.Transparency = 1 end
        return
    end
    circle.Transparency = 0.4
    local camPos = camera.CFrame.Position
    local lookDir = camera.CFrame.LookVector
    circle.CFrame = CFrame.new(camPos + lookDir * 100) * CFrame.Angles(math.rad(90), 0, 0)
end

-- =============================================
-- ESP OBJECTS
-- =============================================

local espObjects = {}

local function createESP()
    for _, v in pairs(espObjects) do pcall(function() v:Destroy() end) end
    espObjects = {}
    if not settings.esp then return end
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            local char = v.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4, 5, 2)
                box.Color3 = settings.espColor
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Adornee = char:FindFirstChild("HumanoidRootPart")
                box.Parent = char
                table.insert(espObjects, box)
                
                local nameTag = Instance.new("BillboardGui")
                nameTag.Size = UDim2.new(0, 100, 0, 20)
                nameTag.Adornee = char:FindFirstChild("Head")
                nameTag.Parent = char
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = v.Name
                label.TextColor3 = settings.espColor
                label.TextScaled = true
                label.Parent = nameTag
                table.insert(espObjects, nameTag)
            end
        end
    end
end

-- =============================================
-- FLY
-- =============================================

local flyConn = nil
local flyBV = nil

local function toggleFly()
    settings.fly = not settings.fly
    if settings.fly then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Parent = root
        flyConn = runService.Heartbeat:Connect(function()
            if not settings.fly then return end
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not r then return end
            local bv = r:FindFirstChild("BodyVelocity")
            if not bv then return end
            local m = Vector3.new(0, 0, 0)
            if userInput:IsKeyDown(Enum.KeyCode.W) then m = m + Vector3.new(0, 0, -50) end
            if userInput:IsKeyDown(Enum.KeyCode.S) then m = m + Vector3.new(0, 0, 50) end
            if userInput:IsKeyDown(Enum.KeyCode.A) then m = m + Vector3.new(-50, 0, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.D) then m = m + Vector3.new(50, 0, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0, 50, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then m = m + Vector3.new(0, -50, 0) end
            bv.Velocity = m
        end)
    else
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if r then local bv = r:FindFirstChild("BodyVelocity") if bv then bv:Destroy() end end
    end
end

-- =============================================
-- GET TARGET
-- =============================================

local function getTargets()
    local targets = {}
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return targets end
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            local char = v.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (root.Position - hrp.Position).Magnitude
                    if dist < settings.distance then
                        table.insert(targets, {
                            Player = v,
                            Character = char,
                            RootPart = hrp,
                            Distance = dist,
                            Position = hrp.Position,
                            Health = char.Humanoid.Health,
                        })
                    end
                end
            end
        end
    end
    return targets
end

local function getBestTarget()
    local targets = getTargets()
    if #targets == 0 then return nil end
    
    table.sort(targets, function(a, b) return a.Distance < b.Distance end)
    
    local camPos = camera.CFrame.Position
    local lookDir = camera.CFrame.LookVector
    
    for _, target in pairs(targets) do
        local dir = (target.Position - camPos).Unit
        local angle = math.acos(lookDir:Dot(dir))
        if angle <= math.rad(settings.fov / 10) then
            return target
        end
    end
    
    return targets[1]
end

-- =============================================
-- AUTO AIM
-- =============================================

local currentTarget = nil

local function autoAim()
    if not settings.aim then return end
    
    local target = getBestTarget()
    currentTarget = target
    
    if not target then
        if targetIndicator then targetIndicator.Transparency = 1 end
        return
    end
    
    local bone = target.Character:FindFirstChild(settings.bone)
    if not bone then bone = target.RootPart end
    if not bone then return end
    
    if targetIndicator then
        targetIndicator.Position = bone.Position
        targetIndicator.Transparency = 0.3
    end
    
    -- Silent Aim
    if settings.silentaim then
        return
    end
    
    -- Normal Aim
    local camPos = camera.CFrame.Position
    local lookAt = CFrame.new(camPos, bone.Position)
    camera.CFrame = camera.CFrame:Lerp(lookAt, settings.smoothness)
end

-- =============================================
-- AUTO SHOOT
-- =============================================

local function autoShoot()
    if not settings.autoshoot then return end
    if not currentTarget then return end
    
    local bone = currentTarget.Character:FindFirstChild(settings.bone)
    if not bone then return end
    
    local camPos = camera.CFrame.Position
    local dir = (bone.Position - camPos).Unit
    local angle = math.acos(camera.CFrame.LookVector:Dot(dir))
    
    if angle <= math.rad(settings.fov / 10) then
        mouse1click()
    end
end

-- =============================================
-- SPEED
-- =============================================

local function toggleSpeed()
    settings.speed = not settings.speed
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = settings.speed and settings.speedValue or 16 end
end

-- =============================================
-- NOCLIP
-- =============================================

local function toggleNoclip()
    settings.noclip = not settings.noclip
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = not settings.noclip end
        end
    end
end

-- =============================================
-- GOD MODE
-- =============================================

local function toggleGod()
    settings.god = not settings.god
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then
        if settings.god then
            h.MaxHealth = 999999
            h.Health = 999999
        else
            h.MaxHealth = 100
            h.Health = 100
        end
    end
end

-- =============================================
-- TAB: AIM
-- =============================================

Tabs.Aim:AddToggle({
    Title = "Aimbot",
    Description = "Toggle auto aim",
    Default = false,
    Callback = function(value)
        settings.aim = value
        if value then
            createTargetIndicator()
        else
            if targetIndicator then targetIndicator.Transparency = 1 end
        end
        print("Aimbot: " .. (value and "ON" or "OFF"))
    end
})

Tabs.Aim:AddToggle({
    Title = "Silent Aim",
    Description = "Aim without moving camera",
    Default = false,
    Callback = function(value)
        settings.silentaim = value
        print("Silent Aim: " .. (value and "ON" or "OFF"))
    end
})

Tabs.Aim:AddToggle({
    Title = "Auto Shoot",
    Description = "Auto shoot when target in FOV",
    Default = false,
    Callback = function(value)
        settings.autoshoot = value
        print("Auto Shoot: " .. (value and "ON" or "OFF"))
    end
})

Tabs.Aim:AddToggle({
    Title = "Show Circle",
    Description = "Show FOV circle",
    Default = false,
    Callback = function(value)
        settings.showCircle = value
        if value then
            createCircle()
        else
            if circle then circle:Destroy(); circle = nil end
        end
        print("Show Circle: " .. (value and "ON" or "OFF"))
    end
})

Tabs.Aim:AddSlider({
    Title = "Smoothness",
    Description = "Aim smoothness (0.1 - 1.0)",
    Default = 0.3,
    Min = 0.1,
    Max = 1.0,
    Rounding = 1,
    Callback = function(value)
        settings.smoothness = value
    end
})

Tabs.Aim:AddSlider({
    Title = "FOV",
    Description = "Field of view (50 - 400)",
    Default = 200,
    Min = 50,
    Max = 400,
    Rounding = 0,
    Callback = function(value)
        settings.fov = value
        if circle then circle.Size = Vector3.new(value * 2, 0.2, value * 2) end
    end
})

Tabs.Aim:AddSlider({
    Title = "Distance",
    Description = "Max distance to target (100 - 800)",
    Default = 500,
    Min = 100,
    Max = 800,
    Rounding = 0,
    Callback = function(value)
        settings.distance = value
    end
})

Tabs.Aim:AddDropdown({
    Title = "Aim Bone",
    Description = "Select bone to aim",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = 1,
    Callback = function(value)
        settings.bone = value
        print("Aim bone: " .. value)
    end
})

Tabs.Aim:AddButton({
    Title = "Target Info",
    Description = "Show current target info",
    Callback = function()
        if currentTarget then
            print("Target: " .. currentTarget.Player.Name)
            print("Distance: " .. math.round(currentTarget.Distance))
            print("Health: " .. math.round(currentTarget.Health))
        else
            print("No target found")
        end
    end
})

-- =============================================
-- TAB: ESP
-- =============================================

Tabs.ESP:AddToggle({
    Title = "ESP",
    Description = "Toggle ESP",
    Default = false,
    Callback = function(value)
        settings.esp = value
        createESP()
        print("ESP: " .. (value and "ON" or "OFF"))
    end
})

Tabs.ESP:AddColorPicker({
    Title = "ESP Color",
    Description = "Select ESP color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(value)
        settings.espColor = value
        createESP()
    end
})

Tabs.ESP:AddButton({
    Title = "Refresh ESP",
    Description = "Refresh ESP objects",
    Callback = function()
        createESP()
        print("ESP refreshed!")
    end
})

-- =============================================
-- TAB: MOVEMENT
-- =============================================

Tabs.Movement:AddToggle({
    Title = "Fly",
    Description = "Toggle fly mode (WASD + Space)",
    Default = false,
    Callback = function(value)
        toggleFly()
    end
})

Tabs.Movement:AddToggle({
    Title = "Speed",
    Description = "Toggle speed hack",
    Default = false,
    Callback = function(value)
        toggleSpeed()
    end
})

Tabs.Movement:AddSlider({
    Title = "Speed Value",
    Description = "Speed value (16 - 200)",
    Default = 50,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(value)
        settings.speedValue = value
        if settings.speed then
            local h = player.Character and player.Character:FindFirstChild("Humanoid")
            if h then h.WalkSpeed = value end
        end
    end
})

Tabs.Movement:AddToggle({
    Title = "Noclip",
    Description = "Toggle noclip",
    Default = false,
    Callback = function(value)
        toggleNoclip()
    end
})

Tabs.Movement:AddToggle({
    Title = "God Mode",
    Description = "Toggle god mode",
    Default = false,
    Callback = function(value)
        toggleGod()
    end
})

-- =============================================
-- TAB: SETTING
-- =============================================

Tabs.Setting:AddButton({
    Title = "Reset Settings",
    Description = "Reset all settings to default",
    Callback = function()
        settings.aim = false
        settings.smoothness = 0.3
        settings.bone = "Head"
        settings.fov = 200
        settings.distance = 500
        settings.showCircle = false
        settings.esp = false
        settings.fly = false
        settings.speed = false
        settings.speedValue = 50
        settings.noclip = false
        settings.god = false
        settings.autoshoot = false
        settings.silentaim = false
        
        if circle then circle:Destroy(); circle = nil end
        if targetIndicator then targetIndicator:Destroy(); targetIndicator = nil end
        for _, v in pairs(espObjects) do pcall(function() v:Destroy() end) end
        espObjects = {}
        print("All settings reset!")
    end
})

Tabs.Setting:AddButton({
    Title = "Discord",
    Description = "Copy Discord link",
    Callback = function()
        setclipboard("https://discord.gg/yourlink")
        print("Copied Discord link!")
    end
})

Tabs.Setting:AddButton({
    Title = "Close Menu",
    Description = "Close the menu",
    Callback = function()
        Window:Destroy()
        print("Menu closed!")
    end
})

-- =============================================
-- MAIN LOOP
-- =============================================

coroutine.wrap(function()
    while player:FindFirstChild("Humanoid") do
        updateCircle()
        autoAim()
        autoShoot()
        if settings.esp then
            createESP()
        end
        wait(0.03)
    end
end)()

-- =============================================
-- CHARACTER RESET
-- =============================================

player.CharacterAdded:Connect(function()
    settings.fly = false
    settings.speed = false
    settings.noclip = false
    settings.god = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
end)

print("========================================")
print("  AIM PRO - FLUENT UI FULL")
print("========================================")
print("  Aimbot - Silent Aim - Auto Shoot")
print("  FOV Circle - ESP - Fly - Speed")
print("  Noclip - God Mode")
print("========================================")
print("  Click icon to open menu")
print("========================================")