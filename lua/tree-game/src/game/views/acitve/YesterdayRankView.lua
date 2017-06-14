--
-- Author: Your Name
-- Date: 2015-11-23 16:52:53
--

local YesterdayRankView = class("YesterdayRankView", base.BaseView)


function YesterdayRankView:init(  )
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1")
	self.listview = self.panel:getChildByName("ListView")
	self.cloneItem = self.view:getChildByName("Panel_item")




	--界面文本
	self.panel:getChildByName("Text_12"):setString(res.str.OPEN_ACT_PRAISE_DESC2)
	self.panel:getChildByName("Text_12_0_1"):setString(res.str.OPEN_ACT_PRAISE_DESC3)
	self.panel:getChildByName("Text_12_0"):setString(res.str.OPEN_ACT_PRAISE_DESC4)
	self.panel:getChildByName("Text_12_0_0"):setString(res.str.OPEN_ACT_PRAISE_DESC5)


	--self:setData()

end

function YesterdayRankView:setData( data )
	local list = data.preList
	for i=1,#list - 1 do
		for j= i + 1,#list do
			if list[i].index > list[j].index then
				list[i],list[j] = list[j],list[i]
			end
		end
	end




	for i=1,#list do
		local item = self.cloneItem:clone()
		local iconPanel = item:getChildByName("Panel_12")
		local nameLab = item:getChildByName("Text_16")
		local czLab = item:getChildByName("Text_17")
		local fhLab = item:getChildByName("Text_17_0")

		nameLab:setString(list[i].roleName)
		czLab:setString(list[i].czZs)
		fhLab:setString(list[i].dianZan)
		
		if list[i].index < 4 then
			local icon = "res/views/ui_res/icon/icon_rank%d.png"
			--rank:loadTexture(string.format(icon, qmthList[i].index) )
			local rank = ccui.ImageView:create(string.format(icon, list[i].index) )
			iconPanel:addChild(rank)
			rank:setPosition(iconPanel:getContentSize().width / 2, iconPanel:getContentSize().height / 2)
			rank:setScale(0.8)
		elseif list[i].index < 10 then
			local fontName = res.font.FLOAT_NUM[3]
			local geWei = list[i].index % 10
			local geImg = cc.LabelAtlas:_create(geWei ,fontName,30,41,string.byte("."))
			iconPanel:addChild(geImg)
			geImg:setAnchorPoint(0.5,0.5)
			geImg:setScale(0.8)
			geImg:setPosition(iconPanel:getContentSize().width / 2, iconPanel:getContentSize().height / 2)

		else
			local fontName = res.font.FLOAT_NUM[3]
			local tenWei = math.floor(list[i].index / 10) 
			local geWei = list[i].index % 10
			local tenImg = cc.LabelAtlas:_create(tenWei ,fontName,30,41,string.byte("."))
			local geImg = cc.LabelAtlas:_create(geWei ,fontName,30,41,string.byte("."))
			iconPanel:addChild(tenImg)
			iconPanel:addChild(geImg)
			tenImg:setAnchorPoint(0.5,0.5)
			geImg:setAnchorPoint(0.5,0.5)
			geImg:setScale(0.8)
			tenImg:setScale(0.8)
			tenImg:setPosition(iconPanel:getContentSize().width / 2 - 9, iconPanel:getContentSize().height / 2)
			geImg:setPosition(iconPanel:getContentSize().width / 2 + 9, iconPanel:getContentSize().height / 2)

		end

		self.listview:pushBackCustomItem(item)
	end

end









return YesterdayRankView