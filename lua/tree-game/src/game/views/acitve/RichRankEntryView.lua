--
-- Author: Your Name
-- Date: 2015-11-12 14:34:14
--
--[[
	活动主入口
]]
local RichRankEntryView=class("RichRankEntryView",base.BaseView)
local _rootPath ="res/itemicon/"
local frameUp = "res/views/ui_res/icon/icon_rich_up.png"
local frameDown = "res/views/ui_res/icon/icon_rich_down.png"

function RichRankEntryView:ctor( ... )
	-- body
	self.openview = nil
end

function RichRankEntryView:init()
	-- body
	self.showtype=view_show_type.TIPS
	self.ShowAll= true
	self.view=self:addSelfView()


	self.ListGUIButton = {}

	self.ListView= self.view:getChildByName("Panel_4"):getChildByName("ListView_1")
	self.clonepanel = self.view:getChildByName("Button_1")
	self.headBar = self.view:getChildByName("Panel_4"):getChildByName("Image_43")
	self.timeLab = self.headBar:getChildByName("Text_44_0_15")
	self.zsLab = self.headBar:getChildByName("Text_44_0_0_17")
	self.act = self.headBar:getChildByName("Text_44_13")
	
	--self:initListView()
	--self:setSwitch()

	--[[local view = mgr.ViewMgr:createView(_viewname.HEAD)
    if view then 
        view:closeSelfView()
    end ]]--

   -- self:setSwitch()


     --文本
     self.act:setString(res.str.RICH_RANK_DESC2)
end


------------设置红点
function RichRankEntryView:setRedPoint(  )
	-- body
	---等级礼包
	-- self.ListGUIButton[1]:setNumber(cache.Player:getZCnumber())
	-- self.ListGUIButton[2]:setNumber(cache.Player:getChiJnumber())
	-- self.ListGUIButton[3]:setNumber(cache.Player:getDengJJLNumber())

	for i=1,#self.ListGUIButton do
		local send = self.ListGUIButton[i]:getInstance()
		if send.id == 1001 then
        	self.ListGUIButton[i]:setNumber(cache.Player:getZCnumber())
        elseif send.id == 1002 then
        	self.ListGUIButton[i]:setNumber(cache.Player:getChiJnumber())  --吃鸡
        elseif send.id == 1003 then
        	self.ListGUIButton[i]:setNumber(cache.Player:getDengJJLNumber())---等级豪礼
        elseif send.id == 1004 then
        	---礼包码
        elseif send.id == 1005 then
        	---每日充值
        	self.ListGUIButton[i]:setNumber(cache.Player:getMeiRiNumber())
        elseif send.id == 1006 then
        	---单笔充值
        	self.ListGUIButton[i]:setNumber(cache.Player:getDanCNumber())
        elseif send.id == 1007 then
        ---累计充值
        	self.ListGUIButton[i]:setNumber(cache.Player:getLeiCNumber())
        elseif send.id == 1008 then
        elseif send.id == 4001 then
        	self.ListGUIButton[i]:setNumber(cache.Player:getXfhlRedpoint())
       	elseif send.id == 3009 then --7星豪礼入口
       		if cache.Player:get100_limite()== 2 then 
       			self.ListGUIButton[i]:setNumber(1)
       		else
       			self.ListGUIButton[i]:setNumber(0)
       		end

        end
	end

end

function RichRankEntryView:setSwitch( data,jump)
	self:setData()
	local newData = {}
	local acts = data.acts
	if acts and table.nums(acts) > 0 then
		for k,v in pairs(self.data) do
			local newId = v.id .. ""
			if acts[newId] and acts[newId] ~= 0 then
				self.data[k].on_off = acts[newId]
			end
		end
	end
	self.isJump = jump
	self:initListView()
	--self:setRedPoint()
end

function RichRankEntryView:setData()
	-- body
	local data = conf.active:getallactive()
	
	local datatmp = {}
	for i,v in pairs(data) do
		local id = math.floor(v.id / 1000)
		if id == 3 or id == 4 then
			if v.id == 3009 then 
				if cache.Player:get100_limite() == 1 or cache.Player:get100_limite() == 2 or cache.Player:get100_limite() == 3 then 
					table.insert(datatmp,v)
				end
			elseif v.id == 3010 then
				if cache.Player:get100_limite_3010() == 1 or cache.Player:get100_limite_3010() == 2 or cache.Player:get100_limite_3010() == 3 then 
					table.insert(datatmp,v)
				end
			else
				table.insert(datatmp,v)
			end
			
		end
	end

	self.data = {}
	for k1,t1 in pairs(datatmp) do
		if type(t1) == "table" then
			self.data[k1] = {}
			for k2,t2 in pairs(t1) do
				self.data[k1][k2] = t2
			end
		else
			self.data[k1] = t1
		end
	end

	--排序
	for i=1,#self.data - 1 do
		for j= i + 1,#self.data do
			if self.data[i].sort >  self.data[j].sort then
				self.data[i] , self.data[j] = self.data[j] , self.data[i]
			end
		end
	end


end

function RichRankEntryView:initListView()
	self.ListView:setItemsMargin(5)

	--for i=1,table.nums(self.data) do
	for k , v in pairs(self.data) do 
		--local v = self.data[(i+1000)..""]
		if  v.on_off == 1 then
			local widget = self.clonepanel:clone()
			widget:setSwallowTouches(false)
			local gui_btn=gui.GUIButton.new(widget,nil,{ImagePath=res.image.RED_PONT,x=15,y=15})
			gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放
			self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
			local iconImg = widget:getChildByName("Image_11")
			if v.icon_src then
				iconImg:loadTexture(_rootPath .. v.icon_src .. ".png")
			else
				iconImg:loadTexture(_rootPath .. v.src .. ".png")
			end
			print("v.id", v.id)

			-- --敬请期待
			-- if v.id == 3006 then
			-- 	widget:setEnabled(false)
			-- 	widget:setBright(false)
			-- 	widget:setEnabled(false)

			-- 	local img1 =  display.newGraySprite("res/views/ui_res/icon/icon_rich_up.png")
			-- 	widget:addChild(img1)
			-- 	img1:setPosition(widget:getContentSize().width / 2,widget:getContentSize().height / 2)

			-- 	local img =  display.newGraySprite(_rootPath .. v.src .. ".png")
			-- 	widget:addChild(img)
			-- 	img:setPosition(iconImg:getPositionX(),iconImg:getPositionY())
			-- 	iconImg:setVisible(false)
				


			-- else
			-- 	--按钮上的图片
			-- 	iconImg:loadTexture(_rootPath .. v.src .. ".png")
			-- end
			

			widget.lv = v.lv --开启等级
			widget.id = v.id
			widget.index = k
			widget:setTouchEnabled(true)
			widget:addTouchEventListener(handler(self,self.imgzhaocai))
			self.ListView:pushBackCustomItem(widget)
		end
	end 

	if not self.openview and not self.isJump then 
		self:imgzhaocai(self.ListView:getItem(0),ccui.TouchEventType.ended)
	end 
end 

----------黄胜----选中状态
function RichRankEntryView:setClickedState(pwidget)
	for i=1,#self.ListGUIButton do
		local btn = self.ListGUIButton[i]:getInstance()
		local v = self.data[btn.index]
		btn:setEnabled(true)
		btn:loadTextureNormal(frameUp)
	end

	-- local params =  {id=404835, x =pwidget:getContentSize().width/2,
	-- y = pwidget:getContentSize().height/2,addTo = pwidget,addName = "effofname"}
	-- mgr.effect:playEffect(params)

	pwidget:setEnabled(false)
	pwidget:loadTextureNormal(frameDown)

end



--添加选中状态
function RichRankEntryView:cleanstatue(pwidget)
	-- body
	if pwidget.lv > cache.Player:getLevel() then 
		local str = string.format(res.str.SYS_OPNE_LV, pwidget.lv)
		G_TipsOfstr(str)
		return 
	end 

	for k , v in pairs(self.ListView:getItems()) do 
		if v:getChildByName("choose") then 
			v:getChildByName("choose"):removeFromParent()
		end 
		v:setTouchEnabled(true)
	end  

	pwidget:setTouchEnabled(false)
	local img = ccui.ImageView:create()
	img:setName("choose")
	img:loadTexture(res.btn.SELECT_BTN)
	img:setPosition(pwidget:getContentSize().width/2, pwidget:getContentSize().height/2)
	img:addTo(pwidget)
end
--列表选中
function RichRankEntryView:imgzhaocai( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        
    -- --	敬请期待
    -- if send.id == 3006 then
    -- 	G_TipsOfstr(res.str.OPEN_ACT_PRAISE_DESC8)
    -- 	return
    -- end

        if send.lv > cache.Player:getLevel() then 
			local str = string.format(res.str.SYS_OPNE_LV, send.lv)
			G_TipsOfstr(str)
			return 
		end 
        self:setClickedState(send)
        if self.openview then 
        	self.openview:closeSelfView()
        end 

        --文本
     	self.act:setString(res.str.RICH_RANK_DESC2)
        
        if send.id == 3001 then
        	self.openview = mgr.ViewMgr:showView(_viewname.RICHRANK)
        elseif send.id == 3002 then
        	self.openview = mgr.ViewMgr:showView(_viewname.HITEGG)
        elseif send.id == 3003 then
        	self.openview = mgr.ViewMgr:showView(_viewname.PALACE)
         elseif send.id == 3004 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACT2CHARGECOUNT)
        elseif send.id == 3005 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACT2CHARGESINGLE)
        elseif send.id == 3006 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACT2SIGN)
        elseif send.id == 3007 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACT2LUCKY)
        elseif send.id == 3008 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACT2MONTHCARD)
        elseif send.id == 4001 then
        	self.zsLab:setString("")
        	self.openview = mgr.ViewMgr:showView(_viewname.CONSUMEGIFT) --消费豪礼
        	local view = mgr.ViewMgr:get(_viewname.CONSUMEGIFT)
			if view then 
				view:hideTitle()
			end
		elseif send.id == 3009 then
			--self.zsLab:setString("")
			--self.openview = mgr.ViewMgr:showView(_viewname.ACTIVE100_1)
			self.zsLab:setString("")
			self.openview = mgr.ViewMgr:showView(_viewname.ACTIVE100_1)
			self.openview:send_116151(3009)
			proxy.Active:send_116151({actId = 3009})
		elseif send.id == 3010 then
			self.zsLab:setString("")
			self.openview = mgr.ViewMgr:showView(_viewname.ACTIVE100_1)
			self.openview:send_116151(3010)
			proxy.Active:send_116151({actId = 3010})
		elseif send.id == 3011 then--幸运大奖
		    --发送幸运大奖请求
		    self.zsLab:setString("")
			proxy.LuckyLottery:sendMessage()
        	self.openview = mgr.ViewMgr:showView(_viewname.AWARDRANK)
       	elseif send.id == 3012 then 
       		proxy.Active:send_116155()
        	self.zsLab:setString("")
        	self.openview = mgr.ViewMgr:showView(_viewname.ACTIVENEWABAG)
        elseif send.id == 3013 then 
        	self.zsLab:setString("")
        	self.openview = mgr.ViewMgr:showView(_viewname.ACTIVITYTIME)
        	self.openview:setData()
      	elseif send.id == 3014 then 
      		proxy.Active:send_116161()
      		self.zsLab:setString("")
      		self.openview = mgr.ViewMgr:showView(_viewname.ACTIVENEWARED)
        end
        
    end
end

function RichRankEntryView:nextStep(id)
	-- body
	for k ,v in pairs(self.ListView:getItems()) do 
		if v.id == id then 
			self:imgzhaocai(v,ccui.TouchEventType.ended)
			return
		end 
	end
	--G_TipsOfstr("该活动已关闭")
	--G_mainView()
	self:imgzhaocai(self.ListView:getItem(0),ccui.TouchEventType.ended)
end

function RichRankEntryView:updateData( timeStr,zsStr )
	self.timeLab:setString(timeStr)
	if zsStr then
		self.zsLab:setString(zsStr)
	end
end

function RichRankEntryView:updateTitleData( titleStr )
	if titleStr then
		self.act:setString(titleStr)
	end
end

function RichRankEntryView:onCloseSelfView(  )
	-- body
	G_mainView()
end


return RichRankEntryView