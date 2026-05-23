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
-- ====================================================================
-- ⚡ SOLAR HUB V1 — 프리미엄 기능 주입 엔진 (1차 완벽 보정판)
-- ====================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ 기능 제어용 글로벌 변수 선언 ]]
_G.AimbotEnabled = false
_G.AimbotFOV = 100

_G.BoxESP = false
_G.NameESP = false
_G.HealthESP = false
_G.WeaponESP = false

_G.NoClipEnabled = false
_G.InfiniteJump = false
local CurrentJumpPower = 50

-- [[ FOV 원화면 그리기 ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 85, 255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.AimbotFOV
FOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
end)

-- [[ 에임봇 타겟 스캔 함수 (10000 스터드 거리 제한 반영) ]]
local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = _G.AimbotFOV
    local MousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local HRP = player.Character.HumanoidRootPart
            local Humanoid = player.Character.Humanoid
            
            -- 1. 체력이 있고 10,000 스터드 이내에 있는 사람만 타겟팅 (요청 반영)
            local MainPlayerDistance = (LocalPlayer.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
            if Humanoid.Health > 0 and MainPlayerDistance <= 10000 then
                
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
                if OnScreen then
                    -- FOV 원 안에 들어왔는지 마우스 거리 계산
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Distance < MaxDistance then
                        MaxDistance = Distance
                        ClosestTarget = HRP
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- [[ 에임봇 실행 루프 (자연스러운 팅김 방지 렌더링 적용) ]]
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target then
            -- 기존의 투박한 화면 돌리기 대신, 부드럽게 대상을 보정하여 고정 (총알이 튀는 현상 완화)
            local TargetCFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, 0.45) -- 0.45 값을 조절해 부드러움 강도 세팅 가능
        end
    end
end)

-- [[ 라이벌즈 전용 무기 이름 탐지 함수 ]]
local function GetCurrentWeapon(player)
    if not player.Character then return "Hands" end
    
    -- 1) 일반적인 Tool 탐지
    local Tool = player.Character:FindFirstChildOfClass("Tool")
    if Tool then return Tool.Name end
    
    -- 2) 라이벌즈(Rivals) 스크립트 전용 모델링 우회 탐지
    -- 캐릭터가 쥐고 있는 무기 오브젝트 이름이나 인벤토리 값을 추적해 표기
    for _, child in pairs(player.Character:GetChildren()) do
        if child:IsA("Model") and (child.Name:match("Rifle") or child.Name:match("Pistol") or child.Name:match("Shotgun") or child.Name:match("Sniper") or child.Name:match("SMG")) then
            return child.Name
        end
    end
    
    -- 3) 만약 여전히 안 잡힌다면 라이벌즈 백엔드 폴더 내부 뒤지기
    local Backpack = player:FindFirstChild("Backpack")
    if Backpack then
        local ActiveWeapon = Backpack:FindFirstChildOfClass("Tool")
        if ActiveWeapon then return ActiveWeapon.Name end
    end
    
    return "Equipped" -- Hands 대신 실전 감성 문구로 대체
end

-- [[ ESP 정밀 드로잉 렌더링 시스템 ]]
local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Filled = false

    local NameLabel = Drawing.new("Text")
    NameLabel.Visible = false
    NameLabel.Color = Color3.fromRGB(255, 255, 255)
    NameLabel.Size = 13
    NameLabel.Center = true
    NameLabel.Outline = true

    local HealthBar = Drawing.new("Square")
    HealthBar.Visible = false
    HealthBar.Color = Color3.fromRGB(0, 255, 0)
    HealthBar.Thickness = 1
    HealthBar.Filled = true

    local WeaponLabel = Drawing.new("Text")
    WeaponLabel.Visible = false
    WeaponLabel.Color = Color3.fromRGB(0, 255, 255)
    WeaponLabel.Size = 11
    WeaponLabel.Center = true
    WeaponLabel.Outline = true

    local Updater
    Updater = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local HRP = player.Character.HumanoidRootPart
            local Humanoid = player.Character.Humanoid
            local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

            if OnScreen then
                local TopSpace = Camera:WorldToViewportPoint(HRP.Position + Vector3.new(0, 3, 0))
                local BottomSpace = Camera:WorldToViewportPoint(HRP.Position - Vector3.new(0, 3.5, 0))
                local Height = math.abs(TopSpace.Y - BottomSpace.Y)
                local Width = Height / 1.5

                -- 1) Box ESP
                if _G.BoxESP then
                    Box.Size = Vector2.new(Width, Height)
                    Box.Position = Vector2.new(Pos.X - Width/2, Pos.Y - Height/2)
                    Box.Visible = true
                else Box.Visible = false end

                -- 2) Name ESP (사람 위에 이름)
                if _G.NameESP then
                    NameLabel.Text = player.Name
                    NameLabel.Position = Vector2.new(Pos.X, (Pos.Y - Height/2) - 15)
                    NameLabel.Visible = true
                else NameLabel.Visible = false end

                -- 3) Health ESP (사람 옆에 막대기 피통)
                if _G.HealthESP then
                    local HealthPercent = Humanoid.Health / Humanoid.MaxHealth
                    HealthBar.Size = Vector2.new(2, Height * HealthPercent)
                    HealthBar.Position = Vector2.new((Pos.X - Width/2) - 6, Pos.Y - Height/2 + (Height * (1 - HealthPercent)))
                    HealthBar.Color = Color3.fromRGB(255 * (1 - HealthPercent), 255 * HealthPercent, 0)
                    HealthBar.Visible = true
                else HealthBar.Visible = false end

                -- 4) Weapon ESP (보정된 라이벌즈 무기 탐지 시스템 연동)
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
                Updater:Disconnect()
            end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)

-- [[ 노클립 & 무한점프 루프 구성 ]]
RunService.Stepped:Connect(function()
    if _G.NoClipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Hum then 
            Hum.UseJumpPower = true
            Hum:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid")
    Hum.UseJumpPower = true
    Hum.JumpPower = CurrentJumpPower
end)


-- ====================================================================
-- 🎨 고급 슬라이더 컴포넌트 정의
-- ====================================================================
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


-- ====================================================================
-- 🛠️ 탭별 박스 및 토글/막대 아이템 최종 배치
-- ====================================================================

local AimSection = AddSection(Tabs["main"].Left, "aimbot settings")
AddToggle(AimSection, "aimbot enabled", false, function(state)
    _G.AimbotEnabled = state
end)
AddToggle(AimSection, "show fov circle", false, function(state)
    FOVCircle.Visible = state
end)
AddSlider(AimSection, "fov radius", 30, 500, 100, function(val)
    _G.AimbotFOV = val
end)

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

AddToggle(MiscSection, "unlock all skins", false, function(state)
    if state then
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/QP-Offcial/Roblox/refs/heads/main/UnlockAll.lua"))()
        end)
        if success then print("UnlockAll Loaded Successfully!") else warn("Error loading script:", err) end
    else
        print("UnlockAll Disabled.")
    end
end)
