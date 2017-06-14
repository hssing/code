local LoginProxy = class("LoginProxy",base.BaseProxy)

function LoginProxy:init()

	--self:add(501001,self.resLogin)
    self:add(501002,self.resCreateRole)
	  self:add(501008,self.checkNameCallBack)
    self:add(800001, self.onErrorCallBack)
    self.firstShow = false

    self:add(501101,self.resLogin)
    self:add(501102,self.bagCallBack)
    self:add(501104,self.LoginRoleCallBack)
    
    --系统公告
    self:add(501103,self.GongGaoCallBack)
    self:add(801003,self.GongGaoUpdate)
end

function LoginProxy:GongGaoCallBack( data_ )
  -- body
  if data_.status == 0 then 
      cache.Player:keepGongGao(data_.noticeStr)
      local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
      if view then 
        view:createMarquee()
      end
  end
end

function LoginProxy:GongGaoUpdate( data_)
  -- body
  if data_.status == 0 then 
      cache.Player:keepGongGao(data_.noticeStr)
      local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
      if view then 
        view:createMarquee()
      end
  end
end

function LoginProxy:send101103()
  -- body
  self:send(101103)
end


--[[function LoginProxy:reqLogin(__reqdata)
  if not self:isConnect() then mgr.NetMgr:quickConnect() return end
	self:send(101001,__reqdata)
end]]--



function LoginProxy:reqCreateRole(data)
  --[[local __reqdata = {
    roleName = roleName_,
    career    = career_,
    roleSex   = sex_,
    roleKey   = roleKey_,
  }]]--
  G_Loading(true)
  printt(data)
  self:send(101002,data)
end
--
function LoginProxy:resLongSucc(  )
  -- body
    G_Loading(true)
    local data_ ={stype = 0 }
     self:send(101102,data_) --背包数据

    local __reqdata = {
    ctype = 0,
    }
    self:send(106001,__reqdata) --请求抽奖
    --请求探险
    proxy.adventure:sendMessage112001()
    --请求双11活动
    proxy.Active:reqSwitchState(nil,2)
    --print("106001 ")
    --proxy.task:sendMessagetype(1)--请求任务
end

function LoginProxy:sendcheckName(name)
  G_Loading(true)
  -- body
  local __reqdata = {
      roleName = name,
    }
    self:send(101008,__reqdata) --检测名字
end

---修改职业
function LoginProxy:sendChangeCarrer(carrer)
  G_Loading(true)
    self:send(101004,{career=carrer}) --请求抽奖
end

function LoginProxy:checkNameCallBack( data_ )
  G_Loading(false)
  -- body
  if data_.status == 0 then
    local __view = mgr.ViewMgr:get(_viewname.CREATE_ROLE)
    if __view ~= nil then
        __view:setNext() 
    end
  elseif  data_.status == 21010002 then 
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT)
  elseif data_.status == 21010003 then 
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_NO)
  elseif  data_.status == 21010001 then 
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_ROLE)
  else
    debugprint("失败检测")
  end 
end

function LoginProxy:resLoginRole()
  -- body
  G_Loading(true)
  self:send(101104)
end

function LoginProxy:LoginRoleCallBack( data_ )
  -- body
  if data_.status == 0 then 
      G_Loading(false)
      cache.Player:setRoleInfo(data_)
      cache.Fortune:setFortuneInfo(data_)

        --功能开启
    cache.Player:openFuncData(data_)
      --新手引导
      mgr.Guide:initGuideId(data_.guideId)
      --副本
      cache.Copy:setZjInfo(data_.fbInfos)
       --公告
       cache.Fortune:setGonggao(data_.notices)  
        --推送
    --G_Init_PushMsg___()

       self:resLongSucc() 
       local scene = mgr.SceneMgr:LoadingScene(_scenename.MAIN)
      self.firstShow = true 
      --一个全局计划
      g_timer_id = scheduler.scheduleGlobal(G_onesecond, 1.0)
   
  else
    debugprint("请求玩家角色失败")
  end 
end

function LoginProxy:reqLogin(__reqdata)
  if not self:isConnect() then mgr.NetMgr:quickConnect() return end
  self:send(101101,__reqdata)
  self:wait(501101)
  G_Loading(true)
end

function LoginProxy:resLogin(data_ )
  -- body
  G_Loading(false)

  if data_.versionId ~= 0 and  data_.versionId ~= g_msg_version then 
      mgr.NetMgr:errorMsg(data_)
      return 
  end

  if data_.status == 0 then
    if data_.career == 0 and fight_newer_state then
       G_EnterNewerFight()
       return 
    end
     cache.Player:setInfo(data_)
     self:resLoginRole()
  elseif data_.status == 21010001 then --木有角色需要跳转至创建角色View
      local __view = mgr.ViewMgr:get(_viewname.LOGIN)
      if __view ~= nil then
        __view:resCreateRole()
      end
  elseif data_.status == 21010002 then --角色名重复
      G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT)  
  elseif data_.status == 21010005 then 
      G_TipsError(data_.status)
  else
    mgr.NetMgr:errorMsg(data_)
    debugprint("请求登录游戏(返回) 失败")
  end 

end

function LoginProxy:bagCallBack(data_ )
  -- body
  if data_.status == 0 then
    printt(data_)
     G_Loading(false)
     cache.Pack:setPackInfo(data_)
     cache.Equipment:setEquitpmentInfo(data_)
     cache.Rune:setInfo(data_)
    -- cache.Material:savaData(data_)--果实合成材料


    local view = mgr.ViewMgr:get(_viewname.MAIN)
    if view then 
      view:setRedPoint()
    end 
  else
    debugprint("请求背包信息失败")
  end
end

--501001登陆返回
--[[function LoginProxy:resLogin(data_)
  G_Loading(false)
  if data_.status == 0 then
    cache.Player:setLoginSign(data_.loginSign) 
    


    ---职业选择为完成，进入新手战斗
    if data_.roleInfo.career == 0 then
       G_EnterNewerFight()
       return 
    end
    
    cache.Player:setRoleInfo(data_)
    cache.Pack:setPackInfo(data_)
    cache.Fortune:setFortuneInfo(data_)
    --公告
    cache.Fortune:setGonggao(data_.notices)       
    cache.Equipment:setEquitpmentInfo(data_)
    --副本
    cache.Copy:setZjInfo(data_.baseFbId, data_.superFbId)
    --功能开启
    cache.Player:openFuncData(data_)
    --新手引导
    mgr.Guide:initGuideId(data_.guideId)
    --推送
    G_Init_PushMsg___()
    --请求
    self:resLongSucc()
    local scene = mgr.SceneMgr:LoadingScene(_scenename.MAIN)
    self.firstShow = true 
    --一个全局计划
    g_timer_id = scheduler.scheduleGlobal(G_onesecond, 1.0)
  elseif data_.status == 21010001 then --木有角色需要跳转至创建角色View
    local __view = mgr.ViewMgr:get(_viewname.LOGIN)
    if __view ~= nil then
      __view:resCreateRole()
    end
  elseif data_.status == 21010002 then --角色名重复
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT)
  end
end
]]--
--501002
function LoginProxy:resCreateRole(data_)
  --在501001返回
  G_Loading(false)
  if data_.status == 0 then
      if not fight_newer_state then 
          G_Loading(false)
      end 
      --
      cache.Player:setLoginSign(data_.loginSign)
      sdk:extendInfoSubmit(3002, {roleId=data_.roleIdStr})
      if fight_newer_state then 
        G_EnterNewerFight()
      end

  elseif  data_.status == 21010002 then 
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT)
  elseif data_.status == 21010003 then 
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_NO)
  elseif  data_.status == 21010001 then 
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_ROLE)
  else
    G_Loading(false)
    G_TipsOfstr(res.str.LOGIN_ACCCOUNT_FAIL)
    --debugprint("失败检测")
  end  
end

--系统公告用的
function LoginProxy:setLoginBool(flag)
  -- body
  local f = flag or false
  self.firstShow = f 
end

function LoginProxy:getLoginBool()
  -- body
  return self.firstShow 
end

function LoginProxy:onErrorCallBack(data_)
    if data_.status == 0 then --模块提示语
        if data_.errorId == 21040004 then 
            G_TipsOfstr(res.str.PROMOTE_LAST)
            return 
        elseif data_.errorId == 21030001 then 
            G_TipsOfstr(res.str.PROMOTE_ENOUGH)
            return 
        elseif data_.errorId == 21090001 or data_.errorId == 21090002 then 
           mgr.NetMgr:errorMsg(data_.errorId)
        else
          G_TipsError(data_.errorId)
        end 
    else --关服,顶号等错误通知
        mgr.NetMgr:errorMsg(data_)
    end
end

return LoginProxy