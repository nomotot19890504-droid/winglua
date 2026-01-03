local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- UIリセット
if CoreGui:FindFirstChild("SmoothWingHub") then CoreGui.SmoothWingHub:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "SmoothWingHub"

-- 🌸 開閉ボタン
local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(0, 15, 0.5, -22)
openBtn.Text = "🌸"
openBtn.TextSize = 25
openBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
openBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- 🌸 メインメニュー
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 70, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FTAP SMOOTH WING"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- 🌸 [10枚連結ボタン]
local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Size = UDim2.new(0, 180, 0, 45)
spawnBtn.Position = UDim2.new(0.5, -90, 0.3, 0)
spawnBtn.Text = "10枚一括連結 (Smooth)"
spawnBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", spawnBtn)

-- 🌸 [削除ボタン]
local removeBtn = Instance.new("TextButton", frame)
removeBtn.Size = UDim2.new(0, 180, 0, 45)
removeBtn.Position = UDim2.new(0.5, -90, 0.65, 0)
removeBtn.Text = "羽を消去"
removeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
removeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", removeBtn)

-- 開閉処理
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

--- システム部 ---
local wingModel, motors = nil, {}

local function createPiece(side, last, i)
    local sm = (side == "Left" and -1 or 1)
    local p = Instance.new("Part", wingModel)
    p.Size = Vector3.new(3, 0.2, 0.8)
    p.Color = Color3.fromRGB(163, 124, 86)
    p.Material = Enum.Material.Wood
    p.CanCollide = false
    p.Massless = true
    local m = Instance.new("Motor6D", p)
    m.Part0 = last
    m.Part1 = p
    if last.Name == "HumanoidRootPart" then
        m.C0 = CFrame.new(0.8 * sm, 1, 0.5) * CFrame.Angles(0, math.rad(90 * sm), 0)
    else
        m.C0 = CFrame.new(0, 0, 2.7)
    end
    table.insert(motors, {m = m, s = sm, i = i})
    return p
end

spawnBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or wingModel then return end
    
    wingModel = Instance.new("Model", char)
    wingModel.Name = "SmoothWingModel"
    local l, r = root, root
    for i = 1, 10 do
        l = createPiece("Left", l, i)
        r = createWing and createPiece("Right", r, i) or createPiece("Right", r, i)
        task.wait(0.06)
    end
end)

removeBtn.MouseButton1Click:Connect(function()
    if wingModel then wingModel:Destroy() end
    wingModel = nil
    motors = {}
end)

-- 滑らかなアニメーション
RunService.RenderStepped:Connect(function()
    if not wingModel then return end
    local t = tick() * 4
    for _, d in ipairs(motors) do
        if d.m and d.m.Parent then
            -- 先端にいくほど遅れて波打つ（しなやかな動き）
            local angle = math.sin(t - (d.i * 0.4)) * math.rad(35)
            d.m.C1 = CFrame.Angles(0, angle * d.s, 0)
        end
    end
end)
