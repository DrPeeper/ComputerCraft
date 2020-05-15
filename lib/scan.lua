os.loadAPI("lib/nav.lua")

function scanUp()
	return turtle.inspectUp()
end
function scan()
	return turtle.inspect()
end
function scanDown()
	return turtle.inspectDown()
end
function scanTo(axis, direction)
	nav.turnTo(axis, direction)
	return turtle.inspect()
end
