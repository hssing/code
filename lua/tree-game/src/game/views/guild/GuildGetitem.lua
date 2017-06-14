--[[
	--物品获得界面
]]
local GuildGetitem=class("GuildGetitem",base.BaseView)

function GuildGetitem:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	--什么鬼宝箱
	local image_bg = self.view:getChildByName("Image_bg")
	self.titleimg = image_bg:getChildByName("bg_title1"):getChildByName("Image_28")
	--描述文字
	self.dec =  image_bg:getChildByName("Text_1_2_0")
	self.btnsure = image_bg:getChildByName("Button_buy_more") 
	self.btnsure:addTouchEventListener(handler(self, self.onbtnSureCallback))
	--奖励容器
	self.panel = self.view:getChildByName("Panel")
	--奖励item 
	self.item = self.view:getChildByName("Panel_c")

	--self:setData()
	self.btnsure:getChildByName("Text_1_2"):setString(res.str.GUILD_DEC_22)
end


function GuildGetitem:setData( data )
	-- body
	--[[local tt = {} --测试玩玩
	for i = 1 , 2 do 
		local t = {}
		t.ii = 1
		table.insert(tt,t)
	end ]]--
	--printt(data)

	self.data = data

	if self.data.status == 0 then 
		self.btnsure:setTouchEnabled(false)
		self.btnsure:setBright(false)
	elseif self.data.status == 2 then 
		self.btnsure:setTouchEnabled(false)
		self.btnsure:setBright(false)
		self.btnsure:getChildByName("Text_1_2"):setString(res.str.MAILVIEW_GET_OVER)
	end 

	local str = string.format(res.str.GUILD_DEC21,self.data.jidu)
	self.dec:setString(str)


	--print(self.data.tag)
	--debugprint(res.font.XIANGZI[self.data.tag])
	self.titleimg:loadTexture(res.font.XIANGZI[self.data.tag])
	self.titleimg:ignoreContentAdaptWithSize(true)

	local ccsize = self.panel:getContentSize()
	for k ,v in pairs(self.data.reward) do
		local item = self.item:clone()
		local w = item:getContentSize().width
		item:setVisible(true)
		if #self.data.reward == 1 then
			item:setPosition(ccsize.width/2, ccsize.height/2)
		elseif #self.data.reward == 2 then 
			item:setPosition(ccsize.width/3*k, ccsize.height/2)
		elseif #self.data.reward == 3 then
			--todo
			item:setPosition(ccsize.width/3*(k)-w/2, ccsize.height/2)
		else
			debugprint("就显示3个 ，多了要改。靠")
			break
		end 
		local mId = v[1]
		local count = v[2]

		local colorlv = conf.Item:getItemQuality(mId)

		local btnframe =item:getChildByName("Button_frame") 
		--btnframe:ignoreContentAdaptWithSize(true) 
		local framePath=res.btn.FRAME[colorlv]
		btnframe:loadTextureNormal(framePath)

		local icon = btnframe:getChildByName("Image_head")
		icon:ignoreContentAdaptWithSize(true)
		local path = conf.Item:getItemSrcbymid(mId)
		icon:loadTexture(path)

		local lab_name = item:getChildByName("Text_name") 
		local name = conf.Item:getName(mId)
		name = name.."x"..count
		lab_name:setColor(COLOR[colorlv])
		lab_name:setString(name)

		item:addTo(self.panel) 

	end 
	self.item:removeFromParent()
end

function GuildGetitem:onbtnSureCallback(sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.data.status == 0 then 
			G_TipsOfstr(res.str.GUILD_DEC19)
			return 
		elseif self.data.status == 2 then 
			G_TipsOfstr(res.str.GUILD_DEC20)
			return 
		end 
		local params = {qfKey = self.data.jidu } --进度奖励 qfKey 就是 可以领取的 进度
		proxy.guild:sendgetQifureward(params)
		--self:onCloseSelfView()
	end 
end

function GuildGetitem:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return GuildGetitem