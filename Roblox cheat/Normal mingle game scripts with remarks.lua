-- Variables and Services
local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local statusLabel = script.Parent:WaitForChild("StatusLabel")  -- Reference to UI Label
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

-- Marbles Game (Simplified with input)
function marblesGame()
    updateUI("Marbles game starting! Choose your game (Odd/Even).")
    
    -- Collect player input (Odd or Even selection)
    for _, player in pairs(players:GetPlayers()) do
        local selected = false
        while not selected do
            -- Simulate decision-making
            print(player.Name .. " is choosing...")
            wait(5)  -- Wait for input or timeout
            
            selected = true  -- Simulate decision
            local choice = math.random(1, 2) == 1 and "Odd" or "Even"
            print(player.Name .. " chose " .. choice)
        end
    end
    nextRound()
end

-- Player Elimination
function eliminatePlayer(player)
    print(player.Name .. " has been eliminated!")
    player:Kick("You were eliminated in this round!")
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
