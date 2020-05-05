os.loadAPI("/lib/inv.lua")

-- TODO: add blaze rods, bamboo, kelp, etc.
FUEL = {
	["minecraft:coal"]=80,
	["minecraft:charcoal"]=80,
	["minecraft:oak_planks"]=15,
}

-- refuel a turtle if necessary
-- returns false if out of fuel
function refuel(threshold)
	threshold = threshold or 80  -- value of one coal
	initial_slot = turtle.getSelectedSlot()
	while turtle.getFuelLevel() < threshold do
		-- select coal
		if not inv.selectFromTable(FUEL) then
			return false
		end
		-- refuel one at a time to not be wasteful
		turtle.refuel(1)
	end
	-- reset to inital inv position
	turtle.select(initial_slot)
	return true
end
