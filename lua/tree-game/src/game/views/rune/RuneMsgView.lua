
local RuneMsgView  = class("RuneMsgView",base.BaseView) 
local ScollLayer = require("game.cocosstudioui.ScollLayer")
function RuneMsgView:ctor()
	-- body
	self.card_pos = 1
	self.fw_pos = 1
end

function RuneMsgView:init()
	-- body
	--
	proxy.card:setToindx(-1)

	self.showtype=view_show_type.TOP
	self.view = self:addSelfView()
	--物品名
	self.lab_name = self.view:getChildByName("Text_name")
	self.Image_star = self.view:getChildByName("Image_star")
	--左右按钮
	self.btnright= self.view:getChildByName("Button_19_0")
	self.btnright:addTouchEventListener(handler(self,self.onDirCallBack))
	self.btnleft = self.view:getChildByName("Button_19")
	self.btnleft:addTouchEventListener(handler(self,self.onDirCallBack))
	--更换按钮
	local btnchange = self.view:getChildByName("Button_change")
	btnchange:addTouchEventListener(handler(self, self.onChangeCallBack))
	self.btnchange = btnchange

	local btnout = self.view:getChildByName("Button_change_0")
	self.btnout = btnout
	btnout:addTouchEventListener(handler(self,self.onbtnOutCall))

	--滚动list
	self.listview = self.view:getChildByName("Image_di"):getChildByName("ListView_1")
	--
	self.item_msg = self.view:getChildByName("Panel1")
	self.item_suit = self.view:getChildByName("Panel3")
	self.suit_pro = self.view:getChildByName("Panel_property")
	self.suit_spr = self.view:getChildByName("Panel_clone")
	--左右切换
	self.panle26 = self.view:getChildByName("Panel_26")

	self.dec = self.view:getChildByName("Text_1")
	self.dec:setString("")

	local posx,posy = self.panle26:getPosition()
	local ccsize =  self.panle26:getContentSize()
	local rect =cc.rect(posx,posy,ccsize.width,ccsize.height)
	local layer = ScollLayer.new(rect,30)
	layer:setName("touchlayer")
	layer:setMoveLeftCalllBack(handler(self,self.prv))
	layer:setMoveRightCalllBack(handler(self,self.next))
	self:addChild(layer)
	self.layer = layer

	self:initDec()
end

function RuneMsgView:initDec()
	-- body
	self.btnchange:setTitleText(res.str.DEC_NEW_13)
	self.btnout:setTitleText(res.str.DEC_NEW_12)

	self.lab_name:setString("")
	local Panel_35 = self.item_msg:getChildByName("Panel_35")
	Panel_35:getChildByName("Text_39_18_9_34"):setString(res.str.EQUIPMENT_DEC2)
	Panel_35:getChildByName("Text_19_11_36"):setString("")
	Panel_35:getChildByName("Text_80_0"):setString("")

	local Panel_35_1 = self.item_msg:getChildByName("Panel_35_1")
	Panel_35_1:getChildByName("Text_39_18_9_34_53"):setString(res.str.EQUIPMENT_DEC5)
	Panel_35_1:getChildByName("Text_19_11_36_55"):setString("")

	local Panel_35_0 = self.item_msg:getChildByName("Panel_35_0")
	Panel_35_0:getChildByName("Text_39_18_9_34_43"):setString(res.str.EQUIPMENT_DEC4)
	Panel_35_0:getChildByName("Text_19_11_36_45"):setString("")
end


function RuneMsgView:setData(data_)
	-- body
	self.data = data_
	--printt(self.data)
end
--显示选中装备
function RuneMsgView:setSelectIndex( card_pos,fw_pos )
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
	--printt(data)
	self:updateinfo(data)
end
--服务器返回后
function RuneMsgView:setCurSelect( ... )
	-- body
	if not self.card_pos then
		self.card_pos = 1
	end

	if not self.fw_pos then
		self.fw_pos = 1 
	end

	if not self.data then
		return 
	end

	if not self.data[self.card_pos] then
		self:prv()
		return
	end

	if not self.data[self.card_pos][self.fw_pos] then
		self:prv()
		return
	end

	local data = self.data[self.card_pos][self.fw_pos]
	self:updateinfo(data)
end

function RuneMsgView:addStar( num)
	self.Image_star:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.Image_star:getContentSize().height
	local iconwidth=self.Image_star:getContentSize().width

	--local 
	local sprite=display.newSprite(starpath)
	local w = sprite:getContentSize().width*size
	local strposX = (iconwidth-w)/2 + sprite:getContentSize().width/2

	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setPosition(strposX+sprite:getContentSize().width*(i-1),iconheight/2)
		self.Image_star:addChild(sprite)
	end
end

function RuneMsgView:initSpr(data_)
	-- body
	local colorlv = conf.Item:getItemQuality(data_.mId)

	local sprfrmae = self.suit_spr:clone()
	--sprfrmae:setPositionY(10)
	--sprfrmae:addTo(self.panle26)

	sprfrmae:getChildByName("Image_12_42"):loadTexture(res.btn.FRAME[colorlv])
	local spr = sprfrmae:getChildByName("Image_13_44")
	spr:ignoreContentAdaptWithSize(true)
	spr:loadTexture(conf.Item:getItemSrcbymid(data_.mId))

	sprfrmae.name = sprfrmae:getChildByName("Text_32")
	sprfrmae.name:setString(conf.Item:getName(data_.mId))
	return sprfrmae
end

function RuneMsgView:setinfo( data_ ,flag)
	-- body
	self.lab_name:setString(conf.Item:getName(data_.mId))
	local colorlv = conf.Item:getItemQuality(data_.mId)
	self.lab_name:setColor(COLOR[colorlv])
	self:addStar(colorlv)

	self.dec:setString(conf.Item:getItemDescribe(data_.mId))
	self.dec:setColor(COLOR[colorlv])

	local spr = self:initSpr(data_)
	spr:setAnchorPoint(cc.p(0.5,0.5))
	spr:setPositionY(self.panle26:getContentSize().height/2+20)
	spr.name:setVisible(false)
	spr:setPositionX(self.panle26:getContentSize().width/2)
	spr:setVisible(true)
	spr:addTo(self.panle26)
	
	---	
	local widget = self.item_msg:clone()
	local btn = widget:getChildByName("Button_21")
	btn:addTouchEventListener(handler(self, self.onbtnLvCallBack))
	--等级
	local lab_curlv = widget:getChildByName("Panel_35"):getChildByName("Text_80_0")
	local lv = data_.propertys[315] and  data_.propertys[315].value or 0
	--printt(data_)
	lab_curlv:setString(lv.."/")

	local lab_maxlv = widget:getChildByName("Panel_35"):getChildByName("Text_19_11_36")
	lab_maxlv:setString(conf.Item:getCardMaxlv(data_.mId))

	for i = 2 , 5 do 
		widget:getChildByTag(1000+i):setVisible(false)
	end
	--printt(data_)
	local count = 1
	for k ,v in pairs(res.str.DEC_NEW_04) do 
		if count >= 3 then
			break
		end
		if data_.propertys[v] then
			count = count + 1
			local panle = widget:getChildByTag(1000+count)
			local value = data_.propertys[v].value

			local img_dec = panle:getChildByTag(1)
			local lab_value = panle:getChildByTag(2)

			--img_dec:loadTexture(res.font.FW[v])
			img_dec:setString(res.str.DEC_NEW_03[v])
			if v > 200 then
				value = value .. "%"
			end
			lab_value:setString(value)

			panle:setVisible(true)
		end
	end
	if count == 0 then
		count = 1
	end

	local panle = widget:getChildByTag(1000 + count+1)
	panle:setVisible(true)

	local t = G_CalculateRunePro(clone(data_))
	local power = t.propertys[305] and  t.propertys[305].value or 0
	local lab_dec = panle:getChildByTag(1)
	local lab_value = panle:getChildByTag(2)

	lab_dec:setString(res.str.PRO_PROWER..":")
	lab_value:setString(power)

	if flag then
		btn:setVisible(false)
	end
	self.listview:pushBackCustomItem(widget)
end
--是否穿戴
function RuneMsgView:isSuitFw(mId)
	-- body
	if not self.data then
		return 
	end

	if not self.data[self.card_pos] then return false end 
	for k , v in pairs(self.data[self.card_pos]) do 
		if v.mId == mId then
			return true
		end
	end
	return false
end
--当前 激活几件套
function RuneMsgView:suitNumber(suit_id)
	-- body
	if not self.data then
		return 
	end

	local data = self.data[self.card_pos]--[fw_pos]
	local count = 0
	if data then
		for k ,v in pairs(data) do 
			local id = conf.Item:getItemSuitId(v.mId) 
			if id and id == suit_id then
				count = count+1
			end
		end
	end
	return count
end

--[[function RuneMsgView:initProStr(_table)
	local str = "" 
	for k , v in pairs(_table) do 
		if k > 1 and k ~=#_table then 
			str = str..","
		end 
		str = str .. string.format(res.str.DEC_NEW_05[tonumber(v[1])],tonumber(v[2]))
	end
	return str
end ]]--

function RuneMsgView:setSuit(data)
	-- body
	--获取
	local suit_id= conf.Item:getItemSuitId(data.mId)
	if not suit_id or suit_id == 0 then
		return 
	end 
	local widget = self.item_suit:clone()
	widget:setVisible(true)
	
	--套装列表
	local ItemList = conf.Suit:getFwIdList(suit_id)
	local suit_name = conf.Suit:getFwNameList(suit_id)
	local suit_value = conf.Suit:getFwPropertyList(suit_id)

	local pos_b_y = widget:getChildByName("Image_10_0_38_64_82"):getPositionY()
	local posy = 0
	for k , v in pairs(ItemList) do 
		local _table = { mId = v  } 
		local item = self:initSpr(_table) 
		if not self:isSuitFw(v) then
			item.name:setColor(cc.c3b(0xaf,0xac,0xac))
		end

		posy = pos_b_y - item:getContentSize().height - 30 
		item:setPositionY(posy)
		local posx = 30 + (k - 1)*(item:getContentSize().width + 50 )
		item:setPositionX(posx)
		item:addTo(widget)
	end 

	local suitnum = self:suitNumber(suit_id) --套装件数
	if not suitnum then
		suitnum = 0
	end
	--print("suitnum = "..suitnum)
	local count = 0 
	for k , v in pairs(suit_name) do 
		if v ~= "" then 
			count = count + 1

			local item = self.suit_pro:clone()
			local _suit = item:getChildByName("Text_suit_name")
			_suit:setString(string.format(res.str.DEC_NEW_14,k+1))

			local _eff = item:getChildByName("Text_suit_value")

			--local str = --self:initProStr(suit_value[k])
			_eff:setString(v)

			posy = posy - item:getContentSize().height - 5
			item:setPosition(0,posy)
			item:addTo(widget)

			if k + 1 <= suitnum then 
				_suit:setColor(cc.c3b(255,104,22))
				_eff:setColor(cc.c3b(255,104,22))
			else
				_suit:setColor(cc.c3b(0xaf,0xac,0xac))
				_eff:setColor(cc.c3b(0xaf,0xac,0xac))
			end 
		end
	end 
	--大小变化
	local height = count * (self.suit_pro:getContentSize().height + 8) + 20
	local oldsize = self.item_suit:getChildByName("Image_33_60_78"):getContentSize()
	widget:getChildByName("Image_33_60_78"):setContentSize(cc.size(oldsize.width,oldsize.height + height))

	self.listview:pushBackCustomItem(widget)
end

function RuneMsgView:updateremove(data_)
	-- body
	--self:prv()
	for k ,v in pairs(self.data) do 
		for i , j in pairs(v) do
			if j.index == data_.index then
				if table.nums(v) == 1 then
					table.remove(self.data,k)
				else
					table.remove(v,i)
				end
				break
			end
		end
	end
	if not self.data or #self.data == 0 then
		self:onCloseSelfView()
	else
		self:prv()
	end
end

function RuneMsgView:updateChange( data_ )
	-- body
	--for k ,v in pairs(self.data) do 
		--for i , j in pairs(v) do
			--if j.index == data_.index then
			--	self.data[k] = data_
			--	self:updateinfo(data_)
				--[[if table.nums(v) == 1 then
					table.remove(self.data,k)
				else
					table.remove(v,i)
				end]]--
				--break
			--end
		--end
	--end
end

--显示数据
function RuneMsgView:updateinfo(data_,falg)
	-- body
	--
	
	self.listview:removeAllChildren()
	---信息
	self:setinfo(data_,falg)
	--套装
	self:setSuit(data_)
	if falg then
		self.btnchange:setVisible(false)
		self.btnout:setVisible(false)
		self.btnright:setVisible(false)
		self.btnleft:setVisible(false)
		if self.layer then
			self.layer:removeSelf()
			self.layer = nil 
		end
	end
end

function RuneMsgView:prv()
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

function RuneMsgView:next()
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

		printt(tt)
		self:updateinfo(tt)
	else
		self:next()
	end
end
--左右按钮按下
function RuneMsgView:onDirCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local btnname = send:getName()
		if btnname == "Button_19" then
			self:prv()
		else
			self:next()
		end
	end
end
--更换按钮返回
function RuneMsgView:onChangeCallBack(send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint(":更换符文X"..self.card_pos..","..self.fw_pos)
		local index = self.data[self.card_pos][self.fw_pos].index
		local view =  mgr.ViewMgr:showView(_viewname.RUNE_LIST_VIEW)
		view:setWearpos(index)
		view:setSomething(false)
	end 
end
--
function RuneMsgView:onbtnOutCall( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint(":脱下符文X")
		if self.data[self.card_pos][self.fw_pos].index>600000 then
			local param = {index =self.data[self.card_pos][self.fw_pos].index ,toIndex = -1 , opType = 2 }
			proxy.Rune:send120201(param)
			mgr.NetMgr:wait(520201)

			self:onCloseSelfView()
		end
	end 
end

--跳转到升级界面
function RuneMsgView:onbtnLvCallBack( send,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("升级界面")
		local view = mgr.ViewMgr:showView(_viewname.RUNE_LV)
		view:setData(self.data)
		view:setSelectIndex(self.card_pos,self.fw_pos)
		self:onCloseSelfView()
	end 
end

function RuneMsgView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return RuneMsgView