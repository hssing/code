local ChangeFormationWidget=class("ChangeFormationWidget",
	function(  )
		return ccui.Widget:create()
	end
)


function ChangeFormationWidget:init(parent,index)
	self.pos=index
	self.isOpen=false
	self.parent=parent
	self.view=parent:getChangeClone()
	self:setContentSize(self.view:getContentSize())
	self:setAnchorPoint(cc.p(0,0))
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:addChild(self.view)
	self.Btn=self.view:getChildByName("Button_add")
	self.Btn:setTouchEnabled(false)
	--
	self.Btn:addTouchEventListener(handler(self,self.onCallBack))
	self.Panel_down=self.view:getChildByName("Panel_down"):setVisible(false)
	self.lv=self.Panel_down:getChildByName("Image_Icon"):getChildByName("Text_lv")
	self.Name=self.Panel_down:getChildByName("Text_name")
	self.Layer=self.view:getChildByName("Image_tx")

	--self:addandplay()
end

function ChangeFormationWidget:onCallBack(send,envetype)
	if envetype == ccui.TouchEventType.ended then
		-- local data = self.parent.data
		-- --dump(data)
		-- local pos = {}
		-- local isFind = false
		-- if data then
		-- 	for i=1,6 do--遍历6个上阵位，找出最小的一个空位
		-- 		isFind = false
		-- 		for k,v in pairs(data) do
		-- 			if i == tonumber(conf.Item:getBattleProperty(v)) then
		-- 				isFind = true
		-- 				break
		-- 			end
		-- 		end

		-- 		if isFind == false then
		-- 			pos[#pos + 1] = i
		-- 		end
		-- 	end
		-- 	dump(pos)
		-- 	table.sort(pos,function( a,b )
		-- 		return a < b
		-- 	end)
		-- 	mgr.ViewMgr:showView(_viewname.BATTLE_LIST):setData(pos[1],1)--队形上阵
		-- 	return
		-- end
		--G_TipsOfstr(self.pos)
		mgr.ViewMgr:showView(_viewname.BATTLE_LIST):setData(self.pos,1)--队形上阵
	end
end
--+号的动画
function ChangeFormationWidget:addandplay()
	-- body
	if not self.view:getChildByName("effofname") then
		local params =  {id=404808, x=self.view:getContentSize().width/2,
		y=self.view:getContentSize().height/2,
		addTo=self.view,
		endCallFunc=nil,
		from=nil,to=nil, 
		playIndex=0,
		addName = "effofname"}
		mgr.effect:playEffect(params)

		self.Btn:setVisible(true)
		self.Btn:setTouchEnabled(true)
		self.Btn:setOpacity(0)
	end 
end

function ChangeFormationWidget:updatePetData(data)
	local lv=conf.Item:getLv(data)
	local name=conf.Item:getName(data.mId,data.propertys)
	local Quality=conf.Item:getItemQuality(data.mId)
	self:setNameColor(Quality)
	self:setLv(lv)
	self:setName(name)
	--self.Panel_down:setVisible(true)
		--self:addPet()
end
function ChangeFormationWidget:getData(data)
	return self.data
end
function ChangeFormationWidget:createPetImage()
	local fileName=conf.Item:getModel(self.data.mId,self.data.propertys)
	local node= cc.Sprite:create("res/cards/"..fileName..".png")
	return node
end
function ChangeFormationWidget:setLv(lv)
	self.lv:setString(lv)
end
function ChangeFormationWidget:setName(name)
	self.Name:setString(name)
end
function ChangeFormationWidget:setNameColor(lv)
	local colro=COLOR[lv]
	if colro then
		self.Name:setColor(colro)
	end
end
function ChangeFormationWidget:setData(data)
	self.data=data
	if self.data == nil  then
		if self.view:getChildByName("effofname") then
			self.view:getChildByName("effofname"):removeFromParent()
		end 
		--self.Btn:setVisible(true)
		self.Panel_down:setVisible(false)
		--self:addandplay()
		if self.parent:isull() then
			self:setBtnVisible(false)
			--self.Btn:setVisible(false)
		else
			self:addandplay()
			--self.Btn:setTouchEnabled(true)
			--self.Btn:setOpacity(0)
		end
		return
	end
	if self.view:getChildByName("effofname") then
		self.view:getChildByName("effofname"):removeFromParent()
	end 
	self.Btn:setVisible(false)
	self:updatePetData(data)
end
--设置add按钮
function ChangeFormationWidget:setBtnVisible( bl )
	self.Btn:setVisible(bl)
	if not bl then
		if self.view:getChildByName("effofname") then
			self.view:getChildByName("effofname"):removeFromParent()
		end
	end 
end

function ChangeFormationWidget:removePet()
	if self.Pet then
		self.Btn:setVisible(true)
		self.Pet:removeFromParent()
		self.Pet = nil 
	end
end
function ChangeFormationWidget:getPet()
	if self.Pet then
		return self.Pet
	end
	return nil
end




return ChangeFormationWidget