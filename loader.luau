local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ 1. 중복 실행 및 연결 초기화 방어선 ]]
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

-- [[ 3. 메인 백그라운드 프레임 (드래그 가능) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

-- 상단 타이틀 바
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -15, 0, 25)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOLAR HUB V1 - CORE UI BASE"
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

-- 콘텐츠 렌더링 영역
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -24, 1, -65)
ContentFrame.Position = UDim2.new(0, 12, 0, 55)
ContentFrame.BackgroundTransparency = 1

-- [[ 5. 탭 페이지 및 좌우 스크롤 생성 함수 ]]
local Tabs = {}
local function CreateTabPages(tabName)
    local Page = Instance.new("Frame", ContentFrame)
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    
    -- 왼쪽 스크롤 레이아웃
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
    -- 오른쪽 스크롤 레이아웃
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

-- 사용할 기본 탭들 미리 생성
CreateTabPages("main")
CreateTabPages("world")
CreateTabPages("esp")

-- 탭 버튼 셋업 함수
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
Tabs["main"].Page.Visible = true -- 첫 시작은 main 탭 활성화

-- [[ 6. 섹션(구획) 프레임 생성 함수 ]]
local function AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 205)
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

-- [[ 7. 토글 컴포넌트 함수 ]]
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

-- [[ 8. 슬라이더 컴포넌트 함수 ]]
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

-- [[ 9. UI 화면 온/오프 토글 버튼 ]]
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
-- 여기 아래에서부터 탭 마운트와 백엔드 기능 코드를 이어 붙여나가면 됩니다.
-- ====================================================================
-- ====================================================================
-- ⚡ 백엔드 기능 코어 & 기능 제어 변수
-- ====================================================================

_G.AimbotEnabled = false
_G.SilentAimEnabled = false
_G.AimbotFOV = 100

_G.FlyEnabled = false
_G.NoClipEnabled = false
_G.InfiniteJump = false
_G.SkinChangerEnabled = false
local CurrentJumpPower = 50
local FlySpeed = 50

-- ESP 제어 토글 변수
_G.BoxESP = false
_G.NameESP = false
_G.WeaponESP = false
_G.HealthESP = false

-- FOV 시각화 원 생성
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 0, 50)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.AimbotFOV
FOVCircle.Filled = false

table.insert(_G.SolarConnections, RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
end))

-- 화면에서 마우스와 가장 가까운 적 타겟팅 함수
local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = _G.AimbotFOV
    local MousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local TargetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if TargetPart and Humanoid and Humanoid.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)
                if OnScreen then
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Distance < MaxDistance then
                        MaxDistance = Distance
                        ClosestTarget = TargetPart
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- [[ 🎯 1. 에임봇 연동형 정밀 Silent Aim ]]
local Meta = getrawmetatable(game)
local OldIndex = Meta.__index
setreadonly(Meta, false)

Meta.__index = newcstackclosure(function(Self, Key)
    if _G.SilentAimEnabled and _G.AimbotEnabled and tostring(Self) == "Mouse" and Key == "Hit" then
        local Target = GetClosestPlayer()
        if Target then
            return Target.CFrame
        end
    end
    return OldIndex(Self, Key)
end)
setreadonly(Meta, true)

-- [[ 👁️ 2. 일반 에임봇 카메라 고정 루프 ]]
table.insert(_G.SolarConnections, RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
        end
    end
end))

-- [[ ✈️ 3. 플라이(비행) 제어 연산 루틴 ]]
table.insert(_G.SolarConnections, RunService.Heartbeat:Connect(function()
    if _G.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local MoveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveDirection = MoveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then MoveDirection = MoveDirection - Vector3.new(0, 1, 0) end
        
        if MoveDirection.Magnitude > 0 then
            HRP.Velocity = MoveDirection.Unit * FlySpeed
        else
            HRP.Velocity = Vector3.new(0, 0, 0)
        end
    end
end))

-- [[ 🚫 4. 노클립 및 플라이 충돌 방지 패시브 ]]
table.insert(_G.SolarConnections, RunService.Stepped:Connect(function()
    if (_G.NoClipEnabled or _G.FlyEnabled) and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

-- [[ 🦘 5. 무한 점프 핸들러 ]]
table.insert(_G.SolarConnections, UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Hum then 
            Hum.UseJumpPower = true
            Hum:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end))

table.insert(_G.SolarConnections, LocalPlayer.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid")
    Hum.UseJumpPower = true
    Hum.JumpPower = CurrentJumpPower
end))

-- [[ 🌟 6. 안전 격리형 골드 스킨 체인저 ]]
table.insert(_G.SolarConnections, RunService.Heartbeat:Connect(function()
    if _G.SkinChangerEnabled and LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetDescendants()) do
            if item:IsA("MeshPart") and (item.Name:lower():match("weapon") or item.Name:lower():match("gun") or item.Parent:IsA("Tool")) then
                if item.Material ~= Enum.Material.ForceField then
                    item.Material = Enum.Material.ForceField
                    item.Color = Color3.fromRGB(255, 215, 0)
                end
            end
        end
    end
end))

-- [[ 👁️‍🗨️ 7. 고성능 드로잉 ESP 엔진 (박스, 이름, 무기, 체력바) ]]
local function GetCurrentWeapon(player)
    if not player.Character then return "None" end
    local Tool = player.Character:FindFirstChildOfClass("Tool")
    if Tool then return Tool.Name end
    return "Hands"
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

    local WeaponLabel = Drawing.new("Text")
    WeaponLabel.Size = 11
    WeaponLabel.Center = true
    WeaponLabel.Outline = true
    WeaponLabel.Color = Color3.fromRGB(0, 255, 255)

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = true

    local ESPConnection

    local function TrackESP()
        ESPConnection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
                local HRP = player.Character.HumanoidRootPart
                local Hum = player.Character.Humanoid
                local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

                if OnScreen then
                    local TopSpace = Camera:WorldToViewportPoint(HRP.Position + Vector3.new(0, 3, 0))
                    local BottomSpace = Camera:WorldToViewportPoint(HRP.Position - Vector3.new(0, 3.5, 0))
                    local Height = math.abs(TopSpace.Y - BottomSpace.Y)
                    local Width = Height / 1.5

                    -- [1] Box ESP
                    if _G.BoxESP then
                        Box.Size = Vector2.new(Width, Height)
                        Box.Position = Vector2.new(Pos.X - Width/2, Pos.Y - Height/2)
                        Box.Visible = true
                    else Box.Visible = false end

                    -- [2] Name ESP (머리 위)
                    if _G.NameESP then
                        NameLabel.Text = player.Name
                        NameLabel.Position = Vector2.new(Pos.X, (Pos.Y - Height/2) - 15)
                        NameLabel.Visible = true
                    else NameLabel.Visible = false end

                    -- [3] Weapon ESP (발 아래)
                    if _G.WeaponESP then
                        WeaponLabel.Text = GetCurrentWeapon(player)
                        WeaponLabel.Position = Vector2.new(Pos.X, (Pos.Y + Height/2) + 5)
                        WeaponLabel.Visible = true
                    else WeaponLabel.Visible = false end

                    -- [4] Health ESP (왼쪽 레이아웃 막대)
                    if _G.HealthESP then
                        local HealthPercent = math.clamp(Hum.Health / Hum.MaxHealth, 0, 1)
                        HealthBar.Size = Vector2.new(2, Height * HealthPercent)
                        HealthBar.Position = Vector2.new((Pos.X - Width/2) - 6, Pos.Y - Height/2 + (Height * (1 - HealthPercent)))
                        HealthBar.Color = Color3.fromRGB(255 * (1 - HealthPercent), 255 * HealthPercent, 0)
                        HealthBar.Visible = true
                    else HealthBar.Visible = false end
                else
                    Box.Visible = false; NameLabel.Visible = false; WeaponLabel.Visible = false; HealthBar.Visible = false
                end
            else
                Box.Visible = false; NameLabel.Visible = false; WeaponLabel.Visible = false; HealthBar.Visible = false
                if not player.Parent then
                    Box:Remove(); NameLabel:Remove(); WeaponLabel:Remove(); HealthBar:Remove()
                    if ESPConnection then ESPConnection:Disconnect() end
                end
            end
        end)
        table.insert(_G.SolarConnections, ESPConnection)
    end

    player.CharacterAdded:Connect(function() task.wait(0.3); TrackESP() end)
    if player.Character then TrackESP() end
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
table.insert(_G.SolarConnections, Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end))


-- ====================================================================
-- 🛠️ UI 컴포넌트에 기능 마운트 (연결 작업)
-- ====================================================================

-- 1. Main 탭 컴포넌트 장착
local CombatSection = AddSection(Tabs["main"].Left, "combat options")
AddToggle(CombatSection, "aimbot enabled", false, function(state) _G.AimbotEnabled = state end)
AddToggle(CombatSection, "silent aim (aimbot link)", false, function(state) _G.SilentAimEnabled = state end)
AddToggle(CombatSection, "show fov circle", false, function(state) FOVCircle.Visible = state end)
AddSlider(CombatSection, "fov radius", 30, 500, 100, function(val) _G.AimbotFOV = val end)

-- 2. World 탭 컴포넌트 장착
local WorldSection = AddSection(Tabs["world"].Left, "movement & skins")
AddToggle(WorldSection, "fly hack", false, function(state) _G.FlyEnabled = state end)
AddSlider(WorldSection, "fly speed", 20, 200, 50, function(val) FlySpeed = val end)
AddToggle(WorldSection, "noclip", false, function(state) _G.NoClipEnabled = state end)
AddToggle(WorldSection, "infinite jump", false, function(state) _G.InfiniteJump = state end)
AddSlider(WorldSection, "jump power", 50, 400, 50, function(val)
    CurrentJumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)
AddToggle(WorldSection, "gold skin changer", false, function(state) _G.SkinChangerEnabled = state end)

-- 3. ESP 탭 컴포넌트 장착
local VisualSection = AddSection(Tabs["esp"].Left, "esp visual overlay")
AddToggle(VisualSection, "box esp", false, function(state) _G.BoxESP = state end)
AddToggle(VisualSection, "name esp (top)", false, function(state) _G.NameESP = state end)
AddToggle(VisualSection, "weapon esp (bottom)", false, function(state) _G.WeaponESP = state end)
AddToggle(VisualSection, "health esp (bar)", false, function(state) _G.HealthESP = state end)

print("SOLAR HUB Backend Engine Successfully Injected!")
