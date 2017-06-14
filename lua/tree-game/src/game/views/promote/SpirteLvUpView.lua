
local ScollLayer = require("game.cocosstudioui.ScollLayer")

local SpriteWidget=require("game.views.promote.SpriteLvUpWidget")
local SpriteUp = require("game.views.promote.SpirteColorUpView")
local pet= require("game.things.PetUi")
local SpirteLvUpView=class("SpirteLvUpView",base.BaseView)


function SpirteLvUpView:ctor()
	--已存在的数据
	-- self.existListData = {} 
	--所有品质数据  
	self._AllQualityData  = { } 
	--排除高品质数据
	self._InferiorQualityData = {}
	--出战的
	self._BattleDataList = {}
	--已选择的列表
	self.SelectPetList = {}
	--升级材料列表
	self.ListWidget = {}  --控件列表

	--加成属性列表
	self.nextLabelPropertyList = {}
	self._NowExp = 0
	self._NowLv = 0
	self.g_exp = 0

	self.tobuy = false
end

function SpirteLvUpView:init()
	
	--self.ShowAll=true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.Panel_up=self.view:getChildByName("Panel_up")
	self.Panel_up:setTouchEnabled(false)

	--页标签
	self.PageButton=gui.PageButton.new()
	self.PageButton:addButton(self.Panel_up:getChildByName("Button_2"))
	self.PageButton:addButton(self.Panel_up:getChildByName("Button_2_0"))
	self.PageButton:setBtnCallBack(handler(self,self.ListButtonCallBack))
	--基础层容器
	self.Panel_c =self.view:getChildByName("Panel_c") 

	--self.Panel_c:setPositionX(display.cx-)

	self.Panel_7 =self.view:getChildByName("Panel_7")
	self.Panel_28 =self.view:getChildByName("Panel_28")
	--进化界面
	self.panle=self.view:getChildByName("panle") 
	--做滑动----------------------------------
	self.conppp  = self.view:getChildByName("Panel_2")
	self.conppp:setVisible(false)
	local rect =cc.rect(self.conppp:getPositionX(),self.conppp:getPositionY(),
	self.conppp:getContentSize().width,self.conppp:getContentSize().height)
	local layer = ScollLayer.new(rect,10)
	self:addChild(layer)
	layer:setMoveLeftCalllBack(handler(self,self.prv))
	layer:setMoveRightCalllBack(handler(self,self.next))
	-----左右切换
	self.BtnLeft=self.view:getChildByName("Panel_c"):getChildByName("button_1")
	self.BtnLeft:setTag(10011)
	self.BtnLeft:addTouchEventListener(handler(self,self.onChangePetCallBack))
	self.BtnRight=self.view:getChildByName("Panel_c"):getChildByName("button")
	self.BtnRight:setTag(10012)
	self.BtnRight:addTouchEventListener(handler(self,self.onChangePetCallBack))
	self._WidgetClone=self.view:getChildByName("Panel_1")
	----自动添加
	self.BtnAutoadd=self.view:getChildByName("Panel_28"):getChildByName("Button_add")
	self.BtnAutoadd:addTouchEventListener(handler(self,self.onAutoAddCallBack))
	--升级
	self.BtnLvUp=self.view:getChildByName("Panel_28"):getChildByName("Button_10")
	self.BtnLvUp:addTouchEventListener(handler(self,self.onLvUpCallBack))
	--经验
	self.LoadingBar1=self.view:getChildByName("Panel_28"):getChildByName("LoadingBar_1")
	self.LoadingBar2=self.view:getChildByName("Panel_28"):getChildByName("LoadingBar_2"):setVisible(false)
	self.LabelExp=self.view:getChildByName("Panel_28"):getChildByName("Text_exp"):setString(0)

	--当前选择 -- 出站列表的
	self.NowSelectPetIndex = 1
	--加成属
	self.propertypanel=self.view:getChildByName("Panel_7")
	--等级
	self.label_lv=self.propertypanel:getChildByName("Image_bg_title_0"):getChildByName("Text_48_14")
	self.nextlabel_lv=self.propertypanel:getChildByName("Image_bg_title_0"):getChildByName("Text_add")

	self.nextLabelPropertyList[1] = self.nextlabel_lv
	--战斗力
	self.prvLabelpower=self.propertypanel:getChildByName("Panel_35"):getChildByName("Text_19")
	self.nextLabelpower=self.propertypanel:getChildByName("Panel_35"):getChildByName("Text_33_0_16")

	self.nextLabelPropertyList[2] = self.nextLabelpower
	--攻击
	self.prvlabelatk=self.propertypanel:getChildByName("Panel_35_1"):getChildByName("Text_19_43")
	self.nextlabelatk=self.propertypanel:getChildByName("Panel_35_1"):getChildByName("Text_33_0_16_39")

	self.nextLabelPropertyList[3] = self.nextlabelatk
	--生命
	self.prvlabelhp=self.propertypanel:getChildByName("Panel_35_0"):getChildByName("Text_19_37")
	self.nextabelhp=self.propertypanel:getChildByName("Panel_35_0"):getChildByName("Text_33_0_16_33")

	self.nextLabelPropertyList[4] = self.nextabelhp

	--还原
	self._btnHuanyuan = self.view:getChildByName("Button_1")
	self._btnHuanyuan:addTouchEventListener(handler(self,self.onbtnHuancall))
	
	--5个选择位置
	local size = 5
	for i=1,size do
		local widget=SpriteWidget.new()
		widget:init(self,i)
		-- widget:showName(true)
        self.Panel_c:addChild(widget,100)
		self.ListWidget[i]=widget
	end
	--当前选择的宠物
	self._petTarget=SpriteWidget.new()
	self._petTarget:init(self,6)
	self._petTarget:restoreSize()
    self.Panel_c:addChild(self._petTarget,100)
	self._petTarget:showName(true)
	--
	mgr.SceneMgr:getMainScene():addHeadView()
	self.pageindex = self.pageindex and self.pageindex or 1
	self:changeData()
	self.PageButton:initClick(self.pageindex)
	
    G_FitScreen(self,"Image_bg")
    

	self:performWithDelay(function()
			self:forever() --地板上的永恒动画
			local effConfig = conf.Effect:getInfoById(404813)
			mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			end)
	end, 0.1)

	self:initDec()
end

function SpirteLvUpView:initDec()
	-- body
	self.Panel_up:getChildByName("Button_2"):setTitleText(res.str.PET_DEC_15)
	self.Panel_up:getChildByName("Button_2_0"):setTitleText(res.str.PET_DEC_16)

	local pan =self.view:getChildByName("Panel_7")

	--setString(string.gsub(res.str.PET_DEC_11," ",""))
	local str = string.gsub(res.str.PET_DEC_11, " ", "")
	pan:getChildByName("Panel_35"):getChildByName("Text_39_18"):setString(str)
	str = string.gsub(res.str.PET_DEC_07," ","")
	pan:getChildByName("Panel_35_0"):getChildByName("Text_39_18_35"):setString(str)
	str = string.gsub(res.str.PET_DEC_06," ","")
	pan:getChildByName("Panel_35_1"):getChildByName("Text_39_18_41"):setString(str)

	local Panel_28 =self.view:getChildByName("Panel_28")
	Panel_28:getChildByName("Text_name"):setString(res.str.PET_DEC_20)
	Panel_28:getChildByName("Button_add"):setTitleText(res.str.PET_DEC_21)
	Panel_28:getChildByName("Button_10"):setTitleText(res.str.PET_DEC_22)

	local panle = self.view:getChildByName("panle")
	--panle:getChildByName("Panel_2_10"):getChildByName("Image_11_51"):getChildByName("Txt_tianfu_name_23"):setString(res.str.PET_DEC_23)

	local Panel_8 = panle:getChildByName("Panel_8")
	Panel_8:getChildByName("Image_22_119"):getChildByName("txt_dec1_82"):setString(res.str.PET_DEC_06)
	Panel_8:getChildByName("Image_22_119"):getChildByName("txt_dec2_86"):setString(res.str.PET_DEC_07)

	Panel_8:getChildByName("Image_22_0_121"):getChildByName("txt_dec1_34_90"):setString(res.str.PET_DEC_06)
	Panel_8:getChildByName("Image_22_0_121"):getChildByName("txt_dec2_38_94"):setString(res.str.PET_DEC_07)

	self.view:getChildByName("Button_1"):setTitleText(res.str.PET_DEC_23)

	local panel_end = self.panle:getChildByName("Panel_down_end")
	panel_end:getChildByName("Panel_35_15_62"):getChildByName("Text_39_18_9_28_51"):setString(res.str.PET_DEC_06)
	panel_end:getChildByName("Panel_35_0_17_66"):getChildByName("Text_39_18_9_49_32_59"):setString(res.str.PET_DEC_07)
	local str = string.gsub(res.str.PET_DEC_11," ","")
	print("str = "..str)
	local lab_ = panel_end:getChildByName("Panel_35_1_19_68"):getChildByName("Text_39_18_9_53_36_63"):setString(str)

	local Panel_7_0_0 =  self.panle:getChildByName("Panel_7_0_0")
	Panel_7_0_0:getChildByName("Panel_35_14_21"):getChildByName("Text_39_18_39_61"):setString(res.str.PET_DEC_11)
	Panel_7_0_0:getChildByName("Panel_35_1_18_25"):getChildByName("Text_39_18_41_51_73"):setString(res.str.PET_DEC_06)
	Panel_7_0_0:getChildByName("Panel_35_0_16_23"):getChildByName("Text_39_18_35_45_67"):setString(res.str.PET_DEC_07)
	Panel_7_0_0:getChildByName("Button_5_33_0"):setTitleText(res.str.PET_DEC_16)

	local Panel_7_0 =  self.panle:getChildByName("Panel_7_0")
	Panel_7_0:getChildByName("Panel_35_14"):getChildByName("Text_39_18_39"):setString(res.str.PET_DEC_11)
	Panel_7_0:getChildByName("Panel_35_1_18"):getChildByName("Text_39_18_41_51"):setString(res.str.PET_DEC_06)
	Panel_7_0:getChildByName("Panel_35_0_16"):getChildByName("Text_39_18_35_45"):setString(res.str.PET_DEC_07)

	local panel_8_img = Panel_8:getChildByName("Image_8_117")
	 panel_8_img:getChildByName("Button_5_33"):setTitleText(res.str.PET_DEC_24)


	 Panel_8:getChildByName("Image_22_119"):getChildByName("txt_dec1_82"):setString(res.str.PET_DEC_06)
	 Panel_8:getChildByName("Image_22_119"):getChildByName("txt_dec2_86"):setString(res.str.PET_DEC_07)

	 Panel_8:getChildByName("Image_22_0_121"):getChildByName("txt_dec1_34_90"):setString(res.str.PET_DEC_06)
	 Panel_8:getChildByName("Image_22_0_121"):getChildByName("txt_dec2_38_94"):setString(res.str.PET_DEC_07)





end



function SpirteLvUpView:forever(  )
	-- body
	local params =  {id=404809, x=self.Panel_c:getContentSize().width/2-3,
	y=self.Panel_c:getContentSize().height/2 - 96,
	addTo=self.Panel_c,
	playIndex=0,
	addName = "effofname"}
	mgr.effect:playEffect(params)
	--BtnLeft
	--BtnRight
	self.Panel_c:reorderChild(self.BtnLeft,500000)
	self.Panel_c:reorderChild(self.BtnRight,500000)
end

--左右切换
function SpirteLvUpView:onChangePetCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		local tag=send:getTag()
		if tag == 10011 then
			self:prv()
		elseif tag == 10012 then
			self:next()
		end
		
	end
end
	--还原按钮是否
function SpirteLvUpView:visbtn()
	-- body
	local data=self._BattleDataList[self.NowSelectPetIndex]
	self._btnHuanyuan:setVisible(false)

	local conf_data = conf.Item:getItemConf(data.mId)
	--print("  "..data.propertys[304].value)
	--print(mgr.ConfMgr:getLv(data.propertys))
	if mgr.ConfMgr.getLv(data.propertys) > 1 or mgr.ConfMgr.getItemJJ(data.propertys) >0 
		or mgr.ConfMgr.getItemJH(data.propertys)>0 or checkint(conf_data.old_id) > 0  then 
		--print("----------------------------------")
		self._btnHuanyuan:setVisible(true)
	end 
end

--重新清理数据
function SpirteLvUpView:updateClean(pp)
	self:changeable(true)
	self:removeAllWidget()
	self:cleanSelectPet()

	self:visbtn()
	--[[self._btnHuanyuan:setVisible(false)
	if mgr.ConfMgr:getLv(data.propertys) > 1 or mgr.ConfMgr:getItemJJ() >0 or mgr.ConfMgr:getItemJH()>0 then 
		self._btnHuanyuan:setVisible(true)
	end ]]--
	--[[local data=self._BattleDataList[self.NowSelectPetIndex]
	local colorlv =conf.Item:getItemQuality(data.mId)
	if colorlv < 4  then
		--todo
		if pp == -1 then 
			self:prv()
		else
			self:next()
		end 
		return 
	end]]--

	self:updateTargetPet(self.NowSelectPetIndex)
	if self._petTargetUp then
		local data=self._BattleDataList[self.NowSelectPetIndex]
		self._petTargetUp:setData(data)
	end
end
--更新显示
function SpirteLvUpView:update( )
	self:visbtn()
	self:updateTargetPet(self.NowSelectPetIndex)
	if self.pageindex == 2 then 
		self:updateColorUpPet(self.NowSelectPetIndex)
	end
end
--前一个
function SpirteLvUpView:prv()

	if self.NowSelectPetIndex > 1 then
		 self.NowSelectPetIndex = self.NowSelectPetIndex-1
	else
		self.NowSelectPetIndex = self.MaxSelectIndex
	end
	self:updateClean(-1)
end
--后一个
function SpirteLvUpView:next()
	if self.NowSelectPetIndex < self.MaxSelectIndex then
		 self.NowSelectPetIndex = self.NowSelectPetIndex + 1
	else
		self.NowSelectPetIndex = 1
	end
	self:updateClean(1)
end


--在进化突破 界面不显示
function SpirteLvUpView:setPanleVisible( flag )
	-- body
	--self.Panel_c:setVisible(flag)
	self.Panel_7:setVisible(flag)
	self.Panel_28:setVisible(flag)
	--self.panle:setVisible(not flag)
	self._petTarget:setVisible(flag)
	if self._petTargetUp then self._petTargetUp:setVisible(not flag) end 
	for k,v in pairs(self.ListWidget)  do
		v:setVisible(flag)
	end

end
--进化突破 容器层
function SpirteLvUpView:getPanelegetClone()
	-- body
	return self.panle:clone()
end

--还原按钮被按下
function SpirteLvUpView:onbtnHuancall( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
		local data = self._BattleDataList[self.NowSelectPetIndex]
		view:setData(data)
	end 
end

function SpirteLvUpView:setPageBtnStatue(index)
	-- body
	local btn = self.PageButton.ListButton[index]
	self.PageButton:setButtonState(btn,true)
end

--页面选择
function SpirteLvUpView:ListButtonCallBack( index,eventtype )
	self.pageindex  = index
	if index == 1 then --升级界面
		self:setPanleVisible(true)
	else --进化 突破
		local data = self._petTarget:getData()
		local colorlv =conf.Item:getItemQuality(data.mId)
		if colorlv < 4 then 
			self.PageButton:initClick(1)
			self:setPageBtnStatue(1)
			G_TipsForColorEnough()
			return 
		end 
		self:setPanleVisible(false)
		self:updateColorUpPet(self.NowSelectPetIndex)
	end
	return self
end
--已选清理
function SpirteLvUpView:cleanSelectPet(  )
	self.tobuy = false
	self.SelectPetList = {}
	self.LabelExp:setString(0)
end
--所有品质
function SpirteLvUpView:getAllQualityData( )
	return self._AllQualityData
end
--已选列表
function SpirteLvUpView:getSelectPetList( )
	return self.SelectPetList
end
--spr 
function SpirteLvUpView:getWidgetClone(  )
	return self._WidgetClone:clone()
end

--转换初始数据
function SpirteLvUpView:changeData(  )
	self.data = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	self._AllQualityData={}
	self._InferiorQualityData={} -- 用來自動填加
	self._BattleDataList={}

	for k ,v in pairs(self.data) do
		if conf.Item:getBattleProperty(v) < 1 then
			table.insert(self._AllQualityData,v)
			if conf.Item:getItemQuality(v.mId) < 4 then 
				table.insert(self._InferiorQualityData,v)
			end
		else
			if conf.Item:getItemQuality(v.mId) > 3 then --3星一下的忽略
				table.insert(self._BattleDataList,v)
			end 
		end
	end 
	self.MaxSelectIndex=#self._BattleDataList
end

---5个升级选择
function SpirteLvUpView:getWidget( index )
	return self.ListWidget[index]
end

function SpirteLvUpView:getListWidget(  )
	return self.ListWidget
end
function SpirteLvUpView:removeAllWidget(  )
	self.tobuy = false
	for i,v in pairs(self:getListWidget()) do
		v:restore()
	end
end

--自动搜索数据
--自动添加按钮触发
-- 经验小的先取
function SpirteLvUpView:getSearchDataoFdaoju()
	-- body
	--经验宝宝 --升级采用的
	local tt = {}
	local cout = 0
	for i = 1 , #EXP_STONE_ID do 
		local tab  = cache.Pack:getItemAllitemByMid(pack_type.PRO,EXP_STONE_ID[i])
		for k , v in pairs(tab) do 
			for j = 1 , v.amount do
				local dd = clone(v) 
				dd.cout = j.."_"..i
				table.insert(tt,dd)
				cout = cout + 1
				if cout > 5 then 
					return tt
				end 
			end 
		end 
	end 
	return tt 
end


function SpirteLvUpView:getSearchData(  )
	local  get_data={}
	local  _searchMax = 5 --搜索的最大数
	local _searchIndex = 1  --搜索到的位置
	table.sort( self._InferiorQualityData, function ( t1,t2 )

			local qu=conf.Item:getItemQuality(t1.mId)

			local lv=mgr.ConfMgr.getLv(t1.propertys)

			local conf_exp= conf.CardExp:getExp(conf.Item:getItemSjPre(t1.mId),lv)

			local t1_exp = mgr.ConfMgr.getExp(t1.propertys) + conf_exp
			

			local qu1=conf.Item:getItemQuality(t2.mId)

			local lv1=mgr.ConfMgr.getLv(t2.propertys)

			local conf_exp1= conf.CardExp:getExp(conf.Item:getItemSjPre(t2.mId),lv1)

			local t2_exp = mgr.ConfMgr.getExp(t2.propertys)+ conf_exp1

		return  t1_exp < t2_exp
	end )
	for k,v in pairs(self._InferiorQualityData) do
		--if not v.isExist  then
			get_data[#get_data+1]=v
			if _searchIndex < _searchMax then
				_searchIndex=_searchIndex+1
			else
				break
			end
		--end
	end
	return get_data
end
--获得升级所需要的经验
function SpirteLvUpView:getNeedExp(  )
	-- body
	return self.NeedExp
end

function SpirteLvUpView:setGray( btn , flag)
	-- body
	btn:setTouchEnabled(flag)
	btn:setBright(flag)
end

--更新当前选择的宠物属性
function SpirteLvUpView:updatePropertyPanel(data)
	local exp =  mgr.ConfMgr.getExp(data.propertys)
	--[[local atk=mgr.ConfMgr.getItemAtK(data.propertys)
	local hp=mgr.ConfMgr.getItemHp(data.propertys)
	local power=mgr.ConfMgr.getPower(data.propertys)]]--
	local lv = mgr.ConfMgr.getLv(data.propertys)
	local t = G_getCardPro(data) --
	local atk = t.base_atk
	local hp = t.base_hp
	local power = t.base_power

	local quality = conf.Item:getItemQuality(data.mId)

	self._NowLv=lv
	self.label_lv:setString(lv)
	self.prvLabelpower:setString(power)
	self.prvlabelatk:setString(atk)
	self.prvlabelhp:setString(hp)

	local confnowexp=conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),lv)
	local confnextexp=conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),lv+1)


	self:setGray(self.BtnLvUp,true)
	self:setGray(self.BtnAutoadd,true)
	if confnextexp == 0  then --配置没有下一个等级了
		--禁用按钮
		self:setGray(self.BtnLvUp,false)
		self:setGray(self.BtnAutoadd,false)

		self.NeedExp = 0 
		self.LoadingBar1:setPercent(100)
	else
		local nextexp=confnextexp-confnowexp

		self.NeedExp = nextexp-exp
		if self.NeedExp <=0 then 
			self.NeedExp = 1
		end 
		local p =  exp/nextexp
		self.LoadingBar1:setPercent(p*100)
	end 
	self:stopAllEffect()
end
--计算已经选择的 列表总经验
function SpirteLvUpView:getSelctExp()
	-- body
	local exp = 0
	for k ,v in pairs(self.SelectPetList) do 
		local type =  conf.Item:getType(v.mId)
		if type == pack_type.PRO then 
			local _exp = conf.Item:getExp(v.mId)
			exp = exp +_exp
		else
			local sexp =  mgr.ConfMgr.getExp(v.propertys)
			local lv = mgr.ConfMgr.getLv(v.propertys)
			local quality = conf.Item:getItemQuality(v.mId)
			exp=exp+conf.CardExp:getExp(conf.Item:getItemSjPre(v.mId),lv)+sexp
		end 
	end 
	return exp
end

function SpirteLvUpView:Canlv(exp,flag)
	-- body
	if exp  < 0 then 
		return false
	end 
	local data = self._petTarget:getData()

	local s_exp =  mgr.ConfMgr.getExp(data.propertys)
	local z_exp =s_exp + exp
	local quality = conf.Item:getItemQuality(data.mId)
	local lv = mgr.ConfMgr.getLv(data.propertys)

	local maxlv = conf.Item:getCardMaxlv(data.mId)
	local addnext = 0 --升到极限
	function lvup( pexp,nowlv )
		--升级所需要的经验
	
		for i = nowlv+1,maxlv do 
		   local nextexp = conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),i)
		   local currexp = conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),i-1)
		   addnext = addnext + (nextexp - currexp)
		   if pexp < addnext then 
		   		return i -1
		   end 

		   if i == maxlv then --如果一直找不到就直接返回maxlv
		   		return i 
		   end 
		end 

		return 0
	end
	local reun = lvup(z_exp,lv)

	if reun > cache.Player:getLevel() and maxlv <= lv  then 
		--print("1")
		return false
	elseif reun == 0 then 
		--print("2")
		return false
	elseif reun >= cache.Player:getLevel() and flag then 
		return false
	end 
	return true
end

function SpirteLvUpView:getAllExp(is_stone)
	
	local exp = self:getSelctExp()
	self.LabelExp:setString(exp)
	self:setNextProperty(exp)
end
--设置加成属性
function SpirteLvUpView:setNextProperty(exp)
	if exp<=0 then 
		return 
	end
	local data = self._petTarget:getData()
	--服务器保持的经验值
	local s_exp =  mgr.ConfMgr.getExp(data.propertys)
	local nowlv = mgr.ConfMgr.getLv(data.propertys)
	local quality = conf.Item:getItemQuality(data.mId)
	local conf_nowexp=conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),nowlv)
	local conf_nextexp=conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),nowlv+1)
	if conf_nextexp == 0 then --没有下一个等级
		return 
	end 
	--可升多少级
	local next_lv = 0
	--下级升级所需经验
	local next_lvup_exp=conf_nextexp-conf_nowexp
	--总经验
	local z_exp =s_exp + exp 

	local p =  z_exp/next_lvup_exp
	if p < 0 or p > 1 then
		p=1
	end
	self.LoadingBar2:setPercent(p*100)
	self:setNextSpecial(self.LoadingBar2,0.5)

	local maxlv = conf.Item:getCardMaxlv(data.mId)
	--print(maxlv)
	local lv = nowlv

	local addnext = 0 --升到极限
	function lvup( pexp,nowlv )
		--升级所需要的经验
	
		for i = nowlv+1,maxlv do 
		   local nextexp = conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),i)
		   local currexp = conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),i-1)
		   addnext = addnext + (nextexp - currexp)
		   if pexp < addnext then 
		   		return i -1
		   end 

		   if i == maxlv then --如果一直找不到就直接返回40 
		   		return i 
		   end 


		end 
		 return maxlv
	end
	local reun = lvup(z_exp,lv)
	local reun = math.min(reun,cache.Player:getLevel())
	--debugprint("reun .."..reun)
	next_lv=reun-lv
	if next_lv <= 0 then
		self.nextLabelPropertyList[1]:setString("")
	    self.nextLabelPropertyList[2]:setString("")
		self.nextLabelPropertyList[3]:setString("")
		self.nextLabelPropertyList[4]:setString("")
		return
	end

	
	local atkold = conf.CardExp:getAtk(conf.Item:getItemSjPre(data.mId),lv)
	local hpold = conf.CardExp:getHp(conf.Item:getItemSjPre(data.mId),lv)
	local powerold = conf.CardExp:getPower(conf.Item:getItemSjPre(data.mId),lv)

	local atk= conf.CardExp:getAtk(conf.Item:getItemSjPre(data.mId),reun)
	local hp = conf.CardExp:getHp(conf.Item:getItemSjPre(data.mId),reun)
	local power=conf.CardExp:getPower(conf.Item:getItemSjPre(data.mId),reun)


	self.nextLabelPropertyList[1]:setString("+"..next_lv)
    self.nextLabelPropertyList[2]:setString("+"..power-powerold)
	self.nextLabelPropertyList[3]:setString("+"..atk-atkold)
	self.nextLabelPropertyList[4]:setString("+"..hp-hpold)
	for i=1,#self.nextLabelPropertyList do
		self:setNextSpecial(self.nextLabelPropertyList[i],0.5)
	end
	
end
function SpirteLvUpView:onCloseSelfView(  )
	-- body
	self.super.onCloseSelfView(self)
	local view =  mgr.ViewMgr:get(_viewname.SPRITE7SCAD)
	if not view then
		mgr.SceneMgr:getMainScene():closeHeadView()
	end
end
--渐隐渐显特效
function SpirteLvUpView:setNextSpecial(node,time)
	node:setVisible(true)
	local  action1=cc.FadeIn:create(time)
	local  action2=cc.FadeOut:create(time)
	local  action3=cc.Sequence:create(action1,action2)
	local  action4=cc.RepeatForever:create(action3)
	node:runAction(action4)
end
function SpirteLvUpView:stopAllEffect(  )
	self.LoadingBar2:stopAllActions()
	self.LoadingBar2:setVisible(false)
	for i=1,#self.nextLabelPropertyList do
		self.nextLabelPropertyList[i]:setVisible(false)
		self.nextLabelPropertyList[i]:stopAllActions()
	end	
end

function SpirteLvUpView:changeable(flag)
	-- body
	for k ,v in pairs(self.ListWidget) do 
		v:setbtnabel(flag)
	end 
end

--搜索
function SpirteLvUpView:_autoSearch()
	--local list_data=self:getSearchData()  --刘波说不给放数码兽
	local list_data = {}
	local list_pro = self:getSearchDataoFdaoju()
	local index=1
	--print("*****************************")
	local dtt = {}

	for k ,v in pairs (list_data) do --数码兽 弃用 
		local qu=conf.Item:getItemQuality(v.mId)
		local lv=mgr.ConfMgr.getLv(v.propertys)
		local conf_exp= conf.CardExp:getExp(conf.Item:getItemSjPre(v.mId),lv)
		v.exp =  mgr.ConfMgr.getExp(v) + conf_exp

		table.insert(dtt,v)
	end 
	for k ,v in pairs(list_pro) do --精灵块
		local exp = conf.Item:getExp(v.mId)
		v.exp = exp
		table.insert(dtt,v)
	end 

	if #dtt == 0 then --如果什么都没有
		self.tobuy = true
		for i =1 , 5 do 
			local t = {}
			t.mId = EXP_STONE_ID[2]
			t.propertys = {}
			t.hehe = 1
			table.insert(dtt,t)
		end 	
	end 
 

	table.sort(dtt,function ( a,b )
		-- body
		if a.exp == b.exp then 
			return a.mId<b.mId
		else
			return a.exp < b.exp
		end 

	end)
	--debugprint(#dtt)

	local function searchExist( data  )
		-- body
		for k ,v in pairs (self.SelectPetList) do 
			if  v.cout and data.cout ==v.cout then 
				return true
			else
				if v == data then 
				--debugprint("有相同的")
					return true 
				end 
			end 
		end 
		return false 
	end



	for i = 1 , 5 do  
		local widget=self:getListWidget()[i]
		local wdata = widget:getData()

		if not widget:isExist() then -- 先早空位置
			for k ,v in pairs(dtt) do 
				if not searchExist(v) then 
					table.insert(self.SelectPetList,v)
					widget:setData(v)
					break
				end 
			end  
		end 

		--if self:getSelctExp() >= self.NeedExp then --如果足够升级就不在添加
		if not self:Canlv(self:getSelctExp(),true) then 
			self:changeable(false)
			break
		end 
	end 
	self:stopAllEffect()
	self:getAllExp(false)
end
function SpirteLvUpView:selectSearch( data )
	self.SelectPetList = data
	self:removeAllWidget()
	self.is_stone = false
	local index=1
	for k,v in pairs(data) do
		self:getListWidget()[index]:setData(v)
		index=index+1
	end
	self:stopAllEffect()
	self:getAllExp(false)

	if not self:Canlv(self:getSelctExp(),true) then --如果足够升级就不在添加
		self:changeable(false)
	end 
end
--选取
function SpirteLvUpView:getNowPetIndex( data )
	if  not self._BattleDataList then return nil end
	for i,v in ipairs(self._BattleDataList) do
		if  data.index == v.index then
			return i
		end
	end
end
--
function SpirteLvUpView:updateTargetPet( index )
	--print("index "..index)
	self.NowSelectPetIndex = index
	local data=self._BattleDataList[index]
	if self._petTarget then
		self._petTarget:setData(data)
	end
	self:visbtn()
	self._petTarget:removeEff()
	self:updatePropertyPanel(data) --设置属性
	--按钮 是进阶 还是进化
	local jinghua = data.propertys[310] and  data.propertys[310].value or 0
	if jinghua >=10 then 
		self:upteTitle(res.str.PROMOTE_TU)
	else
		self:upteTitle(res.str.PROMOTE_JIN)
	end	
end

function SpirteLvUpView:islimitLV()
	 
	local currlv = mgr.ConfMgr.getLv(self._petTarget:getData().propertys)
    local x = cache.Player:getLevel()
 	-- debugprint("currlv ="..currlv.." ,herolv ="..x)
    --debugprint("self:getNeedExp() ="..self:getNeedExp())
    local maxlv = conf.Item:getCardMaxlv(self._petTarget:getData().mId)

	if  currlv==maxlv  then --不能超过最大等级
		--todo
		local data = {};
		data.richtext = res.str.SPRITELV_UP_DEC3;
		data.sure = function( ... )
			-- body
		end
		data.surestr = res.str.SURE
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		return true
	elseif currlv >= x then --不能超过人物等级
		local data = {};
		data.richtext = res.str.SPRITELV_UP_DEC1;
		data.sure = function( ... )
			-- body
		end
		data.surestr = res.str.SURE
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		return true
	end 

	return false 
end 
--自动填加各种精灵或者道具来当 材料
function SpirteLvUpView:onAutoAddCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if not self:islimitLV() then 
			self:_autoSearch()
            local ids = {1023}
            mgr.Guide:continueGuide__(ids)
		end 
	end
end





--进化或者突破 的动画
function SpirteLvUpView:onSeverCallBack()
	-- body
	 --动画播放期间 不给点击
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(display.width,display.height))
	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
    self:addChild(layer,1000) 

    local data=self._BattleDataList[self.NowSelectPetIndex] --升级前
    local breforlv = data.propertys[310] and data.propertys[310].value or 0
   	local breforJie = data.propertys[307] and data.propertys[307].value or 0
   	--debugprint("breforJie = "..breforJie)
    self:changeData()

    local data2 = self._BattleDataList[self.NowSelectPetIndex]
    local afterlv =  data2.propertys[310] and data2.propertys[310].value or 0--升级后
    local aferJie = data2.propertys[307] and data2.propertys[307].value or 0
    local rightPet = self._petTargetUp:getPet(2)
    --debugprint("aferJie = "..aferJie)

    local dd =self._petTargetUp:getPetAddto()
    local leftPet =  self._petTargetUp:getPet(1)
    local pos  = cc.p(rightPet:getPositionX(),rightPet:getPositionY())
    if leftPet then 
    	leftPet:setVisible(false)

    	local params =  {id=404809, x=dd:getContentSize().width/2,
		y=dd:getContentSize().height/2,
		addTo=dd,
		playIndex=2,
		addName = "effofname1"}
		mgr.effect:playEffect(params)

		local  armature
		local params =  {id=404809, x=dd:getContentSize().width/2,
		y=dd:getContentSize().height/2,
		addTo=dd,
		loadComplete= function(var)
			-- body
			armature = var

			local a1 = cc.MoveBy:create(0.1,cc.p(0,120))
			local a5 = cc.MoveBy:create(0.15,cc.p(0,-60))

			local a2 = cc.DelayTime:create(0.3)
			local a3 = cc.MoveTo:create(0.2,dd:convertToNodeSpace(pos))
			

			local a4 = cc.CallFunc:create(function() 
		 		 armature:removeFromParent()
		 	 end) 
			local sequence = cc.Sequence:create(a1,a5,a2,a3,a4)
			armature:runAction(sequence)
		end,
		playIndex=1,
		addName = "effofname"}
		mgr.effect:playEffect(params)

	
    end 

    local function listener()
    	local params =  {id=404809, x=rightPet:getContentSize().width/2,
		y=rightPet:getContentSize().height/2,
		addTo=rightPet,
		endCallFunc = function( ... )
			-- body
			layer:removeFromParent()
			self:cleanSelectPet()
		  	self:removeAllWidget()
		    self:update()
		    
		    if aferJie - breforJie > 0 then --进阶动画
		    	G_playerJingjie(data,data2,self,function()
                mgr.Sound:playMainMusic()
            end)
               
		    end 
		end,
		playIndex=3,
		addName = "effofname"}
		mgr.effect:playEffect(params)
		mgr.Sound:playQianghua()
	end
	self:performWithDelay(listener, 0.7)
end

--升级 服务器返回
function SpirteLvUpView:onLvUpSeverCallBack()
	-- body
	 --动画播放期间 不给点击
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(display.width,display.height))
	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
    self:addChild(layer,1000) 

	local data=self._BattleDataList[self.NowSelectPetIndex] --升级前
	local breforlv =  mgr.ConfMgr.getLv(data.propertys)

	self:changeData()
  

    local data2 = self._BattleDataList[self.NowSelectPetIndex]
    local afterlv =  mgr.ConfMgr.getLv(data2.propertys)--升级后
    local uplv = afterlv - breforlv  --

    --self.ListWidget[i]

    local pos = cc.p(self._petTarget:getPositionX(),self._petTarget:getPositionY())

 
    for k ,v in pairs(self.ListWidget) do 
    	if v:isExist() then
    		v:getPet():setVisible(false)

    		local params =  {id=404809, x=v:getContentSize().width/2,
			y=v:getContentSize().height/2,
			addTo=v,
			playIndex=2,
			addName = "effofname1"}
			mgr.effect:playEffect(params)

    		local  armature
    		local params =  {id=404809, x=v:getContentSize().width/2,
			y=v:getContentSize().height/2,
			addTo=v,
			loadComplete= function(var)
				-- body
				armature = var
			end,
			playIndex=1,
			addName = "effofname"}
			mgr.effect:playEffect(params)

			local pianyix = (k-1)*5  --左右移动的距离
			pianyix = k%2~=0 and pianyix or -pianyix

			local a1 = cc.MoveBy:create(0.1,cc.p(pianyix,120))
			local a5 = cc.MoveBy:create(0.15,cc.p(pianyix,-60))

			local a2 = cc.DelayTime:create(0.3)
			local a3 = cc.MoveTo:create(0.15,v:convertToNodeSpace(pos))
			

			local a4 = cc.CallFunc:create(function() 
		 		 armature:removeFromParent()
		 	 end) 
			local sequence = cc.Sequence:create(a1,a5,a2,a3,a4)
			armature:runAction(sequence)
    	end 
    end 

    local function listener()
    	-- body
    	local params =  {id=404809, x=self._petTarget:getContentSize().width/2,
		y=self._petTarget:getContentSize().height/2,
		addTo=self._petTarget,
		endCallFunc = function( ... )
			-- body
			layer:removeFromParent()
			for k ,v in pairs(self.ListWidget) do 
				v:addandplay()	
			end  
			self:changeable(true)
			self:cleanSelectPet()
		  	self:removeAllWidget()
		    self:update()
		end,
		playIndex=3,
		addName = "effofname"}
		mgr.effect:playEffect(params)
		mgr.Sound:playQianghua()

		--飘字
		debugprint("uplv = "..uplv)
		if uplv > 0 then 
			local img = display.newSprite(res.font.DEC_LV)
			img:setAnchorPoint(cc.p(0,0))
			img:setPositionX(-self._petTarget:getContentSize().width/2+50)
			img:setPositionY(self._petTarget:getContentSize().height)
			img:addTo(self._petTarget)
			img:setScale(0.8)

			local imgJia = display.newSprite(res.font.PLUS)
			imgJia:setAnchorPoint(cc.p(0,0.0))
			imgJia:setPositionX(img:getContentSize().width+5)
			imgJia:addTo(img)
			local mTxt = cc.LabelAtlas:_create(uplv.."",res.font.FLOAT_NUM[3],30,41,string.byte("."))
       		mTxt:setAnchorPoint(cc.p(0,0)) 
       		mTxt:setPositionX(imgJia:getContentSize().width+5)
       		mTxt:addTo(imgJia)

       		local a1 = cc.ScaleTo:create(0.4, 1, 1, 1)
       		local a2 = cc.MoveBy:create(0.8,cc.p(0,65))
       		local a3 = cc.CallFunc:create(function( ... )
       			-- body
       			img:removeFromParent()
       		end)
       		local sequence = cc.Sequence:create(a1,a2,a3)

       		img:runAction(sequence)
		end 
    end

    self:performWithDelay(listener, 0.66)
end

--升级发送信息
function SpirteLvUpView:onLvUpCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		local lvup = {}
		lvup.index = self._petTarget:getData().index
		lvup.packIndex = { }
		for k,v in pairs(self.SelectPetList) do
			local atype = conf.Item:getType(v.mId)
			if atype == pack_type.PRO then 
				table.insert(lvup.packIndex,v.mId)
			else
				table.insert(lvup.packIndex,v.index)
			end 
		end

		local times=MyUserDefault.getIntegerForKey(user_default_keys.GAME_SPRITE_DAY)
		if times then --今日是否勾选了 不在提示
			if os.date("%x", os.time()) == os.date("%x",times) then 
				self.cancelSecond = false 
			else
				self.cancelSecond = true
			end
		end	

		if self.tobuy and self.cancelSecond then 
			local data = {}

			local _table  = {}
			for k ,v in pairs(self.SelectPetList) do 
				if v.hehe  then
					table.insert(_table,v)
				end
			end

			data.amount = #_table
			data.mId = _table[1].mId
			data.sure = function(ff)
				-- body
				proxy.card:reqLvUp(lvup)
				mgr.ViewMgr:closeView(_viewname.PROMOTE_ITEM)

				if ff  then
					MyUserDefault.setIntegerForKey(user_default_keys.GAME_SPRITE_DAY,os.time())
				end 
			end

			mgr.ViewMgr:showView(_viewname.PROMOTE_ITEM):setData(data)
			return 
		end 
		if #lvup.packIndex == 0 then 
			G_TipsOfstr(res.str.PROMOTE_NOCARD)
		elseif not self:Canlv(self:getSelctExp()) then
			--todo
			G_TipsOfstr(res.str.PROMOTE_NOCARD_DEC1)
		elseif #lvup.packIndex ~= 0 and self:Canlv(self:getSelctExp()) then 
			proxy.card:reqLvUp(lvup)
		end 	
	end
end

function SpirteLvUpView:updateColorUpPet( index )
	self.NowSelectPetIndex = index
	local data=self._BattleDataList[index]
	if self._petTargetUp then
		self._petTargetUp:setData(data)
	else
		self._petTargetUp=SpriteUp.new()
		self._petTargetUp:init(self)
		self._petTargetUp:setData(data)
		self:addChild(self._petTargetUp)
	end
end

function SpirteLvUpView:ChoosePage( index )
	-- body
	self.PageButton:initClick(index)
end

function SpirteLvUpView:upteTitle(str)
	local btn = self.Panel_up:getChildByName("Button_2_0")
	btn:setTitleText(str)
end	

return SpirteLvUpView