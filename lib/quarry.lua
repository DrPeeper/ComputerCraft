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
   nav.forceForward() -- start inside quarry zone
   for i = 1,height do
      for j = 1,width do
	 for k = 1,depth-1 do
	    manageInv(VALUABLES)
	    nav.forceForward()
	 end
	 -- Just finished digging one row.
	 -- Now, reposition to dig next row,
	 -- but don't reposition after last pass
	 if j ~= width then
	    if facingForward then
	       turtle.turnRight()
	       manageInv(VALUABLES)
	       nav.forceForward()
	       turtle.turnRight()
	    else
	       turtle.turnLeft()
	       manageInv(VALUABLES)
	       nav.forceForward()
	       turtle.turnLeft()
	    end
	    facingForward = not facingForward
	 end
      end
      -- reposition to start digging plane above,
      -- but don't reposition after last pass
      if i ~= height then
	 manageInv(VALUABLES)
	 nav.forceUp()
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
