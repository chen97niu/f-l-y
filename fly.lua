-- NNNB v1.0 菜单系统（飞行+穿墙+透视+传送+防检测）
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tpService = game:GetService("TeleportService")

-- 状态变量
local flying = false
local speed = 40
local noclip = false
local espEnabled = false
local activeTouches = {}
local espObjects = {}
local speedLevels = {40, 100, 500, 1000}
local currentSpeedLevel = 1

-- 防检测：随机化名称
local function randomName()
    local chars = {}
    for i = 1, 8 do
        table.insert(chars, string.char(math.random(65, 90)))
    end
    return table.concat(chars)
end

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

-- NN 拖动
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

-- ============ 菜单面板 ============
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 180, 0, 420)
panel.Position = UDim2.new(0.5, -90, 0.5, -210)
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

-- 标题 NNNB（彩色渐变效果）
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.Text = "NNNB"
title.TextColor3 = Color3.fromRGB(255, 100, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 19

-- 版本号
local version = Instance.new("TextLabel", panel)
version.Size = UDim2.new(1, -30, 0, 15)
version.Position = UDim2.new(0, 15, 0, 36)
version.BackgroundTransparency = 1
version.Text = "v.1.0"
version.TextColor3 = Color3.fromRGB(255, 50, 50)
version.Font = Enum.Font.GothamBold
version.TextSize = 10
version.TextXAlignment = Enum.TextXAlignment.Left
version.ZIndex = 19

-- 关闭按钮
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.ZIndex = 19
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- 分隔线
local divider0 = Instance.new("Frame", panel)
divider0.Size = UDim2.new(0.9, 0, 0, 1)
divider0.Position = UDim2.new(0.05, 0, 0, 55)
divider0.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider0.ZIndex = 19

-- ============ 1. 飞行按钮（包含速度档位） ============
local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0, 150, 0, 38)
flyBtn.Position = UDim2.new(0.5, -75, 0, 65)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行：关"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBlack
flyBtn.TextSize = 16
flyBtn.ZIndex = 19
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 19)

-- 速度档位显示
local speedLevelText = Instance.new("TextLabel", panel)
speedLevelText.Size = UDim2.new(0, 150, 0, 16)
speedLevelText.Position = UDim2.new(0.5, -75, 0, 108)
speedLevelText.BackgroundTransparency = 1
speedLevelText.Text = "速度档位：1档 (40)"
speedLevelText.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLevelText.Font = Enum.Font.Gotham
speedLevelText.TextSize = 11
speedLevelText.TextXAlignment = Enum.TextXAlignment.Center
speedLevelText.ZIndex = 19

-- 速度档位按钮（2个，左减右加）
local speedDownBtn = Instance.new("TextButton", panel)
speedDownBtn.Size = UDim2.new(0, 35, 0, 24)
speedDownBtn.Position = UDim2.new(0.5, -55, 0, 128)
speedDownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedDownBtn.Text = "◀"
speedDownBtn.TextSize = 12
speedDownBtn.ZIndex = 19
Instance.new("UICorner", speedDownBtn).CornerRadius = UDim.new(0, 12)

local speedUpBtn = Instance.new("TextButton", panel)
speedUpBtn.Size = UDim2.new(0, 35, 0, 24)
speedUpBtn.Position = UDim2.new(0.5, 20, 0, 128)
speedUpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUpBtn.Text = "▶"
speedUpBtn.TextSize = 12
speedUpBtn.ZIndex = 19
Instance.new("UICorner", speedUpBtn).CornerRadius = UDim.new(0, 12)

-- 分隔线
local divider1 = Instance.new("Frame", panel)
divider1.Size = UDim2.new(0.9, 0, 0, 1)
divider1.Position = UDim2.new(0.05, 0, 0, 162)
divider1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider1.ZIndex = 19

-- ============ 2. 穿墙按钮 ============
local noclipBtn = Instance.new("TextButton", panel)
noclipBtn.Size = UDim2.new(0, 150, 0, 38)
noclipBtn.Position = UDim2.new(0.5, -75, 0, 172)
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipBtn.Text = "穿墙：关"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamBlack
noclipBtn.TextSize = 16
noclipBtn.ZIndex = 19
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 19)

-- 分隔线
local divider2 = Instance.new("Frame", panel)
divider2.Size = UDim2.new(0.9, 0, 0, 1)
divider2.Position = UDim2.new(0.05, 0, 0, 220)
divider2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider2.ZIndex = 19

-- ============ 3. 透视按钮 ============
local espBtn = Instance.new("TextButton", panel)
espBtn.Size = UDim2.new(0, 150, 0, 38)
espBtn.Position = UDim2.new(0.5, -75, 0, 230)
espBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
espBtn.Text = "透视：关"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.GothamBlack
espBtn.TextSize = 16
espBtn.ZIndex = 19
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 19)

-- 分隔线
local divider3 = Instance.new("Frame", panel)
divider3.Size = UDim2.new(0.9, 0, 0, 1)
divider3.Position = UDim2.new(0.05, 0, 0, 278)
divider3.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider3.ZIndex = 19

-- ============ 4. 传送功能 ============
local teleportBtn = Instance.new("TextButton", panel)
teleportBtn.Size = UDim2.new(0, 150, 0, 38)
teleportBtn.Position = UDim2.new(0.5, -75, 0, 288)
teleportBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
teleportBtn.Text = "传送玩家"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBlack
teleportBtn.TextSize = 16
teleportBtn.ZIndex = 19
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 19)

-- 玩家列表（传送用）
local playerList = Instance.new("ScrollingFrame", panel)
playerList.Size = UDim2.new(0, 150, 0, 0)
playerList.Position = UDim2.new(0.5, -75, 0, 335)
playerList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
playerList.BackgroundTransparency = 0.3
playerList.BorderSizePixel = 0
playerList.Visible = false
playerList.ZIndex = 19
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 4
Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 8)

local playerListLayout = Instance.new("UIListLayout", playerList)
playerListLayout.Padding = UDim.new(0, 3)
playerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerListLayout.SortOrder = Enum.SortOrder.Name

-- 状态栏
local statusLabel = Instance.new("TextLabel", panel)
statusLabel.Size = UDim2.new(0, 150, 0, 15)
statusLabel.Position = UDim2.new(0.5, -75, 0, 400)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "待机中"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 19

-- ============ 功能实现 ============

-- 传送功能
local function refreshPlayerList()
    -- 清空
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local totalHeight = 0
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(0, 135, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.ZIndex = 19
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseButton1Click:Connect(function()
                local target = p
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if flying then
                        root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    else
                        root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
            
            totalHeight = totalHeight + 33
        end
    end
    
    if totalHeight == 0 then
        local emptyLabel = Instance.new("TextLabel", playerList)
        emptyLabel.Size = UDim2.new(0, 135, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "没有其他玩家"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 11
        emptyLabel.ZIndex = 19
        totalHeight = 30
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    playerList.Size = UDim2.new(0, 150, 0, math.min(totalHeight, 120))
end

-- 透视功能
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = randomName() -- 防检测随机名
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = targetChar
    
    local billboard = Instance.new("BillboardGui", targetHead)
    billboard.Name = randomName()
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

-- 更新状态栏
local function updateStatus()
    local parts = {}
    if flying then table.insert(parts, "✈") end
    if noclip then table.insert(parts, "🧱") end
    if espEnabled then table.insert(parts, "👁") end
    if #parts > 0 then
        statusLabel.Text = table.concat(parts, " | ") .. " 速度:" .. speed
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "待机中"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

-- 飞行
local function startFly()
    flying = true
    hum.PlatformStand = true
    local bg = Instance.new("BodyGyro", root)
    bg.Name = randomName()
    bg.MaxTorque = Vector3.new(1,1,1) * math.huge
    local bv = Instance.new("BodyVelocity", root)
    bv.Name = randomName()
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
    for _, part in ipairs(root:GetChildren()) do
        if part:IsA("BodyGyro") or part:IsA("BodyVelocity") then
            part:Destroy()
        end
    end
    flyBtn.Text = "飞行：关"
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    activeTouches = {}
    updateStatus()
end

-- 速度档位
local function setSpeedLevel(level)
    currentSpeedLevel = math.clamp(level, 1, 4)
    speed = speedLevels[currentSpeedLevel]
    speedLevelText.Text = "速度档位：" .. currentSpeedLevel .. "档 (" .. speed .. ")"
    updateStatus()
end

-- 穿墙
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

-- 透视
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

-- 传送
local function togglePlayerList()
    playerList.Visible = not playerList.Visible
    if playerList.Visible then
        refreshPlayerList()
        -- 展开面板
        panel.Size = UDim2.new(0, 180, 0, 480)
    else
        panel.Size = UDim2.new(0, 180, 0, 420)
    end
end

-- ============ 按钮事件 ============
mainBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    playerList.Visible = false
    panel.Size = UDim2.new(0, 180, 0, 420)
end)

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

speedDownBtn.MouseButton1Click:Connect(function()
    setSpeedLevel(currentSpeedLevel - 1)
end)

speedUpBtn.MouseButton1Click:Connect(function()
    setSpeedLevel(currentSpeedLevel + 1)
end)

noclipBtn.MouseButton1Click:Connect(toggleNoclip)
espBtn.MouseButton1Click:Connect(toggleESP)
teleportBtn.MouseButton1Click:Connect(togglePlayerList)

-- ============ 穿墙循环 ============
rs.Stepped:Connect(function()
    if noclip and flying and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
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
    local bv = root:FindFirstChildOfClass("BodyVelocity")
    local bg = root:FindFirstChildOfClass("BodyGyro")
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

-- 重生处理
player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
    if espEnabled then wait(0.5) refreshESP() end
end)

-- 初始化
setSpeedLevel(1)
updateStatus()