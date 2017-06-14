--[[
	DigChallengeView 挑战界面
]]

local DigChallengeView = class("DigChallengeView",base.BaseView)

function DigChallengeView:ctor()
	-- body
end

function DigChallengeView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panle_di = self.view:getChildByName("Panel_1")
	--那个描述
	local lab_dec1 = panle_di:getChildByName("Text_1")
	lab_dec1:setString(res.str.DIG_DEC6)
	--挑战
	local btn_start = panle_di:getChildByName("Button_2")
	btn_start:addTouchEventListener(handler(self,self.onbtnChallenge))
	--推荐战力
	self.lab_power = panle_di:getChildByName("Text_1_0_0_1_0")

	--3个奖励
	self.btntable = {}
	local btn1 = panle_di:getChildByName("btn_01")
	btn1.spr = btn1:getChildByName("Image_3")
	btn1.txt =  panle_di:getChildByName("Text_1_0")
	table.insert(self.btntable,btn1)

	local btn2 = panle_di:getChildByName("btn_02")
	btn2.spr = btn2:getChildByName("Image_3_5")
	btn2.txt =  panle_di:getChildByName("Text_1_0_0")
	table.insert(self.btntable,btn2)

	local btn3 = panle_di:getChildByName("btn_03")
	btn3.spr = btn3:getChildByName("Image_3_5_7")
	btn3.txt =  panle_di:getChildByName("Text_1_0_1")
	table.insert(self.btntable,btn3)

	G_FitScreen(self,"Image_1")

	--界面文本
	panle_di:getChildByName("Text_1"):setString(res.str.DIG_DEC38) 
	panle_di:getChildByName("Text_1_0_0_1_0"):setString(res.str.DIG_DEC39) 
	btn_start:getChildByName("Text_1_17_31"):setString(res.str.DIG_DEC40) 






	--self:initreward()
end
--奖励设置
function DigChallengeView:initItem()
	-- body1.1.2.100
end
--
function DigChallengeView:initreward(data_ )
	-- body
	for k , v in pairs(self.btntable) do 
		v:setVisible(false)
		v.txt:setVisible(false)
	end 

	for k , v in pairs(data_) do 
		if k > 3 then 
			break;
		end 
		local widget = self.btntable[k]
		widget:setVisible(true)
		widget.txt:setVisible(true)

		local colorlv = conf.Item:getItemQuality(v[1])
		local json = conf.Item:getItemSrcbymid(v[1]) 

		widget:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(json)

		widget.txt:setString(conf.Item:getName(v[1]) .. "x"..v[2])
	end 
end

function DigChallengeView:setData(data_)
	-- body
	self.data = data_
	--local id = data_.id --第几个关卡


	local msg = conf.Tong:getItemMsg(900100+self.data.daoId)
	self.msg = msg

	local spr = display.newSprite("res/cards/"..msg.boss_id..".png")
	spr:setPosition(display.cx,display.cy+50)
	spr:addTo(self.view)

	local rewarddata = msg.awards --奖励物品
	self:initreward(rewarddata)

	self.lab_power:setString(string.format(res.str.DIG_DEC7,msg.power))
end

function DigChallengeView:onbtnChallenge(sender_,eventtype)
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		debugprint("去战斗")
		local data = {fId =self.msg.id }
		proxy.copy:onSFight(102006,data)
	end 
end

function DigChallengeView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return DigChallengeView