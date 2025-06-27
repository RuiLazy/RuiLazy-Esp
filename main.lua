local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local eggCount, petCount = 0, 0

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "RuiLazyESP"
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
toggleBtn.Text = "+"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 24
toggleBtn.ZIndex = 10
toggleBtn.AutoButtonColor = true
toggleBtn.BorderSizePixel = 0
toggleBtn.TextStrokeTransparency = 0.5
toggleBtn.TextScaled = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 70, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.ZIndex = 10

local function createButton(text, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.ZIndex = 11
	btn.MouseButton1Click:Connect(callback)
end

local function notify(text)
	pcall(function()
		game.StarterGui:SetCore("SendNotification", {
			Title = "RuiLazy-ESP",
			Text = tostring(text),
			Duration = 3
		})
	end)
end

local visible = false
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    frame.Visible = visible
end)
local function highlightEggs()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("BasePart") and egg.Name:lower():find("egg") and not egg:FindFirstChild("RuiESP") then
            local tag = Instance.new("BillboardGui", egg)
            tag.Name = "RuiESP"
            tag.Size = UDim2.new(0, 100, 0, 40)
            tag.AlwaysOnTop = true

            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = "🥚 EGG"
            label.TextColor3 = Color3.new(1, 1, 1)
            label.BackgroundTransparency = 1
            label.TextScaled = true
        end
    end
end

local function highlightPets()
    for _, pet in ipairs(workspace:GetDescendants()) do
        if pet:IsA("BasePart") and pet.Name:lower():find("pet") and not pet:FindFirstChild("RuiESP") then
            local tag = Instance.new("BillboardGui", pet)
            tag.Name = "RuiESP"
            tag.Size = UDim2.new(0, 100, 0, 40)
            tag.AlwaysOnTop = true

            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = "🐾 PET"
            label.TextColor3 = Color3.fromRGB(255, 255, 0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
        end
    end
end

local function autoCollectEggs()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("BasePart") and egg.Name:lower():find("egg") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = egg.CFrame + Vector3.new(0, 2, 0)
                firetouchinterest(hrp, egg, 0)
                firetouchinterest(hrp, egg, 1)
                eggCount += 1
                task.wait(0.1)
            end
        end
    end
end

local function autoOpenPet()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name:lower():find("open") then
            fireproximityprompt(v)
            petCount += 1
            task.wait(0.5)
        end
    end
end

local function trackPetAfterEgg()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg:FindFirstChild("Countdown") and egg:FindFirstChild("PetName") then
            local countdown = egg.Countdown
            countdown:GetPropertyChangedSignal("Text"):Connect(function()
                if tonumber(countdown.Text) == 0 then
                    notify("🐾 Sắp nở ra: " .. (egg:FindFirstChild("PetName").Value or "???"))
                end
            end)
        end
    end
end

createButton("🔲 ESP Pet & Egg", 10, function()
    highlightEggs()
    highlightPets()
    notify("✅ Hiển thị Egg và Pet")
end)

createButton("🔲 Auto nhặt trứng", 50, function()
    RunService.Heartbeat:Connect(autoCollectEggs)
    notify("✅ Đang tự động nhặt trứng")
end)

createButton("🔲 Auto mở pet", 90, function()
    RunService.Heartbeat:Connect(autoOpenPet)
    notify("✅ Đang tự động mở pet")
end)

createButton("🔲 Hiện tên pet khi nở", 130, function()
    trackPetAfterEgg()
    notify("✅ Bật theo dõi trứng nở")
end)

local stats = Instance.new("TextLabel", frame)
stats.Size = UDim2.new(1, -20, 0, 30)
stats.Position = UDim2.new(0, 10, 0, 230)
stats.BackgroundTransparency = 1
stats.TextColor3 = Color3.new(1, 1, 1)
stats.Text = "🥚 Egg: 0 | 🐾 Pet: 0"
stats.TextScaled = true

RunService.Heartbeat:Connect(function()
    stats.Text = "🥚 Egg: " .. tostring(eggCount) .. " | 🐾 Pet: " .. tostring(petCount)
end)local function isSummerFruit(name)
    local fruits = {
        ["Carrot"] = true, ["Strawberry"] = true, ["Blueberry"] = true, ["Wild Carrot"] = true,
        ["Pear"] = true, ["Tomato"] = true, ["Cauliflower"] = true, ["Cantaloupe"] = true,
        ["Watermelon"] = true, ["Green Apple"] = true, ["Avocado"] = true, ["Banana"] = true,
        ["Pineapple"] = true, ["Kiwi"] = true, ["Bell Pepper"] = true, ["Prickly Pear"] = true,
        ["Parasol Flower"] = true, ["Rosy Delight"] = true, ["Loquat"] = true, ["Feijoa"] = true,
        ["Sugar Apple"] = true, ["Elephant Ears"] = true
    }
    return fruits[name] or false
end

local function autoFarmSummer()
    while _G.AutoSummer do
        for _, fruit in ipairs(workspace.YourFarmPlot:GetDescendants()) do
            if fruit:IsA("BasePart") and isSummerFruit(fruit.Name) then
                pcall(function()
                    local hrp = Players.LocalPlayer.Character.HumanoidRootPart
                    hrp.CFrame = fruit.CFrame + Vector3.new(0, 3, 0)
                    firetouchinterest(hrp, fruit, 0)
                    firetouchinterest(hrp, fruit, 1)
                    task.wait(0.1)
                end)
            end
        end
        task.wait(1)
    end
end

local function autoSubmitToBasket()
    local time = os.date("*t")
    if time.min == 0 and time.sec < 600 then
        local basket = workspace:FindFirstChild("HarvestBasket") or workspace:FindFirstChild("Basket")
        if basket then
            pcall(function()
                local hrp = Players.LocalPlayer.Character.HumanoidRootPart
                hrp.CFrame = basket.CFrame + Vector3.new(0, 3, 0)
                task.wait(1)
            end)
        end
    end
end

spawn(function()
    while true do
        if _G.AutoSummer then
            autoFarmSummer()
            task.wait(1)
            autoSubmitToBasket()
        end
        task.wait(3)
    end
end)

_G.SafeTeleport = true

function safeTp(pos)
    local hrp = Players.LocalPlayer.Character.HumanoidRootPart
    if _G.SafeTeleport then
        for i = 1, 10 do
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(pos), 0.2)
            task.wait(0.05)
        end
    else
        hrp.CFrame = CFrame.new(pos)
    end
end

function fixLag()
    Lighting:ClearAllChildren()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character then
            v.Character:Destroy()
        end
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Fruit" and not obj:IsDescendantOf(workspace.YourFarmPlot) then
            obj:Destroy()
        end
    end
    if setfpscap then setfpscap(60) end
end

_G.AutoSummer = false

createButton("🔲 Auto Summer Event", 10, function()
    _G.AutoSummer = not _G.AutoSummer
    notify(_G.AutoSummer and "✅ Auto Summer ON" or "🔲 Auto Summer OFF")
end)

createButton("🔲 Safe Teleport", 50, function()
    _G.SafeTeleport = not _G.SafeTeleport
    notify(_G.SafeTeleport and "✅ Safe Teleport ON" or "🔲 Safe Teleport OFF")
end)

createButton("✅ Giảm Lag", 90, function()
    fixLag()
    notify("Đã giảm lag!")
end)
