local guiCode = [[
-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(240, 480)
frame.Position = UDim2.fromScale(0.05, 0.4)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Noahs Hack"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16












local function makeButton(text, y)
local b = Instance.new("TextButton", frame)
b.Size = UDim2.new(1, -20, 0, 36)
b.Position = UDim2.new(0, 10, 0, y)
b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
b.TextColor3 = Color3.new(1, 1, 1)
b.Font = Enum.Font.Gotham
b.TextSize = 14
b.Text = text
Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
return b
end

local function makeButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 36)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local godBtn = makeButton("🛡 Godmode: OFF", 45)
local flyBtn = makeButton("✈ Fly: OFF", 90)

--------------------------------------------------
-- GODMODE / STARTSCHILD
--------------------------------------------------
local godmode = false
local MAX_HEALTH = 1000

local function applyGodmode(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.MaxHealth = MAX_HEALTH
    humanoid.Health = MAX_HEALTH

    humanoid.HealthChanged:Connect(function()
        if godmode then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    if godmode then
        applyGodmode(char)
    end
end)

godBtn.MouseButton1Click:Connect(function()
    godmode = not godmode
    godBtn.Text = godmode and "🛡 Godmode: ON" or "🛡 Godmode: OFF"
    if godmode and player.Character then
        applyGodmode(player.Character)
    end
end)




--------------------------------------------------
-- FLY
--------------------------------------------------
local flying = false
local flyspeed = 150
local bv, bg
local flycontrol = {F=0, B=0, L=0, R=0, U=0, D=0}

local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    flying = true
    hum.PlatformStand = true

    bv = Instance.new("BodyVelocity", hrp)
    bg = Instance.new("BodyGyro", hrp)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

    RunService.RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        bv.Velocity =
            cam.CFrame.LookVector * ((flycontrol.F - flycontrol.B) * flyspeed) +
            cam.CFrame.RightVector * ((flycontrol.R - flycontrol.L) * flyspeed) +
            cam.CFrame.UpVector * ((flycontrol.U - flycontrol.D) * flyspeed)
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if player.Character then
        player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
    end
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "✈ Fly: OFF"
    else
        startFly()
        flyBtn.Text = "✈ Fly: ON"
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then flycontrol.F = 1 end
    if i.KeyCode == Enum.KeyCode.S then flycontrol.B = 1 end
    if i.KeyCode == Enum.KeyCode.A then flycontrol.L = 1 end
    if i.KeyCode == Enum.KeyCode.D then flycontrol.R = 1 end
    if i.KeyCode == Enum.KeyCode.Space then flycontrol.U = 1 end
    if i.KeyCode == Enum.KeyCode.LeftShift then flycontrol.D = 1 end
end)

UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.W then flycontrol.F = 0 end
    if i.KeyCode == Enum.KeyCode.S then flycontrol.B = 0 end
    if i.KeyCode == Enum.KeyCode.A then flycontrol.L = 0 end
    if i.KeyCode == Enum.KeyCode.D then flycontrol.R = 0 end
    if i.KeyCode == Enum.KeyCode.Space then flycontrol.U = 0 end
    if i.KeyCode == Enum.KeyCode.LeftShift then flycontrol.D = 0 end
end)

--------------------------------------------------
-- SPEED & FLY SPEED Eingabe
--------------------------------------------------
-- SPEED Label
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 100, 0, 24)
speedLabel.Position = UDim2.new(0, 10, 0, 135)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- SPEED TextBox
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 80, 0, 24)
speedBox.Position = UDim2.new(0, 110, 0, 135)
speedBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Text = "16"
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,6)

-- FLY SPEED Label
local flyLabel = Instance.new("TextLabel", frame)
flyLabel.Size = UDim2.new(0, 100, 0, 24)
flyLabel.Position = UDim2.new(0, 10, 0, 170)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "FlySpeed:"
flyLabel.TextColor3 = Color3.new(1,1,1)
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 14
flyLabel.TextXAlignment = Enum.TextXAlignment.Left

-- FLY SPEED TextBox
local flyBox = Instance.new("TextBox", frame)
flyBox.Size = UDim2.new(0, 80, 0, 24)
flyBox.Position = UDim2.new(0, 110, 0, 170)
flyBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
flyBox.TextColor3 = Color3.new(1,1,1)
flyBox.Font = Enum.Font.Gotham
flyBox.TextSize = 14
flyBox.Text = "150"
Instance.new("UICorner", flyBox).CornerRadius = UDim.new(0,6)

--------------------------------------------------
-- SPEED LOGIK
--------------------------------------------------
-- WalkSpeed Update
local function updateSpeed()
    local val = tonumber(speedBox.Text)
    if val and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end
speedBox.FocusLost:Connect(updateSpeed)

-- FlySpeed Update
local function updateFlySpeed()
    local val = tonumber(flyBox.Text)
    if val then flyspeed = val end
end
flyBox.FocusLost:Connect(updateFlySpeed)

-- Bei Respawn WalkSpeed erneut setzen
player.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    updateSpeed()
end)

--------------------------------------------------
-- MINIMIZE / RESTORE
--------------------------------------------------
local minimized = false


local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -28, 0, 4)
minBtn.Text = "✖"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)


local restoreBtn = Instance.new("TextButton", gui)
restoreBtn.Size = UDim2.fromOffset(150, 30)
restoreBtn.Position = frame.Position
restoreBtn.Text = "+ Noahs Hack"
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.TextSize = 14
restoreBtn.TextColor3 = Color3.new(1,1,1)
restoreBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
restoreBtn.Visible = false
Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(0,6)
restoreBtn.Active = true
restoreBtn.Draggable = true


minBtn.MouseButton1Click:Connect(function()
    minimized = true
    frame.Visible = false
    restoreBtn.Visible = true
    restoreBtn.Position = frame.Position
end)


restoreBtn.MouseButton1Click:Connect(function()
    minimized = false
    frame.Visible = true
    restoreBtn.Visible = false
end)










-- Give ALL Items Button
local giveItemsBtn = makeButton("🎁 Give ALL Items", 210)
local backpack = player:WaitForChild("Backpack")
local sources = {game:GetService("ReplicatedStorage"), game:GetService("StarterPack")}


local function hasTool(name)
return backpack:FindFirstChild(name) ~= nil
end


local function collectTools(parent)
for _, obj in ipairs(parent:GetChildren()) do
if obj:IsA("Tool") then
if not hasTool(obj.Name) then
obj:Clone().Parent = backpack
end
elseif obj:IsA("Folder") or obj:IsA("Model") then
collectTools(obj)
end
end
end


giveItemsBtn.MouseButton1Click:Connect(function()
local character = player.Character
if character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then humanoid:UnequipTools() end
end
for _, src in ipairs(sources) do
collectTools(src)
end
end)


-- TextBox zum Eingeben des Item-Namens
local spawnTextBox = Instance.new("TextBox", frame)
spawnTextBox.Size = UDim2.new(1, -20, 0, 28)
spawnTextBox.Position = UDim2.new(0, 10, 0, 290)
spawnTextBox.BackgroundColor3 = Color3.fromRGB(2, 25, 25)
spawnTextBox.TextColor3 = Color3.new(1, 1, 1)
spawnTextBox.Font = Enum.Font.Gotham
spawnTextBox.PlaceholderText = "Item Name hier eingeben..."
spawnTextBox.TextSize = 14
Instance.new("UICorner", spawnTextBox).CornerRadius = UDim.new(0, 8)

-- Button zum Spawnen
local spawnButton = makeButton("🚀 Spawn Item", 325)

-- Hilfsfunktion: findet ALLE Objekte nach Name (rekursiv)
local function findObjectByName(name, parent)
    for _, obj in ipairs(parent:GetChildren()) do
        if obj.Name:lower() == name:lower() then
            return obj
        elseif obj:IsA("Folder") or obj:IsA("Model") then
            local res = findObjectByName(name, obj)
            if res then return res end
        end
    end
    return nil
end

-- Hilfsfunktion: klont ein Objekt sicher für den Spieler
local function safeCloneToPlayer(obj, player)
    local backpack = player:WaitForChild("Backpack")
    local clone = obj:Clone()

    if clone:IsA("Tool") then
        clone.Parent = backpack
    elseif clone:IsA("BasePart") or clone:IsA("Model") then
        clone.Parent = workspace
        -- Safe Position über Spieler
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if clone:IsA("Model") and clone.PrimaryPart then
                clone:SetPrimaryPartCFrame(CFrame.new(hrp.Position + Vector3.new(0,5,0)))
            elseif clone:IsA("BasePart") then
                clone.CFrame = CFrame.new(hrp.Position + Vector3.new(0,5,0))
            end
        end
    else
        -- andere Objekte ins Workspace
        clone.Parent = workspace
    end
end

-- Event wenn Button gedrückt wird
spawnButton.MouseButton1Click:Connect(function()
    local itemName = spawnTextBox.Text
    if itemName == "" then return end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local obj = findObjectByName(itemName, ReplicatedStorage)

    if obj then
        safeCloneToPlayer(obj, game.Players.LocalPlayer)
        print(itemName .. " wurde sicher gespawnt!")
    else
        warn("Kein Objekt mit dem Namen '"..itemName.."' gefunden.")
    end
end)








-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ANGENOMMENER FRAME
-- frame existiert schon, Buttons werden darauf gelegt

-- Hilfsfunktion für Buttons
local function makeButton(text, posY, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- NEUER BUTTON unter Spawn Item
local runScriptButton = makeButton("📝 Run Tool Script", 365, frame)

runScriptButton.MouseButton1Click:Connect(function()
    -- QUELL-ORDNER
    local sources = {
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterPack")
    }

    -- Rekursive Funktion um alle Tool-Namen zu sammeln
    local function collectToolNames(parent, list)
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("Tool") then
                table.insert(list, obj.Name)
            elseif obj:IsA("Folder") or obj:IsA("Model") then
                collectToolNames(obj, list)
            end
        end
    end

    -- ALLE TOOLS sammeln
    local allTools = {}
    for _, src in ipairs(sources) do
        collectToolNames(src, allTools)
    end

     -- GUI FENSTER ERSTELLEN (korrigiert)
     local toolGui = Instance.new("Frame")
     toolGui.Name = "ToolWindow"
     toolGui.Size = UDim2.new(0, 300, 0, 400)
     toolGui.AnchorPoint = Vector2.new(0.5, 0.5)         -- Mittelpunkt als Referenz
     toolGui.Position = UDim2.new(0.5, 0, 0.5, 0)        -- exakt in der Bildschirmmitte
     toolGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
     toolGui.BorderSizePixel = 0
     toolGui.Active = true
     toolGui.Draggable = true
     toolGui.Parent = gui                                 -- WICHTIG: parent muss die ScreenGui (variable 'gui') sein


    -- UICorner für runde Ecken
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toolGui

    -- TITLE BAR
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Text = "Alle Tools"
    title.Parent = toolGui

    -- CLOSE BUTTON
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Text = "X"
    closeBtn.Parent = toolGui
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function()
        toolGui:Destroy()
    end)

    -- SCROLLFRAME für Tool-Namen
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.new(0, 10, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = toolGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll

    -- Tools hinzufügen als Buttons, um sie ins Inventar zu bekommen
for i, name in ipairs(allTools) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    -- Funktion beim Klicken
    btn.MouseButton1Click:Connect(function()
        -- Suche das Tool im ReplicatedStorage und StarterPack
        local tool
        for _, src in ipairs({game:GetService("ReplicatedStorage"), game:GetService("StarterPack")}) do
            local found = src:FindFirstChild(name, true) -- true = rekursiv suchen
            if found and found:IsA("Tool") then
                tool = found:Clone()
                break
            end
        end

        if tool then
            tool.Parent = player:WaitForChild("Backpack")
            print(name .. " wurde ins Inventar gelegt!")
        else
            warn("Tool '"..name.."' nicht gefunden!")
        end
    end)
end


    -- Canvas anpassen
    RunService.RenderStepped:Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    -- OPTIONAL: draggable
    toolGui.Active = true
    toolGui.Draggable = true
end) 








-- MOUSE UNLOCK MIT V
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        -- Maus wieder normal freigeben
        local cam = workspace.CurrentCamera
        cam.CameraType = Enum.CameraType.Custom
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        print("Maus entsperrt!")
    end
end)










-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- BUTTON
local espButton = Instance.new("TextButton")
espButton.Parent = frame -- frame = dein bestehendes GUI-Frame
espButton.Size = UDim2.new(1, -20, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 252)
espButton.Text = "ESP+Hitbox: AUS"
espButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
espButton.TextColor3 = Color3.fromRGB(255,255,255)
espButton.BorderSizePixel = 0

local espEnabled = false
local highlights = {}
local hitboxes = {}

-- ESP + HITBOX FUNKTION
local function addESP(plr)
	if plr == player then return end

	local function apply(char)
		if highlights[plr] then return end

		-- Highlight (Leuchten durch Wände)
		local h = Instance.new("Highlight")
		h.FillColor = Color3.fromRGB(255, 0, 0)
		h.OutlineColor = Color3.fromRGB(255, 255, 255)
		h.FillTransparency = 0.5
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Adornee = char
		h.Parent = char
		highlights[plr] = h

		-- Hitbox (BoxHandleAdornment)
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local box = Instance.new("BoxHandleAdornment")
			box.Size = root.Size + Vector3.new(0,3,0) -- etwas größer
			box.Adornee = root
			box.Transparency = 0.5
			box.Color3 = Color3.fromRGB(0,255,0)
			box.AlwaysOnTop = true
			box.ZIndex = 5
			box.Parent = root
			hitboxes[plr] = box
		end
	end

	if plr.Character then
		apply(plr.Character)
	end

	plr.CharacterAdded:Connect(function(char)
		if espEnabled then
			task.wait(0.2)
			apply(char)
		end
	end)
end

local function removeESP()
	for _, h in pairs(highlights) do
		if h then h:Destroy() end
	end
	for _, b in pairs(hitboxes) do
		if b then b:Destroy() end
	end
	highlights = {}
	hitboxes = {}
end

-- BUTTON CLICK
espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espButton.Text = espEnabled and "ESP+Hitbox: AN" or "ESP+Hitbox: AUS"

	if espEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			addESP(plr)
		end
	else
		removeESP()
	end
end)

-- NEUE SPIELER
Players.PlayerAdded:Connect(function(plr)
	if espEnabled then
		addESP(plr)
	end
end)



-- KEIN FALLSCHADEN BUTTON
local noFallButton = makeButton("🪂 Kein Fallschaden: AUS", 400, frame)
local noFallEnabled = false

noFallButton.MouseButton1Click:Connect(function()
    noFallEnabled = not noFallEnabled
    noFallButton.Text = noFallEnabled and "🪂 Kein Fallschaden: AN" or "🪂 Kein Fallschaden: AUS"
end)

-- Fallschaden verhindern
game:GetService("RunService").Stepped:Connect(function()
    if noFallEnabled and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Fallschaden verhindern, indem wir die Humanoid-Velocity beim Fallen abfangen
            if hum.FloorMaterial == Enum.Material.Air and hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                hum.Health = hum.MaxHealth
            end
        end
    end
end)





-- ===== AIMBOT (FINAL FIX – INPUT SAFE) =====

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

-- BUTTON
local aimbotBtn = makeButton("🎯 Aimbot: AUS", 440, frame)

-- STATE
local aimbotEnabled = false
local aiming = false

-- SETTINGS
local FOV_RADIUS = 180
local SMOOTHNESS = 0.15

--------------------------------------------------
-- CROSSHAIR (INPUT TRANSPARENT)
--------------------------------------------------
local crosshair = Instance.new("Frame")
crosshair.Parent = gui
crosshair.Size = UDim2.fromOffset(6,6)
crosshair.Position = UDim2.fromScale(0.5,0.5)
crosshair.AnchorPoint = Vector2.new(0.5,0.5)
crosshair.BackgroundColor3 = Color3.fromRGB(255,0,0)
crosshair.BorderSizePixel = 0
crosshair.Visible = false
crosshair.Active = false
crosshair.Selectable = false
Instance.new("UICorner", crosshair).CornerRadius = UDim.new(1,0)

--------------------------------------------------
-- FOV (INPUT TRANSPARENT)
--------------------------------------------------
local fov = Instance.new("Frame")
fov.Parent = gui
fov.Size = UDim2.fromOffset(FOV_RADIUS*2, FOV_RADIUS*2)
fov.Position = UDim2.fromScale(0.5,0.5)
fov.AnchorPoint = Vector2.new(0.5,0.5)
fov.BackgroundTransparency = 1
fov.BorderSizePixel = 0
fov.Visible = false
fov.Active = false
fov.Selectable = false

local stroke = Instance.new("UIStroke", fov)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255,255,255)
Instance.new("UICorner", fov).CornerRadius = UDim.new(1,0)

--------------------------------------------------
-- TARGET FINDEN
--------------------------------------------------
local function getClosestTarget()
    local closest = nil
    local shortest = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player
        and plr.Character
        and plr.Character:FindFirstChild("Head")
        and plr.Team ~= player.Team then

            local head = plr.Character.Head
            local pos, visible = Camera:WorldToViewportPoint(head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < FOV_RADIUS and dist < shortest then
                    shortest = dist
                    closest = head
                end
            end
        end
    end

    return closest
end

--------------------------------------------------
-- BUTTON TOGGLE
--------------------------------------------------
aimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled

    if aimbotEnabled then
        aimbotBtn.Text = "🎯 Aimbot: AN"
        crosshair.Visible = true
        fov.Visible = true
    else
        aimbotBtn.Text = "🎯 Aimbot: AUS"
        crosshair.Visible = false
        fov.Visible = false
        aiming = false
    end
end)

--------------------------------------------------
-- HOLD TO AIM (IGNORIERT gpe!)
--------------------------------------------------
UIS.InputBegan:Connect(function(input)
    if not aimbotEnabled then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.MouseButton2
    or input.UserInputType == Enum.UserInputType.MouseButton3 then
        aiming = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.MouseButton2
    or input.UserInputType == Enum.UserInputType.MouseButton3 then
        aiming = false
    end
end)

--------------------------------------------------
-- AIM LOOP
--------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not aimbotEnabled or not aiming then return end

    local target = getClosestTarget()
    if target then
        local camPos = Camera.CFrame.Position
        local aimCF = CFrame.new(camPos, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(aimCF, SMOOTHNESS)
    end
end)

-- ===== END AIMBOT =====




]]

local func = loadstring(guiCode)
func()