-- select a block with given id
function selectByName(name)
	for i = 1,16 do
		item = turtle.getItemDetail(i)
		if item ~= nil and item.name == name then
			turtle.select(i)
			return true
		end
	end
end
