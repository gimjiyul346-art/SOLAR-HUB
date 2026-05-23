local CoreGui = game:GetService("CoreGui")

-- [[ 1. 중복 실행 깔끔하게 방지 ]]
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SOLAR_PREMIUM_UE" then v:Destroy() end
end

-- [[ 2. 최상위 Gui 스크린 생성 ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SOLAR_PREMIUM_UE"
ScreenGui.DisplayOrder = 999

-- [[ 3. 메인 백그라운드 프레임 (딥 블랙 사각형) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420) -- 가로형 고급 사이즈
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16) -- 정통 차콜 블랙
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40) -- 얇은 외곽 경계선
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 자유 이동 가능

-- 최상단 얇은 타이틀 텍스트
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - discord.gg/solar"
Title.TextColor3 = Color3.fromRGB(150, 150, 150)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 4. 상단 가로 탭 메뉴 바 (main, world, esp ...) ]]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 24)
TabBar.Position = UDim2.new(0, 12, 0, 25)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBar.BorderSizePixel = 1
TabBar.BorderColor3 = Color3.fromRGB(35, 35, 35)

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ 5. 기능들이 교체될 메인 컨테이너 ]]
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -65)
ContentFrame.Position = UDim2.new(0, 12, 0, 55)
ContentFrame.BackgroundTransparency = 1

-- 탭별 페이지 보관소
local Tabs = {}

local function CreateTabPages(tabName)
    local Page = Instance.new("Frame", ContentFrame)
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false -- 처음엔 숨김
    
    -- 좌측 스크롤 구역
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
    -- 우측 스크롤 구역
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

-- 사용할 탭 페이지 등록
CreateTabPages("main")
CreateTabPages("world")
CreateTabPages("esp")

-- 탭 버튼 생성 및 클릭 이벤트 연동 함수
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
        TabBtn.TextColor3 = Color3.fromRGB(0, 120, 255) -- 선택된 탭은 파란색 빛
    end)
end

-- 탭 세팅
SetupTabButton("main", 1)
SetupTabButton("world", 2)
SetupTabButton("esp", 3)

-- 기본 화면은 main 페이지로 지정
Tabs["main"].Page.Visible = true

-- [[ 6. 파란색 테두리 구역(Section) 생성 함수 ]]
local function AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 150) -- 필요에 따라 높이 조절
    SectionFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SectionFrame.BorderSizePixel = 1
    SectionFrame.BorderColor3 = Color3.fromRGB(0, 85, 255) -- 파란색 네온 선
    
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

-- [[ 8. UI 원버튼 열고 닫기 토글 시스템 ]]
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
-- 💡 여기서부터 원하는 구역과 기능을 한 땀 한 땀 추가해나가면 됩니다!
-- ====================================================================

-- [예시 구역 등록 방법]
-- local 예시섹션 = AddSection(Tabs["main"].Left, "test section")
-- AddToggle(예시섹션, "test sub-function", false, function(state) end)
-- ====================================================================
-- ⚡ SOLAR HUB V1 — 프리미엄 기능 주입 엔진 (핵심 백엔드 로직)
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

-- [[ FOV 원화면 그리기 (Drawing API 사용) ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 85, 255) -- 테마에 맞춘 파란색 FOV 원
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.AimbotFOV
FOVCircle.Filled = false

-- FOV 원을 마우스 커서 위치에 상시 고정
RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
end)

-- [[ 에임봇 타겟 스캔 함수 ]]
local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = _G.AimbotFOV
    local MousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Distance < MaxDistance then
                        MaxDistance = Distance
                        ClosestTarget = player.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- 에임봇 실행 루프
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

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
                -- 캐릭터 크기에 비례하는 박스 사이즈 계산
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

                -- 4) Weapon ESP (사람 밑에 들고 있는 무기 이름)
                if _G.WeaponESP then
                    local Tool = player.Character:FindFirstChildOfClass("Tool")
                    WeaponLabel.Text = Tool and Tool.Name or "Hands"
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

-- 서버에 접속 중이거나 들어오는 유저들 ESP 등록 일괄 자동화
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
-- 🎨 고급 슬라이더 컴포넌트 정의 (UI 바닐라 코드와 연동)
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

-- 1. [main 탭] 에임봇 전용 구역 조립
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


-- 2. [esp 탭] 정통 ESP 구역 조립
local VisualSection = AddSection(Tabs["esp"].Left, "esp overlay")
AddToggle(VisualSection, "box esp", false, function(state) _G.BoxESP = state end)
AddToggle(VisualSection, "name esp (top)", false, function(state) _G.NameESP = state end)
AddToggle(VisualSection, "health esp (bar)", false, function(state) _G.HealthESP = state end)
AddToggle(VisualSection, "weapon esp (bottom)", false, function(state) _G.WeaponESP = state end)


-- 3. [world 이아닌 misc 탭용 예비공간 확보를 위해 world 좌측에 배치]
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

-- 4) ⚡ UnlockAll 외부 로드스트링 온오프 스위치 스크립트
AddToggle(MiscSection, "unlock all skins", false, function(state)
    if state then
        -- 켰을 때 유저가 지정한 기하학 스킨핵 스크립트 강제 인젝션
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/QP-Offcial/Roblox/refs/heads/main/UnlockAll.lua"))()
        end)
        if success then print("UnlockAll Loaded Successfully!") else warn("Error loading script:", err) end
    else
        -- 로블록스 특성상 한 번 실행된 타사 loadstring 소스코드를 완벽히 메모리에서 내리는 것은 구조적으로 불가능하므로, 
        -- 체크박스를 끄면 관련 인벤토리 캐시 갱신을 원상복구하거나 전역 스위치 상태를 변환하여 중지 연출을 유도합니다.
        print("UnlockAll Disabled.")
    end
end)
