--[[
	FriendCaradWidget
]]

local FriendCaradWidget=class("FriendCaradWidget",
	function (  )
		return ccui.Widget:create()
	end
)

function FriendCaradWidget:init(parent)
	self.parent=parent
	self.view=parent:getWidgetClone()
	self:setContentSize(self.view:getContentSize())
	self:setAnchorPoint(cc.p(0,0))
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.BtnFrame=self.view:getChildByName("Button_frame")
	self.LabDescribe=self.view:getChildByName("Text_name1_0")
	self.Image_head=self.BtnFrame:getChildByName("spr")
	self.Btn=self.view:getChildByName("Button_Using")
	self.LabName=self.view:getChildByName("Image_zb"):getChildByName("Text_name1")
	self.LabLv=self.BtnFrame:getChildByName("Image_lv"):getChildByName("Text_lv")

	self.spr7s = self.view:getChildByName("Image_13_0_0")
	self.spr7s:setVisible(false)
end

function FriendCaradWidget:setData(data)
	-- body
	self.data=data

	local colorlv = conf.Item:getItemQuality(data.mId)
	local framePath=res.btn.FRAME[colorlv]
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[colorlv])
	self.LabName:setString(conf.Item:getName(data.mId,data.propertys))
	self.LabLv:setString(data.propertys[304] and data.propertys[304].value or 1 )
	self.Image_head:loadTexture(conf.Item:getItemSrcbymid(data.mId,data.propertys))
	local conf_data = conf.Item:getItemConf(data.mId)
	self.spr7s:setVisible(false)
	if checkint(conf_data.zhuan) > 0 then
		self.spr7s:setVisible(true)
		self.spr7s:loadTexture(res.icon.ZHUANFRAME[conf_data.zhuan])
	end

	self.Btn:setTitleText(res.str.RES_GG_13)
	self.Btn:addTouchEventListener(handler(self,self.onCallBack))

	self.LabDescribe:setString(string.format(res.str.RES_GG_16,checkint(data.count)))
end

--出战
function  FriendCaradWidget:onCallBack(send,eventype)
	if eventype == ccui.TouchEventType.ended then
		self.parent:send_shang(self.data)
		self.parent:onCloseSelfView()
	end
end
return FriendCaradWidget