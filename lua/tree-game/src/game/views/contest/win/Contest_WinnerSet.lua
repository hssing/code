--[[
	点赞设置
]]

local Contest_WinnerSet = class("Contest_WinnerSet",base.BaseView)

function Contest_WinnerSet:init()
	-- body
	self.ShowAll = true
	self.ShowBottom = true
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_2")

	local btn = panle:getChildByName("Button_close")
	btn:addTouchEventListener(handler(self, self.closeview))

	local btn_guize = panle:getChildByName("Button_7_0")
	btn_guize:addTouchEventListener(handler(self, self.onBtnGuize))

	self.btnlist = {}
	local btn = panle:getChildByName("Button_1")
	btn:setTag(1)
	table.insert(self.btnlist,btn)
	local btn = panle:getChildByName("Button_1_0")
	btn:setTag(2)
	table.insert(self.btnlist,btn)
	local btn = panle:getChildByName("Button_1_1")
	btn:setTag(3)
	table.insert(self.btnlist,btn)

	for k ,v in pairs(self.btnlist) do 
		v:addTouchEventListener(handler(self, self.onbtnImgsetCallBack))
	end 
	self:clear()
	self.lab_tian = panle:getChildByName("Text_7")

	local _lab = panle:getChildByName("Image_1"):getChildByName("Text_7_0_2_0_13_0")
	_lab:setString(res.str.CONTEST_DEC43)


	--界面文本
	self.lab_tian:setString(string.format(res.str.CONTEST_TEXT21, 1,5))
	panle:getChildByName("Image_1"):getChildByName("Text_7_0_2_0_13_0"):setString(res.str.CONTEST_TEXT22)



end

--界面信息初始化
function Contest_WinnerSet:clear()
	-- body
	self.conf_data = {}
	for i = 1 , 3 do  
		table.insert(self.conf_data,conf.Contest:getItemByIndex(i))
	end 


	for k , v in pairs(self.btnlist) do 
		local data = self.conf_data[k]
		local txt = v:getChildByTag(2)
		txt:setString(res.str["CONTEST_DEC_"..k.."_1"])
		txt:setColor(cc.c3b(127,48,10)) --颜色
		txt:setFontSize(28) --字体大小
	end 

end

function Contest_WinnerSet:getMaxDay()
	-- body
	local max = 1 
	local status = 0
	for k ,v in pairs(self.data.awards) do 
		if tostring(k) ~= "_size" then 
			if v ~= 0 then 
				if tonumber(k) >= tonumber(max) then 
					max = k
					status = v 
				end 
			end 
		end 
	end 
	return tonumber(max) , tonumber(status)
end

function Contest_WinnerSet:setData(index)
	-- body
	if index then 
		local data = self.conf_data[index].reward
		local t = {}
		for k , v in pairs(data) do 
			local tt = {mId = v[1] , amount = v[2] ,propertys = {}}
			table.insert(t,tt)
		end 

		--弹出获得界面
		local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if not view then
			view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
			view:setData(t,false,true)
			view:setButtonVisible(false)
		end
	end 

	self.data = cache.Contest:getSetMsg()
	self.day , self.status = self:getMaxDay()
	print("self.day , self.status ="..self.day , self.status)
	
	self.setday = self.day
	if self.day == 5 then
		--self.lab_tian:setString(string.fo self.setday.."/5") 
	else
		if self.status == 0 then 
			--self.lab_tian:setString(self.setday.."/5") 
		else
			self.setday = self.setday + 1 
			--self.lab_tian:setString(self.setday.."/5") 
		end 
	end 
	self.lab_tian:setString(string.format(res.str.CONTEST_DEC41,self.setday))

end

function Contest_WinnerSet:onbtnImgsetCallBack( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("那个点击"..send:getTag())
		if 5 == self.day and self.status ~= 0 then  --都设置了
			G_TipsOfstr(res.str.CONTEST_DEC40)
			return 
		end 
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_WIN_SET_SECOND)
		view:setData(send:getTag(),self.setday)
	end 
end

function Contest_WinnerSet:onBtnGuize(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("规则")
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(5)
	end 
end

function Contest_WinnerSet:closeview(send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function Contest_WinnerSet:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Contest_WinnerSet