--[[
	GuildBenquRankItem
]]

local GuildBenquRankItem = class("GuildRankItem",function(  )
	return ccui.Widget:create()
end)

function GuildBenquRankItem:init( param )
	-- body
	self.Parent=param
	self.view=param:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--排名
	self.imgRank = self.view:getChildByName("Image_2_44") --前3
	self.lab_rank = self.view:getChildByName("AtlasLabel_5_7") --3之后

	--公会图片
	self.spr = self.view:getChildByName("Image_3_48"):getChildByName("Image_7_47")
	self.lab_lv = self.view:getChildByName("AtlasLabel_4_4")

	self.lab_name = self.view:getChildByName("Text_32_54")
	self.lab_guildname = self.view:getChildByName("Text_4_46")
	
	self.fuben = self.view:getChildByName("Text_35_58")

	--成员数量 
	self.lab_reward = self.view:getChildByName("Text_33_56")

	self.view:getChildByName("Text_5_48"):setString(res.str.GUILD_DEC44..":")
	self.view:getChildByName("Text_6_50"):setString(res.str.GUILD_DEC47..":")
	self.view:getChildByName("Text_7_52"):setString(res.str.GUILD_DEC45..":")
end

function GuildBenquRankItem:setData(data,idx)
	-- body
	self.data = data

	self.imgRank :setVisible(false)
	self.lab_rank:setVisible(false)
	if data.rank <= 3 then 
		self.imgRank:setVisible(true)
		self.imgRank:loadTexture(res.icon.RANK[data.rank])
	else
		self.lab_rank:setVisible(true)
		self.lab_rank:setString(data.rank)
	end 

	self.spr:loadTexture(res.gonghui.img[data.guildIcon])
	self.lab_lv:setString(data.guildLevel)
	self.lab_name:setString(data.adminName)
	self.lab_guildname:setString(data.guildName)

	self.lab_reward:removeAllChildren()
	self.lab_reward:setString(data.guildCount)
	local maxcout =  conf.guild:getLimitCount(data.guildLevel)
	local lab_max = self.lab_reward:clone()
	lab_max:setString("/"..maxcout)
	lab_max:setPosition(self.lab_reward:getContentSize().width+5,self.lab_reward:getContentSize().height/2)
	lab_max:addTo(self.lab_reward)

	local id = math.floor(self.data.guildFbId/100)
	local zhanjie =  conf.guild:getGuildChapter(id)
	local str = ""
	if zhanjie then 
		str = zhanjie.title..tostring((self.data.guildFbId%10-1)*25).."%"
	else
		str = "100%"
	end 

	self.fuben:setString(str)
end
return GuildBenquRankItem
