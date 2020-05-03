-- TODO: add blaze rods, bamboo, kelp, etc.
FUEL = {
	["minecraft:coal"]=80,
	["minecraft:charcoal"]=80,
}

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
