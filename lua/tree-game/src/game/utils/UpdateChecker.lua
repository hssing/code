--[[
	UpdateChecker 热更检测
]]
local gameCommonTool = require("game.utils.GameCommonTool.GameCommonTool")
local UpdateChecker = class("UpdateChecker")
local UpdateVersion = require("src.version")

function UpdateChecker:ctor(view_)
	self:createDownloadDir()
	self._manager = cc.AssetsManager:new(nil,nil,self:getDownloadDir()) --一个下载放置的目录
	self._manager:retain()
	self._manager:setDelegate(handler(self,self.onUpdateError), cc.ASSETSMANAGER_PROTOCOL_ERROR )
	self._manager:setDelegate(handler(self,self.onUpdateProgress), cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
	self._manager:setDelegate(handler(self,self.onUpdateSuccess), cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
	self._manager:setConnectionTimeout(3)
	self._updateList = {}
	self._view = view_
end

---清理下载器
function UpdateChecker:release() 
	if tolua.isnull(self._manager) ~= false then 
		self._manager:release()
		self._manager = nil
	end
end

---创建下载路径
function UpdateChecker:createDownloadDir()
	local fileUtils = cc.FileUtils:getInstance()
  	local path = self:getDownloadDir().."res/"
	if fileUtils:isDirectoryExist(path) == false then 
   		fileUtils:createDirectory(path)
	end
end

---返回下载路径
function UpdateChecker:getDownloadDir()
	return cc.FileUtils:getInstance():getWritablePath()--.."update/"
end

--更新发生了错误
function UpdateChecker:onUpdateError( errorCode )
	local str = ""
	if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
		  str = res.str.UPDATE_DEC1
	elseif errorCode == cc.ASSETSMANAGER_NETWORK then
		  str = res.str.UPDATE_DEC2
	elseif errorCode == cc.ASSETSMANAGER_UNCOMPRESS then 
		  str = res.str.UPDATE_DEC3
	elseif errorCode == 4 then 
		  str = res.str.UPDATE_DEC3
	end

	--都当网络不好吧
	self._view:setWordMiddle("")
	local data = {}
	data.richtext = res.str.UPDATE_DEC2
	data.sure = function()
			self._view:startChecking()
	end
	data.surestr = res.str.SURE
	mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
end

--更新进度
function UpdateChecker:onUpdateProgress(percent)
	--self._view:setUpdateLoadingPercent(percent)
	self.size = 0
	local size = self._updateList[self._currentPkgIndex].pkgtotal
	for i = 1 , self._currentPkgIndex -1  do  --i,v in ipairs(self._updateList or {}) do 
		self.size =  self.size + self._updateList[i].pkgtotal/1024
	end
	local str = string.format("%.1f",self.size+size*percent/100/1024 )
	local maxsize = string.format("%.1f",self._totalPkgSize/1024)

	local per = (self.size+size*percent/100/1024) / (self._totalPkgSize/1024) * 100
	
	if per>98 then 
		per = 98
		--str = string.format("%.1f", self._totalPkgSize/1024*0.98 ) .."M"
	end
	local s = string.format(res.str.DEC_ERR_27,maxsize,per)
	self._view:updateIng(s)
	--per = string.format("%.01f",per)
	--self.dec = res.str.DEC_ERR_27..maxsize
	--self._view:updateIng(self.dec.."("..per.."%)")	
	--print(res.str.DEC_ERR_27..str.."/"..maxsize)
end


function UpdateChecker:restartGame()
		
	if version_json_data.is_update ~= nil and version_json_data.restart ~= nil then
		self._view:restartCheck()
		return 
	end 

	--自身清理
	self:release()
	--清理效果资源
    mgr.BoneLoad:removeAllArmature()
	---清理已加载的lua
	for key, value in pairs(package.loaded) do
			local paths = string.split(key, ".")
			if paths[1] == "res" or paths[1] == "game" or paths[1] == "config" or paths[1] == "message" then
					package.loaded[key] = nil
			end
	end
	for key, value in pairs(package.preload) do
	    local paths = string.split(key, ".")
	    if paths[1] == "res" or paths[1] == "game" or paths[1] == "config" or paths[1] == "message" then
					package.preload[key] = nil
			end
	end
	--清理所有的缓存
	cc.Director:getInstance():getTextureCache():removeAllTextures()
	--初始化lua
	require("game.init")
    require("message.init") 
    require("game.sdk.init")--SDK
	--重新启动游戏进入登陆界面
	 mgr.SceneMgr:updateEnterScene()
end

--更新完成
function UpdateChecker:onUpdateSuccess()
	self:reloadVersionModule() --每个版本完成后 重新加载刚刚更新的version 
	print("当前版本...", self:getLocalVersion())
	if tonumber(self._serverVersion.pkg_version) == tonumber(self:getLocalVersion()) then 
		local a1 = cc.CallFunc:create(function( ... )
			-- body
			local maxsize = string.format("%.1f",self._totalPkgSize/1024)
			local s = string.format(res.str.DEC_ERR_27,maxsize,100)
			self._view:updateIng(s)
		end)

		local a2 = cc.DelayTime:create(1.0)

		local a3 = cc.CallFunc:create(function()
			-- body
			self:restartGame()
		end)

		local action = cc.Sequence:create(a1,a2,a3)
		self._view:runAction(action)
		
	else
		self._currentPkgIndex = self._currentPkgIndex + 1
		self:doUpdate()
	end
end

function UpdateChecker:onAllCompleted()
	self:restartGame()
	--self._view:updateComplete()
end

--下载更新文件
function UpdateChecker:downPackage( url_ )
	if url_ ==nil or string.len(url_) == 0 then 
	   self:onUpdateError(4) --其中一个提示错误
	end
  	self._manager:setPackageUrl(url_)
  	self._manager:setVersionFileUrl(url_)
  	self._manager:update()
end

--开始更新
function UpdateChecker:doUpdate()
	--界面上一些文字显示
	--self._view:setUpdateLoadingPercent(0)
	self._view:showUpdateView()
	local current_data = self._updateList[self._currentPkgIndex]
	local updateUrl = self:getUpdateUrl(current_data)
	--self:downPackage(current_data.pkgurl) --下载这个文件
	print("======================================"..updateUrl)
	self:downPackage(updateUrl)
end

--计算那些更新 可能有几个版本 
function UpdateChecker:calculateUpdateList( data_ )
	table.insert(self._updateList,1,data_) --把当前需要更新先加入 更新下载列表

	self.curidx = #self._updateList
	if #self._updateList == 1 then 
		self.maxidx = data_.last_version - self:getLocalVersion() 
	end
	self.curidx = #self._updateList
	--print(self.curidx)
	
	if self.maxidx > 3 then 
		self._view:setWordMiddle(res.str.UPDATE_DEC12,"("..self.curidx.."/"..self.maxidx..")")
	end

	if tonumber(self:getLocalVersion()) == tonumber(data_.last_version) then --添加完成 计算所有包的大小
		self._totalPkgSize = 0  -- 几个包
		self._currentPkgIndex = 1
		for i,v in ipairs(self._updateList or {}) do 
			self._totalPkgSize = self._totalPkgSize + v.pkgtotal
		end
		--self._view:setWordMiddle(res.str.UPDATE_DEC10)
		if self._totalPkgSize <= 10240 then
			self:doUpdate()
		else
			local size_ = math.ceil(self._totalPkgSize/1024)
			local data = {}
			data.richtext = string.format(res.str.DEC_ERR_26,size_)  --"更新包"..size_.."M,更新后可领取大礼包哟，是否确认下载？"
			data.surestr = res.str.SURE
			data.sure = function()
				self:doUpdate()
			end
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		end	
	else
		self:continueGetVersion(data_.last_version)
	end
end

--更新之后是否重启
function UpdateChecker:setGameRestart(restart_)
	if restart_ ~= nil then
    	version_json_data.restart = restart_
    end
end

--请求服务器，获取版本数据
function UpdateChecker:continueGetVersion( version )
	local request = cc.XMLHttpRequest:new()  
	local function callback()
		if request.readyState == 4 and (request.status >= 200 and request.status < 207) then
	     	local data = json.decode(request.response,1)
	     	if not  data then 
	     		debugprint("version 里面什么都没")
	     		return
	     	end 
	     	self:setGameRestart(data.restart)  --设置是否需要重启
	     	self:calculateUpdateList(data)   
	    else
		    self._view:setWordMiddle("")
		    local data = {}
			data.richtext = res.str.UPDATE_DEC2
			data.sure = function()
				self._view:startChecking()
			end
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
	    end
	end
	local check_version_url_format = self:getServerName()..self:getPlatform().."/v%s/version.txt"
	local url = string.format(check_version_url_format,version)
	request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	request:open("GET",url)
	request:registerScriptHandler(callback)
	request:send()
end

function UpdateChecker:reset()
	self._updateList = {} --需要更新的大小
    self._totalPkgSize = 0 --大小
    self._currentPkgIndex = 1 --当前第几个
    self._serverVersion = nil 
end

--开始检测更新的入口
function UpdateChecker:checkCurrentServerVersion() 
	if not debug_unzip then --
		MyUserDefault:setProjectVersion(user_default_keys.KEY_OF_APPVERSION,gameCommonTool:getProjectVersion())
 	end

	self:reset()
	local request = cc.XMLHttpRequest:new()
	local function callback()
		if request.readyState == 4 and (request.status >= 200 and request.status < 207) then
				local data = json.decode(request.response,1)
				if not data then 
					debugprint("虽然返回了,但是version 配置错了")
					return 
				end

						-- if tostring(data.apk_version) ~= tostring(gameCommonTool:getProjectVersion()) then  --c++代码版本不一致
				  --       --提示打开助手去下载新的界面
				  --       -- self._view:setWordMiddle("")
				  --       -- local data = {}
				  --       -- data.richtext = res.str.UPDATE_DEC8
				  --      	-- data.surestr = res.str.SURE
				  --      	-- data.sure = function(url_)
				  --      	-- 		cc.Application:getInstance():openURL(url_ or "http://www.baidu.com")
				  --      	-- end
				  --      	-- mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
				  --       -- return
				  --       local list = string.split(data.apk_version, ".")
	  			-- 			local v__ = list[1]..list[2]..list[3]
				  --       local info = {
				  --       		apkurl = UpdateVersion.server_url.."channel"..g_var.channel_id.."/jjsmbl"..v__..".apk"
				  --     	}
				  --       game.GameSdkHelper:getInstance():extFunc(1099,json.encode(info))
				  --       return
				  --   end
		    local server_version = data.pkg_version  --
		    self._serverVersion = data 
		    self:setGameRestart(data.restart)
		    if tonumber(server_version) == tonumber(self:getLocalVersion()) then--版本一致
		    	self:onAllCompleted()
		    else
		     	version_json_data.is_update = true --说明更新了
		     	self:calculateUpdateList(data) --从返回的数据里面收集 信息 比较大小 和还没有没其他包更新
		    end  

		else
			self._view:setWordMiddle("")
			local data = {}
			data.richtext = res.str.UPDATE_DEC2
			data.sure = function()
					self._view:startChecking()
			end
			data.surestr = res.str.UPDATE_DEC9
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		end
	end
	request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
  	local check_current_version_url =self:getServerName()..self:getPlatform().."/version.txt"
  	request:open("GET", check_current_version_url)
 	request:registerScriptHandler(callback)
  	request:send()
end 



function UpdateChecker:makeVisibleVersionCode(proj_version,package_version)
  return proj_version.."."..package_version
end

---version 配置的
function UpdateChecker:getServerName()
	-- body
	return require("src.version").server_url
end

function UpdateChecker:getPlatform()
	-- body
	return require("src.version").platform
end

function UpdateChecker:getLocalVersion()
	-- body
	return require("src.version").pkg_version
end

function UpdateChecker:getLocalVersionObj()
	-- body
	return require("src.version")
end

function UpdateChecker:getUpdateUrl(data)
	local url = UpdateVersion.server_url..UpdateVersion.platform.."/v"..data.pkg_version.."/update.zip"
	return url
end

function UpdateChecker:getLocalProjVersion()
 	return MyUserDefault:getProjectVersion(user_default_keys.KEY_OF_APPVERSION)
end

--重新加载新的version.lua --
function UpdateChecker:reloadVersionModule()
  	package.loaded["src.version"] = nil
end

return UpdateChecker