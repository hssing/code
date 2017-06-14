--
-- Author: Your Name
-- Date: 2015-11-12 19:29:22
--
local GuildCmpConf = class("GuildCmpConf", base.BaseConf)

function GuildCmpConf:init( ... )
	self.conf = require("res.conf.guild_cmp_conf") 
end

function GuildCmpConf:getData( ... )
	return self.conf
end







return GuildCmpConf