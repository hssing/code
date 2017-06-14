local PackPanle=class("PackPanle",function(  )
	return ccui.Widget:create()
end)

function PackPanle:ctor()
	self.Item_type=nil -- 物品的类型
	self.Mark = nil  --做标记用
end
function PackPanle:init(Parent)
	self.Parent=Parent
	self.view=Parent:getColnePnale()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self.view:setTouchEnabled(false)
	self:addChild(self.view)
	--self:setTouchEnabled(false)
	--品质框 按钮
	self.BtnFrame=self.view:getChildByName("Button_frame")
	self.BtnFrame:addTouchEventListener(handler(self,self.onOpenItem))
	--品质框上的图像
	self.spr=self.BtnFrame:getChildByName("Image_22")
	--物品名字
	self.LabName=self.view:getChildByName("Image_zb_bg"):getChildByName("Text_name")
	--使用按钮
	self.BtnUsing=self.view:getChildByName("Button_Using")
	self.BtnUsing:addTouchEventListener(handler(self,self.onUsingCallBack))
	--10次使用按钮
	self.BtnUsing10=self.view:getChildByName("Button_Using10")
	self.BtnUsing10:addTouchEventListener(handler(self,self.onUsingCallBack_10))
	--物品属性面板
	self.PanelAttribute=self.view:getChildByName("Panel_Attribute")
	--描述
	self.Lable_describe=self.PanelAttribute:getChildByName("Text_describe")

	--信息 物品剩余信息
	self.LabMessage=self.view:getChildByName("Text_message")
	--星星面板
	self.IconStar=self.view:getChildByName("Panel_star")
	--等级
	self.Image_lv=self.BtnFrame:getChildByName("Image_lv")
	self.Lable_lv=self.Image_lv:getChildByName("Text_lv")
	--数量
	self.img_amount = self.BtnFrame:getChildByName("Image_lv_0")
	self.Lable_amount=self.img_amount:getChildByName("Text_amount")
	----是否出站的
	self._icon_on = self.view:getChildByName("Image_Icon")
	--是否7S卡
	self._7scard = self.view:getChildByName("Image_13_0_0")
	self._7scard:ignoreContentAdaptWithSize(true)
	--self._7slab = self._7scard:getChildByName("AtlasLabel_1_2_5_7_11_2")
	--self._7scard:setRotation(330)

	
end
--设置图像
function PackPanle:setBImage(imgpath)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:loadTexture(imgpath)
end

function PackPanle:onUsingCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if self.Item_type ==  pack_type.PRO then
			--如果是小喇叭按钮，做限制
			if self.mId == 221015002 then
				if cache.Player:getLevel() < res.kai.horn then
					G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,res.kai.horn ))
					return
				end
				mgr.ViewMgr:showView(_viewname.HORN)

				self.Parent:keepOffset()
				return
			elseif self.mId == 221015011 or self.mId == 221015012 then --特殊的 改名道具
				local var = self.data.propertys[40108] and self.data.propertys[40108].value or 0
				local  tiem = conf.Item:getItemTimelimit(self.data.mId) - var
				if tiem > 0 then 
					local view = mgr.ViewMgr:showView(_viewname.CAHNGENAME)
					view:setData(self.data)
					self.Parent:keepOffset()
					return 
				else
					local _t = { reqType = 0,name ="",index = self.data.index }
					if self.data.mId == 221015012 then  
						_t.reqType = 1
					end
					proxy.pack:send_103005(_t)
					return 
				end
			elseif  self.mId == 221015025 or self.mId == 221015026 or 221015027 == self.mId  then 
				local var = self.data.propertys[40109] and self.data.propertys[40109].value or 0
				if var > 0 then
					G_TipsOfstr(res.str.PACK_DEC2)
					return
				end
			end
			--[[]
				221015003 全服 小
				221015004 全服 中
			--]]
			---如果是红包
			if self.mId == 221015003 or self.mId == 221015004 or self.mId == 221015005 or self.mId == 221015006 or self.mId == 221015007 or self.mId == 221015008 or self.mId == 221015009    then
				if cache.Player:getLevel() < res.kai.redBag then
					G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,res.kai.redBag ))
					return
				end
				local view = mgr.ViewMgr:showView(_viewname.SEND_REDBAG)
				local data = {}
				data.mId = self.mId
				data.index = self.data.index
				view:setMid(data)
				self.Parent:keepOffset()
				return
			end

			local params = conf.Item:UseToVire(self.data.mId)
			if  params   then --如果支持跳转就
				--
				if not self.falg_11 then 
					local t = {
						221015050,221015051,221015052,221015053,221015054,
						221015055,221015056,221015057,221015058,221015059,
						221015060,221015061,221015062,221015063,221015064,
					}
					for k ,v in pairs(t) do 
						if v == self.mId then 
							--检测功能是否开启
	   						local isopen , value = mgr.Guide:checkOpen(_viewname.DIG_MIAN)
	   						if not isopen then 
						        G_TipsOfstr(string.format(res.str.SYS_OPNE_LV, value.level))
						        return nil
						    end
						end 
					end

					G_GoToView(params)
					return
				else 
					if cache.Player:getSeverTime()<conf.Item:getUseTime(self.data.mId) then 
						--G_GoToView(params)
						--跳转抽奖，活动类型3，第3007个选项
						
						proxy.Active:reqSwitchState(3007,3)
						return 
					end
					
				end
			end 

			self:usingItem(1)
		elseif self.Item_type == pack_type.EQUIPMENT then
			if self:getData().index < 400000 then
				
			else
				mgr.ViewMgr:showView(_viewname.EQUIPMENT_QH):setData(self:getData()):setShowPageView(1)
			end
		elseif self.Item_type == pack_type.MATERIAL then
			--出售
			local view = mgr.ViewMgr:showView(_viewname.FRUIT_COMPOSE_SELL)
			if view then
				view:setData(self.data)
			end

		else
			local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
			local index=targetview:getNowPetIndex(self:getData())
			if index then
				targetview:updateTargetPet(index)
				mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
				targetview:ChoosePage(2)
			else
				debugprint("没有出战数据")
			end
		end
	end
end
function PackPanle:onUsingCallBack_10(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if self.Item_type ==  pack_type.PRO then
			self:usingItem(10)
		elseif self.Item_type == pack_type.EQUIPMENT then
			mgr.ViewMgr:showView(_viewname.EQUIPMENT_QH):setData(self:getData()):setShowPageView(2)
		elseif self.Item_type == pack_type.MATERIAL then--果实合成，出售
			G_TipsOfstr("出售")
		else
			local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
			local index=targetview:getNowPetIndex(self:getData())
			if index then
				targetview:updateTargetPet(index)
				mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
			else
				debugprint("没有出战数据")
			end
		end
	end
end
function PackPanle:usingItem( amount )
	self.Parent:keepOffset()

	local islimit=conf.Item:getLimitNum(self.data.mId)
	local usenums  =cache.Pack:getusenums(self.data.mId)
	if islimit and  islimit>0 and islimit == usenums then 
		G_TipsOfstr(res.str.PACK_USELIMIT)
		return 
	end 

	local canuse = islimit - usenums
	--canuse = canuse ~= 0 and canuse or 1

	local amount_=amount
	if amount_ > self.data.amount then
		amount_ = self.data.amount 
	end
	if islimit and islimit>0 then 
		amount_ = math.min(amount_,canuse)
	end 
	
	local sptype = conf.Item:getSp_type(self.data.mId)
	if sptype and sptype > 0 then
		local arg = conf.Item:getArg1(self.data.mId)
		amount_ = arg.arg2
	end



	local data={}
	data.index=self.data.index
	data.amount=amount_
	data.mId=self.data.mId


	debugprint("使用物品！！！data.index="..data.index.." data.amount = "..data.amount
		.."  data.mId ="..data.mId)

	proxy.pack:reqGetPack(data)
end
--设置描述
function PackPanle:setDscribe( shuom )
	self.Lable_describe:setString(shuom)
end
--设置强化等级或物品等级
function PackPanle:setLv(lv)
	self.Lable_lv:setString(lv)
end
function PackPanle:setMark( mark )
	self.Mark=mark
end
function PackPanle:getMark( mark )
	return self.Mark
end
--设置数量
function PackPanle:setAmount(amount,is_all)
	if amount > 1 and is_all>0  then
		self.BtnUsing10:ignoreContentAdaptWithSize(true)
		self.BtnUsing:loadTextureNormal(res.btn.BLUE)
		self.BtnUsing:ignoreContentAdaptWithSize(true)
		self.BtnUsing10:setVisible(true)
	else
		self.BtnUsing:ignoreContentAdaptWithSize(true)
		self.BtnUsing10:ignoreContentAdaptWithSize(true)
		self.BtnUsing10:setVisible(false)
	end
	self.img_amount:setVisible(amount >= 1)
	self.Lable_amount:setVisible(amount >= 1)
	self.Lable_amount:setString(amount)	
end

function PackPanle:onOpenItem(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		local sptype = conf.Item:getSp_type(self.data.mId)
		if sptype and sptype > 0 then
			local arg = conf.Item:getArg1(self.data.mId)
			local data = {mId = arg.arg1,propertys = {}}
			if conf.Item:getType(data.mId) == pack_type.EQUIPMENT then
				G_OpenEquip(data,true)
			else
				G_OpenCard(data,true)
			end
			
		elseif self.Item_type ==  pack_type.PRO then
			mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(self.data)
		elseif  self.Item_type  == pack_type.EQUIPMENT then 
			G_OpenEquip(self.data)
		elseif self.Item_type  == 4 then
			--local lv = self.data.propertys[315] and self.data.propertys[315].value or 0 
			G_openItem(self.data.mId,lv)
			--G_OpenRun(self.data)
		elseif self.Item_type  == pack_type.MATERIAL then--打开材料
			--保存跳转界面信息
			local data = {}
			data.packView = true
			data.selectedPage = 5
			cache.Player:saveMaterialJumpData(data)

			G_OpenMaterial(self.data)
		else	
			G_OpenCard(self.data)
		end
	end
end

function PackPanle:onOpenItem2( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self.Item_type ==  pack_type.PRO then
			mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(self.data)
		end
	end
end

--设置属性
function PackPanle:setPro( Part,propertys )
	-- body
	local atk = 0
	local hp = 0
    --暴击
	local cri = 0
	--暴击伤害
	local crihurt = 0
	--抗暴
	local defcri = 0 
	--闪避
	local dodge = 0
	--命中
	local hit = 0
	if Part == 1 then 
		atk = mgr.ConfMgr.getItemAtK(propertys)
		hp = mgr.ConfMgr.getItemHp(propertys)
		crihurt = mgr.ConfMgr.getCritSh(propertys)
	elseif Part == 2 then 
		atk = mgr.ConfMgr.getItemAtK(propertys)
		hit = mgr.ConfMgr.getHit(propertys)
	elseif Part == 3  then 
		hp = mgr.ConfMgr.getItemHp(propertys)
		defcri = mgr.ConfMgr.getResistantCrit(propertys)
	elseif Part == 4 then
		atk = mgr.ConfMgr.getItemAtK(propertys)
		hp = mgr.ConfMgr.getItemHp(propertys)
		crihurt = mgr.ConfMgr.getCritSh(propertys)
	elseif  Part == 5 then 
		hp = mgr.ConfMgr.getItemHp(propertys)
		dodge = mgr.ConfMgr.getDodge(propertys)
	elseif  Part == 6 then 
		atk = mgr.ConfMgr.getItemAtK(propertys)
		cri = mgr.ConfMgr.getCrit(propertys)
	else
		atk = mgr.ConfMgr.getItemAtK(propertys)
		hp = mgr.ConfMgr.getItemHp(propertys)
	end	

	for i = 1 , 3 do 
		self.PanelAttribute:getChildByName("Image__"..i):setVisible(false)
		self.PanelAttribute:getChildByName("Image__"..i):ignoreContentAdaptWithSize(true)
	end 

	local bl=0
	local function _insetPro(png,v )
		-- body
		local k = pos 
		if v and v > 0 then 
			bl = bl +1 
			local dec = self.PanelAttribute:getChildByName("Image__"..bl)
			dec:setVisible(true)
			dec:loadTexture(png)

			local value = dec:getChildByName("Text_32_"..bl)
			value:setString(v)

			local w =  dec:getContentSize().width  
			value:setPositionX(w+5)
			
		end
	end
	_insetPro(res.font.ATK,atk)
	_insetPro(res.font.HP,hp)
	_insetPro(res.font.CRIT,cri)
	_insetPro(res.font.CRIT_SH,crihurt)
	_insetPro(res.font.JR,defcri)
	_insetPro(res.font.MZ,hit)
	_insetPro(res.font.SB,dodge)
end

function PackPanle:onbtnTuihua( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--print("self.data = "..self.data.mId)
		local data = self.data 
		local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
		view:setData(data)
	end 
end

function PackPanle:changeTimes()
	-- body
	--221015065
	--print("self.data.mId = "..self.data.mId)

	
	if self.data.propertys[40109] then
		local tiem = self.data.propertys[40109].value
		local str =res.str.CONTEST_DEC1..":"..string.formatNumberToTimeString(tiem)
		self.LabMessage:setString(str)
		self.LabMessage:setVisible(true) 
		if tiem == 0 then 
			self.LabMessage:setVisible(false)
		else
			self.LabMessage:setVisible(true)
		end
	elseif self.data.propertys[40108] then
		local tiem = 10800-self.data.propertys[40108].value 
		if self.data.mId == 221015011 or self.data.mId == 221015012 then -- getItemTimelimit
			tiem = conf.Item:getItemTimelimit(self.data.mId)-self.data.propertys[40108].value 
		end

		if tiem < 0 then 
			tiem = 0
		end

		local str =res.str.CONTEST_DEC1..":"..string.formatNumberToTimeString(tiem)
		self.LabMessage:setString(str)
		self.LabMessage:setVisible(true) 
		if tiem == 0 then 
			self.LabMessage:setVisible(false)
		else
			self.LabMessage:setVisible(true)
		end
	end
end
function PackPanle:initItem_11(mId)
	-- body
	if cache.Player:getSeverTime()>conf.Item:getUseTime(self.data.mId) then --超时
		self.BtnUsing:setTitleText(res.str.PACK_USE) --使用
		--self.BtnUsing:addTouchEventListener(handler(self, self.onUsingCallBack))
	else
		self.BtnUsing:setTitleText(res.str.DOUBLE_DEC21) --跳转
		--self.BtnUsing:addTouchEventListener(handler(self, self.onBtnGoToCallBack))
	end
end

--详细信息
function PackPanle:setData(data)
	self.falg_11 = false
	self.data=data
	local type=conf.Item:getType(data.mId)
	self.Item_type=type
	self.mId = data.mId

	local lv=conf.Item:getItemQuality(data.mId)
	self.data.item_lv=lv
	self:setFrameQuality(lv)



	local name=conf.Item:getName(data.mId,data.propertys)
	self.data.item_name=name
	self:setLabName(name)
	
	local path = conf.Item:getItemSrcbymid(data.mId,data.propertys)
	self:setBImage(path)
	self.data.item_path=path

	local sptype = conf.Item:getSp_type(data.mId) --碎片类型

	local part=conf.Item:getItemPart(data.mId)--
	self:setPro(part,data.propertys)
	self:setButtonName(self.Item_type)
	--res.str.PACK_COUT
	self.LabMessage:setVisible(false)
	self._icon_on:setVisible(false)
	self.BtnUsing:setVisible(true)
	self.BtnUsing10:setVisible(true)

	self.BtnUsing:setBright(true)
	self.BtnUsing10:setBright(true)

	self.Lable_describe:setVisible(false)
	self.Image_lv:setVisible(false)

	self.BtnFrame:addTouchEventListener(handler(self, self.onOpenItem))
	self.BtnUsing:addTouchEventListener(handler(self,self.onUsingCallBack))
	self.BtnUsing10:addTouchEventListener(handler(self,self.onUsingCallBack_10))

	self._7scard:setVisible(false)
	local conf_data = conf.Item:getItemConf(self.data.mId)
	if checkint(conf_data.zhuan)>0 then
		self._7scard:setVisible(true)
		self._7scard:loadTexture(res.icon.ZHUANFRAME[conf_data.zhuan])
		--self._7slab:setString(conf_data.zhuan)
	end

	if type == pack_type.PRO then
		self.Lable_describe:setVisible(true)
		self:setDscribe(conf.Item:getItemDescribe(data.mId))

		local is_all = conf.Item:getis_use_all(data.mId)
		if not is_all then 
			is_all = 0
		end 
		self:setAmount(data.amount,is_all)

		local islimit=conf.Item:getLimitNum(data.mId)
		--print("islimit = "..islimit)
		
		if  self.data.propertys[40109] then
			print(string.formatNumberToTimeString(self.data.propertys[40109].value))
			self:changeTimes()
			self.LabMessage:setVisible(false)
			if self.data.mId == 221015025 or 221015026 == self.data.mId or 221015027 == self.data.mId then
				self.BtnUsing:setTitleText(res.str.PACK_USE)
			end
			self:schedule(self.changeTimes,1.0)
		elseif self.data.propertys[40108] then
			self:changeTimes()
			self.LabMessage:setVisible(false)
			if self.data.mId == 221015065 then
				self.BtnUsing:setTitleText(res.str.PACK_DEC1)
			elseif 221015011 == self.data.mId or 221015012 == self.data.mId then 
				self.BtnUsing:setTitleText(res.str.PACK_USE)
			end
			self:schedule(self.changeTimes,1.0)
		elseif islimit ~= 0 then
			local usenums  =cache.Pack:getusenums(data.mId)  --data.propertys[312] and  data.propertys[312].value or 0
			--print("usenums = "..usenums)
			local msg = string.format(res.str.PACK_COUT,islimit - usenums)
			self:setMessage(msg)
			self.LabMessage:setVisible(true)
		end

		local gt =  {[221015021] = 1,[221015022]=1,[221015023]=1,[221015024]=1} --双11道具
		if gt[data.mId] then
			self.falg_11 = true
			self:initItem_11()--双11活动
		end

		if sptype and sptype > 0 then
			self.BtnUsing:setTitleText(res.str.PACK_DEC1)
			self.BtnUsing10:setTitleText(res.str.PACK_DEC1)

			local arg = conf.Item:getArg1(self.data.mId)
			self:setDscribe("\n  "..res.str.DEC_NEW_42 ..self.data.amount.."/"..arg.arg2)

			if self.data.amount >= arg.arg2 then
				self.BtnUsing:setTitleText(res.str.DEC_NEW_43)
				--self.BtnUsing:addTouchEventListener(handler(, method))
			else
				self.BtnUsing:addTouchEventListener(handler(self, self.onOpenItem2))
			end
			
			--self.use  arg.arg2

		end 	
	elseif type == pack_type.EQUIPMENT then
		self.Lable_describe:setVisible(false)
		self.Lable_amount:setVisible(false)
		self.Image_lv:setVisible(true)
		self:setLv(mgr.ConfMgr.getItemQhLV(data.propertys))
	
		if data.index > 400000 then --装备了的
			self._icon_on:setVisible(true)
			self._icon_on:loadTexture(res.icon.PACK.wear)
		else 
			self.BtnUsing:setVisible(false)
			self.BtnUsing10:setVisible(false)
		end

		if lv < 4 then 
			self.BtnUsing:setVisible(false)
			self.BtnUsing10:setVisible(false)
		end 

		self.img_amount:setVisible(false)

		if data.index<400000 then --装备未穿戴 并且可退化
			if mgr.ConfMgr.getItemQhLV(data.propertys) > 0 or mgr.ConfMgr.getItemJh(data.propertys)>0  then    
				self.BtnUsing:setVisible(true)
				self.BtnUsing:setTitleText(res.str.PACK_TUIHUA)
				self.BtnUsing:addTouchEventListener(handler(self, self.onbtnTuihua)) 
			else
				self.BtnUsing:setVisible(false)
			end 
		end 
	elseif type == pack_type.MATERIAL then--果实合成材料
		
		self._7scard:setVisible(false)
		self.Image_lv:setVisible(false)
		self.PanelAttribute:setVisible(true)
		self.PanelAttribute:getChildByName("Image__1"):setVisible(false)
		self.PanelAttribute:getChildByName("Image__2"):setVisible(false)
		self.PanelAttribute:getChildByName("Image__3"):setVisible(false)
		self.LabMessage:setVisible(false)
		self:setDscribe(conf.Item:getItemDescribe(data.mId))
		self:setAmount(data.amount,0)
		self._icon_on:setVisible(false)
		self.Lable_describe:setVisible(true)
		
	else
		self.Image_lv:setVisible(true)
		self.Lable_describe:setVisible(false)
		self.Lable_amount:setVisible(false)
		self:setLv(mgr.ConfMgr.getLv(data.propertys))

		local pos = conf.Item:getBattleProperty(data)
		if pos>0 then 
			self._icon_on:setVisible(true)
			self._icon_on:loadTexture(res.icon.PACK.play)
		elseif data.propertys[317] and data.propertys[317].value > 0 then
			self._icon_on:setVisible(true)
			self._icon_on:loadTexture(res.icon.PACK.xiaohuoban)

			self.BtnUsing:setVisible(false)
			self.BtnUsing10:setVisible(false)
		else
			self.BtnUsing:setVisible(false)
			self.BtnUsing10:setVisible(false)
		end
		self.img_amount:setVisible(false)
		--self:setGray()updateUi
		--print("pos = "..pos)
		if  pos == 0 then 
			--print("pos = "..pos)
			local conf_data = conf.Item:getItemConf(data.mId)
			if mgr.ConfMgr.getLv(data.propertys) > 1 or mgr.ConfMgr.getItemJJ(data.propertys) >0 
        	or mgr.ConfMgr.getItemJH(data.propertys)>0 or checkint(conf_data.old_id) > 0 then
        		self.BtnUsing:setBright(true)
				self.BtnUsing:setTouchEnabled(true)
				--print("dddd .. ")
				self.BtnUsing:setVisible(true)
				self.BtnUsing:setTitleText(res.str.PACK_TUIHUA)
				self.BtnUsing:addTouchEventListener(handler(self, self.onbtnTuihua)) 
			else
				self.BtnUsing:setVisible(false)
			end 
		end 
	end
	

	if self.view:getChildByName("armature") then 
		self.view:getChildByName("armature"):removeFromParent()
	end

	if data.new  then 
		local ccsize = self.view:getContentSize()
		local posx  = ccsize.width/2
		local posy =  ccsize.height/2
		local params =  {id=404084, x=posx,y=posy,addTo=self.view,addName = "armature",
		endCallFunc=nil,from=nil,to=nil, playIndex=0}
		mgr.effect:playEffect(params)
		--G_TipsOfstr("str")
	end

end
function PackPanle:getData()
	-- body
	return self.data
end
--设置按钮的名字
function PackPanle:setButtonName(type)
	self.BtnUsing10:setBright(true)
	self.BtnUsing10:setTouchEnabled(true)
	if type ==  pack_type.PRO then
		self.BtnUsing:setTitleText(res.str.PACK_USE)
		self.BtnUsing10:setTitleText(res.str.PACK_USE10)
	elseif type == pack_type.EQUIPMENT then
		self.BtnUsing:setTitleText(res.str.PACK_STRENG)
		self.BtnUsing10:setTitleText(res.str.PACK_REFINING)
	elseif type == pack_type.MATERIAL then
		self.BtnUsing10:setVisible(true)
		self.BtnUsing10:setTitleText(res.str.PACK_DECS_SELL)
		self.BtnUsing:setVisible(true)
		self.BtnUsing:setTitleText(res.str.PACK_DECS_SELL)
	else
		self.BtnUsing:setTitleText(res.str.PACK_JINGHUA)
		self.BtnUsing10:setTitleText(res.str.PACK_LVUP)

		--self.BtnUsing10:setBright(true)
		--self.BtnUsing10:setTouchEnabled(true)
		if G_CardisEqualToHero(self.data) then 
			self.BtnUsing10:setBright(false)
			self.BtnUsing10:setTouchEnabled(false)
		end 

		self.BtnUsing:setBright(true)
		self.BtnUsing:setTouchEnabled(true)
		if G_CardisMax(self.data) then 
			self.BtnUsing:setBright(false)
			self.BtnUsing:setTouchEnabled(false)
		end 

	end
end
--设置框的品质
function PackPanle:setFrameQuality(lv)

	local framePath=res.btn.FRAME[lv]
	--debugprint("path"..framePath)
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[lv])
	self:addStar(lv)
end
--设置物品名字
function PackPanle:setLabName(name)
	self.LabName:setString(name)
end
--设置信息
function PackPanle:setMessage(message)
	self.LabMessage:setString(message)
end
--添加星星
function PackPanle:addStar( num )
	self.IconStar:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.IconStar:getContentSize().height
	local iconwidth=self.IconStar:getContentSize().width
	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setPosition(sprite:getContentSize().width/2+sprite:getContentSize().width*(i-1),iconheight/2)
		self.IconStar:addChild(sprite)
	end
end



--------------------------------------------------------------------单独对符文
function PackPanle:setDataFw( data )
	-- body
	self._7scard:setVisible(false)
	self.BtnUsing10:setVisible(false)
	self.BtnUsing:addTouchEventListener(handler(self,self.onRuneCallBack))

	self.data=data

	local colorlv = conf.Item:getItemQuality(data.mId)
	self:addStar(colorlv)
	--外框
	local framePath=res.btn.FRAME[colorlv]
	self.BtnFrame:loadTextureNormal(framePath)

	local type=conf.Item:getType(data.mId)
	self.Item_type=type
	--名字
	local name=conf.Item:getName(data.mId,data.propertys)
	self.LabName:setString(name)
	self.LabName:setColor(COLOR[colorlv])
	--icon
	local path = conf.Item:getItemSrcbymid(data.mId)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:loadTexture(path)
	--等级
	local lv = data.propertys[315] and data.propertys[315].value or 0
	--print(" lv "..lv)
	self.Lable_lv:setString(lv)
	self.Image_lv:setVisible(true)
	--数量无
	self.img_amount:setVisible(false)
	self.Lable_describe:setString("")
	self.LabMessage:setString("")

	for i = 1 , 3 do 
		self.PanelAttribute:getChildByName("Image__"..i):setVisible(false)
		self.PanelAttribute:getChildByName("Image__"..i):ignoreContentAdaptWithSize(true)
	end 
	
	--printt(data)
	
	local t = {}
	t.mId = data.mId
	t.propertys = data.propertys
	--print("name"..name)
	--printt(data)
	--计算属性
	local prot =  data --G_CalculateRunePro(t)
	local count = 0
	for k ,v in pairs(res.str.DEC_NEW_04) do 
		if count >= 3 then
			break
		end
		if prot.propertys[v] then
			count = count + 1

			local value = prot.propertys[v].value
			local img_dec = self.PanelAttribute:getChildByName("Image__"..count)
			img_dec:setVisible(true)
			local lab_value = img_dec:getChildByName("Text_32_"..count)


			img_dec:loadTexture(res.font.FW[v])
			if v > 200 then
				value = value .. "%"
			end
			lab_value:setString(value)

			lab_value:setPositionX(img_dec:getContentSize().width+img_dec:getPositionX())
		end
	end

	self._icon_on:loadTexture(res.icon.PACK.wear)
	self.BtnUsing:setTitleText(res.str.DEC_NEW_02)	
	self.BtnUsing:setTouchEnabled(true)
	self.BtnUsing:setBright(true)
	if lv == conf.Item:getCardMaxlv(data.mId) or lv == cache.Player:getLevel() then
		self.BtnUsing:setTouchEnabled(false)
		self.BtnUsing:setBright(false)
	end

	if data.index < 600000 then
		self._icon_on:setVisible(false)
		self.BtnUsing:setVisible(false)
	else
		self._icon_on:setVisible(true)
		self.BtnUsing:setVisible(true)
	end

	if self.view:getChildByName("armature") then 
		self.view:getChildByName("armature"):removeFromParent()
	end

	if data.new  then 
		local ccsize = self.view:getContentSize()
		local posx  = ccsize.width/2
		local posy =  ccsize.height/2
		local params =  {id=404084, x=posx,y=posy,addTo=self.view,addName = "armature",
		endCallFunc=nil,from=nil,to=nil, playIndex=0}
		mgr.effect:playEffect(params)
	end
end


function PackPanle:onRuneCallBack(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("升级")
		local _data = cache.Rune:getUseinfoVec()

		local card_pos = tonumber(string.sub(self.data.index,3,3))--数码兽 上阵位置 
		local part = tonumber(string.sub(self.data.index,-1,-1)) --符文的放置位置
		local view2 = mgr.ViewMgr:showView(_viewname.RUNE_LV)
		if view2 then
			view2:setData(_data)
			view2:setSelectIndex(card_pos,part)	
		end	
	end
end


















return PackPanle