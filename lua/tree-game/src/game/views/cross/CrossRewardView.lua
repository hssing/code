--[[
	王者之战奖励
]]
local CrossRewardView = class("CrossRewardView", base.BaseView)

function CrossRewardView:init()
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	G_FitScreen(self, "Image_1")


	self.listview = self.view:getChildByName("ListView_2")
	self.item = self.view:getChildByName("Panel_79")

	self.btnreward =  self.view:getChildByName("Button_24")

	self:initDec()
end

function CrossRewardView:initDec()
	-- body
	self.btnreward:setTitleText(res.str.RES_RES_26) 

	local lab = self.view:getChildByName("Image_14"):getChildByName("Text_11")
	lab:setString(res.str.RES_RES_27)
end

--专属称号
function CrossRewardView:initFirstItem(  )
	-- body
	local item= self.item:clone()

	local posx = 0 
	local posy = 0
	local w = 0
	for k ,v in pairs(item:getChildren()) do 
		if v:getName() == "Image_221_0" then 
		elseif v:getName() == "Image_221" then
			posx = v:getPositionX()  
			posy = v:getPositionY()
			w = v:getContentSize().width
		elseif v:getName() == "AtlasLabel_3" then 
		elseif v:getName() == "Image_213" then
		else
			v:setVisible(false)
		end
	end 

	local imgdi = display.newSprite(res.btn.ROLE_FRAME[1])
	imgdi:setPosition(posx + w + 25,posy)
	imgdi:addTo(item)


	local sex = cache.Player:getRoleSex()
	--local conf_data = conf.head:getItem(12)
	local str = sex..string.format("%02d",12)
	local img = display.newSprite("res/head/"..str..".png")
	img:setScale(0.8)
	img:setPosition(imgdi:getContentSize().width/2,imgdi:getContentSize().height/2)
	img:addTo(imgdi)

	posx = posx + img:getContentSize().width + 150 
	--专属称号
	--[[local label = display.newTTFLabel({
	    text = res.str.RES_RES_28,
	    font = res.ttf[1],
	    size = 24,
	    align = cc.TEXT_ALIGNMENT_LEFT,
	    color = COLOR[1], -- cc.c3b(R,G,B)
	})]]--
	local label = display.newSprite(res.font.CROSS_CH_LAB)

	posx = posx + 50
	label:setAnchorPoint(cc.p(0.5,0.5))
	label:setPositionX(posx+20)
	label:setPositionY(posy - 30)
	label:addTo(item)

	--驯兽师之王
	local _img = display.newSprite(res.font.CROSS_CH)
	_img:setAnchorPoint(cc.p(0.5,0.5))
	_img:setPositionX(posx+20)
	_img:setPositionY(posy + 20)
	_img:addTo(item)
	self.listview:pushBackCustomItem(item)
end
function CrossRewardView:initItem(item,v)
	-- body
	local img_rank = item:getChildByName("Image_221_0")
	img_rank:setVisible(false)

	local lab_rank = item:getChildByName("Text_186_2")
	lab_rank:setString(v.name)

	local lab_rank_1 = item:getChildByName("AtlasLabel_3")
	--local lab_rank_2 = item:getChildByName("AtlasLabel_3")
	lab_rank_1:setVisible(false)
	if v.id < 3 then 
		img_rank:setVisible(true)
		lab_rank:setVisible(false)
		img_rank:loadTexture(res.icon.RANK[v.id])
		local num
		if v.id == 1  then 
			num = cc.LabelAtlas:_create("1",res.font.FLOAT_NUM[5],31,38,string.byte("."))
		else
			num = cc.LabelAtlas:_create("2",res.font.FLOAT_NUM[6],19,21,string.byte("."))
		end 
		
        num:setAnchorPoint(0.5,0.5)
        num:setPosition(lab_rank_1:getPosition())
        num:addTo(item)
	end 
	

	local _img = item:getChildByName("Image_221")
	if v.id == 16 then 
		_img:setVisible(false)
		lab_rank:setFontSize(24)
	end 

	
	local img_reward = {}
	local t = {}
	local btn1 = item:getChildByName("Button_97")
	local spr = btn1:getChildByName("Image_216")
	local _txt = item:getChildByName("Text_186")
	t.btnframe = btn1
	t.spr = spr
	t.txt = _txt
	table.insert(img_reward,t)
	local t = {}
	local btn1 = item:getChildByName("Button_97_0")
	local spr = btn1:getChildByName("Image_216_218")
	local _txt = item:getChildByName("Text_186_0")
	t.btnframe = btn1
	t.spr = spr
	t.txt = _txt
	table.insert(img_reward,t)
	
	local t = {}
	local btn1 = item:getChildByName("Button_97_1")
	local spr = btn1:getChildByName("Image_216_220")
	local _txt = item:getChildByName("Text_186_1")
	t.btnframe = btn1
	t.spr = spr
	t.txt = _txt
	table.insert(img_reward,t)

	for k ,v in pairs (img_reward) do 
		v.btnframe:setVisible(false)
		v.spr:setVisible(false)
		v.txt:setVisible(false)
	end 

	local sysreward = v.items
	--printt(sysreward)

	--for k ,v in pairs(sysreward) do 
	for i = #sysreward , 1 ,-1 do 
		local v = sysreward[i]
		local colorlv = conf.Item:getItemQuality(v[1])
		local name = conf.Item:getName(v[1]).."x"..v[2]
		local path = conf.Item:getItemSrcbymid(v[1])

		local widget = img_reward[#sysreward - i +1]
		widget.btnframe:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.btnframe:setVisible(true)
		widget.btnframe:setTag(v[1])
		widget.btnframe:addTouchEventListener(handler(self, self.onOpenItem))

		widget.spr:setVisible(true)
		widget.spr:loadTexture(path)

		widget.txt:setVisible(true)
		widget.txt:setString(name)
		widget.txt:setColor(COLOR[colorlv])
	end 
end

function CrossRewardView:onOpenItem( send_ ,event_type )
	-- body
	if event_type == ccui.TouchEventType.ended then
		local mId = send_:getTag()
		G_openItem(mId)
	end
end

function CrossRewardView:setData()
	-- body
	self.data = conf.Cross:getAllItemaward()

	table.sort(self.data,function( a,b )
		-- body
		return a.id < b.id
	end)

	self:initFirstItem()

	for k, v in pairs(self.data) do 
		local item= self.item:clone()
		self:initItem(item,v)
		self.listview:pushBackCustomItem(item)
	end 
end

function CrossRewardView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossRewardView
