--[[
	芯片兑换
]]
local CrossXinDuiView = class("CrossXinDuiView", base.BaseView)
function CrossXinDuiView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.listview = self.view:getChildByName("ListView_1")
	self.cloneitem = self.view:getChildByName("Panel_7")

	local toppanle = self.view:getChildByName("Panel_2")
	self.toppanle = toppanle

	self.lab_fen = self.toppanle:getChildByName("Text_1")

	local btn =  toppanle:getChildByName("Button_8")
	btn:addTouchEventListener(handler(self, self.onbtnclose))

	self:initDec()
	self:initListView()

	G_FitScreen(self,"Image_1")
end

function CrossXinDuiView:initDec()
	-- body
	self.lab_fen:setString(res.str.RES_RES_13.."0")
	self.toppanle:getChildByName("Text_1_0"):setString(res.str.RES_RES_14)
end

function CrossXinDuiView:setData()
	-- body
	self.data = cache.Cross:getSpNum()
	self.lab_fen:setString(res.str.RES_RES_13..self.data)
end

function CrossXinDuiView:onOpenItem( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(send.mId)
	end
end

function CrossXinDuiView:initListView()
	-- body
	local _t = conf.Cross:getAllItem()
	table.sort(_t,function(a,b)
		-- body
		return a.id < b.id
	end)

	for k ,v in pairs(_t) do
		local widget = self.cloneitem:clone()
		self.listview:pushBackCustomItem(widget)

		local colorlv = conf.Item:getItemQuality(v.fw_id)
		local framePath = res.btn.FRAME[colorlv]

		local btnframe = widget:getChildByName("Button_frame")
		btnframe:loadTextureNormal(framePath)
		btnframe.mId = v.fw_id
		btnframe:addTouchEventListener(handler(self,self.onOpenItem))

		local json = conf.Item:getItemSrcbymid(v.fw_id)
		local spr = btnframe:getChildByName("Image_22_33")
		spr:ignoreContentAdaptWithSize(true)
		spr:loadTexture(json)

		local lab_name = widget:getChildByName("Image_zb_bg"):getChildByName("Text_name_30")
		lab_name:setString(conf.Item:getName(v.fw_id))

		local lab_use = widget:getChildByName("Text_33")
		lab_use:setString(v.cost)

		local IconStar = widget:getChildByName("Panel_star")
		local starpath=res.image.STAR
		local size=colorlv
		local iconheight=IconStar:getContentSize().height
		local iconwidth=IconStar:getContentSize().width
		for i=1,size do
			local sprite=display.newSprite(starpath)
			sprite:setPosition(sprite:getContentSize().width/2+sprite:getContentSize().width*(i-1),iconheight/2)
			IconStar:addChild(sprite)
		end

		local btn = widget:getChildByName("Button_Using")
		btn.id = v.id
		btn:setTitleText(res.str.RES_RES_15)
		btn:addTouchEventListener(handler(self,self.onbtnDuihuan))
	end
end

function CrossXinDuiView:onbtnDuihuan( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local data = {dhId = sender.id}
		proxy.Cross:send_122006(data)
	end 
end


function CrossXinDuiView:onbtnclose( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function CrossXinDuiView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossXinDuiView
