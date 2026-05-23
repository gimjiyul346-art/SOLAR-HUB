local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. 중복 실행 방지 (기존 UI 지우기) ]]
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_HUB" or v.Name == "SOLAR_MENU_BTN" then 
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

-- [[ 4. 타이틀 라벨 (이름 반영 완료) ]]
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "  SOLAR HUB V1" -- 이름 변경 완료!
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 5. 탭 메뉴 바 (Main Rage 등등 영역) ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 4)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ 6. 반으로 나뉜 페이지 구역 (세로 분할선) ]]
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

-- 손그림에 있던 가운데 세로 분할선
local CenterLine = Instance.new("Frame", PageFrame)
CenterLine.Size = UDim2.new(0, 1, 1, 0)
CenterLine.Position = UDim2.new(0.5, 0, 0, 0)
CenterLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CenterLine.BorderSizePixel = 0

-- [[ 7. 토글 스위치 생성용 함수 ]]
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

-- [[ 8. UI 숨김/열기용 SOLAR 버튼 ]]
local MenuBtn = Instance.new("TextButton", CoreGui)
MenuBtn.Name = "SOLAR_MENU_BTN"
MenuBtn.Size = UDim2.new(0, 50, 0, 50)
MenuBtn.Position = UDim2.new(0, 10, 0.4, 0)
MenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MenuBtn.Text = "SOLAR"
MenuBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
MenuBtn.Font = Enum.Font.GothamBold
MenuBtn.TextSize = 11
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", MenuBtn)
BtnStroke.Color = Color3.fromRGB(255, 60, 60)

local function ToggleUI() MainFrame.Visible = not MainFrame.Visible end
MenuBtn.MouseButton1Click:Connect(ToggleUI)


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
