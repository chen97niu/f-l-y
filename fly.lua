-- NNNB v1.0 多功能菜单
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local lighting = game:GetService("Lighting")

local flying, noclip, espEnabled, antiFall, nightVision = false, false, false, false, false
local speed = 40
local activeTouches = {}
local espObjects = {}

local function rn() return "P" .. math.random(10000, 99999) end

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
mainBtn.ZIndex = 30
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(1, 0)

local dm, dsp, bsp = false, nil, nil
mainBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then dm = true; dsp = i.Position; bsp = mainBtn.Position end
end)
uis.InputChanged:Connect(function(i)
    if dm and i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - dsp
        mainBtn.Position = UDim2.new(bsp.X.Scale, bsp.X.Offset + d.X, bsp.Y.Scale, bsp.Y.Offset + d.Y)
    end
end)
uis.TouchEnded:Connect(function() dm = false end)

-- ============ 主菜单面板 ============
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 175, 0, 220)
panel.Position = UDim2.new(0.5, -87, 0.5, -110)
panel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
panel.BackgroundTransparency = 0.05
panel.Visible = false
panel.ZIndex = 29
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

local dp, pdsp, psp = false, nil, nil
panel.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then dp = true; pdsp = i.Position; psp = panel.Position end
end)
uis.InputChanged:Connect(function(i)
    if dp and i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - pdsp
        panel.Position = UDim2.new(psp.X.Scale, psp.X.Offset + d.X, psp.Y.Scale, psp.Y.Offset + d.Y)
    end
end)
uis.TouchEnded:Connect(function() dp = false end)

-- 标题 NNNB 彩色
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -30, 0, 26)
title.Position = UDim2.new(0, 12, 0, 5)
title.BackgroundTransparency = 1
title.Text = "NNNB"
title.TextColor3 = Color3.fromRGB(255, 80, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 29

-- 版本号
local ver = Instance.new("TextLabel", panel)
ver.Size = UDim2.new(1, -30, 0, 14)
ver.Position = UDim2.new(0, 12, 0, 28)
ver.BackgroundTransparency = 1
ver.Text = "v.1.0"
ver.TextColor3 = Color3.fromRGB(255, 40, 40)
ver.Font = Enum.Font.Gotham
ver.TextSize = 10
ver.TextXAlignment = Enum.TextXAlignment.Left
ver.ZIndex = 29

-- 关闭
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 10
closeBtn.ZIndex = 29
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- 分割线
local div = Instance.new("Frame", panel)
div.Size = UDim2.new(0.9, 0, 0, 1)
div.Position = UDim2.new(0.05, 0, 0, 44)
div.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
div.ZIndex = 29

-- 状态
local statusLabel = Instance.new("TextLabel", panel)
statusLabel.Size = UDim2.new(0.85, 0, 0, 14)
statusLabel.Position = UDim2.new(0.075, 0, 0, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 9
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 29

local function updateStatus()
    local s = {}
    if flying then table.insert(s, "✈") end
    if noclip then table.insert(s, "🧱") end
    if espEnabled then table.insert(s, "👁") end
    if antiFall then table.insert(s, "🛡") end
    if nightVision then table.insert(s, "☀") end
    statusLabel.Text = #s > 0 and table.concat(s, " ") or ""
end

-- ============ 主菜单按钮 ============
local function makeMainBtn(name, y, color, cb)
    local btn = Instance.new("TextButton", panel)
    btn.Size = UDim2.new(0.85, 0, 0, 26)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(38, 38, 38)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 29
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(cb)
    return btn
end

-- ============ 子面板 ============
local currentSubPanel = nil
local function closeSub()
    if currentSubPanel then currentSubPanel:Destroy(); currentSubPanel = nil end
end
local function createSub(titleText)
    closeSub()
    local sp = Instance.new("Frame", gui)
    sp.Size = UDim2.new(0, 165, 0, 200)
    sp.Position = UDim2.new(panel.Position.X.Scale + 0.01, panel.Position.X.Offset + 178, panel.Position.Y.Scale, panel.Position.Y.Offset)
    sp.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    sp.BackgroundTransparency = 0.05
    sp.ZIndex = 28
    Instance.new("UICorner", sp).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("TextLabel", sp)
    st.Size = UDim2.new(1, -20, 0, 22)
    st.Position = UDim2.new(0, 10, 0, 5)
    st.BackgroundTransparency = 1
    st.Text = titleText
    st.TextColor3 = Color3.fromRGB(255, 80, 255)
    st.Font = Enum.Font.GothamBlack
    st.TextSize = 13
    st.TextXAlignment = Enum.TextXAlignment.Left
    st.ZIndex = 28
    local cb = Instance.new("TextButton", sp)
    cb.Size = UDim2.new(0, 18, 0, 18)
    cb.Position = UDim2.new(1, -22, 0, 5)
    cb.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    cb.Text = "✕"
    cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    cb.TextSize = 9
    cb.ZIndex = 28
    Instance.new("UICorner", cb).CornerRadius = UDim.new(1, 0)
    cb.MouseButton1Click:Connect(closeSub)
    currentSubPanel = sp
    return sp
end
local function addSBtn(parent, name, y, cb2, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85, 0, 0, 26)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(38, 38, 38)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 28
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(cb2)
    return btn
end

-- ============ 1. 飞行 ============
local function openFly()
    local sp = createSub("✈ 飞行设置")
    local flyBtn2 = addSBtn(sp, "飞行：关", 35, function()
        if flying then
            flying = false
            if noclip then noclip = false end
            hum.PlatformStand = false
            for _, n in ipairs({"FlyGyro", "FlyVelocity"}) do
                local o = root:FindFirstChild(n); if o then o:Destroy() end
            end
            flyBtn2.Text = "飞行：关"; flyBtn2.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            mainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            activeTouches = {}
        else
            flying = true; hum.PlatformStand = true
            local bg = Instance.new("BodyGyro", root)
            bg.Name = rn(); bg.MaxTorque = Vector3.new(1, 1, 1) * math.huge
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = rn(); bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
            flyBtn2.Text = "飞行：开"; flyBtn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            mainBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        updateStatus()
    end)
    if flying then flyBtn2.Text = "飞行：开"; flyBtn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50) end

    local sl = Instance.new("TextLabel", sp)
    sl.Size = UDim2.new(0.85, 0, 0, 14)
    sl.Position = UDim2.new(0.075, 0, 0, 70)
    sl.BackgroundTransparency = 1
    sl.Text = "速度：" .. speed
    sl.TextColor3 = Color3.fromRGB(200, 200, 200)
    sl.Font = Enum.Font.Gotham; sl.TextSize = 10; sl.TextXAlignment = Enum.TextXAlignment.Center; sl.ZIndex = 28

    local sps = {{"1档 40", 40}, {"2档 100", 100}, {"3档 500", 500}, {"4档 1000", 1000}}
    for i, sv in ipairs(sps) do
        addSBtn(sp, sv[1], 90 + (i - 1) * 28, function()
            speed = sv[2]; sl.Text = "速度：" .. speed
        end, speed == sv[2] and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(38, 38, 38))
    end
end

-- ============ 2. 穿墙 ============
local function openNoclip()
    local sp = createSub("🧱 穿墙设置")
    local nb2 = addSBtn(sp, "穿墙：关", 35, function()
        if not flying then return end
        noclip = not noclip
        nb2.Text = noclip and "穿墙：开" or "穿墙：关"
        nb2.BackgroundColor3 = noclip and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(38, 38, 38)
        updateStatus()
    end)
    if noclip then nb2.Text = "穿墙：开"; nb2.BackgroundColor3 = Color3.fromRGB(255, 150, 0) end
    local ht = Instance.new("TextLabel", sp)
    ht.Size = UDim2.new(0.85, 0, 0, 40)
    ht.Position = UDim2.new(0.075, 0, 0, 75)
    ht.BackgroundTransparency = 1
    ht.Text = "仅飞行时可用"
    ht.TextColor3 = Color3.fromRGB(150, 150, 150)
    ht.Font = Enum.Font.Gotham; ht.TextSize = 10; ht.TextXAlignment = Enum.TextXAlignment.Center; ht.ZIndex = 28
end

-- ============ 3. 透视 ============
local function createESP(p)
    if p == player then return end
    local c = p.Character; if not c then return end
    local hd = c:FindFirstChild("Head"); if not hd then return end
    local hl = Instance.new("Highlight", c)
    hl.Name = "NN_ESP"; hl.FillTransparency = 1
    hl.OutlineColor = Color3.fromRGB(255, 0, 0); hl.OutlineTransparency = 0
    local bb = Instance.new("BillboardGui", hd)
    bb.Name = "NN_ESPL"; bb.Size = UDim2.new(0, 100, 0, 20)
    bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true
    local lb = Instance.new("TextLabel", bb)
    lb.Size = UDim2.new(1, 0, 1, 0); lb.BackgroundTransparency = 1
    lb.Text = p.Name; lb.TextColor3 = Color3.fromRGB(255, 0, 0)
    lb.Font = Enum.Font.GothamBold; lb.TextSize = 11
    table.insert(espObjects, {h = hl, b = bb, p = p})
end
local function clearESP()
    for _, o in ipairs(espObjects) do
        if o.h and o.h.Parent then o.h:Destroy() end
        if o.b and o.b.Parent then o.b:Destroy() end
    end
    espObjects = {}
end
local function refreshESP()
    clearESP()
    if espEnabled then for _, p in ipairs(game.Players:GetPlayers()) do if p ~= player then pcall(function() createESP(p) end) end end end
end
local function openESP()
    local sp = createSub("👁 透视设置")
    local eb2 = addSBtn(sp, "透视：关", 35, function()
        espEnabled = not espEnabled
        eb2.Text = espEnabled and "透视：开" or "透视：关"
        eb2.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(38, 38, 38)
        if espEnabled then refreshESP() else clearESP() end
        updateStatus()
    end)
    if espEnabled then eb2.Text = "透视：开"; eb2.BackgroundColor3 = Color3.fromRGB(50, 150, 255) end
    local ht2 = Instance.new("TextLabel", sp)
    ht2.Size = UDim2.new(0.85, 0, 0, 40)
    ht2.Position = UDim2.new(0.075, 0, 0, 75)
    ht2.BackgroundTransparency = 1
    ht2.Text = "红色描边+名字"
    ht2.TextColor3 = Color3.fromRGB(150, 150, 150)
    ht2.Font = Enum.Font.Gotham; ht2.TextSize = 10; ht2.TextXAlignment = Enum.TextXAlignment.Center; ht2.ZIndex = 28
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() if espEnabled then wait(0.5) pcall(function() createESP(p) end) end end)
end)
game.Players.PlayerRemoving:Connect(function(p)
    for i, o in ipairs(espObjects) do if o.p == p then
            if o.h then o.h:Destroy() end; if o.b then o.b:Destroy() end; table.remove(espObjects, i); break
    end end
end)

-- ============ 4. 传送 ============
local function openTP()
    local sp = createSub("📍 传送玩家")
    local sf = Instance.new("ScrollingFrame", sp)
    sf.Size = UDim2.new(0.9, 0, 0, 130)
    sf.Position = UDim2.new(0.05, 0, 0, 35)
    sf.BackgroundTransparency = 1; sf.ScrollBarThickness = 3; sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.ZIndex = 28
    local ll = Instance.new("UIListLayout", sf)
    ll.Padding = UDim.new(0, 3); ll.SortOrder = Enum.SortOrder.Name
    local function refreshList()
        for _, c in ipairs(sf:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local th = 0
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                local pb = Instance.new("TextButton", sf)
                pb.Size = UDim2.new(1, -6, 0, 24)
                pb.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                pb.Text = p.Name; pb.TextColor3 = Color3.fromRGB(255, 255, 255)
                pb.Font = Enum.Font.Gotham; pb.TextSize = 10; pb.ZIndex = 28
                Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 4)
                pb.MouseButton1Click:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        root.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                    end
                end)
                th = th + 27
            end
        end
        sf.CanvasSize = UDim2.new(0, 0, 0, math.max(th, 130))
    end
    refreshList()
    addSBtn(sp, "🔄 刷新列表", 175, refreshList, Color3.fromRGB(45, 45, 45))
end

-- ============ 5. 防摔 ============
local function toggleAntiFall()
    antiFall = not antiFall
    updateStatus()
end
local function openAntiFall()
    local sp = createSub("🛡 防摔设置")
    local afb = addSBtn(sp, "防摔：关", 35, function()
        antiFall = not antiFall
        afb.Text = antiFall and "防摔：开" or "防摔：关"
        afb.BackgroundColor3 = antiFall and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(38, 38, 38)
        updateStatus()
    end)
    if antiFall then afb.Text = "防摔：开"; afb.BackgroundColor3 = Color3.fromRGB(50, 200, 100) end
    local ht3 = Instance.new("TextLabel", sp)
    ht3.Size = UDim2.new(0.85, 0, 0, 40)
    ht3.Position = UDim2.new(0.075, 0, 0, 75)
    ht3.BackgroundTransparency = 1
    ht3.Text = "落地自动取消跌落伤害"
    ht3.TextColor3 = Color3.fromRGB(150, 150, 150)
    ht3.Font = Enum.Font.Gotham; ht3.TextSize = 10; ht3.TextXAlignment = Enum.TextXAlignment.Center; ht3.ZIndex = 28
end

-- ============ 6. 夜视 ============
local function openNV()
    local sp = createSub("☀ 夜视设置")
    local nvb = addSBtn(sp, "夜视：关", 35, function()
        nightVision = not nightVision
        nvb.Text = nightVision and "夜视：开" or "夜视：关"
        nvb.BackgroundColor3 = nightVision and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(38, 38, 38)
        if nightVision then
            lighting.Brightness = 2
            lighting.ClockTime = 12
            lighting.FogEnd = 9999
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            lighting.Brightness = 1
            lighting.ClockTime = 14
            lighting.FogEnd = 1000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
        updateStatus()
    end)
    if nightVision then nvb.Text = "夜视：开"; nvb.BackgroundColor3 = Color3.fromRGB(255, 200, 50) end
    local ht4 = Instance.new("TextLabel", sp)
    ht4.Size = UDim2.new(0.85, 0, 0, 40)
    ht4.Position = UDim2.new(0.075, 0, 0, 75)
    ht4.BackgroundTransparency = 1
    ht4.Text = "强制白天/高亮度"
    ht4.TextColor3 = Color3.fromRGB(150, 150, 150)
    ht4.Font = Enum.Font.Gotham; ht4.TextSize = 10; ht4.TextXAlignment = Enum.TextXAlignment.Center; ht4.ZIndex = 28
end

-- ============ 主菜单按钮绑定 ============
makeMainBtn("✈ 飞行", 50, Color3.fromRGB(50, 180, 50), openFly)
makeMainBtn("🧱 穿墙", 80, Color3.fromRGB(180, 120, 40), openNoclip)
makeMainBtn("👁 透视", 110, Color3.fromRGB(50, 120, 255), openESP)
makeMainBtn("📍 传送", 140, Color3.fromRGB(150, 50, 200), openTP)
makeMainBtn("🛡 防摔", 170, Color3.fromRGB(50, 180, 100), openAntiFall)
makeMainBtn("☀ 夜视", 200, Color3.fromRGB(255, 180, 30), openNV)

-- ============ 事件 ============
mainBtn.MouseButton1Click:Connect(function() closeSub(); panel.Visible = not panel.Visible end)
closeBtn.MouseButton1Click:Connect(function() closeSub(); panel.Visible = false end)

-- 穿墙
rs.Stepped:Connect(function()
    if noclip and flying and char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
end)

-- 防摔
hum.StateChanged:Connect(function(_, newState)
    if antiFall and newState == Enum.HumanoidStateType.FallingDown then
        hum.PlatformStand = true
        wait(0.1)
        hum.PlatformStand = false
    end
end)

-- 摇杆
local sHalf = cam.ViewportSize.X / 2
uis.TouchStarted:Connect(function(t) activeTouches[t] = {sp = t.Position, cp = t.Position, L = t.Position.X < sHalf} end)
uis.TouchMoved:Connect(function(t) if activeTouches[t] then activeTouches[t].cp = t.Position end end)
uis.TouchEnded:Connect(function(t) activeTouches[t] = nil end)

-- 飞行
rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv = root:FindFirstChildOfClass("BodyVelocity")
    local bg = root:FindFirstChildOfClass("BodyGyro")
    if not bv or not bg then return end
    local md = Vector3.zero
    for _, d in pairs(activeTouches) do
        if d.L and d.sp and d.cp then
            local delta = d.cp - d.sp
            if delta.Magnitude > 15 then
                local cl = delta.Magnitude > 80 and delta.Unit * 80 or delta
                md += cam.CFrame.RightVector * (cl.X / 80)
                md += cam.CFrame.LookVector * (-cl.Y / 80)
            end
        end
    end
    if md.Magnitude > 1 then md = md.Unit end
    bv.Velocity = md * speed
    bg.CFrame = cam.CFrame
end)

player.CharacterAdded:Connect(function(c)
    char = c; hum = c:WaitForChild("Humanoid"); root = c:WaitForChild("HumanoidRootPart")
    if flying then flying = false; hum.PlatformStand = false; activeTouches = {} end
    if espEnabled then wait(0.5) refreshESP() end
end)

updateStatus()