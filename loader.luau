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

-- [[ 3. 메인 백그라운드 프레임 ]]
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

-- 콘텐츠 스크린 영역
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
    
    local LeftScroll = Instance.new("ScrollingFrame", Page)
    LeftScroll.Name = "Left"
    LeftScroll.Size = UDim2.new(0.5, -5, 1, 0)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50)
    local L_Layout = Instance.new("UIListLayout", LeftScroll)
    L_Layout.Padding = UDim.new(0, 10)
    
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
Tabs["main"].Page.Visible = true 
TabBar:GetChildren()[2].TextColor3 = Color3.fromRGB(255, 0, 50)

-- [[ 6. 섹션 박스 생성 함수 ]]
function _G.AddSection(parent, titleName)
    local SectionFrame = Instance.new("Frame", parent)
    SectionFrame.Size = UDim2.new(1, -5, 0, 180) -- 다양한 기능 추가를 위해 세로폭 살짝 상향
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

-- [[ 7. 온/오프 토글 스위치 함수 ]]
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

-- [[ 8. 수치 조절용 슬라이더 함수 ]]
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

-- [[ 9. UI 숨기기 버튼 ]]
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

for _, name in pairs(TabNames) do
    _G.AddSection(Tabs[name].Left, name .. " options")
end

print("[SOLAR BASE] UI Base Loaded!")

-- ====================================================================
-- ⚙️ [CHARACTER - CAMERA-ORIENTED FLY ENGINE]
-- ====================================================================
_G.FlyEnabled = false
local FlySpeed = 50

table.insert(_G.SolarConnections, RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if _G.FlyEnabled and Hum and Hum.Health > 0 then
            local MoveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Camera.CFrame.RightVector end
            
            if Hum.MoveDirection.Magnitude > 0 then
                local CameraLook = Camera.CFrame.LookVector
                local CameraRight = Camera.CFrame.RightVector
                local ForwardMove = CameraLook * (Hum.MoveDirection:Dot(Camera.CFrame.LookVector) / CameraLook.Magnitude)
                local SideMove = CameraRight * (Hum.MoveDirection:Dot(Camera.CFrame.RightVector) / CameraRight.Magnitude)
                
                if (ForwardMove + SideMove).Magnitude > 0 then
                    MoveDirection = MoveDirection + (ForwardMove + SideMove).Unit
                end
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or Hum.Jump then 
                MoveDirection = MoveDirection + Vector3.new(0, 1, 0) 
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
                MoveDirection = MoveDirection - Vector3.new(0, 1, 0) 
            end
            
            HRP.Velocity = Vector3.new(0, 0, 0)
            if MoveDirection.Magnitude > 0 then
                HRP.CFrame = HRP.CFrame + (MoveDirection.Unit * (FlySpeed / 60))
            else
                HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector * Vector3.new(1, 0, 1))
            end
        end
    end
end))

table.insert(_G.SolarConnections, RunService.Stepped:Connect(function()
    if _G.FlyEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

if Tabs["character"] and Tabs["character"].Left then
    for _, child in pairs(Tabs["character"].Left:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local CharacterSection = _G.AddSection(Tabs["character"].Left, "character configuration")
_G.AddToggle(CharacterSection, "cross-platform fly", false, function(state) _G.FlyEnabled = state end)
_G.AddSlider(CharacterSection, "fly velocity speed", 20, 200, 50, function(val) FlySpeed = val end)

task.defer(function()
    local scroll = Tabs["character"].Left
    if scroll and scroll:FindFirstChild("UIListLayout") then
        scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.UIListLayout.AbsoluteContentSize.Y + 20)
    end
end)

-- ====================================================================
-- ⚙️ [MISC - SKIN CHANGER RUNNER]
-- ====================================================================
local SkinChangerExecuted = false
local function ExecuteSkinChanger()
    if SkinChangerExecuted then return end
    SkinChangerExecuted = true
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/QP-Offcial/Roblox/refs/heads/main/UnlockAll.lua"))()
        end)
        if not success then SkinChangerExecuted = false end
    end)
end

if Tabs["misc"] and Tabs["misc"].Left then
    for _, child in pairs(Tabs["misc"].Left:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local MiscSection = _G.AddSection(Tabs["misc"].Left, "utility configuration")
_G.AddToggle(MiscSection, "skin changer (unlock all)", false, function(state)
    if state then ExecuteSkinChanger() end
end)

task.defer(function()
    local scroll = Tabs["misc"].Left
    if scroll and scroll:FindFirstChild("UIListLayout") then
        scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.UIListLayout.AbsoluteContentSize.Y + 20)
    end
end)

-- ====================================================================
-- ⚙️ [MAIN COMBAT - 60줄 원본 엔진 + 월뱅 + 헤드 고정형]
-- ====================================================================
local replicated_storage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local camera = workspace.CurrentCamera
local utility = require(replicated_storage.Modules.Utility)

local get_players = function()
    local entities = {}
    for _, child in workspace:GetChildren() do
        if child:FindFirstChildOfClass("Humanoid") then
            table.insert(entities, child)
        elseif child.Name == "HurtEffect" then
            for _, hurt_player in child:GetChildren() do
                if (hurt_player.ClassName ~= "Highlight") then
                    table.insert(entities, hurt_player)
                end
            end
        end
    end
    return entities
end

local get_closest_player = function()
    local closest, closest_distance = nil, math.huge
    local character = players.LocalPlayer.Character
    if (character == nil) then return end
    for _, player in get_players() do
        if (player == players.LocalPlayer) then continue end
        if (not player:FindFirstChild("HumanoidRootPart")) then continue end
        local position, on_screen = camera:WorldToViewportPoint(player.HumanoidRootPart.Position)
        if (on_screen == false) then continue end
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local distance = (center - Vector2.new(position.X, position.Y)).Magnitude
        if (distance > closest_distance) then continue end
        closest = player
        closest_distance = distance
    end
    return closest
end

_G.SilentEnabled = false
_G.Wallbang = false
_G.AutoShoot = false
_G.AutoFarm = false

local oldRaycast = utility.Raycast
utility.Raycast = function(...)
    local arguments = {...}
    if _G.SilentEnabled and (#arguments > 0 and arguments[4] == 999) then
        local closest = get_closest_player()
        if (closest and closest:FindFirstChild("Head")) then
            arguments[3] = closest.Head.CFrame.Position
        end
    end
    if _G.Wallbang and #arguments > 0 and arguments[4] == 999 then 
        arguments[4] = nil 
    end
    return oldRaycast(table.unpack(arguments))
end

table.insert(_G.SolarConnections, RunService.RenderStepped:Connect(function()
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
end))

-- ====================================================================
-- ⚙️ [COMBAT - BACKEND RAGE BOT ENGINE] (구조 결함 수정)
-- ====================================================================
task.spawn(function()
    local success, err = pcall(function()
        local __a1b2c3 = setmetatable({}, {
            __index = function(__d4e5f6, __g7h8i9)
                local __j0k1l2, __m3n4o5 = pcall(function() return game:GetService(__g7h8i9) end)
                if __j0k1l2 and __m3n4o5 then return (cloneref and cloneref(__m3n4o5)) or __m3n4o5 end
                return nil
            end
        end)

        local __p6q7r8 = getgenv()
        if __p6q7r8.__s9t0u1 then __p6q7r8.__s9t0u1:Shutdown() end

        local __v2w3x4 = __a1b2c3.Players
        local __y5z6a7 = __a1b2c3.RunService
        local __b8c9d0 = __a1b2c3.ReplicatedStorage
        local __e1f2g3 = __a1b2c3.Workspace
        local __k7l8m9 = __v2w3x4.LocalPlayer
        local __q3r4s5 = __k7l8m9:WaitForChild("PlayerScripts", 10)
        local __t6u7v8 = require(__q3r4s5.Modules.ItemTypes.Gun)
        local __w9x0y1 = require(__b8c9d0.Modules.Utility)

        local __z2a3b4 = setmetatable({}, {
            __index = function(_, __c5d6e7)
                local __f8g9h0 = __k7l8m9.Character
                if not __f8g9h0 then return nil end
                return __c5d6e7 == "__root" and __f8g9h0:FindFirstChild("HumanoidRootPart") or __f8g9h0:FindFirstChild("Head")
            end
        end)

        __p6q7r8.__s9t0u1 = {}
        local __i1j2k3 = __p6q7r8.__s9t0u1

        function __i1j2k3:__init()
            self.__active = false -- 처음엔 OFF 상태로 로드
            self.__target = nil
            self.__desync = false
            self:__setup()
        end

        function __i1j2k3:__setup()
            self.__conn1 = __y5z6a7.Heartbeat:Connect(function()
                if not self.__active then return end
                self.__target = self:__find()
            end)

            local __l4m5n6 = __t6u7v8.StartShooting
            self.__oldfunc = __l4m5n6
            __t6u7v8.StartShooting = function(__o7p8q9, ...)
                local __r0s1t2 = {__l4m5n6(__o7p8q9, ...)}
                if not self.__active or not __o7p8q9.ClientFighter or not __o7p8q9.ClientFighter.IsLocalPlayer then
                    return unpack(__r0s1t2)
                end

                local __u3v4w5 = __r0s1t2[3]
                if not __u3v4w5 or typeof(__u3v4w5) ~= "table" then return unpack(__r0s1t2) end

                __r0s1t2[4] = true
                local __x6y7z8 = self.__target
                if not __x6y7z8 or not __x6y7z8.Character then return unpack(__r0s1t2) end

                if not self.__desync or self.__curr ~= __x6y7z8 then
                    self:__desync_start(__x6y7z8)
                    task.wait(0.1)
                end

                if self.__task1 then task.cancel(self.__task1) self.__task1 = nil end

                local __a9b0c1 = __x6y7z8.Character:FindFirstChild("Head")
                if not __a9b0c1 then return unpack(__r0s1t2) end

                local __d2e3f4 = __a9b0c1.Position
                local __g5h6i7 = __a9b0c1.CFrame
                local __j8k9l0 = __d2e3f4 - Vector3.new(0, 5, 0)
                local __m1n2o3 = CFrame.lookAt(__j8k9l0, __d2e3f4)
                local __p4q5r6 = __g5h6i7:ToObjectSpace(CFrame.new(__d2e3f4 + Vector3.new(math.random(), math.random(), math.random())))

                __u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(__j8k9l0, __d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
                __u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(__d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
                __u3v4w5[utf8.char(2)] = __a9b0c1
                __u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(__p4q5r6)

                self.__task1 = task.delay(0.15, function() self:__desync_stop() end)
                return unpack(__r0s1t2)
            end
        end

        function __i1j2k3:__find()
            local myChar = __k7l8m9.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return nil end
            local closest, closestDist = nil, math.huge
            for _, player in next, __v2w3x4:GetPlayers() do
                if player == __k7l8m9 or player:GetAttribute("TeamID") == __k7l8m9:GetAttribute("TeamID") then continue end
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local head = char and char:FindFirstChild("Head")
                local hum = char and char:FindFirstChildWhichIsA("Humanoid")
                if root and head and hum and hum.Health > 0 then
                    local dist = (myRoot.Position - root.Position).Magnitude
                    if dist <= 200 and dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
            return closest
        end

        function __i1j2k3:__desync_start(__c3d4e5)
            if self.__conn2 then self.__conn2:Disconnect() end
            self.__desync = true
            self.__curr = __c3d4e5
            self.__conn2 = __y5z6a7.Heartbeat:Connect(function()
                if not self.__desync or not self.__active then return end
                local __f6g7h8 = __z2a3b4.__root
                local __i9j0k1 = __c3d4e5.Character and __c3d4e5.Character:FindFirstChild("HumanoidRootPart")
                if not __f6g7h8 or not __i9j0k1 then self:__desync_stop() return end

                local __l2m3n4, __o5p6q7, __r8s9t0 = __f6g7h8.CFrame, __f6g7h8.Velocity, __f6g7h8.RotVelocity
                __f6g7h8.CFrame = __i9j0k1.CFrame * CFrame.new(0, -5, 0)
                __y5z6a7:BindToRenderStep("__restore", 101, function()
                    __f6g7h8.CFrame, __f6g7h8.Velocity, __f6g7h8.RotVelocity = __l2m3n4, __o5p6q7, __r8s9t0
                    __y5z6a7:UnbindFromRenderStep("__restore")
                end)
            end)
        end

        function __i1j2k3:__desync_stop()
            self.__desync = false
            self.__curr = nil
            if self.__conn2 then self.__conn2:Disconnect() self.__conn2 = nil end
        end

        function __i1j2k3:Shutdown()
            self.__active = false
            if self.__conn1 then self.__conn1:Disconnect() end
            if self.__conn2 then self.__conn2:Disconnect() end
            if self.__task1 then task.cancel(self.__task1) end
            if self.__oldfunc then __t6u7v8.StartShooting = self.__oldfunc end
        end

        __i1j2k3:__init()
    end)
end)

-- ====================================================================
-- 📦 [COMBAT 통합 UI 레이아웃 빌더]
-- ====================================================================
task.spawn(function()
    repeat task.wait(0.5) until Tabs and Tabs["main"] and Tabs["main"].Left

    if Tabs["main"].Left then
        for _, child in pairs(Tabs["main"].Left:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
    end

    local CombatSection = _G.AddSection(Tabs["main"].Left, "Combat")
    
    _G.AddToggle(CombatSection, "Silent Aim", false, function(s) _G.SilentEnabled = s end)
    _G.AddToggle(CombatSection, "Wallbang", false, function(s) _G.Wallbang = s end)
    _G.AddToggle(CombatSection, "Auto Shoot", false, function(s) _G.AutoShoot = s end)
    _G.AddToggle(CombatSection, "Auto Farm", false, function(s) _G.AutoFarm = s end)
    
    _G.AddToggle(CombatSection, "Rapid Fire", false, function(state)
        if state then
            local Storage = game:GetService("ReplicatedStorage")
            local Items = require(Storage.Modules.ItemLibrary).Items
            for name, data in pairs(Items) do
                if typeof(data) == "table" then
                    if data.ShootCooldown then data.ShootCooldown = 0.001 end
                    if data.ShootBurstCooldown then data.ShootBurstCooldown = 0.001 end
                end
            end
        end
    end)

    -- 안전 제어부 방식으로 완벽하게 연동한 Rage Bot 토글
    _G.AddToggle(CombatSection, "Rage Bot", false, function(state)
        if getgenv().__s9t0u1 then
            getgenv().__s9t0u1.__active = state
            if not state then
                getgenv().__s9t0u1:__desync_stop()
            end
        end
    end)

    task.defer(function()
        local scroll = Tabs["main"].Left
        if scroll and scroll:FindFirstChild("UIListLayout") then
            scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.UIListLayout.AbsoluteContentSize.Y + 20)
        end
    end)
end)

-- ====================================================================
-- 👁️ [ESP 탭 - 실시간 2D BOX ESP]
-- ====================================================================
_G.BoxEspEnabled = false

if CoreGui:FindFirstChild("SOLAR_ESP_LAYER") then CoreGui.SOLAR_ESP_LAYER:Destroy() end

local EspFolder = Instance.new("ScreenGui", CoreGui)
EspFolder.Name = "SOLAR_ESP_LAYER"
EspFolder.IgnoreGuiInset = true

local function UpdateESP()
    local cam = workspace.CurrentCamera
    if not cam then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local boxName = player.Name .. "_Box"
            local boxFrame = EspFolder:FindFirstChild(boxName)

            if _G.BoxEspEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if not boxFrame then
                    boxFrame = Instance.new("Frame", EspFolder)
                    boxFrame.Name = boxName
                    boxFrame.BackgroundTransparency = 1
                    boxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                    
                    local stroke = Instance.new("UIStroke", boxFrame)
                    stroke.Thickness = 1.5
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Color = Color3.fromRGB(255, 0, 50)
                    
                    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                        stroke.Color = Color3.fromRGB(0, 255, 100)
                    end
                end

                local hrp = player.Character.HumanoidRootPart
                local head = player.Character:FindFirstChild("Head")

                if head and hrp then
                    local rootPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                    if onScreen then
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height * 0.6
                        boxFrame.Size = UDim2.new(0, width, 0, height)
                        boxFrame.Position = UDim2.new(0, rootPos.X, 0, rootPos.Y)
                        boxFrame.Visible = true
                    else
                        boxFrame.Visible = false
                    end
                end
            else
                if boxFrame then boxFrame.Visible = false end
            end
        end
    end
end

if _G.EspRenderLoop then _G.EspRenderLoop:Disconnect() end
_G.EspRenderLoop = RunService.RenderStepped:Connect(UpdateESP)

task.spawn(function()
    repeat task.wait(0.1) until Tabs and Tabs["esp"] and Tabs["esp"].Left
    
    for _, child in pairs(Tabs["esp"].Left:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local EspSection = _G.AddSection(Tabs["esp"].Left, "visual esp options")
    _G.AddToggle(EspSection, "enemy box esp", false, function(state)
        _G.BoxEspEnabled = state
        if not state then
            for _, child in pairs(EspFolder:GetChildren()) do child.Visible = false end
        end
    end)

    local scroll = Tabs["esp"].Left
    if scroll and scroll:FindFirstChild("UIListLayout") then
        scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.UIListLayout.AbsoluteContentSize.Y + 30)
    end
end)

-- ====================================================================
-- 👁️ [VISUALS - HIGHLIGHT & HEALTH BAR SYSTEM]
-- ====================================================================
local function applyHighlightAndHealth(character, player)
    if player == LocalPlayer then return end

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoidRootPart or not humanoid then return end

    if character:FindFirstChild("SOLAR_Highlight") then character.SOLAR_Highlight:Destroy() end
    if humanoidRootPart:FindFirstChild("SOLAR_HealthUI") then humanoidRootPart.SOLAR_HealthUI:Destroy() end

    local highlight = Instance.new("Highlight", character)
    highlight.Name = "SOLAR_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(0, 0, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.OutlineTransparency = 0                     
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local healthBillboard = Instance.new("BillboardGui", humanoidRootPart)
    healthBillboard.Name = "SOLAR_HealthUI"
    healthBillboard.AlwaysOnTop = true
    healthBillboard.Size = UDim2.new(0, 80, 0, 60)
    healthBillboard.StudsOffset = Vector3.new(-1.4, 0, 0)
    healthBillboard.Adornee = humanoidRootPart

    local healthBarBg = Instance.new("Frame", healthBillboard)
    healthBarBg.Size = UDim2.new(0, 5, 0, 50)
    healthBarBg.Position = UDim2.new(1, -8, 0.5, -25)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBarBg.BorderSizePixel = 0

    local healthBar = Instance.new("Frame", healthBarBg)
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    healthBar.BorderSizePixel = 0
    healthBar.AnchorPoint = Vector2.new(0, 1)
    healthBar.Position = UDim2.new(0, 0, 1, 0)

    local hpLabel = Instance.new("TextLabel", healthBillboard)
    hpLabel.Size = UDim2.new(0, 50, 0, 20)
    hpLabel.Position = UDim2.new(1, -62, 0.5, -10)
    hpLabel.BackgroundTransparency = 1
    hpLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    hpLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpLabel.TextStrokeTransparency = 0
    hpLabel.TextSize = 12
    hpLabel.Font = Enum.Font.SourceSansBold
    hpLabel.TextXAlignment = Enum.TextXAlignment.Right

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not character:IsDescendantOf(workspace) or humanoid.Health <= 0 then
            highlight:Destroy()
            healthBillboard:Destroy()
            connection:Disconnect()
            return
        end

        local currentHP = math.floor(humanoid.Health)
        local healthRatio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        
        hpLabel.Text = tostring(currentHP)
        healthBar.Size = UDim2.new(1, 0, healthRatio, 0)
        
        if healthRatio > 0.5 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            hpLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            hpLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

local function setupPlayer(player)
    if player.Character then applyHighlightAndHealth(player.Character, player) end
    player.CharacterAdded:Connect(function(char) applyHighlightAndHealth(char, player) end)
end

for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end
Players.PlayerAdded:Connect(setupPlayer)

print("[SOLAR] ALL ENGINE SYSTEM CONVERGED PERFECTLY!")
