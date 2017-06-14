local PackProxy = class("PackProxy",base.BaseProxy)

function PackProxy:init()
	-- self:add(503001,self.returnPack)
	self:add(503002 ,self.returnUsePack)
	self:add(503004 ,self.keepDetailed)
  self:add(504006 ,self.buyCallBack)
  self:add(503005 ,self.add_503005)
	self.types =  3
	self.useitem = {}
end


function PackProxy:send_103005(param)
  -- body
  self:send(103005,param)
  self:wait(503005)
end

function PackProxy:add_503005( data_)
  -- body
  if data_.status == 0 then
      local view = mgr.ViewMgr:get(_viewname.CAHNGENAME)
      if view then 
        view:onCloseSelfView()
      end

      if  data_.reqType == 0 then
          cache.Player:setPlayerName(data_.name)
      elseif data_.reqType == 1 then
          cache.Player:setguildName(data_.name)
      end
  else
      G_TipsError(data_.status)
  end 
end

--请求某一个 详细信息 tyeps 1 装备 3 卡牌
function PackProxy:reqDetailed( tyeps,index_ )
	-- body
	self.types = tyeps 

	local data = {
		index = index_,
	}
	self:send(103004,data)
end
--详细信息返回
function PackProxy:keepDetailed( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.PETDETAIL)
		if view then 
			view:updateSecond(data_)
		end 
		
		view = mgr.ViewMgr:get(_viewname.EQUIPMENT_MESSAGE)
		if view then
			view:updateSecond(data_)
		end 
	else
		debugprint("103004 请求 503004 没有返回 ")
	end 
end

function PackProxy:reqGetPack(packdata)
	-- printt(packdata)
	self.useitem = packdata --记录使用了什么道具
	self:send(103002,{index=packdata.index,amount=packdata.amount,mId=packdata.mId})
end

function PackProxy:returnUsePack(data_)
  	if data_.status == 0 then
      local view = mgr.ViewMgr:get(_viewname.PACK)
      if view then
        view:scrolltoindex()
      end

  		local type=conf.Item:getType(self.useitem.mId)
      local sptype = conf.Item:getSp_type(self.useitem.mId)
  		if type ==  pack_type.PRO then
  			local str = ""
  			if self.useitem.mId == 221011002 or self.useitem.mId == 221011003
  				or 221011004 == self.useitem.mId then --使用了体力道具
  				local value = conf.Item:getExp(self.useitem.mId)
  				str = string.format(res.str.PACK_USEFORTILI,value*self.useitem.amount)

  			elseif self.useitem.mId == 221011008 or 221011009 == self.useitem.mId 
  				or 221011010 == self.useitem.mId then  --探险次数道具 
  				local value = conf.Item:getExp(self.useitem.mId)
  				str = string.format(res.str.PACK_USELADV,value*self.useitem.amount)

  			elseif self.useitem.mId == 221011005 or self.useitem.mId == 221011006--竞技场道具
  			 	or 221011007 ==  self.useitem.mId  then  
  				local value = conf.Item:getExp(self.useitem.mId)
  				str = string.format(res.str.PACK_USELFORAREAN,value*self.useitem.amount)

  				local view = mgr.ViewMgr:get(_viewname.ATHLETICS)
  				if  view then
  					view:updatejjcTimes(cache.Player:getAthleticsCout())
  				end 
        elseif self.useitem.mId == 221015021 or self.useitem.mId == 221015022--双11
          or 221015023 ==  self.useitem.mId or 221015024 == self.useitem.mId then  
          local arg = conf.Item:getArg1(self.useitem.mId)
          local money = arg.arg1
          G_TipsOfstr(string.format(res.str.DOUBLE_DEC22,money*self.useitem.amount))
        elseif  sptype and sptype >0 then
          --todo
          local arg = conf.Item:getArg1(self.useitem.mId)
          local data = {}
          data.mId = arg.arg1
          data.propertys = {}
          data.amount = 1

          local t ={}
          table.insert(t,data)

          local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
          if not view then
            view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
            view:setData(t,false,true,true)
            view:setButtonVisible(false)
          end

  			end 

  			if str ~= "" then 
  				G_TipsOfstr(str)
  			end 
  		end


  	elseif data_.status == 21030001 then 
  		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif data_.status == 21030004 then 
      G_TipsOfstr(res.str.PACK_DEC2)
  	else
      G_TipsError(data_.status)
  		debugprint("使用失败")	
 	end

end

--501002
function PackProxy:resCreateRole(data_)

  
end
---请求购买某个道具
function PackProxy:requestBuy(param)
  -- body
  printt(param)
  self:send(104006,param)
end

function PackProxy:buyCallBack( data_ )
  -- body
  if data_.status == 0 then 
    G_TipsOfstr(res.str.BUY_SUCCESS)
    local view = mgr.ViewMgr:get(_viewname.DIG_SET)
    if view then 
      view:updateinfo(data_)
    end 
  elseif data_.status == 21030001  then 
      G_TipsOfstr(res.str.NO_ENOUGH_PACK)
  else
      debugprint("购买失败")  
  end
end

return PackProxy