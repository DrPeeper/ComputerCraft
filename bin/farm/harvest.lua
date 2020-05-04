os.loadAPI("/lib/inv.lua")

-- takes prefered seed name
-- if prefered seed not found plants any seed
function plant(seed)
	if not inv.selectByTable(inv.SEEDS) and if not inv.selectByName(seed) then
		print("out of seeds:(")
	else
		turtle.place()
	end
end

function harvest()	
	-- check if crop can be harvested
	crop = inv.inspectWithTable(inv.CROPS)
	if  crop ~= nil then
		turtle.dig()
		plant(inv.CROPS[crop.name])
end

