package.path = package.path .. ";src/?.lua"
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "gamelogic.TWApi"

local function main()
	local app = cc.Application:getInstance()
	local target = app:getTargetPlatform()
	
		require('mobdebug').start("127.0.0.1",8172)
	

	local preInitLIst = TWRequire("preInitList")
	for _,name in pairs(preInitLIst) do
		TWRequire(name)
	end

	TWRequire("AppPrecedure")
	PostLoadLua()

	local SearchPathList = TWRequire("SearchPathList")
	for _,searchPath in ipairs(SearchPathList) do
		cc.FileUtils:getInstance():addSearchPath(searchPath)
	end
	
	require "gamelogic.RootManager"
  	gRootManager:ChangeScene("MainScene")
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    LogError(msg)
end

--require("test")