local GuizeView = class("GuizeView",base.BaseView)



function GuizeView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.panle = self.view:getChildByName("Panel_2")

	--[[self._List = {}
	--宠物进化规则
	local p1 = self.view:getChildByName("Panel_2")
	p1:setVisible(false)
	table.insert(self._List,p1)
	--合成规则
	local p2 = self.view:getChildByName("Panel_3")
	p2:setVisible(false)
	table.insert(self._List,p2)
	--竞技场规则
	local p3 = self.view:getChildByName("Panel_5")
	p3:setVisible(false)
	table.insert(self._List,p3)
	--装备退化
	local p4 = self.view:getChildByName("Panel_5_0")
	p4:setVisible(false)
	table.insert(self._List,p4)
	--祈福规则
	local p5 = self.view:getChildByName("Panel_5_0_0_0") 
	p5:setVisible(false)
	table.insert(self._List,p5)
	--卡牌退化
	local p6 = self.view:getChildByName("Panel_5_0_0")
	p6:setVisible(false)
	table.insert(self._List,p6)
	--公会副本规则
	local p7 = self.view:getChildByName("Panel_5_1")
	p7:setVisible(false)
	table.insert(self._List,p7)
	--驯兽师之王的规则
	local p8 = self.view:getChildByName("Panel_5_0_0_0_0")
	p8:setVisible(false)
	table.insert(self._List,p8)
	--点赞规则
	local p9 = self.view:getChildByName("Panel_5_0_1")
	p9:setVisible(false)
	table.insert(self._List,p9)
	--数码大赛规则
	local p10 = self.view:getChildByName("Panel_5_0_2")
	p10:setVisible(false)
	table.insert(self._List,p10)]]--
end

function GuizeView:showByName( name_ )
	-- body
	local _table = conf.Guize:getTextById(name_)

	local pos = {x = 5 ,y = self.panle:getContentSize().height - 5 }
	for k ,v in pairs(_table) do 
		local label = display.newTTFLabel({
		    text = k.."、"..string.gsub(v,"=",":"),
		    font = res.ttf[1],
		    size = 24,
		    color = cc.c3b(45, 236, 253), -- 使用纯红色
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(self.panle:getContentSize().width*0.96, 0)
		})
		label:setAnchorPoint(cc.p(0,1))
		label:setPositionX(pos.x)
		label:setPositionY(pos.y)
		label:addTo(self.panle)

		pos.y = pos.y - label:getContentSize().height - 10 
	end 

	--[[for k, v in pairs(self._List) do
		if v:getName() == name_ then 
			v:setVisible(true)
		end	
	end	]]--
end

return GuizeView