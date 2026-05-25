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

-- [[ 2. 글로벌 치트 상태 변수 (진짜 본체 기능 제어용) ]]
local CheatSettings = {
    SilentAim = false,
    HitChance = 100,
    FOVSize = 150,
    ShowFOV = false,
    WalkSpeedValue = 16,
    FlyHack = false,
    RapidFire = false,
    NoSpread = false,
    InfAmmo = false,
    EspEnabled = false,
    EspBoxes = false,
    EspTracers = false
}

-- [[ 3. 최상위 GUI 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_PREMIUM_UE"
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false

-- [[ 4. 메인 백그라운드 프레임 (Linoria 스타일의 깔끔한 테마) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

-- 테마 포인트 라인 (상단에 붉은색 선 강조)
local TopLine = Instance.new("Frame", MainFrame)
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
TopLine.BorderSizePixel = 0

-- 상단 타이틀 바
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 30)
Title.Position = UDim2.new(0, 12, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 PREMIUM - PREMIUM EDITION"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 5. 7대 탭 메뉴 바 디자인 ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 28)
TabBar.Position = UDim2.new(0, 12, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(30, 30, 30)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 1)

-- 콘텐츠 스크린 영역
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -75)
ContentFrame.Position = UDim2.new(0, 12, 0, 65)
ContentFrame.BackgroundTransparency = 1

-- [[ 6. 탭 페이지 및 좌우 스크롤 스플릿 빌더 ]]
local Tabs = {}
local function CreateTabPages(tabName)
    local Page = Instance.new("Frame", ContentFrame)
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -6, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 3
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 8)
    L_Layout.SortOrder = Enum.SortOrder.LayoutOrder
    L_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LeftScroll.CanvasSize = UDim2.new(0, 0, 0, L_Layout.AbsoluteContentSize.Y + 10)
    end)
    
    local RightScroll = Instance.new("ScrollingFrame", Page)
    RightScroll.Name = "Right"
    RightScroll.Size = UDim2.new(0.5, -6, 1, 0)
    RightScroll.Position = UDim2.new(0.5, 6, 0, 0)
    RightScroll.BackgroundTransparency = 1
    RightScroll.BorderSizePixel = 0
    RightScroll.ScrollBarThickness = 3
    RightScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local R_Layout = Instance.new("UIListLayout", RightScroll)
    R_Layout.Padding = UDim.new(0, 8)
    R_Layout.SortOrder = Enum.SortOrder.LayoutOrder
    R_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        RightScroll.CanvasSize = UDim2.new(0, 0, 0, R_Layout.AbsoluteContentSize.Y + 10)
    end)

    Tabs[tabName] = {Left = LeftScroll, Right = RightScroll, Page = Page}
end

local TabNames = {"main", "world", "esp", "visuals", "character", "misc", "setting"}
for i, name in ipairs(TabNames) do CreateTabPages(name) end

-- 탭 버튼 셋업
local function SetupTabButton(name, order)
    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 76, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
    TabBtn.Font = Enum.Font.Code
    TabBtn.TextSize = 11
    TabBtn.LayoutOrder = order

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then 
                b.TextColor3 = Color3.fromRGB(140, 140, 140)
                b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            end
        end
        Tabs[name].Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 0, 50)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
end

for i, name in ipairs(TabNames) do SetupTabButton(name, i) end
Tabs["main"].Page.Visible = true
TabBar:GetChildren()[2].TextColor3 = Color3.fromRGB(255, 0, 50)
TabBar:GetChildren()[2].BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- [[ 7. 고품질 UI 컴포넌트 프레임워크 함수 정의 ]]
function _G.AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -4, 0, 10)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(32, 32, 32)
    
    local SecTitle = Instance.new("TextLabel", SectionFrame)
    SecTitle.Size = UDim2.new(1, -10, 0, 16)
    SecTitle.Position = UDim2.new(0, 8, 0, -8)
    SecTitle.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    SecTitle.Text = " " .. titleName:lower() .. " "
    SecTitle.TextColor3 = Color3.fromRGB(255, 0, 50)
    SecTitle.Font = Enum.Font.Code
    SecTitle.TextSize = 11
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local Container = Instance.new("Frame", SectionFrame)
    Container.Size = UDim2.new(1, -12, 1, -14)
    Container.Position = UDim2.new(0, 6, 0, 8)
    Container.BackgroundTransparency = 1
    local C_Layout = Instance.new("UIListLayout", Container)
    C_Layout.Padding = UDim.new(0, 6)
    C_Layout.SortOrder = Enum.SortOrder.LayoutOrder

    C_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, -4, 0, C_Layout.AbsoluteContentSize.Y + 18)
    end)
    
    return Container
end

function _G.AddToggle(section, text, default, callback)
    local Row = Instance.new("Frame", section)
    Row.Size = UDim2.new(1, 0, 0, 16)
    Row.BackgroundTransparency = 1
    
    local Box = Instance.new("TextButton", Row)
    Box.Size = UDim2.new(0, 12, 0, 12)
    Box.Position = UDim2.new(0, 2, 0.5, -6)
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Box.Text = ""
    Box.BackgroundColor3 = default and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(22, 22, 22)
    
    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text:lower()
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = default
    Box.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(22, 22, 22)
        callback(state)
    end)
end

function _G.AddSlider(section, text, min, max, default, callback)
    local SliderRow = Instance.new("Frame", section)
    SliderRow.Size = UDim2.new(1, 0, 0, 28)
    SliderRow.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderRow)
    Label.Size = UDim2.new(1, 0, 0, 12)
    Label.Position = UDim2.new(0, 2, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text:lower()
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", SliderRow)
    ValueLabel.Size = UDim2.new(1, -4, 0, 12)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = default
    ValueLabel.TextColor3 = Color3.fromRGB(255, 0, 50)
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local Track = Instance.new("TextButton", SliderRow)
    Track.Size = UDim2.new(1, -4, 0, 8)
    Track.Position = UDim2.new(0, 2, 0, 15)
    Track.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Track.BorderSizePixel = 1
    Track.BorderColor3 = Color3.fromRGB(35, 35, 35)
    Track.Text = ""

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    Fill.BorderSizePixel = 0

    local SetValue = function(input)
        local l = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(l, 0, 1, 0)
        local val = math.floor(min + (max - min) * l)
        ValueLabel.Text = tostring(val)
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

-- [[ 8. 7대 탭 컴포넌트 실시간 완전 배치 ]]

-- 1. MAIN 탭 (에임봇)
local MainSec = _G.AddSection(Tabs["main"].Left, "Silent Aim Settings")
_G.AddToggle(MainSec, "Enable Silent Aim", false, function(v) CheatSettings.SilentAim = v end)
_G.AddToggle(MainSec, "Show FOV Circle", false, function(v) CheatSettings.ShowFOV = v end)
_G.AddSlider(MainSec, "Hit Chance", 0, 100, 100, function(v) CheatSettings.HitChance = v end)
_G.AddSlider(MainSec, "FOV Radius", 50, 800, 150, function(v) CheatSettings.FOVSize = v end)

-- 2. WORLD 탭
local WorldSec = _G.AddSection(Tabs["world"].Left, "Environment Mod")
_G.AddToggle(WorldSec, "Fullbright (No Shadows)", false, function(v) 
    game:GetService("Lighting").Ambient = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
end)

-- 3. ESP 탭
local EspSec = _G.AddSection(Tabs["esp"].Left, "Visual ESP System")
_G.AddToggle(EspSec, "Master ESP", false, function(v) CheatSettings.EspEnabled = v end)
_G.AddToggle(EspSec, "Draw Boxes", false, function(v) CheatSettings.EspBoxes = v end)
_G.AddToggle(EspSec, "Draw Snaplines", false, function(v) CheatSettings.EspTracers = v end)

-- 4. VISUALS 탭
local VisualsSec = _G.AddSection(Tabs["visuals"].Left, "Screen Special Effects")
_G.AddToggle(VisualsSec, "Enable Bloom Effect", false, function(v) print("Bloom toggle:", v) end)

-- 5. CHARACTER 탭 (기동성)
local CharSec = _G.AddSection(Tabs["character"].Left, "Speed & Fly Modifier")
_G.AddSlider(CharSec, "WalkSpeed Value", 16, 150, 16, function(v) CheatSettings.WalkSpeedValue = v end)
_G.AddToggle(CharSec, "Enable Fly Hack", false, function(v) CheatSettings.FlyHack = v end)

-- 6. MISC 탭 (무기 커스텀)
local MiscSec = _G.AddSection(Tabs["misc"].Left, "Gun Modification")
_G.AddToggle(MiscSec, "Instant Rapid Fire", false, function(v) CheatSettings.RapidFire = v end)
_G.AddToggle(MiscSec, "No Spread / Recoil", false, function(v) CheatSettings.NoSpread = v end)
_G.AddToggle(MiscSec, "Infinite Ammo", false, function(v) CheatSettings.InfAmmo = v end)

-- 7. SETTING 탭
local SettingSec = _G.AddSection(Tabs["setting"].Left, "Configuration Profiles")
_G.AddToggle(SettingSec, "Auto Load Configuration", false, function(v) print("Config Auto Load:", v) end)


-- [[ 9. 아까 가져온 105P, 9P 진짜 핵 엔진 본체 백엔드 연동 ]]

-- FOV 원그리기 드로잉 세팅
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 50)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1

local function GetClosestPlayer()
    local NearestTarget = nil
    local MaxDistance = CheatSettings.FOVSize
    local MousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if OnScreen then
                local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                if Distance < MaxDistance then
                    MaxDistance = Distance
                    NearestTarget = player.Character
                end
            end
        end
    end
    return NearestTarget
end

-- Silent Aim 엔진 비트 후킹 구현 (Metatable 개조)
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and (Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast") and CheatSettings.SilentAim then
        if math.random(1, 100) <= CheatSettings.HitChance then
            local Target = GetClosestPlayer()
            if Target and Target:FindFirstChild("Head") then
                if Method == "Raycast" then
                    Args[2] = (Target.Head.Position - Args[1]).Unit * 1000
                end
                return OldNamecall(self, unpack(Args))
            end
        end
    end
    return OldNamecall(self, ...)
end)

-- 105페이지의 심장: RenderStepped 기반 최적화 실시간 연산 프레임워크 룹
table.insert(_G.SolarConnections, RunService.RenderStepped:Connect(function()
    pcall(function()
        -- 1. FOV 서클 상태 동기화
        FOVCircle.Visible = CheatSettings.ShowFOV
        FOVCircle.Radius = CheatSettings.FOVSize
        FOVCircle.Position = UserInputService:GetMouseLocation()
        
        -- 2. 캐릭터 스피드 강제 고정 룹
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local Hum = LocalPlayer.Character.Humanoid
            if Hum.WalkSpeed ~= CheatSettings.WalkSpeedValue then
                Hum.WalkSpeed = CheatSettings.WalkSpeedValue
            end
            
            -- 플라이 핵 루틴
            local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if CheatSettings.FlyHack and HRP then
                HRP.Velocity = Vector3.new(HRP.Velocity.X, 0, HRP.Velocity.Z)
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    HRP.CFrame = HRP.CFrame + Vector3.new(0, 1.5, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    HRP.CFrame = HRP.CFrame - Vector3.new(0, 1.5, 0)
                end
            end
        end
        
        -- 3. 무기 메카니즘 스크립트 모듈 변조 실시간 오버라이드
        if CheatSettings.RapidFire or CheatSettings.NoSpread or CheatSettings.InfAmmo then
            for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("ModuleScript") and (v.Name:lower():find("weapon") or v.Name:lower():find("gun") or v.Name:lower():find("ammo")) then
                    local data = require(v)
                    if type(data) == "table" then
                        if CheatSettings.NoSpread then data.Spread = 0 data.MinSpread = 0 data.Recoil = 0 end
                        if CheatSettings.RapidFire then data.FireRate = 0.02 data.Cooldown = 0 end
                        if CheatSettings.InfAmmo then data.Ammo = 999 data.ClipSize = 999 end
                    end
                end
            end
        end
    end)
end))

-- [[ 10. 마스터 UI 토글 제어 스위치 ]]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "UIToggleButton"
ToggleBtn.Size = UDim2.new(0, 50, 0, 32)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "SOLAR"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 50)
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 12
ToggleBtn.BorderSizePixel = 1
ToggleBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("[SOLAR MASTER V1] 새로운 프리미엄 통합 UI 및 실시간 엔진 완전 세팅 완료!")
