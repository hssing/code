--
-- Author: chenlu_y
-- Date: 2015-12-12 16:07:13
--

local ScienceCoreConf=class("ScienceCoreConf",base.BaseConf)

function ScienceCoreConf:init()
	self.mainConf=require("res.conf.science_core")
	self.awardConf = require("res.conf.science_award")
end

function ScienceCoreConf:getMainConfig()
	return table.values(self.mainConf)
end

function ScienceCoreConf:getAwardConfig()
	return self.awardConf
end

function ScienceCoreConf:getInfo(cid)
	return self.mainConf[cid..""]
end

function ScienceCoreConf:getAwardInfo(cid)
	return self.awardConf[cid..""]
end

return ScienceCoreConf