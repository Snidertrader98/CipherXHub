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
-- TAB OP + LOGICA AUTO KILL
-------------------------------------------
local opTab = Window:MakeTab({
    Name = "OP",
    Icon = "rbxassetid://6031098406",
    PremiumOnly = false
})

-- Variabili Auto Kill
local autoKillEnabled = false
local allPlayersKilled = false
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")

-- Funzione per equipaggiare il coltello
local function EquipKnife()
    local char = game.Players.LocalPlayer.Character
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild("Knife") then
        local knife = backpack:FindFirstChild("Knife")
        knife.Parent = char
    end
end

-- Funzione per fare click M1
local function ClickM1()
    virtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(0.1)
    virtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Loop Auto Kill: si attacca al bersaglio finché non è morto
task.spawn(function()
    while true do
        if autoKillEnabled and not allPlayersKilled then
            local localPlayer = game.Players.LocalPlayer
            local players = game:GetService("Players"):GetPlayers()
            local playersRemaining = 0

            for _, target in ipairs(players) do
                if target ~= localPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    playersRemaining = playersRemaining + 1
                    local char = localPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        EquipKnife()
                        -- Continua ad attaccare il target finché è vivo
                        while target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 do
                            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            wait(0.2)
                            ClickM1()
                            wait(0.8)
                            -- Verifica se il coltello è ancora equipaggiato
                            if not char:FindFirstChild("Knife") then
                                autoKillEnabled = false  -- Disattiva Auto Kill se il coltello non è più in mano
                                break
                            end
                        end
                    end
                end
            end

            -- Se non ci sono più giocatori da uccidere, ferma il loop
            if playersRemaining == 0 then
                allPlayersKilled = true
                OrionLib:MakeNotification({
                    Name = "Auto Kill",
                    Content = "Tutti i giocatori sono stati uccisi!",
                    Image = "rbxassetid://6031098406",
                    Time = 3
                })
                autoKillEnabled = false -- Disattiva Auto Kill
            end
        end
        wait(1)
    end
end)

-- Bottone per attivare/disattivare Auto Kill
opTab:AddButton({
    Name = "Auto Kill All",
    Callback = function()
        if not allPlayersKilled then
            autoKillEnabled = true
            allPlayersKilled = false
            OrionLib:MakeNotification({
                Name = "Auto Kill",
                Content = "Inizio Auto Kill",
                Image = "rbxassetid://6031098406",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Auto Kill",
                Content = "Tutti i giocatori sono già stati uccisi.",
                Image = "rbxassetid://6031098406",
                Time = 3
            })
        end
    end
})

-------------------------------------------
-- SISTEMA ESP
-------------------------------------------
local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "CipherX_ESP"

-- Funzione per creare ESP
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

-- Funzione per rimuovere ESP
local function removeAllESP()
    for _, v in pairs(espFolder:GetChildren()) do
        v:Destroy()
    end
end

-- Funzione per aggiornare ESP
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

-- Toggle per ESP
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
-- TAB PLAYER (Visualizzazione)
-------------------------------------------
local playerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6031098406",
    PremiumOnly = false
})

local selectedPlayer = nil

-- Funzione per aggiornare la lista dei giocatori
local function UpdatePlayerList()
    local playerList = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Combo Box per selezionare il giocatore
playerTab:AddDropdown({
    Name = "Select Player",
    Options = UpdatePlayerList(),
    Default = "None",
    Callback = function(selected)
        if selected ~= "None" then
            selectedPlayer = game.Players:FindFirstChild(selected)
        else
            selectedPlayer = nil
        end
    end
})

-- Toggle per vedere la visuale del giocatore selezionato
playerTab:AddToggle({
    Name = "Visuale del Giocatore Selezionato",
    Default = false,
    Callback = function(value)
        if value and selectedPlayer then
            local camera = game.Workspace.CurrentCamera
            camera.CameraSubject = selectedPlayer.Character:WaitForChild("Head")
            camera.CameraType = Enum.CameraType.Attach
            OrionLib:MakeNotification({
                Name = "Camera",
                Content = "Visuale impostata su " .. selectedPlayer.Name,
                Image = "rbxassetid://6031098406",
                Time = 3
            })
        else
            local camera = game.Workspace.CurrentCamera
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
            OrionLib:MakeNotification({
                Name = "Camera",
                Content = "Visuale ripristinata",
                Image = "rbxassetid://6031098406",
                Time = 3
            })
        end
    end
})

-- Aggiorna la lista dei giocatori
task.spawn(function()
    while true do
        playerTab:UpdateDropdownOptions(UpdatePlayerList())
        wait(5)
    end
end)
