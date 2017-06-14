--ScienceCoreCache
local ScienceCoreCache = class("ScienceCoreCache",base.BaseCache)

function ScienceCoreCache:init()
	-- body
	self.data = {}
end

function ScienceCoreCache:setDataMsg(data)
	-- body
	self.data = data
end

function ScienceCoreCache:getData()
	-- body
	return self.data
end
--进度:0未放,1放了第一个,2个,3个,4个,999吞噬领取奖励了
function ScienceCoreCache:setCardinfo(data_)
	-- body
	if not self.data then
		return 
	end

	if self.data.allStep[data_.mid..""] then
		self.data.allStep[data_.mid..""] = data_.step
	else
		self.data.allStep[data_.mid..""] = 1 
	end
end

function ScienceCoreCache:getCardinfo(mId)
	-- body
	return self.data.allStep[data_.mid..""] or 0
end
--吞噬
function ScienceCoreCache:setinfoData( data_ )
	-- body
	if not self.data then
		return 
	end

	self.data.allStep[data_.mid..""] = data_.step -- 这个是999
	self.data.starExp[data_.starIndex..""] =  data_.starExp
end
--领取进度奖励
function ScienceCoreCache:setDatainfo( data_ )
	-- body
	self.data.starSign[data_.starIndex..""] =  data_.awardSign
end


function ScienceCoreCache:getallStepOneByMid( mId )
	-- body
	return self.data.allStep[mId..""] or 0
end

return ScienceCoreCache