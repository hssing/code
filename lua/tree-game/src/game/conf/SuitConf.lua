--[[--
技能配置
]]
local SuitConf=class("SuitConf",base.BaseConf)

function SuitConf:init(  )
    self.conf=require("res.conf.equip_suit")
    self.conf_fw = require("res.conf.fuwen_suit")
end

---------------------------
--获得所有套装配对的装备
function SuitConf:getEquipmentIdList( id_ )
	local Equipment=self.conf[tostring(id_)]
	if Equipment then
		return Equipment.items
	else
		self:Error(id_)
	end
end

--获得套装名字列表
function SuitConf:getEquipmentNameList( id_ )
	local Equipment =self.conf[tostring(id_)]
	if Equipment then
		return Equipment.items_name
	else
		self:Error(id_)
	end
end
--获得套装属性列表
function SuitConf:getEquipmentPropertyList( id_ )
	local Equipment =self.conf[tostring(id_)]
	if Equipment then
		return Equipment.prop_affect
	else
		self:Error(id_)
	end
end
-----------------------------------------------获得符文
function SuitConf:getFwIdList( id_ )
	local Equipment=self.conf_fw[tostring(id_)]
	if Equipment then
		return Equipment.items
	else
		self:Error(id_)
	end
end

--获得套装名字列表
function SuitConf:getFwNameList( id_ )
	local Equipment =self.conf_fw[tostring(id_)]
	if Equipment then
		return Equipment.items_name
	else
		self:Error(id_)
	end
end
--获得套装属性列表
function SuitConf:getFwPropertyList( id_ )
	local Equipment =self.conf_fw[tostring(id_)]
	if Equipment then
		return Equipment.prop_affect
	else
		self:Error(id_)
	end
end
return SuitConf
