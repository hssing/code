

local LuckyProxy = class("LuckyProxy",base.BaseProxy)

function LuckyProxy:init()
	-- self:add(503001,self.returnPack)
	self._ctype = 0;--获取抽奖信息,1:道具,2:1次,3:10次
	self:add(506001 ,self.keepDataInfo)
	self:add(508004 ,self.Returncompose)
end

function LuckyProxy:keepDataInfo(data_)
	-- body
	if data_.status == 0 then 
		cache.Lucky:setDatainfo(data_)
		if self._ctype > 0 then --有物品返回 做动画
            mgr.Sound:playChoujiang()
			local __view = mgr.ViewMgr:get(_viewname.LUCKYDRAW)
			if __view  then
				__view:setData(data_)
				__view:severCallBack(cache.Lucky:getDataInfo().items)
			end	

			
			
			--[[local __view = mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if __view == nil  then 
				__view = mgr.ViewMgr:showView(_viewname.PACKGETITEM)	
			end	
			__view:setData(cache.Lucky:getDataInfo().items,true)]]--
            local ids = {1006}
            mgr.Guide:continueGuide__(ids)
		end

		local view = mgr.ViewMgr:get(_viewname.MAIN)
			if view then 
				view:setRedPoint()
			end 
	elseif data_.status == 21060001 then --21060001 抽奖道具不足 
		G_TipsOfstr(res.str.NO_ENOUGH_CHOU)
	elseif data_.status == 21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
		--G_GotoPack(res.str.NO_ENOUGH_PACK)
	else
		print("506001 抽奖新返回失败")
	end
end

function LuckyProxy:getCurBuy_ctype(  )
	-- body
	return self._ctype
end

function LuckyProxy:sendMessage( index_,flag)
	-- body
	self._ctype = index_

	if self._ctype == 1 or self._ctype == 4  then --道具  --221015001
		if cache.Pack:getItemAmountByMid(pack_type.PRO,221015001)<1 then 
			G_TipsOfstr(res.str.NO_ENOUGH_ITEM)
			return
		end	
	elseif self._ctype == 2 then 
		local dd = cache.Lucky:getlastTime()-(os.time()- cache.Lucky:getRecordTime())
		if dd >0 and  not G_BuyAnything(2,conf.Sys:getValue("lucky_zs1_money")) then 
			local view = mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if view then 
				view:onCloseSelfView()
			end 
			return
		end
	elseif self._ctype == 3  then 
		if flag then 
			local data = {}
			data.richtext = {
				{text=res.str.DEC_ERR_76,fontSize=24,color=cc.c3b(255,255,255)},
				{img=res.image.ZS},
				{text=tostring(conf.Sys:getValue("lucky_zs10_money")),fontSize=24,color=cc.c3b(255,204,0)},

				{text=res.str.DEC_ERR_77,fontSize=24,color=cc.c3b(255,255,255)},
				
			}
			data.surestr = res.str.SURE
			data.sure = function( ... )
				-- body
				if G_BuyAnything(2,conf.Sys:getValue("lucky_zs10_money")) then 
					local view = mgr.ViewMgr:get(_viewname.PACKGETITEM)
					if view then 
						view:onCloseSelfView()
					end 
					local __reqdata = {
				    	ctype = self._ctype,
				    }
				    self:send(106001,__reqdata)
				    self:wait(506001)
					return
				end
			end
			data.cancel = function( ... )
				-- body
			end
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)
			return 
		end 

		if not G_BuyAnything(2,conf.Sys:getValue("lucky_zs10_money")) then 
			local view = mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if view then 
				view:onCloseSelfView()
			end 
			return
		end
	else
		debugprint("抽 "..send:getTag().." 只能是 1 2 3")
	end	

	local __reqdata = {
    ctype = self._ctype,
    }
    self:send(106001,__reqdata)
    self:wait(506001)
end

function LuckyProxy:Composesend( data_ )
	-- body
	--108004
	self:send(108004,data_)
	self:wait(508004)
end

function LuckyProxy:Returncompose(data_ )
	-- body
	if data_.status == 0 then 
		debugprint("成功合成 "..data_.index)
		local __view = mgr.ViewMgr:get(_viewname.COMPOSE)
		if __view ~= nil then
			__view:updateData(data_.index)
		end	
		
		--G_ShowAchi()
		
		--data_.itemId
	elseif 20010001 ==  data_.status then 
		G_TipsOfstr(res.str.NO_ENOUGH_JB) 
	elseif 21040001 ==   data_.status then--材料不足
    	G_TipsOfstr(res.str.NO_ENOUGH_ITEM)	
	else
		debugprint("合成失败")
	end	
end

return LuckyProxy
