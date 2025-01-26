-- Variables and Services
local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local statusLabel = script.Parent:WaitForChild("StatusLabel")  -- Reference to UI Label
local speakerLabel = script.Parent:WaitForChild("SpeakerLabel")  -- Reference to Speaker UI Label
local gameState = "Waiting"  -- Game state
local currentRound = 1
local rounds = {"Red Light, Green Light", "Tug of War", "Marbles"}

-- Game States
local function updateGameState(newState)
    gameState = newState
    print("Game state changed to:", gameState)
    updateUI("Current Game State: " .. gameState)
    
    if gameState == "Playing" then
        startRound(rounds[currentRound])
    elseif gameState == "End" then
        endGame()
    end
end

-- UI Update
function updateUI(message)
    statusLabel.Text = message
end

-- Speaker Update
function updateSpeaker(message)
    speakerLabel.Text = message
end

-- Red Light, Green Light
local function redLightGreenLight()
    updateUI("Red Light, Green Light! Green Light starts now!")
    gameState = "Green Light"
    
    -- Green Light Phase
    wait(10)  -- Green Light lasts 10 seconds
    gameState = "Red Light"
    updateUI("Red Light! Stop moving!")

    -- Red Light Phase (Eliminate those who are moving)
    wait(5)  -- Red Light lasts 5 seconds
    for _, player in pairs(players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local speed = humanoid.WalkSpeed  -- Assuming WalkSpeed > 0 indicates movement

            -- Player movement check during Red Light
            if gameState == "Red Light" and speed > 0 then
                eliminatePlayer(player)
            end
        end
    end
    nextRound()
end

-- Team Setup for Tug of War
local teamA = {}
local teamB = {}

function assignTeams()
    -- Reset teams at the beginning of each round
    teamA = {}
    teamB = {}

    local playersList = players:GetPlayers()
    local teamSize = math.floor(#playersList / 2)

    for i = 1, #playersList do
        if i <= teamSize then
            table.insert(teamA, playersList[i])
        else
            table.insert(teamB, playersList[i])
        end
    end
end

-- Start Tug of War
function startTugOfWar()
    assignTeams()
    updateUI("Tug of War! Team A vs Team B")
    
    -- Simulate tug-of-war interaction (e.g., players press a button to pull)
    wait(10)  -- Tug of War lasts 10 seconds
    nextRound()
end

-- Marbles Game (Interactive with player input)
function marblesGame()
    updateUI("Marbles game starting! Choose your game (Odd/Even).")
    
    -- Collect player input (Odd or Even selection)
    for _, player in pairs(players:GetPlayers()) do
        local selected = false
        local choice = nil
        while not selected do
            -- Show options and wait for player to click a button or type choice
            print(player.Name .. " is choosing...")

            -- Simulate waiting for player input (you can link this to GUI buttons)
            wait(5)  -- Wait for input or timeout
            
            -- Randomly simulate Odd or Even choice
            choice = math.random(1, 2) == 1 and "Odd" or "Even"
            print(player.Name .. " chose " .. choice)
            selected = true
        end
    end
    nextRound()
end

-- Player Elimination
function eliminatePlayer(player)
    -- Create the ragdoll effect and simulate a bloody body
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character:FindFirstChild("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        -- Simulate shooting the player (add a blood effect)
        local bloodEffect = Instance.new("Part")
        bloodEffect.Size = Vector3.new(1, 0.1, 1)
        bloodEffect.Shape = Enum.PartType.Ball
        bloodEffect.Position = character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)
        bloodEffect.BrickColor = BrickColor.Red()
        bloodEffect.Material = Enum.Material.SmoothPlastic
        bloodEffect.CanCollide = false
        bloodEffect.Parent = workspace
        
        -- Blood spray when shot
        local bloodSpray = Instance.new("ParticleEmitter")
        bloodSpray.Parent = bloodEffect
        bloodSpray.Lifetime = NumberRange.new(0.5, 1)
        bloodSpray.Rate = 100
        bloodSpray.Velocity = NumberRange.new(0, 10)
        bloodSpray.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        bloodSpray.Size = NumberSequence.new(0.1, 0.3)

        -- Disable humanoid to allow ragdoll physics
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid.PlatformStand = true
        humanoidRootPart.Anchored = false  -- Unanchor the character for ragdoll physics

        -- Play ragdoll physics (apply random forces for realism)
        humanoidRootPart.Velocity = Vector3.new(math.random(-10, 10), math.random(10, 20), math.random(-10, 10))

        -- Make blood effect last longer and move with body
        bloodEffect.Anchored = false  -- Blood moves with the body
        bloodEffect.CFrame = character.HumanoidRootPart.CFrame
        
        -- Wait a moment before kicking player
        wait(3)  -- Ragdoll stays for 3 seconds before kicking

        -- Now kick the player after the ragdoll
        player:Kick("You were eliminated in this round!")
    end
end

-- Update Player Count Announcement
function updatePlayerCount()
    local playersLeft = #players:GetPlayers()
    updateSpeaker("Players Left: " .. playersLeft)
end

-- Round Management
function startRound(roundName)
    updateUI("Starting round: " .. roundName)
    if roundName == "Red Light, Green Light" then
        redLightGreenLight()
    elseif roundName == "Tug of War" then
        startTugOfWar()
    elseif roundName == "Marbles" then
        marblesGame()
    end
end

-- Proceed to next round
function nextRound()
    currentRound = currentRound + 1
    if currentRound <= #rounds then
        updatePlayerCount()  -- Update player count after each round
        startRound(rounds[currentRound])
    else
        updateGameState("End")
    end
end

-- End Game
function endGame()
    updateUI("Game Over! Thanks for playing.")
    -- Here you could display winner stats, reset game, or end the server
end

-- Game Loop - Start Game
local function gameLoop()
    while true do
        if gameState == "Waiting" then
            updateUI("Waiting for players...")
            wait(3)  -- Wait 3 seconds before starting
            updateGameState("Playing")  -- Start the game
        end
    end
end

gameLoop()
