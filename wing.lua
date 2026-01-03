local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 🌸 [設定] ゲーム内のトイメニューにあるボタンの名前
-- Fling Things 等では "Pallet" という名前のボタンが多いです
local TARGET_BUTTON_NAME = "Pallet" 

local function getToyButton()
    -- プレイヤーの画面上(PlayerGui)からボタンを自動探索
    for _, v in ipairs(player:WaitForChild("PlayerGui"):GetDescendants()) do
        if v:IsA("TextButton") and (v.Text:find(TARGET_BUTTON_NAME) or v.Name:find(TARGET_BUTTON_NAME)) then
            return v
        end
    end
    return nil
end

-- 🌸 実際にトイメニューを「操作」する関数
local function autoClickMenu()
    local btn = getToyButton()
    
    if btn then
        print("🌸 トイメニューのボタンを見つけました: " .. btn.Name)
        -- 10回連続でボタンを操作（クリックイベントを発火）
        for i = 1, 10 do
            -- Robloxの標準的なクリック信号を送る
            for _, connection in ipairs(getconnections(btn.MouseButton1Click)) do
                connection:Fire()
            end
            for _, connection in ipairs(getconnections(btn.MouseButton1Down)) do
                connection:Fire()
            end
            task.wait(0.1) -- 連結が追いつくように少し待つ
        end
    else
        warn("⚠️ トイメニューの中に '" .. TARGET_BUTTON_NAME .. "' ボタンが見つかりません。メニューを開いた状態で実行してください。")
    end
end

-- 実行（スクリプトを読み込んだ瞬間に10回操作します）
task.spawn(autoClickMenu)
