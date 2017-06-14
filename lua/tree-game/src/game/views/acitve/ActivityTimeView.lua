local ActivityTimeView=class("ActivityTimeView", base.BaseView)

function ActivityTimeView:init( )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--主面板
	self.Panel1 = self.view:getChildByName("Panel_1") 

	self.listView = self.Panel1:getChildByName("ListView_1")
	self.decclone = self.Panel1:getChildByName("Panel_2")
	
end

function ActivityTimeView:setData( )
	-- body
	local data = conf.active:getConfLimitAcitive()
	
	for i,v in pairs(data) do
		local widget = self.decclone:clone()
		local image = widget:getChildByName("Image_2")
		image:getChildByName("Text_3_0"):setString(v.title)
		image:getChildByName("Text_3_1"):setString(res.str.ACT2_LIMIT_DESC1)
		image:getChildByName("Text_3_2"):setString(v.time)
		image:getChildByName("Text_3_3"):setString(res.str.ACT2_LIMIT_DESC2)
		image:getChildByName("Text_3_4"):setString(v.content1)
		image:getChildByName("Text_3_5"):setString(v.content2)
		self.listView:pushBackCustomItem(widget)
	end
	self.decclone:setVisible(false)

	--界面文本
	self.Panel1:getChildByName("Image_70"):getChildByName("Text_32_2"):setString(res.str.ACT2_LIMIT_DESC3)

	local data = conf.active:getConfItem(3013)
	--dump(data)
	
	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		--string.format(res.str.ACT2_AWARD_RANK_DESC8,self.lotteryNum)
		view:updateData(self:onFormat(data),"")
		view:updateTitleData(res.str.ACT2_LIMIT_DESC4)
	end
end



function ActivityTimeView:onFormat( data )
	-- body
	tab1=os.date("*t",data.startTime)
	local endT = data.startTime + data.endDay*24*60*60
	tab2=os.date("*t",endT)
	return string.format(res.str.ACT2_LIMIT_DESC5, tab1.month, tab1.day, 0,  tab2.month, tab2.day, 0)
end

return ActivityTimeView