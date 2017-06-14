local VipView = class("VipView",base.BaseView)

function VipView:init()
	-- body
	--proxy.shop:send111004() -- 求 那些可领取
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	--
	G_FitScreen(self,"Image_1")
	--
	local img_bg = self.view:getChildByName("Image_bg")
	--vip
	self.img_cur_vip1 = img_bg:getChildByName("Image_43_0")
	self.img_cur_vip2 = img_bg:getChildByName("img_vip_big") 
	self.loadBar_exp = img_bg:getChildByName("Text_2_0_0") 
	self.laodbar_progress = img_bg:getChildByName("LoadingBar_2")
	--vip 可能顶级不显示
	--
	self.img_cur_vip3 = img_bg:getChildByName("img_vip_xiao")
	self.img_cur_vip3:setVisible(false)
	self.dec1 = img_bg:getChildByName("Text_2")
	self.dec2 = img_bg:getChildByName("txt_more")
	self.img_1 = img_bg:getChildByName("img_zs")
	self.img_cur_vip4 = img_bg:getChildByName("Image_43_0_0")
	--
	local btn = img_bg:getChildByName("Button_4")
	btn:addTouchEventListener(handler(self, self.onBtnReflahCallBack))

	local btn_close = img_bg:getChildByName("Button_close")
	btn_close:addTouchEventListener(handler(self, self.onbtnClose))
	--翻页
	self.pv = img_bg:getChildByName("PageView_2")
	self.pv:addEventListener(handler(self, self.onpvViewCallBack))

	self.item = self.view:getChildByName("Panel_3")
	self.item:setVisible(false)

	self.panle1 = self.view:getChildByName("Panel_1")
	self.panle2 = self.view:getChildByName("Panel_1_0")

	self.panle3 = img_bg:getChildByName("Panel_2"):getChildByName("Panel_2_0")

	local btn_r = img_bg:getChildByName("Image_40")
	btn_r:addTouchEventListener(handler(self, self.imgleftcall)) 

	local btn_l = img_bg:getChildByName("Image_40_0")
	btn_l:addTouchEventListener(handler(self, self.imgrightcall))

	self:initDec()
	self:initData()
	self:initPageView()
end

function VipView:initDec()
	-- body
	local img_bg = self.view:getChildByName("Image_bg")
	img_bg:getChildByName("Text_2_0"):setString(res.str.VIP_DEC_01)
	img_bg:getChildByName("Text_2"):setString(res.str.VIP_DEC_02)
	img_bg:getChildByName("txt_more"):setString(res.str.VIP_DEC_03)
	img_bg:getChildByName("Button_4"):setTitleText(res.str.VIP_DEC_04)

end

function VipView:onpvViewCallBack(sender, eventType)
	-- body
	if eventType == 0 then 
		print("回调")
	end
end

function VipView:initData()
	-- body
	self.curvip = cache.Player:getVip() 
	self.curvip = self.curvip == 0 and 1 or self.curvip
	local path = res.icon.VIP_LV[self.curvip]
	local max = #res.icon.VIP_LV
	--进度
	local vipexp = cache.Player:getVipExp() --当前vip经验
	local dd = self.curvip >= max and max or self.curvip+1
	local nextneedexp = conf.Recharge:getNextExp(dd)
	if not  nextneedexp or nextneedexp == 0 then 
		nextneedexp = vipexp
	end 
	self.loadBar_exp:setString(vipexp.."/"..nextneedexp) 
	self.laodbar_progress:setPercent(vipexp*100/nextneedexp)

	self.img_cur_vip1:loadTexture(res.font.VIP[self.curvip])
	self.img_cur_vip2:loadTexture(path)
	
	if self.curvip >= max then --顶级
		self.img_cur_vip3:setVisible(false)
		self.dec1:setVisible(false)
		self.dec2:setVisible(false)
		self.img_1:setVisible(false)
		self.img_cur_vip4:setVisible(false)
	else
		--self.img_cur_vip3:loadTexture(res.icon.VIP_LV[self.curvip+1])
		local vipspr = display.newGraySprite(res.icon.VIP_LV[self.curvip+1])
		vipspr:setPosition(self.img_cur_vip3:getPosition())
		vipspr:addTo(self.img_cur_vip3:getParent()) 

		self.img_cur_vip4:loadTexture(res.font.VIP[self.curvip+1])
		self.dec2:setString(string.format(res.str.SHOP_RECHARGE,nextneedexp-vipexp))
		self.img_cur_vip4:loadTexture(res.font.VIP[self.curvip+1])
		self.img_cur_vip4:ignoreContentAdaptWithSize(true)
		self.img_cur_vip4:setPositionX(self.dec2:getPositionX()+self.dec2:getContentSize().width+5)
	end 
end

function VipView:run(dir)
	-- body
	local a1 = cc.MoveTo:create(0.5,cc.p(self.panle3:getPositionX()+dir*self.panle3:getContentSize().width,0))
	self.panle3:runAction(a1)
end


function VipView:imgrightcall( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self.pos - 1 < -16 then 
			return 
		end
		self.pos = self.pos - 1
		self:run(-1)


		

		--[[local max =  #res.icon.VIP_LV
		local topage  = self.pv:getCurPageIndex()+1
		if topage<=max then 
			self.pv:scrollToPage(topage)
		end]]--
	end
end


function VipView:imgleftcall( send,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self.pos + 1 > 0 then 
			return 
		end
		self.pos = self.pos + 1
		self:run(1)
		--local x = self.pos*self.panle3:getContentSize().width
		--self.panle3:setPositionX(x)
		--[[local topage  = self.pv:getCurPageIndex()-1
		if topage>=0 then 
			self.pv:scrollToPage(topage)
		end]]--
	end
end

function VipView:initPageView( ... )
	-- body
	for  i = 1 ,conf.Recharge:getVipcount()  do 
		local content = self.item:clone()
		content:setVisible(true)
		--content:setPosition(0,0)
		content:setPosition(self.panle3:getContentSize().width*(i-1),0)
		content:addTo(self.panle3)

		--self.pv:addPage(content)

		local img_vip = content:getChildByName("Image_36")
		img_vip:loadTexture(res.icon.VIP_LV[i])

		local  img_dec = content:getChildByName("Image_36_0_0")
		local lvview = content:getChildByName("ListView_1")
		local t = conf.Recharge:getDec(i)
		if t then 
			for k ,v in pairs(t) do 
				local _lab =  self.panle1:clone()
				local img = _lab:getChildByName("Image_36_0_0")
				img:ignoreContentAdaptWithSize(true)
				if k > 1 then 
					img:setVisible(false)
				end 
				local txtimg = _lab:getChildByName("Text_19")
				txtimg:setString(v)
				lvview:pushBackCustomItem(_lab)
			end 
		end 
		local d = conf.Recharge:getDec_2(i)
		if d then 
			local ttt = {}
			for k ,v in pairs(d) do 
				local _lab =  self.panle2:clone()

				local img = _lab:getChildByName("Image_36_0_0_3")
				img:loadTexture(res.font.VIP_DEC[v[1]])
				img:ignoreContentAdaptWithSize(true)

				local img_xian = _lab:getChildByName("Image_4")
				if ttt[v[1]] then 
					img:setVisible(false)
					img_xian:setVisible(false)
				else
					ttt[v[1]] = v[1]
				end

				local txt = _lab:getChildByName("Text_19_2")
				txt:setString(v[2])
				lvview:pushBackCustomItem(_lab)
			end 
		end 
	end	
	self.pos = 1-self.curvip

	local  x = self.pos*self.panle3:getContentSize().width
	self.panle3:setPositionX(x)

	--local x = self.pos*self.panle3:getContentSize().width
	--self.panle3:setPositionX(x)

	--self.pv:scrollToPage(self.curvip-1)
	--self.pv:setTouchEnabled(false)
end


function VipView:onbtnClose( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

--打开充值界面
function VipView:onBtnReflahCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--1 如果充值界面打开 2 充值界面没有打开 从主界面跳转（关闭其他已经打开界面）
		local __view = mgr.ViewMgr:get(_viewname.SHOP)
		if __view then 
			self:onCloseSelfView()
		else
			mgr.SceneMgr:getMainScene():changeView(4,_viewname.SHOP)
			self:onCloseSelfView()	
		end	
	end
end

function VipView:onCloseSelfView( )
	-- body
	self:closeSelfView()
end

return VipView
