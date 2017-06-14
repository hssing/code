local RoleView=class("RoleView",base.BaseView)



function RoleView:init()
	self.NowExp =5  --当前经验值
	self.lv=4
	self.exp=20
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	local panelsize=3
	for i=1,panelsize do
		self["Panel_"..i]=self.view:getChildByTag(1):getChildByTag(i)		
	end
	self:initPanel1()
	self:initPanel2()
	self:initPanel3()

	self.btn_set=self.view:getChildByTag(1):getChildByTag(1001)--设置按钮
	self.btn_set:addTouchEventListener(handler(self,self.onSetCallBack))

	self.btn_sure=self.view:getChildByTag(1):getChildByTag(1002)--确定按钮

	self.btn_sure:addTouchEventListener(handler(self,self.onSureCallBack))
	self.btn_notice=self.view:getChildByTag(1):getChildByTag(1003)--公告按钮
	self.btn_notice:addTouchEventListener(handler(self, self.onbtnSysGonggao))


	self.titlePanel = self["Panel_1"]:getChildByName("Panel_4")------称号
	self.titlePanel:addTouchEventListener(handler(self,self.onChangeTitle))
	self.title = self.titlePanel:getChildByName("Image_1")

	self.btnTitle = self.titlePanel:getChildByName("Button_title")
	self.btnTitle:addTouchEventListener(handler(self,self.onChangeTitle)) 

	self:updateUi()

	self:schedule(self.changeTimes,1.0,"changeTimes")
	
    G_FitScreen(self, "Image_5")
    
    proxy.Radio:send101009()

    if res.banshu then 
    	self.titlePanel:setVisible(false) 
    	self["Panel_3"]:setVisible(false)
    end

    --显示红包
    local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
	if view then
		view:setRedBagVisible(true)
	end 

	self:initDec()
end

function RoleView:initDec()
	-- body
	local Image_bg =self.view:getChildByName("Image_bg")
	local panle1 = Image_bg:getChildByName("Panel_1") 
	panle1:getChildByName("Button_c"):setTitleText(res.str.ROLE_DEC_01)
	
	local panle2 = Image_bg:getChildByName("Panel_2"):getChildByName("Image_down_bg")
	panle2:getChildByName("Panel_4_0"):getChildByName("Text_Title_26"):setString(res.str.ROLE_DEC_02)
	panle2:getChildByName("Panel_4_0"):getChildByName("Text_next_t_30"):setString(res.str.ROLE_DEC_03)
	panle2:getChildByName("Panel_4_0"):getChildByName("Text_all_t_32"):setString(res.str.ROLE_DEC_04)

	panle2:getChildByName("Panel_4_0_1"):getChildByName("Text_Title_26_14"):setString(res.str.ROLE_DEC_05)
	panle2:getChildByName("Panel_4_0_1"):getChildByName("Text_next_t_30_18"):setString(res.str.ROLE_DEC_03)
	panle2:getChildByName("Panel_4_0_1"):getChildByName("Text_all_t_32_20"):setString(res.str.ROLE_DEC_04)

	panle2:getChildByName("Panel_4_0_0"):getChildByName("Text_Title_26_2"):setString(res.str.ROLE_DEC_06)
	panle2:getChildByName("Panel_4_0_0"):getChildByName("Text_next_t_30_6"):setString(res.str.ROLE_DEC_03)
	panle2:getChildByName("Panel_4_0_0"):getChildByName("Text_all_t_32_8"):setString(res.str.ROLE_DEC_04)

	Image_bg:getChildByName("Panel_3"):getChildByName("Button_3"):setTitleText(res.str.ROLE_DEC_07)

	Image_bg:getChildByName("Button_set"):setTitleText(res.str.ROLE_DEC_08)
	Image_bg:getChildByName("Button_sure"):setTitleText(res.str.ROLE_DEC_09)
	Image_bg:getChildByName("Button_notice"):setTitleText(res.str.ROLE_DEC_10)
end

function RoleView:changeTitle( )
	local id = cache.Player:getRoleTitle()
	--id = 302004
	if id and id ~= 0 then
		self.title:setVisible(true)
		self.titlePanel:setTouchEnabled(true)
		self.title:loadTexture(conf.Title:getIcon(id))
		local x = self.titlePanel:getContentSize().width - self.btnTitle:getContentSize().width / 2
		local y = self.titlePanel:getContentSize().height / 2
		self.btnTitle:setPosition(x,y)
	else
		self.titlePanel:setTouchEnabled(false)
		self.title:setVisible(false)
		self.btnTitle:setPosition(self.titlePanel:getContentSize().width / 2,self.titlePanel:getContentSize().height / 2)
	end

end


--称号
function RoleView:onChangeTitle( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--mgr.ViewMgr:showView(_viewname.TITLE)
		proxy.Title:reqTitle()
	end
end



function RoleView:onbtnSysGonggao(send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		mgr.ViewMgr:showView(_viewname.SYS_GONGGAO):setData()
	end
end

--
function RoleView:onSureCallBack(send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--self:onCloseSelfView()
		--等级限制
		local lv = cache.Player:getLevel()
		if lv < res.kai.strategy then 
			G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,res.kai.strategy ))
			return
		end

		 local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:closeHeadView()
        --mgr.ViewMgr:closeView(_viewname.MAIN)
        local view =  mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
        if view then
        	view:setVisible(false)
        end

       --mgr.ViewMgr:closeView(_viewname.MAIN_TOP_LAYER)
    end 

		mgr.ViewMgr:showView(_viewname.STRATEGY)
		self:closeSelfView()
	end
end
function RoleView:onSetCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		debugprint("设置按钮")
		--跳转到设置界面
		self:onHide()
		mgr.ViewMgr:showView("settings.SettingsView")
	end
end
--人物要战斗力 变框
function RoleView:setRoleFrame()
	-- body
	local curpower = cache.Player:getPower()
	local path = res.btn.ROLE_FRAME[1]
	--测试使用 用完注释
	--curpower = 140000
	--print("coming")
	if curpower<5000 then --绿
		path = res.btn.ROLE_FRAME[1]
	elseif curpower<15000 then --蓝
		path = res.btn.ROLE_FRAME[2]
	elseif curpower< 50000 then --紫
		path = res.btn.ROLE_FRAME[3]
	elseif curpower< 150000 then 
		path = res.btn.ROLE_FRAME[4]
	else
		path = res.btn.ROLE_FRAME[5]
	end

	self.btn_head:loadTextureNormal(path)
end

function RoleView:initPanel1(  )
	  --等级
	self.Label_lv=self.Panel_1:getChildByTableTag(1,1)
	 --经验值
	self.Label_exp =self.Panel_1:getChildByTableTag(3,1)
	self.Label_exp:enableOutline(cc.c4b(0,0,0,255),2)
	--经验值进度条
	self.LoadingBar_exp=self.Panel_1:getChildByTableTag(3,2)
	--战斗力
	self.Lable_Fight=self.Panel_1:getChildByTableTag(2,1)
	--vip
	self.Lable_vip=self.Panel_1:getChildByTableTag(4,1)
	--人物名字
	self.Lable_name=self.Panel_1:getChildByName("bg_figure_name"):getChildByName("Text")
	--头像按钮
	self.btn_head=self.Panel_1:getChildByTag(129)
	self.btn_head:addTouchEventListener(handler(self,self.onHeadCallBack))
	--头像
	self.sprite_head=self.btn_head:getChildByName("Sprite")
	self.sprite_head:setScaleX(0.81)
	self.sprite_head:setScaleY(0.85)
	local function goTochongzhi( send,eventype )
		-- body
		if eventype == ccui.TouchEventType.ended then
			--[[if g_recharge then 
				G_TipsOfstr(res.str.ROLE_GONGHUI)
				return 
			end ]]--

			G_GoReCharge()
			self:onCloseSelfView()
		end
	end

	--充值
	local btn =self.Panel_1:getChildByName("Button_c")
	btn:addTouchEventListener(goTochongzhi)

	if res.banshu then
		btn:setVisible(false)
	end 

	self.LoadingBar_exp:setPercent(0)
end
function RoleView:updateUi(  )
	self:updateData(cache.Player:getRoleInfo())
	self:updateFortuneData(cache.Fortune:getFortuneInfo())
end
function RoleView:initPanel2(  )
	--钻石
	self.Lable_zs=self.Panel_2:getChildByTableTag(1,1,1)
	--金币
	self.Lable_gold=self.Panel_2:getChildByTableTag(1,2,2)
	--徽章
	self.Lable_badge=self.Panel_2:getChildByTableTag(1,3,3)

	--竞技场次数
	self.Lable_spritenum=self.Panel_2:getChildByTableTag(2,1,1)
	--竞技场一点恢复time
	self.Lable_sprite_nexttime=self.Panel_2:getChildByTableTag(2,1,2)
	--竞技场全部恢复time
	self.Lable_sprite_alltime=self.Panel_2:getChildByTableTag(2,1,3)

	--探险次数
	self.Lable_explorenum=self.Panel_2:getChildByTableTag(2,3,1)
	--探险下一点恢复time
	self.Lable_explore_nexttime=self.Panel_2:getChildByTableTag(2,3,2)
	--探险全部恢复time
	self.Lable_explore_alltime=self.Panel_2:getChildByTableTag(2,3,3)

	--体力次数
	self.Lable_hpnum=self.Panel_2:getChildByTableTag(2,2,1)
	--体力次数下一点恢复time
	self.Lable_hp_nexttime=self.Panel_2:getChildByTableTag(2,2,2)
	--体力次数全部恢复time
	self.Lable_hp_alltime=self.Panel_2:getChildByTableTag(2,2,3)

end
function RoleView:initPanel3(  )
	--进入公会
	self.Button_getinto=self.Panel_3:getChildByName("Button_3")
	self.Button_getinto:addTouchEventListener(handler(self,self.onBtnHonghuiCallBack))



	if res.banshu then 
		self.Button_getinto:setVisible(false)
	end 
end

function RoleView:onBtnHonghuiCallBack( send,eventype  )
		if eventype == ccui.TouchEventType.ended then
				--有公会请求公会信息
			proxy.guild:sendGuilmsg()
			  --
			self:onCloseSelfView()
		end
end

--更改头像框
function RoleView:setHead( id ,sex)
	--print("id ="..id)

	-- id = id~=0 and id or sex
	-- local framePath=mgr.PathMgr.getImageHeadPath(mgr.ConfMgr.getHeadSrc(id)
		--dump(id)

	self.sprite_head:setTexture(G_GetHeadIcon(id))

	--[[
	id = id~=0 and id or sex
	--local framePath=mgr.PathMgr.getImageHeadPath(mgr.ConfMgr.getHeadSrc(id))

	--self.sprite_head:setTexture(framePath)
	local path = sex == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	self.sprite_head:setTexture(path)

	
=======
	--self.sprite_head:setTexture("res/views/ui_res/icon/head_icon_1.png")]]--
end
--设置竞技场
function RoleView:setArean()
	-- body
	local count = cache.Player:getAthleticsCout()
	local maxcount = cache.Player:getMaxAthleticsMax()

	self.Lable_spritenum:setString(count.."/"..maxcount)
end
--设置探险
function RoleView:setAdv()
	-- body
	local count = cache.Player:getAdventCount()
	local maxcount = cache.Player:getAdventMaxCount()
	self.Lable_explorenum:setString(count.."/"..maxcount)
end
function RoleView:setTilihui(  )
	-- body
	local count = cache.Player:getTili()
	local maxcount = cache.Player:getMaxtli()
	self.Lable_hpnum:setString(count.."/"..maxcount)
end

--数据设置
function RoleView:updateData( data )
	self.data=data
	self:setLv(data.roleLevel)
	self:seVip(data.vip)
	self:setFight(data.power)
	self:setExp(data.roleExp)
	self:setName(data.roleName)
	self:setHead(data.vipIcon,data.sex)
	self:setRoleFrame()
	self:changeTitle()

	if self.data.guildId.key ~= "0_0" then 
		local lab_name = self.Panel_3:getChildByName("Panel_5"):getChildByName("text_guild_name") 
		lab_name:setString(self.data.guildName)

		self.Button_getinto:setVisible(false)
	else

		self.Button_getinto:setVisible(true)
	end 


	self.Lable_hp_nexttime:setString(string.formatNumberToTimeString(0))
	self.Lable_sprite_nexttime:setString(string.formatNumberToTimeString(0))
	self.Lable_explore_nexttime:setString(string.formatNumberToTimeString(0))

	self.Lable_sprite_alltime:setString(string.formatNumberToTimeString(0))
	self.Lable_explore_alltime:setString(string.formatNumberToTimeString(0))
	self.Lable_hp_alltime:setString(string.formatNumberToTimeString(0))


	local function _sethuifu( data )
		-- body
		local cout = data.cout
		local max = data.max

		local time = (max - cout - 1 )* data.resetTime
		if data.lastRettime == 0 then 
			time = time + data.resetTime
		else
			time = time + data.lastRettime
		end 
		if time <= 0 then 
			return 
		end  
		debugprint("time = "..time.." ,"..os.time())

		local temp = os.date("*t", os.time()+time) 
		local strtime = string.format("%02d",temp.hour)..":"..
			string.format("%02d",temp.min)..":"..string.format("%02d",temp.sec)

		if  data.tili then 
			self.Lable_hp_alltime:setString(strtime)
		elseif data.adv then 
			self.Lable_explore_alltime:setString(strtime)
		elseif data.arean then 
			self.Lable_sprite_alltime:setString(strtime)
		end 
	end

   
	local data ={}
	data.recodtiem = cache.Player:getRecordtime()
	data.resetTime = cache.Player:getTiliTimesReset()
	data.lastRettime =  cache.Player:getTiliTimes()
	data.tili = true 

	data.max = cache.Player:getMaxtli()
	data.cout = cache.Player:getTili()

	_sethuifu(data)
	--_fulltime(data)
	--探险
	data ={}
	data.recodtiem = cache.Player:getAdvrecordTime()
	data.resetTime = cache.Player:getAdventresetTime()
	data.lastRettime =  cache.Player:getAdventTime()
	data.adv = true 
	

	data.max = cache.Player:getAdventMaxCount()
	data.cout = cache.Player:getAdventCount() 

	_sethuifu(data)
	--_fulltime(data)

	--竞技场
	data ={}
	data.recodtiem = cache.Player:getRearean()
	data.resetTime = cache.Player:getAthleticsTimerest()
	data.lastRettime =  cache.Player:getAthleticsLastTime()
	data.arean = true 
	
	data.max = cache.Player:getMaxAthleticsMax()
	data.cout = cache.Player:getAthleticsCout()
	_sethuifu(data)
	--_fulltime(data)

	self:setArean()
	self:setAdv()
	self:setTilihui()
end
--货币更新
function RoleView:updateFortuneData( data )
 		--self.FortuneData=data
 		self:setZs(data.moneyZs)
 		self:setGold(data.moneyJb)
 		self:setBadge(data.moneyHz)
 end
 --头像选择
function RoleView:onHeadCallBack( send,eventtype )
	if eventtype ==ccui.TouchEventType.ended then
		--print(conf.head:getHeadIcon(1))
		proxy.Title:reqHeadIcon()
		--mgr.ViewMgr:showView(_viewname.SELECT_HEAD)
	end
	-- body
end

--
function RoleView:setZs( zs )
	self.Lable_zs:setString(zs)
end

function RoleView:setGold( gl )
	self.Lable_gold:setString(gl)
end

function RoleView:setBadge( db )
	self.Lable_badge:setString(db)
end


--设置等级
function RoleView:setLv(lv)
	self.lv=lv
	self.Label_lv:setString(lv)
end

--设置VIP
function RoleView:seVip(vip)
	self.Lable_vip:setString(vip)
end

--设置战斗力
function RoleView:setFight(Fight)
	self.Lable_Fight:setString(Fight)
end
function RoleView:setName( name )
	-- body
	self.Lable_name:setFontName(display.DEFAULT_TTF_FONT)
	self.Lable_name:setString(name)
end



--设置经验
function RoleView:setExp(exp)
	self.NowExp=exp

	local max_exp= conf.Role:getExp(self.lv)
	if not max_exp then
		debugprint("配置表 没有这个等级 = "..self.lv)
		return 
	end
	if exp >= max_exp then
		debugprint("数据异常")
		self.NowExp = max_exp 
		self.LoadingBar_exp:setPercent(100)
		self.Label_exp:setString(self.NowExp.."/".."???")
		return 
	end
	local Percent = self.NowExp / max_exp

	self.LoadingBar_exp:setPercent(Percent*100)

	self.Label_exp:setString(self.NowExp.."/"..max_exp)
end

function RoleView:onCloseSelfView(  )
	-- body
	----------显示聊天按钮
	local  layer = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	local mainView = mgr.ViewMgr:get(_viewname.MAIN)
	if layer and mainView then
		layer.btnChat:setVisible(true)
	end

	 --显示红包
    local view = mgr.ViewMgr:get(_viewname.CHATTING)
    local view2 = mgr.ViewMgr:get(_viewname.HORNTIPS)
	if view and view2 then
		view2:setRedBagVisible(false)
	end 

	self:closeSelfView()
end

function RoleView:changeTimes()
	-- body
	--体力
	self:setArean()
	self:setAdv()
	self:setTilihui()

	local lastRettime = cache.Player:getTiliTimes()
	if lastRettime == cache.Player:getTiliTimesReset() then 
		lastRettime = 0
	end 
	self.Lable_hp_nexttime:setString(string.formatNumberToTimeString(lastRettime))

	lastRettime = cache.Player:getAdventTime()
	if lastRettime == cache.Player:getAdventresetTime() then 
		lastRettime = 0
	end 
	self.Lable_explore_nexttime:setString(string.formatNumberToTimeString(lastRettime))
	

	lastRettime = cache.Player:getAthleticsLastTime()
	if lastRettime == cache.Player:getAthleticsTimerest() then 
		lastRettime = 0
	end 
	self.Lable_sprite_nexttime:setString(string.formatNumberToTimeString(lastRettime))
	


	--[[local data ={}
	data.recodtiem = cache.Player:getRecordtime()
	data.resetTime = cache.Player:getTiliTimesReset()
	data.lastRettime = cache.Player:getTiliTimes()
	--print("data.体力 ."..data.lastRettime)
	data.maxti = cache.Player:getMaxtli()
	data.count = cache.Player:getTili()
	data.tili = true 
	self:changtiemsBytable(data)

	--探险
	data ={}
	data.recodtiem = cache.Player:getAdvrecordTime()
	data.resetTime = cache.Player:getAdventresetTime()
	data.lastRettime = cache.Player:getAdventTime()
	--print("data.探险 ."..data.lastRettime)
	data.maxti = cache.Player:getAdventMaxCount()
	data.count = cache.Player:getAdventCount()
	data.adv = true 
	self:changtiemsBytable(data)
 
	--竞技场
	data ={}
	data.recodtiem = cache.Player:getRearean()
	data.resetTime = cache.Player:getAthleticsTimerest()
	data.lastRettime = cache.Player:getAthleticsLastTime()

	--print("data.竞技场 ."..data.lastRettime)

	data.maxti = cache.Player:getMaxAthleticsMax()
	data.count = cache.Player:getAthleticsCout()
	data.arean = true 
	self:changtiemsBytable(data)]]--

end


function RoleView:changeHeadSucc( hId )
	--local id = cache.Player:getRoleSex() * 100000 + hId
	--self.sprite_head:setTexture(G_GetHeadIcon(id))

	local id = cache.Player:getRoleSex() .. string.format("%02d",hId) 
	self.sprite_head:setTexture("res/head/"..id..".png")
end




return RoleView
