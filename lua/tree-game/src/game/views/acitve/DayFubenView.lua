

local DayFubenView = class("DayFubenView",base.BaseView)
local headpath = "res/views/ui_res/icon/"

function DayFubenView:ctor()
	-- body
	self.oldbtn  = nil 

	self.requestOnce = false
end

function DayFubenView:init()
	-- body
	self.ShowAll= true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_1")
	self.bg = self.view:getChildByName("Image_1")
	--self.bg:

	local btn_guize = panle:getChildByName("Button_24")
	btn_guize:addTouchEventListener(handler(self, self.onBtnGuize))
	--滚动选择
	self.listview = panle:getChildByName("ListView_1") 
	self.item_clone = self.view:getChildByName("Panel_5")
	--
	local panle1 = self.view:getChildByName("Panel_12") 

	local btnpanle = panle1:getChildByName("Panel_18")
	local btnchange = btnpanle:getChildByName("Button_24_0_0")
	self.btnpanle = btnpanle
	--self.btnchange = btnchange
	btnchange:setTitleText(res.str.DEC_NEW_26)
	btnchange:addTouchEventListener(handler(self, self.onbtnchangeCall))
	self.btnchange = btnchange

	local lab = btnpanle:getChildByName("Text_3")
	lab:setString(res.str.DEC_NEW_25..":")

	self.lab_count =  btnpanle:getChildByName("Text_3_0")
	self.lab_count:setString("")
	--说话的东西
	self.pan_word = panle1:getChildByName("Panel_1_0")
	self.pan_word:setScale(0)
	self.lab_ward = self.pan_word:getChildByName("Text_2_24_27_15") 
	self.lab_ward:setString("")
	--
	self.pageview = panle1:getChildByName("PageView_1")
	self.pagepanle = self.view:getChildByName("Panel_24")



	

	--self:Bossword()

	self:schedule(self.changeTimes,1.0,"changeTimes")

	G_FitScreen(self,"Image_1")
end

function DayFubenView:changeTimes()
	-- body
	if self.data then
		local temp = os.date("*t", self.data.time)
		self.data.time = self.data.time + 1
		local temp1 = os.date("*t", self.data.time)
		if temp.day~=temp1.day and not self.requestOnce then
			self.requestOnce = true
			proxy.DayFuben:send121001()
			mgr.NetMgr:wait(521001)
		end
	end
end

function DayFubenView:initlist( ... )
	-- body
	local data = conf.DayFuben:getListAll()
	table.sort(data,function(a,b )
		-- body
		return a.sort < b.sort
	end)
	if self.imgchoose  then
		self.imgchoose:removeSelf()
		self.imgchoose = nil 
	end

	if self.oldbtn then
		self.oldbtn = nil 
	end

	self.pageview:removeAllPages()
	self.listview:removeAllItems()

	self.item = {}
	for k ,v in pairs(data) do 
		local item = self.item_clone:clone()
		item.id = v.id
		--对应icon
		local btn = item:getChildByName("Button_9")
		--btn:setTouchEnabled(false)
		btn.data = v
		btn.orderid = k
		btn:addTouchEventListener(handler(self, self.onbtnChooseCall))

		local img = btn:getChildByName("Image_10")
		img:ignoreContentAdaptWithSize(true)
		--img:setBright(false)
		img:loadTexture(headpath..v.icon..".png")

		--res.str.DEC_NEW_27
		--item:getChildByName("Text_1_0"):setString(v.text)
		local str = ""
		if v.open_time then
			for i = 1 , #v.open_time do
				if str~="" then
					str = str .. "、"
				end
				str = str .. res.str.DEC_NEW_28[v.open_time[i]]
			end
		end
		
		img_suo = item:getChildByName("Image_10_0")
		img_suo:setVisible(false)
		if str~="" then
			item:getChildByName("Text_1_0"):setString(string.format(res.str.DEC_NEW_27,str))
		else
			item:getChildByName("Text_1_0"):setString("")
			img_suo:setVisible(true)
		end

		item:getChildByName("Text_1"):setString(v.name)
		self.listview:pushBackCustomItem(item)
		self.item[tonumber(v.id)]  = item
		--self.item[tonumber(v.id)].btn = btn
		--boss形象
		local widget = self.pagepanle:clone()
		local spr = display.newSprite("res/cards/"..v.boss_id..".png")
		spr:setPositionX(widget:getContentSize().width/2)
		spr:setPositionY(widget:getContentSize().height/2)
		spr:addTo(widget)
		spr:setTag(10000)
		spr.id = v.id

		self.pageview:addPage(widget)
	end
	self.pageview:addEventListener(handler(self, self.pageTurn))
	--printt(self.item)
end

function DayFubenView:pageTurn()
	-- body
	if self.oldpage then
		if self.pageview:getCurPageIndex() == self.oldpage then
			return 
		end
	end 
	self.oldpage = self.pageview:getCurPageIndex()

	cache.DayFuben:keepPage(self.oldpage + 1 )

	local page = self.pageview:getCurPageIndex()
	local widget = self.pageview:getPage(page)
	local spr = widget:getChildByTag(10000)
	if not spr then
		return 
	end
	local btn = self.item[tonumber(spr.id)]:getChildByName("Button_9")
	self:onbtnStatue(btn)
end

function DayFubenView:warCallBack( page)
	-- body
	if not page then
		page = 1
	end

	self:performWithDelay(function( ... )
		-- body
		self.pageview:scrollToPage(page-1)
	end, 0.2)

	
end

function DayFubenView:updateinfo(fbType,value)
	-- body
	local data = self.item[tonumber(fbType)].data
	if  data then
		data.vipBuyCount = value
	end
	self.count = self.count + 1
	self.lab_count:setString(self.count)
end

function DayFubenView:initData(data_conf)
	-- body
	local data = self.item[tonumber(data_conf.id)].data

	local str = ""
	if data_conf.open_time then
		for i = 1 , #data_conf.open_time do
			if str~="" then
				str = str .. "、"
			end
			str = str .. res.str.DEC_NEW_28[data_conf.open_time[i]]
		end
	end

	-- 创建一个居中对齐的文字显示对象 
	if self.label then
		self.label:removeSelf()
		self.label = nil 
	end	
	local label = display.newTTFLabel({
	    text = string.format(res.str.DEC_NEW_36,str),
	    font = res.ttf[1],
	    size = 30,
	    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
		

	self:Bossword(data_conf.speak)
	if not data then

		label:setColor(COLOR[1]) -- 1 跟 品质 走颜色 1 白 2 绿 3 蓝 .....
		label:addTo(self.view)
		label:setTag(10001)

		local pos = self.btnpanle:getWorldPosition()

		label:setPosition(pos.x+self.btnpanle:getContentSize().width/2 + 0 , -- x 方向
			pos.y+self.btnpanle:getContentSize().height/2 + 0)              -- y 方向

		self.label = label

		self.btnpanle:setVisible(false)
		return 
	end
	self.btnpanle:setVisible(true)

	local maxcount = data_conf.comm_limit 
	self.count = maxcount + data.vipBuyCount - data.playCount
	self.lab_count:setString(self.count)



end

function DayFubenView:Bossword(_table)
	-- body
	self.pan_word:stopAllActions()
	local scale = cc.ScaleTo:create(0.8,1)
    local act = cc.EaseElasticOut:create(scale)
	local a1 = cc.DelayTime:create(3.0)
	local a_fistr = cc.CallFunc:create(function()
		-- body
		self.lab_ward:setString( _table[ math.random(1,#_table)])
		self.pan_word:setScale(0)
	end)

	local sequence = cc.Sequence:create(a_fistr,act,a1)
	local action = cc.RepeatForever:create(sequence)
	self.pan_word:runAction(action) 
end

function DayFubenView:setData(data_)
	-- body
	self:initlist()
	self.data = data_ 
	self.requestOnce = false

	local firstpage = 1
	for k , v in pairs(self.data.openFuben) do
		local widget =  self.item[tonumber(v.fbType)]
		--if widget then
		widget.data = v 
		--widget:getChildByName("Image_18"):removeSelf()
		widget:getChildByName("Text_1_0"):removeSelf()
		local btn =  widget:getChildByName("Button_9")
		btn:setTouchEnabled(true)

		local confdata = btn.data 
		local img = btn:getChildByName("Image_10")
		img:ignoreContentAdaptWithSize(true)
		--img:setBright(false)
		img:loadTexture(headpath..confdata.icon1..".png")

		if k == 1 then
			firstpage = btn.orderid
		end
	end
	self:warCallBack(firstpage)
end

function DayFubenView:onCloseSelfView()
	-- body
	--self:closeSelfView()
	--mgr.SceneMgr:getMainScene():addHeadView()
	G_mainView()
	mgr.SceneMgr:getMainScene():changePageView(5)
end

function DayFubenView:onbtnStatue(send_)
	-- body
	if not send_ or tolua.isnull(send_) then
		return
	end

	send_:setTouchEnabled(false)
	if self.oldbtn  then
		self.oldbtn:setTouchEnabled(true)
	end
	self.oldbtn = send_

	if self.imgchoose  then
		self.imgchoose:removeSelf()
		self.imgchoose = nil 
	end

	local size = send_:getContentSize()
	local armature = mgr.BoneLoad:loadArmature(404835,0)
    armature:setPosition(size.width/2,size.height/2)
    armature:addTo(send_)

    self.imgchoose = armature

    self.btnchange.data = send_.data
    self:initData(send_.data)
end

function DayFubenView:onbtnChooseCall( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--debugprint("我被选中了")
		--self:onbtnStatue(send)
		self:warCallBack(send.orderid)
	end
end

function DayFubenView:onbtnchangeCall( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local data_conf = send.data
		local data = self.item[tonumber(data_conf.id)].data
		if self.count > 0 then
			local view =  mgr.ViewMgr:showView(_viewname.FUBEN_DAY_REWARD)
			view:setData(data,data_conf)
		else
			local max = 0 --最大购买次数
			local yy = data_conf.viptq_id
	
			for i = 17 , 1 , -1 do 
				max = conf.Recharge:getVipLimit(i,yy)

				if max > 0 then
					break;
				end
			end
			print(max,data.vipBuyCount)
			if max == data.vipBuyCount then
				local data = {}
				data.sure = function( ... )
					-- body
				end
				data.surestr = res.str.SURE
				data.richtext =res.str.DEC_NEW_31
				mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
				return 
			else
				local curbuy = conf.Recharge:getVipLimit(cache.Player:getVip(),yy)
			
				if not curbuy then
					curbuy = 0
				end
				if curbuy > data.vipBuyCount then --如果还有购买次数
					local data_ = {}
					data_.max = curbuy
					data_.cur = data.vipBuyCount
					data_.yb = conf.buyprice:getPriceDayFuben(data.vipBuyCount+1) 
					data_.fbType = data_conf.id

					local view = mgr.ViewMgr:showTipsView(_viewname.ATHLETICS_ALERT)
					view:setDayFBData(data_)
					return 
				end

				local data = {}
				data.vip = res.str.DEC_NEW_32
				data.sure = function()
					-- body
					mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
					G_GoReCharge()
				end
				data.cancel = function()
					-- body
				end
				data.surestr= res.str.RECHARGE
				local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
				view:setData(data)
				return 
			end
		end
	end
end

function DayFubenView:onBtnGuize(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(15)
	end 
end

return DayFubenView