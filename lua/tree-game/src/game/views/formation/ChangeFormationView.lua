
local pet= require("game.things.PetUi")
local ChangeFormationView=class("ChangeFormationView",base.BaseView)


function ChangeFormationView:init()
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.Panel_clone=self.view:getChildByName("Panel_clone")
	self.Table_power=self.view:getChildByName("Image_bg_4"):getChildByName("Text_power")
	self.panle_down = self.view:getChildByName("Panel_down_0")
	self.name = {}

	self.Table_Widget={}
	self:initWidget(6)

	local layer=cc.Layer:create()
	self.layer=layer
	self:addChild(layer)
	self:createMouseEvent(layer,handler(self,self.onTouchBegan),handler(self,self.onTouchMoved),handler(self,self.onTouchEnded))
	

	self._nowPet=nil --记录当前移动的宠物
	self.SelectPetMax = nil  --能被点击的最大个数
	self.NowSelectPetNum = 1  --当前多少个被选择
	self.ListPet={} --以上阵的精灵 

	

	
	self:performWithDelay(function()
		-- body
		local effConfig = conf.Effect:getInfoById(404084)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)

	end, 0.1)
end
--初始化6个位置
function ChangeFormationView:initWidget( index )
	local max_row=3
	local math_f=math.floor
	local star_x=13
	local star_y=display.height - 400
	--间隔
	local jg_x=10
	local jg_y=80*display.contentScaleFactor
	for i=0,index-1 do
		local row=(i%max_row)
		local col=math_f(i/max_row)
		local head=CreateClass("views.formation.ChangeFormationWidget")
		head:init(self,i+1)
		--head:addandplay()
		head:setPosition(star_x+row*(head:getContentSize().width+jg_x),
			star_y-col*(head:getContentSize().height+jg_y))
		self:addChild(head)
		self.Table_Widget[head.pos]=head

		local lab_name = self.panle_down:clone()
		lab_name:setPosition(head:getPositionX(),head:getPositionY()-lab_name:getContentSize().height-5)
		lab_name:setVisible(false)
		self:addChild(lab_name, 1000)

		self.name[head.pos] = lab_name
		--table.insert(self.name,lab_name)
	end
	self.Panel_clone:removeFromParent()
end
function ChangeFormationView:setNameData( v,index )
	-- body
	local widget = self.name[index]
	if widget then 
		if v then 
			widget:setVisible(true)
			local lv=conf.Item:getLv(v)
			local name=conf.Item:getName(v.mId,v.propertys)
			local Quality=conf.Item:getItemQuality(v.mId)	

			local lab_lv  = widget:getChildByName("Image_Icon_5"):getChildByName("Text_lv_2")
			lab_lv:setString(lv)

			local lab_name = widget:getChildByName("Text_name_4")
			lab_name:setString(name)
			lab_name:setColor(COLOR[Quality])
		else
			widget:setVisible(false)
		end
	end
end

--每个位置上放置数码兽
function ChangeFormationView:updateAllWidget( data ) 
	for i = 1 , 6 do 
		self.Table_Widget[i]:setData()

		self.Table_Widget[i]:addandplay()

		if self.ListPet[i] then
			self.ListPet[i]:removeSelf()
			self.ListPet[i] = nil 
		end

		if self.name[i] then
			self.name[i]:setVisible(false)
		end
	end 
	
	for k,v in pairs(data) do
		local index=conf.Item:getBattlePropertyTo(v)
		local widget=self:updateWidget(index,v)
		self:addPet(widget)
		self.NowSelectPetNum = self.NowSelectPetNum+1

		self:setNameData(v,index)
	end
	
	
	self:updatePower()
end
--战斗力
function ChangeFormationView:updatePower(  )
	local power=0
	self.NowSelectPetNum = 0
	for k,v in pairs(self.Table_Widget) do
		power=power+conf.Item:getPower(v:getData())
		if v:getData() then 
			self.NowSelectPetNum = self.NowSelectPetNum +1 
		end 
	end

	if self:isull() then --如果达到上限 删除所有加号动画
		for i=1,#self.Table_Widget do
			self.Table_Widget[i]:setBtnVisible(false)
		end
	end
	self.Table_power:setString(power)
end
function ChangeFormationView:updateWidget( index,data )
	local widgret=self.Table_Widget[index]
	if  widgret then
		widgret:setData(data)
		self:setNameData(data,index)
	end
	--[[if self:isull() then
		for i=1,#self.Table_Widget do
			self.Table_Widget[i]:setBtnVisible(false)
		end
	end]]--
	return widgret
end
--
function ChangeFormationView:addPet(widgret)
	local data=widgret:getData()
	if not data then return end
	if self.Change then self.Change = false return end
	local node=self:createPetImage(data)
	local w=widgret:getContentSize().width
	local h=widgret:getContentSize().height
	local x=widgret:getPositionX()
	local y=widgret:getPositionY()-20
	node:setAnchorPoint(cc.p(0.5,0.5))
	node:setPosition(x+w/2,y+h/2)

	local color = conf.Item:getItemQuality(data.mId)
	node:setScale(res.card.buzhen[tostring(color)])
	self:addChild(node,100)
	if  self.ListPet[widgret.pos] then
		self.ListPet[widgret.pos]:removeFromParent()
	end


	self.ListPet[widgret.pos]=node
	--self.NowSelectPetNum = self.NowSelectPetNum +1
	self:isull()
	-- widgret:setBtnVisible(false)
end


function ChangeFormationView:createPetImage(data)
	local fileName=conf.Item:getModel(data.mId,data.propertys)
	local node= pet.new(data.mId,data.propertys)
	node:setScale(G_GardChange(data))
	return node
end
function ChangeFormationView:isCollision(sprite,pos,i)
	local pp=sprite:getPosition()
	local spr_pos=sprite:getParent():convertToWorldSpace(cc.p(sprite:getPositionX(),sprite:getPositionY()))
	local spr_x=spr_pos.x
	local spr_y=spr_pos.y

	local spr_w=sprite:getContentSize().width
	local spr_h=sprite:getContentSize().height

	if pos.x < spr_x-spr_w/2 or  pos.x > spr_x+spr_w/2 or pos.y < spr_y-spr_h/2 or pos.y > spr_y +spr_h/2 then
		return false
	end

	return true
end
function ChangeFormationView:isCardCollision(sprite,widget)
	local pp=sprite:getPosition()
	local spr_pos=sprite:getParent():convertToWorldSpace(cc.p(sprite:getPositionX(),sprite:getPositionY()))
	local spr_x=spr_pos.x
	local spr_y=spr_pos.y

	local spr_w=sprite:getContentSize().width
	local spr_h=sprite:getContentSize().height

	local widget_x= widget:getPositionX()
	local  widget_y= widget:getPositionY()

	local  widget_w= widget:getContentSize().width
	local  widget_h= widget:getContentSize().height

	if spr_x+spr_w/2 < widget_x+widget_w/4 or  spr_x-spr_w/2  > widget_x + widget_w*3/4 or spr_y+ spr_h/2 < widget_y+widget_h/4 or 
		spr_y-widget_h/2 > widget_y+widget_h*3/4 then
		return false
	end
	return true
end
function ChangeFormationView:setData(data)
	self.data=data
	local size = 6
	self.SelectPetMax = 0
	local palylv=cache.Player:getLevel()
	for i=1,size do
		if palylv >= conf.Open:getLockLv(i) then
			self.SelectPetMax = self.SelectPetMax + 1
		end
	end
	self:updateAllWidget(data)
	--[[if self:isull() then
		for i=1,#self.Table_Widget do
			self.Table_Widget[i]:setBtnVisible(false)
		end
	end]]--
end
function ChangeFormationView:isull(  )
	if self.NowSelectPetNum >= self.SelectPetMax then
		return true
	end
	return false
end
function ChangeFormationView:getChangeClone(  )
	return self.Panel_clone:clone()
end
--判断哪个数码兽被点中
function ChangeFormationView:onTouchBegan(touch,event)
	--print("onTouchBegan")
	local x=touch:getLocation().x
	local y=touch:getLocation().y
	local index=1
	for k,v in pairs(self.ListPet) do
		local iscloll=self:isCollision(v,touch:getLocation(),index)
		index=index+1
		if  iscloll then
				self._nowPet=v
				self._nowPet.index=k
			break
		end
	end	
	-- if  not self._nowPet then
	-- 	return false
	-- end
    return true
end
--移动动画
function ChangeFormationView:onTouchMoved(touch,event)
	--print("onTouchMoved")
	if  self._nowPet and not tolua.isnull(self._nowPet) and self._nowPet.index then
		local pos=self._nowPet:getParent():convertToNodeSpace(touch:getLocation())
		self._nowPet:setPosition(pos)
	end
end
--移动结束
function ChangeFormationView:onTouchEnded(touch,event)
	--print("onTouchEnded")
	local index
	local toindex
	local data
	local todata
	if self._nowPet and not tolua.isnull(self._nowPet) and self._nowPet.index  then
		for k,v in pairs(self.Table_Widget) do
			if self._nowPet.index ~= k  then 
				if self:isCardCollision(self._nowPet,v) then
					index=self._nowPet.index
					toindex = k
					data=self.Table_Widget[index]:getData()
					todata=self.Table_Widget[k]:getData()
					break
				end
			end
		end
		if data then
			local pos=self.Table_Widget[index].pos
			local pos1=self.Table_Widget[toindex].pos

			self:changePet(pos1,self.ListPet[pos],pos)

			local sdata={}
			sdata.toIndex=toindex
			sdata.index=self.Table_Widget[index]:getData().index
			sdata.mId=self.Table_Widget[index]:getData().mId
			sdata.opType = 2
			self.Change = true
			proxy.card:reqBattle(sdata)
			mgr.NetMgr:wait(504007)
			--self:updateWidget(index,todata)
			--self:updateWidget(toindex,data)
		else
			self:moveTo(self._nowPet,self._nowPet.index) -- 移动到的位置不对
		end

	end
	self._nowPet=nil
end

function ChangeFormationView:changePet(index,pet,toindex)
	local i_pet=self.ListPet[index]
	self.ListPet[index]=pet
	self.ListPet[toindex]=i_pet
	self:moveTo(pet,index)
	self:moveTo(i_pet,toindex)
end
function ChangeFormationView:moveTo(node,index)
	if node and index  then
		local widgret=self.Table_Widget[index]
		local w=widgret:getContentSize().width
		local h=widgret:getContentSize().height
		local x=widgret:getPositionX()
		local y=widgret:getPositionY()-20
		node:runAction(cc.MoveTo:create(0.05,cc.p(x+w/2,y+h/2)))
	end
end
function ChangeFormationView:createMouseEvent(layer,onTouchBegan,onTouchMoved,onTouchEnded)--为ScrollView添加按键事件
    local listener = cc.EventListenerTouchOneByOne:create()--创建一个事件侦听器的触摸
     --listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )--注册脚本处理程序
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = layer:getEventDispatcher()--获得获取事件控制器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)--添加场景的优先事件监听器
end
return ChangeFormationView