-- Assuming the door is a part in the workspace
local door = script.Parent -- The door is the part this script is attached to

-- Create sound instances for opening and closing the door
local openSound = Instance.new("Sound")
openSound.SoundId = "rbxassetid://1234567890" -- USER INPUT NEEDED: Replace with your sound ID for opening
openSound.Parent = door

local isOpen = false

-- Function to open the door
local function openDoor()
    if not isOpen then
        openSound:Play() -- Play the opening sound
        door.CFrame = door.CFrame * CFrame.new(0, 10, 0) -- Moves the door upwards (adjust if necessary)
        isOpen = true
    end
end

-- USER INPUT NEEDED:
-- 1. Replace the SoundId value in openSound.SoundId with the actual Roblox asset ID for the opening door sound.
-- 2. Adjust door.CFrame values if you want to modify how the door moves (e.g., position or animation type).
