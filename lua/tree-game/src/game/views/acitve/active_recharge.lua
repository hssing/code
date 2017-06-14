
local active_recharge = class("active_recharge",function()
	-- body
	return ccui.Widget:create()
end)

function active_recharge:init(Parent)
	-- body
	self.Parent=Parent
	self.view=Parent:getCloneRe_item()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self.view:setTouchEnabled(false)
	self:addChild(self.view)
	self.lab_money = self.view:getChildByName("Text_40")
	self.lab_dec1 = self.view:getChildByName("Text_40_0_0")

	self.rewardframe = {}
	for i = 1 , 3 do 
		local t = {}
		t.frame = self.view:getChildByName("btn_frame"..i)
		t.spr = t.frame:getChildByTag(1)
		t.spr:ignoreContentAdaptWithSize(true)
		t.name = self.view:getChildByName("lab_name"..i)

		t.frame:setVisible(false)
		t.name:setVisible(false)
		table.insert(self.rewardframe,t)
	end

	self.btn = self.view:getChildByName("Button_2")
		--self.btn.index = v.id
	self.btn_lab = self.btn:getChildByName("Text_1_17_58")

	self.lab_count = self.view:getChildByName("Text_40_0_0_0") 
	--lab_count:setString("0")
end


function active_recharge:onGetCallBack(sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local tag =  sender_:getTag()
		if tag == 1 then 
			local data = {index = sender_.index}
			proxy.Double:send116068(data)
			mgr.NetMgr:wait(516068)
		else
			G_TipsOfstr(res.str.DOUBLE_DEC12)
		end
	end 
end

function active_recharge:setBtnStatue(state)
	-- body
	if not state then 
		self.lab_count:setString("1")
		self.btn:setTag(10000)
		self.btn_lab:setString(res.str.DOUBLE_DEC9)
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)
	elseif state == 1 then 
		self.btn:setTag(state)
		self.lab_count:setString("1")
		self.btn_lab:setString(res.str.DOUBLE_DEC10)

	else
		self.btn:setTag(state)
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)
		self.lab_count:setString("0")
		self.btn_lab:setString(res.str.DOUBLE_DEC11)
	end

	self.btn:addTouchEventListener(handler(self, self.onGetCallBack))
end

function active_recharge:setData(data_)
	-- body
	self.data = data_
	self.lab_money:setString(string.format(res.str.DOUBLE_DEC7,data_.quota/10))
	self.lab_dec1:setString(res.str.DOUBLE_DEC8)
	for i , j in pairs(data_.gifts) do 
		local widget = self.rewardframe[i]
		local colorlv = conf.Item:getItemQuality(j[1])
		widget.frame:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(j[1]))
		widget.name:setString(conf.Item:getName(j[1]).."x"..j[2])
		widget.name:setColor(COLOR[colorlv])

		widget.frame:setVisible(true)
		widget.name:setVisible(true)
	end

	self.btn.index = data_.id
	self.lab_count:setString("0")
end

return active_recharge