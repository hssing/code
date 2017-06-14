local HeadView=class("HeadView",base.BaseView)

function HeadView:init(  )
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	self:setTouchEnabled(false)

	self.bg_left=self.view:getChildByName("bg_head_left")
	self.bg_right=self.view:getChildByName("bg_head_right")

	local btn = self.bg_right:getChildByName("Button_2") 
	btn:addTouchEventListener(handler(self, self.Onbtnrecharge))

	local btnleft = self.bg_left:getChildByName("Button_1")
	btnleft:addTouchEventListener(handler(self, self.onbuyTili))

	self.Panel = self.view:getChildByName("Panel_2")
	self.btn_head=self.Panel:getChildByName("Button_Figure")
	self.btn_head:addTouchEventListener(handler(self,self.onHeadCallBack))

	self.Img_Vip = self.view:getChildByName("Panel_2"):getChildByName("Image_vip")
	self.Img_Vip_Num = self.view:getChildByName("Panel_2"):getChildByName("AtlasLabel")

	self.Name = self.bg_left:getChildByName("Text")
	self.Name:setFontName(display.DEFAULT_TTF_FONT )

	self.Jb = self.bg_left:getChildByName("Image_2"):getChildByName("Text_0")
	self.Tl = self.bg_left:getChildByName("Image_2_0"):getChildByName("Text_0_0")
	self.Hz = self.bg_right:getChildByName("Image_2_0_0"):getChildByName("Text_0_0_0")
	self.Zs = self.bg_right:getChildByName("Image_2_0_0_0"):getChildByName("Text_0_0_0_0")
	self.power = self.bg_right:getChildByName("Text_1")
	self.lv = self.bg_left:getChildByName("AtlasLabel_lv")
	self.spr =self.Panel:getChildByName("Image_head") 

	self:headAction()
	self:updateUi()

	if res.banshu then 
		btn:setVisible(false)
	end 

	self:schedule(self.changeTimes,1.0,"changeTimes")
end

function HeadView:headAction(  )
	local lift_w=self.bg_left:getContentSize().width
	local right_w=self.bg_right:getContentSize().width
	local head_h=self.btn_head:getContentSize().height
	self.bg_left:setPositionX(-lift_w/2)
	self.bg_right:setPositionX(CONFIG_SCREEN_WIDTH+right_w/2)

	self.Panel:setPositionY(CONFIG_SCREEN_HEIGHT+head_h/2)


	local fun=function (  )
		self.bg_left:runAction(cc.MoveTo:create(0.3,cc.p(lift_w/2,self.bg_left:getPositionY())))
		self.bg_right:runAction(cc.MoveTo:create(0.3,cc.p(CONFIG_SCREEN_WIDTH-lift_w/2,self.bg_left:getPositionY())))
	end
	local action=cc.MoveTo:create(0.2,cc.p(self.Panel:getPositionX(),CONFIG_SCREEN_HEIGHT-189))
	local action1=cc.CallFunc:create(fun)
	local sqe=cc.Sequence:create(action,action1)
	self.Panel:runAction(sqe)
end
function HeadView:updateUi(  )
	local sex =  cache.Player:getRoleSex()
	--print("sex = "..sex)
	--[[local path = sex == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	self.spr:loadTexture(path)]]

	local id = cache.Player:getHead()

	local temp = G_Split_Back(id)
	self.spr:loadTexture(temp.icon_img)

	local jb = cache.Fortune:getJb()
	local Zs = cache.Fortune:getZs()
	local Hz = cache.Fortune:getHz()
	self.Jb:setString(G_transFormMoney(jb))
	self.Hz:setString(G_transFormMoney(Hz))
	self.Zs:setString(G_transFormMoney(Zs))	

	-- local data=cache.Player:getRoleInfo()

    local lv = cache.Player:getLevel()
	local power = cache.Player:getPower()
	local name =cache.Player:getName()
	local viplv=cache.Player:getVip()
	local tili = cache.Player:getTili()
	local maxid = cache.Player:getMaxtli()
	self.power:setString(power)
	self.lv:setString(lv)
	self.Name:setString(name)
	self.Img_Vip:loadTexture(res.font.VIP[viplv])



	local maxti = cache.Player:getMaxtli()
	local count = cache.Player:getTili()

	self.Tl:setString(cache.Player:getTili().."/"..maxti)

end
function HeadView:onHeadCallBack(send,eventtype)
	if eventtype ==  ccui.TouchEventType.ended then
		
		mgr.ViewMgr:showView(_viewname.ROLE)
	end
end

function HeadView:changeTimes()
	-- body
	local maxti = cache.Player:getMaxtli()
	local count = cache.Player:getTili()
	self.Tl:setString(count.."/"..maxti)
end

---跳转充值
function HeadView:Onbtnrecharge(send,eventtype)
	if eventtype ==  ccui.TouchEventType.ended then
		--[[if g_recharge then 
		
			G_TipsOfstr(res.str.ROLE_GONGHUI)
			return
		end ]]--
		G_GoReCharge()
	end
end

function HeadView:onbuyTili( sender,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then

		if cache.Player:getTili() < cache.Player:getMaxtli()  then 
			--G_GoBuyTili()
			 proxy.Radio:send101006(40411)
		else
			G_TipsOfstr( res.str.ROLE_TILI_MAX)
		end 
	end
end




return HeadView