os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")
os.loadAPI("/lib/nav.lua")
os.loadAPI("/lib/scan.lua")
os.loadAPI("/lib/path.lua")

VALUABLES = {
   ["minecraft:obsidian"] = true,
   ["minecraft:redstone_ore"] = true,
   ["minecraft:redstone"] = true,
   ["minecraft:coal_ore"] = true,
   ["minecraft:iron_ore"] = true,
   ["minecraft:gold_ore"] = true,
   ["minecraft:diamond"] = true,
   ["minecraft:emerald"] = true,
   ["minecraft:lapis_lazuli"] = true,
}

-- add any potential fuel source to VALUABLES
for k,v in pairs(fuel.FUEL) do VALUABLES[k] = v end

-- start bottom front left
function quarry(width, depth, height, valuables, goDown)
   local valuables = valuables or false  -- default to false
   local goDown = goDown or false  --default to up
   local facingForward = true
   nav.forceDir(nav.DIRS.FORWARD) -- start inside quarry zone
   for i = 1,height do
      for j = 1,width do
	 for k = 1,depth-1 do
	    manageInv(VALUABLES)
	    nav.forceDir(nav.DIRS.FORWARD)
	 end
	 -- Just finished digging one row.
	 -- Now, reposition to dig next row,
	 -- but don't reposition after last pass
	 if j ~= width then
	    if facingForward then
	       turtle.turnRight()
	       manageInv(VALUABLES)
	       nav.forceDir(nav.DIRS.FORWARD)
	       turtle.turnRight()
	    else
	       turtle.turnLeft()
	       manageInv(VALUABLES)
	       nav.forceDir(nav.DIRS.FORWARD)
	       turtle.turnLeft()
	    end
	    facingForward = not facingForward
	 end
      end
      -- reposition to start digging plane above,
      -- but don't reposition after last pass
      if i ~= height then
	 manageInv(VALUABLES)
	 if goDown then
	    nav.forceDir(nav.DIRS.DOWN)
	 else
	    nav.forceDir(nav.DIRS.UP)
	 end
	 turtle.turnLeft()
	 turtle.turnLeft()
      end
   end
end

-- drops all non valuable items and condenses inventory when full
function manageInv(valuables)
   if valuables and inv.isFull() then
      inv.dropAllExcept(VALUABLES)
      inv.restack()
   end
end

function vein()
	local scans = {"FORWARD","UP", "DOWN", "LEFT", "LEFT", "LEFT"}
	local digs = {"FORWARD","UP","DOWN","FORWARD","FORWARD","FORWARD"}
	local pos = path.getPosition()
	local dir = path.getDirection()
	local axis = path.getAxis()
	for i,v in ipairs(path.getPosition()) do
		pos[i] = v
	end
	for i,v in ipairs(scans) do
		local flag = false
		local success, item = scan.SCANS[v]()
		if success then
			if  VALUABLES[item.name] then
				path.ACTIONS["DIG"][digs[i]]()
				flag = true
			end
			if item.name == "minecraft:lava" and inv.selectByName("minecraft:bucket") then --TODO go back to previously selected slot
				if item.state.level == 0 then
					tmp = {turtle.place, turtle.placeUp, turtle.placeDown, turtle.place, turtle.place, turtle.place}
					tmp[i]()
					turtle.refuel()
				end
				flag = true
			end
			if flag and not path.ifDir(digs[i]) then
				path.ACTIONS["MOVE"][digs[i]]()
				vein()
			end
		end
	end
	if not path.GoTo(pos) then
	 	error("cannot backtrack")
	end
	path.turnTo(axis,dir)
end

			
