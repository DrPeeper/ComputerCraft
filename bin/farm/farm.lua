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

	for i = 1, rows/3 do
		for j = 1, columns do
			print("next column")
			crop = inv.inspectWithTable(farmer.CROPS)
			turtle.dig()
			fuel.refuel()
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

		
		-- plant last column
		turtle.turnLeft()
		turtle.turnLeft()
		farmer.harvest()
		turtle.turnLeft()
		turtle.turnLeft()
	
		if  i ~= rows/3 then
			print("next row")

			-- go to next row
			if left then 
				turtle.turnLeft()
			else
				turtle.turnRight()
			end
		
			fuel.refuel()
			turtle.forward()
			fuel.refuel()
			turtle.forward()
			fuel.refuel()
			turtle.forward()

			if left then
				turtle.turnLeft()
			else
				turtle.turnRight()
			end
		end

		left = not left
	end
	
	if not left then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end

	turtle.refuel()
	turtle.forward()	
	
	if not left then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end

	for k = 1, columns + 1 do
		fuel.refuel()
		turtle.forward()
	end

	for z = 1, rows - 2 do
		fuel.refuel()
		turtle.forward()
	end
	
	if not left then
		turtle.turnRight()
	else
		turtle.turnLeft()
	end

	turtle.refuel()
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
