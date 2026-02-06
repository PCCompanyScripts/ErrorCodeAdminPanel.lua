local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local adminFolder = game:GetService("ReplicatedStorage"):FindFirstChild("AdminPanelEvents")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if not adminFolder then
    warn("A pasta AdminPanelEvents não foi encontrada!")
    return
end

-----------------------------------------------------------
-- SCRIPT DE LIBERAR MOUSE (TECLA U) - INTEGRADO
-----------------------------------------------------------
local liberado = false

RunService.Heartbeat:Connect(function()
    if liberado then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
        
        if player.CameraMode == Enum.CameraMode.LockFirstPerson then
            player.CameraMode = Enum.CameraMode.Classic
        end
    end
end)

UIS.InputBegan:Connect(function(input, chat)
    if chat then return end 
    if input.KeyCode == Enum.KeyCode.U then
        liberado = not liberado
        if liberado then
            print("--- MOUSE SOLTO ---")
        else
            player.CameraMode = Enum.CameraMode.LockFirstPerson
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
            print("--- MOUSE PRESO ---")
        end
    end
end)

-----------------------------------------------------------
-- SISTEMA DE INTERFACE (ADMIN PANEL)
-----------------------------------------------------------

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ErrorAdminSystem"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- JANELA PRINCIPAL
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 420)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(45, 45, 50)

-- Barra de Título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Text = "Admin Panel [⚠️] ERROR CODE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

makeDraggable(mainFrame, titleBar)

-- JANELA DE KICK
local kickFrame = Instance.new("Frame")
kickFrame.Size = UDim2.new(0, 250, 0, 150)
kickFrame.Position = UDim2.new(0.5, 200, 0.5, -75)
kickFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
kickFrame.Visible = false
kickFrame.Parent = screenGui

Instance.new("UICorner", kickFrame).CornerRadius = UDim.new(0, 10)
local kStroke = Instance.new("UIStroke", kickFrame)
kStroke.Color = Color3.fromRGB(255, 60, 60)
kStroke.Thickness = 2

local kickTitle = Instance.new("Frame")
kickTitle.Size = UDim2.new(1, 0, 0, 35)
kickTitle.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
kickTitle.Parent = kickFrame
Instance.new("UICorner", kickTitle)

local kickLabel = Instance.new("TextLabel")
kickLabel.Size = UDim2.new(1, 0, 1, 0)
kickLabel.Text = "PLAYER KICKER"
kickLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
kickLabel.Font = Enum.Font.GothamBold
kickLabel.BackgroundTransparency = 1
kickLabel.Parent = kickTitle

makeDraggable(kickFrame, kickTitle)

local kickInput = Instance.new("TextBox")
kickInput.Size = UDim2.new(0.9, 0, 0, 35)
kickInput.Position = UDim2.new(0.05, 0, 0.35, 0)
kickInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
kickInput.PlaceholderText = "Target Username..."
kickInput.Text = ""
kickInput.TextColor3 = Color3.new(1, 1, 1)
kickInput.Font = Enum.Font.Gotham
kickInput.Parent = kickFrame
Instance.new("UICorner", kickInput)

local kickConfirm = Instance.new("TextButton")
kickConfirm.Size = UDim2.new(0.9, 0, 0, 35)
kickConfirm.Position = UDim2.new(0.05, 0, 0.7, 0)
kickConfirm.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
kickConfirm.Text = "KICK PLAYER"
kickConfirm.TextColor3 = Color3.new(1, 1, 1)
kickConfirm.Font = Enum.Font.GothamBold
kickConfirm.Parent = kickFrame
Instance.new("UICorner", kickConfirm)

-- Botões de Controle
local function createBtn(txt, color, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = UDim2.new(1, x, 0, 7)
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = titleBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    return b
end

local close = createBtn("×", Color3.fromRGB(255, 60, 60), -35)
local min = createBtn("-", Color3.fromRGB(40, 40, 45), -70)

-- Scrolling Lista
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 55)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 2
scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 8)

-- Gerar Botões
for _, v in pairs(adminFolder:GetChildren()) do
    if v:IsA("RemoteEvent") then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        btn.Text = "    " .. v.Name
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.GothamMedium
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = scroll
        Instance.new("UICorner", btn)
        Instance.new("UIStroke", btn).Color = Color3.fromRGB(40, 40, 45)

        btn.MouseButton1Click:Connect(function()
            if v.Name == "KickPlayer" then
                kickFrame.Visible = not kickFrame.Visible
            else
                v:FireServer()
            end
        end)
    end
end

close.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local isMin = false
min.MouseButton1Click:Connect(function()
    isMin = not isMin
    scroll.Visible = not isMin
    mainFrame:TweenSize(isMin and UDim2.new(0, 380, 0, 45) or UDim2.new(0, 380, 0, 420), "Out", "Back", 0.3, true)
end)

kickConfirm.MouseButton1Click:Connect(function()
    local target = kickInput.Text
    local ev = adminFolder:FindFirstChild("KickPlayer")
    if ev and target ~= "" then
        ev:FireServer(target)
        kickFrame.Visible = false
        kickInput.Text = ""
    end
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)
