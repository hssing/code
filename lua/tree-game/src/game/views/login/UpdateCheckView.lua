--[[
	热更新测试
]]
local _updater = require("game.utils.UpdateChecker")
local gameCommonTool = require("game.utils.GameCommonTool.GameCommonTool")
local UpdateCheckView=class("UpdateCheckView",base.BaseView)

local words = {
	version_checking = "正在与数码世界建立连接",
	unzip_package = "准备资料包中,不需要流量哦！",
	is_top_version = "已是最新版本",
	local_version = "当前的版本号:%s",
	server_version = "服务器版本号:%s",
	game_init = "游戏初始化,加载不需要流量哦！",	
	update_error = "您的网络不给力，请重试。",
	new_package_size = "%sMB",
	new_package_1 = "主人，有",
	new_package_2 = "更新包，取消将退出游戏哦~",
	package_progress = "%s/%s",
	update_progress = "进度:%s%%",

	proj_version_too_old = "主人，你的游戏版本太旧咯,请到助手获取最新版本。",

	new_package_content = "主人,有%sMB更新包,取消将退出游戏哦",
	restart_game_content = "请点击屏幕重启后继续游戏",
}

function UpdateCheckView:ctor()
		self._panelError = nil
		self._error_txtError = nil
		self._error_btnRetry = nil
		self._panelUpdate = nil
		self._update_txtInfo = nil --更新信息文本框
		self._update_txtLocalVersion = nil --本地版本号文本框
		self._update_txtServerVersion= nil --服务器版本号文本框
		self._update_barLoading = nil			 --更新进度条
		self._update_txtProgress = nil		--一共有多少个包
		self._panelComfirm = nil
		self._confirm_panelInfo = nil 	--信息面板
		self._confirm_btnUpdate = nil		--更新按钮
		self._confirm_btnCancel = nil		--取消按钮
		self._updater = nil
end

function UpdateCheckView:init()
		self.showtype=view_show_type.TOP
		self.view=self:addSelfView()
		--提示背景
		self.bg_tishi = self.view:getChildByName("Image_3")
		self._panelUpdate = self.view:getChildByName("Panel_1_0_0")
		self:initUpdatePanel()

		self:registerScriptHandler(handler(self,self.eventHandler))
		--更新检测工具
		self._updater = _updater.new(self)

		G_FitScreen(self, "Image_1")
end 

function UpdateCheckView:eventHandler(event_)
		if event_ == "enter" then 
				self:startChecking()
		elseif event_ == "exit" then 
				if self._updater ~= nil then 
						self._updater:release()
						self._updater = nil
				end
		end
end

--在提示框 里面只显示 检测更新  或者 更新结束，正在加载
function UpdateCheckView:setWordMiddle(txt,txt2)
		self._panelUpdate:setVisible(true)
		if res.str.UPDATE_DEC12~= txt and  self._lab then
			self._lab:removeFromParent()
			self._lab = nil 
		end 

		if not self.lab_middel then 
			-- 创建一个居中对齐的文字显示对象
				self.lab_middel = display.newTTFLabel({
				    text = "",
				    font = res.ttf[1],
				    size = 30,
				    x = self.bg_tishi:getContentSize().width/2,
				    y = self.bg_tishi:getContentSize().height/2, 
				    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
				})
				self.lab_middel:addTo(self.bg_tishi)
		end 
		self.lab_middel:setVisible(true)
		self.lab_middel:setString(txt..(txt2 or ""))
end

--正在更新中 
function UpdateCheckView:updateIng( str )
	self:setUpdateInfoText(str)
	self.lab_middel:setVisible(false)
	--self._update_txtProgress:setString(res.str.UPDATE_DEC6)
end

function UpdateCheckView:showUpdateView( ... )
	self._panelUpdate:setVisible(true)
end

function UpdateCheckView:lab_action(str)
	-- body
	if not self._lab then 
		self._lab = self._update_txtProgress:clone()
		self._lab:setAnchorPoint(cc.p(0,0.5))
		self._lab:setString(str)
		self._lab:setPosition(self.bg_tishi:getContentSize().width/2+self.lab_middel:getContentSize().width/2
			+self._lab:getContentSize().width + 15
			, self.bg_tishi:getContentSize().height/2)
		self._lab:addTo(self.bg_tishi)


		local a1 = cc.CallFunc:create(function( ... )
			-- body
			self._lab:setVisible(false)
		end)

		local a2 = cc.CallFunc:create(function( ... )
			self._lab:setVisible(true)
		end)

		local a3 =  cc.DelayTime:create(0.5)

		local sequence = cc.Sequence:create(a1,a3,a2,a3)
		local r1 = cc.RepeatForever:create(sequence)
		self._lab:runAction(r1)
	end
end

--开始检查更新信息
--开始检查更新 -- --版本检查器 gameCommonTool
function UpdateCheckView:startChecking()
		local version  = MyUserDefault:getProjectVersion(user_default_keys.KEY_OF_APPVERSION) --当前版本	
		local function success_callback( flag )
				--self:setWordMiddle(words.version_checking) --版本检测中...
				self:setWordMiddle(res.str.UPDATE_DEC12) --版本检测中...
				self:lab_action(res.str.UPDATE_DEC11)
				--添加参数是否关闭检查更新 
				local _debug_check_version = true
				if(self._updater ~= nil) then
						self._updater:reloadVersionModule()--version.lua
						local obj = self._updater:getLocalVersionObj() -- version 对象
						if(obj.debug_check_version  and obj.debug_check_version == false) then
								_debug_check_version = false
						end 
				end 

				local _check_update = false
				if (nous.platform ~= platform_type.windows) then
						_check_update = true
				elseif g_win_update == true then 
						_check_update = true
				end

				--g_win_update 客户端 是否开启更新测试
				if _debug_check_version and _check_update then 
						self._updater:checkCurrentServerVersion()	
				else
				 		self:updateComplete()		
				end
		end
		if version ~= gameCommonTool:getProjectVersion() and debug_unzip then  --需要解压 c++版本的比较
				--预留做别东西
		else
			success_callback(true)
		end
end

--检测更新信息 或者是 正在更新
function UpdateCheckView:initUpdatePanel()
		self._update_txtInfo = self._panelUpdate:getChildByName("Text_9")
		self._update_txtLocalVersion = self._panelUpdate:getChildByName("Text_9_0")
		self._update_txtServerVersion= self._panelUpdate:getChildByName("Text_9_1")
		--self._update_barLoading = self._panelUpdate:getChildByName("LoadingBar_1")
		self._update_txtProgress = self._panelUpdate:getChildByName("Text_9_2")
end

---更新完成
function UpdateCheckView:updateComplete(server_version )
		self:setUpdateLocalVersion(server_version or "")
		self:setUpdateServerVersion(server_version or "")
		self:setUpdateInfoText(words.game_init)	
		self:setUpdateLoadingBarVisible(true)
		if version_json_data.is_update ~= nil and version_json_data.restart ~= nil then
				self:restartCheck()
		else
				self:doInitWork()
		end
end

function UpdateCheckView:doInitWork()
		cache:clear() --清除所有的缓存信息
		local initializer = require("initializer")

		initializer:initManagers()
		initializer:initAll()
		mgr.SceneMgr:getNowShowScene():createLoginView()	

		--[[local function callback4()
			local function callback()
					mgr.SceneMgr:getNowShowScene():createLoginView()
			end
			self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(callback)))
		end

		local function callback2()
				local function callback()
						self:stopAllActions()
						self:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(callback4)))
				end
				initializer:initAll()	
				--self:setUpdateLoadingPercent(100,callback)
		end

		local function callback1()
				local function callback()
					self:stopAllActions()
					self:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(callback2)))
				end
				initializer:initManagers()
				--self:setUpdateLoadingPercent(10,callback)
		end
		--self:setUpdateLoadingPercent(0)
		callback1()]]--
end

--退出游戏 
function UpdateCheckView:restartCheck()
		local function callback(sender,eventType)
				if eventType == ccui.TouchEventType.ended then 
						if device.platform == "android" then 
								cc.Director:getInstance():endToLua()
						else
								os.exit()
						end 
				end
		end
		local index 
		local function scheCallback()
				scheduler.unscheduleGlobal(index)
				local layer = ccui.Layout:create()
				layer:setContentSize(display.size)
				layer:setAnchorPoint(cc.p(0,0))
				layer:setPosition(cc.p(0,0))
				layer:setBackGroundColorType(1)
				layer:setBackGroundColor(cc.c3b(0,0,0))
				layer:setOpacity(220)
				layer:addTouchEventListener(callback)
				layer:setTouchEnabled(true)

				--[[local sprite = display.newSprite(res.image.BG[1])
				sprite:setPosition(display.cx,display.cy)
				layer:addChild(sprite,255)]]--

				local txt =ccui.Text:create()
				txt:setString(words.restart_game_content)
				txt:setFontSize(30)
				txt:setPosition(display.cx,display.cy)
				txt:addTo(layer,300)
				
				cc.Director:getInstance():getRunningScene():addChild(layer,255)
		end		
		index = scheduler.scheduleGlobal(scheCallback, 0)
end

function UpdateCheckView:setUpdateLoadingPercent( percent_,callback_,not_animation )
	percent_ = percent_ or 0
	if percent_ == 0 then 
		self._update_barLoading:setPercent(percent_)
		if callback_ then 
			callback_()
		end
	else
		self._update_barLoading:setPercent(percent_)
		if callback_ then 
				callback_()
		end 
		if not not_animation then 
				--G_runProgressBarAction(self._update_barLoading,percent_,0,0.5,callback_)
		end
	end
end

--更新
function UpdateCheckView:setUpdateProgress( cur_index,total_index )
		self._update_txtProgress:setString(cur_index.."/"..total_index)
end

function UpdateCheckView:setUpdateLocalVersion( text_ )
		self._update_txtLocalVersion:setString(text_)
end

function UpdateCheckView:setUpdateServerVersion( text_ )
		self._update_txtServerVersion:setString(text_)
end

function UpdateCheckView:setUpdateInfoProgressText( percent_ )
		self:setUpdateInfoText(percent_)
end

function UpdateCheckView:setUpdateInfoText( text_ )
	self._update_txtInfo:setString(text_ or "")
	if self._lab then 
		self._lab:setPosition(self.bg_tishi:getContentSize().width/2+self._update_txtInfo:getContentSize().width/2
		+self._lab:getContentSize().width /2
		, self.bg_tishi:getContentSize().height/2)
	end
end

function UpdateCheckView:setUpdateLoadingBarVisible(bVal_)
		--self._update_barLoading:setVisible(bVal_)
		--self._panelUpdate:getChildByName("Image_11"):setVisible(bVal_)
		--self._update_txtProgress:setVisible(bVal_)
end

function UpdateCheckView:setNewPackageInfo( size )
		local str =string.format(words.new_package_content,size)
		self._confirm_panelInfo:setString(str)
end

return UpdateCheckView

