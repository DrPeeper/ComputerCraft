os.loadAPI("lib/nav.lua")

DIRS = {
	NORTH = {2,1},
	SOUTH = {2,-2},
	WEST = {1,-1},
	EAST = {1,1}
}

function left()
	if nav.turnLeft() then
		return turtle.inspect()
	end
end

function right()
	if nav.turnRight() then
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
	nav.turnTo(axis, direction)
	return turtle.inspect()
end


SCANS = {
	UP = up,
	DOWN = down,
	FORWARD = forward,
	LEFT = left,
	RIGHT = right,
	TO = to
}

