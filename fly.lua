-- 创世神脚本 v1.2
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local lighting = game:GetService("Lighting")

-- 功能开关（独立）
local flying, noclip, espEnabled, antiFall, nightVision = false, false, false, false, false
local speed = 40
local activeTouches = {}
local espObjects = {}

local function rn() return "P"..math.random(10000,99999) end

pcall(function() player.PlayerGui:FindFirstChild("MainGui"):Destroy() end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MainGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =====================================================
-- 启动画面
-- =====================================================
local splash = Instance.new("Frame", gui)
splash.Size = UDim2.new(1,0,1,0)
splash.BackgroundColor3 = Color3.fromRGB(0,0,0)
splash.ZIndex = 200

local splTitle = Instance.new("TextLabel", splash)
splTitle.Size = UDim2.new(0,400,0,70)
splTitle.Position = UDim2.new(0.5,-200,0.35,0)
splTitle.BackgroundTransparency = 1
splTitle.Text = "创世神脚本"
splTitle.TextColor3 = Color3.fromRGB(255,0,0)
splTitle.Font = Enum.Font.GothamBlack
splTitle.TextSize = 48
splTitle.ZIndex = 201

local splFounder = Instance.new("TextLabel", splash)
splFounder.Size = UDim2.new(0,400,0,30)
splFounder.Position = UDim2.new(0.5,-200,0.48,0)
splFounder.BackgroundTransparency = 1
splFounder.Text = "创始人 Boos_NN"
splFounder.TextColor3 = Color3.fromRGB(255,50,50)
splFounder.Font = Enum.Font.GothamBold
splFounder.TextSize = 16
splFounder.ZIndex = 201

local splLoaded = Instance.new("TextLabel", splash)
splLoaded.Size = UDim2.new(0,400,0,30)
splLoaded.Position = UDim2.new(0.5,-200,0.56,0)
splLoaded.BackgroundTransparency = 1
splLoaded.Text = "加载成功"
splLoaded.TextColor3 = Color3.fromRGB(255,255,255)
splLoaded.Font = Enum.Font.Gotham
splLoaded.TextSize = 14
splLoaded.ZIndex = 201

local splHint = Instance.new("TextLabel", splash)
splHint.Size = UDim2.new(0,400,0,20)
splHint.Position = UDim2.new(0.5,-200,0.7,0)
splHint.BackgroundTransparency = 1
splHint.Text = "点击屏幕继续"
splHint.TextColor3 = Color3.fromRGB(150,150,150)
splHint.Font = Enum.Font.Gotham
splHint.TextSize = 11
splHint.ZIndex = 201

splash.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        splash:Destroy()
    end
end)

-- =====================================================
-- NN 主按钮（红色字体）
-- =====================================================
local mainBtn = Instance.new("TextButton", gui)
mainBtn.Size = UDim2.new(0,55,0,55)
mainBtn.Position = UDim2.new(0.5,-27,0.5,-27)
mainBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainBtn.BackgroundTransparency = 0.2
mainBtn.Text = "NN"
mainBtn.TextColor3 = Color3.fromRGB(255,0,0)
mainBtn.Font = Enum.Font.GothamBlack
mainBtn.TextSize = 18
mainBtn.ZIndex = 30
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(1,0)

local dm,dsp,bsp = false,nil,nil
mainBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then dm=true; dsp=i.Position; bsp=mainBtn.Position end
end)
uis.InputChanged:Connect(function(i)
    if dm and i.UserInputType == Enum.UserInputType.Touch then
        local d=i.Position-dsp
        mainBtn.Position=UDim2.new(bsp.X.Scale,bsp.X.Offset+d.X,bsp.Y.Scale,bsp.Y.Offset+d.Y)
    end
end)
uis.TouchEnded:Connect(function() dm=false end)

-- =====================================================
-- 主面板（左右布局）
-- =====================================================
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,320,0,200)
panel.Position = UDim2.new(0.5,-160,0.5,-100)
panel.BackgroundColor3 = Color3.fromRGB(10,10,10)
panel.BackgroundTransparency = 0.05
panel.Visible = false
panel.ZIndex = 29
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,10)

local dp,pdsp,psp = false,nil,nil
panel.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then dp=true; pdsp=i.Position; psp=panel.Position end
end)
uis.InputChanged:Connect(function(i)
    if dp and i.UserInputType == Enum.UserInputType.Touch then
        local d=i.Position-pdsp
        panel.Position=UDim2.new(psp.X.Scale,psp.X.Offset+d.X,psp.Y.Scale,psp.Y.Offset+d.Y)
    end
end)
uis.TouchEnded:Connect(function() dp=false end)

-- ============ 左侧：电子时钟 + 状态 ============
local leftPanel = Instance.new("Frame", panel)
leftPanel.Size = UDim2.new(0,120,1,0)
leftPanel.BackgroundColor3 = Color3.fromRGB(18,18,18)
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 29
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0,10)

-- 时钟
local clockLabel = Instance.new("TextLabel", leftPanel)
clockLabel.Size = UDim2.new(1,0,0,40)
clockLabel.Position = UDim2.new(0,0,0,15)
clockLabel.BackgroundTransparency = 1
clockLabel.Text = "00:00:00"
clockLabel.TextColor3 = Color3.fromRGB(0,255,200)
clockLabel.Font = Enum.Font.GothamBlack
clockLabel.TextSize = 22
clockLabel.ZIndex = 29

local dateLabel = Instance.new("TextLabel", leftPanel)
dateLabel.Size = UDim2.new(1,0,0,18)
dateLabel.Position = UDim2.new(0,0,0,55)
dateLabel.BackgroundTransparency = 1
dateLabel.Text = "----年--月--日"
dateLabel.TextColor3 = Color3.fromRGB(150,150,150)
dateLabel.Font = Enum.Font.Gotham
dateLabel.TextSize = 9
dateLabel.ZIndex = 29

-- 分割线
local divL = Instance.new("Frame", leftPanel)
divL.Size = UDim2.new(0.8,0,0,1)
divL.Position = UDim2.new(0.1,0,0,78)
divL.BackgroundColor3 = Color3.fromRGB(60,60,60)
divL.ZIndex = 29

-- 状态显示
local statusTitle = Instance.new("TextLabel", leftPanel)
statusTitle.Size = UDim2.new(1,0,0,16)
statusTitle.Position = UDim2.new(0,0,0,85)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "已开启功能"
statusTitle.TextColor3 = Color3.fromRGB(200,200,200)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 10
statusTitle.ZIndex = 29

local statusList = Instance.new("TextLabel", leftPanel)
statusList.Size = UDim2.new(1,0,0,90)
statusList.Position = UDim2.new(0,0,0,102)
statusList.BackgroundTransparency = 1
statusList.Text = "无"
statusList.TextColor3 = Color3.fromRGB(100,255,100)
statusList.Font = Enum.Font.Gotham
statusList.TextSize = 9
statusList.TextWrapped = true
statusList.ZIndex = 29

-- 更新时钟
local function updateClock()
    local t = os.date("*t")
    clockLabel.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
    dateLabel.Text = string.format("%d年%02d月%02d日", t.year, t.month, t.day)
end
updateClock()
rs.Heartbeat:Connect(function()
    updateClock()
end)

local function updateStatus()
    local lines = {}
    if flying then table.insert(lines,"✈ 飞行") end
    if noclip then table.insert(lines,"🧱 穿墙") end
    if espEnabled then table.insert(lines,"👁 透视") end
    if antiFall then table.insert(lines,"🛡 防摔") end
    if nightVision then table.insert(lines,"☀ 夜视") end
    statusList.Text = #lines>0 and table.concat(lines,"\n") or "无"
end

-- ============ 右侧：标题 + 功能按钮 ============
local rightPanel = Instance.new("Frame", panel)
rightPanel.Size = UDim2.new(0,198,1,0)
rightPanel.Position = UDim2.new(0,122,0,0)
rightPanel.BackgroundColor3 = Color3.fromRGB(14,14,14)
rightPanel.BorderSizePixel = 0
rightPanel.ZIndex = 29
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0,10)

-- 标题 NNNB 彩色变换
local titleNN = Instance.new("TextLabel", rightPanel)
titleNN.Size = UDim2.new(1,-10,0,24)
titleNN.Position = UDim2.new(0,5,0,4)
titleNN.BackgroundTransparency = 1
titleNN.Text = "NNNB"
titleNN.TextColor3 = Color3.fromRGB(255,80,255)
titleNN.Font = Enum.Font.GothamBlack
titleNN.TextSize = 18
titleNN.TextXAlignment = Enum.TextXAlignment.Left
titleNN.ZIndex = 29

-- 标题颜色变换
local hue = 0
rs.Heartbeat:Connect(function()
    hue = (hue + 0.005) % 1
    local c = Color3.fromHSV(hue, 1, 1)
    titleNN.TextColor3 = c
end)

-- 版本号
local verLabel = Instance.new("TextLabel", rightPanel)
verLabel.Size = UDim2.new(1,-10,0,14)
verLabel.Position = UDim2.new(0,5,0,26)
verLabel.BackgroundTransparency = 1
verLabel.Text = "v.1.2"
verLabel.TextColor3 = Color3.fromRGB(255,40,40)
verLabel.Font = Enum.Font.Gotham
verLabel.TextSize = 9
verLabel.TextXAlignment = Enum.TextXAlignment.Left
verLabel.ZIndex = 29

-- 关闭
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0,18,0,18)
closeBtn.Position = UDim2.new(1,-20,0,4)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 9
closeBtn.ZIndex = 29
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

-- 分割线
local divR = Instance.new("Frame", rightPanel)
divR.Size = UDim2.new(0.9,0,0,1)
divR.Position = UDim2.new(0.05,0,0,42)
divR.BackgroundColor3 = Color3.fromRGB(60,60,60)
divR.ZIndex = 29

-- ============ 功能按钮（在右侧） ============
local function makeBtn(name, y, color, cb)
    local btn = Instance.new("TextButton", rightPanel)
    btn.Size = UDim2.new(0.9,0,0,24)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.BackgroundColor3 = color or Color3.fromRGB(35,35,35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 29
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    btn.MouseButton1Click:Connect(cb)
    return btn
end

-- ============ 子面板 ============
local currentSub = nil
local function closeSub()
    if currentSub then currentSub:Destroy(); currentSub=nil end
end
local function createSub(txt)
    closeSub()
    local sp = Instance.new("Frame", gui)
    sp.Size = UDim2.new(0,160,0,200)
    sp.Position = UDim2.new(panel.Position.X.Scale+0.01,panel.Position.X.Offset-170,panel.Position.Y.Scale,panel.Position.Y.Offset)
    sp.BackgroundColor3 = Color3.fromRGB(10,10,10)
    sp.BackgroundTransparency = 0.05
    sp.ZIndex = 28
    Instance.new("UICorner", sp).CornerRadius = UDim.new(0,8)
    local st = Instance.new("TextLabel", sp)
    st.Size = UDim2.new(1,-20,0,20)
    st.Position = UDim2.new(0,10,0,4)
    st.BackgroundTransparency = 1
    st.Text = txt
    st.TextColor3 = Color3.fromRGB(255,80,255)
    st.Font = Enum.Font.GothamBlack
    st.TextSize = 12
    st.TextXAlignment = Enum.TextXAlignment.Left
    st.ZIndex = 28
    local cb2 = Instance.new("TextButton", sp)
    cb2.Size = UDim2.new(0,16,0,16)
    cb2.Position = UDim2.new(1,-20,0,4)
    cb2.BackgroundColor3 = Color3.fromRGB(180,40,40)
    cb2.Text = "✕"
    cb2.TextColor3 = Color3.fromRGB(255,255,255)
    cb2.TextSize = 8
    cb2.ZIndex = 28
    Instance.new("UICorner", cb2).CornerRadius = UDim.new(1,0)
    cb2.MouseButton1Click:Connect(closeSub)
    currentSub = sp
    return sp
end
local function addSBtn(parent, name, y, cb2, isOn)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85,0,0,24)
    btn.Position = UDim2.new(0.075,0,0,y)
    btn.BackgroundColor3 = isOn and Color3.fromRGB(50,200,50) or Color3.fromRGB(35,35,35)
    btn.Text = name .. (isOn and " ✓" or "")
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.ZIndex = 28
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    btn.MouseButton1Click:Connect(cb2)
    return btn
end

-- =====================================================
-- 1. 飞行
-- =====================================================
local function openFly()
    local sp = createSub("✈ 飞行设置")
    local fb = addSBtn(sp, "飞行", 32, function()
        if flying then
            flying=false
            if noclip then noclip=false end
            hum.PlatformStand=false
            for _,n in ipairs({"FlyGyro","FlyVelocity"}) do local o=root:FindFirstChild(n) if o then o:Destroy() end end
            local bc=root:FindFirstChildOfClass("BodyVelocity") if bc then bc:Destroy() end
            local bgc=root:FindFirstChildOfClass("BodyGyro") if bgc then bgc:Destroy() end
            mainBtn.BackgroundColor3=Color3.fromRGB(0,0,0)
            activeTouches={}
        else
            flying=true; hum.PlatformStand=true
            local bg=Instance.new("BodyGyro",root); bg.Name=rn(); bg.MaxTorque=Vector3.new(1,1,1)*math.huge
            local bv=Instance.new("BodyVelocity",root); bv.Name=rn(); bv.MaxForce=Vector3.new(1,1,1)*math.huge
            mainBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
        end
        fb.Text = "飞行"..(flying and " ✓" or "")
        fb.BackgroundColor3 = flying and Color3.fromRGB(50,200,50) or Color3.fromRGB(35,35,35)
        updateStatus()
    end, flying)

    local sl = Instance.new("TextLabel", sp)
    sl.Size=UDim2.new(0.85,0,0,14); sl.Position=UDim2.new(0.075,0,0,62)
    sl.BackgroundTransparency=1; sl.Text="速度："..speed
    sl.TextColor3=Color3.fromRGB(200,200,200); sl.Font=Enum.Font.Gotham; sl.TextSize=10
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.ZIndex=28

    local sps = {{"1档 40",40},{"2档 100",100},{"3档 500",500},{"4档 1000",1000},{"5档 2000",2000}}
    for i,sv in ipairs(sps) do
        addSBtn(sp, sv[1], 80+(i-1)*27, function()
            speed=sv[2]; sl.Text="速度："..speed
        end, speed==sv[2])
    end
end

-- =====================================================
-- 2. 穿墙
-- =====================================================
local function openNoclip()
    local sp = createSub("🧱 穿墙设置")
    local nb = addSBtn(sp, "穿墙", 32, function()
        if not flying then return end
        noclip = not noclip
        nb.Text = "穿墙"..(noclip and " ✓" or "")
        nb.BackgroundColor3 = noclip and Color3.fromRGB(50,200,50) or Color3.fromRGB(35,35,35)
        updateStatus()
    end, noclip)
    local ht=Instance.new("TextLabel",sp)
    ht.Size=UDim2.new(0.85,0,0,30); ht.Position=UDim2.new(0.075,0,0,70)
    ht.BackgroundTransparency=1; ht.Text="仅飞行时可用"; ht.TextColor3=Color3.fromRGB(150,150,150)
    ht.Font=Enum.Font.Gotham; ht.TextSize=9; ht.TextXAlignment=Enum.TextXAlignment.Center; ht.ZIndex=28
end

-- =====================================================
-- 3. 透视（修复版）
-- =====================================================
local function createESP(p)
    if p == player then return end
    local c = p.Character; if not c then return end
    local hd = c:FindFirstChild("Head"); if not hd then return end
    -- 清除旧的
    for _,o in ipairs(espObjects) do if o.p==p then if o.h then o.h:Destroy() end; if o.b then o.b:Destroy() end end end
    -- 创建新的
    local hl = Instance.new("Highlight",c)
    hl.Name="NN_ESP"; hl.FillTransparency=1; hl.OutlineColor=Color3.fromRGB(255,0,0); hl.OutlineTransparency=0
    local bb=Instance.new("BillboardGui",hd); bb.Name="NN_ESPL"
    bb.Size=UDim2.new(0,100,0,20); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
    local lb=Instance.new("TextLabel",bb); lb.Size=UDim2.new(1,0,1,0); lb.BackgroundTransparency=1
    lb.Text=p.Name; lb.TextColor3=Color3.fromRGB(255,0,0); lb.Font=Enum.Font.GothamBold; lb.TextSize=11
    -- 保存
    local found=false
    for _,o in ipairs(espObjects) do if o.p==p then o.h=hl; o.b=bb; found=true; break end end
    if not found then table.insert(espObjects,{h=hl,b=bb,p=p}) end
end
local function clearESP()
    for _,o in ipairs(espObjects) do
        if o.h and o.h.Parent then o.h:Destroy() end
        if o.b and o.b.Parent then o.b:Destroy() end
    end
    espObjects={}
end
local function refreshESP()
    clearESP()
    if espEnabled then for _,p in ipairs(game.Players:GetPlayers()) do if p~=player then pcall(function() createESP(p) end) end end end
end
local function openESP()
    local sp = createSub("👁 透视设置")
    local eb = addSBtn(sp, "透视", 32, function()
        espEnabled = not espEnabled
        eb.Text = "透视"..(espEnabled and " ✓" or "")
        eb.BackgroundColor3 = espEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(35,35,35)
        if espEnabled then refreshESP() else clearESP() end
        updateStatus()
    end, espEnabled)
    local ht2=Instance.new("TextLabel",sp)
    ht2.Size=UDim2.new(0.85,0,0,30); ht2.Position=UDim2.new(0.075,0,0,70)
    ht2.BackgroundTransparency=1; ht2.Text="红色描边+名字"; ht2.TextColor3=Color3.fromRGB(150,150,150)
    ht2.Font=Enum.Font.Gotham; ht2.TextSize=9; ht2.TextXAlignment=Enum.TextXAlignment.Center; ht2.ZIndex=28
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() if espEnabled then wait(0.5) pcall(function() createESP(p) end) end end)
end)
game.Players.PlayerRemoving:Connect(function(p)
    for i,o in ipairs(espObjects) do if o.p==p then if o.h then o.h:Destroy() end; if o.b then o.b:Destroy() end; table.remove(espObjects,i); break end end
end)

-- =====================================================
-- 4. 传送
-- =====================================================
local function openTP()
    local sp = createSub("📍 传送玩家")
    local sf=Instance.new("ScrollingFrame",sp)
    sf.Size=UDim2.new(0.9,0,0,130); sf.Position=UDim2.new(0.05,0,0,32)
    sf.BackgroundTransparency=1; sf.ScrollBarThickness=3; sf.CanvasSize=UDim2.new(0,0,0,0); sf.ZIndex=28
    local ll=Instance.new("UIListLayout",sf); ll.Padding=UDim.new(0,3); ll.SortOrder=Enum.SortOrder.Name
    local function refreshList()
        for _,c in ipairs(sf:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local th=0
        for _,p in ipairs(game.Players:GetPlayers()) do
            if p~=player then
                local pb=Instance.new("TextButton",sf)
                pb.Size=UDim2.new(1,-6,0,24); pb.BackgroundColor3=Color3.fromRGB(35,35,35)
                pb.Text=p.Name; pb.TextColor3=Color3.fromRGB(255,255,255)
                pb.Font=Enum.Font.Gotham; pb.TextSize=10; pb.ZIndex=28
                Instance.new("UICorner",pb).CornerRadius=UDim.new(0,4)
                pb.MouseButton1Click:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        root.CFrame=CFrame.new(p.Character.HumanoidRootPart.Position+Vector3.new(0,3,0))
                    end
                end)
                th=th+27
            end
        end
        sf.CanvasSize=UDim2.new(0,0,0,math.max(th,130))
    end
    refreshList()
    addSBtn(sp,"🔄 刷新列表",172,refreshList,false)
end

-- =====================================================
-- 5. 防摔
-- =====================================================
local function openAntiFall()
    local sp = createSub("🛡 防摔设置")
    local ab = addSBtn(sp, "防摔", 32, function()
        antiFall = not antiFall
        ab.Text = "防摔"..(antiFall and " ✓" or "")
        ab.BackgroundColor3 = antiFall and Color3.fromRGB(50,200,50) or Color3.fromRGB(35,35,35)
        updateStatus()
    end, antiFall)
    local ht3=Instance.new("TextLabel",sp)
    ht3.Size=UDim2.new(0.85,0,0,30); ht3.Position=UDim2.new(0.075,0,0,70)
    ht3.BackgroundTransparency=1; ht3.Text="防跌落伤害"; ht3.TextColor3=Color3.fromRGB(150,150,150)
    ht3.Font=Enum.Font.Gotham; ht3.TextSize=9; ht3.TextXAlignment=Enum.TextXAlignment.Center; ht3.ZIndex=28
end

-- =====================================================
-- 6. 夜视
-- =====================================================
local function openNV()
    local sp = createSub("☀ 夜视设置")
    local nb2 = addSBtn(sp, "夜视", 32, function()
        nightVision = not nightVision
        nb2.Text = "夜视"..(nightVision and " ✓" or "")
        nb2.BackgroundColor3 = nightVision and Color3.fromRGB(50,200,50) or Color3.fromRGB(35,35,35)
        if nightVision then
            lighting.Brightness=2; lighting.ClockTime=12; lighting.FogEnd=9999
            lighting.GlobalShadows=false; lighting.OutdoorAmbient=Color3.fromRGB(128,128,128)
        else
            lighting.Brightness=1; lighting.ClockTime=14; lighting.FogEnd=1000
            lighting.GlobalShadows=true; lighting.OutdoorAmbient=Color3.fromRGB(70,70,70)
        end
        updateStatus()
    end, nightVision)
    local ht4=Instance.new("TextLabel",sp)
    ht4.Size=UDim2.new(0.85,0,0,30); ht4.Position=UDim2.new(0.075,0,0,70)
    ht4.BackgroundTransparency=1; ht4.Text="强制白天/高亮度"; ht4.TextColor3=Color3.fromRGB(150,150,150)
    ht4.Font=Enum.Font.Gotham; ht4.TextSize=9; ht4.TextXAlignment=Enum.TextXAlignment.Center; ht4.ZIndex=28
end

-- =====================================================
-- 主菜单按钮绑定
-- =====================================================
makeBtn("✈ 飞行",48,Color3.fromRGB(50,160,50),openFly)
makeBtn("🧱 穿墙",76,Color3.fromRGB(160,100,40),openNoclip)
makeBtn("👁 透视",104,Color3.fromRGB(50,100,255),openESP)
makeBtn("📍 传送",132,Color3.fromRGB(140,50,200),openTP)
makeBtn("🛡 防摔",160,Color3.fromRGB(50,160,100),openAntiFall)
makeBtn("☀ 夜视",188,Color3.fromRGB(240,160,30),openNV)

-- =====================================================
-- 事件
-- =====================================================
mainBtn.MouseButton1Click:Connect(function() closeSub(); panel.Visible=not panel.Visible end)
closeBtn.MouseButton1Click:Connect(function() closeSub(); panel.Visible=false end)

rs.Stepped:Connect(function()
    if noclip and flying and char then
        for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end
    end
end)

hum.StateChanged:Connect(function(_,ns)
    if antiFall and ns==Enum.HumanoidStateType.FallingDown then hum.PlatformStand=true; wait(0.1); hum.PlatformStand=false end
end)

local sHalf=cam.ViewportSize.X/2
uis.TouchStarted:Connect(function(t) activeTouches[t]={sp=t.Position,cp=t.Position,L=t.Position.X<sHalf} end)
uis.TouchMoved:Connect(function(t) if activeTouches[t] then activeTouches[t].cp=t.Position end end)
uis.TouchEnded:Connect(function(t) activeTouches[t]=nil end)

rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv=root:FindFirstChildOfClass("BodyVelocity")
    local bg=root:FindFirstChildOfClass("BodyGyro")
    if not bv or not bg then return end
    local md=Vector3.zero
    for _,d in pairs(activeTouches) do
        if d.L and d.sp and d.cp then
            local delta=d.cp-d.sp
            if delta.Magnitude>15 then
                local cl=delta.Magnitude>80 and delta.Unit*80 or delta
                md+=cam.CFrame.RightVector*(cl.X/80)
                md+=cam.CFrame.LookVector*(-cl.Y/80)
            end
        end
    end
    if md.Magnitude>1 then md=md.Unit end
    bv.Velocity=md*speed
    bg.CFrame=cam.CFrame
end)

player.CharacterAdded:Connect(function(c)
    char=c; hum=c:WaitForChild("Humanoid"); root=c:WaitForChild("HumanoidRootPart")
    if flying then flying=false; hum.PlatformStand=false; activeTouches={}; updateStatus() end
    if espEnabled then wait(0.5) refreshESP() end
end)

updateStatus()