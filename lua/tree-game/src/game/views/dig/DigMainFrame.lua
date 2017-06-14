--[[
DigMainFrame 挖矿主页面 --可以查看别人的界面
--]]

local  DigMainFrame = class("DigMainFrame", base.BaseView)


function DigMainFrame:ctor()
	-- body
	self.data = {} --挖矿数据
	self.isself = true --是否是自己的界面
	self.armature = nil --切换动画
end

function DigMainFrame:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_1")
	self.view:reorderChild(panle, 10000)

	local btn_back = panle:getChildByName("btn_back")
	btn_back:addTouchEventListener(handler(self,self.onBtnFriendCallBack)) --回到自己
	self.btn_back = btn_back --

	local btn_friend = panle:getChildByName("btn_friend")
	btn_friend:addTouchEventListener(handler(self,self.onBtnSeeFriendData))
	self.btn_friend = btn_friend

	local btn_close = self.view:getChildByName("Button_close") 
	btn_close:addTouchEventListener(handler(self, self.onBtnCloseView))

	self.img = panle:getChildByName("Image_15")
	self.oldpos =self.img:getPositionX()
	self.lab_help = self.img:getChildByName("Text_1")
	self.lab_help:setString("")
	G_FitScreen(self,"Image_1")
	---加载一个切换动画
	self:preload()
	--7个岛
	self.img_kuang = {}
	local bg = self.view:getChildByName("Image_1")
	local _p1 = bg:getChildByName("Panel_2")
	_p1.daoId = 1
	table.insert(self.img_kuang,_p1)

	local _p2 = bg:getChildByName("Panel_2_0")
	_p2.daoId = 2
	table.insert(self.img_kuang,_p2)

	local _p3 = bg:getChildByName("Panel_2_0_0")
	_p3.daoId = 6
	table.insert(self.img_kuang,_p3)

	local _p5 = bg:getChildByName("Panel_2_0_0_0_0")
	_p5.daoId = 3
	table.insert(self.img_kuang,_p5)

	local _p6 = bg:getChildByName("Panel_2_0_0_0_0_0")
	_p6.daoId = 5
	table.insert(self.img_kuang,_p6)

	local _p7 = bg:getChildByName("Panel_2_0_0_0_0_0_0")
	_p7.daoId = 4
	table.insert(self.img_kuang,_p7)

	table.sort(self.img_kuang,function( a,b )
		-- body
		return a.daoId<b.daoId
	end)

	self.panle_1 = bg:getChildByName("Panel_2_1")

	for k , v in pairs(self.img_kuang) do 
		if k == 1 then 
			self.panle_1:addTouchEventListener(handler(self,self.onimgCallBack))
		end 
		v:addTouchEventListener(handler(self,self.onimgCallBack))
	end 
	--每个岛
	self.cloneitem = self.view:getChildByName("Panel_12")
	self.cloneitem:setVisible(false)
	--谁谁的文件岛
	local img_di = self.view:getChildByName("Image_59")
	img_di:setPosition(img_di:getPositionX()+0, img_di:getPositionY()+0) --位置

	self.lab_name = img_di:getChildByName("Text_3")
	self.lab_name:setPosition(img_di:getContentSize().width/2,img_di:getContentSize().height/2)
	

	--------------------------------抢夺---------------
	self.btn_qd = panle:getChildByName("btn_back_0") --抢夺
	self.btn_qd:addTouchEventListener(handler(self, self.onbtnQdCallBack))

	self.btn_next =panle:getChildByName("btn_back_0_0")--下一个
	self.btn_next:addTouchEventListener(handler(self,self.onbtnNextCallBack))

	self.btn_search = panle:getChildByName("btn_back_0_0_0")--搜索
	self.btn_search:addTouchEventListener(handler(self,self.onbtnSearchCallBack))

	self.btn_compare = panle:getChildByName("btn_back_1") --对比
	self.btn_compare:ignoreContentAdaptWithSize(true)
	self.btn_compare:addTouchEventListener(handler(self,self.onBtnComposeCallback))

	self.gui_btn1=gui.GUIButton.new(self.btn_friend,nil,{ImagePath=res.image.RED_PONT,x=10,y=10}) 
	self.gui_btn2=gui.GUIButton.new(self.btn_qd,nil,{ImagePath=res.image.RED_PONT,x=10,y=10}) 
	self.gui_btn3=gui.GUIButton.new(self.btn_compare,nil,{ImagePath=res.image.RED_PONT,x=10,y=10}) 
	self:initData()
	self:playerForever()

	self.first = MyUserDefault.getStringForKey(user_default_keys.DIG_FRIST)
	--print(self.first)
	if self.first ~= "false"  then 
		if cache.Player:getLevel()>32 then 
			self.first = "false"
			MyUserDefault.setStringForKey(user_default_keys.DIG_FRIST,self.first)
		else
			self:performWithDelay(function()
				self:setOnlyFirger() --手指动画
			end, 0.2)
		end
    end 

	self:schedule(self.changeTimes,1.0,"changeTimes")


	local scene =  mgr.SceneMgr:getMainScene()
        if scene then 
            scene:addHeadView()
        end
	--界面文本
	


end

function DigMainFrame:setOnlyFirger()
	-- body
	  --动画播放期间 不给点击
    local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(0)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    --addto:addChild(layer,100) 
    mgr.SceneMgr:getNowShowScene():addChild(layer)

    self.layer = layer

    local pos = self.img_kuang[1]:getWorldPosition()
	local params =  {id=404816, x=pos.x + self.img_kuang[1]:getContentSize().width/2-20 ,
	y=pos.y + self.img_kuang[1]:getContentSize().height/2+50,addTo=layer, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)

	local data = {state = 0}
	local panle = self.img_kuang[1]:clone()
	--panle:removeAllChildren()
	panle:setPosition(pos)
	panle:addTo(layer)
	panle.daoId = 1
	panle.data = data
	panle:setTag(1)
	panle:addTouchEventListener(handler(self,self.onimgCallBack))

	self.layer_panel = panle
end
function DigMainFrame:setBtnPos(pos)
	-- body
	if pos == 1 then
		self.btn_compare:setPositionX(self.btn_friend:getPositionX())
	else
		self.btn_compare:setPositionX(self.btn_qd:getPositionX())
	end
end

--根据抢夺界面隐藏按钮
function DigMainFrame:setVisBy(falg)
	-- body
	if not falg then 
		self.btn_qd:setVisible(true)
		self.btn_next:setVisible(false)
		self.btn_search:setVisible(false)
		self.btn_compare:setVisible(false)
		--
		self.btn_back:setVisible(true)
		self.btn_friend:setVisible(true)
		self.btn_back:setVisible(false)

		if not self.isself then  --在好友界面才需要返回
			self.btn_back:setVisible(true)
		else
			--todo	 --在自己的界面要打开复仇列表
			self.btn_compare:setVisible(false)
			self.btn_compare:loadTextureNormal(res.btn.DIG_FUCHOU) --fuchou
			self.btn_compare:setVisible(cache.Dig:isBqd())
			self.btn_compare:addTouchEventListener(handler(self,self.onBtnFuChouCallBack))

			--设置复仇按钮的位置 1 右 -1 左
			self:setBtnPos(-1)
		end

		self.img:setPositionX(self.oldpos - 30)

		self.btn_back:loadTextureNormal(res.btn.DIG_BACK)
		self.btn_back:addTouchEventListener(handler(self,self.onBtnFriendCallBack))

		self.btn_friend:loadTextureNormal(res.btn.DIG_FEIEND)
		self.btn_friend:addTouchEventListener(handler(self,self.onBtnSeeFriendData))

		--self.btn_friend:addTouchEventListener(handler(self,self.onBtnFriendCallBack))
	else
		self.img:setPositionX(self.oldpos)
		self.btn_qd:setVisible(false)
		self.btn_next:setVisible(true)
		self.btn_search:setVisible(true)
		self.btn_compare:setVisible(true)
		--对比
		self.btn_compare:loadTextureNormal(res.btn.DIG_COMPARE)
		--self.btn_compare:setTitleText(res.str.DIG_DEC43)
		self.btn_compare:addTouchEventListener(handler(self,self.onBtnComposeCallback))

		--设置阵容对按钮的位置 1 右 -1 左
		self:setBtnPos(-1)
		--
		self.btn_back:setVisible(false)
		self.btn_friend:loadTextureNormal(res.btn.DIG_BACK)
		self.btn_friend:setVisible(true)
		self.btn_friend:addTouchEventListener(handler(self,self.onBtnFriendCallBack))
	end
end

function DigMainFrame:initData()
	-- body
	--每天可抢夺次数
	self.sqmax = conf.Sys:getValue("player_day_qd_max")
	--岛列表可被抢夺次数
	self.listqdCount = conf.Sys:getValue("dao_qd_max")
	--可助阵次数
	self.cheeMaxCout = conf.Sys:getValue("player_day_confirm_max")


	for i = 1 , 6 do 
		if self["img"..i] then 
			self["img1"]:removeAllChildren()
		end
	end 

	local bg = self.view:getChildByName("Image_1")
	local img1 = bg:getChildByName("Image_2")
	self["img1"] = img1
	local spr = display.newGraySprite(res.image.DAO[1])
	spr:setPosition(img1:getContentSize().width/2,img1:getContentSize().height/2)
	spr:addTo(img1)



	local img2 = bg:getChildByName("Image_2_0")
	local spr = display.newGraySprite(res.image.DAO[2])
	spr:setPosition(img2:getContentSize().width/2,img2:getContentSize().height/2)
	spr:addTo(img2)
	self["img2"] = img2

	local img3 = bg:getChildByName("Image_2_0_0_0")
	local spr = display.newGraySprite(res.image.DAO[3])
	spr:setPosition(img3:getContentSize().width/2,img3:getContentSize().height/2)
	spr:addTo(img3)
	self["img6"] = img3

	local img5 = bg:getChildByName("Image_2_0_0_1_0")
	local spr = display.newGraySprite(res.image.DAO[5])
	spr:setPosition(img5:getContentSize().width/2,img5:getContentSize().height/2)
	spr:addTo(img5)
	self["img3"] = img5

	local img6 = bg:getChildByName("Image_2_0_0_1")
	local spr = display.newGraySprite(res.image.DAO[6])
	spr:setPosition(img6:getContentSize().width/2,img6:getContentSize().height/2)
	spr:addTo(img6)
	self["img5"] = img6

	local img7 = bg:getChildByName("Image_2_0_0_1_0_0")
	local spr = display.newGraySprite(res.image.DAO[7])
	spr:setPosition(img7:getContentSize().width/2,img7:getContentSize().height/2)
	spr:addTo(img7)
	self["img4"] = img7

	self:addSuo()
end



--离子动画
function DigMainFrame:playerForever()
	-- body
	local armature = mgr.BoneLoad:loadArmature(404826,4)
	armature:setPosition(display.cx,display.cy)
	armature:addTo(self.view)
end
--添加锁状态
function DigMainFrame:addSuo()
	-- body
	for i = 1 , 6 do 
		if self["name"..i] then 
			self["name"..i]:removeFromParent()
			self["name"..i] = nil 
		end 

		local img_suo = ccui.ImageView:create() --display.newSprite(res.other.SUO)
		img_suo:loadTexture(res.other.SUO)
		--偏移位置
		local x = 0 
		local y = 0
		if i == 1 then 
			x = 0
			y = 0
		elseif i == 2 then 
			x = 0
			y = 0
		elseif i == 3 then
			x = -10
			y = 75
		elseif i == 4 then  
			x = 0
			y = 40
		elseif i == 5 then
			x = 10
			y = 45
		else
			x = 54
			y = 75
		end  
		img_suo:setPosition(self["img"..i]:getContentSize().width/2+x,
			self["img"..i]:getContentSize().height/2+y)

		img_suo:addTo(self["img"..i])

		--岛名字
		local spr = display.newSprite(res.font.DIG_DAO[i])
		spr:setPosition(img_suo:getWorldPosition())
		spr:setScale(0.7)
		x = 0
		y = 0
		if i == 1 then 
			x = -23
			y = -34
		elseif i == 2 then 
			x = -15
			y = -20
		elseif i == 3 then
			x = 0
			y = -70
		elseif i == 4 then  
			x = 0
			y = -55
		elseif i == 5 then
			x = 0
			y = -84
		else
			x = 0
			y = -70
		end  

		spr:setPositionX(spr:getPositionX()+x) --x 便宜
		spr:setPositionY(spr:getPositionY()+y) --y
		spr:addTo(self.view)
		self["name"..i] = spr
	end  
end
--切换动画
function DigMainFrame:preload()
	-- body
	local armature =mgr.BoneLoad:createArmature(404827)
	armature:setPositionX(display.cx)
	armature:setPositionY(display.cy)
	armature:addTo(self)
	armature:setVisible(false)

	armature:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            armature:setVisible(false)
        end
    end)

	self.armature = armature
end

function DigMainFrame:setRedPoint(count,count2)
	-- body
	self.gui_btn1:setNumber(0)
	--self.gui_btn2:setNumber(0)
	self.gui_btn3:setNumber(0)
	if self.isself then 
		self.gui_btn1:setNumber(count)
		if cache.Player:getDigFuchou() and count2 > 0  then 

			self.gui_btn3:setNumber(count2)
		end
	end
	self.gui_btn2:setNumber(count2)
end

--在好友界面救援后
function DigMainFrame:updateCount()
	-- body
	--可帮次数
	local count = cache.Dig:getHelpCount()
	local count2 = cache.Dig:getQdCount()
	local count3 = cache.Dig:getCheerCount()
	self.lab_help:setString(string.format(res.str.DIG_DEC11,count,self.sqmax-count2,self.cheeMaxCout - count3))
	self:setRedPoint(count,self.sqmax-count2)
end

--每一个开启的岛
function DigMainFrame:initItem( data )
	-- body
	if self["huo"..data.daoId] then 
		self["huo"..data.daoId]:removeFromParent()
		self["huo"..data.daoId] = nil 
	end 
	if self["fight"..data.daoId] then 
		self["fight"..data.daoId]:removeFromParent()
		self["fight"..data.daoId] = nil 
	end 
	if self["jia"..data.daoId] then 
		self["jia"..data.daoId]:removeFromParent()
		self["jia"..data.daoId] = nil 
	end 
	if self["boos"..data.daoId] then 
		self["boos"..data.daoId]:removeFromParent()
		self["boos"..data.daoId] = nil 
	end 

	if self["item"..data.daoId] then 
		self["item"..data.daoId]:removeFromParent()
		self["item"..data.daoId] = nil 
	end 

	self["img"..data.daoId]:removeAllChildren()
	local widget= self.img_kuang[data.daoId]
	widget:setTag(data.daoId)
	widget:removeAllChildren()
	widget.data = data

	if data.daoId == 1 then 
		self.panle_1:setTag(data.daoId)
		self.panle_1.data = data
	end 

	local pos = self["img"..data.daoId]:getWorldPosition()
	local item = self.cloneitem:clone()
	item:setAnchorPoint(cc.p(0.5,0.5))
	item:setVisible(true)
	item:setPosition(pos)
	item:addTo(self.view,100)

	
	self["item"..data.daoId] = item
	---位置偏移
	local offx = 0
	local offy = 0 
	local k = data.daoId
	if k == 1 then 
		offx = -15 
		offy = -40
	elseif k == 2 then 
		offx = -15 
		offy = -10
	elseif k == 3 then 
		offx = 0 
		offy = -5
	elseif k == 4 then 
		offx = 0 
		offy = -31
	elseif k == 5 then 
		offx = 10 
		offy = -35
	elseif k == 6 then 
		offx = 20 
		offy = -25
	else
		offx = 0 
		offy = 0
	end 
	item:setPositionX(item:getPositionX()+offx)
	item:setPositionY(item:getPositionY()+offy)
	--
	

	--倒计时
	self["lab_"..data.daoId] = item:getChildByName("Text_2")
	self["lab_"..data.daoId]:setColor(cc.c3b(113,66,45))

 	--星星
 	local start_panle = item:getChildByName("Panel_13") 
 	self["start_panle"..data.daoId] = start_panle
 	if data.mId~=0 then 
	 	local colorlv = conf.Item:getItemQuality(data.mId)
	 	for i = 1 , colorlv do 
	 		local sprite=display.newSprite(res.image.STAR)
	 		sprite:setPositionX(sprite:getContentSize().width*(i-0.5))
	 		sprite:setPositionY(start_panle:getContentSize().height/2)
	 		sprite:addTo(start_panle)
	 	end 

	 	local arg = conf.Item:getArg1(data.mId)
	 	local mId =arg.arg5
	 	local json = res.image.GOLD
	 	if mId == 221051003 then 
	 		json = res.image.BADGE
	 	elseif mId == 221051002 then 
	 		json = res.image.ZS
	 	else

	 	end 
	 	local _img_ = item:getChildByName("Image_17") 
	 	_img_:loadTexture(json)

	end
	--着火
 	if data.state== 11 or data.state== 12 or data.state== 13 or data.state== 14 then 
 		if not self["huo"..data.daoId] then 
			self["huo"..data.daoId] =  mgr.BoneLoad:loadArmature(404839,0)
			local pos = self["img"..data.daoId]:getWorldPosition()
			self["huo"..data.daoId]:setPosition(pos)

			--火的位置
			if k == 1 then 
				offx = 0 
				offy = 0
			elseif k == 2 then 
				offx = -10 
				offy = 30
			elseif k == 3 then 
				offx = -10 
				offy = 30
			elseif k == 4 then 
				offx = 0 
				offy = 0
			elseif k == 5 then 
				offx = 10 
				offy = 0
			elseif k == 6 then 
				offx = 50
				offy = 0
			else
				offx = 0 
				offy = 0
			end 
			self["huo"..data.daoId]:setPositionX(pos.x+offx)
			self["huo"..data.daoId]:setPositionY(pos.y+offy)

			self["huo"..data.daoId]:addTo(self.view,99)
		end

		local b = { ["11"] = 404844,["12"] = 404842,["13"] = 404845,["14"] =  404843}
		if not self["boos"..data.daoId] then 
			self["boos"..data.daoId] =  mgr.BoneLoad:loadArmature(b[tostring(data.state)],1)
			local pos = self["img"..data.daoId]:getWorldPosition()
			self["boos"..data.daoId]:setPosition(pos.x,pos.y)
			self["boos"..data.daoId]:addTo(self.view,101)
			
			--捣乱的数码兽位置
			if k == 1 then 
				offx = 0 
				offy = 50
			elseif k == 2 then 
				offx = 0 
				offy = 100
			elseif k == 3 then 
				offx = 0 
				offy = 100
			elseif k == 4 then 
				offx = 10 
				offy = 60
			elseif k == 5 then 
				offx = 10 
				offy = 65
			elseif k == 6 then 
				offx = 65 
				offy = 95
			else
				offx = 0 
				offy = 0
			end 
			self["boos"..data.daoId]:setPositionX(self["boos"..data.daoId]:getPositionX()+offx)
			self["boos"..data.daoId]:setPositionY(self["boos"..data.daoId]:getPositionY()+offy)

		end 
	else
		if self["huo"..data.daoId] then 
			self["huo"..data.daoId]:removeFromParent()
			self["huo"..data.daoId] = nil 
		end 

		if self["boos"..data.daoId] then 
			self["boos"..data.daoId]:removeFromParent()
			self["boos"..data.daoId] = nil 
		end 
 	end 
 	--这个item 是否显示
 	if data.state == 0 then --可挖矿的时候
 		self["name"..data.daoId]:setVisible(true)
 		item:setVisible(false)
 		if self.isself == true then 
	 		if not self["jia"..data.daoId] then 
	 			--print("是自己的岛")

	 			self["jia"..data.daoId] =  mgr.BoneLoad:loadArmature(404808,0)
				local pos = self["img"..data.daoId]:getWorldPosition()
				self["jia"..data.daoId]:setPosition(pos)
				self["jia"..data.daoId]:addTo(self.view)
	 			--加号位置调整
				local x = 0
				local y = 0
				if data.daoId == 1 then 
					x = -26
					y = 17
				elseif data.daoId == 2 then 
					x = -22
					y = 55
				elseif data.daoId == 3 then
					x = -10
					y = 50
				elseif data.daoId == 4 then  
					x = 0
					y = 35
				elseif data.daoId == 5 then
					x = 10
					y = 35
				else
					x = 51
					y = 65
				end  
	 			self["jia"..data.daoId]:setPositionX(self["jia"..data.daoId]:getPositionX()+x) --x 
	 			self["jia"..data.daoId]:setPositionY(self["jia"..data.daoId]:getPositionY()+y) --y
	 		end 
	 	else
	 		--print("是biren的岛")
	 		if self["jia"..data.daoId] then 
 				self["jia"..data.daoId]:removeFromParent()
 				self["jia"..data.daoId] = nil 
 			end 
	 	end 
 	else
 		self["name"..data.daoId]:setVisible(false)
 		item:setVisible(true)
 		if self["jia"..data.daoId] then 
 			self["jia"..data.daoId]:removeFromParent()
 			self["jia"..data.daoId] = nil 
 		end 
 	end 

 	--救援者的名字
	local lab_name =  item:getChildByName("Image_3")
	lab_name:setVisible(false)
	--lab_name:setString(res.str.DEC_ERR_21)
	--if self.type > 1  then
	
		if data.cheerName and  data.cheerName ~= "" then 
			lab_name:getChildByName("Text_4"):setString(string.format(res.str.DIG_DEC60,data.cheerName))
			lab_name:setVisible(true)
		end
		if self.type > 1 then 
			self["lab_"..data.daoId]:setString(string.format(res.str.DIG_DEC61,data.atkAward))
			if self:isOver(data,data.daoId) then
				self["lab_"..data.daoId]:setString(res.str.DEC_ERR_03)
			end
		end
	--end
end
--时间
function DigMainFrame:changeTimes()
	-- body
	if self.type > 1 then 
		return 
	end
	if not self.isself  then 
		if self.data.wkList then 
			for k , v in pairs(self.data.wkList) do
				if self["lab_"..v.daoId] then 
					local time = v.lastTime - 1
					if time < 0 then 
						time = 0
					end  
					self.data.wkList[k].lastTime = time
					if time == 0 then 
						self["lab_"..v.daoId]:setString(res.str.DIG_DEC9)
					else
						self["lab_"..v.daoId]:setString(string.formatNumberToTimeString(time))
					end 
				else
					break
				end 
			end 
		end 
	else
		if self.data.wkList then 
			for k , v in pairs(self.data.wkList) do 
				if self["lab_"..v.daoId] then 
					if v.awardState > 0 then 
						self["lab_"..v.daoId]:setString(res.str.DIG_DEC9)
					else
						if v.lastTime == 0  then 
							if v.mId~=0 then 
								self["lab_"..v.daoId]:setString(res.str.DIG_DEC9)
							else
								self["lab_"..v.daoId]:setString(res.str.DIG_DEC19)
							end
						else
							self["lab_"..v.daoId]:setString(string.formatNumberToTimeString(v.lastTime))
						end
					end
				else
					break
				end
			end 
		end
	end 
end
--两个暴龙机的动画
function DigMainFrame:fightAction( daoId,flag )
	-- body
	--local widget = self.img_kuang[daoId]
	if not self.isself then
		return 
	end 

	if not flag then 
		if not self["fight"..daoId] then 
			self["fight"..daoId] =  mgr.BoneLoad:loadArmature(404802,0)
			local pos = self["img"..daoId]:getWorldPosition()
			self["fight"..daoId]:setPosition(pos)
			self["fight"..daoId]:addTo(self.view)
			--战斗位置调整
			local x = 0
			local y = 0
			if daoId == 1 then 
				x = -18
				y = -28
			elseif daoId == 2 then 
				x = -19
				y = 60
			elseif daoId == 3 then
				x = -10
				y = 70
			elseif daoId == 4 then  
				x = 0
				y = 40
			elseif daoId == 5 then
				x = 10
				y = 40
			else
				x = 50
				y = 75
			end  
			self["fight"..daoId]:setPositionX(self["fight"..daoId]:getPositionX()+x) --x 
			self["fight"..daoId]:setPositionY(self["fight"..daoId]:getPositionY()+y) --y
		end 
	else
		if self["fight"..daoId] then 
			self["fight"..daoId]:removeFromParent()
			self["fight"..daoId] = nil 
		end 
	end 
end
--根据传递来的值 if type >=2 then -- 抢夺
function DigMainFrame:setData(data_,type)
	-- body
	if data_ and data_.wkList then 
	else
		return
	end 
	if data_.roleId.key~=cache.Player:getRoleInfo().roleId.key then --如果不是自己
		--self.btn_back:setVisible(true)	
		self.isself = false
		self.lab_name:setColor(cc.c3b(255,0,0)) --不是维鹏的文件岛 颜色
	else
		self.isself = true	
		self.lab_name:setColor(COLOR[3]) --维鹏的文件岛 颜色
	end 
	if not type then 
		type = 1
	end
	self.type = type
	if self.type > 1 then 
		self:setVisBy(true)
	else
		--print("----")
		self:setVisBy(false)
	end

	self:initData()
	
	for i = 1 , 6 do 
		--清楚所有的着火
		if self["huo"..i] then 
			self["huo"..i]:removeFromParent()
			self["huo"..i] = nil 
		end
		--清除所有战斗标志
		if self["fight"..i] then 
			self["fight"..i]:removeFromParent()
			self["fight"..i] = nil 
		end
		--清除所有+
		if self["jia"..i] then 
			self["jia"..i]:removeFromParent()
			self["jia"..i] = nil 
		end
		--每个岛信息
		if self["item"..i] then 
			self["item"..i]:removeFromParent()
			self["item"..i] = nil 
		end
		--捣乱的boos
		if self["boos"..i] then 
			self["boos"..i]:removeFromParent()
			self["boos"..i] = nil 
		end 
	end 
	self.data = data_


	--self.btn_back:setVisible(false)
	
	---看看那些岛开启
	local maxid = 1
	for k , v in pairs(data_.wkList) do 
		self:initItem(v)
		if v.daoId>maxid then 
			maxid = v.daoId
		end 
	end
	if maxid == 1 then  --第一个岛默认开启
		self["img"..maxid]:removeAllChildren()
		self["img"..maxid+1]:removeAllChildren()
		--可挑战
		self.img_kuang[2].data = {state = 4} 
		self.img_kuang[2]:setTag(2)
		self:fightAction(2)
		--上个开启
		self.img_kuang[3].data = {state = 5}
	elseif maxid == 6 then --全部开启了
	else
		self["img"..maxid+1]:removeAllChildren()
		--可挑战
		self.img_kuang[maxid+1]:setTag(maxid+1)
		self.img_kuang[maxid+1].data = {state = 4 } 
		self:fightAction(maxid+1)

		--这个需要开启上一个岛
		if maxid+2 <= 6 then 
			self.img_kuang[maxid+2].data = {state = 5}
		end 
	end 
	--岛名字
	self.lab_name:setString(string.format(res.str.DIG_DEC8,data_.roleName))
	--可帮次数
	local count = data_.helpCount --cache.Dig:getHelpCount() 
	local count2 = data_.qdCount --cache.Dig:getQdCount()
	local count3 = data_.cheerCount--cache.Dig:getCheerCount()

	----特殊保留一下 --如果没有进入过文件岛 直接从复仇列表过来
	self.count2 = count2


	self.lab_help:setString(string.format(res.str.DIG_DEC11,count,self.sqmax-count2,self.cheeMaxCout - count3))
	self:setRedPoint(count,self.sqmax-count2)
	
	self:changeTimes()
end

--刷新数据
function DigMainFrame:updateInfo(data_)
	-- body
	-- 可探险次
	--好友次数
	local count = cache.Dig:getHelpCount()
	local count2 = cache.Dig:getQdCount()
	local count3 = cache.Dig:getCheerCount()
	self.lab_help:setString(string.format(res.str.DIG_DEC11,count,self.sqmax-count2,self.cheeMaxCout - count3))
	self:setRedPoint(count,self.sqmax-count2)
	--self.lab_help:setString(string.format(res.str.DIG_DEC11,cache.Dig:getHelpCount()))
	--文件岛状态
	self["icon_huo"..data_.daoId]:setVisible(false)
	if data_.state==1 then 
 		self["icon_huo"..data_.daoId]:setVisible(true)
 	end 
	--星级
	self["start_panle"..data_.daoId]:removeAllChildren()
	local colorlv = conf.Item:getItemQuality(data.mId)
 	for i = 1 , colorlv do 
 		local sprite=display.newSprite(res.image.STAR)
 		sprite:setPositionX(sprite:getContentSize().width*(i-0.5))
 		sprite:setPositionY(start_panle:getContentSize().height/2)
 		sprite:addTo(start_panle)
 	end 
end

--回到自己界面 
function DigMainFrame:playActionCallBack()
	-- body
	if not self.armature then 
		--self:setData()
		return 
	end 
	self.armature:setVisible(true)
	self.armature:getAnimation():playWithIndex(0)
end

function DigMainFrame:onBtnFuChouCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("复仇")
		proxy.Dig:sendEnemy()
		mgr.NetMgr:wait(520009)
	end
end

function DigMainFrame:onBtnFriendCallBack(sender_,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:playActionCallBack()--回到自己界面的播放一个
		--self:setData(cache.Dig:getMainData())
		local data = {roleId = cache.Player:getRoleInfo().roleId }
		proxy.Dig:sendDigMainMsg(data)
		mgr.NetMgr:wait(520002)
	end 
end
--好友列表
function DigMainFrame:onBtnSeeFriendData(sender_,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		proxy.Dig:sendfriend({flag = 1})
		mgr.NetMgr:wait(520005)
	end 
end

function DigMainFrame:isOver(data_,tag)
	-- body
	if self.listqdCount and self.listqdCount[tag] then 
		if self.listqdCount[tag] == data_.bqdCount then 
			return true
		end 
	end
	return false
end

--文件岛点击
function DigMainFrame:onimgCallBack(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local tag = sender_:getTag()
		--[[if not sender_.data then 
			return 
		end ]]
		if self.type > 1 then
		   --debugprint("发送抢夺 岛信息"..self.sqmax.."="..cache.Dig:getQdCount())
		   local count2 = cache.Dig:getQdCount()
		   if not count2 then
		   		count2 = self.count2 
		   end 

		   if not sender_.data then 
		   		G_TipsOfstr(res.str.DIG_DEC65)
		   		return 
		   elseif  count2 == self.sqmax then
		   		G_TipsOfstr(res.str.DIG_DEC64)
		   		return 
		   elseif not  sender_.data.atkAward or sender_.data.atkAward == 0 then 
		   		G_TipsOfstr(res.str.DIG_DEC69)
		   		return
		   	elseif self:isOver(sender_.data,tag) then --这个岛被抢完了
		   	--todo
		   		G_TipsOfstr(res.str.DIG_DEC65)
		   		return
		   end
		   cache.Fight.curFightName =   self.data.roleName
		   cache.Fight.curFightPower = self.data.score
		   --printt(sender_.data)
		   if sender_.data and  sender_.data.cheerName ~="" then 
		   		cache.Fight.curFightName =  sender_.data.cheerName
		   		cache.Fight.curFightPower = sender_.data.cheerScore
		   end
		  

		   proxy.copy:onSFight(102007,{tarId =self.data.roleId,daoId = tag  })
		   return 
		end

		if self.layer then 
			self.layer:removeFromParent()
			self.layer = nil 
		end 
		if self.layer_panel then 
			self.layer_panel:removeFromParent()
			self.layer_panel = nil 
		end 

		
		local state = 5
		if sender_.data and sender_.data.state  then 
			state = sender_.data.state
		end 
		
		if self.isself then  --自己的岛
			if state == 5 then --
				G_TipsOfstr(res.str.DIG_DEC1)
				return 
			elseif state == 4 then --挑战界面
				--todo
				local view = mgr.ViewMgr:showView(_viewname.DIG_INNER_MAIN)
				view:setData({daoId =sender_:getTag(),state = state })
				return
			end 
		else
			if (state == 11 or state == 12 or state == 13 or state == 14)  then  --如果没有起火
			else
				G_TipsOfstr(res.str.DIG_DEC2)
				return 
			end 
		end 
		local data = {roleId = self.data.roleId,daoId = sender_:getTag()}
		proxy.Dig:sendOneMsg(data,sender_.data)
		mgr.NetMgr:wait(520001)
	end 
end

function DigMainFrame:onBtnCloseView( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		mgr.SceneMgr:getMainScene():changePageView(5)
	end 
end

function DigMainFrame:onCloseSelfView()
	-- body
	self:closeSelfView()
end

---------------------
function DigMainFrame:onbtnQdCallBack(  sender_, eventtype  )
	-- body 抢夺
	if eventtype == ccui.TouchEventType.ended then
		debugprint("开始抢夺")
		local param = {roleId = {key = -1} , roleName = "",type = 3}
		proxy.Dig:sendDigMainMsg(param)
		mgr.NetMgr:wait(520002)
	end 
end

function DigMainFrame:onbtnNextCallBack(  sender_, eventtype  )
	-- body 下一个
	if eventtype == ccui.TouchEventType.ended then
		local param = {roleId = {key = -1} , roleName = "",type = 3}
		proxy.Dig:sendDigMainMsg(param)
		mgr.NetMgr:wait(520002)
	end 
end

function DigMainFrame:onbtnSearchCallBack(  sender_, eventtype  )
	-- body 收索
	if eventtype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.DIG_SEARCH)
		view:setData()
	end 
end

function DigMainFrame:onBtnComposeCallback(  sender_, eventtype  )
	-- body 对比
	if eventtype == ccui.TouchEventType.ended then
		if cache.Player:getRoleId().key == self.data.roleId.key then 
			G_TipsOfstr(res.str.CONTEST_DEC27)
			return 
		end 
		local param = {tarAId =  cache.Player:getRoleId(), tarBId =  self.data.roleId }
		--printt(param)
		proxy.Contest:sendCompare(param)
		mgr.NetMgr:wait(501201)
	end 
end

function DigMainFrame:comPareCalllBack( data_ )
	-- body
	cache.Friend:setOnlyClose(true)
	local view = mgr.ViewMgr:createView(_viewname.ATHLETICS_COMPARE)
	local data = {}



	--右边
	local data1 = {}
	data1.tarName = data_.tarBName
	data1.tarLvl = data_.tarBLvl
	data1.tarPower = data_.tarBPower
	data1.tarCards = data_.tarBCards
	data1.huoban = data_.tarBXhbs
	if data1.tarName == cache.Player:getName() then 
		data1.roleId = cache.Player:getRoleId()
	else
		data1.roleId = self.data.roleId
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.huoban = data_.tarAXhbs
	if data.tarName == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		data.roleId = self.data.roleId
	end 

	if data.tarName == cache.Player:getName() then
		view:setData(data1,data)
	else
		view:setData(data,data1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end


return DigMainFrame
