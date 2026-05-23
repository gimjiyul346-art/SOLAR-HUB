local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. 중복 실행 방지 ]]
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

-- 상단 타이틀
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - discord.gg/solar"
Title.TextColor3 = Color3.fromRGB(150, 150, 150)
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

CreateTabPages("main")
CreateTabPages("world")

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
        TabBtn.TextColor3 = Color3.fromRGB(0, 120, 255)
    end)
end

SetupTabButton("main", 1)
SetupTabButton("world", 2)
Tabs["main"].Page.Visible = true

-- [[ 5. 섹션 프레임 생성 함수 ]]
local function AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 160)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(0, 85, 255)
    
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
    C_Layout.Padding = UDim.new(0, 6)
    
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

-- [[ 7. 하이엔드 슬라이더 함수 (영상 속 테두리 및 레이아웃 반영) ]]
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

    -- 슬라이더 전체 축 프레임
    local Track = Instance.new("TextButton", SliderRow)
    Track.Size = UDim2.new(1, -10, 0, 10)
    Track.Position = UDim2.new(0, 5, 0, 16)
    Track.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Track.BorderSizePixel = 1
    Track.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Track.Text = ""

    -- 파란색 게이지 프레임 (영상 디자인 핵심)
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
            IsDragging = true
            SetValue(input)
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

-- [[ 8. 숨기기 숨기기 기능 토글 버튼 ]]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 1
ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)


-- ====================================================================
-- 💡 기능 실시간 엔진 로직 및 UI 배치 연동
-- ====================================================================

local CurrentJumpPower = 50 -- 로블록스 기본 점프력 값 설정
_G.InfiniteJumpEnabled = false

-- 무한 점프 백엔드 루프 연동
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            -- 점프력을 변경하면 UseJumpPower 옵션을 강제로 True로 켜줘야 적용되는 게임이 많아 안전장치 배치
            Humanoid.UseJumpPower = true 
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 캐릭터가 죽고 부활해도 슬라이더로 조절한 점프력을 계속 유지시키는 추적 엔진
LocalPlayer.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = CurrentJumpPower
end)


-- [[ 9. UI 섹션 및 기능 주입 ]]
local CharacterSection = AddSection(Tabs["main"].Left, "character settings")

-- 1) 무한 점프 토글 추가
AddToggle(CharacterSection, "infinite jump", false, function(state)
    _G.InfiniteJumpEnabled = state
end)

-- 2) 점프력 슬라이더 바 추가 (최소 50 ~ 최대 500 조절 가능)
AddSlider(CharacterSection, "jump power", 50, 500, 50, function(value)
    CurrentJumpPower = value
    if LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = value
        end
    end
end)
