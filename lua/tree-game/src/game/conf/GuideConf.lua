--[[--
引导配置
]]
local GuideConf=class("GuideConf",base.BaseConf)

function GuideConf:init(  )
    self.guide=require("res.conf.guide_config")
    self.dialogue = require("res.conf.dialogue_config")
    self.func = require("res.conf.open_func")
end


---获取引导配置
function GuideConf:getGuideById( id_ )
    return self.guide[id_..""]
end

---获取对话配置
function GuideConf:getDialogueById( id_ )
    return self.dialogue[id_..""]
end

---获取功能开启配置
function GuideConf:getOpenFunc()
    return self.func
end

return GuideConf
