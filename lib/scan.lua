os.loadAPI("lib/path.lua")


function left()
	if path.turnLeft() then
		return turtle.inspect()
	end
end

function right()
	if path.turnRight() then
		return turtle.inspect()
	end
end

function up()
	return turtle.inspectUp()
end

function forward()
	return turtle.inspect()
end

function down()
	return turtle.inspectDown()
end

function to(axis, direction)
	path.turnTo(axis, direction)
	return turtle.inspect()
end

DIR = {
	UP = "UP",
	DOWN = "DOWN",
	FORWARD = "FORWARD",
	LEFT = "LEFT",
	RIGHT = "RIGHT",
}

CARDINALS = {
	NORTH = "NORTH",
	EAST = "EAST",
	SOUTH = "SOUTH",
	WEST = "WEST",
}

SCANS = {
	["UP"] = up,
	["DOWN"] = down,
	["FORWARD"] = forward,
	["LEFT"] = left,
	["RIGHT"] = right,
}

