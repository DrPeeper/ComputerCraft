VARS = {
	QUEUE = 1,
	TOP = 2,
	BOTTOM = 3,
	SIZE = 4,
	CAPACITY = 5
}

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
	if q[VARS.SIZE] == 0 then -- if size is equal to zero
		return true
	end
	return false
end

function isFull(q)
	if q[VARS.SIZE] == q[VARS.CAPACITY] then -- if size is equal to capacity
		return true
	end
	return false
end

function pop(q)
	if not isEmpty(q) then
		tmp = q[VARS.QUEUE][VARS.TOP] -- tmp equals the value at queue index top
		q[VARS.TOP] = 1 + q[VARS.TOP] % q[VARS.CAPACITY] -- top = top + 1 % capacity
		q[VARS.SIZE] = q[VARS.SIZE] - 1 -- size = size - 1
		return tmp
	end
	return nil
end

function enq(q, item)
	if not isFull(q) then
		q[VARS.BOTTOM] = 1 + q[VARS.BOTTOM] % q[VARS.CAPACITY] -- bottom = bottom + one % capacity
		q[VARS.QUEUE][VARS.BOTTOM] = item -- item is stored in queue at index botom
		q[VARS.SIZE] = q[VARS.SIZE] + 1 -- size = size + 1
		return true
	end
	return false
end
