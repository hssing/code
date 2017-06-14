--GuildConf
--[[
	公会
]]

local GuildConf=class("GuildConf",base.BaseConf)

function GuildConf:init( )
	-- body
	self.conf=require("res.conf.gonghui") -- 公会等级 经验..
	self.conf_qifu=require("res.conf.gonghui_qifu")  --祈福
	--公会副本
	self._guildChapter = require("res.conf.guild_chapter")
	self._guildFb = require("res.conf.guild_fuben")
	self.guildFBID = 0
	--公会商店
	self._shop = require("res.conf.guild_shop")
	--副本排行奖励
	self._guildFb_rank_reward = require("res.conf.guild_fuben_rank_award")
end
--副本排行奖励
function GuildConf:getRankReward(id)
	-- body
	local guild = self._guildFb_rank_reward[tostring(id)]
	if not guild then 
		self:Error(id)
		return nil
	end 
	return guild
end


--祈福
function GuildConf:getQifuitem( id )
	-- body
	local guild=self.conf_qifu[tostring(id)]

	if not guild then 
		self:Error(id)
		return nil
	end
	return guild
end

--祈福奖励
function GuildConf:getReward(id)
	-- body
	local guild=self.conf[tostring(id)]
	if not guild then 
		self:Error(id)
		return nil
	end
	local qf_awards = guild.qf_awards
	local t = {}
	if qf_awards then 
		
		for k ,v in pairs(qf_awards) do 
			if not t[v[3]] then 
				t[v[3]] = {}
			end 
			table.insert(t[v[3]],v)
		end 
	else
		debugprint("该等级没有配置祈福奖励奖励") 	
	end  
	return t
end

--升到一级需要经验
function GuildConf:getExp(id)
	-- body
	local guild=self.conf[tostring(id)]

	if not guild then 
		self:Error(id)
		return nil
	end
	return guild.exp
end

--成员上限
function GuildConf:getLimitCount(id)
	-- body
	local guild=self.conf[tostring(id)]

	if not guild then 
		self:Error(id)
		return nil
	end
	return guild.limit_count
end
--公会图片
function GuildConf:getSrc(id)
	-- body
	local guild=self.conf[tostring(id)]

	if not guild then 
		self:Error(id)
		return nil
	end
	return guild.src
end

--
function GuildConf:getMaxjingdu(id )
	-- body
	local guild=self.conf[tostring(id)]

	if not guild then 
		self:Error(id)
		return nil
	end
	return guild.qf_jindu
	
end

--副本章节配置
function GuildConf:getGuildChapter(id_)
		return self._guildChapter[id_..""]
end
--副本关卡信息
function GuildConf:getGuildFb(id_)
		return self._guildFb[id_..""]
end
function GuildConf:getGuildFbAll()
	-- body
	return self._guildChapter
end

---获取每一个商店的item
function GuildConf:getShopItem( id )
	-- body
	return self._shop[tostring(id)]
end

--获得公会副本最大章节
function GuildConf:getMaxChapterIdx(  )
	-- body
	local maxIdx = 1
	for k,v in pairs(self._guildChapter) do
		local idx = v.id % 5000
		if maxIdx < idx then
			maxIdx = idx
		end
	end

	return maxIdx
end

function GuildConf:isForbiden( idx )
	-- body
	local cId = 5000 + idx

	return self._guildChapter[cId..""]["forbiden"]
end


return GuildConf