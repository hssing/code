local sdk = class("sdk")

--SDK初始化成功
local CODE_INIT_SUCCESS = 2;
--登录成功(code,sid)
local CODE_LOGIN_SUCCESS = 4
local CODE_LOGIN_FAIL = 5
--登录结果
local CODE_LOGIN_RESULT  = 6
--关闭账号UI
local CODE_LOGIN_EXIT = 7
--账号退出成功
local CODE_LOGOUT_SUCCESS = 8

local CODE_CHANGE = 10;  --sdk切换账号
--提交信息
local CODE_INFO_SUBMIT = 11

local CODE_ONPAUSE = 12  --游戏暂停
local CODE_ONSTOP  = 13  --游戏停止
local CODE_ONRESUME = 14  --游戏恢复
local CODE_ONRESTART=15  --游戏开始
local CODE_PRESS_BACK=16  --按下返回键
local CODE_SWITCH_ACCOUNT = 17  --切换账号
local CPLOGIN = 18;  --cp登陆
local CODE_GAMESOUND = 19  --音频管理

local CODE_PAY_SUCCESS = 402

--点击sdk返回
local CODE_SDK_EXIT = 999
FACEBOOK_THUMB = 1002
FACEBOOK_SHARE = 1003

local USER_CENTER = 1004 --进入用户中心，暂时就凤凰网SDK使用
local CODE_GET_PLAYVIDEO = 1005  --ios开始播放视频

--apk更新
local CODE_APK_UPDATE = 1099

local SUBMIT_TYPE_LOGIN = 3001   --登录
local SUBMIT_TYPE_CREATE = 3002  --创建角色
local SUBMIT_TYPE_LEVELUP = 3003 --升级

function sdk:ctor()
  self.cpLogining = false
  self.loginResult = nil
  self.loginFlag = 0
  self.sdkParams = json.decode(game.GameSdkHelper:getInstance():getSdkParams())
  if self.sdkParams ~= nil and self.sdkParams.platformStr ~= "win32" then
      g_var.platform = self.sdkParams.platformStr
      g_var.channel_id = self.sdkParams.channel
      print("----------------------------------=======================",g_var.channel_id)
  end
  game.GameSdkHelper:getInstance():setDelegate(handler(self,self.onResult))
end

function sdk:initSdk()
  -- game.GameSdkHelper:getInstance():initSdk();
end

function sdk:login()
	game.GameSdkHelper:getInstance():login()
  --[[if self.loginFlag ~= 0 then
    self:_login()  --登陆游戏
  else
    print("--------------------------------------------------------------game.GameSdkHelper:getInstance():login()")
    self.loginFlag = 1
    game.GameSdkHelper:getInstance():login()--sdk
  end]]
end

function sdk:logout()
    G_RestGame() 
    mgr.SceneMgr:LoginSceneWithUpdateCheck(true,function()
        self.loginFlag = 0
        g_var.debug_accountId = ""
        --game.GameSdkHelper:getInstance():logout()   
    end)
end

function sdk:isSdkInit()
  return game.GameSdkHelper:getInstance():getResult(CODE_INIT_SUCCESS) ~= "fail"
end

--支付
function sdk:pay(params_)
    local waresid = conf.Waresid:getWaresid(g_var.channel_id, params_.price)
    local jsonObj = {
        money = params_.price,
        roleId = cache.Player:getRoleIdStr(),
        roleName = cache.Player:getName(),
        roleLevel = cache.Player:getLevel(),
        serverId = g_var.server_id,
        serverIp = g_var.debug_ip,
        serverPort = g_var.debug_port,
        serverName = g_var.debug_name,
        productName = params_.name,
        productDesc = params_.desc,
        roleLeftMoney = cache.Fortune:getZs(),
        roleVip = cache.Player:getVip(),
        roleGuild = cache.Player:getGuildId().key,
        waresid = waresid,
    }
    print("--------------",json.encode(jsonObj))
    game.GameSdkHelper:getInstance():setPay(json.encode(jsonObj))
end

--提交渠道用户信息
function sdk:extendInfoSubmit(type, data_)
    local jsonObj
    if type == SUBMIT_TYPE_CREATE then
        jsonObj = {
            type = SUBMIT_TYPE_CREATE,
            roleId = data_.roleId,
            roleName = cache.Player:getName(),
            roleLevel = 1,
            serverId = g_var.server_id,
            serverIp = g_var.debug_ip,
            serverPort = g_var.debug_port,
            serverName = g_var.debug_name,
            roleLeftMoney = 0,
            roleVip = 1,
            roleGuild = "0_0",
        }
    else
        jsonObj = {
            type = type,
            roleId = cache.Player:getRoleIdStr(),
            roleName = cache.Player:getName(),
            roleLevel = cache.Player:getLevel(),
            serverId = g_var.server_id,
            serverIp = g_var.debug_ip,
            serverPort = g_var.debug_port,
            serverName = g_var.debug_name,
            roleLeftMoney = cache.Fortune:getZs(),
            roleVip = cache.Player:getVip(),
            roleGuild = cache.Player:getGuildId().key,
        }
    end
    print("_______提交sdk信息type:",type)
    game.GameSdkHelper:getInstance():extFunc(CODE_INFO_SUBMIT, json.encode(jsonObj))
end

function sdk:_excFunc(code_,str_)
  game.GameSdkHelper:getInstance():extFunc(code_,str_)
end

--返回结果
function sdk:onResult(code_,jonsStr_)
    print("onResult->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",code_,jonsStr_)
    if code_ == CODE_LOGIN_SUCCESS then
        self.loginResult = {}
    elseif code_ == CODE_LOGIN_RESULT then --登陆结果
        self.cpLogining = false
        self.loginFlag = 1
        self.loginResult        = json.decode(jonsStr_)
        g_var.debug_accountName = self.loginResult.nick_name
        g_var.debug_accountId   = self.loginResult.account
        g_var.flag              = self.loginResult.flag
        g_var.time              = self.loginResult.time
        g_var.channel_id        = self.loginResult.channel
		    self:_login()
    elseif code_ == CODE_INIT_SUCCESS then --SDK初始化成功
        self:_onSdkInit(jonsStr_)
    elseif code_ == CODE_LOGOUT_SUCCESS then --退出登陆
        self.loginResult = nil
    elseif code_ == CODE_LOGIN_EXIT then  
    elseif code_ == CODE_ONPAUSE then--游戏暂停
        g_var.ignore_heart = true
    elseif code_ == CODE_ONSTOP then --游戏停止
        g_var.ignore_heart = true
    elseif code_ == CODE_ONRESUME then  --游戏恢复
        self.lastHeartbeatTime = os.time()
        g_var.ignore_heart = false
    elseif code_ == CODE_ONRESTART then --游戏重启
        self.lastHeartbeatTime = os.time()
        g_var.ignore_heart = false
    elseif code_ == CODE_PRESS_BACK then  --部分sdk不提供返回处理，自己弹出退出框
        local data = {}
        data.sure = function( ... ) app:exit() end
        data.cancel = function( ... )end
        data.richtext  = res.str.SYS_DEC10
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
    elseif code_ == CODE_CHANGE then  --sdk切换账号
        if mgr.SceneMgr:checkCurScene() == _scenename.LOGIN then
            self.loginFlag = 1
            game.GameSdkHelper:getInstance():login()
        else
            mgr.NetMgr:closeNoView()
            sdk:logout()
        end
    elseif code_ == CODE_PAY_SUCCESS then  --支付成功
        --local data_ = json.decode(jonsStr_)
        if jonsStr_ and  jonsStr_ ~= "" then 
           local str = string.split(jonsStr_, ",")
           cache.Shop:updateListinfo(str[1])
        end 
        --cache.Shop:updateListinfo( RMB的值 )
    elseif code_ == CODE_SDK_EXIT then  --退出游戏
        app:exit()
    elseif code_ == CODE_LOGIN_FAIL then
        self.cpLogining = false
    elseif code_ == CODE_GAMESOUND then
        if jonsStr_ == "101" or jonsStr_ == "105" then  --静音处理
            mgr.Sound:sdkSound(false)
        else
            mgr.Sound:sdkSound(true)
            
        end
    elseif code_ == CODE_GET_PLAYVIDEO then
        if device.platform == "ios" then
            mgr.SceneMgr:getNowShowScene():playVoide()
        end
    end
end

function sdk:loginGame()
  --if self.cpLogining == true then return end
	--cp登陆
  self.cpLogining = true
	game.GameSdkHelper:getInstance():extFunc(CPLOGIN,"cplogin")
end

function sdk:_login()
  local loginFunc = function()
      local data = {
          accountId     = g_var.debug_accountId,
          accountName   = g_var.debug_accountName,
          channelId     = g_var.channel_id,
          serverId      = g_var.server_id,
          md5Flag       = g_var.flag,
          md5Time       = g_var.time ,
          sId           = "" ,
      }
      --作弊用的
      if g_var.server_bt ~= 0 then
          data.serverId = g_var.server_bt
      end
      if g_var.channel_bt ~= 0 then
          data.channelId = g_var.channel_bt
      end
      if g_var.account_bt ~= 0 then
          data.accountId = g_var.account_bt
      end
	  proxy.Login:reqLogin(data)
  end	
    mgr.NetMgr:quickConnect(function()
        loginFunc()
    end)
end

function sdk:onSwitchAccount()
    game.GameSdkHelper:getInstance():extFunc(CODE_SWITCH_ACCOUNT,"CODE_SWITCH_ACCOUNT")
end

--
function sdk:_onSdkInit(jsonStr_) 
    mgr.SceneMgr:playPreSceneVideo()
end

--
function sdk:onBack()
  self:_excFunc(1001,"{}")
end

--[[
###################################################################
]]

function sdk:share()
    game.GameSdkHelper:getInstance():extFunc(FACEBOOK_SHARE,"FACEBOOK_SHARE")
end

function sdk:thumb()
    game.GameSdkHelper:getInstance():extFunc(FACEBOOK_THUMB,"FACEBOOK_THUMB")
end

--@param flag_ 非0为用不锁屏
function sdk:setWakeLock(flag_)
  game.GameHelper:getInstance():setWakeLock(flag_)
end

--进入用户中心
function sdk:userCenter(  )
  self:_excFunc(USER_CENTER,"{}")
end



return sdk