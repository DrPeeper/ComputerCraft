os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")
os.loadAPI("/lib/nav.lua")

VALUABLES = {
    ["minecraft:iron_ore"] = true,
    ["minecraft:gold_ore"] = true,
    ["minecraft:diamond"] = true,
    ["minecraft:emerald"] = true,
    ["minecraft:lapis_lazuli"] = true,
}

-- add any potential fuel source to VALUABLES
for k,v in pairs(fuel.FUEL) do VALUABLES[k] = v end

-- start bottom front left
function quarry(width, depth, height, valuables)
    local valuables = valuables or false  -- default to false
	local facingForward = true
	nav.forceForward()
	for i = 1,height do
		for j = 1,width do
			for k = 1,depth-1 do
                if valuables and inv.isFull() then inv.dropAllExcept(VALUABLES) end
				nav.forceForward()
			end
			-- just finished digging one row
			-- reposition to dig second row
			if j ~= width then
				-- don't reposition on last row
				if facingForward then
					turtle.turnRight()
                    if valuables and inv.isFull() then inv.dropAllExcept(VALUABLES) end
					nav.forceForward()
					turtle.turnRight()
				else
					turtle.turnLeft()
                    if valuables and inv.isFull() then inv.dropAllExcept(VALUABLES) end
					nav.forceForward()
					turtle.turnLeft()
				end
				facingForward = not facingForward
			end
			-- toggle every row
		end
		-- reposition to start digging plane above
		if i ~= height then
            if valuables and inv.isFull() then inv.dropAllExcept(VALUABLES) end
			nav.forceUp()
			turtle.turnLeft()
			turtle.turnLeft()
		end
	end
end

