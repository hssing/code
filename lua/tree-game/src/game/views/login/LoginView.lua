local LoginView=class("LoginView",base.BaseView)
local version = require("src.version")
local gameCommonTool = require("game.utils.GameCommonTool.GameCommonTool")

function LoginView:init()
		--debugprint(os.time({year=2015, month=8, day=19, hour=14,min = 16}))
		self.showtype=view_show_type.UI
		self.view=self:addSelfView()

		local currPanle = self.view:getChildByName("img_choose_01") 
		self.qu = currPanle:getChildByName("text_num_qu")
		self.quname = currPanle:getChildByName("text_name")
		self.qustatue = currPanle:getChildByName("text_statue")
		self.imgstatue = currPanle:getChildByName("Image_2_0")
		self.imgstatue:setVisible(false)
		currPanle:setTouchEnabled(true)
		currPanle:addTouchEventListener(handler(self,self.onTxtChoose))

		self.btnSatart = self.view:getChildByName("Button_start")
		self.btnSatart:addTouchEventListener(handler(self, self.StareGame))

		self.listItemClone = self.view:getChildByName("Button_clone")
		self.clonePanle = self.view:getChildByName("Panel_7")
		self.img_bg_list = self.view:getChildByName("img_bg_list")
		self.img_bg_list:setVisible(false)

		local Button_close_v = self.img_bg_list:getChildByName("Button_close_v")
		Button_close_v:addTouchEventListener(handler(self, self.onBtnClosev))
		--最近
		self.ScrollView_1 = self.img_bg_list:getChildByName("ScrollView_1")
		self.ScrollView_list = self.img_bg_list:getChildByName("ScrollView_1_0")
		--self.ScrollView_list:addTouchEventListener(handler(self, self.onListViewCall))

		local _code_di =  self.view:getChildByName("Panel_Account")
		local ttt = self.view:getChildByName("Panel_Account"):getChildByName("TextField_1_4")
		ttt:setVisible(false)
		self.LableAccount=cc.ui.UIInput.new({
		    image = res.image.TRANSPARENT,
		    x = _code_di:getContentSize().width/2,
		    y = _code_di:getContentSize().height/2,
		    size = cc.size(ttt:getContentSize().width,ttt:getContentSize().height)
		})
		self.LableAccount:setPlaceHolder(res.str.LOGIN_DEC_06)
		self.LableAccount:addTo(_code_di)
		ttt:removeFromParent()
		--调整一下 
		local Sprite_a_1_7 = _code_di:getChildByName("Sprite_a_1_7")
		local Sprite_a_2_9 = _code_di:getChildByName("Sprite_a_2_9")
		Sprite_a_2_9:setPositionX(Sprite_a_1_7:getPositionX()+Sprite_a_1_7:getContentSize().width/2)

    if g_var.platform=="win32" then
        local account=MyUserDefault.getAcount(user_default_keys.GAME_LOGIN_USER_ACCOUNT_KEY)
        g_var.debug_accountId =  account
        if account then
           self.LableAccount:setText(account)
        end
    else
        _code_di:setVisible(false)
    end 

    local lab_version = ccui.Text:create()
    lab_version:setAnchorPoint(cc.p(0,0.5))
    lab_version:setFontName(res.ttf[1])
    lab_version:setFontSize(24)--字体大小
    lab_version:setPosition(5,10)--位置
    lab_version:addTo(self.view)
    lab_version:setColor(cc.c3b(255,255,255))--颜色
    lab_version:setString(tostring(gameCommonTool:getProjectVersion()).."."..version.pkg_version.."."..g_msg_version)

	self:setinit()
    --移动
    self.bg_move = self.view:getChildByName("Panel_2"):getChildByName("Panel_3")
    self:bgMove()

   	self:performWithDelay(function()
					self:playLogo()--永恒动画
    end, 0.1)
    
    self:performWithDelay(function()
				self:playStartGmae()--永恒动画
    end, 0.1)

    --本地记录 --是否有选择登录的
    self.url_list = ""
    self.loginList = MyUserDefault.getAcount(user_default_keys.LAST_LOGIN)
    if self.loginList and self.loginList~="" then 
    	local t = json.decode(self.loginList) 
    	
    	local i = 1
    	for i = 1 , 3 do
    		local num = 0
    		if t[i] then
    			num = t[i].server_id
    		end
    		self.url_list = self.url_list .. "&s"..i.."="..num
    	end
    	print("self.url_list = "..self.url_list)
    end

	--[[local url2 = version.server_list_url_local
	self.loginList = MyUserDefault.getAcount(user_default_keys.LAST_LOGIN)
	local falg = false
	if self.loginList then 
		local t =  json.decode(self.loginList) 
		if t and #t>0 then
			local i = 1
		  	for k , v in pairs(t) do 
		  		url2 = url2.."/"..v.server_id
		  		i = i +1
		  	end
		  	for j = i , 3 do 
		  		url2 = url2.."/"..0
		  	end
		  	falg = true
		end
	end]]--

	local layer=cc.Layer:create()
	self.layer=layer
	self:addChild(layer)
	self:createMouseEvent(layer,handler(self,self.onTouchBegan),handler(self,self.onTouchMoved),handler(self,self.onTouchEnded))


	--http连接
	self.httpConnect = 0
	if falg then 
    	self:xmlHttpRequest()
    else
    	self:xmlHttpRequest()
    end
    self:schedule(self.scheduleFunction,10.0)

    self:initDec()
end

function LoginView:onTouchBegan( touch,event )
	-- body
	--self.touchpos = touch:getLocation()
	 return true
end
function LoginView:onTouchMoved( touch,event )
	-- body
	
end
function LoginView:onTouchEnded( touch,event )
	-- body

	self.touchpos = touch:getLocation()
end

function LoginView:createMouseEvent(layer,onTouchBegan,onTouchMoved,onTouchEnded)--为ScrollView添加按键事件
    local listener = cc.EventListenerTouchOneByOne:create()--创建一个事件侦听器的触摸
     --listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )--注册脚本处理程序
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()--获得获取事件控制器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)--添加场景的优先事件监听器
end

function LoginView:initDec( ... )
	-- body
	self.img_bg_list:getChildByName("Text_14"):setString(res.str.LOGIN_DEC_07)
	self.img_bg_list:getChildByName("Text_14_0"):setString(res.str.LOGIN_DEC_08)
	self.view:getChildByName("img_choose_01") :getChildByName("text_01"):setString(res.str.LOGIN_DEC_09)

end

function LoginView:scheduleFunction()
    if self.httpConnect == 1 then
        self.httpConnect = 0
        self:xmlHttpRequest()
    end
end

---1、登陆获取默认角色时候设置一次，
---2、点击开始游戏的时候设置一次如切换账号或者服务器则重置
function LoginView:_initSoundMgr(play_)
	---初始化音效
	mgr.Sound:init()
  	--登陆背景音乐
    mgr.Sound:playLoginMusic()
end

function LoginView:playLogo()
	local params =  {id=404819, x=display.cx,y=display.height-150,addTo=self.view, playIndex=0}
	if version.platform_id == 202 then
		params.id = 404853
	end
	mgr.effect:playEffect(params)
end

function LoginView:playStartGmae()
	local params =  {id=404821, x=self.btnSatart:getContentSize().width/2,
	y=self.btnSatart:getContentSize().height/2,addTo=self.btnSatart, playIndex=0}
	mgr.effect:playEffect(params)
end

function LoginView:bgMove()
	--local bg1 = display.newSprite(res.image.LOGIN_BG.BOTTOM)
	local bg1 = ccui.ImageView:create(res.image.LOGIN_BG.BOTTOM)
	bg1:setPosition(bg1:getContentSize().width/2,bg1:getContentSize().height/2)
	bg1:addTo(self.bg_move)

	local height = bg1:getContentSize().height

	local bg2 = ccui.ImageView:create(res.image.LOGIN_BG.CENTER) --display.newSprite(res.image.LOGIN_BG.CENTER)
	bg2:setPosition(bg2:getContentSize().width/2,height + bg2:getContentSize().height/2 )
	bg2:addTo(self.bg_move)

	height = height + bg2:getContentSize().height

	local bg3 = ccui.ImageView:create(res.image.LOGIN_BG.TOP)  --display.newSprite(res.image.LOGIN_BG.TOP)
	bg3:setPosition(bg3:getContentSize().width/2,
	height+ bg3:getContentSize().height/2)
	bg3:addTo(self.bg_move)

	height = height + bg3:getContentSize().height


	local a1 = cc.MoveTo:create(18, cc.p(0,display.height-height ))
	self.bg_move:runAction(a1)
end
--xmlhttp
function LoginView:xmlHttpRequest(page)
   -- body
  local request = cc.XMLHttpRequest:new()  	
  local function callback()
  	-- body
  	if request.readyState == 4 and (request.status >= 200 and request.status < 207) then
  		print("xmlhttp 成功"..request.response)
  		self.httpConnect = 2
        self.output = json.decode(request.response,1)
        printt(self.output)
        self:setData()
  	else
  		print("xmlhttp 失败")
  		self.httpConnect = 1
  		G_TipsOfstr(res.str.LOGIN_DEC2)--你的网络不给力啊
  	end 
  end
  local version_ = require("src.version")
  if not page then 
  	self.page = 1
  else
    self.page = page
  end
  local url = version_.server_list_url.."?c="..version_.platform_id ..self.url_list.."&p="..self.page.."&t="..os.time()
  
  --作弊使用
  if g_var.platform_id_bt ~= 0 then
    url = g_var.server_list_url_bt.."?c="..g_var.platform_id_bt..self.url_list.."&p="..self.page.."&t="..os.time()
  end
  print("sendURL"..url)
  request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
  request:open("GET",url)
  request:registerScriptHandler(callback)
  request:send()
  package.loaded[ "src.version" ] = nil
end

---连接http,获取服务器列表
function LoginView:onHTTPRequest()
    local function onRequestFinished(event)
        local ok = (event.name == "completed")
        local request = event.request
        if not ok then
            if event.name == "failed" then
              -- 请求失败，显示错误代码和错误消息
              self.httpConnect = 1
              debugprint(request:getErrorCode(), request:getErrorMessage(),"_____开始重连Http获取服务器！！")
            end
            return
        end
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            return
        end
        -- 请求成功，显示服务端返回的内容
        local response = request:getResponseString()
        self.output = json.decode(response,1)
        self:setData()
        self.httpConnect = 2
        debugprint("_____Http获取服务器成功！！")
    end
    -- 创建一个请求，并以 get 方式发送数据到服务端
    local __version = require("src.version")
  	local __url = __version.server_list_url.."?"..os.time()
    local request = network.createHTTPRequest(onRequestFinished, __url, "GET")
    request:start()
end

function LoginView:setinit()
	-- body
	self.qu:setString("")
	self.quname:setString("")
	self.qustatue:setString("")
end

--选服务器列表
function LoginView:onTxtChoose( send_,eventtype )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
		if self.httpConnect == 1 then
          self.httpConnect = 0
          --self:onHTTPRequest()
          self:xmlHttpRequest()
        elseif not self.Listdata then
          self:xmlHttpRequest()
    	end
		self.img_bg_list:setVisible(true) 
	end
end

function LoginView:onBtnClosev( send_,eventtype )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
		self.img_bg_list:setVisible(false) 
	end
end


function LoginView:getStateString( type )
	-- body
	if type == 2 then 
		return res.str.LOGIN_WEIHU
	elseif type == 1 then 
		return res.str.LOGIN_WEIHU
	else
		--todo
		return res.str.LOGIN_BAOMAN
	end 
end


function LoginView:setListBy( scroll,data  )
	-- body
	--每2个分一组 

	scroll:removeAllChildren()
	local t = {}
	local t1 = {}
	for k ,v in pairs(data) do 
	--for k = 1 , #data do
		--local v = data[k]
		table.insert(t,v)
		if k%2 == 0  then 
			table.insert(t1,clone(t))
			t = {}
		elseif  k == #data then 
			table.insert(t1,clone(t))
		end 
	end 
	if data then 
		for k , j in pairs(t1) do 
			local widget = self.clonePanle:clone()
			ccsize = widget:getContentSize()
			scroll:pushBackCustomItem(widget)
			for i,v in pairs(j) do  
				local item = self.listItemClone:clone()
				item.data = v
				item:addTouchEventListener(handler(self, self.choosscall))

				item:setAnchorPoint(cc.p(0.5,1))
				item:loadTextureNormal(res.btn.LOGIN_BTN[1])

				local qu = item:getChildByName("text_num_qu_7")
				qu:setString(v.area_id..res.str.SYS_DEC5)

				local name = item:getChildByName("text_name_9")
				name:setString(v.name)

				local stat = item:getChildByName("text_statue_11")
				stat:setVisible(false)
				stat:setString(self:getStateString(v.type))
				
				local img = item:getChildByName("Image_2")
				img:loadTexture(res.font.LOGIN_TYPE[v.type+1])

				local posx = i%2 == 0 and  ccsize.width/4*3  or ccsize.width/4
				local ky = checkint(i/2) 
				local posy = ccsize.height  - (ky-1) * item:getContentSize().height

				item:setPosition(posx,posy)
				widget:addChild(item)

				if k ==1 and i == 1 and self.page == 1 then 
					self:choosscall(item,ccui.TouchEventType.ended)
				end
			end 
		end 
		scroll:refreshView()
	end 
end

function LoginView:choosscall(send_,eventtype)
	-- body
	if  eventtype == ccui.TouchEventType.ended then

		local data = send_.data
		local tipsdata = {}
		tipsdata.sure = function( ... )
			-- body
		end
		tipsdata.surestr = res.str.SURE

		if data.type == 3 then 
			tipsdata.richtext =  data.tip_str

			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(tipsdata)
			return 
		elseif data.type == 2 then
			tipsdata.richtext =  data.tip_str
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(tipsdata)
			return 
		end 

		self:setCurrData(data,send_)
	end
end

function LoginView:setCurrData(data,send_)
	-- body
	if send_ and  not tolua.isnull(send_)  then 
		if self.oldbtn and not tolua.isnull(self.oldbtn) then 
			self.oldbtn:loadTextureNormal(res.btn.LOGIN_BTN[1])
			--self.oldbtn:setBright(true)
			--self.oldbtn:setHighlighted(false)
			--self.oldbtn:setTouchEnabled(true)
		end
		--send_:setBright(false)
		--send_:setHighlighted(true)
		--send_:setTouchEnabled(false)
		send_:loadTextureNormal(res.btn.LOGIN_BTN[2])
		self.oldbtn = send_
	end


	self.data = data
	g_var.server_id = data.server_id
	self.qu:setString(data.area_id..res.str.SYS_DEC5)
	self.quname:setString(data.name)
	self.qustatue:setString(self:getStateString(data.type))
	self.qustatue:setVisible(false)
	self.imgstatue:setVisible(true)
	self.imgstatue:loadTexture(res.font.LOGIN_TYPE[data.type+1])
	self:_initSoundMgr(true)
end

--[[function LoginView:initLastLogin( data )
	-- body


	local t = json.decode(self.loginList)
	local lastdata 
	if t and type(t)=="table" and data then --如果有最近登录列表
		for k ,v in pairs(t) do
			local flag = false
			for i , j  in pairs(data) do 
				if tonumber(v.server_id) == tonumber(j.server_id) then --找到相同的
					j.date =v.date 
					v = j 
					flag = true
					break 
				end 
			end 

			if flag then 
				if not lastdata then 
					lastdata = {}
					v.date = os.time()
				end 
				table.insert(lastdata,v)
			end 	
		end 
		self.loginList = json.encode(lastdata and lastdata or "")
		
	else
		if not lastdata then 
			lastdata = {}
		end 
		table.insert(lastdata,data[1])
	end 

	if lastdata then 
		table.sort(lastdata,function( a,b )
			-- body
			if a.date and  b.date then 
				return a.date > b.date
			end 
		end)
		--printt(lastdata)
		self:setListBy(self.ScrollView_1,lastdata)
	end
end--]]

function LoginView:initLastLogin(data_) --封装 对比 最近登录信息
	-- body
	local t = json.decode(self.loginList)
	local function isKey(id)
		-- body
		for k ,v in pairs(t) do 
			if tonumber(v.server_id) == tonumber(id) then 
				return true,v.date
			end
		end
		return false
	end

	--if not lastdata then 
	local 	lastdata = {}
	--end 

	if  self.output.msg.last_list and #self.output.msg.last_list > 0 then 
		for k ,v in pairs(data_) do 
			local v_date = v.date
			local flag , _value = isKey(v.server_id) 
			if flag then --
				v.date = _value
			end
		end 
		table.sort(data_,function( a,b )
			-- body
			return a.date > b.date
		end)

		for k , v in pairs(data_) do 
			table.insert(lastdata,v)
		end
	else
		local last = {} 
		data_.date =  os.time()
		--printt(data_)
		table.insert(lastdata,data_)
	end
	self.loginList = json.encode(lastdata)
	self:setListBy(self.ScrollView_1,lastdata)
end

function LoginView:setData()
	-- body
	if self.page == 1 then --请求的是第一页 需要判断本地列表信息
		self.Listdata = {}

		if self.output.msg.last_list and #self.output.msg.last_list > 0 then
			self:initLastLogin(self.output.msg.last_list)
		else
			self.loginList = "" --清除本地请求过的列表
			local falg = false
			for k , v in pairs(self.output.msg.list) do 
				if v.type == 0 then --新区
					self:initLastLogin(v)
					falg = true
					break
				end
			end
			if not falg then 
				self:initLastLogin(self.output.msg.list[1])
			end

			
		end
	end

	local usedata =  {}
	if self.Listdata then 
		for k , v  in pairs(self.output.msg.list) do 
			local flag = false
			for i , j  in pairs(self.Listdata) do 
				if tonumber(v.server_id) == tonumber(j.server_id) then --找到相同的
					flag = true
					break 
				end 
			end 

			if not flag then 
				table.insert(usedata,v)
			end
		end
	else
		usedata = self.output.msg.list
	end

	

	local t = {}
	local t1 = {}
	for k ,v in pairs(usedata) do --每2个分一组
		table.insert(t,v)
		if k%2 == 0  then 
			table.insert(t1,clone(t))
			t = {}
		elseif  k == #self.output.msg.list then 
			table.insert(t1,clone(t))
		end 
	end 

	--printt(t1)

	if not self.Listdata then --是否有服务器列表信息
		self.Listdata = t1
	else
		for k , v in pairs(t1) do
			table.insert(self.Listdata,v)
		end
	end
	
	self:inittableView()



	--[[local data = self.output.msg[1].list
	if flag then
		self:initLastLogin(data)
		return 
	end

	local t = {}
	local t1 = {}
	for k ,v in pairs(data) do --每2个分一组
		table.insert(t,v)
		if k%2 == 0  then 
			table.insert(t1,clone(t))
			t = {}
		elseif  k == #data then 
			table.insert(t1,clone(t))
		end 
	end 

	if not self.Listdata then --是否有服务器列表信息
		self.Listdata = t1
	else
		for k , v in pairs(t1) do
			table.insert(self.Listdata,v)
		end
	end
	self:inittableView()

	local lastdata 
	if self.loginList == "" then  --如果最近没有登录列表
		lastdata = {}
		local findlist = {}
		local falg = false
		for k , v in pairs(data) do 
			if v.type == 0 then --新区
				table.insert(lastdata,v)
				falg = true
				break
			end
		end
		if not falg then 
			table.insert(lastdata,data)
		end
		if lastdata then 
			table.sort(lastdata,function( a,b )
				-- body
				if a.date and  b.date then 
					return a.date > b.date
				end 
			end)


			self:initLastLogin(lastdata)
		end
	end]]--


	---最近登录
	--[[self.loginList = MyUserDefault.getAcount(user_default_keys.LAST_LOGIN)
	local t =  json.decode(self.loginList) 

	local lastdata = {}
	local listdata = data

	if t and type(t)=="table" and listdata then --如果有最近登录列表里面有

	end]]--

	
--[[
	self.Btnlist = {}
	self.loginList = MyUserDefault.getAcount(user_default_keys.LAST_LOGIN)
	--print("self.loginList = "..self.loginList)
	local t =  json.decode(self.loginList)
	
	local lastdata = {}
	local listdata = self.output.msg[1].list
	if t and type(t)=="table" and listdata then --如果有最近登录列表
		for k ,v in pairs(t) do
			local flag = false
			for i , j  in pairs(listdata) do 
				if tonumber(v.server_id) == tonumber(j.server_id) then --找到相同的
					j.date =v.date 
					v = j 
					flag = true
					break 
				end 
			end 

			if flag then 
				if not lastdata then 
					lastdata = {}
				end 
				table.insert(lastdata,v)
			end 	
		end 
		self.loginList = json.encode(lastdata and lastdata or "")
	end 

	if #lastdata == 0  and listdata and self.page == 1 then --如果没有最近登录的
		lastdata = {}
		local findlist = {}
		local falg = false
		for k , v in pairs(listdata) do 
			--print(v.area_id)
			if v.type == 0 then --新区
				table.insert(lastdata,v)
				falg = true
				break
			end
		end
		if not falg then 
			table.insert(lastdata,listdata[1])
		end
	end 

	--local lastdata = self.output.msg[1].last_list 
	if #lastdata>0 and  self.page == 1 then 
		table.sort(lastdata,function( a,b )
			-- body
			if a.date and  b.date then 
				return a.date > b.date
			end 
		end)
		self:setCurrData(lastdata[1])
		self:setListBy(self.ScrollView_1,lastdata)
		if self.Btnlist[1] then 
			self.Btnlist[1]:setHighlighted(true)
			self.Btnlist[1]:setTouchEnabled(false)
		end
	end 

	
	if listdata then 
		self:setListBy(self.ScrollView_list,listdata)
	end 
]]
end

function LoginView:StareGame( send_,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		if not self.data then
			return 
		end

		--[[if checkint(self.data.notreg ) > 0 then 
			local data = {}
	        data.richtext = res.str.RES_RES_92
	        data.sure = function( ... )
	            -- body
	           mgr.NetMgr:_backToLogin()
	           mgr.NetMgr:close()
	        end
	        data.surestr = res.str.SURE
	        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
			return 
		end]]--


		local data = self.data
		local tipsdata = {}
  		tipsdata.sure = function( ... )
  		end
  		tipsdata.surestr = res.str.SURE


  		if self.data.type == 3 then 
    			if self.data.open_time<os.time() then --时间到了请求一次
    				  self:xmlHttpRequest()
    			end
    			tipsdata.richtext =  data.tip_str
    			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(tipsdata)
    			return 
  		elseif self.data.type == 2 then
    			tipsdata.richtext = data.tip_str
    			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(tipsdata)
    			return 
  		end
    	self.bg_move:stopAllActions()
		self:logIn()
		  --初始化设置--锁屏
		  local lockKey = g_var.debug_accountId .. "_" .. user_default_keys.SCREEN_LOCK
		  local lock = MyUserDefault.getIntegerForKey(lockKey)
  		if lock and lock == 2 then
  		    sdk:setWakeLock(0)
  		else
          sdk:setWakeLock(1)
  		end

  		--主界面是否显示红包
  		local key = g_var.debug_accountId .. "_" ..user_default_keys.REDBAG_SHOW
  		local str = MyUserDefault.getStringForKey(key)
  		cache.Player:setShowRedBag(str)
	end
end



function LoginView:logInCallBack( send_,eventtype)
	if  eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
		if self:userAccountLawful() then
			if self:userPasswordLawful() then
				self:logIn()
			else
				debugprint("登陆失败！")
			end
		else
			debugprint("登陆失败！")
		end	
	end
end


--验证账号 
function LoginView:userAccountLawful(  )
	local account=self.LableAccount:getText()
	if not account or account == "" then
			return false
		end
	return true
end

--验证密码
function LoginView:userPasswordLawful(  )
	return true
end

--登陆
function LoginView:logIn()
		---	无服务器信息
		if self.data == nil then return end
		---登陆
	  if self.data ~= nil then
		    g_var.server_id = self.data.server_id
		    local str = string.split(self.data.server,":")
		    g_var.debug_ip = str[1]
		    g_var.debug_port = str[2]
		    g_var.debug_name = self.data.name
	  end
    --在调试模式才有用
	  if g_var.platform == "win32" then 
	  	  g_var.debug_accountId = self.LableAccount:getText()
        MyUserDefault.setAcount(user_default_keys.GAME_LOGIN_USER_ACCOUNT_KEY,g_var.debug_accountId)
	 	end
 	  --保存最近选的服务器
 	  local t = json.decode(self.loginList)
 	 -- printt(t)

   	if t and type(t) == "table" then 
    	 	local flag = false
    	 	for k , v in pairs (t) do 
      	 		if tonumber(v.server_id) == tonumber(self.data.server_id) then 
        	 			v.date =  os.time()
        	 			v = self.data
        	 			flag = true
        	 			break;
      	 		end 
    	 	end
    	 	if not flag then 
    	 		table.sort( t, function( a,b )
    	 			-- body
    	 			return a.date>b.date
    	 		end )

      	 		if #t>=3 then --只保留3条
      	 			table.remove(t,#t)
      	 		end 
      	 		self.data.date = os.time()
      	 		table.insert(t,self.data)
      	 		--printt(t)
    	 	end 
  	else
    		t = {}
    		self.data.date = os.time()
    		table.insert(t,self.data)
  	end
 		local j = json.encode(t)
 		MyUserDefault.setAcount(user_default_keys.LAST_LOGIN,j)
    if g_var.platform=="win32" then
        sdk:_login()
    else
        sdk:loginGame()
    end
    
    ----初始化声音
    self:_initSoundMgr(false)
end


function LoginView:resCreateRole()
	mgr.SceneMgr:LoadingScene(_scenename.ROLE)
	--mgr.ViewMgr:showView(_viewname.CREATE_ROLE)
	--mgr.ViewMgr:closeView(_viewname.LOGIN)
end

function LoginView:onCloseSelfView()
	-- body
	--mgr.BoneLoad:removeArmatureFileInfo(404819)
	--mgr.BoneLoad:removeArmatureFileInfo(404821)
	
	self:closeSelfView()
end
--------------------------服务器列表多的时候------------------------------------------------------------------
function LoginView:numberOfCellsInTableView(table)
	-- body
	local size=#self.Listdata
    return size
end

function LoginView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function LoginView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function LoginView:tableCellTouched(table,cell)
	--printt(self.touchpos)
	--print(self.touchpos.x..","..self.touchpos.y)
    print("cell touched at index: " .. cell:getIdx())

    local widget = cell:getChildByName("widget")
    widget:BtnChoos(self.touchpos)
end

function LoginView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanle:getContentSize()    
    return ccsize.height,ccsize.width
end

function LoginView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local data =  self.Listdata[idx+1]
    local widget

    if nil == cell then
        cell = cc.TableViewCell:new()
       	widget=CreateClass("views.login.loginItem")
       	widget:init(self)
        widget:setData(data,idx)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	--print("idx = "..idx)
    	widget = cell:getChildByName("widget")
        widget:setData(data,idx)
    end

    if idx + 2>#self.Listdata then 
    	self.idx = idx
    	if self.page+1 >  self.output.msg.pageTotal then
			--print("back") 
			--return 
		else
			self.page = self.page +1 
			print("请求页数"..self.page)
			self:xmlHttpRequest(self.page)
		end
		
    end 

    return cell
end

function LoginView:getClone()
	-- body
	return self.clonePanle:clone()
end

function LoginView:getCloneBtn( ... )
	-- body
	return self.listItemClone:clone()
end

function LoginView:inittableView()
	-- body
	if not self.tableView then 
		--self.ScrollView_list
		local posx ,posy = self.ScrollView_list:getPosition()
		local ccsize =  self.ScrollView_list:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.img_bg_list:addChild(self.tableView,100)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView:reloadData()
	else
		self.tableView:reloadData()
	end 

	if self.idx then 
		local num = math.ceil(self.ScrollView_list:getContentSize().height/self.clonePanle:getContentSize().height)
		if  self.idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.idx+1) * self.clonePanle:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		self.tableView:setContentOffset(offset)
	end 
end



return LoginView