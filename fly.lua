- 飞行开关
local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0.85, 0, 0, 38)
flyBtn.Position = UDim2.new(0.075, 0, 0.08, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行：关"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 15
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 8)

-- 速度显示
local speedText = Instance.new("TextLabel", panel)
speedText.Size = UDim2.new(0.85, 0, 0, 22)
speedText.Position = UDim2.new(0.075, 0, 0.33, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "速度：50"
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 13
speedText.TextXAlignment = Enum.TextXAlignment.Left

-- 减速度
local speedDown = Instance.new("TextButton", panel)
speedDown.Size = UDim2.new(0.35, 0, 0, 30)
speedDown.Position = UDim2.new(0.1, 0, 0.48, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedDown.Text = "-"
speedDown.TextSize = 20
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 6)

-- 加速度
local speedUp = Instance.new("TextButton", panel)
speedUp.Size = UDim2.new(0.35, 0, 0, 30)
speedUp.Position = UDim2.new(0.55, 0, 0.48, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedUp.Text = "+"
speedUp.TextSize = 20
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 6)

-- 预设速度
local presets = {25, 50, 100, 200}
for i, v in ipairs(presets) do
    local btn = Instance.new("TextButton", panel)
    btn.Size = UDim2.new(0.85, 0, 0, 20)
    btn.Position = UDim2.new(0.075, 0, 0.68 + (i-1)*0.08, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = "速度 "..v
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function()
        speed = v
        speedText.Text = "速度："..v
    end)
end

-- 摇杆
local joyFrame = Instance.new("Frame", gui)
joyFrame.Size = UDim2.new(0, 120, 0, 120)
joyFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
joyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyFrame.BackgroundTransparency = 0.8
joyFrame.Visible = false
Instance.new("UICorner", joyFrame).CornerRadius = UDim.new(0, 60)

local joyThumb = Instance.new("Frame", joyFrame)
joyThumb.Size = UDim2.new(0, 45, 0, 45)
joyThumb.Position = UDim2.new(0.5, -22, 0.5, -22)
joyThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joyThumb.BackgroundTransparency = 0.5
Instance.new("UICorner", joyThumb).CornerRadius = UDim.new(0, 22)

-- 上升按钮
local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0, 55, 0, 55)
upBtn.Position = UDim2.new(0.8, 0, 0.6, 0)
upBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
upBtn.BackgroundTransparency = 0.5
upBtn.Text = "⬆"
upBtn.TextSize = 24
upBtn.Visible = false
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(0, 27)

-- 下降按钮
local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0, 55, 0, 55)
downBtn.Position = UDim2.new(0.8, 0, 0.75, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
downBtn.BackgroundTransparency = 0.5
downBtn.Text = "⬇"
downBtn.TextSize = 24
downBtn.Visible = false
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0, 27)

-- 功能
local moveDir = Vector3.zero
local upHeld, downHeld = false, false
local joyActive = false

local function startFly()
    flying = true
    hum.PlatformStand = true
    local bg = Instance.new("BodyGyro", root)
    bg.Name = "FlyGyro"
    bg.MaxTorque = Vector3.new(1,1,1) * math.huge
    local bv = Instance.new("BodyVelocity", root)
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(1,1,1) * math.huge
    flyBtn.Text = "飞行：开"
    flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    joyFrame.Visible = true
    upBtn.Visible = true
    downBtn.Visible = true
end

local function stopFly()
    flying = false
    hum.PlatformStand = false
    for _, n in ipairs({"FlyGyro", "FlyVelocity"}) do
        local obj = root:FindFirstChild(n)
        if obj then obj:Destroy() end
    end
    flyBtn.Text = "飞行：关"
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    joyFrame.Visible = false
    upBtn.Visible = false
    downBtn.Visible = false
end

-- 按钮事件
mainBtn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)
flyBtn.MouseButton1Click:Connect(function() if flying then stopFly() else startFly() end end)
speedDown.MouseButton1Click:Connect(function() speed = math.max(5, speed - 5); speedText.Text = "速度："..speed end)
speedUp.MouseButton1Click:Connect(function() speed = math.min(500, speed + 5); speedText.Text = "速度："..speed end)

-- 摇杆事件
joyFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then joyActive = true end
end)
joyFrame.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        joyActive = false
        joyThumb.Position = UDim2.new(0.5, -22, 0.5, -22)
        moveDir = Vector3.zero
    end
end)
joyFrame.InputChanged:Connect(function(i)
    if joyActive and i.UserInputType == Enum.UserInputType.Touch then
        local center = Vector2.new(60, 60)
        local pos = Vector2.new(i.Position.X, i.Position.Y) - joyFrame.AbsolutePosition
        local dir = pos - center
        local dist = math.min(dir.Magnitude, 37)
        if dir.Magnitude > 0 then dir = dir.Unit * dist end
        joyThumb.Position = UDim2.new(0, dir.X + 37, 0, dir.Y + 37)
        local cam = workspace.CurrentCamera
        moveDir = cam.CFrame.LookVector * (-dir.Y/37) + cam.CFrame.RightVector * (dir.X/37)
        if moveDir.Magnitude > 1 then moveDir = moveDir.Unit end
    end
end)

-- 上下按钮事件
upBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then upHeld = true end end)
upBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then upHeld = false end end)
downBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then downHeld = true end end)
downBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then downHeld = false end end)

-- 飞行循环
rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv = root:FindFirstChild("FlyVelocity")
    local bg = root:FindFirstChild("FlyGyro")
    if not bv or not bg then return end
    local vel = moveDir * speed
    if upHeld then vel = vel + Vector3.new(0, speed, 0) end
    if downHeld then vel = vel - Vector3.new(0, speed, 0) end
    bv.Velocity = vel
    bg.CFrame = workspace.CurrentCamera.CFrame
end)

-- 重生处理
player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
end)
