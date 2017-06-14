
local SpriteWidget = require("game.views.rune.runitemUpView")
local ScollLayer = require("game.cocosstudioui.ScollLayer")
local RunelvView=class("RunelvView",base.BaseView)

function RunelvView:ctor()
	-- body
	self.item = {} --5个位置 放置被吞噬的东西
	self.select = {} --当前选择的
	self.card_pos = 1 --数码兽位置
	self.fw_pos = 1 --数码兽的几个东西
end


function RunelvView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	mgr.SceneMgr:getMainScene():addHeadView()

	self.panle1 = self.view:getChildByName("Panel_7")
	self.panle2 = self.view:getChildByName("Panel_28")

	self.Panel_c =self.view:getChildByName("Panel_c") 
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
	self.BtnLeft=self.Panel_c:getChildByName("button_1")
	self.BtnLeft:addTouchEventListener(handler(self,self.onChangePetCallBack))
	self.BtnRight=self.Panel_c:getChildByName("button")
	self.BtnRight:addTouchEventListener(handler(self,self.onChangePetCallBack))

	--6个按钮位置
	self.clonemItem =  self.view:getChildByName("Panel_1")
	self:initfivePos()
	--
	self:initDec()
	self:palyForever()
end

function RunelvView:palyForever()
	-- body
	--[[local params =  {id=404805, x=self.Panel_1:getContentSize().width/2,
					y=self.Panel_1:getContentSize().height/2,addTo=self.Panel_1,
					loadComplete = function(var)
							var:setScale(self.scale)
					end, playIndex=0,addName = "effofname"}
	mgr.effect:playEffect(params)--]]

	local armature_1 = mgr.BoneLoad:loadArmature(404805,0)
	local widget = self:getPositionByI(6)
	armature_1:setPosition(widget:getContentSize().width/2,widget:getContentSize().height/2) 
	armature_1:addTo(widget)

end

function RunelvView:getWidgetClone( ... )
	-- body
	return self.clonemItem:clone()
end
--初始化位置 格子
function RunelvView:initfivePos()
	-- body
	local size = 5
	for i=1,size do
		local widget= SpriteWidget.new()
		widget:init(self,i)
		-- widget:showName(true)
		widget:setScale(0.8)
        self.view:addChild(widget,100)
        local widgetpos = self:getPositionByI(i)
		widget:setPosition(widgetpos:getPositionX()+35,widgetpos:getPositionY()+45)

		self.item[i]=widget
	end

	self.curwidget = SpriteWidget.new()
	self.curwidget:init(self,6)
	local widget = self:getPositionByI(6)
	self.curwidget:setPosition(widget:getPositionX()+50,widget:getPositionY()+45)
    self.view:addChild(self.curwidget,100)	
end

function RunelvView:getPositionByI( pos )
	-- body
	return self.view:getChildByName("Panel_4_0"..pos)
end

--一闪一闪的动画
function RunelvView:_runBilk( lab,tiem )
	-- body
	local  a1=cc.FadeIn:create(tiem)
	local  a2=cc.FadeOut:create(tiem)

	local a3 = cc.DelayTime:create(tiem)
	local sequence = cc.Sequence:create(a1,a2)
	lab:runAction(cc.RepeatForever:create(sequence))
end
--文字初始化
function RunelvView:initDec()
	-- body
	self.curlv = self.panle1:getChildByName("Image_bg_title_0"):getChildByName("Text_48_14")
	self.addlv = self.panle1:getChildByName("Image_bg_title_0"):getChildByName("Text_add")
	self.curlv:setString("")
	self.addlv:setString("")

	self:_runBilk(self.addlv,0.5)
	self.pro_panel = {}
	for i = 1 , 3 do 
		local t = {}
		t.panle = self.panle1:getChildByTag(i*100)
		t.panle:setVisible(false)
		
		t.dec  = t.panle:getChildByTag(101)
		t.value = t.panle:getChildByTag(102)
		t.addvalue = t.panle:getChildByTag(103)
		t.addvalue:setString("")
		t.addvalue:setVisible(false)
		
		self:_runBilk(t.addvalue,0.5)
		table.insert(self.pro_panel,t)
	end
	--
	self.loadbar = self.panle2:getChildByName("LoadingBar_2")
	self.loadbar_exp = self.panle2:getChildByName("Text_exp") 
	self.loadbar_exp:setString("")

	self.lab_jb = self.panle2:getChildByName("Text_name_0")
	self.lab_jb:setString("")

	self.loadbar_lan = self.panle2:getChildByName("LoadingBar_1")
	

	self.panle2:getChildByName("Text_name"):setString(res.str.PET_DEC_20)

	local btn = self.panle2:getChildByName("Button_add")
	btn:setTitleText(res.str.PET_DEC_21)
	btn:addTouchEventListener(handler(self,self.onbtnAuto))

	local btn2 = self.panle2:getChildByName("Button_10")
	btn2:setTitleText(res.str.PET_DEC_22)
	btn2:addTouchEventListener(handler(self,self.onbtnLvup))
end
--前一个
function RunelvView:prv()
	-- body
	if self.fw_pos > 1 then
		self.fw_pos=self.fw_pos - 1
	else
		if self.card_pos > 1 then
			self.fw_pos = 6
			self.card_pos =  self.card_pos - 1
		else
			self.card_pos = 6 
			self.fw_pos =  6
		end
	end
	if self.data[self.card_pos] and self.data[self.card_pos][self.fw_pos] then
		local tt = self.data[self.card_pos][self.fw_pos]
		self:updateinfo(tt)
	else
		self:prv()
	end
end
--后一个
function RunelvView:next()
	-- body
	if self.fw_pos < 6 then
		self.fw_pos=self.fw_pos+1
	else
		if self.card_pos < 6 then
			self.fw_pos = 1
			self.card_pos =  self.card_pos +1
		else
			self.card_pos = 1 
			self.fw_pos =  1
		end
	end

	--printt(self.data)

	if self.data[self.card_pos] and self.data[self.card_pos][self.fw_pos] then
		local tt = self.data[self.card_pos][self.fw_pos]
		self:updateinfo(tt)
	else
		self:next()
	end
end
--当前选择
function RunelvView:setSelectIndex( card_pos,fw_pos )
	-- body
	if not self.data then
		return 
	end

	if not self.data[card_pos] then
		return 
	end

	if not self.data[card_pos][fw_pos] then
		return 
	end

	self.card_pos = card_pos
	self.fw_pos = fw_pos

	local data = self.data[card_pos][fw_pos]
	self:updateinfo(data)
end
--进度条动画
function RunelvView:runLoadBar(exp)
	-- body
	if not self.conf_next or not exp or exp == 0 then
		return
	end

	self.loadbar:setPercent(0)
	self.loadbar:stopAllActions()
	if #self.select > 0 then
		self.loadbar:setPercent((self.exp + exp)*100/self.conf_next.need_exp) 
		self:_runBilk(self.loadbar,0.3)
		--G_ExpofRune(self.showdata)
		if exp + self.exp >=self.conf_next.need_exp then --如果足够升级
			local lv ,state = G_CanUptolv(self.showdata, exp   )
			if lv == 0 then
				return 
			end
	
			self.addlv:setString("+" .. lv - tonumber(self.curlv:getString() ))

			local t = {}
			t.mId = self.showdata.mId
			t.propertys = clone(self.showdata.propertys)
			t.propertys[315] = {}
			t.propertys[315].value = lv
			local prot =  G_CalculateRunePro(t)
			--printt(prot)
			--print("max power")
			local count = 0
			for k , v in pairs(res.str.DEC_NEW_04) do 
				if count >= 2 then
					break
				end
				if prot.propertys[v] then
					count = count + 1
					local widget =  self.pro_panel[count]

					local str = string.split(widget.value:getString(),"%")
					printt(str)

					local value = prot.propertys[v].value - tonumber(str[1])
					--print( prot.propertys[v].value,tonumber(str[1]))
					if v > 200 then
						value = value .. "%"
					end
					--print(value)
					widget.addvalue:setString("+"..value)
					widget.addvalue:setVisible(true)
				end
			end

			local widget =  self.pro_panel[count+1]
			--print(count,tolua.type(widget.addvalue) )
			--print(prot.propertys[305].value,widget.value:getString())
			local power = prot.propertys[305].value - checkint(widget.value:getString())
			widget.addvalue:setString("+"..power)
			widget.addvalue:setVisible(true)
		end
	end
end
--文字
function RunelvView:clear()
	-- body
	self.curlv:setString("")
	self.addlv:setString("")
	self.loadbar_exp:setString("")
	self.loadbar:setPercent(0)
	self.loadbar_lan:setPercent(0)
end
--当前显示的符文
function RunelvView:curData()
	-- body
	return self.showdata
end

function RunelvView:setServerCallBack( data )
	-- body
	 --动画播放期间 不给点击
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(display.width,display.height))
	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
    self:addChild(layer,1000) 

    local lv = self.showdata.propertys[315] and self.showdata.propertys[315].value or 0
	local uplv = data.lev - lv
    local function listener( ... )
		-- body
		layer:removeFromParent()

		debugprint("uplv = "..uplv)
		if uplv > 0 then 
			local img = display.newSprite(res.font.DEC_LV)
			img:setAnchorPoint(cc.p(0,0))
			img:setPositionX(-self.curwidget:getContentSize().width/2)
			img:setPositionY(self.curwidget:getContentSize().height)
			img:addTo(self.curwidget)
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

		if not self.showdata.propertys[315] then
		self.showdata.propertys[315] = {}
		end
		self.showdata.propertys[315].value = data.lev

		if not self.showdata.propertys[316] then
			self.showdata.propertys[316] = {}
		end
		self.showdata.propertys[316].value = data.extExp

		self:updateinfo(self.showdata)
	end

    local armature_1 = mgr.BoneLoad:loadArmature(404805,1)
	local widget = self.curwidget
	armature_1:setPosition(widget:getContentSize().width/2-50,widget:getContentSize().height/2-50) 
	armature_1:addTo(widget)

	armature_1:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
     		listener()
        end
    end)	
end

function RunelvView:updateinfo(data_)
	-- body
	--清除5个选择 还原数据
	--
	self.lab_jb:setString("")
	---
	self.showdata = data_
	self:clear()
	self.select = {}
	for k ,v in pairs(self.item) do 
		v:setData()
	end
	--清理一些动画
	self.loadbar:stopAllActions()
	for k , v in pairs(self.pro_panel) do
		v.panle:setVisible(false)
		v.addvalue:setString("")
	end
	--设置当前符文
	--
	self.curwidget:setData(data_)
	local lv = data_.propertys[315] and data_.propertys[315].value  or 0
	local exp = data_.propertys[316] and data_.propertys[316].value or 0
	self.exp = exp
	self.curlv:setString(lv)

	local t = {}
	t.mId = data_.mId
	t.propertys = data_.propertys
	--计算属性
	local prot =  G_CalculateRunePro(t)
	local count = 0
	for k , v in pairs(res.str.DEC_NEW_04) do 
		if count >= 2 then
			break
		end

		if prot.propertys[v] then
			count = count + 1
			local widget =  self.pro_panel[count]
			widget.panle:setVisible(true)

			widget.dec:setString(res.str.DEC_NEW_03[v])
			local value = prot.propertys[v].value
			if v > 200 then
				value = value .. "%"
			end
			widget.value:setString(value)
		end
	end

	local widget =  self.pro_panel[count+1]
	widget.panle:setVisible(true)
	widget.dec:setString(res.str.PRO_PROWER)
	print("cur power")
	widget.value:setString(prot.propertys[305].value)
	--计算下一级需要
	local att_pre = conf.Item:getAttPre(data_.mId)
	local id  = att_pre .. string.format("%03d",lv)
	local nextid = att_pre .. string.format("%03d",lv+1)

	self.conf = conf.Rune:getItem( id )
	self.conf_next = conf.Rune:getItem( nextid )

	self.loadbar_lan:setPercent(100)
	self.next_need = 0 --升到下一集经验所需
	if self.conf_next then
		self.loadbar_lan:setPercent(exp*100/self.conf_next.need_exp)
		--self.lab_jb:setString(self.conf_next.need_exp)
		self.next_need = self.conf_next.need_exp - exp
		if self.next_need < 0 then
			self.next_need = 0
		end
	else
		self.lab_jb:setString("")
	end
	--计算升到最大等级需要 --上限是人物等级 或者是 装备上限等级
	self.maxexp = 0
	local maxlv = conf.Item:getMaxQhLv(data_.mId) --可升到的最高等级
	--local maxplayerLv = cache.Player:getLevel() --玩家等级
	--local max = math.min(maxlv,maxplayerLv)
	local max = maxlv
	local id_max = att_pre .. string.format("%03d",max)
	print("att_pre",att_pre)
	print("id_max",id_max)
	local maxconf = conf.Rune:getItem( id_max )
	self.maxlv = maxlv --能升到的最大等级
	self.maxexp = maxconf.all_exp --升到最大等级所需的经验

end
--升到下一级 所需的经验 
function RunelvView:getNeedExp()
	-- body
	return self.next_need
end
--升到当前最大等级的经验 -- 这个是算上自己本身的价值经验
function RunelvView:getMaxExp( ... )
	-- body
	return self.maxexp
end
--
function RunelvView:setData(data_)
	-- body
	self.data = data_
end

--已经选择的
function RunelvView:getSelectList()
	-- body
	return self.select
end
--设置已经选择的
function RunelvView:setSelectList(data_)
	-- body
	self.select = data_

	for k ,v in pairs(self.item) do 
		v:setData()
	end
	for k ,v in pairs(self.select) do 
		self.item[k]:setData(v)
	end
	--重新计算经验
	self:setSelectExp()
end
--重新计算经验 判断是否 升级 升几级 
function RunelvView:setSelectExp( ... )
	-- body
	local exp = 0
	for k ,v in pairs(self.select) do 
		exp = exp + G_ExpofRune(v)
	end
	self.addexp = exp
	self.loadbar_exp:setString(exp)
	--print("self.addexp = "..self.addexp)
	self:runLoadBar(exp)

	local xishu = conf.Sys:getValue("fuwen_up_jb_coef")
	self.lab_jb:setString(math.floor( exp*xishu))
end

function RunelvView:checkmax(flag)
	-- body
	if not self:check() then --顶级了 没有下一级
		G_TipsOfstr(res.str.DEC_NEW_22)
		return false
	elseif #self.select >= 5 and not flag  then --材料已够了
		return false
	end
	local exp = 0
	for k ,v in pairs(self.select) do 
		exp = exp + G_ExpofRune(v) 
	end

	if exp + G_ExpofRune(self.showdata) >= self.maxexp then --添加的 道具 已经够最大等级
		G_TipsOfstr(res.str.DEC_NEW_38)
		return false
	end

	return true
end

--自动添加
function RunelvView:auto()
	-- body
	if not  self:checkmax() then
		return 
	end

	local data = cache.Rune:getPackinfo()

	if #data  == 0 then
		G_TipsOfstr(res.str.DEC_NEW_37)
		return 
	end

	table.sort(data,function( a,b )
		-- body
		local acolorlv = conf.Item:getItemQuality(a.mId)
		local bcolorlv = conf.Item:getItemQuality(b.mId)

		local apower = mgr.ConfMgr.getPower(a.propertys)
        local bpower = mgr.ConfMgr.getPower(b.propertys)

		if acolorlv == bcolorlv then 
			if apower == bpower then 
				return a.index < b.index
			else
				return apower < bpower
			end 
		else
			return acolorlv<bcolorlv
		end 
	end)

	local t = {}
	
	for k , v in pairs(data) do 
		local ff = true
		for i , j in pairs(self.select) do --排除选中的
			if j.index == v.index then
				ff = false
				break
			end
		end 

		if ff then --排除品质较高的
			local v_c = conf.Item:getItemQuality(v.mId)
			local s_c = conf.Item:getItemQuality(self.showdata.mId)
			if v_c >3 or v_c > s_c then
				ff = false
			elseif v_c > s_c then
				if v.propertys[315] and v.propertys[315].value > 0 then
					ff = false
				end
			end
		end


		if ff then
			table.insert(t,v)
		end
	end

	if #t == 0 and #data ~=0 then
		G_TipsOfstr(res.str.RES_RES_43)
		return 
	end 



	local count = #self.select
	for i = 1 , 5 - count do
		if t[i] then
			--printt(data[i])
			table.insert(self.select,t[i])
			if not self:checkmax() then --刚好足够了 或者数量足够了
				break;
			end
		end
	end

	local t = clone(self.select)
	self:setSelectList(t)
end

function RunelvView:check()
	-- body
	if not self.conf_next then
		G_TipsOfstr(res.str.DEC_NEW_22)
		return false
	end
	return true
end

function RunelvView:sendmsg()
	-- body
	local cout = self.lab_jb:getString()
	if G_BuyAnything(1, tonumber(cout)) then
		local data = {}
		data.items = {}
		table.insert(data.items,self.showdata.index)
		for  k ,v in pairs(self.select) do 
			print(v.mId)
			table.insert(data.items,v.index)
		end
		proxy.Rune:send120203(data)
	end
end

function RunelvView:onbtnLvup(  send,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("升级")
		if #self.select == 0 then --没有材料
			G_TipsOfstr(res.str.DEC_NEW_21)
			return
		elseif  not self.conf_next then --满级
			G_TipsOfstr(res.str.DEC_NEW_22)
			return 
		end

		local ff = false
		for k, v in pairs(self.select) do 
			local v_c = conf.Item:getItemQuality(v.mId)
			local s_c = conf.Item:getItemQuality(self.showdata.mId)
			if v_c > s_c then
				ff = true
				break
			end
		end

		if ff then
			local data = {}
			data.richtext = res.str.DUI_DEC_67
			data.sure = function( ... )
				-- body
				self:sendmsg()
			end
			data.cancel = function( ... )
				-- body
			end
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		else
			self:sendmsg()
		end
	end
end

function RunelvView:onbtnAuto( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("自动添加")
		self:auto()
	end
end

function RunelvView:onChangePetCallBack( send,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local tag=send:getName()
		if tag == "button_1" then
			self:prv()
		elseif tag == "button" then
			self:next()
		end
	end
end

function RunelvView:onCloseSelfView()
	-- body
	self.super.onCloseSelfView(self)
	mgr.SceneMgr:getMainScene():closeHeadView()
end

return RunelvView