local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- UIリセット
if CoreGui:FindFirstChild("WingUI") then CoreGui.WingUI:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "WingUI"
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.8, 0)
btn.Text = "パレットを1つ連結"

local wing, motors = nil, {}
local lastL, lastR = nil, nil

-- 連結関数（もっともシンプルな形）
local function connect(side, last)
    local sm = (side == "Left" and -1 or 1)
    local idx = (#motors / 2) + 1

    -- パーツ作成
    local p = Instance.new("Part", wing)
    p.Size = Vector3.new(2.8, 0.2, 0.6)
    p.Color = Color3.fromRGB(163, 124, 86)
    p.CanCollide = false

    -- 連結ジョイント
    local m = Instance.new("Motor6D", p)
    m.Part0 = last
    m.Part1 = p
    
    if last.Name == "HumanoidRootPart" then
        m.C0 = CFrame.new(0.7 * sm, 1, 0.5) * CFrame.Angles(0, math.rad(90 * sm), 0)
    else
        m.C0 = CFrame.new(0, 0, 2.5)
    end
    
    table.insert(motors, {motor = m, side = sm, step = math.ceil(idx)})
    return p
end

btn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    
    if not wing then
        wing = Instance.new("Model", char)
        lastL = char.HumanoidRootPart
        lastR = char.HumanoidRootPart
    end

    lastL = connect("Left", lastL)
    lastR = connect("Right", lastR)
end)

-- アニメーション
RunService.RenderStepped:Connect(function()
    if not wing then return end
    for _, d in ipairs(motors) do
        d.motor.C1 = CFrame.Angles(0, math.sin(tick() * 3.5 - (d.step * 0.4)) * math.rad(30) * d.side, 0)
    end
end)
