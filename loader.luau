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
local TabNames = {"main", "world", "esp", "visuals", "character", "misc", "setting"}
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
 
