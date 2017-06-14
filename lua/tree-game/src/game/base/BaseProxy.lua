--[[--



]]

local BaseProxy = class("BaseProxy")


function BaseProxy:ctor()
	self._msgs = {}
	self:init()
end


function BaseProxy:init()


end

function BaseProxy:add(msgId_,callBack_)
	mgr.NetMgr:add(msgId_,handler(self,callBack_))
end

function BaseProxy:send(msgId_,data_)
	if data_ == nil then data_ = {} end
	mgr.NetMgr:send(msgId_,data_)
end

function BaseProxy:wait( msgId_, ignore_)
	-- body
	if msgId_ then 
		mgr.NetMgr:wait(msgId_, ignore_)
	end 
end

function BaseProxy:isConnect()
	return mgr.NetMgr.isConnect
end



return BaseProxy