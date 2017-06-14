--[[--
技能配置
]]
local SkillConf=class("SkillConf",base.BaseConf)

function SkillConf:init(  )
    self.conf=require("res.conf.skill_config")
    self.posConf = require("res.conf.format_config")
    self.buff = require("res.conf.buff_affect")
end

---------------------------
--@param id_ 技能id
--@return 技能数据
function SkillConf:getInfoById( id_ )
    return self.conf[id_..""]
end


--获得技能名字
function SkillConf:getSkillName( id_ )
	local skill=self.conf[tostring(id_)]
	if skill then
		return skill.name
	else
		self:Error(id_)
	end
	return "技能"
end

--获得技能描述
function SkillConf:getSkillDec( id_ )
	local skill=self.conf[tostring(id_)]
	if skill then
		return skill.dec
	else
		self:Error(id_)
	end
	return "描述"
end

function SkillConf:getFightPos(id_, index_)
    return self.posConf[id_..""][index_..""]
end

function SkillConf:getPlayerPos(id_)
    return self:getFightPos(id_,"init_pos")
end

function SkillConf:getBuffInfo(id_)
    return self.buff[id_..""]
end

return SkillConf
