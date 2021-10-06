
--circular buffer of Lua values
--Written by Cosmin Apreutesei. Public domain.

local function new(size)

	local head = 1
	local tail = 1
	local n = 0
	local t = {}
	local q = {}

	function q:size() return size end
	function q:count() return n end

	function q:push_grow(v)
		assert(v ~= nil)
		if n >= size then
			size = size + 1
		end
		t[head] = v
		n = n + 1
		head = (head % size) + 1
		return true
	end

	function q:push(v)
		assert(v ~= nil)
		if n >= size then
			return nil, 'queue full'
		end
		t[head] = v
		n = n + 1
		head = (head % size) + 1
		return true
	end

	function q:pop()
		if n == 0 then
			return nil
		end
		local v = t[tail]
		t[tail] = false
		tail = (tail % size) + 1
		n = n - 1
		return v
	end

	function q:peek()
		if n == 0 then
			return nil
		end
		return t[tail]
	end

	function q:items()
		local i = 0
		return function()
			if i >= n then
				return nil
			end
			i = i + 1
			return t[(tail + i) % size]
		end
	end

	return q
end

return {new = new}
