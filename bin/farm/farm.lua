os.loadAPI("/bin/farm/farmer.lua")
os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")

-- add deposit harvest
-- destroy seeds?

function farm(columns, rows)
	
	if (rows % 3 ~= 0) then
		error("Turtle needs rows to be divisible by 3")
	end

	local left = true
	local crop = nil
	
	fuel.refuel()

	for i = 1, rows/3 do
		for j = 1, columns do

			crop = inv.inspectWithTable(farmer.CROPS)
			turtle.dig()
			turtle.forward()

			-- harvest left side
			turtle.turnLeft()
			farmer.harvest()

			-- harvest back side
			turtle.turnLeft()	
			if crops ~= nil then
				turtle.dig()
				farmer.plant(farmer.CROPS[crop.name])
			else
				farmer.harvest()
			end
			-- harvest right side
			turtle.turnLeft()
			farmer.harvest()
			turtle.turnLeft()

		end

		turtle.refuel()	
		if  i ~= rows/3 then
			print("next row")
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

	turtle.refuel()

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
