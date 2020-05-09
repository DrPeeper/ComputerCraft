os.loadAPI("/lib/fuel.lua")

<<<<<<< HEAD
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

north = {0,1,0}
west = {-1,0,0}
south = {0,-1,0}
east = {1,0,0}

cardinalCoordinates = {
	[north] = "north",
	[west] = "west",
	[south] = "south",
	[east] = "east",
}

-- initialize starting position
-- DoNt FoRgEt
function init()
	direction = "north"
	pos = {0,0,0}
end

-- getter functions
function getPos()
	return pos
end

function getDirection()
	return direction
end

-- record turn or movement
function rCmd(cmd)
	-- if movement command
	if mvInputs[cmd] then
		for i,v in pairs(pos)do
			pos[i] = v + mvInputs[cmd][direction][i]
		end
	end
	-- if turn command
	if dirInputs[cmd] then
		direction = directions[(directions[direction] + dirInputs[cmd]) % 4]

	end
end

-- complete turn or movement
-- given turtle movement or turn command
-- returns success if movement or turn was possible
function nav(cmd)
	if mvInputs[cmd] or dirInputs[cmd] then
		fuel.refuel()
		if cmd() then
			rCmd(cmd)
			return true
		end
	end
	return false
end

-- wrapper turtle move/turn functions
function turnLeft()
	return nav(turtle.turnLeft)
end

function turnRight()
	return nav(turtle.turnRight)
end

function forward()
	return nav(turtle.forward)
end

function back()
	return nav(turtle.back)
end

function up()
	return nav(turtle.up)
end

function down()
	return nav(turtle.down)
end

-- turn around
function turnAround()
	if turnLeft() then
		if turnLeft() then
			return true
		else
			return turnRight() and turnRight() and turnRight()
		end
	end
end

-- move to given direction
function turnTo(destDir)
	if directions[destDir] ~= nil then
		if math.abs(directions[direction] - directions[destDir]) == 2 then
			return turnAround()
		end
		if directions[(directions[direction] + 1) % 4] == destDir then
			return nav(turtle.turnLeft)
		end
		return nav(turtle.turnRight)

	end
end

-- move to the given coordinates destination
-- can only be one value (1 or -1) on one axis
function move(dest)
	tmp = {0,0,0}
	for i,v in ipairs(dest) do
		tmp[] = v * -1
	end
	if cardinalCoordinates[direction] == tmp 

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
