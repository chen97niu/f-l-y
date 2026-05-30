-- 创世神脚本 v1.2
local player=game.Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hum=char:WaitForChild("Humanoid")
local root=char:WaitForChild("HumanoidRootPart")
local rs=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local cam=workspace.CurrentCamera
local lighting=game:GetService("Lighting")

local flying,noclip,espEnabled,antiDetect,antiFall,nightVision=false,false,false,false,false,false
local speed=40
local activeTouches={}
local espObjects={}
local cape=nil

local function rn()return"P"..math.random(10000,99999)end

local function createCape()
    if cape then pcall(function()cape:Destroy()end)end
    local torso=char:FindFirstChild("UpperTorso")or char:FindFirstChild("Torso")
    if not torso then return end
    cape=Instance.new("Part")
    cape.Name="FlyCape"
    cape.Size=Vector3.new(1.6,2.5,0.12)
    cape.BrickColor=BrickColor.new("Bright red")
    cape.Material=Enum.Material.Fabric
    cape.Transparency=0.05
    cape.CanCollide=false
    cape.Anchored=false
    cape.Massless=true
    local w=Instance.new("WeldConstraint",cape)
    w.Part0=cape
    w.Part1=torso
    cape.Parent=char
end
local function removeCape()
    if cape then pcall(function()cape:Destroy()end)cape=nil end
end

pcall(function()player.PlayerGui:FindFirstChild("MainGui"):Destroy()end)

local gui=Instance.new("ScreenGui",player.PlayerGui)
gui.Name="MainGui"
gui.ResetOnSpawn=false
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

-- 启动画面
local splash=Instance.new("Frame",gui)
splash.Size=UDim2.new(1,0,1,0)
splash.BackgroundColor3=Color3.fromRGB(0,0,0)
splash.ZIndex=200

local splTitle=Instance.new("TextLabel",splash)
splTitle.Size=UDim2.new(0,400,0,70)
splTitle.Position=UDim2.new(0.5,-200,0.35,0)
splTitle.BackgroundTransparency=1
splTitle.Text="创世神脚本"
splTitle.TextColor3=Color3.fromRGB(255,0,0)
splTitle.Font=Enum.Font.GothamBlack
splTitle.TextSize=48
splTitle.ZIndex=201

local splFounder=Instance.new("TextLabel",splash)
splFounder.Size=UDim2.new(0,400,0,30)
splFounder.Position=UDim2.new(0.5,-200,0.48,0)
splFounder.BackgroundTransparency=1
splFounder.Text="创始人 Boos_NN"
splFounder.TextColor3=Color3.fromRGB(255,50,50)
splFounder.Font=Enum.Font.GothamBold
splFounder.TextSize=16
splFounder.ZIndex=201

local splLoaded=Instance.new("TextLabel",splash)
splLoaded.Size=UDim2.new(0,400,0,30)
splLoaded.Position=UDim2.new(0.5,-200,0.56,0)
splLoaded.BackgroundTransparency=1
splLoaded.Text="加载成功"
splLoaded.TextColor3=Color3.fromRGB(255,255,255)
splLoaded.Font=Enum.Font.Gotham
splLoaded.TextSize=14
splLoaded.ZIndex=201

local splHint=Instance.new("TextLabel",splash)
splHint.Size=UDim2.new(0,400,0,20)
splHint.Position=UDim2.new(0.5,-200,0.7,0)
splHint.BackgroundTransparency=1
splHint.Text="点击屏幕继续"
splHint.TextColor3=Color3.fromRGB(150,150,150)
splHint.Font=Enum.Font.Gotham
splHint.TextSize=11
splHint.ZIndex=201

splash.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        splash:Destroy()
    end
end)

-- NN 主按钮
local mainBtn=Instance.new("TextButton",gui)
mainBtn.Size=UDim2.new(0,55,0,55)
mainBtn.Position=UDim2.new(0.5,-27,0.5,-27)
mainBtn.BackgroundColor3=Color3.fromRGB(0,0,0)
mainBtn.BackgroundTransparency=0.2
mainBtn.Text="NN"
mainBtn.TextColor3=Color3.fromRGB(255,0,0)
mainBtn.Font=Enum.Font.GothamBlack
mainBtn.TextSize=18
mainBtn.ZIndex=30
Instance.new("UICorner",mainBtn).CornerRadius=UDim.new(1,0)

local dm,dsp,bsp=false,nil,nil
mainBtn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch then dm=true;dsp=i.Position;bsp=mainBtn.Position end
end)
uis.InputChanged:Connect(function(i)
    if dm and i.UserInputType==Enum.UserInputType.Touch then
        local d=i.Position-dsp
        mainBtn.Position=UDim2.new(bsp.X.Scale,bsp.X.Offset+d.X,bsp.Y.Scale,bsp.Y.Offset+d.Y)
    end
end)
uis.TouchEnded:Connect(function()dm=false end)

-- 主面板
local panel=Instance.new("Frame",gui)
panel.Size=UDim2.new(0,340,0,220)
panel.Position=UDim2.new(0.5,-170,0.5,-110)
panel.BackgroundColor3=Color3.fromRGB(10,10,10)
panel.BackgroundTransparency=0.05
panel.Visible=false
panel.ZIndex=29
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local dp,pdsp,psp=false,nil,nil
panel.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch then dp=true;pdsp=i.Position;psp=panel.Position end
end)
uis.InputChanged:Connect(function(i)
    if dp and i.UserInputType==Enum.UserInputType.Touch then
        local d=i.Position-pdsp
        panel.Position=UDim2.new(psp.X.Scale,psp.X.Offset+d.X,psp.Y.Scale,psp.Y.Offset+d.Y)
    end
end)
uis.TouchEnded:Connect(function()dp=false end)

local closeBtn=Instance.new("TextButton",panel)
closeBtn.Size=UDim2.new(0,18,0,18)
closeBtn.Position=UDim2.new(1,-22,0,4)
closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
closeBtn.Text="✕"
closeBtn.TextColor3=Color3.fromRGB(255,255,255)
closeBtn.TextSize=9
closeBtn.ZIndex=32
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)

-- 左侧
local leftPanel=Instance.new("Frame",panel)
leftPanel.Size=UDim2.new(0,195,1,0)
leftPanel.BackgroundColor3=Color3.fromRGB(14,14,14)
leftPanel.BorderSizePixel=0
leftPanel.ZIndex=29
Instance.new("UICorner",leftPanel).CornerRadius=UDim.new(0,10)

local titleNN=Instance.new("TextLabel",leftPanel)
titleNN.Size=UDim2.new(1,-10,0,22)
titleNN.Position=UDim2.new(0,5,0,4)
titleNN.BackgroundTransparency=1
titleNN.Text="NNNB"
titleNN.TextColor3=Color3.fromRGB(255,80,255)
titleNN.Font=Enum.Font.GothamBlack
titleNN.TextSize=17
titleNN.TextXAlignment=Enum.TextXAlignment.Left
titleNN.ZIndex=31

local hue=0
rs.Heartbeat:Connect(function()
    hue=(hue+0.005)%1
    titleNN.TextColor3=Color3.fromHSV(hue,1,1)
end)

local verLabel=Instance.new("TextLabel",leftPanel)
verLabel.Size=UDim2.new(1,-10,0,12)
verLabel.Position=UDim2.new(0,5,0,24)
verLabel.BackgroundTransparency=1
verLabel.Text="v.1.2"
verLabel.TextColor3=Color3.fromRGB(255,40,40)
verLabel.Font=Enum.Font.Gotham
verLabel.TextSize=9
verLabel.TextXAlignment=Enum.TextXAlignment.Left
verLabel.ZIndex=31

local scrollFrame=Instance.new("ScrollingFrame",leftPanel)
scrollFrame.Size=UDim2.new(1,0,1,-40)
scrollFrame.Position=UDim2.new(0,0,0,40)
scrollFrame.BackgroundTransparency=1
scrollFrame.ScrollBarThickness=3
scrollFrame.CanvasSize=UDim2.new(0,0,0,235)
scrollFrame.ZIndex=29
scrollFrame.ScrollingDirection=Enum.ScrollingDirection.Y

local mainLabel=Instance.new("TextLabel",scrollFrame)
mainLabel.Size=UDim2.new(0.9,0,0,14)
mainLabel.Position=UDim2.new(0.05,0,0,2)
mainLabel.BackgroundTransparency=1
mainLabel.Text="▼ 主要内容"
mainLabel.TextColor3=Color3.fromRGB(255,200,100)
mainLabel.Font=Enum.Font.GothamBold
mainLabel.TextSize=10
mainLabel.TextXAlignment=Enum.TextXAlignment.Left
mainLabel.ZIndex=29

local subLabel=Instance.new("TextLabel",scrollFrame)
subLabel.Size=UDim2.new(0.9,0,0,14)
subLabel.Position=UDim2.new(0.05,0,0,130)
subLabel.BackgroundTransparency=1
subLabel.Text="▼ 次要内容"
subLabel.TextColor3=Color3.fromRGB(150,150,150)
subLabel.Font=Enum.Font.GothamBold
subLabel.TextSize=10
subLabel.TextXAlignment=Enum.TextXAlignment.Left
subLabel.ZIndex=29

local function makeMainBtn(name,y,cb)
    local btn=Instance.new("TextButton",scrollFrame)
    btn.Size=UDim2.new(0.9,0,0,24)
    btn.Position=UDim2.new(0.05,0,0,y)
    btn.BackgroundColor3=Color3.fromRGB(35,35,35)
    btn.Text=name
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=10
    btn.ZIndex=29
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,4)
    btn.MouseButton1Click:Connect(cb)
    return btn
end

-- 右侧
local rightPanel=Instance.new("Frame",panel)
rightPanel.Size=UDim2.new(0,143,1,0)
rightPanel.Position=UDim2.new(0,197,0,0)
rightPanel.BackgroundColor3=Color3.fromRGB(18,18,18)
rightPanel.BorderSizePixel=0
rightPanel.ZIndex=29
Instance.new("UICorner",rightPanel).CornerRadius=UDim.new(0,10)

local clockLabel=Instance.new("TextLabel",rightPanel)
clockLabel.Size=UDim2.new(1,0,0,40)
clockLabel.Position=UDim2.new(0,0,0,18)
clockLabel.BackgroundTransparency=1
clockLabel.Text="00:00:00"
clockLabel.TextColor3=Color3.fromRGB(0,255,200)
clockLabel.Font=Enum.Font.GothamBlack
clockLabel.TextSize=22
clockLabel.ZIndex=29

local dateLabel=Instance.new("TextLabel",rightPanel)
dateLabel.Size=UDim2.new(1,0,0,14)
dateLabel.Position=UDim2.new(0,0,0,56)
dateLabel.BackgroundTransparency=1
dateLabel.Text="----年--月--日"
dateLabel.TextColor3=Color3.fromRGB(150,150,150)
dateLabel.Font=Enum.Font.Gotham
dateLabel.TextSize=8
dateLabel.ZIndex=29

local divR=Instance.new("Frame",rightPanel)
divR.Size=UDim2.new(0.8,0,0,1)
divR.Position=UDim2.new(0.1,0,0,74)
divR.BackgroundColor3=Color3.fromRGB(60,60,60)
divR.ZIndex=29

local statusTitle=Instance.new("TextLabel",rightPanel)
statusTitle.Size=UDim2.new(1,0,0,14)
statusTitle.Position=UDim2.new(0,0,0,82)
statusTitle.BackgroundTransparency=1
statusTitle.Text="已开启"
statusTitle.TextColor3=Color3.fromRGB(200,200,200)
statusTitle.Font=Enum.Font.GothamBold
statusTitle.TextSize=10
statusTitle.ZIndex=29

local statusList=Instance.new("TextLabel",rightPanel)
statusList.Size=UDim2.new(1,0,0,120)
statusList.Position=UDim2.new(0,0,0,96)
statusList.BackgroundTransparency=1
statusList.Text="无"
statusList.TextColor3=Color3.fromRGB(100,255,100)
statusList.Font=Enum.Font.Gotham
statusList.TextSize=8
statusList.TextWrapped=true
statusList.ZIndex=29

local function updateClock()
    local t=os.date("*t")
    clockLabel.Text=string.format("%02d:%02d:%02d",t.hour,t.min,t.sec)
    dateLabel.Text=string.format("%d年%02d月%02d日",t.year,t.month,t.day)
end
updateClock()
rs.Heartbeat:Connect(updateClock)

local function updateStatus()
    local lines={}
    if flying then table.insert(lines,"✈ 飞行")end
    if noclip then table.insert(lines,"🧱 穿墙")end
    if espEnabled then table.insert(lines,"👁 透视")end
    if antiDetect then table.insert(lines,"🛡 防检测")end
    if antiFall then table.insert(lines,"🦿 防摔")end
    if nightVision then table.insert(lines,"☀ 夜视")end
    statusList.Text=#lines>0 and table.concat(lines,"\n")or"无"
end

-- 子面板
local currentSub=nil
local function closeSub()
    if currentSub then currentSub:Destroy();currentSub=nil end
end
local function createSub(txt)
    closeSub()
    local sp=Instance.new("Frame",gui)
    sp.Size=UDim2.new(0,155,0,195)
    sp.Position=UDim2.new(panel.Position.X.Scale,panel.Position.X.Offset-163,panel.Position.Y.Scale,panel.Position.Y.Offset)
    sp.BackgroundColor3=Color3.fromRGB(10,10,10)
    sp.BackgroundTransparency=0.05
    sp.ZIndex=28
    Instance.new("UICorner",sp).CornerRadius=UDim.new(0,8)
    local st=Instance.new("TextLabel",sp)
    st.Size=UDim2.new(1,-20,0,20)
    st.Position=UDim2.new(0,10,0,4)
    st.BackgroundTransparency=1
    st.Text=txt
    st.TextColor3=Color3.fromRGB(255,80,255)
    st.Font=Enum.Font.GothamBlack
    st.TextSize=12
    st.TextXAlignment=Enum.TextXAlignment.Left
    st.ZIndex=28
    local cb2=Instance.new("TextButton",sp)
    cb2.Size=UDim2.new(0,16,0,16)
    cb2.Position=UDim2.new(1,-20,0,4)
    cb2.BackgroundColor3=Color3.fromRGB(180,40,40)
    cb2.Text="✕"
    cb2.TextColor3=Color3.fromRGB(255,255,255)
    cb2.TextSize=8
    cb2.ZIndex=28
    Instance.new("UICorner",cb2).CornerRadius=UDim.new(1,0)
    cb2.MouseButton1Click:Connect(closeSub)
    currentSub=sp
    return sp
end

-- 开关按钮（开=绿，关=红）
local function addSwitch(parent,name,y,getState,toggleFn)
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(0.85,0,0,28)
    btn.Position=UDim2.new(0.075,0,0,y)
    btn.Text=name
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=11
    btn.ZIndex=28
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
    local function refresh()
        local state=getState()
        if state then
            btn.Text=name.." ✓"
            btn.BackgroundColor3=Color3.fromRGB(50,200,50)
        else
            btn.Text=name
            btn.BackgroundColor3=Color3.fromRGB(200,50,50)
        end
    end
    refresh()
    btn.MouseButton1Click:Connect(function()
        toggleFn()
        refresh()
    end)
    return btn
end

-- ===== 1. 飞行（+红色斗篷） =====
local function openFly()
    local sp=createSub("✈ 飞行设置")
    addSwitch(sp,"飞行",32,
        function()return flying end,
        function()
            if flying then
                flying=false
                if noclip then noclip=false end
                hum.PlatformStand=false
                removeCape()
                for _,n in ipairs({"FlyGyro","FlyVelocity"})do local o=root:FindFirstChild(n)if o then o:Destroy()end end
                local bc=root:FindFirstChildOfClass("BodyVelocity")if bc then bc:Destroy()end
                local bgc=root:FindFirstChildOfClass("BodyGyro")if bgc then bgc:Destroy()end
                mainBtn.BackgroundColor3=Color3.fromRGB(0,0,0)
                activeTouches={}
            else
                flying=true
                hum.PlatformStand=true
                createCape()
                local bg=Instance.new("BodyGyro",root)bg.Name=rn()bg.MaxTorque=Vector3.new(1,1,1)*math.huge
                local bv=Instance.new("BodyVelocity",root)bv.Name=rn()bv.MaxForce=Vector3.new(1,1,1)*math.huge
                mainBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
            end
            updateStatus()
        end
    )
    local sl=Instance.new("TextLabel",sp)
    sl.Size=UDim2.new(0.85,0,0,14)sl.Position=UDim2.new(0.075,0,0,66)
    sl.BackgroundTransparency=1 sl.Text="速度："..speed
    sl.TextColor3=Color3.fromRGB(200,200,200)sl.Font=Enum.Font.Gotham sl.TextSize=10
    sl.TextXAlignment=Enum.TextXAlignment.Center sl.ZIndex=28
    local sps={{"1档 40",40},{"2档 100",100},{"3档 500",500},{"4档 1000",1000},{"5档 2000",2000}}
    for i,sv in ipairs(sps)do
        local b=Instance.new("TextButton",sp)
        b.Size=UDim2.new(0.85,0,0,21)b.Position=UDim2.new(0.075,0,0,84+(i-1)*23)
        b.BackgroundColor3=speed==sv[2]and Color3.fromRGB(100,150,255)or Color3.fromRGB(35,35,35)
        b.Text=sv[1]b.TextColor3=Color3.fromRGB(255,255,255)b.Font=Enum.Font.GothamBold b.TextSize=10 b.ZIndex=28
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
        b.MouseButton1Click:Connect(function()
            speed=sv[2]sl.Text="速度："..speed
            for _,c in ipairs(sp:GetChildren())do if c:IsA("TextButton")and c.Text:find("档")then
                local v=tonumber(c.Text:match("%d+$"))
                c.BackgroundColor3=v==speed and Color3.fromRGB(100,150,255)or Color3.fromRGB(35,35,35)
            end end
        end)
    end
end

-- ===== 2. 穿墙 =====
local function openNoclip()
    local sp=createSub("🧱 穿墙设置")
    addSwitch(sp,"穿墙",32,
        function()return noclip end,
        function()if not flying then return end noclip=not noclip updateStatus()end
    )
    local ht=Instance.new("TextLabel",sp)
    ht.Size=UDim2.new(0.85,0,0,30)ht.Position=UDim2.new(0.075,0,0,70)
    ht.BackgroundTransparency=1 ht.Text="仅飞行时可用"ht.TextColor3=Color3.fromRGB(150,150,150)
    ht.Font=Enum.Font.Gotham ht.TextSize=9 ht.TextXAlignment=Enum.TextXAlignment.Center ht.ZIndex=28
end

-- ===== 3. 透视 =====
local function createESP(p)
    if p==player then return end
    local c=p.Character if not c then return end
    local hd=c:FindFirstChild("Head")if not hd then return end
    for i,o in ipairs(espObjects)do if o.p==p then
        pcall(function()if o.h then o.h:Destroy()end end)
        pcall(function()if o.b then o.b:Destroy()end end)
        table.remove(espObjects,i)break
    end end
    local hl=Instance.new("Highlight",c)hl.Name="NNESP"
    hl.FillTransparency=1 hl.OutlineColor=Color3.fromRGB(255,0,0)hl.OutlineTransparency=0
    local bb=Instance.new("BillboardGui",hd)bb.Name="NNESPL"
    bb.Size=UDim2.new(0,100,0,20)bb.StudsOffset=Vector3.new(0,3,0)bb.AlwaysOnTop=true
    local lb=Instance.new("TextLabel",bb)lb.Size=UDim2.new(1,0,1,0)lb.BackgroundTransparency=1
    lb.Text=p.Name lb.TextColor3=Color3.fromRGB(255,0,0)lb.Font=Enum.Font.GothamBold lb.TextSize=11
    table.insert(espObjects,{h=hl,b=bb,p=p})
end
local function clearESP()
    for _,o in ipairs(espObjects)do
        pcall(function()if o.h then o.h:Destroy()end end)
        pcall(function()if o.b then o.b:Destroy()end end)
    end
    espObjects={}
end
local function refreshESP()
    clearESP()
    if espEnabled then for _,p in ipairs(game.Players:GetPlayers())do if p~=player then pcall(function()createESP(p)end)end end end
end
local function openESP()
    local sp=createSub("👁 透视设置")
    addSwitch(sp,"透视",32,
        function()return espEnabled end,
        function()espEnabled=not espEnabled if espEnabled then refreshESP()else clearESP()end updateStatus()end
    )
    local ht2=Instance.new("TextLabel",sp)
    ht2.Size=UDim2.new(0.85,0,0,30)ht2.Position=UDim2.new(0.075,0,0,70)
    ht2.BackgroundTransparency=1 ht2.Text="红色描边+名字"ht2.TextColor3=Color3.fromRGB(150,150,150)
    ht2.Font=Enum.Font.Gotham ht2.TextSize=9 ht2.TextXAlignment=Enum.TextXAlignment.Center ht2.ZIndex=28
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()if espEnabled then wait(0.5)pcall(function()createESP(p)end)end end)
end)
game.Players.PlayerRemoving:Connect(function(p)
    for i,o in ipairs(espObjects)do if o.p==p then
        pcall(function()if o.h then o.h:Destroy()end end)
        pcall(function()if o.b then o.b:Destroy()end end)
        table.remove(espObjects,i)break
    end end
end)

-- ===== 4. 传送 =====
local function openTP()
    local sp=createSub("📍 传送玩家")
    local sf=Instance.new("ScrollingFrame",sp)
    sf.Size=UDim2.new(0.9,0,0,125)sf.Position=UDim2.new(0.05,0,0,30)
    sf.BackgroundTransparency=1 sf.ScrollBarThickness=3 sf.CanvasSize=UDim2.new(0,0,0,0)sf.ZIndex=28
    local ll=Instance.new("UIListLayout",sf)ll.Padding=UDim.new(0,3)ll.SortOrder=Enum.SortOrder.Name
    local function refreshList()
        for _,c in ipairs(sf:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end
        local th=0
        for _,p in ipairs(game.Players:GetPlayers())do if p~=player then
            local pb=Instance.new("TextButton",sf)
            pb.Size=UDim2.new(1,-6,0,23)pb.BackgroundColor3=Color3.fromRGB(35,35,35)
            pb.Text=p.Name pb.TextColor3=Color3.fromRGB(255,255,255)
            pb.Font=Enum.Font.Gotham pb.TextSize=10 pb.ZIndex=28
            Instance.new("UICorner",pb).CornerRadius=UDim.new(0,4)
            pb.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart")then
                    root.CFrame=CFrame.new(p.Character.HumanoidRootPart.Position+Vector3.new(0,3,0))
                end
            end)
            th=th+26
        end end
        sf.CanvasSize=UDim2.new(0,0,0,math.max(th,125))
    end
    refreshList()
    local rb=Instance.new("TextButton",sp)
    rb.Size=UDim2.new(0.85,0,0,23)rb.Position=UDim2.new(0.075,0,0,165)
    rb.BackgroundColor3=Color3.fromRGB(45,45,45)rb.Text="🔄 刷新列表"
    rb.TextColor3=Color3.fromRGB(255,255,255)rb.Font=Enum.Font.GothamBold rb.TextSize=10 rb.ZIndex=28
    Instance.new("UICorner",rb).CornerRadius=UDim.new(0,4)
    rb.MouseButton1Click:Connect(refreshList)
end

-- ===== 5. 防检测 =====
local function openAntiDetect()
    local sp=createSub("🛡 防检测设置")
    addSwitch(sp,"防检测",32,
        function()return antiDetect end,
        function()antiDetect=not antiDetect updateStatus()end
    )
    local ht3=Instance.new("TextLabel",sp)
    ht3.Size=UDim2.new(0.85,0,0,30)ht3.Position=UDim2.new(0.075,0,0,70)
    ht3.BackgroundTransparency=1 ht3.Text="不限制飞行功能"ht3.TextColor3=Color3.fromRGB(150,150,150)
    ht3.Font=Enum.Font.Gotham ht3.TextSize=9 ht3.TextXAlignment=Enum.TextXAlignment.Center ht3.ZIndex=28
end

-- ===== 6. 防摔 =====
local function openAntiFall()
    local sp=createSub("🦿 防摔设置")
    addSwitch(sp,"防摔",32,
        function()return antiFall end,
        function()antiFall=not antiFall updateStatus()end
    )
    local ht4=Instance.new("TextLabel",sp)
    ht4.Size=UDim2.new(0.85,0,0,30)ht4.Position=UDim2.new(0.075,0,0,70)
    ht4.BackgroundTransparency=1 ht4.Text="防跌落伤害"ht4.TextColor3=Color3.fromRGB(150,150,150)
    ht4.Font=Enum.Font.Gotham ht4.TextSize=9 ht4.TextXAlignment=Enum.TextXAlignment.Center ht4.ZIndex=28
end

-- ===== 7. 夜视 =====
local function openNV()
    local sp=createSub("☀ 夜视设置")
    addSwitch(sp,"夜视",32,
        function()return nightVision end,
        function()
            nightVision=not nightVision
            if nightVision then
                lighting.Brightness=2 lighting.ClockTime=12 lighting.FogEnd=9999
                lighting.GlobalShadows=false lighting.OutdoorAmbient=Color3.fromRGB(128,128,128)
            else
                lighting.Brightness=1 lighting.ClockTime=14 lighting.FogEnd=1000
                lighting.GlobalShadows=true lighting.OutdoorAmbient=Color3.fromRGB(70,70,70)
            end
            updateStatus()
        end
    )
    local ht5=Instance.new("TextLabel",sp)
    ht5.Size=UDim2.new(0.85,0,0,30)ht5.Position=UDim2.new(0.075,0,0,70)
    ht5.BackgroundTransparency=1 ht5.Text="强制白天/高亮度"ht5.TextColor3=Color3.fromRGB(150,150,150)
    ht5.Font=Enum.Font.Gotham ht5.TextSize=9 ht5.TextXAlignment=Enum.TextXAlignment.Center ht5.ZIndex=28
end

-- 主菜单按钮
makeMainBtn("✈ 飞行",18,openFly)
makeMainBtn("🧱 穿墙",46,openNoclip)
makeMainBtn("👁 透视",74,openESP)
makeMainBtn("📍 传送",102,openTP)
makeMainBtn("🛡 防检测",146,openAntiDetect)
makeMainBtn("🦿 防摔",174,openAntiFall)
makeMainBtn("☀ 夜视",202,openNV)

-- 事件
mainBtn.MouseButton1Click:Connect(function()closeSub()panel.Visible=not panel.Visible end)
closeBtn.MouseButton1Click:Connect(function()closeSub()panel.Visible=false end)

rs.Stepped:Connect(function()
    if noclip and flying and char then
        for _,p in ipairs(char:GetDescendants())do if p:IsA("BasePart")and p.CanCollide then p.CanCollide=false end end
    end
    if cape and flying and char then
        local torso=char:FindFirstChild("UpperTorso")or char:FindFirstChild("Torso")
        if torso then cape.CFrame=torso.CFrame*CFrame.new(0,0.3,-0.7)*CFrame.Angles(math.rad(-15),0,0)end
    end
end)

hum.StateChanged:Connect(function(_,ns)
    if antiFall and ns==Enum.HumanoidStateType.FallingDown then hum.PlatformStand=true wait(0.1)hum.PlatformStand=false end
end)

local sHalf=cam.ViewportSize.X/2
uis.TouchStarted:Connect(function(t)activeTouches[t]={sp=t.Position,cp=t.Position,L=t.Position.X<sHalf}end)
uis.TouchMoved:Connect(function(t)if activeTouches[t]then activeTouches[t].cp=t.Position end end)
uis.TouchEnded:Connect(function(t)activeTouches[t]=nil end)

rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv=root:FindFirstChildOfClass("BodyVelocity")
    local bg=root:FindFirstChildOfClass("BodyGyro")
    if not bv or not bg then return end
    local md=Vector3.zero
    for _,d in pairs(activeTouches)do
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
    char=c hum=c:WaitForChild("Humanoid")root=c:WaitForChild("HumanoidRootPart")
    if flying then flying=false hum.PlatformStand=false removeCape()activeTouches={}updateStatus()end
    if espEnabled then wait(0.5)refreshESP()end
end)

updateStatus()