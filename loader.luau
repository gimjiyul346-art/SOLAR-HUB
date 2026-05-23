local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- [[ 1. 중복 실행 방지 ]]
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_PREMIUM_UE" then v:Destroy() end
end

-- [[ 2. 최상위 Gui 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_PREMIUM_UE"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 백그라운드 프레임 (Unamed Enhancements 스타일 딥 차콜 블랙) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40) -- 정밀한 외곽선
MainFrame.Active = true
MainFrame.Draggable = true -- 모바일/PC 드래그 이동 가능

-- 상단 얇은 타이틀 텍스트
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - discord.gg/solar"
Title.TextColor3 = Color3.fromRGB(150, 150, 150)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 상단 탭 메뉴 바 ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 24)
TabBar.Position = UDim2.new(0, 12, 0, 25)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(35, 35, 35)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 탭 전환 시 기능 컴포넌트들이 교체되어 보일 메인 컨테이너
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -65)
ContentFrame.Position = UDim2.new(0, 12, 0, 55)
ContentFrame.BackgroundTransparency = 1

local Tabs = {}

-- 탭별 내부 좌/우 스크롤 레이아웃 생성기
local function CreateTabPages(tabName)
    local Page = Instance.new("Frame", ContentFrame)
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    -- 좌측 스크롤 라인
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
    -- 우측 스크롤 라인
    local RightScroll = Instance.new("ScrollingFrame", Page)
    RightScroll.Name = "Right"
    RightScroll.Size = UDim2.new(0.5, -5, 1, 0)
    RightScroll.Position = UDim2.new(0.5, 5, 0, 0)
    RightScroll.BackgroundTransparency = 1
    RightScroll.BorderSizePixel = 0
    RightScroll.ScrollBarThickness = 2
    RightScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
    local R_Layout = Instance.new("UIListLayout", RightScroll)
    R_Layout.Padding = UDim.new(0, 10)

    Tabs[tabName] = {Left = LeftScroll, Right = RightScroll, Page = Page}
end

-- [디자인 틀] 사용하고 싶은 탭 명칭 선언 구역
CreateTabPages("main")
CreateTabPages("world")
CreateTabPages("esp")

-- 탭 버튼 생성 및 클릭 시 화면 체인지 이벤트 함수
local function SetupTabButton(name, order)
    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 65, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    TabBtn.Font = Enum.Font.Code
    TabBtn.TextSize = 12
    TabBtn.LayoutOrder = order

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(160, 160, 160) end
        end
        Tabs[name].Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 120, 255) -- 선택 시 하이라이트 블루광
    end)
end

-- 상단 메뉴 바 버튼 세팅
SetupTabButton("main", 1)
SetupTabButton("world", 2)
SetupTabButton("esp", 3)

-- 켜졌을 때 기본 디폴트 오픈 페이지 지정
Tabs["main"].Page.Visible = true

-- [[ 5. 파란색 테두리 구역(Section) 디자인 함수 ]]
local function AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 150) -- 내부에 들어갈 아이템 개수에 맞게 확장됨
    SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(0, 85, 255) -- ⚡ 선명한 네온 블루 보더
    
    local SecTitle = Instance.new("TextLabel", SectionFrame)
    SecTitle.Size = UDim2.new(1, -10, 0, 18)
    SecTitle.Position = UDim2.new(0, 8, 0, 2)
    SecTitle.BackgroundTransparency = 1
    SecTitle.Text = titleName
    SecTitle.TextColor3 = Color3.fromRGB(0, 120, 255)
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

-- [[ 6. 미니 체크박스 토글(Toggle) 컴포넌트 함수 ]]
local function AddToggle(section, text, default, callback)
    local Row = Instance.new("Frame", section)
    Row.Size = UDim2.new(1, 0, 0, 20)
    Row.BackgroundTransparency = 1
    
    local Box = Instance.new("TextButton", Row)
    Box.Size = UDim2.new(0, 12, 0, 12)
    Box.Position = UDim2.new(0, 5, 0.5, -6)
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Box.Text = ""
    Box.BackgroundColor3 = default and Color3.fromRGB(0, 85, 255) or Color3.fromRGB(14, 14, 14)
    
    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Position = UDim2.new(0, 22, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = default
    Box.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(0, 85, 255) or Color3.fromRGB(14, 14, 14)
        callback(state)
    end)
end

-- [[ 7. 정밀 드레그 게이지 슬라이더(Slider) 컴포넌트 함수 ]]
local function AddSlider(section, text, min, max, default, callback)
    local SliderRow = Instance.new("Frame", section)
    SliderRow.Size = UDim2.new(1, 0, 0, 32)
    SliderRow.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderRow)
    Label.Size = UDim2.new(1, 0, 0, 14)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", SliderRow)
    ValueLabel.Size = UDim2.new(1, -10, 0, 14)
    ValueLabel.Position = UDim2.new(0, 0, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = default .. " / " .. max
    ValueLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
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
    Fill.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
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

-- [[ 8. UI 미니 고정 토글 버튼 (열고 닫기용) ]]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "UIToggleButton"
ToggleBtn.Size = UDim2.new(0, 45, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 1
ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ 1. 중복 실행 및 백엔드 꼬임 완벽 초기화 ]]
if _G.Connections then
    for _, conn in pairs(_G.Connections) do
        if conn then conn:Disconnect() end
    end
end
_G.Connections = {}

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_PREMIUM_UE" then v:Destroy() end
end

-- [[ 2. 최상위 Gui 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_PREMIUM_UE"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 백그라운드 프레임 ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - ANTI-FREEZE PATCH"
Title.TextColor3 = Color3.fromRGB(255, 0, 50)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 탭 메뉴 바 ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 24)
TabBar.Position = UDim2.new(0, 12, 0, 25)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(35, 35, 35)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -65)
ContentFrame.Position = UDim2.new(0, 12, 0, 55)
ContentFrame.BackgroundTransparency = 1

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
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
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

CreateTabPages("main")
CreateTabPages("world")
CreateTabPages("esp")

local function SetupTabButton(name, order)
    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 65, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    TabBtn.Font = Enum.Font.Code
    TabBtn.TextSize = 12
    TabBtn.LayoutOrder = order

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(160, 160, 160) end
        end
        Tabs[name].Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 0, 50)
    end)
end

SetupTabButton("main", 1)
SetupTabButton("world", 2)
SetupTabButton("esp", 3)
Tabs["main"].Page.Visible = true

-- [[ 5. 섹션 프레임 생성 함수 ]]
local function AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 195)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(255, 0, 50)
    
    local SecTitle = Instance.new("TextLabel", SectionFrame)
    SecTitle.Size = UDim2.new(1, -10, 0, 18)
    SecTitle.Position = UDim2.new(0, 8, 0, 2)
    SecTitle.BackgroundTransparency = 1
    SecTitle.Text = titleName
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

-- [[ 6. 토글 기능 함수 ]]
local function AddToggle(section, text, default, callback)
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
    Label.Text = text
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

-- [[ 7. 슬라이더 함수 ]]
local function AddSlider(section, text, min, max, default, callback)
    local SliderRow = Instance.new("Frame", section)
    SliderRow.Size = UDim2.new(1, 0, 0, 32)
    SliderRow.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderRow)
    Label.Size = UDim2.new(1, 0, 0, 14)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
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

-- [[ 8. UI 토글 버튼 ]]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "UIToggleButton"
ToggleBtn.Size = UDim2.new(0, 45, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 1
ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)


-- ====================================================================
-- ⚡ 백엔드 기능 제어 엔진 (안정화 픽스)
-- ====================================================================

_G.AimbotEnabled = false
_G.SilentAimEnabled = false
_G.TriggerBotEnabled = false
_G.RageBotEnabled = false
_G.AutoFarmEnabled = false
_G.AimbotFOV = 100

_G.BoxESP = false
_G.NameESP = false
_G.HealthESP = false
_G.WeaponESP = false

_G.NoClipEnabled = false
_G.InfiniteJump = false
local CurrentJumpPower = 50

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 0, 50)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.AimbotFOV
FOVCircle.Filled = false

table.insert(_G.Connections, RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
end))

local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = 999999
    local MousePos = UserInputService:GetMouseLocation()
    local MyCharacter = LocalPlayer.Character
    if not MyCharacter then return nil end
    local MyHRP = MyCharacter:FindFirstChild("HumanoidRootPart")
    if not MyHRP then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local TargetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if TargetPart and Humanoid and Humanoid.Health > 0 then
                if _G.AutoFarmEnabled then
                    local Distance = (MyHRP.Position - TargetPart.Position).Magnitude
                    if Distance < MaxDistance then
                        MaxDistance = Distance
                        ClosestTarget = TargetPart
                    end
                else
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)
                    if OnScreen then
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                        if Distance < _G.AimbotFOV then
                            if Distance < MaxDistance then
                                MaxDistance = Distance
                                ClosestTarget = TargetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- 오토팜 텔레포트 (밀착 거리 고정)
table.insert(_G.Connections, RunService.Heartbeat:Connect(function()
    if _G.AutoFarmEnabled and LocalPlayer.Character then
        local MyHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local TargetPart = GetClosestPlayer()
        
        if MyHRP and TargetPart and TargetPart.Parent then
            MyHRP.CFrame = TargetPart.CFrame * CFrame.new(0, 1.8, 0)
            MyHRP.Velocity = Vector3.new(0, 0, 0)
        end
    end
end))

-- 사일런트 에임 인덱스 바인딩 (메타테이블 우회방식 안정화)
local Meta = getrawmetatable(game)
local OldIndex = Meta.__index
setreadonly(Meta, false)

Meta.__index = newcstackclosure(function(Self, Key)
    if _G.SilentAimEnabled and tostring(Self) == "Mouse" and Key == "Hit" then
        local Target = GetClosestPlayer()
        if Target then
            return Target.CFrame
        end
    end
    return OldIndex(Self, Key)
end)
setreadonly(Meta, true)

-- 트리거봇 가상 액티베이트 루프
table.insert(_G.Connections, RunService.RenderStepped:Connect(function()
    if _G.TriggerBotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Parent then
            local PlayerTarget = Players:GetPlayerFromCharacter(Target.Parent)
            if PlayerTarget and PlayerTarget ~= LocalPlayer then
                local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if Tool then
                    Tool:Activate()
                end
            end
        end
    end
end))

-- 레이지 에임봇 루프
table.insert(_G.Connections, RunService.RenderStepped:Connect(function()
    local Target = GetClosestPlayer()
    if Target then
        if _G.RageBotEnabled or _G.AimbotEnabled then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
        end
    end
end))

local function GetCurrentWeapon(player)
    if not player.Character then return "Hands" end
    local Tool = player.Character:FindFirstChildOfClass("Tool")
    if Tool then return Tool.Name end
    for _, child in pairs(player.Character:GetChildren()) do
        if child:IsA("Model") and (child.Name:lower():match("rifle") or child.Name:lower():match("pistol") or child.Name:lower():match("shotgun") or child.Name:lower():match("sniper") or child.Name:lower():match("smg") or child.Name:lower():match("weapon")) then
            return child.Name
        end
    end
    return "Equipped"
end

local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Thickness = 1
    Box.Filled = false
    Box.Color = Color3.fromRGB(255, 0, 50)

    local NameLabel = Drawing.new("Text")
    NameLabel.Size = 13
    NameLabel.Center = true
    NameLabel.Outline = true
    NameLabel.Color = Color3.fromRGB(255, 255, 255)

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = true

    local WeaponLabel = Drawing.new("Text")
    WeaponLabel.Size = 11
    WeaponLabel.Center = true
    WeaponLabel.Outline = true
    WeaponLabel.Color = Color3.fromRGB(0, 255, 255)

    local Connection

    local function StartTracking()
        if Connection then Connection:Disconnect() end
        
        Connection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
                local HRP = player.Character.HumanoidRootPart
                local Humanoid = player.Character.Humanoid
                local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

                if OnScreen then
                    local TopSpace = Camera:WorldToViewportPoint(HRP.Position + Vector3.new(0, 3, 0))
                    local BottomSpace = Camera:WorldToViewportPoint(HRP.Position - Vector3.new(0, 3.5, 0))
                    local Height = math.abs(TopSpace.Y - BottomSpace.Y)
                    local Width = Height / 1.5

                    if _G.BoxESP then
                        Box.Size = Vector2.new(Width, Height)
                        Box.Position = Vector2.new(Pos.X - Width/2, Pos.Y - Height/2)
                        Box.Visible = true
                    else Box.Visible = false end

                    if _G.NameESP then
                        NameLabel.Text = player.Name
                        NameLabel.Position = Vector2.new(Pos.X, (Pos.Y - Height/2) - 15)
                        NameLabel.Visible = true
                    else NameLabel.Visible = false end

                    if _G.HealthESP then
                        local HealthPercent = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
                        HealthBar.Size = Vector2.new(2, Height * HealthPercent)
                        HealthBar.Position = Vector2.new((Pos.X - Width/2) - 6, Pos.Y - Height/2 + (Height * (1 - HealthPercent)))
                        HealthBar.Color = Color3.fromRGB(255 * (1 - HealthPercent), 255 * HealthPercent, 0)
                        HealthBar.Visible = true
                    else HealthBar.Visible = false end

                    if _G.WeaponESP then
                        WeaponLabel.Text = GetCurrentWeapon(player)
                        WeaponLabel.Position = Vector2.new(Pos.X, (Pos.Y + Height/2) + 5)
                        WeaponLabel.Visible = true
                    else WeaponLabel.Visible = false end
                else
                    Box.Visible = false; NameLabel.Visible = false; HealthBar.Visible = false; WeaponLabel.Visible = false
                end
            else
                Box.Visible = false; NameLabel.Visible = false; HealthBar.Visible = false; WeaponLabel.Visible = false
                if not player.Parent then
                    Box:Remove(); NameLabel:Remove(); HealthBar:Remove(); WeaponLabel:Remove()
                    if Connection then Connection:Disconnect() end
                end
            end
        end)
        table.insert(_G.Connections, Connection)
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.3)
        StartTracking()
    end)
    
    if player.Character then StartTracking() end
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
table.insert(_G.Connections, Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end))

table.insert(_G.Connections, RunService.Stepped:Connect(function()
    if (_G.NoClipEnabled or _G.AutoFarmEnabled) and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

table.insert(_G.Connections, UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Hum then 
            Hum.UseJumpPower = true
            Hum:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end))

table.insert(_G.Connections, LocalPlayer.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid")
    Hum.UseJumpPower = true
    Hum.JumpPower = CurrentJumpPower
end))


-- ====================================================================
-- 🛠️ UI 배치 (자체 스킨핵 복구 및 프리징 차단)
-- ====================================================================

local AimSection = AddSection(Tabs["main"].Left, "combat & auto farm settings")
AddToggle(AimSection, "aimbot enabled", false, function(state) _G.AimbotEnabled = state end)
AddToggle(AimSection, "silent aim (legit)", false, function(state) _G.SilentAimEnabled = state end)
AddToggle(AimSection, "trigger bot (auto-shot)", false, function(state) _G.TriggerBotEnabled = state end)
AddToggle(AimSection, "rage bot (ultra hard)", false, function(state) _G.RageBotEnabled = state end)
AddToggle(AimSection, "auto farm (teleport)", false, function(state) _G.AutoFarmEnabled = state end)
AddToggle(AimSection, "show fov circle", false, function(state) FOVCircle.Visible = state end)
AddSlider(AimSection, "fov radius", 30, 500, 100, function(val) _G.AimbotFOV = val end)

local VisualSection = AddSection(Tabs["esp"].Left, "esp overlay")
AddToggle(VisualSection, "box esp", false, function(state) _G.BoxESP = state end)
AddToggle(VisualSection, "name esp (top)", false, function(state) _G.NameESP = state end)
AddToggle(VisualSection, "health esp (bar)", false, function(state) _G.HealthESP = state end)
AddToggle(VisualSection, "weapon esp (bottom)", false, function(state) _G.WeaponESP = state end)

local MiscSection = AddSection(Tabs["world"].Left, "misc utilities")
AddToggle(MiscSection, "noclip", false, function(state) _G.NoClipEnabled = state end)
AddToggle(MiscSection, "infinite jump", false, function(state) _G.InfiniteJump = state end)
AddSlider(MiscSection, "jump power", 50, 400, 50, function(val)
    CurrentJumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- [개선] 프리징을 유발하는 외부 링크 대신 내부 클라이언트 텍스처를 스와핑하는 안전 스킨핵 방식으로 전면 개조
AddToggle(MiscSection, "unlock all skins (safe)", false, function(state)
    if state then
        local function ApplySafeSkinChanger()
            for _, item in pairs(game:GetDescendants()) do
                -- 라이벌즈 게임 내부 무기 메쉬 및 스킨 텍스처 데이터 안전 스캔 후 덮어쓰기
                if item:IsA("MeshPart") and (item.Name:lower():match("weapon") or item.Name:lower():match("gun")) then
                    -- 튕김 현상을 유발하는 외부 모듈 호출 없이 내부 메테리얼 광택만 최대로 펌핑하여 희귀 스킨 연출
                    item.Material = Enum.Material.ForceField
                    item.Color = Color3.fromRGB(255, 215, 0) -- 골드 스킨 효과
                end
            end
        end
        task.spawn(ApplySafeSkinChanger)
        print("Safe SkinChanger Loop Active!")
    else
        print("Safe SkinChanger Disabled.")
    end
end)
