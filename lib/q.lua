function q()
	local queue = { 
			["top"] = 0,
			["bottom"] = 1,
		}
	return queue
end

function qIsEmpty(q)
	if q["bottom"] > q["top"] then
		return true
	end
	return false
end

function addQ(item,q)
	q["top"] = q["top"] + 1
	q[q["top"]] = item
end

function popQ(q)
	if not qIsEmpty(q) then
		item = q[q["bottom"]]
		q["bottom"] = q["bottom"] + 1
		return item
	end
end

function printQ(q)
	for i,v in pairs(q) do
		if not i == "bottom" and not i == "top" then
			print(i,v)
		end
	end
end

