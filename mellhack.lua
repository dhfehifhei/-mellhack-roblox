-- [AERO] MellHack Ultimate v8.0 (Fun, Animations & Invisible Edition)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cfg = {
    AccentColor = Color3.fromRGB(255, 100, 200), -- Розовый неон для фан-хаба
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    WalkSpeedVal = 32,
    Jump = false,
    JumpPowerVal = 100,
    Noclip = false,
    Invisible = false,
    Godmode = false,
    Fullbright = false,
    ButterflyKnife = false,
    HeadKick = false,
    SpinBot = false
}

if CoreGui:FindFirstChild("MellHackV8") then
    CoreGui.MellHackV8:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MellHackV8"
ScreenGui.ResetOnSpawn = false

-- Кнопка меню
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 180, 0, 38)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "MellHack v8.0 [Fun Hub]"
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = cfg.AccentColor
tStroke.Thickness = 1.5

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
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
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "MellHack v8.0 // Fun & Animations Hub"

-- Вкладки слева
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 140, 1, -54)
TabBar.Position = UDim2.new(0, 8, 0, 50)
TabBar.BackgroundTransparency = 1

-- Контент справа
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -160, 1, -54)
ContentArea.Position = UDim2.new(0, 152, 0, 50)
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
local secFun = createSection("Fun")
local secAnim = createSection("Anim")
local secSettings = createSection("Settings")

secMove.Visible = true

local function switchSection(secName)
    for name, s in pairs(sections) do
        s.Visible = (name == secName)
    end
end

local function createTabButton(title, secName, index)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, (index - 1) * 44)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
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
                child.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                child.TextColor3 = Color3.fromRGB(160, 160, 180)
            end
        end
        btn.BackgroundColor3 = cfg.AccentColor
        btn.TextColor3 = Color3.fromRGB(12, 12, 16)
    end)
    
    if index == 1 then
        btn.BackgroundColor3 = cfg.AccentColor
        btn.TextColor3 = Color3.fromRGB(12, 12, 16)
    end
end

createTabButton("Движение", "Move", 1)
createTabButton("Фан & Инвиз", "Fun", 2)
createTabButton("Анимации & Оружие", "Anim", 3)
createTabButton("Настройки", "Settings", 4)


-- КОНСТРУКТОРЫ
local function addToggle(parent, name, yOffset, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -6, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
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
            btn.TextColor3 = Color3.fromRGB(12, 12, 16)
            btn.Text = "  " .. name .. " [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = "  " .. name .. " [OFF]"
        end
        callback(state)
    end)
end

local function addButton(parent, name, yOffset, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -6, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  ▶ " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        callback()
    end)
end

local function addSlider(parent, name, min, max, default, yOffset, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -6, 0, 44)
    frame.Position = UDim2.new(0, 0, 0, yOffset)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
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
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
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

-- НАПОЛНЕНИЕ ВКЛАДОК

-- 1. Движение
addToggle(secMove, "Полет (Fly)", 0, function(v) cfg.Fly = v end)
addSlider(secMove, "Скорость полета", 10, 200, 50, 39, function(v) cfg.FlySpeed = v end)
addToggle(secMove, "Спидхак (Speed)", 88, function(v) cfg.Speed = v end)
addSlider(secMove, "Значение бега", 16, 150, 32, 127, function(v) cfg.WalkSpeedVal = v end)
addToggle(secMove, "Супер Прыжок (Jump)", 176, function(v) cfg.Jump = v end)
addSlider(secMove, "Высота прыжка", 50, 400, 100, 215, function(v) cfg.JumpPowerVal = v end)
addToggle(secMove, "Сквозь стены (Noclip)", 264, function(v) cfg.Noclip = v end)

-- 2. Фан и Инвиз
addToggle(secFun, "Невидимка (Invisible Mode)", 0, function(v) 
    cfg.Invisible = v
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = v and 1 or 0
            end
        end
    end
end)
addToggle(secFun, "Бессмертие (Godmode)", 39, function(v) cfg.Godmode = v end)
addToggle(secFun, "Спинбот (SpinBot)", 78, function(v) cfg.SpinBot = v end)

-- 3. Анимации и Оружие
addToggle(secAnim, "Нож-Бабочка (Butterfly Knife)", 0, function(v)
    cfg.ButterflyKnife = v
    local char = LocalPlayer.Character
    if v and char and not char:FindFirstChild("MellButterfly") then
        -- Создаем визуальный проп ножа-бабочки в руке
        local knife = Instance.new("Part", char)
        knife.Name = "MellButterfly"
        knife.Size = Vector3.new(0.2, 0.2, 1.2)
        knife.BrickColor = BrickColor.new("Dark stone grey")
        local weld = Instance.new("Weld", knife)
        weld.Part0 = knife
        weld.Part1 = char:FindFirstChild("Right Hand") or char:FindFirstChild("Right Arm")
        weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), 0, 0)
    elseif not v and char and char:FindFirstChild("MellButterfly") then
        char.MellButterfly:Destroy()
    end
end)

addButton(secAnim, "Снять голову и пинать её!", 39, function()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        -- Отрываем голову по-настоящему, превращая в физический предмет
        head.Parent = workspace
        head.CanCollide = true
        head.Anchored = false
        -- Додаем легкий толчок вперед, чтобы её можно было пинать ногами
        head.AssemblyLinearVelocity = char.HumanoidRootPart.CFrame.LookVector * 25
    end
end)

addButton(secAnim, "Запустить танец (Dance Emote)", 78, function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        -- Запуск встроенной анимации танца Roblox
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://507771019" -- Популярный танец
        local track = hum:LoadAnimation(anim)
        track:Play()
    end
end)

-- 4. Настройки темы
local stLbl = Instance.new("TextLabel", secSettings)
stLbl.Size = UDim2.new(1, 0, 0, 24)
stLbl.BackgroundTransparency = 1
stLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
stLbl.TextSize = 11
stLbl.Font = Enum.Font.GothamBold
stLbl.TextXAlignment = Enum.TextXAlignment.Left
stLbl.Text = "  Цветовая тема интерфейса:"

local function addTheme(name, color, yPos)
    local b = Instance.new("TextButton", secSettings)
    b.Size = UDim2.new(1, -6, 0, 34)
    b.Position = UDim2.new(0, 0, 0, yPos)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(12, 12, 16)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Text = "Тема: " .. name
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseButton1Click:Connect(function()
        cfg.AccentColor = color
        mStroke.Color = color
        tStroke.Color = color
    end)
end

addTheme("Розовый неон", Color3.fromRGB(255, 100, 200), 30)
addTheme("Хакерский зеленый", Color3.fromRGB(0, 255, 128), 69)
addTheme("Кибер-синий", Color3.fromRGB(40, 130, 240), 108)
addTheme("Ярко-оранжевый", Color3.fromRGB(255, 140, 0), 147)


-- ФОНОВЫЙ ЦИКЛ ФИЗИКИ
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

    if cfg.SpinBot then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(60), 0)
    end

    if cfg.Fly then
        hrp.Velocity = Vector3.new(0, 0.5, 0)
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CGrade.RightVector end
        hrp.CFrame = hrp.CFrame + (move * (cfg.FlySpeed / 30))
    end
end)

print("[AERO] MellHack v8.0 Fun & Animations Hub loaded!")

