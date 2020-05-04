-- TODO: add blaze rods, bamboo, kelp, etc.
FUEL = {
	["minecraft:coal"]=80,
	["minecraft:charcoal"]=80,
	["minecraft:oak_planks"]=15,
}

SEEDS = {
	["minecraft:wheat_seeds"]=7,
	["minecraft:potatoes"]=7,
}

CROPS = {
	["minecraft:wheat"]="minecraft:wheat_seeds",
	["minecraft:potatoes"]="minecraft:potatoes",
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

-- insepect the item in front and compare to table
function inspectWithTable(table)
	local success, lookingAt = turtle.inspect()
	
	if lookingAt ~= nil and table[lookingAt.name] ~= nil then
		return lookingAt
	else
		return nil
	end
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
