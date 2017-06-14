--
-- Author: Your Name
-- Date: 2015-10-24 14:44:22
--


local InvitateAwardView = class("InvitateAwardView", base.BaseView)
local bit = require("bit")

function InvitateAwardView:init( )
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.clonePanel = self.view:getChildByName("Item_Panel")
	self.itemClone =  self.view:getChildByName("item")

	self.listView = self.view:getChildByName("Panel_1"):getChildByName("ListView_3")
end

function InvitateAwardView:setData( count,sign )
	self.data = conf.Invitate:getData()
	self.count = count
	self.sign = sign

	self:createItems()
end

function InvitateAwardView:createItems( )
	for i=1,table.nums(self.data) do
		local awards = self.data[i].items
		local panel = self.clonePanel:clone()
		for j=1,table.nums(awards) do
			local item = self.itemClone:clone()
			local name = item:getChildByName("text_goods_39")
			local frame = item:getChildByName("btn_goods_8")
			local img = item:getChildByName("img_goods_25")
			local mid = awards[j][1]
			local count = awards[j][2]
			local color = conf.Item:getItemQuality(mid)
			local iconPath = res.btn["FRAME"][color]
			local imgpath = conf.Item:getItemSrcbymid(mid)

			name:setString(conf.Item:getName(mid) .. "x" .. count ) 
			name:setColor(COLOR[color])
			frame:loadTextureNormal(iconPath)
			img:loadTexture(imgpath)

			local x = (j - 1) * item:getContentSize().width+ 10
			local y = 10
			item:setPosition(x,y)

			frame.mid = mid
			frame:addTouchEventListener(handler(self,self.openItem))

			panel:addChild(item)
		end

		local descLab = panel:getChildByName("Text_31_31")
		local currCount =  panel:getChildByName("Text_32_35")
		local total =  panel:getChildByName("Text_33_37")
		local btn = panel:getChildByName("Button_get_6")
		btn:setVisible(false)
		btn:setEnabled(false)

		if i == 1 then
			descLab:setString(string.format(res.str.ACTIVE_TEXT37, 1)) 
			total:setString("/"..1)
			if bit._and(self.sign, bit.lshift(1,1)) > 0 then
				btn:setVisible(true)
				descLab:setVisible(false)
				total:setVisible(false)
				currCount:setVisible(false)
			end
		elseif i == 2 then
			descLab:setString(string.format(res.str.ACTIVE_TEXT37, 3)) 
			total:setString("/"..3)
			if bit._and(self.sign, bit.lshift(1,3)) > 0 then
				btn:setVisible(true)
				descLab:setVisible(false)
				total:setVisible(false)
				currCount:setVisible(false)
			end
		elseif i == 3 then
			descLab:setString(string.format(res.str.ACTIVE_TEXT37, 5)) 
			total:setString("/"..5)
			if bit._and(self.sign, bit.lshift(1,5)) > 0 then
				btn:setVisible(true)
				descLab:setVisible(false)
				total:setVisible(false)
				currCount:setVisible(false)
			end
		elseif i == 4 then
			descLab:setString(string.format(res.str.ACTIVE_TEXT37, 10)) 
			total:setString("/"..10)
			if bit._and(self.sign, bit.lshift(1,10)) > 0 then
				btn:setVisible(true)
				descLab:setVisible(false)
				total:setVisible(false)
				currCount:setVisible(false)
			end
		end
		currCount:setString(self.count)

		self.listView:pushBackCustomItem(panel)
	end

	-- && 》0 --已
	-- &&==0 & 》count --可领取
end


function InvitateAwardView:openItem( send,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then

		local data = {}
			data.mId = send.mid
		local itype=conf.Item:getType(data.mId)
		if itype ==  pack_type.PRO then
			G_openItem(data.mId)
		elseif itype  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		else	
			G_OpenCard(data,true)
		end

	end
end








return InvitateAwardView