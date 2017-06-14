
local BaseConf = class("BaseConf")

--
function BaseConf:ctor()
	self:init()
end

function BaseConf:init()


end
function BaseConf:Error(message)
	debugprint(self.__cname.."(配置表)没有这个配置:"..message)
end



return BaseConf