local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ 1. 중복 실행 방지 및 예전 GUI 정리 ]]
if _G.SolarConnections then
    for _, conn in pairs(_G.SolarConnections) do
        if conn then conn:Disconnect() end
    end
end
_G.SolarConnections = {}

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_PREMIUM_UE" then v:Destroy() end
end

-- [[ 2. 최상위 GUI 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_PREMIUM_UE"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 백그라운드 프레임 (영상 속 디자인 반영) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 440)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

-- 상단 타이틀 바 고정
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - discord.gg/VtPuHZQt8y"
Title.TextColor3 = Color3.fromRGB(255, 0, 50)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 7대 탭 메뉴 바 디자인 ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 26)
TabBar.Position = UDim2.new(0, 12, 0, 25)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(35, 35, 35)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 2)

-- 콘텐츠가 들어갈 메인 스크린 영역
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -65)
ContentFrame.Position = UDim2.new(0, 12, 0, 55)
ContentFrame.BackgroundTransparency = 1

-- [[ 5. 탭 페이지 생성 및 레이아웃 빌더 ]]
local Tabs = {}
local function CreateTabPages(tabName)
    local Page = Instance.new("Frame", ContentFrame)
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    -- 각 탭 내부의 왼쪽 정렬 스크롤바
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
    -- 각 탭 내부의 오른쪽 정렬 스크롤바
    local RightScroll = Instance.new("ScrollingFrame", Page)
    RightScroll.Name = "Right"
    RightScroll.Size = UDim2.new(0.5, -5, 1, 0)
    RightScroll.Position = UDim2.new(0.5, 5, 0, 0)
    RightScroll.BackgroundTransparency = 1
    RightScroll.BorderSizePixel = 0
    RightScroll.ScrollBarThickness = 2
    RightScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    local R_Layout = Instance.new("UIListLayout", RightScroll)
    R_Layout.Padding = UDim.new(0, 10)

    Tabs[tabName] = {Left = LeftScroll, Right = RightScroll, Page = Page}
end

-- 형이 요청한 7대 탭 등록
local TabNames = {"Main", "World", "Esp", "Visuals", "Character", "Misc", "Setting"}
for i, name in ipairs(TabNames) do
    CreateTabPages(name)
end

-- 탭 전환 버튼 스크립트
local function SetupTabButton(name, order)
    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 72, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.Code
    TabBtn.TextSize = 10
    TabBtn.LayoutOrder = order

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        Tabs[name].Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 0, 50)
    end)
end

for i, name in ipairs(TabNames) do
    SetupTabButton(name, i)
end
Tabs["main"].Page.Visible = true -- 첫 시작은 MAIN 탭 활성화
TabBar:GetChildren()[2].TextColor3 = Color3.fromRGB(255, 0, 50)

-- [[ 6. 버튼 및 슬라이더를 담아줄 섹션 박스 함수 ]]
function _G.AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 150)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(255, 0, 50)
    
    local SecTitle = Instance.new("TextLabel", SectionFrame)
    SecTitle.Size = UDim2.new(1, -10, 0, 18)
    SecTitle.Position = UDim2.new(0, 8, 0, 2)
    SecTitle.BackgroundTransparency = 1
    SecTitle.Text = titleName:lower()
    SecTitle.TextColor3 = Color3.fromRGB(255, 0, 50)
    SecTitle.Font = Enum.Font.Code
    SecTitle.TextSize = 11
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local Container = Instance.new("Frame", SectionFrame)
    Container.Size = UDim2.new(1, -10, 1, -25)
    Container.Position = UDim2.new(0, 5, 0, 22)
    Container.BackgroundTransparency = 1
    local C_Layout = Instance.new("UIListLayout", Container)
    C_Layout.Padding = UDim.new(0, 4)
    
    return Container
end

-- [[ 7. 온/오프 토글 스위치 뼈대 함수 ]]
function _G.AddToggle(section, text, default, callback)
    local Row = Instance.new("Frame", section)
    Row.Size = UDim2.new(1, 0, 0, 20)
    Row.BackgroundTransparency = 1
    
    local Box = Instance.new("TextButton", Row)
    Box.Size = UDim2.new(0, 12, 0, 12)
    Box.Position = UDim2.new(0, 5, 0.5, -6)
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Box.Text = ""
    Box.BackgroundColor3 = default and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(14, 14, 14)
    
    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Position = UDim2.new(0, 22, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text:lower()
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = default
    Box.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(14, 14, 14)
        callback(state)
    end)
end

-- [[ 8. 수치 조절용 슬라이더 뼈대 함수 ]]
function _G.AddSlider(section, text, min, max, default, callback)
    local SliderRow = Instance.new("Frame", section)
    SliderRow.Size = UDim2.new(1, 0, 0, 32)
    SliderRow.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderRow)
    Label.Size = UDim2.new(1, 0, 0, 14)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text:lower()
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", SliderRow)
    ValueLabel.Size = UDim2.new(1, -10, 0, 14)
    ValueLabel.Position = UDim2.new(0, 0, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = default .. " / " .. max
    ValueLabel.TextColor3 = Color3.fromRGB(255, 0, 50)
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local Track = Instance.new("TextButton", SliderRow)
    Track.Size = UDim2.new(1, -10, 0, 10)
    Track.Position = UDim2.new(0, 5, 0, 16)
    Track.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Track.BorderSizePixel = 1
    Track.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Track.Text = ""

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    Fill.BorderSizePixel = 0

    local SetValue = function(input)
        local l = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(l, 0, 1, 0)
        local val = math.floor(min + (max - min) * l)
        ValueLabel.Text = val .. " / " .. max
        callback(val)
    end

    local IsDragging = false
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true; SetValue(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            SetValue(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = false
        end
    end)
end

-- [[ 9. 모바일/PC 통합 UI 숨기기 마스터 버튼 ]]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "UIToggleButton"
ToggleBtn.Size = UDim2.new(0, 45, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "SOLAR"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
ToggleBtn.BorderSizePixel = 1
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 50)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 나머지 빈 탭들 에러 방지용 초기 셋업
for _, name in pairs(TabNames) do
    _G.AddSection(Tabs[name].Left, name .. " options")
end

print("[SOLAR BASE] UI Base Loaded! Ready for Functions.")
{
  "Visuals/Effects/ColorCorrection/Saturation": 48,
  "Esp/Enemy/HealthBar/Color1": {
    "alpha": 1,
    "rgb": [
      0.28999996185302737,
      0,
      1
    ]
  },
  "Misc/Character/Noclip": true,
  "Visuals/World/Reflections": 50,
  "Misc/Character/SlideBoost": false,
  "settings/menu/invis_open": false,
  "Visuals/Effects/Bloom/Size": 24,
  "Misc/Character/WalkSpeed/Bind": {
    "mode": "Always"
  },
  "Esp/Extra/Size/Width": 10,
  "Visuals/Asus/Color": {
    "alpha": 1,
    "rgb": [
      0,
      0.699999988079071,
      1
    ]
  },
  "Visuals/Effects/ColorCorrection": true,
  "Triggerbot/Advanced/MinDelay": 40,
  "Esp/EnemyVisOverrides/Distance/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Legitbot/Main/SpeedScaleFOV": 100,
  "Esp/Team/HealthBar/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Bounding Box Size": false,
  "Esp/TeamVisOverrides/Ammo/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Visuals/World/Brightness": 100,
  "Note": false,
  "Esp/Team/ChamsOccluded": true,
  "Triggerbot/Main/Grace": 0,
  "Triggerbot/Main/Enabled/Key": {
    "mode": "Always"
  },
  "Esp/TeamVisOverrides/Distance": false,
  "Visuals/World/Exposure": 50,
  "Misc/Character/JumpPower": false,
  "Legitbot/FOV/Draw": false,
  "Esp/EnemyVisOverrides/KatanaStatus": false,
  "Visuals/BT/Lifetime": 1.74,
  "Esp/Team/Name/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Visuals/World/ColorShift/Bottom": {
    "alpha": 0,
    "rgb": [
      0.440000057220459,
      0,
      1
    ]
  },
  "Esp/EnemyVisOverrides/WeaponText/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Misc/AutoLoadout/MeleeLabel": false,
  "Esp/Team/HealthBar/Color0": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "Visuals/ArmChams/Reflectance": 0.24,
  "Tint Color": false,
  "Esp/Team/HealthBar/Color1": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "Esp/Main/BoxSize": "Static",
  "Triggerbot/Targeting/VisCheck": false,
  "Esp/EnemyVisOverrides/HealthBar/Color1": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "GC Material": false,
  "SilentAim/Main/HitChance": 100,
  "Visuals/BT/InitialCol": {
    "alpha": 0,
    "rgb": [
      0.440000057220459,
      0,
      1
    ]
  },
  "Targeting Hitparts": false,
  "Visuals/Effects/ColorCorrection/TintColor": {
    "alpha": 0,
    "rgb": [
      0.38000011444091799,
      0,
      1
    ]
  },
  "Esp/Enemy/Chams/OutlineColor": {
    "alpha": 0.5,
    "rgb": [
      1,
      0.8100001811981201,
      0
    ]
  },
  "SilentAim/FOV/Ignore": false,
  "Esp/EnemyVisOverrides/Ammo/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Misc/Character/SlideBoost/Bind": {
    "mode": "Always"
  },
  "Esp/TeamVisOverrides/WeaponText/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "AntiAim/AntiHS": true,
  "Esp/Team/Chams/OutlineColor": {
    "alpha": 0.5,
    "rgb": [
      0.6549019813537598,
      0.6549019813537598,
      0.6549019813537598
    ]
  },
  "SilentAim/Targeting/Hitparts": {
    "Head": true,
    "Body": false
  },
  "Misc/AutoLoadout/SecondaryLabel": false,
  "Misc/World/PreventOutOfBounds": true,
  "Esp/EnemyVisOverrides/WeaponText": false,
  "Legitbot/Main/Enabled/Key": {
    "mode": "Always"
  },
  "Misc/Weapons/RecoilModifier/Value": 0,
  "AutoReconnect": true,
  "Esp/TeamVisOverrides/Box": false,
  "AntiAim/InFloor": true,
  "Visuals/World/ColorShift/Top": {
    "alpha": 0,
    "rgb": [
      1,
      1,
      0
    ]
  },
  "Tracer Texture": false,
  "Esp/Enemy/WeaponText/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0.8899999856948853,
      1,
      0
    ]
  },
  "ARM Material": false,
  "Esp/Team/Name": true,
  "Misc/World/NoFireDamage": true,
  "Triggerbot/Advanced/RandomDelay": false,
  "Visuals/Effects/ColorCorrection/Preset": "Cinematic",
  "Esp/Team/Box/Type": "Full",
  "Visuals/Effects/SunRays/Spread": 50,
  "SilentAim/Targeting/PreferredHitpart": "Head",
  "Esp/TeamVisOverrides/Box/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Visuals/ArmChams/Enabled/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0.8400000333786011,
      0
    ]
  },
  "Esp/Extra/UseDisplayName": false,
  "Esp/Team/Name/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Esp/EnemyVisOverrides/Name/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Esp/Enemy/Ammo/OutlineColor": {
    "alpha": 1,
    "rgb": [
      1,
      0.8700001239776611,
      0
    ]
  },
  "Esp/Extra/DrawDistance/Limit": 500,
  "AntiAim/Yaw/Angle": -22,
  "Esp/TeamVisOverrides/KatanaStatus": false,
  "Esp/Enemy/Enabled": true,
  "Movement/AutoStrafer/ViewAngle": false,
  "Visuals/ThirdPerson/Z": 7.5,
  "Visuals/GunChams/Reflectance": 1,
  "Disable3dRendering": false,
  "Visuals/ViewmodelOffset/X": 0,
  "SilentAim/Main/Enabled/Key": {
    "mode": "Always"
  },
  "Legitbot/Main/AttackSpeed": 5,
  "Visuals/World/AmbientColor": {
    "alpha": 0,
    "rgb": [
      0.23659978806972505,
      0,
      0.9100000262260437
    ]
  },
  "Esp/Team/KatanaStatus/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Esp/TeamVisOverrides/WeaponText": false,
  "Misc/AutoLoadout/PrimaryLabel": false,
  "Visuals/BT/HideGameImpacts": true,
  "Esp/Team/ChamsOccluded/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0.800000011920929,
      0.749019980430603,
      0.05490199849009514
    ]
  },
  "Color Correction Preset": false,
  "AntiAim/YawBase": "At Targets",
  "Triggerbot/Main/Delay": 0,
  "Esp/Team/KatanaStatus/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "Visuals/BulletTracers/FinalCol": {
    "alpha": 0,
    "rgb": [
      0.9199998378753662,
      1,
      0
    ]
  },
  "ARM FF Animation": false,
  "Esp/EnemyVisOverrides/HealthBar/Color0": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "Misc/Weapons/NoSpread": true,
  "Legitbot/Main/Enabled": true,
  "Esp/Enemy/Chams": true,
  "Movement/AutoSlideJump": false,
  "Visuals/BT/Length": 5,
  "Esp/Enemy/ChamsOccluded/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0.8400001525878906,
      0
    ]
  },
  "Visuals/ViewmodelOffset/Y": 0,
  "Misc/AutoLoadout/Melee2": "Fists",
  "AntiAim/Enabled": true,
  "Misc/Character/FlyHack": true,
  "Visuals/BT/Size": 1.5,
  "Visuals/Effects/ColorCorrection/Brightness": 52,
  "Esp/Enemy/Distance": true,
  "Esp/Enemy/KatanaStatus": true,
  "Pitch": false,
  "Misc/Weapons/RecoilModifier": true,
  "Esp/TeamVisOverrides/HealthBar/Color0": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "Esp/Enemy/HealthBar": true,
  "Esp/Team/WeaponText/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Misc/World/RemoveKillers": true,
  "KeybindMenu": false,
  "SilentAim/FOV/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "SilentAim/FOV/Dynamic": false,
  "Visuals/Effects/Bloom": true,
  "Visuals/BT/Texture": "Photon Stream",
  "settings/menu/mobile_tip1": false,
  "Esp/EnemyVisOverrides/HealthBar/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Legitbot/Main/MaxLockTime": 10,
  "Esp/Extra/DrawDistance": false,
  "Visuals/ThirdPerson": true,
  "Legitbot/Main/Speed": 5,
  "Visuals/ThirdPerson/Y": 1.5,
  "Misc/AutoLoadout/Primary2": "Bow",
  "Visuals/Removables/FlashEffect": true,
  "Triggerbot/Main/Enabled": true,
  "Esp/Team/Ammo/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Esp/EnemyVisOverrides/Distance": false,
  "Legitbot/FOV/Dynamic": false,
  "DebugMode": false,
  "Misc/Weapons/UnlockAll": true,
  "Misc/HitSounds/Selected": "Rust",
  "Visuals/Effects/CameraMotionBlur": true,
  "Misc/Character/WalkSpeed": false,
  "SilentAim/Targeting/SelectionMethod": "Closest",
  "Esp/EnemyVisOverrides/Distance/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Misc/World/AntiFreeze": true,
  "Misc/DeviceSpoofer/Device": "Console",
  "Legitbot/Main/ReactionTime": 0,
  "Esp/Enemy/ChamsOccluded/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0.23000001907348634,
      0,
      1
    ]
  },
  "Esp/EnemyVisOverrides/HealthBar": false,
  "AntiAim/Pitch": "Random2",
  "Rage/FOV": 360,
  "Movement/AutoStrafer/Intensity": 65,
  "Esp/TeamVisOverrides/Name/Color": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "Esp/Enemy/Name/Color": {
    "alpha": 1,
    "rgb": [
      0.3271294832229614,
      0.15644998848438264,
      0.7450000047683716
    ]
  },
  "Esp/Enemy/ChamsOccluded": true,
  "Esp/EnemyVisOverrides/Ammo/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Visuals/BT/Enabled": true,
  "Misc/Weapons/InstantScope": true,
  "SilentAim/Main/Enabled": true,
  "Esp/EnemyVisOverrides/Box": false,
  "Visuals/World/Shadows": true,
  "AutoRunScript": true,
  "Esp/Extra/Size/Height": 10,
  "Visuals/Effects/ColorCorrection/Contrast": 45,
  "Esp/TeamVisOverrides/Distance/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Esp/Team/ChamsOccluded/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0.9725490212440491,
      0.5803920030593872
    ]
  },
  "SilentAim/FOV/Draw": false,
  "Misc/HitSounds/Volume": 3,
  "Misc/Weapons/AlwaysBackstab": true,
  "Esp/Enemy/Name/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0.8299999237060547,
      1,
      0
    ]
  },
  "Legitbot/FOV/Color": {
    "alpha": 0,
    "rgb": [
      0,
      1,
      0.2500002384185791
    ]
  },
  "Esp/TeamVisOverrides/Ammo/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Triggerbot/Targeting/Hitparts": {
    "RightArm": false,
    "Head": true,
    "Body": false,
    "LeftArm": false,
    "RightLeg": false,
    "LeftLeg": false
  },
  "Final Color": false,
  "Misc/DeviceSpoofer": true,
  "Visuals/World/ColorShift": true,
  "Misc/AutoLoadout": true,
  "Top Ambient/Sky Color": false,
  "Movement/AutoStrafer/Pattern": "Adaptive",
  "settings/menu/accent_label": false,
  "Esp/Team/Enabled": false,
  "Visuals/ThirdPerson/HideCharacter": false,
  "Esp/Team/WeaponText/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Direct Outdoor Ambient Color": false,
  "settings/menu/font_label": false,
  "Misc/Character/SlideBoost/Value": 5,
  "Esp/Team/Box/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Esp/Enemy/Box/Color": {
    "alpha": 1,
    "rgb": [
      0.43968749046325686,
      0.004374995827674866,
      0.875
    ]
  },
  "Visuals/Asus/ColorEnabled": false,
  "Movement/JumpBug/Bind": {
    "key": [
      "KeyCode",
      "X"
    ],
    "mode": "Hold"
  },
  "Visuals/World/ShadowSoftness": 50,
  "Visuals/Effects/Bloom/Intensity": 50,
  "Esp/Team/Ammo/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Esp/Enemy/Ammo/Color": {
    "alpha": 1,
    "rgb": [
      0.32000017166137698,
      0,
      1
    ]
  },
  "Visuals/Removables/FireVisual": false,
  "settings/menu/accent": {
    "alpha": 1,
    "rgb": [
      0.6499996185302734,
      0,
      1
    ]
  },
  "Esp/Team/Chams/Color": {
    "alpha": 0.5,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Visuals/BT/FaceCamera": true,
  "Esp/TeamVisOverrides/HealthBar/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "settings/menu/font_size": 14,
  "Esp/Team/Box": true,
  "AntiAim/Roll": "Random",
  "Misc/Character/JumpPower/Value": 1,
  "Visuals/World/Fog/Density": 50,
  "Visuals/Asus/Transparency": 50,
  "Triggerbot/Advanced/MaxDelay": 120,
  "Legitbot/Targeting/VisCheck": false,
  "Esp/Team/Distance": true,
  "Esp/EnemyVisOverrides/WeaponText/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Fog Color": false,
  "Esp/TeamVisOverrides/HealthBar": false,
  "Esp/Enemy/Box/Type": "Full",
  "Misc/Character/FlyHack/Value": 10000,
  "Bottom Ambient/Ground Color": false,
  "Esp/TeamVisOverrides/KatanaStatus/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "Visuals/ThirdPerson/X": 3,
  "Esp/Enemy/HealthBar/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0.32000017166137698,
      0,
      1
    ]
  },
  "Esp/Enemy/Distance/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0.8599998950958252,
      1,
      0
    ]
  },
  "Esp/Team/Chams": true,
  "Esp/EnemyVisOverrides/KatanaStatus/Color": {
    "alpha": 1,
    "rgb": [
      1,
      0,
      0
    ]
  },
  "Visuals/Effects/SunRays": true,
  "Misc/AutoQueue": true,
  "Esp/TeamVisOverrides/WeaponText/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Visuals/GunChams/Enabled/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "AntiAim/Yaw": "Glitch Spin",
  "Initial Color": false,
  "Esp/Team/WeaponText": true,
  "Esp/TeamVisOverrides/Ammo": false,
  "Roll": false,
  "Auto Strafe Pattern": false,
  "Misc/HitSounds/Enabled": true,
  "Esp/Enemy/Distance/Color": {
    "alpha": 1,
    "rgb": [
      0.1700000762939453,
      0,
      1
    ]
  },
  "Esp/Enemy/HealthBar/Color0": {
    "alpha": 1,
    "rgb": [
      1,
      0.9900000095367432,
      0
    ]
  },
  "Visuals/ViewmodelOffset/Z": 0,
  "Esp/TeamVisOverrides/Box/Color": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "SilentAim/Targeting/PreferHitpart": false,
  "Esp/Extra/HPBarThickness": 2,
  "Visuals/GunChams/Material": "ForceField",
  "GC FF Animation": false,
  "Esp/EnemyVisOverrides/Box/Color": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "Esp/Enemy/WeaponText": true,
  "Esp/Team/KatanaStatus": true,
  "Misc/Character/FlyHack/Bind": {
    "mode": "Always"
  },
  "Esp/Enemy/Chams/Color": {
    "alpha": 0.5,
    "rgb": [
      0.23000001907348634,
      0,
      1
    ]
  },
  "Movement/EdgeJump": false,
  "Esp/TeamVisOverrides/Name": false,
  "Visuals/World/Fog/Distance": 0,
  "Legitbot/Targeting/TeamCheck": true,
  "Visuals/Effects/DepthOfField": true,
  "Visuals/ArmChams/Material": "SmoothPlastic",
  "Esp/Team/Distance/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Visuals/ThirdPerson/Key": {
    "key": [
      "KeyCode",
      "X"
    ],
    "mode": "Always"
  },
  "Esp/Enemy/Box/OutlineColor": {
    "alpha": 1,
    "rgb": [
      1,
      0.9900000095367432,
      0
    ]
  },
  "Esp/Enemy/WeaponText/Color": {
    "alpha": 1,
    "rgb": [
      0.28999996185302737,
      0,
      1
    ]
  },
  "Visuals/ArmChams/Animation": "Galaxy",
  "Yaw Base": false,
  "Esp/EnemyVisOverrides/KatanaStatus/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Visuals/BT/ServerImpacts": true,
  "Esp/Enemy/Ammo": true,
  "Esp/Main/Enabled": true,
  "Misc/Weapons/AntiKatana": true,
  "SilentAim/FOV/Size": 600,
  "Visuals/BT/ShowImpacts": true,
  "Esp/Enemy/Box": true,
  "Movement/AutoStrafer": false,
  "Esp/Enemy/Name": true,
  "Esp/EnemyVisOverrides/Ammo": false,
  "Direct Ambient Color": false,
  "Esp/Team/Distance/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "settings/menu/mobile_tip2": false,
  "Visuals/GunChams/Animation": "Swirl",
  "Esp/Team/HealthBar": true,
  "Rage/Enabled": true,
  "Visuals/ViewmodelOffset/Enabled": false,
  "Misc/Character/Noclip/Bind": {
    "mode": "Always"
  },
  "Legitbot/Targeting/Hitparts": {
    "RightArm": false,
    "Head": true,
    "Body": false,
    "LeftArm": false,
    "RightLeg": false,
    "LeftLeg": false
  },
  "settings/menu/font": "Ubuntu",
  "Esp/TeamVisOverrides/KatanaStatus/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "SilentAim/Main/VisCheck": true,
  "Movement/EdgeJump/Bind": {
    "key": [
      "KeyCode",
      "V"
    ],
    "mode": "Always"
  },
  "Misc/Character/JumpPower/Bind": {
    "mode": "Always"
  },
  "Esp/TeamVisOverrides/HealthBar/Color1": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "Visuals/Effects/Bloom/Threshold": 40,
  "Visuals/Asus/Enabled": false,
  "Esp/Enemy/KatanaStatus/OutlineColor": {
    "alpha": 1,
    "rgb": [
      1,
      0.8400001525878906,
      0
    ]
  },
  "settings/config/list": "x7y3m1u8c1y.json",
  "Visuals/Effects/CameraMotionBlur/Intensity": 50,
  "Misc/AutoLoadout/Secondary2": "Handgun",
  "Misc/AutoQueue/Duel": "1v1",
  "Visuals/BT/Speed": 1,
  "Misc/Weapons/RapidFire": true,
  "Visuals/ArmChams/Enabled": true,
  "Movement/JumpBug": false,
  "Misc/Character/WalkSpeed/Value": 45,
  "Esp/Extra/Size": false,
  "SilentLoad": true,
  "Visuals/World/Fog/Color": {
    "alpha": 0,
    "rgb": [
      1,
      1,
      0.8823529481887817
    ]
  },
  "Misc/AutoLoadout/UtilityLabel": false,
  "Misc/AutoLoadout/Utility2": "Grenade",
  "Esp/Enemy/KatanaStatus/Color": {
    "alpha": 1,
    "rgb": [
      0.28999996185302737,
      0,
      1
    ]
  },
  "Esp/Team/Ammo": true,
  "Legitbot/FOV/Size": 600,
  "Esp/EnemyVisOverrides/Name/Color": {
    "alpha": 1,
    "rgb": [
      0,
      1,
      0
    ]
  },
  "Yaw": false,
  "Visuals/World/Fog/Enabled": false,
  "Esp/Team/Box/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Esp/EnemyVisOverrides/Name": false,
  "Esp/TeamVisOverrides/Distance/Color": {
    "alpha": 1,
    "rgb": [
      1,
      1,
      1
    ]
  },
  "Visuals/GunChams/Enabled": false,
  "Esp/TeamVisOverrides/Name/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Esp/EnemyVisOverrides/Box/OutlineColor": {
    "alpha": 1,
    "rgb": [
      0,
      0,
      0
    ]
  },
  "Misc/Weapons/AutomaticWeapon": true,
  "Visuals/World/OutdoorAmbientColor": {
    "alpha": 0,
    "rgb": [
      0,
      0.8600000143051148,
      0.7309997081756592
    ]
  },
  "Visuals/Effects/SunRays/Intensity": 25
}
