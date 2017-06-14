--
-- Author: Your Name
-- Date: 2015-09-08 15:20:47
--
local TitleView = class("TitleView", base.BaseView)


function TitleView:init(  )
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1")
	self.clonePanel = self.view:getChildByName("Panel_clone")
	self.listView = self.panel:getChildByName("ListView_3")


	self.clonePanel:getChildByName("Text_19"):setString(res.str.HEAD_TEXT1)

	self.data = conf.Title:getData()
	--self:test()
end

function TitleView:setData( data )
	--self.data = data
	for k,v in pairs(self.data) do
		if data and data["titles"] and data["titles"][v.id .. ""] then
			v.isGet = data["titles"][v.id .. ""]
		else
			v.isGet = 3
		end
	end

	local data1 = {}
	local data2 = {}
	local data3 = {}

	for k,v in pairs(self.data) do
		if v.isGet == 1 then
			table.insert(data1,v)
		elseif v.isGet == 2 then
			table.insert(data2,v)
		elseif v.isGet == 3 then
			table.insert(data3,v)
		end
	end

	self.data = {}

	for k,v in pairs(data2) do
		table.insert(self.data,v)
	end
	for k,v in pairs(data1) do
		table.insert(self.data,v)
	end
	for k,v in pairs(data3) do
		table.insert(self.data,v)
	end


	self:createItems()
end

function TitleView:createItems(  )
	--dump(self.data)
	for i=1,#self.data do
		local item = self.clonePanel:clone()
		local titleIcon = item:getChildByName("Image_31")
		local originLab = item:getChildByName("Text_19")
		local originDescLab = item:getChildByName("Text_20")
		local getBtn = item:getChildByName("Button_get")
		local getBtnTitle = getBtn:getChildByName("Text_title_28")

		titleIcon:loadTexture(conf.Title:getIcon(self.data[i]["id"]))--称号图标
		originDescLab:setString(self.data[i]["desc"])--称号来源

		if self.data[i]["isGet"] == 1 then
			getBtnTitle:setString(res.str.HSUI_DESC36)
			getBtnTitle:setColor(cc.c3b(127,48,10))
			getBtn:setBright(true)
			getBtn:setEnabled(true)
		elseif self.data[i]["isGet"] == 2 then
			getBtnTitle:setString(res.str.HSUI_DESC37)
			getBtn:setBright(false)
			getBtn:setEnabled(false)
			getBtnTitle:setColor(cc.c3b(127,48,10))
		else
			getBtnTitle:setString(res.str.HSUI_DESC35)
			getBtn:setBright(false)
			getBtn:setEnabled(false)
			getBtnTitle:setColor(cc.c3b(0,0,0))
		end

		getBtn:addTouchEventListener(handler(self,self.onGetBtnClick))
		getBtn.id = self.data[i].id

		if  self.data[i]["isGet"] == 3 and self.data[i]["show"] == 0 then
		
		else
			self.listView:pushBackCustomItem(item)
		end
		
	end
end

function TitleView:onGetBtnClick( send,etype )
	if etype == ccui.TouchEventType.ended then
		proxy.Title:reqReplaceTitle(send.id)
	end
end

function TitleView:changeTileSucc(  )
	G_TipsOfstr(res.str.TITLE_TIPS1)
	self:closeSelfView()
end

function TitleView:test(  )
	print("===============TitleView:test=====================")

	c = coroutine.create(function (  )
		
		print("egwerhgo3hemhioeih")
	end)


	print("===============TitleView:test=====================",coroutine.resume(c))
end



return TitleView