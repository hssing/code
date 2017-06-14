
local RuneFrame = class("RuneFrame", function( ... )
	-- body
	return ccui.Widget:create()
end)

function RuneFrame:ctor(item,index)
	-- body
	self.index=index
	self:init(item)
end

function RuneFrame:init(item)
	-- body
	self.view=item:clone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	--self:setAnchorPoint(cc.p(0,0))
	--self.view:setAnchorPoint(cc.p(0.5,0.5))
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.frame = self.view:getChildByName("Image_6")
	self.frame:addTouchEventListener(handler(self, self.onCallBack))

	self.spr = self.frame:getChildByName("Image_7_0")
	self.spr:setScale(0.8)
	self.spr:ignoreContentAdaptWithSize(true)

	self.lab_dec =  self.view:getChildByName("Text_2_0")
	self.img_name = self.view:getChildByName("Image_7")
	self.lab_name = self.img_name:getChildByName("Text_2")
	self.suo = self.view:getChildByName("Image_8")
	self.jia = self.view:getChildByName("Image_3_0")

	self.lv_img = self.view:getChildByName("Image_9")
	self.lv = self.view:getChildByName("Text_3") 
	self:initData()
end

--一闪一闪的动画
function RuneFrame:_runBilk( lab,tiem )
	-- body
	local a1 = cc.FadeOut:create(tiem)
	local a2 = cc.FadeIn:create(tiem)
	local a3 = cc.DelayTime:create(tiem)
	local sequence = cc.Sequence:create(a1,a2)
	lab:runAction(cc.RepeatForever:create(sequence))	
end

--格子初始化
function RuneFrame:initData()
	-- body
	self.spr:setVisible(false)
	self.lab_dec:setString("")
	self.img_name:setVisible(false)
	self.suo:setVisible(false)
	self.jia:setVisible(false)
	self.lv:setString("")
	self.lv_img:setVisible(false)

	self.lab_name:setString("")
	if self.index < 3 then
		self.frame:setTouchEnabled(true)
	elseif self.index == 3 then 
		self.lab_dec:setString(res.str.DEC_NEW_06)
		self.suo:setVisible(true)
	elseif self.index == 4 then
		self.lab_dec:setString(res.str.DEC_NEW_07)
		self.suo:setVisible(true)
	elseif self.index == 5 then
		self.lab_dec:setString(res.str.DEC_NEW_08)
		self.suo:setVisible(true)
	else
		self.lab_dec:setString(res.str.DEC_NEW_09)
		self.suo:setVisible(true)
	end
end
---判定格子开启那些
function RuneFrame:initlock(jie,jinghua,falg)
	-- body
	if falg then
		self.lab_dec:setString("")
		self.suo:setVisible(false)
		self.frame:setTouchEnabled(true)
	elseif self.index < 3 then
		--self.jia:setVisible(true)
	elseif self.index == 4 then
		if jie >= 2 then
			self.lab_dec:setString("")
			self.suo:setVisible(false)
			self.frame:setTouchEnabled(true)
			--self.jia:setVisible(true)
		else
			self.frame:setTouchEnabled(false)
			self.jia:setVisible(false)
		end
	elseif self.index == 5 then
		if jie >= 3 then
			self.lab_dec:setString("")
			self.suo:setVisible(false)
			self.frame:setTouchEnabled(true)
			--self.jia:setVisible(true)
		else
			self.frame:setTouchEnabled(false)
			self.jia:setVisible(false)
		end
	elseif self.index == 6 then
		--todo
		if jie >= 4 then
			self.lab_dec:setString("")
			self.suo:setVisible(false)
			self.frame:setTouchEnabled(true)
		else
			self.frame:setTouchEnabled(false)
			self.jia:setVisible(false)
		end
	elseif self.index == 3 then 
		if jie >= 2  or jinghua >= 5 then
			--self.jia:setVisible(true)
			self.lab_dec:setString("")
			self.suo:setVisible(false)
			self.frame:setTouchEnabled(true)
		else
			self.frame:setTouchEnabled(false)
			self.jia:setVisible(false)
		end
	end

end

function RuneFrame:getData()
	-- body
	return self.data
end

function RuneFrame:setData(data_,pos,card_data)
	-- body

	self.data = data_
	self.card_pos  = pos
	self.jia:setVisible(false)
	self:initData()

	if self.view:getChildByName("effofname") then 
		self.view:getChildByName("effofname"):removeFromParent()
	end 

	self.jia:stopAllActions()
	--self.jia:setVisible(false)

	if  data_ then
		local lv = data_.propertys[315] and data_.propertys[315].value or 0
		self.lv:setString(lv)
		self.lv_img:setVisible(true)

		local colorlv = conf.Item:getItemQuality(data_.mId)
		self.lab_name:setColor(COLOR[colorlv])
		self.img_name:setVisible(true)
		self.lab_name:setString(conf.Item:getName(data_.mId))

		self.spr:loadTexture(conf.Item:getItemSrcbymid(data_.mId))
		self.spr:setVisible(true)
		
		self.lab_dec:setString("")

		if G_isRuneSuit(data_) and not self.view:getChildByName("effofname") then
			local params =  {id=404803, x=self.view:getContentSize().width/2,
			y=self.view:getContentSize().height/2 + 10,
			addTo=self.view,endCallFunc=nil,from=nil,to=nil, playIndex=0,addName = "effofname"}
			mgr.effect:playEffect(params)
		end	
	else
		
	end
	self.jia:setVisible(false)
	if card_data then
		local jie = 1
		local jinghua= 0 
		for k ,v in pairs(card_data.propertys) do 
			if k == 307 then
				jie = v.value + 1
			elseif k == 310 then
				jinghua = v.value 
			end
		end
		
		if not data_ then
			if G_isRuneForCard(pos) then
				self.jia:setVisible(true)
				local a1 = cc.FadeOut:create(0.5)
				local a2 = cc.FadeIn:create(0.3)
				local s = cc.Sequence:create(a1,a2)
				self.jia:runAction(cc.RepeatForever:create(s))
			end
		end
		self:initlock(jie,jinghua,G_is7sCard(card_data.mId))
	end
end

--[[
	local pom = mgr.BoneLoad:loadArmature(404856,0)
	pom:setPositionX(widget:getContentSize().width/2)
	pom:setPositionY(widget:getContentSize().height/2)
	pom:addTo(widget)
	pom:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.complete then
			pom:removeSelf()
		end
	end)
]]

function RuneFrame:setCallBack( fun )
	self.callback=fun
end

function RuneFrame:onCallBack(send_,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self.callback then
			self.callback(self.index,self.data)
		end
	end
end



return RuneFrame