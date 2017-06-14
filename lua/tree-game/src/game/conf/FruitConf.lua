--
-- Author: Your Name
-- Date: 2015-12-17 20:16:06
--

local FruitConf = class("FruitConf", base.BaseConf)

function FruitConf:init(  )
	self.conf = require("res.conf.fruit_hc")
end


function FruitConf:getData( ... )
	
	return self.conf
end

function FruitConf:getItemData( id )
	local data = self.conf[tostring(id)]
	if data == nil then
		print("合成果实配置没有这个id=" .. id)

	end

	return data
end

function FruitConf:getDataByTypeStep( atype, step )
	local data = {}
	local temp = self:getDataByType(atype)
	for k,v in pairs(temp) do
		if v.jie == step then
			table.insert(data, v)
		end
	end

	if #data == 0 then
		print("没有这个阶的果实信息jie="..step)
	end

	return data

end

function FruitConf:getStepNum(idx,pageType)
	local step = 0
	local data = self:getDataByIdxPage(idx,pageType)
	for k,v in pairs(data) do
		if v.jie > step then
			step = v.jie
		end
	end

	return step
end

--出战位置+类型
function FruitConf:getDataByIdxPage( idx,pageType )
	local data = {}
	local preIdx = string.format("1%02d%02d", idx,pageType)
	for k,v in pairs(self.conf) do
		local i,j = string.find(k,preIdx)
		if i and j then
			table.insert(data, v)
		end
	end

	if #data == 0 then
		print("没有这样的数据")
	end

	return data
end



--出战位置+类型+阶数
function FruitConf:getDataByIdxPageStep( idx,atype,step )
	local  data = self:getDataByIdxPage(idx,atype)
	local tmp = {}
	for k,v in pairs(data) do
		if v.jie == step then
			table.insert(tmp, v)
		end
	end

	tmp = self:sort(tmp)
	if #tmp == 0 then
		print("读取配置错误出战位="..idx.."分类="..atype)
	end

	return tmp


end

function FruitConf:sort( data )
	for i=1,#data - 1 do
		for j=i + 1,#data do
			if data[i].id > data[j].id then
				 data[i] , data[j] =  data[j] , data[i]
			end
		end
	end

	return data
end




--三位，01--99
function FruitConf:getDataByType( atype )
	local data = {}

	atype = atype + 100

	for k,v in pairs(self.conf) do
		if v.id / 10000 == atype then
			table.insert(data, v)
		end
	end

	if #data == 0 then
		print("没有这个 分页类型")
	end

	return data
	--1010102 /10000

end

function FruitConf:getImgSrc( id )
	for k,v in pairs(self.conf) do
		if v.id == id then
			return v.fruit_icon
		end
	end

	print("getImgSrc果实配置没有这个id"..id)
end

function FruitConf:getItemProp( id,attr )
	for k,v in pairs(self.conf) do
		if v.id == id then
			return v[attr]
		end
	end
	print("getItemProp果实配置没有这个id"..id)
end

--边框
function FruitConf:getFrameColor( id )
	local data = self.conf[tostring(id)]
	if data then
		return data["color"]
	end

	print("果实配置没这个ID"..id)
end



return FruitConf