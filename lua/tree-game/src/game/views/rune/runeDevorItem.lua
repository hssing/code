
local runeDevorItem = class("runeDevorItem",function( ... )
	-- body
	return ccui.Widget:create()
end)

function runeDevorItem:init(parent)
	-- body
	self.view=parent:getWidgetClone()
	self.parent=parent
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.btnframe=self.view:getChildByName("Button_frame")
	--头像 
	self.imghead=self.btnframe:getChildByName("Image")
	--等级
	self.LableLv=self.btnframe:getChildByName("Image_lv_25_21"):getChildByName("Text_lv")
	--经验
	self.labelexp=self.view:getChildByName("Image_30"):getChildByName("Text_exp")
	--复选框
	self.checkbox=self.view:getChildByName("CheckBox")
	self.checkbox:setSelected(false)
	self.checkbox:addEventListener(handler(self,self.onCheckBoxCallBack))
	--名字
	self.LableName=self.view:getChildByName("Image_zb_bg_29_23"):getChildByName("Text_name1_22")

	--self._exp = 0
end

function runeDevorItem:setData( data )
	-- body
	self.data=data
	self.checkbox:setSelected(false)

	local quality = conf.Item:getItemQuality(data.mId)
	self.btnframe:loadTextureNormal(res.btn.FRAME[quality])

	self.imghead:loadTexture(conf.Item:getItemSrcbymid(data.mId))

	--data.propertys = vector2table(data.propertys,"type")
	local lv = data.propertys[315] and data.propertys[315].value or 0
	self.LableLv:setString(lv)

	local exp =  G_ExpofRune(data) ---去计算一下
	self.labelexp:setString(exp)

	self.LableName:setString(conf.Item:getName(data.mId))
	self.LableName:setColor(COLOR[quality])
end

function runeDevorItem:setBtnfalse( ... )
	-- body
	self.checkbox:setSelected(true)
end

function runeDevorItem:onCheckBoxCallBack(send,eventype )
	
	if eventype == 0 then  --勾选
		if self.parent:check(self.data,true) then
		else
			self.checkbox:setSelected(false)
		end
	else
		self.parent:check(self.data)
	end
end

return runeDevorItem