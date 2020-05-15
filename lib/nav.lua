os.loadAPI("/lib/fuel.lua")
os.loadAPI("/lib/q.lua")

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

-- cardinal, axis, direction
-- east, 1, 1
-- north, 2, 1
-- west, 1, -1
-- south, 2, -1
cardinals = {"east","north","west","south"}

-- instantiate current position
function init()
	position = {0,0,0}
	axis = 2
	direction = 1
end

function getAxis()
	return axis
end

function getPosition()
	return position
end

function getDirection()
	return direction
end

-- return the axis and direction of if given the index of a cardinal direction
function toDir(cardinal)
	if cardinals[cardinal] then
		axis = 2 - cardinal % 2
		direction = 1 + axis - cardinal
		return axis,direction
	end
	error("enter valid cardinal direction")
end

-- given an axis and direction return the index of the respective cardinal direction index
function toCardinal(axis,direction)
	return 1 + axis - direction
end

-- turn the turtle left
-- if sucessfull return so and update direction, axis
function turnLeft()
	local tmp = {1, -1}
	if turtle.turnLeft() then
		direction = direction * -1 * tmp[1 + axis % 2]
		axis = 1 + axis % 2
		return true
	end
	return false
end

function turnRight()
	local tmp = {1, -1}
	if turtle.turnRight() then
		direction = direction * 1 * tmp[1 + axis % 2]
		axis = 1 + axis % 2
		return true
	end
	return false
end

function turnAround()
	if turnLeft() then
		if not turnLeft() then
			return turnRight() and turnRight() and turnRight()
		end
		return true
	end
	return turnRight() and turnRight()
end

function forward()
	fuel.refuel()
	if turtle.forward() then
		position[axis] = position[axis] + direction
		return true
	end
	return false
end

function back()
	fuel.refuel()
	if turtle.back() then
		position[axis] = position[axis] - direction
		return true
	end
	return false
end

function up()
	fuel.refuel()
	if turtle.up() then
		position[3] = position[3] + 1
		return true
	end
	return false
end

function down()
	fuel.refuel()
	if turtle.down() then
		position[3] = position[3] - 1
		return true
	end
	return false
end

-- turn given the opcode
-- -1 = turn left
-- 0 = do nothing
-- 1 = turn right
-- 2 = turn around
function turn(opcode)
	if opcode > -2 and opcode < 3 then
		local function doNothing()
			return true
		end
		local actions  = {turnLeft, doNothing, turnRight, turnAround}
		return actions[opcode + 2]()
	end
	error("invalid opcode")
end

-- given the axis and direction of destination, turn there
function turnTo(axisD, directionD)
	if cardinals[toCardinal(axisD, directionD)] then
		return turn(((axis - axisD) + (directionD - direction) + 1) % 4 - 1)
	end
	error ("invalid axis and or direction")
end

-- given the opcode turn there and move forward
-- if given the opcode for turn around return turtle.back()
function move(opcode)
	local function wrapper(cmd)
		local tmp = axis -- to check if turn
		if cmd() then
			if tmp ~= axis then
				return forward()
			end
			return true
		else
			return false
		end
	end
	if opcode > -2 and opcode < 3 then
		local actions = {turnLeft, forward, turnRight, back}
		return wrapper(actions[opcode + 2])
	end
	error("invalid axis and or direction")
end

-- given the axis and direction of destination, turn forward there
-- if axis is 3, will go up or down
function moveTo(axisD, directionD)
	if axisD ~= 3 then
		return move(((axis - axisD) + (directionD - direction) + 1) % 4 - 1)
	end
	if directionD == 1 then
		return up()
	end
		return down()
end

-- move to the given coordinates
-- will only move once in a single axis
function moveC(coordinates)
	for i,v in ipairs(coordinates) do
		if v ~= 0 then
			return moveTo(i,v/math.abs(v))
		end
	end
	return false
end

-- TODO attempt to go to these coordinates
function goTo(dest)
	local record = {}
	return GoTo(dest,record)
end

-- TODO add breaks to avoid infinite search
function GoTo(dest, prev)
	-- base case
	if dest[1] == position[1] and dest[2] == position[2] and dest[3] == position[3] then
		return true
	end

	-- save destination as to not return here
	prev[table.concat(position)] = true
	-- queues sort moves into good, nuetral, and bad
	local g = q.init()
	local n = q.init()
	local b = q.init()

	-- create key for next move
	for i,v in ipairs(dest) do
		local key = dest[i] - position[i]
		if key ~= 0 then
			key = key/math.abs(key)
			q.enq(g,{i,key})
			q.enq(b,{i,-key})
		else
			q.enq(n,{i,1})
			q.enq(n,{i,-1})
		end
	end

	while not q.isEmpty(n) do
		q.enq(g,q.pop(n))
	end
	while not q.isEmpty(b) do
		q.enq(g,q.pop(b))
	end

	-- attempt to move in each direction in an optimal order
	while not q.isEmpty(g) do
		local move = q.pop(g)
		local i = move[1]
		local v = move[2]

		-- check if next move leads to a visited destination
		position[i] = position[i] + v
		local check = prev[table.concat(position)]
		position[i] = position[i] - v
		
		if not check then
			if moveTo(i, v) then
				if GoTo(dest, prev) then
					return true
				end
				if not moveTo(i, v) then
					error("cannot backtrack")
				end
			end
		end
	end

	return false	
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

-- move forward n blocks
function forceForward(n)
	n = n or 1  -- default to one block
	for i = 1,n do
		turtle.dig()
		while true do
			-- keep trying until success
			-- used to deal w/falling gravel etc.
			fuel.refuel()
			if turtle.forward() then
				break
			end
			turtle.dig()
		end
	end
end


-- move up n blocks
function forceUp(n)
	n = n or 1  -- default to one block
	for i = 1,n do
		turtle.digUp()
		while true do
			-- keep trying until success
			-- used to deal w/falling gravel etc.
			fuel.refuel()
			if turtle.up() then
				break
			end
			turtle.digUp()
		end
	end
end
