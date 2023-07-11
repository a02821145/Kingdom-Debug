_GModel = {}

local function GetPathByFilename(filename)
	local filePathList = require('filePathList')
	local filePath = filePathList[filename]
	local isFileExist = not not filePath
	return isFileExist,filePath
end 

function TWRequire(filename)
	local isFileExist,filePath = GetPathByFilename(filename)
	local mod

	if isFileExist then
		mod = require(filePath)
	else
		mod = require(filename)
	end

	if _GModel then
		rawset(_GModel,filename,mod)
	end

	return mod
end

function _Log(log,logType)
    if log == nil then return end
    if logType == nil then logType = RA_DEBUG end
    
    if logType == LogLevel.LL_ERROR then
	    local traceback = debug.traceback()
	    log = log..traceback
	end
    LogApp(log,logType)
end

function Log(fmt, ...)
    _Log(string.format(fmt, ...), LogLevel.LL_NONE)
end

function LogInfo(fmt, ...)
    _Log(string.format(fmt, ...), LogLevel.LL_INFO)
end

function LogWarn(fmt, ...)
    _Log(string.format(fmt, ...), LogLevel.LL_WARNING)
end

function LogError(fmt,...)
    _Log(string.format(fmt, ...), LogLevel.LL_ERROR)
end

function LogAction(fmt,...)
    _Log(string.format(fmt, ...), LogLevel.LL_ACTION)
end

function LogVerbose(fmt,...)
    _Log(string.format(fmt, ...), LogLevel.LL_VERBOSE)
end