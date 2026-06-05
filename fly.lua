local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 200, 0, 80)
btn.Position = UDim2.new(0.5, -100, 0.3, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "点我打开菜单"
btn.TextSize = 22
btn.TextColor3 = Color3.fromRGB(255, 255, 255)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 200, 0, 150)
menu.Position = UDim2.new(0.5, -100, 0.5, -75)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.Visible = false

local closeBtn = Instance.new("TextButton", menu)
closeBtn.Size = UDim2.new(0, 60, 0, 30)
closeBtn.Position = UDim2.new(0.5, -30, 0.7, 0)
closeBtn.Text = "关闭"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local label = Instance.new("TextLabel", menu)
label.Size = UDim2.new(1, 0, 0, 40)
label.Position = UDim2.new(0, 0, 0.2, 0)
label.Text = "菜单打开了！"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 18
label.BackgroundTransparency = 1

btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
end)