--[[

]]
local pet= require("game.things.PetUi") 
local TuiView=class("TuiView",base.BaseView)

function TuiView:ctor( ... )
	-- body
	self.table_left = {}
	self.table_right = {}
	self.table_reward = {{},{},{}}

	self.cost = 0

	self.olddata = {}

	self.tuihua = 1 
end

function TuiView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	--预留的哦 退化  还是还原 
	self.titleimg = self.view:getChildByName("Panel_1"):getChildByName("Image_3") 

	local panle = self.view:getChildByName("Panel_2")
	local btn_guize = panle:getChildByName("Button_14")
	btn_guize:addTouchEventListener(handler(self, self.onbtnGuize))



	--形象地低
	self.spr_di = panle:getChildByName("Image_8")
	self.spr_di1 =  panle:getChildByName("Image_51")
	self.equip = panle:getChildByName("Button_frame_1")

	--星星
	self.panlestar = panle:getChildByName("Panel_start")
	self.imgStar = panle:getChildByName("Image_32_0") 
	self.imgCard = panle:getChildByName("Image_5")

	--print(type(self.panlestar))

	local btnClose = self.view:getChildByName("Panel_1"):getChildByName("Button_close") 
	btnClose:addTouchEventListener(handler(self, self.onbtnClose))
	--名字
	local Image_4 = panle:getChildByName("Image_4")
	local lname = Image_4:getChildByName("Text_1")
	local rname = Image_4:getChildByName("Text_1_0")
	self.table_left.name = lname
	self.table_right.name = rname

	self.left_sprite7 = Image_4:getChildByName("Image_13") 
	self.left_sprite7:setVisible(false)

	self.right_sprite7 =  Image_4:getChildByName("Image_13_0")
	self.right_sprite7:setVisible(false)  
	--等级
	local Image_4_0 = panle:getChildByName("Image_4_0")
	local lv1 = Image_4_0:getChildByName("Text_1_5")
	local lv2 = Image_4_0:getChildByName("Text_1_0_7")
	self.table_left.lv = lv1
	self.table_right.lv = lv2
	--攻击
	local Image_4_0_0 = panle:getChildByName("Image_4_0_0")
	local atk1= Image_4_0_0:getChildByName("Text_1_5_9")
	local atk2= Image_4_0_0:getChildByName("Text_1_0_7_11")
	self.table_left.pro1 = atk1
	self.table_right.pro1 = atk2
	--生命
	local Image_4_0_0_0 = panle:getChildByName("Image_4_0_0_0")
	local hp1= Image_4_0_0_0:getChildByName("Text_1_5_9_13")
	local hp2= Image_4_0_0_0:getChildByName("Text_1_0_7_11_15")
	self.table_left.pro2 = hp1
	self.table_right.pro2 = hp2

	--奖励
	local reward = panle:getChildByName("Button_frame")
	local spr = reward:getChildByName("Image_22_21")
	local txt_di = panle:getChildByName("Image_27") 
	local txt = panle:getChildByName("Text_30") 
	self.table_reward[1].reward= reward
	self.table_reward[1].spr= spr
	self.table_reward[1].txt_di= txt_di
	self.table_reward[1].txt= txt


	local reward = panle:getChildByName("Button_frame_0")
	local spr = reward:getChildByName("Image_22_21_30")
	local txt_di = panle:getChildByName("Image_27_0") 
	local txt = panle:getChildByName("Text_30_0") 
	self.table_reward[2].reward= reward
	self.table_reward[2].spr= spr
	self.table_reward[2].txt_di= txt_di
	self.table_reward[2].txt= txt

	local reward = panle:getChildByName("Button_frame_0_0")
	local spr = reward:getChildByName("Image_22_21_30_6")
	local txt_di = panle:getChildByName("Image_27_0_0") 
	local txt = panle:getChildByName("Text_30_0_0") 
	self.table_reward[3].reward= reward
	self.table_reward[3].spr= spr
	self.table_reward[3].txt_di= txt_di
	self.table_reward[3].txt= txt



	--退化
	local btnTuihua = panle:getChildByName("Button_13")
	btnTuihua:addTouchEventListener(handler(self, self.onbtnTuiCall))

	local btn_tuiall = panle:getChildByName("Button_13_0")
	btn_tuiall:addTouchEventListener(handler(self, self.onbtnTuihuaAll))
	self.btn_tuiall = btn_tuiall

	--消耗目前固定
	--self.cost = btnTuihua:getChildByName("Text_32")
	self.lab_dec_cost = panle:getChildByName("Image_32"):getChildByName("Text_34")

	local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:addHeadView()
    end 

	self:initpanle()

	self:initDec()
end

function TuiView:initDec()
	-- body
	self.view:getChildByName("Panel_2"):getChildByName("Button_13"):getChildByName("Text_32_0"):setString(res.str.DUI_DEC_07)
	self.view:getChildByName("Panel_2"):getChildByName("Button_13_0"):getChildByName("Text_32_0_5"):setString(res.str.DUI_DEC_08)
end

function TuiView:initpanle()
	-- body
	self.spr_di:removeAllChildren()
	self.spr_di:setVisible(false)
	self.panlestar:setVisible(false)

	self.spr_di1:setVisible(false)
	self.equip:setVisible(false)
	self.imgStar:setVisible(false)

	self.panlestar:removeAllChildren()

	self.table_left.name:setString("")
	self.table_left.lv:setString("")

	self.table_right.name:setString("")
	self.table_right.lv:setString("")

	for k ,v in pairs (self.table_reward) do 
		v.spr:ignoreContentAdaptWithSize(true)
		v.spr:setVisible(false)
		v.txt:setVisible(false)
		v.reward:setVisible(false)
		v.txt_di:setVisible(false)
	end 
end

function TuiView:getPropertys(id)
	-- body
	return self.data.propertys[id] and self.data.propertys[id].value or 0
end

--数码兽的星星
function TuiView:addStar(num)
	-- body
	self.imgCard:setVisible(true)
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.panlestar:getContentSize().height
	local iconwidth=self.panlestar:getContentSize().width

	--local 
	local sprite=display.newSprite(starpath)
	local w = sprite:getContentSize().width*size
	local strposX = (iconwidth-w)/2 + sprite:getContentSize().width/2

	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setScale(0.8)
		sprite:setPosition(strposX+sprite:getContentSize().width*(i-1),iconheight/2)
		self.panlestar:addChild(sprite)
	end
end

--装备的星星
function TuiView:addStarImg( num )
	-- body
	self.imgCard:setVisible(false)
	local starpath=res.image.STAR
	local size=num
	

	local sprite=display.newSprite(starpath)
	local w = sprite:getContentSize().width*size

	self.imgStar:setContentSize(cc.size(w,self.imgStar:getContentSize().height))

	local iconheight=self.imgStar:getContentSize().height
	local iconwidth=self.imgStar:getContentSize().width
	local strposX = (iconwidth-w)/2 + sprite:getContentSize().width/2

	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setScale(0.8)
		sprite:setPosition(strposX+sprite:getContentSize().width*(i-1),iconheight/2)
		self.imgStar:addChild(sprite)
	end
end

function TuiView:left( )
	-- body
	self.left_sprite7:setVisible(false)
	local name = conf.Item:getName(self.data.mId,self.data.propertys)
	local colorlv = conf.Item:getItemQuality(self.data.mId)

	local t ={}
	local type = conf.Item:getType(self.data.mId)
	if type == pack_type.EQUIPMENT then
		t = G_getEquipPro(self.data)
	else
		t = G_getCardPro(self.data)

		local conf_data = conf.Item:getItemConf(self.data.mId)
		if  checkint(conf_data.old_id) > 0 then
			self.left_sprite7:loadTexture(res.icon.ZHUAN[conf_data.zhuan])
			self.left_sprite7:setVisible(true)
		end
	end 

	self.table_left.name:setColor(COLOR[colorlv])
	self.table_left.name:setString(name)

	for i = 1 , 2 do 
		self.table_left["pro"..i]:getParent():setVisible(false)
	end
	local bl = 0
	local function _insetPro(lab,v)
	-- body
		if v and v >0 then 
			bl = bl +1 
			local str = string.format(lab,v)
			self.table_left["pro"..bl]:getParent():setVisible(true)
			self.table_left["pro"..bl]:setString(str)
		end
	end
	_insetPro(res.str.TUIHUA_GONGJI,t.base_atk)
	_insetPro(res.str.TUIHUA_SHENGMING,t.base_hp)
end

function TuiView:Card()
	-- body
	

	local att = self:getPropertys(102)
	local hp = self:getPropertys(105)

	local jie = self:getPropertys(307)
	local jiehua = self:getPropertys(310)
	local lv = self:getPropertys(304)
	local colorlv = conf.Item:getItemQuality(self.data.mId)
	local name =""

	local conf_data = conf.Item:getItemConf(self.data.mId)
	self.conf_data = conf_data
	--print("self.conf_data = ",self.conf_data.old_id)

	local t ={}
	if jiehua > 0 then --如果进化>0
		self.lab_dec_cost:setString(res.str.TUIHUA_DEC2)

		local data = clone(self.data)
		data.propertys[310].value = data.propertys[310].value -1 
		name = conf.Item:getName(self.data.mId,data.propertys)

		t = G_getCardPro(data)

		local path = conf.Item:getItemSrcbymid(data.mId)
		local framePath=res.btn.FRAME[colorlv]
		local _name = conf.Item:getName(self.data.mId)
		local v =self.table_reward[1]

		self.right_sprite7:setVisible(false)
		if checkint(conf_data.old_id)>0 then
			path = conf.Item:getItemSrcbymid(conf_data.old_id)
			framePath=res.btn.FRAME[conf.Item:getItemQuality(conf_data.old_id)]
			_name = conf.Item:getName(conf_data.old_id)

			self.right_sprite7:loadTexture(res.icon.ZHUAN[conf_data.zhuan])
			self.right_sprite7:setVisible(true)
		end

		
		v.spr:loadTexture(path)
		
		v.reward:loadTextureNormal(framePath)
		v.txt:setString(_name)
		v.txt:setColor(COLOR[colorlv])


		v.spr:setVisible(true)
		v.txt:setVisible(true)
		v.reward:setVisible(true)
		v.txt_di:setVisible(true)

		local prvid = conf.Item:getItemJHPre(self.data.mId) + jiehua-1 --colorlv*1000 + jiehua-1
		local cost = conf.CardJinghua:getcost(prvid)

		local v =self.table_reward[2]
		local path = conf.Item:getItemSrcbymid(221051001)
		v.spr:loadTexture(path)
		local clv = conf.Item:getItemQuality(221051001)
		local framePath=res.btn.FRAME[clv]
		v.reward:loadTextureNormal(framePath)
		v.txt:setString(cost)
		v.spr:setVisible(true)
		v.txt:setVisible(true)
		v.reward:setVisible(true)
		v.txt_di:setVisible(true)

		self.cost = cost

	elseif jie > 0 then
		self.right_sprite7:setVisible(false)
		if checkint(conf_data.old_id)>0 then
			self.right_sprite7:setVisible(true)
		end

		self.add = true
		self.lab_dec_cost:setString(res.str.TUIHUA_DEC4)
		self.cost = 0 
		local data = clone(self.data)
		data.propertys[310] = {}
		data.propertys[310].value = 10 
		data.propertys[307].value = data.propertys[307].value-1
		t = G_getCardPro(data)
		name = conf.Item:getName(data.mId,data.propertys)

		local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
		local v =self.table_reward[1]
		v.spr:loadTexture(path)

		local framePath=res.btn.FRAME[colorlv]
		v.reward:loadTextureNormal(framePath)

		v.txt:setString(conf.Item:getName(self.data.mId))
		v.txt:setColor(COLOR[colorlv])

		v.spr:setVisible(true)
		v.txt:setVisible(true)
		v.reward:setVisible(true)
		v.txt_di:setVisible(true)

		local jie = data.propertys[307] and data.propertys[307].value or 0 
		local colorlv = conf.Item:getItemQuality(data.mId)
		local lv = conf.Item:getItemJJClPre(self.data.mId)+jie --colorlv*1000+jie
		local needtab = conf.CardTopo:getUseitem(lv) 

		for k ,v in pairs(needtab) do 
			local widget = self.table_reward[k]

			local path = conf.Item:getItemSrcbymid(v[1])
			widget.spr:loadTexture(path)

			local color = conf.Item:getItemQuality(v[1])
			local framePath=res.btn.FRAME[color]
			widget.reward:loadTextureNormal(framePath)

			widget.txt:setString(conf.Item:getName(v[1]).."x"..v[2])
			widget.txt:setColor(COLOR[color])


			widget.spr:setVisible(true)
			widget.txt:setVisible(true)
			widget.reward:setVisible(true)
			widget.txt_di:setVisible(true)
		end 
	elseif checkint(conf_data.old_id)>0 then 
		self.s7 = true
		local data = clone(self.data)
		data.mId = conf_data.old_id
		
		data.propertys[307] = {}
		data.propertys[307].value = 3
		data.propertys[310] = {}
		data.propertys[310].value = 10
		t = G_getCardPro(data)

		self.right_sprite7:setVisible(false)
		local __conf_data = conf.Item:getItemConf(data.mId)
		if checkint(__conf_data.old_id)>0 then
			self.right_sprite7:setVisible(true)
		end

		self.willget = data

		self.add = true

		name = conf.Item:getName(data.mId,data.propertys)
		local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
		colorlv = conf.Item:getItemQuality(data.mId)

		local v =self.table_reward[1]
		--local path = conf.Item:getItemSrcbymid(221051001)
		v.spr:loadTexture(path)
		local clv = colorlv
		local framePath=res.btn.FRAME[clv]
		v.reward:loadTextureNormal(framePath)
		v.txt:setString(name)
		--[[v.spr:setVisible(true)
		v.txt:setVisible(true)
		v.reward:setVisible(true)
		v.txt_di:setVisible(true)]]--

	elseif lv > 1 then 
		self.right_sprite7:setVisible(false)
		if checkint(conf_data.old_id)>0 then
			self.right_sprite7:setVisible(true)
		end

		self.lab_dec_cost:setString(res.str.TUIHUA_DEC5)
		local jb_cost = 0
		local s_exp =  mgr.ConfMgr.getExp(self.data.propertys) --服务器经验
		local currenexp = conf.CardExp:getExp(conf.Item:getItemSjPre(self.data.mId),lv)
		local exp1 = conf.CardExp:getExp(conf.Item:getItemSjPre(self.data.mId),1)
		jb_cost = currenexp - exp1 + s_exp
		--debugprint("s_exp = "..s_exp)

		--self.cost = 0
		local data = clone(self.data)
		data.propertys[304] = {}
		data.propertys[304].value = 1
		t = G_getCardPro(data)

		lv = 1
		name = conf.Item:getName(data.mId,data.propertys)
		local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)

		self.add = true
		if jb_cost > 0 then 
			local v =self.table_reward[1]
			local path = conf.Item:getItemSrcbymid(221051001)
			v.spr:loadTexture(path)
			local clv = conf.Item:getItemQuality(221051001)
			local framePath=res.btn.FRAME[clv]
			v.reward:loadTextureNormal(framePath)
			v.txt:setString(jb_cost)
			v.spr:setVisible(true)
			v.txt:setVisible(true)
			v.reward:setVisible(true)
			v.txt_di:setVisible(true)
		end 

		self.cost = jb_cost
	end 

	self.table_right.name:setColor(COLOR[colorlv])
	self.table_right.name:setString(name)

	self.right_sprite7:setPositionX(self.table_right.name:getContentSize().width
		+self.table_right.name:getPositionX()+5)
	

	self.table_right.lv:setString(string.format(res.str.TUIHUA_DENGJI,lv))

	local bl = 0
	local function _insetPro(lab,v)
	-- body
		if v and v >0 then 
			bl = bl +1 
			local str = string.format(lab,v)
			self.table_right["pro"..bl]:setString(str)
		end
	end
	_insetPro(res.str.TUIHUA_GONGJI,t.base_atk)
	_insetPro(res.str.TUIHUA_SHENGMING,t.base_hp)

	if self.s7 then
		self.btn_tuiall:setVisible(false)
	else
		self.btn_tuiall:setVisible(true)
	end
end


function TuiView:Equip( data )
	-- body
	
	self.cost = 0
	local att = self:getPropertys(102)
	local hp = self:getPropertys(105)

	local jiehua = self:getPropertys(311)
	local lv = self:getPropertys(303)
	local colorlv = conf.Item:getItemQuality(self.data.mId)
	local part = conf.Item:getItemPart(self.data.mId)
	local name = conf.Item:getName(self.data.mId,self.data.propertys)

	local t = {}
	if jiehua >0 then
		self.lab_dec_cost:setString(res.str.TUIHUA_DEC3)
		--todo
		local data1 =  clone(data)
		data1.propertys[311].value = self:getPropertys(311)-1
		t = G_getEquipPro(data1)
		name =  conf.Item:getName(self.data.mId,data1.propertys)

		local EquipmentJhID = conf.Item:getEquipmentJLId(data1.mId,data1.propertys[311].value)
		local jb_cost = conf.EquipmentJh:getJb(EquipmentJhID)

		local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
		local v =self.table_reward[1]
		v.spr:loadTexture(path)
		local framePath=res.btn.FRAME[colorlv]
		v.reward:loadTextureNormal(framePath)
		v.txt:setString(conf.Item:getName(self.data.mId))
		v.txt:setColor(COLOR[colorlv])
		v.spr:setVisible(true)
		v.txt:setVisible(true)
		v.reward:setVisible(true)
		v.txt_di:setVisible(true)
		if jb_cost > 0 then 
			local v =self.table_reward[2]
			local path = conf.Item:getItemSrcbymid(221051001)
			v.spr:loadTexture(path)
			local clv = conf.Item:getItemQuality(221051001)
			local framePath=res.btn.FRAME[clv]
			v.reward:loadTextureNormal(framePath)
			v.txt:setString(jb_cost)
			v.spr:setVisible(true)
			v.txt:setVisible(true)
			v.reward:setVisible(true)
			v.txt_di:setVisible(true)
		end 
		self.cost = jb_cost
	elseif lv > 0 then 
		self.lab_dec_cost:setString(res.str.TUIHUA_DEC1)
		local data1 =  clone(data)
		data1.propertys[303].value = 0
		t = G_getEquipPro(data1)
		lv = 0

		self.add = true
		--[[local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
		local v =self.table_reward[1]
		v.spr:loadTexture(path)
		local framePath=res.btn.FRAME[colorlv]
		v.reward:loadTextureNormal(framePath)
		v.txt:setString(name)
		v.txt:setColor(COLOR[colorlv])
		v.spr:setVisible(true)
		v.txt:setVisible(true)
		v.reward:setVisible(true)
		v.txt_di:setVisible(true)]]--

		local cachedata 
		if self.data.index > 400000 then 
			cachedata = cache.Equipment:isKey(self.data.index)
		else
			cachedata= cache.Pack:getTypePackInfo(1)[self.data.index]
		end 
		local jb_cost =  cachedata.propertys[313] and  cachedata.propertys[313].value or 0
		if jb_cost > 0 then 
			local v =self.table_reward[1]
			local path = conf.Item:getItemSrcbymid(221051001)
			v.spr:loadTexture(path)
			local clv = conf.Item:getItemQuality(221051001)
			local framePath=res.btn.FRAME[clv]
			v.reward:loadTextureNormal(framePath)
			v.txt:setString(jb_cost)
			v.spr:setVisible(true)
			v.txt:setVisible(true)
			v.reward:setVisible(true)
			v.txt_di:setVisible(true)		
		end 
		--end 
	end 
	self.table_right.name:setColor(COLOR[colorlv])
	self.table_right.name:setString(name)
	self.table_right.lv:setString(string.format(res.str.TUIHUA_QIANGHUA,lv))

	local bl = 0
	local function _insetPro(lab,v)
	-- body
		if v and v >0 then 
			bl = bl +1 
			local str = string.format(lab,v)
			self.table_right["pro"..bl]:setString(str)
		end
	end
	_insetPro(res.str.TUIHUA_GONGJI,t.base_atk)
	_insetPro(res.str.TUIHUA_SHENGMING,t.base_hp)

end

function TuiView:fillData(data)
	-- body
	self:initpanle()
	local type = conf.Item:getType(data.mId)
	local colorlv = conf.Item:getItemQuality(data.mId)
	self:left()
	if type == pack_type.SPRITE then 
		local lv = self:getPropertys(304)
		self.table_left.lv:setString(string.format(res.str.TUIHUA_DENGJI,lv))
		local node=pet.new(data.mId,data.propertys)
		node:setScale(G_GardChange(data))
		node:setPosition(self.spr_di:getContentSize().width/2,
		self.spr_di:getContentSize().height/2+node:getContentSize().height*node:getScale()/2)
		node:addTo(self.spr_di)
		self.spr_di:setVisible(true)
		self.panlestar:setVisible(true)

		self:addStar(colorlv)
		self:Card(data)
	else
		local lv = self:getPropertys(303)
		self.table_left.lv:setString(string.format(res.str.TUIHUA_QIANGHUA,lv))
		local path = conf.Item:getItemSrcbymid(data.mId, data.propertys)
		self.spr_di1:setVisible(true)
		self.equip:setVisible(true)
		self.imgStar:setVisible(true)
		self.equip:getChildByName("Image_22_21_53"):loadTexture(path)
		self.equip:getChildByName("Image_22_21_53"):ignoreContentAdaptWithSize(true)
		local framePath=res.btn.FRAME[colorlv]
		self.equip:loadTextureNormal(framePath)
		jie = self:getPropertys(311)
		lv = self:getPropertys(303)
		self:addStarImg(colorlv)
		self:Equip(data)
	end 
end

function TuiView:setData(data_)
	-- body
	self.willget = nil 
	self.add = false
	self.s7 =false
	self.data = data_
	self:fillData(self.data)

	self.olddata = clone(data_)
end

function TuiView:onSeverCallBack( data_ )
	-- body
	--退化
	local type = conf.Item:getType(self.data.mId)
	local t = {}
	local data 

	local function addToby( mid,count )
		-- body
		local findkey = 0
		for key , value in pairs(t) do 
			if value.mId == mid then 
				findkey = key 
				break
			end
		end 

		if findkey > 0 then 
			t[findkey].amount = t[findkey].amount+count
		else
			local tt = {mId = mid , amount = count,propertys = {}}
			table.insert(t,tt)
		end 
	end
	if not self.willget then --如果是7s卡变成之前的卡
		if self.tuihua ~= 1 then 
			if type == pack_type.SPRITE then 
				--退化后
				data = cache.Pack:getTypePackInfo(type)[data_.index]
				local colorlv = conf.Item:getItemQuality(data.mId)
				--jie
				local function compare307()
					-- body
					local a = self.data.propertys[307] and self.data .propertys[307].value or 0 
					local b = data.propertys[307] and data.propertys[307].value or 0 

					--计算需要的消耗 --阶
					if a~=b then
						for i = b , a-1 do 
							--addToby(self.data.mId,1)
							local lv = conf.Item:getItemJJClPre(self.data.mId)+i --colorlv*1000+i
							local needtab = conf.CardTopo:getUseitem(lv) 
							if needtab then 
								for k ,v in pairs(needtab) do 
									addToby(v[1],v[2])						
								end 
							end 
						end 
					end 
				end
				--进化
				local function compare310()
					-- body
					local a307 = self.data.propertys[307] and self.data .propertys[307].value or 0 
					local b307 = data.propertys[307] and data.propertys[307].value or 0 

					local a310 = self.data.propertys[310] and self.data .propertys[310].value or 0 
					local b310 = data.propertys[310] and data.propertys[310].value or 0 

					if a307 == b307 then 
						for i = b310, a310-1 do 
							local id = conf.Item:getItemJHPre(self.data.mId)+i --colorlv*1000 + i

							local c = conf.CardJinghua:getcost(id)
							
							addToby(221051001,c)
							if checkint(self.conf_data.old_id) > 0 then
								addToby(self.conf_data.old_id,1)
							else
								addToby(self.data.mId,1)
							end
								
						end 
					else
						for i = b307 , a307 do 
							if i < a307 then 
								for j = 0 , 9 do 
									local id = conf.Item:getItemJHPre(self.data.mId)+j-- colorlv*1000 + j
									local c = conf.CardJinghua:getcost(id)
									addToby(221051001,c)
									if checkint(self.conf_data.old_id) > 0 then
										addToby(self.conf_data.old_id,1)
									else
										addToby(self.data.mId,1)
									end
								end 
							else
								for j = 0 , a310-1 do 
									local id = conf.Item:getItemJHPre(self.data.mId)+j -- colorlv*1000 + j
									local c = conf.CardJinghua:getcost(id)
									addToby(221051001,c)
									if checkint(self.conf_data.old_id) > 0 then
										addToby(self.conf_data.old_id,1)
									else
										addToby(self.data.mId,1)
									end
								end
							end 
						end 
					 	--
					end 
				end
				--等级
				local function compare304()
					-- body
					local a304 = self.data.propertys[304] and self.data .propertys[304].value or 0 
					local b304 = data.propertys[304] and data.propertys[304].value or 0 

					if a304~=b304 then 
						local s_exp =  mgr.ConfMgr.getExp(self.data.propertys) --服务器经验
						local currenexp = conf.CardExp:getExp(conf.Item:getItemSjPre(self.data.mId),a304)
						local exp1 = conf.CardExp:getExp(conf.Item:getItemSjPre(self.data.mId),1)
						jb_cost = currenexp - exp1 + s_exp
						addToby(221051001,jb_cost)
					end
				end
				compare307()
				compare310()
				if checkint(self.conf_data.old_id) > 0 then
				else
					compare304()
				end
				
			else
				if self.data.index > 400000 then 
					data = cache.Equipment:isKey(data_.index)
				else
					data= cache.Pack:getTypePackInfo(1)[data_.index]
				end 
				local cost = data_.moneyJb 
				local a311 = self.data.propertys[311] and self.data .propertys[311].value or 0 
				local b311 = data.propertys[311] and data.propertys[311].value or 0 

				if a311 == b311 then 
					addToby(221051001,data_.moneyJb)
				else
					addToby(221051001,data_.moneyJb)
					for i = b311 , a311-1  do 
						addToby(self.data.mId,1)
					end 
				end
			end 
		else
			if type == pack_type.SPRITE then 
				
				data = cache.Pack:getTypePackInfo(type)[data_.index]
				local jinghua = data.propertys[310] and data.propertys[310].value or 0
				if jinghua == 10 then 
					local jie = data.propertys[307] and data.propertys[307].value or 0 
					local colorlv = conf.Item:getItemQuality(data.mId)
					local lv = conf.Item:getItemJJClPre(self.data.mId)+jie
					local needtab = conf.CardTopo:getUseitem(lv) 
					if needtab then 
						for k ,v in pairs(needtab) do 
							local tt = {mId = v[1] , amount = v[2],propertys = {}}
							table.insert(t,tt)
						end 
					end 
				end 
				if not self.add then 
					local s = clone(data)

					if checkint(self.conf_data.old_id) > 0 then
						s.mId = self.conf_data.old_id
					end

					s.propertys = {}
					table.insert(t,s)
				end 

				

				if self.cost >0 then 
					local tt = {mId = 221051001 , amount = self.cost,propertys = {}}
					table.insert(t,tt)
				end 
			else
				
				if self.data.index > 400000 then 
					data = cache.Equipment:isKey(data_.index)
					--cachedata.propertys = vector2table(cachedata.propertys) 
				else
					data= cache.Pack:getTypePackInfo(1)[data_.index]
				end 
				if not self.add then 
					local s = clone(data)
					s.propertys = {}
					table.insert(t,s)
				end 
				local cost = data_.moneyJb 
				if cost >0 then 
					local tt = {mId = 221051001 , amount = cost,propertys = {}}
					table.insert(t,tt)
				end 
			end 
		end
	else
		data = cache.Pack:getTypePackInfo(type)[data_.index]
		--local tt = {mId = self.willget.mId,amount = 1 ,propertys = self.willget.propertys   }
		--table.insert(t,tt)
	end
	

	--弹出获得界面
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	if not view and #t > 0 then

		view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(t,false,true,true)
		view:setButtonVisible(false)
	end

	if data then 
		--print("data 待定")
		self.olddata = {}
		self:setData(data)
	end
end

--规则界面
function TuiView:onbtnGuize(sender,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("规则界面")
		--装备退化
		local type = conf.Item:getType(self.data.mId)
		if type == pack_type.SPRITE then
			mgr.ViewMgr:showView(_viewname.GUIZE):showByName(6)
		else 
			--todo
			mgr.ViewMgr:showView(_viewname.GUIZE):showByName(7)
		end 
	end 
end

function TuiView:check( type )
	-- body
	if type == pack_type.SPRITE then 
		local jie = self:getPropertys(307)
		local jiehua = self:getPropertys(310)
		local lv = self:getPropertys(304)

		--print(lv)
		if lv <2 and jiehua <1 and jie <1 and not self.s7 then 
			return false
		end 
	else
		local jiehua = self:getPropertys(311)
		local lv = self:getPropertys(303)
		if lv <1 and jiehua <1  then 
			return false
		end
	end 

	return true
end

function TuiView:TuihuaAll(cost)
	-- body
	local type = conf.Item:getType(self.data.mId)
	local str = res.str.TUIHUA_DEC6.."\n"..res.str.TUIHUA_DEC8
	if type ~= pack_type.SPRITE then
		str = res.str.TUIHUA_DEC7.."\n"..res.str.TUIHUA_DEC8
	end 
	local data = {}
	data.richtext = {
		{title=true},
		{text=res.str.GUILD_DEC24,fontSize=24,color=cc.c3b(255,255,255)},
		{img=res.image.ZS},
		{text=tostring(cost),fontSize=24,color=cc.c3b(255,255,255)},
		{text=str,fontSize=24,color=cc.c3b(255,255,255)},
		
	}
	data.sure =function( ... )
		-- body
		self.amount = cost
		if type == pack_type.SPRITE then
			proxy.card:resTuihua(self.data.index,1)
		else
			proxy.Equipment:reqTuihua(self.data.index,1)
		end		
	end
	data.cancel = function( ... )
		-- body
	end
	data.surestr =  res.str.SURE
	mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)
end

function  TuiView:onbtnTuihuaAll( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self.tuihua = 10

		local type = conf.Item:getType(self.data.mId)
		local cost = 0 
		if type == pack_type.SPRITE then 
			local jie = self:getPropertys(307)
			local jiehua = self:getPropertys(310)
			local lv = self:getPropertys(304)
			cost = jie*10+jie + jiehua 
			if checkint(self.conf_data.old_id) > 0 then
			else
				if lv > 1 then
					cost = cost + 1
				end
			end

			if self:check(type) then 
				if not G_BuyAnything(2,cost) then 
					return 
				end 
				self:TuihuaAll(cost)
			else
				G_TipsOfstr(res.str.TUIHUA_CARD)
			end 
		else
			local jiehua = self:getPropertys(311)
			local lv = self:getPropertys(303)

			cost =  jiehua  
			if lv > 0 then 
				cost = cost +1 
			end

			if self:check(type) then
				if not G_BuyAnything(2,cost) then 
					return 
				end  
				self:TuihuaAll(cost)
			else
				G_TipsOfstr(res.str.TUIHUA_EQUIP)
			end 
		end 
	end 
end


--退化按钮按一下
function TuiView:onbtnTuiCall(sender,eventtype)
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("退化按钮按一下")
		self.tuihua = 1 
		local type = conf.Item:getType(self.data.mId)
		if type == pack_type.SPRITE then
			if self:check(type) then 
				if not G_BuyAnything(2,1) then 
					return 
				end 
				self.amount = 1
				proxy.card:resTuihua(self.data.index)
			else
				G_TipsOfstr(res.str.TUIHUA_CARD)
			end 
		else
			if self:check(type) then
				if not G_BuyAnything(2,1) then 
					return 
				end  
				self.amount = 1
				proxy.Equipment:reqTuihua(self.data.index)
			else
				G_TipsOfstr(res.str.TUIHUA_EQUIP)
			end 
		end 
	end 
end 

function TuiView:onbtnClose( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:closeSelfView()

		local view = mgr.ViewMgr:get(_viewname.PACK)
		local view2 = mgr.ViewMgr:get(_viewname.PROMOTE_LV)
		local view3 = mgr.ViewMgr:get(_viewname.EQUIPMENT_QH)
		if view and (not view2 and not view3 ) then 
			local scene =  mgr.SceneMgr:getMainScene()
		    if scene then 
		        scene:closeHeadView()
		    end 
		end 
	end 
end


return TuiView
