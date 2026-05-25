-- ====================================================================
-- [SOLAR HUB V1 마스터 시스템: UI + 엔진 최종 통합본]
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local replicated_storage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local utility = require(replicated_storage.Modules.Utility)

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

-- [[ 3. 메인 백그라운드 프레임 ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 440)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

-- 상단 타이틀 바
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

-- 콘텐츠 스크린 영역
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
    
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    L_Layout.SortOrder = Enum.SortOrder.LayoutOrder
    L_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LeftScroll.CanvasSize = UDim2.new(0, 0, 0, L_Layout.AbsoluteContentSize.Y + 15)
    end)
    
    local RightScroll = Instance.new("ScrollingFrame", Page)
    RightScroll.Name = "Right"
    RightScroll.Size = UDim2.new(0.5, -5, 1, 0)
    RightScroll.Position = UDim2.new(0.5, 5, 0, 0)
    RightScroll.BackgroundTransparency = 1
    RightScroll.BorderSizePixel = 0
    RightScroll.ScrollBarThickness = 2
    RightScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local R_Layout = Instance.new("UIListLayout", RightScroll)
    R_Layout.Padding = UDim.new(0, 10)
    R_Layout.SortOrder = Enum.SortOrder.LayoutOrder
    R_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        RightScroll.CanvasSize = UDim2.new(0, 0, 0, R_Layout.AbsoluteContentSize.Y + 15)
    end)

    Tabs[tabName] = {Left = LeftScroll, Right = RightScroll, Page = Page}
end

local TabNames = {"main", "world", "esp", "visuals", "character", "misc", "setting"}
for i, name in ipairs(TabNames) do
    CreateTabPages(name)
end

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
Tabs["main"].Page.Visible = true
TabBar:GetChildren()[2].TextColor3 = Color3.fromRGB(255, 0, 50)

-- [[ 6. 섹션 박스 함수 ]]
function _G.AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 0)
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

    C_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, -5, 0, C_Layout.AbsoluteContentSize.Y + 30)
    end)
    
    return Container
end

-- [[ 7. 온/오프 토글 스위치 함수 ]]
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
    callback(default)
end

-- [[ 8. 수치 조절용 슬라이더 함수 ]]
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
    callback(default)
end

-- [[ 9. UI 숨기기 마스터 버튼 ]]
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

table.insert(_G.SolarConnections, ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end))


-- ====================================================================
-- [10. 실시간 치트 하단 백엔드 로직]
-- ====================================================================

local get_players = function()
    local entities = {};
    for _, child in workspace:GetChildren() do
        if child:FindFirstChildOfClass("Humanoid") then
            table.insert(entities, child);
        elseif child.Name == "HurtEffect" then
            for _, hurt_player in child:GetChildren() do
                if (hurt_player.ClassName ~= "Highlight") then
                    table.insert(entities, hurt_player);
                end
            end
        end
    end
    return entities
end

local get_closest_player = function()
    local closest, closest_distance = nil, math.huge;
    local character = LocalPlayer.Character;
    if (character == nil) then return; end
    for _, player in get_players() do
        if (player == LocalPlayer) then continue; end
        if (not player:FindFirstChild("HumanoidRootPart")) then continue; end
        local position, on_screen = Camera:WorldToViewportPoint(player.HumanoidRootPart.Position);
        if (on_screen == false) then continue; end
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2);
        local distance = (center - Vector2.new(position.X, position.Y)).Magnitude;
        if (distance > closest_distance) then continue; end
        closest = player;
        closest_distance = distance;
    end
    return closest;
end

-- 글로벌 스펙 상태 관리 변수 (JSON 데이터 연동)
_G.SilentEnabled = false
_G.SilentHitChance = 100
_G.RageEnabled = false
_G.RageFOV = 360
_G.Wallbang = false
_G.AutoShoot = false
_G.AutoFarm = false
_G.BoxESP = false
_G.AttackSpeed = 5
_G.WalkSpeedValue = 45

-- [Raycast 함수 가로채기 엔진 연동]
local oldRaycast = utility.Raycast
utility.Raycast = function(...)
    local args = {...}
    
    -- Silent Aim 및 Rage 모드 통합 제어 (식별자 999 타겟팅 고정)
    if (_G.SilentEnabled or _G.RageEnabled) and (#args > 0 and args[4] == 999) then
        -- 셋팅된 HitChance 확률 적용 계산
        if math.random(1, 100) <= _G.SilentHitChance then
            local closest = get_closest_player();
            if (closest and closest:FindFirstChild("Head")) then
                args[3] = closest.Head.CFrame.Position; 
            end
        end
    end
    
    -- Wallbang 원리 적용 (필터 인자값 우회 변조)
    if _G.Wallbang and #args > 0 and args[4] == 999 then 
        args[4] = nil 
    end
    
    return oldRaycast(unpack(args))
end

-- [Main 핵심 실행 루프 연동]
table.insert(_G.SolarConnections, RunService.RenderStepped:Connect(function()
    if _G.AutoShoot then
        local target = get_closest_player()
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
        end
    end
    
    -- 머리 위 3 Studs 무한 홀딩 텔레포트
    if _G.AutoFarm then
        local target = get_closest_player()
        if target and target:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Head.CFrame + Vector3.new(0, 3, 0)
        end
    end
end))


-- ====================================================================
-- [11. 메인 탭 UI 구조 설계 및 연동]
-- ====================================================================

task.spawn(function()
    repeat task.wait(0.1) until Tabs and Tabs["main"]
    
    -- 1) MAIN 탭 왼쪽 구역: Combat 시스템 설정
    local CombatSection = _G.AddSection(Tabs["main"].Left, "Combat Masters")
    _G.AddToggle(CombatSection, "Silent Aim", false, function(s) _G.SilentEnabled = s end)
    _G.AddSlider(CombatSection, "Hit Chance", 0, 100, 100, function(v) _G.SilentHitChance = v end)
    _G.AddToggle(CombatSection, "Wallbang", false, function(s) _G.Wallbang = s end)
    _G.AddToggle(CombatSection, "Auto Shoot", false, function(s) _G.AutoShoot = s end)
    _G.AddToggle(CombatSection, "Auto Farm", false, function(s) _G.AutoFarm = s end)
    
    -- 2) MAIN 탭 오른쪽 구역: JSON에서 추출한 Ragebot 특수 옵션들 추가 배치
    local RageSection = _G.AddSection(Tabs["main"].Right, "Ragebot Engine")
    _G.AddToggle(RageSection, "Rage Enabled", true, function(s) _G.RageEnabled = s end)
    _G.AddSlider(RageSection, "Rage FOV", 0, 360, 360, function(v) _G.RageFOV = v end)
    _G.AddSlider(RageSection, "Attack Speed", 1, 10, 5, function(v) _G.AttackSpeed = v end)
    _G.AddSlider(RageSection, "Speed Modify", 16, 150, 45, function(v) _G.WalkSpeedValue = v end)

    -- 3) ESP 탭 왼쪽 구역: 요청받은 Box ESP 토글 스위치 정렬
    local EspSection = _G.AddSection(Tabs["esp"].Left, "Visual ESP Display")
    _G.AddToggle(EspSection, "Box ESP", false, function(s) _G.BoxESP = s end)
    
    print("[SOLAR MASTER] All engine systems and UI successfully injected!")
end)
