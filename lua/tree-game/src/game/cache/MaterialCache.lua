--
-- Author: Your Name
-- Date: 2015-12-18 14:13:57
--

local MaterialCache = class("MaterialCache", base.BaseCache)

function MaterialCache:init(  )
	self.data = {}
	self.isFirst = true
end

function MaterialCache:savaData( data )
	self:init()
	local temp = data.caliaoInfo
	for k,v in pairs(temp) do
		table.insert(self.data, v)
	end

	self.isFirst = false
	--dump(self.data)

end

function MaterialCache:getMaterialData(  )
	return self.data
end

function MaterialCache:removeData( data )
	-- body
	if not data or not self.data then
		return 
	end

	for k,v in pairs(self.data) do 
		if v.index == data.index then
			table.remove(self.data,k)
			return 
		end
	end

end

function MaterialCache:addData( data )
	-- body
	if not data  then
		return 
	end
	data.propertys = vector2table(data.propertys,"type")
	if not self.data then 
		self.data = {}
	end

	local f = true
	for k ,v in pairs(self.data) do 
		if v.index == data.index then
			self.data[k].amount = self.data[k].amount + data.amount
			f = false
			self.data[k].new = data.new
			
			break
		end 
	end

	if f then 
		--print("符文调价")
		table.insert(self.data,data)
	end
end

function MaterialCache:reduceData( data )
	if not data or not self.data then
		return 
	end

	for k,v in pairs(self.data) do 
		if v.index == data.index then
			if v.amount <= data.amount then
				table.remove(self.data,k)
			else
				self.data[k].amount = v.amount - data.amount
			end
			return 
		end
	end
end









function MaterialCache:getItemIdx( mid )
	for k,v in pairs(self.data) do
		if v.mId == mid then
			return v.index
		end
	end

	print("没有获得这样的物品ID="..mid)
end

function MaterialCache:getpropty( mId )
	for k,v in pairs(self.data) do
		if v.mId == mId then
			return v.propertys
		end
	end

	print("没有获得这样的物品ID="..mId)
	return {}
end

function MaterialCache:getAmount( mId )
	for k,v in pairs(self.data) do
		if v.mId == mId then
			return v.amount
		end
	end

	
	print("没有获得这样的物品ID="..mId)
	return 0
end




return MaterialCache