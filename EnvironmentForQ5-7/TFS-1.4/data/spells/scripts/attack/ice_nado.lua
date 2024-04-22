-- Useing an array of combat objects since there is a pattern of pulses
combat = {}

-- Create the combat areas for the different sections of the spell
-- These are created in a way that matches the visuals from the given example
-- This means that the spell area is internally set as a 9x7
local area = {
	{
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 1, 0, 0, 0},
		{0, 0, 1, 1, 0, 1, 0, 0},
		{0, 1, 0, 1, 1, 1, 1, 0},
		{1, 1, 0, 0, 3, 0, 1, 1},
		{0, 1, 0, 1, 0, 0, 1, 0},
		{0, 0, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0},
		{0, 1, 1, 1, 0, 0, 1, 0},
		{0, 1, 1, 1, 3, 1, 1, 0},
		{0, 1, 1, 0, 1, 1, 1, 0},
		{0, 0, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 1, 0, 0, 0},
		{0, 0, 1, 0, 1, 1, 0, 0},
		{0, 1, 0, 0, 1, 0, 1, 0},
		{0, 0, 1, 1, 3, 1, 1, 1},
		{0, 0, 1, 0, 0, 0, 1, 0},
		{0, 0, 1, 0, 0, 1, 0, 0},
		{0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
	}
}

-- Create all of the combat object for the spell
for i = 1, #area do
    combat[i] = Combat()
    combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	combat[i]:setArea(createCombatArea(area[i]))
end

function onCastSpell(creature, variant)
	-- Send the number of pulses you want when casting the spell, for this example I used 10
    return sendPulse(creature:getId(), variant, 1, 10)
end

function sendPulse(cid, variant, currentAreaIndex, remainingPulses)
	-- Repeating function that alternates the spell's combat area

	-- Reset back to the first Area if the index reaches 4
	if currentAreaIndex > 3 then
		currentAreaIndex = 1
	end

	-- If the spell has more pulses, then schedule them after a short delay
	if remainingPulses > 1 then
		-- Increase the current area index, and reduce the remaining pulses by 1
		addEvent(sendPulse, 500, cid, variant, currentAreaIndex + 1, remainingPulses - 1)
	end

	-- Effect needs to be offset by a unit to the right
	-- Lack of documentation has made this nearly impossible to figure out
	return combat[currentAreaIndex]:execute(Player(cid), variant)
end
