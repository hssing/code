--[[
	文件岛 内部
]]
local DigOneFrame = class("DigOneFrame",base.BaseView)

function DigOneFrame:ctor()
	-- body
	self.data = {}

	self.openview = nil  
end

function DigOneFrame:init()
	-- body
	self.showtype=view_show_type.TIPS
	self.view=self:addSelfView()

	local btn_close = self.view:getChildByName("Panel_3"):getChildByName("Button_10")
	btn_close:addTouchEventListener(handler(self, self.closeview))

	self.img_name = self.view:getChildByName("Panel_3"):getChildByName("Image_30")
end

function DigOneFrame:openView()
	-- body
	if self.openview then 
		self.openview:closeSelfView()
		self.openview = nil 
	end 
	local status = self.data.state 
	if status == 0 then --打开设置
		self.openview = mgr.ViewMgr:showView(_viewname.DIG_SET)
		self.openview:setData(self.data)
	elseif status == 11 or status == 12 or status == 13 or status == 14 or status == 2 or status == 3 then ----打开收货
		self.openview = mgr.ViewMgr:showView(_viewname.DIG_PROGRESS)
		self.openview:setData(self.isself,self.data,self.roleId)
	else--打开挑战
		self.openview = mgr.ViewMgr:showView(_viewname.DIG_CHALLENGE)
		self.openview:setData(self.data)
	end 
end

function DigOneFrame:setData(data_,isself,paramroleId)
	-- body
	cache.Dig:keepCurDaoId(data_.daoId)--为了战斗回来打开
	self.roleId = paramroleId
	self.data = data_
	self.isself = isself
	--设置岛的名字
	self.img_name:ignoreContentAdaptWithSize(true)
	self.img_name:loadTexture(res.font.DIG_DAO[data_.daoId])
	--按类型打开界面
	self:openView()
end

function DigOneFrame:closeview(sender_,eventtype)
	-- body
	if  eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

--挑战胜利获得物品界面
function DigOneFrame:itemTipsView()
	-- body
	debugprint("获得物品奖励弹窗")
end

function DigOneFrame:onCloseSelfView()
	-- body
	if self.openview then 
		self.openview:onCloseSelfView()
	end 
	self:closeSelfView()
end

return DigOneFrame