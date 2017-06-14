--[[
	GuildWorldItem --世界排行的item
]]
local GuildWorldItem = class("GuildShopItem",function(  )
	return ccui.Widget:create()
end)

function GuildWorldItem:init(widget)
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	self._frame = self.view:getChildByName("Image_3_7")
	self._frame:setTouchEnabled(true)
	self._icon =   self._frame:getChildByName("Image_3_7_0")
	--排名 
	self.img_rank = self.view:getChildByName("Image_2_3")
	self.rank = self.view:getChildByName("AtlasLabel_5_4")
	--等级
	self.lv =  self.view:getChildByName("AtlasLabel_4_2") 
	self.guild_name = self.view:getChildByName("Text_4_2")

	self.leader_name = self.view:getChildByName("Text_32_10")
	self.member_num = self.view:getChildByName("Text_35_14")
	self.jidu = self.view:getChildByName("Text_33_12")
end

function GuildWorldItem:setData(data,idx)
	-- body
	
end

return GuildWorldItem