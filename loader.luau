local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- [[ 1. 중복 실행 방지 ]]
-- 코드를 여러 번 실행해도 화면이 지저분해지지 않게 기존 창을 깔끔하게 청소해줘.
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_REBOOT" then 
        v:Destroy() 
    end
end

-- [[ 2. 최상위 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_REBOOT"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 프레임 (요청한 직사각형 검은색 네모 창) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 320) -- 가로가 조금 더 긴 완벽한 직사각형
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160) -- 화면 정확히 정중앙 배치
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- 순수한 무광 검은색
MainFrame.BorderSizePixel = 0 -- 테두리 선 없이 깔끔하게 처리
MainFrame.Visible = true -- 처음 실행 시 켜진 상태
MainFrame.Active = true
MainFrame.Draggable = true -- 모바일 화면에서 손가락으로 드래그 이동 가능!

-- 타이틀 텍스트 (창 윗부분에 SOLAR HUB V1 표시)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 기능들을 담을 스크롤 구역 (나중에 기능 추가할 공간) ]]
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -30, 1, -60)
Container.Position = UDim2.new(0, 15, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 6) -- 기능 버튼들 사이의 자잘한 간격 조절
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ 5. ⚡ 핵심: 열고 닫는 "UI" 토글 버튼 ]]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Size = UDim2.new(0, 50, 0, 30) -- 조그맣고 깔끔한 크기
ToggleBtn.Position = UDim2.new(0, 15, 0, 15) -- 모바일 화면 좌측 상단 터치하기 편한 곳
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- 버튼도 검은색 계열
ToggleBtn.Text = "UI" -- 네가 요청한 버튼 글자
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.BorderSizePixel = 1
ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50) -- 약간의 경계선 유전

-- UI 버튼 클릭 시 메인 창 ON / OFF 스위칭 완벽 작동
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [[ 6. 나중에 버튼을 쉽게 추가하기 위한 마법의 함수 ]]
-- 네가 이 아래에 AddFunction("기능이름", function() ... end) 만 써주면 버튼이 자동으로 생성돼!
local function AddFunction(name, callback)
    local FuncBtn = Instance.new("TextButton", Container)
    FuncBtn.Size = UDim2.new(1, 0, 0, 35)
    FuncBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- 약간 밝은 검은색 버튼
    FuncBtn.BorderSizePixel = 0
    FuncBtn.Text = name
    FuncBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    FuncBtn.Font = Enum.Font.Gotham
    FuncBtn.TextSize = 13
    
    FuncBtn.MouseButton1Click:Connect(callback)
    
    -- 버튼 모서리 아주 살짝만 둥글게 해서 세련미 추가
    local Corner = Instance.new("UICorner", FuncBtn)
    Corner.CornerRadius = UDim.new(0, 4)
end


-- ====================================================================
-- 💡 기능 코드는 이 아래줄부터 AddFunction을 사용해서 편하게 이어 붙이세요!
-- ====================================================================

-- 1. 예시용 기능 (테스트용)
AddFunction("Test Function", function()
    print("SOLAR HUB 기능 정상 작동 중!")
end)

-- 2. 아까 네가 성공했던 하늘 파괴 코드를 여기 쏙 집어넣으면 끝!
AddFunction("Remove Server Sky", function()
    local Lighting = game:GetService("Lighting")
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    print("서버 하늘 파괴 완료!")
end)
