--人物配置
local RoleConf=class("RoleConf",base.BaseConf)

function RoleConf:init(  )
	-- body
	self.conf=require("res.conf.base_property")
	self.role_name = require("res.conf.role_name")
	self.xing = require("res.conf.role_xing")

	self.lvup = require("res.conf.role_lv_up")

	self.opendec = require("res.conf.role_miaoshu")
	
end

--获取人物升级的时候 开启功能的列表
function RoleConf:getOpenList()
	-- body
	local t = {}
	--local nums = table.nums(self.lvup)
	for k ,v in pairs(self.lvup) do 
		if v.lv > 0 then 
			table.insert(t,v)
		end 
	end 
	return t
end
--获取某一个功能xinxi
function RoleConf:getSysOpne(name,page) 
	-- body
	for k , v in pairs(self.opendec) do 
		if v.name == name  then
			if v.page and v.page ==  page then 
				return v
			else
				return v
			end 
		end 
	end 
end

function RoleConf:getManual( lv )
	local Role=self.conf[tostring(lv)]

	if not Role then 
		self:Error(lv)
		return nil
	end
	return Role.att_117
end


function RoleConf:getExplore(lv)
	local Role=self.conf[tostring(lv)]
	if not Role then 
		self:Error(lv)
		return nil
	end
	return Role.att_118
end
function RoleConf:getExp(lv)
	local Role=self.conf[tostring(lv)]
	if not Role then 
		self:Error(lv)
		return nil
	end
	return Role.att_101
end

---返回一个随机名字
function RoleConf:getName()
	-- body
	--math.randomseed(os.time())
	math.newrandomseed()
	local k1 = math.random(table.nums(self.xing))
	local k2 = math.random(table.nums(self.role_name))

	local name = ""
	local xing=self.xing[tostring(k1)] 
	if xing then 
		name = name .. xing.xing
	end 
	local role_name=self.role_name[tostring(k2)] 
	if role_name then 
		name = name .. role_name.ming
	end 
	return name
end

return RoleConf