-- select a block with given id
function select(id)
	for i = 1,16 do
		item = turtle.getItemDetail(i)
		if item.id == id
			turtle.select(i)
			return true
		end
	end
end
