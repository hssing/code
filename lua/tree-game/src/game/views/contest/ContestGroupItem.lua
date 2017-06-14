--[[
	ContestGroupItem
]]

local ContestGroupItem = class("ContestGroupItem",function(  )
	return ccui.Widget:create()
end)

function ContestGroupItem:init(widget)
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	self.lab_name = self.view:getChildByName("Text_1")
	self.lab_power = self.view:getChildByName("Text_1_0")

	local btn = self.view:getChildByName("Button_2_0_20")
	btn:addTouchEventListener(handler(self, self.onBtnSee))

end

function ContestGroupItem:setData(data,idx)
	-- body

	self.data = data
	self.lab_name:setString(data.roleName)
	self.lab_power:setString(data.power)
end

function ContestGroupItem:onBtnSee(sender_,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		
		debugprint("阵容对比")

		self.Parent:sendDuibi(self.data.roleId) 
		
		
	end 
end



return ContestGroupItem

