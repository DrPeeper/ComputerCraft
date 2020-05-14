function init(capacity)
	capacity = capacity or 10
	top = 0
	bottom = capacity - 1
	size = 0
	queue = {}
	-- size, capacity, rear, top
	q = {queue, top, bottom, size, capacity}
	return q
end

function isEmpty(q)
	if q[4] == 0 then -- if size is equal to zero
		return true
	end
	return false
end

function isFull(q)
	if q[4] == q[5] then -- if size is equal to capacity
		return true
	end
	return false
end

function pop(q)
	if not isEmpty(q) then
		tmp = q[1][q[2]] -- tmp equals the value at queue index top
		q[2] = 1 + q[2] % q[5] -- top = top + 1 % capacity
		q[4] = q[4] - 1 -- size = size - 1
		return tmp
	end
	return nil
end

function enq(q, item)
	if not isFull(q) then
		q[3] = 1 + q[3] % q[5] -- bottom = bottom + one % capacity
		q[1][q[3]] = item -- item is stored in queue at index botom
		q[4] = q[4] + 1 -- size = size + 1
	end
end
