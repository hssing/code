local SpirteLvUpAutobuyView=class("SpirteLvUpAutobuyView",base.BaseView)

function SpirteLvUpAutobuyView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	--消耗的前
	local Panel_2 = self.view:getChildByName("Panel_2")

	self.cost = Panel_2:getChildByName("Text_1_0") 
	--
	self.amount = Panel_2:getChildByName("Image_3_0"):getChildByName("Text_1_0_0")

	self.name = Panel_2:getChildByName("Text_1_2_0")

	self._checkbox = Panel_2:getChildByName("CheckBox_1")
	self._checkbox:setSelected(false)

	local btncancel = Panel_2:getChildByName("Button_close_0")
	btncancel:addTouchEventListener(handler(self, self.onbtnCancel))

	self.button_sure = Panel_2:getChildByName("Button_2")
	self.button_sure:addTouchEventListener(handler(self, self.onCallBack))

	
	---------界面固定文本
	Panel_2:getChildByName("Text_1"):setString(res.str.PROMOTEN_DEC7)
	Panel_2:getChildByName("Text_1_1"):setString(res.str.PROMOTEN_DEC8)
	Panel_2:getChildByName("Text_1_2"):setString(res.str.PROMOTEN_DEC11)
	Panel_2:getChildByName("Text_1_3"):setString(res.str.PROMOTEN_DEC12)
	Panel_2:getChildByName("Text_1_3_0"):setString(res.str.PROMOTEN_DEC13)

	btncancel:getChildByName("Text_1_0_19_10"):setString(res.str.PROMOTEN_DEC9) 
	self.button_sure:getChildByName("Text_1_17_12"):setString(res.str.PROMOTEN_DEC10) 

end 


--[[function SpirteLvUpAutobuyView:checkBoxCallback( sender,eventtype )
	-- body
	if eventtype == ccui.CheckBoxEventType.selected then
		MyUserDefault.setIntegerForKey(user_default_keys.GAME_SPRITE_DAY,os.time())
	end 
end]]--

function SpirteLvUpAutobuyView:setData(data)
	-- body
	self.data = data

	local name = conf.Item:getName(data.mId)
	self.name:setString(name)

	self.amount:setString(data.amount)
	--print(data.mId)
	local tab = conf.Sys:getValue("card_jinjie_tuihui_exp_items")
	--printt(tab)
	local price = 0
	for k ,v in pairs(tab) do 
		if tonumber(v[1]) == tonumber(data.mId) then 
			price = tonumber(v[3])
			break
		end 
	end  
	self.cost:setString(price*data.amount)
end

function SpirteLvUpAutobuyView:onCallBack( sender,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		local ff 
		if self._checkbox then 
			ff=  self._checkbox:isSelected()
		end
		self.data.sure(ff)
	end
end

function SpirteLvUpAutobuyView:onbtnCancel(sender,eventtype)
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function SpirteLvUpAutobuyView:onCloseSelfView( )
	-- body
	self:closeSelfView()
end

return SpirteLvUpAutobuyView