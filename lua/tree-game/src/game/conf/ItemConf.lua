--物品配置
local ItemConf=class("ItemConf",base.BaseConf)

function ItemConf:init(  )
	self.conf = require("res.conf.item")
end
--获取限制时间
function ItemConf:getItemTimelimit(id)
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.time_limit
	else
		self:Error(id)
		return nil
	end 
end

function ItemConf:getItemConf(id)
	-- body
	return self.conf[tostring(id)]
end

---获取升级 前缀
function ItemConf:getItemSjPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.sj_att_pre
	else
		self:Error(id)
		return nil
	end 
end

---获取进化 前缀
function ItemConf:getItemJHPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.jh_att_pre
	else
		self:Error(id)
		return nil
	end 
end

---获取进阶 前缀
function ItemConf:getItemJJPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.jj_att_pre
	else
		self:Error(id)
		return nil
	end 
end

---获取进阶消耗 前缀
function ItemConf:getItemJJClPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.jj_cl_pre
	else
		self:Error(id)
		return nil
	end 
end


function ItemConf:getItemWord( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.word
	else
		self:Error(id)
		return nil
	end 
end

--碎片类型
function ItemConf:getSp_type( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.sp_type
	else
		self:Error(id)
		return nil
	end 
end

function ItemConf:getAttPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.att_pre
	else
		self:Error(id)
		return nil
	end 
end

function ItemConf:getUseTime( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.use_time
	else
		self:Error(id)
		return 0
	end 

end

function ItemConf:getArg1(id)
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.args
	else
		self:Error(id)
		return nil
	end 
end
function ItemConf:getBuyPrice(mId)
	-- body
	local Item=self.conf[tostring(mId)]
	if Item then 
		return Item.buy_price
	else
		self:Error(mId)
		return nil
	end 
end
--buy_type
function ItemConf:getBuyType( mId)
	-- body
	local Item=self.conf[tostring(mId)]
	if Item then 
		return Item.buy_type
	else
		self:Error(mId)
		return nil
	end 
end

-- function ItemConf:Error(message)
-- 	debugprint("(配置表)没有这个物品:"..message)
-- end
--使用道具跳转界面  viewid = [1,1] viewid[1] 对面ViewName  viewid[2] 页面
function ItemConf:UseToVire(id)
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.viewid
	else
		self:Error(id)
		return nil
	end 
end
--获取路径跳转
function ItemConf:FromView(id)
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.formView
	else
		self:Error(id)
		return nil
	end 
end
--获取所有的信息
function ItemConf:getall()
	-- body
	return self.conf
end

function ItemConf:getCardMaxlv( id )
	-- body
	--print("id = "..id)
	local itme=self.conf[tostring(id)]
	if itme then
		return itme.max_lvl
	end
	--debugprint("最大等级 不应该为0 或者没有配置")
	return 0
end

function ItemConf:getName( id,propertys,next_)
	local Item=self.conf[tostring(id)]
	local name= nil 
	if  Item  then
		name=Item.name
		local data=propertys
		if self:getType(id) == pack_type.SPRITE and data then
			if  data  then --进数
				local jj = 1
				if data[307] then 
					jj=  data[307].value == 0 and  data[307].value +1 or data[307].value +1 
				end
				--print("jj = "..jj)
				local src_id=Item.srcs[jj]
				if not src_id then 
					return nil
				end 
				--print("src_id = "..src_id)
				name=conf.Card:getName(src_id)
				local jinghua = data[310] and  data[310].value or 0
				if next_ then jinghua = jinghua +1 end 
    			if jinghua > 0 then 
    				name = name.."+"..jinghua
    		    end		
			else
			    local src_id=Item.srcs[1]
			    name=conf.Card:getName(src_id)
			end
		end
		if self:getType(id) == pack_type.EQUIPMENT and propertys then
			local jhlv = mgr.ConfMgr.getItemJh(propertys)
			if jhlv > 0 then
				name=name.."+"..jhlv
			end
		end
	else
		self:Error(id)
		return nil
	end
	return name
end
--获得指定数据
function ItemConf:getItemData( id)
	local itme=self.conf[tostring(id)]
	if itme then
		return itme
	end
	return nil
end
--获得指定数据
function ItemConf:getExp( id)
	local itme=self.conf[tostring(id)]
	if itme then
		return itme.exp
	end
	return 0
end
function ItemConf:getMaxQhLv( id,propertys)
	local itme=self.conf[tostring(id)]
	if itme then
		local lv = itme.max_lvl
		if  lv then
			return lv
		end
	end
	return 1
end
function ItemConf:getMaxJhLv( id,propertys)
	local itme=self.conf[tostring(id)]
	if itme then
		local lv = itme.max_rank
		if  lv then
			return lv
		end
	end
	return 1
end
function ItemConf:getNameByJJ( id,propertys)
	-- local Item=self.conf[tostring(id)]
	-- local name= nil 
	-- if  Item  then
	-- 	local src_id=Item.srcs[jj]
	-- 	name=conf.Card:getName(src_id)
	-- else
	-- 	self:Error(id)
	-- 	return nil
	-- end
	-- return name
end


---获取强化 前缀
function ItemConf:getItemQhPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.qh_att_pre
	else
		self:Error(id)
		return nil
	end 
end

---获取精炼 前缀
function ItemConf:getItemJlPre( id )
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return Item.jl_att_pre
	else
		self:Error(id)
		return nil
	end 
end

function ItemConf:getEquipmentQhId(id,qhlv)
	--[[local time=self.conf[tostring(id)]
	local quality = self:getItemQuality(id)
	local part = self:getItemPart(id)
	local id = quality*10000+part*1000+qhlv]]
	return checkint(self:getItemQhPre(id)) + qhlv
end

function ItemConf:getEquipmentJLId(id,qhlv)
	--[[local time=self.conf[tostring(id)]
	local quality = self:getItemQuality(id)
	local part = self:getItemPart(id)
	local id = quality*10000+part*1000+qhlv]]
	return checkint(self:getItemJlPre(id)) + qhlv
end

--获取物品品质
function ItemConf:getItemQuality(id)
	local time=self.conf[tostring(id)]
	if not time then 
		self:Error(id)
		return 
	end
	if not time.color then 
		self:Error(id)
	end 
	return time.color
end
--获取物品套装ID
function ItemConf:getItemSuitId(id)
	local time=self.conf[tostring(id)]
	if not time then 
		self:Error(id)
		return 
	end
	return time.suit_id
end
--获取物品部位
function ItemConf:getItemPart(id)
	local time=self.conf[tostring(id)]
	if not time then 
		self:Error(id)
		return 1
	end
	return time.part
end
-----获取物品属性位置
function ItemConf:getItemtypePart(id)
	local time=self.conf[tostring(id)]
	if not time then 
		self:Error(id)
		return 1
	end
	return time.att_type
end
--出战位置(1-6)
function ItemConf:getBattleProperty(v)
	local data= 0 
	if v.propertys then
		local data_=v.propertys[308]
		if data_ then
			data=data_.value 
		end
	else
		--debugprint("propertys 出错！！！")

	end
	return data
end
--出战位置(1-6)
function ItemConf:getBattlePropertyTo(v)
	local data= 0 
	if v.propertys then
		local data_=v.propertys[309]
		if data_ then
			data=data_.value 
		end
	else
		--debugprint("propertys 出错！！！")

	end
	return data
end
function ItemConf:getPower(v)
	local data= nil 
	if v and v.propertys then
		local dd=v.propertys[305]
		if dd then
			data=dd.value 
		else
			data=0
		end
		
	else
		data=0
		--debugprint("propertys 出错！！！")

	end
	return data
end
function ItemConf:getLv(v)
	local data= nil 
	if v.propertys then
		data=v.propertys[304].value
	else
		--debugprint("propertys 出错！！！")
		return 0
	end
	return data
end
--通过物品ID,propertys查找到技能列表
function ItemConf:getSkillList(id,propertys)
	-- body
	local Item=self.conf[tostring(id)]
	if  Item  then
		local data=propertys
		if data then
			local jj
			if data[307] then
				jj= data[307].value+1
			else
				jj= 1
			end
			local src_id=Item.srcs[jj]
			return conf.Card:getSkill(src_id)
		else
			self:Error("propertys 参数错误！！")
		end
	else
		self:Error(id)
	end
end
--获得亲密度ID
function ItemConf:getIntimacyID(id)
	-- body
	local Item=self.conf[tostring(id)]
	if  Item  then
		local Intimacy_id = Item.qinmi_id

		return Intimacy_id 
	else
		self:Error(id)
	end
end
-- --获得亲密度ID
-- function ItemConf:getIntimacyID(id)
-- 	-- body
-- 	local Item=self.conf[tostring(id)]
-- 	if  Item  then
-- 		local Intimacy_id = Item.qinmi_id

-- 		return Intimacy_id 
-- 	else
-- 		self:Error(id)
-- 	end
-- end
--获得天赋
function ItemConf:getGiftList(id)
	-- body
	local Item=self.conf[tostring(id)]
	if  Item  then
		local Gift = Item.tianfu_ids

		return Gift 
	else
		self:Error(id)
	end
end
function ItemConf:getSrc(id,propertys)
	local Item=self.conf[tostring(id)]
	local src= nil 
	if  Item  then
		src=Item.src
		if not src  then
			local data=propertys
            local jj = 1
			if  data  then --进数			
				if data[307] then
					jj= data[307].value==0 and 1 or  data[307].value +1 
				end
			end
            local src_id=Item.srcs[jj]
            src=conf.Card:getImageSrc(src_id)
		end
	else
		self:Error(id)
		return nil
	end
	return src
end
--获取物品的图片
function ItemConf:getItemSrcbymid( id ,property)
	-- body
	local type=conf.Item:getType(id)
	local itemSrc=conf.Item:getSrc(id,property)
	local path
	if type == pack_type.SPRITE then 
		path = mgr.PathMgr.getImageHeadPath(itemSrc)
	else
		path = mgr.PathMgr.getItemImagePath(itemSrc)
	end 
	return path
end
--得到最大阶
function ItemConf:getCardMaxjie(id)
	-- body
	local Item=self.conf[tostring(id)]
	if Item then 
		return #Item.srcs
	else
		self:Error(id)
	end 
	return 1
end

--得到第几阶ID
function ItemConf:getCardId(id,j)
	local Item=self.conf[tostring(id)]
	local src= nil 
	if  Item  then
		src=Item.srcs
		return src[j]
	else
		self:Error(id)
		return nil
	end
	return 0
end
--得到道具形象
function ItemConf:getModelPro( id )
 	-- body
 	local Item=self.conf[tostring(id)]
 	if Item then 
 		return Item.modelSrc
 	end 
 	return nil 
end 


--得到形象
function ItemConf:getModel(id,propertys)
	local Item=self.conf[tostring(id)]
	local jj
	local src = Item.src
	if   src then
		return src
	end
	local data=propertys
	if  data  then --进数
		if data[307] then
			jj= data[307].value == 0 and data[307].value +1 or data[307].value +1
		else
			jj= 1
		end
	else
		jj = 1
	end

	 src = self:getModelByJJ(id,jj)
	return src
end
--得到形象
function ItemConf:getModelByJJ(id,jj)
	local Item=self.conf[tostring(id)]
	local src= nil 
	if  Item  then
		local src_id=Item.srcs[jj]
		if src_id then
			src=conf.Card:getModel(src_id)
		else
			return nil
		end
	else
		self:Error(id)
		return nil
	end
	return src
end

--道具类型
function ItemConf:getType(id)
	local Item=self.conf[tostring(id)]
	if not Item then 
		self:Error(id)
		return nil
	end
	return Item.type
end

--限制次数
function ItemConf:getLimitNum(id)
	local Item=self.conf[tostring(id)]
	if not Item then 
		self:Error(id)
		return 0
	end
	return Item.is_limit
end
--是否显示10个按钮
function ItemConf:getis_use_all(id)
	local Item=self.conf[tostring(id)]
	if not Item then 
		self:Error(id)
		return 0
	end
	return Item.is_use_all
end

--获得排列序号
function ItemConf:getSort(id)
	local Item=self.conf[tostring(id)]
	if not Item then 
		self:Error(id)
		return 0
	end
	return Item.sort
end


--获取物品说明
function ItemConf:getItemDescribe(id)
	local time=self.conf[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.describe
end


--local 信息
--战斗力
function ItemConf:getloaclEquippower(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.power and item.power or 0
end

--破甲
function ItemConf:getPojia(id)
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_116 and item.att_116 or 0
end

--防御
function ItemConf:getLocalEquipdef(id)
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_103 and item.att_103 or 0
end

--攻击
function ItemConf:getLocalEquipAtt(id)
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_102 and item.att_102 or 0
end
--hp
function ItemConf:getLocalEquipHp(id)
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_105 and item.att_105 or 0
end
--暴击
function ItemConf:getLocalEquipCrit(id)
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_106 and item.att_106 or 0
end
--暴击伤害
function ItemConf:getLocalEquipCrithurt(id)
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_107 and item.att_107 or 0
end
--抗暴
function ItemConf:getLocalEquipdefCrit(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_108 and item.att_108 or 0
end
--闪避
function ItemConf:getLocalEquipdshanbi(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_109 and item.att_109 or 0
end
--命中
function ItemConf:getLocalEquipdefmingzhong(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_110 and item.att_110 or 0
end

--攻击百分比
function ItemConf:getPercentAtk(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_202 and item.att_202 or 0
end

--血量百分比
function ItemConf:getPercentHp(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_205 and item.att_205 or 0
end

--防御百分比
function ItemConf:getPercentDef(id)
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_203 and item.att_203 or 0
end

function ItemConf:getPercentCri( id )
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_206 and item.att_206 or 0
end

function ItemConf:getPercentDefCri( id )
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_208 and item.att_208 or 0
end

function ItemConf:getPercentMZ( id )
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_210 and item.att_210 or 0
end

function ItemConf:getPercentsb( id )
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return item.att_209 and item.att_209 or 0
end




--获取对应阶段名字
function ItemConf:getJieName( id,jie )
	-- body
	local item=self.conf[tostring(id)]
	if not item then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	local j = 1 
	if jie then 
		if jie<1 then 
			jie = 1
		end
		j = jie
	end

	if item.jienname then 
		if j <= #item.jienname  then 
			return item.jienname[j]
		else
			debugprint("配置表 没有这个阶段.."..j)
		end
	end
end

-----扩展字段值获取

--扩展类型
function ItemConf:getExtTpye( mId )
	-- body
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..id.."物品！")
		return 
	end 

	return item.ext_type
end


--扩展值1
function ItemConf:getExt01( mId )
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..id.."物品！")
		return 
	end 

	return item.ext01

end

--扩展值2
function ItemConf:getExt02( mId )
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..id.."物品！")
		return 
	end 

	return item.ext02

end
--扩展值3
function ItemConf:getExt03(mId)
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..id.."物品！")
		return 
	end 

	return item.ext03

end

--获取ext03对应的 图标
function ItemConf:getExt03Icon(mId )
	local ext03 = self:getExt03(mId)
	local icon
	if ext03 then
		if ext03 == 2 then--砖石
			icon = res.image.ZS
		elseif ext03 == 1 then--金币
			icon = res.image.GOLD
		elseif ext03 == 3 then--徽章
			icon = res.image.BADGE
		elseif ext03 == 4 then--贡献
			icon = res.icon.GONGXIANIOCN
		end
	end

	return icon
end

function ItemConf:getPrice( mId )
	-- body
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..id.."物品！")
		return 
	end 

	return item.price
end

function ItemConf:getIteminfo(id)
	-- body
	return self.conf[tostring(id)]
end

--跳转路径的 描述
function ItemConf:getItemjumpDesc( mId )
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..mId.."物品！")
		return 
	end 

	if not item.jump_desc then
		debugprint("没有jump_desc这个属性id="..mId)
	end

	return item.jump_desc
end

--跳转路径的 模式
function ItemConf:getJumpMode( mId )
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..mId.."物品！")
		return 
	end 

	if not item.mode then
		debugprint("没有mode这个属性id="..mId)
	end

	return item.mode
end

--跳转路径的 美术字
function ItemConf:getJumpFont( mId )
	local item = self.conf[tostring(mId)]
	if not item then
	 	debugprint("找不到ID "..mId.."物品！")
		return 
	end 

	if not item.jump_font then
		debugprint("没有mode这个属性id="..mId)
	end

	return item.jump_font
end



return ItemConf