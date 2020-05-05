os.loadAPI("/lib/inv.lua")

SEEDS = {
	["minecraft:wheat_seeds"]=7,
	["minecraft:potato"]=7,
}

CROPS = {
	["minecraft:wheat"]="minecraft:wheat_seeds",
	["minecraft:potato"]="minecraft:potato",
}

-- takes prefered seed name
-- if prefered seed not found plants any seed
function plant(seed)
	if not inv.selectFromTable(SEEDS) and not inv.selectByName(seed) then
		print("out of seeds:(")
	else
		turtle.place()
	end
end

function harvest()
	crop = inv.inspectWithTable(CROPS)
	turtle.dig()
	if crop ~= nil then
		plant(CROPS[crop.name])
	else
		plant()
	end

end

