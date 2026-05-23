local CoreGui = game:GetService("CoreGui")

-- [[ 1. 중복 실행 깔끔하게 방지 ]]
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_PREMIUM_UE" then v:Destroy() end
end

-- [[ 2. 최상위 Gui 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_PREMIUM_UE"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 백그라운드 프레임 (사진 속 딥 블랙 사각형) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420) -- 비율에 맞춘 최적의 고급 사이즈
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16) -- 정통 차콜 블랙
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40) -- 얇고 고급스러운 외곽선
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 자유 이동

-- 1) 최상단 얇은 타이틀 텍스트
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - discord.gg/solar"
Title.TextColor3 = Color3.fromRGB(150, 150, 150) -- 은은한 회색조
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 탭 메뉴 바 시스템 (main, world, esp ... 구역) ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 24)
TabBar.Position = UDim2.new(0, 12, 0, 25)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(35, 35, 35)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 1)

-- [[ 5. 기능들이 교체될 메인 컨테이너 주입 ]]
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -65)
ContentFrame.Position = UDim2.new(0, 12, 0, 55)
ContentFrame.BackgroundTransparency = 1

-- 탭별로 보여줄 하위 컨테이너 보관소
local Tabs = {}

local function CreateTabPages(tabName)
    local Page = Instance.new("Frame", ContentFrame)
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false -- 처음엔 다 숨겨둠
    
    -- 좌우 투컴포넌트 배치를 위한 레이아웃 적용
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.Position = UDim2.new(0, 0, 0, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
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

-- 시스템에 탭 페이지 사전 등록
CreateTabPages("main")
CreateTabPages("world")
CreateTabPages("esp")

-- 탭 전환 마법의 기능함수
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
        TabBtn.TextColor3 = Color3.fromRGB(0, 120, 255) -- 활성화된 탭은 정밀 블루광
    end)
end

SetupTabButton("main", 1)
SetupTabButton("world", 2)
SetupTabButton("esp", 3)

-- 기본 첫 화면은 main 페이지 활성화
Tabs["main"].Page.Visible = true

-- [[ 6. 사진 속 핵심 감성: 파란색 테두리 섹션(구역) 박스 디자인 ]]
local function AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 150) -- 내부 내용에 맞게 조절 가능
    SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(0, 85, 255) -- ⚡ 대망의 딥블루 선 연출!
    
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

-- [[ 7. 정통 미니 체크박스 토글 함수 ]]
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

-- [[ 8. UI 원버튼 열고닫기 토글 ]]
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
-- 💡 기능 배치 샘플 구성 (사진 레이아웃 100% 반영)
-- ====================================================================

-- 1. [main 탭] 왼쪽 구역 -> silent aim 박스 분할 생성
local SilentAimSection = AddSection(Tabs["main"].Left, "silent aim")
AddToggle(SilentAimSection, "enabled", false, function(state)
    _G.SilentAim = state
end)
AddToggle(SilentAimSection, "closest part", false, function(state) end)
AddToggle(SilentAimSection, "show fov", false, function(state) end)

-- 2. [main 탭] 오른쪽 구역 -> aimbot / weapons 박스 분할 생성
local AimbotSection = AddSection(Tabs["main"].Right, "aimbot")
AddToggle(AimbotSection, "enabled", false, function(state) end)

local WeaponSection = AddSection(Tabs["main"].Right, "weapons")
AddToggle(WeaponSection, "no spread", false, function(state) end)
AddToggle(WeaponSection, "full auto", false, function(state) end)

-- 3. [world 탭] 왼쪽 구역 -> 그래픽 최적화 박스 세팅
local GraphicSection = AddSection(Tabs["world"].Left, "graphics & map")
AddToggle(GraphicSection, "remove server sky", false, function(state)
    if state then
        local Lighting = game:GetService("Lighting")
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") then v:Destroy() end
        end
    end
end)
