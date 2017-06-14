--[[
	救援结束 弹出框
]]

local Dig_HelpOver = class("Dig_HelpOver",base.BaseView)

function Dig_HelpOver:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	G_FitScreen(self,"Image_1")

	local panel = self.view:getChildByName("Panel_1")
	panel:addTouchEventListener(handler(self, self.onbtnclose))

	self.lab_friend = panel:getChildByName("Text_1") 
	self.lab_self = panel:getChildByName("Text_1_0") 
end

function Dig_HelpOver:setData(win )
	-- body

	local t = 0
	--print("win = "..win)
	local sys = conf.Sys:getValue("dig_help_add")
	if tonumber(win) == 1 then 
		self.lab_friend:setString("+"..sys[2].."%")
		self.lab_self:setString("+"..sys[1].."%")
	else
		t = 2
		self.lab_friend:setString("+"..sys[4].."%")
		self.lab_self:setString("+"..sys[3].."%")
		--self.lab_friend:setString("5%")
		--self.lab_self:setString("5%")
	end 

	local a =  mgr.BoneLoad:loadArmature(404840,t+1)
	local b =  mgr.BoneLoad:loadArmature(404840,t)

	a:setPositionX(display.cx)
	b:setPositionX(display.cx)

	a:setPositionY(self.lab_friend:getPositionY() + 200)
	b:setPositionY(self.lab_friend:getPositionY() + 200)

	
	a:addTo(self.view)
	b:addTo(self.view)
end

function Dig_HelpOver:onbtnclose(sender,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function Dig_HelpOver:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Dig_HelpOver