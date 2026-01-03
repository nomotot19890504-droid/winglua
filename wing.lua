-- [[ 🌸 SAKURA STYLE PALLET WINGS 🌸 ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- 既存のUIを削除
if CoreGui:FindFirstChild("SakuraWingUI") then CoreGui.SakuraWingUI:Destroy() end

-- 🌸UI作成🌸
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "SakuraWingUI"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 200, 0, 100)
main.Position = UDim2.new(0.5, -100, 0.8, 0)
main.BackgroundColor3 = Color3.fromRGB(255, 192, 203) -- さくらピンク
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0, 180, 0, 40)
btn.Position = UDim2.new(0.5, -90, 0.2, 0)
btn.Text = "パレットを連結"
btn.Font = Enum.Font.GothamBold
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.TextColor3 = Color3.fromRGB(255, 105, 180)
Instance.new("UICorner", btn)

local reset = Instance.new("TextButton", main)
reset.Size = UDim2.new(0, 180, 0, 25)
reset.Position = UDim2.new(0.5, -90, 0.65, 0)
reset.Text = "リセット"
reset.Font = Enum.Font.Gotham
reset.BackgroundTransparency = 1
reset.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 🌸システム🌸
local wingModel = nil
local motors = {}
local lastL, lastR = nil, nil

-- 連結の仕組み
local function addPallet(side, lastPart)
    local sm = (side == "Left" and -1 or 1)
    local idx = (#motors / 2) + 1

    -- パーツ作成
    local p = Instance.new("Part", wingModel)
    p.Size = Vector3.new(2.8, 0.15, 0.5)
    p.Color = Color3.fromRGB(163, 124, 86) -- パレットの色
    p.Material = Enum.Material.Wood
    p.CanCollide = false
    p.Massless = true

    -- ジョイント（Motor6D）
    local m = Instance.new("Motor6D", p)
    m.Part0 = lastPart
    m.Part1 = p
    
    -- 連結位置（1枚目は背中、2枚目以降は板の先に）
    if lastPart.Name == "HumanoidRootPart" then
        m.C0 = CFrame.new(0.7 * sm, 1, 0.5) * CFrame.Angles(0, math.rad(90 * sm), 0)
    else
        m.C0 = CFrame.new(0, 0, 2.3)
    end
    
    table.insert(motors, {motor = m, side = sm, step = math.ceil(idx)})
    return p
end

-- ボタン操作
btn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    
    if not wingModel or not wingModel.Parent then
        wingModel = Instance.new("Model", char)
        wingModel.Name = "PalletWing"
        lastL = char:WaitForChild("HumanoidRootPart")
        lastR = lastL
        motors = {}
    end

    lastL = addPallet("Left", lastL)
    lastR = addPallet("Right", lastR)
end)

-- リセット
reset.MouseButton1Click:Connect(function()
    if wingModel then wingModel:Destroy() end
    wingModel = nil
    motors = {}
end)

-- 🌸羽ばたきアニメーション🌸
RunService.RenderStepped:Connect(function()
    if not wingModel then return end
    local t = tick() * 4 -- 速さ
    for _, d in ipairs(motors) do
        if d.motor and d.motor.Parent then
            -- 連結数が増えるほど、先端が遅れて動く（しなやかな動き）
            d.motor.C1 = CFrame.Angles(0, math.sin(t - (d.step * 0.5)) * math.rad(30) * d.side, 0)
        end
    end
end)
