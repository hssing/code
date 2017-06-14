--[[--

]]
local FigureView=class("FigureView",base.BaseView)



function FigureView:init()
	self.NowExp =5  --当前经验值
	self.lv=4
	self.exp=20
	self.showtype=view_show_type.UI
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
	self.btn_notice=self.view:getChildByTag(1):getChildByTag(1003)--公告按钮
end
function FigureView:onSetCallBack( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then

	end
end
function FigureView:initPanel1(  )
	  --等级
	self.Label_lv=self.Panel_1:getChildByTableTag(1,1)
	 --经验值
	self.Label_exp=self.Panel_1:getChildByTableTag(3,1)
	--经验值进度条
	self.LoadingBar_exp=self.Panel_1:getChildByTableTag(3,2)
	--战斗力
	self.Lable_Fight=self.Panel_1:getChildByTableTag(2,1)
	--vip
	self.Lable_vip=self.Panel_1:getChildByTableTag(4,1)
	--充值
	--self.Lable_vip=self.Panel_1:getChildByTag(4):getChildByTag(1)

	self.LoadingBar_exp:setPercent(50)
end
function FigureView:initPanel2(  )
	--钻石
	self.Lable_zs=self.Panel_2:getChildByTableTag(1,1)
	--金币
	self.Lable_gold=self.Panel_2:getChildByTableTag(1,2)
	--徽章
	self.Lable_badge=self.Panel_2:getChildByTableTag(1,3)
	--精灵次数
	self.Lable_spritenum=self.Panel_2:getChildByTableTag(2,1,1)
	--精灵下一点恢复time
	self.Lable_sprite_nexttime=self.Panel_2:getChildByTableTag(2,1,2)
	--精灵全部恢复time
	self.Lable_sprite_alltime=self.Panel_2:getChildByTableTag(2,1,3)
	--探险次数
	self.Lable_explorenum=self.Panel_2:getChildByTableTag(2,2,1)
	--探险下一点恢复time
	self.Lable_explore_nexttime=self.Panel_2:getChildByTableTag(2,2,2)
	--探险全部恢复time
	self.Lable_explore_alltime=self.Panel_2:getChildByTableTag(2,2,3)
	--探险次数
	self.Lable_hpnum=self.Panel_2:getChildByTableTag(2,2,1)
	--探险下一点恢复time
	self.Lable_hp_nexttime=self.Panel_2:getChildByTableTag(2,2,2)
	--探险全部恢复time
	self.Lable_hp_alltime=self.Panel_2:getChildByTableTag(2,2,3)

end
function FigureView:setData( data )
		self.data=data
		self.lv=lv
end
local  ConfExp={
	10,
	20,
	30,
	40,
	50,
	60,
	70,
	80,
}

--设置等级
function FigureView:setLv(lv)
	self.lv=lv
	self.Label_lv:setString(lv)
end

--设置VIP
function FigureView:seVip(vip)
	self.Lable_vip:setString(vip)
end

--设置战斗力
function FigureView:setFight(Fight)
	self.Lable_Fight=Fight
end



--设置经验
function FigureView:setExp(exp)
	self.NowExp=exp

	local max_exp=ConfExp[self.lv]

	if exp >= max_exp then
		debugprint("数据异常")
		return 
	end
	local Percent = self.NowExp / max_exp

	self.LoadingBar_exp:setPercent(Percent*100)

	self.Label_exp:setString(self.NowExp.."/"..max_exp)
end

function FigureView:initPanel3(  )
	--进入公会
	self.Button_getinto=self.Panel_2:getChildByTag(2):getChildByTag(3):getChildByTag(1)
end


return FigureView
