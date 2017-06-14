--[[DigOneCardItem]]


local DigOneCardItem = class("DigOneCardItem",function(  )
	return ccui.Widget:create()
end)

function DigOneCardItem:init(param)
	-- body
	self.Parent=param
	self.view=param:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	self.btnframe =self.view:getChildByName("Button_frame_18_31") 
	self.spr = self.btnframe:getChildByName("Image_22_23_51")

	self.lab_lv = self.btnframe:getChildByName("Image_lv_25_53"):getChildByName("Text_lv_21_21")
	self.lan_name = self.view:getChildByName("Image_zb_bg_29_55"):getChildByName("Text_name1_25")
	self.lab_power = self.view:getChildByName("Image__1_31_61"):getChildByName("Text_32_29_31")

	local btn = self.view:getChildByName("Button_Using_33")
	btn:addTouchEventListener(handler(self, self.onBtnCallBack))

	self.btn = btn
end

function DigOneCardItem:setOnlyFirger()
	-- body
	  --动画播放期间 不给点击
    local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(0)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    --addto:addChild(layer,100) 
    mgr.SceneMgr:getNowShowScene():addChild(layer)

    self.layer = layer

    local pos = self.btn:getWorldPosition()
	local params =  {id=404816, x=pos.x ,
	y=pos.y,addTo=self.layer, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)

	local panle = self.btn:clone()
	--panle:removeAllChildren()
	panle:setOpacity(0)
	panle:setPosition(pos)
	panle:addTo(layer)
	panle:addTouchEventListener(handler(self,self.onBtnCallBack))
end

function DigOneCardItem:setData(data,idx,falg)
	-- body
	self.data = data

	local colorlv = conf.Item:getItemQuality(data.mId)
	local frame = res.btn.FRAME[colorlv]
	self.btnframe:loadTextureNormal(frame)

	local spr = conf.Item:getItemSrcbymid(data.mId,data.propertys)
	self.spr:loadTexture(spr)

	self.lab_lv:setString(data.propertys[304].value)
	self.lan_name:setString(conf.Item:getName(data.mId,data.propertys))
	self.lan_name:setColor(COLOR[colorlv])
	self.lab_power:setString(data.propertys[305].value)

	if idx == 0 and falg then 
		self:setOnlyFirger()
	end
end

function DigOneCardItem:onBtnCallBack( send_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.layer then 
			self.layer:removeFromParent()
		end 

		local view = mgr.ViewMgr:get(_viewname.DIG_SET)
		view:CardCallBack(self.data)

		self.Parent:onCloseSelfView()
	end 
end

return DigOneCardItem