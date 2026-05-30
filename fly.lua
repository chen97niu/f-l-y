-- NNNB 菜单系统（飞行+穿墙+透视，独立按钮，菜单不消失）
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local flying = false
local speed = 50
local noclip = false
local espEnabled = false
local activeTouches = {}
local espObjects = {}

pcall(function() player.PlayerGui:FindFirstChild("NNBGui"):Destroy() end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NNBGui"
gui.ResetOnSpawn = false

-- ============ NN 主按钮（始终显示） ============
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

-- NN 按钮拖动
local dragMain, dragStartPos, btnStartPos = false, nil, nil
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
        mainBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
uis.TouchEnded:Connect(function() dragMain = false end)

-- ============ 菜单面板（独立，不会自动关闭） ============
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 180, 0, 300)
panel.Position = UDim2.new(0.5, -90, 0.5, -150)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
panel.BackgroundTransparency = 0.1
panel.Visible = false
panel.ZIndex = 19
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

-- 面板拖动
local dragPanel, panelDragStart, panelStartPos = false, nil, nil
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
        panel.Position = UDim2.new(panelStartPos.X.Scale, panelStartPos.X.Offset + delta.X, panelStartPos.Y.Scale, panelStartPos.Y.Offset + delta.Y)
    end
end)
uis.TouchEnded:Connect(function() dragPanel = false end)

-- 标题 NNNB
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -30, 0, 35)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.Text = "NNNB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 19

-- 关闭菜单按钮（只关菜单，不影响功能）
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.ZIndex = 19
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- 分隔线
local divider1 = Instance.new("Frame", panel)
divider1.Size = UDim2.new(0.9, 0, 0, 1)
divider1.Position = UDim2.new(0.05, 0, 0, 48)
divider1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider1.ZIndex = 19

-- ============ 飞行开关按钮 ============
local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0, 150, 0, 40)
flyBtn.Position = UDim2.new(0.5, -75, 0, 58)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行：关"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBlack
flyBtn.TextSize = 16
flyBtn.ZIndex = 19
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 20)

-- ============ 穿墙开关按钮 ============
local noclipBtn = Instance.new("TextButton", panel)
noclipBtn.Size = UDim2.new(0, 150, 0, 40)
noclipBtn.Position = UDim2.new(0.5, -75, 0, 108)
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipBtn.Text = "穿墙：关"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamBlack
noclipBtn.TextSize = 16
noclipBtn.ZIndex = 19
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 20)

-- ============ 透视开关按钮 ============
local espBtn = Instance.new("TextButton", panel)
espBtn.Size = UDim2.new(0, 150, 0, 40)
espBtn.Position = UDim2.new(0.5, -75, 0, 158)
espBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
espBtn.Text = "透视：关"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.GothamBlack
espBtn.TextSize = 16
espBtn.ZIndex = 19
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 20)

-- 分隔线
local divider2 = Instance.new("Frame", panel)
divider2.Size = UDim2.new(0.9, 0, 0, 1)
divider2.Position = UDim2.new(0.05, 0, 0, 210)
divider2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider2.ZIndex = 19

-- ============ 速度显示 ============
local speedText = Instance.new("TextLabel", panel)
speedText.Size = UDim2.new(0, 150, 0, 18)
speedText.Position = UDim2.new(0.5, -75, 0, 220)
speedText.BackgroundTransparency = 1
speedText.Text = "飞行速度：50"
speedText.TextColor3 = Color3.fromRGB(200, 200, 200)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 12
speedText.TextXAlignment = Enum.TextXAlignment.Center
speedText.ZIndex = 19

-- 速度 -
local speedDown = Instance.new("TextButton", panel)
speedDown.Size = UDim2.new(0, 40, 0, 25)
speedDown.Position = UDim2.new(0.5, -60, 0, 245)
speedDown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedDown.Text = "-"
speedDown.TextSize = 14
speedDown.ZIndex = 19
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 12)

-- 速度 +
local speedUp = Instance.new("TextButton", panel)
speedUp.Size = UDim2.new(0, 40, 0, 25)
speedUp.Position = UDim2.new(0.5, 20, 0, 245)
speedUp.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUp.Text = "+"
speedUp.TextSize = 14
speedUp.ZIndex = 19
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 12)

-- 状态指示灯
local statusLabel = Instance.new("TextLabel", panel)
statusLabel.Size = UDim2.new(0, 150, 0, 15)
statusLabel.Position = UDim2.new(0.5, -75, 0, 278)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 19

-- ============ 透视功能 ============
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "NN_ESP"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = targetChar
    
    local billboard = Instance.new("BillboardGui", targetHead)
    billboard.Name = "NN_ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = targetPlayer.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    
    table.insert(espObjects, {highlight = highlight, billboard = billboard, player = targetPlayer})
end

local function clearESP()
    for _, obj in ipairs(espObjects) do
        if obj.highlight and obj.highlight.Parent then obj.highlight:Destroy() end
        if obj.billboard and obj.billboard.Parent then obj.billboard:Destroy() end
    end
    espObjects = {}
end

local function refreshESP()
    clearESP()
    if espEnabled then
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                pcall(function() createESP(p) end)
            end
        end
    end
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espEnabled then wait(0.5) pcall(function() createESP(p) end) end
    end)
end)

game.Players.PlayerRemoving:Connect(function(p)
    for i, obj in ipairs(espObjects) do
        if obj.player == p then
            if obj.highlight then obj.highlight:Destroy() end
            if obj.billboard then obj.billboard:Destroy() end
            table.remove(espObjects, i)
            break
        end
    end
end)

-- ============ 更新状态显示 ============
local function updateStatus()
    local parts = {}
    if flying then table.insert(parts, "✈飞行中") end
    if noclip then table.insert(parts, "🧱穿墙") end
    if espEnabled then table.insert(parts, "👁透视") end
    if #parts > 0 then
        statusLabel.Text = table.concat(parts, " | ")
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "待机中"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

-- ============ 飞行功能 ============
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
    mainBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    updateStatus()
end

local function stopFly()
    flying = false
    if noclip then
        noclip = false
        noclipBtn.Text = "穿墙：关"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
    hum.PlatformStand = false
    for _, n in ipairs({"FlyGyro", "FlyVelocity"}) do
        local obj = root:FindFirstChild(n)
        if obj then obj:Destroy() end
    end
    flyBtn.Text = "飞行：关"
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    activeTouches = {}
    updateStatus()
end

-- ============ 穿墙功能 ============
local function toggleNoclip()
    if not flying then return end
    noclip = not noclip
    if noclip then
        noclipBtn.Text = "穿墙：开"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    else
        noclipBtn.Text = "穿墙：关"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
    updateStatus()
end

-- 穿墙循环
rs.Stepped:Connect(function()
    if noclip and flying and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ============ 透视功能 ============
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "透视：开"
        espBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        refreshESP()
    else
        espBtn.Text = "透视：关"
        espBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        clearESP()
    end
    updateStatus()
end

-- ============ 按钮事件 ============
mainBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

noclipBtn.MouseButton1Click:Connect(toggleNoclip)
espBtn.MouseButton1Click:Connect(toggleESP)

speedDown.MouseButton1Click:Connect(function()
    speed = math.max(5, speed - 5)
    speedText.Text = "飞行速度："..speed
end)

speedUp.MouseButton1Click:Connect(function()
    speed = math.min(500, speed + 5)
    speedText.Text = "飞行速度："..speed
end)

-- ============ 摇杆 ============
local screenHalf = workspace.CurrentCamera.ViewportSize.X / 2

uis.TouchStarted:Connect(function(touch, gp)
    activeTouches[touch] = {
        startPos = touch.Position,
        currentPos = touch.Position,
        isLeft = touch.Position.X < screenHalf
    }
end)
uis.TouchMoved:Connect(function(touch, gp)
    if activeTouches[touch] then activeTouches[touch].currentPos = touch.Position end
end)
uis.TouchEnded:Connect(function(touch, gp)
    activeTouches[touch] = nil
end)

-- ============ 飞行循环 ============
rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv = root:FindFirstChild("FlyVelocity")
    local bg = root:FindFirstChild("FlyGyro")
    if not bv or not bg then return end
    
    local cam = workspace.CurrentCamera
    local moveDir = Vector3.zero
    
    for _, data in pairs(activeTouches) do
        if data.isLeft and data.startPos and data.currentPos then
            local delta = data.currentPos - data.startPos
            if delta.Magnitude > 15 then
                local clamped = delta.Magnitude > 80 and delta.Unit * 80 or delta
                local nx = clamped.X / 80
                local ny = clamped.Y / 80
                moveDir += cam.CFrame.RightVector * nx
                moveDir += cam.CFrame.LookVector * (-ny)
            end
        end
    end
    
    if moveDir.Magnitude > 1 then moveDir = moveDir.Unit end
    bv.Velocity = moveDir * speed
    bg.CFrame = cam.CFrame
end)

player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
    if espEnabled then wait(0.5) refreshESP() end
end)

updateStatus()