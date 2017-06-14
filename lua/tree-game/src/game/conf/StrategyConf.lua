--
-- Author: Your Name
-- Date: 2015-07-23 17:35:42
--
local StrategyConf = class("StrategyConf", base.BaseConf)

local ICON_PATH = "res/views/ui_res/icon/"
local IMG_FONT_PATH = "res/views/ui_res/imagefont/"

function StrategyConf:init()
	-- body
	self.conf1 = require("res.conf.strategy_conf")
	self.conf2 = require("res.conf.strategy_conf_2")
	self.conf3 = require("res.conf.strategy_conf_3")

	self.pageIdx = 1 --界面 页标，代表第几个界面
	self.selectedIdx = 0 --item 标记，代表选择第几个 item

end

-- icon 路径
function StrategyConf:getIconSrc( key )
	-- body
	local data = self:getCurrPageData()
	local fileName =  data[key]["iconSrc"]

	return self:getResPath(fileName)
end

-- 显示内容
function StrategyConf:getContent( key )
	-- body
	local data = self:getCurrPageData()
	return data[key]["content"]
end

-- 资源路径
function StrategyConf:getResPath( fileName )
	-- body

	if self.pageIdx == 1 or self.pageIdx == 2 then
		--todo
		return ICON_PATH .. fileName
	elseif self.pageIdx == 3 then
			--todo
		return IMG_FONT_PATH .. fileName
	end

end

-- 显示 title
function StrategyConf:getTitle( key )
	-- body
	local data = self:getCurrPageData()
	return data[key]["title"]
end

-- 获得跳转系统的 ID
function StrategyConf:getFowardViewId( key )
	-- body
	local data = self:getCurrPageData()
	return data[key]["viewid"]
end

function StrategyConf:sort( )
	-- body
	local  data = self:getCurrPageData()
	local keys = {}

	for k,v in pairs(data) do
		table.insert(keys,k)
	end

	table.sort( keys)

	return keys

end

function StrategyConf:setSelectedIdx( idx )
	-- body
	self.selectedIdx = idx
end

function StrategyConf:getSelectedIdx(  )
	-- body
	return self.selectedIdx
end

function StrategyConf:getCurrPageData(  )
	-- body
	return self:getPageData(self.pageIdx)
end

function StrategyConf:getPageData( index )
	-- body
	local limitIdex = self.selectedIdx
	local totalData = self["conf"..index]
	local data = {}

	for k,v in pairs(totalData) do
		if math.floor(v["id"] / 100) == limitIdex then
			--todo
			data[k] = v
		end

	end

	return data
end

function StrategyConf:setPageIndex( index )
	-- body
	self.pageIdx = index
end

function StrategyConf:getProperties( index)
	
	local  temp = self.conf1[index .. ""]["pro_desc"]
	if not temp then
		debugprint("攻略配置没有属性介绍id="..index)
	end

	return temp
	
end

--响应类型，弹窗or跳转
function  StrategyConf:getResType( index )
	local  temp = self.conf1[index .. ""]["res_type"]
	if not temp then
		debugprint("攻略配置跳转类型id="..index)
	end

	return temp
end

--获得属性介绍的美术字
function StrategyConf:getImgfont( index )
	local  temp = self.conf1[index .. ""]["img_font"]
	if not temp then
		debugprint("攻略配置美术字id="..index)
	end

	return temp
end



return StrategyConf