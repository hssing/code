local CardProxy=class("CardProxy",base.BaseProxy)

function CardProxy:init()
  self:add(504007 ,self.returnBattle)
  self:add(504002 ,self.returnlvUP)
  self:add(504004 ,self.returnColorUP)
  self:add(504005 ,self.retrurnTuihua)

  self:add(501202,self.add_501202) --查看对方的阵容
  self:add(504008,self.add_504008) --请求小伙伴改变
  self.toinx = -1 -- 出站位置 --
  self.send_index = -1
end

function CardProxy:send_104008(param)
  -- body
  printt(param)
  self:send(104008,param)
  self.send_index = param.packIndex
  self:wait(504008)
end

function CardProxy:add_504008(data_)
  -- body
  if data_.status == 0 then 
    local view_1 = mgr.ViewMgr:get(_viewname.PETDETAIL)
    if view_1 then
      view_1:onCloseSelfView()
    end

    local view = mgr.ViewMgr:get(_viewname.CRADFRIEND)
    if view then 
      view:updateInfo(data_,self.send_index)
    end
  else
    G_TipsError(data_.status)
  end
end

function CardProxy:add_501202(data_ )
  -- body
  if data_.status == 0 then 
    local view = mgr.ViewMgr:get(_viewname.OTHER_VIEW)
    if view then 
      view:setServerBack(data_)
    end
  else
    G_TipsError(data_.status)
  end
end

function CardProxy:send_101202(param)
  -- body
  printt(param)
  self:send(101202,param)
  self:wait(501202)
end

function CardProxy:returnToindx()
  -- body
  return self.toinx
end


function CardProxy:setToindx( id )
  -- body
  self.toinx = id
end

function CardProxy:reqBattle(data)
  self:setToindx(data.toIndex)
  printt(data)
  self:send(104007,{toIndex=data.toIndex,index=data.index,mid=data.mId,opType = data.opType})
end

function CardProxy:reqLvUp(data)
  self:send(104002,data)
  self:wait(504002)
end

function CardProxy:reqJINHUA(data)
  -- body
  self:send(104004,data)
  self:wait(504004)
end
--退化
function CardProxy:resTuihua( index_ ,flag)
  -- body
  local f = 0 
  if flag then 
    f = 1
  end
  local data = {index = index_,opType = f }
  printt(data)
  self:send(104005,data)
end

function CardProxy:retrurnTuihua( data_ )
  -- body
  if data_.status == 0 then 
    debugprint("退化成功 card")
    local __view = mgr.ViewMgr:get(_viewname.TUIVIEW)
    if __view then
      __view:onSeverCallBack(data_)
    end
     __view = mgr.ViewMgr:get(_viewname.COMPOSE) 
    if __view then 
      print("ddddd")
      __view:setSeverData()
    end 
     __view = mgr.ViewMgr:get(_viewname.PROMOTE_LV) 
    if __view then
      __view:changeData()
      __view:update()
    end 

    

  elseif data_.status == 21050003 then 
    G_TipsOfstr(res.str.NO_ENOUGH_ZS)
  else
    G_TipsError(data_.status)
    debugprint("退化返回失败")
  end 
end

function CardProxy:returnColorUP( data_ )
  -- body
  if data_.status ==0 then 
     local __view = mgr.ViewMgr:get(_viewname.PROMOTE_LV)
     if __view then
        __view:onSeverCallBack()
       --__view:changeData()
       --__view:cleanSelectPet()
       --__view:removeAllWidget()
       --__view:update()
     end

     local view = mgr.ViewMgr:get(_viewname.SPRITE7SCAD)
     if view then
        view:serverCallBack()
     end
   

  elseif 21040002 == data_.status then--品质不够
    G_TipsOfstr(res.str.NO_ENOUGH_COLOR)
  elseif 21040001 ==   data_.status then--材料不足
    G_TipsOfstr(res.str.NO_ENOUGH_ITEM)
  elseif 20010001 == data_.status then
    --todo
     G_TipsOfstr(res.str.NO_ENOUGH_JB)
  else
    G_TipsError(data_.status)
    debugprint("卡牌进化 失败")
  end 
end

function CardProxy:returnBattle(data_)
  if data_.status == 0 then
  	 debugprint("请求出站成功！！！！")
  	 local view = mgr.ViewMgr:get(_viewname.CHANGE_FORMATION)
     if view  then 
        local  alldata  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
        local onbattle = {}
        for k,v in pairs(alldata) do
            if conf.Item:getBattleProperty(v) > 0 then
              table.insert(onbattle,v) --所有上阵的人
            end

            view:setData(onbattle)
        end


       -- view:selectCallBack(self.toinx)
    end 
  else
      G_TipsError(data_.status)
  end
end
function CardProxy:returnlvUP(data_)
  if data_.status == 0 then
  	 --debugprint("成功！！！！！！")
    
  	 local view=mgr.ViewMgr:get(_viewname.PROMOTE_LV)
  	 if view then
  	 	   view:onLvUpSeverCallBack()
  	 end
     local ids = {1024}
     mgr.Guide:continueGuide__(ids)
  elseif data_.status == 21040003 then 
    G_TipsOfstr(res.str.CARD_HERO_MAX)
  elseif data_.status == 21040001 then 
    G_TipsOfstr(res.str.NO_ENOUGH_ITEM)
  elseif data_.status ==21040002 then --品质不够
    G_TipsOfstr(res.str.NO_ENOUGH_COLOR)
  elseif 20010001 == data_.status then
    G_TipsOfstr(res.str.NO_ENOUGH_JB)
  else
  	 debugprint("升级返回！！！！！",data_.status)
  end
end



return CardProxy