

local CreatePetView=class("CreatePetView",base.BaseView)
local pet= require("game.things.PetUi")
local ScollLayer = require("game.cocosstudioui.ScollLayer")

function CreatePetView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.bg = self.view:getChildByName("Image_13")

	local startbtn = self.view:getChildByName("Button_5")
	startbtn:addTouchEventListener(handler(self, self.createAccount)) 

	self.pet_pos3 = self.view:getChildByName("Image_17_0")
	local btn = self.pet_pos3:getChildByName("Panel_2_1")
	btn:addTouchEventListener(function(sender,eventtype)
		-- body
		if eventtype == ccui.TouchEventType.ended then 
			self:next() 
		end 
	end)

	self.pet_pos2 = self.view:getChildByName("Image_17")

	self.pet_pos1 = self.view:getChildByName("Image_17_1")
	local btn1 = self.pet_pos1:getChildByName("Panel_2_0")
	btn1:addTouchEventListener(function(sender,eventtype)
		-- body
		if eventtype == ccui.TouchEventType.ended then 
			self:prv()
		end 
	end)
	


	local panle = self.view:getChildByName("Panel_14")
	--做滑动----------------------------------
	local rect =cc.rect(panle:getPositionX(),panle:getPositionY(),
	panle:getContentSize().width,panle:getContentSize().height)
	local layer = ScollLayer.new(rect,rect.width/3)
	self:addChild(layer)
	layer:setMoveLeftCalllBack(handler(self,self.prv))
	layer:setMoveRightCalllBack(handler(self,self.next)) 
	--3个形象位置
	self.model_1 =  self.view:getChildByName("Panel_11"):getChildByName("Image_14")
	self.model_name1 = self.view:getChildByName("Panel_11"):getChildByName("Image_22_0_0")
	self.model_name1:ignoreContentAdaptWithSize(true)



	self.model_2 =  self.view:getChildByName("Panel_11"):getChildByName("Image_14_0_0")
	self.model_name2 = self.view:getChildByName("Panel_11"):getChildByName("Image_22")
	self.model_name2:ignoreContentAdaptWithSize(true)

	self.model_3 =  self.view:getChildByName("Panel_11"):getChildByName("Image_14_0")
	self.model_name3 = self.view:getChildByName("Panel_11"):getChildByName("Image_22_0")
	self.model_name3:ignoreContentAdaptWithSize(true)

	--
	self.lab_di = self.view:getChildByName("Image_20")

	self.dataModel = {}

	local t = {}
	t.mId = 231005001
	t.propertys = {}
	t.propertys[307] ={}
	t.propertys[307].value = 0

	table.insert(self.dataModel,t)

	local t1 = clone(t)
	t1.mId = 231005003
	table.insert(self.dataModel,t1)

	local t2 = clone(t)
	t2.mId = 231005013
	table.insert(self.dataModel,t2)

	self:initpet()

	self:performWithDelay(function()
			self:forever()--永恒动画
	end, 0.1)

end

function CreatePetView:forever()
	-- body
	local params =  {id=404817, x=self.bg:getContentSize().width/2,
	y=self.bg:getContentSize().height/2,
	addTo=self.bg,
	playIndex=1,
	addName = "effofname" }
	mgr.effect:playEffect(params)
end

function CreatePetView:prv()
	-- body

	if self.data.career - 1>0 then 
		self.data.career = self.data.career-1
	else
		self.data.career = 3 
	end
	self.dir = -1 --左
	self:RoleChangeAction()
end

function CreatePetView:next()
	-- body
	if self.data.career + 1>3 then 
		self.data.career = 1
	else
		self.data.career =self.data.career +1
	end
	self.dir = 1 --右
	self:RoleChangeAction()
end

--
function CreatePetView:RoleChangeAction()
	-- body
	local function act1( pos,scale )
		-- body
		local a1 = cc.MoveTo:create(0.2,cc.p(pos.x,pos.y))
		local a2 = cc.ScaleTo:create(0.2,scale)
		return cc.Spawn:create(a1,a2)
	end
	--debugprint("self.data.career = "..self.data.career.." self.dir = "..self.dir)
	
	for i = 1 , 3 do 
		self["pet"..i].setpos = self["pet"..i].setpos - self.dir
		if self["pet"..i].setpos > 3 then 
			self["pet"..i].setpos = 1
		elseif self["pet"..i].setpos < 1 then 
			self["pet"..i].setpos = 3
		end 

		self["pet"..i]:stopAllActions()

		local pos = clone(self["pet_pos_"..self["pet"..i].setpos])
		pos.y = pos.y +self["pet_pos"..self["pet"..i].setpos]:getContentSize().height/2
		local scale = 0.5
		if self.data.career == i then 
			pos.y = pos.y+ 20
			scale = 0.85
		else
			pos.y = pos.y+ 10
		end 

		self["pet"..i]:runAction(act1(pos,scale))
	end 

	self:initCurrPet()
end

function CreatePetView:initCurrPet()
	-- body
	local data = clone(self.dataModel[self.data.career])
	--信息
	local t = {}
	local t_lab = {} 
	if self.data.career == 1 then 
		t = res.font.PET.JIABUSHOU
		t_lab.name =res.str.LOGIN_CARD2
		t_lab.dec1 = res.str.LOGIN_CARD7
		t_lab.dec2 = res.str.LOGIN_DEC_03
	elseif self.data.career == 2 then 
		t = res.font.PET.YAGUSHOU
		t_lab.name =res.str.LOGIN_CARD1
		t_lab.dec1 = res.str.LOGIN_CARD5
		t_lab.dec2 = res.str.LOGIN_DEC_01
	else
		t = res.font.PET.BADASHOU
		t_lab.name =res.str.LOGIN_CARD3
		t_lab.dec1 = res.str.LOGIN_CARD6
		t_lab.dec2 = res.str.LOGIN_DEC_02
	end 
	--3个数码兽初始位置
	for i = 1 , 3 do 
		self["model_"..i]:removeAllChildren()
		data.propertys[307].value = data.propertys[307].value + 1
		local pet =  pet.new(data.mId,data.propertys)
		pet:setScale(0.7)
		if i == 3 then 
			pet:setScaleX(-0.7)
		end 
		pet:setPosition(self["model_"..i]:getContentSize().width/2, self["model_"..i]:getContentSize().height/2)
		if i == 1 then 
			pet:setPositionX(pet:getPositionX()+5)
		end 
		pet:addTo(self["model_"..i])

		
		self["model_name"..i]:loadTexture(t[i])
	end 
	--数码兽描述
	local w = 0
	if not self.lab_name then 
		self.lab_name =  display.newTTFLabel({
		    text = "",
		    size = 20,
		    align = cc.ui.TEXT_ALIGNMENT_LEFT ,-- 文字内部居中对齐
		    x = 0,
		    y = self.lab_di:getContentSize().height/2,
		    color = cc.c3b(255, 192, 0),
		})
		self.lab_name:setAnchorPoint(cc.p(0,0.5))
		self.lab_name:addTo(self.lab_di)
	end
	self.lab_name:setString(t_lab.name..":"..res.str.LOGIN_CARD4)
	w = w +self.lab_name:getContentSize().width

	if not self.lab_dec1 then 
		self.lab_dec1 =  display.newTTFLabel({
		    text = "",
		    size = 20,
		    align = cc.ui.TEXT_ALIGNMENT_LEFT ,-- 文字内部居中对齐
		    x = w,
		    y = self.lab_di:getContentSize().height/2,
		    color = cc.c3b(0, 255, 0),
		})
		self.lab_dec1:setAnchorPoint(cc.p(0,0.5))
		self.lab_dec1:addTo(self.lab_di)
	end 
	self.lab_dec1:setString(t_lab.dec1)
	w = w +self.lab_dec1:getContentSize().width

	if not self.lab_dec2 then 
		self.lab_dec2 =  display.newTTFLabel({
		    text = "",
		    size = 20,
		    align = cc.ui.TEXT_ALIGNMENT_LEFT ,-- 文字内部居中对齐
		    x = w,
		    y = self.lab_di:getContentSize().height/2,
		    color = cc.c3b(255, 192, 0),
		})
		self.lab_dec2:setAnchorPoint(cc.p(0,0.5))
		self.lab_dec2:addTo(self.lab_di)
	end 
	self.lab_dec2:setString(t_lab.dec2)
	w = w +self.lab_dec2:getContentSize().width
	--居中对齐
	local x = (self.lab_di:getContentSize().width-w)/2
	self.lab_name:setPositionX(x)
	self.lab_dec1:setPositionX(x+self.lab_name:getContentSize().width)
	self.lab_dec2:setPositionX(x+self.lab_name:getContentSize().width+self.lab_dec1:getContentSize().width)
end

function CreatePetView:initpet()
	-- body
	--位置
	local pos = {}
	pos.x = self.pet_pos3:getPositionX()
	pos.y = self.pet_pos3:getPositionY()

	self.pet_pos_3 = clone(pos)

	local pos = {}
	pos.x= self.pet_pos2:getPositionX()
	pos.y = self.pet_pos2:getPositionY()
	self.pet_pos_2 = clone(pos)

	local pos = {}
	pos.x = self.pet_pos1:getPositionX()
	pos.y = self.pet_pos1:getPositionY()
	self.pet_pos_1 = clone(pos)
	--巴达兽
	local data = self.dataModel[3]
	self.pet3 = pet.new(data.mId,data.propertys)
	self.pet3:setScale(0.5)
	self.pet3:setPosition(
	self.pet_pos_3.x,
	self.pet_pos_3.y+self.pet_pos3:getContentSize().height/2+10
	)
	self.pet3:addTo(self.view)
	self.pet3.setpos = 3 --当前站位

	--亚古兽
	local data = self.dataModel[2]
	data = {mId=231005003,propertys={}}
	self.pet2 = pet.new(data.mId,data.propertys)
	self.pet2:setScale(0.85)
	self.pet2:setPosition(
	self.pet_pos_2.x,
	self.pet_pos_2.y+self.pet_pos2:getContentSize().height/2+30
	)
	self.pet2:addTo(self.view)
	self.pet2.setpos = 2 --当前站位
	--加布兽
	local data = self.dataModel[1]
	data = {mId=231005001,propertys={}}
	self.pet1 = pet.new(data.mId,data.propertys)
	self.pet1:setScale(0.5)
	self.pet1:setPosition(
	self.pet_pos_1.x,
	self.pet_pos_1.y+self.pet_pos1:getContentSize().height/2+10
	)
	self.pet1:addTo(self.view)
	self.pet1.setpos = 1 --当前站位
end

function CreatePetView:setData(data)
	-- body
	self.data = data
	--默认第一选择亚古兽
	self.data.career = 2
	self:initCurrPet()
end


--开始游戏
function CreatePetView:createAccount( sender_,eventType_ )
	-- body
	if eventType_ == ccui.TouchEventType.ended then
		-- 特别处理一下  1 才是亚古兽 2 是加布兽
		if self.data.career == 1 then 
			self.data.career = 2
		elseif self.data.career == 2 then 
			self.data.career = 1 
		end 

		proxy.Login:sendChangeCarrer(self.data.career)
	end
end

function CreatePetView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CreatePetView