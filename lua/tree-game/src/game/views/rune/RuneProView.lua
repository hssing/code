--[[
	属性介绍
]]
local RuneProView = class("RuneProView", base.BaseView)

function RuneProView:ctor()
	-- body
	self.proitem = {}
end

function RuneProView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.img1 = self.view:getChildByName("Image_1")
	local btn = self.img1:getChildByName("Button_close")
	btn:addTouchEventListener(handler(self, self.onbtnclose))

	self.item_panle = self.view:getChildByName("Panel_2")
	self.itemclone = self.view:getChildByName("Panel_3")
	
	self.listview = self.img1:getChildByName("ListView_2")

	self:initProItem()
	self:initItemDec()
	self:initListView()
end

function RuneProView:initItem( data )
	-- body
	--printt(data)

	local widget_panel = self.item_panle:clone()
	self.listview:pushBackCustomItem(widget_panel)
	for k , v in pairs(data) do 
		local widget = self.itemclone:clone()

		--widget:setAnchorPoint(cc.p(0,0))
		local dec = widget:getChildByName("Text_1")
		local value = widget:getChildByName("Text_1_0")

		dec:setString(res.str.DEC_NEW_03[v.pro])
		value:setString("+0")
		
		local pos = {}
		if k%2 == 0 then
			pos.x = widget_panel:getContentSize().width/2 
		else
			pos.x = 0
		end
		pos.y = 0 --widget_panel:getContentSize().height/2 

		widget:setPosition(pos.x,pos.y)
		widget:addTo(widget_panel)

		self.proitem[v.pro] = {}
		self.proitem[v.pro].value = value
	end
end

function RuneProView:initItemDec()
	-- body
	local widget_panel = self.item_panle:clone()
	local img = display.newSprite(res.other.RUNE_PRO)
	img:addTo(widget_panel)
	widget_panel:setContentSize(img:getContentSize().width, img:getContentSize().height)
	img:setPositionX(widget_panel:getContentSize().width/2)
	img:setPositionY(widget_panel:getContentSize().height/2)
	self.listview:pushBackCustomItem(widget_panel)

	local widget_panel = self.item_panle:clone()
	local spr_di  = display.newSprite(res.image.TITLE_DI)
	widget_panel:setContentSize(spr_di:getContentSize().width, spr_di:getContentSize().height)
	spr_di:setAnchorPoint(cc.p(0,0.5))
	spr_di:setPositionX(-5)
	spr_di:setPositionY(widget_panel:getContentSize().height/2)
	spr_di:addTo(widget_panel)

	local spr =  display.newSprite(res.font.RUNE_PRO)
	spr:setPositionX(spr_di:getContentSize().width/2)
	spr:setPositionY(spr_di:getContentSize().height/2-5)
	spr:addTo(spr_di)
	self.listview:pushBackCustomItem(widget_panel)
	--[[self.listview:pushBackCustomItem(widget_panel)
	local label = display.newTTFLabel({
	    text = res.str.DUI_DEC_64,
	    font = res.ttf[1],
	    size = 30,
	    align = cc.TEXT_ALIGNMENT_LEFT ,
	    color = self.itemclone:getChildByName("Text_1"):getColor(),
	    x = 0,
	    y = widget_panel:getContentSize().height/2,
	})
	label:setAnchorPoint(cc.p(0,0.5))
	label:addTo(widget_panel)]]--
	
end

function RuneProView:initProItem()
	-- body
	table.sort(res.str.DUI_DEC_65,function(a,b)
		-- body
		return a.sort<b.sort
	end)
	--每两个分一组
	local t = {}
	local t1 = {}
	for k ,v in pairs(res.str.DUI_DEC_65) do 
		table.insert(t,v)
		if k%2 == 0  then 
			table.insert(t1,clone(t))
			t = {}
		elseif  k == #res.str.DUI_DEC_65 then 
			table.insert(t1,clone(t))
		end 
	end 

	for k , v in pairs(t1) do 
		self:initItem(v)
	end
end

function RuneProView:initListView()
	-- bod
	for k ,v in pairs(res.str.DUI_DEC_66) do
		local str_table = string.split(v, ":")

		local label1 = display.newTTFLabel({
		    text = str_table[1]..":" or ":" ,
		    font = res.ttf[1],
		    size = 24,
		    align = cc.TEXT_ALIGNMENT_LEFT,
		})

		local widget_panel = self.item_panle:clone()
		-- 左对齐，并且多行文字顶部对齐
		local label2 = display.newTTFLabel({
		    text = str_table[2] or ""  ,
		    font = res.ttf[1],
		    size = 24,
		    --color = cc.c3b(255, 0, 0), -- 使用纯红色
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(widget_panel:getContentSize().width*0.85, 0)
		})

		widget_panel:setContentSize(widget_panel:getContentSize().width,
			label2:getContentSize().height)

		label1:setAnchorPoint(cc.p(0,1))
		label1:setPosition(10,label2:getContentSize().height)
		label1:addTo(widget_panel)


		label2:setAnchorPoint(cc.p(0,1))
		label2:setPosition(label1:getContentSize().width+10,label2:getContentSize().height)
		label2:addTo(widget_panel)
		
		self.listview:pushBackCustomItem(widget_panel)
	end
end

function RuneProView:setData(data_)
	-- body
	self.data = data_
	if not data_ then
		return 
	end
	local t = {}
	--printt(data_)
	for k , v in pairs(data_) do 
		for i , j in pairs(res.str.DUI_DEC_65) do 
			--print(j.pro)
			if v.propertys[j.pro] then
				--print("-------------------------------")
				if not t[j.pro] then
					t[j.pro] = v.propertys[j.pro].value
				else
					t[j.pro] = t[j.pro] + v.propertys[j.pro].value
				end
			end
		end
	end
	--printt(t)
	for k ,v in pairs(t) do 
		if self.proitem[k] then
			self.proitem[k].value:setString("+"..v)
		end
	end
end

function RuneProView:onbtnclose( send_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:closeSelfView()
	end
end

return RuneProView