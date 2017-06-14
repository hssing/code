--[[
	--GuildRankItem 副本排行信息 item
]]

local GuildRankItem = class("GuildRankItem",function(  )
	return ccui.Widget:create()
end)

function GuildRankItem:init( param )
	-- body
	self.Parent=param
	self.view=param:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--排名
	self.imgRank = self.view:getChildByName("Image_2") --前3
	self.lab_rank = self.view:getChildByName("AtlasLabel_5") --3之后

	--公会图片
	self.spr = self.view:getChildByName("Image_3"):getChildByName("Image_7")
	self.lab_lv = self.view:getChildByName("AtlasLabel_4")

	self.lab_name = self.view:getChildByName("Text_32")
	self.lab_guildname = self.view:getChildByName("Text_4")
	self.lab_reward = self.view:getChildByName("Text_35")
	self.fuben = self.view:getChildByName("Text_33")

	local lab = self.view:getChildByName("Text_5")
	lab:setString(res.str.GUILD_DEC44..":")


	self.view:getChildByName("Text_32"):setString(res.str.GUILD_DEC44..":")
	--self.view:getChildByName("Text_7"):setString(res.str.GUILD_DEC47..":")
	self.view:getChildByName("Text_6"):setString(res.str.GUILD_DEC45..":")
end

function GuildRankItem:setData(data,idx)
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
	self.lab_reward:setString(data.awardZs)

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
return GuildRankItem