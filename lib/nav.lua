os.loadAPI("/lib/fuel.lua")

-- navigation variables
dirInputs = {

	[turtle.turnLeft] = 1,
	[turtle.turnRight] = -1,
}

directions = {

	["north"] = 0,
	["west"] = 1,
	["south"] = 2,
	["east"] = 3,
	[0] = "north",
	[1] = "west",
	[2] = "south",
	[3] = "east",
}

mvInputs = {

	[turtle.forward] = {
			
		["north"] = {0,1,0},
		["west"] = {-1,0,0},
		["south"] = {0,-1,0},
		["east"] = {1,0,0},
	},

	[turtle.back] = {
			
		["north"] = {0,-1,0},
		["west"] = {1,0,0},
		["south"] = {0,1,0},
		["east"] = {-1,0,0},
	},

	[turtle.up] = {
		
		["north"] = {0,0,1},
		["west"] = {0,0,1},
		["south"] = {0,0,1},
		["east"] = {0,0,1},
	},

	[turtle.down] = {
		
		["north"] = {0,0,-1},
		["west"] = {0,0,-1},
		["south"] = {0,0,-1},
		["east"] = {0,0,-1},
	},
}

-- initialize starting position
function init()
	direction = "north"
	pos = {0,0,0}
end

function pos()
	return pos
end

function direction()
	return direction
end

-- record the given turn
function rTurn(cmd)
	if dirInputs[cmd] ~= nil then
		direction = directions[directions.direction + dirInputs[cmd] % 4]
	end
end

-- record movement
function rMove(cmd)
	if mvInputs[cmd] ~= nil then
		for i,v in pairs(pos) do
			pos[i] = v + mvInputs[cmd].direction[i]
		end
	end
end

-- record turn or movement
function rCmd(cmd)
	if mvInputs[cmd] ~= nil then
		rMove(cmd)
	else
		rTurn(cmd)
	end
end
-- do turn or movement
-- returns success if movement was possible
function nav(cmd)
	fuel.refuel()
	if cmd() then
		rCmd(cmd)
		return true
	end
	return false
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

