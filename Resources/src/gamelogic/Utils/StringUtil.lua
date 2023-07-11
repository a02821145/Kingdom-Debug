local StringUtil = class("StringUtil")

function StringUtil:initLang()

	if self._curLang == "zh" then
		self._langTab = _GModel.lang_zh
	else
		self._langTab = _GModel.lang_en
	end
end

function StringUtil:fill(s, ...)
    if s == nil then
        return ""
    end
    local o = tostring(s)
    for i = 1, select("#", ...) do
	-- o = o:gsub("{"..(i-1).."}", tostring((select(i, ...))))
       -- 原来的接口如果传递的参数中含有 "%" 会出现问题，因为gsub是按正则来处理替换，%是lua正则中的转意字符
       o = string.gsub(o, "{"..(i-1).."}", tostring((select(i, ...))),1)
    end
    return o
end

--获取路径
function StringUtil:getPathFileName(filename)
	return string.match(filename, "(.+)/[^/]*%.%w+$")
end

--获取文件名
function StringUtil:getFileName(str)
    return string.match(str, ".+/([^/]*%.%w+)$")
end

--获取后缀名
function StringUtil:getExtension(str)
    return str:match(".+%.(%w+)$")
end

--去除后缀名
function StringUtil:stripExtension(filename)
	local idx = filename:match(".+()%.%w+$")
	if(idx) then
		return filename:sub(1, idx-1)
	else
		return filename
	end
end

function StringUtil:getLanguageStringByKey(key,...)
	-- body
	if not string.find(tostring(key),"@") then 
		return self:fill(key,...) 
	end

	if not self._langTab then
		self:initLang()
	end

	local str = self._langTab[key]
	if not str then
		LogWarn("not find lang by key %s",key)
		return key 
	end

	return self:fill(str,...)
end

function StringUtil:setCurrentLang(lang)
	self._curLang = lang

	self:initLang()
end

function StringUtil:getCurrentLang()
	return self._curLang
end

function StringUtil:isChinese()
	return self._curLang == "zh"
end

function _Lang(key,...)
	return StringUtil:getLanguageStringByKey(key,...)
end

return StringUtil