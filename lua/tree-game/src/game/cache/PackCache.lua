--[[--
  背包数据(包括仓库、装备、等使用背包存储的数据)
]]
local PackCache = class("PackCache",base.BaseCache)




function PackCache:init()
	self.DataInfo={
	{},--装备
	{},--道具
	{},--卡牌
	{},
	{},
	}
	self.ShowDataInfo={
	{},--装备
	{},--道具
	{},--卡牌
	{},
	{},
	}

	-- key 是mid value 是 使用次数
	self.DataPro = {}
end

function PackCache:setPackInfo(data_)
	local data=data_.packInfo
	for k,v in pairs(data) do
		self:addItem(v)
	end
	--self:update()

	--self.DataInfo=data
end
--剩余使用次数
function PackCache:getusenums( mid )
	-- body
	local count = self.DataPro[mid] and self.DataPro[mid] or 0
 	return count
end
-- function PackCache:isKey(data_)
-- 	for k,v in pairs(self.DataInfo[itemtype]) do
-- 		if v.index ==  index then
-- 			local amount_=amount-v.amount
-- 			 v.amount=amount
-- 			 return amount_
-- 		end
-- 	end
-- end
function PackCache:isKey(type,index)
	local data = self.DataInfo[type][index]
	if  data  then
		return index,self.DataInfo[type][index]
	end

	-- for k,v in pairs(self.DataInfo[type]) do
	-- 	if v.index ==  index then
	-- 		return k,v
	-- 	end
	-- end
	return false
end

function PackCache:getItemAmountByMid( type,mid )
	-- body
	local count = 0;
	if self.DataInfo[type]~=nil then 
		for k , v in pairs(self.DataInfo[type]) do 
			if mid == v.mId then 
				count = count +v.amount;
			end	
		end	
	end
	return count;
end

function PackCache:getIteminfoByMid(type,mid )
	-- body
	if self.DataInfo[type]~=nil then
		for k , v in pairs(self.DataInfo[type]) do 
			if mid == v.mId then 
				return v 
			end	
		end	
	end 
	return nil 
end

function PackCache:getItemAllitemByMid( type,mid )
	-- body
	local tt = {}
	if self.DataInfo[type]~=nil then 
		for k ,v in pairs(self.DataInfo[type]) do 
			if mid == v.mId then 
				table.insert(tt,v)
			end 
		end 
	end 
	return tt 
end

function PackCache:getPackInfo()
	return self.DataInfo
end
function PackCache:getTypePackInfo(index)
	return self.DataInfo[index]
end
function PackCache:updatePackData(item_type,data)
	self.DataInfo[item_type][data.index]=data

	self.DataPro[data.mId] = data.propertys[312] and  data.propertys[312].value or 0
end
--用于 合成显示
function PackCache:getItemByIndex( index )

	for k,v in pairs(self.DataInfo) do
		for k1,v1 in pairs(v) do
			if v1.index  ==  index then
				return self.DataInfo[k][index]
			end
		end
	end
end

--得到指定道具的数量
function PackCache:getItemAmount(index)
	for k,v in pairs(self.DataInfo) do
		if v.index  ==  index then
			return v[index].amount
		end
	end
	-- local item =self.DataInfo[item_type][index]
	-- if item then
	-- 	return item.amount
	-- end
	return 0
	
end

function PackCache:getSptypeCount()
	-- body
	local count = 0
	for k , v in pairs(self.DataInfo[pack_type.PRO]) do 
		local sptype = conf.Item:getSp_type(v.mId)
		if sptype and sptype > 0 then
			local arg = conf.Item:getArg1(v.mId)
			count = count + math.floor(v.amount / arg.arg2)
		end
	end
	return count
end

--添加一个道具
function PackCache:addItem(data,i)
	data.propertys = vector2table(data.propertys,"type")
	local item_type=conf.Item:getType(data.mId)
	local item_sort=conf.Item:getSort(data.mId)
	if not item_type then
		debugprint("配置表中不存在该物品！！！！")
		return 
	end

	if not item_sort then 
		debugprint("配置表中不存在该物品！！！！没有区分装备 是谁的 ")
		return 
	end

	self.DataPro[data.mId] =  data.propertys[312] and  data.propertys[312].value or  0

	data.sort=item_sort
	self.DataInfo[item_type][data.index]=data
	self.ShowDataInfo[item_type][i or (#self.ShowDataInfo+1)]=data
end
--更新指定index道具的数量
function PackCache:setItemAmount(itemtype,index,amount)
	-- local item =self.DataInfo[item_type][index]
	-- local amount_
	-- if item then
	-- 	item.amount
	-- 	return amount_
	-- end
	-- local amount_=self.DataInfo[item_type][index].amount

	-- for k,v in pairs(self.DataInfo[itemtype]) do
	-- 	if v.index ==  index then
	-- 		local amount_=amount-v.amount
	-- 		 v.amount=amount
	-- 		 return amount_
	-- 	end
	-- end
	return nil
end
function PackCache:update(  )
	-- self:spriteSort()
	-- self:equipmentSort()
	-- self:proSort()
	--self:updateRemove(data)

end
--删除为0的数据
function PackCache:removeData(item_type,index,data)
	self:getTypePackInfo(item_type)[index] = nil


	data.propertys = vector2table(data.propertys,"type")
	self.DataPro[data.mId] = data.propertys[312] and  data.propertys[312].value or 0
	--table.remove(,index)
end
--精灵排序
function PackCache:spriteSort(  )
	table.sort(self.DataInfo[3], function( a,b )
		if a.sort then
			return a.sort < b.sort
		else

		end
	end )
end
--装备排序
function PackCache:equipmentSort(  )
	table.sort(self.DataInfo[1], function( a,b )
		return a.sort < b.sort
	end )
end
--道具排序
function PackCache:proSort(  )
	table.sort(self.DataInfo[2], function( a,b )
		return a.sort < b.sort
	end )
end

---获取我方上阵伙伴
function PackCache:getEquipCards()
    local data = self:getTypePackInfo(pack_type.SPRITE)
    local list={}
    for k,v in pairs(data) do
        if conf.Item:getBattleProperty(v) > 0 then
            list[#list+1] = v
        end
    end
    return list
end

return PackCache