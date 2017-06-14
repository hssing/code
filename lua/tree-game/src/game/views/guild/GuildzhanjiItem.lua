--GuildzhanjiItem
--[[
	GuildzhanjiItem 成员战绩
]]
local GuildzhanjiItem = class("GuildzhanjiItem",function(  )
	return ccui.Widget:create()
end)

function GuildzhanjiItem:init(widget)
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	self._frame = self.view:getChildByName("Image_6_29_37")
	self._frame:setTouchEnabled(true)
	self._icon =   self._frame:getChildByName("Image_7_28_36")
	--排名 
	self.imgRank = self.view:getChildByName("Image_2")
	self.lab_rank = self.view:getChildByName("AtlasLabel_5")
	--等级
	self.lab_name =  self.view:getChildByName("Text_1_25_35") 
	local img_di = self.view:getChildByName("Image_8_31_39")
	self.lab_day_count = img_di:getChildByName("Text_1_0_1_31_41")
	self.lab_maxhurt = img_di:getChildByName("Text_1_0_0_0_33_43")

	self.vip = self.view:getChildByName("Image_4")
end

function GuildzhanjiItem:setData(data,idx)
	-- body
	self.data = data

	self.imgRank:setVisible(false)
	self.lab_rank:setVisible(false)
	if data.rank <= 3 then 
		self.imgRank:setVisible(true)
		self.imgRank:loadTexture(res.icon.RANK[data.rank])
	else
		self.lab_rank:setVisible(true)
		self.lab_rank:setString(data.rank)
	end 
	local temp = G_Split_Back(data.roleIcon)
	self._frame:loadTexture(temp.frame_img)
	self._icon:ignoreContentAdaptWithSize(true)
	self._icon:setScale(0.8)
	self._icon:loadTexture(temp.icon_img)
	if self._frame:getChildByName("dw") then 
		self._frame:getChildByName("dw"):removeSelf()
	end
	if temp.dw > temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setName("dw")
		spr:setPosition(temp.dw_pos)
		spr:addTo(self._frame)
	end

	self.lab_name:setString(data.roleName)
	self.lab_day_count:setString(data.todayCount)
	self.lab_maxhurt:setString(data.hitStr)

	self.vip:ignoreContentAdaptWithSize(true)
	self.vip:loadTexture(res.icon.VIP_LV[data.vipLevel])
end

return GuildzhanjiItem