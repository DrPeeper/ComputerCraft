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


-- cardinal, axis, direction
-- east, 1, 1
-- north, 2, 1
-- west, 1, -1
-- south, 2, -1
cardinals = {"east","north","west","south"}
local position = {0,0,0}
local axis = 2
local direction = 1
local history = {}
history[table.concat(position,",")] = true

-- instantiate current position
function init()
	position = {0,0,0}
	axis = 2
	direction = 1
	history[table.concat(position,",")] = true
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

function getHistory()
	return history
end

-- return the axis and direction of if given the index of a cardinal direction
function toDir(cardinal)
	if cardinals[cardinal] then
		local axis = 2 - cardinal % 2
		local direction = 1 + axis - cardinal
		return axis,direction
	end
	error("enter valid cardinal direction")
end

-- TODO argument validity test
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
		history[table.concat(position,",")] = true
		return true
	end
	return false
end

function back()
	fuel.refuel()
	if turtle.back() then
		position[axis] = position[axis] - direction
		history[table.concat(position,",")] = true
		return true
	end
	return false
end

function up()
	fuel.refuel()
	if turtle.up() then
		position[3] = position[3] + 1
		history[table.concat(position,",")] = true
		return true
	end
	return false
end

function down()
	fuel.refuel()
	if turtle.down() then
		position[3] = position[3] - 1
		history[table.concat(position,",")] = true
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
function goTo(dest, back)
	back = back or false
	if back then
		local record = {}
		return GoToB(dest,record)
	else
		return GoTo(dest)
	end
end

function GoTo(dest)
	if dest[1] == position[1] and dest[2] == position[2] and dest[3] == position[3] then
		return true
	end
	local flag = false
	for i,v in ipairs(dest) do
		local diff = v - position[i]
		if diff ~= 0 then 
			local dir = diff/math.abs(diff)
			while diff ~= 0 and moveTo(i,dir) do
				flag = true
				diff = diff - dir
			end
		end
	end
	if flag then
		return GoTo(dest)
	else
		return false
	end		
end

-- TODO add breaks to avoid infinite search
function GoToB(dest, prev)
	-- base case
	if dest[1] == position[1] and dest[2] == position[2] and dest[3] == position[3] then
		return true
	end

	-- TODO position vector to string
	-- save destination as to not return here
	prev[table.concat(position)] = true
	-- queues sort moves into good, nuetral, and bad
	local g = q.init()
	local n = q.init()
	local b = q.init()

	-- TODO create key by subtracting dest vector by position vector
	-- create key for next move
	for i,v in ipairs(dest) do
		local key = dest[i] - position[i]
		if key ~= 0 then -- TODO ~= inf
			key = key/math.abs(key) -- TODO do this to the key vector before loop
			q.enq(g,{i,key})
			--q.enq(b,{i,-key})
		else
			q.enq(n,{i,1})
			q.enq(n,{i,-1})
		end
	end

	while not q.isEmpty(n) do
		q.enq(g,q.pop(n))
	end
	--while not q.isEmpty(b) do
	--	q.enq(g,q.pop(b))
	--end

	-- attempt to move in each direction in an optimal order
	while not q.isEmpty(g) do
		local move = q.pop(g)
		local i = move[1]
		local v = move[2]

		-- TODO use a temporary vector and to edit
		-- check if next move leads to a visited destination
		position[i] = position[i] + v 
		local check = prev[table.concat(position)] -- TODO vector.toString(vector)
		position[i] = position[i] - v
		
		if not check then
			if moveTo(i, v) then
				if GoToB(dest, prev) then
					return true
				end
				if not moveTo(i,-v) then
					error("cannot backtrack")
				end
			end
		end
	end
	return false	
end

function ifMove(dir)
	local tmp = {0,0,0}
	for i,v in ipairs(position) do
		tmp[i] = v
	end
	if dir == DIRS.UP then
		tmp[3] = tmp[3] + 1
	end
	if dir == DIRS.DOWN then
		tmp[3] = tmp[3] - 1
	end
	if dir == DIRS.FORWARD then
		tmp[axis] = direction
	end
	return tmp
end

ACTIONS = {
   ["MOVE"] = {
      ["UP"] = up,
      ["DOWN"] = down,
      ["FORWARD"] = forward,
      ["LEFT"] = turnLeft,
      ["RIGHT"] = turnRight,
   },
   ["DIG"] = {
      ["UP"] = turtle.digUp,
      ["DOWN"] = turtle.digDown,
      ["FORWARD"] = turtle.dig,
   },
}
