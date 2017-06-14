--
-- Author: Your Name
-- Date: 2015-12-17 17:25:15
--


local FruitComposeView = class("FruitComposeView", base.BaseView)

function FruitComposeView:init(  )
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1")
	self.infoPanel = self.panel:getChildByName("Image_51")
	self.prodoctPanel = self.panel:getChildByName("Image_59")

	local panel = self.panel:getChildByName("Panel_27")
	self.costLab = panel:getChildByName("Text_59")
	self.composeBtn = panel:getChildByName("Button_14")
	self.composeBtn:addTouchEventListener(handler(self,self.gotoCompose))

	self.listView = self.panel:getChildByName("Image_59"):getChildByName("ListView_8")
	self.cloneItem = self.view:getChildByName("Panel_26")
	self.costLab = panel:getChildByName("Text_59") 
	self.nameLab = self.infoPanel:getChildByName("Text_12_28")

	self.attrList = {}
	for i=1,5 do
		local attr = self.infoPanel:getChildByTag(100 + i)
		attr:setVisible(false)
		table.insert(self.attrList ,attr)
	end



	--界面文本
	self.composeBtn:getChildByName("Text_60"):setString(res.str.FRUIT_DESC7)
	panel:getChildByName("Text_58"):setString(res.str.FRUIT_DESC8)
	

end

function FruitComposeView:setData( data )
	self.data = data
	--print(data.state .. "======state=======")
	--100010101
	local pageType = (data.id % 1000000 - data.id % 10000) / 10000--那个分页
	local step = (data.id % 10000 - data.id % 100) / 100--多少阶
	print(step.."===="..pageType)
	local nameStr = string.format(res.str.FRUIT_PAGE_TYPE[pageType],res.str.FRUIT_STEP_NUM[step])


	self.nameLab:setString(nameStr)--名称
	local fruitBtn = self.infoPanel:getChildByName("Button_12")
	local path = "res/itemicon/%s.png"
	fruitBtn:getChildByName("Image_54"):loadTexture(string.format(path, data.fruit_icon))
	fruitBtn:getChildByName("Image_54"):ignoreContentAdaptWithSize(true)
	local path = res.btn.FRAME[conf.Fruit:getFrameColor(data.id)]
	fruitBtn:loadTextureNormal(path) --品质框

	--花费
	self.costLab:setString(data.cost_jb) 

	--显示合成需要的材料
	local conditions = data.cons
	for k,v in pairs(conditions) do
		local item = self.cloneItem:clone()
		local btn = item:getChildByName("Button_13")
		local icon = btn:getChildByName("Image_63")
		local infoLab= item:getChildByName("Text_57")
		local hasLab = item:getChildByName("Text_1")

		--材料ICON
		local path = conf.Item:getItemSrcbymid(v[1],{})
		icon:loadTexture(path)
		icon:ignoreContentAdaptWithSize(true)
		--数量
		local num = cache.Material:getAmount(v[1])
		infoLab:setString("/" .. v[2])
		hasLab:setString(num)
		
		if num < v[2] then
			hasLab:setColor(cc.c3b(255,0,0))
		else
			hasLab:setColor(cc.c3b(255,255,255))
		end


		--品质框
		local fIcon =  res.btn.FRAME[conf.Item:getItemQuality(v[1])]
		btn:loadTextureNormal(fIcon)--品质框
		btn.mId = v[1]
		btn:addTouchEventListener(handler(self,self.openDetail))
		self.listView:pushBackCustomItem(item)
	end
	--判断合成状态
	if data.state == 0 then--未开启
		self.composeBtn:setEnabled(false)
		self.composeBtn:setBright(false)
	elseif data.state == 1 then--已开启未合成
		self.composeBtn:setEnabled(true)
		self.composeBtn:setBright(true)
	elseif data.state == 2 then--已合成
		self.composeBtn:setEnabled(false)
		self.composeBtn:setBright(false)
		self.composeBtn:getChildByName("Text_60"):setString(res.str.FRUIT_DESC9)
	end


	--蛋疼的加成属性
	 self.attr = {
	 att_102 = res.str.FRUIT_ATTR_DESC[1],
	 att_105 = res.str.FRUIT_ATTR_DESC[2],
	 att_103 = res.str.FRUIT_ATTR_DESC[3],
	 att_116 = res.str.FRUIT_ATTR_DESC[4],
	 att_106 = res.str.FRUIT_ATTR_DESC[5],
	 att_108 = res.str.FRUIT_ATTR_DESC[6],
	 att_110 = res.str.FRUIT_ATTR_DESC[7],
	 att_109 = res.str.FRUIT_ATTR_DESC[8],
	 att_120 = res.str.FRUIT_ATTR_DESC[9],
	 att_119 = res.str.FRUIT_ATTR_DESC[10],
	 att_107 = res.str.FRUIT_ATTR_DESC[11],
	 att_125 = res.str.FRUIT_ATTR_DESC[12],
	 att_122 = res.str.FRUIT_ATTR_DESC[13],
	 att_123 = res.str.FRUIT_ATTR_DESC[14],
	 att_124 = res.str.FRUIT_ATTR_DESC[15],
	 att_121 = res.str.FRUIT_ATTR_DESC[16],
	-- power = res.str.FRUIT_ATTR_DESC[17],
	}


	local itemData = conf.Fruit:getItemData(self.data.id)
	self.attrList[1]:getChildByTag(1001):setString(  res.str.FRUIT_ATTR_DESC[17])
	self.attrList[1]:getChildByTag(1002):setString("+"..itemData["power"])
	self.attrList[1]:setVisible(true)
	local x = 2

	table.remove(self.attr,1)
	
	--dump(itemData)
	for k,v in pairs(self.attr) do
		if itemData[k] then
			self.attrList[x]:setVisible(true)
			self.attrList[x]:getChildByTag(1001):setString(v)
			self.attrList[x]:getChildByTag(1002):setString("+"..itemData[k])
			x = x + 1
			if x > 4 then
				break
			end
		end
	end
--
end



--查看材料道具信息
function FruitComposeView:openDetail( send,etype )
	if etype == ccui.TouchEventType.ended then
		
		G_OpenMaterial({mId =  send.mId})
	end
end

--合成
function FruitComposeView:gotoCompose( send,etype )
	if etype == ccui.TouchEventType.ended then

		local items = {}
		for k,v in pairs(self.data.cons) do
			local amount = cache.Material:getAmount(v[1])
			if amount < v[2] then
				G_TipsOfstr(res.str.FRUIT_DESC14)
				return
			end
			table.insert(items, cache.Material:getItemIdx(v[1]))
		end

		--判断金币
		if cache.Fortune:getJb() < self.data.cost_jb then
			G_TipsOfstr(res.str.FRUIT_DESC15)
			return
		end


		proxy.Fruit:reqFluitCompose(self.data.id,self.data.fIdx)
	end
end






return FruitComposeView