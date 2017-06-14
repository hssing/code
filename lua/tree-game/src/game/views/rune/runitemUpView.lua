
local runitemUpView = class("runitemUpView",function( ... )
	-- body
	return ccui.Widget:create()
end)

local offsetX=50
local offsetY=-190
local __WidgetPos =
{
	cc.p(257+offsetX,543+offsetY),
	cc.p(105.78+offsetX,490+offsetY),
	cc.p(408.64+offsetX,490.45+offsetY),
	cc.p(96.95+offsetX,395.96+offsetY),
	cc.p(438.93+offsetX,396.68+offsetY),
	cc.p(263.40+offsetX,355+offsetY),
}

local _scale  = { 0.8, 0.8, 0.8, 0.8, 0.8,0.8 }

function runitemUpView:init(_parent,i)
	-- body
	self._parent = _parent
	self.view=_parent:getWidgetClone()

	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)
	
	--local s = _scale[pos]
	--self.view:setScale(s)

	self.Button=self.view:getChildByName("Button_12_42")
	self.Button:addTouchEventListener(handler(self,self.onCallBack))
	self.Button:setOpacity(0)

	self.frame = self.view:getChildByName("Image_21")
	self.spr =  self.frame:getChildByName("Image_21_0")
	self.spr:ignoreContentAdaptWithSize(true)
	--self.frame:setVisible(false)

	self.Panel_name=self.view:getChildByName("Panel_name")
	self.LabelName=self.Panel_name:getChildByName("Text_pet_name") --宠物名字

	if i < 6 then
		--self.Panel_name:setVisible(false)
	end
end

function runitemUpView:onCallBack( send,enenttype )
	-- body
	if enenttype ==  ccui.TouchEventType.ended then
		if self._parent:checkmax(true) then
			local view = mgr.ViewMgr:showView(_viewname.RUNE_LIST_TUNSHI)
			view:setSelect(self._parent:getSelectList())
			view:setData()
			view:setUseFor(self._parent:curData())
			view:setNeedExp(self._parent:getNeedExp())
		end
	end
end

function runitemUpView:setData( data )
	-- body
	self.data = data

	if self.data then
		local lv=conf.Item:getItemQuality(data.mId)
		local name=conf.Item:getName(data.mId)
		self.LabelName:setString(name)
		self.LabelName:setColor(COLOR[lv])

		--self.frame:setVisible(true)
		self.frame:loadTexture(res.btn.FRAME[lv])

		self.spr:setVisible(true)
		self.spr:loadTexture(conf.Item:getItemSrcbymid(data.mId))

		if self.armature then
			self.armature:removeSelf()
			self.armature = nil 
		end
	else
		--self.frame:setVisible(false)
		self.LabelName:setString("")
		self.spr:setVisible(false)
		self.frame:loadTexture(res.btn.FRAME[1])
		if not self.armature then
			--self.armature = mgr.BoneLoad:loadArmature(404808,0)
	   		--self.armature:setPosition(self.view:getContentSize().width/2,self.view:getContentSize().height/2)
	  		--self.armature:addTo(self.view,999)
	  	end
	end
end

function runitemUpView:setFrameVis(falg )
	-- body
	--self.frame:setVisible(falg)
end

function runitemUpView:isExist()
	-- body
	if self.data then
		return true
	else
		return false
	end
end
return runitemUpView