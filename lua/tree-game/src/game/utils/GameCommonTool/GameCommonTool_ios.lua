local luaoc = require("cocos.cocos2d.luaoc")
local GameCommonTool_ios = class("GameCommonTool_ios")

function GameCommonTool_ios:getProjectVersion()
	--local ok,ret = luaoc.callStaticMethod("GameCommonTool_ios","getGameVersion",nil)

	--return ret.version
	return game.GameHelper:getInstance():getProjVersion()
	-- function luaoc.callStaticMethod(className, methodName, args)
end

function GameCommonTool_ios:addLocalNofication(time_,content_,openTips_,repeatType_)
	assert(time_ ~= nil,"发闹钟的时间不能为NIL")
	local param = {}
	param.time = time_
	param.content = content_ or ""
	param.open = openTips_ or ""
	param.type = repeatType_ or 0
	luaoc.callStaticMethod("GameCommonTool_ios","setLocalNofication",param)
	
end


return GameCommonTool_ios