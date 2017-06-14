--
-- Author: Your Name
-- Date: 2015-08-03 21:24:30
--

local FacialsView = class("FacialsView", base.BaseView)
local pageNum = 1
local rowNum = 4
local colNum = 8
local itemSize = 50

function FacialsView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.delegate = nil

	self.itemPanel = self.view:getChildByName("Panel_clone")
	self.panel = self.view:getChildByName("PageView")
	self.itemClone = self.view:getChildByName("Button_clone")


	--panel:addPage(page)

	local tag = 1
	for i=1,pageNum do
		page = self.itemPanel:clone()
		------------- 4 行 8 列
		--local size = self.itemPanel:getContentSize().width / colNum
		for i=1,rowNum do
			for j=1,colNum do
				local item = self.itemClone:clone()
				item:setAnchorPoint(0,1)
				item:setPosition((j-1)*itemSize + (j+1)*22,i*itemSize+i*20)
				page:addChild(item)
				item:setTag(tag+100)
				local name = string.format("%02d", tag)
				item:setName(name)
				item:loadTextureNormal(res.btn.FACIALICONPATH .. name ..".png")
				item:addTouchEventListener(handler(self,self.onFacialSelected))
				tag = tag + 1
			end
		end

		self.panel:addPage(page)

	end

end

function FacialsView:setDelegate(delegate)
	-- body
	self.delegate = delegate
end

function FacialsView:onFacialSelected(sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		--todo
		if self.delegate then
			--------------表情图片名称
			self.delegate:facialSelected(sender:getName())
		else
			print("will do nothing without set delegate")
		end

		self:closeSelfView()
	end
end







return FacialsView