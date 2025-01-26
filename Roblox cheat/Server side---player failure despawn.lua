-- Create a RemoteEvent in ReplicatedStorage to handle shooting from the client side
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shootEvent = Instance.new("RemoteEvent")
shootEvent.Name = "ShootEvent"
shootEvent.Parent = ReplicatedStorage

-- Function to handle when a player fails the challenge
local function playerFailedChallenge(player)
    local character = player.Character or player.CharacterAdded:Wait()  -- Wait for character if not loaded yet

    -- Ensure the character doesn't respawn automatically
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0  -- Set health to 0 to simulate death
        humanoid.PlatformStand = true  -- Disable movement, ragdoll effect
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)  -- Switch to physics state

        -- Fire the event to show blood and ragdoll on the client side
        shootEvent:FireClient(player)

        -- Prevent respawn by removing humanoid
        humanoid:Destroy()

        -- Disable automatic despawning
        local bodyParts = character:GetChildren()
        for _, part in pairs(bodyParts) do
            if part:IsA("BasePart") then
                part.Anchored = true  -- Anchor parts to prevent them from falling and despawning
            end
        end
    end
end

-- Triggering the failed challenge (replace with your game logic)
game.Players.PlayerAdded:Connect(function(player)
    -- Wait for player to load fully
    player.CharacterAdded:Connect(function(character)
        -- Simulate failure after 5 seconds (replace with actual game logic)
        wait(5)
        playerFailedChallenge(player)
    end)
end)
