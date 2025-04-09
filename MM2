-- Carica la libreria OrionLib 
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Crea la finestra con parametri avanzati e tema blu
local Window = OrionLib:MakeWindow({
    Name = "CipherX Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroEnabled = true,
    IntroText = "Welcome to CipherX Hub!",
    IntroIcon = "rbxassetid://6031098406",
    Icon = "rbxassetid://6031098406",
    CloseCallback = function()
        print("Window closed")
    end,
    Theme = {
        Main = Color3.fromRGB(0, 85, 255),
        Accent = Color3.fromRGB(0, 170, 255),
        Outline = Color3.fromRGB(0, 60, 130),
        FontColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(20, 20, 30),
        TabBackground = Color3.fromRGB(10, 10, 20)
    }
})

-------------------------------------------
-- TAB OP + LOGICA AUTO KILL + Aimbot
-------------------------------------------
local opTab = Window:MakeTab({
    Name = "OP",
    Icon = "rbxassetid://6031098406",
    PremiumOnly = false
})

local autoKillEnabled = false
local aimbotEnabled = false -- Variabile per attivare/disattivare l'aimbot
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")

local function EquipKnife()
    local char = game.Players.LocalPlayer.Character
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild("Knife") then
        local knife = backpack:FindFirstChild("Knife")
        knife.Parent = char
    end
end

local function ClickM1()
    virtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(0.1)
    virtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Loop Auto Kill: si attacca al bersaglio finché non è morto
task.spawn(function()
    while true do
        if autoKillEnabled then
            local localPlayer = game.Players.LocalPlayer
            local players = game:GetService("Players"):GetPlayers()
            for _, target in ipairs(players) do
                if target ~= localPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local char = localPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        EquipKnife()
                        -- Continua ad attaccare il target finché è vivo
                        while target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 do
                            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            wait(0.2)
                            ClickM1()
                            wait(0.8)
                        end
                    end
                end
            end
        end
        wait(1)
    end
end)

opTab:AddToggle({
    Name = "Auto Kill All",
    Default = false,
    Callback = function(value)
        autoKillEnabled = value
        if not autoKillEnabled then
            -- Assicurati che il clic M1 venga disattivato quando Auto Kill è disattivato
            OrionLib:MakeNotification({
                Name = "Auto Kill",
                Content = "Disattivato",
                Image = "rbxassetid://6031098406",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Auto Kill",
                Content = "Attivato",
                Image = "rbxassetid://6031098406",
                Time = 3
            })
        end
    end
})

-- Aimbot: usando RenderStepped per aggiornamenti continui
runService.RenderStepped:Connect(function(deltaTime)
    if aimbotEnabled then
        local localPlayer = game.Players.LocalPlayer
        local localChar = localPlayer.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") then
            local localPos = localChar.HumanoidRootPart.Position
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (plr.Character.HumanoidRootPart.Position - localPos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = plr
                    end
                end
            end
            
            if closestPlayer then
                local targetPos = closestPlayer.Character.HumanoidRootPart.Position
                local currentCF = localChar.HumanoidRootPart.CFrame
                local targetCF = CFrame.new(currentCF.Position, targetPos)
                local smoothFactor = 0.2
                local newCF = currentCF:Lerp(targetCF, smoothFactor)
                localChar.HumanoidRootPart.CFrame = newCF
            end
        end
    end
end)

opTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(value)
        aimbotEnabled = value
        OrionLib:MakeNotification({
            Name = "Aimbot",
            Content = value and "Aimbot Attivato" or "Aimbot Disattivato",
            Image = "rbxassetid://6031098406",
            Time = 3
        })
    end
})

-------------------------------------------
-- SISTEMA ESP
-------------------------------------------
local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "CipherX_ESP"

local function createESP(player, role)
    local tag = Instance.new("BillboardGui")
    tag.Name = "ESP_Tag"
    tag.Size = UDim2.new(0, 100, 0, 40)
    tag.Adornee = player.Character:WaitForChild("Head")
    tag.AlwaysOnTop = true

    local label = Instance.new("TextLabel", tag)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = role
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextColor3 = role == "Murder" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 170, 255)

    tag.Parent = espFolder
end

local function removeAllESP()
    for _, v in pairs(espFolder:GetChildren()) do
        v:Destroy()
    end
end

local function updateESP()
    removeAllESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local hasKnife = player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife")
            local hasGun = player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun")
            if player.Character:FindFirstChild("Knife") then hasKnife = true end
            if player.Character:FindFirstChild("Gun") then hasGun = true end

            if hasKnife then
                createESP(player, "Murder")
            elseif hasGun then
                createESP(player, "Sheriff")
            end
        end
    end
end

task.spawn(function()
    while true do
        if espEnabled then
            updateESP()
        else
            removeAllESP()
        end
        wait(2)
    end
end)

opTab:AddToggle({
    Name = "ESP Murder/Sheriff",
    Default = false,
    Callback = function(value)
        espEnabled = value
        OrionLib:MakeNotification({
            Name = "ESP",
            Content = value and "ESP Attivato" or "ESP Disattivato",
            Image = "rbxassetid://6031098406",
            Time = 3
        })
    end
})

-------------------------------------------
-- TAB PLAYER (Teleport) con aggiornamento automatico
-------------------------------------------
local playerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6031098406",
    PremiumOnly = false
})

local function TeleportToPlayer(playerName)
    local player = game:GetService("Players"):FindFirstChild(playerName)
    if player and player.Character then
        local localChar = game.Players.LocalPlayer.Character
        local targetChar = player.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
            localChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
        end
    else
        local playerList = game:GetService("Players"):GetPlayers()
        local playerNames = {}
        for _, p in pairs(playerList) do
            table.insert(playerNames, p.Name)
        end
        OrionLib:MakeNotification({
            Name = "Available Players",
            Content = "Current players: " .. table.concat(playerNames, ", "),
            Image = "rbxassetid://6031098406",
            Time = 5
        })
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "Player not found.",
            Image = "rbxassetid://6031098406",
            Time = 3
        })
    end
end

local function GetPlayerList()
    local playersList = {}
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        table.insert(playersList, player.Name)
    end
    return playersList
end

local selectedPlayerName = "CipherX"
local teleportDropdown

-- Creazione iniziale del dropdown
teleportDropdown = playerTab:AddDropdown({
    Name = "Seleziona Giocatore",
    Default = selectedPlayerName,
    Options = GetPlayerList(),
    Callback = function(value)
        selectedPlayerName = value
    end
})

playerTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        TeleportToPlayer(selectedPlayerName)
    end
})

-- Aggiornamento automatico del dropdown ogni 5 secondi
task.spawn(function()
    while true do
        wait(5)
        local updatedList = GetPlayerList()
        -- Se il dropdown supporta l'aggiornamento diretto, usalo
        if teleportDropdown and teleportDropdown.SetOptions then
            teleportDropdown:SetOptions(updatedList)
        else
            -- Se non supporta, ricrea il dropdown (questo cancella gli altri elementi nel tab!)
            playerTab:Clear()
            teleportDropdown = playerTab:AddDropdown({
                Name = "Seleziona Giocatore",
                Default = selectedPlayerName,
                Options = updatedList,
                Callback = function(value)
                    selectedPlayerName = value
                end
            })
            playerTab:AddButton({
                Name = "Teleport to Player",
                Callback = function()
                    TeleportToPlayer(selectedPlayerName)
                end
            })
        end
    end
end)
