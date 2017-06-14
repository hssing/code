
local pet= require("game.things.PetUi")

local EquipmentWidget = require("game.views.formation.EquipmentFrame")

local RuneWidget = require("game.views.formation.RuneFrame")

local FormationView=class("FormationView",base.BaseView)

local ScollLayer = require("game.cocosstudioui.ScollLayer")

function FormationView:ctor( ... )
	-- body
end

function FormationView:init(  )
	self.ShowAll=true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--self.view:getChildByName("Image_9"):removeFromParent()

	--上面的面板
	local Panel_up=self.view:getChildByName("Panel_up")
	self.Panel_up = Panel_up
	--布阵按钮
	local btnBuzheng=Panel_up:getChildByName("Panel_left"):getChildByName("Button_l")
	btnBuzheng:addTouchEventListener(handler(self,self.onChangeCallBack))
	--小伙伴按钮
	local btnHuoban =Panel_up:getChildByName("Panel_right"):getChildByName("Button_r")
	btnHuoban:addTouchEventListener(handler(self,self.onHuobanCallBack))
	--宠物位置框
	self.headitem = Panel_up:getChildByName("Panel_clone")
	self.headlist = Panel_up:getChildByName("ListView_1")
	self:initHeadList() --初始化宠物位置框


	--中间层 当前选择的宠物信息
	local Panel_c=self.view:getChildByName("Panel_C")
	self.Panel_c = Panel_c
	self.PanelTitle=Panel_c:getChildByName("Panel_title") --宠物信息
	self.spr7s = self.PanelTitle:getChildByName("Image_13")
	self.spr7s:setVisible(false)
	--self.lab_atls = self.spr7s:getChildByName("AtlasLabel_1")
	--self.spr7s:setVisible(false)
	--self.lab_atls:setString(1) 

	self.paramsImg = self.PanelTitle:getChildByName("Image_4") --底图
	self.TitleName=self.PanelTitle:getChildByName("Image_4"):getChildByName("Text_name") --名字
	self.TitleLv=self.PanelTitle:getChildByName("Image_4"):getChildByName("Text_lv_12") --等级
	self.BgStar=self.PanelTitle:getChildByName("Panel_1")--星星
	self.PanelSprite=Panel_c:getChildByName("Panel_sprite")--存放形象层
	self.PanelSprite:setTouchEnabled(true)
	self.PanelSprite:addTouchEventListener(handler(self, self.seedetailmessage))
	--装备
	self.equipitem = self.view:getChildByName("Panel_Helmet")
	self.equipitem:setVisible(false)
	self:initEquipmentWidget() --初始化6个装备框

	self.img_di = self.view:getChildByName("Image_10")
	self.runeitem = self.view:getChildByName("Panel_2")
	self.runeitem:setVisible(false)
	self:initRuneWidget() --初始化6符文框

	self.pv = self.view:getChildByName("PageView_1")
	

	local panle_down = self.view:getChildByName("Panel_down")
	-- --替换按钮
	local Btn_change=panle_down:getChildByName("Button_z")
	Btn_change:addTouchEventListener(handler(self,self.changePet))
	--符文按钮
	local Btn_Fw=panle_down:getChildByName("Button_f")
	Btn_Fw:addTouchEventListener(handler(self,self.onFwCallBack))
	self.btnfw = Btn_Fw
	--一键换装
	self.Btn_change_equipment=panle_down:getChildByName("Button_y")
	self.Btn_change_equipment:addTouchEventListener(handler(self,self.onChangeEquipmentCallBack))


	--属性
	local shux=panle_down:getChildByName("Panel_shux")
	self.shux = shux
	--战斗力
	self.Lbale_Power=shux:getChildByName("Image_bg_title_0"):getChildByName("Text_48")
	--攻击
	self.Lbale_Atk=shux:getChildByName("Panel_35"):getChildByName("Text_33_0")
	--生命
	self.Lbale_Hp=shux:getChildByName("Panel_35_0"):getChildByName("Text_33_0_41")
	--亲密度
	self.Intimacy_1=shux:getChildByName("Text_49")
	self.Intimacy_2=shux:getChildByName("Text_49_0")
	self.Intimacy_3=shux:getChildByName("Text_49_1")
	self.Intimacy_4=shux:getChildByName("Text_49_0_0")

	self.Intimacy_5 = shux:getChildByName("Text_49_0_1") 

	self.IntimacyList={}
	self.IntimacyList[1]=self.Intimacy_1
	self.IntimacyList[2]=self.Intimacy_2
	self.IntimacyList[3]=self.Intimacy_3
	self.IntimacyList[4]=self.Intimacy_4
	self.IntimacyList[5]=self.Intimacy_5

	self.fruitCompBtn = Panel_c:getChildByName("Button_2")
	self.fruitCompBtn:addTouchEventListener(handler(self,self.fruitCompose))
	self.guiFruitCompBtn = gui.GUIButton.new(self.fruitCompBtn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

	self.btn_ke = Panel_c:getChildByName("Button_2_0")
	self.btn_ke:addTouchEventListener(handler(self, self.onbtnKeJiCallBack))
	--if g_var.platform ~= "win32" then
		self.btn_ke:setVisible(false)
	--end



	self.bg = self.view:getChildByName("Image_bg")
	self.page = 1 --当前是装备
	self:initDec()
	self:setData()
	

	
	G_FitScreen(self,"Image_bg")
	
	self:performWithDelay(function()
		-- body
		---预加载动画到内存
		local effConfig = conf.Effect:getInfoById(404803)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
		end)
		local effConfig = conf.Effect:getInfoById(404808)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)
		local effConfig = conf.Effect:getInfoById(404835)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)

		self:forever()
	end,0.01)

	
end

function FormationView:initDec()
	-- body
	self.view:getChildByName("Panel_up"):getChildByName("Panel_left"):getChildByName("Text_l"):setString(res.str.DUI_DEC_01)
	self.view:getChildByName("Panel_up"):getChildByName("Panel_right"):getChildByName("Text_r"):setString(res.str.DUI_DEC_02)
	self.shux:getChildByName("Panel_35"):getChildByName("Text_39"):setString(res.str.DUI_DEC_04)
	self.shux:getChildByName("Panel_35_0"):getChildByName("Text_39_43"):setString(res.str.DUI_DEC_03)

	local Panel_down = self.view:getChildByName("Panel_down")
	self.view:getChildByName("Panel_down"):getChildByName("Button_f"):setTitleText(res.str.DUI_DEC_09)
 	self.view:getChildByName("Panel_down"):getChildByName("Button_z"):setTitleText(res.str.DUI_DEC_10)
 	self.view:getChildByName("Panel_down"):getChildByName("Button_y"):setTitleText(res.str.DUI_DEC_11)
 	--self.view:getChildByName("Panel_down"):getChildByName("Button_y"):setTitleFontSize(24)

 	self.view:reorderChild(self.bg, 9)
 	self.view:reorderChild(Panel_down, 10)
 	self.view:reorderChild(self.pv, 11)
 	self.view:reorderChild(self.img_di, 12)
 	self.view:reorderChild(self.Panel_c, 13)
 	self.view:reorderChild(self.Panel_up, 14)
end

function FormationView:forever( ... )
	-- body
	local params =  {id=404826, x=self.bg:getContentSize().width/2,
	y=self.bg:getContentSize().height/2,addTo=self.bg, playIndex=4}
	mgr.effect:playEffect(params)
end

--headitem 
function FormationView:getBattleClone()
	-- body
	return self.headitem:clone()
end
--初始化 头像框
function FormationView:initHeadList()
	-- body
	for i=1,6 do 
		local widget=CreateClass("views.formation.BattleHead")
		widget:init(self,i)
		widget:addCallBack(handler(self,self.selectCallBack))
		self.headlist:pushBackCustomItem(widget)
	end 
end

function FormationView:selectedpage( pos )
	-- body
	self.pv:scrollToPage(pos-1)
end

function FormationView:setRedPoint()
	-- body
	--红点
	if self.Btn_change_equipment:getChildByName("img_hong") then 
		self.Btn_change_equipment:getChildByName("img_hong"):removeFromParent()
	end

	if self.page ==1 and  #self:checkEquipOne() > 0 then
	--if self.yijian  then 
		local imp = display.newSprite(res.image.RED_PONT)
		imp:setName("img_hong")
		imp:setPosition(self.Btn_change_equipment:getContentSize().width-imp:getContentSize().width/2
			,self.Btn_change_equipment:getContentSize().height)
		self.Btn_change_equipment:addChild(imp)
	elseif self.page == 2 then
		for i = 1 ,#self.Runelist do
			local widget = self.Runelist[i]
			local tt = self.wearRune[self.SelectBattlePos] and 
			self.wearRune[self.SelectBattlePos][i] or nil

			if tt then
				local pom = mgr.BoneLoad:loadArmature(404856,0)
				pom:setPositionX(widget:getContentSize().width/2)
				pom:setPositionY(widget:getContentSize().height/2)
				pom:addTo(widget)
				pom:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
					if movementType == ccs.MovementEventType.complete then
						pom:removeSelf()
					end
				end)
			end
		end
	end
end

--头像框 方法回调 --只是在有宠物的时候到这里
function FormationView:selectCallBack( pos,send )
	-- body
	--print("-----".."callback_main")
	if send then
		pos = send.page
	end
	
	--G_TipsOfstr(pos)
	--看看有没有数码兽上阵
	-- local isShang = false
	-- local gotoData = {}
	-- for k,v in pairs(self.BattleData) do
	-- 	if  pos ==  then
	-- 		gotoData = v
	-- 		isShang = true
	-- 		break
	-- 	end
	-- end

	-- if isShang == false then
	-- 	return
	-- end

	local data = nil
	for k ,v in pairs(self.headlist:getItems()) do 
		v:setSelectState(false)
		if v.page == pos then
			data = v:getData()
			if data == nil then
				return
			end

			self.realPos = k
			v:setSelectState(true)
		end
	end 
	-- local choose = self.headlist:getItem(pos-1)
	-- choose:setSelectState(true)
	--选中效果

	-- for k,v in pairs(table_name) do
	-- 	print(k,v)
	-- end
	-- if data == nil then
	-- 	return
	-- end


	if self.headpos ~= pos then 
		if not self.paramsImg:getChildByName("effofname") then 
			local params =  {id=404803, x=self.paramsImg:getContentSize().width/2-10,
			y=self.paramsImg:getContentSize().height/2,
			addTo=self.paramsImg,endCallFunc=nil,from=nil,to=nil, playIndex=1,addName = "effofname"}
			mgr.effect:playEffect(params)
		end 
		
		--[[if not self.choosearme  then 
			local params =  {id=404803, x = choose:getContentSize().width/2,
			y = choose:getContentSize().height/2,addTo = choose}
			mgr.effect:playEffect(params)
		end ]]--
	end 
	--printt(self.BattleData)
	--print(self.headpos)



--	dump(data)
	self.headpos = pos
	-- local data = self.headlist:getItem(pos).data --self.BattleData[self.headpos]
	-- print(self.headpos)
	--dump(data)
	self.SelectBattlePos = conf.Item:getBattleProperty(data)

	--printt(data)
	--debugprint("上阵位置 = "..self.SelectBattlePos)
	--print("self.headpos ="..self.headpos)

	self:updateInfo(data)


	for i=1,#self.EquipmentList do --设置每个位置的装备
		local widget = self.EquipmentList[i]

		local tt = self.HasEquipmentDataList[self.SelectBattlePos] and 
		self.HasEquipmentDataList[self.SelectBattlePos][i] or nil
		widget:setData(tt,self.SelectBattlePos)
	end 
	--装备符文
	for i = 1 ,#self.Runelist do
		local widget = self.Runelist[i]
		local tt = self.wearRune[self.SelectBattlePos] and 
		self.wearRune[self.SelectBattlePos][i] or nil
		widget:setData(tt,self.SelectBattlePos,data)
	end

	self:setRedPoint()
	self:setFruitRedpoint()

	self.pv:scrollToPage(pos-1)

end

function FormationView:setData(pos)
	-- body

	self.BattleData = {}
	local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)


	for k,v in pairs(data) do
		if conf.Item:getBattleProperty(v) > 0 then
			table.insert(self.BattleData,v) --所有上阵的人
		end
	end
	

	--上阵排序
	table.sort( self.BattleData, function ( a,b )
		local in1=conf.Item:getBattleProperty(a)
		local in2=conf.Item:getBattleProperty(b)
		return in1 < in2
	end)
	--self.pv:setVisible(false)
    --设置当前显示 符文 还是装备
	self:setFwEq()
	--每个形象加在一个pageview里面
	self:initPageView()
	--所有上阵宠物的装备
	self:initHasEquipmentData()
	--所有上阵宠物的符文
	self:initHasRuneData()

	--给各个头像框放置头像
	self:setHeadIcon(pos)
	
	
end
--给各个头像框放置头像
function FormationView:setHeadIcon(pos)
	-- body
	for k ,v in pairs(self.headlist:getItems()) do 
		v:clear()
		v.Pagedata = nil
		for k2,v2 in pairs(self.BattleData) do
			if k == tonumber(conf.Item:getBattleProperty(v2)) then
				local widget = self.headlist:getItem(k-1)
				widget:setData(v2)
				v.Pagedata = v2
			end
		end
	end 

	local bechoose = 0
	-- for k ,v in pairs(self.BattleData) do 
	-- 	local widget = self.headlist:getItem(k-1)
	-- 	widget:setData(v)
	-- 	if pos then 
	-- 		print(k,conf.Item:getBattleProperty(v))
	-- 		if tonumber(conf.Item:getBattleProperty(v)) == tonumber(pos) then 
				
	-- 			bechoose = k
	-- 		end 
	-- 	end
	-- end 

	-- for k,v in pairs(self.headlist:getItems()) do
	-- 	for k2,v2 in pairs(self.BattleData) do
	-- 		if k == tonumber(conf.Item:getBattleProperty(v2)) then
	-- 			local widget = self.headlist:getItem(k-1)
	-- 			widget:setData(v2)
	-- 			v.Pagedata = v2
	-- 		end
	-- 	end
	-- end

	local bechoose = 0
	for k ,v in pairs(self.BattleData) do 
		local widget = self.headlist:getItem(k-1)
		if pos then 
			print(k,conf.Item:getBattleProperty(v))
			if tonumber(conf.Item:getBattleProperty(v)) == tonumber(pos) then 
				bechoose = k
			end 
		end
	end 



	--self.headpos = 1 

	for k ,v in pairs(self.headlist:getItems()) do 
		if v:getChildByName("effofname")then 
			v:getChildByName("effofname"):removeFromParent()
		end 
		v:playAction()
	end 

	if bechoose ~=0 then 
		print("bechoose = "..bechoose)
		self.headpos = bechoose
	end 

	--G_TipsOfstr(pos)

	if not self.headpos then 
		self.headpos = 1 
		self:selectCallBack(self.headpos)
	else
		if #self.BattleData <self.headpos then 
			debugprint("#self.BattleData "..#self.BattleData)
			self:selectCallBack(#self.BattleData)
		else
			debugprint("self.headpos "..self.headpos)
			self:selectCallBack(self.headpos)
		end
	end 
end

function FormationView:pageTurn()
	-- body
	if not self.currpage then 
		self.currpage = self.pv:getCurPageIndex()
		self:selectCallBack(self.currpage+1)
		--self:selectCallBack(self.currpage)
		return 
	end 

	if self.currpage == self.pv:getCurPageIndex() then return end 
	self.currpage = self.pv:getCurPageIndex()
   self:selectCallBack(self.currpage +1 )
   --self:selectCallBack(self.currpage )
end

function FormationView:initPageView( ... )
	-- body
	self.pv:removeAllPages()
	local layout_c = self.view:getChildByName("Panel_C")
	for k , v in pairs(self.headlist:getItems()) do 
		local data = nil
		v.page = nil
		v.view:getChildByName("Button").page = nil
		for k2,v2 in pairs(self.BattleData) do
			if k == tonumber(conf.Item:getBattleProperty(v2)) then
				data = v2
				local layout = ccui.Layout:create()
				layout:setContentSize(layout_c:getContentSize())
				--layout:setTouchEnabled(true)

				local posx ,posy = self.PanelSprite:getPosition()
				posx = posx + self.PanelSprite:getContentSize().width/2
				posy = posy --+ PanelSprite:getContentSize().height/2

				local offsetY = 0 --宠物位置偏移 
				posy = posy + offsetY
				print(v2.mId)
				local pet = pet.new(v2.mId,v2.propertys)
				pet:setAnchorPoint(0.5,0)
				local Quality=conf.Item:getItemQuality(v2.mId)

				local jie =  v2.propertys[307] and v2.propertys[307].value or 0
				pet:setScale(res.card.formationScale[tostring(Quality)][jie+1])

				pet:setPosition(posx, posy)
				pet:addTo(layout) 
				self.pv:addPage(layout)
				

				--dump(value, desciption, nesting)
				v.page = k2
				v.view:getChildByName("Button").page = k2
				layout.headIdx = k
				break
			end

		end


	end 
	self.pv:addEventListener(handler(self, self.pageTurn))
end

function FormationView:updateInfo(data)
	-- body
	self.showdata = data


	local lv=conf.Item:getLv(data)
	local Quality=conf.Item:getItemQuality(data.mId)
	local name=conf.Item:getName(data.mId,data.propertys)

	self.spr7s:setVisible(false)

	--self.lab_atls:setString(1) 
	local conf_data = conf.Item:getItemConf(data.mId)
	if conf_data.zhuan then
		self.spr7s:setVisible(true)
		self.spr7s:ignoreContentAdaptWithSize(true)
		self.spr7s:loadTexture(res.icon.ZHUAN[conf_data.zhuan])
		--self.lab_atls:setString(conf_data.zhuan) 
	end
	self.TitleName:setString(name)
	self.TitleLv:setString(lv)
	self.TitleName:setColor(COLOR[Quality])
	self:addStar(Quality)


	local power=mgr.ConfMgr.getPower(data.propertys)
	local atk=mgr.ConfMgr.getItemAtK(data.propertys)
	local hp=mgr.ConfMgr.getItemHp(data.propertys)

	local Intimacy_id=conf.Item:getIntimacyID(data.mId)

	for k ,v in pairs(self.IntimacyList) do 
		v:setString("")
	end 

	if Intimacy_id then
		local listname = conf.CardIntimacy:getSkillName(Intimacy_id)
		local listid = conf.CardIntimacy:getPetList(Intimacy_id)
		for j=1,#listid do
			if G_CheckFriend_qm(listid[j]) then 
				self.IntimacyList[j]:setColor(cc.c3b(255,104,22))
			else
				self.IntimacyList[j]:setColor(cc.c3b(0xaf,0xac,0xac))
			end
			--[[for i=1,#self.BattleData do
				self.IntimacyList[j]:setColor(cc.c3b(0xaf,0xac,0xac))
				if self.BattleData[i].mId == listid[j] then
					self.IntimacyList[j]:setColor(cc.c3b(255,104,22))
					break;
				end
			end]]--
			self.IntimacyList[j]:setString(listname[j])
		end
	else
		self.IntimacyList[5]:setString(res.str.DEC_NEW_45)
	end 
	self.Lbale_Power:setString(power)
	self.Lbale_Atk:setString(atk)
	self.Lbale_Hp:setString(hp)
end

function FormationView:addStar( amount )
	self.BgStar:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.BgStar:getContentSize().height
	local iconwidth=self.BgStar:getContentSize().width
	local sprite=display.newSprite(starpath)
	local spr_width=sprite:getContentSize().width
	local starx=(iconwidth-spr_width*amount)/2
	for i=1,amount do
		sprite=display.newSprite(starpath)
		sprite:setPosition(starx-10+spr_width*i,iconheight/2)
		self.BgStar:addChild(sprite)
	end
end
-----
function FormationView:initEquipmentWidget()
	-- body
	self.EquipmentList = {}
	local starx=50
	local stary= display.height - 300*(display.height/960) --670
	local width =450
	local height =162*(display.height/960)
	for i=1,6 do
		local widget = EquipmentWidget.new(self.equipitem,i)
		widget:setPosition(starx+(i-1)%2*width,stary-math.floor((i-1)/2)*height)
		widget:setCallBack(handler(self,self.onEquipmentFrameCallBack))
		self:addChild(widget)

		self.EquipmentList[#self.EquipmentList+1]=widget
	end 
end


function FormationView:initRuneWidget()
	-- body
	self.Runelist = {}
	for i = 1 , 6 do
		local widget = RuneWidget.new(self.runeitem,i)
		widget:setCallBack(handler(self,self.onRuneCallBack))
		widget:setPosition(self.img_di:getChildByName("Image_1_"..i):getPosition())
		widget:addTo(self.img_di)
		self.Runelist[i] = widget
	end
end

function FormationView:onRuneCallBack( index , data_)
	-- body
	--debugprint("点击位置回调")
	if not data_ then
		---print("弹出选择")
		--符文位置变化
		local index = 600000+self.SelectBattlePos*1000+index
		local view =  mgr.ViewMgr:showView(_viewname.RUNE_LIST_VIEW)
		view:setWearpos(index)
	else
		--print("查看")
		local view = mgr.ViewMgr:showView(_viewname.RUNE_MSG)
		view:setData(self.wearRune)
		view:setSelectIndex(self.SelectBattlePos,index)	
	end
end



--装备位置选择
function FormationView:onEquipmentFrameCallBack( State,pos )
	-- body
	proxy.card:setToindx(-1)
	if  State == 1 then
		local index= 400000+self.SelectBattlePos*1000+pos
		mgr.ViewMgr:showView(_viewname.EQUIPMENT):setData(index)
		--选择武器
        local ids = {1039, 1057}
        mgr.Guide:continueGuide__(ids)
	elseif State == 2 then
		
		local view = mgr.ViewMgr:createView(_viewname.EQUIPMENT_MESSAGE)
		view:setData(self.HasEquipmentDataList)
		view:selectUpdate(self.SelectBattlePos,pos)
		if view then
			 mgr.ViewMgr:showView(_viewname.EQUIPMENT_MESSAGE)
		end
        --选择武器
        local ids = {1046}
        mgr.Guide:continueGuide__(ids)
	end 
end

function FormationView:initHasRuneData()
	-- body
	self.wearRune = cache.Rune:getUseinfoVec()
end

function FormationView:initHasEquipmentData()
	-- body
	local data = cache.Equipment:getEquitpmentDataInfo()
	self.HasEquipmentDataList = {
		{},
		{},
		{},
		{},
		{},
		{}
	}
	for k,v in pairs(data) do
		--print("k = "..k)
		local battle_index=tonumber(string.sub(k,3,3))  --数码兽 上阵位置 
		local bt=self.HasEquipmentDataList[battle_index]
		local part = conf.Item:getItemPart(v.mId) --装备部位
		if bt then
			self.HasEquipmentDataList[battle_index][part]=v
		else
			self.HasEquipmentDataList[battle_index]={}
			self.HasEquipmentDataList[battle_index][part]=v
		end
	end
end

--强化后装备属性对应要变化
function FormationView:updateEquipment(data)
	-- body
	for k ,v in pairs(self.HasEquipmentDataList) do 
		for i , value in pairs(v) do 
			if data.index  == value.index then 
				self.HasEquipmentDataList[k][i] = data 
				break
			end 
		end 
	end
	--self:update()
	if not self.headpos then 
		self:selectCallBack(1)
	else
		if #self.BattleData <self.headpos then 
			self:selectCallBack(#self.BattleData)
		else
			self:selectCallBack(self.headpos)
		end
	end 
end 

--跳转去装备
function FormationView:nextStepEquip()
	-- body
	for k ,v in pairs(self.EquipmentList) do 
		if v:getData() then 
			self:onEquipmentFrameCallBack(2,k)
			break
		end 	
	end 	
end

--为了界面跳转用的
function FormationView:nextStep()
	-- body
	self.headpos = 1
	local view=mgr.ViewMgr:createView(_viewname.PETDETAIL)
	view:setData(self.BattleData)
	view:selectUpdate(self.headpos)
    mgr.ViewMgr:showView(_viewname.PETDETAIL)
end


function FormationView:seedetailmessage( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("查看详细信息")
		local view=mgr.ViewMgr:createView(_viewname.PETDETAIL)
		view:setData(self.BattleData)
		view:selectUpdate(self.headpos)
		--view:selectUpdate(self.realPos)

	    mgr.ViewMgr:showView(_viewname.PETDETAIL)
        local ids = {1021}
        mgr.Guide:continueGuide__(ids)
	end 
end
--替换
function FormationView:changePet(sender_,eventtype)
	-- body
	if eventtype ==  ccui.TouchEventType.ended  then 
		-- local data = self.BattleData[self.realPos]
		-- local pos=conf.Item:getBattlePropertyTo(data)
		--G_TipsOfstr(self.realPos)
		mgr.ViewMgr:showView(_viewname.BATTLE_LIST):setData(self.realPos,13)
	end 
end
--装备符文 切换
function FormationView:setFwEq()
	-- body
	if self.page == 1  then
		self.btn_ke:setVisible(false)
		self.btnfw:setTitleText(res.str.DUI_DEC_09)
		self.Btn_change_equipment:setTitleText(res.str.DUI_DEC_11)
		for k ,v in pairs(self.EquipmentList) do 
			v:setVisible(true)
		end
		for k ,v in pairs(self.Runelist) do 
			v:setVisible(false)
		end
		--self.pv:setVisible(true)
		self.PanelSprite:setVisible(true)
		self.img_di:setVisible(false)

		self.view:reorderChild(self.pv, 11)

		self.fruitCompBtn:setVisible(true)
	else
		self.btn_ke:setVisible(false)
		self.btnfw:setTitleText(res.str.DEC_NEW_10)
		self.Btn_change_equipment:setTitleText(res.str.DUI_DEC_64)
		for k ,v in pairs(self.EquipmentList) do 
			v:setVisible(false)
		end
		for k ,v in pairs(self.Runelist) do 
			v:setVisible(true)
		end

		self.PanelSprite:setVisible(false)
		self.img_di:setVisible(true)

		self.view:reorderChild(self.pv, 8)
		self.fruitCompBtn:setVisible(false)
	end 
end

function FormationView:CallbtnFuben( ... )
	-- body
	self:onFwCallBack(self.btnfw,ccui.TouchEventType.ended)
end

function FormationView:onHuobanCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--G_TipsMoveUpStr(res.str.DUI_DEC_12)
		local view = mgr.ViewMgr:showView(_viewname.CRADFRIEND)
		view:setData()
	end
end

--符文回调
function FormationView:onFwCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		--G_TipsMoveUpStr(res.str.DEC_ERR_25)
		if self.page == 1  then
			self.page = 2
		else
			self.page = 1
		end
		self:setFwEq()
		self:setRedPoint()
		--self.fruitCompBtn:setVisible(false)
		--G_TipsMoveUpStr(res.str.DUI_DEC_12)
	end
end

--符文会被添加到的位置
function FormationView:willonPos(_table)
	-- body
	--print("ddddddddddd-------------------------")
	--printt(_table)
	local data = self.showdata 
	local jie = data.propertys[307] and data.propertys[307].value + 1  or  1
	local jinghua = data.propertys[310] and data.propertys[310].value + 1  or  1

	local part_get = 2
	if jie >= 4 then
		part_get = 6
	elseif jie>=3 then
		--todo
		part_get = 5
	elseif jie >= 2 then
		part_get = 4
	elseif jie >=1 and jinghua >=5 then
		part_get = 3
	else
		part_get = 2
	end

	local function callback( data_ )
		-- body
		local flag = false
		for k , v in pairs(_table) do 
			if v.mId == data_.mId then
				flag = true
				break
			end
		end

		if not flag then
			table.insert(_table,data_)
		end
	end
	if self.wearRune[self.SelectBattlePos] then
		for k , v in pairs(self.wearRune[self.SelectBattlePos]) do 
			callback(v)
		end
	end

	table.sort(_table,function( a,b )
	-- body
		local acolorlv = conf.Item:getItemQuality(a.mId)
		local bcolorlv = conf.Item:getItemQuality(b.mId)

		local a_type = conf.Item:getItemtypePart(a.mId)
		local b_type = conf.Item:getItemtypePart(b.mId)

		local apower = a.propertys[315] and a.propertys[315].value or 0 -- mgr.ConfMgr.getPower(a.propertys)
        local bpower =  b.propertys[315] and b.propertys[315].value or 0--mgr.ConfMgr.getPower(b.propertys)

        local a_suit_id =  conf.Item:getItemSuitId(a.mId) or 0
        local b_suit_id =  conf.Item:getItemSuitId(b.mId) or 0

        if acolorlv ~= bcolorlv then
        	return acolorlv > bcolorlv
        else
        	if a_suit_id ~= b_suit_id then
        		return a_suit_id > b_suit_id
        	else
        		if apower ~= bpower then
        			return apower > bpower
        		else
        			if a_type ~= b_type then
        				return a_type > b_type
        			else
        				return a.index>b.index
        			end
        		end
        	end
        end
       
	end)

	local t = {}
	local t1 = {}
	for i = 1 , part_get do 
		local v = _table[i]
		if v then 
			if v.index < 600000 then
				table.insert(t,v)
			end 
		end 
		table.insert(t1,v)
	end 

	return t , t1
end

--布阵回调
function FormationView:onChangeCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		mgr.ViewMgr:showView(_viewname.CHANGE_FORMATION):setData(self.BattleData)
	end
end
--一键换砖
function FormationView:onChangeEquipmentCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--local t = self:checkEquip()--self:getTable()
		if self.page == 1 then
			local t = self:checkEquipOne()
			proxy.card:setToindx(-1)
			for k , v in pairs(t) do 
				local part = conf.Item:getItemPart(v.mId)
				local pos = 400000+(self.SelectBattlePos)*1000+part
				proxy.Equipment:reqWearEquipment(pos,v.index)
			end
		else
			local view = mgr.ViewMgr:showView(_viewname.RUNE_PRO_MSG)
			view:setData(self.wearRune[self.SelectBattlePos])
		end
	end
end

function FormationView:getEquipByPart(parttable,param)
	-- body
	--身上的套装posSuit[suit_id][mid]
	local posSuit = {}
	for k ,v in pairs(param) do 
		local suit_id = conf.Item:getItemSuitId(v.mId) 
		if suit_id then 
			if not posSuit[suit_id] then 
				posSuit[suit_id] = {}
			end 
			--table.insert(posSuit[suit_id],v)
			posSuit[suit_id][v.mId] = v
		end 
	end  

	--可替换上来的最高品质
	local maxcolor = 0
	local listpart ={}
	for k , v in pairs(parttable) do 
		-- k 值  是部位  v 是品质
		if  v>maxcolor then 
			maxcolor = v
		end 
	end  

	--只按最大品质找
	local suittable = {} --找的套装 --需要把身上的一起做对比 只要最大品质的相同的
	for k ,v in pairs(posSuit) do 
		
		local mId =  table.keys(v)[1]
		local color =  conf.Item:getItemQuality(mId)
		if color == maxcolor then 
			if not suittable[k] then 
				suittable[k] = {}
			end 
			for i ,j in pairs(v) do 
				table.insert(suittable[k],j)
			end 
		end 
 	end 
 	--开始找套装
 	local havedone = {}
	for k ,v in pairs(parttable) do 
		if v == maxcolor then 
			local t =  G_autoSearchEquipment(k) 
			--分出套装
			--local mId = 0
			for i , j in pairs(t) do 
				if not havedone[j.mId]   then --同样的装备只取一个
					havedone[j.mId] = true
					mId = j.mId
					
					local suit_id = conf.Item:getItemSuitId(j.mId) 
					local color = conf.Item:getItemQuality(j.mId)
					if color == maxcolor then --只找这个品质
						if suit_id then --是套装
							if posSuit[suit_id] then -- 和身上是同一套
								if posSuit[suit_id][j.mId] then --已经有这件
									local p =   mgr.ConfMgr.getPower(posSuit[suit_id][j.mId].propertys)
									local p1 = mgr.ConfMgr.getPower(j.propertys)
									if p < p1 then 
										for n,m in pairs(suittable[suit_id]) do 
											if m.mId == j.mId then 
												m = j 
												break;
											end 
										end 
									end 
								else 
									if not suittable[suit_id] then 
										suittable[suit_id] = {}
									end
									table.insert(suittable[suit_id],j)	
								end 
							else
								if not suittable[suit_id] then 
									suittable[suit_id] = {}
								end
								table.insert(suittable[suit_id],j)	
							end 
						end
					end 
				end
			end 
		end 
	end 

	print("------------------------------------------------")
	--在套装里面跳多的，多的跳战力大的
	local function allPower( data_ , id  )
		-- body
		local p = 0
		for i , j in pairs(data_) do 
			p = p+ mgr.ConfMgr.getPower(j.propertys)
		end 
		return p
	end
	local maxcout = 0
	local bestlist = {}

	for k ,v in pairs(suittable) do 
		local ccccc = #v 
		if tonumber(ccccc) > 1 then 
			if ccccc  > maxcout then 
				maxcout = ccccc
				bestlist = v
			elseif  ccccc == maxcout then 
				local p1 = allPower( v , k  )
				local p2 = allPower(bestlist , k )
				if  p1> p2 then
					bestlist = v 
				elseif  p1 == p2 then 
					for i , j in pairs(v) do 
						if j.index>400000 then 
							bestlist = v
						end 
					end 
				end 
			end  
		end
	end 
	--[[print("**************************************************************")
	printt(bestlist)
	print("**************************************************************")]]--

	for k , v in pairs(bestlist) do 
		local part = conf.Item:getItemPart(v.mId) 
		--print("name = "..conf.Item:getName(v.mId))
		parttable[part] = nil --这些位置有了最好的装备
		--if v.index<400000 then  
		--	parttable[part] = nil 
		--end 
	end 

	--printt(bestlist)

	for k ,v in pairs(parttable) do 
		if v and v ==maxcolor then 
			local t = G_autoSearchEquipment(k)[1]
			if param[k] then 
				if conf.Item:getItemQuality(param[k].mId) < conf.Item:getItemQuality(t.mId) then 
					table.insert(bestlist,t)
			    elseif conf.Item:getItemQuality(param[k].mId) < conf.Item:getItemQuality(t.mId) and 
				 	mgr.ConfMgr.getPower(param[k].propertys)<mgr.ConfMgr.getPower(t.propertys) then 
					table.insert(bestlist,t)
				end
			else
				--print("dwu")
				table.insert(bestlist,t)
			end
			parttable[k] = nil 
		end 
	end 

	for k , v in pairs(bestlist) do 
		local part = conf.Item:getItemPart(v.mId)
		param[part] = v 
	end 

	local last_data ={}
	for k , v in pairs(bestlist) do 
		if v.index<400000 then 
			table.insert(last_data,v)
		end 
	end 
	--printt(last_data)
	if #last_data>0 then 
		return last_data
	else
		return nil 
	end  

end



function FormationView:checkEquipOne( ... )
	-- body
	--self.SelectPos 数码兽是上阵位置
	--self.HasEquipmentDataList[pos][part] --pos 数码兽是上阵位置() part 是装备位置
	--不管什么装备 都是品质>套装>数量>战斗力>id
	local data = clone(self.HasEquipmentDataList[self.SelectBattlePos] or {})

	local parttable = {}
	for i = 1 , 6 do  --如果背包的品质比较低就不换了 没有也排除 并且排除这几个位置
		local t =  G_autoSearchEquipment(i) 
		local c_e = self.HasEquipmentDataList[self.SelectBattlePos] and 
		self.HasEquipmentDataList[self.SelectBattlePos][i] or nil 
		local flag = false
		if #t == 0  then  --这个位置背包没东西
			flag = true
		elseif c_e and #t>0  then --同样的位置 但是只有低品质的装备也不需要找了
			if conf.Item:getItemQuality(c_e.mId)>conf.Item:getItemQuality(t[1].mId) then 
				flag = true
			end 
		end 

		if not flag then 
			parttable[i] = conf.Item:getItemQuality(t[1].mId)
			--table.insert(parttable[],i) --那些部位需要找装备
		end 
	end  

	--开始查找这些位置的可以替换的装备
	local bestsend = {}
	while true do
		--todo
		local re_part = self:getEquipByPart(parttable,data)
		if re_part then 
			for k , v in pairs(re_part) do 
				table.insert(bestsend,v)
			end 
		end 
		--print("dddddd")

		local count = 0 
		for k ,v in pairs(parttable) do 
			if v then
				count= count +1 
			end 
		end 
		if count == 0 then --所有需要的位置都找到了装备
			break
		end 	
	end
	return bestsend
end
---------------------------------------------------------------------------------------------------------------------
--*******************************************************************************************************************
--*******************************************************************************************************************
function FormationView:checkRune()
	-- body
	local data = self.showdata 
	local jie = data.propertys[307] and data.propertys[307].value + 1  or  1
	local jinghua = data.propertys[310] and data.propertys[310].value + 1  or  1

	local part_get = 2
	if jie >= 4 then
		part_get = 6
	elseif jie>=3 then
		--todo
		part_get = 5
	elseif jie >= 2 then
		part_get = 4
	elseif jie >=1 and jinghua >=5 then
		part_get = 3
	else
		part_get = 2
	end
	--已经穿戴的 key 类型 value 品质
	local maxColor = {}

	local c_r = {}
	if self.wearRune[self.SelectBattlePos] then

		for k ,v in pairs(self.wearRune[self.SelectBattlePos]) do 
			local colorlv = conf.Item:getItemQuality(v.mId) 
			local part = conf.Item:getItemtypePart(v.mId)
			local suit_id =  conf.Item:getItemSuitId(v.mId) 

			c_r[part] = {}
			c_r[part]["colorlv"] = colorlv
			c_r[part]["suit_id"] = suit_id
			c_r[part]["power"] =  v.propertys[315] and v.propertys[315].value or 0
			c_r[part]["data"] = v 

			local flag = false
			for k ,v in pairs(maxColor) do 
				if v == colorlv then
					flag = true
					break
				end  
			end

			if not flag then
				table.insert(maxColor,colorlv)
			end
		end

	end
	--按品质排序
	table.sort(maxColor,function(a,b)
		-- body
		return a > b 
	end)

	local function sortdata( data )
		-- body
		table.sort(data,function( a,b )
		-- body
			local acolorlv = conf.Item:getItemQuality(a.mId)
			local bcolorlv = conf.Item:getItemQuality(b.mId)

			local a_type = conf.Item:getItemtypePart(a.mId)
			local b_type = conf.Item:getItemtypePart(b.mId)

			local apower = mgr.ConfMgr.getPower(a.propertys)
	        local bpower = mgr.ConfMgr.getPower(b.propertys)

	        if a_type ~= b_type then
	        	return a_type > b_type
	        else
	        	if acolorlv ~= bcolorlv then
	        		return acolorlv > bcolorlv
	        	else
	        		if apower ~= bpower then
	        			return apower > bpower
	        		else
	        			return a.mId>b.mId
	        		end
	        	end
	        end
		end)
	end

	--获取背包数据 
	local packinfo = cache.Rune:getPackinfo()
	sortdata(packinfo)

	
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	--先排除和身上类型相同的 而且品质低的 或者战力低的
	local p_t1 = {}
	local isGet = {}
	local function delete_1( v )
		-- body
		if isGet[v.mId] then --同ID 取一件就好了
			return  false
		end

		local colorlv = conf.Item:getItemQuality(v.mId) 
		local part = conf.Item:getItemtypePart(v.mId)
		local suit_id =  conf.Item:getItemSuitId(v.mId) 
		local power = v.propertys[315] and v.propertys[315].value or 0

		if c_r[part]  then
			if c_r[part]["colorlv"] > colorlv then --品质低排除
				return false
			else  
				if v.mId == c_r[part]["data"].mId then --相同ID 排除战力低的
					if c_r[part]["power"] >= power then
						return false
					end
				else
					if  not suit_id then --如果不是套装 排除战力低下的
						if c_r[part]["power"] >= power then
							return false
						end
					end 
				end
			end 
		end	

		isGet[v.mId] = true

		return true
	end

	for k ,v in pairs(packinfo) do 
		if delete_1(v) then
			table.insert(p_t1,v)
		end 
	end
	--装备获取
	local function getRuneByColor(color)
		-- body
		local t = {}
		for k , v in pairs(p_t1) do 
			if conf.Item:getItemQuality(v.mId) >= color then
				table.insert(t,v)
			end
		end
		return t
	end
	--战力计算
	local function allPower( data )
		-- body
		local r_power = 0
		for k ,v in pairs(data) do 
			local power =  v.propertys[315] and v.propertys[315].value or 0
			r_power = r_power + power
		end 
		return r_power
	end

	local last_t = {}
	local function setRuneBy( data_ )
		-- body
		--table.
		sortdata(data_)
		for k ,v in pairs(data_) do 
			if #last_t >= part_get then
				break
			end
			local colorlv = conf.Item:getItemQuality(v.mId) 
			local part = conf.Item:getItemtypePart(v.mId)
			local suit_id =  conf.Item:getItemSuitId(v.mId) 
			local power = v.propertys[315] and v.propertys[315].value or 0
			--print("---------*************------------")
			--printt(v)
			if not c_r[part] then --如果没有这个类型的装备 对比战力
				--table.insert(last_t,v)
				local flag = false
				if self.wearRune[self.SelectBattlePos] then
					for i , j in pairs(self.wearRune[self.SelectBattlePos]) do 
						local j_colorlv = conf.Item:getItemQuality(j.mId)
						local j_suit_id =  conf.Item:getItemSuitId(j.mId) 
						local j_power = j.propertys[315] and j.propertys[315].value or 0
						local j_suit_id =  conf.Item:getItemSuitId(j.mId) 

						if colorlv < j_colorlv then
							flag = true
							break
						elseif colorlv == j_colorlv then
							if suit_id and not j_suit_id then
								flag = true
								break
							elseif  not suit_id and not j_suit_id then
								if power < j_power then
									flag = true
									break
								end 
							end
						end	
					end
				end 

				if not flag then
					table.insert(last_t,v)
				end
			else
				if c_r[part]["suit_id"]  then
					if suit_id then
						if c_r[part]["power"]<power then
							table.insert(last_t,v)
						end
					end
				else 
					if suit_id then
						table.insert(last_t,v)
					else
						if c_r[part]["power"]<power then
							table.insert(last_t,v)
						end
					end
				end 		
			end
		end
	end

	--
	local count = 0
	if #maxColor == 0 then
		table.insert(maxColor,1)
	end 
	for k , v in pairs(maxColor) do 
		local color_t = getRuneByColor(v)
		local _t = setRuneBy(color_t)
		count = count +  #color_t
		if #color_t >= part_get then
			break
		end
	end

	local t , t1 = self:willonPos(last_t)

	return t,t1,part_get
end
------------------科技
function FormationView:onbtnKeJiCallBack( send ,eType )
	-- body
	if eType == ccui.TouchEventType.ended then
		--
		if cache.Player:getLevel() >= 40 then
			proxy.ScienceCore:send_127001()
		else
			G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,40))
		end
	end
end



------果实合成入口
function FormationView:fruitCompose( send ,eType)

	if eType == ccui.TouchEventType.ended then

		proxy.Radio:reqMaterialInfo(1)
		--proxy.Fruit:reqFruitinfo(self.headpos,1)
		local view = mgr.ViewMgr:showView(_viewname.FRUIT_COMPOSE_PAGE)
		view:setFidx(self.SelectBattlePos)
	end
end

function FormationView:setFruitRedpoint( ... )
	--选中，显示红点
	 local num = cache.Player:getFruitRedpoint()
	-- if bit.band(num , bit.lshift(1,self.SelectBattlePos)) > 0 then
	--  	self.guiFruitCompBtn:setNumber(-1)
	--  else
	--  	self.guiFruitCompBtn:setNumber(0)
	--  end 
	--G_TipsOfstr(G_getRedPointAtIdx(num,self.SelectBattlePos))
	if G_getRedPointAtIdx(num,self.SelectBattlePos) then
		self.guiFruitCompBtn:setNumber(-1)
	else
		self.guiFruitCompBtn:setNumber(0)
	end

	local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if view then
		view:setRedPoint()
	end

end

--材料跳转返回
function FormationView:jumpBack( idx )
	--self.headpos = idx
	self:selectCallBack(0,self.headlist:getItem(idx - 1))
end


return FormationView