local RoleLevelUpView=class("RoleLevelUpView",base.BaseView)



function RoleLevelUpView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	
	self.ListView=self.view:getChildByName("ListView_1")

	self.bg =self.view:getChildByName("Image_18") 
	self.bg:setTouchEnabled(true)
	
	--体力
	self.Lable_prvlv=self.view:getChildByName("Panel_1"):getChildByName("Panel_2"):getChildByName("Lable_prv")
	self.Lable_nextlv=self.view:getChildByName("Panel_1"):getChildByName("Panel_2"):getChildByName("Lable_next")
	--探险次数
	self.Lable_prvlv_1=self.view:getChildByName("Panel_1"):getChildByName("Panel_2_0"):getChildByName("Lable_prv_8")
	self.Lable_nextlv_1=self.view:getChildByName("Panel_1"):getChildByName("Panel_2_0"):getChildByName("Lable_next_10")

	self.Panel_clone = self.view:getChildByName("Panel_clone")

	self.Panel_3 = self.view:getChildByName("Panel_3")

	self.pan = self.view:getChildByName("Image_25")
    local offsetX = 0 
    local offsetY = 0

    self.pan:setPositionX(self.pan:getPositionX()+offsetX)
    self.pan:setPositionY(self.pan:getPositionY()+offsetY)

    local sequence = transition.sequence({
	   	cc.FadeOut:create(0.5),
	    cc.FadeIn:create(0.5),
	    cc.DelayTime:create(0.5),
	})
	local action = cc.RepeatForever:create(sequence)
	self.pan:runAction(action)

	--self:initlistView()
    mgr.Sound:playRoleLevelUp()


    ---屠魔未开启，关闭
    local advPanel = self.view:getChildByName("Panel_1"):getChildByName("Panel_2_0")
    --检测功能的是佛开启
    if cache.Player:getLevel() < 12 then 
        advPanel:setVisible(false)
    else
    	advPanel:setVisible(true)
    end




end


function RoleLevelUpView:onImgClose( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function RoleLevelUpView:onbtnGoto( sender,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		local data = sender.data
		if  data then --如果支持跳转就
			G_GoToView(data)
			self:onCloseSelfView()
			return 
		else
			G_TipsOfstr(res.str.NOOPEN)
		end 
	end 
end

function RoleLevelUpView:initlistView()
	-- body 
	local lv = cache.Player:getLevel()
	self.list = conf.Role:getOpenList()

	table.sort(self.list,function(a,b )
		-- body
		return a.lv < b.lv 
	end)

	local max = 0
	for i = 1 , #self.list do 

		local data = self.list[i]
		if  max == 0 and  data.lv >= lv then 
			max = i  
		end 
		
		if max>0 and i > max +1 then 
			break
		end 
		if max > 0 then 
			local widget = self.Panel_clone:clone()
			widget:setVisible(true)
			--开启功能图片
			local img = widget:getChildByName("Image_15_2_36")
			--名字
			local name = widget:getChildByName("Text_title_2_51")
			name:setVisible(true)
			name:setString(tostring(data.buy_tl))
			--描述
			local txt = widget:getChildByName("Text_4_53")
			txt:setString(data.dec)

			local txtlv  =  widget:getChildByName("Text_lock_6_55")
			local imglock = widget:getChildByName("Image_lock_4_38")

			local opendata = {}
			table.insert(opendata,data.name)
			if data.page then 
				table.insert(opendata,data.page)
			end 
			
			if lv >= data.lv then 
				imglock:setVisible(true)
				txtlv:setString(res.str.ROLE_OPEN_DONE)
				widget.data = opendata
			else
				
				imglock:setVisible(false)
				txtlv:setString(string.format(res.str.ROLE_OPEN,data.lv))
			end 

			widget:setTouchEnabled(true)
			widget:addTouchEventListener(handler(self, self.onbtnGoto))

			self.ListView:pushBackCustomItem(widget)
		end 
		
		
	end 

end


function RoleLevelUpView:updateUi(data )
	self:playAnimation(cache.Player:getLevel())

	if not data then 
		debugprint("没有data")
		data = {}
		data.tili_befor = cache.Player:getTili()
		data.newTili = cache.Player:getTili()

		data.oldadv = cache.Player:getAdventCount()
		data.newadv = cache.Player:getAdventCount()
	end   

	self.Lable_prvlv:setString(data.tili_befor)
	self.Lable_nextlv:setString(data.newTili)

	self.Lable_prvlv_1:setString(data.oldadv)
	self.Lable_nextlv_1:setString(data.newadv)
	
	--self:updateProperty(cache.Player:getLevel())
end
function RoleLevelUpView:updateProperty( lv )


	--[[local ma=conf.Role:getManual(lv)
	local next_ma=conf.Role:getManual(lv+1)
	local ep=conf.Role:getExplore(lv)
	local next_ep=conf.Role:getExplore(lv+1)
	if not ma or not ep then 
		return
	end
	if (not next_ma) and (not next_epthen) then
		next_ma=ma
		next_ep=ep
	end]]--
	self.Lable_prvlv:setString(ma)
	self.Lable_nextlv:setString(next_ma)
	self.Lable_prvlv_1:setString(ep)
	self.Lable_nextlv_1:setString(next_ep)
end


function RoleLevelUpView:onCloseSelfView()
	if cache.Fight.fightLevelUp > 0 then  --战斗升级
		G_FightFromEnd(cache.Fight.fightLevelUp)
	else
		mgr.Guide:openFunc()
	end
	proxy.Radio:setLevelup()
    mgr.Sound:playMainMusic()
	self:closeSelfView()

	G_TaskShow(true)
end

--升级到 lv 
function RoleLevelUpView:PlayWenzi(lv)
	-- body
	 local function run(spr)
        -- body
        spr:setVisible(true)
        local lastPosY = display.cy + 60
        local a1 =  cc.MoveTo:create(0.08,cc.p(spr:getPositionX(),lastPosY-20))  -- 下
        local a2 =  cc.MoveTo:create(0.12,cc.p(spr:getPositionX(),lastPosY+50)) --  上
        local a3 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY-10)) -- 下
        local a4 =  cc.MoveTo:create(0.1,cc.p(spr:getPositionX(),lastPosY+20)) -- 上
        local a5 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY))--最后停留 

        local sequence = cc.Sequence:create(a1,a2,a3,a4,a5)
        spr:runAction(sequence)
    end


	local posy = display.cy + 200  --开始掉落前的高度
    local img_sprite = display.newSprite(res.font.FIGHT_DEC[6])
    img_sprite:setPosition(display.width/2-90,posy)
    img_sprite:addTo(self.Panel_3,1000)
    --run(img_sprite) 	

    local function calaback( ... ) --数字动画
    	-- body
    	local x = img_sprite:getPositionX() +img_sprite:getContentSize().width/2 - 30
	    local strnum=tostring(lv)
		local length=string.len(strnum)
		for i = 1 , length do 
			local index=tonumber(string.sub(strnum,i,i))
			if tonumber(index) == 0 then 
				index = 10
			end
			
			local sprite = display.newSprite(res.other.NUMBER_LV[index])
			sprite:setVisible(false)
			x = x + sprite:getContentSize().width
			sprite:setPosition( x,posy)

	   		sprite:addTo(self.Panel_3,1001)

	   		local a1 = cc.DelayTime:create(0.25*(i-1)) --数字之间掉落时间差
	   		local a2 = cc.CallFunc:create(function( ... )
	   			-- body
	   			run(sprite) 	
	   		end)
	   		local sequence = cc.Sequence:create(a1,a2)
	   		sprite:runAction(sequence)	

	   		if i == length then 
	   			self.bg:addTouchEventListener(handler(self, self.onImgClose))
	   		end
		end 
    end 

    local a1 = cc.CallFunc:create(function( ... )
		-- body
		run(img_sprite)
	end)
    local a2 = cc.DelayTime:create(0.3) --数字之间掉落时间差
	local a3 = cc.CallFunc:create(function( ... )
		-- body
		calaback() 	
	end)
	local sequence = cc.Sequence:create(a1,a2,a3)
	img_sprite:runAction(sequence)	
    
end


function RoleLevelUpView:playAnimation(lv )
	--光效 旋转
	local armature = mgr.BoneLoad:loadArmature(404086,4)
    armature:setPosition(display.width/2,display.cy)
    armature:addTo(self.Panel_3,999)
    --横条
    local armature_kn = mgr.BoneLoad:loadArmature(404088,0)
    armature_kn:setPosition(display.width/2,display.cy)
    armature_kn:addTo(self.Panel_3,1000)
    --

   armature_kn:getAnimation():setFrameEventCallFunc(function(bone,event,originFrameIndex,intcurrentFrameIndex)
	    if event == "a1" then 
			 self:PlayWenzi(lv)         
	    end
	end)




	--[[local params =  {id=404088, x=display.cx,y=display.cy,addTo=self.Panel_3,endCallFunc=nil,from=nil,to=nil, playIndex=0,retain = true}
	mgr.effect:playEffect(params)	

	local params =  {id=404088, x=display.cx,y=display.cy,addTo=self.Panel_3,endCallFunc=nil,from=nil,to=nil, playIndex=1,retain = true}
	mgr.effect:playEffect(params)	

	--光效动画
	local paramsforeve =  {id=404086, x=display.cx  ,y=display.cy,addTo=self.Panel_3,depth = 999
	,endCallFunc=nil,from=nil,to=nil, playIndex=4}
	
	local  posx
	local strnum=tostring(lv)
	local length=string.len(strnum)

	for i = 1 , length do 
		local index=string.sub(strnum,i,i)
		local d = tonumber(index)+3
		if length > 1 then 
			posx = display.cx - 40 +60*(i-1)
			posy = display.cy - 10*(i-1)
		else
			posx = display.cx 
			posy =  display.cy 
		end 
		local params =  {id=404088, x=posx ,y=posy,addTo=self.Panel_3, playIndex=d,retain = true}
		mgr.effect:playEffect(params)
	end 

	local off_x = 0
	local offy = 0
	if  length >= 3 then 
		off_x = (length - 2) * 60
		offy  = 10*(length-1)
	end 
	local params =  {id=404088, x=display.cx + off_x ,y=display.cy-offy,addTo=self.Panel_3
	,endCallFunc=function()
			-- body
			self.bg:addTouchEventListener(handler(self, self.onImgClose))
		end, playIndex=2,retain = true}
	mgr.effect:playEffect(params)

	self:performWithDelay(function( ... )
		-- body
		mgr.effect:playEffect(paramsforeve)
	end, 0.3)]]--

	
	
	
	 
end

return RoleLevelUpView