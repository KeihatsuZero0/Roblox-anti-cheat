-- Create a RemoteEvent in ReplicatedStorage to handle shooting from the client side
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shootEvent = Instance.new("RemoteEvent")
shootEvent.Name = "ShootEvent"
shootEvent.Parent = ReplicatedStorage

-- Function to handle when a player fails the challenge
local function playerFailedChallenge(player)
    -- Make the player "shot" (we'll simulate this)
    local character = player.Character
    if character then
        -- Trigger ragdoll effect (GTA 4 style physics)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true -- Disable the humanoid's movement, essentially making them ragdoll
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)

            -- Fire the event to show blood and ragdoll on the client side
            shootEvent:FireClient(player)

            -- After a short time, reset the ragdoll effect
            wait(3) -- Simulate being down for a while (adjust the time)
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

-- Example of triggering the failed challenge (can be based on some condition)
game.Players.PlayerAdded:Connect(function(player)
    -- You can replace this with any condition for failing the challenge
    wait(5)  -- Delay to simulate time before failure
    playerFailedChallenge(player)
end)
