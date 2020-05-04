os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")

WHEAT = "minecraft:wheat"
SEEDS = "minecraft:wheat_seeds"
FARMLENGTH = 3
ROWLENGTH = 8
SLEEP = 1500

function harvest()
	
	local success, lookingAt = turtle.inspect()

	if success == true and lookingAt.name == WHEAT and lookingAt.state.age ~= 7 then
		return
	end

	turtle.dig()
	if not inv.selectByName(SEEDS) then
		print("harvest(): out of seeds")
	else
		turtle.place()
	end
end

-- Move one block to the left or right
-- Keep the same direction
function moveOver(left)
	if left then
		turtle.turnLeft()
		fuel.refuel()
		turtle.forward()
		turtle.turnRight()
	
	-- if not left than right
	else
		turtle.turnRight()
		fuel.refuel()
		turtle.forward()
		turtle.turnLeft()
	end
end

function harvestRow(left, rowLength)
	
	local success, lookingAt = turtle.inspect()

	for i = 1, rowLength do

		harvest()
		moveOver(left)
	end
end

function moveRow(left)
	
	turtle.forward()
	turtle.forward()
	moveOver(not left)
end

function harvestFarm(farmLength, rowLength)
	local direction = true

	for i = 1, farmLength * 2 do
		
		harvestRow(direction, rowLength)
		
		-- move to next row
		moveRow(direction)	

		direction = not direction
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

	-- get fuel
	turtle.turnLeft()
	turtle.suck()
	
	-- deposite wheat
	turtle.turnRight()
	while inv.selectByName(WHEAT) do
		turtle.drop()
	end
	
	-- go to starting position
	turtle.turnRight()
	fuel.refuel()
	turtle.forward()
	turtle.turnRight()
 
end

while true do
	harvestFarm(FARMLENGTH, ROWLENGTH)
	os.sleep(SLEEP)
end
