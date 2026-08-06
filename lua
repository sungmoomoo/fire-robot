display · LUA
-- AFSSDisplay (LocalScript)
--
-- SETUP: Insert a ScreenGui into StarterGui, then inside it add a Frame,
-- and inside that Frame add three TextLabels named exactly:
--   StageLabel, DataLabel, OutcomeLabel
-- Then put this script inside the ScreenGui.
 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("AFSSUpdate")
 
local screenGui = script.Parent
local frame = screenGui:WaitForChild("Frame")
local stageLabel = frame:WaitForChild("StageLabel")
local dataLabel = frame:WaitForChild("DataLabel")
local outcomeLabel = frame:WaitForChild("OutcomeLabel")
 
local FRIENDLY_STAGE_NAMES = {
	DETECTED = "Candidate fire detected",
	FALSE_POSITIVE = "Discarded - false positive",
	CONFIRMED = "Fire confirmed",
	DISPATCHED = "Robot dispatched",
	ARRIVED = "Robot arrived at zone",
	SUPPRESSING = "Suppressing fire...",
	CONTAINED = "Fire contained",
	SUPPRESSION_FAILED = "Suppression failed",
}
 
local function formatData(data)
	local lines = {}
	for key, value in pairs(data) do
		if typeof(value) == "number" then
			table.insert(lines, key .. ": " .. string.format("%.2f", value))
		elseif key ~= "outcome" then
			table.insert(lines, key .. ": " .. tostring(value))
		end
	end
	return table.concat(lines, "\n")
end
 
remoteEvent.OnClientEvent:Connect(function(stage, data)
	stageLabel.Text = FRIENDLY_STAGE_NAMES[stage] or stage
	dataLabel.Text = formatData(data)
 
	if stage == "CONTAINED" then
		outcomeLabel.Text = data.outcome or "Mission Complete"
		outcomeLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
	elseif stage == "SUPPRESSION_FAILED" then
		outcomeLabel.Text = data.outcome or "Mission Incomplete"
		outcomeLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
	elseif stage == "FALSE_POSITIVE" then
		outcomeLabel.Text = "False positive discarded"
		outcomeLabel.TextColor3 = Color3.fromRGB(240, 180, 60)
	else
		outcomeLabel.Text = ""
	end
end)
