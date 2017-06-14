local ConfMgr={}

local ITEM_PATH_ROOT="res/itemicon/"



--获取物品图片路径
function ConfMgr.getItemSrc(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.src
end

--获取物品对应卡的id
function ConfMgr.getItembyID(id)
	local time=res.conf.ITEM[tostring(id)]
	return time.srcs[1];

end
--获取物品对应卡的ID
function ConfMgr.getItemID(id,jj)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.srcs[jj]
end
--获取物品品质
function ConfMgr.getItemQuality(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.color
end
--获取物品类型
function ConfMgr.getItemType(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.type
end
--获取物品名字
function ConfMgr.getItemName(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.name
end
--获取物品说明
function ConfMgr.getItemDescribe(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return time.describe
end

--本地表信息
--获取装备的攻击的攻击
function ConfMgr.getLocalEquipAtt(id)
	-- body
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end 
	return time.att_102
end

function ConfMgr.getLocalEquipdef(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end 
	return time.att_103
end	

function ConfMgr.getLocalEquipHp(id)
	local time=res.conf.ITEM[tostring(id)]
	if not time then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end 
	return time.att_105
end	

--获取人物升级经验值
function ConfMgr.getPlayerExp(lv)
	local Role=res.conf.BASE_PROPERTY[tostring(lv)]
	if not Role then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return Role.att_101
end
--获取人物hp
function ConfMgr.getPlayerMaxHp(lv)
	local Role=res.conf.BASE_PROPERTY[tostring(lv)]
	if not Role then 
		debugprint("找不到ID "..lv.."物品！")
		return 
	end
	return Role.att_105
end
--获取人物atk
function ConfMgr.getPlayeAtk(lv)
	local Role=res.conf.BASE_PROPERTY[tostring(lv)]
	if not Role then 
		debugprint("找不到ID "..lv.."物品！")
		return 
	end
	return Role.att_102
end
--获取人物def
function ConfMgr.getPlayerDef(lv)
	local Role=res.conf.BASE_PROPERTY[tostring(lv)]
	if not Role then 
		debugprint("找不到ID "..lv.."物品！")
		return 
	end
	return Role.att_103
end

--获取人物def
function ConfMgr.getHeadSrc(id)
	local head=res.conf.HEAD[tostring(id)]
	if not head then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return head.src
end
--获取怪物SRC
function ConfMgr.getCardSrc(id)
	local head=res.conf.CARD[tostring(id)]
	if not head then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return head.img_src
end
--获取怪物name
function ConfMgr.getCardName(id)
	local head=res.conf.CARD[tostring(id)]
	if not head then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return head.name
end
--获取物品的等级
function ConfMgr.getLv(propertys)
	local data= propertys[304]
	if data then
		return data.value
	end
	return  1
end
--获取物品的阶数
function ConfMgr.getItemJJ(propertys)
	local data= propertys[307]
	if data then
		return data.value
	end
	return  0
end
--获取物品的进化数
function ConfMgr.getItemJH(propertys)
	local data= propertys[310]
	if data then
		return data.value
	end
	return  0
end
--获取物品精炼等级
function ConfMgr.getItemJh(propertys)
	if propertys then
		local data= propertys[311]
		if data then
			return data.value
		end
	end
	return  0
end
--获取强化等级
function ConfMgr.getItemQhLV(propertys)
	local data= propertys[303]
	if data then
		return data.value
	end
	return  0
end
--获取物品攻击
function ConfMgr.getItemAtK(propertys)
	local data= propertys[102]
	if data then
		return data.value	
	end
	return  0
end

--获取物品防御
function ConfMgr.getItemDef(propertys)
	local data= propertys[103]
	if data then
		return data.value
	end
	return  0
end
--获取物品生命
function ConfMgr.getItemHp(propertys)
	local data= propertys[105]
	if data then
		return data.value
	end
	return  0
end
--获取物品经验值
function ConfMgr.getExp(propertys)
	local data= propertys[101]
	if data then
		return data.value
	end
	return  0
end
--获取物战斗力
function ConfMgr.getPower(propertys)
	if propertys then
		local data= propertys[305]
		if data then
			return data.value
		end
	end
	
	return  0
end
--获取物暴击
function ConfMgr.getCrit(propertys)
	local data= propertys[106]
	if data then
		return data.value
	end
	return  0
end
--获取物暴击伤害
function ConfMgr.getCritSh(propertys)
	local data= propertys[107]
	if data then
		return data.value
	end
	return  0
end
--获取物命中
function ConfMgr.getMz(propertys)
	local data= propertys[110]
	if data then
		return data.value
	end
	return  0
end
--获取物抗暴击
function ConfMgr.getResistantCrit(propertys)
	local data= propertys[108]
	if data then
		return data.value
	end
	return  0
end
--获取物命中
function ConfMgr.getHit(propertys)
	local data= propertys[110]
	if data then
		return data.value
	end
	return  0
end
--获取物闪避
function ConfMgr.getDodge(propertys)
	local data= propertys[109]
	if data then
		return data.value
	end
	return  0
end
--获取物破甲
-- function ConfMgr.getSunder(propertys)
-- 	local data= propertys[109]
-- 	if data then
-- 		return data.value
-- 	end
-- 	return  0
-- end
-- --获取物品生命
-- function ConfMgr.getItemHp(propertys)
-- 	local data= propertys[105]
-- 	if data then
-- 		return data.value
-- 	end
-- 	return  0
-- end


----获取vip商店的原价
function ConfMgr.getOldPrice( id )
	-- body
	local shop=res.conf.SHOP[tostring(id)]
	if not shop then 
		debugprint("找不到ID "..id.."物品！")
		return 
	end
	return shop.old_price
end












return ConfMgr