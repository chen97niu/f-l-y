-- NNNB 飞行脚本（手机版，默认摇杆移动）
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local flying = false
local speed = 50
local moveDirection = Vector3.zero
local upHeld, downHeld = false, false

-- 摇杆读取
local touchStartPos, touchCurrentPos, touchActive = nil, nil, false

pcall(function() player.PlayerGui:FindFirstChild("NNBGui"):Destroy() end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NNBGui"
gui.ResetOnSpawn = false

-- ============ NN 主按钮（圆形） ============
local mainBtn = Instance.new("TextButton", gui)
mainBtn.Size = UDim2.new(0, 55, 0, 55)
mainBtn.Position = UDim2.new(0.5, -27, 0.5, -27)
mainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainBtn.BackgroundTransparency = 0.2
mainBtn.Text = "NN"
mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.TextSize = 18
mainBtn.ZIndex = 20
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(1, 0)

-- ============ NN 按钮可拖动 ============
local dragMain = false
local dragStartPos, btnStartPos = nil, nil

mainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragMain = true
        dragStartPos = input.Position
        btnStartPos = mainBtn.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if dragMain and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        mainBtn.Position = UDim2.new(
            btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
        )
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragMain = false
    end
end)

-- ============ 弹出面板 ============
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 170, 0, 180)
panel.Position = UDim2.new(0.5, -85, 0.5, -90)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
panel.BackgroundTransparency = 0.1
panel.Visible = false
panel.ZIndex = 19
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

-- 面板可拖动
local dragPanel = false
local panelDragStart, panelStartPos = nil, nil

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragPanel = true
        panelDragStart = input.Position
        panelStartPos = panel.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if dragPanel and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - panelDragStart
        panel.Position = UDim2.new(
            panelStartPos.X.Scale, panelStartPos.X.Offset + delta.X,
            panelStartPos.Y.Scale, panelStartPos.Y.Offset + delta.Y
        )
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragPanel = false
    end
end)

-- ============ 标题 NNNB ============
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "NNNB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.ZIndex = 19

-- ============ 飞行按钮 ============
local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0, 130, 0, 40)
flyBtn.Position = UDim2.new(0.5, -65, 0, 50)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBlack
flyBtn.TextSize = 18
flyBtn.ZIndex = 19
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 20)

-- ============ 速度显示 ============
local speedText = Instance.new("TextLabel", panel)
speedText.Size = UDim2.new(0, 130, 0, 18)
speedText.Position = UDim2.new(0.5, -65, 0, 100)
speedText.BackgroundTransparency = 1
speedText.Text = "速度：50"
speedText.TextColor3 = Color3.fromRGB(200, 200, 200)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 11
speedText.TextXAlignment = Enum.TextXAlignment.Center
speedText.ZIndex = 19

-- ============ 速度调节 ============
local speedDown = Instance.new("TextButton", panel)
speedDown.Size = UDim2.new(0, 35, 0, 25)
speedDown.Position = UDim2.new(0.5, -55, 0, 125)
speedDown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedDown.Text = "-"
speedDown.TextSize = 16
speedDown.ZIndex = 19
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 12)

local speedUp = Instance.new("TextButton", panel)
speedUp.Size = UDim2.new(0, 35, 0, 25)
speedUp.Position = UDim2.new(0.5, 20, 0, 125)
speedUp.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUp.Text = "+"
speedUp.TextSize = 16
speedUp.ZIndex = 19
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 12)

-- ============ 关闭按钮 ============
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.ZIndex = 19
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- ============ 升降按钮（飞行时显示在右侧） ============
local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0, 50, 0, 50)
upBtn.Position = UDim2.new(0.84, 0, 0.52, 0)
upBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
upBtn.BackgroundTransparency = 0.3
upBtn.Text = "⬆"
upBtn.TextSize = 22
upBtn.Visible = false
upBtn.ZIndex = 18
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1, 0)

local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0, 50, 0, 50)
downBtn.Position = UDim2.new(0.84, 0, 0.67, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
downBtn.BackgroundTransparency = 0.3
downBtn.Text = "⬇"
downBtn.TextSize = 22
downBtn.Visible = false
downBtn.ZIndex = 18
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(1, 0)

-- ============ 功能 ============
local function startFly()
    flying = true
    hum.PlatformStand = true
    Instance.new("BodyGyro", root).MaxTorque = Vector3.new(1,1,1) * math.huge
    root.BodyGyro.Name = "FlyGyro"
    Instance.new("BodyVelocity", root).MaxForce = Vector3.new(1,1,1) * math.huge
    root.BodyVelocity.Name = "FlyVelocity"
    flyBtn.Text = "飞行中..."
    flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    upBtn.Visible = true
    downBtn.Visible = true
    panel.Visible = false
    mainBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end

local function stopFly()
    flying = false
    hum.PlatformStand = false
    for _, n in ipairs({"FlyGyro", "FlyVelocity"}) do
        if root:FindFirstChild(n) then root[n]:Destroy() end
    end
    flyBtn.Text = "飞行"
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    upBtn.Visible = false
    downBtn.Visible = false
    moveDirection = Vector3.zero
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
end

-- 点 NN 按钮打开面板
mainBtn.MouseButton1Click:Connect(function()
    if not flying then
        panel.Visible = not panel.Visible
    else
        -- 飞行中点 NN 直接关闭飞行
        stopFly()
    end
end)

-- 点飞行按钮
flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

-- 关闭按钮
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

-- 速度调节
speedDown.MouseButton1Click:Connect(function()
    speed = math.max(5, speed - 5)
    speedText.Text = "速度："..speed
end)
speedUp.MouseButton1Click:Connect(function()
    speed = math.min(500, speed + 5)
    speedText.Text = "速度："..speed
end)

-- 升降按钮
upBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then upHeld = true end end)
upBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then upHeld = false end end)
downBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then downHeld = true end end)
downBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then downHeld = false end end)

-- ============ 读取游戏默认摇杆 ============
uis.TouchStarted:Connect(function(touch, gameProcessed)
    if touch.Position.X < workspace.CurrentCamera.ViewportSize.X / 2 then
        touchStartPos = touch.Position
        touchCurrentPos = touch.Position
        touchActive = true
    end
end)

uis.TouchMoved:Connect(function(touch, gameProcessed)
    if touchActive and touchStartPos then
        touchCurrentPos = touch.Position
    end
end)

uis.TouchEnded:Connect(function(touch, gameProcessed)
    if touchActive then
        touchActive = false
        touchStartPos = nil
        touchCurrentPos = nil
        moveDirection = Vector3.zero
    end
end)

-- ============ 飞行循环 ============
rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv = root:FindFirstChild("FlyVelocity")
    local bg = root:FindFirstChild("FlyGyro")
    if not bv or not bg then return end
    
    local cam = workspace.CurrentCamera
    
    if touchActive and touchStartPos and touchCurrentPos then
        local delta = touchCurrentPos - touchStartPos
        if delta.Magnitude > 15 then
            local clampedDelta = delta.Magnitude > 80 and delta.Unit * 80 or delta
            local nx = clampedDelta.X / 80
            local ny = clampedDelta.Y / 80
            moveDirection = cam.CFrame.LookVector * (-ny) + cam.CFrame.RightVector * nx
            if moveDirection.Magnitude > 1 then moveDirection = moveDirection.Unit end
        else
            moveDirection = Vector3.zero
        end
    end
    
    local vel = moveDirection * speed
    if upHeld then vel += Vector3.new(0, speed, 0) end
    if downHeld then vel -= Vector3.new(0, speed, 0) end
    
    bv.Velocity = vel
    bg.CFrame = cam.CFrame
end)

player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
end)