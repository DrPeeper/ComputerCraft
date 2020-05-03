os.loadAPI("/lib/inv.lua")

COAL = "minecraft:coal"

function refuel(threshold)
	threshold = threshold or turtle.getFuelLimit()
	initial_slot = turtle.getSelectedSlot()
	if turtle.getFuelLevel() < threshold then
		-- select coal
		inv.selectByName(COAL)
		-- TODO: handle if no more fuel?
		-- refuel
		turtle.refuel()
		-- reset to inital inv position
		turtle.select(initial_slot)
	end
end
