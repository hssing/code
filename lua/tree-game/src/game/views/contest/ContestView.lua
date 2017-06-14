--[[
	ContestView 数码兽大赛主页面
]]
local ScollLayer = require("game.cocosstudioui.ScollLayer")
local ContestView = class("ContestView",base.BaseView)

--[[local words = {
	"我就是一个测试用的我就是一个测试我就是一个测试我就是一个测试我就是一个测试",
	"第一名",
	"楼上是傻瓜",
	"看的书法家的身份讲的是防静电服京东方",
	"j122354544554",
	"我是时间地方东方今典恢复较好的的还是减肥红点设就放或的肌肤和电视剧等级放好久都很费劲的收费的健身房金",
}]]--

function ContestView:ctor()
	-- body
	self.postabel = {}
	self.askOne = false --倒计时为0的时候请求一次服务器
	self.word = {} --循环的广告 -- 系统返回和本地配置

	self.clearable = {} --可能需要清理的
end

function ContestView:init()
	-- body
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	G_FitScreen(self, "Image_1")
	self.bg = self.view:getChildByName("Image_1")
	--顶部层容器
	local panle_top = self.view:getChildByName("Panel_1")
	local img_reward = panle_top:getChildByName("Image_3_1")
	img_reward:setTouchEnabled(true)
	img_reward:addTouchEventListener(handler(self, self.onimgRewardCallback))


	local btn_shop = panle_top:getChildByName("Button_2_0") 
	btn_shop:addTouchEventListener(handler(self, self.onbtnShop))

	--是什么鬼的 倒计时
	self.lab_top_dec = panle_top:getChildByName("Text_1")
	--倒计时
	self.lab_times = panle_top:getChildByName("Text_1_0")
	--比赛录像
	self.btn_video = panle_top:getChildByName("Button_32")
	self.btn_video:addTouchEventListener(handler(self, self.onvedioCallBack))

	--人的剪影
	self.item = self.view:getChildByName("Panel_2")
	--中间层容器
	local panle_middle = self.view:getChildByName("Panel_3")
	self.midpanle = panle_middle
	self.btn_baoming = self.view:getChildByName("Button_close_0")--报名
	self.btn_baoming:addTouchEventListener(handler(self, self.onbtnBaoming))

	self.btn_cai = panle_middle:getChildByName("Button_close_0_0")--竞猜
	self.btn_cai:addTouchEventListener(handler(self, self.onbtnCaiCallBack))
	self.img_vs = panle_middle:getChildByName("Image_7") --vs
	self.panle_left = panle_middle:getChildByName("Panel_39")
	self.panle_left:getChildByName("Text_79"):setFontName(display.DEFAULT_TTF_FONT)
	self.panle_left:getChildByName("Text_79"):setFontSize(18)

	self.panel_right = panle_middle:getChildByName("Panel_39_0")
	self.panel_right:getChildByName("Text_79_83") :setFontName(display.DEFAULT_TTF_FONT)
	self.panel_right:getChildByName("Text_79_83") :setFontSize(18)

	self.img_font_sai =  panle_middle:getChildByName("Image_7_1")
	
	self.view:reorderChild(panle_middle, 100)
	--广告牌子
	self.panle_gg =  self.view:getChildByName("Panel_38")
	self.img_guanggao =self.panle_gg:getChildByName("Image_73")
	self.lab_g_item = self.panle_gg:getChildByName("Text_78")
	self.lab_g_item:setVisible(false)

	---
	self.speak = self.view:getChildByName("Panel_1_0")


	self.view:reorderChild(panle_middle, 200)
	self.view:reorderChild(self.btn_baoming, 200)
	self.view:reorderChild(self.panle_gg, 100)
	--做滑动
	local rect =cc.rect(0,display.height/8,display.width,display.height/8*6)
	local layer = ScollLayer.new(rect,80)
	layer:setName("touchlayer")
	layer:setMoveLeftCalllBack(handler(self,self.prv))
	layer:setMoveRightCalllBack(handler(self,self.next))
	--layer:setMoveingCallback(handler(self,self.moveing))
	self:addChild(layer)
	
	
	--self:setData()


	--界面文本
	panle_top:getChildByName("Text_1"):setString(res.str.CONTEST_TEXT15)
	panle_top:getChildByName("Button_32"):setTitleText(res.str.CONTEST_TEXT16)





	
	self:schedule(self.changeTimes,1.0)


	self:performWithDelay(function()
		-- body
		self:forever()
	end, 0.1)
	--测试使用
	--[[self.count = 4
	self:initItemPos(self.count)
	self:setRoleImg()]]--
end

function ContestView:onbtnShop( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_SHOP)
	end 
end

function ContestView:forever( ... )
	-- body

	local params =  {id=404836, x=self.bg:getContentSize().width/2,
	y=self.bg:getContentSize().height/2,addTo=self.bg, playIndex=0}
	mgr.effect:playEffect(params)

	local params =  {id=404826, x=self.bg:getContentSize().width/2,
	y=self.bg:getContentSize().height/2,addTo=self.bg, playIndex=4}
	mgr.effect:playEffect(params)


	
end

--循环的广告语言
function ContestView:repeatWord(param)
	-- body
	local panle_in = self.panle_gg:getChildByName("Panel_44")
	--panle_in:removeAllChildren()

	local panle_move =  ccui.Layout:create()
	panle_move:setContentSize(panle_in:getContentSize())
	--panle_move:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
   	--panle_move:setBackGroundColor(cc.c3b(0, 0, 0))
   	panle_move:setPosition(0,-panle_in:getContentSize().height)
	panle_move:addTo(panle_in)

	local posx = 0
	local posy = panle_move:getContentSize().height
	for i = 1 , #param do 
		-- 左对齐，并且多行文字顶部对齐
		local label = display.newTTFLabel({
		    text = param[i],
		    font = res.ttf[1],
		    size = self.lab_g_item:getFontSize(),
		    color = self.lab_g_item:getColor(),
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(panle_move:getContentSize().width*0.9, 0), 
		})
		label:setAnchorPoint(cc.p(0,1))
		label:setPosition(posx,posy)
		
		label:addTo(panle_move)

		posy = posy - label:getContentSize().height-10
	end

	if posy < 0 then 
		local distance =  math.abs(posy) + panle_in:getContentSize().height*2
		local time =(distance ) / 30  
		local time2 =  (distance - panle_in:getContentSize().height)/30
		local a1 = cc.MoveTo:create(time, cc.p(panle_move:getPositionX(),panle_move:getPositionY()+distance
			+panle_in:getContentSize().height/2))
		local a2 = cc.CallFunc:create(function ( ... )
			-- body
			panle_move:removeSelf()
			
		end)


		local sequence = cc.Sequence:create(a1,a2)
		--panle_move:runAction(cc.RepeatForever:create(sequence))
		panle_move:runAction(sequence)

		panle_move:performWithDelay(function( ... )
			-- body
			self:repeatWord(param)
		end, time2)
	end 
end
--把后端定义转义为前端使用的定义 1 现在接受报名 2 已经报名了 3 小组赛结算前，4小组赛结果 5： 4强 6，决赛，7 冠军
function ContestView:changedsStateTolocal( dsState )
	-- body
	return dsState
end
--已报名
function ContestView:update( ... )
	-- body
	G_TipsOfstr(res.str.CONTEST_DEC24)
	self.data = cache.Contest:getContest()
	local dsState = self:changedsStateTolocal(self.data.dsState)
	local flag = dsState == 1 and true or false
	local img = self.btn_baoming:getChildByName("Image_72")
	self.btn_baoming:setTouchEnabled(flag)

	--print(res.font.CONTEST_BAOMING[dsState])
	img:loadTexture(res.font.CONTEST_BAOMING[dsState])
end
--按状态初始化 位置个数
function ContestView:initposByStatue( statue )
	-- body
	if statue < 6 or statue == 11 then 
		return 8
	elseif statue < 8 then 
		return 4
	elseif statue < 10 then 
		return 2
	else
		return 1
	end
end

function ContestView:initVSbyState( statue )
	-- body
	--self.img_font_sai:loadTexture(res.font.CONTESTVIEW[1])
	self.img_font_sai:setVisible(false)
	if statue == 6 or statue == 7  then
		self.img_font_sai:setVisible(true)
		self.img_font_sai:loadTexture(res.font.CONTESTVIEW[1])
	elseif statue == 8 or statue == 9 then
		--todo
		self.img_font_sai:setVisible(true)
		self.img_font_sai:loadTexture(res.font.CONTESTVIEW[2])
	end  
end
--倒计时描述
function ContestView:initTimeDec( ... )
	-- body
	if self.data.dsState < 3  then 
		self.lab_top_dec:setString(res.str.CONTEST_DEC17..":")
	elseif self.data.dsState  == 3 then 
		self.lab_top_dec:setString(res.str.CONTEST_DEC16..":")
		
	elseif self.data.dsState  == 4 or self.data.dsState  == 6 or 
		self.data.dsState  == 8 then 
		self.lab_top_dec:setString(res.str.CONTEST_DEC18..":")
	elseif self.data.dsState  == 5 then 
		self.lab_top_dec:setString(res.str.CONTEST_DEC19..":")
	elseif self.data.dsState  ==  7 then 
		self.lab_top_dec:setString(res.str.CONTEST_DEC20..":")
	elseif self.data.dsState  ==  9 then
		--todo
		self.lab_top_dec:setString(res.str.CONTEST_DEC21..":")
	elseif self.data.dsState  ==  10 then 
		self.lab_top_dec:setString(res.str.CONTEST_DEC22..":")
	elseif self.data.dsState  ==  11 then
		--todo
		self.lab_top_dec:setString(res.str.CONTEST_DEC29..":")
		
	end 

	self.lab_times:setPositionX(self.lab_top_dec:getPositionX() + self.lab_top_dec:getContentSize().width + 10 )
end

function ContestView:setData()
	-- body

	--一些清理工作
	self.panle_gg:getChildByName("Panel_44"):removeAllChildren()

	for i = 1 , 8 do 
		if self["item"..i] then 
			self["item"..i]:removeFromParent() 
		end 
		self["item"..i] = nil 
	end 
	for k , v in pairs(self.clearable) do 
		if v then 
			v:removeFromParent()
		end 
	end 
	self.clearable = {}

	self.askOne = true ---倒计时为0 的时候 请求一次
	self.data = clone(cache.Contest:getContest())

	table.sort(self.data.users,function( a,b )
		-- body
		return a.index<b.index
	end)



	self.count_time_data  = cache.Contest:getContest()
	--广告循环说的话
	self.word = {}
	if self.data.rankStrs then 
		for k ,v in pairs(self.data.rankStrs) do 
			table.insert(self.word,v)
		end 
	end 
	local words = conf.Sys:getValue("contest_word")
	if words then 
		for i = 1 , #words do 
			table.insert(self.word,words[i])
		end 
	end 
	self:repeatWord(self.word)

	---按状态初始化 位置个数
	self.count = self:initposByStatue(self.data.dsState)
	self:initItemPos(self.count) --位置

	--比赛是 头尾比 所以得排序 1 - 8 ， 2 -7 .... 添加字段区分组别
	if self.data.users then 
		if #self.data.users < self.count then 
			for i = #self.data.users+1 , self.count do 
				local t = {}
				t.sex = 2
				t.index = 8 + i 
				table.insert(self.data.users,t)
			end 
		end 

		for k ,v in pairs(self.data.users) do 
			if k <= self.count /2 then 
				v.zu = k
			else
			 	v.zu = self.count + 1 - k 
			end  
		end 
	end 

	table.sort( self.data.users, function ( a,b )
		-- body
		if a.zu == b.zu then 
			return a.index<b.index
		else
			return a.zu < b.zu 
		end 
	end)

	--printt(self.data.users)

	self.lab_top_dec:setString(res.str.CONTEST_DEC1)--倒计时	
	
	self.btn_video:addTouchEventListener(handler(self, self.onvedioCallBack))
	self.btn_video:setTitleText(res.str.CONTEST_DEC12)

	--按类型分倒计时 描述
	self:initTimeDec()

	local dsState = self:changedsStateTolocal(self.data.dsState)
	if dsState == 1 or dsState == 2  then --报名期间
		local img = self.btn_baoming:getChildByName("Image_72")
		local flag = dsState == 1 and true or false
		self.btn_baoming:setTouchEnabled(flag)
		img:loadTexture(res.font.CONTEST_BAOMING[dsState])

		self:initMiddle(1)
		if #self.data.users > 0 then 
			self:setGuangJun()
			--[[for k ,v in pairs(self.data.users) do 
				if v.index < 9 and v.index>0 and v.roleName then 
					 -- 有上届冠军
					break
				end 
			end ]]--
			
		end 
	elseif dsState == 3 or dsState == 11 then --小组赛结算没出来之前
		

		self:initMiddle(4)
		self:setRoleJianying() 

		self.btn_video:setVisible(true)
		self.btn_video:addTouchEventListener(handler(self, self.onbtnXiaozuMsg))
		self.btn_video:setTitleText(res.str.CONTEST_DEC13)
	elseif dsState == 4 or dsState == 6 or dsState == 8 then ----小组赛已经结算,(可竞猜
		self:initMiddle(3)
		if #self.data.users == 0 then
			self:setRoleJianying() 
		else
			self:setRoleImg()
		end 
		
		self.btn_cai:setTouchEnabled(true)
	elseif dsState == 5 or dsState == 7 or dsState == 9  then --4强赛,结算前10分钟,(不可竞猜
		self:initMiddle(3)
		if #self.data.users == 0 then 
			self:setRoleJianying() 
		else
			self:setRoleImg()
		end 
	else
		self:initMiddle(5)
		self:setGuangJun(true)
	end 

	self:initVSbyState(self.data.dsState)---设置比赛
	self:changeTimes()
end

--这里分类型倒数
function ContestView:changeTimes()
	-- body
	--倒计时	
	if self.count_time_data.lastTime > 3600 then 
		self.lab_times:setString(string.formatNumberToTimeString(self.count_time_data.lastTime))
	else
		local str = string.format("%02d:%02d",math.floor(self.count_time_data.lastTime/60),self.count_time_data.lastTime%60)
		self.lab_times:setString(str)
	end 
	local dsState = self:changedsStateTolocal(self.count_time_data.dsState)

	if self.askOne and self.count_time_data.lastTime == 0  then --小组赛
		self.askOne = false
		
		self:performWithDelay(function( ... )
			-- body
			proxy.Contest:sendContest()
			mgr.NetMgr:wait(519001)
		end, 1)
	end 
end

--初始化中间层 1 只看报名按钮 2   只有名字 3.竞猜按钮和图片,4 只有剪影的时候,名字问好
function ContestView:initMiddle( value )
	-- body
	self.btn_baoming:setVisible(false)
	self.btn_cai:setVisible(false)
	self.img_vs:setVisible(false)
	self.panle_left:setVisible(false)
	self.panel_right:setVisible(false)
	self.img_font_sai:setVisible(false)

	self.panle_gg:setVisible(false)
	self.btn_video:setVisible(false)
	if value == 1 then 
		self.btn_baoming:setVisible(true)
	elseif value == 2 then 
		self.panle_left:setVisible(true)
		self.panel_right:setVisible(true)
		self.btn_video:setVisible(true)
	elseif value == 3 then 
		self.btn_cai:setVisible(true)
		self.img_vs:setVisible(true)
		self.panle_left:setVisible(true)
		self.panel_right:setVisible(true)
		self.img_font_sai:setVisible(true)
		self.btn_video:setVisible(true)
		self.panle_gg:setVisible(true)
	elseif value == 4 then
		--todo
		self.panle_gg:setVisible(true)

		self.panle_left:setVisible(true)
		self.panle_left:getChildByName("AtlasLabel_3"):setVisible(false)
		self.panle_left:getChildByName("Image_79"):setVisible(false)
		self.panle_left:getChildByName("Image_79_0"):setVisible(false)
		
		self.panle_left:getChildByName("Text_79"):setString("")

		self.panel_right:setVisible(true)
		self.panel_right:getChildByName("AtlasLabel_3_5"):setVisible(false)
		self.panel_right:getChildByName("Image_79_87"):setVisible(false)
		self.panel_right:getChildByName("Image_79_0_89"):setVisible(false)
		self.panel_right:getChildByName("Text_79_83"):setString("")
	else
		self.btn_video:setVisible(true)
	end 
end
--按数量初始化位置
function ContestView:initItemPos(value)
	-- body
	self.postabel = {}
	
	local ccsize = self.item:getContentSize()
	if value == 1 then 
		local pos = {} 
		pos.x = display.cx 
		pos.y = display.cy - ccsize.height/2 - 50
		table.insert(self.postabel,pos)--位置中间
	elseif value ==2 then 
		local pos = {}  	
		pos.x = self.midpanle:getPositionX() - ccsize.width/2 - self.midpanle:getContentSize().width/2
		pos.y = display.cy - ccsize.height/2 - 100
		table.insert(self.postabel,pos)--位置 1 左

		pos = {}
		pos.x = self.midpanle:getPositionX() +  ccsize.width/2 + self.midpanle:getContentSize().width/2
		pos.y = display.cy - ccsize.height/2 - 100
		table.insert(self.postabel,pos)--位置 2 右
	elseif value == 4 then 
		local pos = {}  	
		pos.x = self.midpanle:getPositionX() - ccsize.width/2 - self.midpanle:getContentSize().width/2
		pos.y = display.cy - ccsize.height/2 - 100
		table.insert(self.postabel,pos)--位置 1 左

		pos = {}
		pos.x = self.midpanle:getPositionX() +  ccsize.width/2 + self.midpanle:getContentSize().width/2
		pos.y = display.cy - ccsize.height/2 - 100
		table.insert(self.postabel,pos)--位置 2 右


		pos = {} 
		pos.x = self.postabel[2].x  - ccsize.width/2 +57
		pos.y = self.postabel[2].y  + 91 
		table.insert(self.postabel,pos)--位置 3 右

		pos = {} 
		pos.x = self.postabel[1].x   + ccsize.width/2 -62
		pos.y = self.postabel[1].y  + 90 
		table.insert(self.postabel,pos)--位置 4 左
	elseif value == 8 then 
		local pos = {}  	
		pos.x = self.midpanle:getPositionX() - ccsize.width/2 - self.midpanle:getContentSize().width/2
		pos.y = display.cy - ccsize.height/2 - 100
		table.insert(self.postabel,pos)--位置 1 左

		pos = {}
		pos.x = self.midpanle:getPositionX() +  ccsize.width/2 + self.midpanle:getContentSize().width/2
		pos.y = display.cy - ccsize.height/2 - 100
		table.insert(self.postabel,pos)--位置 2 右

		pos = {}
		pos.x = self.postabel[2].x +  ccsize.width/2 +10
		pos.y = self.postabel[2].y +50
		table.insert(self.postabel,pos)--位置 3 右

		pos = {}
		pos.x = self.postabel[3].x -  ccsize.width/2 +22
		pos.y = self.postabel[3].y +37
		table.insert(self.postabel,pos)--位置 4 右

		pos = {}
		pos.x = self.postabel[4].x -  ccsize.width/2 -5
		pos.y = self.postabel[4].y +17
		table.insert(self.postabel,pos)--位置 5 右

		pos = {}
		pos.x = display.width - self.postabel[5].x
		pos.y = self.postabel[5].y 
		table.insert(self.postabel,pos)--位置 6

		pos = {}
		pos.x = display.width - self.postabel[4].x 
		pos.y = self.postabel[4].y 
		table.insert(self.postabel,pos)--位置 7


		pos = {}
		pos.x = display.width - self.postabel[3].x 
		pos.y = self.postabel[3].y 
		table.insert(self.postabel,pos)--位置 8


	end 
end
--self["item"..i] 设置显示的名字和组别
function ContestView:setLabL_R(item)
	-- body
	local data = item.data 
	if item.pos >= 3 then 
		return 
	end  
 	
	if item.pos ==1 then 
		local lab_name = self.panle_left:getChildByName("Text_79") 
		local lab_zu = self.panle_left:getChildByName("AtlasLabel_3")
		local img_zu = self.panle_left:getChildByName("Image_79")
		local img_zu_1 = self.panle_left:getChildByName("Image_79_0")


		self.panle_left:setVisible(true)
		lab_zu:setString(item.zu)
		lab_zu:setVisible(true)
		img_zu:setVisible(true)

		if data then 
			
			img_zu_1:setVisible(true)
			lab_name:setString(data.roleName)
			--lab_zu:setString(data.index)
		else
			img_zu_1:setVisible(false)
			lab_name:setString("")
		end
	else
		--self.panel_right:setVisible(false)
		local lab_name = self.panel_right:getChildByName("Text_79_83") 
		local lab_zu = self.panel_right:getChildByName("AtlasLabel_3_5")
		local img_zu = self.panel_right:getChildByName("Image_79_87")
		local img_zu_1 = self.panel_right:getChildByName("Image_79_0_89")

		self.panel_right:setVisible(true)
		lab_zu:setString(item.zu)
		lab_zu:setVisible(true)
		img_zu:setVisible(true)

		if data then 
			
			img_zu_1:setVisible(true)
			lab_name:setString(data.roleName)
			--lab_zu:setString(data.)
		else
			img_zu_1:setVisible(false)
			lab_name:setString("")
			
		end 
	end 
end
--显示的各个移动后
function ContestView:setSpr( item )
	-- body
	local data = item.data 
	local spr = item:getChildByName("Image_74_0")
	local wenhao = item:getChildByName("Image_76")

	item:setScale(self:getScaleByPos(item.pos))  --设置大小
	item:setFlippedX(self:setFaceBypos(item.pos)) --设置朝向
	if item:isFlippedX() then 
		wenhao:setFlippedX(true)
	end 

	if not data then
		if (item.pos == 1 or item.pos == 2)  then 
			wenhao:loadTexture(res.other.CONTEST_WENHAO[1])
			--spr:loadTexture(res.image.CONTEST_ROLE[3])
			if item.sex == 1 then 
				if not item.data  then 
					spr:loadTexture(res.image.CONTEST_ROLE[1])
				end 
			else
				if not item.data then 
					spr:loadTexture(res.image.CONTEST_ROLE[3])
				end 
			end 
			self:setLabL_R(item)
		else
			wenhao:loadTexture(res.other.CONTEST_WENHAO[2])
			if item.sex == 1 then 
				if not item.data  then 
					spr:loadTexture(res.image.CONTEST_ROLE[2])
				end 
			else
				if  not item.data  then 
					spr:loadTexture(res.image.CONTEST_ROLE[4])
				end 
			end 
			--spr:loadTexture(res.image.CONTEST_ROLE[4])
		end 
	else
		self:setLabL_R(item)
	end 

end

function ContestView:onpanClick( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("跳转到驯兽师之王")

		proxy.Contest:sendWinnerMsg()
			mgr.NetMgr:wait(519101)

	end 
end

--报名期间的冠军展示
function ContestView:setGuangJun(flag)
	-- body
	local pos = self.btn_baoming:getWorldPosition()
	

	local data = self.data.users[1]

	local item  = self.item:clone()
	
	item:addTo(self.view)

	item:setTouchEnabled(true)
	item:addTouchEventListener(handler(self, self.onpanClick))

	local img = item:getChildByName("Image_79_0_0")
	local lab_name = img:getChildByName("Text_81")
	lab_name:setString(data.roleName)

	local spr = item:getChildByName("Image_74_0")
	local wenhao = item:getChildByName("Image_76")
	local dizuo = item:getChildByName("Image_74")
	local guan = item:getChildByName("Image_81")
	wenhao:setVisible(false)
	if data.sex == 1 then 
		spr:loadTexture(res.image.ROLE_BOY)
		dizuo:loadTexture(res.image.CONTEST_DIZUO[2])
		guan:loadTexture(res.image.CONTEST_GUANG[1])
	else
		spr:loadTexture(res.image.ROLE_GRILS)
		dizuo:loadTexture(res.image.CONTEST_DIZUO[1])
		guan:loadTexture(res.image.CONTEST_GUANG[2])
	end

	if  not data.roleName then 
		img:setVisible(false)
		wenhao:setVisible(true)
		if data.sex == 1 then
			spr:loadTexture(res.image.CONTEST_ROLE[4])
		else
			spr:loadTexture(res.image.CONTEST_ROLE[2])
		end

		
	else
	 	--todo 
	end 

	if flag then 
		img:setVisible(true)
		pos.y = pos.y -15
		item:setPosition(pos)
	else
		pos.y = pos.y -15
		item:setPosition(pos)
		local img_di = item:getChildByName("Image_81_0")
		img_di:setPositionY(img:getPositionY() + img:getContentSize().height + 30  )
	end 


	item:setFlippedX(false)

	local speak = self.speak:clone()
	speak:getChildByName("Text_2_24_27_16"):setString(res.str.CONTEST_DEC23)
	if  not data.roleName then 
		speak:getChildByName("Text_2_24_27_16"):setString(res.str.CONTEST_DEC25)
	end 
	speak:addTo(item)
	speak:setScale(0)
	speak:setPosition(0,item:getContentSize().height-50)

	local scale = cc.ScaleTo:create(0.8,1)
    local act = cc.EaseElasticOut:create(scale)
    local a_fistr = cc.CallFunc:create(function()
		-- body
		speak:setVisible(false)
		speak:setScale(0)
	end)
    local a_end  = cc.CallFunc:create(function()
		-- body
		speak:setVisible(true)
	end)

	local a1 = cc.DelayTime:create(1.0)


    local sequence = cc.Sequence:create(a_end,act,a1,a_fistr,a1)
    local action = cc.RepeatForever:create(sequence)

    speak:runAction(action)

	table.insert(self.clearable,item)
	--
end

function ContestView:setDizuo(pos,item)
	-- body
	local dizuo = item:getChildByName("Image_74")
	local guan = item:getChildByName("Image_81")
	if pos%2 == 1 then 
		dizuo:loadTexture(res.image.CONTEST_DIZUO[2])
		guan:loadTexture(res.image.CONTEST_GUANG[1])
	else
		dizuo:loadTexture(res.image.CONTEST_DIZUO[1])
		guan:loadTexture(res.image.CONTEST_GUANG[2])
	end 
end

--把玩家放到对应的位置
function ContestView:setRoleImg()
	-- body
	for i = 1 , self.count do 
		local item = self.item:clone()
		item:setPosition(self.postabel[i].x, self.postabel[i].y)
		
		item.pos = i

		local order = 1
		if i  < 3 then 
			order = 100
		elseif i == 3 or i == 8 then 
			order = 90
		elseif i == 4 or i == 7 then 
			order = 80 
		elseif i == 5 or i == 6 then
			order = 70 
		end 
		item:addTo(self.view,order)

		item:setScale(self:getScaleByPos(i))  --设置大小
		item:setFlippedX(self:setFaceBypos(i)) --设置朝向


		local spr = item:getChildByName("Image_74_0")
		local wenhao = item:getChildByName("Image_76")
		local dizuo = item:getChildByName("Image_74")
		local guan = item:getChildByName("Image_81")
		wenhao:setVisible(true)
		if item:isFlippedX() then 
			wenhao:setFlippedX(true)
		end 

		if i%2 == 0 then 
			item.sex = 2
			spr:loadTexture(res.image.CONTEST_ROLE[4])
		else
			item.sex = 1
			spr:loadTexture(res.image.CONTEST_ROLE[2])
		end 

		if i == 1 then 
			spr:loadTexture(res.image.CONTEST_ROLE[1])
		elseif i == 2 then 
			spr:loadTexture(res.image.CONTEST_ROLE[3])
		end 

		self:setDizuo(i,item)
 		
 		if i%2 == 0 then 
			item.zu = self.count - math.floor((i-1)/2)
		else
			item.zu =  math.floor(i/2)+1
		end 

		self["item"..i] = item
		if self.data.users[i] and  self.data.users[i].index > 8  then
			item:getChildByName("Image_81_0"):setVisible(false)
			item:getChildByName("Image_79_0_0"):setVisible(false)
		else
			
			item.data = self.data.users[i]
			--item.zu = item.data.index

			wenhao:setVisible(false)
			if self.count > 1  then 
				item:getChildByName("Image_81_0"):setVisible(false)
				item:getChildByName("Image_79_0_0"):setVisible(false)
			else
				local name = item:getChildByName("Image_79_0_0"):getChildByName("Text_81")
				name:setString(item.data.roleName)
			end

			local sex = item.data.sex
			item.sex = sex

			if sex == 1  then 
				spr:loadTexture(res.image.ROLE_BOY)
			else
				spr:loadTexture(res.image.ROLE_GRILS)
			end 


			item:setTouchEnabled(true)
			item.roleId = item.data.roleId
			item.roleName = item.data.roleName
			item:addTouchEventListener(handler(self, self.onpanRoleCallBack))


		end  

		self:setLabL_R(item)	
	end
	--self:setLabL_R() 
end

function ContestView:onpanRoleCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("看看录像别人录像"..sender_.roleName.." item.pos "..sender_.pos)
		if not self:checkVideo() then 
			return 
		end 
		local param = {roleId = sender_.roleId,name = sender_.roleName}
		proxy.Contest:sendVideo(param)
		mgr.NetMgr:wait(519003)
	end 
end

--移动后
function ContestView:RoleJianyingMoveBack( item )
	-- body
	self:setSpr(item) 
	local order = 1
	item:setTouchEnabled(false)
	if item.pos  < 3 then 
		order = 100
		item:setTouchEnabled(true)
	elseif item.pos == 3 or item.pos == 8 then 
		order = 90
	elseif item.pos == 4 or item.pos == 7 then 
		order = 80 
	elseif item.pos == 5 or item.pos == 6 then
		order = 70 
	end 
	self.view:reorderChild(item, order)
end

function ContestView:getScaleByPos( pos )
	-- body
	local i = pos
	if self.count == 8 then 
		if i == 3 or i ==8 then 
			return 0.65
		elseif i == 4 or i == 7 then 
			return 0.45
		elseif i == 5 or i == 6 then
			--todo
			return 0.35
		end 
	elseif self.count == 4 then 
		if i == 3 or i == 4 then 
			return 0.65
		end 
	else
		return 1.0
	end 

	return 1.0
end

function ContestView:setFaceBypos(pos)
	-- body
	if pos == 1 then 
		return true
	elseif pos == 2 then 
		return false
	elseif pos%2==0 then
		--todo
		return false
	else
		return true
	end 
end

--设置剪影
function ContestView:setRoleJianying()
	-- body
	for i = 1 , self.count do 
		local item = self.item:clone()
		item.pos = i
		item:setScale(1.0)

		if i%2 == 0 then 
			item.zu = self.count - math.floor((i-1)/2)
		else
			item.zu =  math.floor(i/2)+1
		end 

		local spr = item:getChildByName("Image_74_0")
		local wenhao = item:getChildByName("Image_76")
		local dizuo = item:getChildByName("Image_74")
		local guan = item:getChildByName("Image_81")

		--[[if i > 1 and i < 6 then 
			spr:loadTexture(res.image.CONTEST_ROLE[1])
		else
			spr:loadTexture(res.image.CONTEST_ROLE[2])
		end ]]--

		if i%2 == 0 then 
			item.sex = 2
			spr:loadTexture(res.image.CONTEST_ROLE[4])
		else
			item.sex = 1
			spr:loadTexture(res.image.CONTEST_ROLE[2])
		end 

		if i == 1 then 
			spr:loadTexture(res.image.CONTEST_ROLE[1])
		elseif i == 2 then 
			spr:loadTexture(res.image.CONTEST_ROLE[3])
		end 

		self:setDizuo(i,item)

		if i == 1 or i == 2 then 
			wenhao:loadTexture(res.other.CONTEST_WENHAO[1])
		else
			wenhao:loadTexture(res.other.CONTEST_WENHAO[2])
		end  
		--print("  scale "..self:getScaleByPos(i))
		item:setScale(self:getScaleByPos(i))  --设置大小
		item:setFlippedX(self:setFaceBypos(i)) --设置朝向
		if item:isFlippedX() then 
			wenhao:setFlippedX(true)
		end 


		item:getChildByName("Image_81_0"):setVisible(false)
		item:getChildByName("Image_79_0_0"):setVisible(false)

		item:setPosition(self.postabel[i].x, self.postabel[i].y)
		item:addTo(self.view,10-i)
		item.pos = i

		self:setLabL_R(item)

		self["item"..i] = item
	
	end 
end

function ContestView:prv()
	-- body
	self:move(-2)
end

function ContestView:next()
	-- body
	self:move(2)
end
--移动动画
function ContestView:move( dir )
	-- body
	if self.count <= 2 or self.data.dsState == 1 or self.data.dsState == 2  then 
		return 
	end 
	
	local time = 0.3
	local function moveing(spr,dir )
		-- body
		spr.pos = spr.pos +dir
		if spr.pos > self.count then 
			spr.pos = spr.pos - self.count 
		elseif spr.pos<1 then 
			spr.pos = self.count + spr.pos
		end 
		local a1 = cc.MoveTo:create(time, cc.p(self.postabel[spr.pos].x,self.postabel[spr.pos].y))
		local scale = self:getScaleByPos(spr.pos)
		local a2 = cc.ScaleTo:create(time,scale)
		local a4 = cc.Spawn:create(a1,a2)
		local a3 = cc.CallFunc:create(function( ... )
			-- body
			self:RoleJianyingMoveBack(spr)
		end)
		spr:runAction(cc.Sequence:create(a4,a3))
	end
	local function callback( ... )
		-- body
		--停止动画，复位
		for i = 1 , self.count do 
			self["item"..i]:stopAllActions()
			self["item"..i]:setPosition(self.postabel[self["item"..i].pos].x,self.postabel[self["item"..i].pos].y)
		end 

		for i = 1 , self.count do  
			moveing(self["item"..i],dir/2)
		end 


	end
	self:performWithDelay(callback, 0)
	self:performWithDelay(callback, time)
end

function ContestView:onbtnXiaozuMsg( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("小组信息")
		if self.data.isReady == 1 then 
			local param = {pageIndex = 1}
			proxy.Contest:sendMyGroup(param)
			
		else
			G_TipsOfstr(res.str.CONTEST_DEC26)
		end 
	end 
end

function ContestView:onbtnBaoming( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--debugprint("报名")
		proxy.Contest:sendBaoming()
	end 
end

--奖励按钮按下
function ContestView:onimgRewardCallback( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("跳出奖励界面")
		mgr.ViewMgr:showView(_viewname.CONTEST_REWARD)

		--self:onPanleCallback(sender_,ccui.TouchEventType.ended)
	end 
end

function ContestView:onvedioCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("看看录像")
		if not self:checkVideo() then 
			return 
		end 
		--local view = mgr.ViewMgr:showView(_viewname.CONTEST_VIDEO)
		local selfroleId = cache.Player:getRoleId() 
		local param = {roleId = selfroleId,name = cache.Player:getName() }
		--printt(param)
		proxy.Contest:sendVideo(param)
		mgr.NetMgr:wait(519003)
	end 
end
--是否可以看录像
function ContestView:checkVideo( ... )
	-- body
	if self.data.dsState == 3 or self.data.dsState == 5 or 
		self.data.dsState == 7 or self.data.dsState == 9 then 
		G_TipsOfstr(res.str.CONTEST_DEC16)
		return false
	end

	return true
end

function ContestView:onbtnCaiCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--debugprint("猜猜谁赢")

		if not self:checkVideo() then 
			return 
		end 
		
		
		local data = {}
		for i = 1 , self.count do 
			local item = self["item"..i]
			if item.pos == 1 or item.pos == 2 then 
				table.insert(data,item.data) 
			end 
		end 

		if #data == 2 then 
			local view = mgr.ViewMgr:showView(_viewname.CONTEST_COMPARE)
			view:setData(data)
		else
			G_TipsOfstr(res.str.CONTEST_DEC3)
		end 
	end 
end

function ContestView:onPanleCallback(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("小组信息")
		if self.data.isReady == 1 then 
			local param = {pageIndex = 1}
			proxy.Contest:sendMyGroup(param)
			--mgr.NetMgr:wait(519002)
		else
			G_TipsOfstr(res.str.CONTEST_DEC26)
		end 
	end 
end

function ContestView:onCloseSelfView()
	-- body
	mgr.SceneMgr:getMainScene():changePageView(5)
	--G_mainView()
end


return ContestView