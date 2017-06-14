
local GonggaoConf=class("GonggaoConf",base.BaseConf)

function GonggaoConf:init(  )
    self.conf=require("res.conf.gonggao")
end



function GonggaoConf:getAllItem( id)
	return table.values(self.conf)
end

return GonggaoConf