local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerCountEvent = ReplicatedStorage:WaitForChild("PlayerCount")

-- Existing player count setup

-- Function to update player count for GUI display
local function updatePlayerCount()
    playerCountEvent:FireAllClients(playersAtDoor)
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Update player count
        playersAtDoor = playersAtDoor + 1
        updatePlayerCount() -- Fire the updated player count to clients
        
        -- Announce if enough players are present
        if playersAtDoor >= requiredPlayers then
            announcePlayers()
        end
    end)
end)
