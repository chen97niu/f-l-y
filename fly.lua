-- NNNB 飞行+穿墙+透视脚本（手机版，纯摇杆）
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

-- ============ NN 主按钮 ============
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

-- ============ 面板 ============
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 170, 0, 260)
panel.Position = UDim2.new(0.5, -85, 0.5, -130)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
panel.BackgroundTransparency = 0.1
panel.Visible = false
panel.ZIndex = 19
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

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

-- 标题
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.Text = "NNNB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 19

-- 关闭
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.ZIndex = 19
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- 飞行按钮
local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0, 140, 0, 35)
flyBtn.Position = UDim2.new(0.5, -70, 0, 48)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBlack
flyBtn.TextSize = 15
flyBtn.ZIndex = 19
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 17)

-- 穿墙按钮
local noclipBtn = Instance.new("TextButton", panel)
noclipBtn.Size = UDim2.new(0, 140, 0, 35)
noclipBtn.Position = UDim2.new(0.5, -70, 0, 90)
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipBtn.Text = "穿墙：关"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamBlack
noclipBtn.TextSize = 15
noclipBtn.ZIndex = 19
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 17)

-- 透视按钮
local espBtn = Instance.new("TextButton", panel)
espBtn.Size = UDim2.new(0, 140, 0, 35)
espBtn.Position = UDim2.new(0.5, -70, 0, 132)
espBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
espBtn.Text = "透视：关"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.GothamBlack
espBtn.TextSize = 15
espBtn.ZIndex = 19
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 17)

-- 速度显示
local speedText = Instance.new("TextLabel", panel)
speedText.Size = UDim2.new(0, 140, 0, 16)
speedText.Position = UDim2.new(0.5, -70, 0, 175)
speedText.BackgroundTransparency = 1
speedText.Text = "速度：50"
speedText.TextColor3 = Color3.fromRGB(200, 200, 200)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 11
speedText.TextXAlignment = Enum.TextXAlignment.Center
speedText.ZIndex = 19

local speedDown = Instance.new("TextButton", panel)
speedDown.Size = UDim2.new(0, 35, 0, 22)
speedDown.Position = UDim2.new(0.5, -55, 0, 195)
speedDown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedDown.Text = "-"
speedDown.TextSize = 13
speedDown.ZIndex = 19
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 11)

local speedUp = Instance.new("TextButton", panel)
speedUp.Size = UDim2.new(0, 35, 0, 22)
speedUp.Position = UDim2.new(0.5, 20, 0, 195)
speedUp.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUp.Text = "+"
speedUp.TextSize = 13
speedUp.ZIndex = 19
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 11)

-- ============ 透视功能 ============
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetRoot or not targetHead then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "NN_ESP"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = targetChar
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NN_ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = targetHead
    
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

-- ============ 穿墙功能 ============
local function enableNoclip()
    noclip = true
    noclipBtn.Text = "穿墙：开"
    noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
end

local function disableNoclip()
    noclip = false
    noclipBtn.Text = "穿墙：关"
    noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end

local function toggleNoclip()
    if not flying then return end
    if noclip then disableNoclip() else enableNoclip() end
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
    flyBtn.Text = "飞行中..."
    flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    panel.Visible = false
    mainBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end

local function stopFly()
    flying = false
    disableNoclip()
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
    if flying then stopFly() else panel.Visible = not panel.Visible end
end)
flyBtn.MouseButton1Click:Connect(function() if flying then stopFly() else startFly() end end)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
espBtn.MouseButton1Click:Connect(toggleESP)
speedDown.MouseButton1Click:Connect(function() speed = math.max(5, speed - 5); speedText.Text = "速度："..speed end)
speedUp.MouseButton1Click:Connect(function() speed = math.min(500, speed + 5); speedText.Text = "速度："..speed end)

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