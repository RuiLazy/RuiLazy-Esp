-- ruilazy-esp main.lua
-- Script Grow a Garden ESP + Auto Egg + Auto Open + Thống kê
-- Tương thích KRNL / Delta / Codex / Hydrogen

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Config màu hồng
local ColorBackground = Color3.fromRGB(255, 192, 203) -- hồng nhạt
local ColorButton = Color3.fromRGB(255, 105, 180) -- hồng đậm
local ColorText = Color3.fromRGB(255, 255, 255) -- trắng

-- Thống kê
local eggCount = 0
local petCount = 0

-- GUI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RuiLazyESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Khởi tạo menu
local menuFrame = Instance.new("Frame")
menuFrame.Name = "Menu"
menuFrame.Size = UDim2.new(0, 240, 0, 280)
menuFrame.Position = UDim2.new(0, 10, 0, 100)
menuFrame.BackgroundColor3 = ColorBackground
menuFrame.BorderSizePixel = 0
menuFrame.Parent = ScreenGui
menuFrame.Active = true
menuFrame.Draggable = true

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "RuiLazy-ESP MENU"
title.TextColor3 = ColorText
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = menuFrame

-- Tạo nút toggle chung
local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = menuFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = ColorText
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, -10, 0.7, 0)
    button.Position = UDim2.new(0.7, 5, 0.15, 0)
    button.BackgroundColor3 = ColorButton
    button.TextColor3 = ColorText
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Text = default and "ON" or "OFF"
    button.Parent = frame

    local toggled = default
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.Text = toggled and "ON" or "OFF"
        callback(toggled)
    end)

    return toggled, button
end

-- Biến trạng thái
local espEggEnabled = true
local autoEggEnabled = true
local autoOpenEnabled = true
local espPetEnabled = true

-- Nút bật/tắt
local toggles = {}

local function updateStats()
    statsLabel.Text = ("🥚 Egg: %d  |  🐾 Pet: %d"):format(eggCount, petCount)
end

-- Tạo label thống kê
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -20, 0, 30)
statsLabel.Position = UDim2.new(0, 10, 1, -35)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = ColorText
statsLabel.Font = Enum.Font.SourceSansBold
statsLabel.TextSize = 16
statsLabel.Text = "🥚 Egg: 0  |  🐾 Pet: 0"
statsLabel.Parent = menuFrame

-- Tạo các nút toggle với callback update trạng thái
toggles.espEgg = createToggle("ESP Egg", espEggEnabled, function(state)
    espEggEnabled = state
end)

toggles.autoEgg = createToggle("Auto Egg", autoEggEnabled, function(state)
    autoEggEnabled = state
end)

toggles.autoOpen = createToggle("Auto Open", autoOpenEnabled, function(state)
    autoOpenEnabled = state
end)

toggles.espPet = createToggle("ESP Pet", espPetEnabled, function(state)
    espPetEnabled = state
end)

-- Nút ẩn/hiện menu
local toggleMenuButton = Instance.new("TextButton")
toggleMenuButton.Size = UDim2.new(0, 80, 0, 30)
toggleMenuButton.Position = UDim2.new(1, -85, 1, -35)
toggleMenuButton.BackgroundColor3 = ColorButton
toggleMenuButton.TextColor3 = ColorText
toggleMenuButton.Font = Enum.Font.SourceSansBold
toggleMenuButton.TextSize = 16
toggleMenuButton.Text = "Ẩn Menu"
toggleMenuButton.Parent = ScreenGui

local menuVisible = true
toggleMenuButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    menuFrame.Visible = menuVisible
    toggleMenuButton.Text = menuVisible and "Ẩn Menu" or "Hiện Menu"
end)

-- ESP bằng BillboardGui cho Egg và Pet
local espContainers = {}

local function createBillboardGui(parent, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = parent
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.6
    label.BackgroundColor3 = color
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.Text = text
    label.Parent = billboard

    return billboard, label
end

-- Quét egg hiện có trong workspace
local function getEggs()
    local eggs = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("egg") and obj:IsA("Model") then
            table.insert(eggs, obj)
        end
    end
    return eggs
end

-- Quét pet của người chơi
local function getPets()
    local pets = {}
    local char = LocalPlayer.Character
    if not char then return pets end
    for _, obj in pairs(char:GetChildren()) do
        if obj.Name:lower():find("pet") and obj:IsA("Model") then
            table.insert(pets, obj)
        end
    end
    return pets
end

-- Tự động nhặt egg
local function autoCollectEggs()
    if not autoEggEnabled then return end
    local eggs = getEggs()
    for _, egg in pairs(eggs) do
        if egg.PrimaryPart and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
            local dist = (egg.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < 50 then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, egg.PrimaryPart, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, egg.PrimaryPart, 1)
                eggCount = eggCount + 1
                updateStats()
            end
        end
    end
end

-- Tự động mở pet sau khi trứng nở
local function autoOpenPet()
    if not autoOpenEnabled then return end
    -- Giả lập click nút mở pet trong GUI game
    local petGui = LocalPlayer.PlayerGui:FindFirstChild("PetGui")
    if petGui then
        local openButton = petGui:FindFirstChild("OpenButton") or petGui:FindFirstChildWhichIsA("TextButton")
        if openButton and openButton.Visible then
            openButton.MouseButton1Click:Fire()
            petCount = petCount + 1
            updateStats()
        end
    end
end

-- Xoá hết BillboardGui cũ
local function clearESP()
    for part, gui in pairs(espContainers) do
        if gui and gui.Parent then
            gui:Destroy()
        end
    end
    espContainers = {}
end

-- Cập nhật ESP BillboardGui cho eggs và pets
local function updateESP()
    if espEggEnabled then
        for _, egg in pairs(getEggs()) do
            if egg.PrimaryPart and not espContainers[egg.PrimaryPart] then
                local billboard = createBillboardGui(egg.PrimaryPart, "Egg", Color3.fromRGB(255, 182, 193))
                espContainers[egg.PrimaryPart] = billboard
            end
        end
    end
    if espPetEnabled then
        for _, pet in pairs(getPets()) do
            if pet.PrimaryPart and not espContainers[pet.PrimaryPart] then
                local billboard = createBillboardGui(pet.PrimaryPart, "Pet", Color3.fromRGB(255, 105, 180))
                espContainers[pet.PrimaryPart] = billboard
            end
        end
    end
    if not espEggEnabled and not espPetEnabled then
        clearESP()
    end
end

-- Main loop
RunService.Heartbeat:Connect(function()
    if menuVisible then
        updateESP()
    else
        clearESP()
    end
    autoCollectEggs()
    autoOpenPet()
end)

-- Tab thông tin
local infoButton = Instance.new("TextButton")
infoButton.Size = UDim2.new(1, -20, 0, 30)
infoButton.Position = UDim2.new(0, 10, 0, 230)
infoButton.BackgroundColor3 = ColorButton
infoButton.TextColor3 = ColorText
infoButton.Font = Enum.Font.SourceSansBold
infoButton.TextSize = 18
infoButton.Text = "Thông tin script"
infoButton.Parent = menuFrame

infoButton.MouseButton1Click:Connect(function()
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(0, 220, 0, 100)
    infoFrame.Position = UDim2.new(0, 10, 0, 30)
    infoFrame.BackgroundColor3 = ColorBackground
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = menuFrame

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -10, 1, -10)
    infoLabel.Position = UDim2.new(0, 5, 0, 5)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = ColorText
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 16
    infoLabel.Text = "Script: ruilazy-esp\nDiscord: @RuiLazy"
    infoLabel.TextWrapped = true
    infoLabel.Parent = infoFrame

    -- Ẩn info khi click infoFrame
    infoFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            infoFrame:Destroy()
        end
    end)
end)

-- Script đã sẵn sàng
print("[RuiLazy-ESP] Script loaded. Enjoy!")
