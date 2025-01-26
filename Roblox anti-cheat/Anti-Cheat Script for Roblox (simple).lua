-- Anti-Cheat Script for Roblox

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Speed Hack Detection (Checks if the player's speed exceeds a set limit)
local MAX_SPEED = 100 -- The maximum allowed speed (adjust this as needed)

function checkSpeed(player)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character:FindFirstChild("Humanoid")
        local currentSpeed = humanoid.WalkSpeed

        if currentSpeed > MAX_SPEED then
            warn(player.Name .. " is moving too fast! Speed hack detected.")
            -- Here, you can kick the player or take other actions
            player:Kick("Speed hack detected!")
        end
    end
end

-- Tool Usage Detection (Checks if the player is using tools inappropriately)
function checkToolUsage(player)
    local character = player.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                -- Customize this for tool-specific hacks (like infinite usage)
                -- Example: Detect if a tool is being used excessively in a short period of time
                -- This is a basic check. You could add more logic to handle suspicious tool activity
                if tool.Name == "SuspiciousToolName" then
                    warn(player.Name .. " is using a suspicious tool!")
                    player:Kick("Suspicious tool detected!")
                end
            end
        end
    end
end

-- Server-Side Detection for Exploits
function checkExploits(player)
    local character = player.Character
    if character then
        -- Exploit check example: Verify if the character's position is too far from its last position
        local previousPosition = player:WaitForChild("PreviousPosition", 5) -- Store previous position here
        local currentPosition = character.PrimaryPart.Position

        if previousPosition and (previousPosition - currentPosition).Magnitude > 500 then -- If they moved too far in one frame
            warn(player.Name .. " moved too far in one frame! Exploit detected.")
            player:Kick("Exploit detected: abnormal movement.")
        end

        -- Update the position after check
        player:SetAttribute("PreviousPosition", currentPosition)
    end
end

-- Continuous checks every frame
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            checkSpeed(player)
            checkToolUsage(player)
            checkExploits(player)
        end
    end
end)

-- Anti-exploit Event Handler (For server-side cheating tools)
local function detectExploitAttempts(player)
    -- Checking for common exploit attempts or abnormal behavior
    player.CharacterAdded:Connect(function(character)
        -- Example: If the character has a suspicious part or tool that shouldn't be there, kick the player
        if character:FindFirstChild("ExploitPart") then
            warn(player.Name .. " has an exploit part in their character!")
            player:Kick("Exploit detected!")
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    detectExploitAttempts(player)
end)
