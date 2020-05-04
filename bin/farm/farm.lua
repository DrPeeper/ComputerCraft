os.loadAPI("/bin/farm/farmer.lua")
os.loadAPI("/lib/inv.lua")

-- fix one too far 
-- add refuel
-- add harvest
-- add plant(lookingAt)
-- add deposite harvest
-- destroy seeds?

function farm(columns, rows)
	
	if (row % 3 ~= 0) then
		error("Turtle needs rows to be divisible by 3")
	end

	local left = true
	local crop = nil

	for i = 1, rows/3 do
		for j = 1, columns do

			-- turn around and plant the last plant
			if crop ~= nil then
				turtle.turnLeft()
				turtle.turnLeft()
				farmer.plant(inv.CROPS[crop.name])
				turtle.turnLeft()
				turtle.turnLeft()
			end

			crop = inv.inspectWithTable(inv.CROPS)
			turtle.dig()
			turtle.forward()

			-- harvest left side
			turtle.turnLeft()
			harvest.harvest()
			turtle.turnRight()

			-- harvest right side
			turtle.turnRight()
			harvest.harvest()
			turtle.turnLeft()

		end

		crop = nil
	
		if  j ~= rows/3 then
			-- go to next row
			if left then 
				turtle.turnLeft()
			else
				turtle.turnRight()
			end
			turtle.forward()
			turtle.forward()
			turtle.forward()

			if left then
				turtle.turnLeft()
			else
				turtle.turnRight()
			end
		end

		left = not left
	end

	-- go home	
	turtle.turnLeft()
	turtle.turnLeft()

	for i = 1, column+1 do
		turtle.forward()
	end

	if left then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end

	for i = 1, row - 2 do
		turtle.forward()
	end
	
	if left then
		turtle.turnRight()
	else
		turtle.turnLeft()
	end

	turtle.forward()

	--[===[
	-- deposit crops
	turtle.turnLeft()

	-- suck fuel
	turtle.turnLeft()
	turtle.turnRight()
	turtle.suck()
	--]===]
	-- starting position
	turtle.turnRight()
end
