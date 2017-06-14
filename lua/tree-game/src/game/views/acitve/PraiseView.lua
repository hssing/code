--
-- Author: Your Name
-- Date: 2015-10-26 11:22:32
--


local PraiseView = class("PraiseView_tw", base.BaseView)

function PraiseView:init( )
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_5"):getChildByName("Panel_6")
	self.descLab = self.panel:getChildByName("Text_7")
	self.praseBtn = self.panel:getChildByName("Button_3")

	self.praseBtn.state = 1
	self.praseBtn:addTouchEventListener(handler(self,self.praiseBtnCallback))


	
	--界面固定文本
	self.descLab:setString(res.str.ACTIVE_TEXT38)
	self:setData()
end

function PraiseView:setData(  )
	-- body
	local data = conf.Praise:getData()
	self.data = data["1"]["awards"]
	self:createItems()
end

function PraiseView:createItems(  )
	for i=1,table.nums(self.data) do
		local tag = 100 + i
		local item = self.panel:getChildByTag(tag)
		local icon = item:getChildByName("Image_" .. tag)
		local name = item:getChildByName("Text_"..tag)

		local mid = self.data[i][1]
		local count = self.data[i][2]
		local color = conf.Item:getItemQuality(mid)
		local iconPath = res.btn["FRAME"][color]
		local imgpath = conf.Item:getItemSrcbymid(mid)

		item:loadTextureNormal(iconPath)
		icon:loadTexture(imgpath)
		name:setString(conf.Item:getName(mid) .. "x" .. count )
		name:setColor(COLOR[color])

		item.mid = mid
		item:addTouchEventListener(handler(self,self.openItem))

	end
end

function PraiseView:openItem( send,eventType  )
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

function PraiseView:praiseBtnCallback( send,eventType )
	if eventType == ccui.TouchEventType.ended then
		sdk:thumb()
		debugprint("点赞")

	end
end








return PraiseView