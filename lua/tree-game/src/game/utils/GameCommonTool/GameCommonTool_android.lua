local GameCommonTool_android = class("GameCommonTool_android")

--[[function GameCommonTool_android:getProjectVersion()
	local className = "org/cocos2dx/lua/AppActivity"
	local methodName= "getVersion"
	local sig = "()Ljava/lang/String;"
	local ok,ret = 	luaj.callStaticMethod(className,methodName,{},sig)
	return ret
end]]--

function GameCommonTool_android:getProjectVersion()
	  return game.GameHelper:getInstance():getProjVersion()
end

return GameCommonTool_android