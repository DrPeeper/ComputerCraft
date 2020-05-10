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
	axis = 1
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
	if turtle.forward() then
		position[axis] = position[axis] + direction
		return true
	end
	return false
end

function back()
	if turtle.back() then
		position[axis] = position[axis] - direction
		return true
	end
	return false
end

function up()
	if turtle.up() then
		position[3] = position[3] + 1
		return true
	end
	return false
end

function down()
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
	function doNothing()
		return true
	end
	array = {turnLeft, doNothing, turnRight, turnAround}
	return array[opcode + 2]()
end

-- given the axis and direction of destination, turn there
function turnTo(axisD, directionD)
	return turn(((axis - axisD) + (directionD - direction) + 1) % 4 - 1)
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
	array = {turnLeft, forward, turnRight, back}
	return wrapper(array[opcode + 2])
end

-- given the axis and direction of destination, turn forward there
-- if axis is 3, will go up or down
function moveTo(axisD, directionD)
	if axisD ~= 3 then
		if directionD ~= 0 then
			return move(((axis - axisD) + (directionD - direction) + 1) % 4 - 1)
		end
		return true
	end
	if directionD == 1 then
		return up()
	else
		return down()
	end
end

-- move to the given coordinates
-- will only move once in each axis
function moveC(coordinates)
	for i,v in ipairs(coordinates) do
		moveTo(i,v)
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
