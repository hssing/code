--
-- Author: Your Name
-- Date: 2015-12-02 14:43:56
--


--[[
	双11抽奖
]]
local Act2LuckyView = class("Act2SignView",base.BaseView)

function Act2LuckyView:init(Parent)
	
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.panel=self.view:getChildByName("Panel_11_1")
	self.view:getChildByName("Panel_11_0"):setVisible(false)
	

	local img = self.panel:getChildByName("Image_69_133")
	self.img = img --转盘

	self.btnlist = {}
	for i = 1 , 6 do 
		local t = {}
		t.frame = img:getChildByName("Button_1_"..i)
		t.spr = t.frame:getChildByTag(100)
		t.spr:ignoreContentAdaptWithSize(true)
		t.name =t.frame:getChildByTag(200)

		t.frame:setRotation(60*(i-1))

		table.insert(self.btnlist,t)
	end
	--4个道具
	self.lablist ={}
	for i = 1 , 4 do 
		local lab = self.panel:getChildByName("Image_71_"..i):getChildByName("Text_1_"..i)
		table.insert(self.lablist,lab)
	end

	self.btn = self.panel:getChildByName("Button_2_0")
	self.btn:addTouchEventListener(handler(self, self.onbtnChouCall))

	self._checkbox = self.panel:getChildByName("CheckBox_2")
	self._checkbox:setSelected(false)
	self._checkbox:addEventListener(handler(self, self.checkBoxCallback))

	local times=MyUserDefault.getIntegerForKey(user_default_keys.ACT2_CHOU_CHECK)
	if times then --今日是否勾选了 不在提示
		if os.date("%x", os.time()) == os.date("%x",times) then 
			self.cancelSecond = false 
		else
			self.cancelSecond = true
		end
	end	

	--界面文本
	self.view:getChildByName("Panel_1"):getChildByName("Text_5_23"):setString(res.str.ACT2_LUCKY_DESC3)
	self.panel:getChildByName("Text_1_17_58_89_0"):setString(res.str.ACT2_LUCKY_DESC1)
	self.btn:getChildByName("Text_1_17_58_89_111"):setString(res.str.ACT2_LUCKY_DESC2)

	self:initData()
	proxy.RichRank:send116138()
end

--设置今天是否取消2次确认界面
function Act2LuckyView:savedaycancel( )
	-- body
	self.cancelSecond = false
	MyUserDefault.setIntegerForKey(user_default_keys.ACT2_CHOU_CHECK,os.time())
end

function Act2LuckyView:run(pos)
	-- body
	 local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(0)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    --addto:addChild(layer,100) 
    mgr.SceneMgr:getNowShowScene():addChild(layer)


	local jiaodu = 360 - (pos -1)*60 --最后停留
	--local t = 4 --旋转总时长
	local allqun = 360*5+jiaodu
	
	--快速旋转 
	local q1 = math.floor(3/4*allqun)
	local q2 = math.floor(7/8*(allqun - math.floor(3/4*allqun)))
	local q3 = allqun - q1 -q2

	--print(q1..","..q2..","..q3)

	local a1 = cc.RotateBy:create(2.0,q1)
	local a2 = cc.RotateBy:create(2.0,q2)
	local a3 = cc.RotateBy:create(1.4,q3)
	local a4 = cc.CallFunc:create(function()
		-- body
		layer:removeFromParent()
		local t = self.data.items
		local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if not view then
			view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
			view:setData(t,false,true,true)
			view:setButtonVisible(false)
		end

	end)

	local sequence = cc.Sequence:create(a1,a2,a3,a4)

	self.img:runAction(sequence)
end

function Act2LuckyView:initTool()
	-- body
	--4种道具
	self.tool = true
	self.min = 0
	----------------       
	local t = {221015021,221015023,221015024,221015022}
	for k , v in pairs(t) do 
		local count = cache.Pack:getItemAmountByMid(pack_type.PRO,v)
		self.lablist[k]:setString("/"..count)

		print(">>>>"..count)

		if count == 0 then 
			self.tool =false
		end

		if count > 0  then
			if self.min == 0 then 
				self.min = count
			else
				if self.min > count then 
					self.min = count
				end
			end
		end
	end
	if not self.tool then 
		self._checkbox:setEnabled(false)
		self._checkbox:setBright(false)
		self._checkbox:setSelected(false)
	else
		self._checkbox:setTouchEnabled(true)
		self._checkbox:setBright(true)
	end 
end

function Act2LuckyView:initData()
	-- body
	--初始化6个奖励
	local confdata = conf.ActiveVar:getValueByName("lotteryConf")
	for k , v in pairs(confdata) do 
		if k > 6 then 
			break
		end
		local widget = self.btnlist[k]

		local mId = v[1]
		local count = v[2]
		local cololv = conf.Item:getItemQuality(mId)

		widget.frame:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(mId))
		widget.name:setString(conf.Item:getName(mId).."x"..count)
		widget.name:setColor(COLOR[cololv])
	end
	self:initTool()
end

function Act2LuckyView:setData( data )
	self.leftTime = data["leftTime"]

	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(self:getTimeStr(self.leftTime),"")
	end

	self:schedule(self.timeTick, 1)
	self.dayTime = 100000000000

	--dump(data)
end


function Act2LuckyView:updateinfo(data_)
	-- body
	self:initTool()
	self.data = data_
	self:run(data_.gotIndex+1)
end

function Act2LuckyView:getMin( ... )
	-- body

end

function Act2LuckyView:checkBoxCallback(sender,eventtype)
	-- body
	print("checkBoxCallback")
	if eventtype == ccui.CheckBoxEventType.selected then
		if self.cancelSecond then 
			local data ={}
			local function sure(f)
				-- body
				mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
				if f then 
					self:savedaycancel()
				end	
			end
			local function cancel()
				-- body
			end
			local count = self.min
			data.adv = string.format(res.str.DOUBLE_DEC23,10)
			data.sure = sure
			data.cancel = cancel
			local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
			view:setData(data)
		else
		end
	end
end


function Act2LuckyView:onbtnChouCall(send,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		local falg = self._checkbox:isSelected() --复选框选中
		if self.tool then 
			self.img:setRotation(0)
			--proxy.RichRank:send116073({playType = falg and 1 or 0 })
			proxy.RichRank:send116139(falg and 1 or 0 )
			--mgr.NetMgr:wait(516073)
		else
			G_TipsOfstr(res.str.DOUBLE_DEC13)
		end
		--self:run(2)
	end
end



-----活动倒计时
function Act2LuckyView:timeTick( )
	self.leftTime = self.leftTime - 1
	self.dayTime = self.dayTime - 1
	--self.todayTime = self.todayTime - 1
	if self.leftTime <= 0 then
		self:stopAction(self.timeSchedual)
		--如果是主界面进入
		local view = mgr.ViewMgr:get(_viewname.RANKENTY)
		if view then
			view:updateData(res.str.RICH_RANK_DESC37,"")
		end

		self.btn:setBright(false)
		self.btn:setEnabled(false)
		G_mainView()

		return
	end

	if self.dayTime <= 0 then
		self:stopAllActions()
		proxy.RichRank:send116134()
		return
	end

	-- if self.todayTime <= 0 then
	-- 	self:stopAllActions()
	-- 	proxy.RichRank:reqOpenChargeCountInfo()
	-- 	return
	-- end

	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(self:getTimeStr(self.leftTime))
	end

end


function Act2LuckyView:getTimeStr( leftTime )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(leftTime / (60 * 60 * 24))--天
	left = leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC9,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC10, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC11, hour,minute,left)
	else
		timeStr = string.format(res.str.RICH_RANK_DESC12, day,hour,minute,left)
	end

	return timeStr
end




return Act2LuckyView