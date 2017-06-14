--
-- Author: Your Name
-- Date: 2015-08-19 21:14:33
--

local HornTipsView = class("HornTipsView",base.BaseView)
local MsgClass =require("game.views.friends.MessageItem")

local fontParam = 
{
	{color = {255,0,0}},
	{color = {0,255,0}},
	{color = {0,0,255}},
}

function HornTipsView:init(  )
	-- body
	self.view=self:addSelfView()
	self.showtype = view_show_type.OTHER
	self:setNodeEventEnabled(true)

	----------这里是小喇叭
	self.panel = self.view:getChildByName("Panel_10")
	self.panel:setSwallowTouches(false)
	
	self.ContentPanel = self.panel:getChildByName("Image_panel")
	self.ContentPanel:setScaleX(0)
	self.ContentPanel:setOpacity(0)
	self.ContentPanel:setSwallowTouches(false)
	self.ContentPanel:setAnchorPoint(0,1)
	self.horn = self.ContentPanel:getChildByName("Image_horn")


	----------这里是红包
	self.redBagBtn = self.view:getChildByName("Button_16")
	self.redBagBtn:addTouchEventListener(handler(self,self.redBagBtnCallback))

	----读取红包位置
	local x,y = self:readChatIconPos()
	if x and y then
		self.redBagBtn:setPosition(x,y)
	end


	self.data = {}
	self.sysData = {}
	local level = cache.Player:getLevel()
	if res.kai.showMainRedBag < level then
		self.redBagData = cache.Redbag:getShowData()
	else
		self.redBagData = {}
	end
	
	--标记小喇叭信息是否在显示中
	self.isRun = false
	--标记红包是否在显示状态
	self.isShowRedbag = true


	self.maxHornCount = 20
	self.maxRedbagCount = 3

	self.horn:setVisible(false)
	self.redBagBtn:setVisible(false)
	self.y = self.redBagBtn:getPositionY()
	self.x = self.redBagBtn:getPositionX()

	self:resRedbagState()

	--self:addRedbagData()
end

function HornTipsView:onExit()
	--dump(self.redBagData)
	--开关
	if cache.Player == nil then
		return
	end


	local  level = cache.Player:getLevel()
	if level and res.kai.showMainRedBag > level  then
		return
	end
	cache.Redbag:saveShowData(self.redBagData)
end

function HornTipsView:onEnter( )
	--开关
	local  level = cache.Player:getLevel()
	if res.kai.showMainRedBag > level  then
		return
	end
	if #self.redBagData >= 1 then
		self:showRedBag( )
	end
end


------这里是小喇叭

------逐个显示喇叭信息
function HornTipsView:runAnimation( )
	-- body
	print("========动画队列个数========", #self.data)
	if #self.data >= 1 then
		self.isRun = true
		local msg = self:createMsg()

		self.ContentPanel:addChild(msg)
		msg:setVisible(false)
		local size = msg:getContentSize()
		
		-- if size.width > self.ContentPanel:getContentSize().width - 50 then
		-- 	self.ContentPanel:setContentSize(size.width + 100,self.ContentPanel:getContentSize().height)
		-- end
		self.ContentPanel:setPosition(cc.p(self.panel:getContentSize().width/2 - self.ContentPanel:getContentSize().width/2 + 10 , self.panel:getContentSize().height))
		--msg:setAnchorPoint(0,0.5)
		self.ContentPanel:setContentSize(640,60)
		msg:setPosition(self.horn:getPositionX() + 20 + msg:getContentSize().width / 2 ,self.ContentPanel:getContentSize().height/2  )
		

		 local scaleToSide = cc.ScaleTo:create(1,1,1)
		 local fadeIn = cc.FadeIn:create(0.5)
		 local showFontCallFunc = cc.CallFunc:create(function (  )
		 	 msg:setVisible(true)
			 self.horn:setVisible(true)
			 local x = self.panel:getContentSize().width / 2
			 local y = self.panel:getContentSize().height / 2 + 20
			local params =  {id=404834, x=x,y=y,addTo=self.panel,retain =false,scale=0.8,loadComplete=function(arm )
		   self.normalEft = arm
	end}
			mgr.effect:playEffect(params)

		 end)
		 local delay = cc.DelayTime:create(3)

		 local spawIn = cc.Spawn:create(scaleToSide,fadeIn)


		local scaleEnd = cc.CallFunc:create(function (  )
			-- body
			--self.ContentPanel:removeAllChildren()
			msg:removeFromParent()
			self.isRun = false
			table.remove(self.data,1)
			self.ContentPanel:setScaleX(0)
			self.ContentPanel:setOpacity(0)
			self.ContentPanel:setContentSize(640,60)
			self.horn:setVisible(false)
			if self.normalEft then
				--self.normalEft:removeFromParent()
				self.normalEft = nil
			end
			self:runAnimation()
			
		end)

		local seq = cc.Sequence:create(spawIn,showFontCallFunc,delay,scaleEnd)
		self.ContentPanel:runAction(seq)
	end

end


function HornTipsView:setData( data )
	if data.cType == 6 then
		--保留20个喇叭足矣
		if table.nums(self.data) > self.maxHornCount then
			table.remove(self.data,1)
		end
		table.insert(self.data,data)
	else
		table.insert(self.sysData,data)
	end
	if self.isRun == false then
		-- self.data[#self.data + 1] = data
		self:runAnimation()
	end

end

function HornTipsView:createMsg(  )
	------取第一个数据来显示，优先显示系统消息
	if #self.sysData >= 1 then
		local data = self.sysData[1]
		table.insert(self.data,1,data)
		table.remove(self.sysData,1)
	end
--明天XX点有，请驯兽师们注意
	local data = self.data[1]
	local msg = MsgClass.new()
	local str = "[p=1,t=" .. data.roleName .. ":]"..data.contentStr
	local tableData = G_RenderStrKey(str, fontParam)
	--dump(tableData)
	msg:init(tableData,700,10,10)
	return msg

end




----------这里是红包

function HornTipsView:addRedbagData( data )

	--开关
	local  level = cache.Player:getLevel()
	if res.kai.showMainRedBag > level or cache.Player:getShowRedbag() == false  then
		if table.nums(self.redBagData) >= 0 then
			self.redBagData = {}
		end
		return
	end

	--如果是自己发的红包，插队
	local roleId = cache.Player:getRoleId()

	--溢出,移除除正在显示以外的 最早一个
	if self.maxRedbagCount <= table.nums(self.redBagData) then

		local dataDel = self.redBagData[#self.redBagData]
		local i = #self.redBagData

		for k=2,#self.redBagData do
			local v = self.redBagData[k]
			if v.index < dataDel.index then
				i = k
				dataDel = v
			end
		end
		print("======== HornTipsView:addRedbagData======",self.redBagData[i].index,i)
		table.remove(self.redBagData,i)
	end

	for k,v in pairs(self.redBagData) do
		v.isShow = false
	end

	if data["roleId"]["key"] == roleId["key"] then--自己发的
		table.insert(self.redBagData, 1,data)
		self:showRedBag()
		return
	end

	table.insert(self.redBagData, data)
	if table.nums(self.redBagData) >= 1 then
		self.redBagData[1].isShow = true
	end

	if table.nums(self.redBagData) == 1  then
		self:showRedBag()
	end


end

function HornTipsView:onBtnGetRadbagClick( send,eType )
	-- body
	if eType == ccui.TouchEventType.ended then
		local data = {}
		data.hbId = self.redBagBtn.hbId
		proxy.Redbag:reqGetRedbag(data)
	end
end

--显示红包信息
function HornTipsView:showRedBag(  )
	--如果在聊天界面中，红包不显示
	local  level = cache.Player:getLevel()
	if self.isShowRedbag == false or cache.Player:getShowRedbag() == false or res.kai.showMainRedBag > level then
		return
	end
	--透明渐变
	if table.nums(self.redBagData) >= 1 then
		self.redBagBtn:stopAllActions()
		self.redBagBtn:setScale(0)
		self.redBagBtn:setOpacity(0)
		self.redBagBtn:setPosition(display.cx,0)

		local scale1 = cc.ScaleTo:create(0.2, 1.3)
		local moveTo = cc.MoveTo:create(0.2,cc.p(self.x,self.y))
		local fadeIn = cc.FadeIn:create(0.2)
		local scale3 = cc.ScaleTo:create(0.1, 1)
		local spaw1 = cc.Spawn:create(scale1,moveTo,fadeIn)
		local func1 = cc.CallFunc:create(function ( )
			--self.redBagPanel:setScale(1)
			local scale2 = cc.ScaleTo:create(1, 0.9)
			local scale1 = cc.ScaleTo:create(1, 1)
			local seq1  = cc.Sequence:create(scale2,scale1)
			self.redBagBtn:runAction(cc.RepeatForever:create(seq1))
		end)

		local seq = cc.Sequence:create(spaw1,scale3,func1)
		self.redBagBtn:runAction(seq)

		self.redBagBtn.hbId = self.redBagData[1]["hbId"]
		self.redBagData[1].isShow = true
		self.redBagBtn:setVisible(true)
		self.isShowRedbag = true
	end
end

function HornTipsView:showNextRedBag( pre )
	--透明渐变
	self.redBagBtn:setVisible(false)
	if table.nums(self.redBagData) >= 1 then
		for k,v in pairs(self.redBagData) do
			if v.hbId["key"] == pre["key"] then
				v.isShow = false
				print("====showNextRedBag==index====",v.index)
				table.remove(self.redBagData,k)
				break
			end
		end
	end



	self:showRedBag()

	
end

function HornTipsView:setRedBagVisible( flag )

	self.isShowRedbag = flag
	if flag == false then
		self.redBagBtn:setVisible(false)
	end
	self:showRedBag()
end

function HornTipsView:resRedbagState( )
	self:schedule(function (  )
		local data = os.date("*t",os.time())
		--print( data.hour,data.min,data.sec)
		if data.hour == 0 and data.min == 0 and data.sec == 0 then
			local key = g_var.debug_accountId .. "_" ..user_default_keys.REDBAG_SHOW
			cache.Player:setShowRedBag("")
			MyUserDefault.setStringForKey(key,"")
		end
	end, 1)
end


---------------聊天按钮移动点击处理,长按0.8秒可拖动
function HornTipsView:longMove(  )
  -- body
  if  self.timer == nil then
    --todo
    self.timer = 0
  end

  self.timer = self.timer +1
  if self.timer > 1 then
    self:stopAllActions()
  end

end

--聊天按

function HornTipsView:redBagBtnCallback( send,etype )
  -- body
  if etype == ccui.TouchEventType.moved then
      local x = send:getTouchMovePosition().x
      local y = send:getTouchMovePosition().y
      local px = self.redBagBtn:getPositionX()
     local py = self.redBagBtn:getPositionY()
     local w = self.redBagBtn:getContentSize().width/4
     local h = self.redBagBtn:getContentSize().height/4

       if x - w <= 0 or x + w >= display.width  then
         return
       end
       if y - h <= 0 or y + h >= display.height then
         return
       end


    if self.timer == nil then
       -- self:stopAllActions()
       -- self.timer = nil
    elseif self.timer >= 1 then
      --todo
       self.redBagBtn:setPosition(x,y)
    end

  elseif etype == ccui.TouchEventType.began then
    local timeTick = self:schedule(self.longMove, 0.8)
  elseif etype == ccui.TouchEventType.ended then
     self:stopAllActions()
    if self.timer and self.timer >= 1 then
       self:saveChatIconPos(self.redBagBtn:getPosition())
    else
        self:onBtnGetRadbagClick(send,etype)
    end
    self.timer = nil
   
  end
  
end

-----保存红包icon位置
function HornTipsView:saveChatIconPos( x,y )
  -- body
  local key = g_var.debug_accountId .."_".. user_default_keys.REDBAG_POS
  local posStr = x .. "_"..y
  self.x = x
  self.y = y
  MyUserDefault.setStringForKey(key,posStr)

end

----读取红包Icon的位置
function HornTipsView:readChatIconPos(  )
  -- body
  local key = g_var.debug_accountId .."_".. user_default_keys.REDBAG_POS
  local posStr = MyUserDefault.getStringForKey(key)
  if posStr == nil or posStr == "" then
    --todo
    return nil
  end

  local starX,endX = string.find(posStr,"_")
  print(posStr)
  
  local x = tonumber(string.sub(posStr,1,starX-1))
  local y = tonumber(string.sub(posStr,endX+1,string.len(posStr)))

  return x,y
end





return HornTipsView