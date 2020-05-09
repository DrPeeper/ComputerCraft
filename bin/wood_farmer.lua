os.loadAPI("/lib/inv.lua")
os.loadAPI("/lib/fuel.lua")

LOG = "minecraft:oak_log"
SAPLING = "minecraft:oak_sapling"
CARRY = {
   [LOG] = true,
   [SAPLING] = true,
}
SLEEP_TIME = 300

-- add any potential fuel source to VALUABLES
for k,v in pairs(fuel.FUEL) do CARRY[k] = v end

function nextTree()
   -- move to next tree
   turtle.turnRight()
   for i = 1,2 do
      fuel.refuel()
      if not turtle.forward() then
	 return false
      end
   end
   turtle.turnLeft()
   return true
end

function plant()
   if inv.selectByName(SAPLING) then
      turtle.place()
   else
      print("out of saplings")
   end
end

function fellTree()
   -- mine first block
   turtle.dig()
   turtle.forward()

   -- chop tree
   while true do
      local success, lookingAt = turtle.inspectUp()
      if not success or lookingAt.name ~= LOG then
	 break
      end
      turtle.digUp()
      fuel.refuel()
      turtle.up()
   end

   -- go back down
   while turtle.down() do
      fuel.refuel()
   end

   turtle.back()
end

function harvestPass()
   -- harvest trees
   while true do
      -- start facing a tree on the left side of the farm
      local success, lookingAt = turtle.inspect()
      if success == false then
	 error("turtle placed incorrectly")
      end

      -- chop tree if ready
      if lookingAt.name == LOG then
	 fellTree()
	 plant()
      end
      if not nextTree() then
	 -- reached end of row
	 break
      end
   end

   -- return to starting position
   turtle.turnLeft()
   turtle.turnLeft()
   while turtle.forward() do
      fuel.refuel()
   end

   -- face first tree to prepare for another pass
   turtle.turnRight()
end

function restock()
   -- go down to chest
   local down = 0
   while turtle.down() do
      down = down + 1
      fuel.refuel()
   end

   -- get stuff
   while turtle.suckDown() do
      if inv.isFull() then
	 inv.dropAllExcept(CARRY)
	 inv.restack()
      end
   end

   -- go back up
   while down > 0 do
      if turtle.up() then down = down - 1 end
   end
end


-- drop logs into chest
function dropOff()
   turtle.turnLeft()
   turtle.turnLeft()
   local success, lookingAt = turtle.inspect()
   if success and lookingAt.name == "minecraft:chest" then
      inv.depositBlock(LOG)
   end
   turtle.turnLeft()
   turtle.turnLeft()
end


print("Lumberjack protocol intializing...")
fuel.refuel()
while true do
   local success, lookingAt = turtle.inspect()
   if success and lookingAt.name == LOG then
      print("Harvesting")
      restock()
      harvestPass()
      dropOff()
      print("Harvest completed. Sleeping.")
   end
   os.sleep(SLEEP_TIME)
end
