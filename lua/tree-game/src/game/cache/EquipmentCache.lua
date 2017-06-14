local EquipmentCache=class("EquipmentCache",base.BaseCache)




function EquipmentCache:init(  )
	self.DataInfo = {}
end

function EquipmentCache:setEquitpmentInfo( data_ )
	local data = data_.equipInfo
	for k,v in pairs(data) do
		self:addEquitpment(v)
	end
end
function EquipmentCache:isKey(index)
	local data = self.DataInfo[index]
	if  data  then
		return self.DataInfo[index]
	end

	return false
end
function EquipmentCache:updatePackData(data)
	self.DataInfo[data.index]=data
end
--添加已佩戴的装备
function EquipmentCache:addEquitpment(data)
	data.propertys = vector2table(data.propertys,"type")
	local item_sort=conf.Item:getSort(data.mId)

	-- local itemtype={2,1,3}--服务器编号转换客户端对应编号
	-- local index=itemtype[item_type]
	data.sort=item_sort
	self.DataInfo[data.index]=data
end

function EquipmentCache:getEquitpmentDataInfo()
	return self.DataInfo
end
function EquipmentCache:removeEquipmentData(index)
	
	
	self.DataInfo[index] = nil
end



















return EquipmentCache