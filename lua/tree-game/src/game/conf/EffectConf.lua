--[[--
效果配置
]]
local EffectConf=class("EffectConf",base.BaseConf)

function EffectConf:init(  )
    self.conf=require("res.conf.effect_config")
end


---------------------------
--@param id_效果id
--@return 效果数据
function EffectConf:getInfoById( id_ )
	return self.conf[id_..""]
end

return EffectConf
