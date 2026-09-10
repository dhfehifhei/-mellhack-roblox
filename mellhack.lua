-- [AERO] MellHack Ultimate v11.0 (Fixed, Overhauled & Optimized)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cfg = {
    AccentColor = Color3.fromRGB(0, 255, 128),
    -- Движение
    Fly = false,
    FlySpeed = 70,
    Speed = false,
    WalkSpeedVal = 50,
    Jump = false,
    JumpPowerVal = 180,
    InfiniteJump = false,
    Bhop = false,
    Noclip = false,
    -- Бой / Aim
    Aimbot = false,
    AimPart = "Head",
    AimFOV = 180,
    AimSmooth = 2,
    VisibleCheck = true,
    DrawFOV = true,
    FOVColor = Color3.fromRGB(255, 255, 255),
    Triggerbot = false,
    HitboxExpander = false,
    HitboxSize = 5,
    -- Визуалы
    ESPBox = true,
    HPBar = true,
    Chams = true,
    Xray = false,
    Fullbright = false,
    -- Рейдж / Fun
    Godmode = false,
    SpinBot = false,
    Fling = false
}

if CoreGui:FindFirstChild("MellHackV11") then
    CoreGui.MellHackV11:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MellHackV11"
ScreenGui.ResetOnSpawn = false

-- Кнопка меню
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 180, 0, 38)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "MellHack v11.0 [Fixed Hub]"
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = cfg.AccentColor
tStroke.Thickness = 1.5

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = cfg.AccentColor
mStroke.Thickness = 2

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Шапка
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "MellHack v11.0 // Overhauled Pro Edition"

-- Вкладки слева
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 135, 1, -54)
TabBar.Position = UDim2.new(0, 8, 0, 50)
TabBar.BackgroundTransparency = 1

-- Контент справа
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -155, 1, -54)
ContentArea.Position = UDim2.new(0, 147, 0, 50)
ContentArea.BackgroundTransparency = 1

local sections = {}
local function createSection(name)
    local sec = Instance.new("Frame", ContentArea)
    sec.Size = UDim2.new(1, 0, 1, 0)
    sec.BackgroundTransparency = 1
    sec.Visible = false
    sections[name] = sec
    return sec
end

local secMove = createSection("Move")
local secCombat = createSection("Combat")
local secVisual = createSection("Visual")
local secRage = createSection("Rage")
local secSettings = createSection("Settings")

secMove.Visible = true

local function switchSection(secName)
    for name, s in pairs(sections) do
        s.Visible = (name == secName)
    end
end

local function createTabButton(title, secName, index)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, 0, (index - 1) * 42)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. title
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        switchSection(secName)
        for _, child in pairs(TabBar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
                child.TextColor3 = Color3.fromRGB(160, 160, 180)
            end
        end
        btn.BackgroundColor3 = cfg.AccentColor
        btn.TextColor3 = Color3.fromRGB(10, 10, 14)
    end)
    
    if index == 1 then
        btn.BackgroundColor3 = cfg.AccentColor
        btn.TextColor3 = Color3.fromRGB(10, 10, 14)
    end
end

createTabButton("Движение", "Move", 1)
createTabButton("Бой / Aim", "Combat", 2)
createTabButton("Визуалы ESP", "Visual", 3)
createTabButton("Рейдж / Fun", "Rage", 4)
createTabButton("Настройки", "Settings", 5)


-- КОНСТРУКТОРЫ ЭЛЕМЕНТОВ
local function addToggle(parent, name, yOffset, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -6, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. name .. " [OFF]"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = cfg.AccentColor
            btn.TextColor3 = Color3.fromRGB(10, 10, 14)
            btn.Text = "  " .. name .. " [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = "  " .. name .. " [OFF]"
        end
        callback(state)
    end)
end

local function addSlider(parent, name, min, max, default, yOffset, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -6, 0, 44)
    frame.Position = UDim2.new(0, 0, 0, yOffset)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -12, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = name .. ": " .. default

    local sliderBg = Instance.new("TextButton", frame)
    sliderBg.Size = UDim2.new(1, -16, 0, 6)
    sliderBg.Position = UDim2.new(0, 8, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    sliderBg.Text = ""
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = cfg.AccentColor
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local dragging = false
    sliderBg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((inp.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- НАПОЛНЕНИЕ РАЗДЕЛОВ

-- 1. Движение
addToggle(secMove, "Полет (Fly)", 0, function(v) cfg.Fly = v end)
addSlider(secMove, "Скорость полета", 10, 200, 70, 39, function(v) cfg.FlySpeed = v end)
addToggle(secMove, "Спидхак (Speed)", 88, function(v) cfg.Speed = v end)
addSlider(secMove, "Значение бега", 16, 200, 50, 127, function(v) cfg.WalkSpeedVal = v end)
addToggle(secMove, "Супер Прыжок (Jump)", 176, function(v) cfg.Jump = v end)
addSlider(secMove, "Высота прыжка", 50, 500, 180, 215, function(v) cfg.JumpPowerVal = v end)
addToggle(secMove, "Авто-распрыг (Bunnyhop)", 264, function(v) cfg.Bhop = v end)
addToggle(secMove, "Бесконечный прыжок (Inf Jump)", 303, function(v) cfg.InfiniteJump = v end)
addToggle(secMove, "Хождение сквозь стены (Noclip)", 342, function(v) cfg.Noclip = v end)

-- 2. Бой / Aim
addToggle(secCombat, "Аимбот (Aimbot)", 0, function(v) cfg.Aimbot = v end)
addSlider(secCombat, "Радиус FOV", 50, 600, 180, 39, function(v) cfg.AimFOV = v end)
addSlider(secCombat, "Плавность аимбота", 1, 15, 2, 88, function(v) cfg.AimSmooth = v end)
addToggle(secCombat, "Рисовать круг FOV (Draw FOV)", 137, function(v) cfg.DrawFOV = v end)
addToggle(secCombat, "Проверка видимости", 176, function(v) cfg.VisibleCheck = v end)
addToggle(secCombat, "Увеличение хитбоксов", 215, function(v) cfg.HitboxExpander = v end)

-- 3. Визуалы ESP
addToggle(secVisual, "ESP Боксы (Boxes)", 0, function(v) cfg.ESPBox = v end)
addToggle(secVisual, "Полоска здоровья (HP Bar)", 39, function(v) cfg.HPBar = v end)
addToggle(secVisual, "Чамсы (Chams Glow)", 78, function(v) cfg.Chams = v end)
addToggle(secVisual, "Просвет стен (Xray)", 117, function(v) cfg.Xray = v end)
addToggle(secVisual, "Яркий свет (Fullbright)", 156, function(v) cfg.Fullbright = v end)

-- 4. Рейдж / Fun
addToggle(secRage, "Бессмертие (Godmode)", 0, function(v) cfg.Godmode = v end)
addToggle(secRage, "Спинбот (SpinBot)", 39, function(v) cfg.SpinBot = v end)
addToggle(secRage, "Флинг-аура (Rage Fling)", 78, function(v) cfg.Fling = v end)

-- 5. Настройки
local stLbl = Instance.new("TextLabel", secSettings)
stLbl.Size = UDim2.new(1, 0, 0, 24)
stLbl.BackgroundTransparency = 1
stLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
stLbl.TextSize = 11
stLbl.Font = Enum.Font.GothamBold
stLbl.TextXAlignment = Enum.TextXAlignment.Left
stLbl.Text = "  Настройки темы и цвета FOV:"

local function addThemeButton(name, color, yPos)
    local b = Instance.new("TextButton", secSettings)
    b.Size = UDim2.new(1, -6, 0, 34)
    b.Position = UDim2.new(0, 0, 0, yPos)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(10, 10, 14)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Text = "Цвет: " .. name
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        cfg.AccentColor = color
        cfg.FOVColor = color
        mStroke.Color = color
        tStroke.Color = color
    end)
end

addThemeButton("Кислотный зеленый", Color3.fromRGB(0, 255, 128), 30)
addThemeButton("Неоновый фиолетовый", Color3.fromRGB(138, 43, 226), 69)
addThemeButton("Кибернетический синий", Color3.fromRGB(40, 130, 240), 108)
addThemeButton("Ярко-красный", Color3.fromRGB(240, 40, 80), 147)
addThemeButton("Чистый белый", Color3.fromRGB(255, 255, 255), 186)


-- СТАБИЛЬНЫЙ УНИВЕРСАЛЬНЫЙ ESP РЕНДЕРЕР
local espBlips = {}
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")

            if not espBlips[p] then
                local folder = Instance.new("Folder", ScreenGui)
                folder.Name = "ESP_" .. p.Name
                
                local box = Instance.new("Frame", folder)
                box.BackgroundColor3 = Color3.new(0,0,0)
                box.BackgroundTransparency = 1
                box.BorderSizePixel = 0
                
                local stroke = Instance.new("UIStroke", box)
                stroke.Color = cfg.AccentColor
                stroke.Thickness = 1.5

                local hpBack = Instance.new("Frame", folder)
                hpBack.BackgroundColor3 = Color3.fromRGB(0,0,0)
                hpBack.BorderSizePixel = 0
                hpBack.Visible = false

                local hpFill = Instance.new("Frame", hpBack)
                hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                hpFill.BorderSizePixel = 0

                espBlips[p] = {Box = box, HPBack = hpBack, HPFill = hpFill, Stroke = stroke}
            end

            local ui = espBlips[p]
            ui.Stroke.Color = cfg.AccentColor
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if (cfg.ESPBox or cfg.HPBar) and onScreen then
                local size = Vector2.new(2000 / vector.Z, 3000 / vector.Z)
                local pos = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)

                if cfg.ESPBox then
                    ui.Box.Size = UDim2.new(0, size.X, 0, size.Y)
                    ui.Box.Position = UDim2.new(0, pos.X, 0, pos.Y)
                    ui.Box.Visible = true
                else
                    ui.Box.Visible = false
                end

                if cfg.HPBar and hum then
                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    ui.HPBack.Size = UDim2.new(0, 3, 0, size.Y)
                    ui.HPBack.Position = UDim2.new(0, pos.X - 6, 0, pos.Y)
                    ui.HPBack.Visible = true

                    ui.HPFill.Size = UDim2.new(1, 0, 0, size.Y * pct)
                    ui.HPFill.Position = UDim2.new(0, 0, 1 - pct, 0)
                else
                    ui.HPBack.Visible = false
                end
            else
                ui.Box.Visible = false
                ui.HPBack.Visible = false
            end
        elseif espBlips[p] then
            espBlips[p].Box.Visible = false
            espBlips[p].HPBack.Visible = false
        end
    end
end)


-- ОТРИСОВКА КРУГА FOV НА ЭКРАНЕ
local fovDrawing = Drawing.new("Circle")
fovDrawing.Thickness = 1.5
fovDrawing.NumSides = 60
fovDrawing.Filled = false
fovDrawing.Transparency = 0.8

RunService.RenderStepped:Connect(function()
    if cfg.Aimbot and cfg.DrawFOV then
        fovDrawing.Visible = true
        fovDrawing.Radius = cfg.AimFOV
        fovDrawing.Color = cfg.FOVColor
        fovDrawing.Position = UserInputService:GetMouseLocation()
    else
        fovDrawing.Visible = false
    end
end)


-- ПРОВЕРКА ВИДИМОСТИ ДЛЯ АИМБОТА
local function isVisible(targetPart)
    if not cfg.VisibleCheck then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)
    return result == nil or result.Instance:IsDescendantOf(targetPart.Parent)
end


-- ГЛАВНЫЙ ИСПОЛНИТЕЛЬНЫЙ ЦИКЛ ФИЗИКИ И БОЯ
UserInputService.JumpRequest:Connect(function()
    if cfg.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    if cfg.Speed then humanoid.WalkSpeed = cfg.WalkSpeedVal end
    if cfg.Jump then humanoid.JumpPower = cfg.JumpPowerVal end
    if cfg.Godmode then humanoid.Health = humanoid.MaxHealth end

    if cfg.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    -- Авто-распрыг (Bunnyhop)
    if cfg.Bhop and humanoid then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    if cfg.SpinBot then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(80), 0)
    end

    if cfg.Fling then
        hrp.RotVelocity = Vector3.new(0, 99999, 0)
    end

    if cfg.Fly then
        hrp.Velocity = Vector3.new(0, 0.5, 0)
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        hrp.CFrame = hrp.CFrame + (move * (cfg.FlySpeed / 30))
    end

    if cfg.Fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
    end

    if cfg.Xray then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency < 0.5 and not p:IsDescendantOf(char) then
                p.LocalTransparencyModifier = 0.6
            end
        end
    end

    -- Хитбоксы голов
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            if cfg.HitboxExpander then
                head.Size = Vector3.new(cfg.HitboxSize, cfg.HitboxSize, cfg.HitboxSize)
                head.Transparency = 0.4
                head.CanCollide = false
            else
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
            end
        end
    end

    if cfg.Chams then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("MellChamsV11") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "MellChamsV11"
                hl.FillColor = cfg.AccentColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif p.Character and p.Character:FindFirstChild("MellChamsV11") then
                p.Character.MellChamsV11.FillColor = cfg.AccentColor
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MellChamsV11") then
                p.Character.MellChamsV11:Destroy()
            end
        end
    end

    -- УЛУЧШЕННЫЙ АИМБОТ
    if cfg.Aimbot and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)) then
        local target, minDst = nil, cfg.AimFOV
        local mousePos = UserInputService:GetMouseLocation()

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen and isVisible(p.Character.Head) then
                        local dst = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dst < minDst then
                            minDst = dst
                            target = p.Character.Head
                        end
                    end
                end
            end
        end

        if target then
            local goalCF = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goalCF, 1 / cfg.AimSmooth)
        end
    end
end)

print("[AERO] MellHack v11.0 Overhauled Hub loaded successfully!")

