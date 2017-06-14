--
-- Author: Your Name
-- Date: 2016-01-04 15:54:07
--

local StrategyIntroView = class("StrategyIntroView",base.BaseView)

function StrategyIntroView:init(  )
	-- body
	self.showtype=view_show_type.TIPS
	self.view=self:addSelfView()

	local btn = self.view:getChildByName("Image_1"):getChildByName("Button_close")
	btn:addTouchEventListener(handler(self,self.onClose))

	self.itemPanelClone = self.view:getChildByName("Panel_2")
	self.itemClone = self.view:getChildByName("Panel_11")
	self.listView = self.view:getChildByName("Image_1"):getChildByName("ListView_2")


end

function StrategyIntroView:setData( index )
	self.data = conf.strategy:getProperties(index)

	--创建每个条目
	--local posy = 

	local imgFont = conf.strategy:getImgfont(index)
	
	for i,v in ipairs(self.data) do
		local height = 0
		local panel = self.itemPanelClone:clone()
		--dump(v)
		for k=1,table.nums(v) do
			local str = v[k]
			local item = self.itemClone:clone()
			local descLab = item:getChildByName("Text_4")
			descLab:setString(str)

			-- descLab:ignoreContentAdaptWithSize(false)
			-- descLab:setContentSize(item:getContentSize().width - 10,60)

			height = height + item:getContentSize().height
			panel:addChild(item)
			item:setPosition(0,panel:getContentSize().height/2)
			item:setTag(100 + k)

			
			--descLab:setContentSize(width,height)
			
		end
		local panelHead = panel:getChildByName("Panel_12")
		height = height + panelHead:getContentSize().height
		panel:setContentSize(panel:getContentSize().width,height)

		--美术字
		local img = panelHead:getChildByName("Image_9")
		img:loadTexture("res/views/ui_res/imagefont/" .. imgFont[i] .. ".png" )


		--位置设置
		panelHead:setPositionY(height - panelHead:getContentSize().height)

		local num = table.nums(v)
		for k=1, num do
			local item = panel:getChildByTag(100 + k)
			if item then
				local itemPre = panel:getChildByTag(100 + k - 1)
				local posy = 0
				if itemPre then
					posy = itemPre:getPositionY() -  item:getContentSize().height
				else
					posy = panelHead:getPositionY() - item:getContentSize().height
				end

				item:setPosition(0, posy)
				posy = posy - item:getPositionY()
			end
		end


		self.listView:pushBackCustomItem(panel)

	end


end

function StrategyIntroView:onClose( send,eType )
	if eType == ccui.TouchEventType.ended then
		self:closeSelfView()
	end
end






return StrategyIntroView