local EquipmentMessageWidget = class("EquipmentMessageWidget",function ( ... )
	-- body
	return ccui.Widget:create()
end)



function EquipmentMessageWidget:ctor(widget)
	self:init(widget)
end
function EquipmentMessageWidget:init(widget)
	self.view=widget:clone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self:setAnchorPoint(cc.p(0,0))
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.Img = self.view:getChildByName("Image_13_44")

	self.ImageFrame = self.view:getChildByName("Image_12_42")

	self.TableName=self.view:getChildByName("Text_32"):setVisible(false)

	self.lv = self.view:getChildByName("Image_lv"):getChildByName("Text_lv_13_2")

end
function EquipmentMessageWidget:setData(data)
	self.data = data
	local Quality=conf.Item:getItemQuality(data.mId)
	local itemSrc=conf.Item:getSrc(data.mId,data.propertys)
	local path=mgr.PathMgr.getItemImagePath(itemSrc)
	local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
	local name = conf.Item:getName(data.mId,data.propertys)

	self.ImageFrame:loadTexture(res.btn.FRAME[Quality])
	self.Img:ignoreContentAdaptWithSize(true)
	self.Img:loadTexture(path)

	self.lv:getParent():setVisible(false)
	local text = 0
	if data.propertys then 
		text = mgr.ConfMgr.getItemQhLV(data.propertys)
		self.lv:getParent():setVisible(true)
	end 
	self.lv:setString(text)

	local color = data.color
	if not color then 
		color =  COLOR[Quality]
	end 

	self:setName(name,color)
end
function EquipmentMessageWidget:getData(  )
	-- body
	return self.data
end
function EquipmentMessageWidget:setName( name,color)
	self.TableName:setString(name)
	self.TableName:setColor(color)
end
function EquipmentMessageWidget:showName(flag )
	self.TableName:setVisible(flag)
end
function EquipmentMessageWidget:setNameVisible( bl )
	self.TableName:setVisible(bl)
end
function EquipmentMessageWidget:setImage()

end



















return EquipmentMessageWidget