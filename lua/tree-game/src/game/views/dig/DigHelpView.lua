

local  DigHelpView = class("DigHelpView",base.BaseView)
function DigHelpView:ctor()
	-- body
end
function DigHelpView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.pandle_up = self.view:getChildByName("Panel_3"):getChildByName("Panel_4")
	self.pandle_down = self.view:getChildByName("Panel_3"):getChildByName("Panel_4_0")
	--boos
	self.boosname = self.view:getChildByName("Panel_3"):getChildByName("Text_12")
	self.boosimg = self.view:getChildByName("Panel_3"):getChildByName("Image_16")
	--自己
	self.lab_name = self.view:getChildByName("Panel_3"):getChildByName("Text_12_0")
	self.img_self = self.view:getChildByName("Panel_3"):getChildByName("Image_16_0")
end

function DigHelpView:run( str,dir ,i)
	-- body
	local widget = self[str..i]
	local ccsize = self.pandle_up:getContentSize()
	local toposx = ccsize.width*dir

	local s = toposx - widget:getPositionX()
	local v = 90

	local a1 = cc.MoveTo:create(math.abs(s/v),cc.p(toposx,0))
	local a2 = cc.CallFunc:create(function( ... )
		-- body
		--widget:setPositionX(-toposx)

		if 	str ~= "move_up" then 
			if i == 1 then 
				widget:setPositionX(self[str..3]:getPositionX()+ccsize.width)
			elseif i == 2 then 
				widget:setPositionX(self[str..1]:getPositionX()+ccsize.width)
			else
				widget:setPositionX(self[str..2]:getPositionX()+ccsize.width)
			end 
		else
			if i == 1 then 
				widget:setPositionX(self[str..3]:getPositionX()-ccsize.width)
			elseif i == 2 then 
				widget:setPositionX(self[str..1]:getPositionX()-ccsize.width)
			else
				widget:setPositionX(self[str..2]:getPositionX()-ccsize.width)
			end 
		end 
		self:run(str,dir,i)
	end)
	local sequence = cc.Sequence:create(a1,a2)
	widget:runAction(sequence)
end
--
function DigHelpView:moveTest(widget,dir)
	-- body
	local minpos = -widget:getContentSize().width
	local maxpos = 4*widget:getContentSize().width

	local toposx = 0
	if dir == 1 then --往右边移动
		toposx = maxpos
	else
		toposx = minpos
	end 

	local s = toposx - widget:getPositionX()
	local v = 90 
	local t = math.abs(s/v)
	local a1 = cc.MoveTo:create(t, cc.p(toposx,self.pandle_up:getContentSize().height/2))
	local a2 =  cc.CallFunc:create(function( ... )
		-- body
		if dir == 1 then --往右边移动
			widget:setPositionX(minpos)
		else
			widget:setPositionX(maxpos)
		end 
		self:moveTest(widget,dir)
	end)
	local sequence = cc.Sequence:create(a1,a2)
	widget:runAction(sequence)
end

function DigHelpView:setData(data_)
	-- body
	self.data = data_

	local data = cache.Dig:getOtherOnsMsg()
	print(data.state)

	local icon = res.icon.DIG_BOOS[tostring(data.state)]
	self.boosimg:ignoreContentAdaptWithSize(true)
	self.boosimg:loadTexture(icon)
	self.boosname:setString(res.str["DIG_DEC_BOSS"..data.state])

	self.lab_name:setString(res.str.DIG_DEC_BOSS15)
	self.img_self:loadTexture(res.image.ROLE_BG[cache.Player:getRoleSex()])

	self.win = data_.state;--默 1 赢
	print("self.win = "..self.win)


	if self.layout then 
		self.layout:removeSelf()
		self.layout = nil 
	end 
	self.pandle_up:removeAllChildren()
	self.pandle_down:removeAllChildren()

	local ccsize = self.pandle_up:getContentSize()
	--初始化电脑卡牌
	for i = 3 , 1 ,-1 do 
		local layout = ccui.Layout:create()
		layout:setContentSize(ccsize)
		layout:setAnchorPoint(cc.p(0,0))
		layout:setPositionX((2-i)*ccsize.width)
		layout:setPositionY(0)
		layout:addTo(self.pandle_up)
		self["move_up"..i] = layout

		for j = 1 , 3 do --卡牌添加
			local img = ccui.ImageView:create()
			img:loadTexture("res/views/ui_res/icon/icon_dig_4.png")
			img:setAnchorPoint(cc.p(0.5,0.5))
			img:setPositionX( (2*j-1)*(ccsize.width/6) )
			img:setPositionY(ccsize.height/2)
			img:addTo(layout)

			img:setTag(j)
			img.parent = i 
			img.index = j 
		end 

		--[[local _txt = ccui.Text:create()
		_txt:setString("text "..i)
		_txt:setFontSize(64)
		_txt:setPosition(ccsize.width/2,ccsize.height/2)
		_txt:addTo(layout)]]--
	end 

	--玩家可选
	for i = 1 , 3 do 
		local layout = ccui.Layout:create()
		layout:setContentSize(ccsize)
		layout:setAnchorPoint(cc.p(0,0))
		layout:setPositionX((i-2)*ccsize.width)
		layout:setPositionY(0)
		layout:addTo(self.pandle_down)
		self["move_down"..i] = layout
		

		for j = 1 , 3 do 
			local img = ccui.ImageView:create()
			img:loadTexture("res/views/ui_res/icon/icon_dig_"..j..".png")
			img:setAnchorPoint(cc.p(0.5,0.5))
			img:setPositionX( (2*j-1)*(ccsize.width/6) )
			img:setPositionY(ccsize.height/2)
			img:addTo(layout)

			img:setTag(j)
			img.parent = i 
			img.index = j 
			img:setTouchEnabled(true)
			img:addTouchEventListener(handler(self,self.onimgCallBack))
		end 
	end 

	for  i = 1 , 3 do 
		self:run("move_up",1,i)
		self:run("move_down",-1,i)
	end
end

function DigHelpView:cardTurn(param)
	-- body
	local ccsize = self.pandle_up:getContentSize()
	--吞噬其他点击
	self.layout = ccui.Layout:create()
	self.layout:setTouchEnabled(true)
	self.layout:setContentSize(display.size)
	self.layout:addTo(self.view)
	--停止动作
	for  i = 1 , 3 do 
		self["move_up"..i]:stopAllActions()
		self["move_down"..i]:stopAllActions()	
	end 
	
	--确定移动前 前后都有
	--local index = param.parent
	--if 	str == "move_up" then 
		local widget = self["move_up"..param.parent]
		if param.parent == 1 then 
			self["move_up"..2]:setPositionX(widget:getPositionX()-ccsize.width)
			self["move_up"..3]:setPositionX(widget:getPositionX()+ccsize.width)
		elseif param.parent == 2 then
			self["move_up"..3]:setPositionX(widget:getPositionX()-ccsize.width)
			self["move_up"..1]:setPositionX(widget:getPositionX()+ccsize.width)
		else
			self["move_up"..1]:setPositionX(widget:getPositionX()-ccsize.width)
			self["move_up"..2]:setPositionX(widget:getPositionX()+ccsize.width)
		end 
	--else

		local widget = self["move_down"..param.parent]
		if param.parent == 1 then 
			self["move_down"..2]:setPositionX(widget:getPositionX()+ccsize.width)
			self["move_down"..3]:setPositionX(widget:getPositionX()-ccsize.width)
		elseif param.parent == 2 then
			self["move_down"..3]:setPositionX(widget:getPositionX()+ccsize.width)
			self["move_down"..1]:setPositionX(widget:getPositionX()-ccsize.width)
		else
			self["move_down"..1]:setPositionX(widget:getPositionX()+ccsize.width)
			self["move_down"..2]:setPositionX(widget:getPositionX()-ccsize.width)
		end 
	--end 

	--加速移动
	local function moveFast(str,flag)
		-- body
		local tox = 0
		if param.index == 1 then 
			tox = 1/3*ccsize.width
		elseif param.index == 3 then 
			tox = -1/3*ccsize.width
		end
		local curx = self[str..param.parent]:getPositionX()
		

		local s = tox-curx
		local v = 1000 
		local t = math.abs(s/v)
		local a1 = cc.MoveTo:create(t,cc.p(tox,0))
		local a2 = cc.CallFunc:create(function( ... )
			-- body
			debugprint("移动到中间了")
			--翻转卡牌
			local win =math.random(100)
			local ping = 20 --平局可能
			if str == "move_up" then 
				local img = self[str..param.parent]:getChildByTag(param.index)
				--img:loadTexture("res/views/ui_res/icon/icon_dig_1.png")
				img:setScaleY(-1)
				local a3 = cc.OrbitCamera:create(0.5,1,0,0,360,0,0)
				local a4 = cc.CallFunc:create(function()
					-- body
					
					if win < ping then --平局
						--local a3 = cc.OrbitCamera:create(0.5,1,0,0,180,0,0)
						img:loadTexture("res/views/ui_res/icon/icon_dig_"..param.index..".png")
					else
						if tonumber(self.win) == 1 then --赢了
							print("我赢了")
							if param.index -1  > 0 then 
								img:loadTexture("res/views/ui_res/icon/icon_dig_"..tostring(param.index-1)..".png")
							else
								img:loadTexture("res/views/ui_res/icon/icon_dig_3.png")
							end 
						else--输了
							print("我输了")
							if param.index+1 < 4 then 
								img:loadTexture("res/views/ui_res/icon/icon_dig_"..tostring(param.index+1)..".png")
							else
								img:loadTexture("res/views/ui_res/icon/icon_dig_1.png")
							end 
						end
					end 
				end)
				local a5 = cc.DelayTime:create(1.0)

				local a6 = cc.CallFunc:create(function( ... )
					-- body
					--self:setData()
					if win < ping then 
						G_TipsOfstr(res.str.DIG_DEC42)
						self:setData(self.data)
					else
						
						local view = mgr.ViewMgr:showView(_viewname.DIG_HELPOVER)
						view:setData(self.win)

						self:onCloseSelfView()
					end 
					
				end)
				img:runAction(cc.Sequence:create(a3,a4,a5,a6))
				
			end 
		end)
		local sequence = cc.Sequence:create(a1,a2)
		

		local function callback( widget , x )
			-- body
			local acc = cc.MoveBy:create(t, cc.p(x,0))
			widget:runAction(acc)
		end

		for i = 1 , 3 do 
			if i ~= param.parent then 
				callback(self[str..i],s)
			else
			 	self[str..i]:runAction(sequence) 
			end 
		end 

	
	end
	moveFast("move_up")
	moveFast("move_down")
end

function DigHelpView:onimgCallBack(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("选中的了其中一种"..sender_.index)
		self:cardTurn({index = sender_.index,parent = sender_.parent })
	end 
end

function DigHelpView:onCloseSelfView()
	-- body
	self:closeSelfView()
end
return DigHelpView