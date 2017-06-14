--GuildSearchitem
--[[
	搜索公会 item
]]
local head_path = "res/views/ui_res/icon/"
local end_type = ".png"


local GuildSearchitem = class("GuildSearchitem",function(  )
	return ccui.Widget:create()
end)

function GuildSearchitem:init( widget )
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--图像框
	self.bt_frame  =self.view:getChildByName("Button_frame_24_3_82") 
	self.spr = self.bt_frame:getChildByName("Image_22_24_8_108")

	--vip等级 名字
	local img_di = self.view:getChildByName("Image_zb_bg_30_13_112") 
	self.viplv = img_di:getChildByName("Image_3_111")
	self.lab_lv = self.viplv:getChildByName("AtlasLabel_1")
	self.name = img_di:getChildByName("Text_name_19_6_83")

	--会长 进度 战力
	local panel = self.view:getChildByName("Image_115")
	self.leader = panel:getChildByName("Text_name_19_6_83_0_0_1")
	self.pass = panel:getChildByName("Text_name_19_6_83_0_0_1_0")
	self.power = panel:getChildByName("Text_name_19_6_83_0_0_1_1")
	--加入最低战力设置
	self.lab_addpower = img_di:getChildByName("Text_name_19_6_83_0_0")
	self.lab_addpower:setFontSize(18)
	--
	panel:getChildByName("Text_name_19_6_83_0_0"):setString(res.str.GUILD_DEC44..":")
	panel:getChildByName("Text_name_19_6_83_0_0_0"):setString(res.str.GUILD_DEC45.. ":")
	panel:getChildByName("Text_name_19_6_83_0_0_0_0"):setString(res.str.GUILD_DEC46..":")
	

	--成员数
	self.currNum = img_di:getChildByName("Text_name_19_6_83_0")
	self.currNum:setColor(COLOR[1])

	self.maxNum = self.currNum:clone()
	--self.maxNum:setAnchorPoint(cc.p(0,0.5))
	self.maxNum:setColor(COLOR[2])
	self.maxNum:setPosition(self.currNum:getPositionX()+self.currNum:getContentSize().width, 
		self.currNum:getPositionY())
	self.maxNum:addTo(img_di)

	self.btn = self.view:getChildByName("Button_Using_26_7_84")
end

function GuildSearchitem:setData( data,idx )
	-- body
	self.idx = idx
	self.data = data

	local path = res.btn.FRAME[1]
	self.bt_frame:loadTextureNormal(path)

	local icon = res.gonghui.img[data.guildIcon]
	self.spr:loadTexture(icon)

    self.lab_lv:setString(data.guildLevel)

	self.name:setString(data.guildName)
	self.leader:setString(data.adminName)
	
	--print("data.fbId ="..data.fbId)
	local id = math.floor(data.fbId/100)
	local zhanjie =  conf.guild:getGuildChapter(id)
	local str = ""
	if zhanjie then 
		str = zhanjie.title .. tostring((data.fbId%10-1) *25).."%"
	else
		str = "100%"
	end 

	self.pass:setString(str ) --这里要改 --副本进度 当前显示为副本ID
	self.power:setString(data.guildPower  or 0)

	self.currNum:setString(data.count)

	local maxnum = conf.guild:getLimitCount(data.guildLevel)
	if not maxnum then 
		maxnum = 0
	end 
	self.maxNum:setString("/"..maxnum)

	self.maxNum:setPosition(self.currNum:getPositionX()+self.currNum:getContentSize().width, 
		self.currNum:getPositionY())

	local isShenqing = data.isShenqing

	local t = cache.Guild:getAdd(data.guildId)
	if t then 
		isShenqing = t.isOk
	end 

	if isShenqing == 1 then 
		--self.btn:setTouchEnabled(false)
		--self.btn:setBright(false)
		self.btn:setTitleText(res.str.GUILD_DEC4)
		self.btn:setTitleColor(cc.c3b(33, 46, 111))
		self.btn:loadTextureNormal(res.btn.BLUE_BIG)
		self.btn:setTag(0)
	else
		--self.btn:setTouchEnabled(true)
		--self.btn:setBright(true)
		self.btn:setTitleText(res.str.GUILD_DEC5)
		self.btn:setTag(1)
		self.btn:setTitleColor(cc.c3b(127, 48, 10))
		self.btn:loadTextureNormal(res.btn.YELLOW)
		--self.btn:addTouchEventListener(handler(self, self.onbtnShengqing))
	end 

	self.btn:addTouchEventListener(handler(self, self.onbtnShengqing))

	self.needpower = data.minPower or 0
	if self.needpower > 0 then 
		self.lab_addpower:setVisible(true)
		self.lab_addpower:setString(string.format(res.str.GUILD_DEC54,G_FormatPower(self.needpower)))
	else
		self.lab_addpower:setVisible(false)
	end
end

function GuildSearchitem:onbtnShengqing(  sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		debugprint("申请加入")
		if cache.Player:getPower() < self.needpower and sender_:getTag() == 1  then 
			G_TipsOfstr(res.str.GUILD_DEC55)
			return 
		end 

		local params = {guildId = self.data.guildId , isOk = sender_:getTag() }
		printt(params)
		proxy.guild:sendaddGuild(params,self.idx)
	end 
end







return GuildSearchitem