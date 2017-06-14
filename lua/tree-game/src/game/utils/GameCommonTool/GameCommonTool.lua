local GameCommonTool = class("GameCommonTool")


function GameCommonTool:initPlatform()
		if not self._instance then
				--print("**************************"..device.platform)
				if device.platform == "ios" then --ios
						self._instance = require("game.utils.GameCommonTool.GameCommonTool_ios").new()
				elseif device.platform == "android" then --android
						self._instance = require("game.utils.GameCommonTool.GameCommonTool_android").new()
				end
		end
end

--獲取版本
function GameCommonTool:getProjectVersion()
	self:initPlatform()
	if self._instance then
			local ver = self._instance:getProjectVersion()
			print("游戏版本号："..ver)
			return ver
	else
			print("default project version")
			return "1.0.1"
	end
end

return GameCommonTool