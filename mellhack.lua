local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
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

local DrawingObjects = {}
local function trackDrawing(obj)
    table.insert(DrawingObjects, obj)
    return obj
end

local function unloadScript()
    getgenv().MellHackLoaded = false
    for _, conn in pairs(Connections) do
        if conn and conn.Connected then pcall(function() conn:Disconnect() end) end
    end
    for _, obj in pairs(ObjectsToCleanup) do
        if obj and obj.Parent then pcall(function() obj:Destroy() end) end
    end
    for _, draw in pairs(DrawingObjects) do
        pcall(function() draw:Remove() end)
    end
    pcall(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
            LocalPlayer.Character.Humanoid.PlatformStand = false
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        local gui = CoreGui:FindFirstChild("MellHack_GUI")
        if gui then gui:Destroy() end
    end)
end
getgenv().MellHackUnload = unloadScript

local AccentColor = Color3.fromRGB(255, 40, 90)
local MenuTransparency = 0.15
local m = Color3.fromRGB(10, 10, 14)
local n = Color3.fromRGB(16, 16, 22)
local o = Color3.fromRGB(240, 238, 245)
local p = Color3.fromRGB(140, 135, 155)

local function q(r, s, t)
  local u = Instance.new(r)
  for v, w in pairs((s or {})) do u[v] = w end
  u.Parent = t
  return trackObj(u)
end
local function x(y, z)
  q("UICorner", {CornerRadius = UDim.new(0, (z or 8))}, y)
end
local function aa(ab, ac)
  local ad = TweenService:Create(ab, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), ac)
  ad:Play()
end

local k = {}
function k.new(ae)
  local af = ((type(gethui) == "function" and gethui()) or LocalPlayer:WaitForChild("PlayerGui"))
  local ag = af:FindFirstChild("MellHack_GUI")
  if ag then ag:Destroy() end
  
  local ah = q("ScreenGui", {Name = "MellHack_GUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Global}, af)
  
  local watermark = q("TextButton", {
    Size = UDim2.fromOffset(300, 34),
    Position = UDim2.new(0.5, -150, 0, 15),
    BackgroundColor3 = Color3.fromRGB(12, 12, 18),
    BackgroundTransparency = 0.1,
    TextColor3 = o,
    Text = "MellHack | by @ruzoxu | FPS: 60",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    AutoButtonColor = false,
    ZIndex = 100
  }, ah)
  x(watermark, 10)
  local wmStroke = q("UIStroke", {Color = AccentColor, Thickness = 1.4, Transparency = 0.15}, watermark)

  local ai = q("Frame", {Size = UDim2.fromOffset(580, 420), Position = UDim2.new(.5, -290, .5, -210), BackgroundColor3 = Color3.new(), BackgroundTransparency = .5, BorderSizePixel = 0, Active = true, ZIndex = 90}, ah)
  x(ai, 14)
  local aj = q("Frame", {Size = UDim2.fromOffset(572, 412), Position = UDim2.new(.5, -286, .5, -206), BackgroundColor3 = m, BackgroundTransparency = MenuTransparency, BorderSizePixel = 0, Active = true, ZIndex = 91}, ah)
  x(aj, 12)
  local mainStroke = q("UIStroke", {Color = AccentColor, Thickness = 1.2, Transparency = .2}, aj)

  local dragging, dragInput, dragStart, startPos
  trackConn(aj.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = ai.Position
    end
  end))
  trackConn(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = false
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

  q("TextLabel", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
    Text = "  " .. (ae or "MellHack // @ruzoxu"),
    TextColor3 = o,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 95
  }, aj)

  local al = q("Frame", {Position = UDim2.fromOffset(0, 32), Size = UDim2.new(0, 135, 1, -32), BackgroundColor3 = Color3.fromRGB(12, 12, 16), BackgroundTransparency = MenuTransparency, BorderSizePixel = 0, ZIndex = 92}, aj)
  local am = q("ScrollingFrame", {Position = UDim2.fromOffset(6, 8), Size = UDim2.new(1, -12, 1, -16), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ZIndex = 93}, al)
  q("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, am)
  local an = q("Frame", {Position = UDim2.fromOffset(135, 32), Size = UDim2.new(1, -135, 1, -32), BackgroundColor3 = n, BackgroundTransparency = MenuTransparency, BorderSizePixel = 0, ZIndex = 92}, aj)
  
  local tabsList = {}
  local function updateTheme()
    wmStroke.Color = AccentColor
    mainStroke.Color = AccentColor
    aj.BackgroundTransparency = MenuTransparency
    al.BackgroundTransparency = MenuTransparency
    an.BackgroundTransparency = MenuTransparency
    for _, tabData in pairs(tabsList) do
      tabData.marker.BackgroundColor3 = AccentColor
      tabData.scrollBar.ScrollBarImageColor3 = AccentColor
      if tabData.isShown then
        tabData.navButton.TextColor3 = o
        aa(tabData.navButton, {BackgroundTransparency = .82})
      else
        tabData.navButton.TextColor3 = p
        aa(tabData.navButton, {BackgroundTransparency = 1})
      end
    end
  end
  getgenv().MellUpdateTheme = updateTheme

  local ao = {}
  local ap = {gui = ah, main = aj, tabs = {}}

  local menuVisible = true
  local function toggleMenu()
    menuVisible = not menuVisible
    aj.Visible = menuVisible
    ai.Visible = menuVisible
  end

  trackConn(watermark.Activated:Connect(function() toggleMenu() end))
  trackConn(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then toggleMenu() end
  end))

  function ap:tab(bj)
    if self.tabs[bj] then return self.tabs[bj] end
    local bk = q("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = ("   " .. bj:upper()), TextColor3 = p, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 11, AutoButtonColor = false, ZIndex = 94}, am)
    x(bk, 6)
    local bl = q("Frame", {Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 0, .5, -8), BackgroundColor3 = AccentColor, BorderSizePixel = 0, Visible = false, ZIndex = 94}, bk)
    x(bl, 2)
    local bm = q("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = AccentColor, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 93}, an)
    q("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, bm)
    q("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)}, bm)
    
    local bn = {page = bm, navButton = bk, marker = bl, scrollBar = bm, isShown = false}
    table.insert(tabsList, bn)

    function bn:show()
      for _, bp in pairs(ao) do
        bp.page.Visible = false
        bp.navButton.TextColor3 = p
        aa(bp.navButton, {BackgroundTransparency = 1})
        bp.marker.Visible = false
        bp.isShown = false
      end
      bm.Visible = true
      bk.TextColor3 = o
      aa(bk, {BackgroundTransparency = .82})
      bl.Visible = true
      bn.isShown = true
    end
    function bn:section(bq)
      q("TextLabel", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = bq:upper(), TextColor3 = AccentColor, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 95}, bm)
    end
    function bn:toggle(bv, bw, bx)
      local by = (bw == true)
      local bz = q("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = bv, TextColor3 = o, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 13, AutoButtonColor = false, ZIndex = 95}, bm)
      local ca = q("Frame", {AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(40, 20), BackgroundColor3 = ((by and AccentColor) or Color3.fromRGB(55, 52, 62)), BorderSizePixel = 0, ZIndex = 96}, bz)
      x(ca, 10)
      local cb = q("Frame", {Size = UDim2.fromOffset(16, 16), Position = ((by and UDim2.fromOffset(22, 2)) or UDim2.fromOffset(2, 2)), BackgroundColor3 = Color3.fromRGB(245, 242, 250), BorderSizePixel = 0, ZIndex = 97}, ca)
      x(cb, 8)
      local function cc(cd, ce)
        by = (cd == true)
        aa(ca, {BackgroundColor3 = ((by and AccentColor) or Color3.fromRGB(55, 52, 62))})
        aa(cb, {Position = ((by and UDim2.fromOffset(22, 2)) or UDim2.fromOffset(2, 2))})
        if ce and bx then task.spawn(bx, by) end
      end
      trackConn(bz.Activated:Connect(function() cc(not by, true) end))
      return {set = function(_, cg) cc(cg, true) end, get = function() return by end}
    end
    function bn:slider(ch, ci, cj, ck, cl)
      local cm = math.clamp((ck or ci), ci, cj)
      local cn = (((cj - ci) <= 1) and .01 or 1)
      local co = q("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, ZIndex = 95}, bm)
      q("TextLabel", {Size = UDim2.new(1, -55, 0, 22), BackgroundTransparency = 1, Text = ch, TextColor3 = o, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 96}, co)
      local cp = q("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0), Size = UDim2.fromOffset(50, 22), BackgroundTransparency = 1, Text = tostring(cm), TextColor3 = o, TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 96}, co)
      local cq = q("TextButton", {Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = Color3.fromRGB(50, 47, 58), BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 96}, co)
      x(cq, 3)
      local cr = q("Frame", {Size = UDim2.new((cm - ci)/(cj - ci), 0, 1, 0), BackgroundColor3 = AccentColor, BorderSizePixel = 0, ZIndex = 97}, cq)
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
      trackConn(UserInputService.InputChanged:Connect(function(da)
        if cs and (da.UserInputType == Enum.UserInputType.MouseMovement or da.UserInputType == Enum.UserInputType.Touch) then
          cw(da)
        end
      end))
      trackConn(UserInputService.InputEnded:Connect(function(db)
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

pcall(function()
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do
        v:Disable()
    end
    if setfflag then
        setfflag("HumanoidParallelization", "False")
    end
end)

local Window = k.new("MellHack // @ruzoxu")

local tabMovement = Window:tab("Movement / Движение")
local tabCombat = Window:tab("Combat / Бой")
local tabVisuals = Window:tab("Visuals / Визуалы")
local tabShaders = Window:tab("Shaders / Мир")
local tabRage = Window:tab("Rage & Fun / Рейдж")
local tabBinds = Window:tab("Keybinds / Бинды")
local tabSettings = Window:tab("Settings / Настройки")

local Settings = {
    Fly = false,
    FlySpeed = 70,
    Speed = false,
    WalkSpeedVal = 80,
    Jump = false,
    JumpPowerVal = 250,
    Bhop = false,
    InfiniteJump = false,
    Noclip = false,
    
    Aimbot = false,
    CamLock = false,
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
    ColorBox = {255, 40, 90},

    Fullbright = false,
    Xray = false,
    SkyColor = {135, 206, 235},
    
    Invisible = false,
    Godmode = false,
    SpinBot = false,
    Earthquake = false,
    ClickTeleport = false,
    Fling = false,
    ChatFlood = false,
    FloodText = "MellHack by @ruzoxu",
    FloodDelay = 1,
    
    ColorAccent = {255, 40, 90},
    MenuAlpha = 15
}

local flyActive = false
local flyConn = nil
local function toggleFly(state)
    flyActive = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hrp = char.HumanoidRootPart
    local hum = char.Humanoid

    if state then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.Name = "MellFlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.Name = "MellFlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        flyConn = trackConn(RunService.RenderStepped:Connect(function()
            if not flyActive or not char or not hrp then return end
            local camCF = Camera.CFrame
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            bv.Velocity = moveDir * Settings.FlySpeed
            bg.CFrame = camCF
        end))
    else
        hum.PlatformStand = false
        if flyConn then flyConn:Disconnect() end
        if hrp:FindFirstChild("MellFlyVelocity") then hrp.MellFlyVelocity:Destroy() end
        if hrp:FindFirstChild("MellFlyGyro") then hrp.MellFlyGyro:Destroy() end
    end
end

trackConn(Mouse.Button1Down:Connect(function()
    if Settings.ClickTeleport and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end))

trackConn(task.spawn(function()
    while getgenv().MellHackLoaded do
        if Settings.ChatFlood and Settings.FloodText ~= "" then
            pcall(function()
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    local channel = TextChatService.TextChannels.RBXGeneral
                    if channel then channel:SendAsync(Settings.FloodText) end
                else
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.FloodText, "All")
                end
            end)
        end
        task.wait(Settings.FloodDelay)
    end
end))

tabMovement:section("Character Physics / Физика персонажа")
tabMovement:toggle("Fly / Полет", false, function(v) toggleFly(v) end)
tabMovement:slider("Fly Speed / Скорость полета", 10, 300, 70, function(v) Settings.FlySpeed = v end)

tabMovement:toggle("SpeedHack / Спидхак", false, function(v) 
    Settings.Speed = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
tabMovement:slider("WalkSpeed / Скорость бега", 16, 400, 80, function(v) Settings.WalkSpeedVal = v end)

tabMovement:toggle("JumpPower / Супер Прыжок", false, function(v) 
    Settings.Jump = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)
tabMovement:slider("Jump Height / Высота прыжка", 50, 800, 250, function(v) Settings.JumpPowerVal = v end)

tabMovement:toggle("Auto-Bhop / Авто-баннихоп", false, function(v) Settings.Bhop = v end)
tabMovement:toggle("Infinite Jump / Бесконечный прыжок", false, function(v) Settings.InfiniteJump = v end)
tabMovement:toggle("Noclip / Хождение сквозь стены", false, function(v) 
    Settings.Noclip = v
    if not v and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)

tabCombat:section("Aim & Combat / Наведение и Стрельба")
tabCombat:toggle("Aimbot / Ультимативный Аимбот", false, function(v) Settings.Aimbot = v end)
tabCombat:toggle("CamLock / Мягкое удержание", false, function(v) Settings.CamLock = v end)
tabCombat:toggle("TeamCheck / Проверка команды", true, function(v) Settings.TeamCheck = v end)
tabCombat:slider("Aim FOV / Радиус обзора", 50, 1000, 350, function(v) Settings.AimFOV = v end)
tabCombat:slider("Aim Smooth / Плавность аимбота", 1, 10, 2, function(v) Settings.AimSmooth = v end)
tabCombat:toggle("Draw FOV / Отображать круг FOV", true, function(v) Settings.DrawFOV = v end)

tabCombat:toggle("Autoclicker / Автокликер", false, function(v) Settings.Autoclicker = v end)
tabCombat:slider("CPS / Скорость кликов", 1, 50, 15, function(v) Settings.AutoclickerCPS = v end)

tabCombat:toggle("Killaura / Киллаура", false, function(v) Settings.Killaura = v end)
tabCombat:toggle("Triggerbot / Триггербот", false, function(v) Settings.Triggerbot = v end)
tabCombat:toggle("Hitbox Expander / Увеличение хитбоксов", false, function(v) 
    Settings.HitboxExpander = v
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(2, 1, 1)
                p.Character.Head.Transparency = 0
            end
        end
    end
end)
tabCombat:slider("Hitbox Size / Размер хитбокса", 2, 40, 8, function(v) Settings.HitboxSize = v end)

tabVisuals:section("ESP & Visuals / Подсветка и Экран")
tabVisuals:toggle("ESP Boxes / Боксы на игроков", true, function(v) Settings.ESPBox = v end)
tabVisuals:toggle("HP Bar / Полоска здоровья", true, function(v) Settings.HPBar = v end)
tabVisuals:toggle("Tracers / Линии-трейсеры", true, function(v) Settings.Tracers = v end)
tabVisuals:toggle("Skeleton ESP / Скелет игроков", true, function(v) Settings.SkeletonESP = v end)
tabVisuals:toggle("Name ESP / Имена и дистанция", true, function(v) Settings.NameESP = v end)
tabVisuals:toggle("Chams / Чамсы свечение", false, function(v) 
    Settings.Chams = v
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MellChams") then
                p.Character.MellChams:Destroy()
            end
        end
    end
end)

tabVisuals:section("Colors / Настройка цветов")
tabVisuals:slider("Box Color [R] / Красный", 0, 255, 255, function(v) Settings.ColorBox[1] = v end)
tabVisuals:slider("Box Color [G] / Зеленый", 0, 255, 40, function(v) Settings.ColorBox[2] = v end)
tabVisuals:slider("Box Color [B] / Синий", 0, 255, 90, function(v) Settings.ColorBox[3] = v end)

tabShaders:section("Lighting & Sky / Освещение и Небо")
tabShaders:toggle("Fullbright / Яркий свет", false, function(v) 
    Settings.Fullbright = v
    if not v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
    end
end)
tabShaders:toggle("X-Ray / Просвет стен", false, function(v) 
    Settings.Xray = v
    if not v then
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
        end
    end
end)
tabShaders:section("Sky Color / Цвет неба")
tabShaders:slider("Sky Color [R] / Красный", 0, 255, 135, function(v) 
    Settings.SkyColor[1] = v
    Lighting.Ambient = Color3.fromRGB(v, Settings.SkyColor[2], Settings.SkyColor[3])
end)
tabShaders:slider("Sky Color [G] / Зеленый", 0, 255, 206, function(v) 
    Settings.SkyColor[2] = v
    Lighting.Ambient = Color3.fromRGB(Settings.SkyColor[1], v, Settings.SkyColor[3])
end)
tabShaders:slider("Sky Color [B] / Синий", 0, 255, 235, function(v) 
    Settings.SkyColor[3] = v
    Lighting.Ambient = Color3.fromRGB(Settings.SkyColor[1], Settings.SkyColor[2], v)
end)

tabRage:section("Rage & Fun / Хардкор и Угар")
tabRage:toggle("Fling Aura / Флинг-аура", false, function(v) Settings.Fling = v end)
tabRage:toggle("Chat Flood / Флудер чата", false, function(v) Settings.ChatFlood = v end)
tabRage:slider("Flood Delay / Задержка флуда", 0.2, 5, 1, function(v) Settings.FloodDelay = v end)
tabRage:toggle("Click Teleport / Клик-телепорт", false, function(v) Settings.ClickTeleport = v end)
tabRage:toggle("Earthquake / Тряска камеры", false, function(v) Settings.Earthquake = v end)
tabRage:toggle("Invisibility / Невидимка", false, function(v) 
    Settings.Invisible = v
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 1 or 0 end
        end
    end
end)
tabRage:toggle("Godmode / Бессмертие", false, function(v) Settings.Godmode = v end)
tabRage:toggle("SpinBot / Спинбот", false, function(v) Settings.SpinBot = v end)

tabBinds:section("Keybinds / Горячие клавиши")
local keybinds = {
    [Enum.KeyCode.F] = function() toggleFly(not flyActive) end,
    [Enum.KeyCode.G] = function() Settings.Noclip = not Settings.Noclip end,
    [Enum.KeyCode.H] = function() Settings.Speed = not Settings.Speed end,
}
trackConn(UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if keybinds[input.KeyCode] then pcall(keybinds[input.KeyCode]) end
end))

tabSettings:section("Menu Settings / Внешний вид меню")
tabSettings:slider("Menu Color [R] / Красный", 0, 255, 255, function(v) 
    Settings.ColorAccent[1] = v 
    AccentColor = Color3.fromRGB(v, Settings.ColorAccent[2], Settings.ColorAccent[3])
    if getgenv().MellUpdateTheme then getgenv().MellUpdateTheme() end
end)
tabSettings:slider("Menu Color [G] / Зеленый", 0, 255, 40, function(v) 
    Settings.ColorAccent[2] = v 
    AccentColor = Color3.fromRGB(Settings.ColorAccent[1], v, Settings.ColorAccent[3])
    if getgenv().MellUpdateTheme then getgenv().MellUpdateTheme() end
end)
tabSettings:slider("Menu Color [B] / Синий", 0, 255, 90, function(v) 
    Settings.ColorAccent[3] = v 
    AccentColor = Color3.fromRGB(Settings.ColorAccent[1], Settings.ColorAccent[2], v)
    if getgenv().MellUpdateTheme then getgenv().MellUpdateTheme() end
end)
tabSettings:slider("Menu Transparency / Прозрачность", 0, 90, 15, function(v)
    Settings.MenuAlpha = v
    MenuTransparency = v / 100
    if getgenv().MellUpdateTheme then getgenv().MellUpdateTheme() end
end)

tabSettings:section("Script Control / Управление скриптом")
tabSettings:toggle("Unload / Выгрузить скрипт", false, function(v)
    if v then unloadScript() end
end)

local function isEnemy(player)
    if not Settings.TeamCheck then return true end
    return player.Team ~= LocalPlayer.Team
end

trackConn(RunService.Stepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    if Settings.Fling then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = p.Character.HumanoidRootPart
                    if (hrp.Position - targetHrp.Position).Magnitude < 15 then
                        targetHrp.AssemblyLinearVelocity = Vector3.new(math.random(-8000, 8000), 150000, math.random(-8000, 8000))
                        targetHrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                    end
                end
            end
        end
    end
end))

local drawings = {}
trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end

    local boxCol = Color3.fromRGB(Settings.ColorBox[1], Settings.ColorBox[2], Settings.ColorBox[3])

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
                b.Thickness = 1.5; b.Filled = false

                local hbp = trackDrawing(Drawing.new("Square"))
                hbp.Thickness = 1; hbp.Filled = true; hbp.Color = Color3.new(0,0,0)

                local hbf = trackDrawing(Drawing.new("Square"))
                hbf.Thickness = 1; hbf.Filled = true; hbf.Color = Color3.fromRGB(0,255,0)

                local tr = trackDrawing(Drawing.new("Line"))
                tr.Thickness = 1.5

                local nt = trackDrawing(Drawing.new("Text"))
                nt.Size = 13; nt.Center = true; nt.Outline = true; nt.Color = Color3.fromRGB(255,255,255)

                local sk = trackDrawing(Drawing.new("Line"))
                sk.Thickness = 1.5

                drawings[p] = {Box = b, HPBack = hbp, HPFill = hbf, Tracer = tr, NameTag = nt, Skeleton = sk}
            end

            local ui = drawings[p]
            ui.Box.Color = boxCol
            ui.Tracer.Color = boxCol
            ui.Skeleton.Color = Color3.fromRGB(255, 255, 255)

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

                if Settings.SkeletonESP and head and hrp then
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
        fovCircle.Color = Color3.fromRGB(Settings.ColorBox[1], Settings.ColorBox[2], Settings.ColorBox[3])
        fovCircle.Position = UserInputService:GetMouseLocation()
    else
        fovCircle.Visible = false
    end
end))

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
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    if Settings.SpinBot then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(9999), 0)
    end

    if Settings.Earthquake then
        Camera.CFrame = Camera.CFrame * CFrame.new(math.random(-1,1)*0.1, math.random(-1,1)*0.1, 0)
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

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isEnemy(p) and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head and Settings.HitboxExpander then
                head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                head.Transparency = 0.5
                head.CanCollide = false
            elseif head then
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
            end

            if Settings.Chams and not p.Character:FindFirstChild("MellChams") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "MellChams"
                hl.FillColor = AccentColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif p.Character and p.Character:FindFirstChild("MellChams") then
                p.Character.MellChams.FillColor = AccentColor
            end
        end
    end

    if Settings.Killaura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isEnemy(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local enemyHrp = p.Character.HumanoidRootPart
                if (hrp.Position - enemyHrp.Position).Magnitude < 20 then
                    pcall(function() mouse1click() end)
                end
            end
        end
    end

    if Settings.Triggerbot then
        local target = Mouse.Target
        if target and target.Parent then
            local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if enemyPlayer and enemyPlayer ~= LocalPlayer and isEnemy(enemyPlayer) then
                pcall(function() mouse1click() end)
            end
        end
    end

    if Settings.Aimbot or Settings.CamLock then
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

print("MellHack чыч успещна лоадед — фром @ruzoxu")

