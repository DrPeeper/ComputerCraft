os.loadAPI("/lib/inv")

COAL_ID = "minecraft:coal"

function refuel(threshold)
	threshold = threshold or turtle.getFuelLimit()
	initial_slot = turtle.getSelectedSlot()
	if turtle.getFuelLevel() < threshold
		-- select coal
		inv.select(COAL_ID)
		-- refuel
		-- TODO: handle if no more fuel?
		turtle.refuel()
		-- reset to inital inv position
		turtle.select(initial_slot)
	end
end
