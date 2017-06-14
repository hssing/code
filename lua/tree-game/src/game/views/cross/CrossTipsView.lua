--[[
	跨服战段位提升
]]

local CrossTipsView = class("CrossTipsView", base.BaseTipsView)

function CrossTipsView:ctor()

end
function CrossTipsView:init(  )
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()

	self.panle = self.view:getChildByName("Panel") 
	self.panle:setTouchEnabled(false)
	self.panle:addTouchEventListener(handler(self, self.onpanlecloseView))

	self:initDec()
end

function CrossTipsView:initDec()
	self.panle:getChildByName("Text_1"):setString(res.str.RES_RES_41)
	self.lab_dec = self.panle:getChildByName("Text_1_0")
	self.lab_dec:setString("")
	self.img = self.panle:getChildByName("Image_7") 
end

function CrossTipsView:setData(data)
	-- body
	self.data = data
	self.lab_dec:setString(data.richtext)

	local id = math.ceil(data.dw/5) 
	if data.dw > 20 then
		id =  5 + data.dw%5
	end
	self.img:loadTexture(res.icon.DW[id])

	self:performWithDelay(function( ... )
		-- body
		self.panle:setTouchEnabled(true)
	end, 2.0)
end

function CrossTipsView:onpanlecloseView( send_ ,event_type )
	-- body
	if event_type == ccui.TouchEventType.ended then
		if self.data.sure then 
			self.data.sure()
		end	
		if not tolua.isnull(self) then
			self:onCloseSelfView()
		end
	end
end

function CrossTipsView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossTipsView
