--[[
	GuildRewarditem --通关奖励item 
]]

local GuildRewarditem = class("GuildRewarditem",function(  )
	return ccui.Widget:create()
end)


function GuildRewarditem:init( widget )
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	self.lab_zhanjie = self.view:getChildByName("Text_1_25_35_0")
	self.img = self.view:getChildByName("Image_8_31_39")
	self.listView = self.view:getChildByName("ListView_1")

	self.btn = self.view:getChildByName("Button_close_0_0")

end

function GuildRewarditem:setData(data,idx)
	-- body
	self.data = data
	self.idx = idx

	--printt(data)

	local name = data.data.title
	self.lab_zhanjie:setString(string.format(res.str.GUILD_DEC40,name))
	self.listView:removeAllChildren()
	for k ,v in pairs( data.data.award) do
		--print("******k = "..k)

		local item = self.Parent:getRewaditem()
		local btnframe = item:getChildByName("Button_frame1") 
		local icon = btnframe:getChildByName("img_head1_43")
		local lab_name = btnframe:getChildByName("Txt_name1_37")

		local colorlv = conf.Item:getItemQuality(v[1])
		btnframe:loadTextureNormal(res.btn.FRAME[colorlv])

		local path = conf.Item:getItemSrcbymid(v[1])
		icon:loadTexture(path)

		local name  = conf.Item:getName(v[1])
		lab_name:setString(name.."x"..v[2])
		lab_name:setColor(COLOR[colorlv])


		self.listView:pushBackCustomItem(item)
	end 

	self.img:setVisible(false)
	self.btn:setVisible(false)
	if data.status == 1 then 
		self.btn:setVisible(true)
		self.btn:addTouchEventListener(handler(self, self.onbtngetreward))
	else
		self.img:setVisible(true)
		if data.status==0 then 
			self.img:loadTexture(res.font.GETFONT.WDC)
		else
			self.img:loadTexture(res.font.GETFONT.YWC)
		end 
	end 

	--local name = conf.guild:get
end


function GuildRewarditem:onbtngetreward(sender_,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then 
		proxy.guild:sendGetReward(self.data.cId,self.idx )
	end 
end


return GuildRewarditem