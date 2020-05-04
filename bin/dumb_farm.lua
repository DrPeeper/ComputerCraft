os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")

WHEAT = "minecraft:wheat"
SEEDS = "minecraft:wheat_seeds"

function harvest()
	
	local success, lookingAt = turtle.inspect()
	
	-- Return false if front block is not harvestable
	if success == false or lookingAt.name ~= WHEAT then
		print("harvest(): Cannot harvest block")
		return false
	end

	-- Only harvest if age is 7
	if lookingAt.state.age == 7 then
		turtle.dig()
	end

	return true
end

function plant()

	local success, lookingAt = turtle.inspect()

	-- If something is here error
	if success == true then
		print("plant(): Not plantable")
		return false
	end

	-- Hoe dirt
	turtle.dig()
	
	-- Select seeds
	if inv.selectByName(SEEDS) == false then
		print("plant(): Out of seeds")
		return false
	end

	-- Plant seeds
	turtle.place()

	return true
end

function harvestRow(direction, rowLength)
	
	local success, lookingAt = turtle.inpsect()
	
	if direction == "left" then
		
		for i = 1, rowLength do	

			if lookingAt == WHEAT or success == false then

				harvest()
				plant()

				-- move one block to the left
				turtle.turnLeft()
				fuel.refuel()
				turtle.forward()
				turtle.turnRight()
			end
		end
	end

	if direction == "right" then

		for i = 1, rowLength do

			if lookingAt == WHEAT or success == false then

				harvest()
				plant()

				-- move one block to the right
				turtle.turnRight()
				fuel.refuel()
				turtle.forward()
				turtle.turnLeft()
			end
		end
	end
end

function harvestFarm(farmLength, rowLength)

	for i = 1, farmLength do
		harvestRow("left", rowLength)
		
		-- move to next row
		fuel.refuel()
		turtle.forward()
		turtle.forward()
		turtle.turnRight()
		turtle.forward()
		turtle.turnLeft()

		harvestRow("right", rowLength)
		
		-- move to next row
		fuel.refuel()
		turtle.forward()
		turtle.forward()
		turtle.turnLeft()
		turtle.forward()
		turtle.turnRight()
	end

	-- return home
	
	-- turn around
	turtle.turnRight()
	fuel.refuel()
	turtle.forward()
	turtle.turnRight()

	-- walk back
	for i = 1, rowLength * 4 do
		fuel.refuel()
		turtle.forward()
	end

	-- go to starting position
	turtle.turnRight()
	fuel.refuel()
	turtle.forward()
	turtle.turnRight()
	
end	


		
