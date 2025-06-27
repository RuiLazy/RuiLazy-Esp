-- ruilazy-esp main.lua -- Grow a Garden ESP + Auto Egg + Auto Open + Thống kê + Hiện tên pet sau khi trứng nở -- Tương thích KRNL / Delta / Codex / Hydrogen

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local LocalPlayer = Players.LocalPlayer local Workspace = game:GetService("Workspace")

local eggCount, petCount = 0, 0 local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "RuiLazyESP"

-- Nút tròn ẩn/hiện menu local toggleBtn = Instance.new("TextButton", gui) toggleBtn.Size = UDim2.new(0, 50, 0, 50) toggleBtn.Position = UDim2.new(0, 10, 0, 10) toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) toggleBtn.Text = "+" toggleBtn.TextColor3 = Color3.new(1, 1, 1) toggleBtn.Font = Enum.Font.SourceSansBold toggleBtn.TextSize = 24 toggleBtn.ZIndex = 10

toggleBtn.AutoButtonColor = true toggleBtn.BorderSizePixel = 0

toggleBtn.TextStrokeTransparency = 0.5 toggleBtn.TextScaled = true

-- Menu local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 220, 0, 220) frame.Position = UDim2.new(0, 70, 0, 10) frame.BackgroundColor3 = Color3.fromRGB(255, 192, 203) frame.Active, frame.Draggable = true frame.Visible = false

local function createButton(text, y, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -20, 0, 30) btn.Position = UDim2.new(0, 10, 0, y) btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.SourceSansBold btn.TextSize = 16 btn.MouseButton1Click:Connect(callback) end

local function notify(text) game.StarterGui:SetCore("SendNotification", { Title = "RuiLazy-ESP", Text = text, Duration = 3 }) end

local function autoCollectEggs() for _, obj in ipairs(Workspace:GetChildren()) do if obj.Name:lower():find("egg") and obj:IsA("Model") and obj:FindFirstChild("TouchInterest") then firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0) firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1) eggCount += 1 end end end

local function autoOpenPet() local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui") if gui then for _, obj in ipairs(gui:GetDescendants()) do if obj:IsA("TextButton") and obj.Text:lower():find("open") then obj:FireMouseButton1Click() petCount += 1 end end end end

local function createESP() for _, obj in ipairs(Workspace:GetChildren()) do if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("pet")) then if not obj:FindFirstChild("RuiESP") and obj:FindFirstChild("PrimaryPart") then local gui = Instance.new("BillboardGui", obj) gui.Name = "RuiESP" gui.Size = UDim2.new(0, 100, 0, 20) gui.AlwaysOnTop = true gui.Adornee = obj.PrimaryPart local label = Instance.new("TextLabel", gui) label.Size = UDim2.new(1, 0, 1, 0) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.Text = obj.Name label.TextScaled = true end end end end

local lastPets = {} local function trackPetAfterEgg() local eggList = {} for _, e in pairs(Workspace:GetChildren()) do if e.Name:lower():find("egg") and e:IsA("Model") and e:FindFirstChild("PrimaryPart") then eggList[e] = e.PrimaryPart.Position end end task.wait(1.5) for _, p in pairs(Workspace:GetChildren()) do if p:IsA("Model") and not lastPets[p] and p:FindFirstChild("HumanoidRootPart") and p:FindFirstChildWhichIsA("Humanoid") then local pos = p.HumanoidRootPart.Position for egg, oldPos in pairs(eggList) do if (pos - oldPos).Magnitude < 10 then local gui = Instance.new("BillboardGui", p) gui.Name = "PetNameESP" gui.Size = UDim2.new(0, 100, 0, 20) gui.Adornee = p.HumanoidRootPart gui.AlwaysOnTop = true local label = Instance.new("TextLabel", gui) label.Size = UDim2.new(1, 0, 1, 0) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.Text = p.Name label.TextScaled = true lastPets[p] = true break end end end end end

createButton("ESP", 10, function() createESP() notify("ESP Enabled") end)

createButton("Auto Egg", 50, function() RunService.Heartbeat:Connect(autoCollectEggs) notify("Auto Collect Started") end)

createButton("Auto Open", 90, function() RunService.Heartbeat:Connect(autoOpenPet) notify("Auto Open Started") end)

createButton("Hiện pet sau khi nở", 130, function() RunService.Heartbeat:Connect(trackPetAfterEgg) notify("Theo dõi pet sau khi trứng nở") end)

createButton("Thông tin script", 170, function() notify("🛠 Script: RuiLazy-ESP 📬 Discord: @RuiLazy") end)

local stats = Instance.new("TextLabel", frame) stats.Size = UDim2.new(1, -20, 0, 30) stats.Position = UDim2.new(0, 10, 0, 190) stats.BackgroundTransparency = 1 stats.TextColor3 = Color3.new(1, 1, 1) stats.Text = "🥚 Egg: 0 | 🐾 Pet: 0" stats.TextScaled = true

RunService.Heartbeat:Connect(function() stats.Text = "🥚 Egg: "..eggCount.." | 🐾 Pet: "..petCount end)

-- Toggle hiện/ẩn menu local visible = false toggleBtn.MouseButton1Click:Connect(function() visible = not visible frame.Visible = visible toggleBtn.Text = ""

local icon = Instance.new("ImageLabel", toggleBtn) icon.Size = UDim2.new(1, 0, 1, 0) icon.BackgroundTransparency = 1 icon.Image = "rbxassetid://16783449232" -- Icon mô phỏng logo RuiLazy (trứng hồng anime style) icon.ZIndex = 11 end)

print("[RuiLazy-ESP] Loaded")

