local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- UIリセット
if CoreGui:FindFirstChild("PalletUI") then CoreGui.PalletUI:Destroy() end

-- シンプルなボタン
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "PalletUI"
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 40)
btn.Position = UDim2.new(0.5, -75, 0.8, 0)
btn.Text = "PALLET START"
btn.BackgroundColor3 = Color3.fromRGB(163, 124, 86)
btn.TextColor3 = Color3.new(1, 1, 1)

local wing = nil
local motors = {}

-- 1枚ずつ連結する関数
local function addPiece(side, idx, last)
    local sm = (side == "Left" and -1 or 1)
    local b = Instance.new("Part", wing)
    b.Size = Vector3.new(0.1, 0.1, 0.1); b.Transparency = 1; b.CanCollide = false
    
    -- パレットの板
    local p = Instance.new("Part", b)
    p.Size = Vector3.new(2.8, 0.15, 0.5); p.Color = Color3.fromRGB(163, 124, 86); p.Material = "Wood"
    p.CanCollide = false; p.Massless = true
    local w = Instance.new("Weld", p); w.Part0 = b; w.Part1 = p

    -- 連結ジョイント
    local m = Instance.new("Motor6D", last)
    m.Part0 = last; m.Part1 = b
    if idx == 1 then
        m.C0 = CFrame.new(0.6 * sm, 1, 0.5) * CFrame.Angles(0, math.rad(90 * sm), 0)
    else
        m.C0 = CFrame.new(0, 0, 2.3)
    end
    table.insert(motors, {motor = m, index = idx, side = sm})
    return b
end

btn.MouseButton1Click:Connect(function()
    if wing then wing:Destroy(); wing = nil; motors = {}; return end
    
    local char = player.Character
    wing = Instance.new("Model", char)
    local lLast = char.HumanoidRootPart
    local rLast = lLast
    
    -- 1つずつ連結していく様子
    for i = 1, 3 do
        lLast = addPiece("Left", i, lLast)
        rLast = addPiece("Right", i, rLast)
        task.wait(0.3) -- 連結の間隔
    end
    
    -- 完成後に羽ばたく
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not wing or not wing.Parent then conn:Disconnect() return end
        local t = tick() * 3.5
        for _, d in ipairs(motors) do
            d.motor.C1 = CFrame.Angles(0, math.sin(t - (d.index * 0.4)) * math.rad(35) * d.side, 0)
        end
    end)
end)