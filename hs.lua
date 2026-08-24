-- =============================================
-- ROBLOX - AIM CIRCLE ULTIMATE (MAX LEVEL)
-- =============================================

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

-- =============================================
-- SETTINGS (MAX LEVEL)
-- =============================================

local settings = {
    -- AIM
    enabled = true,
    radius = 150,
    smoothness = 0.3,
    aimBone = "Head",
    showTarget = true,
    showCircle = true,
    showFOV = true,
    targetColor = Color3.fromRGB(255, 0, 0),
    circleColor = Color3.fromRGB(0, 255, 0),
    fovColor = Color3.fromRGB(0, 200, 255),
    maxDistance = 500,
    
    -- ESP
    espEnabled = true,
    espBox = true,
    espName = true,
    espHealth = true,
    espDistance = true,
    espSkeleton = false,
    espColor = Color3.fromRGB(255, 50, 50),
    espTeamColor = Color3.fromRGB(50, 255, 50),
    
    -- VISUAL
    wallhack = false,
    fullbright = false,
    noFog = false,
    highlight = false,
    glow = false,
    chams = false,
    
    -- MOVEMENT
    speedEnabled = false,
    speedValue = 50,
    noclip = false,
    fly = false,
    flySpeed = 50,
    jumpPower = 50,
    autoJump = false,
    
    -- COMBAT
    autoShoot = false,
    silentAim = false,
    noRecoil = false,
    noSpread = false,
    aimbotFOV = 200,
    hitChance = 95,
    
    -- PLAYER
    godMode = false,
    infiniteStamina = false,
    autoHeal = false,
    
    -- MISC
    antiAFK = true,
    chatSpam = false,
}

-- =============================================
-- CREATE ULTIMATE CIRCLE
-- =============================================

local circle = nil
local targetIndicator = nil
local fovCircle = nil
local espObjects = {}
local glowParts = {}

local function createUltimateCircle()
    if circle then circle:Destroy() end
    
    circle = Instance.new("Part")
    circle.Name = "AimCircle"
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(settings.radius * 2, 0.2, settings.radius * 2)
    circle.BrickColor = BrickColor.new("Bright green")
    circle.Material = Enum.Material.Neon
    circle.Transparency = 0.4
    circle.Anchored = true
    circle.CanCollide = false
    circle.Parent = workspace
    
    -- Border glow
    local border = Instance.new("Part")
    border.Name = "CircleBorder"
    border.Shape = Enum.PartType.Cylinder
    border.Size = Vector3.new(settings.radius * 2 + 1, 0.3, settings.radius * 2 + 1)
    border.BrickColor = BrickColor.new("Bright green")
    border.Material = Enum.Material.Neon
    border.Transparency = 0.6
    border.Anchored = true
    border.CanCollide = false
    border.Parent = circle
    
    -- Center dot
    local center = Instance.new("Part")
    center.Name = "CenterDot"
    center.Shape = Enum.PartType.Ball
    center.Size = Vector3.new(3, 3, 3)
    center.BrickColor = BrickColor.new("Bright green")
    center.Material = Enum.Material.Neon
    center.Transparency = 0.3
    center.Anchored = true
    center.CanCollide = false
    center.Parent = circle
    
    -- Crosshair
    for i = 0, 3 do
        local line = Instance.new("Part")
        line.Name = "Crosshair"
        line.Shape = Enum.PartType.Block
        line.Size = Vector3.new(0.2, 0.2, settings.radius * 0.3)
        line.BrickColor = BrickColor.new("Bright green")
        line.Material = Enum.Material.Neon
        line.Transparency = 0.4
        line.Anchored = true
        line.CanCollide = false
        line.CFrame = circle.CFrame * CFrame.Angles(0, math.rad(i * 90), 0) * CFrame.new(0, 0, -settings.radius * 0.5)
        line.Parent = circle
    end
    
    return circle
end

local function createFOVCircle()
    if fovCircle then fovCircle:Destroy() end
    
    fovCircle = Instance.new("Part")
    fovCircle.Name = "FOVCircle"
    fovCircle.Shape = Enum.PartType.Cylinder
    fovCircle.Size = Vector3.new(settings.aimbotFOV * 2, 0.1, settings.aimbotFOV * 2)
    fovCircle.BrickColor = BrickColor.new("Bright blue")
    fovCircle.Material = Enum.Material.Neon
    fovCircle.Transparency = 0.5
    fovCircle.Anchored = true
    fovCircle.CanCollide = false
    fovCircle.Parent = workspace
    
    return fovCircle
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
    
    local ring = Instance.new("Part")
    ring.Name = "TargetRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(6, 0.2, 6)
    ring.BrickColor = BrickColor.new("Bright red")
    ring.Material = Enum.Material.Neon
    ring.Transparency = 0.5
    ring.Anchored = true
    ring.CanCollide = false
    ring.Parent = targetIndicator
    
    return targetIndicator
end

-- =============================================
-- ESP ENGINE
-- =============================================

local function createESP(playerChar, color)
    if not playerChar then return end
    
    -- Box ESP
    if settings.espBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(4, 5, 2)
        box.Color3 = color
        box.Transparency = 0.3
        box.AlwaysOnTop = true
        box.ZIndex = 0
        box.Adornee = playerChar:FindFirstChild("HumanoidRootPart")
        box.Parent = playerChar
        table.insert(espObjects, box)
    end
    
    -- Name ESP
    if settings.espName then
        local nameLabel = Instance.new("BillboardGui")
        nameLabel.Size = UDim2.new(0, 100, 0, 20)
        nameLabel.Adornee = playerChar:FindFirstChild("Head")
        nameLabel.Parent = playerChar
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = playerChar.Parent.Name
        label.TextColor3 = color
        label.TextScaled = true
        label.Parent = nameLabel
        table.insert(espObjects, nameLabel)
    end
    
    -- Health bar
    if settings.espHealth then
        local healthGui = Instance.new("BillboardGui")
        healthGui.Size = UDim2.new(0, 50, 0, 5)
        healthGui.Position = UDim2.new(0, -25, 0, 2)
        healthGui.Adornee = playerChar:FindFirstChild("Head")
        healthGui.Parent = playerChar
        
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.BackgroundTransparency = 0.3
        healthBar.Parent = healthGui
        
        local healthFill = Instance.new("Frame")
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BackgroundTransparency = 0.3
        healthFill.Parent = healthBar
        
        table.insert(espObjects, healthGui)
    end
end

local function updateESP()
    -- Clear old ESP
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            local char = p.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local color = settings.espColor
                -- Team color
                if p.Team == player.Team then
                    color = settings.espTeamColor
                end
                createESP(char, color)
            end
        end
    end
end

-- =============================================
-- UPDATE FUNCTIONS
-- =============================================

local function updateCircle()
    if not circle or not settings.showCircle then 
        if circle then circle.Transparency = 1 end
        return 
    end
    
    circle.Transparency = 0.4
    local camPos = camera.CFrame.Position
    local lookDir = camera.CFrame.LookVector
    local circlePos = camPos + lookDir * settings.radius
    
    circle.CFrame = CFrame.new(circlePos) * CFrame.Angles(math.rad(90), 0, 0)
    
    local border = circle:FindFirstChild("CircleBorder")
    if border then
        border.Size = Vector3.new(settings.radius * 2 + 1, 0.3, settings.radius * 2 + 1)
        border.CFrame = circle.CFrame * CFrame.new(0, 0.2, 0)
    end
    
    local center = circle:FindFirstChild("CenterDot")
    if center then
        center.Position = circlePos
    end
    
    for _, line in pairs(circle:GetChildren()) do
        if line.Name == "Crosshair" then
            line.Size = Vector3.new(0.2, 0.2, settings.radius * 0.3)
        end
    end
end

local function updateFOV()
    if not fovCircle or not settings.showFOV then
        if fovCircle then fovCircle.Transparency = 1 end
        return
    end
    
    fovCircle.Transparency = 0.5
    local camPos = camera.CFrame.Position
    local lookDir = camera.CFrame.LookVector
    local fovPos = camPos + lookDir * 100
    
    fovCircle.CFrame = CFrame.new(fovPos) * CFrame.Angles(math.rad(90), 0, 0)
    fovCircle.Size = Vector3.new(settings.aimbotFOV * 2, 0.1, settings.aimbotFOV * 2)
end

-- =============================================
-- FIND TARGET
-- =============================================

local function findTargets()
    local targets = {}
    local rootPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPos then return targets end
    
    for _, v in pairs(players:GetPlayers()) do
        if v ~= player then
            local char = v.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (rootPos.Position - hrp.Position).Magnitude
                    if dist < settings.maxDistance then
                        table.insert(targets, {
                            Player = v,
                            Character = char,
                            Humanoid = char.Humanoid,
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
    local targets = findTargets()
    if #targets == 0 then return nil end
    
    table.sort(targets, function(a, b) return a.Distance < b.Distance end)
    
    local camPos = camera.CFrame.Position
    local lookDir = camera.CFrame.LookVector
    
    for _, target in pairs(targets) do
        local dir = (target.Position - camPos).Unit
        local angle = math.acos(lookDir:Dot(dir))
        if angle <= math.rad(settings.aimbotFOV / 10) then
            return target
        end
    end
    
    return targets[1]
end

-- =============================================
-- AUTO AIM ULTIMATE
-- =============================================

local currentTarget = nil

local function autoAim()
    if not settings.enabled then return end
    
    local target = getBestTarget()
    currentTarget = target
    
    if not target then
        if targetIndicator then targetIndicator.Transparency = 1 end
        return
    end
    
    local bone = target.Character:FindFirstChild(settings.aimBone)
    if not bone then
        bone = target.RootPart
    end
    
    if bone then
        local aimPos = bone.Position
        
        if targetIndicator and settings.showTarget then
            targetIndicator.Position = aimPos
            targetIndicator.Transparency = 0.3
        end
        
        -- Silent Aim
        if settings.silentAim then
            return aimPos
        end
        
        local camPos = camera.CFrame.Position
        local lookAt = CFrame.new(camPos, aimPos)
        camera.CFrame = camera.CFrame:Lerp(lookAt, settings.smoothness)
    end
end

-- =============================================
-- MOVEMENT FUNCTIONS
-- =============================================

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local function updateMovement()
    -- Speed
    if settings.speedEnabled then
        humanoid.WalkSpeed = settings.speedValue
    else
        humanoid.WalkSpeed = 16
    end
    
    -- Jump Power
    humanoid.JumpPower = settings.jumpPower
    
    -- Auto Jump
    if settings.autoJump then
        humanoid:Jump()
    end
    
    -- Noclip
    if settings.noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Fly
    if settings.fly then
        local bv = rootPart:FindFirstChild("FlyVelocity")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = rootPart
        end
        
        local moveDir = Vector3.new(0, 0, 0)
        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -settings.flySpeed) end
        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, settings.flySpeed) end
        if userInput:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-settings.flySpeed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(settings.flySpeed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, settings.flySpeed, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -settings.flySpeed, 0) end
        
        bv.Velocity = moveDir
    else
        local bv = rootPart:FindFirstChild("FlyVelocity")
        if bv then bv:Destroy() end
    end
end

-- =============================================
-- VISUAL FUNCTIONS
-- =============================================

local function updateVisuals()
    -- Fullbright
    if settings.fullbright then
        lighting.Brightness = 10
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        lighting.Brightness = 2
        lighting.Ambient = Color3.fromRGB(128, 128, 128)
    end
    
    -- No Fog
    if settings.noFog then
        lighting.FogEnd = 999999
    else
        lighting.FogEnd = 1000
    end
    
    -- God Mode
    if settings.godMode then
        humanoid.MaxHealth = 999999
        humanoid.Health = 999999
    else
        humanoid.MaxHealth = 100
    end
    
    -- Auto Heal
    if settings.autoHeal and humanoid.Health < humanoid.MaxHealth * 0.5 then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- =============================================
-- CREATE ULTIMATE MENU
-- =============================================

local function createUltimateMenu()
    if player.PlayerGui:FindFirstChild("AimCircleMenu") then
        player.PlayerGui.AimCircleMenu:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimCircleMenu"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 580)
    frame.Position = UDim2.new(0.5, -210, 0.5, -290)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    -- Glow Border
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(200, 50, 255)
    border.Thickness = 2
    border.Transparency = 0.5
    border.Parent = frame
    
    -- Title
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 50)
    titleFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 255)
    titleFrame.BackgroundTransparency = 0.3
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "👑 ULTIMATE AIM PRO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.Bold
    title.Parent = titleFrame
    
    -- Status
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0.9, 0, 0, 25)
    statusText.Position = UDim2.new(0.05, 0, 0.11, 0)
    statusText.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    statusText.BackgroundTransparency = 0.3
    statusText.Text = "🟢 ULTIMATE ACTIVE"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.Bold
    statusText.Parent = frame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusText
    
    -- ScrollFrame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -115)
    scrollFrame.Position = UDim2.new(0, 5, 0, 0.17)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.Parent = frame
    
    -- =============================================
    -- SECTIONS
    -- =============================================
    
    local function addSection(text, yPos)
        local section = Instance.new("TextLabel")
        section.Size = UDim2.new(0.9, 0, 0, 25)
        section.Position = UDim2.new(0.05, 0, 0, yPos)
        section.BackgroundColor3 = Color3.fromRGB(200, 50, 255)
        section.BackgroundTransparency = 0.2
        section.Text = text
        section.TextColor3 = Color3.fromRGB(255, 255, 255)
        section.TextScaled = true
        section.Font = Enum.Font.Bold
        section.Parent = scrollFrame
        
        local secCorner = Instance.new("UICorner")
        secCorner.CornerRadius = UDim.new(0, 5)
        secCorner.Parent = section
        
        return section
    end
    
    local function addToggle(text, key, yPos, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.42, 0, 0, 28)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = settings[key] and color or Color3.fromRGB(40, 40, 70)
        btn.BackgroundTransparency = 0.2
        btn.Text = text .. (settings[key] and " ✅" or " ❌")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Parent = scrollFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            settings[key] = not settings[key]
            btn.Text = text .. (settings[key] and " ✅" or " ❌")
            btn.BackgroundColor3 = settings[key] and color or Color3.fromRGB(40, 40, 70)
        end)
        
        return btn
    end
    
    local function addSlider(label, key, min, max, yPos)
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.5, 0, 0, 20)
        labelText.Position = UDim2.new(0.05, 0, 0, yPos)
        labelText.BackgroundTransparency = 1
        labelText.Text = label .. ": " .. settings[key]
        labelText.TextColor3 = Color3.fromRGB(200, 200, 255)
        labelText.TextScaled = true
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = scrollFrame
        
        local slider = Instance.new("ImageLabel")
        slider.Size = UDim2.new(0.4, 0, 0, 15)
        slider.Position = UDim2.new(0.55, 0, 0, yPos + 0.03)
        slider.Image = "rbxassetid://1318875445"
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        slider.BackgroundTransparency = 0.5
        slider.Parent = scrollFrame
        
        local knob = Instance.new("ImageLabel")
        knob.Size = UDim2.new(0, 15, 0, 15)
        knob.Position = UDim2.new((settings[key] - min) / (max - min), -7.5, 0, 0)
        knob.Image = "rbxassetid://1318875445"
        knob.BackgroundColor3 = Color3.fromRGB(200, 50, 255)
        knob.BackgroundTransparency = 0.5
        knob.Parent = slider
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        slider.MouseButton1Down:Connect(function()
            local connection
            connection = mouse.Move:Connect(function()
                local relX = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * relX
                knob.Position = UDim2.new(relX, -7.5, 0, 0)
                settings[key] = math.round(value)
                labelText.Text = label .. ": " .. settings[key]
            end)
            
            mouse.ButtonUp:Connect(function()
                connection:Disconnect()
            end)
        end)
        
        return slider
    end
    
    -- SECTION: AIM
    addSection("🎯 AIM SETTINGS", 0)
    addToggle("Aimbot", "enabled", 35, Color3.fromRGB(0, 150, 0))
    addToggle("Silent Aim", "silentAim", 68, Color3.fromRGB(100, 50, 200))
    addToggle("Show Target", "showTarget", 101, Color3.fromRGB(50, 100, 200))
    addToggle("Show Circle", "showCircle", 134, Color3.fromRGB(0, 200, 100))
    addToggle("Show FOV", "showFOV", 167, Color3.fromRGB(0, 150, 200))
    addSlider("Radius", "radius", 50, 300, 200)
    addSlider("Smoothness", "smoothness", 0.05, 0.9, 235)
    addSlider("FOV", "aimbotFOV", 50, 400, 270)
    addSlider("Max Distance", "maxDistance", 100, 800, 305)
    
    -- SECTION: ESP
    local espY = 350
    addSection("👁️ ESP SETTINGS", espY)
    addToggle("ESP", "espEnabled", espY + 35, Color3.fromRGB(0, 150, 200))
    addToggle("Box ESP", "espBox", espY + 68, Color3.fromRGB(0, 150, 200))
    addToggle("Name ESP", "espName", espY + 101, Color3.fromRGB(0, 150, 200))
    addToggle("Health ESP", "espHealth", espY + 134, Color3.fromRGB(0, 150, 200))
    addToggle("Distance ESP", "espDistance", espY + 167, Color3.fromRGB(0, 150, 200))
    
    -- SECTION: MOVEMENT
    local moveY = 520
    addSection("🚀 MOVEMENT", moveY)
    addToggle("Speed Hack", "speedEnabled", moveY + 35, Color3.fromRGB(0, 200, 100))
    addSlider("Speed Value", "speedValue", 16, 100, moveY + 70)
    addToggle("Fly", "fly", moveY + 105, Color3.fromRGB(100, 100, 255))
    addSlider("Fly Speed", "flySpeed", 10, 100, moveY + 140)
    addToggle("NoClip", "noclip", moveY + 175, Color3.fromRGB(200, 100, 200))
    addToggle("Auto Jump", "autoJump", moveY + 208, Color3.fromRGB(200, 150, 50))
    addSlider("Jump Power", "jumpPower", 50, 200, moveY + 243)
    
    -- SECTION: COMBAT
    local combatY = 690
    addSection("⚔️ COMBAT", combatY)
    addToggle("Auto Shoot", "autoShoot", combatY + 35, Color3.fromRGB(255, 50, 50))
    addToggle("No Recoil", "noRecoil", combatY + 68, Color3.fromRGB(255, 50, 50))
    addToggle("No Spread", "noSpread", combatY + 101, Color3.fromRGB(255, 50, 50))
    
    -- SECTION: PLAYER
    local playerY = 830
    addSection("🛡️ PLAYER", playerY)
    addToggle("God Mode", "godMode", playerY + 35, Color3.fromRGB(50, 200, 50))
    addToggle("Auto Heal", "autoHeal", playerY + 68, Color3.fromRGB(50, 200, 50))
    
    -- SECTION: VISUAL
    local visualY = 960
    addSection("🎨 VISUAL", visualY)
    addToggle("Fullbright", "fullbright", visualY + 35, Color3.fromRGB(200, 200, 50))
    addToggle("No Fog", "noFog", visualY + 68, Color3.fromRGB(200, 200, 50))
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.3, 0, 0, 35)
    closeBtn.Position = UDim2.new(0.35, 0, 0.94, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "❌ CLOSE"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.Bold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    return screenGui
end

-- =============================================
-- MAIN LOOP
-- =============================================

coroutine.wrap(function()
    while player:FindFirstChild("Humanoid") do
        updateCircle()
        updateFOV()
        autoAim()
        updateMovement()
        updateVisuals()
        
        if settings.espEnabled then
            updateESP()
        end
        
        wait(0.03)
    end
end)()

-- =============================================
-- KEYBINDS
-- =============================================

userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        local gui = player.PlayerGui:FindFirstChild("AimCircleMenu")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        settings.enabled = not settings.enabled
        print("Aimbot: " .. (settings.enabled and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.F7 then
        settings.fly = not settings.fly
        print("Fly: " .. (settings.fly and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.F6 then
        settings.godMode = not settings.godMode
        print("God Mode: " .. (settings.godMode and "ON" or "OFF"))
    end
end)

-- =============================================
-- CLEANUP
-- =============================================

player.CharacterAdded:Connect(function()
    if circle then circle:Destroy() end
    if targetIndicator then targetIndicator:Destroy() end
    if fovCircle then fovCircle:Destroy() end
    circle = nil
    targetIndicator = nil
    fovCircle = nil
    createUltimateCircle()
    createTargetIndicator()
    createFOVCircle()
end)

-- =============================================
-- START
-- =============================================

print("========================================")
print("  👑 ULTIMATE AIM PRO - MAX LEVEL")
print("========================================")
print("  All features unlocked")
print("  Auto Aim | ESP | Fly | God Mode")
print("  No Recoil | Speed Hack | Wallhack")
print("  Fullbright | No Fog | Auto Heal")
print("========================================")
print("  F9 = Menu")
print("  F8 = Aimbot")
print("  F7 = Fly")
print("  F6 = God Mode")
print("========================================")

createUltimateCircle()
createTargetIndicator()
createFOVCircle()
createUltimateMenu()

print("👑 ULTIMATE AIM PRO LOADED!")