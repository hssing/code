--[[
	活动主入口
]]
local ActiveView=class("ActiveView",base.BaseView)
local _rootPath ="res/itemicon/"

function ActiveView:ctor( ... )
	-- body
	self.openview = nil
end

function ActiveView:init()
	-- body
	self.showtype=view_show_type.TIPS
	self.ShowAll= true
	self.view=self:addSelfView()

	self.ListGUIButton = {}

	self.ListView= self.view:getChildByName("Panel_4"):getChildByName("ListView_1")
	self.clonepanel = self.view:getChildByName("Image_10")

	
	--self:initListView()
	--self:setSwitch()

	--[[local view = mgr.ViewMgr:createView(_viewname.HEAD)
    if view then 
        view:closeSelfView()
    end ]]--

   self:performWithDelay(function()
		--预加载动画到内存
		local effConfig = conf.Effect:getInfoById(404835)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)
	end,0.1)
end


------------设置红点
function ActiveView:setRedPoint(  )
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
        elseif send.id == 1008 then--回归大礼
        elseif send.id == 1009 then--邀请码
        elseif send.id == 1010 then--公会挣榜
        elseif send.id == 1011 then--进化神殿
        elseif send.id == 1012 then--土豪点赞
        	self.ListGUIButton[i]:setNumber(cache.Player:getOpenActPraiseNumber())
        elseif send.id == 1013 then --什么鬼月卡活动
        	if self.ListGUIButton[i] and cache.Player:getMonth()~=3 then
        		self.ListGUIButton[i]:setNumber(cache.Player:getMonth())
        	end
        elseif send.id == 1014 then --VIP商店
        elseif send.id == 1015 then --天天豪礼
        	self.ListGUIButton[i]:setNumber(cache.Player:getTthlRedpoint())
       	elseif send.id == 4001 then --消费豪礼
       		self.ListGUIButton[i]:setNumber(cache.Player:getXfhlRedpoint())
       	elseif send.id == 1018 then --7星好礼 --
       		if cache.Player:get100() == 2 then --7星豪礼1开关默认关闭1开启,2有东西可领取,3领取完,4领取完过了一天
       			self.ListGUIButton[i]:setNumber(1)
       		else
       			self.ListGUIButton[i]:setNumber(0)
       		end
       	elseif send.id == 1019 then 
       		
        end
	end

end

function ActiveView:setSwitch( data )
	self:setData()
	local newData = {}
	local acts = data.acts
	for k,v in pairs(self.data) do
		if acts and table.nums(acts) > 0 and acts[v.id .. ""] and acts[v.id .. ""] ~= 0 then
			self.data[k].on_off = acts[v.id .. ""]
		end
	end
	--dump(self.data)
	self:initListView()
	self:setRedPoint()
end

function ActiveView:setData()
	-- body
	local data = conf.active:getallactive()
	local datatmp = {}
	for i,v in ipairs(data) do
		if v["actType"] == 1 or v["actType"] == 4 then
			if tonumber(v.id) == 1013 then
				if cache.Player:getMonth()~=3 then
					table.insert(datatmp,v)
				end
			elseif tonumber(v.id) == 1016 or tonumber(v.id) == 1017  then --这两个游戏王 益玩才有
				--todo
			elseif tonumber(v.id) == 1018 then  --7星好礼
				if cache.Player:get100() == 1 or cache.Player:get100() == 2 or cache.Player:get100() == 3 then 
					table.insert(datatmp,v)
				end
			--elseif tonumber(v.id) == 1019 then  --天讲砖石 --不给看
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
end

function ActiveView:initListView()
	self.ListView:setItemsMargin(5)

	--for i=1,table.nums(self.data) do
	for k , v in pairs(self.data) do 

		--local v = self.data[(i+1000)..""]
		if  v.on_off == 1 then
			local widget = self.clonepanel:clone()
			widget:setSwallowTouches(false)
			--widget:setPressedActionEnabled(false)
			--widget:setScale9Enabled(false)
			local gui_btn=gui.GUIButton.new(widget,nil,{ImagePath=res.image.RED_PONT,x=15,y=15})
			gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放
			self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
			local lab_name = widget:getChildByName("Text_1")
			lab_name:setString(v.name)

			local spr_head = widget:getChildByName("Image_11")
			spr_head:ignoreContentAdaptWithSize(true)
			spr_head:loadTexture(_rootPath..v.src..".png")

			widget.lv = v.lv --开启等级
			widget.id = v.id
			widget.index = k

			widget:loadTextureNormal(res.btn.FRAME[v.color])
			--widget:loadTexture(res.btn.FRAME[v.color])
			widget:setTouchEnabled(true)
			widget:addTouchEventListener(handler(self,self.imgzhaocai))
			self.ListView:pushBackCustomItem(widget)
		end
	end 

	if not self.openview then 
		--self:imgzhaocai(self.ListView:getItem(0),ccui.TouchEventType.ended)
	end 
end 

----------黄胜----选中状态
function ActiveView:setClickedState(pwidget)
	for i=1,#self.ListGUIButton do
		local btn = self.ListGUIButton[i]:getInstance()
		local v = self.data[btn.index]
		btn:setEnabled(true)
		btn:loadTextureNormal(res.btn.FRAME[v.color])

		if btn:getChildByName("effofname") then 
			btn:getChildByName("effofname"):removeSelf()
		end 
	end

	local params =  {id=404835, x =pwidget:getContentSize().width/2,
	y = pwidget:getContentSize().height/2,addTo = pwidget,addName = "effofname"}
	mgr.effect:playEffect(params)

	pwidget:setEnabled(false)
	pwidget:loadTextureNormal(res.btn.SELECT_BTN)

end



--添加选中状态
function ActiveView:cleanstatue(pwidget)
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
function ActiveView:imgzhaocai( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        --self:cleanstatue(send)
        if send.lv > cache.Player:getLevel() then 
			local str = string.format(res.str.SYS_OPNE_LV, send.lv)
			G_TipsOfstr(str)
			return 
		end 
        self:setClickedState(send)
        if self.openview then 
        	self.openview:closeSelfView()
        end 
        print(send.id)
        if send.id == 1001 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACTIVITYZHAOCAI)
        elseif send.id == 1002 then
        	self.openview = mgr.ViewMgr:showView(_viewname.EATCHICKEN)  --吃鸡
        elseif send.id == 1003 then
        	self.openview = mgr.ViewMgr:showView(_viewname.LEVELBIGIFT)---等级豪礼
        elseif send.id == 1004 then
        	self.openview = mgr.ViewMgr:showView(_viewname.GIFTPACKCODE)---礼包码
        elseif send.id == 1005 then
        	self.openview = mgr.ViewMgr:showView(_viewname.CHARGEPERDAY)---每日充值
        elseif send.id == 1006 then
        	self.openview = mgr.ViewMgr:showView(_viewname.CRAZYFEEDBACK)---疯狂回馈
        elseif send.id == 1007 then
        	self.openview = mgr.ViewMgr:showView(_viewname.CHARGECOUNT)---累计充值
        elseif send.id == 1008 then
        	self.openview = mgr.ViewMgr:showView(_viewname.COMEBACK)---回归大礼
        elseif send.id == 1009 then
        	self.openview = mgr.ViewMgr:showView(_viewname.INVITATEFRIEND)------邀请码
        elseif send.id == 1010 then
        	self.openview = mgr.ViewMgr:showView(_viewname.CMPRANK)------公会挣榜
		elseif send.id == 1011 then
        	self.openview = mgr.ViewMgr:showView(_viewname.OPENACTPALACE)-----进化神殿
        elseif send.id == 1012 then
        	self.openview = mgr.ViewMgr:showView(_viewname.OPENACTPRAISE)------全民土豪
       	elseif send.id == 1013 then
       		self.openview = mgr.ViewMgr:showView(_viewname.ACTIVEMONTH) --月卡
       	elseif send.id == 1014 then
       		self.openview = mgr.ViewMgr:showView(_viewname.ACTIVEVIPSHOP) --VIP商店
       	elseif send.id == 1015 then 
       		self.openview = mgr.ViewMgr:showView(_viewname.EVERYDAYGIFT) --天天豪礼
        elseif send.id == 4001 then 
        	self.openview = mgr.ViewMgr:showView(_viewname.CONSUMEGIFT) --消费豪礼
        elseif send.id == 1018 then
        	self.openview = mgr.ViewMgr:showView(_viewname.ACTIVE100) --7星好礼
        elseif send.id == 1019 then 
        	self.openview = mgr.ViewMgr:showView(_viewname.ACTIVETIANZS) --天降砖石
        end
    
    end
end

function ActiveView:nextStep(id)
	-- body
	for k ,v in pairs(self.ListView:getItems()) do 

		if v.id == id then 
			self:imgzhaocai(v,ccui.TouchEventType.ended)
			return
		end 
	end
	--G_TipsOfstr("该活动已关闭")
	self:imgzhaocai(self.ListView:getItem(0),ccui.TouchEventType.ended)
end



return ActiveView