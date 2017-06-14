
local pet=require("game.things.PetUi")
local ScollLayer = require("game.cocosstudioui.ScollLayer")
local PetDetailWidget=require("game.views.promote.PetDetailWidget")
local PetDetailView=class("PetDetailView",base.BaseView)


function PetDetailView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	self.ScollView=self.view:getChildByName("ScrollView_1")
	
	self.clone=self.view:getChildByName("Panel_clone")
	self.PetName = self.view:getChildByName("Text_name")
	self.Panel_1=self.view:getChildByName("Panel_1"):retain()
	self.Panel_1:removeFromParent()
	--升级按钮
	self._btnLvup = self.Panel_1:getChildByName("Button_5")
	self._btnLvup:addTouchEventListener(handler(self,self.onLvUpCallBack))
	--进化按钮
	self._btnjinghua =  self.Panel_1:getChildByName("Button_5_0")
	self._btnjinghua:addTouchEventListener(handler(self,self.onLvJingUPCallBack))
	
	--放形象容器
	self.PetPanel=self.view:getChildByName("Image_35")
	--放星星
	self.StarPanel=self.view:getChildByName("Panel_star_1")
	
	--左按钮
	self.BtnLeft=self.view:getChildByTag("1001")
	self.BtnLeft:addTouchEventListener(handler(self,self.onCallBack))
	--右边
	self.BtnRight=self.view:getChildByTag("1002")
	self.BtnRight:addTouchEventListener(handler(self,self.onCallBack))
	--更换
	self.BtnChage = self.view:getChildByName("Button_change")
	self.BtnChage:addTouchEventListener(handler(self,self.onChange))
	--下阵
	self.btn_xia = self.view:getChildByName("Button_change_0") 
	self.btn_xia:addTouchEventListener(handler(self, self.onbtnxia))

	local offex = 10
	self.btn_xia:setPositionX(self.btn_xia:getPositionX()+offex)

	--天赋
	self.LableGift=self.view:getChildByName("Image_bg_4"):getChildByName("Text_power_3")
	--宠物的各个属性
	local Image=self.Panel_1:getChildByName("Image_9")
	self.Lable_lv=Image:getChildByName("Panel_2"):getChildByName("Text_6")
	self.Lable_atk=Image:getChildByName("Panel_2_0"):getChildByName("Text_6_10")
	self.Lable_hp=Image:getChildByName("Panel_2_0_0"):getChildByName("Text_6_10_14")
	self.Lable_def=Image:getChildByName("Panel_2_0_1"):getChildByName("Text_6_10_18")
	self.Lable_crit=Image:getChildByName("Panel_2_0_2"):getChildByName("Text_6_10_22")
	self.Lable_resistant_crit=Image:getChildByName("Panel_2_0_3"):getChildByName("Text_6_10_26")
	self.Lable_power=Image:getChildByName("Panel_2_0_4"):getChildByName("Text_6_10_30")
	self.Lable_hit=Image:getChildByName("Panel_2_0_5"):getChildByName("Text_6_10_34")
	self.Lable_dodge=Image:getChildByName("Panel_2_0_6"):getChildByName("Text_6_10_38")
	self.Lable_baojishangs=Image:getChildByName("Panel_2_0_7"):getChildByName("Text_6_10_42")
	self.lab_pojia =Image:getChildByName("Panel_2_0_3_0"):getChildByName("Text_6_10_26_8") 
	self.lab_gedang = Image:getChildByName("Panel_2_0_7_0"):getChildByName("Text_6_10_42_8") 
	-------
	self.spr7s =  self.view:getChildByName("Image_13") 
	self.spr7s:ignoreContentAdaptWithSize(true)

	self.pan_4 = self.view:getChildByName("Panel_4")--:getChildByName("Text_1"):clone()
	--self.lab_card_dec:setString("")
	--一个盖在宠物升上的层 ，看起来像变灰一样
	--self.zedang = self.view:getChildByName("Panel_3")
	--self.zedang:setVisible(false)

	self.PetDetailWidgetList={} 
	--self.PetList = {}
	--向右的箭头 2个 
	self._Jian_first =  self.view:getChildByName("Image_37")
	self._Jian_second =  self.view:getChildByName("Image_37_0")

	self.NowSelectIndex = 1
	self:initPanel()

	local posx,posy =  self.PetPanel:getPosition()
	local ccsize = self.PetPanel:getContentSize()
	local rect =cc.rect(posx,posy,ccsize.width,ccsize.height)
	local layer = ScollLayer.new(rect,40)
	layer:setName("touchlayer")
	layer:setMoveLeftCalllBack(handler(self,self.prv))
	layer:setMoveRightCalllBack(handler(self,self.next))
	self:addChild(layer)
	
    G_FitScreen(self,"Image_bg")

    self:initDec()
end

function PetDetailView:initDec( ... )
	-- body
	local img = self.Panel_1:getChildByName("Image_9")
	img:getChildByName("Panel_2_0"):getChildByName("Text_5_8"):setString(res.str.PET_DEC_06)
	img:getChildByName("Panel_2_0_0"):getChildByName("Text_5_8_12"):setString(res.str.PET_DEC_07)
	img:getChildByName("Panel_2_0_1"):getChildByName("Text_5_8_16"):setString(res.str.PET_DEC_08)
	img:getChildByName("Panel_2_0_2"):getChildByName("Text_5_8_20"):setString(res.str.PET_DEC_09)
	img:getChildByName("Panel_2_0_3"):getChildByName("Text_5_8_24"):setString(res.str.PET_DEC_10)
	img:getChildByName("Panel_2_0_4"):getChildByName("Text_5_8_28"):setString(res.str.PET_DEC_11)
	img:getChildByName("Panel_2_0_5"):getChildByName("Text_5_8_32"):setString(res.str.PET_DEC_12)
	img:getChildByName("Panel_2_0_6"):getChildByName("Text_5_8_36"):setString(res.str.PET_DEC_13)
	img:getChildByName("Panel_2_0_7"):getChildByName("Text_5_8_40"):setString(res.str.PET_DEC_14)
	img:getChildByName("Panel_2_0_3_0"):getChildByName("Text_6_10_26_8"):setString(res.str.DEC_NEW_03[116])
	img:getChildByName("Panel_2_0_7_0"):getChildByName("Text_5_8_40_4"):setString(res.str.RES_RES_94)

	self.Panel_1:getChildByName("Button_5"):setTitleText(res.str.PET_DEC_15)
	self.Panel_1:getChildByName("Button_5_0"):setTitleText(res.str.PET_DEC_16)

	self.view:getChildByName("Button_change"):setTitleText(res.str.PET_DEC_17)
	self.view:getChildByName("Button_change_0"):setTitleText(res.str.PET_DEC_18)
	
end

---左右按钮点击
function PetDetailView:onCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		--self:initPanel()
		if send:getTag() == 1001 then
			self:prv()
		elseif send:getTag() ==  1002 then
			self:next()
		end
	end
end
function PetDetailView:initPanel( data )
	--print("****************************************************")
	self.ScollView:removeAllChildren()


	local sv_w=self.ScollView:getContentSize().width
	local sv_h=self.ScollView:getContentSize().height
	--local starY=415
	local widgetY =0
	local size=4
	--亲密度面板
	self.lab_card_dec = self.pan_4:clone()
	self.lab_card_dec:setPositionY(widgetY)
	self.lab_card_dec:setPositionX(15)
	self.lab_card_dec:addTo(self.ScollView)

	widgetY = widgetY + self.lab_card_dec:getContentSize().height + 15 

	--其他面板
	for i=1,size do --亲密
		local widget=PetDetailWidget.new(self.clone)
		widget:setWidgetPosition(0,widgetY)
		widget:setTitleData(res.font.MESSAGE[i])
		self.ScollView:addChild(widget)
		widgetY =widgetY+widget:getHeight()
		self.PetDetailWidgetList[#self.PetDetailWidgetList+1]=widget
	end
	widgetY=widgetY+self.Panel_1:getContentSize().height
	--基本属性面板
	self.Panel_1:setPosition(0,widgetY)
	self.ScollView:addChild(self.Panel_1)
	self.ScollView:setInnerContainerSize(cc.size(sv_w,widgetY))
end

function PetDetailView:updateSkillPanel(data,y)
	local widget =self.PetDetailWidgetList[4]
	local widgetY =y
	local skill_list=conf.Item:getSkillList(data.mId,data.propertys)
	local listText={}
	for i=1,#skill_list do
		local listname={}
		--listname.ImageIcon=true
		listname.Name=conf.Skill:getSkillName(skill_list[i])
		listname.Text=conf.Skill:getSkillDec(skill_list[i])
		listname.color = cc.c3b(255,255,255)
		if not listname.Text then 
			debugprint(skill_list[i].." 技能没描述")
		end 
		listText[#listText+1]=listname
	end
	local table={}
	table.Label=listText
	widget:updatePanelSize(table)
	widget:setWidgetPosition(0,widgetY)
	return widget:getHeight()
end
--天赋是否开启最大那个
function PetDetailView:getTianfuOpen()
	-- body
	local data_=self.data[self.NowSelectIndex]
	local jie = data_.propertys[307] and data_.propertys[307].value or 0

	local jinghua = data_.propertys[310] and data_.propertys[310].value or 0

	--print("jie .."..jie)

	if jie == 0 then 
		if jinghua <2 then 
			return 1 --第一个天赋开启
		elseif jinghua <5 then
			return 2 
		else
			return 3
		end 
	elseif jie == 1 then  
		if jinghua < 5 then
			return 4 
		else 
			return 5
		end 
	elseif jie == 2 then 
		if jinghua < 5 then 
			return 6
		else
			return 7
		end 
	else
		return 8
	end 	
	return 1 
end
function PetDetailView:updateOldGiftPanel(data,y )
	-- body
	local widget =self.PetDetailWidgetList[3]
	local widgetY =y
	local conf_data = conf.Item:getItemConf(data.mId)
	if not conf_data.old_tianfu  then
		widget:setVisible(false)
		return 0
	end
	self.PetDetailWidgetList[2]:setTitleData(res.font.TIANFU_7S)
	

	widget:setVisible(true)
	local listText = {}
	local conf_data = conf.Item:getItemConf(data.mId)
	for k , v in pairs(conf_data.old_tianfu) do 
		local listname={}
		listname.Name=conf.CardGift:getGiftName(v)
		listname.Text=conf.CardGift:getDescription(v)
		if listname.Name and listname.Name~="" then --特别处理 如果没有配置 表示这个阶段不想给 7s 卡 草
			listname.color = cc.c3b(255,104,22)
			listText[#listText+1]=listname
		end
	end

	local table={}
	table.Label=listText
	widget:updatePanelSize(table)
	widget:setWidgetPosition(0,widgetY)
	return widget:getHeight()
end


--更新天赋
function PetDetailView:updateGiftPanel(data,y)
	local widget =self.PetDetailWidgetList[2]
	local widgetY =y
	local gift_list=conf.Item:getGiftList(data.mId)

	local listText={}
	local max = self:getTianfuOpen()

	--[[local conf_data = conf.Item:getItemConf(data.mId)
	for k , v in pairs(conf_data.old_tianfu) do 
		local listname={}
		listname.Name=conf.CardGift:getGiftName(v)
		listname.Text=conf.CardGift:getDescription(v)
		if listname.Name and listname.Name~="" then --特别处理 如果没有配置 表示这个阶段不想给 7s 卡 草
			listname.color = cc.c3b(255,104,22)
			listText[#listText+1]=listname
		end
	end]]--


	for i=1,#gift_list do
		if i > 1 then
			local listname={}
			listname.Name=conf.CardGift:getGiftName(gift_list[i])
			listname.Text=conf.CardGift:getDescription(gift_list[i])
			if listname.Name and listname.Name~="" then --特别处理 如果没有配置 表示这个阶段不想给 7s 卡 草
				if i <= max then 
					listname.color = cc.c3b(255,104,22)
				else
					--todo
					listname.color = cc.c3b(0xaf,0xac,0xac)
				end 

				listText[#listText+1]=listname
			end
		else
			self.LableGift:setString(conf.CardGift:getDescription(gift_list[i]))
		end
	end
	--local color1 = cc.c3b(255,104,22)
	--local color2 = cc.c3b(0xaf,0xac,0xac)


	local table={}
	table.Label=listText
	widget:updatePanelSize(table)
	widget:setWidgetPosition(0,widgetY)
	return widget:getHeight()
end

--更新亲密度
function PetDetailView:updateIntimacyPanel(data,y)
	local widget =self.PetDetailWidgetList[1]
	local widgetY =y


	local Intimacy_id=conf.Item:getIntimacyID(data.mId)

	local table={}
	--table.isFriend = self.isFriend
	if data.propertys[308] and data.propertys[308].value > 0 then
		table.isFriend = false
	else
		table.isFriend = true
	end

	if Intimacy_id then 
		table.ImageHeadData=conf.CardIntimacy:getIntimacy(Intimacy_id)
		widget:updatePanelSize(table,self.data)
	else
		widget:updatePanelSize(table,self.data)
		widget:setDecValue(res.str.DEC_NEW_44)
		--lab:setString(res.str.dec)
	end 
	
	widget:setWidgetPosition(0,widgetY)
	return  widget:getHeight()
end

function PetDetailView:updatePanel( data)
	local widgetY =0
	local h=0

	--亲密度面板
	--self.lab_card_dec:setPositionY(widgetY)
	--self.lab_card_dec:setPositionX(15)
	--self.lab_card_dec:addTo(self.ScollView)
	local size_h = self.lab_card_dec:getContentSize().height
	if not self.str then
		self.lab_card_dec:setVisible(false)
		size_h = 0
	else
		self.lab_card_dec:setVisible(true)
	end
	h = size_h
	widgetY = widgetY + h

	--h = h + 

	h=self:updateIntimacyPanel(data,widgetY- size_h)
	widgetY=widgetY+h
	
	h=self:updateGiftPanel(data,widgetY-size_h)
	widgetY=widgetY+h
	h = self:updateOldGiftPanel(data,widgetY-size_h)
	widgetY=widgetY+h
	h=self:updateSkillPanel(data,widgetY-size_h)
	widgetY=widgetY+h

	widgetY=widgetY+self.Panel_1:getContentSize().height
	self.Panel_1:setPosition(0,widgetY-size_h)
	self.ScollView:setInnerContainerSize(cc.size(640,widgetY))

	self.lab_card_dec:setPositionY(widgetY-size_h/2)
end


--更换选择出站
function PetDetailView:onChange(send,eventtype) 
	if  eventtype == ccui.TouchEventType.ended then
		if not self.isFriend then
			local data=self.data[self.NowSelectIndex]
			local pos=conf.Item:getBattleProperty(data)
			mgr.ViewMgr:showView(_viewname.BATTLE_LIST):setData(pos,13)--13代表阵型交换
		else
			local view = mgr.ViewMgr:showView(_viewname.CRADFRIEND_LIAS)
			local data=self.data[self.NowSelectIndex]
       		view:setPos(data.propertys[317].value)
		end
	end
end

function PetDetailView:onbtnxia( send,eventtype )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
		if not self.isFriend then
			local batton_data=self.data[self.NowSelectIndex]
			local data={}
			data.toIndex= conf.Item:getBattlePropertyTo(batton_data)
			data.index=batton_data.index
			data.mId=batton_data.mId
			data.opType = 12--阵型下阵
			printt(data)
			proxy.card:reqBattle(data)
	        ---点击出战
	        local ids = {1010}
	        mgr.Guide:continueGuide__(ids)
	    else
	    	local batton_data=self.data[self.NowSelectIndex]
	    	local param = {opType = 3,xhbIndex = batton_data.propertys[317].value ,packIndex=batton_data.index}
			proxy.card:send_104008(param)
	    end
	    self:onCloseHandler()
	end 
end

function PetDetailView:onCloseHandler() 
	self.Panel_1:release()
	self.super.onCloseHandler(self)
end

function PetDetailView:setData(data)
	self.data=data
	self.MaxIndex=#self.data
end

--请求详细信息更新
function PetDetailView:updateSecond(data)
	-- body

	if self.data then 
		for k ,v in pairs(self.data) do 
			if v.index == data.itemInfo.index then
				self.data[k].propertys = vector2table(data.itemInfo.propertys,"type")
				break
			end 
		end 
	end

	local data_=self.data[self.NowSelectIndex]

	if data_ then 
		self:updatePropertyPanel(data_)
		self:updatePet(data_)
		self:updatePanel(data_)
		local quality=conf.Item:getItemQuality(data_.mId)
		self:updateStar(quality)
	end 
end

function PetDetailView:updateData(data)
	-- body
	if self.data then 
		
	end
end

--选中的宠物信息更新
function PetDetailView:updateDataSelect()
	--if not self.data then return end 
	--self.data[self.NowSelectIndex]=data
	if self.NowSelectIndex <=#self.data then 
		self:selectUpdate(self.NowSelectIndex)
	else
		self.NowSelectIndex = #self.data-1
		self:selectUpdate(self.NowSelectIndex)
	end 

	
end
function PetDetailView:selectUpdate(pos,flag)
	if not self.data then return end 
	self.NowSelectIndex =  pos
	local data_=self.data[pos]
	if data_ then
		--请求详细信息
		if not flag then 
			proxy.pack:reqDetailed(pack_type.SPRITE,data_.index)
		end 

		self:updatePropertyPanel(data_)
		self:updatePet(data_)
		self:updatePanel(data_)
		local quality=conf.Item:getItemQuality(data_.mId)
		self:updateStar(quality)
	end
end
--  进化界面

function PetDetailView:onLvJingUPCallBack( send ,eventtype)
	-- body
	if eventtype ==  ccui.TouchEventType.ended then

		local colorlv =conf.Item:getItemQuality(self.data[self.NowSelectIndex].mId)
		if colorlv < 4 then 
			G_TipsForColorEnough()
			return 
		end 

		local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
		local index= targetview:getNowPetIndex(self.data[self.NowSelectIndex])
		if index then

			--targetview:updateColorUpPet(index)
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

--升级界面
function PetDetailView:onLvUpCallBack(send,eventtype)
	if eventtype ==  ccui.TouchEventType.ended then
		--mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
		--self:closeSelfView()
		local colorlv =conf.Item:getItemQuality(self.data[self.NowSelectIndex].mId)
		if colorlv < 4 then 
			G_TipsForColorEnough(res.str.COLORTOOLOWER2)
			return 
		end 

		local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
		local index= targetview:getNowPetIndex(self.data[self.NowSelectIndex])


		if index then
			targetview:updateTargetPet(index)
			mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
			targetview:setPageBtnStatue(1)
			self:closeSelfView()
            local ids = {1022}
            mgr.Guide:continueGuide__(ids)
		else
			debugprint("没有出战数据")
		end
	end
end

--为了界面跳转用的
function PetDetailView:nextStep(p)
	-- body
	local pageindex = p 
	pageindex  = (pageindex and  pageindex>0) and pageindex or 1
	if pageindex == 1 then 
		local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
		local index= targetview:getNowPetIndex(self.data[self.NowSelectIndex])
		if index then
			targetview:updateTargetPet(index)
			mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
			self:closeSelfView()
		else
			debugprint("没有出战数据")
		end
	else
		local targetview=mgr.ViewMgr:createView(_viewname.PROMOTE_LV)
		local index= targetview:getNowPetIndex(self.data[self.NowSelectIndex])
		if index then
			--targetview:updateColorUpPet(index)
			targetview:updateTargetPet(index)
			mgr.ViewMgr:showView(_viewname.PROMOTE_LV)
			targetview:ChoosePage(2)
			self:closeSelfView()
		else
			debugprint("没有出战数据")
		end
	end 
end

function PetDetailView:next(  )
	--self:initPanel()
	self.NowSelectIndex = self.NowSelectIndex + 1
	if self.NowSelectIndex > self.MaxIndex then
		self.NowSelectIndex = 1
	end
	self:selectUpdate(self.NowSelectIndex)
end
function PetDetailView:prv( )
	--self:initPanel()
	--debugprint("self.NowSelectIndex = "..self.NowSelectIndex)
	self.NowSelectIndex = self.NowSelectIndex - 1
	if self.NowSelectIndex < 1 then
		self.NowSelectIndex = self.MaxIndex
	end

	self:selectUpdate(self.NowSelectIndex)
end
--BUG #1859 数码兽：当数码兽等级》=主角等级或者数码兽等级=极限等级后，数码兽界面以及背包界面升
function PetDetailView:gray_btnLvup(data)
	-- body
	self._btnLvup:setBright(true)
	self._btnLvup:setTouchEnabled(true)
	--[[if G_CardisEqualToHero(data) then 
		self._btnLvup:setBright(false)
		self._btnLvup:setTouchEnabled(false)
	end]]-- 
end

function PetDetailView:gray_btnjinghua(data)
	-- body
	self._btnjinghua:setBright(true)
	self._btnjinghua:setTouchEnabled(true)
	--[[if G_CardisMax(data) then 
		self._btnjinghua:setBright(false)
		self._btnjinghua:setTouchEnabled(false)
	end ]]--
end

--设置宠物属性
function PetDetailView:updatePropertyPanel( data )
	--printt(data)
	self.spr7s:setVisible(false)
	local conf_data = conf.Item:getItemConf(data.mId)
	if conf_data.zhuan then
		self.spr7s:setVisible(true)
		self.spr7s:loadTexture(res.icon.ZHUAN[conf_data.zhuan])
	end

	local jj = data.propertys[307] and data.propertys[307].value or 0
	local jh = data.propertys[310] and data.propertys[310].value or 0

	if checkint(conf_data.new_id) >0 and  jj == 3 and   jh == 10 then
		self._btnjinghua:setTitleText(res.str.RES_RES_04)
	else
		self._btnjinghua:setTitleText(res.str.PET_DEC_16)
	end

	self:gray_btnLvup(data)
	self:gray_btnjinghua(data)

	local property=data.propertys
	local lv=mgr.ConfMgr.getLv(property)
	local atk=mgr.ConfMgr.getItemAtK(property)
	local def=mgr.ConfMgr.getItemDef(property)
	local crit =mgr.ConfMgr.getCrit(property)
	local resistantcrit=mgr.ConfMgr.getResistantCrit(property)
	local power=mgr.ConfMgr.getPower(property)
	local hit=mgr.ConfMgr.getHit(property)
	local dodge=mgr.ConfMgr.getDodge(property)
	local hp=mgr.ConfMgr.getItemHp(property)
	local name =conf.Item:getName(data.mId,property)
	local crit_hurt = mgr.ConfMgr.getCritSh(property)

	local colorlv =conf.Item:getItemQuality(data.mId)
	self.PetName:setColor(COLOR[colorlv])
	self.PetName:setString(name)
	self.Lable_lv:setString(lv)
	self.Lable_atk:setString(atk)
	self.Lable_hp:setString(hp)
	self.Lable_def:setString(def)
	self.Lable_crit:setString(crit)
	self.Lable_resistant_crit:setString(resistantcrit)
	self.Lable_power:setString(power)
	--print("hit = "..hit)
	self.Lable_hit:setString(hit)
	self.Lable_dodge:setString(dodge)

	self.Lable_baojishangs:setString(crit_hurt)

	self.lab_pojia:setString(property[116] and property[116].value or 0 )

	self.lab_gedang:setString(property[119] and property[119].value or 0 )

	local str  = conf.Item:getItemWord(data.mId)
	self.str = str
	debugprint(self.str)
	if str then
		--print("cccc")
		local strtable = string.split(str,"\n")
		--printt(strtable)
		self.lab_card_dec:getChildByName("Text_1"):setString(strtable[1] or "")
		self.lab_card_dec:getChildByName("Text_1_0"):setString(strtable[2] or "")
	else
		self.str = nil 
		self.lab_card_dec:getChildByName("Text_1"):setString("")
		self.lab_card_dec:getChildByName("Text_1_0"):setString("")
	end
end

--在里添加 数码兽当前以及之后的形态
function PetDetailView:updatePet( data )
	--[[for i=1,#self.PetList do
		self.PetList[i]:removeFromParent()
	end]]
	self.PetPanel:removeAllChildren()
	self.PetLis={}

	local x=self.PetPanel:getContentSize().width
	local y=self.PetPanel:getContentSize().height
	local node=pet.new(data.mId,data.propertys)

	local colorlv = conf.Item:getItemQuality(data.mId)
	--if colorlv > 4 then
		node.node:setScale(res.card.petdetail)
	--end 

	
	--node:setScale(0.65)
	node:setPosition(x/2,y/2)
	self.PetPanel:addChild(node)
	--self.PetList[#self.PetList+1]=node
	--table.insert(self.PetList,node)
	self._Jian_first:setVisible(false)
	self._Jian_second:setVisible(false)
	local propertys = clone(data.propertys)
	if not propertys[307] then 
		propertys[307]= {}
		propertys[307].value = 0
	end 

	propertys[307].value = propertys[307].value == 0 and  1 or  propertys[307].value +1
	
	if not propertys[310] then 
		propertys[310]= {}
		propertys[310].value = 0
	end
	for i = 1,3 do  
		--
		--print("propertys[307].value = "..propertys[307].value)
		propertys[310].value = 0
		local name_next = conf.Item:getName(data.mId,propertys)
		local src=conf.Item:getModelByJJ(data.mId,propertys[307].value+1) 
		if src and name_next then
			propertys[307].value = propertys[307].value +1 
			
			node=pet.new(nil,nil,src)
			--
			local sx = self.PetPanel:getContentSize().width/node:getContentSize() .width
			local sy = self.PetPanel:getContentSize().height/node:getContentSize().height

			node:setScaleX(sx)
			node:setScaleY(sy)

			node:setScale(0.6)
			--node.node:setOpacity(50)
			local posx = 0
			local posy = self.PetPanel:getContentSize().height/2
			node.node:setOpacity(90)
			local colorForlab = cc.c3b(127, 127, 127)
			if i == 1 then
				posx = self._Jian_first:getPositionX()-node:getContentSize().width*0.6 /2
				if propertys[310].value == 10 then 
					node.node:setOpacity(255)
					colorForlab = cc.c3b(245, 82, 251)
				end

			elseif i == 2 then 
				self._Jian_first:setVisible(true)
				posx = (self._Jian_first:getPositionX()+self._Jian_second:getPositionX())/2
			else
				self._Jian_second:setVisible(true)
				posx = self._Jian_second:getPositionX()+node:getContentSize().width*0.6/2
			end

			posx = posx-self.PetPanel:getPositionX() --+ self.PetPanel:getContentSize().width/2
			--node:setPosition(x/2+i*120+60,y/2)
			node:setPosition(posx, posy)

			local name_jie = conf.Item:getJieName(data.mId,propertys[307].value)
			--print(name_next)
			local label = display.newTTFLabel({
			    text = name_next.."\n("..name_jie..")",
			    size = 18,
			    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
			    x = posx,
			    y = 0,
			    color =colorForlab 
			})


			label:addTo(self.PetPanel,10)
			self.PetPanel:addChild(node,10)	
		else
			break
		end
	end
end
--改变星星显示
function PetDetailView:updateStar(num )
	-- body
	self.StarPanel:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.StarPanel:getContentSize().height
	local iconwidth=self.StarPanel:getContentSize().width
	local node=cc.Node:create()
	local h = 0
	local w = 0
	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setPosition(sprite:getContentSize().width*i,iconheight/2)
		node:addChild(sprite)
		h=sprite:getContentSize().height
		w=w+sprite:getContentSize().width
	end
	node:setPositionX((iconwidth-w)/2)
	self.StarPanel:addChild(node)
end

--单独我查看 时候 屏蔽一些东东
function PetDetailView:setOnlySee( ... )
	-- body
	self.isFriend = true 
	if self:getChildByName("touchlayer") then 
		self:getChildByName("touchlayer"):removeFromParent()
	end  

	self._btnLvup:setVisible(false)
	self._btnjinghua:setVisible(false)
	self.BtnRight:setVisible(false)
	self.BtnLeft:setVisible(false)
	self.BtnChage:setVisible(false)
	self.btn_xia:setVisible(false)
end

---阵容对比隐藏升级进化更换按钮
function PetDetailView:onCompareState()
	self.isFriend = true 
    self._btnLvup:setVisible(false)
    self._btnjinghua:setVisible(false)
    self.BtnChage:setVisible(false)
    self.btn_xia:setVisible(false)
end
--这个是小伙伴查看的时候
function PetDetailView:setFrienddata()
	-- body
	self.isFriend = true 
	self._btnLvup:setVisible(false)
    self._btnjinghua:setVisible(false)
end

return PetDetailView