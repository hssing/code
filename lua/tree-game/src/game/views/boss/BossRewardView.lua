--[[
	世界boss 排行帮
]]

local BossRewardView = class("BossRewardView",base.BaseView)

function BossRewardView:init()
	-- body
	self.ShowAll = true
	self.showtype=view_show_type.UI   
    self.view=self:addSelfView()

    local panel1 = self.view:getChildByName("Panel_1")
    self.panel1 = panel1
    local btn_clsoe = panel1:getChildByName("Button_1_2")
    btn_clsoe:addTouchEventListener(handler(self,self.onBtnClose))

   	self.cloneitem = self.view:getChildByName("Panel_7")

    self.listview = self.view:getChildByName("Image_27"):getChildByName("ListView_1")
    self:initDec()
    G_FitScreen(self,"Image_1")
end

function BossRewardView:initDec()
	-- body
	local dec = self.panel1:getChildByName("Text_1_2")
	dec:setString(res.str.RES_GG_42)
	--世界战力
	self.lab_power = self.panel1:getChildByName("Text_1_2_0")
	self.lab_power:setString(cache.Boss:getInspirePercent().."%")
	self.lab_power:setPositionX(dec:getPositionX()+dec:getContentSize().width)

	self.panel1:getChildByName("Text_1_2_1"):setString(res.str.RES_GG_55)

	local Panel_6 = self.view:getChildByName("Panel_6")
	self.lab_my_hurt = Panel_6:getChildByName("Text_8") --我的伤害
	self.lab_my_rank = Panel_6:getChildByName("Text_8_0") --我的排行
	--击杀奖
	local conf_data = conf.Boss:getOtherItem(18)
	self.item_kill = self:inititem()
	self.item_kill.dec1:setString(res.str.RES_GG_56)
	--for k ,v in pairs(conf_data.value or {}) do
		--[[if v[1] == 221051001 then
			self.item_kill.dec2:setString(string.format(res.str.RES_GG_57,v[2]))
		else
			self.item_kill.dec3:setString(conf.Item:getName(v[1]).."x"..v[2])
		end]]
	local str = res.str.RES_GG_57 ..conf_data.value[1][2]
	self.item_kill.dec2:setString(str)
	local json = res.image.GOLD
	if conf_data.value[1][1] == 221051001 then 
	elseif conf_data.value[1][1] == 221051002 then
		json = res.image.ZS
	elseif conf_data.value[1][1] == 221051003 then 
		json = res.image.BADGE 
	end
	local img = display.newSprite(json)
	img:setScale(0.5)
	img:setPosition(self.item_kill.dec2:getPositionX() + 90, self.item_kill.dec2:getPositionY())
	img:addTo(self.item_kill)
	if conf_data.value[2] then 
		self.item_kill.dec3:setString(conf_data.value[2][2])

		local json = res.image.GOLD
		if conf_data.value[2][1] == 221051001 then 
		elseif conf_data.value[2][1] == 221051002 then
			json = res.image.ZS
		elseif conf_data.value[2][1] == 221051003 then 
			json = res.image.BADGE 
		end
		local img = display.newSprite(json)
		img:setScale(0.5)
		img:setPosition(self.item_kill.dec3:getPositionX() - self.item_kill.dec3:getContentSize().width 
			- img:getContentSize().width/2*0.5
			, self.item_kill.dec3:getPositionY())
		img:addTo(self.item_kill)
		
	end

	--self.item_kill.dec3:setString(conf.Item:getName(conf_data.value[2][1]).."x"..conf_data.value[2][2])


	--end
	self.item_kill:setPosition(7,Panel_6:getContentSize().height
		-self.item_kill:getContentSize().height)
	self.item_kill:addTo(Panel_6)

	--参与奖
	local conf_data = conf.Boss:getOtherItem(19)
	self.item_part = self:inititem()
	self.item_part.dec1:setString(res.str.RES_GG_58) 
	local str = res.str.RES_GG_57 ..conf_data.value[1][2]
	self.item_part.dec2:setString(str)
	local json = res.image.GOLD
	if conf_data.value[1][1] == 221051001 then 
	elseif conf_data.value[1][1] == 221051002 then
		json = res.image.ZS
	elseif conf_data.value[1][1] == 221051003 then 
		json = res.image.BADGE 
	end
	local img = display.newSprite(json)
	img:setScale(0.5)
	img:setPosition(self.item_part.dec2:getPositionX() + 90, self.item_part.dec2:getPositionY())
	img:addTo(self.item_part)
	if conf_data.value[2] then 
		self.item_part.dec3:setString(conf_data.value[2][2])

		local json = res.image.GOLD
		if conf_data.value[2][1] == 221051001 then 
		elseif conf_data.value[2][1] == 221051002 then
			json = res.image.ZS
		elseif conf_data.value[2][1] == 221051003 then 
			json = res.image.BADGE 
		end
		local img = display.newSprite(json)
		img:setScale(0.5)
		img:setPosition(self.item_part.dec3:getPositionX() - self.item_part.dec3:getContentSize().width 
			- img:getContentSize().width*0.5*0.5
			, self.item_part.dec3:getPositionY())
		img:addTo(self.item_part)
		
	end

	self.item_part:setPosition(7,self.item_kill:getPositionY() - self.item_kill:getContentSize().height)
	self.item_part:addTo(Panel_6)

end

function BossRewardView:inititem()
	-- body
	local item = self.cloneitem:clone()
	for i = 5 , 10 do
		item["dec"..(i-4)] = item:getChildByName("Text_10_"..i)
		item["dec"..(i-4)]:setString("")
	end
	return item
end

function BossRewardView:setData(data)
	-- body
	self.data = data 

	table.sort(self.data.rankingList,function( a,b )
		-- body
		return a.rank < b.rank
	end)

	self.item = {}
	for i = 1 , 10 do 
		local conf_data = conf.Boss:getRankitem(i)
		local item = self:inititem()

		item.dec1:setString(conf_data.dec)
		--conf.Item:getName(conf_data.awards[1][1])
		local str = res.str.RES_GG_57 ..conf_data.awards[1][2]
		--item.dec2:setString(string.format(res.str.RES_GG_57,conf_data.gold))
		item.dec2:setString(str)

		local json = res.image.GOLD
		if conf_data.awards[1][1] == 221051001 then 
		elseif conf_data.awards[1][1] == 221051002 then
			json = res.image.ZS
		elseif conf_data.awards[1][1] == 221051003 then 
			json = res.image.BADGE 
		end
		local img = display.newSprite(json)
		img:setScale(0.5)
		img:setPosition(item.dec2:getPositionX() + 90, item.dec2:getPositionY())
		img:addTo(item)

		if conf_data.awards[2] then 
			item.dec3:setString(conf_data.awards[2][2])

			local json = res.image.GOLD
			if conf_data.awards[2][1] == 221051001 then 
			elseif conf_data.awards[2][1] == 221051002 then
				json = res.image.ZS
			elseif conf_data.awards[2][1] == 221051003 then 
				json = res.image.BADGE 
			end
			local img = display.newSprite(json)
			img:setScale(0.5)
			img:setPosition(item.dec3:getPositionX() - item.dec3:getContentSize().width 
				- img:getContentSize().width*0.5*0.5
				, item.dec3:getPositionY())
			img:addTo(item)
		end
		--item.dec3:setString(conf.Item:getName(conf_data.awards[2][1]).."x"..conf_data.awards[2][2])

		item.dec4:setString(res.str.RES_GG_70)
		item.dec5:setString("")
		item.dec6:setString("")
		self.listview:pushBackCustomItem(item)
		table.insert(self.item,item)
	end

	for k ,v in pairs(self.data.rankingList) do
		local item = self.item[v.rank]
		if not item then
			break
		end
		item.dec4:setString(v.playerName)
		item.dec4:setFontName(display.DEFAULT_TTF_FONT)
		item.dec4:setFontSize(24)
		item.dec5:setString(string.format(res.str.RES_GG_59,v.damage))
		--[[if v.percent < 1 then 
			item.dec6:setString("<1%")
		else
			item.dec6:setString(v.percent.."%")
		end]]--
	end
	--击杀者
	self.item_kill.dec4:setString(self.data.lastHitRankInfo.playerName or "")
	self.item_kill.dec4:setFontName(display.DEFAULT_TTF_FONT)
	self.item_kill.dec4:setFontSize(24)
	if self.item_kill.dec4:getString()~="" then
		self.item_kill.dec5:setString(string.format(res.str.RES_GG_59,self.data.lastHitRankInfo.damage))
		--[[if self.data.lastHitRankInfo.percent < 1 then 
			self.item_kill.dec6:setString("<1%")
		else
			self.item_kill.dec6:setString(self.data.lastHitRankInfo.percent.."%")
		end]]--
	end

	--参与
	self.item_part.dec4:setString(self.data.myRankInfo.playerName or "")
	self.item_part.dec4:setFontName(display.DEFAULT_TTF_FONT)
	self.item_part.dec4:setFontSize(24)
	if self.item_part.dec4:getString()~="" then
	   self.item_part.dec5:setString(string.format(res.str.RES_GG_59,self.data.myRankInfo.damage))
	    --[[if self.data.myRankInfo.percent < 1 then 
			self.item_part.dec6:setString("<1%")
		else
			self.item_part.dec6:setString(self.data.myRankInfo.percent.."%")
		end]]--
	end
	self.lab_my_hurt:setString(res.str.RES_GG_63 .. self.data.myRankInfo.damage)
	if self.data.myRankInfo.rank > 0 then
		self.lab_my_rank:setString(res.str.RES_GG_60..self.data.myRankInfo.rank)
	else
		self.lab_my_rank:setString(res.str.RES_GG_60..res.str.RES_GG_61)
	end


end

function BossRewardView:onBtnClose( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function BossRewardView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return BossRewardView