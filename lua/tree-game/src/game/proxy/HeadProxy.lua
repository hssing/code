local HeadProxy = class("HeadProxy",base.BaseProxy)

function HeadProxy:init()

  self:add(511005,self.returnHead)

  self.vipIcon = 0
end


function HeadProxy:reqGetHead(career_)
  debugprint("career_:"..career_)
  self.vipIcon = career_
  self:send(111005,{vipIcon=career_})
end


function HeadProxy:returnHead(data_)
  if data_.status == 0 then
	local view = mgr.ViewMgr:get(_viewname.ROLE)
	if view then 
		cache.Player:setHead(self.vipIcon)
		local data =cache.Player:getRoleInfo() 
		view:setHead(data.vipIcon,data.sex)
	end 
  end
end

return HeadProxy