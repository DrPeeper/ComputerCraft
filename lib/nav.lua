os.loadAPI("/lib/fuel.lua")

DIRS = {
   UP="UP",
   DOWN="DOWN",
   FORWARD="FORWARD",
}

OPS = {
   DIG="DIG",
   MOVE="MOVE",
}

ACTIONS = {
   ["MOVE"] = {
      ["UP"] = turtle.up,
      ["DOWN"] = turtle.down,
      ["FORWARD"] = turtle.forward,
   },
   ["DIG"] = {
      ["UP"] = turtle.digUp,
      ["DOWN"] = turtle.digDown,
      ["FORWARD"] = turtle.dig,
   },
}

-- wrapper for gps.locate
-- returns results as a vector
-- errors if failed
function locate()
   local x, y, z = gps.locate()
   if x == nil then
      error("gps location failed")
   end
   return vector.new(x, y, z)
end

-- destructively more n blocks
function forceDir(dir, n)
   if DIRS[dir] == nil then
      error("enter a valid direction")
   end

   n = n or 1  -- default to one block
   for i = 1,n do
      ACTIONS[OPS.DIG][dir]()
      
      while true do
	 -- keep trying until success
	 -- used to deal w/falling gravel etc.
	 fuel.refuel()
	 if ACTIONS[OPS.MOVE][dir]() then
	    break
	 end
	ACTIONS[OPS.DIG][dir]()
      end
   end
end

function getBearing()
   local initial_pos = locate()
   local delta_pos = vector.new()

   for i = 1,4 do
      local lookingAt, _ = turtle.inspect()
      if lookingAt == false then
	 turtle.forward()
	 delta_pos = locate() - initial_pos
	 turtle.back()
	 break
      end
      -- something is blocking the way
      -- turn and try again
      turtle.turnRight()
   end

   if delta_pos.length() == 0 then
      error("failed to get bearing")
   end

   if delta_pos.x == 1 then
      return "east"
   elseif delta_pos.x == -1 then
      return "west"
   elseif delta_pos.z == 1 then
      return "south"
   elseif delta_pos.z == -1 then
      return "north"
   end
end
