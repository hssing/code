local EquipmentPromoteProxy=class("EquipmentPromoteProxy",base.BaseProxy)

function EquipmentPromoteProxy:init()
    self:add(508002,self.returnEquipmentQh)
    self:add(508001,self.returnWearEquipment)
    self:add(508003,self.returnEquipmentJh)
    self:add(508005,self.returnEquipmentTuihua)
    self:add(508006,self.returnCompose) --降星
end
--佩戴装
function EquipmentPromoteProxy:reqWearEquipment(index_,toindex_)
	self:send(108001,{index=index_,toIndex=toindex_})
end
function EquipmentPromoteProxy:reqQhEquipment(  index_,flag)
	local data = {index=index_,flag = flag}
	printt(data)
	self:send(108002,data)

end
function EquipmentPromoteProxy:reqJhEquipment(  index_,toindex_)
	self:send(108003,{index=index_,toIndex = toindex_})
end
--装备退化
function EquipmentPromoteProxy:reqTuihua( index_ ,falg)
	-- body
	--print("index_ = "..index_)
	local i = 0
	if falg then 
		i = 1
	end 

	local data = {index = index_,opType = i}
	 printt(data)
	self:send(108005,data)
end

function EquipmentPromoteProxy:returnEquipmentTuihua( data_ )
	-- body
	if data_.status == 0 then 
	    debugprint("退化成功")
	    local __view = mgr.ViewMgr:get(_viewname.TUIVIEW)
	    if __view then
	        __view:onSeverCallBack(data_)
	    end

	    __view = mgr.ViewMgr:get(_viewname.COMPOSE) 
	    if __view then 
	       __view:setSeverData()
	    end

	    __view = mgr.ViewMgr:get(_viewname.EQUIPMENT_QH) 
	    if __view then 
	      __view:getCacheEquipment()
	      __view:getCacheMaterial()
	      local tt1 
			if data_.index > 400000 then 
				tt1 = cache.Equipment:isKey(data_.index)
				__view:updateEquipmentListData(clone(tt1))
			end 
	    end  




	  elseif data_.status == 21050003 then 
	    G_TipsOfstr(res.str.NO_ENOUGH_ZS)
	  else
	  	G_TipsError(data_.status)
	    debugprint("退化返回失败")
  end 
end

function EquipmentPromoteProxy:returnEquipmentQh( data_ )
	if  data_.status == 0 then
		debugprint("强化成功！！！！")
		local index= data_.index
		local cachedata = cache.Equipment:getEquitpmentDataInfo()
		local view=mgr.ViewMgr:get(_viewname.EQUIPMENT_QH)
	  	if view then
	  		view:severCallBack(data_,data_.lvl)
	  	end

	  	local view = mgr.ViewMgr:get(_viewname.FORMATION)
	  	if view then 
	  		view:updateEquipment(cachedata[index])
	  	end 

	  	local view = mgr.ViewMgr:get(_viewname.PACK)
	  	if view then 
	  		view:setData(cache.Pack:getPackInfo())
			view:updateUi()
	  	end 

        --武器强化
        local ids = {1048}
        mgr.Guide:continueGuide__(ids)
        
	else
		debugprint("返回："..data_.status)
	end
end
function EquipmentPromoteProxy:returnEquipmentJh( data_ )
	if  data_.status == 0 then
		debugprint("进化成功！！！！")
		local index= data_.index
		local cachedata = cache.Equipment:getEquitpmentDataInfo()
		 local view=mgr.ViewMgr:get(_viewname.EQUIPMENT_QH)

	  	 if view then
	  	 	view:JLseverCallBack(cachedata[index])
	  	 	--view:getCacheMaterial()
	  	 	--view:updateEquipmentListData(cachedata[index])
	  	 end

	  	local view = mgr.ViewMgr:get(_viewname.FORMATION)
	  	if view then 
	  		view:updateEquipment(cachedata[index])
	  	end 

	  	local view = mgr.ViewMgr:get(_viewname.PACK)
	  	if view then 
	  		view:setData(cache.Pack:getPackInfo())
			view:updateUi()
	  	end 
	else
		debugprint("返回："..data_.status)
	end
end
function EquipmentPromoteProxy:returnWearEquipment( data_ )
	if  data_.status == 0 then
		debugprint("佩戴装备！！！！")
        local ids = {1040,1058}
        mgr.Guide:continueGuide__(ids)
	else
		debugprint("返回："..data_.status)
	end
end

--降星
function EquipmentPromoteProxy:send108006( data_ )
	-- body
	self:send(108006,data_)
end
function EquipmentPromoteProxy:returnCompose( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.COMPOSE) 
		if view then 
			view:lowCallBack(data_.awards)
		end
	elseif data_.status == 21050003 then 
	    G_TipsOfstr(res.str.NO_ENOUGH_ZS)
	elseif data_.status == 21030001 then
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif 21030007 == data_.status  then
    	--todo
    	G_TipsOfstr(res.str.DEC_ERR_83)
    else
    	G_TipsError(data_.status)
	end
end

return EquipmentPromoteProxy