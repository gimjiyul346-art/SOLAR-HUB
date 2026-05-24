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
-- ====================================================================
-- ⚙️ [CHARACTER - CAMERA-ORIENTED FLY ENGINE]
-- ====================================================================

_G.FlyEnabled = false
local FlySpeed = 50

-- 비행 중 위치 유지를 위한 바디 포지션 오브젝트 세팅
local FlyGyro, FlyPosition

table.insert(_G.SolarConnections, RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if _G.FlyEnabled and Hum and Hum.Health > 0 then
            local MoveDirection = Vector3.new(0, 0, 0)
            
            -- [1] PC 키보드 입력 방향 연산 (카메라 LookVector 완벽 동기화)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Camera.CFrame.RightVector end
            
            -- [2] 모바일 조이스틱 입력 방향 연산
            -- 모바일 조이스틱을 움직였을 때, 캐릭터 평면 무빙을 카메라가 바라보는 입체 방향(3D Vector)으로 변환합니다.
            if Hum.MoveDirection.Magnitude > 0 then
                local CameraLook = Camera.CFrame.LookVector
                local CameraRight = Camera.CFrame.RightVector
                
                -- 조이스틱의 앞/뒤, 좌/우 입력을 카메라 시선 기준으로 재조합
                local ForwardMove = CameraLook * (Hum.MoveDirection:Dot(Camera.CFrame.LookVector) / CameraLook.Magnitude)
                local SideMove = CameraRight * (Hum.MoveDirection:Dot(Camera.CFrame.RightVector) / CameraRight.Magnitude)
                
                -- 이동 벡터가 비정상적으로 튀는 현상 방지 보정
                if (ForwardMove + SideMove).Magnitude > 0 then
                    MoveDirection = MoveDirection + (ForwardMove + SideMove).Unit
                end
            end
            
            -- [3] 수직 수동 제어 (PC: 스페이스바 / 모바일: 점프 버튼)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or Hum.Jump then 
                MoveDirection = MoveDirection + Vector3.new(0, 1, 0) 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
                MoveDirection = MoveDirection - Vector3.new(0, 1, 0) 
            end
            
            -- [4] 실제 좌표 이동 및 물리 제어
            HRP.Velocity = Vector3.new(0, 0, 0) -- 중력 및 관성 제로화
            
            if MoveDirection.Magnitude > 0 then
                -- 이동 중일 때: 시선 방향 벡터로 정밀 이동
                HRP.CFrame = HRP.CFrame + (MoveDirection.Unit * (FlySpeed / 60))
            else
                -- 정지 중일 때 (호버링): 떨어지지 않고 공중에 고정되도록 강제 좌표 록온
                HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector * Vector3.new(1, 0, 1))
            end
        end
    end
end))

-- 비행 중 벽 통과 및 낙하 대미지 유발 렉 차단 (Noclip 셋업)
table.insert(_G.SolarConnections, RunService.Stepped:Connect(function()
    if _G.FlyEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))


-- ====================================================================
-- 📦 [CHARACTER 탭 마운트 구역]
-- ====================================================================

-- 기존 베이스 반복문이 미리 만들어둔 빈 character options 상자를 깔끔하게 제거
if Tabs["character"] and Tabs["character"].Left then
    for _, child in pairs(Tabs["character"].Left:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

-- CHARACTER 탭 왼쪽 스크롤뷰에 개선된 방향성 FLY 기능 배치
local CharacterSection = _G.AddSection(Tabs["character"].Left, "character configuration")
_G.AddToggle(CharacterSection, "cross-platform fly", false, function(state) 
    _G.FlyEnabled = state 
end)
_G.AddSlider(CharacterSection, "fly velocity speed", 20, 200, 50, function(val) 
    FlySpeed = val 
end)

-- 레이아웃 스크롤 리사이징 갱신
task.defer(function()
    local scroll = Tabs["character"].Left
    if scroll and scroll:FindFirstChild("UIListLayout") then
        scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.UIListLayout.AbsoluteContentSize.Y + 20)
    end
end)

print("[SOLAR] 시선 방향 인지형 3D Fly 엔진 패치 완료!")
-- ====================================================================
-- ⚙️ [MISC - SKIN CHANGER RUNNER] (게임 프리징 방지 우회 프로토콜)
-- ====================================================================

local SkinChangerExecuted = false

local function ExecuteSkinChanger()
    if SkinChangerExecuted then 
        print("[SOLAR] Skin Changer가 이미 백엔드에서 구동 중입니다.")
        return 
    end
    
    SkinChangerExecuted = true
    print("[SOLAR] Skin Changer 안전 로딩 시작...")

    -- task.spawn을 사용하여 메인 UI 스레드와 분리된 독립 스레드에서 실행합니다.
    -- 이 방식으로 실행하면 외부 깃허브 코드가 대량의 스킨 데이터를 불러올 때 발생하는 게임 멈춤(Freezing) 현상을 완전히 해결할 수 있습니다.
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/QP-Offcial/Roblox/refs/heads/main/UnlockAll.lua"))()
        end)
        
        if success then
            print("[SOLAR] Skin Changer 소스 로드 성공!")
        else
            warn("[SOLAR] Skin Changer 로드 실패 (실행기 환경 확인 필요):", err)
            SkinChangerExecuted = false -- 에러 발생 시 재시도 가능하도록 초기화
        end
    end)
end


-- ====================================================================
-- 📦 [MISC 탭 마운트 구역]
-- ====================================================================

-- 기존 베이스 반복문이 미리 만들어둔 빈 misc options 상자를 깨끗하게 청소
if Tabs["misc"] and Tabs["misc"].Left then
    for _, child in pairs(Tabs["misc"].Left:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

-- MISC 탭 왼쪽 스크롤뷰에 진짜 SKIN CHANGER 섹션 생성
local MiscSection = _G.AddSection(Tabs["misc"].Left, "utility configuration")

-- 토글이 켜지는 순간 프리징 방지 코드가 적용된 깃허브 스크립트가 로드됩니다.
_G.AddToggle(MiscSection, "skin changer (unlock all)", false, function(state)
    if state then
        ExecuteSkinChanger()
    end
end)

-- 레이아웃 스크롤 리사이징 자동 갱신
task.defer(function()
    local scroll = Tabs["misc"].Left
    if scroll and scroll:FindFirstChild("UIListLayout") then
        scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.UIListLayout.AbsoluteContentSize.Y + 20)
    end
end)

print("[SOLAR] MISC 탭에 멈춤 방지형 Skin Changer 연동 완료!")
-- ====================================================================
-- [최종 통합 엔진: 60줄 원본 로직 + 헤드샷 전용]
-- ====================================================================

-- 1. [형이 준 원본 60줄 로직]
local replicated_storage = game:GetService("ReplicatedStorage");
local players = game:GetService("Players");
local camera = workspace.CurrentCamera;
local utility = require(replicated_storage.Modules.Utility);

local get_players = function()
    local entities = {};
    for _, child in workspace:GetChildren() do
        if child:FindFirstChildOfClass("Humanoid") then
            table.insert(entities, child);
        elseif child.Name == "HurtEffect" then
            for _, hurt_player in child:GetChildren() do
                if (hurt_player.ClassName ~= "Highlight") then
                    table.insert(entities, hurt_player);
                end
            end
        end
    end
    return entities
end
local get_closest_player = function()
    local closest, closest_distance = nil, math.huge;
    local character = players.LocalPlayer.Character;
    if (character == nil) then return; end
    for _, player in get_players() do
        if (player == players.LocalPlayer) then continue; end
        if (not player:FindFirstChild("HumanoidRootPart")) then continue; end
        local position, on_screen = camera:WorldToViewportPoint(player.HumanoidRootPart.Position);
        if (on_screen == false) then continue; end
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
        local distance = (center - Vector2.new(position.X, position.Y)).Magnitude;
        if (distance > closest_distance) then continue; end
        closest = player;
        closest_distance = distance;
    end
    return closest;
end

-- 2. [헤드샷 전용으로 수정된 Raycast]
local old = utility.Raycast; 
utility.Raycast = function(...)
    local arguments = {...};
    -- 헤드 고정 로직: 999번 식별자일 때만 헤드로 좌표 강제 교체
    if _G.SilentEnabled and (#arguments > 0 and arguments[4] == 999) then
        local closest = get_closest_player();
        if (closest and closest:FindFirstChild("Head")) then
            -- [수정] 몸통이 아닌 무조건 머리 좌표로 고정
            arguments[3] = closest.Head.CFrame.Position; 
        end
    end
    return old(table.unpack(arguments));
end

-- 3. [기능 및 UI 통합 (나머지 기능들)]
_G.SilentEnabled = false; _G.Wallbang = false; _G.AutoShoot = false; _G.AutoFarm = false;

-- Wallbang 로직: 레이캐스트의 4번째 인자(필터)를 없애 벽 통과
local oldRaycast = utility.Raycast
utility.Raycast = function(...)
    local args = {...}
    if _G.Wallbang and #args > 0 and args[4] == 999 then args[4] = nil end
    return oldRaycast(unpack(args))
end

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.AutoShoot then
        local target = get_closest_player()
        if target and players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
        end
    end
    if _G.AutoFarm and players.LocalPlayer.Character then
        local target = get_closest_player()
        if target and target:FindFirstChild("Head") then
            players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Head.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

task.spawn(function()
    repeat task.wait(0.5) until Tabs and Tabs["main"]
    local M = _G.AddSection(Tabs["main"].Left, "Combat")
    _G.AddToggle(M, "Silent Aim", false, function(s) _G.SilentEnabled = s end)
    _G.AddToggle(M, "Wallbang", false, function(s) _G.Wallbang = s end)
    _G.AddToggle(M, "Auto Shoot", false, function(s) _G.AutoShoot = s end)
    _G.AddToggle(M, "Auto Farm", false, function(s) _G.AutoFarm = s end)
end)
