os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")
os.loadAPI("/lib/nav.lua")

-- start bottom front left
function quarry(width, depth, height)
	local facingForward = true
	for i = 1,height do
		for j = 1,width do
			for k = 1,depth do
				nav.forceForward()
			end
			-- just finished digging one row
			-- reposition to dig second row
			if facingForward then
				turtle.turnRight()
				nav.forceForward()
				turtle.turnRight()
			else
				turtle.turnLeft()
				nav.forceForward()
				turtle.turnLeft()
			end
			-- toggle every row
			facingForward = not facingForward
		end
		-- reposition to start digging plane above
		nav.forceUp()
		turtle.turnLeft()
		turtle.turnLeft()
	end
end

