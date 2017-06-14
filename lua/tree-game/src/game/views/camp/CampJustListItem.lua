

local CampJustListItem = class("CampJustListItem",function(  )
	return ccui.Widget:create()
end)

function CampJustListItem:init(param)
	-- body
	self.Parent=param
	self.view=param:getCloneItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	self.lab_name = self.view:getChildByName("Text_3")
	self.lab_power = self.view:getChildByName("Text_3_0")
end

function CampJustListItem:setData( data,color )
	-- body
	self.data = data
	self.lab_name:setString(data.roleName)
	if data.power > 10000 then 
		self.lab_power:setString(string.format("%.1f",data.power/10000)..res.str.SYS_DEC7 )
	else
		self.lab_power:setString(data.power)
	end

	self:setTextColor(color)
end

function CampJustListItem:setTextColor(color)
	-- body
	if self.data.roleId.key == cache.Player:getRoleInfo().roleId.key then 
		self.lab_name:setColor(COLOR[2])
	else
		self.lab_name:setColor(color)
	end
	
end

return CampJustListItem