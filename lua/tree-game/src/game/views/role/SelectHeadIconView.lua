--
-- Author: Your Name
-- Date: 2015-09-08 16:10:34
--
local SelectHeadIconView = class("SelectHeadIconView", base.BaseView)

function SelectHeadIconView:init(  )
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()
	self.panel = self.view:getChildByName("Panel_1")
	self.clonePanel = self.view:getChildByName("Panel_clone")
	self.listView = self.panel:getChildByName("ListView_3")

	self.clonePanel:getChildByName("Text_19"):setString(res.str.HEAD_TEXT1)
	self.panel:getChildByName("Text_1"):setString(res.str.HEAD_TEXT2)

	self.data = conf.head:getData()
	--self:setData()
	
end

function SelectHeadIconView:setData( data )

	for k,v in pairs(self.data) do
		if data and data["headImgs"] and data["headImgs"][v.id .. ""] then
			v.isGet = data["headImgs"][v.id .. ""]
		else
			v.isGet = 3
		end
	end

		local data1 = {}
		local data2 = {}
		local data3 = {}

		for k,v in pairs(self.data) do
			if v.isGet == 2 then
				table.insert(data1,v)
			elseif v.isGet == 1 then
				table.insert(data2,v)
			elseif v.isGet == 3 then
				table.insert(data3,v)
			end
		end

		self.data = {}
		for k,v in pairs(data1) do
			table.insert(self.data,v)
		end
		for k,v in pairs(data2) do
			table.insert(self.data,v)
		end
		
		for k,v in pairs(data3) do
			table.insert(self.data,v)
		end
		--dump(self.data)
		self:createItems()
	
end



function SelectHeadIconView:createItems(  )
	for k,v in pairs(self.data) do
		local item = self.clonePanel:clone()
		local iconView = item:getChildByName("Image_31")
		local iconFrame = item:getChildByName("Button_1")
		local btnGet = item:getChildByName("Button_get")
		local btnTitle = btnGet:getChildByName("Text_title_28")
		local descLab = item:getChildByName("Text_20")
		descLab:setString(v.desc)
		descLab:ignoreContentAdaptWithSize(false)
		descLab:setContentSize(230,50)
		descLab:setPositionY(descLab:getPositionY() - 15)
		
		--计算图片名称id
		local id = cache.Player:getRoleSex() .. string.format("%02d",v.id) 
		iconView:loadTexture("res/head/"..id..".png")
		iconFrame:setEnabled(false)

		--对默认头像图片做缩放
			iconView:setScale(0.84)
		
			-- iconView:setScale(0.84)
			-- iconView:setScaleY(1)
		
		local str
		if v.isGet == 2 then
			btnGet:setEnabled(false)
			btnGet:setBright(false)
			btnTitle:setColor(cc.c3b(127,48,10))
			str = res.str.HSUI_DESC33
		elseif v.isGet == 1 then
			btnGet:setEnabled(true)
			btnGet:setBright(true)
			btnTitle:setColor(cc.c3b(127,48,10))
			str = res.str.HSUI_DESC34
		elseif v.isGet == 3 then
			btnGet:setEnabled(false)
			btnGet:setBright(false)
			btnTitle:setColor(cc.c3b(0,0,0))
			str = res.str.HSUI_DESC35
		end
		btnTitle:setString(str)
		btnGet.hId = v.id
		btnGet:addTouchEventListener(handler(self,self.reqReplaceHead))


		self.listView:pushBackCustomItem(item)
	end
end





function SelectHeadIconView:titleStrByState( state )
	local str
	if state == 2 then
		str = res.str.HSUI_DESC33
	elseif state == 1 then
		str = res.str.HSUI_DESC34
	elseif state == 3 then
		str = res.str.HSUI_DESC35
	end

	return str
end


function SelectHeadIconView:reqReplaceHead( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		proxy.Title:reqReplaceHead(send.hId)
	end
end




function SelectHeadIconView:changeHeadSucc( )
	self:closeSelfView()
end





return SelectHeadIconView