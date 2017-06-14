local SysConf=class("SysConf",base.BaseConf)

function SysConf:init(  )
    local sc = require("res.conf.sys_conf")
    self.conf = {}
    for i,v in pairs(sc) do 
        self.conf[v["name"]] = v["value"]
    end
end

function SysConf:getValue(name_)
	if self.conf ~= nil then return self.conf[name_] end
	return nil
end


return SysConf