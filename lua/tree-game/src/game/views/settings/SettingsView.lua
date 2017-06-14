--
-- Author: Your Name
-- Date: 2015-07-15 17:07:00
--
local SettingsView = class("SettingsView", base.BaseView)

function SettingsView:init(  )
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.panelBg = self.view:getChildByName("Panel_4")
	self.listView = self.panelBg:getChildByName("ListView_1")
	self.item1 = self.view:getChildByName("Panel_1")
	self.item2 = self.view:getChildByName("Panel_2")
	self.item3 = self.view:getChildByName("Panel_2_0")
	self.item4 = self.view:getChildByName("Panel_3")
	self.item5 = self.view:getChildByName("Panel_3_0")-----凤凰网SDK独有


	--界面 文字初始化
	self.item1:getChildByName("Text_1"):setString(res.str.SETTING_TEXT1) 
	self.item1:getChildByName("Text_21"):setString(res.str.SETTING_TEXT2) 
	self.item1:getChildByName("Text_20"):setString(res.str.SETTING_TEXT1) 
	self.item2:getChildByName("Text_1_0"):setString(res.str.SETTING_TEXT3) 
	self.item2:getChildByName("Text_26"):setString(res.str.SETTING_TEXT4) 
	self.item2:getChildByName("Text_24"):setString(res.str.SETTING_TEXT5) 
	self.item2:getChildByName("Button_switch"):getChildByName("Text_4_0"):setString(res.str.SETTING_TEXT6)

	self.item3:getChildByName("Text_1_0_3"):setString(res.str.SETTING_TEXT7)
	self.item3:getChildByName("Text_24_5"):setString(res.str.SETTING_TEXT8)


	local panel = self.item3:getChildByName("Panel_32")
	panel:getChildByName("Text_63"):setString(res.str.SETTING_TEXT12)
	panel:getChildByName("Text_64"):setString(res.str.SETTING_TEXT13)
	panel:getChildByName("Text_63_0"):setString(res.str.SETTING_TEXT14)
	panel:getChildByName("Text_64_0"):setString(res.str.SETTING_TEXT15)
	panel:getChildByName("Text_63_1"):setString(res.str.SETTING_TEXT16)
	panel:getChildByName("Text_64_1"):setString(res.str.SETTING_TEXT17)

	self.item4:getChildByName("Text_27"):setString(res.str.SETTING_TEXT9)
	self.item4:getChildByName("textField"):setPlaceHolder(res.str.SETTING_TEXT10)
	self.item4:getChildByName("Button_confirm"):getChildByName("Text_7"):setString(res.str.SETTING_TEXT11)

	self.item5:getChildByName("Button_confirm_2"):getChildByName("Text_7_6"):setString(res.str.SETTING_TEXT18)
	self.item5:getChildByName("Button_confirm_2_0"):getChildByName("Text_7_6_9"):setString(res.str.SETTING_TEXT19)




	self.item1:retain()
	self.item2:retain()
	self.item3:retain()
	self.item4:retain()

	self.item1:removeSelf()
	self.item2:removeSelf()
	self.item3:removeSelf()
	self.item4:removeSelf()

	self.listView:pushBackCustomItem(self.item1)
	self.listView:pushBackCustomItem(self.item2)
	self.listView:pushBackCustomItem(self.item3)
	self.listView:pushBackCustomItem(self.item4)

	self.item1:release()
	self.item2:release()
	self.item3:release()
	self.item4:release()

	
	-----凤凰网SDK独有
	if g_var.channel_id == "535" or g_var.channel_id == 535 then
		self.item5:retain()
		self.item5:removeSelf()
		self.listView:pushBackCustomItem(self.item5)
		self.item5:release()
	end

	--关闭果实界面
	local view = mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE_PAGE)
	if view then
		view:setVisible(false)
	end


	self:initItems()

end


function SettingsView:initItems(  )

	self.btnMusic = self.item1:getChildByName("Button_music")
	self.btnSound = self.item1:getChildByName("Button_sound")
	self.btnLock = self.item2:getChildByName("Button_lock")
	self.btnSwitch = self.item2:getChildByName("Button_switch")

	self.textAccount = self.item2:getChildByName("Panel_account"):getChildByName("text_acount")
	self.textField = self.item4:getChildByName("textField")
	self.btnConfirm = self.item4:getChildByName("Button_confirm")

	self.backImg = self.panelBg:getChildByName("Image_4")
	self.inputCodeBox=cc.ui.UIInput.new({
		 	UIInputType == 2,
		    image = res.image.TRANSPARENT,
		    x = self.textField:getPositionX(),
		    y = self.textField:getPositionY()+3,
		   -- listener = self.editBoxHandler,
		    size = cc.size(self.textField:getContentSize().width,self.textField:getContentSize().height + 5)
		})
	self.inputCodeBox:registerScriptEditBoxHandler(handler(self, self.editBoxHandler))
	self.item4:addChild(self.inputCodeBox)
	 self.inputCodeBox:setPlaceHolder(self.textField:getPlaceHolder())
	-- self.textField:setPlaceHolder("")
	self.textField:removeFromParent()

	--红包屏蔽按钮
	self.btnShowRedBag = self.item3:getChildByName("Button_lock_2")
	self.redbagState = 0
	

	--按钮点击事件绑定
	self.btnMusic:addTouchEventListener(handler(self,self.onBtnMusicClickUpCallback))
	self.btnSound:addTouchEventListener(handler(self,self.onBtnSoundClickUpCallback))
	self.btnLock:addTouchEventListener(handler(self,self.onBtnLockClickUpCallback))
	self.btnSwitch:addTouchEventListener(handler(self,self.onBtnSwitchClickUpCallback))
	self.btnConfirm:addTouchEventListener(handler(self,self.onBtnConfirmClickUpCallback))
	self.btnShowRedBag:addTouchEventListener(handler(self,self.onBtnShowRedBagCallback))

	-- 设置界面显示
	if mgr.Sound._isOpenMusic then
		--todo
		self.btnMusic:getChildByName("Text_2"):setString(res.str.HSUI_DESC13)
	else
		--todo
		self.btnMusic:getChildByName("Text_2"):setString(res.str.HSUI_DESC14)
		
	end

	if mgr.Sound._isOpenSound then
		--todo
		self.btnSound:getChildByName("Text_2_0"):setString(res.str.HSUI_DESC13)
	else
		--todo
		self.btnSound:getChildByName("Text_2_0"):setString(res.str.HSUI_DESC14)
	end

		--读取锁屏 配置
	self.lockKey = g_var.debug_accountId .. "_" .. user_default_keys.SCREEN_LOCK
	self.isLock = MyUserDefault.getIntegerForKey(self.lockKey)

	if self.isLock == nil or self.isLock == 0 or self.isLock == 1 then
		--todo
		self.isLock = 1

	else
		self.isLock = 2
	end

	self:screenLock()


	self:changeRedbagBtnTile(cache.Player:getShowRedbag())


	self.textAccount:setString(cache.Player:getName())
	self.textAccount:ignoreContentAdaptWithSize(true)

	G_FitScreen(self,"Image_1")


	if res.banshu then
		self:hideSys()
	end

	if g_var.channel_id == "535" or g_var.channel_id == 535 then
	-------凤凰网SDk独有
		self.centerBtn = self.item5:getChildByName("Button_confirm_2")
		self.backLoginBtn = self.item5:getChildByName("Button_confirm_2_0")

		self.centerBtn:addTouchEventListener(handler(self,self.centerBtnCallback))
		self.backLoginBtn:addTouchEventListener(handler(self,self.backLoginBtnCallback))
	end


end

-- 音乐控制按钮

function SettingsView:changMusicState(  )
	-- body
	if mgr.Sound._isOpenMusic then
		--todo
		self.btnMusic:getChildByName("Text_2"):setString(res.str.HSUI_DESC14)
		mgr.Sound:openMusic(false)
	else
		--todo
		self.btnMusic:getChildByName("Text_2"):setString(res.str.HSUI_DESC13)
		mgr.Sound:openMusic(true)
	end
end



function SettingsView:onBtnMusicClickUpCallback( sender,eventType )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		--todo
		self:changMusicState()

	end

end



-- 音效控制按钮
function SettingsView:changSoundState(  )
	-- body
	if mgr.Sound._isOpenSound then
		--todo
		self.btnSound:getChildByName("Text_2_0"):setString(res.str.HSUI_DESC14)
		mgr.Sound:openSound(false)
	else
		--todo
		self.btnSound:getChildByName("Text_2_0"):setString(res.str.HSUI_DESC13)
		mgr.Sound:openSound(true)
	end
end



function SettingsView:onBtnSoundClickUpCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		--todo
		self:changSoundState()
	end

end


function SettingsView:screenLock(  )
	-- body
	if self.isLock == 1 then
		--todo
		self.btnLock:getChildByName("Text_4"):setString(res.str.HSUI_DESC13)
	elseif self.isLock == 2 then
		self.btnLock:getChildByName("Text_4"):setString(res.str.HSUI_DESC14)
	end

end

-- 开启永不锁频按钮
function SettingsView:onBtnLockClickUpCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		self.isLock = (self.isLock) % 2 + 1
		self:screenLock()
		MyUserDefault.setIntegerForKey(self.lockKey,self.isLock)
		
		if self.isLock == 1 then
			--todo
			sdk:setWakeLock(1)

		else
			sdk:setWakeLock(0)
		end
		
	end

end

-- 切换账号按钮
function SettingsView:onBtnSwitchClickUpCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
			sdk:onSwitchAccount()
			--退出登录
      mgr.NetMgr:close()
			sdk:logout()		
	end
end

----凤凰网SDK  start

-- 个人中心
function SettingsView:centerBtnCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		sdk:userCenter()
	end
end

-- 退出游戏
function SettingsView:backLoginBtnCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
			--退出登录
		mgr.NetMgr:close()
     	G_RestGame() 
   		 mgr.SceneMgr:LoginSceneWithUpdateCheck(true,function()
      		sdk.loginFlag = 0
        --game.GameSdkHelper:getInstance():logout()   
   		 end)
	end
end

----凤凰网SDK end


-- 红包屏蔽
function SettingsView:onBtnShowRedBagCallback( sender,eventType )
	if eventType == ccui.TouchEventType.ended then
		self.redbagState = (self.redbagState + 1) % 2
		local key = g_var.debug_accountId .. "_" ..user_default_keys.REDBAG_SHOW
		if self.redbagState == 1 then--开启
			self:changeRedbagBtnTile(false)
			cache.Player:setShowRedBag(os.time() .. "")
			MyUserDefault.setStringForKey(key,os.time() .. "")
		else--关闭
			self:changeRedbagBtnTile(true)
			cache.Player:setShowRedBag("")
			MyUserDefault.setStringForKey(key,"")
		end
	end
end


function SettingsView:changeRedbagBtnTile( flag )
	--红包屏蔽
	if flag then
		self.btnShowRedBag:getChildByName("Text_6"):setString(res.str.HSUI_DESC15)
		self.redbagState = 0
	else
		self.btnShowRedBag:getChildByName("Text_6"):setString(res.str.HSUI_DESC16)
		self.redbagState = 1
	end
end



-- 礼包兑换
function SettingsView:onBtnConfirmClickUpCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		
		local giftCode = string.trim(self.inputCodeBox:getText())
		print(cache.Player:getAuth(),">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		if giftCode == "@gmf" and cache.Player:getAuth() > 0 then
		-- if giftCode == "@gmf" then
			g_var.fight_skip_bt = 1
			return
		end
		if giftCode == "@gm" then
			local view = mgr.ViewMgr:get(_viewname.DEBUG)
			if view then
				mgr.ViewMgr:closeView(_viewname.DEBUG)
				cc.Director:getInstance():setDisplayStats(false)
			else
				mgr.ViewMgr:showView(_viewname.DEBUG)
				cc.Director:getInstance():setDisplayStats(true)
			end
			return
		end


		if giftCode == "" then
			return
		end
	  
	  	print("============"..giftCode)
	  	if giftCode then
	  		proxy.GiftPackCode:reqGetGift(giftCode)
	  	end
	end

end

function SettingsView:hideSys( )
	-- body
	--self.panelBg:setPosition(self.panelBg:getPositionX(),self.panelBg:getPositionY() + self.item3:getContentSize().height )
	self.backImg:setContentSize(self.backImg:getContentSize().width,self.backImg:getContentSize().height -self.item4:getContentSize().height)
	self.backImg:setPosition(self.backImg:getPositionX(),self.backImg:getPositionY() +80)
	self.item4:removeFromParent()
end

function SettingsView:editBoxHandler(strEventName,inputBox )
	-- body
	if strEventName == "began" then
      -- self.inputCodeBox:setText(self.textField:getString())
      print("began")
    elseif strEventName == "changed" then
        -- 输入框内容发生变化
    elseif strEventName == "ended" then
        -- 输入结束
    elseif strEventName == "return" then
        -- 从输入框返回
       -- self.textField:setString(self.inputCodeBox:getText())
      --  self.inputCodeBox:setText("")

    end

	
end


function SettingsView:onCloseSelfView(  )
	self:closeSelfView()
	--关闭果实界面
	local view = mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE_PAGE)
	if view then
		view:setVisible(true)
	end

	mgr.ViewMgr:showView(_viewname.ROLE)
end

return SettingsView