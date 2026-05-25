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
local R = {
						{ "LeftUpperArm", "UpperTorso" },
						{ "LeftLowerArm", "LeftUpperArm" },
						{ "LeftLowerArm", "LeftHand" },
						{ "RightUpperArm", "UpperTorso" },
						{ "RightLowerArm", "RightUpperArm" },
						{ "RightHand", "RightLowerArm" },
						{ "LeftUpperLeg", "LowerTorso" },
						{ "LeftLowerLeg", "LeftUpperLeg" },
						{ "LeftFoot", "LeftLowerLeg" },
						{ "RightUpperLeg", "LowerTorso" },
						{ "RightLowerLeg", "RightUpperLeg" },
						{ "RightFoot", "RightLowerLeg" },
						{ "LowerTorso", "UpperTorso" },
					}
					local m = b.lines
					local G = m[1]
					local G = false
					local c = function()
						if G then
							return
						end
						G = true
						for y, y in m do
							y.Visible = false
						end
					end
					local y = #Z
					local Z = function()
						local O = {}
						local t = 0
						for o, V in k(P) do
							t = t + 1
							O[o] = g[3][g[2]](o ~= "UpperTorso" and V.Position or (V.Position + U(0, V.Size.Y / 3, 0)))
						end
						if (t ~= y) then
							return
						end
						return O
					end
					b.functions.skeleton = function()
						if not B then
							return c()
						end
						local g = Z()
						if not g then
							return c()
						end
						G = false
						for Z, G in R do
							local R, U = m[Z], m[Z + 13]
							local m, Z = g[G[1]], g[G[2]]
							local g = (m - Z).Unit
							R.From, R.To = m + g, Z - g
							if f then
								local G = g * 2
								U.From, U.To = m + G, Z - G
								U.Visible = true
							else
								U.Visible = false
							end
							R.Visible = true
						end
					end
				end
				do
					local R = u("healthbar", Instance.new("UIGradient", b.squares[3]._frame._stroke))
					R.Color = s[3][s[2]]
					R.Rotation = 90
					local g, m = b.squares[3], b.squares[4]
					g._frame.AnchorPoint = A(0, 1)
					m._frame.AnchorPoint = A(0, 1)
					local Z, Z = 0, 0
					local s = math.lerp
					local G = Options.esp_healthbar_health_lerp
					local G, U = A(0, 1), A(0, 2)
					local c = A(5, 0)
					local c = A(-1, 2)
					local y = A(1, -1)
					local y = A(1, -1)
					table.insert(
						b.connections,
						I.CharacterAdded:Connect(function()
							Z = 0
						end)
					)
					b.functions.healthbar = function(O, t, B)
						if L[3][L[2]] then
							t = t - G
							O = O + U
							local G = t - A(O.X / 2 + 6, -O.Y + 1) - c
							if L[3][L[2]] then
								local U = n / a
								Z = s(Z, U, j)
								local s = A(2, T(2, (O.Y - 2) * Z))
								g.Size = s
								g.Position = G
								R.Offset = A(0, (Z - 1))
								if z then
									m.Size = A(4, s.Y + 2)
									m.Position = G - y
								else
									m.Size = A(4, O.Y)
									m.Position = G - y
								end
								m.Visible = true
								g.Visible = true
							else
								m.Visible, g.Visible = false, false
							end
						else
							m.Visible, g.Visible = false, false
						end
					end
				end
				local R = false
				local T = function()
					if R then
						return
					end
					R = true
					for g, g in b.drawings do
						g.Visible = false
					end
				end
				table.insert(b.connections, I.CharacterAdded:Connect(S))
				table.insert(
					b.connections,
					I.CharacterRemoving:Connect(function(g)
						if (H == g) then
							H = nil
							M = nil
							C = nil
							n = 0
							b.text[2].Text = "none"
							table.clear(P)
						end
					end)
				)
				local g
				table.insert(
					b.connections,
					J.events.esp_color_changed.Event:Connect(function()
						for m, Z in { "esp_name_", "esp_weapon_", "esp_distance_" } do
							local s = b.text[m]._frame.UIGradient
							s.Color, s.Rotation = i(Z .. "color"), Options[Z .. "rotation"].Value
						end
						local m = b.squares[2]._frame._stroke.UIGradient
						m.Color = i("esp_box_color")
						m.Rotation = Options.esp_box_rotation.Value
						b.text[1].Text = I[Options.esp_name_type.Value]
						local m = q[Options.esp_font.Value]
						for Z, Z in b.text do
							Z._frame.FontFace, Z.Size = m.font, _G.A or m.size
						end
						do
							local m = {
								ColorSequence.new(Options.esp_skeleton_color2.Value, Options.esp_skeleton_color3.Value),
								ColorSequence.new(Options.esp_skeleton_color1.Value, Options.esp_skeleton_color2.Value),
								ColorSequence.new(Options.esp_skeleton_color1.Value),
							}
							for Z, s in b.lines do
								local G = (Z > 13)
								s.Thickness = Q + (G and 2 or 0)
								if not G then
									local G = s._frame.UIGradient
									local s = ((Z - 1) % 3) + 1
									if (Z == 13) then
										G.Color = ColorSequence.new(Options.esp_skeleton_color3.Value)
									else
										G.Color = m[s]
									end
								end
							end
						end
						local m = function()
							if ((w or not r._is_ally) and H and Toggles.esp_override_appearance.Value) then
								J.customization.self:change(H, function()
									local Z = Options.esp_body_disables.Value
									return Toggles.esp_body_color.Value and Options.esp_body_color_value.Value,
										1 - (Options.esp_body_transparency.Value / 100),
										Toggles.esp_material.Value and Enum.Material[Options.esp_material_value.Value],
										Z["decals"],
										Toggles.esp_material.Value and Options.esp_material_value.Value ~= "ForceField"
											or Z["clothing"]
								end)
							else
								J.customization.self:restore(H)
							end
						end
						local Z = P.Head
						if (H and (J.customization.self:get(H) or (Z and Z.Transparency < 0.5))) then
							m()
						elseif (H and Z and Toggles.esp_override_appearance.Value) then
							pcall(task.cancel, g)
							g = task.spawn(function()
								while (task.wait(1) and Z.Parent and Z.Transparency > 0.5) do
								end
								if Z.Parent then
									m()
								end
							end)
						end
						l = N[Options.esp_font.Value] or A(2, -1)
						W = A(5, q[Options.esp_font.Value].size - 2)
						if (H and H.Parent) then
							local q = H.Parent
							if (not w and r._is_ally) then
								pcall(F, H, "Parent", workspace)
							else
								pcall(F, H, "Parent", d)
							end
						end
					end)
				)
				table.insert(
					b.connections,
					J.events.esp_effects_changed.Event:Connect(function()
						for q, q in { "aura", "particle" } do
							if (not w and r._is_ally) then
								E:destroy(q)
								continue
							end
							if (H and Toggles["esp_effects_" .. q].Value) then
								E:create(H, Options["esp_effects_" .. q .. "_value"].Value, q)
							else
								E:destroy(q)
							end
						end
					end)
				)
				table.insert(
					b.connections,
					J.events.esp_effects_color_changed.Event:Connect(function()
						for q, q in { "aura", "particle" } do
							E:update(q)
						end
					end)
				)
				local q, g, l, m, d, d, Z =
					b.functions.box,
					b.functions.fill,
					b.functions.name,
					b.functions.weapon,
					b.functions.accuracy,
					b.functions.distance,
					b.functions.healthbar
				local F = b.functions.skeleton
				table.insert(
					b.connections,
					Y.RenderStepped:Connect(function(A)
						if (not x or not M or (not w and r._is_ally)) then
							return T()
						end
						if (n <= 0) then
							return T()
						end
						local n, J, s = v()
						if not n then
							return T()
						end
						R = false
						F()
						q(n, J)
						l(n, J)
						g(n, J, A)
						m(n, J)
						d(n, J, s)
						Z(n, J, A)
					end)
				)
				if H then
					task.spawn(S, H)
				end
				table.clear(b.functions)
				_.running[I] = b
			end
		end
	end

local A_func = function(R)
		local T = R[2]
		local q = R[1]
		local g = R[0]
		local l = R[3]
		return function()
			if g.Value then
				local R = l.CFrame
				q._current.Position = R.Position + T
			end
		end
	end

local Y = function(R)
		local T = R[4]
		local q = R[0]
		local g = R[8]
		local l = R[3]
		local m = R[9]
		local d = R[7]
		local Z = R[2]
		local F = R[6]
		local A = R[1]
		local _ = R[5]
		return function()
			local R = A.Tabboxes
			function l:Remove()
				d:Destroy()
				table.clear(l)
				R[_.Name or ""] = nil
			end
			function l:AddTab(R, n)
				local v = {}
				local J = q:Create(
					T[3][T[2]],
					{
						BackgroundColor3 = q.MainColor,
						BorderSizePixel = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Size = UDim2.new(0.5, 0, 1, 0),
						ZIndex = 6,
						Parent = Z,
					}
				)
				local s = q:Create(
					T[3][T[2]],
					{
						BackgroundColor3 = q.AccentColor,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 0, 1),
						ZIndex = 8,
						Visible = n or false,
						Parent = J,
					}
				)
				q:AddToRegistry(s, { BackgroundColor3 = "AccentColor" })
				local G = n and UDim2.new(1, -1, 1, 0) or UDim2.new(1, 0, 1, 0)
				local n = q:Create(
					T[3][T[2]],
					{
						BackgroundTransparency = 0,
						BackgroundColor3 = q.MainColor,
						BorderSizePixel = 1,
						BorderColor3 = q.OutlineColor,
						BorderMode = Enum.BorderMode.Inset,
						Size = G,
						ZIndex = 7,
						Parent = J,
					}
				)
				q:AddToRegistry(J, { BackgroundColor3 = "MainColor" })
				q:AddToRegistry(n, { BackgroundColor3 = "MainColor", BorderColor3 = m[3][m[2]] })
				local m = q:CreateLabel({
					Size = UDim2.new(1, 0, 1, 0),
					TextSize = 14,
					Text = R,
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 7,
					Parent = J,
				})
				local m = q:Create(
					T[3][T[2]],
					{
						BackgroundColor3 = q.BackgroundColor,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 1, 0),
						Size = UDim2.new(1, 0, 0, 1),
						Visible = false,
						ZIndex = 9,
						Parent = J,
					}
				)
				q:AddToRegistry(m, { BackgroundColor3 = "BackgroundColor" })
				local G = q:Create(
					T[3][T[2]],
					{
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 4, 0, 20),
						Size = UDim2.new(1, -4, 1, -20),
						ZIndex = 1,
						Visible = false,
						Parent = g,
					}
				)
				q:Create(
					"UIListLayout",
					{ FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Parent = G }
				)
				function v:Show()
					for T, T in next, l.Tabs do
						T:Hide()
					end
					G.Visible = true
					m.Visible = true
					n.Visible = false
					s.Visible = true
					J.BackgroundColor3 = q.BackgroundColor
					q.RegistryMap[J].Properties.BackgroundColor3 = "BackgroundColor"
					v:Resize()
				end
				function v:Hide()
					G.Visible = false
					m.Visible = false
					n.Visible = true
					s.Visible = false
					J.BackgroundColor3 = q.MainColor
					q.RegistryMap[J].Properties.BackgroundColor3 = "MainColor"
				end
				function v:Resize()
					local T = 0
					for g, g in next, l.Tabs do
						T = T + 1
					end
					for g, g in next, Z:GetChildren() do
						if not g:IsA("UIListLayout") then
							g.Size = UDim2.new(1 / T, 0, 1, 0)
						end
					end
					if not G.Visible then
						return
					end
					local T = 0
					for g, g in next, v.Container:GetChildren() do
						if (not g:IsA("UIListLayout")) and g.Visible then
							T = T + g.Size.Y.Offset
						end
					end
					d.Size = UDim2.new(1, 0, 0, 20 + T + 2 + 2)
				end
				J.InputBegan:Connect(function(T)
					if
						(T.UserInputType == Enum.UserInputType.MouseButton1 and not q:MouseIsOverOpenedFrame())
						or T.UserInputType == Enum.UserInputType.Touch
					then
						v:Show()
						v:Resize()
					end
				end)
				v.Container = G
				l.Tabs[R] = v
				setmetatable(v, F)
				v:AddBlank(3)
				v:Resize()
				if #Z:GetChildren() == 2 then
					v:Show()
				end
				return v
			end
			A.Tabboxes[_.Name or ""] = l
		end
	end

local r = function(R)
		local T = R[2]
		local q = R[1]
		local g = R[0]
		return function()
			local R = cloneref or function(l)
				return l
			end
			local l = R(game:GetService("HttpService"))
			local R = (syn and syn.request)
				or (http and http.request)
				or http_request
				or (fluxus and fluxus.request)
				or request
			local R = getcustomasset or getsynasset
			do
				g.Folder = ""
				g.Library = nil
				g.BuiltInThemes = {
					["Default"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"131313",\n\t\t\t\t"AccentColor":"a2cdff",\n\t\t\t\t"BackgroundColor":"151515",\n\t\t\t\t"OutlineColor":"212121",\n\t\t\t\t"RiskColor":"ff7425",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Tokyo Night"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"191925",\n\t\t\t\t"AccentColor":"6956cb",\n\t\t\t\t"BackgroundColor":"15151e",\n\t\t\t\t"OutlineColor":"272727",\n\t\t\t\t"RiskColor":"fb5f5f",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Nord"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"1c1e20",\n\t\t\t\t"AccentColor":"9effc8",\n\t\t\t\t"BackgroundColor":"1c1e20",\n\t\t\t\t"OutlineColor":"24282d",\n\t\t\t\t"RiskColor":"ff7a00",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Skeet"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"131313",\n\t\t\t\t"AccentColor":"81ff54",\n\t\t\t\t"BackgroundColor":"151515",\n\t\t\t\t"OutlineColor":"2a2a2a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Fatality"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"181537",\n\t\t\t\t"AccentColor":"ca0756",\n\t\t\t\t"BackgroundColor":"201c46",\n\t\t\t\t"OutlineColor":"39335a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Neverlose"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"0c1014",\n\t\t\t\t"AccentColor":"01a3f1",\n\t\t\t\t"BackgroundColor":"0c0f14",\n\t\t\t\t"OutlineColor":"191919",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Onetap"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"1e1d22",\n\t\t\t\t"AccentColor":"faa614",\n\t\t\t\t"BackgroundColor":"18181c",\n\t\t\t\t"OutlineColor":"313033",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Imgui"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"151617",\n\t\t\t\t"AccentColor":"406ba8",\n\t\t\t\t"BackgroundColor":"151617",\n\t\t\t\t"OutlineColor":"242424",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Iniuria"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"1e1d1e",\n\t\t\t\t"AccentColor":"c41275",\n\t\t\t\t"BackgroundColor":"1e1d1e",\n\t\t\t\t"OutlineColor":"33252b",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Primordial"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"181818",\n\t\t\t\t"AccentColor":"d7a6b0",\n\t\t\t\t"BackgroundColor":"1f1f1f",\n\t\t\t\t"OutlineColor":"2a2a2a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Monolith"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"141115",\n\t\t\t\t"AccentColor":"c707bd",\n\t\t\t\t"BackgroundColor":"171417",\n\t\t\t\t"OutlineColor":"272427",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["V3rmillion"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"202020",\n\t\t\t\t"AccentColor":"cd1818",\n\t\t\t\t"BackgroundColor":"202020",\n\t\t\t\t"OutlineColor":"2a2a2a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
					["Dark"] = {
						1,
						l:JSONDecode(
							'{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"0a0a0a",\n\t\t\t\t"AccentColor":"5945ff",\n\t\t\t\t"BackgroundColor":"0a0a0a",\n\t\t\t\t"OutlineColor":"171717",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'
						),
					},
				}
				function g:ApplyTheme(R)
					if not R then
						return
					end
					local m = self:GetCustomTheme(R)
					local d = m or self.BuiltInThemes[R]
					if not d then
						return
					end
					if self.Library.InnerVideoBackground ~= nil then
						self.Library.InnerVideoBackground.Visible = false
					end
					local R = d[2]
					for d, Z in next, m or R do
						if d:find("Color") then
							self.Library[d] = Color3.fromHex(Z)
							if q[d] then
								q[d]:SetValueRGB(Color3.fromHex(Z))
							end
						else
							self.Library[d] = Z
							if q[d] then
								q[d]:SetValue(Z)
							end
						end
					end
					self:ThemeUpdate()
				end
				function g:ThemeUpdate()
					if self.Library.InnerVideoBackground ~= nil then
						self.Library.InnerVideoBackground.Visible = false
					end
					local R = {
						"Contrast",
						"Saturation",
						"Brightness",
						"BlurSize",
						"FontColor",
						"RiskColor",
						"MainColor",
						"AccentColor",
						"BackgroundColor",
						T[3][T[2]],
						"SwordColor",
						"ItemType",
						"BackTransparency",
						"BackColor",
						"SwordTransparency",
						"SwordReflectance",
						"SwordMaterial",
						"SwordSpeed",
					}
					for m, m in next, R do
						if q and q[m] then
							self.Library[m] = q[m].Value
						end
					end
					self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
					self.Library:UpdateColorsUsingRegistry()
				end
				function g:LoadDefault()
					local R = "Default"
					local m = isfile(self.Folder .. "/themes/default.txt")
						and readfile(self.Folder .. "/themes/default.txt")
					local d = true
					if m then
						if self.BuiltInThemes[m] then
							R = m
						elseif self:GetCustomTheme(m) then
							R = m
							d = false
						end
					elseif self.BuiltInThemes[self.DefaultTheme] then
						R = self.DefaultTheme
					end
					if d then
						q.ThemeManager_ThemeList:SetValue(R)
					else
						self:ApplyTheme(R)
					end
				end
				function g:SaveDefault(R)
					writefile(self.Folder .. "/themes/default.txt", R)
				end
				function g:Delete(R)
					if not R then
						return false, "no config file is selected"
					end
					local m = self.Folder .. "/themes/" .. R
					if not isfile(m) then
						return false, "invalid file"
					end
					local R, d = pcall(delfile, m)
					if not R then
						return false, "delete file error"
					end
					return true
				end
				function g:GetCustomTheme(R)
					if not R then
						return
					end
					local m = self.Folder .. "/themes/" .. R
					if not isfile(m) then
						return nil
					end
					local R = readfile(m)
					local m, d = pcall(l.JSONDecode, l, R)
					if not m then
						return nil
					end
					return d
				end
				function g:SaveCustomTheme(R)
					if not R or R:gsub(" ", "") == "" then
						return self.Library:Notify("Invalid file name for theme (empty)", 3)
					end
					local m = {}
					local d = {
						"Contrast",
						"Saturation",
						"Brightness",
						"BlurSize",
						"FontColor",
						"RiskColor",
						"MainColor",
						"AccentColor",
						"BackgroundColor",
						T[3][T[2]],
						"ItemType",
						"SwordColor",
						"BackTransparency",
						"BackColor",
						"SwordTransparency",
						"SwordReflectance",
						"SwordMaterial",
						"SwordSpeed",
					}
					for T, T in next, d do
						if q[T] then
							if not T:find("Color") then
								m[T] = q[T].Value
							else
								m[T] = q[T].Value:ToHex()
							end
						end
					end
					writefile(self.Folder .. "/themes/" .. R, l:JSONEncode(m))
				end
				function g:ReloadCustomThemes()
					local R = listfiles(self.Folder .. "/themes")
					local T = {}
					for q = 1, #R do
						local l = R[q]
						if l:sub(-5) == ".json" then
							local R = l:find(".json", 1, true)
							local q = l:sub(R, R)
							while q ~= "/" and q ~= "\\" and q ~= "" do
								R = R - 1
								q = l:sub(R, R)
							end
							if q == "/" or q == "\\" then
								table.insert(T, l:sub(R + 1))
							end
						end
					end
					return T
				end
				function g:SetLibrary(R)
					self.Library = R
				end
				function g:BuildFolderTree()
					local R = {}
					local T = self.Folder:split("/")
					for q = 1, #T do
						R[#R + 1] = table.concat(T, "/", 1, q)
					end
					table.insert(R, self.Folder .. "/themes")
					for T = 1, #R do
						local q = R[T]
						if not isfolder(q) then
							makefolder(q)
						end
					end
				end
				function g:SetFolder(R)
					self.Folder = R
					self:BuildFolderTree()
				end
				function g:CreateGroupBox(R)
					assert(self.Library, "Must set ThemeManager.Library first!")
					return R:AddLeftTabbox()
				end
				function g:ApplyToTab(R)
					assert(self.Library, "Must set ThemeManager.Library first!")
					local T = self:CreateGroupBox(R)
					self:CreateThemeManager(T)
				end
				function g:ApplyToGroupbox(R)
					assert(self.Library, "Must set ThemeManager.Library first!")
					self:CreateThemeManager(R)
				end
			end
			getgenv().ThemeManager = g
		end
	end

local o = function(R)
		local T = R[33]
		local q = R[22]
		local g = R[21]
		local l = R[13]
		local m = R[30]
		local d = R[2]
		local Z = R[20]
		local F = R[16]
		local A = R[7]
		local _ = R[29]
		local n = R[17]
		local v = R[28]
		local J = R[27]
		local s = R[15]
		local G = R[6]
		local a = R[8]
		local H = R[10]
		local Y = R[3]
		local N = R[11]
		local U = R[19]
		local i = R[9]
		local L = R[14]
		local c = R[25]
		local y = R[5]
		local O = R[24]
		local t = R[0]
		local B = R[1]
		local f = R[32]
		local Q = R[12]
		local z = R[23]
		local j = R[4]
		local S = R[18]
		local u = R[26]
		local w = R[31]
		return function(R, x, o, V, X, I)
			q(8)
			I = O[3][O[2]](I)
			local O, r = f.Value, J.Value
			local J = F.Value
			local F = d.Value
			local d, f
			local b, C = nil, nil
			if o then
				local M, E = O["position on target"], r["position on target"]
				if (M or E or J["position on target"] or F["position on target"]) then
					local W, e
					if X then
						W, e = V, X
					else
						W, e = G[3][G[2]](o.Position)
					end
					if e then
						V, b, X = W, W, e
						if M then
							f = B.Position:Lerp(V, y.Value)
						end
						if E then
							d = U.Position:Lerp(V, a.Value)
						end
					end
				end
			end
			local M = u[3][u[2]].EquippedItem
			if (M and M.ViewModel and M.Info.Type == "Gun") then
				local u, E = not f and O["position on barrel"], not d and r["position on barrel"]
				if (u or E or J["position on barrel"] or F["position on barrel"]) then
					local O = M.ViewModel
					if (O and (#O._muzzle_attachments > 0 or (O._body_model and O._body_model.PrimaryPart))) then
						local r, W, e = pcall(function()
							return G[3][G[2]](O:GetMuzzlePosition())
						end)
						q(8)
						if (r and e) then
							C = W
							if u then
								f = B.Position:Lerp(W, y.Value)
							end
							if E then
								d = U.Position:Lerp(W, a.Value)
							end
						end
					end
				end
				if l[3][l[2]] then
					local q, l = _[3][_[2]], ""
					local _, O, u = M.Info.MaxAmmo, M.Data.AmmoReserve, M.Data.Ammo
					if ((_ and _ ~= i) and (O and O ~= i) and (u and u ~= i)) then
						if q.ammo then
							I = I .. Z("ammo", u)
							l = Z("ammo divider", "/")
						end
						if q["max ammo"] then
							I = I .. l .. Z("max ammo", _)
							l = Z("ammo divider", "/")
						end
						if q["reserve"] then
							I = I .. l .. Z("reserve", O)
						end
						if (I ~= "") then
							I = I .. "\n"
						end
					end
				end
			end
			if not d then
				d = U.Position:Lerp(R, a.Value)
			end
			if not f then
				f = B.Position:Lerp(R, y.Value)
			end
			local q = (F["position on target"] and b) or (F["position on barrel"] and C) or R
			c[3][c[2]] = c[3][c[2]]:Lerp(q, z.Value)
			s.Position = c[3][c[2]] + m[3][m[2]]
			s.Text = I
			local q = Q()
			L[3][L[2]]((J["position on target"] and b) or (J["position on barrel"] and C) or R, q)
			B.Position, U.Position = f, d
			Y.Position, n.Position = f, d
			if v.Value then
				local R = (q * 360 * H.Value) % 360
				for l, l in N do
					l.Rotation = R
				end
			end
			if w.Value then
				local R = (q * 360 * A.Value) % 360
				for q, q in T do
					q.Rotation = R
				end
			end
			if (o and X) then
				if j.Value then
					t.Adornee = x
					t.Enabled = true
				else
					t.Adornee = nil
					t.Enabled = false
				end
				if S.Value then
					g.Visible = true
					g.To = V or G[3][G[2]](o.Position)
					g.From = f
				else
					g.Visible = false
				end
			else
				g.Visible = false
				t.Adornee = nil
				t.Enabled = false
			end
		end
	end

local N = function(R)
		local T = R[10]
		local q = R[21]
		local g = R[16]
		local l = R[6]
		local m = R[7]
		local d = R[9]
		local Z = R[23]
		local F = R[18]
		local A = R[2]
		local _ = R[8]
		local n = R[19]
		local v = R[24]
		local J = R[22]
		local s = R[5]
		local G = R[3]
		local a = R[14]
		local H = R[0]
		local Y = R[4]
		local N = R[13]
		local U = R[17]
		local i = R[15]
		local L = R[1]
		local c = R[20]
		local y = R[12]
		local O = R[11]
		return function()
			local R = L:AddContextMenu(a)
			R:AddOption("Make gradient", function()
				local t = {}
				for B, B in J.Addons do
					if (B.Type == "ColorPicker") then
						table.insert(t, B)
					end
				end
				if (#t < 3) then
					R:Hide()
					return L:Notify("not enough colors for a gradient.", 2)
				end
				local B, f = t[1].Value, t[#t].Value
				for Q = 2, #t - 1 do
					local z = t[Q]
					z:SetValueRGB(B:Lerp(f, Q / #t), z.Transparency)
				end
				L:Notify("created gradient!", 2)
				R:Hide()
			end)
			R:AddOption("Match color", function()
				local t = {}
				for B, B in J.Addons do
					if (B.Type == "ColorPicker") then
						table.insert(t, B)
					end
				end
				for J, J in t do
					J:SetValueRGB(H.Value, J.Transparency)
				end
				L:Notify("matched all colors!", 2)
				R:Hide()
			end)
			R:AddOption("Copy color", function()
				L.ColorClipboard = H
				L:Notify("Copied color!", 2)
				R:Hide()
			end)
			R:AddOption("Paste color", function()
				if not L.ColorClipboard then
					return L:Notify("You have not copied a color!", 2)
				end
				H:SetValueRGB(L.ColorClipboard.Value, L.ColorClipboard.Transparency)
				R:Hide()
			end)
			if L.FlagCopying then
				R:AddOption("Copy Flag", function()
					pcall(setclipboard, H.Idx)
					task.wait()
					L:Notify("Copied flag to clipboard!", 2)
					R:Hide()
				end)
			end
			L:AddToRegistry(Z, { BackgroundColor3 = "BackgroundColor", BorderColor3 = O[3][O[2]] })
			L:AddToRegistry(i, { BackgroundColor3 = "AccentColor" })
			L:AddToRegistry(n, { BackgroundColor3 = "BackgroundColor", BorderColor3 = O[3][O[2]] })
			L:AddToRegistry(q, { BackgroundColor3 = "MainColor", BorderColor3 = O[3][O[2]] })
			L:AddToRegistry(v.Frame, { BackgroundColor3 = "MainColor", BorderColor3 = O[3][O[2]] })
			L:AddToRegistry(_, { TextColor3 = "FontColor" })
			L:AddToRegistry(l, { TextColor3 = "FontColor" })
			local R = {}
			for q = 0, 1, 0.1 do
				table.insert(R, ColorSequenceKeypoint.new(q, Color3.fromHSV(q, 1, 1)))
			end
			local q = L:Create("UIGradient", { Color = ColorSequence.new(R), Rotation = 90, Parent = N })
			l.FocusLost:Connect(function(R)
				if R then
					local R, q = pcall(Color3.fromHex, l.Text)
					if R and typeof(q) == "Color3" then
						H.Hue, H.Sat, H.Vib = Color3.toHSV(q)
					end
				end
				H:Display()
			end)
			_.FocusLost:Connect(function(R)
				if R then
					local R, q, Z = _.Text:match("(%d+),%s*(%d+),%s*(%d+)")
					if R and q and Z then
						H.Hue, H.Sat, H.Vib = Color3.toHSV(Color3.fromRGB(R, q, Z))
					end
				end
				H:Display()
			end)
			function H:Display()
				H.Value = Color3.fromHSV(H.Hue, H.Sat, H.Vib)
				d.BackgroundColor3 = Color3.fromHSV(H.Hue, 1, 1)
				L:Create(
					a,
					{
						BackgroundColor3 = H.Value,
						BackgroundTransparency = H.Transparency,
						BorderColor3 = L:GetDarkerColor(H.Value),
					}
				)
				if s[3][s[2]] then
					s[3][s[2]].BackgroundColor3 = H.Value
					g[3][g[2]].Position = UDim2.new(1 - H.Transparency, 0, 0, 0)
				end
				U.Position = UDim2.new(H.Sat, 0, 1 - H.Vib, 0)
				F.Position = UDim2.new(0, 0, H.Hue, 0)
				l.Text = "#" .. H.Value:ToHex()
				_.Text = table.concat(
					{ math.floor(H.Value.R * 255), math.floor(H.Value.G * 255), math.floor(H.Value.B * 255) },
					", "
				)
				L:SafeCallback(H.Callback, H.Value)
				L:SafeCallback(H.Changed, H.Value)
			end
			function H:OnChanged(R)
				H.Changed = R
				R(H.Value)
			end
			local R = false
			function H:Show()
				R = true
				for q, g in next, L.OpenedFrames do
					if q.Name == "Color" then
						q.Visible = false
						L.OpenedFrames[q] = nil
					end
				end
				A.Visible = true
				L.OpenedFrames[A] = true
			end
			function H:Hide()
				R = false
				A.Visible = false
				L.OpenedFrames[A] = nil
			end
			function H:SetValue(q, g)
				local l = Color3.fromHSV(q[1], q[2], q[3])
				H.Transparency = g or 0
				H:SetHSVFromRGB(l)
				H:Display()
			end
			function H:Remove()
				c[y] = nil
				table.clear(H)
			end
			function H:SetValueRGB(q, g)
				H.Transparency = g or 0
				H:SetHSVFromRGB(q)
				H:Display()
			end
			d.InputBegan:Connect(function(q)
				if q.UserInputType == Enum.UserInputType.MouseButton1 then
					while T:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local q = d.AbsolutePosition.X
						local g = q + d.AbsoluteSize.X
						local l = math.clamp(m.X, q, g)
						local Z = d.AbsolutePosition.Y
						local F = Z + d.AbsoluteSize.Y
						local d = math.clamp(m.Y, Z, F)
						H.Sat = (l - q) / (g - q)
						H.Vib = 1 - ((d - Z) / (F - Z))
						H:Display()
						Y:Wait()
					end
					L:AttemptSave()
				end
			end)
			N.InputBegan:Connect(function(q)
				if q.UserInputType == Enum.UserInputType.MouseButton1 then
					while T:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local q = N.AbsolutePosition.Y
						local g = q + N.AbsoluteSize.Y
						local l = math.clamp(m.Y, q, g)
						H.Hue = ((l - q) / (g - q))
						H:Display()
						Y:Wait()
					end
					L:AttemptSave()
				end
			end)
			a.InputBegan:Connect(function(q)
				if q.UserInputType == Enum.UserInputType.MouseButton1 and not L:MouseIsOverOpenedFrame() then
					if A.Visible then
						H:Hide()
					else
						H:Show()
					end
				elseif q.UserInputType == Enum.UserInputType.MouseButton2 and not L:MouseIsOverOpenedFrame() then
					H:Hide()
				end
			end)
			if s[3][s[2]] then
				s[3][s[2]].InputBegan:Connect(function(q)
					if q.UserInputType == Enum.UserInputType.MouseButton1 then
						while T:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local T = s[3][s[2]].AbsolutePosition.X
							local q = T + s[3][s[2]].AbsoluteSize.X
							local g = math.clamp(m.X, T, q)
							H.Transparency = 1 - ((g - T) / (q - T))
							H:Display()
							Y:Wait()
						end
						L:AttemptSave()
					end
				end)
			end
			local T = function()
				if not R then
					return
				end
				local R, q = A.AbsolutePosition, A.AbsoluteSize
				if (m.X < R.X or m.X > R.X + q.X or m.Y < (R.Y - 20 - 1) or m.Y > R.Y + q.Y) then
					H:Hide()
				end
			end
			for R, R in { Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2 } do
				L:BindToInput(R, T)
			end
			H:Display()
			H.DisplayFrame = a
			c[y] = H
			G.Addons = G.Addons or {}
			table.insert(G.Addons, H)
			if G.ToggleRegion then
				G.ColorPickerCount = G.ColorPickerCount + 1
				if (G.ColorPickerCount > 2) then
					G.ToggleRegion.Size = G.ToggleRegion.Size - UDim2.new(0, 32, 0, 0)
				end
			end
		end
	end

local D = function(R)
		local T = R[2]
		local q = R[0]
		local g = R[4]
		local l = R[1]
		local m = R[3]
		return function()
			function l:AddButton(...)
				local R = typeof(select(1, ...)) == "table" and select(1, ...)
					or { Text = select(1, ...), Func = select(2, ...) }
				assert(typeof(R.Func) == "function", "AddButton: `Func` callback is missing.")
				self.Outer.Size = UDim2.new(0.5, -2, 0, 20)
				R.Outer, R.Inner, R.Label = g(R)
				R.Outer.Position = UDim2.new(1, 3, 0, 0)
				R.Outer.Size = UDim2.new(1, -3, 1, 0)
				R.Outer.Parent = self.Outer
				function R:AddTooltip(g)
					if typeof(g) == "string" then
						m:AddToolTip(g, self.Outer)
					end
					return R
				end
				if typeof(R.Tooltip) == "string" then
					R:AddTooltip(R.Tooltip)
				end
				T(R)
				return R
			end
			local R = {}
			function l:Remove()
				for T, T in R do
					T:Destroy()
				end
				l.Outer:Destroy()
				table.clear(l)
				q:Resize()
			end
			if typeof(l.Tooltip) == "string" then
				l:AddTooltip(l.Tooltip)
			end
			table.insert(R, q:AddBlank(5))
			q:Resize()
		end
	end

local u = function(R)
		local T = R[1]
		local q = R[3]
		local g = R[0]
		local l = R[4]
		local m = R[5]
		local d = R[2]
		return function()
			function T:SetText(R)
				l.Text = R
				if q then
					local Z = select(2, g:GetTextBounds(R, g.Font, 14, Vector2.new(l.AbsoluteSize.X, math.huge)))
					l.Size = UDim2.new(1, -4, 0, Z)
				end
				d:Resize()
			end
			local R = {}
			function T:Remove()
				for g, g in R do
					g:Destroy()
				end
				l:Destroy()
				table.clear(T)
				d:Resize()
			end
			if not q then
				setmetatable(T, m)
			end
			table.insert(R, d:AddBlank(5))
			d:Resize()
		end
	end

local H = function(R)
		local T = R[2]
		local q = R[0]
		local g = R[5]
		local l = R[1]
		local m = R[3]
		local d = R[4]
		local Z = R[6]
		return function()
			function l:Resize()
				m.Size = UDim2.new(1, 0, 0, q.AbsoluteContentSize.Y)
				T:Resize()
			end
			q:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				l:Resize()
			end)
			m:GetPropertyChangedSignal("Visible"):Connect(function()
				l:Resize()
			end)
			function l:Update()
				local R = false
				for q, q in next, l.Dependencies do
					if (q[1].Value == q[2]) then
						R = true
						break
					end
				end
				m.Visible = R
				l:Resize()
			end
			function l:SetupDependencies(R)
				for q, q in next, R do
					assert(type(q) == "table", "SetupDependencies: Dependency is not of type `table`.")
					assert(q[1], "SetupDependencies: Dependency is missing element argument.")
					assert(q[2] ~= nil, "SetupDependencies: Dependency is missing value argument.")
				end
				l.Dependencies = R
				l:Update()
			end
			function l:Remove()
				table.remove(d.DependencyBoxes, table.find(d.DependencyBoxes, l))
				table.clear(l)
				m:Destroy()
				T:Resize()
			end
			l.Container = g
			setmetatable(l, Z)
			table.insert(d.DependencyBoxes, l)
		end
	end

local g = function(R)
		local T = R[5]
		local q = R[2]
		local g = R[6]
		local l = R[12]
		local m = R[11]
		local d = R[8]
		local Z = R[9]
		local F = R[10]
		local A = R[4]
		local _ = R[7]
		local n = R[0]
		local v = R[3]
		local J = R[1]
		return function(R, s, G)
			local a, H = n("Attachment", v), n("Attachment", v)
			a.WorldPosition, H.WorldPosition = R, R
			local R = _:Clone()
			local _ = F.Value
			R.Width0, R.Width1 = _, _
			R.LightEmission = d.Value
			R.TextureSpeed = A.Value
			R.TextureLength = m.Value
			R.Parent = a
			R.Color = G
			R.Attachment0 = a
			R.Attachment1 = H
			local m = { R }
			for d = 1, (q.Value - 1) do
				local q = R:Clone()
				q.Parent = R.Parent
				table.insert(m, q)
			end
			T:Create(H, 
