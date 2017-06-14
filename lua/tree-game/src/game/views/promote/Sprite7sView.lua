
local Sprite7sView =class("Sprite7sView",base.BaseView)
local pet= require("game.things.PetUi")

function Sprite7sView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local top = self.view:getChildByName("Panel_27")
	local btnclose = top:getChildByName("Button_25_0")
	btnclose:addTouchEventListener(handler(self,self.onBtnCloseView))

	local btn_gui = top:getChildByName("Button_25")
	btn_gui:addTouchEventListener(handler(self,self.onBtnGuize))

	local bg = self.view:getChildByName("Image_55")
	self.jiantou = bg:getChildByName("Image_68")
	bg:setTouchEnabled(true)
	self.left_panle = bg:getChildByName("Panel_2_10_0") 
	self.left_name = self.left_panle:getChildByName("Image_10_49_66_0_6"):getChildByName("Text_1_3")
	self.left_name:setString("")
	self.left_sprite7 = self.left_panle:getChildByName("Image_13_0_0")
	self.left_sprite7:ignoreContentAdaptWithSize(true)

	self.right_panle = bg:getChildByName("Panel_2_10") 
	self.right_name = self.right_panle:getChildByName("Image_10_49_66_0"):getChildByName("Text_1")
	self.right_name:setString("")
	self.right_sprite7 = self.right_panle:getChildByName("Image_13_0")
	self.right_sprite7:ignoreContentAdaptWithSize(true)


	local panle_bottom = self.view:getChildByName("Panel_30")
	self.bg_di = panle_bottom:getChildByName("Image_64")

	self.lab_condition = self.bg_di:getChildByName("Text_56_0_0_0")
	self.lab_condition:setString("")
	local btn = self.bg_di:getChildByName("Button_18_0")
	btn:addTouchEventListener(handler(self,self.onbtnPerSee))
	self.btn = btn

	local btn_start = self.bg_di:getChildByName("Button_18")
	btn_start:addTouchEventListener(handler(self,self.onbtnStart))
	self.btn_start = btn_start

	self:initDec()
	
	G_FitScreen(self,"Image_55")
end

function Sprite7sView:initVisfalse( ... )
	-- body
	self.bg_di:getChildByName("Image_66"):setVisible(false)
	self.bg_di:getChildByName("Image_66_0"):setVisible(false)
	self.bg_di:getChildByName("Text_56_0_0"):setVisible(false)
	self.bg_di:getChildByName("Text_56_0_0_0"):setVisible(false)

end

function Sprite7sView:initDec()
	-- body
	self.bg_di:getChildByName("Text_56"):setString(res.str.DUI_DEC_82)
	self.bg_di:getChildByName("Text_56_0"):setString(res.str.DUI_DEC_83)
	self.bg_di:getChildByName("Text_56_0_0"):setString(res.str.DUI_DEC_84)
	self.btn:setTitleText(res.str.DUI_DEC_86)
	self.btn_start:setTitleText(res.str.DUI_DEC_87)
end

function Sprite7sView:addPet(data)
	local node=pet.new(data.mId,data.propertys)
	node:setScale(0.8)
	return node
end

function Sprite7sView:setLeft()
	-- body
	self.left_sprite7:setVisible(false)
	if self.conf_data.zhuan and checkint(self.conf_data.zhuan) > 0 then
		self.left_sprite7:setVisible(true)
		self.left_sprite7:loadTexture(res.icon.ZHUAN[1])
	end 
	self.left_name:setString(conf.Item:getName(self.data.mId,self.data.propertys))
	local spr = self:addPet(self.data)
	spr:setAnchorPoint(cc.p(0.5,0))
	spr:setPositionX(self.left_panle:getContentSize().width/2)
	spr:setPositionY(0)
	spr:addTo(self.left_panle)
end

function Sprite7sView:setRight()
	-- body
	self.right_sprite7:setVisible(false)
	if self.new_data.zhuan and checkint(self.new_data.zhuan) > 0 then
		self.right_sprite7:setVisible(true)
		self.right_sprite7:loadTexture(res.icon.ZHUAN[1])
	end

	self.right_name:setString(conf.Item:getName(self.conf_data.new_id))
	local data = clone(self.data) -- {mId = self.conf_data.new_id,property = self.data.propertys}
	data.propertys[307].value = 0
	data.propertys[310].value = 0
	data.mId = self.conf_data.new_id
	printt(data)
	local spr = self:addPet(data)
	spr:setAnchorPoint(cc.p(0.5,0))
	spr:setPositionX(self.right_panle:getContentSize().width/2)
	spr:setPositionY(0)
	spr:addTo(self.right_panle)

end

function Sprite7sView:setData(data_)
	-- body
	self.data = clone(data_)
	self.conf_data = conf.Item:getItemConf(self.data.mId)
	self.new_data = conf.Item:getItemConf(self.conf_data.new_id)

	--self.data.propertys = vector2table(self.data.propertys, "type")
	self.data2 = clone(self.data)

	self.data2.mId = self.conf_data.new_id
	self.data2.propertys[307].value = 0
	self.data2.propertys[310].value = 0

	local str = ""
	for k , v in pairs(self.new_data.conditions) do
		if v[1] == 1 then --关卡
			local zid = math.floor(v[2]/100)
			local gid = v[2]%100
			local zhan = conf.Copy:getChapterInfo(zid)
			str = str..string.format(res.str.DUI_DEC_85,zhan.title,gid)
		end
	end
	self.lab_condition:setString(str)
	self:setLeft()
	self:setRight()
end

function Sprite7sView:serverCallBack( ... )
	-- body
	self.btn_start:setVisible(true)
	self.btn_start:setTitleText(res.str.RES_RES_03)
	self.btn_start:setPositionX(self.bg_di:getContentSize().width/2)
	self.btn_start:addTouchEventListener(handler(self, self.onbtnJinghua))

	self:initVisfalse()

	self.btn:setVisible(false)
	self.left_panle:setVisible(false)

	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(display.width,display.height))
	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
    self:addChild(layer,1000) 

    local left_pos = self.left_panle:getWorldPosition()
    local params =  {id=404809, x=left_pos.x+self.left_panle:getContentSize().width/2,
	y=left_pos.y + self.left_panle:getContentSize().height/2,
	addTo=self.view,
	playIndex=2,
	addName = "effofname1"}
	mgr.effect:playEffect(params)

	local  armature
	local params =  {id=404809, x=left_pos.x+self.left_panle:getContentSize().width/2,
	y=left_pos.y + self.left_panle:getContentSize().height/2,
	addTo=self.view,
	loadComplete= function(var)
		-- body
		armature = var

		local a1 = cc.MoveBy:create(0.1,cc.p(0,120))
		local a5 = cc.MoveBy:create(0.15,cc.p(0,-60))

		local a2 = cc.DelayTime:create(0.3)


		local pos  = self.right_panle:getWorldPosition() --cc.p(self.right_panle:getPositionX(),self.right_panle:getPositionY())
		local a3 = cc.MoveTo:create(0.2,cc.p(pos.x + self.right_panle:getContentSize().width/2,
		 pos.y + self.right_panle:getContentSize().height/2))
		
		local a4 = cc.CallFunc:create(function() 
	 		 armature:removeFromParent()
	 	 end) 
		local sequence = cc.Sequence:create(a1,a5,a2,a3,a4)
		armature:runAction(sequence)
	end,
	playIndex=1,
	addName = "effofname"}
	mgr.effect:playEffect(params)

	local function listener()
		local pos  = self.right_panle:getWorldPosition()
		pos.x = pos.x +  self.right_panle:getContentSize().width/2
		pos.y = pos.y +  self.right_panle:getContentSize().height/2
		local params =  {id=404809, x=pos.x,
		y=pos.y,
		addTo=self.view,
		endCallFunc = function( ... )
			-- body
			layer:removeSelf()
			self.right_panle:setPositionX(display.cx-self.right_panle:getContentSize().width/2)
			G_playerJingjie(self.data,self.data2,self,function() mgr.Sound:playMainMusic() end)
			self.jiantou:setVisible(false)
	
		end,
		playIndex=3,
		addName = "effofname"}
		mgr.effect:playEffect(params)
		mgr.Sound:playQianghua()
	end

	self:performWithDelay(listener, 0.7)

	--self.right_panle:setPositionX(display.cx-self.right_panle:getContentSize().width/2)
end

function Sprite7sView:onbtnJinghua(send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
		local index= targetview:getNowPetIndex(self.data)
		if index then
			targetview:updateTargetPet(index)
			mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
			targetview:ChoosePage(2)
			targetview:setPageBtnStatue(2)
			self:closeSelfView()
		else
			debugprint("没有出战数据")
		end
	end
end

function Sprite7sView:onbtnStart( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--预览输赢
		debugprint("进化")
		local data = {index = self.data.index,toIndex = 0}
		--proxy.Card:reqJINHUA(data)
		proxy.card:reqJINHUA(data)
	end
end

function Sprite7sView:onbtnPerSee( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--预览输赢
		debugprint("预览属性")
		local data = {mId = self.conf_data.new_id}
		G_OpenCard(data,true)
	end
end

function Sprite7sView:onBtnGuize(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(17)
	end
end

function Sprite7sView:onBtnCloseView( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function Sprite7sView:onCloseSelfView()
	-- body
	self:closeSelfView()
	mgr.SceneMgr:getMainScene():closeHeadView()
end
return Sprite7sView