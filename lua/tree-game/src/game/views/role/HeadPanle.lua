local HeadPanle=class("HeadPanle",function(  )
	return ccui.Widget:create()
end)



function HeadPanle:init(Parent,type)
	self.Parent=Parent
	self.id=type
	self.view=Parent:getColnePnale()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)
	self.Image_head=self.view:getChildByName("Image_2")
	--品质框 按钮
	self.BtnFrame=self.view:getChildByName("btn")
	self.BtnFrame:addTouchEventListener(handler(self,self.onCakkBackSelectHead))
	--vip字
	self.Image_vip=self.view:getChildByName("Panel_1"):getChildByName("Image_vip")
end

function HeadPanle:onCakkBackSelectHead(send,eventtype)
	if  eventtype== ccui.TouchEventType.ended then
		cache.Player:setHead(self.id)
		proxy.head:reqGetHead(self.id)
		self.Parent:closeSelfView()	
	end
end
function HeadPanle:setData(data)
	local framePath=mgr.PathMgr.getImageHeadPath(data.src)
	self.Image_head:loadTexture(framePath)

	self:setFrame(data)
	self:setLv(data.lv)
end
function HeadPanle:setFrame(data)
	self.BtnFrame:loadTextureNormal(res.btn.FRAME[data.lv])
end
--设置vip等级
function HeadPanle:setLv(lv)
	self.Image_vip:loadTexture(res.font.VIP[lv])
	--self.Image_vip:loadTexture(res.font.VIP[math.floor(lv/4)+1])
end








return HeadPanle