
--[[
	双11抽奖
]]
local active_chou = class("active_chou.lua",base.BaseView)

function active_chou:init(Parent)
	-- body
	self.Parent=Parent
	self.view=Parent:getCloneChou()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self.view:setTouchEnabled(false)
	self:addChild(self.view)

	local img = self.view:getChildByName("Image_69")
	self.img = img --转盘

	self.btnlist = {}
	for i = 1 , 6 do 
		local t = {}
		t.frame = img:getChildByName("Button_1_"..i)
		t.spr = t.frame:getChildByTag(1)
		t.spr:ignoreContentAdaptWithSize(true)
		t.name =t.frame:getChildByTag(2)

		t.frame:setRotation(60*(i-1))

		table.insert(self.btnlist,t)
	end
	--4个道具
	self.lablist ={}
	for i = 1 , 4 do 
		local lab = self.view:getChildByName("Image_71_"..i):getChildByName("Text_1_"..i)
		table.insert(self.lablist,lab)
	end

	local btn = self.view:getChildByName("Button_2_0")
	btn:addTouchEventListener(handler(self, self.onbtnChouCall))

	self._checkbox = self.view:getChildByName("CheckBox_2")
	self._checkbox:setSelected(false)
	self._checkbox:addEventListener(handler(self, self.checkBoxCallback))

	local times=MyUserDefault.getIntegerForKey(user_default_keys.GAME_11CHOU_DAY)
	if times then --今日是否勾选了 不在提示
		if os.date("%x", os.time()) == os.date("%x",times) then 
			self.cancelSecond = false 
		else
			self.cancelSecond = true
		end
	end	

	self.view:getChildByName("Text_1_17_58_89_0"):setString(res.str.DOUBLE_DEC20)

	self:initData()
end

--设置今天是否取消2次确认界面
function active_chou:savedaycancel( )
	-- body
	self.cancelSecond = false
	MyUserDefault.setIntegerForKey(user_default_keys.GAME_11CHOU_DAY,os.time())
end

function active_chou:run(pos)
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

function active_chou:initTool()
	-- body
	--4种道具
	self.tool = true
	self.min = 0
	local t = {221015021,221015022,221015023,221015024}
	for k , v in pairs(t) do 
		local count = cache.Pack:getItemAmountByMid(pack_type.PRO,v)
		self.lablist[k]:setString("/"..count)

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
		self._checkbox:setTouchEnabled(false)
		self._checkbox:setBright(false)
		self._checkbox:setSelected(false)
	else
		self._checkbox:setTouchEnabled(true)
		self._checkbox:setBright(true)
	end 
end

function active_chou:initData()
	-- body
	--初始化6个奖励
	local confdata = conf.Double:getChouRewad()
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


function active_chou:updateinfo(data_)
	-- body
	self:initTool()
	self.data = data_
	self:run(data_.gotIndex+1)
end

function active_chou:getMin( ... )
	-- body

end

function active_chou:checkBoxCallback(sender,eventtype)
	-- body
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


function active_chou:onbtnChouCall(send,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		local falg = self._checkbox:isSelected() --复选框选中
		if self.tool then 
			self.img:setRotation(0)
			proxy.Double:send116073({playType = falg and 1 or 0 })
			mgr.NetMgr:wait(516073)
		else
			G_TipsOfstr(res.str.DOUBLE_DEC13)
		end
		--self:run(2)
	end
end


return active_chou