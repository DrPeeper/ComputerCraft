-- select a block with given name
function selectByName(name)
   for i = 1,16 do
      item = turtle.getItemDetail(i)
      if item ~= nil and item.name == name then
	 turtle.select(i)
	 return true
      end
   end
   return false
end

-- select the first item in inv from table
function selectFromTable(table)
   for i = 1,16 do
      item = turtle.getItemDetail(i)
      if item ~=nil and table[item.name] ~= nil then
	 turtle.select(i)
	 return true
      end
   end
   return false
end

-- checks if every inventory slot has a block in it
-- NOTE: does not care if any slots still have space remainign
function isFull()
   for i = 1,16 do
      item = turtle.getItemDetail(i)
      if item == nil then
	 return false
      end
   end
   return true
end

-- drop all items from inventory execpt those in provided table
function dropAllExcept(keep)
   initial_slot = turtle.getSelectedSlot()
   for i = 1,16 do
      item = turtle.getItemDetail(i)
      if item ~= nil and keep[item.name] == nil then
	 -- found item not in keep
	 turtle.select(i)
	 turtle.drop()
      end
   end
   -- reselect initial slot
   turtle.select(initial_slot)
end

-- deposits all of a certain block into a chest
-- NOTE: turtle must already be facing chest
function depositBlock(name)
   initial_slot = turtle.getSelectedSlot()
   while selectByName(name) do
      turtle.drop()
   end
   turtle.select(initial_slot)
end

-- condense turtle inventory
function restack()
   local initial_slot = turtle.getSelectedSlot()
   local inv = {}
   for i = 1,16 do
      local item = turtle.getItemDetail(i)
      if item ~= nil then
	 if inv[item.name] ~= nil then
	    -- stack with space already in inventory
	    turtle.select(i)
	    turtle.transferTo(inv[item.name]["slot"])
	    local prev_space = turtle.getItemSpace(inv[item.name]["slot"])
	    if prev_space > 0 then
	       -- previous stack still has space remaining
	       inv[item.name]["space"] = prev_space
	    elseif turtle.getItemCount(i) > 0 then
	       -- previous stack full, selected slot not empty
	       inv[item.name] = {["space"]=turtle.getItemSpace(i), ["slot"]=i}
	    else
	       -- previous stack full, selected slot empty
	       inv[item.name] = nil
	    end
	 elseif turtle.getItemSpace(i) > 0 then
	    -- add item to inv if not there and still has space
	    inv[item.name] = {["space"]=turtle.getItemSpace(i), ["slot"]=i}
	 end
      end
   end
   turtle.select(initial_slot)
end

-- returns a table representing the turtle's inventory
function invTable()
   local inv = {}
   for i = 1,16 do
      local item = turtle.getItemDetail(i)
      inv[i] = item
   end
   return inv
end

-- TODO: make multidirectional
function depositSome(toDeposit, count, down)
   local remaining = count
   while remaining > 0 do
      -- select item
      if not selectFromTable(toDeposit) then
	 return count - remaining
      end

      -- deposit
      item = turtle.getItemDetail()
      if item.count >= remaining then
	 if down then
	    turtle.dropDown(remaining)
	 else
	    turtle.dropUp(remaining)
	 end
	 remaining = 0
      else
	 if down then
	    turtle.dropDown()
	 else
	    turtle.dropUp()
	 end
	 remaining = remaining - item.count
      end
   end
   return count - remaining  -- should be zero here
end
