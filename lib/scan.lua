os.loadAPI("lib/move.lua")


function left()
	if move.turnLeft() then
		return turtle.inspect()
	end
end

function right()
	if move.turnRight() then
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
	move.turnTo(axis, direction)
	return turtle.inspect()
end


SCANS = {
	UP = up,
	DOWN = down,
	FORWARD = forward,
	LEFT = left,
	RIGHT = right,
	TO = to,
	NORTH = to(2,1),
	WEST = to(1,-1),
	SOUTH = to(2,-1),
	EAST = to(1,1)
}
