-- MellHack v14 — Ultimate Edition (FIXED)
local function safeLog(msg, extra)
    pcall(function()
        warn("[MellHack] " .. tostring(msg) .. (extra and (" " .. tostring(extra)) or ""))
    end)
end

local function httpGet(url)
    local ok, body = pcall(function()
        if syn and syn.request then
            return syn.request({ Url = url, Method = "GET" }).Body
        elseif http_request then
            return http_request({ Url = url, Method = "GET" }).Body
        elseif request then
            return request({ Url = url, Method = "GET" }).Body
        elseif game.HttpGet then
            return game:HttpGet(url)
        end
    end)
    if ok and body and #body > 500 then return body end
    return nil
end

local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")
local TweenService     = game:GetService("TweenService")
local TextChatService  = game:GetService("TextChatService")
local HttpService      = game:GetService("HttpService")
local StarterGui       = game:GetService("StarterGui")
local SoundService     = game:GetService("SoundService")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()
local Camera           = Workspace.CurrentCamera

pcall(function()
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
end)

if getgenv().MellHackLoaded then
    pcall(function() getgenv().MellHackUnload() end)
end
getgenv().MellHackLoaded = true

local Connections      = {}
local ObjectsToCleanup = {}

local function trackConn(c) table.insert(Connections, c) return c end
local function trackObj(o)  table.insert(ObjectsToCleanup, o) return o end

local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso") or char:FindFirstChild("RootPart")
end
local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end
local function getHead(char)
    if not char then return nil end
    return char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso")
end

local WindUI = getgenv().WindUI_Cache
if not WindUI then
    local src
    for _, url in ipairs({
        "https://cdn.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua",
        "https://raw.githack.com/Footagesus/WindUI/main/dist/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    }) do
        src = httpGet(url)
        if src then safeLog("WindUI downloaded from " .. url); break end
    end
    if not src then
        safeLog("WindUI download failed")
        StarterGui:SetCore("SendNotification", {
            Title = "MellHack", Text = "WindUI download failed", Duration = 8,
        })
        return
    end
    local fn, err = loadstring(src)
    if not fn then safeLog("loadstring err", err); return end
    local ok, res = pcall(fn)
    if not ok or not res then safeLog("WindUI init err", res); return end
    WindUI = res
    getgenv().WindUI_Cache = WindUI
end

local Window = WindUI:CreateWindow({
    Title    = "MellHack",
    Author   = "@ruzoxu",
    Icon     = "rbxassetid://120997033468887",
    Size     = UDim2.fromOffset(600, 480),
    MinSize  = Vector2.new(480, 400),
    MaxSize  = Vector2.new(950, 720),
    Transparent = true,
    Acrylic  = false,
    Theme    = "Dark",
    User     = { Enabled = false, Anonymous = true, Callback = function() end },
    Topbar   = { Height = 52, ButtonsType = "Default" },
    Resizable = true,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    NewElements = true,
    IgnoreAlerts = true,
})

-- ═══════════════════════════════════════════════════════════════
--  SETTINGS
-- ═══════════════════════════════════════════════════════════════
local Settings = {
    Fly = false, FlySpeed = 127,
    Speed = false, WalkSpeedVal = 80,
    Jump = false, JumpPowerVal = 250,
    Bhop = false, Strafes = false, StrafeSpeed = 35,
    PixelSurf = false, InfiniteJump = false, Noclip = false,
    LongJump = false, SuperGlide = false, WallHop = false,
    AirBoost = false, EdgeBug = false,
    WallClimb = false, NoFallDamage = false, AutoRespawn = false,

    Aimbot = false, SilentAim = false, WallCheck = true,
    CamLock = false, TeamCheck = true, AimFOV = 350,
    AimSmooth = 4, DrawFOV = true, AimPart = "Head",
    AimPrediction = 0.15, AimHitChance = 100,
    Triggerbot = false, TriggerbotDelay = 0.05,
    TriggerbotFOV = 150, TriggerbotWallCheck = true,
    Autoclicker = false, AutoclickerCPS = 15,
    Killaura = false, KillauraRange = 20,
    HitboxExpander = false, HitboxSize = 8,

    ESPBox = true, HPBar = true, Tracers = true,
    SkeletonESP = true, NameESP = true, Chams = true,
    LocalChams = false,
    Crosshair = false, BulletTracers = false,
    TeamESP = true, Watermark = true,

    -- ESP Preview (right of menu)
    PreviewEnabled = true,
    Preview3D      = true,
    PreviewModel   = "R6 Blocky",
    PreviewShader  = "Flat",
    PreviewBox     = true,
    PreviewName    = true,
    PreviewHP      = true,
    PreviewSkeleton= false,
    PreviewTracer  = false,
    PreviewChams   = false,
    PreviewZoom    = 8,
    PreviewOffsetX = 12,   -- gap between menu and preview

    -- Chams
    ChamsType = "Highlight",
    ChamsShader = "Flat",
    LocalChamsShader = "Flat",
    ChamsWallOccluded = false,

    ColorMenu         = Color3.fromRGB(255, 40, 90),
    ColorWindow       = Color3.fromRGB(16, 16, 22),
    ColorPanel        = Color3.fromRGB(12, 12, 16),
    ColorText         = Color3.fromRGB(240, 238, 245),
    ColorSubText      = Color3.fromRGB(140, 135, 155),

    ColorBox          = Color3.fromRGB(255, 40, 90),
    ColorTracer       = Color3.fromRGB(255, 40, 90),
    ColorSkeleton     = Color3.fromRGB(255, 255, 255),
    ColorName         = Color3.fromRGB(255, 255, 255),
    ColorHPFull       = Color3.fromRGB(0, 255, 80),
    ColorHPEmpty      = Color3.fromRGB(0, 0, 0),
    ColorFOV          = Color3.fromRGB(255, 40, 90),
    ColorCrosshair    = Color3.fromRGB(255, 255, 255),
    ColorBulletTracer = Color3.fromRGB(255, 200, 0),

    ColorChams        = Color3.fromRGB(255, 40, 90),
    ColorChamsOutline = Color3.fromRGB(255, 255, 255),
    ColorLocalChams   = Color3.fromRGB(0, 255, 200),

    AlphaMenu         = 0.15,
    AlphaWindow       = 0.15,
    AlphaPanel        = 0.15,
    AlphaText         = 0.0,
    AlphaSubText      = 0.0,
    AlphaBox          = 0.0,
    AlphaTracer       = 0.0,
    AlphaSkeleton     = 0.0,
    AlphaName         = 0.0,
    AlphaHPFull       = 0.0,
    AlphaHPEmpty      = 0.0,
    AlphaFOV          = 0.2,
    AlphaCrosshair    = 0.0,
    AlphaBulletTracer = 0.0,
    AlphaChams        = 0.5,
    AlphaChamsOutline = 0.0,
    AlphaLocalChams   = 0.35,

    Fullbright = false, Xray = false, SkyColor = {135,206,235},
    CustomFog = false, FogColor = {200,200,200}, FogEnd = 500,
    FogStart = 0, FogDensity = 0.0, FogMode = "Linear",

    Invisible = false, Godmode = false, SpinBot = false,
    SpinSpeed = 1000, AntiAim = false, AntiAimMode = "Spin",
    YawOffset = 0, HideHead = false, JitterRange = 45,
    BodyShake = false,
    Freecam = false, FreecamSpeed = 50, Earthquake = false,
    ClickTeleport = false, ChatFlood = false,
    FloodText = "MellHack by @ruzoxu", FloodDelay = 1,
    AutoHeal = false,

    FOVChanger = false, CustomFOV = 90,
    Jerk = false, Bang = false, Fling = false, AntiFling = false,

    DroneEnabled     = false,
    DroneSpeed       = 200,
    DroneAccel       = 8,
    DroneCamera      = "TPV",
    DroneDamage      = 100,
    DroneHUDCorner   = "TR",
    DroneShowExplosion = true,
    DroneKnockback   = true,
    DroneAutoDestroy = true,
    DroneCameraBack  = 10,
    DroneFPVEffects  = true,
    DroneFPVFOV      = 100,
    DroneFPVShake    = true,
    DroneShowVignette = true,
    DroneSoundVolume = 0.6,
    DroneMissiles    = true,
    DroneShield      = false,
    DroneNightVision = false,
    DroneAutoHover   = true,
    DroneRadar       = true,
    DroneLockOn      = false,
    DroneLockRange   = 150,
}

local function ApplyMenuColorsToTheme()
    if not WindUI or not WindUI.Themes then return end
    for _, key in ipairs({"Dark", "Light"}) do
        local t = WindUI.Themes[key]
        if t then
            t.Accent = Settings.ColorMenu
            t.Primary = Settings.ColorMenu
            t.Button = Settings.ColorMenu
            t.Slider = Settings.ColorMenu
            t.Toggle = Settings.ColorMenu
            t.Checkbox = Settings.ColorMenu
            t.WindowBackground = Settings.ColorWindow
            t.Background = Settings.ColorWindow
            t.PanelBackground = Settings.ColorPanel
            t.TabBackground = Settings.ColorPanel
            t.TabBackgroundActive = Settings.ColorPanel
            t.Text = Settings.ColorText
            t.Placeholder = Settings.ColorSubText
            t.Icon = Settings.ColorSubText
            t.BackgroundTransparency = Settings.AlphaWindow
            t.PanelBackgroundTransparency = Settings.AlphaPanel
            t.TabBackgroundActiveTransparency = Settings.AlphaPanel
            t.TabBackgroundHoverTransparency = math.clamp(Settings.AlphaPanel + 0.05, 0, 1)
            t.WindowBackgroundTransparency = Settings.AlphaWindow
        end
    end
    if WindUI.Creator and WindUI.Creator.UpdateTheme then
        pcall(function() WindUI.Creator.UpdateTheme(nil, false, false) end)
    end
end

local gethuiFn = gethui or function()
    return (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
end
local ParentGui
pcall(function() ParentGui = gethuiFn() end)
if not ParentGui then ParentGui = CoreGui end

local ESPGui = trackObj(Instance.new("ScreenGui"))
ESPGui.Name = "MellHack_ESP"
ESPGui.ResetOnSpawn = false
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ESPGui.IgnoreGuiInset = true
ESPGui.Parent = ParentGui

-- Separate ScreenGui for preview so it stays anchored to viewport
local PreviewGui = trackObj(Instance.new("ScreenGui"))
PreviewGui.Name = "MellHack_Preview"
PreviewGui.ResetOnSpawn = false
PreviewGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
PreviewGui.IgnoreGuiInset = true
PreviewGui.Parent = ParentGui

local function newFrame(props)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    f.BackgroundColor3 = Color3.new(1,1,1)
    if props then for k,v in pairs(props) do f[k] = v end end
    return trackObj(f)
end
local function newStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(1,1,1)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- ═══════════════════════════════════════════════════════════════
--  USER PANEL (bottom-left)
-- ═══════════════════════════════════════════════════════════════
do
    local userPanel = Instance.new("Frame")
    userPanel.Name = "MellUserPanel"
    userPanel.Size = UDim2.fromOffset(180, 48)
    userPanel.Position = UDim2.new(0, 16, 1, -64)
    userPanel.AnchorPoint = Vector2.new(0, 0)
    userPanel.BackgroundColor3 = Settings.ColorPanel
    userPanel.BackgroundTransparency = 0.35
    userPanel.BorderSizePixel = 0
    userPanel.ZIndex = 99999
    userPanel.Parent = WindUI and WindUI.ScreenGui or ESPGui
    trackObj(userPanel)

    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 12); pc.Parent = userPanel
    local ps = Instance.new("UIStroke"); ps.Color = Settings.ColorMenu; ps.Thickness = 1.5; ps.Transparency = 0.35; ps.Parent = userPanel

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.fromOffset(36, 36)
    avatarFrame.Position = UDim2.new(0, 6, 0.5, -18)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    avatarFrame.BackgroundTransparency = 0.4
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 100000
    avatarFrame.Parent = userPanel
    local ac = Instance.new("UICorner"); ac.CornerRadius = UDim.new(1, 0); ac.Parent = avatarFrame

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.fromScale(1, 1)
    avatar.BackgroundTransparency = 1
    avatar.ZIndex = 100001
    avatar.Parent = avatarFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, -50, 0, 18)
    nameLabel.Position = UDim2.new(0, 48, 0, 8)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Settings.ColorText
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = LocalPlayer.DisplayName
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 100000
    nameLabel.Parent = userPanel
    trackObj(nameLabel)

    local userLabel = Instance.new("TextLabel")
    userLabel.Name = "Username"
    userLabel.BackgroundTransparency = 1
    userLabel.Size = UDim2.new(1, -50, 0, 14)
    userLabel.Position = UDim2.new(0, 48, 0, 26)
    userLabel.Font = Enum.Font.Gotham
    userLabel.TextSize = 11
    userLabel.TextColor3 = Settings.ColorSubText
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.Text = "@" .. LocalPlayer.Name
    userLabel.TextTruncate = Enum.TextTruncate.AtEnd
    userLabel.ZIndex = 100000
    userLabel.Parent = userPanel
    trackObj(userLabel)

    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok and image then avatar.Image = image end
    end)
end

-- ═══════════════════════════════════════════════════════════════
--  CHAMS — NativeChams-inspired shader palette
-- ═══════════════════════════════════════════════════════════════
local ChamsShaders = {
    Flat    = { fill = 1.00, outline = 0.00, glow = 0.00, desc = "Solid color" },
    Lit     = { fill = 0.82, outline = 0.15, glow = 0.05, desc = "Directional lit" },
    Clay    = { fill = 0.90, outline = 0.10, glow = 0.00, desc = "Matte clay" },
    Glass   = { fill = 0.50, outline = 0.05, glow = 0.20, desc = "Transparent glass" },
    Crystal = { fill = 0.35, outline = 0.65, glow = 0.10, desc = "High outline" },
    Ice     = { fill = 0.55, outline = 0.35, glow = 0.30, desc = "Frozen glow" },
    Prism   = { fill = 0.65, outline = 0.45, glow = 0.45, desc = "Rainbow edge" },
    Heat    = { fill = 0.75, outline = 0.55, glow = 0.60, desc = "Heat haze" },
    Core    = { fill = 0.15, outline = 0.95, glow = 0.25, desc = "Outline only" },
}

local function buildHighlightProps(shader, baseColor, baseAlpha, outlineColor, outlineAlpha)
    local s = ChamsShaders[shader] or ChamsShaders.Flat
    return {
        FillColor = baseColor,
        FillTransparency = math.clamp(baseAlpha * s.fill, 0, 1),
        OutlineColor = outlineColor,
        OutlineTransparency = math.clamp(s.outline + outlineAlpha * 0.5, 0, 1),
        DepthMode = Settings.ChamsWallOccluded
            and Enum.HighlightDepthMode.AlwaysOnTop
            or Enum.HighlightDepthMode.Occluded,
    }
end

local function applyChamsToCharacter(char, isLocal)
    if not char then return end
    local wantChams = isLocal and Settings.LocalChams or (not isLocal and Settings.Chams)
    local shader = isLocal and Settings.LocalChamsShader or Settings.ChamsShader
    local baseColor = isLocal and Settings.ColorLocalChams or Settings.ColorChams
    local baseAlpha = isLocal and Settings.AlphaLocalChams or Settings.AlphaChams
    local outlineColor = isLocal and Settings.ColorLocalChams or Settings.ColorChamsOutline
    local outlineAlpha = isLocal and 0.3 or Settings.AlphaChamsOutline

    if Settings.ChamsType == "ForceField" then
        local hl = char:FindFirstChild("MellChams")
        if hl then hl:Destroy() end
        if not wantChams then
            for _, d in ipairs(char:GetDescendants()) do
                if d.Name == "MellForceField" and d:IsA("SelectionBox") then
                    d:Destroy()
                end
            end
            return
        end
        local existing = char:FindFirstChild("MellForceField")
        if not existing then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local sb = Instance.new("SelectionBox")
                    sb.Name = "MellForceField"
                    sb.Adornee = part
                    sb.LineThickness = 0.05
                    sb.Color3 = baseColor
                    sb.SurfaceColor3 = baseColor
                    sb.SurfaceTransparency = 0.85
                    sb.Transparency = 1 - baseAlpha
                    sb.Parent = part
                end
            end
        else
            for _, sb in ipairs(char:GetDescendants()) do
                if sb.Name == "MellForceField" and sb:IsA("SelectionBox") then
                    sb.Color3 = baseColor
                    sb.SurfaceColor3 = baseColor
                    sb.Transparency = 1 - baseAlpha
                end
            end
        end
        return
    end

    -- Highlight chams (default)
    for _, d in ipairs(char:GetDescendants()) do
        if d.Name == "MellForceField" and d:IsA("SelectionBox") then
            d:Destroy()
        end
    end

    local hl = char:FindFirstChild("MellChams")
    if not wantChams then
        if hl then hl:Destroy() end
        return
    end
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "MellChams"
        hl.Parent = char
    end
    local props = buildHighlightProps(shader, baseColor, baseAlpha, outlineColor, outlineAlpha)
    hl.FillColor = props.FillColor
    hl.FillTransparency = props.FillTransparency
    hl.OutlineColor = props.OutlineColor
    hl.OutlineTransparency = props.OutlineTransparency
    hl.DepthMode = props.DepthMode
end

local function clearAllChams()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("MellChams")
            if h then h:Destroy() end
            for _, d in ipairs(p.Character:GetDescendants()) do
                if d.Name == "MellForceField" and d:IsA("SelectionBox") then
                    d:Destroy()
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
--  ESP CACHE (Box + Name + HP)
-- ═══════════════════════════════════════════════════════════════
local ESPCache = {}

local function ensureESP(player)
    if ESPCache[player] then return ESPCache[player] end
    local data = {}

    data.Billboard = Instance.new("BillboardGui")
    data.Billboard.Name = "MellESP_" .. player.Name
    data.Billboard.AlwaysOnTop = true
    data.Billboard.LightInfluence = 0
    data.Billboard.Size = UDim2.fromOffset(60, 120)
    data.Billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
    data.Billboard.ResetOnSpawn = false
    data.Billboard.Parent = ESPGui
    trackObj(data.Billboard)

    -- Root frame holds the box; HP bar positioned to the left of box
    data.BoxFrame = newFrame({
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = data.Billboard,
    })
    data.BoxStroke = newStroke(data.BoxFrame, Settings.ColorBox, 1.5, Settings.AlphaBox)

    -- HP bar (left of box)
    data.HPBarBack = newFrame({
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, -7, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Settings.ColorHPEmpty,
        BackgroundTransparency = Settings.AlphaHPEmpty,
        Parent = data.Billboard,
    })
    data.HPBarFill = newFrame({
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Settings.ColorHPFull,
        BackgroundTransparency = Settings.AlphaHPFull,
        Parent = data.HPBarBack,
    })
    data.HPBarFill.ClipsDescendants = false

    -- Name
    data.NameLabel = Instance.new("TextLabel")
    data.NameLabel.BackgroundTransparency = 1
    data.NameLabel.Size = UDim2.new(1, 0, 0, 16)
    data.NameLabel.Position = UDim2.new(0, 0, 0, -18)
    data.NameLabel.Font = Enum.Font.GothamBold
    data.NameLabel.TextSize = 13
    data.NameLabel.TextColor3 = Settings.ColorName
    data.NameLabel.TextTransparency = Settings.AlphaName
    data.NameLabel.TextStrokeTransparency = 0.4
    data.NameLabel.Text = ""
    data.NameLabel.Visible = false
    data.NameLabel.Parent = data.Billboard
    trackObj(data.NameLabel)

    ESPCache[player] = data
    return data
end

local function destroyESP(player)
    local d = ESPCache[player]
    if d and d.Billboard then d.Billboard:Destroy() end
    ESPCache[player] = nil
end
trackConn(Players.PlayerRemoving:Connect(destroyESP))

local TracerCache = {}
local function ensureTracer(player)
    if TracerCache[player] then return TracerCache[player] end
    local line = newFrame({
        BackgroundTransparency = Settings.AlphaTracer,
        BackgroundColor3 = Settings.ColorTracer,
        Size = UDim2.new(0, 1, 0, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ESPGui,
        Visible = false,
    })
    TracerCache[player] = { Frame = line }
    return TracerCache[player]
end
local function destroyTracer(player)
    local t = TracerCache[player]
    if t and t.Frame then t.Frame:Destroy() end
    TracerCache[player] = nil
end
trackConn(Players.PlayerRemoving:Connect(destroyTracer))

local SkeletonCache = {}
local function ensureSkeleton(player)
    if SkeletonCache[player] then return SkeletonCache[player] end
    local bones = {}
    for i = 1, 8 do
        local line = newFrame({
            BackgroundTransparency = Settings.AlphaSkeleton,
            BackgroundColor3 = Settings.ColorSkeleton,
            Size = UDim2.new(0, 1, 0, 1),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = ESPGui,
            Visible = false,
        })
        bones[i] = line
    end
    SkeletonCache[player] = bones
    return bones
end
local function destroySkeleton(player)
    local b = SkeletonCache[player]
    if b then for _, l in ipairs(b) do l:Destroy() end end
    SkeletonCache[player] = nil
end
trackConn(Players.PlayerRemoving:Connect(destroySkeleton))

local function drawLine(frame, fromPos, toPos, color, transparency)
    if not frame then return end
    if not fromPos or not toPos then frame.Visible = false; return end
    local delta = toPos - fromPos
    local length = delta.Magnitude
    if length < 1 then frame.Visible = false; return end
    local center = (fromPos + toPos) / 2
    local angle = math.deg(math.atan2(delta.Y, delta.X))
    frame.Visible = true
    frame.Position = UDim2.fromOffset(center.X, center.Y)
    frame.Size = UDim2.fromOffset(length, 1.5)
    frame.Rotation = angle
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency
end

-- ═══════════════════════════════════════════════════════════════
--  ESP PREVIEW (right of menu, always built)
-- ═══════════════════════════════════════════════════════════════
local Preview = {
    frame     = nil,
    gridHolder= nil,
    viewport  = nil,
    model     = nil,
    camera    = nil,
    rotY      = 0.6,
    rotX      = -0.15,
    gridLines = {},
    nameLbl   = nil,
    hpBack    = nil,
    hpFill    = nil,
    boxOutline= nil,
    boxStroke = nil,
    dragging  = false,
    lastM     = nil,
}

local function buildPreviewCharacter(modelKind)
    if Preview.model then Preview.model:Destroy() end
    local m = Instance.new("Model")
    m.Name = "PreviewModel"

    local skin  = Color3.fromRGB(255, 220, 180)
    local shirt = Color3.fromRGB(80, 120, 220)
    local pants = Color3.fromRGB(40, 60, 100)

    if modelKind == "R6 Blocky" then
        local torso = Instance.new("Part", m); torso.Name = "Torso"
        torso.Size = Vector3.new(2, 2, 1); torso.Color = shirt
        torso.Anchored = true; torso.CanCollide = false
        torso.Position = Vector3.new(0, 0, 0)
        m.PrimaryPart = torso

        local head = Instance.new("Part", m); head.Name = "Head"
        head.Size = Vector3.new(1.5, 1.5, 1.5); head.Shape = Enum.PartType.Ball; head.Color = skin
        head.Anchored = true; head.CanCollide = false
        head.Position = torso.Position + Vector3.new(0, 1.75, 0)

        local la = Instance.new("Part", m); la.Name = "Left Arm"
        la.Size = Vector3.new(1, 2, 1); la.Color = shirt
        la.Anchored = true; la.CanCollide = false
        la.Position = torso.Position + Vector3.new(-1.5, 0, 0)
        local ra = Instance.new("Part", m); ra.Name = "Right Arm"
        ra.Size = Vector3.new(1, 2, 1); ra.Color = shirt
        ra.Anchored = true; ra.CanCollide = false
        ra.Position = torso.Position + Vector3.new(1.5, 0, 0)

        local ll = Instance.new("Part", m); ll.Name = "Left Leg"
        ll.Size = Vector3.new(1, 2, 1); ll.Color = pants
        ll.Anchored = true; ll.CanCollide = false
        ll.Position = torso.Position + Vector3.new(-0.5, -2, 0)
        local rl = Instance.new("Part", m); rl.Name = "Right Leg"
        rl.Size = Vector3.new(1, 2, 1); rl.Color = pants
        rl.Anchored = true; rl.CanCollide = false
        rl.Position = torso.Position + Vector3.new(0.5, -2, 0)

    elseif modelKind == "R15 Blocky" then
        local hum = Instance.new("Part", m); hum.Name = "UpperTorso"
        hum.Size = Vector3.new(2, 2, 1); hum.Color = shirt
        hum.Anchored = true; hum.CanCollide = false
        hum.Position = Vector3.new(0, 0, 0)
        m.PrimaryPart = hum

        local lower = Instance.new("Part", m); lower.Name = "LowerTorso"
        lower.Size = Vector3.new(2, 1, 1); lower.Color = shirt
        lower.Anchored = true; lower.CanCollide = false
        lower.Position = hum.Position + Vector3.new(0, -1.5, 0)

        local head = Instance.new("Part", m); head.Name = "Head"
        head.Size = Vector3.new(1.5, 1.5, 1.5); head.Shape = Enum.PartType.Ball; head.Color = skin
        head.Anchored = true; head.CanCollide = false
        head.Position = hum.Position + Vector3.new(0, 1.75, 0)

        local la = Instance.new("Part", m); la.Name = "LeftUpperArm"
        la.Size = Vector3.new(1, 1.5, 1); la.Color = shirt
        la.Anchored = true; la.CanCollide = false
        la.Position = hum.Position + Vector3.new(-1.5, 0.3, 0)
        local ra = Instance.new("Part", m); ra.Name = "RightUpperArm"
        ra.Size = Vector3.new(1, 1.5, 1); ra.Color = shirt
        ra.Anchored = true; ra.CanCollide = false
        ra.Position = hum.Position + Vector3.new(1.5, 0.3, 0)

        local ll = Instance.new("Part", m); ll.Name = "LeftUpperLeg"
        ll.Size = Vector3.new(1, 1.8, 1); ll.Color = pants
        ll.Anchored = true; ll.CanCollide = false
        ll.Position = lower.Position + Vector3.new(-0.5, -1.8, 0)
        local rl = Instance.new("Part", m); rl.Name = "RightUpperLeg"
        rl.Size = Vector3.new(1, 1.8, 1); rl.Color = pants
        rl.Anchored = true; rl.CanCollide = false
        rl.Position = lower.Position + Vector3.new(0.5, -1.8, 0)

    elseif modelKind == "Cylinder" then
        local body = Instance.new("Part", m); body.Name = "Torso"
        body.Shape = Enum.PartType.Cylinder
        body.Size = Vector3.new(1.5, 2, 2); body.Color = shirt
        body.Anchored = true; body.CanCollide = false
        body.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
        m.PrimaryPart = body

        local head = Instance.new("Part", m); head.Name = "Head"
        head.Shape = Enum.PartType.Ball
        head.Size = Vector3.new(1.5, 1.5, 1.5); head.Color = skin
        head.Anchored = true; head.CanCollide = false
        head.Position = Vector3.new(0, 1.75, 0)
    end

    m.Parent = Preview.viewport
    Preview.model = m
end

local function buildPreviewPanel()
    if Preview.frame then return end

    local f = Instance.new("Frame")
    f.Name = "MellPreview"
    f.Size = UDim2.fromOffset(200, 300)
    f.BackgroundColor3 = Settings.ColorPanel
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0
    f.ZIndex = 5
    f.Visible = false
    f.Parent = PreviewGui
    trackObj(f)
    Preview.frame = f

    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 14); c.Parent = f
    local s = Instance.new("UIStroke"); s.Color = Settings.ColorMenu; s.Thickness = 1.5; s.Transparency = 0.25; s.Parent = f

    local header = Instance.new("TextLabel")
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 20)
    header.Position = UDim2.new(0, 0, 0, -22)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 13
    header.TextColor3 = Settings.ColorMenu
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = "  ESP PREVIEW"
    header.Parent = f

    local gridHolder = Instance.new("Frame")
    gridHolder.Size = UDim2.new(1, -12, 1, -12)
    gridHolder.Position = UDim2.fromOffset(6, 6)
    gridHolder.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
    gridHolder.BackgroundTransparency = 0.1
    gridHolder.BorderSizePixel = 0
    gridHolder.ClipsDescendants = true
    gridHolder.Parent = f
    Preview.gridHolder = gridHolder

    local ghc = Instance.new("UICorner"); ghc.CornerRadius = UDim.new(0, 10); ghc.Parent = gridHolder

    for i = 1, 12 do
        local isH = i <= 6
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(60, 80, 100)
        line.BackgroundTransparency = 0.85
        line.BorderSizePixel = 0
        if isH then
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, (i-1)/5.5, 0)
        else
            line.Size = UDim2.new(0, 1, 1, 0)
            line.Position = UDim2.new((i-7)/5.5, 0, 0, 0)
        end
        line.Parent = gridHolder
        table.insert(Preview.gridLines, line)
    end

    local vp = Instance.new("ViewportFrame")
    vp.Name = "PreviewViewport"
    vp.Size = UDim2.fromScale(1, 1)
    vp.BackgroundTransparency = 1
    vp.Ambient = Color3.fromRGB(180, 180, 200)
    vp.LightColor = Color3.fromRGB(255, 255, 255)
    vp.LightDirection = Vector3.new(-0.5, -1, -0.5)
    vp.Parent = gridHolder
    Preview.viewport = vp

    local cam = Instance.new("Camera")
    cam.FieldOfView = 50
    cam.CFrame = CFrame.new(Vector3.new(0, 1, 8), Vector3.new(0, 1, 0))
    vp.CurrentCamera = cam
    Preview.camera = cam

    local overlay = Instance.new("Frame")
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Parent = gridHolder

    local boxOutline = Instance.new("Frame")
    boxOutline.BackgroundTransparency = 1
    boxOutline.Size = UDim2.new(0, 90, 0, 180)
    boxOutline.Position = UDim2.new(0.5, -45, 0.5, -90)
    boxOutline.Parent = overlay
    boxOutline.Visible = false
    Preview.boxOutline = boxOutline
    local bstroke = Instance.new("UIStroke")
    bstroke.Color = Settings.ColorBox
    bstroke.Thickness = 1.5
    bstroke.Parent = boxOutline
    Preview.boxStroke = bstroke

    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundTransparency = 1
    nameLbl.Size = UDim2.new(1, 0, 0, 16)
    nameLbl.Position = UDim2.new(0, 0, 0.5, -105)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = Settings.ColorName
    nameLbl.TextStrokeTransparency = 0.4
    nameLbl.Text = "PreviewPlayer"
    nameLbl.Visible = false
    nameLbl.Parent = overlay
    Preview.nameLbl = nameLbl

    local hpBack = Instance.new("Frame")
    hpBack.BackgroundColor3 = Settings.ColorHPEmpty
    hpBack.Size = UDim2.new(0, 4, 0, 180)
    hpBack.Position = UDim2.new(0.5, -50, 0.5, -90)
    hpBack.BorderSizePixel = 0
    hpBack.Visible = false
    hpBack.Parent = overlay
    Preview.hpBack = hpBack
    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = Settings.ColorHPFull
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.Position = UDim2.new(0, 0, 0, 0)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBack
    Preview.hpFill = hpFill

    buildPreviewCharacter(Settings.PreviewModel)

    -- Drag rotate
    local dragging = false
    local lastM = nil
    vp.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            lastM = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    vp.InputChanged:Connect(function(input)
        if not Settings.Preview3D then return end
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local cur = Vector2.new(input.Position.X, input.Position.Y)
            if lastM then
                local d = cur - lastM
                Preview.rotY = Preview.rotY - d.X * 0.01
                Preview.rotX = math.clamp(Preview.rotX - d.Y * 0.01, -1.2, 1.2)
            end
            lastM = cur
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            lastM = nil
        end
    end)
end

-- Build preview immediately (so it always exists)
buildPreviewPanel()

-- Position preview right next to menu window
local function positionPreview()
    if not Preview.frame then return end
    if not Settings.PreviewEnabled then
        Preview.frame.Visible = false
        return
    end
    Preview.frame.Visible = true

    local menuGui = WindUI and WindUI.ScreenGui
    local menuFrame = nil
    if menuGui then
        for _, d in ipairs(menuGui:GetDescendants()) do
            if d:IsA("Frame") and d.Name:lower():find("main") then
                menuFrame = d
                break
            end
        end
        if not menuFrame then
            for _, d in ipairs(menuGui:GetDescendants()) do
                if d:IsA("Frame") and d.AbsoluteSize.X > 200 and d.AbsoluteSize.Y > 200 then
                    menuFrame = d
                    break
                end
            end
        end
    end

    if menuFrame then
        local pos = menuFrame.AbsolutePosition
        local size = menuFrame.AbsoluteSize
        local px = pos.X + size.X + Settings.PreviewOffsetX
        local py = pos.Y
        local vw = Camera.ViewportSize.X
        if px + 200 > vw then
            px = math.max(0, pos.X - 200 - Settings.PreviewOffsetX)
        end
        Preview.frame.Position = UDim2.fromOffset(px, py)
        Preview.frame.Size = UDim2.fromOffset(200, math.max(260, size.Y))
    else
        Preview.frame.Position = UDim2.new(0, 20, 0, 100)
    end
end

-- ═══════════════════════════════════════════════════════════════
--  CROSSHAIR / WATERMARK / BULLET TRACERS / FOV
-- ═══════════════════════════════════════════════════════════════
local crosshairParts = {}
for i = 1, 4 do
    crosshairParts[i] = newFrame({
        BackgroundTransparency = Settings.AlphaCrosshair,
        BackgroundColor3 = Settings.ColorCrosshair,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ESPGui,
        Visible = false,
    })
end

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Name = "MellWatermark"
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Size = UDim2.fromOffset(400, 24)
watermarkLabel.Position = UDim2.fromOffset(20, 20)
watermarkLabel.Font = Enum.Font.GothamBold
watermarkLabel.TextSize = 15
watermarkLabel.TextColor3 = Color3.fromRGB(255,255,255)
watermarkLabel.TextStrokeTransparency = 0.4
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
watermarkLabel.Text = "MellHack | @ruzoxu"
watermarkLabel.Parent = ESPGui
trackObj(watermarkLabel)

local fpsCounter = { count = 0, last = tick(), fps = 0 }
trackConn(RunService.RenderStepped:Connect(function()
    fpsCounter.count = fpsCounter.count + 1
    local now = tick()
    if now - fpsCounter.last >= 1 then
        fpsCounter.fps = fpsCounter.count
        fpsCounter.count = 0
        fpsCounter.last = now
    end
end))

trackConn(RunService.RenderStepped:Connect(function()
    watermarkLabel.Visible = Settings.Watermark
    if Settings.Watermark then
        local server = Players:GetPlayers()
        watermarkLabel.Text = string.format("MellHack v14 | %s | %d FPS | %d players",
            LocalPlayer.Name, fpsCounter.fps, #server)
        watermarkLabel.TextColor3 = Settings.ColorText
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  UI TABS
-- ═══════════════════════════════════════════════════════════════
local function notifyState(name, enabled)
    WindUI:Notify({
        Title = "MellHack",
        Content = name .. (enabled and " ON" or " OFF"),
        Icon = enabled and "check" or "x",
        Duration = 2,
    })
end

local TabMovement = Window:Tab({ Title = "Movement",   Icon = "move" })
local TabCombat   = Window:Tab({ Title = "Combat",     Icon = "crosshair" })
local TabVisuals  = Window:Tab({ Title = "Visuals",    Icon = "eye" })
local TabColors   = Window:Tab({ Title = "Colors",     Icon = "palette" })
local TabConfig   = Window:Tab({ Title = "Configs",    Icon = "save" })
local TabDrone    = Window:Tab({ Title = "Drone",      Icon = "plane" })
local TabExtras   = Window:Tab({ Title = "Extras",     Icon = "sparkles" })
local TabShaders  = Window:Tab({ Title = "Shaders",    Icon = "sun" })
local TabRage     = Window:Tab({ Title = "Rage & Fun", Icon = "bomb" })
local TabBinds    = Window:Tab({ Title = "Keybinds",   Icon = "keyboard" })
local TabSettings = Window:Tab({ Title = "Settings",   Icon = "settings" })

TabMovement:Section({ Title = "Character Physics" })
TabMovement:Toggle({ Title = "Fly", Value = false, Callback = function(v) Settings.Fly = v; notifyState("Fly", v) end })
TabMovement:Slider({ Title = "Fly Speed", Value = { Min = 10, Max = 300, Default = 127 },
    Callback = function(v) Settings.FlySpeed = v; if _G.fly_rp then _G.fly_rp.MaxSpeed = v end end })
TabMovement:Toggle({ Title = "SpeedHack", Value = false,
    Callback = function(v)
        Settings.Speed = v; notifyState("SpeedHack", v)
        if not v and LocalPlayer.Character then
            local hum = getHumanoid(LocalPlayer.Character)
            if hum then hum.WalkSpeed = 16 end
        end
    end })
TabMovement:Slider({ Title = "WalkSpeed", Value = { Min = 16, Max = 400, Default = 80 },
    Callback = function(v) Settings.WalkSpeedVal = v end })
TabMovement:Toggle({ Title = "Super Jump", Value = false,
    Callback = function(v)
        Settings.Jump = v; notifyState("Super Jump", v)
        if not v and LocalPlayer.Character then
            local hum = getHumanoid(LocalPlayer.Character)
            if hum then hum.JumpPower = 50 end
        end
    end })
TabMovement:Slider({ Title = "Jump Height", Value = { Min = 50, Max = 800, Default = 250 },
    Callback = function(v) Settings.JumpPowerVal = v end })

TabMovement:Section({ Title = "Advanced Movement" })
TabMovement:Toggle({ Title = "Auto-Bhop", Value = false, Callback = function(v) Settings.Bhop = v; notifyState("Bhop", v) end })
TabMovement:Toggle({ Title = "Air Strafes", Value = false, Callback = function(v) Settings.Strafes = v; notifyState("Strafes", v) end })
TabMovement:Slider({ Title = "Strafe Speed", Value = { Min = 10, Max = 100, Default = 35 }, Callback = function(v) Settings.StrafeSpeed = v end })
TabMovement:Toggle({ Title = "Pixel Surf", Value = false, Callback = function(v) Settings.PixelSurf = v end })
TabMovement:Toggle({ Title = "Long Jump", Value = false, Callback = function(v) Settings.LongJump = v end })
TabMovement:Toggle({ Title = "Super Glide", Value = false, Callback = function(v) Settings.SuperGlide = v end })
TabMovement:Toggle({ Title = "Wall Hop", Value = false, Callback = function(v) Settings.WallHop = v end })
TabMovement:Toggle({ Title = "Wall Climb", Value = false, Callback = function(v) Settings.WallClimb = v end })
TabMovement:Toggle({ Title = "Air Boost", Value = false, Callback = function(v) Settings.AirBoost = v end })
TabMovement:Toggle({ Title = "Edge Bug", Value = false, Callback = function(v) Settings.EdgeBug = v end })
TabMovement:Toggle({ Title = "Infinite Jump", Value = false, Callback = function(v) Settings.InfiniteJump = v end })
TabMovement:Toggle({ Title = "No Fall Damage", Value = false, Callback = function(v) Settings.NoFallDamage = v end })
TabMovement:Toggle({ Title = "Auto Respawn", Value = false, Callback = function(v) Settings.AutoRespawn = v end })
TabMovement:Toggle({ Title = "Noclip", Value = false,
    Callback = function(v)
        Settings.Noclip = v; notifyState("Noclip", v)
        if not v and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end })

-- ═══════════════════════════════════════════════════════════════
--  AIMBOT (enhanced)
-- ═══════════════════════════════════════════════════════════════
local AimbotState = {
    target = nil,
    targetLastSeen = 0,
    switchCooldown = 0,
}

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
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = { char, targetPart.Parent }
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local result = Workspace:Raycast(origin, targetPart.Position - origin, rp)
    return result == nil
end
local function isTriggerVisible(targetPart)
    if not Settings.TriggerbotWallCheck then return true end
    return isVisible(targetPart)
end

local function getAimPart(player)
    local char = player.Character
    if not char then return nil end
    if Settings.AimPart == "Head" then
        return char:FindFirstChild("Head")
    elseif Settings.AimPart == "Torso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    else
        local best, bestDist
        local mouse = UserInputService:GetMouseLocation()
        for _, partName in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart"}) do
            local part = char:FindFirstChild(partName)
            if part then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                    if not bestDist or d < bestDist then
                        bestDist = d
                        best = part
                    end
                end
            end
        end
        return best or char:FindFirstChild("HumanoidRootPart")
    end
end

local function findAimbotTarget()
    local bestPart, bestDst = nil, Settings.AimFOV
    local mouse = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isEnemy(p) and p.Character then
            local hum = getHumanoid(p.Character)
            if hum and hum.Health > 0 then
                local part = getAimPart(p)
                if part and isVisible(part) then
                    local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                        if d < bestDst then
                            bestDst = d
                            bestPart = part
                        end
                    end
                end
            end
        end
    end
    return bestPart
end

trackConn(RunService.RenderStepped:Connect(function(dt)
    if not getgenv().MellHackLoaded then return end
    if not Settings.Aimbot then
        AimbotState.target = nil
        return
    end
    if Drone.active then return end

    AimbotState.switchCooldown = math.max(0, AimbotState.switchCooldown - dt)

    local part = findAimbotTarget()
    if part then
        AimbotState.target = part
        AimbotState.targetLastSeen = tick()
    elseif AimbotState.target and tick() - AimbotState.targetLastSeen > 0.35 then
        AimbotState.target = nil
    end

    if AimbotState.target and AimbotState.target.Parent then
        local targetPos = AimbotState.target.Position
        if Settings.AimPrediction > 0 then
            targetPos = targetPos + (AimbotState.target.AssemblyLinearVelocity * Settings.AimPrediction)
        end
        local goalCF = CFrame.new(Camera.CFrame.Position, targetPos)
        local smoothFactor = 1 / math.clamp(Settings.AimSmooth, 1, 100)
        Camera.CFrame = Camera.CFrame:Lerp(goalCF, smoothFactor)
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  SILENT AIM
-- ═══════════════════════════════════════════════════════════════
pcall(function()
    if not hookmetamethod or not getnamecallmethod then return end
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not getgenv().MellHackLoaded or not Settings.SilentAim then
            return oldNamecall(self, ...)
        end
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" or method == "InvokeServer" then
            local targetPart, minDst = nil, Settings.AimFOV
            local mousePos = UserInputService:GetMouseLocation()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and isEnemy(p) and p.Character then
                    local hum = getHumanoid(p.Character)
                    if hum and hum.Health > 0 then
                        local part = getAimPart(p)
                        if part and isVisible(part) then
                            if Settings.AimHitChance < 100 and math.random(1, 100) > Settings.AimHitChance then
                                continue
                            end
                            local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local dst = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                                if dst < minDst then minDst = dst; targetPart = part end
                            end
                        end
                    end
                end
            end
            if targetPart then
                local predictedPos = targetPart.Position
                if Settings.AimPrediction > 0 then
                    predictedPos = targetPart.Position + (targetPart.AssemblyLinearVelocity * Settings.AimPrediction)
                end
                for i, arg in pairs(args) do
                    if typeof(arg) == "Vector3" then
                        args[i] = predictedPos
                    elseif typeof(arg) == "CFrame" then
                        args[i] = CFrame.new(arg.Position, predictedPos)
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
end)

TabCombat:Section({ Title = "Aimbot" })
TabCombat:Toggle({ Title = "Aimbot (Cam Lock)", Value = false, Callback = function(v) Settings.Aimbot = v; notifyState("Aimbot", v) end })
TabCombat:Toggle({ Title = "Silent Aim", Value = false, Callback = function(v) Settings.SilentAim = v; notifyState("Silent Aim", v) end })
TabCombat:Toggle({ Title = "Wall Check", Value = true, Callback = function(v) Settings.WallCheck = v end })
TabCombat:Toggle({ Title = "Team Check", Value = true, Callback = function(v) Settings.TeamCheck = v end })
TabCombat:Dropdown({ Title = "Aim Part", Values = { "Head", "Torso", "Closest" }, Value = "Head",
    Callback = function(v) Settings.AimPart = v end })
TabCombat:Slider({ Title = "Aim FOV", Value = { Min = 50, Max = 1000, Default = 350 }, Callback = function(v) Settings.AimFOV = v end })
TabCombat:Slider({ Title = "Aim Smooth", Value = { Min = 1, Max = 20, Default = 4 }, Callback = function(v) Settings.AimSmooth = v end })
TabCombat:Slider({ Title = "Aim Prediction", Value = { Min = 0, Max = 1, Default = 0.15 }, Callback = function(v) Settings.AimPrediction = v end })
TabCombat:Slider({ Title = "Hit Chance %", Value = { Min = 0, Max = 100, Default = 100 }, Callback = function(v) Settings.AimHitChance = v end })
TabCombat:Toggle({ Title = "Draw FOV", Value = true, Callback = function(v) Settings.DrawFOV = v end })

TabCombat:Section({ Title = "Triggerbot" })
TabCombat:Toggle({ Title = "Triggerbot", Value = false, Callback = function(v) Settings.Triggerbot = v; notifyState("Triggerbot", v) end })
TabCombat:Toggle({ Title = "Wall Check", Value = true, Callback = function(v) Settings.TriggerbotWallCheck = v end })
TabCombat:Slider({ Title = "Trigger FOV", Value = { Min = 30, Max = 500, Default = 150 }, Callback = function(v) Settings.TriggerbotFOV = v end })
TabCombat:Slider({ Title = "Trigger Delay", Value = { Min = 0.0, Max = 1, Default = 0.05 }, Callback = function(v) Settings.TriggerbotDelay = v end })

TabCombat:Section({ Title = "Other Combat" })
TabCombat:Toggle({ Title = "Autoclicker", Value = false, Callback = function(v) Settings.Autoclicker = v end })
TabCombat:Slider({ Title = "CPS", Value = { Min = 1, Max = 50, Default = 15 }, Callback = function(v) Settings.AutoclickerCPS = v end })
TabCombat:Toggle({ Title = "Killaura", Value = false, Callback = function(v) Settings.Killaura = v; notifyState("Killaura", v) end })
TabCombat:Slider({ Title = "Killaura Range", Value = { Min = 5, Max = 60, Default = 20 }, Callback = function(v) Settings.KillauraRange = v end })
TabCombat:Toggle({ Title = "Hitbox Expander", Value = false,
    Callback = function(v)
        Settings.HitboxExpander = v; notifyState("Hitbox Expander", v)
        if not v then
            for _, p in pairs(Players:GetPlayers()) do
                local head = getHead(p.Character)
                if head then head.Size = Vector3.new(2, 1, 1); head.Transparency = 0 end
            end
        end
    end })
TabCombat:Slider({ Title = "Hitbox Size", Value = { Min = 2, Max = 40, Default = 8 }, Callback = function(v) Settings.HitboxSize = v end })

-- ═══════════════════════════════════════════════════════════════
--  VISUALS TAB
-- ═══════════════════════════════════════════════════════════════
TabVisuals:Section({ Title = "ESP" })
TabVisuals:Toggle({ Title = "ESP Boxes", Value = true, Callback = function(v) Settings.ESPBox = v end })
TabVisuals:Toggle({ Title = "HP Bar", Value = true, Callback = function(v) Settings.HPBar = v end })
TabVisuals:Toggle({ Title = "Tracers", Value = true, Callback = function(v) Settings.Tracers = v end })
TabVisuals:Toggle({ Title = "Skeleton ESP", Value = true, Callback = function(v) Settings.SkeletonESP = v end })
TabVisuals:Toggle({ Title = "Name ESP", Value = true, Callback = function(v) Settings.NameESP = v end })

TabVisuals:Section({ Title = "Chams" })
TabVisuals:Toggle({ Title = "Player Chams", Value = true, Callback = function(v) Settings.Chams = v; if not v then clearAllChams() end end })
TabVisuals:Toggle({ Title = "Local Chams", Value = false, Callback = function(v)
    Settings.LocalChams = v
    if LocalPlayer.Character then applyChamsToCharacter(LocalPlayer.Character, true) end
end })
TabVisuals:Dropdown({
    Title = "Chams Type",
    Values = { "Highlight", "ForceField" },
    Value = "Highlight",
    Callback = function(v) Settings.ChamsType = v end,
})
TabVisuals:Dropdown({
    Title = "Chams Shader",
    Values = { "Flat", "Lit", "Clay", "Glass", "Crystal", "Ice", "Prism", "Heat", "Core" },
    Value = "Flat",
    Callback = function(v) Settings.ChamsShader = v end,
})
TabVisuals:Dropdown({
    Title = "Local Chams Shader",
    Values = { "Flat", "Lit", "Clay", "Glass", "Crystal", "Ice", "Prism", "Heat", "Core" },
    Value = "Flat",
    Callback = function(v) Settings.LocalChamsShader = v end,
})
TabVisuals:Toggle({ Title = "Chams Wall Pierce", Value = false, Callback = function(v) Settings.ChamsWallOccluded = v end })

TabVisuals:Section({ Title = "ESP Preview" })
TabVisuals:Toggle({
    Title = "Enable ESP Preview",
    Value = true,
    Callback = function(v)
        Settings.PreviewEnabled = v
        if Preview.frame then Preview.frame.Visible = v end
    end,
})
TabVisuals:Toggle({
    Title = "3D Preview (rotate with mouse)",
    Value = true,
    Callback = function(v) Settings.Preview3D = v end,
})
TabVisuals:Dropdown({
    Title = "Preview Model",
    Values = { "R6 Blocky", "R15 Blocky", "Cylinder" },
    Value = "R6 Blocky",
    Callback = function(v)
        Settings.PreviewModel = v
        if Preview.viewport then buildPreviewCharacter(v) end
    end,
})
TabVisuals:Slider({
    Title = "Preview Zoom",
    Value = { Min = 4, Max = 20, Default = 8 },
    Callback = function(v) Settings.PreviewZoom = v end,
})
TabVisuals:Toggle({ Title = "Preview Box", Value = true, Callback = function(v) Settings.PreviewBox = v end })
TabVisuals:Toggle({ Title = "Preview Name", Value = true, Callback = function(v) Settings.PreviewName = v end })
TabVisuals:Toggle({ Title = "Preview HP Bar", Value = true, Callback = function(v) Settings.PreviewHP = v end })
TabVisuals:Toggle({ Title = "Preview Chams", Value = false, Callback = function(v) Settings.PreviewChams = v end })

TabVisuals:Section({ Title = "Screen" })
TabVisuals:Toggle({ Title = "Crosshair", Value = false, Callback = function(v) Settings.Crosshair = v end })
TabVisuals:Toggle({ Title = "Bullet Tracers", Value = false, Callback = function(v) Settings.BulletTracers = v end })
TabVisuals:Toggle({ Title = "FOV Changer", Value = false, Callback = function(v) Settings.FOVChanger = v end })
TabVisuals:Slider({ Title = "Game FOV", Value = { Min = 30, Max = 120, Default = 90 }, Callback = function(v) Settings.CustomFOV = v end })
TabVisuals:Toggle({ Title = "Watermark", Value = true, Callback = function(v) Settings.Watermark = v end })

-- ═══════════════════════════════════════════════════════════════
--  COLORS TAB
-- ═══════════════════════════════════════════════════════════════
TabColors:Section({ Title = "Menu" })
TabColors:Colorpicker({ Title = "Accent", Default = Settings.ColorMenu, Transparency = Settings.AlphaMenu,
    Callback = function(c, a) Settings.ColorMenu = c; if a then Settings.AlphaMenu = a end; ApplyMenuColorsToTheme() end })
TabColors:Colorpicker({ Title = "Window Background", Default = Settings.ColorWindow, Transparency = Settings.AlphaWindow,
    Callback = function(c, a) Settings.ColorWindow = c; if a then Settings.AlphaWindow = a end; ApplyMenuColorsToTheme() end })
TabColors:Colorpicker({ Title = "Panel Background", Default = Settings.ColorPanel, Transparency = Settings.AlphaPanel,
    Callback = function(c, a) Settings.ColorPanel = c; if a then Settings.AlphaPanel = a end; ApplyMenuColorsToTheme() end })
TabColors:Colorpicker({ Title = "Text", Default = Settings.ColorText, Transparency = Settings.AlphaText,
    Callback = function(c, a) Settings.ColorText = c; if a then Settings.AlphaText = a end; ApplyMenuColorsToTheme() end })
TabColors:Colorpicker({ Title = "Sub Text", Default = Settings.ColorSubText, Transparency = Settings.AlphaSubText,
    Callback = function(c, a) Settings.ColorSubText = c; if a then Settings.AlphaSubText = a end; ApplyMenuColorsToTheme() end })

TabColors:Section({ Title = "ESP" })
TabColors:Colorpicker({ Title = "Box", Default = Settings.ColorBox, Transparency = Settings.AlphaBox,
    Callback = function(c, a) Settings.ColorBox = c; if a then Settings.AlphaBox = a end end })
TabColors:Colorpicker({ Title = "Tracer", Default = Settings.ColorTracer, Transparency = Settings.AlphaTracer,
    Callback = function(c, a) Settings.ColorTracer = c; if a then Settings.AlphaTracer = a end end })
TabColors:Colorpicker({ Title = "Skeleton", Default = Settings.ColorSkeleton, Transparency = Settings.AlphaSkeleton,
    Callback = function(c, a) Settings.ColorSkeleton = c; if a then Settings.AlphaSkeleton = a end end })
TabColors:Colorpicker({ Title = "Name", Default = Settings.ColorName, Transparency = Settings.AlphaName,
    Callback = function(c, a) Settings.ColorName = c; if a then Settings.AlphaName = a end end })
TabColors:Colorpicker({ Title = "HP Full", Default = Settings.ColorHPFull, Transparency = Settings.AlphaHPFull,
    Callback = function(c, a) Settings.ColorHPFull = c; if a then Settings.AlphaHPFull = a end end })
TabColors:Colorpicker({ Title = "HP Empty", Default = Settings.ColorHPEmpty, Transparency = Settings.AlphaHPEmpty,
    Callback = function(c, a) Settings.ColorHPEmpty = c; if a then Settings.AlphaHPEmpty = a end end })
TabColors:Colorpicker({ Title = "FOV Circle", Default = Settings.ColorFOV, Transparency = Settings.AlphaFOV,
    Callback = function(c, a) Settings.ColorFOV = c; if a then Settings.AlphaFOV = a end end })
TabColors:Colorpicker({ Title = "Crosshair", Default = Settings.ColorCrosshair, Transparency = Settings.AlphaCrosshair,
    Callback = function(c, a) Settings.ColorCrosshair = c; if a then Settings.AlphaCrosshair = a end end })
TabColors:Colorpicker({ Title = "Bullet Tracer", Default = Settings.ColorBulletTracer, Transparency = Settings.AlphaBulletTracer,
    Callback = function(c, a) Settings.ColorBulletTracer = c; if a then Settings.AlphaBulletTracer = a end end })

TabColors:Section({ Title = "Chams" })
TabColors:Colorpicker({
    Title = "Chams Fill", Default = Settings.ColorChams, Transparency = Settings.AlphaChams,
    Callback = function(c, a) Settings.ColorChams = c; if a then Settings.AlphaChams = a end end,
})
TabColors:Colorpicker({
    Title = "Chams Outline", Default = Settings.ColorChamsOutline, Transparency = Settings.AlphaChamsOutline,
    Callback = function(c, a) Settings.ColorChamsOutline = c; if a then Settings.AlphaChamsOutline = a end end,
})
TabColors:Colorpicker({
    Title = "Local Chams", Default = Settings.ColorLocalChams, Transparency = Settings.AlphaLocalChams,
    Callback = function(c, a) Settings.ColorLocalChams = c; if a then Settings.AlphaLocalChams = a end end,
})

TabColors:Section({ Title = "Fog" })
TabColors:Colorpicker({
    Title = "Fog Color", Default = Color3.fromRGB(200, 200, 200), Transparency = 0,
    Callback = function(c)
        Settings.FogColor = { math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255) }
    end,
})

-- ═══════════════════════════════════════════════════════════════
--  CONFIG (unchanged helpers)
-- ═══════════════════════════════════════════════════════════════
local CONFIG_ROOT   = "MellHack"
local CONFIG_DIR    = CONFIG_ROOT .. "/configs"
local AUTOLOAD_FILE = CONFIG_ROOT .. "/autoload.txt"

local function ensureDirs()
    if not isfolder then return end
    if not isfolder(CONFIG_ROOT) then pcall(makefolder, CONFIG_ROOT) end
    if not isfolder(CONFIG_DIR) then pcall(makefolder, CONFIG_DIR) end
end
ensureDirs()

local function sanitizeName(name)
    name = tostring(name or ""):gsub("[^%w_%-%s]", "")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if #name == 0 then name = "MellHack" end
    if #name > 50 then name = name:sub(1, 50) end
    return name
end

local function serializeSettings()
    local out = {}
    for k, v in pairs(Settings) do
        if typeof(v) == "Color3" then
            out[k] = { __color = true, r = v.R, g = v.G, b = v.B }
        else
            out[k] = v
        end
    end
    return out
end

local function deserializeSettings(tbl)
    for k, v in pairs(tbl) do
        if type(v) == "table" and v.__color then
            Settings[k] = Color3.new(v.r, v.g, v.b)
        else
            Settings[k] = v
        end
    end
end

local function nextDefaultName()
    local i = 1
    while true do
        local name = string.format("MellHack_%02d", i)
        local path = CONFIG_DIR .. "/" .. name .. ".json"
        if not (isfile and isfile(path)) then return name end
        i = i + 1
        if i > 999 then return "MellHack_" .. tostring(os.time()) end
    end
end

local function configExists(name)
    if not isfile then return false end
    return isfile(CONFIG_DIR .. "/" .. sanitizeName(name) .. ".json")
end

local function saveConfigAs(name)
    if not (writefile and isfolder) then return false end
    ensureDirs()
    name = sanitizeName(name)
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    local payload = {
        __meta = { name = name, created = os.time(), author = LocalPlayer.Name, placeId = game.PlaceId, version = "14.0" },
        settings = serializeSettings(),
    }
    local ok, json = pcall(function() return HttpService:JSONEncode(payload) end)
    if not ok then return false end
    pcall(writefile, path, json)
    return true
end

local function loadConfigByName(name)
    if not (isfile and readfile) then return false end
    name = sanitizeName(name)
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or not data then return false end
    deserializeSettings(data.settings or data)
    ApplyMenuColorsToTheme()
    return true
end

local function deleteConfigByName(name)
    if not (delfile and isfile) then return false end
    name = sanitizeName(name)
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    pcall(delfile, path)
    return true
end

local function listConfigs()
    local out = {}
    if not (listfiles and isfolder) then return out end
    if not isfolder(CONFIG_DIR) then return out end
    for _, f in ipairs(listfiles(CONFIG_DIR)) do
        local name = f:match("([^/\\]+)%.json$")
        if name then table.insert(out, name) end
    end
    table.sort(out)
    return out
end

local function getConfigJSON(name)
    if not (isfile and readfile) then return nil end
    name = sanitizeName(name)
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local ok, content = pcall(readfile, path)
    if ok then return content end
    return nil
end

local function copyConfigToClipboard(name)
    local json = getConfigJSON(name)
    if not json then return false end
    if setclipboard then
        pcall(setclipboard, json)
        WindUI:Notify({ Title = "MellHack", Content = "JSON copied: " .. name, Icon = "check", Duration = 3 })
        return true
    end
    return false
end

local function importConfigFromJSON(json, saveAs)
    if not (writefile and isfolder) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or not data then
        WindUI:Notify({ Title = "MellHack", Content = "Invalid JSON", Icon = "x", Duration = 4 })
        return false
    end
    ensureDirs()
    local name
    if saveAs and #saveAs > 0 then
        name = sanitizeName(saveAs)
        if configExists(name) then name = name .. "_" .. tostring(os.time() % 10000) end
    else
        name = (data.__meta and sanitizeName(data.__meta.name)) or nextDefaultName()
        if configExists(name) then name = name .. "_" .. tostring(os.time() % 10000) end
    end
    local payload
    if data.settings then
        payload = data
        payload.__meta = payload.__meta or { name = name, created = os.time(), version = "14.0" }
        payload.__meta.name = name
    else
        payload = { __meta = { name = name, created = os.time(), version = "14.0" }, settings = data }
    end
    local encOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encOk then return false end
    pcall(writefile, CONFIG_DIR .. "/" .. name .. ".json", encoded)
    WindUI:Notify({ Title = "MellHack", Content = "Imported: " .. name, Icon = "check", Duration = 3 })
    return true
end

local function getAutoLoadName()
    if not (isfile and readfile) then return nil end
    if not isfile(AUTOLOAD_FILE) then return nil end
    local ok, name = pcall(readfile, AUTOLOAD_FILE)
    if ok and name and #name > 0 then return name end
    return nil
end
local function setAutoLoadName(name)
    if not writefile then return end
    ensureDirs()
    pcall(writefile, AUTOLOAD_FILE, tostring(name or ""))
end

local autoName = getAutoLoadName()
if autoName and #autoName > 0 and configExists(autoName) then
    task.defer(function()
        task.wait(1)
        loadConfigByName(autoName)
        WindUI:Notify({ Title = "MellHack", Content = "Auto-loaded: " .. autoName, Icon = "check", Duration = 3 })
    end)
end

local renameBuffer = ""
local importBuffer = ""

local function rebuildConfigList()
    local list = listConfigs()
    local text = #list == 0 and "No configs yet" or table.concat(list, ", ")
    WindUI:Notify({ Title = "Configs", Content = text, Icon = "list", Duration = 6 })
    return list
end

TabConfig:Section({ Title = "Save / Import" })
TabConfig:Input({ Title = "New config name (empty = auto)", Placeholder = "MellHack_01",
    Callback = function(text) renameBuffer = text end })
TabConfig:Button({ Title = "Save New Config", Icon = "save", Callback = function()
    local name = renameBuffer
    if not name or #name == 0 then name = nextDefaultName() end
    if configExists(name) then name = name .. "_" .. tostring(os.time() % 10000) end
    if saveConfigAs(name) then
        WindUI:Notify({ Title = "MellHack", Content = "Saved: " .. name, Icon = "check", Duration = 3 })
        rebuildConfigList()
    end
end })
TabConfig:Button({ Title = "Import from clipboard", Icon = "clipboard-paste", Callback = function()
    if not getclipboard then return end
    local ok, clip = pcall(getclipboard)
    if ok and clip and #clip > 10 then importConfigFromJSON(clip, nil) end
end })
TabConfig:Input({ Title = "Paste JSON", Placeholder = '{"settings":{...}}',
    Callback = function(text) importBuffer = text end })
TabConfig:Button({ Title = "Import JSON above", Icon = "import", Callback = function()
    if importBuffer and #importBuffer > 10 then importConfigFromJSON(importBuffer, nil) end
end })
TabConfig:Button({ Title = "Load Current Name", Icon = "folder-open", Callback = function()
    if renameBuffer and #renameBuffer > 0 then loadConfigByName(renameBuffer) end
end })
TabConfig:Button({ Title = "Copy Current as JSON", Icon = "copy", Callback = function()
    if renameBuffer and #renameBuffer > 0 then copyConfigToClipboard(renameBuffer) end
end })
TabConfig:Button({ Title = "Delete Current Name", Icon = "trash", Callback = function()
    if renameBuffer and #renameBuffer > 0 then deleteConfigByName(renameBuffer) end
end })
TabConfig:Button({ Title = "Set Auto-Load", Icon = "power", Callback = function()
    if renameBuffer and #renameBuffer > 0 then setAutoLoadName(renameBuffer) end
end })
TabConfig:Button({ Title = "Disable Auto-Load", Icon = "x", Callback = function() setAutoLoadName("") end })
TabConfig:Button({ Title = "Show Config List", Icon = "list", Callback = rebuildConfigList })

-- ═══════════════════════════════════════════════════════════════
--  DRONE (kept same behavior, minimal touches)
-- ═══════════════════════════════════════════════════════════════
local Drone = {
    model = nil, base = nil, hum = nil, hrp = nil,
    oldCameraType = nil, oldCameraSubject = nil, oldFOV = nil,
    active = false, lastHit = "", hitTimer = 0, props = {},
    destroyed = false, deathTimer = 0,
    currentVel = Vector3.new(0,0,0), droneCF = CFrame.new(),
    fpvShakeOff = Vector3.new(0,0,0), fpvRoll = 0,
    camYaw = 0, camPitch = -0.15,
    soundEngine = nil, soundStartup = nil, soundHit = nil, soundMissile = nil,
    shieldPart = nil, nightVisionEffect = nil,
    lockTarget = nil, hoverBase = nil, laserBeam = nil,
}

local SOUND_ENGINE  = "rbxassetid://9120386436"
local SOUND_STARTUP = "rbxassetid://9125402237"
local SOUND_HIT     = "rbxassetid://9120386675"
local SOUND_MISSILE = "rbxassetid://9114251230"

local function createSounds()
    local engine = Instance.new("Sound")
    engine.Name = "MellDroneEngine"; engine.SoundId = SOUND_ENGINE
    engine.Looped = true; engine.Volume = 0; engine.PlaybackSpeed = 1
    engine.Parent = SoundService; trackObj(engine)
    Drone.soundEngine = engine

    local startup = Instance.new("Sound")
    startup.Name = "MellDroneStartup"; startup.SoundId = SOUND_STARTUP
    startup.Looped = false; startup.Volume = Settings.DroneSoundVolume
    startup.Parent = SoundService; trackObj(startup)
    Drone.soundStartup = startup

    local hitSnd = Instance.new("Sound")
    hitSnd.Name = "MellDroneHit"; hitSnd.SoundId = SOUND_HIT
    hitSnd.Looped = false; hitSnd.Volume = Settings.DroneSoundVolume
    hitSnd.Parent = SoundService; trackObj(hitSnd)
    Drone.soundHit = hitSnd

    local missileSnd = Instance.new("Sound")
    missileSnd.Name = "MellDroneMissile"; missileSnd.SoundId = SOUND_MISSILE
    missileSnd.Looped = false; missileSnd.Volume = Settings.DroneSoundVolume
    missileSnd.Parent = SoundService; trackObj(missileSnd)
    Drone.soundMissile = missileSnd
end

local function buildDroneModel()
    local model = Instance.new("Model")
    model.Name = "MellDroneUltimate"

    local DARK   = Color3.fromRGB(15, 17, 22)
    local DARKER = Color3.fromRGB(8, 9, 12)
    local LIGHT  = Color3.fromRGB(220, 225, 235)
    local GRAY   = Color3.fromRGB(45, 48, 56)
    local ACCENT = Color3.fromRGB(255, 40, 90)

    local core = Instance.new("Part")
    core.Name = "CoreBody"; core.Size = Vector3.new(2.0, 0.6, 3.2)
    core.Color = DARK; core.Material = Enum.Material.Metal
    core.Anchored = true; core.CanCollide = true
    core.Parent = model; model.PrimaryPart = core

    local shield = Instance.new("Part")
    shield.Name = "ShieldDome"; shield.Shape = Enum.PartType.Ball
    shield.Size = Vector3.new(5, 5, 5); shield.Color = Color3.fromRGB(0, 180, 255)
    shield.Material = Enum.Material.Neon; shield.Transparency = 1
    shield.Anchored = true; shield.CanCollide = false
    shield.Parent = model; shield.CFrame = core.CFrame
    Drone.shieldPart = shield

    local laser = Instance.new("Part")
    laser.Name = "LaserBeam"; laser.Size = Vector3.new(0.05, 0.05, 100)
    laser.Color = Color3.fromRGB(255, 0, 0); laser.Material = Enum.Material.Neon
    laser.Transparency = 0.4; laser.Anchored = true; laser.CanCollide = false
    laser.Parent = model; laser.CFrame = core.CFrame * CFrame.new(0, -0.7, -50)
    Drone.laserBeam = laser

    return model
end

local function setDroneCFrame(model, core, targetCF)
    local oldCoreCF = core.CFrame
    local delta = targetCF * oldCoreCF:Inverse()
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CFrame = delta * part.CFrame
        end
    end
end

local function destroyDroneModel()
    if Drone.model then pcall(function() Drone.model:Destroy() end) end
    Drone.model = nil; Drone.base = nil; Drone.props = {}
    Drone.shieldPart = nil; Drone.laserBeam = nil
end

local function setCharacterHidden(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = state and 1 or 0
            p.CanCollide = not state
        elseif p:IsA("Decal") then
            p.Transparency = state and 1 or 0
        end
    end
end

function Drone:Start()
    if self.active then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = getHumanoid(char); local hrp = getRoot(char)
    if not hum or not hrp then return end

    self.hum = hum; self.hrp = hrp
    self.destroyed = false; self.lastHit = ""; self.props = {}
    self.currentVel = Vector3.new(0,0,0)
    self.droneCF = hrp.CFrame * CFrame.new(0, 4, 0)
    self.fpvShakeOff = Vector3.new(0,0,0); self.fpvRoll = 0
    self.hoverBase = self.droneCF.Position.Y

    local lookDir = Camera.CFrame.LookVector
    self.camYaw = math.atan2(-lookDir.X, -lookDir.Z)
    self.camPitch = math.asin(math.clamp(lookDir.Y, -1, 1))

    setCharacterHidden(true)

    local model = buildDroneModel()
    model.Parent = Workspace
    self.model = model; self.base = model.PrimaryPart
    self.base.CFrame = self.droneCF
    setDroneCFrame(model, self.base, self.droneCF)

    if not self.soundEngine then createSounds() end
    if self.soundStartup then
        pcall(function()
            self.soundStartup.Volume = Settings.DroneSoundVolume
            self.soundStartup:Play()
        end)
    end
    if self.soundEngine then
        task.delay(0.4, function()
            pcall(function()
                if Drone.active and Drone.soundEngine then
                    Drone.soundEngine.Volume = Settings.DroneSoundVolume * 0.6
                    Drone.soundEngine:Play()
                end
            end)
        end)
    end

    self.oldCameraType = Camera.CameraType
    self.oldCameraSubject = Camera.CameraSubject
    self.oldFOV = Camera.FieldOfView
    Camera.CameraType = Enum.CameraType.Scriptable
    pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)

    self.active = true
    WindUI:Notify({ Title = "Drone", Content = "Ultimate drone deployed!", Icon = "plane", Duration = 2 })
end

function Drone:Stop()
    if not self.active then return end
    self.active = false; self.destroyed = false
    destroyDroneModel()
    setCharacterHidden(false)

    if self.soundEngine then
        pcall(function()
            TweenService:Create(self.soundEngine, TweenInfo.new(0.4), {Volume = 0}):Play()
        end)
        task.delay(0.5, function()
            pcall(function()
                if Drone.soundEngine then
                    Drone.soundEngine:Stop(); Drone.soundEngine.Volume = 0
                end
            end)
        end)
    end

    pcall(function()
        Camera.CameraType = self.oldCameraType or Enum.CameraType.Custom
        Camera.CameraSubject = self.oldCameraSubject or self.hum
        if self.oldFOV then Camera.FieldOfView = self.oldFOV end
    end)

    if self.nightVisionEffect then
        pcall(function() self.nightVisionEffect:Destroy() end)
        self.nightVisionEffect = nil
    end
end

TabDrone:Section({ Title = "Ultimate Drone Control" })
TabDrone:Toggle({ Title = "Enable Drone", Value = false, Callback = function(v)
    Settings.DroneEnabled = v
    if v then Drone:Start() else Drone:Stop() end
end })
TabDrone:Slider({ Title = "Speed", Value = { Min = 50, Max = 1000, Default = 200 },
    Callback = function(v) Settings.DroneSpeed = v end })
TabDrone:Slider({ Title = "Acceleration", Value = { Min = 1, Max = 20, Default = 8 },
    Callback = function(v) Settings.DroneAccel = v end })
TabDrone:Dropdown({ Title = "Camera", Values = { "FPV", "TPV" }, Value = "TPV",
    Callback = function(v)
        Settings.DroneCamera = v
        if Drone.active then
            Camera.FieldOfView = (v == "FPV" and Settings.DroneFPVEffects) and Settings.DroneFPVFOV or 90
        end
    end })
TabDrone:Toggle({ Title = "Missile Launcher", Value = true, Callback = function(v) Settings.DroneMissiles = v end })
TabDrone:Toggle({ Title = "Energy Shield", Value = false, Callback = function(v) Settings.DroneShield = v end })
TabDrone:Toggle({ Title = "Lock-On Laser", Value = false, Callback = function(v) Settings.DroneLockOn = v end })
TabDrone:Button({ Title = "Launch Drone", Icon = "play", Callback = function() Drone:Start() end })
TabDrone:Button({ Title = "Land Drone", Icon = "square", Callback = function() Drone:Stop() end })

-- Minimal drone update loop (kept behavior)
trackConn(RunService.RenderStepped:Connect(function(dt)
    if not Drone.active or not Drone.base then return end
    dt = math.clamp(dt, 0, 0.1)
    local moveInput = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveInput += Vector3.new(0, 0, -1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveInput += Vector3.new(0, 0, 1)  end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveInput += Vector3.new(-1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveInput += Vector3.new(1, 0, 0)  end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveInput += Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveInput += Vector3.new(0, -1, 0) end

    local camLook = Camera.CFrame.LookVector
    local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
    local flatRight = Vector3.new(flatLook.Z, 0, -flatLook.X)
    local moveDir = (flatLook * -moveInput.Z) + (flatRight * moveInput.X) + Vector3.new(0, moveInput.Y, 0)
    if moveDir.Magnitude > 1 then moveDir = moveDir.Unit end

    local targetVel = moveDir * Settings.DroneSpeed
    local accel = math.clamp(Settings.DroneAccel * dt, 0, 1)
    Drone.currentVel = Drone.currentVel:Lerp(targetVel, accel)

    if Drone.currentVel.Magnitude > 0.1 then
        Drone.droneCF = Drone.droneCF + Drone.currentVel * dt
    end

    local lookDir = Drone.currentVel.Magnitude > 5 and Drone.currentVel.Unit or flatLook
    local targetCF = CFrame.lookAt(Drone.droneCF.Position, Drone.droneCF.Position + lookDir)
    Drone.droneCF = Drone.droneCF:Lerp(targetCF, 0.3)
    setDroneCFrame(Drone.model, Drone.base, Drone.droneCF)

    Camera.CameraType = Enum.CameraType.Scriptable
    if Settings.DroneCamera == "FPV" then
        Camera.FieldOfView = Settings.DroneFPVFOV
        Camera.CFrame = Drone.droneCF * CFrame.new(0, 0.4, -0.6)
    else
        Camera.FieldOfView = 90
        local camPos = Drone.droneCF.Position + (Drone.droneCF.LookVector * -10) + Vector3.new(0, 4, 0)
        Camera.CFrame = CFrame.lookAt(camPos, Drone.droneCF.Position)
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  BULLET TRACERS
-- ═══════════════════════════════════════════════════════════════
local bulletTracers = {}
local function spawnBulletTracer(fromPos, toPos)
    local line = newFrame({
        BackgroundTransparency = Settings.AlphaBulletTracer,
        BackgroundColor3 = Settings.ColorBulletTracer,
        Parent = ESPGui,
    })
    local fromScreen = Camera:WorldToViewportPoint(fromPos)
    local toScreen   = Camera:WorldToViewportPoint(toPos)
    local delta = Vector2.new(toScreen.X - fromScreen.X, toScreen.Y - fromScreen.Y)
    local length = delta.Magnitude
    local center = Vector2.new((fromScreen.X + toScreen.X)/2, (fromScreen.Y + toScreen.Y)/2)
    line.Position = UDim2.fromOffset(center.X, center.Y)
    line.Size = UDim2.fromOffset(length, 2)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    table.insert(bulletTracers, {Frame = line, Birth = tick()})
end

trackConn(RunService.RenderStepped:Connect(function()
    for i = #bulletTracers, 1, -1 do
        local t = bulletTracers[i]
        local age = tick() - t.Birth
        if age > 1 then
            t.Frame:Destroy()
            table.remove(bulletTracers, i)
        else
            t.Frame.BackgroundTransparency = math.clamp(Settings.AlphaBulletTracer + age, 0, 1)
        end
    end
end))

local function onToolActivated()
    if not Settings.BulletTracers then return end
    local char = LocalPlayer.Character
    local hrp = getRoot(char)
    if not hrp then return end
    local fromPos = hrp.Position + Vector3.new(0, 1, 0)
    local targetPos = Camera.CFrame.Position + Camera.CFrame.LookVector * 100
    spawnBulletTracer(fromPos, targetPos)
end

trackConn(LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _, c in pairs(char:GetChildren()) do
        if c:IsA("Tool") then c.Activated:Connect(onToolActivated) end
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  FLY (kept)
-- ═══════════════════════════════════════════════════════════════
local ControlModule
pcall(function()
    ControlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
end)

local function initFlyObjects()
    pcall(function()
        if _G.fly_rp then _G.fly_rp:Destroy() end
        if _G.fly_bg then _G.fly_bg:Destroy() end
    end)
    local ch = LocalPlayer.Character
    if not ch then return end
    local hum  = getHumanoid(ch)
    local root = getRoot(ch)
    if not hum or not root then return end

    local rp_h = 1e4
    _G.fly_bg = Instance.new('BodyGyro', root)
    _G.fly_rp = Instance.new('RocketPropulsion', root)
    local md = Instance.new('Model')
    _G.fly_pt = Instance.new('Part', md)
    _G.fly_rp.MaxTorque = Vector3.new(rp_h, rp_h, rp_h)
    _G.fly_bg.MaxTorque = Vector3.new()
    md.PrimaryPart = _G.fly_pt
    _G.fly_pt.Anchored = true
    _G.fly_pt.CanCollide = false
    _G.fly_rp.CartoonFactor = 1
    _G.fly_rp.Target = _G.fly_pt
    _G.fly_rp.MaxSpeed = Settings.FlySpeed
    _G.fly_rp.MaxThrust = 5e5
    _G.fly_rp.ThrustP = 1e5
    _G.fly_rp.ThrustD = math.huge
    _G.fly_rp.TurnP = 1e5
    _G.fly_rp.TurnD = 2e2
    _G.fly_bg.P = 3e4
end
trackConn(LocalPlayer.CharacterAdded:Connect(function() task.wait(1); initFlyObjects() end))
initFlyObjects()

trackConn(RunService.RenderStepped:Connect(function()
    if not _G.fly_rp or not getgenv().MellHackLoaded then return end
    local char = LocalPlayer.Character
    local root = getRoot(char)
    local hum  = getHumanoid(char)
    if not char or not root or not hum then return end

    local kb = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then kb += Vector3.new(0,0,-1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then kb += Vector3.new(0,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then kb += Vector3.new(-1,0,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then kb += Vector3.new(1,0,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then kb += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then kb += Vector3.new(0,-1,0) end

    if Settings.Fly then
        hum.AutoRotate = false
        hum.PlatformStand = true
        _G.fly_bg.MaxTorque = Vector3.new(3e4, 3e4, 3e4)
        _G.fly_rp.MaxTorque = Vector3.new(1e4, 1e4, 1e4)
        if kb.Magnitude > 0 then
            pcall(function() _G.fly_rp:Fire() end)
            local camCF = Camera.CFrame
            local targetDir = (camCF.RightVector * kb.X) - (camCF.LookVector * kb.Z) + Vector3.new(0, kb.Y * 2, 0)
            _G.fly_pt.Position = root.Position + (targetDir * 1000)
            _G.fly_bg.CFrame = Camera.CFrame
        else
            pcall(function() _G.fly_rp:Abort() end)
            root.Velocity = Vector3.new(0,0,0)
        end
    else
        hum.AutoRotate = true
        hum.PlatformStand = false
        _G.fly_bg.MaxTorque = Vector3.new()
        _G.fly_rp.MaxTorque = Vector3.new()
        pcall(function() _G.fly_rp:Abort() end)
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  MAIN ESP LOOP (with fixed HP Bar + Preview update)
-- ═══════════════════════════════════════════════════════════════
trackConn(RunService.RenderStepped:Connect(function(dt)
    if not getgenv().MellHackLoaded then return end

    -- Local chams
    if Settings.LocalChams and LocalPlayer.Character then
        applyChamsToCharacter(LocalPlayer.Character, true)
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("MellChams") and not Settings.LocalChams then
        local h = LocalPlayer.Character:FindFirstChild("MellChams")
        if h then h:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        local hrp = getRoot(char)
        local hum = getHumanoid(char)
        local head = getHead(char)

        local shouldShow = char and hrp and hum and hum.Health > 0
            and ((Settings.TeamESP and isEnemy(p)) or not Settings.TeamESP)

        local esp = ESPCache[p]
        local tracer = TracerCache[p]
        local skeleton = SkeletonCache[p]

        if not shouldShow then
            if esp then esp.Billboard.Enabled = false end
            if tracer then tracer.Frame.Visible = false end
            if skeleton then for _, l in ipairs(skeleton) do l.Visible = false end end
            if char and not Settings.Chams then
                local hc = char:FindFirstChild("MellChams")
                if hc then hc:Destroy() end
            end
            continue
        end

        applyChamsToCharacter(char, false)

        -- ── Correct world→screen box computation ──
        local topWorld, bottomWorld
        if head then
            topWorld = head.Position + Vector3.new(0, 1.0, 0)
        else
            topWorld = hrp.Position + Vector3.new(0, 2.5, 0)
        end
        local footPart = char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
            or char:FindFirstChild("Left Leg") or char:FindFirstChild("Right Leg")
        if footPart then
            bottomWorld = footPart.Position - Vector3.new(0, 0.5, 0)
        else
            bottomWorld = hrp.Position - Vector3.new(0, 2.8, 0)
        end

        local topPos, topOn = Camera:WorldToViewportPoint(topWorld)
        local botPos, botOn = Camera:WorldToViewportPoint(bottomWorld)

        if topOn and botOn and topPos.Z > 0 and botPos.Z > 0 then
            local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
            local heightPixels = math.abs(topPos.Y - botPos.Y)
            local widthPixels = heightPixels * 0.55
            if widthPixels < 8 then widthPixels = 8 end
            if heightPixels < 8 then heightPixels = 8 end

            esp = esp or ensureESP(p)
            esp.Billboard.Adornee = nil
            esp.Billboard.Enabled = true
            esp.Billboard.Size = UDim2.fromOffset(widthPixels, heightPixels)
            local midWorld = (topWorld + bottomWorld) * 0.5
            esp.Billboard.Adornee = hrp
            esp.Billboard.StudsOffsetWorldSpace = midWorld - hrp.Position

            -- Box
            esp.BoxFrame.Visible = Settings.ESPBox
            esp.BoxStroke.Enabled = Settings.ESPBox
            esp.BoxStroke.Color = Settings.ColorBox
            esp.BoxStroke.Transparency = Settings.AlphaBox
            esp.BoxStroke.Thickness = 1.5

            -- Name
            esp.NameLabel.Visible = Settings.NameESP
            esp.NameLabel.TextColor3 = Settings.ColorName
            esp.NameLabel.TextTransparency = Settings.AlphaName
            esp.NameLabel.Text = string.format("%s [%dm]", p.Name, math.floor(distance))

            -- HP Bar (correct)
            esp.HPBarBack.Visible = Settings.HPBar
            esp.HPBarBack.BackgroundColor3 = Settings.ColorHPEmpty
            esp.HPBarBack.BackgroundTransparency = Settings.AlphaHPEmpty
            esp.HPBarFill.BackgroundColor3 = Settings.ColorHPFull
            esp.HPBarFill.BackgroundTransparency = Settings.AlphaHPFull
            if hum then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                esp.HPBarFill.Size = UDim2.new(1, 0, pct, 0)
                esp.HPBarFill.Position = UDim2.new(0, 0, 1, 0)
                esp.HPBarFill.AnchorPoint = Vector2.new(0, 1)
            end

            -- Tracers
            if Settings.Tracers then
                local t = tracer or ensureTracer(p)
                local bottomScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                local targetScreen = Vector2.new(topPos.X, topPos.Y + heightPixels / 2)
                drawLine(t.Frame, bottomScreen, targetScreen, Settings.ColorTracer, Settings.AlphaTracer)
            elseif tracer then
                tracer.Frame.Visible = false
            end

            -- Skeleton
            if Settings.SkeletonESP and head then
                local bones = skeleton or ensureSkeleton(p)
                local ut = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                local lt = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")
                local la = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local ra = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local ll = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rl = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")

                local function screen(pos)
                    if not pos then return nil end
                    local sp, on = Camera:WorldToViewportPoint(pos.Position)
                    if not on then return nil end
                    return Vector2.new(sp.X, sp.Y)
                end

                local hS  = screen(head)
                local utS = screen(ut)
                local ltS = screen(lt)
                local laS = screen(la)
                local raS = screen(ra)
                local llS = screen(ll)
                local rlS = screen(rl)

                drawLine(bones[1], hS, utS, Settings.ColorSkeleton, Settings.AlphaSkeleton)
                drawLine(bones[2], utS, ltS, Settings.ColorSkeleton, Settings.AlphaSkeleton)
                drawLine(bones[3], ltS, llS, Settings.ColorSkeleton, Settings.AlphaSkeleton)
                drawLine(bones[4], ltS, rlS, Settings.ColorSkeleton, Settings.AlphaSkeleton)
                drawLine(bones[5], utS, laS, Settings.ColorSkeleton, Settings.AlphaSkeleton)
                drawLine(bones[6], utS, raS, Settings.ColorSkeleton, Settings.AlphaSkeleton)
                for i = 7, 8 do if bones[i] then bones[i].Visible = false end end
            elseif skeleton then
                for _, l in ipairs(skeleton) do l.Visible = false end
            end
        else
            if esp then esp.Billboard.Enabled = false end
            if tracer then tracer.Frame.Visible = false end
            if skeleton then for _, l in ipairs(skeleton) do l.Visible = false end end
        end
    end

    -- ── Preview update ──
    if Preview.frame then
        positionPreview()
        if Settings.PreviewEnabled then
            for _, gl in ipairs(Preview.gridLines) do
                gl.BackgroundColor3 = Settings.ColorMenu
            end
            Preview.nameLbl.Visible = Settings.PreviewName
            Preview.nameLbl.TextColor3 = Settings.ColorName
            Preview.hpBack.Visible = Settings.PreviewHP
            Preview.hpBack.BackgroundColor3 = Settings.ColorHPEmpty
            Preview.hpFill.BackgroundColor3 = Settings.ColorHPFull
            Preview.boxOutline.Visible = Settings.PreviewBox
            Preview.boxStroke.Color = Settings.ColorBox

            local dist = Settings.PreviewZoom
            local rx, ry = Preview.rotX, Preview.rotY
            local camPos = Vector3.new(
                math.sin(ry) * math.cos(rx) * dist,
                0.6 + math.sin(rx) * dist,
                math.cos(ry) * math.cos(rx) * dist
            )
            if Settings.Preview3D then
                Preview.camera.CFrame = CFrame.new(camPos, Vector3.new(0, 0.2, 0))
            else
                Preview.camera.CFrame = CFrame.new(Vector3.new(0, 0.2, dist), Vector3.new(0, 0.2, 0))
            end

            local model = Preview.model
            if model then
                local hl = model:FindFirstChild("MellPreviewChams")
                if Settings.PreviewChams then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "MellPreviewChams"
                        hl.Parent = model
                    end
                    hl.FillColor = Settings.ColorChams
                    hl.FillTransparency = Settings.AlphaChams
                    hl.OutlineColor = Settings.ColorChamsOutline
                    hl.OutlineTransparency = Settings.AlphaChamsOutline
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif hl then
                    hl:Destroy()
                end
            end
        end
    end

    if not Settings.Chams then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hc = p.Character:FindFirstChild("MellChams")
                if hc then hc:Destroy() end
            end
        end
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  FOV CIRCLE + CROSSHAIR
-- ═══════════════════════════════════════════════════════════════
local fovFrame = newFrame({
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Parent = ESPGui,
    Visible = false,
    Size = UDim2.fromOffset(100, 100),
})
fovFrame.Name = "MellFOV"
local fovStroke = newStroke(fovFrame, Settings.ColorFOV, 1.5, Settings.AlphaFOV)
local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(1, 0); fovCorner.Parent = fovFrame

trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    if (Settings.Aimbot or Settings.SilentAim) and Settings.DrawFOV then
        local r = Settings.AimFOV * 2
        fovFrame.Visible = true
        fovFrame.Size = UDim2.fromOffset(r, r)
        fovFrame.Position = UDim2.fromOffset(
            UserInputService:GetMouseLocation().X,
            UserInputService:GetMouseLocation().Y
        )
        fovStroke.Color = Settings.ColorFOV
        fovStroke.Transparency = Settings.AlphaFOV
    else
        fovFrame.Visible = false
    end
end))

trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    if Settings.Crosshair then
        local center = Camera.ViewportSize / 2
        local gap, len = 6, 12
        for i = 1, 4 do
            crosshairParts[i].Visible = true
            crosshairParts[i].BackgroundColor3 = Settings.ColorCrosshair
            crosshairParts[i].BackgroundTransparency = Settings.AlphaCrosshair
        end
        crosshairParts[1].Size = UDim2.fromOffset(1.5, len)
        crosshairParts[1].Position = UDim2.fromOffset(center.X, center.Y - gap - len/2)
        crosshairParts[2].Size = UDim2.fromOffset(1.5, len)
        crosshairParts[2].Position = UDim2.fromOffset(center.X, center.Y + gap + len/2)
        crosshairParts[3].Size = UDim2.fromOffset(len, 1.5)
        crosshairParts[3].Position = UDim2.fromOffset(center.X - gap - len/2, center.Y)
        crosshairParts[4].Size = UDim2.fromOffset(len, 1.5)
        crosshairParts[4].Position = UDim2.fromOffset(center.X + gap + len/2, center.Y)
    else
        for i = 1, 4 do crosshairParts[i].Visible = false end
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  TRIGGERBOT
-- ═══════════════════════════════════════════════════════════════
local lastTrigger = 0
trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded or not Settings.Triggerbot then return end
    local now = tick()
    if now - lastTrigger < Settings.TriggerbotDelay then return end
    local mousePos = UserInputService:GetMouseLocation()
    local target, minDst = nil, Settings.TriggerbotFOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isEnemy(p) and p.Character then
            local hum = getHumanoid(p.Character)
            if hum and hum.Health > 0 then
                local part = getAimPart(p) or getRoot(p.Character)
                if part and isTriggerVisible(part) then
                    local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dst = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        if dst < minDst then minDst = dst; target = p end
                    end
                end
            end
        end
    end
    if target then
        pcall(function() mouse1click() end)
        lastTrigger = now
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  MAIN CHARACTER LOOP
-- ═══════════════════════════════════════════════════════════════
trackConn(RunService.RenderStepped:Connect(function()
    if not getgenv().MellHackLoaded then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = getRoot(char)
    local humanoid = getHumanoid(char)
    if not hrp or not humanoid then return end

    if not Drone.active then
        if Settings.Speed  then humanoid.WalkSpeed = Settings.WalkSpeedVal end
        if Settings.Jump   then humanoid.JumpPower = Settings.JumpPowerVal end
        if Settings.Godmode then humanoid.Health = humanoid.MaxHealth end
        if Settings.AutoHeal and humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
    end

    if Settings.FOVChanger then Camera.FieldOfView = Settings.CustomFOV end

    if Settings.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if not Drone.active then
        if Settings.Bhop and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if Settings.Strafes and humanoid.FloorMaterial == Enum.Material.Air then
            local md = humanoid.MoveDirection
            if md.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * Settings.StrafeSpeed, hrp.AssemblyLinearVelocity.Y, md.Z * Settings.StrafeSpeed)
            end
        end
        if Settings.LongJump and humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 90 + Vector3.new(0, 40, 0)
        end
        if Settings.NoFallDamage and hrp.AssemblyLinearVelocity.Y < -50 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -50, hrp.AssemblyLinearVelocity.Z)
        end
        if Settings.AutoRespawn and humanoid.Health <= 0 then
            task.spawn(function() task.wait(3); pcall(function() LocalPlayer:LoadCharacter() end) end)
        end
        if Settings.SpinBot then
            hrp.CFrame *= CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
        elseif Settings.AntiAim then
            local mode = Settings.AntiAimMode or "Spin"
            local yawOffsetRad = math.rad(Settings.YawOffset)
            local finalAngle
            if mode == "Spin" then finalAngle = (tick() * Settings.SpinSpeed * 20) + yawOffsetRad
            elseif mode == "Jitter" then finalAngle = yawOffsetRad + math.rad(math.random(-Settings.JitterRange, Settings.JitterRange))
            elseif mode == "Random" then finalAngle = math.rad(math.random(0, 360))
            else finalAngle = yawOffsetRad end
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, finalAngle, 0)
        end
        if Settings.HideHead then
            local head = getHead(char)
            if head then
                head.Transparency = 1
                head.CanCollide = false
                for _, c in pairs(head:GetChildren()) do
                    if c:IsA("SpecialMesh") or c:IsA("DataModelMesh") or c:IsA("Decal") then
                        c.Transparency = 1
                    end
                end
            end
        end
        if Settings.Freecam then
            Camera.CameraType = Enum.CameraType.Scriptable
            local md = Vector3.new(0,0,0)
            local camCF = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then md += camCF.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then md -= camCF.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then md -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then md += camCF.RightVector end
            Camera.CFrame = camCF + (md * (Settings.FreecamSpeed / 30))
        elseif Camera.CameraType == Enum.CameraType.Scriptable and not Drone.active then
            Camera.CameraType = Enum.CameraType.Custom
        end
        if Settings.Earthquake then
            Camera.CFrame *= CFrame.new(math.random(-1,1)*0.1, math.random(-1,1)*0.1, 0)
        end
    end

    if Settings.Fullbright then
        Lighting.Brightness = 3; Lighting.ClockTime = 12; Lighting.GlobalShadows = false
    end

    if Settings.CustomFog then
        Lighting.FogEnd = Settings.FogEnd
        Lighting.FogStart = Settings.FogStart
        Lighting.FogColor = Color3.fromRGB(
            Settings.FogColor[1], Settings.FogColor[2], Settings.FogColor[3])
    end

    if Settings.Xray then
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency < 0.5 and not p:IsDescendantOf(char) then
                p.LocalTransparencyModifier = 0.6
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (not Settings.TeamCheck or isEnemy(p)) and p.Character then
            local head = getHead(p.Character)
            if head then
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
    end

    if Settings.Killaura then
        for _, p in pairs(Players:GetPlayers()) do
            local eRoot = getRoot(p.Character)
            if p ~= LocalPlayer and isEnemy(p) and p.Character and eRoot then
                if (hrp.Position - eRoot.Position).Magnitude < Settings.KillauraRange then
                    pcall(function() mouse1click() end)
                end
            end
        end
    end
end))

-- ═══════════════════════════════════════════════════════════════
--  UNLOAD
-- ═══════════════════════════════════════════════════════════════
trackConn(LocalPlayer.Idled:Connect(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end))

getgenv().MellHackUnload = function()
    getgenv().MellHackLoaded = false
    pcall(function() if Drone.active then Drone:Stop() end end)
    for _, conn in pairs(Connections) do
        if conn and conn.Connected then pcall(function() conn:Disconnect() end) end
    end
    for _, obj in pairs(ObjectsToCleanup) do
        if obj and obj.Parent then pcall(function() obj:Destroy() end) end
    end
    pcall(function()
        if ESPGui then ESPGui:Destroy() end
        if PreviewGui then PreviewGui:Destroy() end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Camera.FieldOfView = 70
        if _G.fly_rp then _G.fly_rp:Destroy() end
        if _G.fly_bg then _G.fly_bg:Destroy() end
    end)
end

task.defer(ApplyMenuColorsToTheme)

WindUI:Notify({
    Title    = "MellHack",
    Content  = "MellHack loaded! By @ruzoxu",
    Duration = 6,
    Icon     = "check",
})

safeLog("MellHack loaded!")