--[[
	福袋
]]

local ActiveNewBag = class("ActiveNewBag",base.BaseView)

function ActiveNewBag:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.cloneitem = self.view:getChildByName("Panel_9")
	self.getitem = self.view:getChildByName("Image_2")

	self:initDec()
	--G_FitScreen(self,"Image_7")
	self.mianview = mgr.ViewMgr:get(_viewname.RANKENTY)
	self:schedule(self.changeTimes,1.0,"changeTimes")
end

function ActiveNewBag:initDec()
	-- body
	local img = self.view:getChildByName("Image_96")
	img:getChildByName("Text_40"):setString(res.str.ACT_DEC_1)

	local panel = self.view:getChildByName("Panel_2")
	local img_1 =  panel:getChildByName("Image_12")
	self.img_1 = img_1
	self.btnlist = {}
	for i = 1 , 6 do 
		local btn = img_1:getChildByName("Button_bag_"..i)
		btn.tag = i
		btn:addTouchEventListener(handler(self,self.onbtnFudaiCallBack))
		table.insert(self.btnlist,btn)
	end

	self.open_dec = img_1:getChildByName("Image_24_1")
	self.open_dec:ignoreContentAdaptWithSize(true)
	self.open_img = img_1:getChildByName("Image_24_1_0")
	self.lab_open = img_1:getChildByName("AtlasLabel_1")
	self.lab_open:setString(0)

	local btn_cz = img_1:getChildByName("Button_9")
	btn_cz:addTouchEventListener(handler(self,self.onbtnRecharge))

	local img_2  = panel:getChildByName("Image_20") 
	self.img_2 = img_2
	local img_3 = img_2:getChildByName("Image_24_0_0")
	img_3:getChildByName("Text_7"):setString(res.str.ACT_DEC_2)

	self.lab_time =img_3:getChildByName("Text_7_0")
	self.lab_time:setString("")

	local btn_shua = img_2:getChildByName("Button_bag_2_0")
	btn_shua:addTouchEventListener(handler(self, self.onbtnReflash))
	btn_shua:setTitleText(res.str.ACT_DEC_3)

	local img_4 = img_2:getChildByName("Image_24_0_0_0")
	img_4:getChildByName("Text_7_10_0"):setString(res.str.ACT_DEC_4)
	img_4:getChildByName("Text_7_10"):setString(res.str.ACT_DEC_5)

	self.lab_cost = img_4:getChildByName("Text_7_0_12_0")
	self.lab_cost:setString(0)

	self.lab_cout = img_4:getChildByName("Text_7_0_12")
	self.lab_cout:setString(0)

	self.show = {}
	local ccsize = img_2:getContentSize()
	local starx = 80 
	local distance = ((ccsize.width - starx ) - 4 * self.cloneitem:getContentSize().width ) / 3
	for i = 1 , 6 do 
		local itme = self.cloneitem:clone()
		if i < 5 then
			itme:setPositionY(ccsize.height - itme:getContentSize().height )
		else
			itme:setPositionY(ccsize.height - 2*itme:getContentSize().height - 5)
		end

		local j = i % 4 
		if j == 0 then 
			j = 4
		end

		itme:setPositionX(starx + (j-1)*distance + itme:getContentSize().width * (j -1))
		itme:addTo(img_2)
		itme:setVisible(false)
		itme.frmae = itme:getChildByName("Button_17")
		itme.spr = itme.frmae:getChildByName("Image_21")
		itme.spr:ignoreContentAdaptWithSize(true)
		itme.name = itme:getChildByName("Text_6")
		itme.name:setString("")

		table.insert(self.show,itme)
	end
end

function ActiveNewBag:changeTimes()
	-- body
	if not self.data then
		if self.mianview then
			self.mianview:updateData("")
		end
		return 
	end

	self.data.actLeftTime = self.data.actLeftTime - 1
	if self.data.actLeftTime < 0 then 
		G_mainView()
		return
	end

	self.mianview:updateData(G_getTimeStr(self.data.actLeftTime))

	--福袋剩余刷新时间
	self.data.zeroLeftTime = self.data.zeroLeftTime - 1
	if self.data.zeroLeftTime <= 0 then
		self.data.zeroLeftTime = 0
		proxy.Active:send_116155()
		return 
	end
	self.lab_time:setString(G_getTimeStr(self.data.zeroLeftTime))
end

function ActiveNewBag:inititem( key  )
	-- body
	self.btnlist[key]:removeAllChildren()
	self.btnlist[key].tag = -1 --表示领取了
	local spr = self.getitem:clone() --display.newSprite(res.font._NEWBAG_4)
	spr:setPositionX(self.btnlist[key]:getContentSize().width/2)
	spr:setPositionY(self.btnlist[key]:getContentSize().height/2)
	spr:addTo(self.btnlist[key])
end

function ActiveNewBag:setBtngetStatue(data)
	-- body
	for k ,v in pairs(self.btnlist) do 
		v.tag = k 
		v:removeAllChildren()
	end
	for k ,v in pairs(data) do 
		local key = checkint(k)
		if key > 0 and tonumber(v) > 0 and self.btnlist[key] then --这个已经领取
			self:inititem(key)
		end
	end
end

function ActiveNewBag:setbagshow(data)
	-- body
	for k , v in pairs(self.show) do 
		v:setVisible(false)
	end
	for k ,v in pairs(data) do 
		local itme = self.show[k]
		if itme then
			--[[if itme.done then 
				itme.done:removeSelf()
			end]]--

			local colorlv = conf.Item:getItemQuality(v.mid)
			itme:setVisible(true)
			itme.libId = v.libId
			itme.frmae:loadTextureNormal(res.btn.FRAME[colorlv]) 
			itme.spr:loadTexture(conf.Item:getItemSrcbymid(v.mid))
			itme.name:setString(conf.Item:getName(v.mid).."x"..v.amount)
			itme.name:setColor(COLOR[colorlv])
		end
	end
end

function ActiveNewBag:checkGet()
	-- body

	
	for i , j in pairs(self.show) do
		if j.done then
			print("清除")
			j.done:removeSelf()
			j.done = nil 
		end
	end
	for k, v in pairs(self.data.gotStatus) do 
		if checkint(k) > 0 then
			if v > 0 then
				for i , j in pairs(self.show) do 
					if j.libId and j.libId == checkint(v) then
						if not j.done then
							j.done =self.getitem:clone()
							j.done:setPositionX(j:getContentSize().width/2)
							j.done:setPositionY(j:getContentSize().height/2)
							j.done:addTo(j)
							break
						end
					end
				end
			end
		end
	end
end

--免费次数
function ActiveNewBag:setFreetime(value)
	-- body
	self.curfree = self.max_free[1] - value
	if self.curfree <= 0 then 
		self.curfree = 0
		self.open_dec:loadTexture(res.font._NEWBAG_2)
		self.open_img:setVisible(true)
		self.lab_open:setString(self.cost_chou[self.data.costLottryTimes+1] or self.cost_chou[#self.cost_chou])

		local w = self.open_dec:getContentSize().width + self.open_img:getContentSize().width + self.lab_open:getContentSize().width
		local startx = (self.img_1:getContentSize().width - w)/2
		self.open_dec:setPositionX(startx)
		self.open_img:setPositionX(self.open_dec:getPositionX()+self.open_dec:getContentSize().width)
		self.lab_open:setPositionX(self.open_img:getPositionX()+self.open_img:getContentSize().width/2*0.5+10)
	else
		self.open_dec:loadTexture(res.font._NEWBAG_5)
		self.open_img:setVisible(false)
		self.lab_open:setString(self.curfree)

		local w = self.open_dec:getContentSize().width + self.lab_open:getContentSize().width
		local startx = (self.img_1:getContentSize().width - w)/2
		self.open_dec:setPositionX(startx)
		self.lab_open:setPositionX(startx+self.open_dec:getContentSize().width)
	end
end
--抽奖消耗次数
function ActiveNewBag:setCostTime( value )
	-- body
	self.cur_ref = self.max_free[2] -value  
	if self.cur_ref < 0 then
		self.cur_ref = 0
	end
	self.lab_cout:setString(self.cur_ref)
	self.lab_cost:setString(self.cost_fudai[value + 1] or self.cost_fudai[#self.cost_fudai])
end

function ActiveNewBag:setData(data)
	-- body
	self.data = data
	self:setBtngetStatue(data.gotStatus)
	--剩余免费开启次数
	self.max_free = conf.Sys:getValue("bag_free_times")
	--付费消耗
	self.cost_chou = conf.Sys:getValue("bag_lottery_cost")
	--刷新福袋消耗
	self.cost_fudai = conf.Sys:getValue("bag_refresh_cost")
	if not self.max_free then
		self.max_free = {1,1}
	end
	self:setFreetime(data.freeLotteryTimes)
	--本轮奖励
	self:setbagshow(data.luckyBags)
	--剩余刷新次数
	self:setCostTime(data.costRfeTimes)

	self:checkGet()
	self:changeTimes()
end
--抽取一次返回
function ActiveNewBag:setChouData(data)
	-- body
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
	view:setData(data.items,true,true)
	view:setButtonVisible(false)

	--免费次数
	self.data.freeLotteryTimes = data.freeLotteryTimes
	--话费次数
	self.data.costLottryTimes = data.costLottryTimes
	self:setFreetime(data.freeLotteryTimes)
	--加上领取
	self:inititem(data.index)
	for k, v in pairs(data.gotStatus) do 
		if checkint(k) > 0 and v > 0 then
			self.data.gotStatus[k..""] = v 
		end
	end

	if #data.luckyBags>0 then
		--重置奖励
		self:setbagshow(data.luckyBags)
		--领取清除
		for k ,v in pairs(self.btnlist) do 
			v.tag = k 
			v:removeAllChildren()
		end

		for k ,v in pairs(self.data.gotStatus) do 
			if checkint(k) > 0 then
				self.data.gotStatus[k..""] = 0
			end
		end
	end
	--验证那些已经抽取了
	self:checkGet()
end
--刷新一次
function ActiveNewBag:setrefData( data )
	-- body
	--刷新次数
	self.data.costRfeTimes = data.costRfeTimes
	self:setCostTime(data.costRfeTimes)

	--话费次数
	self.data.costLottryTimes = data.costLottryTimes
	self:setFreetime(self.data.freeLotteryTimes)

	--重置奖励
	self:setbagshow(data.luckyBags)
	--领取清除
	for k ,v in pairs(self.btnlist) do 
		v.tag = k 
		v:removeAllChildren()
	end
	for k ,v in pairs(self.data.gotStatus) do 
		if checkint(k) > 0 then
			self.data.gotStatus[k..""] = 0
		end
	end
	self:checkGet()
end
--按钮刷新
function ActiveNewBag:onbtnReflash(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self.cur_ref <= 0 then
			G_TipsOfstr(res.str.ACT_DEC_8)
		else
			local str =  res.image.ZS
			local data = {}
			data.richtext = {
				{text=res.str.GUILD_DEC24,fontSize=24,color=cc.c3b(255,255,255)},
				{img=str},
				{text=self.cost_fudai[self.data.costRfeTimes + 1] or self.cost_fudai[#self.cost_fudai],fontSize=24
				,color=cc.c3b(255,0,0)},
				{text=","..res.str.ACT_DEC_9,fontSize=24,color=cc.c3b(255,255,255)},
				
			}
			data.sure = function( ... )
				-- body
				proxy.Active:send_116154()
			end
			data.cancel = function( ... )
				-- body
			end
			data.surestr =  res.str.SURE
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)
		end
	end
end

--前往充值
function ActiveNewBag:onbtnRecharge( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_GoReCharge()
	end
end
--福袋点击
function ActiveNewBag:onbtnFudaiCallBack(send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--某一个福袋被点击
		local tag = send.tag
		if tag <= 0 or tag > 6  then
			return
		end

		if self.curfree > 0 then --免费次数还有
			proxy.Active:send_116153({index = tag})
		else
			local str =  res.image.ZS
			local data = {}
			data.richtext = {
				{text=res.str.GUILD_DEC24,fontSize=24,color=cc.c3b(255,255,255)},
				{img=str},
				{text=self.cost_chou[self.data.costLottryTimes + 1] or self.cost_chou[#self.cost_chou],fontSize=24
				,color=cc.c3b(255,0,0)},
				{text=","..res.str.ACT_DEC_7,fontSize=24,color=cc.c3b(255,255,255)},
				
			}
			data.sure = function( ... )
				-- body
				proxy.Active:send_116153({index = tag})
			end
			data.cancel = function( ... )
				-- body
			end
			data.surestr =  res.str.SURE
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)
		end
	end
end

return ActiveNewBag