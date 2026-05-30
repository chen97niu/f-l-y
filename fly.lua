local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local flying = false
local speed = 50
local keys = {}

pcall(function() player.PlayerGui:FindFirstChild("FlyGui"):Destroy() end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FlyGui"
gui.ResetOnSpawn = false

local mainBtn = Instance.new("TextButton", gui)
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0.95, 0, 0.02, 0)
mainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainBtn.BackgroundTransparency = 0.3
mainBtn.Text = "✈"
mainBtn.TextSize = 24
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 25)

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 160, 0, 180)
panel.Position = UDim2.new(0.88, 0, 0.1, 0)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BackgroundTransparency = 0.2
panel.Visible = false
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local flyBtn = Instance.new("TextButton", panel)
flyBtn.Size = UDim2.new(0.85, 0, 0, 38)
flyBtn.Position = UDim2.new(0.075, 0, 0.08, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyBtn.Text = "飞行：关"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 15
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 8)

local speedText = Instance.new("TextLabel", panel)
speedText.Size = UDim2.new(0.85, 0, 0, 22)
speedText.Position = UDim2.new(0.075, 0, 0.33, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "速度：50"
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 13
speedText.TextXAlignment = Enum.TextXAlignment.Left

local speedDown = Instance.new("TextButton", panel)
speedDown.Size = UDim2.new(0.35, 0, 0, 30)
speedDown.Position = UDim2.new(0.1, 0, 0.48, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedDown.Text = "-"
speedDown.TextSize = 20
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0, 6)

local speedUp = Instance.new("TextButton", panel)
speedUp.Size = UDim2.new(0.35, 0, 0, 30)
speedUp.Position = UDim2.new(0.55, 0, 0.48, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedUp.Text = "+"
speedUp.TextSize = 20
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0, 6)

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
end

mainBtn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)
flyBtn.MouseButton1Click:Connect(function() if flying then stopFly() else startFly() end end)
speedDown.MouseButton1Click:Connect(function() speed = math.max(5, speed - 5); speedText.Text = "速度："..speed end)
speedUp.MouseButton1Click:Connect(function() speed = math.min(500, speed + 5); speedText.Text = "速度："..speed end)

uis.InputBegan:Connect(function(i, g)
    if g then return end
    keys[i.KeyCode] = true
end)
uis.InputEnded:Connect(function(i)
    keys[i.KeyCode] = false
end)

rs.RenderStepped:Connect(function()
    if not flying then return end
    local bv = root:FindFirstChild("FlyVelocity")
    local bg = root:FindFirstChild("FlyGyro")
    if not bv or not bg then return end
    local cam = workspace.CurrentCamera
    local dir = Vector3.zero
    if keys[Enum.KeyCode.W] then dir += cam.CFrame.LookVector end
    if keys[Enum.KeyCode.S] then dir -= cam.CFrame.LookVector end
    if keys[Enum.KeyCode.A] then dir -= cam.CFrame.RightVector end
    if keys[Enum.KeyCode.D] then dir += cam.CFrame.RightVector end
    if keys[Enum.KeyCode.Space] then dir += Vector3.new(0,1,0) end
    if keys[Enum.KeyCode.LeftShift] then dir -= Vector3.new(0,1,0) end
    bv.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
    bg.CFrame = cam.CFrame
end)

player.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if flying then stopFly() end
end)