

local pet= require("game.things.PetUi")
local SpirteColorUpView=class("SpirteColorUpView",function ()
	-- body
	return ccui.Widget:create()
end)

function SpirteColorUpView:ctor(  )
	--所有相同品质数据  
	self._AllQualityData  = { } 
end

function SpirteColorUpView:init(_parent)
	self.view=_parent:getPanelegetClone()
	self.view:setVisible(true)
	self._parent = _parent
	--self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self._onbtn_Guize =  self.view:getChildByName("btn_guize_12")
	self._onbtn_Guize:addTouchEventListener(handler(self,self.onbtnGuizeCallBack))
	--试用的材料名字
	self.lab_Usename =  self.view:getChildByName("Image_9_59"):getChildByName("Text_1_29")
	self.view:reorderChild(self.view:getChildByName("Image_9_59"), 200)

	self.left_spr7s = self.view:getChildByName("Image_9_59"):getChildByName("Image_13_0")
	self.left_spr7s:setVisible(false)
	self.left_spr7s:ignoreContentAdaptWithSize(true)



	--选择材料的+ 号
	self.btn_choose_10 = self.view:getChildByName("btn_choose_10")
	self.btn_choose_10:addTouchEventListener(handler(self,self.onbtnChooseCallBack))
	--名字
	self.lab_name = self.view:getChildByName("Image_9_0_61"):getChildByName("txt_name_31")
	self.view:reorderChild(self.view:getChildByName("Image_9_0_61"), 200)

	self.right_spr7s = self.view:getChildByName("Image_9_0_61"):getChildByName("Image_13")
	self.right_spr7s:setVisible(false)
	self.right_spr7s:ignoreContentAdaptWithSize(true)


	--icon
	self.spr = self.view:getChildByName("img_spr_53")
	self.spr:setVisible(false)
	--天赋狂
	self._tianFuDi = self.view:getChildByName("Panel_2_10"):getChildByName("Image_11_51")
	

	--进阶前属性
	self._befPanle = self.view:getChildByName("Panel_7_0")
	--进阶后属性
	self._aftPanle = self.view:getChildByName("Panel_7_0_0")

	--self.Tupo
	self._TupoPanle = self.view:getChildByName("Panel_8")

	--进化
	self._btnjinghua = self._aftPanle:getChildByName("Button_5_33_0")
	self._btnjinghua:addTouchEventListener(handler(self,self.onbtnJinghuasendCallBack))
	--突破
	self._btnTopo= self._TupoPanle:getChildByName("Image_8_117"):getChildByName("Button_5_33")
	self._btnTopo:addTouchEventListener(handler(self,self.onbtnToposendCallBack))
	--完美进化
	self.img_zuo_di = self.view:getChildByName("Image_7_67")
	self.img_you_di =self.view:getChildByName("Panel_2_10") 
	self.Panel_down_end = self.view:getChildByName("Panel_down_end")
	self.btn_perfect = self.Panel_down_end:getChildByName("Button_3")
	self.btn_perfect:setVisible(false)
	self.btn_perfect:setTitleText(res.str.DUI_DEC_77)
	self.btn_perfect:addTouchEventListener(handler(self,self.onbtnperfectCallBack))

	self.view:reorderChild(self.Panel_down_end, 10000)

	local times= MyUserDefault.getIntegerForKey(user_default_keys.TUNSHI_7S)
	if times then --今日是否勾选了 不在提示
		if os.date("%x", os.time()) == os.date("%x",times) then 
			self.cancelSecond = false 
		else
			self.cancelSecond = true
		end
	end	
	
	--self.img_you_di self.img_zuo_di
end	

--设置今天是否取消2次确认界面
function SpirteColorUpView:savedaycancel( )
	-- body
	self.cancelSecond = false
	MyUserDefault.setIntegerForKey(user_default_keys.TUNSHI_7S,os.time())
end

--[[function SpirteColorUpView:onbtnHuancall( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
		view:setData(self.data)
	end 
end]]--

function SpirteColorUpView:onbtnperfectCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("究极数码进化")
		
		local view =  mgr.ViewMgr:showView(_viewname.SPRITE7SCAD)
		view:setData(self.data)

		self._parent:onCloseSelfView()
	end
end

function SpirteColorUpView:onbtnJinghuasendCallBack( send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.useData == nil then 
			G_TipsOfstr( res.str.PROMOTE_NOCARD )
			return
		end	

		local conf_data = conf.Item:getItemConf(self.useData.mId)
		if checkint(conf_data.new_id)>0 and self.cancelSecond  then
			local data ={}
			local function sure(f)
				-- body
				mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
				local data = {
					index = self.data.index,
					toIndex = self.useData.index,
				}
				proxy.card:reqJINHUA(data)

				if f then
					self:savedaycancel()
				end
			end
			local function cancel()
				-- body
			end
			data.adv = res.str.RES_GG_31
			data.sure = sure
			data.cancel = function( ... )
				-- body
			end
			local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
			view:setData(data)
		else
			local data = {
				index = self.data.index,
				toIndex = self.useData.index,
			}
			proxy.card:reqJINHUA(data)
		end
		
	end	
end

function SpirteColorUpView:onbtnToposendCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--printt(self.data)
		local jie = self.data.propertys[307] and self.data.propertys[307].value or 0 
		local colorlv = conf.Item:getItemQuality(self.data.mId)
		local lv = conf.Item:getItemJJClPre(self.data.mId)+jie --colorlv*1000+jie
		--print(jie)
	
		local needtab = conf.CardTopo:getUseitem(lv) 
		local flag = false 

		local worddata = {}
		worddata.sure = function ( ... )
			-- body
			--debugprint("跳转到无尽深渊")
			if cache.Player:getLevel()<20 then 
				G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,20))
				return 
			end 

			local _data = {"FUNBENVIEW",0,{{"ATHLETICS",2}}}
			G_GoToView(_data)
		end
		worddata.cancel = function( ... )
			-- body
		end
	
		

		local str = {}
		--printt(needtab)
		for k ,v in pairs(needtab) do 
			if k >= 3 then 
				debugprint("card_jinjie_item 不能配置超过2个 突破需求")
				break
			end 
			if v ==nil or #v<2  then 
				return 
			end 

			local maxcount = v[2]
			local curcount = cache.Pack:getItemAmountByMid(pack_type.PRO,v[1])

			if curcount < maxcount then 
				table.insert(str,conf.Item:getName(v[1]))
				flag = true 
			end 
		end 
		--printt(str)
		if flag then 
			worddata.richtext = {}
			if #str>1 then 
				worddata.richtext = {
					{text=str[1].."、",fontSize=24,color=cc.c3b(255,0,0)},
					{text=str[2],fontSize=24,color=cc.c3b(255,0,0)},
				}
			else
				worddata.richtext = {
					{text=str[1],fontSize=24,color=cc.c3b(255,0,0)},
				}
			end 

			local t = {text=res.str.PROMOTE_DEC6,fontSize=24,color=cc.c3b(255,255,255)}
			table.insert(worddata.richtext,t)

			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(worddata,true)
		else
			local data = {
				index = self.data.index,
				toIndex = 0,
			}
			proxy.card:reqJINHUA(data)
		end 
	end
end

--进化 突破返回
function SpirteColorUpView:OnSeverBack()
	-- body
end

function SpirteColorUpView:setbtnTopoStatue(flag )
	-- body
	self._btnTopo:setEnabled(flag)
	self._btnTopo:setBright(flag)

end

--左边的宠物
function SpirteColorUpView:setLeftName( name,lv,mId )
	self.lab_Usename:setString(name)
	self.lab_Usename:setColor(COLOR[lv])

	self.left_spr7s:setVisible(false)
	local conf_data = conf.Item:getItemConf(mId)
	if conf_data.zhuan and checkint(conf_data.zhuan) > 0  and name~="" then
		self.left_spr7s:setVisible(true)
		self.left_spr7s:loadTexture(res.icon.ZHUAN[1])
	end
end

--右边的宠物
function SpirteColorUpView:setRightName(name,lv,mId)
	self.lab_name:setString(name)
	self.lab_name:setColor(COLOR[lv])

	self.right_spr7s:setVisible(false)
	local conf_data = conf.Item:getItemConf(mId)
	if conf_data.zhuan and checkint(conf_data.zhuan) > 0  then
		self.right_spr7s:setVisible(true)
		self.right_spr7s:loadTexture(res.icon.ZHUAN[1])
	end
end	

-- 1 左 2 右 
function SpirteColorUpView:getPet( index   )
	-- body
	if index == 1 then
		return self._petLeft
	else
		return self._petright 
	end 
end

function SpirteColorUpView:getPetAddto()
	-- body
	return self.btn_choose_10
end

function SpirteColorUpView:setPanleVisible( flag )
	-- body
	local vis = flag and true or false
	self._befPanle:setVisible(not vis)
	self._aftPanle:setVisible(not vis)
	self._TupoPanle:setVisible(vis)

end
--本级属性
function SpirteColorUpView:setCurrPro(data)
	-- body
	local t = G_getCardPro(data) --
	local addatk =t.base_atk --propertys[102] and propertys[102].value or 0
	local addhp =t.base_hp --propertys[105] and propertys[105].value or 0
	local power =t.base_power  --propertys[305] and propertys[305].value or 0
	--进阶的
	local lab_power = self._befPanle:getChildByName("Panel_35_14"):getChildByName("Text_33_0_16_37")
	local lab_atk = self._befPanle:getChildByName("Panel_35_1_18"):getChildByName("Text_33_0_16_39_49")
	local lab_hp = self._befPanle:getChildByName("Panel_35_0_16"):getChildByName("Text_33_0_16_33_43")
	lab_power:setString(power)
	lab_atk:setString(addatk)
	lab_hp:setString(addhp)
	--突破的

	--local lab_power_to =  
	local lab_atk_to = self._TupoPanle:getChildByName("Image_22_119"):getChildByName("txt_add1_84")
	local lab_hp_to = self._TupoPanle:getChildByName("Image_22_119"):getChildByName("txtadd2_88")

	lab_atk_to:setString(addatk)
	lab_hp_to:setString(addhp)
end
--下级属性
function SpirteColorUpView:setNextPro( data,jie,jinghua,colorlv )
	-- body

	local pre =  conf.Item:getItemJHPre(data.mId)
	
	local oldid =  pre + jinghua

	local oldatt = conf.CardJinghua:getAtt(oldid) 
	local oldhp = conf.CardJinghua:getHp(oldid)
	local oldpower = conf.CardJinghua:getPower(oldid)

	oldatt = oldatt and oldatt or 0
	oldhp = oldhp and oldhp or 0
	oldpower = oldpower and  oldpower or 0

	local id = pre + jinghua+1 
	local huaatk = conf.CardJinghua:getAtt(id) 
	local huahp = conf.CardJinghua:getHp(id)
	local huapower = conf.CardJinghua:getPower(id)

	huaatk = huaatk and huaatk or 0
	huahp = huahp and huahp or 0
	huapower = huapower and  huapower or 0


	local t = G_getCardPro(data) --
	local addatk =t.base_atk --propertys[102] and propertys[102].value or 0
	local addhp =t.base_hp --propertys[105] and propertys[105].value or 0
	local power =t.base_power  --propertys[305] and propertys[305].value or 0

	local addatk = addatk + (huaatk - oldatt)
	local addhp = addhp+ (huahp -oldhp )
	local power = power +(huapower - oldpower)

	local lab_power = self._aftPanle:getChildByName("Panel_35_14_21"):getChildByName("Text_33_0_16_37_59")
	local lab_atk = self._aftPanle:getChildByName("Panel_35_1_18_25"):getChildByName("Text_33_0_16_39_49_71")
	local lab_hp = self._aftPanle:getChildByName("Panel_35_0_16_23"):getChildByName("Text_33_0_16_33_43_65")

	local lab_cost = self._aftPanle:getChildByName("Text_166")
	local cout = conf.CardJinghua:getcost(oldid)
	local currhave = cache.Fortune:getJb()
	if cout then
		lab_cost:setString(cout)
		if currhave < cout then 
			lab_cost:setColor(COLOR[6])--红色
		else
			lab_cost:setColor(COLOR[1])--白色
		end 
	else
		lab_cost:setString("")
	end  


	
	local lab_atk_to = self._TupoPanle:getChildByName("Image_22_0_121"):getChildByName("txt_add1_36_92")
	local lab_hp_to = self._TupoPanle:getChildByName("Image_22_0_121"):getChildByName("txtadd2_40_96")

	lab_power:setString(power)
	lab_atk:setString(addatk)
	lab_hp:setString(addhp)


	--突破的下级
	local v = clone(data)
	v.propertys[310] = {}
	v.propertys[310].value = 0
	if not v.propertys[307] then 
		v.propertys[307]={}
		v.propertys[307].value = 0
	end 
	v.propertys[307].value = v.propertys[307] and v.propertys[307].value+1 or 1
	--print("v.propertys[307].value = "..v.propertys[307].value)
	local t2 = G_getCardPro(v)

	--[[local oldid = colorlv*1000 + jie
	local oldatt = conf.CardJinghua:getAtt(oldid) 
	local oldhp = conf.CardJinghua:getHp(oldid)
	oldatt = oldatt and oldatt or 0
	oldhp = oldhp and oldhp or 0

	local id = colorlv*1000 + jie+1 
	local jieatk = conf.CardTopo:getAtt(id)
	local jiehp = conf.CardTopo:getHp(id)]]--
	if t2.base_atk == 0 then 
		lab_atk_to:setString("")
		lab_hp_to:setString("")
	else
		local jatk = t2.base_atk 
		local jiehp = t2.base_hp 

		lab_atk_to:setString(jatk)
		lab_hp_to:setString(jiehp)
	end 

end
--完美突破
function SpirteColorUpView:setWanemi( data )
	-- body
	local v = clone(data)
	if not v.propertys[307] then 
		v.propertys[307]={}
		v.propertys[307].value = 0
	end 
	--v.propertys[307].value = v.propertys[307] and v.propertys[307].value+1 or 1
	--print("v.propertys[307].value = "..v.propertys[307].value)
	--printt(v)
	local t2 = G_getCardPro(v)


	self.Panel_down_end:getChildByName("Panel_35_15_62"):getChildByName("Text_atk_123"):setString(t2.base_atk)
	self.Panel_down_end:getChildByName("Panel_35_0_17_66"):getChildByName("Text_def_131"):setString(t2.base_hp)
	self.Panel_down_end:getChildByName("Panel_35_1_19_68"):getChildByName("Text_crit_135"):setString(t2.base_power)

	local lab_name  = self.Panel_down_end:getChildByName("Image_1"):getChildByName("Text_2")

	local name = conf.Item:getName(v.mId,v.propertys)
	lab_name:setString(name)

	local color = conf.Item:getItemQuality(v.mId)
	lab_name:setColor(COLOR[color])


	self.middlepet=pet.new(data.mId,data.propertys)
	self.middlepet:setScale(1.0)
	self.middlepet:setPosition(display.cx, display.cy+50)
	self.middlepet:addTo(self.view)

	self.btn_perfect:setVisible(false)
	if  G_isNextCard(data) then --是否能进化
		self.btn_perfect:setVisible(true)
	end

	--[[if t2.base_atk == 0 then 
		lab_atk_to:setString("")
		lab_hp_to:setString("")
	else
		local jatk = t2.base_atk 
		local jiehp = t2.base_hp 

		lab_atk_to:setString(jatk)
		lab_hp_to:setString(jiehp)
	end ]]--

end

--
function  SpirteColorUpView:setTopo(lv)
	-- body
	--card_jinjie_tuihui_exp_items

	local needtab = conf.CardTopo:getUseitem(lv) 

	local tt = {}
	tt[1]={}
	tt[1].BtnFrame =  self._TupoPanle:getChildByName("Image_8_117"):getChildByName("Button_frame_24_0_35")
	tt[1].spr=tt[1].BtnFrame:getChildByName("Image_22_24_9_46_112")
	tt[1].lab_name = self._TupoPanle:getChildByName("Image_8_117"):getChildByName("txtadd2_40_0_0_80")
	tt[1].lab_count = self._TupoPanle:getChildByName("Image_8_117"):getChildByName("txtadd2_40_0_78")
	tt[2] ={}
	tt[2].BtnFrame =  self._TupoPanle:getChildByName("Image_8_117"):getChildByName("Button_frame_24_0_35_0")
	tt[2].spr=tt[2].BtnFrame:getChildByName("Image_22_24_9_46_112_177")
	tt[2].lab_name = self._TupoPanle:getChildByName("Image_8_117"):getChildByName("txtadd2_40_0_0_80_0")
	tt[2].lab_count = self._TupoPanle:getChildByName("Image_8_117"):getChildByName("txtadd2_40_0_78_0")

	for k , v in pairs(tt) do 
		v.BtnFrame:setVisible(false)
		v.spr:setVisible(false)
		v.lab_name:setVisible(false)
		v.lab_count:setVisible(false)
	end  
	if needtab  then 
		for k ,v in pairs(needtab) do 
			if k >= 3 then 
				debugprint("card_jinjie_item 不能配置超过2个 突破需求")
				break
			end 
			if v ==nil or #v<2  then 
				return 
			end 

			local maxcount = v[2]
			local curcount = cache.Pack:getItemAmountByMid(pack_type.PRO,v[1])
			tt[k].lab_count:setString(curcount)

			local colorlv=conf.Item:getItemQuality(v[1])
			local name=conf.Item:getName(v[1])
			local path=conf.Item:getItemSrcbymid(v[1])

			local framePath=res.btn.FRAME[colorlv]

			tt[k].BtnFrame:setVisible(true)
			tt[k].spr:setVisible(true)
			tt[k].lab_name:setVisible(true)
			tt[k].lab_count:setVisible(true)

			tt[k].lab_count:removeAllChildren()
			local tmax = ccui.Text:create()
			tmax:setString("/"..maxcount)
			tmax:setColor(COLOR[2])
			tmax:setFontSize(tt[k].lab_count:getFontSize())
			tmax:setPosition(tt[k].lab_count:getContentSize().width+tmax:getContentSize().width/2
				,tt[k].lab_count:getContentSize().height/2)

			
			tmax:addTo(tt[k].lab_count)

			if curcount < maxcount then 
				tt[k].lab_count:setColor(COLOR[6])
			else
				tt[k].lab_count:setColor(COLOR[2])
			end 

			tt[k].BtnFrame:loadTextureNormal(framePath)
			tt[k].lab_name:setColor(COLOR[colorlv])
			tt[k].spr:loadTexture(path)
			tt[k].lab_name:setString(name)
		end 
	end 


end

--进阶才用到
function SpirteColorUpView:setuseData( data )
	-- body
	self.left_spr7s:setVisible(false)
	if data then 
		self.useData = data
		local lv=conf.Item:getItemQuality(data.mId)
		local name=conf.Item:getName(data.mId,data.propertys)
		self:setLeftName(name,lv,data.mId)
		self:addPet(data,true)
	end	
end

function SpirteColorUpView:setTianFu( id ,str,jinghua_,jie_)
	-- body
	if id and id ~= 500000 then 
		self._tianFuDi:setVisible(true)
		local lab_name = self._tianFuDi:getChildByName("Txt_tianfu_name_23")
		local name = conf.CardGift:getGiftName(id)
		lab_name:setString(name)

		local lab_jiehua = self._tianFuDi:getChildByName("Txt_tianfu_name_0_25")
	
		if str == res.str.PROMOTE_JINGHU then 
			lab_jiehua:setString(string.format(str,jinghua_+1))
		else
			lab_jiehua:setString(string.format(str,jie_+1))
		end


		local lab_dec = self._tianFuDi:getChildByName("txt_pro_add_27")
		lab_dec:ignoreContentAdaptWithSize(false)
		local dec =conf.CardGift:getDescription(id) 
		if dec then 
			lab_dec:setString(dec)
		else
			lab_dec:setString("")
			debugprint("配置表没有这个天赋"..id)
		end
	else
		--print("wo cao")
		self._tianFuDi:setVisible(false)
	end	
end


function  SpirteColorUpView:getTianfuid( mId,jie,jinghua_,padd)
	-- body
	local jinghua = jinghua_+ 1
	local tianfuindex=1
	local tianfu = conf.Item:getGiftList(mId)
	--[[for k , v in pairs(tianfu) do 
		print(v)
	end 
	debugprint("mId = "..mId)
	debugprint("jie = "..jie)
	debugprint("jinghua_ = "..jinghua_)]]--

	local str = ""
	if jie <= 0 then 
		if jinghua==2 then 
			str = res.str.PROMOTE_JINGHU 
			tianfuindex = 2
		elseif jinghua == 5 then 
			str = res.str.PROMOTE_JINGHU 
			tianfuindex = 3
		end
	elseif jie == 1 then 
		if jinghua == 1 and padd then 
			str = res.str.PROMOTE_JIHUO
			tianfuindex = 4 
		elseif  jinghua == 5 then 
			str = res.str.PROMOTE_JINGHU
			tianfuindex = 5
		end

	elseif jie == 2 then
		if jinghua == 1 and padd then 
			str = res.str.PROMOTE_JIHUO
			tianfuindex = 6
		elseif jinghua == 5 then 
			str = res.str.PROMOTE_JINGHU
			tianfuindex = 7
		end
	else
		if jinghua==1 and padd then 
			str = res.str.PROMOTE_JIHUO
			tianfuindex = 8
		end
	end
	--print(tianfuindex)
	if tianfuindex > 1 then return tianfu[tianfuindex] ,str end
	return nil
end
--是否有下一届
function SpirteColorUpView:isExistNext( data ,propertys) 
	-- body
	local Modelid=conf.Item:getCardId(data.mId,propertys[307].value+1)
	if Modelid then 
		return true
	else
		return false
	end
end
--
function SpirteColorUpView:isViseNext( flag)
	-- body
	local t1 =  self._TupoPanle:getChildByName("Image_bg_title_0_109")
	local t2 =  self._TupoPanle:getChildByName("Image_22_0_121")

	t1:setVisible(flag)
	t2:setVisible(flag)
end

--flag 是突破还是  进阶
function SpirteColorUpView:setData( data )
	-- body
	self.useData = nil
 	if not data.propertys[307] then 
		data.propertys[307]= {}
		data.propertys[307].value = 0
	end

	if not data.propertys[310] then 
		data.propertys[310]= {}
		data.propertys[310].value = 0
	end
	local jinghua = data.propertys[310] and  data.propertys[310].value or 0
	local flag = jinghua >= 10 and true or false

	local jie =   data.propertys[307].value  

	self.data = data
	self:setPanleVisible(flag)



	local card_id=mgr.ConfMgr.getItemID(data.mId,jie+1)
	local lv=conf.Item:getItemQuality(data.mId)
	self.Qualitylv = lv
	self:setAllQualityData()


	self:setLeftName("",lv,data.mId)


	self._tianFuDi:setVisible(true)
	

	if self._petLeft  then 
		self._petLeft:removeFromParent()
		self._petLeft=nil
	end

	if self._petright  then 
		self._petright:removeFromParent()
		self._petright=nil
	end

	if self.middlepet then 
		self.middlepet:removeFromParent()
		self.middlepet=nil
	end 

	self.Panel_down_end:setVisible(false)
	self.img_you_di:setVisible(true) 
	self.img_zuo_di:setVisible(true)
	self.lab_Usename:getParent():setVisible(true)
	self.lab_name:getParent():setVisible(true)
	--self._befPanle self._aftPanle self._TupoPanle
	
	self:addPet(self.data,flag)
	if flag then
		self.btn_choose_10:setVisible(false)
		--self.btn_choose_10:setEnabled(false)
		local name=conf.Item:getName(data.mId,data.propertys)
		self:setLeftName(name,lv,data.mId)
		
		--这里右边 是下一个阶级的图片
		local propertys = clone(data.propertys) 
		if propertys[307] then 
			propertys[307].value = propertys[307].value ==0 and 1 or propertys[307].value  +1 
		end	

		if propertys[310] then 
			propertys[310].value = 0 
		end	
		
		if self:isExistNext(self.data,propertys) then
			self:setTopo(conf.Item:getItemJJClPre(data.mId)+jie)
			self:addPet(self.data,not flag,propertys)
			local id , str = self:getTianfuid(data.mId,jie+1,0,true)
			--if id~=500000 then 
			self:setTianFu(id , str,jinghua,jie)
			--self._tianFuDi:setVisible(true) 

			name=conf.Item:getName(data.mId,propertys)
			self:setbtnTopoStatue(true)
			self:isViseNext(true)
		else --突破到极限le 

			self._tianFuDi:setVisible(false)
			name = ""
			self:setbtnTopoStatue(false)
			self:isViseNext(false)

			self._befPanle:setVisible(false) 
			self._aftPanle:setVisible(false) 
			self._TupoPanle:setVisible(false)
			self.Panel_down_end:setVisible(true)
			self.img_you_di:setVisible(false) 
			self.img_zuo_di:setVisible(false)
			self._petLeft:setVisible(false)
			self.lab_Usename:getParent():setVisible(false)
			self.lab_name:getParent():setVisible(false)
			self:setWanemi(self.data)
			--self.Panel_down_end:setVisible(true)
		end	
		self:setRightName(name,lv,data.mId)

		self._parent:upteTitle(res.str.PROMOTE_TU)
	else
		self.btn_choose_10:setVisible(true)
		local name=conf.Item:getName(data.mId,data.propertys,true)
		local id , str = self:getTianfuid(data.mId,jie,jinghua)
		self:setTianFu(id ,str,jinghua,jie)
		self:setRightName(name,lv,data.mId)
		self.useData = self:SearchOneCanUse()
		if self.useData then 
			self:addPet(self.useData,not flag)
			self:setuseData(self.useData)
			self.btn_choose_10:setOpacity(0)
		else
			self.btn_choose_10:setOpacity(100)
		end

		self._parent:upteTitle(res.str.PROMOTE_JIN)
	end	
	

	self:setCurrPro(data)
	-- propertys,jie,jinghua,colorlv
	self:setNextPro(data,jie,jinghua,lv)
	
	--self:setName(name,lv)
end

function SpirteColorUpView:SearchOneCanUse( )
	-- body
	for k ,v in pairs (self._AllQualityData) do 
		local lv = v.propertys[304] and  v.propertys[304].value or 1
		local jianghua = v.propertys[310] and v.propertys[310].value or 0
		local jie = v.propertys[307] and v.propertys[307].value or 0

		if lv < 2 and jianghua<1 and jie<1 and not G_is7sCard(v.mId) 
			and not (v.propertys[317] and v.propertys[317].value>0 ) then 
			return v
		end 
	end 

	--if #self._AllQualityData > 0 then --已经排序过了 
		--return self._AllQualityData[1]
	--end
	return nil
end

function SpirteColorUpView:getAllQualityData(  )
	-- body
	return self._AllQualityData
end

function SpirteColorUpView:setAllQualityData()
	-- body
	self._AllQualityData = {}
	local QualityData = {}
	local data = cache.Pack:getTypePackInfo(pack_type.SPRITE)

	for k ,v in pairs(data) do 
		local lv = conf.Item:getItemQuality(v.mId)
		local pos = conf.Item:getBattleProperty(v) 
		if lv == self.Qualitylv and pos<1 then 
			table.insert(QualityData,v)
		end	
	end

	table.sort( QualityData, function (a,b)
		-- body
		local lva = a.propertys[304] and a.propertys[304].value or 0
		local lvb = b.propertys[304]  and b.propertys[304].value or 0

		local Ja = a.propertys[310] and a.propertys[310].value or 0
		local Jb = b.propertys[310] and b.propertys[310].value or 0

		local pa = a.propertys[305] and a.propertys[305].value or 0
		local pb = b.propertys[305] and b.propertys[305].value or 0


		if lva == lvb then --强化等级相同
			if Ja == Jb then -- 进阶数相同
				if  pa  == pb then --战力相同
					return a.mId<b.mId
				else
					return pa  < pb
				end	
			else
				return  Ja<Jb
			end	
		else
			return lva<lvb
		end
	end )

	self._AllQualityData = QualityData
end

function SpirteColorUpView:addPet( data,flag,propertys_)
	local _propertys = data.propertys
	if propertys_ then 
		_propertys = propertys_
	end
	local node=pet.new(data.mId,_propertys)
	node:setScale(0.8)
	if propertys_ then
		_propertys  = propertys_
		node.node:setOpacity(90)

	end

	local posx,posy = self.btn_choose_10:getPosition()
	if flag then 
		if self._petLeft  then 
			self._petLeft:removeFromParent()
			self._petLeft=nil
		end
		self._petLeft = node
	else
		if self._petright  then 
			self._petright:removeFromParent()
			self._petright=nil
		end
		posx,posy = self.spr:getPosition()
		self._petright = node
	end	

	--node:setScale(1)
	node:setPosition(posx,posy+20)
	self.view:addChild(node,100)

end

function SpirteColorUpView:onbtnGuizeCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--print("规则界面")
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(10)
	end
end

function SpirteColorUpView:onbtnChooseCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--print("打开卡片选择界面")
		
		local view=mgr.ViewMgr:createView(_viewname.DEVOUR_MATERIAL)
		view:CardJingjie()
		if self.useData then 
			local tt = {};
			table.insert(tt,self.useData)
			view:setSelectPetListData(tt)
		end	
		view:setData(self:getAllQualityData())
		mgr.ViewMgr:showView(_viewname.DEVOUR_MATERIAL)
		mgr.SceneMgr:getMainScene():closeHeadView()

	end
end

return SpirteColorUpView