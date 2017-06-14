
local Dig_SearchView = class("Dig_SearchView",base.BaseView)

function Dig_SearchView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local btn = self.view:getChildByName("Image_bg"):getChildByName("Button_buy_more_7_8")
	btn:addTouchEventListener(handler(self, self.onbtnNext))

	local lab = btn:getChildByName("Text_1_2_12_13")
	lab:setString(res.str.DIG_DEC63)
end

function Dig_SearchView:setData()
	-- body
	local _name_di = self.view:getChildByName("Image_bg"):getChildByName("Image_19")
	self.lab_name = cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _name_di:getPositionX(),
	    y = _name_di:getPositionY(),
	    size = cc.size(_name_di:getContentSize().width,_name_di:getContentSize().height)
	})
	
	self.lab_name:setMaxLength(5)
	self.lab_name:setPlaceHolder(res.str.LOGIN_DEC_05)
	self.lab_name:addTo(self.view:getChildByName("Image_bg"))
	self.lab_name:registerScriptEditBoxHandler(handler(self, self.onName))

	self.view:reorderChild(_name_di,500)
	self.view:reorderChild(self.lab_name,400)


	--拿来做居中显示，妈的
	self.label = display.newTTFLabel({
    text = res.str.LOGIN_DEC_05,
    font = res.ttf[1],
    size = 40,
    color = COLOR[1], 
    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
    x=_name_di:getContentSize().width/2,
    y=_name_di:getContentSize().height/2,
    })
    self.label:setAnchorPoint(cc.p(0.5,0.5))
    self.label:addTo(_name_di)
end

function Dig_SearchView:onName( eventType )
	-- body
	if eventType == "began" then
	elseif  eventType == "ended" then
		local str = (self.lab_name:getText())
		if str == "" then 
			self.label:setString(res.str.LOGIN_DEC_05)
		else
			self.label:setString(str)
		end 
	elseif eventType == "changed" then
	elseif eventType == "return" then
		local str = (self.lab_name:getText())
		if str == "" then 
			self.label:setString(res.str.LOGIN_DEC_05)
		else
			self.label:setString(str)
		end 
	end
end

function Dig_SearchView:onbtnNext( sender_,eventType_ )
	-- body
	if eventType_ == ccui.TouchEventType.ended then
		local str = G_filterChar(self.label:getString())
		local len = string.utf8len(str)
		
		if string.find(self.label:getString()," ") ~=nil then --不允许空格
			G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_NO)
			return 
		elseif string.len(str) ~= string.len(self.lab_name:getText()) then  --非法字符
			G_TipsOfstr(res.str.GUILD_DEC12)
			return  
			--todo
		end

		local param = {roleId = {key = -1} , roleName = str ,type = 2}
		proxy.Dig:sendDigMainMsg(param)
		mgr.NetMgr:wait(520002)

		self:onCloseSelfView()
	end
end

function Dig_SearchView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Dig_SearchView