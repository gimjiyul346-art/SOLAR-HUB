local CoreGui = game:GetService("CoreGui")

-- [[ 1. 기존 잔상 깔끔하게 청소 ]]
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_INJECTOR_STYLE" then 
        v:Destroy() 
    end
end

-- [[ 2. 최상위 스크린 Gui 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_INJECTOR_STYLE"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 프레임 (사진의 Unnamed Enhancements 스타일) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 380) -- 가로형 정밀 사이즈
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190) -- 정중앙 배치
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- 아주 어두운 차콜 블랙
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(45, 45, 45) -- 얇은 외곽 경계선
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- 모바일 드래그 이동 가능

-- 타이틀 바 네임 (맨 위 얇은 텍스트)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - discord.gg/solar" -- 인젝터 감성 타이틀
Title.TextColor3 = Color3.fromRGB(180, 180, 180)
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 탭 가로 메뉴 바 (사진의 main, world, esp ... 부분) ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 25)
TabBar.Position = UDim2.new(0, 10, 0, 25)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(40, 40, 40)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabBar.LayoutOrder = 1
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)

-- 탭 버튼을 쉽게 만드는 함수
local function CreateTab(name)
    local Tab = Instance.new("TextButton", TabBar)
    Tab.Size = UDim2.new(0, 60, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Text = name
    Tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab.Font = Enum.Font.Code
    Tab.TextSize = 12
end

-- 사진에 있던 감성 탭들 그대로 박아넣기
CreateTab("main")
CreateTab("world")
CreateTab("esp")
CreateTab("visuals")
CreateTab("misc")

-- [[ 5. 기능들이 담길 하단 컨텐츠 박스 (파란색 테두리 구역 분할) ]]
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -65)
ContentFrame.Position = UDim2.new(0, 10, 0, 55)
ContentFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
ContentFrame.BorderSizePixel = 1
ContentFrame.BorderColor3 = Color3.fromRGB(0, 85, 255) -- ⭐새 사진 속 핵심인 '파란색 선 테두리' 연출!

-- 내부 스크롤 영역
local Container = Instance.new("ScrollingFrame", ContentFrame)
Container.Size = UDim2.new(1, -10, 1, -10)
Container.Position = UDim2.new(0, 5, 0, 5)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 85, 255)

local ListLayout = Instance.new("UIListLayout", Container)
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ 6. ⚡ "UI" 버튼 하나로 열고 닫는 토글 연동 ]]
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
ToggleBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [[ 7. 정통 핵 스타일 체크박스(토글) 생성 함수 ]]
local function AddHackToggle(text, default, callback)
    local Row = Instance.new("Frame", Container)
    Row.Size = UDim2.new(1, 0, 0, 25)
    Row.BackgroundTransparency = 1
    
    local Box = Instance.new("TextButton", Row)
    Box.Size = UDim2.new(0, 14, 0, 14)
    Box.Position = UDim2.new(0, 5, 0.5, -7)
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color3.fromRGB(70, 70, 70)
    Box.Text = ""
    -- 켜져 있으면 파란색 채우기, 꺼져 있으면 검은색
    Box.BackgroundColor3 = default and Color3.fromRGB(0, 85, 255) or Color3.fromRGB(15, 15, 15)
    
    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.new(0, 25, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.Code
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = default
    Box.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(0, 85, 255) or Color3.fromRGB(15, 15, 15)
        callback(state)
    end)
end


-- ====================================================================
-- 💡 기능 코드는 이 아래줄부터 마음껏 추가하시면 됩니다!
-- ====================================================================

-- 1. 사일런트 에임 (새 사진에 있던 기능 명칭 그대로 뼈대 조립)
AddHackToggle("silent aim", false, function(state)
    _G.SilentAim = state
    print("Silent Aim:", state)
end)

-- 2. 아까 네가 성공시킨 하늘 파괴 코드 연동 버튼
AddHackToggle("remove server sky", false, function(state)
    _G.RemoveSky = state
    if state then
        local Lighting = game:GetService("Lighting")
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") then v:Destroy() end
        end
    end
end)
