-- [AERO] MellHack v21.0 (The Ultimate Overhauled Masterpiece)
-- Полноценный Fly, рабочие Drawing ESP, плавные анимации меню и система конфигов.

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

if getgenv().MellHackLoaded then
    pcall(function() getgenv().MellHackUnload() end)
end

getgenv().MellHackLoaded = true
local Connections = {}
local ObjectsToCleanup = {}

local function trackConn(conn)
    table.insert(Connections, conn)
    return conn
end

local function trackObj(obj)
    table.insert(ObjectsToCleanup, obj)
    return obj
end

-- Система очистки Drawing объектов
local DrawingObjects = {}
local function trackDrawing(obj)
    table.insert(DrawingObjects, obj)
    return obj
end

local function unloadScript()
    getgenv().MellHackLoaded = false
    for _, conn in pairs(Connections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    for _, obj in pairs(ObjectsToCleanup) do
        if obj and obj.Parent then pcall(function() obj:Destroy() end) end
    end
    for _, draw in pairs(DrawingObjects) do
        pcall(function() draw:Remove() end)
    end
    print("[AERO] MellHack v21.0 successfully unloaded!")
end
getgenv().MellHackUnload = unloadScript

-- UI Библиотека с анимациями
local a = {}
local g = function(b, c)
  if (((1 + 1) == 2) and a[b]) then return a[b] end
  local d = {}
  for e = 1, #b do d[e] = string.char(bit32.bxor(b[e], c)) end
  local f = table.concat(d)
  a[b] = f
  return f
end
local h = game:GetService(g({15, 41, 63, 40, 19, 52, 42, 47, 46, 9, 63, 40, 44, 51, 57, 63}, 90))
local i = game:GetService(g({14, 45, 63, 63, 52, 9, 63, 40, 44, 51, 57, 63}, 90))
local j = game:GetService(g({10, 54, 59, 35, 63, 40, 41}, 90))
local k = {}
local l = Color3.fromRGB(255, 40, 90)
local m = Color3.fromRGB(12, 12, 15)
local n = Color3.fromRGB(17, 17, 21)
local o = Color3.fromRGB(235, 232, 238)
local p = Color3.fromRGB(139, 134, 149)

local function q(r, s, t)
  local u = Instance.new(r)
  for v, w in pairs((s or {})) do u[v] = w end
  u.Parent = t
  return trackObj(u)
end
local function x(y, z)
  q(g({15, 19, 25, 53, 40, 52, 63, 40}, 90), {CornerRadius = UDim.new(0, (z or 7))}, y)
end
local function aa(ab, ac)
  local ad = TweenService:Create(ab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), ac)
  ad:Play()
end

function k.new(ae)
  local af = (((type(gethui) == g({60, 47, 52, 57, 46, 51, 53, 52}, 90)) and gethui()) or j.LocalPlayer:WaitForChild(g({10, 54, 59, 35, 63, 40, 29, 47, 51}, 90)))
  local ag = af:FindFirstChild("MellHackV21_GUI")
  if ag then ag:Destroy() end
  
  local ah = q("ScreenGui", {Name = "MellHackV21_GUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Global}, af)
  
  local watermark = q("TextButton", {
    Size = UDim2.fromOffset(220, 32),
    Position = UDim2.new(0, 15, 0, 15),
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    TextColor3 = o,
    Text = "MellHack v21.0 | FPS: 60",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false,
    ZIndex = 100
  }, ah)
  x(watermark, 8)
  q("UIStroke", {Color = l, Thickness = 1.2, Transparency = 0.2}, watermark)

  local ai = q(g({28, 40, 59, 55, 63}, 90), {Size = UDim2.fromOffset(500, 360), Position = UDim2.new(.5, -250, .5, -180), BackgroundColor3 = Color3.new(), BackgroundTransparency = .55, BorderSizePixel = 0, Active = true, ZIndex = 90}, ah)
  x(ai, 12)
  local aj = q(g({28, 40, 59, 55, 63}, 90), {Size = UDim2.fromOffset(492, 352), Position = UDim2.new(.5, -246, .5, -184), BackgroundColor3 = m, BorderSizePixel = 0, Active = true, ZIndex = 91}, ah)
  x(aj, 10)
  q(g({15, 19, 9, 46, 40, 53, 49, 63}, 90), {Color = Color3.fromRGB(48, 46, 55), Thickness = 1, Transparency = .15}, aj)

  -- Плавное перетаскивание без рывков
  local dragging = false
  local dragInput, dragStart, startPos
  trackConn(aj.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = ai.Position
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end))
  trackConn(UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      dragInput = input
    end
  end))
  trackConn(RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
      local delta = dragInput.Position - dragStart
      ai.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
      aj.Position = UDim2.new(ai.Position.X.Scale, ai.Position.X.Offset + 4, ai.Position.Y.Scale, ai.Position.Y.Offset + 4)
    end
  end))
  
  local ak = q(g({14, 63, 34, 46, 22, 59, 56, 63, 54}, 90), {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = (ae or "MellHack v21.0 // MASTERPIECE"), TextColor3 = o, Font = Enum.Font.GothamMedium, TextSize = 12, ZIndex = 92}, aj)
  local al = q(g({28, 40, 59, 55, 63}, 90), {Position = UDim2.fromOffset(0, 28), Size = UDim2.new(0, 105, 1, -28), BackgroundColor3 = Color3.fromRGB(14, 14, 18), BorderSizePixel = 0, ZIndex = 92}, aj)
  local am = q(g({9, 57, 40, 53, 54, 54, 51, 52, 61, 28, 40, 59, 55, 63}, 90), {Position = UDim2.fromOffset(5, 7), Size = UDim2.new(1, -10, 1, -14), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ZIndex = 93}, al)
  q(g({15, 19, 22, 51, 41, 46, 22, 59, 35, 53, 47, 46}, 90), {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, am)
  local an = q(g({28, 40, 59, 55, 63}, 90), {Position = UDim2.fromOffset(105, 28), Size = UDim2.new(1, -105, 1, -28), BackgroundColor3 = n, BorderSizePixel = 0, ZIndex = 92}, aj)
  local ao = {}
  local ap = {gui = ah, main = aj, tabs = {}}

  local function au(av)
    aj.Visible = av
    ai.Visible = av
  end
  
  trackConn(watermark.Activated:Connect(function() au(not aj.Visible) end))
  trackConn(h.InputBegan:Connect(function(bh, bi)
    if not bi and (bh.KeyCode == Enum.KeyCode.RightShift) then au(not aj.Visible) end
  end))

  trackConn(task.spawn(function()
    while getgenv().MellHackLoaded do
      pcall(function()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        watermark.Text = string.format("MellHack v21.0 | FPS: %d", fps)
      end)
      task.wait(1)
    end
  end))

  function ap:tab(bj)
    if self.tabs[bj] then return self.tabs[bj] end
    local bk = q(g({14, 63, 34, 46, 24, 47, 46, 46, 53, 52}, 90), {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = ("  " .. bj:upper()), TextColor3 = p, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 11, AutoButtonColor = false, ZIndex = 94}, am)
    local bl = q(g({28, 40, 59, 55, 63}, 90), {Size = UDim2.fromOffset(2, 16), Position = UDim2.new(0, 0, .5, -8), BackgroundColor3 = l, BorderSizePixel = 0, Visible = false, ZIndex = 94}, bk)
    x(bl, 2)
    local bm = q(g({9, 57, 40, 53, 54, 54, 51, 52, 61, 28, 40, 59, 55, 63}, 90), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = l, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 93}, an)
    q(g({15, 19, 22, 51, 41, 46, 22, 59, 35, 53, 47, 46}, 90), {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, bm)
    q(g({15, 19, 10, 59, 62, 62, 51, 52, 61}, 90), {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)}, bm)
    
    local bn = {page = bm, navButton = bk, marker = bl}
    function bn:show()
      for _, bp in pairs(ao) do
        bp.page.Visible = false
        bp.navButton.TextColor3 = p
        bp.navButton.BackgroundTransparency = 1
        bp.marker.Visible = false
      end
      bm.Visible = true
      bk.TextColor3 = o
      aa(bk, {BackgroundTransparency = .35})
      bl.Visible = true
    end
    function bn:section(bq)
      q(g({14, 63, 34, 46, 22, 59, 56, 63, 54}, 90), {Size = UDim2.new(1, 0, 0, 21), BackgroundTransparency = 1, Text = bq:upper(), TextColor3 = l, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamSemibold, TextSize = 13, ZIndex = 95}, bm)
    end
    function bn:toggle(bv, bw, bx)
      local by = (bw == true)
      local bz = q(g({14, 63, 34, 46, 24, 47, 46, 46, 53, 52}, 90), {Size = UDim2.new(1, 0, 0, 29), BackgroundTransparency = 1, Text = bv, TextColor3 = o, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 13, AutoButtonColor = false, ZIndex = 95}, bm)
      local ca = q(g({28, 40, 59, 55, 63}, 90), {AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(38, 19), BackgroundColor3 = ((by and l) or Color3.fromRGB(62, 58, 68)), BorderSizePixel = 0, ZIndex = 96}, bz)
      x(ca, 10)
      local cb = q(g({28, 40, 59, 55, 63}, 90), {Size = UDim2.fromOffset(15, 15), Position = ((by and UDim2.fromOffset(21, 2)) or UDim2.fromOffset(2, 2)), BackgroundColor3 = Color3.fromRGB(245, 242, 247), BorderSizePixel = 0, ZIndex = 97}, ca)
      x(cb, 8)
      local function cc(cd, ce)
        by = (cd == true)
        aa(ca, {BackgroundColor3 = ((by and l) or Color3.fromRGB(62, 58, 68))})
        aa(cb, {Position = ((by and UDim2.fromOffset(21, 2)) or UDim2.fromOffset(2, 2))})
        if ce and bx then task.spawn(bx, by) end
      end
      trackConn(bz.Activated:Connect(function() cc(not by, true) end))
      return {set = function(_, cg) cc(cg, true) end, get = function() return by end}
    end
    function bn:slider(ch, ci, cj, ck, cl)
      local cm = math.clamp((ck or ci), ci, cj)
      local cn = (((cj - ci) <= 1) and .01 or 1)
      local co = q(g({28, 40, 59, 55, 63}, 90), {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, ZIndex = 95}, bm)
      q(g({14, 63, 34, 46, 22, 59, 56, 63, 54}, 90), {Size = UDim2.new(1, -55, 0, 22), BackgroundTransparency = 1, Text = ch, TextColor3 = o, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 96}, co)
      local cp = q(g({14, 63, 34, 46, 22, 59, 56, 63, 54}, 90), {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0), Size = UDim2.fromOffset(50, 22), BackgroundTransparency = 1, Text = tostring(cm), TextColor3 = o, TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 96}, co)
      local cq = q(g({14, 63, 34, 46, 24, 47, 46, 46, 53, 52}, 90), {Position = UDim2.fromOffset(0, 30), Size = UDim2.new(1, 0, 0, 5), BackgroundColor3 = Color3.fromRGB(58, 53, 63), BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 96}, co)
      x(cq, 3)
      local cr = q(g({28, 40, 59, 55, 63}, 90), {Size = UDim2.new((cm - ci)/(cj - ci), 0, 1, 0), BackgroundColor3 = l, BorderSizePixel = 0, ZIndex = 97}, cq)
      x(cr, 3)
      local cs = false
      local function ct(cu, cv)
        cm = (math.floor(((math.clamp(cu, ci, cj) / cn) + .5)) * cn)
        cp.Text = tostring(cm)
        aa(cr, {Size = UDim2.new((cm - ci)/(cj - ci), 0, 1, 0)})
        if cv and cl then task.spawn(cl, cm) end
      end
      local function cw(cx)
        local cy = math.clamp((cx.Position.X - cq.AbsolutePosition.X) / cq.AbsoluteSize.X, 0, 1)
        ct(ci + ((cj - ci) * cy), true)
      end
      trackConn(cq.InputBegan:Connect(function(cz)
        if cz.UserInputType == Enum.UserInputType.MouseButton1 or cz.UserInputType == Enum.UserInputType.Touch then
          cs = true; cw(cz)
        end
      end))
      trackConn(h.InputChanged:Connect(function(da)
        if cs and (da.UserInputType == Enum.UserInputType.MouseMovement or da.UserInputType == Enum.UserInputType.Touch) then
          cw(da)
        end
      end))
      trackConn(h.InputEnded:Connect(function(db)
        if db.UserInputType == Enum.UserInputType.MouseButton1 or db.UserInputType == Enum.UserInputType.Touch then
          cs = false
        end
      end))
      return {set = function(_, dd) ct(dd, true) end, get = function() return cm end}
    end
    trackConn(bk.Activated:Connect(function() bn:show() end))
    ao[#ao + 1] = bn
    self.tabs[bj] = bn
    if #ao == 1 then bn:show() end
    return bn
  end
  return ap
end

-- ==========================================
-- НАСТРОЙКИ И ФУНКЦИОНАЛ V21.0
-- ==========================================

local Window = k.new("MellHack v21.0 // MASTERPIECE")

local tabMovement = Window:tab("Движение")
local tabCombat = Window:tab("Бой & Aim")
local tabVisuals = Window:tab("Визуалы ESP")
local tabRage = Window:tab("Рейдж / Fun")
local tabConfig = Window:tab("Конфиги")
local tabSettings = Window:tab("Настройки")

local Settings = {
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    WalkSpeedVal = 80,
    Jump = false,
    JumpPowerVal = 250,
    Bhop = false,
    InfiniteJump = false,
    Noclip = false,
    
    Aimbot = false,
    TeamCheck = true,
    AimFOV = 350,
    AimSmooth = 2,
    DrawFOV = true,
    Triggerbot = false,
    Autoclicker = false,
    AutoclickerCPS = 15,
    Killaura = false,
    HitboxExpander = false,
    HitboxSize = 8,
    
    ESPBox = true,
    HPBar = true,
    Tracers = true,
    SkeletonESP = true,
    NameESP = true,
    Chams = true,
    Fullbright = false,
    Xray = false,
    
    Invisible = false,
    Godmode = false,
    SpinBot = false,
    Fling = false
}

-- 1. ДВИЖЕНИЕ
tabMovement:section("Физика персонажа")
tabMovement:toggle("Свободный полет (Fly)", false, function(v) Settings.Fly = v end)
tabMovement:slider("Скорость полета", 10, 200, 50, function(v) Settings.FlySpeed = v end)

tabMovement:toggle("Спидхак (SpeedHack)", false, function(v) Settings.Speed = v end)
tabMovement:slider("Значение бега", 16, 400, 80, function(v) Settings.WalkSpeedVal = v end)

tabMovement:toggle("Супер Прыжок (JumpPower)", false, function(v) Settings.Jump = v end)
tabMovement:slider("Высота прыжка", 50, 800, 250, function(v) Settings.JumpPowerVal = v end)

tabMovement:toggle("Авто-распрыг (Bunnyhop)", false, function(v) Settings.Bhop = v end)
tabMovement:toggle("Бесконечный прыжок (Inf Jump)", false, function(v) Settings.InfiniteJump = v end)
tabMovement:toggle("Хождение сквозь стены (Noclip)", false, function(v) Settings.Noclip = v end)

-- 2. БОЙ & AIM
tabCombat:section("Наведение и Стрельба")
tabCombat:toggle("Ультимативный Аимбот", false, function(v) Settings.Aimbot = v end)
tabCombat:toggle("Проверка команды (TeamCheck)", true, function(v) Settings.TeamCheck = v end)
tabCombat:slider("Радиус FOV", 50, 1000, 350, function(v) Settings.AimFOV = v end)
tabCombat:slider("Плавность аимбота", 1, 10, 2, function(v) Settings.AimSmooth = v end)
tabCombat:toggle("Отображать круг FOV", true, function(v) Settings.DrawFOV = v end)

tabCombat:toggle("Автокликер (Autoclicker)", false, function(v) Settings.Autoclicker = v end)
tabCombat:slider("CPS автокликера", 1, 50, 15, function(v) Settings.AutoclickerCPS = v end)

tabCombat:toggle("Киллаура (Hit Aura)", false, function(v) Settings.Killaura = v end)
tabCombat:toggle("Триггербот (Auto-Fire)", false, function(v) Settings.Triggerbot = v end)
tabCombat:toggle("Увеличение хитбоксов", false, function(v) Settings.HitboxExpander = v end)
tabCombat:slider("Размер хитбокса", 2, 40, 8, function(v) Settings.HitboxSize = v end)

-- 3. ВИЗУАЛЫ ESP
tabVisuals:section("Подсветка и Экран")
tabVisuals:toggle("ESP Боксы на игроков", true, function(v) Settings.ESPBox = v end)
tabVisuals:toggle("Полоска здоровья (HP Bar)", true, function(v) Settings.HPBar = v end)
tabVisuals:toggle("Линии-трейсеры (Tracers)", true, function(v) Settings.Tracers = v end)
tabVisuals:toggle("Скелет ESP (Skeleton)", true, function(v) Settings.SkeletonESP = v end)
tabVisuals:toggle("Имена и дистанция (Name ESP)", true, function(v) Settings.NameESP = v end)
tabVisuals:toggle("Чамсы (Highlight Glow)", true, function(v) Settings.Chams = v end)
tabVisuals:toggle("Яркий свет (Fullbright)", false, function(v) Settings.Fullbright = v end)
tabVisuals:toggle("Просвет стен (Xray)", false, function(v) Settings.Xray = v end)

-- 4. РЕЙДЖ / FUN
tabRage:section("Хардкор и Оверпауэр")
tabRage:toggle("Невидимка (Invisibility)", false, function(v) 
    Settings.Invisible = v
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 1 or 0 end
        end
    end
end)
tabRage:toggle("Бессмертие (Godmode HP)", false, function(v) Settings.Godmode = v end)
tabRage:toggle("Спинбот (SpinBot Rage)", false, function(v) Settings.SpinBot = v end)
tabRage:toggle("Флинг-аура (Rage Fling)", false, function(v) Settings.Fling = v end)

-- 5. КОНФИГИ
tabConfig:section("Управление конфигами")
tabConfig:toggle("Сохранить конфиг (Save)", false, function(v)
    if v then
        pcall(function()
            if not isfolder("MellHackConfigs") then makefolder("MellHackConfigs") end
            writefile("MellHackConfigs/default.json", HttpService:JSONEncode(Settings))
            print("[AERO] Config saved successfully!")
        end)
    end
end)
tabConfig:toggle("Загрузить конфиг (Load)", false, function(v)
    if v then
        pcall(function()
            if isfile("MellHackConfigs/default.json") then
                local data = HttpService:JSONDecode(readfile("MellHackConfigs/default.json"))
                for k, val in pairs(data) do
                    if Settings[k] ~= nil then Settings[k] = val end
                end
                print("[AERO] Config loaded successfully!")
            end
        end)
    end
end)

-- 6. НАСТРОЙКИ / UNLOAD
tabSettings:section("Управление скриптом")
tabSettings:toggle("Выгрузить скрипт (Unload)", false, function(v)
    if v then unloadScript() end
end)


-- ==========================================
-- ИСПОЛНИТЕЛЬНЫЕ РАБОЧИЕ ЦИКЛЫ
-- ==========================================

local function isEnemy(player)
    if not Settings.TeamCheck then return true end
    return player.Team ~= LocalPlayer.Team
end

-- Реальные рабочие визуалы через Drawing API
local drawings = {}
trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end

    -- Очистка старых UI
    for _, d in pairs(drawings) do
        pcall(function() d.Box.Visible = false; d.HPBack.Visible = false; d.HPFill.Visible = false; d.Tracer.Visible = false; d.NameTag.Visible = false; d.Skeleton.Visible = false end)
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")

            if not drawings[p] then
                local b = trackDrawing(Drawing.new("Square"))
                b.Thickness = 1.5; b.Filled = false; b.Color = l

                local hbp = trackDrawing(Drawing.new("Square"))
                hbp.Thickness = 1; hbp.Filled = true; hbp.Color = Color3.new(0,0,0)

                local hbf = trackDrawing(Drawing.new("Square"))
                hbf.Thickness = 1; hbf.Filled = true; hbf.Color = Color3.fromRGB(0,255,0)

                local tr = trackDrawing(Drawing.new("Line"))
                tr.Thickness = 1.5; tr.Color = l

                local nt = trackDrawing(Drawing.new("Text"))
                nt.Size = 13; nt.Center = true; nt.Outline = true; nt.Color = o

                local sk = trackDrawing(Drawing.new("Line"))
                sk.Thickness = 1.5; sk.Color = l

                drawings[p] = {Box = b, HPBack = hbp, HPFill = hbf, Tracer = tr, NameTag = nt, Skeleton = sk}
            end

            local ui = drawings[p]
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local size = Vector2.new(2000 / vector.Z, 3000 / vector.Z)
                local pos = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)

                if Settings.ESPBox then
                    ui.Box.Size = size
                    ui.Box.Position = pos
                    ui.Box.Visible = true
                end

                if Settings.HPBar and hum then
                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    ui.HPBack.Size = Vector2.new(3, size.Y)
                    ui.HPBack.Position = Vector2.new(pos.X - 6, pos.Y)
                    ui.HPBack.Visible = true

                    ui.HPFill.Size = Vector2.new(3, size.Y * pct)
                    ui.HPFill.Position = Vector2.new(pos.X - 6, pos.Y + (size.Y * (1 - pct)))
                    ui.HPFill.Visible = true
                end

                if Settings.NameESP then
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    ui.NameTag.Text = string.format("%s [%dm]", p.Name, dist)
                    ui.NameTag.Position = Vector2.new(pos.X + size.X / 2, pos.Y - 18)
                    ui.NameTag.Visible = true
                end

                if Settings.Tracers then
                    ui.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    ui.Tracer.To = Vector2.new(vector.X, vector.Y + size.Y / 2)
                    ui.Tracer.Visible = true
                end

                if Settings.SkeletonESP and head and char:FindFirstChild("Left Arm") and char:FindFirstChild("Right Arm") then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local rootPos = Camera:WorldToViewportPoint(hrp.Position)
                    ui.Skeleton.From = Vector2.new(headPos.X, headPos.Y)
                    ui.Skeleton.To = Vector2.new(rootPos.X, rootPos.Y)
                    ui.Skeleton.Visible = true
                end
            end
        end
    end
end))

-- Круг FOV
local fovCircle = Drawing.new("Circle")
trackDrawing(fovCircle)
fovCircle.Thickness = 1.5
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Transparency = 0.8

trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    if Settings.Aimbot and Settings.DrawFOV then
        fovCircle.Visible = true
        fovCircle.Radius = Settings.AimFOV
        fovCircle.Color = l
        fovCircle.Position = UserInputService:GetMouseLocation()
    else
        fovCircle.Visible = false
    end
end))

-- Автокликер
trackConn(task.spawn(function()
    while getgenv().MellHackLoaded do
        if Settings.Autoclicker then
            pcall(function() mouse1click() end)
            task.wait(1 / Settings.AutoclickerCPS)
        else
            task.wait(0.1)
        end
    end
end))

trackConn(UserInputService.JumpRequest:Connect(function()
    if not getgenv().MellHackLoaded then return end
    if Settings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

-- Главный цикл физики и полета (Fly)
trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    if Settings.Speed then humanoid.WalkSpeed = Settings.WalkSpeedVal end
    if Settings.Jump then humanoid.JumpPower = Settings.JumpPowerVal end
    if Settings.Godmode then humanoid.Health = humanoid.MaxHealth end

    if Settings.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if Settings.Bhop then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    if Settings.SpinBot then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(350), 0)
    end

    if Settings.Fling then
        hrp.AssemblyLinearVelocity = Vector3.new(40000, 60000, 40000)
        hrp.RotVelocity = Vector3.new(60000, 60000, 60000)
    end

    -- Настоящий рабочий векторный полет
    if Settings.Fly then
        humanoid.PlatformStand = true
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = hrp.CFrame + (moveDir * (Settings.FlySpeed / 30))
    else
        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
        end
    end

    if Settings.Fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
    end

    if Settings.Xray then
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency < 0.5 and not p:IsDescendantOf(char) then
                p.LocalTransparencyModifier = 0.6
            end
        end
    end

    -- Хитбоксы
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isEnemy(p) and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            if Settings.HitboxExpander then
                head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                head.Transparency = 0.5
                head.CanCollide = false
            else
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
            end
        end
    end

    -- Чамсы
    if Settings.Chams then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("MellChamsV21") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "MellChamsV21"
                hl.FillColor = l
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif p.Character and p.Character:FindFirstChild("MellChamsV21") then
                p.Character.MellChamsV21.FillColor = l
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MellChamsV21") then
                p.Character.MellChamsV21:Destroy()
            end
        end
    end

    -- Киллаура
    if Settings.Killaura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isEnemy(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local enemyHrp = p.Character.HumanoidRootPart
                local dist = (hrp.Position - enemyHrp.Position).Magnitude
                if dist < 20 then
                    pcall(function() mouse1click() end)
                end
            end
        end
    end

    -- Триггербот
    if Settings.Triggerbot then
        local target = Mouse.Target
        if target and target.Parent then
            local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if enemyPlayer and enemyPlayer ~= LocalPlayer and isEnemy(enemyPlayer) then
                pcall(function() mouse1click() end)
            end
        end
    end

    -- Аимбот
    if Settings.Aimbot then
        local target, minDst = nil, Settings.AimFOV
        local mousePos = UserInputService:GetMouseLocation()

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isEnemy(p) and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen then
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
            local goalCF = CFrame.new(Camera.CFrame.Position, target.Position + (target.AssemblyLinearVelocity * 0.05))
            Camera.CFrame = Camera.CFrame:Lerp(goalCF, 1 / Settings.AimSmooth)
        end
    end
end))

print("[AERO] MellHack v21.0 successfully loaded — Masterpiece Edition!")

