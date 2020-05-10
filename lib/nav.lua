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
	array = {1, -1}
	if turtle.turnLeft() then
		direction = direction * -1 * array[1 + axis % 2]
		axis = 1 + axis % 2
		return true
	end
	return false
end

function turnRight()
	array = {1, -1}
	if turtle.turnRight() then
		direction = direction * 1 * array[1 + axis % 2]
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
		function doNothing()
			return true
		end
		array = {turnLeft, doNothing, turnRight, turnAround}
		return array[opcode + 2]()
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
	function wrapper(cmd)
		tmp = axis -- to check if turn
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
		array = {turnLeft, forward, turnRight, back}
		return wrapper(array[opcode + 2])
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
		if v ~= 0 and v ~= 2 then
			return moveTo(i,v)
		end
	end
	return false
end

-- move efficient
-- given a key with 3 directions for 3 axis
-- attempt to move in given direction
-- zeroes in the key assume a don't care and 
-- move efficient will try to move in both directions
-- on the specified axis if the non zero axis fail
-- if you don't want to move on a axis, put 2
function moveE(coordinates)
	-- attempt to move optimally
	for i,v in ipairs(coordinates) do
		if v ~= 0 and v ~= 2 then
			-- if the axis has valid coordinates move there
			if moveTo(i,v) then
				return i,v
			end
		end
	end
	-- attempt to move nuetrally
	for i,v in ipairs(coordinates) do
		if v == 0 then
			if moveTo(i,1) then
				return i,1
			end
			if moveTo(i,-1) then
				return i,-1
			end
		end
	end
	-- fail to move
	return nil, nil
end

-- attempt to travel to given coordinates
function goTo(dest, prevA, prevD)
	-- default garbage values
	prevA = prevA or 6
	prevD = prevD or 10

	-- base case
	if dest[1] == position[1] and dest[2] == position[2] and dest[3] == position[3] then
		return true
	end
	-- copy previous position in case we need to return
	prev = {0,0,0}
	for i,v in ipairs(position) do
		prev[i] = v
	end
	key = {0,0,0}
	-- create key for next moveE
	for i,v in ipairs(dest) do
		if dest[i] ~= 0 then
			key[i] = key[i]/math.abs(key[i])
		end
		-- cannot go back
		if key[prevA] == prevD * -1 then
			key[prevA] = 2
		end
	end
	-- attempt to move in optimal direction
	prevA, prevD = moveE(key)
	if not prevA or not prevD then
		return false
	end
	-- make next move
	if goTo(dest, prevA, prevD) then
		return true
	else
		-- calculate previous move
		for i,v in ipairs(position) do
			prev[i] = position[i] - prev[i]
		end
		-- attempt backtrack
		if not moveC(prev) then
			-- TODO: add force move
			-- TODO: add turnC
			error("cannot backtrack")
		end
		return false
	end
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
