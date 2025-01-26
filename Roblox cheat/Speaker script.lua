-- Set the number of players required to go to the door
local requiredPlayers = 3
local playersAtDoor = 0

-- Create a sound instance for the speaker announcement
local speaker = workspace.Speaker -- Replace with your actual speaker part
local announceSound = Instance.new("Sound")
announceSound.SoundId = "rbxassetid://1234567890" -- USER INPUT NEEDED: Replace with your sound ID for the announcement
announceSound.Parent = speaker

-- Function to announce the number of players remaining
local function announcePlayers()
    announceSound:Play() -- Play the announcement sound
    print("There are " .. (requiredPlayers - playersAtDoor) .. " players left to reach the door.") -- Logs the announcement in output
end

-- Function to handle when players go to the door (use an event to detect)
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Update player count when a player enters the game
        playersAtDoor = playersAtDoor + 1
        announcePlayers() -- Announce the player count each time a player joins
        
        -- Check if enough players are at the door
        if playersAtDoor >= requiredPlayers then
            announcePlayers() -- If enough players are there, announce it
        end
    end)
end)
