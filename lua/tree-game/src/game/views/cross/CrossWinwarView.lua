---
--[[
	王者之战	
]]
--数据模拟
--[[local test_tab = {}
for i = 1 , 16 do 
	local p1 = { sname ="s207",pname = "维鹏傻吊"..i,win = i%2,zu = i}
	table.insert(test_tab,p1)
end]]--


local CrossWinwarView = class("CrossWinwarView",base.BaseView)

function CrossWinwarView:ctor()
	-- body
	self.player = {}
	self.xian = {}
	self.btnlist = {}

	self.request = 0 --倒计时为0的时候请求一次服务器信息
end

function CrossWinwarView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panel = self.view:getChildByName("Panel_1")
	local btnclose = panel:getChildByName("Button_15")
	btnclose:addTouchEventListener(handler(self, self.onbtnclose))
	--规则按钮
	local btnguize = panel:getChildByName("Button_15_0")
	btnguize:addTouchEventListener(handler(self,self.onbtnguze))
	--奖励
	local btnreward = panel:getChildByName("Button_15_1")
	btnreward:addTouchEventListener(handler(self,self.onbtnReward))
	--留言
	local btnword = panel:getChildByName("Button_15_0_0")
	btnword:setVisible(false)
	btnword:addTouchEventListener(handler(self,self.onbtnGetWord))
	---倒计时
	self.lab_dec = panel:getChildByName("Text_1")
	self.lab_time = panel:getChildByName("Text_1_0") 
	self.lab_dec_1 = panel:getChildByName("Text_1_1")
	----------------------------------------------------------------------------------------
	local panlemiddle = self.view:getChildByName("Panel_14") 
	for i = 1 , 16 do 
		local widget = panlemiddle:getChildByName("Img_player_"..i)
		widget.sever_name = widget:getChildByName("Text_3_"..i)
		widget.player_name = widget:getChildByName("Text_4_"..i)

		widget.sever_name:setFontName(display.DEFAULT_TTF_FONT)
		widget.sever_name:setPositionY(widget.sever_name:getPositionY())
		widget.sever_name:setFontSize(20)

		widget.player_name:setFontName(display.DEFAULT_TTF_FONT)
		widget.player_name:setFontSize(18)

		widget.sever_name:setString("")
		widget.player_name:setString("")
		table.insert(self.player,widget)

		local xian =  panlemiddle:getChildByName("Image_xian_16_"..i)
		if not self.xian[16] then
			self.xian[16] = {}
		end
		table.insert(self.xian[16],xian)
	end
	--8强竞猜按钮
	for i = 1 , 8 do
		local xian =  panlemiddle:getChildByName("Image_xian_8_"..i)
		if not self.xian[8] then
			self.xian[8] = {}
		end
		table.insert(self.xian[8],xian)

		local widget = panlemiddle:getChildByName("Button_8_"..i)
		widget:addTouchEventListener(handler(self,self.onbtnCai))
		widget.name = panlemiddle:getChildByName("Text_8c_"..i)
		widget.name:setString("?")

		if not self.btnlist[8] then
			self.btnlist[8] = {}
		end

		table.insert(self.btnlist[8],widget)
	end

	for i = 1 , 4 do 
		local xian =  panlemiddle:getChildByName("Image_xian_4_"..i)
		if not self.xian[4] then
			self.xian[4] = {}
		end
		table.insert(self.xian[4],xian)
		local widget = panlemiddle:getChildByName("Button_4_"..i)
		widget:addTouchEventListener(handler(self,self.onbtnCai))
		widget.name = panlemiddle:getChildByName("Text_4c_"..i)
		widget.name:setString("?")
		if not self.btnlist[4] then
			self.btnlist[4] = {}
		end
		table.insert(self.btnlist[4],widget)
	end

	for i = 1 , 2 do 
		local widget = panlemiddle:getChildByName("Button_2_"..i)
		widget:addTouchEventListener(handler(self,self.onbtnCai))
		widget.name = panlemiddle:getChildByName("Text_2c_"..i)
		widget.name:setString("?")
		if not self.btnlist[2] then
			self.btnlist[2] = {}
		end
		table.insert(self.btnlist[2],widget)
	end

	self.btnlist[1] = {}
	local widget = panlemiddle:getChildByName("Button_1_1")
	widget:addTouchEventListener(handler(self,self.onbtnCai))
	widget.name = panlemiddle:getChildByName("Text_1c_1")
	widget.name:setString("?")
	table.insert(self.btnlist[1],widget)

	self.winner_panel = panlemiddle:getChildByName("Panel_21")
	self.winner_panel.frame = self.winner_panel:getChildByName("Image_93")
	self.winner_panel.spr = self.winner_panel.frame:getChildByName("Image_94_0")
	self.winner_panel.spr:setScale(0.8)
	self.winner_panel.spr:ignoreContentAdaptWithSize(true)

	self.winner_panel.sever_name = self.winner_panel:getChildByName("Text_112")
	self.winner_panel.sever_name:setString("")

	self.winner_panel.lab_name = self.winner_panel:getChildByName("Text_112_0")
	self.winner_panel.lab_name:setFontName(display.DEFAULT_TTF_FONT)
	self.winner_panel.lab_name:setFontSize(20)
	self.winner_panel.lab_name:setString("")

	local btn = self.winner_panel:getChildByName("Button_59")
	btn:addTouchEventListener(handler(self, self.onbtnMobai))


	self:initDec()
	self:initPlayerList()
	self:schedule(self.changeTimes,1.0,"changeTimes")
	G_FitScreen(self,"Image_1")
end

function CrossWinwarView:initDec()
	-- body
	self.lab_time:setString("")
	self.lab_dec:setString(res.str.RES_RES_57)
	self.lab_dec_1:setString(res.str.RES_RES_52)
	for k,v in pairs(self.winner_panel:getChildren()) do 
		if v:getName() ~="Button_59" and v:getName() ~="Image_94" then
			v:setVisible(false)
		end
	end
end
--初始化玩家信息路线
function CrossWinwarView:initPlayerList()
	-- body
	self.list = {}
	for i = 1 , 16 do 
		local t = {}
		t.player = self.player[i]
		t.xian1 = self.xian[16][i]
		t.xian2 = self.xian[8][math.ceil(i/2)]
		t.xian3 = self.xian[4][math.ceil(i/4)]

		t.btn1 = self.btnlist[8][math.ceil(i/2)]
		t.btn2 = self.btnlist[4][math.ceil(i/4)]
		t.btn3 = self.btnlist[2][math.ceil(i/8)]
		t.btn4 = self.btnlist[1][1]

		t.btn1.frId = -1 
		t.btn2.frId = -1 
		t.btn3.frId = -1 
		t.btn4.frId = -1 
		if i == 1 then
			self.list[1] = t
		elseif i == 2 then 
			self.list[16] = t
		elseif i == 3 then
			self.list[9] = t 
		elseif i == 4 then 
			self.list[8] = t 
		elseif i == 5 then 
			self.list[12] = t 
		elseif i == 6 then 
			self.list[5] = t 
		elseif i == 7 then 
			self.list[13] = t 
		elseif i == 8 then 
			self.list[4] = t 
		elseif i == 9 then 
			self.list[2] = t 
		elseif i == 10 then 
			self.list[15] = t 
		elseif i == 11 then 
			self.list[10] = t 
		elseif i == 12 then 
			self.list[7] = t 
		elseif i == 13 then
			self.list[11] = t 
		elseif i == 14 then 
			self.list[6] = t 
		elseif i == 15 then 
			self.list[14] = t 
		elseif i == 16 then 
			self.list[3] = t 
		end
	end
end

function CrossWinwarView:clear()
	-- body
	self:initDec()
	for k ,v in pairs(self.list) do 
		v.player.sever_name:setString("")
		v.player.player_name:setString("")

		v.xian1:loadTexture(res.other.CROSS_XIAN_OLD[1])
		v.xian2:loadTexture(res.other.CROSS_XIAN_OLD[2])
		v.xian3:loadTexture(res.other.CROSS_XIAN_OLD[3])

		v.btn1.data = nil 
		v.btn2.data = nil 
		v.btn3.data = nil 
		v.btn4.data = nil 

		v.btn1.frId = -1 
		v.btn2.frId = -1 
		v.btn3.frId = -1 
		v.btn4.frId = -1 

		v.btn1.name:setString("?")
		v.btn2.name:setString("?")
		v.btn3.name:setString("?")
		v.btn4.name:setString("?")

		v.btn1:loadTextureNormal(res.btn.LUXIANG)
		v.btn2:loadTextureNormal(res.btn.LUXIANG)
		v.btn3:loadTextureNormal(res.btn.LUXIANG)
		v.btn4:loadTextureNormal(res.btn.LUXIANG)

	end
end

--设置每个玩家信息 以及胜利晋级路线
function CrossWinwarView:initPlayerItem(v)
	-- body
	local widget = self.list[v.index]
	if not widget then
		return
	end
	widget.player.sever_name:setString(G_SplitStr(v.namePre,"\n"))
	widget.player.player_name:setString(G_SplitStr(v.roleName,"\n"))


	local function callback(_btn)
		if not _btn.data then
			_btn.data = {}
		end
		table.insert(_btn.data,v)

		--[[if _btn.frId == -1 then 
			_btn.name:setString(res.str.RES_RES_58)
			_btn:loadTextureNormal(res.btn.JINGCAI)
		end]]--
	end

	local function callxian(_xian,i)
		-- body
		_xian:loadTexture(res.other.CROSS_XIAN[i])
	end

	local function callbtn( btn,id )
		-- body
		btn.frId = id
		btn.name:setString(res.str.RES_RES_59)
		btn:loadTextureNormal(res.btn.LUXIANG)		
	end

	if v.win == 16 then
		callback(widget.btn1)
		--[[if v.frId and v.frId.key ~= "0_0" then
			callbtn(widget.btn1,v.frId)
		end]]
		--callbtn(widget.btn1,v.win)
	elseif v.win == 8 then 
		callxian(widget.xian1,1)
		callback(widget.btn1)
		callback(widget.btn2)

		--callbtn(widget.btn1,v.win)
	elseif v.win == 4 then 
		callxian(widget.xian1,1)
		callxian(widget.xian2,2)
		callback(widget.btn1)
		callback(widget.btn2)
		callback(widget.btn3)
		--callbtn(widget.btn1,v.win)
	elseif v.win == 2 then
		callxian(widget.xian1,1)
		callxian(widget.xian2,2)
		callxian(widget.xian3,3)

		callback(widget.btn1)
		callback(widget.btn2)
		callback(widget.btn3)
		callback(widget.btn4)

		--callbtn(widget.btn1,v.win)
	elseif v.win == 1 then 
		--他妈的冠军
		callxian(widget.xian1,1)
		callxian(widget.xian2,2)
		callxian(widget.xian3,3)

		callback(widget.btn1)
		callback(widget.btn2)
		callback(widget.btn3)
		callback(widget.btn4)

		
		for k,v in pairs(self.winner_panel:getChildren()) do 
			v:setVisible(true)
		end
		self.winner_panel.lab_name:setString(v.namePre.."."..v.roleName)
		self.winner_panel.sever_name:setString(res.str.RES_RES_69)

		local json = G_Split_Back(v.roleIcon)
		self.winner_panel.frame:loadTexture(json.frame_img)
		local sex = json.sex
		local str = sex..string.format("%02d",12)
		self.winner_panel.spr:loadTexture("res/head/"..str..".png")

		--[[if json.dw > 0 then 
			local spr = display.newSprite(res.icon.DW_ICON[json.dw])
			spr:setPosition(json.dw_pos)
			spr:addTo(self.winner_panel.frame)
		end
		if json.vip > 1 then 
			local spr = display.newSprite(res.icon.VIP_LV[json.vip])
			spr:setPosition(json.vip_pos)
			spr:addTo(self.winner_panel.frame)
		end]]--
	end
end

--倒数计时
function CrossWinwarView:changeTimes()
	-- body
	if not self.data then 
		return 
	end

	local str = res.str.RES_RES_64
	if self.data.state == 1 then 
	elseif self.data.state == 3 then 
		str = res.str.RES_RES_65
	elseif self.data.state == 2 then 
		str = res.str.RES_RES_66
	end

	self.lab_dec:setString(str)

	local d = 0
	local h = 0 
	local m = 0
	local s = 0

	d = math.floor(self.data.nextTime/(3600*24))
	h = math.floor(self.data.nextTime%(3600*24)/3600)
	m = math.floor(self.data.nextTime%3600/60)
	s = math.floor(self.data.nextTime%3600%60)

	local str = ""
	if d > 0 then
		str = str..string.format(res.str.DUI_DEC_71,d)
	end
	if h > 0 then 
		str = str..string.format(res.str.DUI_DEC_90,h)
	end

	if m > 0 then 
		str = str..string.format(res.str.DUI_DEC_91,m)
	end 

	if s > 0 then
		str = str..string.format(res.str.DUI_DEC_92,s)
	end
	self.lab_time:setString(str)

	--[[if self.data.nextTime <= 3600 * 24 then 
		self.lab_time:setString(string.formatNumberToTimeString(self.data.nextTime))
	else
		

	end]]--
	if self.data.nextTime <=0 and self.request == 0 then
		self.request = 1
		proxy.Cross:send_123006()
	end
end
--填充玩家信息
function CrossWinwarView:initPlayer( var )
	-- body
	local data = self.playerzu[var]
	if not data then
		return 
	end

	for k ,v in pairs(data) do 
		local widget = self.zu[8][var]
		widget.player[k].sever_name:setString(G_SplitStr(v.namePre,"\n"))
		widget.player[k].player_name:setString(G_SplitStr(v.roleName,"\n"))
	end
end

function CrossWinwarView:checkbtn()
	-- body
	for k ,v in pairs(self.btnlist[8]) do 
		v.hehe = 16
		if not v.data  then
			v.name:setString("?")
			v:loadTextureNormal(res.btn.LUXIANG)
		elseif #v.data == 1 then
			v.name:setString(res.str.RES_RES_77)
			v:loadTextureNormal(res.btn.LUXIANG)
		else
			if v.data[1].win == v.data[2].win then --竞猜
				v.frId = -1 
				v.name:setString(res.str.RES_RES_58)
				v:loadTextureNormal(res.btn.JINGCAI)
			else --录像
				v.frId = 1 
				v.name:setString(res.str.RES_RES_59)
				v:loadTextureNormal(res.btn.LUXIANG)		
			end
		end
	end

	for k ,v in pairs(self.btnlist[4]) do 
		v.hehe = 8
		if not v.data then
			v.name:setString("?")
			v:loadTextureNormal(res.btn.LUXIANG)
		elseif #v.data == 1 then
			v.name:setString(res.str.RES_RES_77)
			v:loadTextureNormal(res.btn.LUXIANG)
		else
			if v.data[1].win == v.data[2].win then --竞猜
				v.frId = -1 
				v.name:setString(res.str.RES_RES_58)
				v:loadTextureNormal(res.btn.JINGCAI)
			else --录像
				v.frId = 1 
				v.name:setString(res.str.RES_RES_59)
				v:loadTextureNormal(res.btn.LUXIANG)		
			end
		end
	end

	for k ,v in pairs(self.btnlist[2]) do 
		v.hehe = 4
		if not v.data  then
			v.name:setString("?")
			v:loadTextureNormal(res.btn.LUXIANG)
		elseif #v.data == 1 then
			v.name:setString(res.str.RES_RES_77)
			v:loadTextureNormal(res.btn.LUXIANG)
		else
			if v.data[1].win == v.data[2].win then --竞猜
				v.frId = -1 
				v.name:setString(res.str.RES_RES_58)
				v:loadTextureNormal(res.btn.JINGCAI)
			else --录像
				v.frId = 1 
				v.name:setString(res.str.RES_RES_59)
				v:loadTextureNormal(res.btn.LUXIANG)		
			end
		end
	end

	for k ,v in pairs(self.btnlist[1]) do 
		v.hehe = 2
		if not v.data  then
			v.name:setString("?")
			v:loadTextureNormal(res.btn.LUXIANG)
		elseif  #v.data == 1 then
			if #self.data.rankUkings == 1 then
				v.name:setString(res.str.RES_RES_77)
				v:loadTextureNormal(res.btn.LUXIANG)
			else
				v.data = nil 
				v.name:setString("?")
				v:loadTextureNormal(res.btn.LUXIANG)
			end
		else
			if v.data[1].win == v.data[2].win then --竞猜
				v.frId = -1 
				v.name:setString(res.str.RES_RES_58)
				v:loadTextureNormal(res.btn.JINGCAI)
			else --录像
				v.frId = 1 
				v.name:setString(res.str.RES_RES_59)
				v:loadTextureNormal(res.btn.LUXIANG)		
			end
		end
	end
end

function CrossWinwarView:setData(data)
	-- body
	self.request = 0
	self.data = data
	self:changeTimes()
	table.sort(self.data.rankUkings,function(a,b)
		-- body
		return a.index < b.index
	end)

	self:clear()
	for k ,v in pairs(self.data.rankUkings) do 
		self:initPlayerItem(v)
	end
	self:checkbtn()

	if self.data and g_var.platform == "win32" then
		local label = display.newTTFLabel({
		    text = "("..self.data.day.."天)".." 阶段 ".. self.data.state,
		    font = "Marker Felt",
		    size = 24,
		    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		label:setPosition(self.lab_time:getPositionX()-200,self.lab_time:getPositionY() + 50)
		label:addTo(self.lab_time:getParent())
	end
end

function CrossWinwarView:onbtnMobai( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_MOBAO)
		--view:setData()
		proxy.Cross:send_123007()
	end
end

function CrossWinwarView:onbtnCai( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_COMPARE)
		if send.frId > 0 then --有录像
			--G_TipsOfstr("这里是录像")
			cache.Cross:keepInfobefor(clone(send.data),send.hehe)
			local view = mgr.ViewMgr:showView(_viewname.CROSS_VIDEO_TRUE)
			view:setPlayerData(clone(send.data),send.hehe)
		else
			if not send.data then 
				G_TipsOfstr(res.str.RES_RES_61)
			else
				if #send.data == 1 then 
					G_TipsOfstr(res.str.RES_RES_62)
				else
					local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_COMPARE)
					view:setData(send.data)
				end
			end
		end
	end
end


function CrossWinwarView:onbtnReward( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_REWARD)
		view:setData()
	end
end

function CrossWinwarView:onbtnguze( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(19)
	end
end

function CrossWinwarView:onbtnGetWord( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("留言")
	end
end

function CrossWinwarView:onbtnclose( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function CrossWinwarView:onCloseSelfView()
	-- body
	self:closeSelfView()
end
return CrossWinwarView
