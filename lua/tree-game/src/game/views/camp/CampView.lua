
local CampView = class("CampView",base.BaseView)

function CampView:init()
	-- body
	self.ShowAll=true
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    local panle1 = self.view:getChildByName("Panel_1")
    self.panle1 = panle1
    --时间
    self.imgdi = panle1:getChildByName("Image_15")
    self.lab_time = self.imgdi:getChildByName("Text_1_0")
    --排名
    local _img = panle1:getChildByName("Image_16")
    --名字 连胜
    for i = 1 , 3 do 
    	self["lab_name"..i] = _img:getChildByName("dec_"..i)
    	self["wincount"..i] = _img:getChildByName("value_"..i)
    end
    
    --规则
    local btn = panle1:getChildByName("Button_2_0")
    btn:addTouchEventListener(handler(self,self.onBtnGuize))
    --退出
    local btnclose = panle1:getChildByName("Button_2")	
    btnclose:addTouchEventListener(handler(self,self.onBtnClose))
    --参战
    local btn_canzhan = self.view:getChildByName("Panel_2"):getChildByName("Button_1")	 
    btn_canzhan:addTouchEventListener(handler(self,self.onbtnCanzhan))

    self:initDec()

    

    self:schedule(self.changeTimes,1.0,"changeTimes")

    G_FitScreen(self,"Image_1")
end

function CampView:initDec()
	-- body
	self.dec1 = self.imgdi:getChildByName("Text_1")
	self.dec1:setString(res.str.DEC_ERR_31)

	local bg = self.view:getChildByName("Image_1")
	self.armature =mgr.BoneLoad:createArmature(404849)
	self.armature:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2)
	self.armature:addTo(bg)
	self.armature:getAnimation():playWithIndex(0)
end

function CampView:setData()
	-- body
	self.data = cache.Camp:getData()
	self:changeTimes()
	for k, v in pairs(self.data.topWinner) do 
		self["lab_name"..k]:setString(v.roleName)
		self["wincount"..k]:setString(string.format(res.str.DEC_ERR_33,v.rankConCout))
	end
end

function CampView:changeTimes()
	-- body
	self.data.leftTime = self.data.leftTime - 1 
	if self.data.leftTime <= 0 or self.data.timeStatu == 1  then 
		self.lab_time:setString(res.str.DEC_ERR_32)
		self.dec1:setVisible(false)

		--self.lab_time:setAnchorPoint(cc.p(0.5,0.5))
		self.lab_time:setPositionX(self.imgdi:getContentSize().width/2-self.lab_time:getContentSize().width/2)
		return 
	end
	self.lab_time:setString(string.formatNumberToTimeString(self.data.leftTime))	
end
--产站
function CampView:onbtnCanzhan( send, eventtype )
	-- body
	--请求参战
	if eventtype == ccui.TouchEventType.ended then 
		if not self.data  then 
			return 
		end 
		if self.data.leftTime >0 and self.data.timeStatu == 0 then 
			G_TipsOfstr(res.str.DEC_ERR_34)
			return 
		end
		proxy.Camp:send120102()
		mgr.NetMgr:wait(520102)
	end
end
--规则
function CampView:onBtnGuize(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(14)
	end 
end
function CampView:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end
function CampView:onCloseSelfView()
	-- body
	self:closeSelfView()
	local view = mgr.ViewMgr:get(_viewname.FUNBENVIEW)
	if view then 
		local scene =  mgr.SceneMgr:getMainScene()
	    if scene then 
	        scene:addHeadView()
	    end 
	end 
end

return CampView