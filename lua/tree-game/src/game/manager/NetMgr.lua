--[[--
游戏网络连接管理
]]

local NetMgr = class("NetMgr")

CONST_HEART_TIMEOUT     = 180  --socket心跳超时时间
CONST_HEART_SEND_TIME   = 10  --socket心跳发送间隔
CONST_HEART_CHECK_TIME  = 15  --socket心跳检查时间

MSG_ID_REQ_HEART      = 101902 --心跳包消息号
local NOT_PRINT_MSGIDS = {
  [501902] = {},
  --[502001] = {},
}

local scheduler = require("framework.scheduler")

function NetMgr:ctor()
	self.msgs      = {}
  self.isConnect = false
  self.timeCheckScheduler = nil -- 心跳动超时检测定时器
  self.heartbeatScheduler = nil -- 心跳包定时发送定时器
  self.reconnectScheduler = nil -- 重连定时器
  self.connectTimeTickScheduler = nil --检测连接超时定时器
  self.lastHeartbeatTime = os.time()
  self.netState = net_state.none
  self.connectedHandler = nil
  self.ignoreLoad = false

  self.handlerforwait = nil --等待消息返回时间限定 句柄
end

--添加监听
function NetMgr:add(msgId_,target_)
  self.msgs[msgId_] = target_
end


function NetMgr:quickConnect(func_)
  if func_ ~= nil then
    self.connectedHandler = func_
  end
  print("quickConnect-->",g_var.debug_ip,g_var.debug_port)
  self:connect(g_var.debug_ip,g_var.debug_port)
end


function NetMgr:restConnect()
    if self.gate == nil then
        self.isReConnect = true
        self.connectedHandler = nil
        self:quickConnect()
    end
end

--连接
function NetMgr:connect(host_,port_)
  if self.gate == nil then
    self._buf = MsgPacket.new()
    self.gate = common.netEngine
    self.gate:init(handler(self,self._onConnected),handler(self,self._onData),handler(self,self._onClose),handler(self,self._onConnectFailure))
    self.gate:connect(host_,port_)
  end
end

--发送
function NetMgr:send(msgId_,data_) 
  if self.gate and self.isConnect then
    if g_msg_pint == true and msgId_ ~= MSG_ID_REQ_HEART then --心跳包排除
      debugprint("msgId_ ==",msgId_)
    end
    local __def = Protocol.getSend(msgId_)
    local __buf = MsgPacket.createPacket(__def,data_)
    self.gate:send(__buf:getPack())
  else
    printError("网络异常~~~ 网络未连接......NetMgr:send:",msgId_)
  end
end

function NetMgr:wait( msgId_, ignoreLoad_ )
  -- body
  if msgId_ == 512002 then 
    G_Loading(true,nil,true)
  elseif msgId_ == 526005 then
    G_Loading(true,nil,true)
  else
     G_Loading(true)
  end 
  self.wait_msgId = msgId_
  if ignoreLoad_==true then
      self.ignoreLoad = true
  else
      self.ignoreLoad = false
  end

  local t = 10
  if self.handlerforwait ~= nil then
    return 
  end

  self.handlerforwait = scheduler.scheduleGlobal(function()
    -- body
      t = t -1 
       print("t = "..t)
      if t == 0 then 
        G_Loading(false)
        --G_TipsOfstr(res.str.NET_LONG_TIME)
        scheduler.unscheduleGlobal(self.handlerforwait)
        self.handlerforwait = nil 

        self:close()
      end 
  end,1)
end

--关闭网络
function NetMgr:close()
  debugprint("NetMgr:close()")
  if self.gate ~= nil then
    self.isConnect = false
    self.gate:close()
    self.gate = nil
  end
end

function NetMgr:close_NotTips()
  -- body
  if self.gate ~= nil then
    self.isConnect = false
    self:_onClose(true)
    self.gate = nil
  end
end

function NetMgr:closeNoView()
    debugprint("NetMgr:close()")
    if self.gate ~= nil then
        self.isConnect = false
        self.gate:_disconnect()
        self.gate = nil
        if self.heartbeatScheduler then scheduler.unscheduleGlobal(self.heartbeatScheduler) end
        if self.timeCheckScheduler then scheduler.unscheduleGlobal(self.timeCheckScheduler) end
    end
end

--登录测试
function NetMgr:testLogin()
  if self.tl == nil then
    self:add(501001,function(data_)
      print(data_.status,"~~~~~~~~~~~~~~~~~~")
    end)
    self.tl = {}
  end
  if self.gate ~= nil then
    print("testLogin")
    local da = {
      accountId     = "lanr",
      accountName   = "lanrName",
      channelId     = 1011,
      serverId      = 1001,
      md5Flag       = "md5xxxx",
    }
    self:send(101001,da)
  end
end

--创建测试
function NetMgr:testCreate()
  if self.tc == nil then
    self.tc = {}
    self:add(502001,function(data_)

    end)
  end
  if self.gate ~= nil then
    local __da = {
      career    = 1,
      RoleSex   = 1,
      roleName  = "aaa",
      roleKey   = "xxx-xxx-xx",
    }
    self:send(101002,__da)
  end

end

--测试命令
function NetMgr:testCommand(cmdStr_)
  if self.resTestCommand == nil then
    self.resTestCommand = {}
    self:add(501901,function(data_)
      print("resTestCommand")
    end)
  end
  if self.gate ~= nil then 
    self:send(101901,{cmdStr = cmdStr_,})
  end
end

--发送心跳包
function NetMgr:reqHeart()
  if self.isResHeart == nil then
    self.isResHeart = {}
    self:add(501902,handler(self,self.resHeart))
  end
  if self.gate ~= nil then
    self:send(101902,{})
  end
end

--发送心跳包(返回)
function NetMgr:resHeart(data_)
  g_var.serverTime = data_.serverTime
end

--检查超时
function NetMgr:checkHeartTimeout()
  if os.time() - self.lastHeartbeatTime > CONST_HEART_TIMEOUT and self.gate ~= nil and g_var.ignore_heart == false then
    self.gate:disconnect()
  end
end

--重连成功,重新登陆
function NetMgr:restConnectLogin(loginSign__) 
  local __da = {
    loginSign   = loginSign__,
  }
  self:send(101003,__da)
end

---------------------
---- private
---------------------

function NetMgr:_onConnected()
   self.netState = net_state.connect
   self.isConnect = true
   print("NetMgr:_onConnected()",self._buf)
   self.heartbeatScheduler = scheduler.scheduleGlobal(handler(self, self.reqHeart), CONST_HEART_SEND_TIME, false)
   self.timeCheckScheduler = scheduler.scheduleGlobal(handler(self, self.checkHeartTimeout), CONST_HEART_CHECK_TIME, false)  
    if self.isReConnect then
        mgr.NetMgr:restConnectLogin(cache.Player:getLoginSign())       
        self.isReConnect = nil
    end
    if self._restTips and not tolua.isnull(self._restTips) then
        self._restTips:closeSelfView()
        self._restTips = nil
    end
    if self.connectedHandler ~= nil then
      self.connectedHandler()
    end
end

function NetMgr:_onData(data_)
  self.lastHeartbeatTime = os.time()
  local arrs = self._buf:splitPacket(data_)
  self:_dispatch(arrs)
end

function NetMgr:_dispatch(resultArray)
  for i=1,#resultArray do
    local __msgBody = resultArray[i]
    local __cback = self.msgs[__msgBody.msgId]
    if self.wait_msgId and self.wait_msgId == __msgBody.msgId then
        if not self.ignoreLoad or __msgBody.status~=0 then
            G_Loading(false)
        end    
        if self.handlerforwait then 
          scheduler.unscheduleGlobal(self.handlerforwait)
           self.handlerforwait = nil 
        end
        self.wait_msgId = nil 
    end
    if g_msg_pint == true and NOT_PRINT_MSGIDS[__msgBody.msgId] == nil then
        print("---------------消息下行begin----------------")
         printt(__msgBody)
        print("---------------消息下行end----------------")
    end
    if __cback ~= nil then
      __cback(__msgBody)
    end
  end
end

--关闭连接
function NetMgr:_onClose(var)
    if self.netState == net_state.connect or self.netState == net_state.none then
        self.netState = net_state.break_line
    end 
    print("NetMgr:_onClose()",var)
    print(type(var) == "boolean")
    if self.heartbeatScheduler then scheduler.unscheduleGlobal(self.heartbeatScheduler) end
    if self.timeCheckScheduler then scheduler.unscheduleGlobal(self.timeCheckScheduler) end
    self.isConnect = false
    self.gate = nil    
    if not self._restTips and (type(var) ~= "boolean")  then
        self:showNetTips(-1)
    end
end

--连接失败
function NetMgr:_onConnectFailure()
    if self.netState == net_state.connect or self.netState == net_state.none then
        self.netState = net_state.failure
    end   
    print("NetMgr:onConnectFailure()")
    if self.heartbeatScheduler then scheduler.unscheduleGlobal(self.heartbeatScheduler) end
    if self.timeCheckScheduler then scheduler.unscheduleGlobal(self.timeCheckScheduler) end
    self.isConnect = false
    self.gate = nil
    if not self._restTips or self._restTips:isReConnet() then
        self:showNetTips(-2)
    end
end

---连接状态提示框
function NetMgr:showNetTips(errorCode_)
    debugprint("_________________________________[断线]", self.netState)
    if mgr.SceneMgr:checkCurScene() == _scenename.FIGHT then
        return
    end
    --debugprint("_________________________________[断线]", "不在fight")
    if mgr.SceneMgr:checkCurScene() == _scenename.LOGIN 
      and self.netState ~= net_state.connect 
      and self.netState ~= net_state.none 
      and self.netState ~= net_state.jump_say_fenhao
      and self.netState ~= net_state.jump_say_fenIp 
      and self.netState ~= net_state.md5_lose
      and self.netState ~= net_state.version_lose then 
        self.netState = net_state.login
    end
    --if not errorCode_ then errorCode_ = "" end
    errorCode_ = ""
    cache.Fight.isClickFight = false --客户端检测点击进入战斗，有点坑
    local data = {}
    if self.netState == net_state.break_line then
        data.richtext = res.str.NET_MGR_DESC1..errorCode_
        data.surestr = res.str.NET_MGR_DESC2
        data.sure = function() 
            self:restConnect()
        end
        data.cancel = function()
            self:_backToLogin()
        end
    elseif self.netState == net_state.failure then
        cache.Fight.fightState = 0
        data.richtext = res.str.NET_MGR_DESC3..errorCode_
        data.surestr = res.str.NET_MGR_DESC2
        data.sure = function() 
            self:restConnect()
        end
        data.cancel = function()
            self:_backToLogin()
        end
    elseif self.netState == net_state.mult_line then
        data.richtext = res.str.NET_MGR_DESC4..errorCode_
        data.surestr = res.str.NET_MGR_DESC5
        data.sure = function()
            self:_backToLogin()
        end
    elseif self.netState == net_state.jump then  --跳转登陆界面
        self:_backToLogin()
        return
    elseif self.netState == net_state.connect then
        if self._restTips and not tolua.isnull(self._restTips) then
            self._restTips:closeSelfView()
            self._restTips = nil
        end
        return
    elseif self.netState == net_state.close then
        data.richtext = res.str.NET_MGR_DESC6..errorCode_
        data.surestr = res.str.NET_MGR_DESC5
        data.sure = function()
            self:_backToLogin()
        end
    elseif self.netState == net_state.login then
        data.richtext = res.str.NET_MGR_DESC7..errorCode_
        data.surestr = res.str.NET_MGR_DESC5
        data.sure = function()
            self:_backToLogin()
        end
    elseif net_state.jump_say_fenhao == self.netState  then
      --todo
        data.richtext = res.str.ERROR_DEC1..errorCode_
        data.surestr = res.str.NET_MGR_DESC9
        data.sure = function()
            self:_backToLogin()
        end
    elseif net_state.jump_say_fenIp == self.netState then
      --todo
        data.richtext = res.str.ERROR_DEC2..errorCode_
        data.surestr = res.str.NET_MGR_DESC9
        data.sure = function()
            self:_backToLogin()
        end
    elseif net_state.md5_lose == self.netState  then
      --todo
        data.richtext = res.str.NET_MGR_DESC8..errorCode_
        data.surestr = res.str.NET_MGR_DESC5
        data.sure = function()
            self:_backToLogin()
        end
    elseif net_state.version_lose == self.netState then 
        data.richtext = res.str.DEC_ERR_28
        data.surestr = res.str.SURE
        data.sure = function()
            self:_backToLogin()
        end
    end    
    if self._restTips == nil then
        self._restTips = mgr.ViewMgr:createView(_viewname.NET_REST_TIPS)
    end
    if not self._restTips:getParent() then
      
      mgr.SceneMgr:getNowShowScene():addView(self._restTips)     
    end
    G_Loading(false)   
    self._restTips:setData(data)
end

---返回登陆场景
function NetMgr:_backToLogin()
    if self._restTips and not tolua.isnull(self._restTips) then
        self._restTips:closeSelfView()
        self._restTips = nil
    end
    sdk:logout()
end

---网络错误号返回
function NetMgr:errorMsg(data_)

    if data_.status == 20010101 then  --服务器关闭
        self.netState = net_state.close
        self:showNetTips(20010101)
    elseif data_.status == 20010102 then  --占线
        self.netState = net_state.mult_line
        self:showNetTips(20010102)
    elseif data_.status == 20010103 then  --跳转
        self.netState = net_state.jump
        self:showNetTips(20010103)
    elseif data_.status == 21090001 then --封号
        --debugprint("错误号提示")
        self.netState = net_state.jump_say_fenhao
        self:showNetTips(21090001)
    elseif data_.status == 21090002 then --封ip
      self.netState = net_state.jump_say_fenIp
      self:showNetTips(21090002)
    elseif data_.status == 21090005 then --验证失败
      self.netState = net_state.md5_lose
      self:showNetTips(21090005)
    elseif data_.versionId then --登录版本
      self.netState = net_state.version_lose
      self:showNetTips(res.str.DEC_ERR_28)
    end
    self:close()
end

return NetMgr