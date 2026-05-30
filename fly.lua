-- NNNB 飞行脚本（纯摇杆，无按钮，修复断触）
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local flying = false
local speed = 50

-- 摇杆数据（用多点触摸追踪，修复断触）
local activeTouches = {}

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

-- NN 按钮可拖动
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

uis.TouchEnded:Connect(function(input)
    dragMain = false
end)

-- ============ 弹出面板 ============
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 170, 0, 150)
panel.Position = UDim2.new(0.5, -85, 0.5, -75)
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

uis.TouchEnded:Connect(function(input)
    dragPanel = false
end)

-- 标题 NNNB
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "NNNB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.ZIndex = 19

-- 飞行按钮
local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0, 120, 0, 42)
flyBtn.Position = UDim2.new(0.5, -60, 0, 55)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBlack
flyBtn.TextSize = 18
flyBtn.ZIndex = 19
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 21)

-- 速度显示
local speedText = Instance.new("TextLabel", panel)
speedText.Size = UDim2.new(0, 120, 0, 18)
speedText.Position = UDim2.new(0.5, -60, 0, 105)
speedText.BackgroundTransparency = 1
speedText.Text = "速度：50"
speedText.TextColor3 = Color3.fromRGB(200, 200, 200)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 12
speedText.TextXAlignment = Enum.TextXAlignment.Center
speedText.ZIndex = 19

-- 速度 -
local speedDown = Instance.new("TextButton", panel)
speedDown.Size = UDim2.new(0, 30, 0, 22)
speedDown.Position = UDim2.new(0.5, -40, 0, 125)
speedDown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedDown.Text = "-"
speedDown.TextSize = 14
speedDown.ZIndex = 19
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 11)

-- 速度 +
local speedUp = Instance.new("TextButton", panel)
speedUp.Size = UDim2.new(0, 30, 0, 22)
speedUp.Position = UDim2.new(0.5, 10, 0, 125)
speedUp.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUp.Text = "+"
speedUp.TextSize = 14
speedUp.ZIndex = 19
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 11)

-- 关闭按钮
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.ZIndex = 19
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- ============ 功能函数 ============
local function startFly()
    flying = true
    hum.PlatformStand = true
    local bg = Instance.new("BodyGyro", root)
    bg.Name = "FlyGyro"
    bg.MaxTorque = Vector3.new(1,1,1) * math.huge
    local bv = Instance.new("BodyVelocity", root)
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(1,1,1) * math.huge
    flyBtn.Text = "飞行中..."
    flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    panel.Visible = false
    mainBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end

local function stopFly()
    flying = false
    hum.PlatformStand = false
    for _, n in ipairs({"FlyGyro", "FlyVelocity"}) do
        local obj = root:FindFirstChild(n)
        if obj then obj:Destroy() end
    end
    flyBtn.Text = "飞行"
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    activeTouches = {}
end

-- 点 NN 按钮
mainBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        panel.Visible = not panel.Visible
    end
end)

-- 飞行按钮
flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

-- 关闭按钮
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

-- 速度
speedDown.MouseButton1Click:Connect(function()
    speed = math.max(5, speed - 5)
    speedText.Text = "速度："..speed
end)
speedUp.MouseButton1Click:Connect(function()
    speed = math.min(500, speed + 5)
    speedText.Text = "速度："..speed
end)

-- ============ 多点触摸摇杆（修复断触） ============
local screenWidth = workspace.CurrentCamera.ViewportSize.X
local screenHalf = screenWidth / 2

uis.TouchStarted:Connect(function(touch, gameProcessed)
    activeTouches[touch] = {
        startPos = touch.Position,
        currentPos = touch.Position,
        isLeft = touch.Position.X < screenHalf
    }
end)

uis.TouchMoved:Connect(function(touch, gameProcessed)
    if activeTouches[touch] then
        activeTouches[touch].currentPos = touch.Position
    end
end)

uis.TouchEnded:Connect(function(touch, gameProcessed)
    activeTouches[touch] = nil
end)

-- ============ 飞行循环 ============
rs.RenderStepped:Connect(function()
    if not flying then return end
    
    local bv = root:FindFirstChild("FlyVelocity")
    local bg = root:FindFirstChild("FlyGyro")
    if not bv or not bg then return end
    
    local cam = workspace.CurrentCamera
    
    -- 遍历所有活跃触摸，找左边的摇杆触摸
    local moveDir = Vector3.zero
    for _, data in pairs(activeTouches) do
        if data.isLeft and data.startPos and data.currentPos then
            local delta = data.currentPos - data.startPos
            if delta.Magnitude > 15 then
                local clamped = delta.Magnitude > 80 and delta.Unit * 80 or delta
                local nx = clamped.X / 80  -- 左右
                local ny = clamped.Y / 80  -- 上下
                -- 水平移动
                moveDir += cam.CFrame.RightVector * nx
                -- 垂直移动（摇杆上推=上升，下推=下降）
                moveDir += Vector3.new(0, 1, 0) * (-ny)
            end
        end
    end
    
    if moveDir.Magnitude > 1 then moveDir = moveDir.Unit end
    
    bv.Velocity = moveDir * speed
    bg.CFrame = cam.CFrame
end)

-- 重生
player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
end)