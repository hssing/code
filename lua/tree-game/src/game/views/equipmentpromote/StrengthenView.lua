local PageButton=require("game.cocosstudioui.PageButton")

local StrengthenView = class("StrengthenView",base.BaseView)
local ScollLayer = require("game.cocosstudioui.ScollLayer")

function StrengthenView:ctor(  )
	self.super.ctor(self)
	--当前显示的那个界面
	self.AllEquipmentList = {}
	self._NowShowViewIndex = nil
	self.MaxEquipmentIndex = nil
	self.NowSelectEquipmentIndex =1 
	--是否自动强化
	self.AutoQh = false

	--self:addHead()
end
function StrengthenView:init()
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.PageButton=PageButton.new()
	self.PageButton:addButton(self.view:getChildByName("Panel_up"):getChildByName("Button_2_3"))
	self.PageButton:addButton(self.view:getChildByName("Panel_up"):getChildByName("Button_2_0_5"))
	self.PageButton:setBtnCallBack(handler(self,self._onPageBtnCallBack))
	self.Btn_Left = self.view:getChildByName("button_life")
	self.Btn_Left:setTag(110011)
	self.Btn_Left:addTouchEventListener(handler(self,self.onDirectionCallBack))

	self.Btn_right = self.view:getChildByName("button_right")
	self.Btn_right:setTag(110012)
	self.Btn_right:addTouchEventListener(handler(self,self.onDirectionCallBack))

	self.Img_bg = self.view:getChildByName("Image_bg")
	self.TitleName=self.view:getChildByName("Image_line"):getChildByName("Text_name")


	self.action_panle = self.view:getChildByName("Panel_2")
	--强化界面
	self.Panel_Qh=self.view:getChildByName("Panel_Qh")
	self.action1 = self.Panel_Qh:getChildByName("Image_6") 

	self.QH_Image_frame = self.Panel_Qh:getChildByName("Image_frame")
	self.labqhlv = self.QH_Image_frame:getChildByName("Image_lv_25_7_1"):getChildByName("Text_lv_6")

	self.QH_Image =self.QH_Image_frame:getChildByName("Image")

	self.Panel_down=self.Panel_Qh:getChildByName("Panel_down")

	self.QH_maxlv = self.Panel_down:getChildByName("Image_bg_title"):getChildByName("Text_48_14_3")

	self.QH_lv = self.Panel_down:getChildByName("Image_bg_title"):getChildByName("Text_48_14_3_0")


	--[[self.QH_now_atk =  Panel_down:getChildByName("Panel_35"):getChildByName("Text_19_11")
	self.QH_now_def = Panel_down:getChildByName("Panel_35_0"):getChildByName("Text_19_11_51")
	self.QH_now_crit = Panel_down:getChildByName("Panel_35_1"):getChildByName("Text_19_11_55")]]--


	self.QH_next_maxlv = self.Panel_down:getChildByName("Image_bg_title_next"):getChildByName("Text_48_14_3_57")
	self.QH_next_lv = self.Panel_down:getChildByName("Image_bg_title_next"):getChildByName("Text_48_14_3_57_0")

	--[[self.QH_next_atk =  Panel_down:getChildByName("Panel_35_next"):getChildByName("Text_19_11_61")
	self.QH_next_def = Panel_down:getChildByName("Panel_35_0_next"):getChildByName("Text_19_11_51_65")
	self.QH_next_crit = Panel_down:getChildByName("Panel_35_1_next"):getChildByName("Text_19_11_55_69")]]--

	self.Qh_Jb = self.Panel_down:getChildByName("Image_icon"):getChildByName("Text_70")

	self.Panel_down:getChildByName("Button"):addTouchEventListener(handler(self,self.onQhCallBack))

	self.Panel_down:getChildByName("Button_auto"):addTouchEventListener(handler(self,self.onAutoQhCallBack))
	-------------------------------------------------------------------
	self.AllEquipmentList = {
	{},
	{},
	{},
	{},
	{},
	{},
	}
	--装备材料列表

	-- self:initHasEquipmentData()
	self:getCacheEquipment()
	self:getCacheMaterial()
	--精炼界面
	self.Panel_JL=self.view:getChildByName("Panel_JL")
	self.action2 = self.Panel_JL:getChildByName("Panel_1") 
	
	--达到完美的界面
	self.Panel_end = self.Panel_JL:getChildByName("Panel_down_end"):setVisible(false)
	self.Panel_end.pro1 = self.Panel_end:getChildByName("Panel_35_15")
	self.Panel_end.pro1:setVisible(false)
	self.Panel_end.pro1.dec = self.Panel_end.pro1:getChildByName("Text_39_18_9_28")
	self.Panel_end.pro1.value = self.Panel_end.pro1:getChildByName("Text_atk")

	self.Panel_end.pro2 = self.Panel_end:getChildByName("Panel_35_0_17")
	self.Panel_end.pro2:setVisible(false)
	self.Panel_end.pro2.dec = self.Panel_end.pro2:getChildByName("Text_39_18_9_49_32")
	self.Panel_end.pro2.value = self.Panel_end.pro2:getChildByName("Text_def")

	self.Panel_end.pro3 = self.Panel_end:getChildByName("Panel_35_1_19")
	self.Panel_end.pro3:setVisible(false)
	self.Panel_end.pro3.dec = self.Panel_end.pro3:getChildByName("Text_39_18_9_53_36")
	self.Panel_end.pro3.value = self.Panel_end.pro3:getChildByName("Text_crit")
	--self.Panel_end_atk = self.Panel_end:getChildByName("Panel_35_15"):getChildByName("Text_atk")
	--self.Panel_end_hp = self.Panel_end:getChildByName("Panel_35_0_17"):getChildByName("Text_def")
	--self.Panel_end_crit = self.Panel_end:getChildByName("Panel_35_1_19"):getChildByName("Text_crit")

	self.Panel_end_nowlv = self.Panel_end:getChildByName("Panel_titile"):getChildByName("Text_now_value")

	self.Panel_end_maxlv = self.Panel_end:getChildByName("Panel_titile"):getChildByName("Text_next_value")

	self.Panel = self.Panel_JL:getChildByName("Panel_60")


	self.BtnAdd =self.Panel:getChildByName("Button_31")
	self.BtnAdd:addTouchEventListener(handler(self,self.onAddCallBack))


	self.LiftFrame = self.Panel:getChildByName("Image_frame_1"):setVisible(false)
	self.liftlv = self.LiftFrame:getChildByName("Image_lv_25_7"):getChildByName("Text_lv_2")


	self.JhFrame = self.Panel_JL:getChildByName("Image_frame_2")
	self.JhFramelv = self.JhFrame:getChildByName("Image_lv_25_7_0"):getChildByName("Text_lv_4")
	self.JhFrame_name = self.JhFrame:getChildByName("Text_jh_name")

	self.JhFrame_img = self.JhFrame:getChildByName("Image_119")

	self.JhPanl_lift = self.Panel_JL:getChildByName("Panel_7_0")
	self.xiaolv = self.Panel_JL:getChildByName("Image_100")
	self.JhPanl_right = self.Panel_JL:getChildByName("Panel_7_0_0")

	self.Btn_Jl = self.JhPanl_right:getChildByName("Button_5_33_0_14")

	self.Btn_Jl:addTouchEventListener(handler(self,self.onJhCallBack))

	self.JH_now_lv =self.JhPanl_lift:getChildByName("Image_bg_title_0_78_81"):getChildByName("Text_115")

	self.JH_now_maxlv =self.JhPanl_lift:getChildByName("Image_bg_title_0_78_81"):getChildByName("Text_115_0")
	self.JhPanl_lift.pro1 = self.JhPanl_lift:getChildByName("Panel_35_14_39")
	self.JhPanl_lift.pro1.dec = self.JhPanl_lift.pro1:getChildByName("Text_39_18_39_94")
	self.JhPanl_lift.pro1.value = self.JhPanl_lift.pro1:getChildByName("Text_33_0_16_37_92")

	self.JhPanl_lift.pro2 = self.JhPanl_lift:getChildByName("Panel_35_1_18_43")
	self.JhPanl_lift.pro2.dec = self.JhPanl_lift.pro2:getChildByName("Text_39_18_41_51_102")
	self.JhPanl_lift.pro2.value = self.JhPanl_lift.pro2:getChildByName("Text_33_0_16_39_49_100")

	self.JhPanl_lift.pro3 = self.JhPanl_lift:getChildByName("Panel_35_0_16_41")
	self.JhPanl_lift.pro3.dec = self.JhPanl_lift.pro3:getChildByName("Text_39_18_35_45_98")
	self.JhPanl_lift.pro3.value = self.JhPanl_lift.pro3:getChildByName("Text_33_0_16_33_43_96")



	--self.JH_now_atk = self.JhPanl_lift:getChildByName("Panel_35_14_39"):getChildByName("Text_33_0_16_37_92")
	--self.JH_now_hp = self.JhPanl_lift:getChildByName("Panel_35_1_18_43"):getChildByName("Text_33_0_16_39_49_100")
	--self.JH_now_crit = self.JhPanl_lift:getChildByName("Panel_35_0_16_41"):getChildByName("Text_33_0_16_33_43_96")


	self.JH_next_lv =self.JhPanl_right:getChildByName("Image_bg_title_0_78_91_93"):getChildByName("Text_115_1")
	self.JH_next_maxlv =self.JhPanl_right:getChildByName("Image_bg_title_0_78_91_93"):getChildByName("Text_115_0_0")

	self.JhPanl_right.pro1 = self.JhPanl_right:getChildByName("Panel_35_14_21_46")
	self.JhPanl_right.pro1.dec = self.JhPanl_right.pro1:getChildByName("Text_39_18_39_61_106")
	self.JhPanl_right.pro1.value = self.JhPanl_right.pro1:getChildByName("Text_33_0_16_37_59_104")

	self.JhPanl_right.pro2 = self.JhPanl_right:getChildByName("Panel_35_1_18_25_50")
	self.JhPanl_right.pro2.dec = self.JhPanl_right.pro2:getChildByName("Text_39_18_41_51_73_114")
	self.JhPanl_right.pro2.value = self.JhPanl_right.pro2:getChildByName("Text_33_0_16_39_49_71_112")

	self.JhPanl_right.pro3 = self.JhPanl_right:getChildByName("Panel_35_0_16_23_48")
	self.JhPanl_right.pro3.dec = self.JhPanl_right.pro3:getChildByName("Text_39_18_35_45_67_110")
	self.JhPanl_right.pro3.value = self.JhPanl_right.pro3:getChildByName("Text_33_0_16_33_43_65_108")

	--self.JH_next_atk =self.JhPanl_right:getChildByName("Panel_35_14_21_46"):getChildByName("Text_33_0_16_37_59_104")
	--self.JH_next_hp = self.JhPanl_right:getChildByName("Panel_35_1_18_25_50"):getChildByName("Text_33_0_16_39_49_71_112")
	--self.Jh_next_crit = self.JhPanl_right:getChildByName("Panel_35_0_16_23_48"):getChildByName("Text_33_0_16_33_43_65_108")

	self.Jh_Jb = self.JhPanl_right:getChildByName("Image_icon_0"):getChildByName("Text_70_2")

	mgr.SceneMgr:getMainScene():addHeadView()
	--self:addHead()

	-- 
	local panel =self.view:getChildByName("Panel_12")
	local posx,posy = panel:getPosition()
	local ccsize =  panel:getContentSize()

	local rect =cc.rect(posx,posy,ccsize.width,ccsize.height)
	local layer = ScollLayer.new(rect,30)
	layer:setName("touchlayer")
	layer:setMoveLeftCalllBack(handler(self,self.prvEquipment))
	layer:setMoveRightCalllBack(handler(self,self.nextEquipment))
	self:addChild(layer) 


	--还原
	self._btnHuanyuan = self.view:getChildByName("Button_1")
	self._btnHuanyuan:addTouchEventListener(handler(self,self.onbtnHuancall))

	self:performWithDelay(function()
		-- body
		--[[local effConfig = conf.Effect:getInfoById(404804)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)

		local effConfig = conf.Effect:getInfoById(404809)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)]]--
	end, 0.1)



	---界面文本
	local panelup = self.view:getChildByName("Panel_up")
	panelup:getChildByName("Button_2_3"):setTitleText(res.str.EQUIPMENT_DEC8)
	panelup:getChildByName("Button_2_0_5"):setTitleText(res.str.EQUIPMENT_DEC9)
	self._btnHuanyuan:setTitleText(res.str.EQUIPMENT_DEC16)
	self.Panel_down:getChildByName("Panel_35"):getChildByName("Text_39_18_9"):setString(res.str.EQUIPMENT_DEC5)
	self.Panel_down:getChildByName("Panel_35_0"):getChildByName("Text_39_18_9_49"):setString(res.str.EQUIPMENT_DEC17)
	self.Panel_down:getChildByName("Panel_35_1"):getChildByName("Text_39_18_9_53"):setString(res.str.EQUIPMENT_DEC18)

	self.Panel_down:getChildByName("Panel_35_next"):getChildByName("Text_39_18_9_59"):setString(res.str.EQUIPMENT_DEC5)
	self.Panel_down:getChildByName("Panel_35_0_next"):getChildByName("Text_39_18_9_49_63"):setString(res.str.EQUIPMENT_DEC17)
	self.Panel_down:getChildByName("Panel_35_1_next"):getChildByName("Text_39_18_9_53_67"):setString(res.str.EQUIPMENT_DEC18)



	self.JhPanl_right.pro1.dec:setString(res.str.EQUIPMENT_DEC3)
	self.JhPanl_right.pro2.dec:setString(res.str.EQUIPMENT_DEC4)
	self.JhPanl_right.pro3.dec:setString(res.str.EQUIPMENT_DEC5)

	self.Panel_end.pro1.dec:setString(res.str.EQUIPMENT_DEC3)
	self.Panel_end.pro2.dec:setString(res.str.EQUIPMENT_DEC4)
	self.Panel_end.pro3.dec:setString(res.str.EQUIPMENT_DEC5)

	self.JhPanl_lift.pro1.dec:setString(res.str.EQUIPMENT_DEC3)
	self.JhPanl_lift.pro2.dec:setString(res.str.EQUIPMENT_DEC4)
	self.JhPanl_lift.pro3.dec:setString(res.str.EQUIPMENT_DEC5)

	self.Panel_down:getChildByName("Button_auto"):setTitleText(res.str.EQUIPMENT_DEC19)
	self.Btn_Jl:setTitleText(res.str.EQUIPMENT_DEC9)

	self.Panel_down:getChildByName("Button"):setTitleText(res.str.EQUIPMENT_DEC20)

end

function StrengthenView:addHead()
	-- body
	mgr.SceneMgr:getMainScene():addHeadView()
end

-----------------------回调事件--------------
function StrengthenView:onbtnHuancall( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
		local nowdata=self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]
		--printt(nowdata)
		view:setData(nowdata)
	end 
end

--精炼
function StrengthenView:onJhCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		local nowdata=self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]
		local nowjhlv = mgr.ConfMgr.getItemJh(nowdata.propertys)
		local user_jb = cache.Fortune:getJb()
		local EquipmentJhID = conf.Item:getEquipmentJLId(nowdata.mId,nowjhlv)
		local jb = conf.EquipmentJh:getJb(EquipmentJhID)
		if jb > user_jb then
			G_TipsMoveUpStr("金币不足！")
			return 
		end
		if  self.QhData then
			local qhlv = mgr.ConfMgr.getItemQhLV(self.QhData.propertys)
			local jhlv = mgr.ConfMgr.getItemJh(self.QhData.propertys)
			local fun=function ( ... )
                mgr.Sound:playQianghua()
				local nowdata=self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]
				debugprint("要精炼的ID = "..nowdata.index.."被吞噬的ID "..self.QhData.index
				.."被吞噬的名字 "..conf.Item:getName(self.QhData.mId) )
				proxy.Equipment:reqJhEquipment(nowdata.index,self.QhData.index)
			end
			if qhlv > 0  or jhlv > 0 then
				local data = {};
				data.richtext = {
					{text=res.str.PROMOTEN_DEC1,fontSize=24,color=cc.c3b(255,255,255)},
					{text=string.gsub(res.str.PACK_STRENG," ","") ,fontSize=24,color=cc.c3b(255,0,0)},
					{text=res.str.PROMOTEN_DEC3,fontSize=24,color=cc.c3b(255,255,255)},
					{text=string.gsub(res.str.PACK_REFINING," ",""),fontSize=24,color=cc.c3b(255,0,0)},
					{text=res.str.COMPOSE_EQUIP_DEC2,fontSize=24,color=cc.c3b(255,255,255)},
				};
				data.sure = function( ... )
					-- body
					local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
					view:setData(self.QhData)

				end
				data.surestr =  res.str.COMPOSE_EQUIP_SURE
				mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)
			else
				fun()
			end
		else
			G_TipsOfstr(res.str.PROMOTE_NOCARD)
		end
	end
end
--添加材料
function StrengthenView:onAddCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		local nowdata=self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]
		local nowdatacolorlv = conf.Item:getItemQuality(nowdata.mId,nowdata.propertys)
		local view = mgr.ViewMgr:showView(_viewname.SELECT_EQUIPMENT)
		view:Colorlv(nowdatacolorlv)
		view:setData(self.EquipmentMaterialList[self.EuqipmentType],self.QhData)
	end
end
--自动强化
function StrengthenView:onAutoQhCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		self.AutoQh = true
		self:reqQhEquipment(self._QhNowLv,1)
        mgr.Sound:playQianghua()
	end
end
--强化
function StrengthenView:onQhCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		 self.AutoQh = false
		 self:reqQhEquipment(self._QhNowLv)
		 mgr.Sound:playQianghua()
	end
end
---服务器精炼返回

function StrengthenView:JLseverCallBack(data)
	-- body
	self:getCacheMaterial()

	local pos  = cc.p(self.JhFrame:getPositionX(),self.JhFrame:getPositionY())
	local params =  {id=404809, x=self.LiftFrame:getContentSize().width/2,
	y=self.LiftFrame:getContentSize().height/2,
	addTo=self.LiftFrame,
	playIndex=2,
	addName = "effofname1"}
	mgr.effect:playEffect(params)
	mgr.Sound:playQianghua()

	local  armature
	local params =  {id=404809, x=self.LiftFrame:getContentSize().width/2,
	y=self.LiftFrame:getContentSize().height/2,
	addTo=self.LiftFrame,
	loadComplete= function(var)
		-- body
		armature = var
	end,
	playIndex=1,
	addName = "effofname"}
	mgr.effect:playEffect(params)

	local a1 = cc.MoveBy:create(0.1,cc.p(0,120))
	local a5 = cc.MoveBy:create(0.15,cc.p(0,-60))

	local a2 = cc.DelayTime:create(0.3)
	local a3 = cc.MoveTo:create(0.2,self.LiftFrame:convertToNodeSpace(pos))
	

	local a4 = cc.CallFunc:create(function() 
 		 armature:removeFromParent()
 	 end) 
	local sequence = cc.Sequence:create(a1,a5,a2,a3,a4)
	armature:runAction(sequence)

	local function listener()
    	-- body
    	if self.JhFrame then 

	    	local params =  {id=404809, x=self.JhFrame:getContentSize().width/2,
			y=self.JhFrame:getContentSize().height/2,
			addTo=self.JhFrame,
			endCallFunc = function( ... )
				-- body
				self:updateEquipmentListData(data)
			end,
			playIndex=3,
			addName = "effofname"}
			mgr.effect:playEffect(params)
		end 
	end 
	self:performWithDelay(listener, 0.7)

	--self:updateEquipmentListData(data)
end

--服务器强化返回
function StrengthenView:severCallBack(data,lv)
	-- body
	local index= data.index
	local cachedata = cache.Equipment:getEquitpmentDataInfo()
	local updatedata =  cachedata[index]
	self.willdata = updatedata

	debugprint("强化成功.....")
	local sc = 1 
	if self.AutoQh then
		sc = 4.5
		self.flag = true
	end 

	if not self.AutoQh and not self.QH_Image_frame:getChildByName("effofname") then 
		local params =  {id=404804, x=self.QH_Image_frame:getContentSize().width/2,
		y=self.QH_Image_frame:getContentSize().height/2,
		addTo=self.QH_Image_frame,endCallFunc=nil,from=nil,to=nil, playIndex=0,addName = "effofname"}
		mgr.effect:playEffect(params)
	end 
	--printt(data.ups)
	local t  = {}
	for k ,v in pairs(data.ups) do 
		if tostring(k) ~= "_size" then 
			table.insert(t,v)
		end 
	end 

	local nowdata=clone(self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType])
	local newdata = nowdata
	
	local pos = self.QH_Image_frame:getWorldPosition()

	local num = 0
	local num1 = 0
	for k , v in pairs(t) do 
		--强化倍数
		local spr1 = display.newSprite(res.font.EQUIPQH_DEC)
		spr1:setPosition(pos.x - self.QH_Image_frame:getContentSize().width/2 
			, pos.y + self.QH_Image_frame:getContentSize().height/2 + spr1:getContentSize().height/2)
		spr1:addTo(self.action_panle)
		spr1:setScale(0.8)
		spr1:setVisible(false)

		local xn = display.newSprite(res.font.EQUIPQH[v])
		xn:setPosition(spr1:getContentSize().width +xn:getContentSize().width/2 ,spr1:getContentSize().height/2)
		xn:addTo(spr1)

		if 	self.view:getChildByName("haveeff") then 
			self.view:getChildByName("haveeff"):removeFromParent()
		end 

		local node = display.newNode()
		node:setName("haveeff")
		node:setPosition(pos.x + self.QH_Image_frame:getContentSize().width/2, pos.y)
		node:addTo(self.action_panle)
		node:setVisible(false)	


		local function beishu( spr )
			-- body
			--[[local spr1 = display.newSprite(res.font.EQUIPQH_DEC)
			spr1:setPosition(pos.x - self.QH_Image_frame:getContentSize().width/2 
				, pos.y + self.QH_Image_frame:getContentSize().height/2 + spr1:getContentSize().height/2)
			spr1:addTo(self.view)
			spr1:setScale(0.8)]]--
			spr:setVisible(true)
			local a1_s = cc.ScaleTo:create(0.15/sc,1.5)
			local a2_s = cc.ScaleTo:create(0.1/sc,0.1)
			local a4_s =cc.DelayTime:create(0.8/sc)
			local a3_s = cc.CallFunc:create(function( ... )
				-- body
				debugprint("移除"..v)
				spr:removeFromParent()
				local lvnumber = tonumber(self.labqhlv:getString()) 
				self.labqhlv:setString(lvnumber+v)
				
				if k < #t then 
					if newdata.propertys[303] then 
						newdata.propertys[303].value = tonumber(lvnumber+v)
					end
					--local t2 = G_getEquipPro(newdata)
					self.QH_lv:setString(lvnumber+v)
					self:updateQhPanledata(newdata)
				else
				--最后一次才弄个数值
					node:setVisible(true)
					---等级加
					local lab = display.newTTFLabel{
						text = res.str.EQUIPMENT_DEC1,
						textAlign = cc.TEXT_ALIGNMENT_LEFT,
						size = 24,
						font =res.ttf[1],
						color = cc.c3b(255,192,0),
					}
					lab:setAnchorPoint(cc.p(0,0))
					lab:addTo(node)
					
					local lab2 = display.newTTFLabel{
						text = "+"..data.lvl-mgr.ConfMgr.getItemQhLV(nowdata.propertys),
						size = 24,
						textAlign = cc.TEXT_ALIGNMENT_LEFT,
						x = lab:getContentSize().width,
						y = 0,
						color = cc.c3b(0,255,0),
					}
					lab2:setAnchorPoint(cc.p(0,0))
					lab2:addTo(node)

					--攻击加
					local b1 = 1
					local t1 = G_getEquipPro(newdata)
					if newdata.propertys[303] then 
						newdata.propertys[303].value = data.lvl
					end
					local t2 = G_getEquipPro(newdata)
					if t2.base_atk - t1.base_atk > 0 then 
						local lab = display.newTTFLabel{
							text = res.str.PRO_GONGJI,
							textAlign = cc.TEXT_ALIGNMENT_LEFT,
							size = 24,
							font =self.TitleName:getFontName(),
							color = cc.c3b(255,192,0),
							y = -b1 * 30 ,
							x = 0,
						}
						lab:setAnchorPoint(cc.p(0,0))
						lab:addTo(node)

						local lab2 = display.newTTFLabel{
							text = "+"..t2.base_atk - t1.base_atk,
							size = 24,
							textAlign = cc.TEXT_ALIGNMENT_LEFT,
							x = lab:getContentSize().width,
							y = -b1 * 30,
							color = cc.c3b(0,255,0),
						}
						lab2:setAnchorPoint(cc.p(0,0))
						lab2:addTo(node)
						b1 = b1 +1 
					end 

					if t2.base_hp - t1.base_hp > 0 then 
						local lab = display.newTTFLabel{
							text = res.str.PRO_HP,
							textAlign = cc.TEXT_ALIGNMENT_LEFT,
							size = 24,
							font =self.TitleName:getFontName(),
							color = cc.c3b(255,192,0),
							y = -b1 * 30 ,
							x = 0,
						}
						lab:setAnchorPoint(cc.p(0,0))
						lab:addTo(node)

						local lab2 = display.newTTFLabel{
							text = "+"..t2.base_hp - t1.base_hp,
							size = 24,
							textAlign = cc.TEXT_ALIGNMENT_LEFT,
							x = lab:getContentSize().width,
							y = -b1 * 30,
							color = cc.c3b(0,255,0),
						}
						lab2:setAnchorPoint(cc.p(0,0))
						lab2:addTo(node)
						b1 = b1 +1 
					end  
					node:setScale(0.5)
		
					local movetoposx,movetoposy = self.QH_lv:getWorldPosition()
			
					local speed = 2
					local a6 = cc.ScaleTo:create(0.3/speed,1.0)
					local a4 =cc.DelayTime:create(0.5/speed)
					local a1 = cc.ScaleTo:create(0.1/speed,1.1)
					local a2= cc.MoveTo:create(0.5/speed,cc.p(movetoposx,movetoposy))
					local a5 = cc.ScaleTo:create(0.5/speed,0.8)
					local asw = cc.Spawn:create(a2,a5)
					local a3 = cc.CallFunc:create(function( )
						-- body
						
						local function runScale( nodeparam )
							-- body
							local sequ = cc.Sequence:create(cc.ScaleTo:create(0.1/sc,2.5),cc.ScaleTo:create(0.2/sc,1.0))
							nodeparam:runAction(sequ)
						end
						runScale(self.QH_lv)
						runScale(self.QH_maxlv)
						local pro01 = self.Panel_down:getChildByName("Panel_35_0")
						runScale(pro01:getChildByName("Text_19_11_51"))
						local pro02 = self.Panel_down:getChildByName("Panel_35_1")
						runScale(pro02:getChildByName("Text_19_11_55"))
						runScale(self.Panel_down:getChildByName("Panel_35"):getChildByName("Text_19_11"))

						node:removeFromParent()
						self:updateEquipmentListData(updatedata)
					end)

					local sequence = cc.Sequence:create(a6,a4,a1,asw,a3)
					node:runAction(sequence)

				end 
			end)
			local sequence1 = cc.Sequence:create(a1_s,a4_s,a2_s,a3_s)

			--[[if not self.AutoQh and v == 1 then --自动强化不显示强化倍数
				spr1:setVisible(false)
			else
				--todo
				spr1:setVisible(true)
			end]]-- 
			spr:runAction(sequence1)
		end

		self.action_panle:performWithDelay(function( ... )
			-- body
			beishu(spr1)
		end, num * (0.15/sc + 0.1/sc+0.8/sc) )

		num = num + 1		
	end 
end
-- falg  是否强化到最大等级
function StrengthenView:reqQhEquipment(lv,flag)
	local nowdata=self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]

	local nowqhlv = mgr.ConfMgr.getItemQhLV(nowdata.propertys)
	local EquipmentQhID = conf.Item:getEquipmentQhId(nowdata.mId,nowqhlv)
	local jb =conf.EquipmentQh:getJb(EquipmentQhID)
	local user_jb = cache.Fortune:getJb()
	--
	if self.flag then 
		debugprint("自动强化中")
		return
	end 


	--只是强化一级JB 时候是否足够
	if jb > user_jb then
		G_TipsOfstr(res.str.NO_ENOUGH_JB)
		return 
	end
	--上限等级
	if lv >= self._QhMaxLv then 
		G_TipsOfstr(res.str.EQUIPMENT_MAXLV)
	end 

	if flag then  --最大等级
		proxy.Equipment:reqQhEquipment(nowdata.index,2)
	else --强化一次
		proxy.Equipment:reqQhEquipment(nowdata.index,1)
	end
end
--左右按钮
function StrengthenView:onDirectionCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
 		local tag = send:getTag()
 		if   tag == 110011 then
 			self:onLiftCallBack()
 		else
 			self:onRightCallBack()
 		end
	end
end
-----------------------回调事件--------------
function StrengthenView:updateLiftFrame(data)
	--printt(data)
	self.QhData = data
	if data ==  nil then
		self.LiftFrame:setVisible(false)
		return
	else
		self.LiftFrame:setVisible(true)
	end
	local name =conf.Item:getName(data.mId,data.propertys)
	local quality = conf.Item:getItemQuality(data.mId)
	local img_src = conf.Item:getSrc(data.mId,data.propertys)
	local img_path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
	self.LiftFrame:loadTexture(res.btn.FRAME[quality])
	self.LiftFrame:getChildByName("Image_head"):ignoreContentAdaptWithSize(true)
	self.LiftFrame:getChildByName("Image_head"):loadTexture(img_path)
	self.LiftFrame:getChildByName("Text_lift_name"):setString(name)
	self.LiftFrame:getChildByName("Text_lift_name"):setColor(COLOR[quality])
	local elv = mgr.ConfMgr.getItemQhLV(data.propertys)
	self.liftlv:setString(elv)
end
function StrengthenView:onLiftCallBack(  )
	--强化
	--if  self._NowShowViewIndex == 1 then
		self:prvEquipment()
	--else

	-- end
end
function StrengthenView:onRightCallBack(  )
	--强化
	self:nextEquipment()
end

function StrengthenView:setShowPageView( index )
	self.PageButton:initClick(index)
	if index == 1 then
		mgr.Sound:playViewQianghua()
	end
	--return self
end
--从缓存中获取 装备数据
function StrengthenView:getCacheEquipment(  )
	local data = cache.Equipment:getEquitpmentDataInfo()
	for k,v in pairs(data) do
		local battle_index=tonumber(string.sub(k,3,3))
		local bt=self.AllEquipmentList[battle_index]
		local colorlv = conf.Item:getItemQuality(v.mId)
		if colorlv > 3 then 
			local part = conf.Item:getItemPart(v.mId)
			if bt then
				self.AllEquipmentList[battle_index][part]=v
			else
				self.AllEquipmentList[battle_index]={}
				self.AllEquipmentList[battle_index][part]=v
			end
		end 
	end
	-- self.MaxEquipmentIndex=#self.AllEquipmentList
end

function StrengthenView:getCacheMaterial(  )
	local data =cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
	self.EquipmentMaterialList = {
	{},
	{},
	{},
	{},
	{},
	{},
	}
	for k,v in pairs(data) do
		local battle_index=tonumber(string.sub(k,3,3))
		local bt=self.AllEquipmentList[battle_index]
		local part = conf.Item:getItemPart(v.mId)
		self.EquipmentMaterialList[part][#self.EquipmentMaterialList[part]+1]=v
	end
	for i=1,#self.EquipmentMaterialList do
		table.sort(self.EquipmentMaterialList[i],function ( a,b )
			return mgr.ConfMgr.getPower(a.propertys) < mgr.ConfMgr.getPower(b.propertys)
			end)
	end
	-- self.MaxEquipmentIndex=#self.AllEquipmentList
end


function StrengthenView:updateEquipmentListData( data )
	local  NowSelectIndex=tonumber(string.sub(data.index,3,3))
	local  EuqipmentType=conf.Item:getItemPart(data.mId)
	self.AllEquipmentList[NowSelectIndex][EuqipmentType] = data
	self:updatePanle(data)
	self.flag = false
end

function StrengthenView:stopAction()
	-- body
	self.flag = false
	self.action_panle:stopAllActions()
	self.action_panle:removeAllChildren()

	if self.willdata then 
		local  NowSelectIndex=tonumber(string.sub(self.willdata.index,3,3))
		local  EuqipmentType=conf.Item:getItemPart(self.willdata.mId)
		self.AllEquipmentList[NowSelectIndex][EuqipmentType] = self.willdata
		self.willdata = nil 
	end 
end

function StrengthenView:nextEquipment(  )
	self:stopAction()
	if self.EuqipmentType < 6 then
		self.EuqipmentType=self.EuqipmentType+1
	else
		if self.NowSelectIndex < 6 then
			self.EuqipmentType = 1
			self.NowSelectIndex =  self.NowSelectIndex +1
		else
			self.NowSelectIndex = 1 
			self.EuqipmentType =  1
		end
	end
	local data_ = self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]
	if not data_ then
		self:nextEquipment()
	else
		self.data = data_
		self:updatePanle(data_)
	end
end

function StrengthenView:prvEquipment( )
	self:stopAction()
	if not  self:isVisible() then 
		return 
	end 

	if self.EuqipmentType > 1 then
		self.EuqipmentType=self.EuqipmentType - 1
	else
		if self.NowSelectIndex > 1 then
			self.EuqipmentType = 6
			self.NowSelectIndex =  self.NowSelectIndex - 1
		else
			self.NowSelectIndex = 6 
			self.EuqipmentType =  6
		end
	end
	local data_ = self.AllEquipmentList[self.NowSelectIndex][self.EuqipmentType]
	if not data_ then
		self:prvEquipment()
	else
		self.data = data_
		self:updatePanle(data_)
	end
end
function StrengthenView:_setNowVisibleState( bl )
	self.Panel_Qh:setVisible(bl)
	self.Panel_JL:setVisible(not bl)
end

--永横动画
function StrengthenView:loadforeverAction( index )
	-- body
	if index == 1 then 
		if not self.action1:getChildByName("qh_eff") then 
			local armature =mgr.BoneLoad:loadArmature(404804,1)
			armature:setPositionX(self.action1:getContentSize().width/2 -8)
			armature:setPositionY(self.action1:getContentSize().height + 5)
			armature:setName("qh_eff")
			armature:addTo(self.action1)
			--[[local params =  {id=404804, x=self.action1:getContentSize().width/2 -8,
			y=self.action1:getContentSize().height + 5,
			addTo=self.action1,endCallFunc=nil,from=nil,to=nil, playIndex=1,addName = "qh_eff"}
			mgr.effect:playEffect(params)]]--
		end
	elseif index == 2 then 
		if not self.Panel_JL:getChildByName("jl_eff") then 
			local pos = self.Panel_JL:convertToNodeSpace(cc.p(display.cx,display.cy*0.83))  
			local armature =mgr.BoneLoad:loadArmature(404809,0)
			armature:setPositionX(pos.x)
			armature:setPositionY(pos.y)
			armature:setName("jl_eff")
			armature:addTo(self.Panel_JL)

			--[[local pos = self.Panel_JL:convertToNodeSpace(cc.p(display.cx,display.cy*0.83))
			local params =  {id=404809, x=pos.x ,y=pos.y,addTo=self.Panel_JL, playIndex=0,addName = "jl_eff"}
			mgr.effect:playEffect(params)]]--
		end
	end 
	--Panel_1
end

function StrengthenView:_onPageBtnCallBack(index,eventtype)
	self:stopAction()
	if index == 2 then 
		local herolv = cache.Player:getLevel()
		if herolv < 20 then 
			G_TipsOfstr(res.str.LV20OPEN)
			--self.PageButton:setSelectButton(1)
			
			self:setShowPageView(1)
			local btn = self.PageButton.ListButton[1]
			self.PageButton:setButtonState(btn,true)
			return --self
		end 
	end 

	self._NowShowViewIndex = index
	self:_setNowVisibleState(index == 1)
	self.Img_bg:loadTexture(res.image.BG[index])

	self:loadforeverAction(index)
	self:updatePanleByIndex(self.NowSelectIndex,self.EuqipmentType)
	return self
end
function StrengthenView:setData(data)
	self.data=data
	self.NowSelectIndex=tonumber(string.sub(data.index,3,3))
	self.EuqipmentType=conf.Item:getItemPart(data.mId)
	return self
end
function StrengthenView:initNowSelectEquipmentIndex( index )
	self.NowSelectEquipmentIndex=index
end
function StrengthenView:updateUi(  )
	self:updatePanle(self.NowSelectEquipmentIndex)
end

function StrengthenView:updatePanleByIndex( index,type )
	self.NowSelectIndex = index
	self.EuqipmentType = type
	local data = self.AllEquipmentList[index][type]
	local colorlv = conf.Item:getItemQuality(self.data.mId)
	--printt(data)

	if colorlv < 4 then 
		G_TipsOfstr(res.str.EQUIPMENT_LOWER3JL)
		self:setShowPageView(1)
		return 
	end 

	if data then
		self:updatePanle(data)
	end
end

function StrengthenView:updatePanle( data )
	self._btnHuanyuan:setVisible(false)
	local elv = mgr.ConfMgr.getItemQhLV(data.propertys)
	local jlv = mgr.ConfMgr.getItemJh(data.propertys)
	if elv > 0 or jlv >0 then 
		self._btnHuanyuan:setVisible(true)
	end 

	
	if self._NowShowViewIndex == 1 then
		self:updateQhPanle(data)
	else
		self:updateLiftFrame()
		local nowdata = nil 
		for k,v in pairs(self.EquipmentMaterialList[self.EuqipmentType]) do
			local colorlv = conf.Item:getItemQuality(v.mId,v.propertys)
			local lv =  conf.Item:getItemQuality(self.data.mId,self.data.propertys)
			local elv = mgr.ConfMgr.getItemQhLV(v.propertys)
			local jlv = mgr.ConfMgr.getItemJh(v.propertys)

			if colorlv == lv and elv <=0 and jlv <=0 then
				nowdata = v 
				break;
			end
		end
		if nowdata then
			self:updateLiftFrame(nowdata)		
		end
		self:updateJlPanle(data)
	end 
end
function StrengthenView:onCloseHandler()
	mgr.SceneMgr:getMainScene():closeHeadView()
	self.super.onCloseHandler(self)
	
end
function StrengthenView:updateQhPanledata( data )
	-- body
	local t = G_getEquipPro(data)
	local labpwoer = self.Panel_down:getChildByName("Panel_35"):getChildByName("Text_19_11")
	labpwoer:setString(t.base_power)

	local pro01 = self.Panel_down:getChildByName("Panel_35_0")
	local pro02 = self.Panel_down:getChildByName("Panel_35_1")

	pro01:setVisible(false)
	pro02:setVisible(false)

	local b1 = 0 
	if  t.base_atk ~= 0 then
		pro01:setVisible(true)
		pro01:getChildByName("Text_39_18_9_49"):setString(res.str.PRO_GONGJI..":")
		pro01:getChildByName("Text_19_11_51"):setString(t.base_atk)
		b1 = b1 + 1
	end  

	if b1 > 0 and t.base_hp >0 then 
		pro02:setVisible(true)
		pro02:getChildByName("Text_39_18_9_53"):setString(res.str.PRO_HP..":")
		pro02:getChildByName("Text_19_11_55"):setString(t.base_hp)
	elseif t.base_hp >0 then 
		pro01:setVisible(true)
		pro01:getChildByName("Text_39_18_9_49"):setString(res.str.PRO_HP..":")
		pro01:getChildByName("Text_19_11_51"):setString(t.base_hp)
	end 

	--右边
	local nowqhlv = mgr.ConfMgr.getItemQhLV(data.propertys)
	local maxqhlv = conf.Item:getMaxQhLv(data.mId,data.propertys)

	

	local labpwoer_next = self.Panel_down:getChildByName("Panel_35_next"):getChildByName("Text_19_11_61")
	local pro01_next = self.Panel_down:getChildByName("Panel_35_0_next")
	local pro02_next = self.Panel_down:getChildByName("Panel_35_1_next")
	pro01_next:setVisible(false)
	pro02_next:setVisible(false)

	local atk = 0
	local hp =0 
	local power = 0
	--print("222")
	if nowqhlv >= maxqhlv then 
	else
		local data1 = clone(data) 
		if not data1.propertys[303] then 
			data1.propertys[303] = {}
			data1.propertys[303].value = 0
		end 
		data1.propertys[303].value =  data1.propertys[303].value +1 
		t = G_getEquipPro(data1)
	end 

	atk =  t.base_atk
	hp = t.base_hp
	power = t.base_power

	
	b1 = 0 
	if  t.base_atk ~= 0 then
		pro01_next:setVisible(true)
		pro01_next:getChildByName("Text_39_18_9_49_63"):setString(res.str.PRO_GONGJI..":")
		pro01_next:getChildByName("Text_19_11_51_65"):setString(atk)
		b1 = b1 + 1
	end  

	if b1 > 0 and t.base_hp >0 then 
		pro02_next:setVisible(true)
		pro02_next:getChildByName("Text_39_18_9_53_67"):setString(res.str.PRO_HP..":")
		pro02_next:getChildByName("Text_19_11_55_69"):setString(hp)
	elseif t.base_hp >0 then 
		pro01_next:setVisible(true)
		pro01_next:getChildByName("Text_39_18_9_49_63"):setString(res.str.PRO_HP..":")
		pro01_next:getChildByName("Text_19_11_51_65"):setString(hp)
	end 
	
	labpwoer_next:setString(power)

end

--更新强化
function StrengthenView:updateQhPanle( data )
	-- local  data=self.data
	local nowqhlv = mgr.ConfMgr.getItemQhLV(data.propertys)
	local nowatk = mgr.ConfMgr.getItemQhLV(data.propertys)

	local quality = conf.Item:getItemQuality(data.mId)
	local img_path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
	local name = conf.Item:getName(data.mId,data.propertys)

	local maxqhlv = conf.Item:getMaxQhLv(data.mId,data.propertys)
	local EquipmentQhID = conf.Item:getEquipmentQhId(data.mId,nowqhlv)
    local playerlv = cache.Player:getLevel()
	local maxlv =math.min(maxqhlv,playerlv)
	local nextlv = math.min(nowqhlv+1,maxlv)
	local EquipmentQhID1 = conf.Item:getEquipmentQhId(data.mId,math.min(nowqhlv+1,maxqhlv))

	local jb =conf.EquipmentQh:getJb(EquipmentQhID)
	local user_jb = cache.Fortune:getJb()


	self._QhMaxLv = math.min(maxqhlv,playerlv)
	self._QhNowLv = nowqhlv

	self.QH_Image:ignoreContentAdaptWithSize(true)
	self.QH_Image:loadTexture(img_path)
	self.QH_Image_frame:loadTexture(res.btn.FRAME[quality])
	
	self.labqhlv:setString(nowqhlv)

	self.TitleName:setColor(COLOR[quality])
	self.TitleName:setString(name)
	self.QH_lv:setString(nowqhlv)
	if jb > user_jb then
		self.Qh_Jb:setColor(cc.c3b(255,0,0))
	end
	self.Qh_Jb:setString(jb)
	if nowqhlv +1 >= maxqhlv then 
		self.QH_next_lv:setString(nextlv)
	else
		self.QH_next_lv:setString(nowqhlv+1)
	end 
	self.QH_next_lv:setColor(cc.c3b(0,255,0))


	self.QH_next_maxlv:setString("/"..maxlv)
	self.QH_maxlv:setString("/"..maxlv)
	if nowqhlv >= maxlv then
		self.QH_lv:setColor(cc.c3b(255,0,0))
	else
		self.QH_lv:setColor(cc.c3b(0,255,0))
	end

	self:updateQhPanledata(data)
end
--更新精炼
function StrengthenView:updateJlPanle( data )
	local name = conf.Item:getName(data.mId,data.propertys)
	local quality = conf.Item:getItemQuality(data.mId)
	self.TitleName:setColor(COLOR[quality])
	self.TitleName:setString(name)


	local maxjhlv = conf.Item:getMaxJhLv(data.mId)
	local nowjhlv = mgr.ConfMgr.getItemJh(data.propertys)

	local playerlv = cache.Player:getLevel()
	local maxlv =math.min(maxjhlv,playerlv)
	local nextlv = math.min(nowjhlv+1,maxlv)

	self.JH_now_lv:setString(nowjhlv)
	self.JH_now_maxlv:setString("/"..maxlv)

	local t = G_getEquipPro(data)


	for i = 1 , 3 do 
		self.JhPanl_lift["pro"..i]:setVisible(false)
	end

	for i = 1 , 3 do 
		self.JhPanl_right["pro"..i]:setVisible(false)
	end 

	local bl = 0
	local function _insetPro(lab,v,tt )
	-- body
		local k = pos 
		if v and v >0 then 
			bl = bl +1 
			self[tt]["pro"..bl]:setVisible(true)
			self[tt]["pro"..bl].dec:setString(lab..":")
			self[tt]["pro"..bl].value:setString("+"..v)
		end
	end
	_insetPro(res.str.PRO_PROWER,t.base_power,"JhPanl_lift")--战斗力
	_insetPro(res.str.PRO_GONGJI,t.base_atk,"JhPanl_lift") --攻击
	_insetPro(res.str.PRO_HP,t.base_hp,"JhPanl_lift")--生命


	

	--self.JH_now_atk:setString(t.base_atk)
	--self.JH_now_hp:setString(t.base_hp)
	--self.JH_now_crit:setString(t.base_power)

	local data1 =  clone(data)
	if not data1.propertys[311] then 
		data1.propertys[311] = {}
		data1.propertys[311].value = 0 
	end 
	data1.propertys[311].value = data1.propertys[311].value + 1 

	local rt = G_getEquipPro(data1)

	bl = 0 
	_insetPro(res.str.PRO_PROWER,rt.base_power,"JhPanl_right")--战斗力
	_insetPro(res.str.PRO_GONGJI,rt.base_atk,"JhPanl_right") --攻击
	_insetPro(res.str.PRO_HP,rt.base_hp,"JhPanl_right")--生命
	--self.JH_next_atk:setString(rt.base_atk)
	--self.JH_next_hp:setString(rt.base_hp)
	--self.Jh_next_crit:setString(rt.base_power)

	self.JH_next_lv:setString(nextlv)
	self.JH_next_maxlv:setString("/"..maxlv)

	local EquipmentJhID = conf.Item:getEquipmentJLId(data.mId,nowjhlv)
	local jb = conf.EquipmentJh:getJb(EquipmentJhID)
	local user_jb = cache.Fortune:getJb()
	if jb > user_jb then
		self.Jh_Jb:setColor(cc.c3b(255,0,0))
	end
	self.Jh_Jb:setString(jb)

	local text = mgr.ConfMgr.getItemQhLV(data.propertys)
	self.JhFramelv:setString(text)
	local img_path = conf.Item:getItemSrcbymid(data1.mId, data1.propertys)
	local nextname = conf.Item:getName(data.mId,data1.propertys)
	self.JhFrame_img:ignoreContentAdaptWithSize(true)
	self.JhFrame_img:loadTexture(img_path)
	self.JhFrame:loadTexture(res.btn.FRAME[quality])
	self.JhFrame_name:setColor(COLOR[quality])
	--self.JhFrame_name:setString(nextname and nextname or "")
	self.xiaolv:setVisible(false)
	if nowjhlv >= maxjhlv then 
		self.Panel_end:setVisible(true)

		for i = 1 , 3 do 
			self.Panel_end["pro"..i]:setVisible(false)
		end

		local bl = 0
		local function _insetPro(lab,v )
		-- body
			local k = pos 
			if v and v >0 then 
				bl = bl +1 
				self.Panel_end["pro"..bl]:setVisible(true)
				self.Panel_end["pro"..bl].dec:setString(lab..":")
				self.Panel_end["pro"..bl].value:setString("+"..v)
			end
		end
		_insetPro(res.str.PRO_PROWER,t.base_power)--战斗力
		_insetPro(res.str.PRO_GONGJI,t.base_atk) --攻击
		_insetPro(res.str.PRO_HP,t.base_hp)--生命

		--self.Panel_end_atk:setString(t.base_atk)
		--self.Panel_end_hp:setString(t.base_hp)
		--self.Panel_end_crit:setString(t.base_power)
		self.Panel_end_nowlv:setString(maxjhlv)
		self.Panel_end_maxlv:setString("/"..maxjhlv)

		self.xiaolv:setVisible(false)
		self.JhPanl_lift:setVisible(false)
		self.JhPanl_right:setVisible(false)
		self.Panel:setVisible(false)
		self.JhFrame:setPositionX(display.cx)
		self.JhFrame_name:setString(name)
	else
		self.JhFrame:setPositionX(display.cx+150)
		self.xiaolv:setVisible(true)
		self.Panel:setVisible(true)
		self.JhPanl_lift:setVisible(true)
		self.JhPanl_right:setVisible(true)
		self.Panel_end:setVisible(false)
		self.JhFrame_name:setString(nextname)
	end 
end

return StrengthenView