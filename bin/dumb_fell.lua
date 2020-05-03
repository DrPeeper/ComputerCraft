os.loadAPI("/lib/fuel.lua")

-- place facing the bottom of a tree to start
fuel.refuel()
turtle.dig()
turtle.forward()

-- dig up as long as there is a block above
while turtle.digUp() do
	fuel.refuel()
	turtle.up()
end

-- go down until you hit the ground
while turtle.down() do
	fuel.refuel()
end


