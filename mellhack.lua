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

pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, k)
        if k == "WalkSpeed" or k == "JumpPower" or k == "Health" or k == "FieldOfView" then
            return oldIndex(self, k)
        end
        return oldIndex(self, k)
    end)
    setreadonly(mt, true)
    
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
    if setfflag then
        setfflag("HumanoidParallelization", "False")
        setfflag("AbuseReportScreenshotPercentage", "0")
    end
end)

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

local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("Torso") 
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("RootPart")
end

local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function getHead(char)
    if not char then return nil end
    return char:FindFirstChild("Head") 
        or char:FindFirstChild("UpperTorso")
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
        Lighting.FogEnd = 100000
        Camera.FieldOfView = 70
        local sky = Lighting:FindFirstChild("MellCustomSky")
        if sky then sky:Destroy() end
        local bloom = Lighting:FindFirstChild("MellBloom")
        if bloom then bloom:Destroy() end
        local cc = Lighting:FindFirstChild("MellCC")
        if cc then cc:Destroy() end
        local blur = Lighting:FindFirstChild("MellBlur")
        if blur then blur:Destroy() end
        local char = LocalPlayer.Character
        local hum = getHumanoid(char)
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.PlatformStand = false
        end
        if char then
            for _, p in pairs(char:GetDescendants()) do
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

local ThemeConfig = {
    Dark = {
        Main = Color3.fromRGB(10, 10, 14),
        Inner = Color3.fromRGB(16, 16, 22),
        Side = Color3.fromRGB(12, 12, 16),
        Text = Color3.fromRGB(240, 238, 245),
        SubText = Color3.fromRGB(140, 135, 155),
        SliderBg = Color3.fromRGB(50, 47, 58)
    },
    Light = {
        Main = Color3.fromRGB(235, 235, 240),
        Inner = Color3.fromRGB(250, 250, 255),
        Side = Color3.fromRGB(240, 240, 245),
        Text = Color3.fromRGB(20, 20, 30),
        SubText = Color3.fromRGB(100, 100, 115),
        SliderBg = Color3.fromRGB(200, 200, 210)
    }
}

local CurrentTheme = ThemeConfig.Dark

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
    BackgroundColor3 = CurrentTheme.Side,
    BackgroundTransparency = 0.1,
    TextColor3 = CurrentTheme.Text,
    Text = "MellHack Universal | by @ruzoxu | FPS: 60",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    AutoButtonColor = false,
    ZIndex = 100
  }, ah)
  x(watermark, 10)
  local wmStroke = q("UIStroke", {Color = AccentColor, Thickness = 1.4, Transparency = 0.15}, watermark)

  local ai = q("Frame", {Size = UDim2.fromOffset(580, 430), Position = UDim2.new(.5, -290, .5, -215), BackgroundColor3 = Color3.new(), BackgroundTransparency = .5, BorderSizePixel = 0, Active = true, ZIndex = 90}, ah)
  x(ai, 14)
  local aj = q("Frame", {Size = UDim2.fromOffset(572, 422), Position = UDim2.new(.5, -286, .5, -211), BackgroundColor3 = CurrentTheme.Main, BackgroundTransparency = MenuTransparency, BorderSizePixel = 0, Active = true, ZIndex = 91}, ah)
  x(aj, 12)
  local mainStroke = q("UIStroke", {Color = AccentColor, Thickness = 1.2, Transparency = .2}, aj)

  local rgbBar = q("Frame", {Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0, ZIndex = 120}, aj)
  x(rgbBar, 4)
  trackConn(RunService.RenderStepped:Connect(function()
    local hue = (tick() * 0.3) % 1
    rgbBar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
  end))

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

  local titleLabel = q("TextLabel", {
    Size = UDim2.new(1, 0, 0, 32),
    Position = UDim2.new(0, 0, 0, 4),
    BackgroundTransparency = 1,
    Text = "  " .. (ae or "MellHack // @ruzoxu"),
    TextColor3 = CurrentTheme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 95
  }, aj)

  local al = q("Frame", {Position = UDim2.fromOffset(0, 36), Size = UDim2.new(0, 135, 1, -36), BackgroundColor3 = CurrentTheme.Side, BackgroundTransparency = MenuTransparency, BorderSizePixel = 0, ZIndex = 92}, aj)
  local am = q("ScrollingFrame", {Position = UDim2.fromOffset(6, 8), Size = UDim2.new(1, -12, 1, -16), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ZIndex = 93}, al)
  q("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, am)
  local an = q("Frame", {Position = UDim2.fromOffset(135, 36), Size = UDim2.new(1, -135, 1, -36), BackgroundColor3 = CurrentTheme.Inner, BackgroundTransparency = MenuTransparency, BorderSizePixel = 0, ZIndex = 92}, aj)
  
  local tabsList = {}
  local function updateTheme()
    wmStroke.Color = AccentColor
    mainStroke.Color = AccentColor
    watermark.BackgroundColor3 = CurrentTheme.Side
    watermark.TextColor3 = CurrentTheme.Text
    aj.BackgroundColor3 = CurrentTheme.Main
    al.BackgroundColor3 = CurrentTheme.Side
    an.BackgroundColor3 = CurrentTheme.Inner
    titleLabel.TextColor3 = CurrentTheme.Text
    aj.BackgroundTransparency = MenuTransparency
    al.BackgroundTransparency = MenuTransparency
    an.BackgroundTransparency = MenuTransparency
    for _, tabData in pairs(tabsList) do
      tabData.marker.BackgroundColor3 = AccentColor
      tabData.scrollBar.ScrollBarImageColor3 = AccentColor
      tabData.titleText.TextColor3 = CurrentTheme.Text
      tabData.sliderBg.BackgroundColor3 = CurrentTheme.SliderBg
      if tabData.isShown then
        tabData.navButton.TextColor3 = CurrentTheme.Text
        aa(tabData.navButton, {BackgroundTransparency = .82})
      else
        tabData.navButton.TextColor3 = CurrentTheme.SubText
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
    local bk = q("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = ("   " .. bj:upper()), TextColor3 = CurrentTheme.SubText, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 11, AutoButtonColor = false, ZIndex = 94}, am)
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
        bp.navButton.TextColor3 = CurrentTheme.SubText
        aa(bp.navButton, {BackgroundTransparency = 1})
        bp.marker.Visible = false
        bp.isShown = false
      end
      bm.Visible = true
      bk.TextColor3 = CurrentTheme.Text
      aa(bk, {BackgroundTransparency = .82})
      bl.Visible = true
      bn.isShown = true
    end
    function bn:section(bq)
      q("TextLabel", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = bq:upper(), TextColor3 = AccentColor, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 95}, bm)
    end
    function bn:toggle(bv, bw, bx)
      local by = (bw == true)
      local bz = q("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = bv, TextColor3 = CurrentTheme.Text, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 13, AutoButtonColor = false, ZIndex = 95}, bm)
      bn.titleText = bz
      local ca = q("Frame", {AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(40, 20), BackgroundColor3 = ((by and AccentColor) or CurrentTheme.SliderBg), BorderSizePixel = 0, ZIndex = 96}, bz)
      x(ca, 10)
      local cb = q("Frame", {Size = UDim2.fromOffset(16, 16), Position = ((by and UDim2.fromOffset(22, 2)) or UDim2.fromOffset(2, 2)), BackgroundColor3 = Color3.fromRGB(245, 242, 250), BorderSizePixel = 0, ZIndex = 97}, ca)
      x(cb, 8)
      local function cc(cd, ce)
        by = (cd == true)
        aa(ca, {BackgroundColor3 = ((by and AccentColor) or CurrentTheme.SliderBg)})
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
      local titleSl = q("TextLabel", {Size = UDim2.new(1, -55, 0, 22), BackgroundTransparency = 1, Text = ch, TextColor3 = CurrentTheme.Text, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 13, ZIndex = 96}, co)
      local cp = q("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0), Size = UDim2.fromOffset(50, 22), BackgroundTransparency = 1, Text = tostring(cm), TextColor3 = CurrentTheme.Text, TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 96}, co)
      local cq = q("TextButton", {Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = CurrentTheme.SliderBg, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 96}, co)
      bn.sliderBg = cq
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

local Window = k.new("MellHack // @ruzoxu")

local tabMovement = Window:tab("Movement / Мувмент")
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
    Strafes = false,
    StrafeSpeed = 35,
    PixelSurf = false,
    InfiniteJump = false,
    Noclip = false,
    LongJump = false,
    SuperGlide = false,
    WallHop = false,
    AirBoost = false,
    EdgeBug = false,
    
    Aimbot = false,
    WallCheck = true,
    CamLock = false,
    TeamCheck = true,
    AimFOV = 350,
    AimSmooth = 4,
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
    ColorTracer = {255, 40, 90},
    ColorSkeleton = {255, 255, 255},
    ColorChams = {255, 40, 90},
    Crosshair = false,
    FOVIndicator = false,
    BulletTracers = false,
    GlowESP = false,
    TeamESP = true,
    DistanceESP = true,

    Fullbright = false,
    Xray = false,
    SkyColor = {135, 206, 235},
    CustomFog = false,
    FogColor = {200, 200, 200},
    FogEnd = 500,
    ShaderBloom = false,
    ShaderCC = false,
    ShaderBlur = false,
    ShaderSunRays = false,
    ShaderDOF = false,
    
    Invisible = false,
    Godmode = false,
    SpinBot = false,
    AntiAim = false,
    AntiAimMode = "Spin",
    AntiAimPitch = "Normal",
    YawOffset = 0,
    HideHead = false,
    JitterRange = 45,
    SpinSpeed = 150,
    BodyShake = false,
    Freecam = false,
    FreecamSpeed = 50,
    Earthquake = false,
    ClickTeleport = false,
    Fling = false,
    ChatFlood = false,
    FloodText = "MellHack by @ruzoxu",
    FloodDelay = 1,
    AutoHeal = false,
    HitSound = false,
    
    ColorAccent = {255, 40, 90},
    MenuAlpha = 15,
    WhiteTheme = false,
    FOVChanger = false,
    CustomFOV = 90
}

local flyActive = false
local flyConn = nil
local function toggleFly(state)
    flyActive = state
    local char = LocalPlayer.Character
    local hrp = getRoot(char)
    local hum = getHumanoid(char)
    if not char or not hrp or not hum then return end

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

local function handleTeleport(pos)
    if Settings.ClickTeleport then
        local char = LocalPlayer.Character
        local hrp = getRoot(char)
        if char and hrp then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        end
    end
end

trackConn(Mouse.Button1Down:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService.TouchEnabled then
        handleTeleport(Mouse.Hit.Position)
    end
end))

trackConn(UserInputService.TouchTapInWorld:Connect(function(position, processed)
    if not processed and Settings.ClickTeleport then
        local ray = Camera:ScreenPointToRay(position.X, position.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        if result then
            handleTeleport(result.Position)
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
    if not v and LocalPlayer.Character then
        local hum = getHumanoid(LocalPlayer.Character)
        if hum then hum.WalkSpeed = 16 end
    end
end)
tabMovement:slider("WalkSpeed / Скорость бега", 16, 400, 80, function(v) Settings.WalkSpeedVal = v end)

tabMovement:toggle("JumpPower / Супер Прыжок", false, function(v) 
    Settings.Jump = v
    if not v and LocalPlayer.Character then
        local hum = getHumanoid(LocalPlayer.Character)
        if hum then hum.JumpPower = 50 end
    end
end)
tabMovement:slider("Jump Height / Высота прыжка", 50, 800, 250, function(v) Settings.JumpPowerVal = v end)

tabMovement:section("Advanced Movement / Продвинутый мувмент")
tabMovement:toggle("Auto-Bhop / Авто-баннихоп", false, function(v) Settings.Bhop = v end)
tabMovement:toggle("Air Strafes / Воздушные стрейфы", false, function(v) Settings.Strafes = v end)
tabMovement:slider("Strafe Speed / Скорость стрейфов", 10, 100, 35, function(v) Settings.StrafeSpeed = v end)
tabMovement:toggle("Pixel Surf / Прилипание к стенам", false, function(v) Settings.PixelSurf = v end)
tabMovement:toggle("Long Jump / Длинный прыжок", false, function(v) Settings.LongJump = v end)
tabMovement:toggle("Super Glide / Супер скольжение", false, function(v) Settings.SuperGlide = v end)
tabMovement:toggle("Wall Hop / Отскок от стен", false, function(v) Settings.WallHop = v end)
tabMovement:toggle("Air Boost / Воздушное ускорение", false, function(v) Settings.AirBoost = v end)
tabMovement:toggle("Edge Bug / Смягчение падения у края", false, function(v) Settings.EdgeBug = v end)
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
tabCombat:toggle("WallCheck / Проверка стен (Не шить сквозь стены)", true, function(v) Settings.WallCheck = v end)
tabCombat:toggle("CamLock / Мягкое удержание", false, function(v) Settings.CamLock = v end)
tabCombat:toggle("TeamCheck / Проверка команды", true, function(v) Settings.TeamCheck = v end)
tabCombat:slider("Aim FOV / Радиус обзора", 50, 1000, 350, function(v) Settings.AimFOV = v end)
tabCombat:slider("Aim Smooth / Плавность аимбота", 1, 10, 4, function(v) Settings.AimSmooth = v end)
tabCombat:toggle("Draw FOV / Отображать круг FOV", true, function(v) Settings.DrawFOV = v end)

tabCombat:toggle("Autoclicker / Автокликер", false, function(v) Settings.Autoclicker = v end)
tabCombat:slider("CPS / Скорость кликов", 1, 50, 15, function(v) Settings.AutoclickerCPS = v end)

tabCombat:toggle("Killaura / Киллаура", false, function(v) Settings.Killaura = v end)
tabCombat:toggle("Triggerbot / Триггербот", false, function(v) Settings.Triggerbot = v end)
tabCombat:toggle("Hitbox Expander / Увеличение хитбоксов", false, function(v) 
    Settings.HitboxExpander = v
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            local head = getHead(p.Character)
            if head then
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
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
tabVisuals:toggle("FOV Changer / Настройка FOV игры", false, function(v) Settings.FOVChanger = v end)
tabVisuals:slider("Game FOV / Значение FOV", 30, 120, 90, function(v) Settings.CustomFOV = v end)

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
tabShaders:toggle("Custom Fog / Настройка тумана", false, function(v)
    Settings.CustomFog = v
    if not v then
        Lighting.FogEnd = 100000
    end
end)
tabShaders:slider("Fog Distance / Плотность тумана", 50, 5000, 500, function(v) Settings.FogEnd = v end)

tabShaders:section("Shaders Pro / Ультра Шейдеры")
tabShaders:toggle("Shader: Cinema Bloom / Кино-свечение", false, function(v)
    local bloom = Lighting:FindFirstChild("MellBloom")
    if v and not bloom then
        bloom = Instance.new("BloomEffect", Lighting)
        bloom.Name = "MellBloom"
        bloom.Intensity = 1.2
        bloom.Size = 40
        bloom.Threshold = 0.6
    elseif not v and bloom then
        bloom:Destroy()
    end
end)
tabShaders:toggle("Shader: HDR Color Correction / HDR Графика", false, function(v)
    local cc = Lighting:FindFirstChild("MellCC")
    if v and not cc then
        cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "MellCC"
        cc.Saturation = 0.45
        cc.Contrast = 0.3
        cc.TintColor = Color3.fromRGB(245, 230, 210)
    elseif not v and cc then
        cc:Destroy()
    end
end)

tabShaders:section("Sky Color RGB / Цвет неба")
tabShaders:slider("Sky Color [R]", 0, 255, 135, function(v) 
    Settings.SkyColor[1] = v
    local sky = Lighting:FindFirstChild("MellCustomSky")
    if not sky then
        sky = Instance.new("Sky", Lighting)
        sky.Name = "MellCustomSky"
    end
    sky.SkyboxBk = "" sky.SkyboxDn = "" sky.SkyboxFt = "" sky.SkyboxLf = "" sky.SkyboxRt = "" sky.SkyboxUp = ""
    Lighting.Ambient = Color3.fromRGB(v, Settings.SkyColor[2], Settings.SkyColor[3])
    Lighting.OutdoorAmbient = Color3.fromRGB(v, Settings.SkyColor[2], Settings.SkyColor[3])
end)
tabShaders:slider("Sky Color [G]", 0, 255, 206, function(v) 
    Settings.SkyColor[2] = v
    Lighting.Ambient = Color3.fromRGB(Settings.SkyColor[1], v, Settings.SkyColor[3])
    Lighting.OutdoorAmbient = Color3.fromRGB(Settings.SkyColor[1], v, Settings.SkyColor[3])
end)
tabShaders:slider("Sky Color [B]", 0, 255, 235, function(v) 
    Settings.SkyColor[3] = v
    Lighting.Ambient = Color3.fromRGB(Settings.SkyColor[1], Settings.SkyColor[2], v)
    Lighting.OutdoorAmbient = Color3.fromRGB(Settings.SkyColor[1], Settings.SkyColor[2], v)
end)

tabRage:section("Rage & Fun / Хардкор и Угар")
tabRage:toggle("Fling Aura / Флинг-аура", false, function(v) Settings.Fling = v end)
tabRage:toggle("Chat Flood / Флудер чата", false, function(v) Settings.ChatFlood = v end)
tabRage:slider("Flood Delay / Задержка флуда", 0.2, 5, 1, function(v) Settings.FloodDelay = v end)
tabRage:toggle("Click Teleport / Клик-телепорт", false, function(v) Settings.ClickTeleport = v end)
tabRage:toggle("Freecam / Свободная камера", false, function(v) Settings.Freecam = v end)
tabRage:slider("Freecam Speed / Скорость камеры", 10, 200, 50, function(v) Settings.FreecamSpeed = v end)
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
tabRage:toggle("Auto Heal / Авто-хил", false, function(v) Settings.AutoHeal = v end)

tabRage:section("Anti-Aim Pro / Ультра Анти-аим")
tabRage:toggle("Anti-Aim Active / Включить анти-аим", false, function(v) Settings.AntiAim = v end)
tabRage:slider("Spin Speed / Скорость крутилки", 100, 5000, 2000, function(v) Settings.SpinSpeed = v end)
tabRage:slider("Jitter Range / Размах джитеров", 10, 180, 90, function(v) Settings.JitterRange = v end)
tabRage:slider("Yaw Offset / Направление взгляда", -180, 180, 0, function(v) Settings.YawOffset = v end)
tabRage:toggle("Body Shake / Потрясывание тела", false, function(v) Settings.BodyShake = v end)
tabRage:toggle("Hide Head / Спрятать голову (Без смерти)", false, function(v) Settings.HideHead = v end)

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
tabSettings:toggle("White Theme / Белая тема меню", false, function(v)
    Settings.WhiteTheme = v
    CurrentTheme = v and ThemeConfig.Light or ThemeConfig.Dark
    if getgenv().MellUpdateTheme then getgenv().MellUpdateTheme() end
end)
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

local function isVisible(targetPart)
    if not Settings.WallCheck then return true end
    local char = LocalPlayer.Character
    local cam = Camera
    if not char or not cam then return false end
    local origin = cam.CFrame.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {char, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    local result = Workspace:Raycast(origin, targetPart.Position - origin, raycastParams)
    return result == nil
end

trackConn(RunService.Stepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    if Settings.Fling then
        local char = LocalPlayer.Character
        local hrp = getRoot(char)
        if char and hrp then
            for _, p in pairs(Players:GetPlayers()) do
                local targetHrp = getRoot(p.Character)
                if p ~= LocalPlayer and p.Character and targetHrp then
                    if (hrp.Position - targetHrp.Position).Magnitude < 15 then
                        hrp.CFrame = targetHrp.CFrame
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        local thr = hrp:FindFirstChild("FlingThrust")
                        if not thr then
                            thr = Instance.new("BodyThrust", hrp)
                            thr.Name = "FlingThrust"
                            thr.Force = Vector3.new(99999, 99999, 99999)
                        end
                        thr.Location = targetHrp.Position
                        break
                    end
                end
            end
        end
    else
        local char = LocalPlayer.Character
        local hrp = getRoot(char)
        if char and hrp then
            local thr = hrp:FindFirstChild("FlingThrust")
            if thr then thr:Destroy() end
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
        if p ~= LocalPlayer and (Settings.TeamCheck and isEnemy(p) or not Settings.TeamCheck) and p.Character then
            local hrp = getRoot(p.Character)
            local hum = getHumanoid(p.Character)
            local head = getHead(p.Character)

            if hrp then
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
                ui.Tracer.Color = Color3.fromRGB(Settings.ColorTracer[1], Settings.ColorTracer[2], Settings.ColorTracer[3])
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
    local char = LocalPlayer.Character
    local hum = getHumanoid(char)
    if Settings.InfiniteJump and char and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = getRoot(char)
    local humanoid = getHumanoid(char)
    if not hrp or not humanoid then return end

    if Settings.Speed then humanoid.WalkSpeed = Settings.WalkSpeedVal end
    if Settings.Jump then humanoid.JumpPower = Settings.JumpPowerVal end
    if Settings.Godmode then humanoid.Health = humanoid.MaxHealth end
    if Settings.AutoHeal and humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end

    if Settings.FOVChanger then
        Camera.FieldOfView = Settings.CustomFOV
    end

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

    if Settings.Strafes then
        if humanoid.FloorMaterial == Enum.Material.Air then
            local moveDir = humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * Settings.StrafeSpeed, hrp.AssemblyLinearVelocity.Y, moveDir.Z * Settings.StrafeSpeed)
            end
        end
    end

    if Settings.PixelSurf then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local leftRay = Workspace:Raycast(hrp.Position, -hrp.CFrame.RightVector * 3.5, params)
        local rightRay = Workspace:Raycast(hrp.Position, hrp.CFrame.RightVector * 3.5, params)
        local forwardRay = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3.5, params)
        local backRay = Workspace:Raycast(hrp.Position, -hrp.CFrame.LookVector * 3.5, params)
        
        if (leftRay or rightRay or forwardRay or backRay) and humanoid.FloorMaterial == Enum.Material.Air then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
            else
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (moveDir * (Settings.StrafeSpeed / 60))
                end
            end
        end
    end

    if Settings.LongJump and humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 90 + Vector3.new(0, 40, 0)
    end

    if Settings.SuperGlide then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ledgeRay = Workspace:Raycast(hrp.Position + Vector3.new(0, 2, 0), hrp.CFrame.LookVector * 4, params)
        if ledgeRay and humanoid.FloorMaterial == Enum.Material.Air then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 15, hrp.AssemblyLinearVelocity.Z * 3)
        end
    end

    if Settings.WallHop and humanoid.FloorMaterial == Enum.Material.Air then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local wallRay = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3, params)
        if wallRay and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 65, hrp.AssemblyLinearVelocity.Z)
        end
    end

    if Settings.AirBoost and humanoid.FloorMaterial == Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + (Camera.CFrame.LookVector * 5)
    end

    if Settings.EdgeBug then
        if hrp.AssemblyLinearVelocity.Y < -50 and humanoid.FloorMaterial == Enum.Material.Air then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
        end
    end

    if Settings.SpinBot and not Settings.AntiAim then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    if Settings.AntiAim then
        local rotSpeed = Settings.SpinSpeed * 20
        local yawOffsetRad = math.rad(Settings.YawOffset)
        local jitterRad = math.rad(math.random(-Settings.JitterRange, Settings.JitterRange))
        local finalAngle = (tick() * rotSpeed) + yawOffsetRad + jitterRad
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, finalAngle, 0)
    end

    if Settings.BodyShake then
        hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-1,1)*0.2, math.random(-1,1)*0.2, math.random(-1,1)*0.2)
    end

    if Settings.HideHead then
        local head = getHead(char)
        if head then
            head.Transparency = 1
            head.CanCollide = false
            for _, child in pairs(head:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("DataModelMesh") or child:IsA("Decal") then
                    child.Transparency = 1
                end
            end
        end
    end

    if Settings.Freecam then
        Camera.CameraType = Enum.CameraType.Scriptable
        local moveDir = Vector3.new(0, 0, 0)
        local camCF = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        Camera.CFrame = camCF + (moveDir * (Settings.FreecamSpeed / 30))
    else
        if Camera.CameraType == Enum.CameraType.Scriptable then
            Camera.CameraType = Enum.CameraType.Custom
        end
    end

    if Settings.Earthquake then
        Camera.CFrame = Camera.CFrame * CFrame.new(math.random(-1,1)*0.1, math.random(-1,1)*0.1, 0)
    end

    if Settings.Fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
    end

    if Settings.CustomFog then
        Lighting.FogEnd = Settings.FogEnd
        Lighting.FogColor = Color3.fromRGB(Settings.FogColor[1], Settings.FogColor[2], Settings.FogColor[3])
    end

    if Settings.Xray then
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency < 0.5 and not p:IsDescendantOf(char) then
                p.LocalTransparencyModifier = 0.6
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (Settings.TeamCheck and isEnemy(p) or not Settings.TeamCheck) and p.Character then
            local head = getHead(p.Character)
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
                hl.FillColor = Color3.fromRGB(Settings.ColorChams[1], Settings.ColorChams[2], Settings.ColorChams[3])
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif p.Character and p.Character:FindFirstChild("MellChams") then
                p.Character.MellChams.FillColor = Color3.fromRGB(Settings.ColorChams[1], Settings.ColorChams[2], Settings.ColorChams[3])
            end
        end
    end

    if Settings.Killaura then
        for _, p in pairs(Players:GetPlayers()) do
            local enemyHrp = getRoot(p.Character)
            if p ~= LocalPlayer and isEnemy(p) and p.Character and enemyHrp then
                if (hrp.Position - enemyHrp.Position).Magnitude < 20 then
                    pcall(function() mouse1click() end)
                end
            end
        end
    end

    if Settings.Triggerbot then
        local target = Mouse.Target
        if target and target.Parent then
            local pTarget = Players:GetPlayerFromCharacter(target.Parent)
            if pTarget and pTarget ~= LocalPlayer and isEnemy(pTarget) then
                pcall(function() mouse1keypress() end)
            end
        end
    end

    if Settings.Aimbot or Settings.CamLock then
        local target, minDst = nil, Settings.AimFOV
        local mousePos = UserInputService:GetMouseLocation()

        for _, p in pairs(Players:GetPlayers()) do
            local targetHead = getHead(p.Character)
            local hum = getHumanoid(p.Character)
            if p ~= LocalPlayer and isEnemy(p) and p.Character and targetHead then
                if hum and hum.Health > 0 and isVisible(targetHead) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetHead.Position)
                    if onScreen then
                        local dst = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dst < minDst then
                            minDst = dst
                            target = targetHead
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

print("[AERO] MellHack successfully loaded — by @ruzoxu!")

