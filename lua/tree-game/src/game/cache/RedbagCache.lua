--
-- Author: Your Name
-- Date: 2015-09-07 22:21:57
--
local RedbagCache = class("RedbagCache", base.BaseCache)

function RedbagCache:init( )
	self.data = {}
	self.data[1] = {}
	self.data[2] = {}
	self.showData = {}
	self.maxCount = 30
	self.maxShowNum = 10
	
end

function RedbagCache:getData( )
	return self.data
end

function RedbagCache:addData( data )
	local len = #self.data[data.chatType]
	if self.maxCount <= len  then
		--table.remove(self.data[data.chatType],1)
		--len = len - 1]
		local dataDel = self.data[data.chatType][len]
		local i = len
		for k,v in pairs(self.data[data.chatType]) do
			print("=========i====",k,v.isShow)
			if v.index < dataDel.index and v.isShow == false then
				i = k
				dataDel = v
				print("======= RedbagCache:addData switch============")
			end
		end
		print("======= RedbagCache:addData remove============",self.data[data.chatType][i].index)
		table.remove(self.data[data.chatType],i)
		len = len - 1
	end

	self.data[data.chatType][len + 1] = data

	--如果进入战斗场景
	local name = mgr.SceneMgr:checkCurScene()
	if name == _scenename.FIGHT  then
		self:addShowData(data)
	end

end

function RedbagCache:getDataById( hbId )
	for k,v in pairs(self.data[1]) do
		if v.hbId["key"] == hbId["key"] then
			return v
		end
	end

	for k,v in pairs(self.data[2]) do
		if v.hbId["key"] == hbId["key"] then
			return v
		end
	end

	return nil
end

function RedbagCache:removeDataById( hbId )
	for k,v in pairs(self.data) do
		if v.hbId == hbId then
			table.remove(self.data,k)
			return
		end
	end
end

function RedbagCache:pushBackData( hbId )
	-- local index = -1
	-- for k,v in pairs(self.data[1]) do
	-- 	if v.hbId == hbId then
	-- 		local data = v
	-- 		table.remove(self.data[1],k)
	-- 		table.insert(self.data[1],1,data)
	-- 		return
	-- 	end
	-- end
	-- for k,v in pairs(self.data[2]) do
	-- 	if v.hbId == hbId then
	-- 		local data = v
	-- 		table.remove(self.data[2],k)
	-- 		table.insert(self.data[2],1,data)
	-- 		return
	-- 	end
	-- end
end

--获取未领取的 最新的红包进行显示
function RedbagCache:getAvailableData(  )
	for i=1,#self.data do
		print(i)
	end
end

function RedbagCache:saveShowData( data )
	self.showData = data
end

function RedbagCache:getShowData(  )
	return self.showData
end

function RedbagCache:addShowData( data )
	local len = #self.showData
	if self.maxShowNum < len then
		table.remove(self.showData,1)
		len = len - 1
	end
	self.showData[len + 1] = data
end





return RedbagCache