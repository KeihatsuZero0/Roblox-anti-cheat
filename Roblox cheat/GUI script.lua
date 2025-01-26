-- Assuming the GUI is in the player's PlayerGui
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gui

-- Create a text label to show the count of players at the door
local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 300, 0, 50)
textLabel.Position = UDim2.new(0.5, -150, 0.1, 0)
textLabel.Text = "Players left to reach the door: " .. (requiredPlayers - playersAtDoor)
textLabel.TextSize = 24
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Update the text with the number of players at the door
game.ReplicatedStorage.PlayerCount.OnClientEvent:Connect(function(playerCount)
    textLabel.Text = "Players left to reach the door: " .. (requiredPlayers - playerCount)
end)
