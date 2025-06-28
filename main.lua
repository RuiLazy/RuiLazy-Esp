-- ruilazy-esp • FULL SCRIPT UI • Version June 2025
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Remove old UI if exists
pcall(function() CoreGui["ruilazy-esp"]:Destroy() end)

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ruilazy-esp"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- 🌸 UI Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 500, 0, 340)
Frame.Position = UDim2.new(0, 20, 0.5, -170)
Frame.BackgroundColor3 = Color3.fromRGB(255, 210, 235)
Frame.BorderSizePixel = 0
Frame.Visible = false

-- Nút tròn bật tắt menu
local OpenButton = Instance.new("ImageButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 40, 0, 40)
OpenButton.Position = UDim2.new(0, 10, 0, 100)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
OpenButton.BorderSizePixel = 0
OpenButton.Image = "rbxassetid://7743878856" -- Hình logo Discord (có thể đổi)

OpenButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- Tabs + Content
local SideBar = Instance.new("Frame", Frame)
SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(255, 160, 200)
SideBar.BorderSizePixel = 0

local Content = Instance.new("Frame", Frame)
Content.Position = UDim2.new(0, 120, 0, 0)
Content.Size = UDim2.new(1, -120, 1, 0)
Content.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", SideBar)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

-- Danh sách tab
local Tabs = {}
local Pages = {}
local TabNames = {
	["Thông tin"] = "Thông tin script",
	["Trang chính"] = "Tổng quan menu",
	["Event Summer"] = "Sự kiện Summer",
	["🛒 Shop"] = "Tự động Mua Egg & Seed",
	["Cài đặt"] = "Cài đặt hệ thống"
}

for name, title in pairs(TabNames) do
	local Btn = Instance.new("TextButton", SideBar)
	Btn.Size = UDim2.new(1, -12, 0, 36)
	Btn.Position = UDim2.new(0, 6, 0, 0)
	Btn.Text = name
	Btn.BackgroundColor3 = Color3.fromRGB(255, 140, 180)
	Btn.TextColor3 = Color3.new(1, 1, 1)
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 16
	Btn.AutoButtonColor = true

	local Page = Instance.new("ScrollingFrame", Content)
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.ScrollBarThickness = 4
	Page.CanvasSize = UDim2.new(0, 0, 0, 800)
	Page.Visible = false
	Page.Name = name
	Page.BackgroundTransparency = 1

	local PageLayout = Instance.new("UIListLayout", Page)
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PageLayout.Padding = UDim.new(0, 6)

	Btn.MouseButton1Click:Connect(function()
		for _, page in pairs(Content:GetChildren()) do
			if page:IsA("ScrollingFrame") then
				page.Visible = false
			end
		end
		Page.Visible = true
	end)

	if name == "Thông tin" then Page.Visible = true end

	Tabs[name] = Btn
	Pages[name] = Page
end-- Hàm tạo checkbox ✅ 🔲
local function CreateCheckbox(parent, text, default, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 32)
	button.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Text = (default and "✅ " or "🔲 ") .. text

	local state = default
	button.MouseButton1Click:Connect(function()
		state = not state
		button.Text = (state and "✅ " or "🔲 ") .. text
		if callback then callback(state) end
	end)

	button.Parent = parent
	return function() return state end
end

-- Hàm tạo danh sách chọn nhiều (checkbox list)
local function CreateChecklist(parent, title, items)
	local titleLabel = Instance.new("TextLabel", parent)
	titleLabel.Size = UDim2.new(1, -10, 0, 28)
	titleLabel.Text = "🔽 " .. title
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local container = Instance.new("Frame", parent)
	container.Size = UDim2.new(1, -10, 0, #items * 30)
	container.BackgroundTransparency = 1

	local listLayout = Instance.new("UIListLayout", container)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 4)

	local toggles = {}
	for _, name in ipairs(items) do
		local state = false
		local item = Instance.new("TextButton", container)
		item.Size = UDim2.new(1, 0, 0, 28)
		item.BackgroundColor3 = Color3.fromRGB(255, 210, 230)
		item.TextColor3 = Color3.new(1, 1, 1)
		item.Font = Enum.Font.Gotham
		item.TextSize = 14
		item.Text = "🔲 " .. name
		item.TextXAlignment = Enum.TextXAlignment.Left
		item.MouseButton1Click:Connect(function()
			state = not state
			item.Text = (state and "✅ " or "🔲 ") .. name
		end)
		toggles[name] = function() return state end
	end

	return toggles
	end-- 📦 Tab SHOP
local eggList = {
	"Common Egg", "Rare Egg", "Legendary Egg",
	"Mythical Egg", "Bug Egg", "Paradise Egg", "Bee Egg"
}
local seedList = {
	"Carrot", "Strawberry", "Blueberry", "Tomato", "Cauliflower",
	"Watermelon", "Green Apple", "Avocado", "Pineapple", "Banana",
	"Prickly Pear", "Bell Pepper", "Kiwi", "Feijoa", "Loquat", "Sugar Apple"
}

local shopPage = Pages["🛒 Shop"]
local eggToggles = CreateChecklist(shopPage, "Auto Mua Egg", eggList)
local seedToggles = CreateChecklist(shopPage, "Auto Mua Seed", seedList)

-- Nút tới Tom
local tpTom = Instance.new("TextButton", shopPage)
tpTom.Size = UDim2.new(0, 160, 0, 30)
tpTom.Text = "📍 Teleport tới Tom"
tpTom.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
tpTom.TextColor3 = Color3.new(1,1,1)
tpTom.Font = Enum.Font.GothamBold
tpTom.TextSize = 14
tpTom.MouseButton1Click:Connect(function()
	local tom = workspace:FindFirstChild("Tom")
	if tom and tom:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = tom.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)
tpTom.Parent = shopPage-- ⚙️ Tab Cài đặt
local settingPage = Pages["Cài đặt"]

local safeTeleToggle = CreateCheckbox(settingPage, "Dịch chuyển an toàn (Safe Teleport)", false)

local antiAfkToggle = CreateCheckbox(settingPage, "Bật chống bị văng AFK", false, function(state)
	if state then
		LocalPlayer.Idled:Connect(function()
			local vu = game:GetService("VirtualUser")
			vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
	end
end)

CreateCheckbox(settingPage, "🧹 Xoá bầu trời (Sky)", false, function(on)
	if on then pcall(function() workspace:FindFirstChildOfClass("Sky"):Destroy() end) end
end)

CreateCheckbox(settingPage, "❌ Xoá skin người chơi khác", false, function(on)
	if on then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				for _, v in pairs(p.Character:GetDescendants()) do
					if v:IsA("MeshPart") or v:IsA("Accessory") then
						v:Destroy()
					end
				end
			end
		end
	end
end)

CreateCheckbox(settingPage, "🍃 Xoá trái cây trong vườn người khác", false, function(on)
	if on then
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v:FindFirstChild("Fruit") and not v:IsDescendantOf(LocalPlayer) then
				v:Destroy()
			end
		end
	end
end)

CreateCheckbox(settingPage, "🌫️ Giảm tầm nhìn", false, function(on)
	if on and workspace:FindFirstChild("Terrain") then
		workspace.Terrain.FogEnd = 50
	end
end)

CreateCheckbox(settingPage, "💻 Đồ hoạ cực thấp", false, function(on)
	if on then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end
end)

CreateCheckbox(settingPage, "🎯 Giữ FPS ở mức 60", true, function(on)
	if on then setfpscap(60) end
end)-- 🎉 Tab Event Summer
local eventPage = Pages["Event Summer"]

local autoSummerToggle = CreateCheckbox(eventPage, "⚡ Auto làm sự kiện Summer", false)

local fruitList = {
	"Carrot", "Strawberry", "Blueberry", "Wild Carrot", "Pear", "Tomato", "Cauliflower",
	"Cantaloupe", "Watermelon", "Green Apple", "Avocado", "Banana", "Pineapple", "Kiwi",
	"Bell Pepper", "Prickly Pear", "Parasol Flower", "Rosy Delight", "Loquat", "Feijoa",
	"Sugar Apple", "Elephant Ears"
}

-- Tự động thu hoạch fruit từ YourFarmPlot
spawn(function()
	while task.wait(2) do
		if autoSummerToggle() then
			for _, plot in pairs(workspace:GetChildren()) do
				if plot.Name == "YourFarmPlot" then
					for _, v in pairs(plot:GetDescendants()) do
						if v:IsA("Model") and table.find(fruitList, v.Name) then
							firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
							firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
						end
					end
				end
			end
		end
	end
end)

-- Tự động nộp trái vào giỏ event
spawn(function()
	while task.wait(1) do
		if autoSummerToggle() then
			local basket = workspace:FindFirstChild("Basket")
			if basket and basket:FindFirstChild("ClickDetector") then
				fireclickdetector(basket.ClickDetector)
			end
		end
	end
end)-- 🐣 ESP Trứng + Tên Pet (hiển thị trên Egg)
local autoESP = CreateCheckbox(eventPage, "👁️ ESP Trứng & hiện tên pet sắp nở", true)
local eggCount, petCount = 0, 0

spawn(function()
	while task.wait(1) do
		if autoESP() then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("Model") and v.Name:lower():find("egg") and not v:FindFirstChild("BillboardGui") then
					local gui = Instance.new("BillboardGui", v)
					gui.Size = UDim2.new(0, 100, 0, 40)
					gui.AlwaysOnTop = true
					local label = Instance.new("TextLabel", gui)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.new(1, 0.5, 1)
					label.Font = Enum.Font.GothamBold
					label.TextScaled = true
					label.Text = "🐣 " .. (v.PetName and v.PetName.Value or "Egg")
				end
			end
		end
	end
end)

-- 🐾 Auto mở Pet sau khi trứng nở
local autoOpen = CreateCheckbox(eventPage, "🤖 Auto mở Pet sau khi nở", true)
spawn(function()
	while task.wait(2) do
		if autoOpen() then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("ClickDetector") and v.Parent and v.Parent.Name:lower():find("hatched") then
					fireclickdetector(v)
					eggCount += 1
				end
			end
		end
	end
end)

-- 📊 Thống kê số egg và pet
local statsLabel = Instance.new("TextLabel", eventPage)
statsLabel.Size = UDim2.new(1, -10, 0, 30)
statsLabel.TextColor3 = Color3.new(1,1,1)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextSize = 16
statsLabel.Text = "📦 Egg mở: 0 | 🐾 Pet nhận: 0"

-- Cập nhật liên tục
spawn(function()
	while task.wait(3) do
		statsLabel.Text = string.format("📦 Egg mở: %s | 🐾 Pet nhận: %s", eggCount, petCount)
	end
end)-- ℹ️ Tab Thông tin Script
local infoPage = Pages["Thông tin"]

-- Logo ảnh Discord
local logo = Instance.new("ImageLabel", infoPage)
logo.Size = UDim2.new(0, 80, 0, 80)
logo.BackgroundTransparency = 1
logo.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=7743878856&width=420&height=420&format=png"

local title = Instance.new("TextLabel", infoPage)
title.Size = UDim2.new(1, -10, 0, 28)
title.Text = "🌸 Script: ruilazy-esp"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local author = Instance.new("TextLabel", infoPage)
author.Size = UDim2.new(1, -10, 0, 24)
author.Text = "📣 Tác giả: @RuiLazy (Discord)"
author.TextColor3 = Color3.new(1, 1, 1)
author.BackgroundTransparency = 1
author.Font = Enum.Font.Gotham
author.TextSize = 16

local note = Instance.new("TextLabel", infoPage)
note.Size = UDim2.new(1, -10, 0, 60)
note.Text = "✨ Script đa năng dành riêng cho Grow a Garden\nESP, Auto Egg, Event, Giảm lag, Mở Pet, và hơn thế nữa!"
note.TextColor3 = Color3.new(1, 1, 1)
note.BackgroundTransparency = 1
note.Font = Enum.Font.Gotham
note.TextSize = 14
note.TextWrapped = true
note.TextYAlignment = Enum.TextYAlignment.Top
