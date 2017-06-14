local sdk = class("sdk")

function sdk:ctor()
  self.loginResult = nil
end

function sdk:initSdk()
  mgr.SceneMgr:playPreSceneVideo()
end

function sdk:login()
  if self.loginResult ~= nil then
    self:_login()
    self.loginResult = nil
  else
    self.loginResult = {}
  end
end

function sdk:logout()
  -- game.GameSdkHelper:getInstance():logout();
end

function sdk:isSdkInit()
  return true
  -- return game.GameSdkHelper:getInstance():getResult(CODE_INIT_SUCCESS) ~= "fail"
end

--支付
function sdk:pay(money_)
  local jsonObj = {
      money = money_,
      roleId = cache.Player:getRoleIdStr(),
      roleName = cache.Player:getName(),
      roleLevel = cache.Player:getLevel(),
      serverId = g_var.server_id,
      serverIp = g_var.debug_ip,
      serverPort = g_var.debug_port,
  }
  -- game.GameSdkHelper:getInstance():setPay(json.encode(jsonObj))
  if g_var.platform == "win32" then
    proxy.shop:sendRecharge(money_*10)  
  end
end

function sdk:_excFunc(code_,str_)
  game.GameSdkHelper:getInstance():excFunc(code_,str_);
end

--返回结果
function sdk:onResult(code_,jonsStr_)

end

function sdk:_login()
  local loginFunc = function()
    --保存账号
    --print("g_var.debug_accountId = "..g_var.debug_accountId)
    MyUserDefault.setAcount(user_default_keys.GAME_LOGIN_USER_ACCOUNT_KEY,g_var.debug_accountId) 
    g_var.debug_accountId = g_var.debug_accountId
    local data = {
        accountId     = g_var.debug_accountId,
        accountName   = g_var.debug_accountId,
        channelId     = g_var.channel_id,
        serverId      = g_var.server_id,
        md5Flag       = g_var.md5Flag,
    }
    proxy.Login:reqLogin(data)
    self.loginResult = nil
  end

  if mgr.NetMgr.isConnect ~= true then
      mgr.NetMgr:quickConnect(function()
        loginFunc()
        end)
  else
    loginFunc()
  end
end

--
function sdk:_onSdkInit(jsonStr_) 
   
end


--[[
###################################################################
]]

--@param flag_ 非0为用不锁屏
function sdk:setWakeLock(flag_)
  -- game.GameHelper:getInstance():setWakeLock(flag_)
end

return sdk