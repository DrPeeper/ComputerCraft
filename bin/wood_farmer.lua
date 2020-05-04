os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")

LOG = "minecraft:oak_log"
SLEEP_TIME = 300

function nextTree()
	-- move to next tree
	turtle.turnRight()
	for i = 1,2 do
		fuel.refuel()
		if not turtle.forward() then
			return false
		end
	end
	turtle.turnLeft()
	return true
end

function fellTree()
	-- mine first block
	turtle.dig()
	turtle.forward()

	-- chop tree
	while turtle.digUp() do
		fuel.refuel()
		turtle.up()
	end

	-- go back down
	while turtle.down() do
		fuel.refuel()
	end

	turtle.back()
end

function harvestPass()
	-- start facing a tree on the left side of the farm
	local success, lookingAt = turtle.inspect()
	if success == false then
		error("turtle placed incorrectly")
	end

	-- harvest trees
	while true do
		-- chop tree if ready
		if lookingAt.name == LOG then
			fellTree()
		end
		if not nextTree() then
			-- reached end of row
			break
		end
	end

	-- return to starting position
	turtle.turnLeft()
	turtle.turnLeft()
	while turtle.forward() do
		fuel.refuel()
	end

	-- face first tree to prepare for another pass
	turtle.turnRight()
end

print("Lumberjack protocol intializing...")
while true do
	print("Harvesting")
	harvestPass()
	print("Harvest completed. Sleeping.")
	os.sleep(SLEEP_TIME)
end
