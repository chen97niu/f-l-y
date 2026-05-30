-- NNNB 飞行脚本（摇杆控制前进后退左右移动，视角决定飞行方向，修复断触）
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local flying = false
local speed = 50

-- 多点触摸追踪
local activeTouches = {}

pcall(function() player.PlayerGui:FindFirstChild("NNBGui"):Destroy() end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NNBGui"
gui.ResetOnSpawn = false

-- ============ NN 圆形主按钮 ============
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

-- NN 可拖动
local draggingMain = false
local mainDragStart, mainPosStart = nil, nil

mainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        mainDragStart = input.Position
        mainPosStart = mainBtn.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - mainDragStart
        mainBtn.Position = UDim2.new(
            mainPosStart.X.Scale, mainPosStart.X.Offset + d.X,
            mainPosStart.Y.Scale, mainPosStart.Y.Offset + d.Y
        )
    end
end)

uis.TouchEnded:Connect(function(input)
    draggingMain = false
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
local draggingPanel = false
local panelDragStart, panelPosStart = nil, nil

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = true
        panelDragStart = input.Position
        panelPosStart = panel.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if draggingPanel and input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - panelDragStart
        panel.Position = UDim2.new(
            panelPosStart.X.Scale, panelPosStart.X.Offset + d.X,
            panelPosStart.Y.Scale, panelPosStart.Y.Offset + d.Y
        )
    end
end)

uis.TouchEnded:Connect(function(input)
    draggingPanel = false
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

mainBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        panel.Visible = not panel.Visible
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

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
    local camForward = cam.CFrame.LookVector
    local camRight = cam.CFrame.RightVector
    
    -- 水平方向（去掉Y分量，保持在地面平面）
    local forwardFlat = Vector3.new(camForward.X, 0, camForward.Z)
    if forwardFlat.Magnitude > 0 then forwardFlat = forwardFlat.Unit end
    local rightFlat = Vector3.new(camRight.X, 0, camRight.Z)
    if rightFlat.Magnitude > 0 then rightFlat = rightFlat.Unit end
    
    -- 遍历左半边触摸
    local moveX, moveY = 0, 0
    for _, data in pairs(activeTouches) do
        if data.isLeft and data.startPos and data.currentPos then
            local delta = data.currentPos - data.startPos
            if delta.Magnitude > 15 then
                local clamped = delta.Magnitude > 80 and delta.Unit * 80 or delta
                moveX = clamped.X / 80   -- 左右（-1到1）
                moveY = clamped.Y / 80   -- 上下（-1到1）
            end
        end
    end
    
    -- 组装飞行方向
    -- 摇杆推上（moveY负）= 前进
    -- 摇杆推下（moveY正）= 后退
    -- 摇杆推左（moveX负）= 左移
    -- 摇杆推右（moveX正）= 右移
    local flyDir = Vector3.zero
    flyDir += forwardFlat * (-moveY)   -- 前进/后退（基于视角水平方向）
    flyDir += rightFlat * moveX        -- 左右平移（基于视角水平方向）
    
    -- 上下飞：根据视角垂直方向
    -- 视角朝上时前进=上升，视角朝下时前进=下降
    flyDir += Vector3.new(0, camForward.Y, 0) * (-moveY)
    flyDir += Vector3.new(0, camRight.Y, 0) * moveX
    
    if flyDir.Magnitude > 1 then flyDir = flyDir.Unit end
    
    bv.Velocity = flyDir * speed
    bg.CFrame = cam.CFrame
end)

-- 重生
player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
end)