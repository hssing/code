local CreateRoleView=class("CreateRoleView",base.BaseView)

local ScollLayer = require("game.cocosstudioui.ScollLayer")


function CreateRoleView:ctor( ... )
	-- body
	--
	--职业
	self.career = 0
	--
	self.roleSex = 1 

	self.roleName = ""

	self.roleKey = ""


end

function CreateRoleView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	--bg 
	self.bg = self.view:getChildByName("Image_1")

	--形象 
	local img = self.view:getChildByName("Image_8")
	img:addTouchEventListener(function( sender,eventType_ )
		-- body
		if eventType_ == ccui.TouchEventType.ended then
			self.roleSex = 1 
			self:RoleChangeAction()
		end 
	end)

	self.model_boy = img:getChildByName("Image_12")
	local pos = {}
	pos.x= self.model_boy:getPositionX()
	pos.y= self.model_boy:getPositionY()
	self.oldposboy=clone(pos)

	local img2 = self.view:getChildByName("Image_8_1")
	img2:addTouchEventListener(function( sender,eventType_)
		-- body
		if eventType_ == ccui.TouchEventType.ended then
			self.roleSex = 2
			self:RoleChangeAction()
		end 
	end)

	self.model_gril = img2:getChildByName("Image_10_0")
	local pos = {}
	pos.x= self.model_gril:getPositionX()
	pos.y= self.model_gril:getPositionY()
	self.oldposgril=clone(pos)

	--形象大 位置
	self.panle = self.view:getChildByName("Panel_4")	
	--形象切换
	local _prv =self.view:getChildByName("Button_2") 
	_prv:addTouchEventListener(handler(self, self.btnmodel))

	local _next =self.view:getChildByName("Button_2_0") 
	_next:addTouchEventListener(handler(self, self.btnmodel))

	--做滑动----------------------------------
	local rect =cc.rect(self.panle:getPositionX(),self.panle:getPositionY(),
	self.panle:getContentSize().width,self.panle:getContentSize().height)
	local layer = ScollLayer.new(rect,rect.width/3)
	self:addChild(layer)
	layer:setMoveLeftCalllBack(handler(self,self.tochangemodel))
	layer:setMoveRightCalllBack(handler(self,self.tochangemodel))
	--输入验证码
	local _code_di = self.view:getChildByName("Image_4_0") 

	self.lab_code = cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _code_di:getPositionX(),
	    y = _code_di:getPositionY(),
	    size = cc.size(_code_di:getContentSize().width,_code_di:getContentSize().height*0.6)
	})
	self.lab_code:setPlaceHolder(res.str.LOGIN_DEC_04)
	self.lab_code:addTo(self.view)
	self.lab_code:setMaxLength(20)
	self.lab_code:registerScriptEditBoxHandler(handler(self, self.onCode))

	self.view:reorderChild(_code_di,500)
	self.view:reorderChild(self.lab_code,400)





	--拿来做居中显示，妈的
	self.label_code = display.newTTFLabel({
    text = res.str.LOGIN_DEC_04,
    font = res.ttf[1],
    size = 24,
    color = COLOR[1], 
    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
    x=_code_di:getContentSize().width/2,
    y=_code_di:getContentSize().height/2,
    })
    self.label_code:setAnchorPoint(cc.p(0.5,0.5))
    self.label_code:addTo(_code_di)

    if res.banshu then 
    	_code_di:setVisible(false)
    	self.label_code:setVisible(false)
    	self.lab_code:setVisible(false)
    end



    --_code_di:setVisible(false)
    --self.label_code:setVisible(false)
    --self.lab_code:setVisible(false)


	--名字
	local _name_di = self.view:getChildByName("Image_4") 
	self.lab_name = cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _name_di:getPositionX(),
	    y = _name_di:getPositionY(),
	    size = cc.size(_name_di:getContentSize().width,_name_di:getContentSize().height)
	})
	self.view:reorderChild(_name_di,500)
	self.view:reorderChild(self.lab_name,400)

	self.lab_name:setMaxLength(5)
	self.lab_name:setPlaceHolder(res.str.LOGIN_DEC_05)
	self.lab_name:addTo(self.view)
	self.lab_name:registerScriptEditBoxHandler(handler(self, self.onName))


	--拿来做居中显示，妈的
	self.label = display.newTTFLabel({
    text = "",
    font = res.ttf[1],
    size = 24,
    color = COLOR[1], 
    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
    x=_name_di:getContentSize().width/2,
    y=_name_di:getContentSize().height/2,
    })
    self.label:setAnchorPoint(cc.p(0.5,0.5))
    self.label:addTo(_name_di)

	--随机名字按钮
	local randbtn =  self.view:getChildByName("Button_4")
	randbtn:addTouchEventListener(handler(self, self.onbtnRandomcallbcak))
	self:onbtnRandomcallbcak( randbtn,ccui.TouchEventType.ended)
	--下一步
	local nextbtn = self.view:getChildByName("Button_1")
	nextbtn:addTouchEventListener(handler(self, self.onbtnNext))
	--G_FitScreen(self,"Image_1")
	--随机一个男女
	if  50>math.random(0,100) then 
		self.roleSex = 1 
	else
		self.roleSex = 2
	end 
	self:tochangemodel()

	G_FitScreen(self,"Image_1")

	self:performWithDelay(function()
			self:forever()--永恒动画
  		local effConfig = conf.Effect:getInfoById(404831)
  		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
  		end)
	end, 0.1)
end

function CreateRoleView:forever()
	-- body
	local params =  {id=404817, x=self.bg:getContentSize().width/2,
	y=self.bg:getContentSize().height/2,
	addTo=self.bg,
	playIndex=0,
	addName = "effofname" }
	mgr.effect:playEffect(params)
end

function CreateRoleView:onName( eventType )
	-- body
	if eventType == "began" then
	elseif  eventType == "ended" then
		local str = string.trim(self.lab_name:getText())
		if str == "" then 
			self.label:setString(res.str.LOGIN_DEC_05)
		else
			self.label:setString(str)
		end 
	elseif eventType == "changed" then
	elseif eventType == "return" then
		local str = string.trim(self.lab_name:getText())
		if str == "" then 
			self.label:setString(res.str.LOGIN_DEC_05)
		else
			self.label:setString(str)
		end 
	end
end

function CreateRoleView:onCode(eventType)
	-- body
	if eventType == "began" then
	elseif  eventType == "ended" then
		local str = string.trim(self.lab_code:getText())
		if str == "" then 
			self.label_code:setString(res.str.LOGIN_DEC_04)
		else
			self.label_code:setString(str)
		end 
	elseif eventType == "changed" then
	elseif eventType == "return" then
		local str = string.trim(self.lab_code:getText())
		--debugprint("heee  "..str)
		if str == "" then 
			self.label_code:setString(res.str.LOGIN_DEC_04)
		else
			self.label_code:setString(str)
		end 
	end
end


function CreateRoleView:tochangemodel()
	-- body
	self.roleSex = self.roleSex == 1 and 2 or 1  
	self:RoleChangeAction()
end

function CreateRoleView:btnmodel(sender,eventType_)
	-- body
	if eventType_ == ccui.TouchEventType.ended then
		self:tochangemodel()
	end 
end

function CreateRoleView:RoleChangeAction()
	-- body
	---第一形象改变
	self.model_boy:removeAllChildren()
	self.model_gril:removeAllChildren()

	local topos = self.panle:getWorldPosition()
	topos.x = topos.x+self.panle:getContentSize().width/2
	topos.y = topos.y+self.panle:getContentSize().height/2+70
	--printt(topos)
	local function act1( pos,scale )
		-- body
		local a1 = cc.MoveTo:create(0.2,cc.p(pos.x,pos.y))
		local a2 = cc.ScaleTo:create(0.2,scale)
		return cc.Spawn:create(a1,a2)
	end
	self.model_gril:stopAllActions()
	self.model_boy:stopAllActions()
	if self.roleSex == 1 then 
		topos = self.model_boy:getParent():convertToNodeSpace(topos)
		self.model_gril:runAction(act1(self.oldposgril,0.3))
		self.model_boy:runAction(act1(topos,0.97))
	else
		topos = self.model_gril:getParent():convertToNodeSpace(topos)
		self.model_boy:runAction(act1(self.oldposboy,0.3))
		self.model_gril:runAction(act1(topos,0.96))
	end 

	local addto = self.roleSex == 1 and self.model_boy or self.model_gril
	local scaless = self.roleSex == 1 and 1.2 or 1.4
	local index = self.roleSex - 1 

	local  offsety = self.roleSex == 1 and 2 or -5
	local  offsetx = self.roleSex == 1 and -2 or -1

	local params =  {id=404831, x=addto:getContentSize().width/2+offsetx,
	y=addto:getContentSize().height/2+offsety,addTo=addto,scale =scaless,
	playIndex=index,addName = "effofname" }

	

	addto:performWithDelay(function( ... )
		-- body
		mgr.effect:playEffect(params)
	end, 0.31)
	
end
--随机个名字
function CreateRoleView:onbtnRandomcallbcak( sender_,eventType_ )
	-- body
	if eventType_ == ccui.TouchEventType.ended then
		local txt = conf.Role:getName()
		self.lab_name:setText(txt)
		self.label:setString(self.lab_name:getText())
	end
end

---点击下一步返回
function CreateRoleView:setNext()
    if fight_newer_state == false then
    	--print("aaaa")
        self:newerFightEnd()
        self:createAccount()
        self:onCloseSelfView()
    else
    	--print("顶顶顶顶")
        --此处直接创号
        self:createAccount()
        --进入新手战斗
        --G_EnterNewerFight()
        --self:onCloseSelfView()
    end  
end

function CreateRoleView:newerFightEnd()
    --背景音乐
    local data ={
        career = self.career,
        roleSex = self.roleSex,
        roleName = string.trim(G_filterChar(self.lab_name:getText())),
        roleKey = self.lab_code:getText()
    }
    local view = mgr.ViewMgr:showView(_viewname.CREATE_ROLE_PET):setData(data)

    --检测是否断线
    mgr.NetMgr:showNetTips(-4)
end

function CreateRoleView:FightOver( )
    self:newerFightEnd()
    --self:createAccount()
    --self:onCloseSelfView()
end

function CreateRoleView:onbtnNext(sender_,eventType_)
	-- body
	if eventType_ == ccui.TouchEventType.ended then
		debugprint("检查名字")
		if string.find(self.lab_name:getText()," ") ~=nil then --不允许空格
			G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_NO)
			return 
		end 
		--玩家创号 时输入的邀请码
	    if self.lab_code:getText() ~= "" and self.lab_code:getText() ~= self.lab_code:getPlaceHolder()  then
	    	cache.Player:setCode(self.lab_code:getText()) 
	    end
		--proxy.Login:sendcheckName(string.trim(G_filterChar(self.lab_name:getText())))
		--mgr.NetMgr:wait(501008)
		
		
		self:setNext()
	end
end

function CreateRoleView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

function CreateRoleView:createAccount()
    local data ={
        career = self.career,
        roleSex = self.roleSex,
        roleName = string.trim(G_filterChar(self.lab_name:getText())),
        roleKey = self.lab_code:getText()
    }
    --零时保存信息
    cache.Player.DataInfo.sex = self.roleSex
    cache.Player.DataInfo.roleName = data.roleName
    proxy.Login:reqCreateRole(data)
end


return CreateRoleView