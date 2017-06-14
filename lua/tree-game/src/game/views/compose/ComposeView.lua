local ComposeView  = class("ComposeView",base.BaseView)

function ComposeView:ctor( ... )
	-- body 
	--所有卡牌
	self._AllQualityDataOFCard = { } 
	self._diffQualityDataCard = {}
	self.AutoCard = {} 
	--所有装备
	self._AllQualityDataOFEquip = { } 
	self._diffQualityDataEquip = {}
	self.AutoEquip = {}
	--已经选择的列表
	self.SelectList = {}
	--剩余空位子
	self.CanUseGZ = {
		true,
		true,
		true,
		true,
		true,
	}
	-- 自动添加被按下几次
	self.countEquip  = 0
	self.countCard  = 0

	-- 选择类型
	self.calltype = nil 
	self.colorlv = nil 
end

function ComposeView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	--为了加底层特效 --一直放的
	self.Panel_1 = self.view:getChildByName("Panel_1")
	--等比例缩放值
	self.scale = G_FitScreen(self,"Image_1")
	--规则
	local btnGui =  self.view:getChildByName("btn_guize_12")
	btnGui:addTouchEventListener(handler(self,self.onBtnGuize))

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	local panle = self.view:getChildByName("Panel_3")
	local btn = panle:getChildByName("Button_26")
	btn:setTitleText(res.str.DEC_ERR_23)
	self.PageButton:addButton(btn)
	local btn1 = panle:getChildByName("Button_26_0")
	btn1:setTitleText(res.str.DEC_ERR_24)
	self.PageButton:addButton(btn1)

	--幸运合成
	--[[self._bg_luck_di = self.view:getChildByName("bg_luck_copme")
	self._t_time = self._bg_luck_di:getChildByName("Txt_times")
	--这个暂时没有
	self._bg_luck_di:setVisible(false)]]--

	--自动放精灵
	local btnCard =  self.view:getChildByName("btn_card")
	--btnCard:addTouchEventListener(handler(self,self.onBtnCardcallBack))

	--self.btnCard = btnCard

	self.btnCard = gui.GUIButton.new(btnCard,handler(self,self.onBtnCardcallBack)
	,{ImagePath=res.image.RED_PONT,x=2,y=3})

	--自动放装备 
	local btnEquip =  self.view:getChildByName("btn_equip")
	--btnEquip:addTouchEventListener(handler(self,self.onBtnEquipCallback))

	self.btnEquip = gui.GUIButton.new(btnEquip,handler(self,self.onBtnEquipCallback)
	,{ImagePath=res.image.RED_PONT,x=2,y=3})

	--合成材料
	self.listbtn = {}
	local size = 5 
	for i = 1 , size do  
		local colorKuang = self.view:getChildByName("img_color"..i)
		colorKuang:setScale(self.scale) 
		local spr  = colorKuang:getChildByName("Img_choose"..i)
		self.listbtn[i] ={}
		self.listbtn[i].colorKuang = colorKuang
		self.listbtn[i].spr = spr
		self.listbtn[i].imgdi = colorKuang:getChildByName("Img_"..i)
		self.listbtn[i].lab = self.listbtn[i].imgdi:getChildByName("Text_1_"..i)
	end	

	--消耗
	self.Image_zb_bg =  self.view:getChildByName("Image_zb_bg")

	self.cost = self.view:getChildByName("Image_zb_bg"):getChildByName("Text_name_2")
	self.cost:setString("")

	self.jbIcon = self.view:getChildByName("Image_zb_bg"):getChildByName("Image_4")
	self.jbIcon:ignoreContentAdaptWithSize(true)
	self.jbIcon:setVisible(false)

	self.old_cost = self.cost:getPositionX()
	self.oldx_jb = self.jbIcon:getPositionX()
	--合成后
	self.colorKuang = self.view:getChildByName("img_color1_1_0")
	self.colorKuang:addTouchEventListener(handler(self,self.onBtnComposeaftCallback))
	self.spr = self.colorKuang:getChildByName("Img_choose1_32_41")
	self.colorKuang:setScale(self.scale) 

	--合成按钮
	local btnCompose =  self.view:getChildByName("btn_compose")
	btnCompose:addTouchEventListener(handler(self,self.onBtnComposeCallback))
	self.btnCompose = btnCompose
	self.btnCompose:ignoreContentAdaptWithSize(true)

	self.title = self.view:getChildByName("Image_2")
	self.title:ignoreContentAdaptWithSize(true) 

	self.lab_xing =self.view:getChildByName("Text_1")
	self.lab_xing:setString(res.str.DEC_ERR_84)
	----星将 ， 或者 合成 转换
	--self.btnchange = self.view:getChildByName("btn_guize_12_0")
	--self.btnchange:addTouchEventListener(handler(self,self.onchangeCallBack))

	self:clearListbtn()
	self:clearMiddlespr()
	self:setData()

	btnEquip:setTitleText(res.str.COMPOSE_DEC14)
	btnCard:setTitleText(res.str.COMPOSE_DEC18)

	self.PageButton:initClick(1)

	self:performWithDelay(function()
			self:onlyOnce()
	end, 0.1)
end

function ComposeView:onlyOnce()
	local params =  {id=404805, x=self.Panel_1:getContentSize().width/2,
										y=self.Panel_1:getContentSize().height/2,addTo=self.Panel_1,
										loadComplete = function(var)
												var:setScale(self.scale)
										end, playIndex=0,addName = "effofname"}
	mgr.effect:playEffect(params)
end

function ComposeView:pagebtninit( index )
	-- body
	self.PageButton:initClick(index)
end

function ComposeView:onPageButtonCallBack(index,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.pageindex = index
		--[[if index == 2 then  ---处理一下 降星未上传 只提示
			G_TipsOfstr(res.str.DEC_ERR_25)
			self.PageButton:initClick(1)
			local btn = self.PageButton.ListButton[1]
			self.PageButton:setButtonState(btn,true)
			return 
		end]]
		if index == 1 then 
			self:setData()
		else
			self:setData(true)
		end
		return self
	end
end

--把各个选择材料的框复原
function ComposeView:clearListbtn()
	-- body
	local colorFrame = res.btn.FRAME[1]
	local sprFrame = res.other.PLUS 
	for i = 1 , #self.listbtn do 
		local v = self.listbtn[i]
		v.colorKuang:loadTexture(colorFrame)
		v.spr:loadTexture(sprFrame)
		v.spr:setTag(i) -- 哪个格子
		v.spr:setTouchEnabled(true)
		v.spr:addTouchEventListener(handler(self,self.onBtnChooseCallback))
		v.imgdi:setVisible(false)
	end	

	self.CanUseGZ = {
		true,
		true,
		true,
		true,
		true,
	}

	self.calltype = nil
	self.colorlv = nil 
end
--把合成的中间材料复原
function ComposeView:clearMiddlespr(  )
	-- body
	local colorFrame = res.btn.FRAME[1]
	self.colorKuang:loadTexture(colorFrame)
	self.colorKuang:setTouchEnabled(false)
	local sprFrame = res.other.WENHAO 
	self.spr:loadTexture(sprFrame)
end
--将星返回
function ComposeView:lowCallBack(data)
	-- body
	self:setData(true)
	--弹出获得界面
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	if not view then
		view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(data,false,true,true)
		view:setButtonVisible(false)
	end
end

function ComposeView:setMiddlespr(data)
	-- body
	self.usedata = data
	--self.cost:setAnchorPoint(cc.p(0,0.5))
	if not self.usedata then 
		return 
	end

	if self.lab then
		self.lab:removeSelf()
		self.lab = nil 
	end

	local colorlv = conf.Item:getItemQuality(data.mId)
	local colorFrame = res.btn.FRAME[colorlv]
	self.colorKuang:loadTexture(colorFrame)
	--self.colorKuang:setTouchEnabled(false)
	local sprFrame =conf.Item:getItemSrcbymid(data.mId)
	self.spr:loadTexture(sprFrame)

	local t = {}
	local use = 0
	if conf.Item:getType(data.mId) == pack_type.SPRITE  then
		t = { [6] = 221023003,[7] = 221023004 }
		use = conf.Compose:getItemUse( 3 * 1000 + colorlv )
	else
		t = { [6] = 221023010,[7] = 221023011 }
		use = conf.Compose:getItemUse( 1 * 1000 + colorlv )
	end

	for k ,v in pairs(self.listbtn) do 
		--print("colorlv = "..colorlv)
		local mId = t[colorlv]
		local lv  = conf.Item:getItemQuality(mId)
		local sprframe  =  conf.Item:getItemSrcbymid(mId)
		v.colorKuang:loadTexture(res.btn.FRAME[lv])
		v.spr:loadTexture(sprframe)
		v.spr:setTag(mId) -- 哪个格子
		v.lab:setString(conf.Item:getName(mId))
		v.lab:setColor(COLOR[lv])
		v.imgdi:setVisible(true)
	end
	self.use = use
	self.jbIcon:loadTexture(res.image.ZS)
	self.jbIcon:setVisible(true)
	self.cost:setString(use)

	self.jbIcon:setPositionX(self.oldx_jb + 20)
	self.cost:setPositionX(self.old_cost + 20 )
end

--红点设置
function ComposeView:setRedPoint( ... )
	-- body
	if #self.AutoCard>0 then 
		self.btnCard:setNumber(-1)
	else
		self.btnCard:setNumber(0)
	end 

	if #self.AutoEquip>0 then 
		self.btnEquip:setNumber(-1)
	else
		self.btnEquip:setNumber(0)
	end 
end
--合成需要数据
function ComposeView:initDataCompose()
	-- body
	--[[for k , v in pairs(self.listbtn) do 
		v.colorKuang:loadTexture(res.btn.FRAME[1])
		v.colorKuang:addTouchEventListener(handler(self,self.onBtnComposeaftCallback))
		v.spr:loadTexture(res.other.PLUS)
	end]]--
	--5按钮
	if self.lab then
		self.lab:removeSelf()
		self.lab = nil 
	end

	self.jbIcon:setVisible(false)
	self.jbIcon:loadTexture(res.image.GOLD)
	self.cost:setString("")

	self.lab_xing:setVisible(false)
	--self.cost:setAnchorPoint(cc.p(0,0.5))

	self.jbIcon:setPositionX(self.oldx_jb)
	self.cost:setPositionX(self.old_cost)

	self:clearListbtn() 
	--中间
	self.colorKuang:loadTexture(res.btn.FRAME[1])
	self.spr:setTag(-1)
	self.spr:loadTexture(res.other.WENHAO)
	self.colorKuang:addTouchEventListener(handler(self,self.onBtnComposeaftCallback))

	self.btnCompose:loadTextureNormal(res.btn.COMPOSE_HE)
	self.title:loadTexture(res.font.COMPOSE_HE)

	local dataCard = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	if dataCard then 
		for k ,v in pairs(dataCard) do

			if conf.Item:getBattleProperty(v) < 1 then --出站排除
				if v.propertys[317] and v.propertys[317].value > 0 then
				else 
					local name=conf.Item:getName(v.mId,v.propertys)
					local qq =  conf.Item:getItemQuality(v.mId)
					--print("name = "..name.." qq "..qq)
					if qq < 7  then --最高星级排除
						table.insert(self._AllQualityDataOFCard,v)
						if not self._diffQualityDataCard[qq] then 
							self._diffQualityDataCard[qq] = {}
						end
						table.insert(self._diffQualityDataCard[qq],v)
					end	
				end
			end		
		end
	end	

	local dataEquip = cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)

	if dataEquip then 
		for k ,v in pairs(dataEquip) do
			--待定
			--print("propertys = "..self:getPropByid(v,311))
			--if conf.Item:getBattleProperty(v) < 1 then --穿戴排除
					local qq = conf.Item:getItemQuality(v.mId)
					if qq < 7  then --最高星级排除
						table.insert(self._AllQualityDataOFEquip,v)
						if not self._diffQualityDataEquip[qq] then 
							self._diffQualityDataEquip[qq] = {}
						end
						table.insert(self._diffQualityDataEquip[qq],v)
					end	
			--end	
		end
	end	

	self.AutoCard = self:search(1)
	self.AutoEquip = self:search()
end
--降星需要
function ComposeView:initDataStar()
	-- body
	self.usedata = {}
	self.jbIcon:setVisible(false)
	self.cost:setString("")
	--self.cost:setAnchorPoint(cc.p(0.5,0.5))
	self.lab_xing:setVisible(true)
	if not self.lab then
		self.lab = self.cost:clone()
		self.lab:setAnchorPoint(cc.p(0.5,0.5))
		self.lab:setPosition(display.cx,self.Image_zb_bg :getPositionY())
		self.lab:addTo(self.view)
	end
	self.lab:setString(res.str.DEC_ERR_72)

	--5个按钮
	for k , v in pairs(self.listbtn) do 
		v.colorKuang:loadTexture(res.btn.FRAME[1])
		v.spr:loadTexture(res.other.WENHAO)
		v.spr:setTag(-1)
		v.spr:addTouchEventListener(handler(self,self.onBtnComposeaftCallback))
		v.imgdi:setVisible(false)
	end
	--中间
	self.colorKuang:loadTexture(res.btn.FRAME[1])
	self.colorKuang:setTouchEnabled(true)
	self.colorKuang:addTouchEventListener(handler(self,self.onbtnChoosMiddle))
	self.spr:loadTexture(res.other.PLUS)

	self.btnCompose:loadTextureNormal(res.btn.COMPOSE_JIANG)
	self.title:loadTexture(res.font.COMPOSE_JIANG)
	--只要6 ， 7 星的
	local dataCard = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	if dataCard then 
		for k ,v in pairs(dataCard) do

			if conf.Item:getBattleProperty(v) < 1 then --出站排除
				if v.propertys[317] and v.propertys[317].value > 0 then

				else
					local name=conf.Item:getName(v.mId,v.propertys)
					local qq =  conf.Item:getItemQuality(v.mId)
					
					if qq > 5 and  not G_is7sCard(v.mId) then --最高星级排除 7s 卡排除
						table.insert(self._AllQualityDataOFCard,v)
						if not self._diffQualityDataCard[qq] then 
							self._diffQualityDataCard[qq] = {}
						end
						table.insert(self._diffQualityDataCard[qq],v)
					end	
				end 
			end		
		end
	end	

	local dataEquip = cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)

	if dataEquip then 
		for k ,v in pairs(dataEquip) do
			--待定
			local qq = conf.Item:getItemQuality(v.mId)
			if qq > 5   then --最高星级排除
				table.insert(self._AllQualityDataOFEquip,v)
				if not self._diffQualityDataEquip[qq] then 
					self._diffQualityDataEquip[qq] = {}
				end
				table.insert(self._diffQualityDataEquip[qq],v)
			end		
		end
	end	
end

function ComposeView:setSeverData()
	-- body
	self:setData(self.falg)
end

function ComposeView:setData(flag)
	-- body
	self.SelectList = {}
	--所有填充处复原
	
	self:clearMiddlespr()

	self.countEquip  = 0
	self.countCard  = 0

	self._AllQualityDataOFCard = { } 
	self._diffQualityDataCard = {}
	--所有装备
	self._AllQualityDataOFEquip = { } 
	self._diffQualityDataEquip = {}
	--已经选择的列表
	self.SelectList = {}

	self.AutoCard = {} 
	self.AutoEquip = {}
	

	self.falg = flag -- 合成或者 降星的 标志
	if flag then 
		self.btnCard:getInstance():setVisible(false)
		self.btnEquip:getInstance():setVisible(false)
		self:initDataStar()
	else
		self.btnCard:getInstance():setVisible(true)
		self.btnEquip:getInstance():setVisible(true)
		self:initDataCompose()
	end
	self:setRedPoint()
end
--装排序
function ComposeView:_sortEquip(data)
	table.sort( data, function(a,b)--装备排序
	-- body
		local lva = a.propertys[303] and a.propertys[303].value or 0
		local lvb = b.propertys[303]  and b.propertys[303].value or 0

		local Ja = a.propertys[311] and a.propertys[311].value or 0
		local Jb = b.propertys[311] and b.propertys[311].value or 0

		local pa = a.propertys[305] and a.propertys[305].value or 0
		local pb = b.propertys[305] and b.propertys[305].value or 0

		if Ja == Jb then -- 进化数相同
			if lva == lvb then --强化等级相同
				if  pa  == pb then --战力相同
					return a.mId<b.mId
				else
					return pa  < pb
				end	
			else
				return lva<lvb
			end	
		else
			return Ja<Jb
		end
	end)
end
function ComposeView:getPropByid(t,id)
	return t.propertys[id] and t.propertys[id].value or 0
end

--卡牌排序
function ComposeView:_sortCard( data )
	-- body
	table.sort( data, function(a,b)--卡牌排序
				-- body
		local lva = self:getPropByid(a,304) 
		local lvb = self:getPropByid(b,304)  

		local Ja = self:getPropByid(a,310)  --a.propertys[310] and a.propertys[310].value or 0
		local Jb = self:getPropByid(b,310) --b.propertys[310] and b.propertys[310].value or 0

		local pa = self:getPropByid(a,305) --a.propertys[305] and a.propertys[305].value or 0
		local pb = self:getPropByid(b,305) --b.propertys[305] and b.propertys[305].value or 0

		local jia = self:getPropByid(a,307) --a.propertys[307] and a.propertys[307].value or 0
		local jieb = self:getPropByid(a,307) --b.propertys[307] and b.propertys[307].value or 0
		if jia == jieb then --阶数相同
			if lva == lvb then --强化等级相同
				if Ja == Jb then -- 进化数相同
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
		else
			return jia < jieb
		end
	end)
end

--自动添加时检测那个能添加 1 检测卡牌 否则 检测装备
function ComposeView:search( index )
	-- body
	local data = index == 1 and self._diffQualityDataCard or self._diffQualityDataEquip

	local retable = {}
	for i = 1 , 6 do
		if data[i] and #data[i]>=5 then --如果该品质存在
			local flag = false 
			if not index  then 
				self:_sortEquip(data[i])
			else 
				self:_sortCard(data[i])
			end
			--排序完成后 取前5个作为材料 --阶 = 0 进化 0
			local t = {}
			for j = 1 , 5 do 	
				if index then 
					local jie = self:getPropByid(data[i][j],307)
					local jihua = self:getPropByid(data[i][j],310)
					local lv = self:getPropByid(data[i][j],304)
					local huoban = self:getPropByid(data[i][j],317)
					if jie>0 or jihua>0 or lv >1 then 
						break
					end
				else
					local jie = self:getPropByid(data[i][j],311)
					local lv = self:getPropByid(data[i][j],303)
					if jie>0 or lv > 0  then 
						break
					end
				end
				table.insert(t,data[i][j])
			end
			if #t>=5 then 
				table.insert(retable,t)
			end
		end
	end	
	return retable
end
--替换选着
function ComposeView:replaceFromSelectList(data )
	-- body
	self.SelectList[data.pos] = data
end
--添加物品到框里面
function ComposeView:filldata( k,v )
	-- body
	
	self.cost:setString("")
	self.jbIcon:setVisible(false)
	local type=conf.Item:getType(v.mId)
	local lv=conf.Item:getItemQuality(v.mId)

	local path  = conf.Item:getItemSrcbymid(v.mId,v.propertys)
	local framePath=res.btn.FRAME[lv]
 	
	if k then  
		--print("kkkkk")
		v.pos = k 
		--table.insert(self.SelectList,v)
		self:replaceFromSelectList(v)
		self.CanUseGZ[k] =false
		self.listbtn[k].colorKuang:loadTexture(framePath)
		self.listbtn[k].spr:loadTexture(path)
		--self.listbtn[k].spr:setTouchEnabled(false)
		--记录当前是怎么类型被选中
		self.calltype = type 
		self.colorlv = lv
		local id = 0
		if self.calltype  == pack_type.SPRITE then 
			id  = 3000 + self.colorlv  
		else
			id  = 1000 + self.colorlv  
		end
		self.jbIcon:setVisible(true)
		self.cost:setString(conf.Card:getCost(id))
	else
		self.colorKuang:loadTexture(framePath)
		self.colorKuang:setTouchEnabled(true)
		self.colorKuang:setTag(v.mId)
		--print(jianren)
		self.spr:loadTexture(path)	
		self.cost:setString("")
	end	
end

--自动添加
function ComposeView:searchADDindex( type_ , color )
	-- body
	--self.SelectList = {}
	local count = #self.SelectList
	if count >= 5 then 
		color = nil 
	end	
	local data = {}
	local index = 1
	if not color then 
		--所有填充处复原
		self:clearListbtn() 
		self:clearMiddlespr()
		self.SelectList = {}
		if type_ then 
			self.countCard  = self.countCard+1 > #self.AutoCard and  1 or  self.countCard+1 
			data = self.AutoCard[self.countCard]
		else
			self.countEquip = self.countEquip+1 > #self.AutoEquip and 1 or self.countEquip+1 
			data = self.AutoEquip[self.countEquip]
		end
	else
		if type_ then
			for k ,v in pairs(self.AutoCard) do 
				local lv=conf.Item:getItemQuality(v[1].mId)
				if lv == color then 
					data = v
					break
				end	
			end	
		else
			for k ,v in pairs(self.AutoEquip) do 
				local lv=conf.Item:getItemQuality(v[1].mId)
				if lv == color then 
					data = v
					break
				end	
			end	
		end	
	end	
	if data then 
		for k , v in pairs (data) do 
			if k  > 5 then 
				break;
			end	

			local flag = true
			for i ,value in pairs(self.SelectList) do --不要放重复的
				if value == v then  
					flag = false 
					break
				end 
			end 

			if flag then 
				for i = 1 , 5 do --找个空位置
					--if self.SelectList[i]  
					if self.CanUseGZ[i] then 
						
						self:filldata( i ,v )
						break
					end	
				end	
			end 
		end	
	end		
end
--选择精灵返回
function ComposeView:chooseCallback( data_,flag)
	-- body
	if not flag then 
		self:removeFromWidge()
		self:clearMiddlespr()
		if self.gid and self.gid>0 and self.gid < 6 then 
			self:filldata( self.gid,data_ )
		end
	else
		self.SelectList = {}
		table.insert(self.SelectList,data_)
		self:setMiddlespr(data_)
	end
end
--合成成功后更新 index  去背包里获取对应装备
function  ComposeView:updateData(index)
	-- body

	local function CallBackFunc()
		-- body
		self.SelectList = {}
		--所有填充处复原
		self:clearListbtn() 
		self:clearMiddlespr()
		self:setData()
		local data  = cache.Pack:getItemByIndex(index)
		self:filldata(nil,data)


		local __view = mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if __view == nil  then 
			__view = mgr.ViewMgr:showView(_viewname.PACKGETITEM)	
		end	
		local datainfo   = cache.Pack:getItemByIndex(index)
		local t ={} 
		table.insert(t,datainfo)
		local type=conf.Item:getType(datainfo.mId)
		if type ==  pack_type.SPRITE then 
			__view:setData(t)
		else
			__view:setData(t,nil,true)
		end	
		__view:setButtonVisible(false)
	end


	local pos  = self.Panel_1:getWorldPosition()
	local posx = pos.x + self.Panel_1:getContentSize().width/2
	local posy = pos.y + self.Panel_1:getContentSize().height/2

	local params =  {id=404805, x=posx,y=posy,
	addTo=self.view,endCallFunc=CallBackFunc,from=nil,to=nil, 
	playIndex=1,addName = "effofname"}
	mgr.effect:playEffect(params)

	
end
--精灵按钮按下
function  ComposeView:onBtnCardcallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if self.calltype and self.calltype == 1 then 
			self:clearListbtn() 
			self:clearMiddlespr()
			self.cost:setString("")
			self.SelectList = {}
			self.colorlv = nil
		end	
		--debugprint("精灵按钮被按下")
		if #self.AutoCard == 0 then 
			G_TipsOfstr(res.str.COMPOSE_DEC2)
			return 
		end 

		self.gid = 0
		self:searchADDindex(1,self.colorlv)
	end
end

function ComposeView:onBtnEquipCallback( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint("装备按钮被按下")
		if self.calltype and self.calltype == 3 then 
			self:clearListbtn() 
			self:clearMiddlespr()
			self.cost:setString("")
			self.SelectList = {}
			self.colorlv = nil
		end	

		if #self.AutoEquip == 0 then 
			G_TipsOfstr(res.str.COMPOSE_DEC1)
			return 
		end 

		self.gid = 0
		self:searchADDindex(nil,self.colorlv)
	end
end
--中间图片按钮
function ComposeView:onBtnComposeaftCallback( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local tag = send:getTag()
		if tonumber(tag) ~= -1 then 
			G_openItem(tag)
		end
	end
end
--发送合成信息
function ComposeView:tosend()
	-- body
	local lvup = {}
	lvup.indexs = { }
	for k,v in pairs(self.SelectList) do
		--print("v.index "..v.index)
		table.insert(lvup.indexs,v.index)
	end
	if #lvup.indexs==0 then
		G_TipsOfstr(res.str.COMPOSE_DEC3) 
		return 
	end 

	proxy.lucky:Composesend(lvup)
	mgr.Sound:playQianghua()
end
---合成按下
function ComposeView:onBtnComposeCallback( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint("合成按钮被按下"..table.nums(self.SelectList))
		if self.falg then 
			if not self.usedata or not self.usedata.index  then
				G_TipsOfstr(res.str.PROMOTE_NOCARD) --没有选择材料
			else
				local data = {}
				data.cancel = function( ... )
					-- body
				end
				data.surestr = res.str.SURE 
				if cache.Player:getVip() < 2 then
					data.richtext = res.str.DEC_ERR_29
					data.sure = function( ... )
						-- body
						G_GoReCharge()
					end
					mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
				else
					data.richtext = {
						{text=res.str.GUILD_DEC24,fontSize=24,color=cc.c3b(255,255,255)},
						{img=res.image.ZS},
						{text=tostring(self.use),fontSize=24,color==cc.c3b(255,255,255)},
						{text=","..res.str.DEC_ERR_30,fontSize=24,color=cc.c3b(255,255,255)},
					}
					data.sure = function( ... )
						-- body
						if G_BuyAnything(2,self.use) then
							--debugprint("发送请求合成")
							local data  = {index = self.usedata.index}
							proxy.Equipment:send108006(data)
							mgr.NetMgr:wait(508006)
						end
					end
					mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)
				end
				
			end
		else
			if table.nums(self.SelectList) == 5 then 
				local colorlv = conf.Item:getItemQuality(self.SelectList[1].mId) 
				local type = conf.Item:getType(self.SelectList[1].mId)
				local data = {}
				
				data.sure = function( ... )
					-- body
					self:tosend()
				end
				data.cancel = function( ... )
					-- body
				end
				data.surestr = res.str.SURE

				if colorlv == 5 then 
					data.richtext = res.str.COMPOSE_DEC4
					if type == pack_type.SPRITE then 
						data.richtext = res.str.COMPOSE_DEC6
					end 

					mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
					return 
				elseif colorlv == 6 then 
					data.richtext = res.str.COMPOSE_DEC5
					if type == pack_type.SPRITE then 
						data.richtext = res.str.COMPOSE_DEC7
					end 
					mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
					return 
				else
					self:tosend()
				end 
			else
				G_TipsOfstr(res.str.COMPOSE_DEC3) 
			end 
		end	
	end
end
--规则按下
function ComposeView:onBtnGuize(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint("规则按钮被按下")
		if self.falg then 
			mgr.ViewMgr:showView(_viewname.GUIZE):showByName(11)
		else
			mgr.ViewMgr:showView(_viewname.GUIZE):showByName(1)
		end
	end
end
--好像已经没有用了..
function ComposeView:removeFromWidge(  )
	-- body
	self:setVisible(true)
end

function ComposeView:onBtnChooseCallback(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self.gid =  send:getTag()
		--self:setVisible(false) -- 不让他接受点击事件 为了listView
		local view = mgr.ViewMgr:showView(_viewname.COMPOSELIST)
		view:setEquiplist(self._diffQualityDataEquip,self.colorlv) --装备可选列表
		view:setCardList(self._diffQualityDataCard,self.colorlv) --装备卡牌可选列表
		view:setSelectPetListData(self.SelectList) --已选择
		view:btncall(self.calltype)
	end
end

-------------------------------------------------------------------------------------------------------

function ComposeView:onbtnChoosMiddle(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.COMPOSELIST)
		view:setEquiplist(self._diffQualityDataEquip) --装备可选列表
		view:setCardList(self._diffQualityDataCard) --装备卡牌可选列表
		view:setSelectPetListData(self.SelectList) --已选择
		view:setLowStart(true)
		view:selePage(1)
	end
end

function ComposeView:onCloseSelfView()
	-- body
	G_mainView()
	--mgr.SceneMgr:getMainScene():changeView( 1)
end

return ComposeView