--[[
	救援结束 弹出框
]]

local Dig_HelpOver = class("Dig_HelpOver",base.BaseView)

function Dig_HelpOver:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	G_FitScreen(self,"Image_1")

	local panle = self.view:getChildByName("Panel_1")
	panle:addTouchEventListener(handler(self, self.onpanleCallBack))

	self.lab_friend = panle:getChildByName("Text_1")
	self.lab_self = panle:getChildByName("Text_1_0")

end


function Dig_HelpOver:setData(flag)
	-- body
	local a1 ,a2
	if flag == 1 then --赢了
		a1 =  mgr.BoneLoad:loadArmature(404840,1)
		a2 =  mgr.BoneLoad:loadArmature(404840,0) 

		self.lab_friend:setString("10%")
		self.lab_self:setString("10%")
	else
		a1 =  mgr.BoneLoad:loadArmature(404840,3)
		a2 =  mgr.BoneLoad:loadArmature(404840,2)

		self.lab_friend:setString("5%")
		self.lab_self:setString("5%")
	end 

	a1:setPositionX(display.cx)
	a1:setPositionY(self.lab_friend:getPositionY()+200)

	a2:setPositionX(display.cx)
	a2:setPositionY(self.lab_friend:getPositionY()+200)

	a1:addTo(self.view)
	a2:addTo(self.view)
end


function Dig_HelpOver:onpanleCallBack( sender_, eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function Dig_HelpOver:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Dig_HelpOver