local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shootEvent = ReplicatedStorage:WaitForChild("ShootEvent")

-- Function to handle when the shoot event is triggered (client-side)
shootEvent.OnClientEvent:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        -- Blood effect (you can customize the blood effect here)
        local bloodEffect = Instance.new("ParticleEmitter")
        bloodEffect.Texture = "rbxassetid://BloodParticleTextureID" -- Replace with actual blood particle texture ID
        bloodEffect.Size = NumberSequence.new(0.5)
        bloodEffect.Lifetime = NumberRange.new(1)
        bloodEffect.Rate = 100
        bloodEffect.Parent = character:FindFirstChild("Head") -- Attach blood to head or any part

        -- Ragdoll Physics (GTA 4 style)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            
            -- Simulate the ragdoll physics (you can add more realism by applying forces if necessary)
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("Part") and part.Name ~= "Head" then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(5000, 5000, 5000)
                    bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), math.random(100, 300), math.random(-100, 100))
                    bodyVelocity.Parent = part
                    game.Debris:AddItem(bodyVelocity, 0.5) -- Remove force after a while
                end
            end
        end
    end
end)
