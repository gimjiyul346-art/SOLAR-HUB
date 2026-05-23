local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. 중복 실행 방지 (기존 UI 지우기) ]]
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_HUB" or v.Name == "SOLAR_OPEN_BTN" then 
        v:Destroy() 
    end
end

-- [[ 2. 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_HUB"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 프레임 (전체 창) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 360)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- 딥 블랙
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 이동 가능
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- 테두리 선 (네온 레드)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 60, 60)
Stroke.Thickness = 1.5

-- [[ 4. 타이틀 라벨 ]]
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, -60, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "  SOLAR HUB V1"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 5. ⚡ Close 버튼 (우측 상단 추가) ]]
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 50, 0, 25)
CloseBtn.Position = UDim2.new(1, -60, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
CloseBtn.Text = "Close"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
local CloseStroke = Instance.new("UIStroke", CloseBtn)
CloseStroke.Color = Color3.fromRGB(255, 60, 60)

-- [[ 6. ⚡ Open 버튼 (기본적으로 숨겨짐) ]]
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "SOLAR_OPEN_BTN"
OpenBtn.Size = UDim2.new(0, 60, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0) -- 화면 좌측 중앙 부근
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "Open"
OpenBtn.TextColor3 = Color3.fromRGB(60, 255, 60) -- 열기 버튼은 네온 그린 토글 느낌
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.Visible = false -- 처음엔 메인 창이 켜져 있으므로 숨김
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(60, 255, 60)

-- [[ 7. Open / Close 버튼 기능 연동 ]]
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- [[ 8. 탭 메뉴 바 (Main Rage 등등 영역) ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 4)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ 9. 반으로 나뉜 페이지 구역 (세로 분할선) ]]
local PageFrame = Instance.new("Frame", MainFrame)
PageFrame.Size = UDim2.new(1, -20, 1, -90)
PageFrame.Position = UDim2.new(0, 10, 0, 80)
PageFrame.BackgroundTransparency = 1

-- 왼쪽 스크롤 구역
local LeftSection = Instance.new("ScrollingFrame", PageFrame)
LeftSection.Size = UDim2.new(0.5, -5, 1, 0)
LeftSection.Position = UDim2.new(0, 0, 0, 0)
LeftSection.BackgroundTransparency = 1
LeftSection.ScrollBarThickness = 2
local LeftLayout = Instance.new("UIListLayout", LeftSection)
LeftLayout.Padding = UDim.new(0, 5)

-- 오른쪽 스크롤 구역
local RightSection = Instance.new("ScrollingFrame", PageFrame)
RightSection.Size = UDim2.new(0.5, -5, 1, 0)
RightSection.Position = UDim2.new(0.5, 5, 0, 0)
RightSection.BackgroundTransparency = 1
RightSection.ScrollBarThickness = 2
local RightLayout = Instance.new("UIListLayout", RightSection)
RightLayout.Padding = UDim.new(0, 5)

-- 가운데 세로 분할선
local CenterLine = Instance.new("Frame", PageFrame)
CenterLine.Size = UDim2.new(0, 1, 1, 0)
CenterLine.Position = UDim2.new(0.5, 0, 0, 0)
CenterLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CenterLine.BorderSizePixel = 0

-- [[ 10. 토글 스위치 생성용 함수 ]]
local function AddToggle(parent, text, defaultState, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 20, 0, 20)
    Button.Position = UDim2.new(0, 5, 0.5, -10)
    Button.Text = ""
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.Position = UDim2.new(0, 35, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    local state = defaultState
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end


-- ====================================================================
-- 💡 기능 코드는 이 아래줄부터 이어서 붙여넣으면 됩니다!
-- ====================================================================

-- [예시] 왼쪽 구역에 토글 스위치 추가하기
AddToggle(LeftSection, "Example Function", false, function(state)
    if state then
        print("기능 켜짐")
    else
        print("기능 꺼짐")
    end
end)


-- 실행 완료 알림
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SOLAR HUB V1",
    Text = "성공적으로 로드되었습니다!",
    Duration = 3
})
