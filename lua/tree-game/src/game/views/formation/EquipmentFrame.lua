local EquipmentFrame = class("EquipmentFrame",function (  )
	-- body
	return ccui.Widget:create()
end)

local EquipmentName={
	res.str.EQUIPMENT_NAME_TOU,
	res.str.EQUIPMENT_NAME_WUQI,
	res.str.EQUIPMENT_NAME_YIFU,
	res.str.EQUIPMENT_NAME_PIFENG,
	res.str.EQUIPMENT_NAME_KUZI,
	res.str.EQUIPMENT_NAME_TUTENG,
}

function EquipmentFrame:ctor(equipment,index)
	self.index=index
	self._State =  1  --状态
	self:init(equipment)
end

function EquipmentFrame:init( equipment )
	self.view=equipment:clone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self:setAnchorPoint(cc.p(0,0))
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:addChild(self.view)
	self._State =  1  

	--装备图标
	self.Img = self.view:getChildByName("Image_24"):setVisible(false)

	self.Btn =self.view:getChildByName("Button_66") -- 选中按下
	self.Btn:addTouchEventListener(handler(self,self.onCallBack))
	self.Btn:setTitleText(EquipmentName[self.index])

	self.Name = self.view:getChildByName("Text_1")
	self.Titile_Image=self.view:getChildByName("Image_2")

	self.lv = self.view:getChildByName("Image_lv"):getChildByName("Text_lv_13")

	--加号按钮
	self._jiahao =  self.view:getChildByName("Image_3")
end
function EquipmentFrame:setName( name,lv )
	self.Name:setVisible(true)
	self.Titile_Image:setVisible(true)
	self.Name:setString(name)
	self.Name:setColor(COLOR[lv])
end
function EquipmentFrame:setData( data ,pos)
	self._jiahao:setVisible(false)
	self.data=data
	if self.view:getChildByName("effofname") then 
		self.view:getChildByName("effofname"):removeFromParent()
	end 
	if data == nil then
		self.lv:getParent():setVisible(false) 
		


		self.Img:setVisible(false) 
		self.Titile_Image:setVisible(false)
		self.Name:setVisible(false)
		self.Btn:ignoreContentAdaptWithSize(true)
		self.Btn:loadTextureNormal(res.btn.EQUIPMENT_FRAME)
		self._State = 1


		if self:searbypart() then 
			self._jiahao:setVisible(true)
			local a1 = cc.FadeOut:create(0.5)
			local a2 = cc.FadeIn:create(0.3)
			local s = cc.Sequence:create(a1,a2)
			self._jiahao:runAction(cc.RepeatForever:create(s))
		end
		return 
	end
	self._jiahao:stopAllActions()
	self._jiahao:setVisible(false)
	
	local quality = conf.Item:getItemQuality(data.mId)
	local name = conf.Item:getName(data.mId,data.propertys)
	local img_src = conf.Item:getSrc(data.mId,data.propertys)

	local img_path = conf.Item:getItemSrcbymid(data.mId, data.propertys)

	self.Btn:ignoreContentAdaptWithSize(true)
	self.Btn:loadTextureNormal(res.btn.FRAME[quality])
	self:setName(name,quality)
	self.Img:setVisible(true)
	self.Img:ignoreContentAdaptWithSize(true)
	self.Img:loadTexture(img_path)

	local text = mgr.ConfMgr.getItemQhLV(data.propertys)
	self.lv:setString(text)
	self.lv:getParent():setVisible(true)
	self._State = 2



	if G_isSuitonWear(self.data.mId,pos) and  not self.view:getChildByName("effofname") then 
		--self.view:getChildByName("effofname"):removeFromParent()
		local params =  {id=404803, x=self.view:getContentSize().width/2,
		y=self.view:getContentSize().height/2,
		addTo=self.view,endCallFunc=nil,from=nil,to=nil, playIndex=0,addName = "effofname"}
		mgr.effect:playEffect(params)
	end 
end

function EquipmentFrame:searbypart()
	-- body
	local part = self.index

	local data = cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
	for k ,v in pairs(data) do 
		local vpart = conf.Item:getItemPart(v.mId)
		if vpart == part then 
			return true
		end  
	end
	return false
end

function EquipmentFrame:getData( )
	-- body
	return self.data
end

function EquipmentFrame:onCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if self.callback then
			self.callback(self._State,self.index)
		end
	end
end
function EquipmentFrame:setCallBack( fun )
	self.callback=fun
end




















return EquipmentFrame