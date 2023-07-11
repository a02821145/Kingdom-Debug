local common = class("common")

function common:table_merge(...)
	local tb = {}
	for i = 1, select("#", ...) do
		table.foreach((select(i, ...)), function(k, v)
			tb[k] = v
		end)
	end
	return tb
end

function common:table_merge_by_order(...)
    local tb = {}
    for i = 1, select("#", ...) do
        table.foreach((select(i, ...)), function(k, v)
            tb[#tb+1] = v
        end)
    end
    return tb
end

function common:table_count(tb)
	local c = 0;
	for _, _ in pairs(tb) do 
        c = c + 1
    end
	return c;
end

function common:table_simple_copy(tb)
	-- body
	local t = {}

	for k,v in pairs(tb) do
		if type(v) == "table" then
			t[k] = self:table_simple_copy(v)
		else
			t[k] = v
		end	
	end

	return t
end

return common