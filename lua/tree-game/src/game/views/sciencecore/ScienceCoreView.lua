--
-- Author: chenlu_y
-- Date: 2015-12-12 10:33:05
-- 科技核心主界面 

local ScienceCoreView=class("ScienceCoreView",base.BaseView)

function ScienceCoreView:init()
	self.currCradVal = {}
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	G_FitScreen(self,"Image_bg")

	self:initPanel1()
	self:initPanel2()

	local panel4 = self.view:getChildByName("Image_bg"):getChildByName("Panel_4")
	self.panel4 = panel4
	self.itemImg = panel4:getChildByName("Sprite_15")
	self.posx = self.itemImg:getPositionX()
	self.posy = self.itemImg:getPositionY()
	panel4:addTouchEventListener(handler(self, self.onOpenDevourView))

	local btn_guzi = self.view:getChildByName("Panel_1"):getChildByName("Button_1")
	btn_guzi:addTouchEventListener(handler(self, self.onBtnGuize))

	self.openlv = 1 --默认只开发了紫色一下的
	self:palyForever()

	self.maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if self.maintoplayerview and  not tolua.isnull(self.maintoplayerview) then
		self.maintoplayerview:setVisible(false)
	end
end

--规则
function ScienceCoreView:onBtnGuize(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(20)
	end 
end

function ScienceCoreView:palyForever()
	-- body
	local bg = self.view:getChildByName("Image_bg")
	local armature = mgr.BoneLoad:loadArmature(404860,0)
    armature:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2)
    armature:setName("armature")
    armature:addTo(bg)

	local armature = mgr.BoneLoad:loadArmature(404860,1)
    armature:setPosition(self.itemImg:getContentSize().width/2,self.itemImg:getContentSize().height/2)
    armature:setName("armature")
    armature:addTo(self.itemImg)
    self.armature = armature
end
--
function ScienceCoreView:initPanel1()
	local panel1 = self.view:getChildByName("Panel_1")
	self.listView= panel1:getChildByName("ListView_1_2")
	self.clonepanel = self.view:getChildByName("item_0")
	self.listView:setItemsMargin(15) --间距

	self:initListView()
end

function ScienceCoreView:initPanel2()
	local panel2 = self.view:getChildByName("Panel_2")
	self.img_txt1 = panel2:getChildByName("Image_141_0")
	self.img_txt2 = panel2:getChildByName("Image_141")

	self.progressBar = panel2:getChildByName("zLoadingBar_exp")
	self.progressTxt = panel2:getChildByName("Text_exp")
	self.tipsDecTxt = panel2:getChildByName("Text_129")
	self.tipsdeclv = panel2:getChildByName("Text_129_0")
	self.baoxBtn = panel2:getChildByName("Button_35")
	self.baoxBtn:ignoreContentAdaptWithSize(false)
	self.baoxBtn:addTouchEventListener(handler(self, self.onBxClick))
	panel2:getChildByName("Text_130"):setString(res.str.KJHX_DEC_1)
	self.progressBar:setPercent(0)
end

function ScienceCoreView:initListView()
	if self.itemList == nil then
		self.itemList = {}
		local awardList = conf.ScienceCore:getAwardConfig()
		local length = table.nums(awardList)
		for i=1,length do
			local widget = self.clonepanel:clone()
			widget:getChildByName("btn_goods_3_17"):loadTextureNormal(res.btn["FRAME"][i+3])
			widget:getChildByName("img_goods_17_58"):loadTexture(res.kjhx.LISTITEM2[i])
			widget:setSwallowTouches(false)
			widget.data = awardList[i..""]
			widget:setTouchEnabled(true)
			widget:addTouchEventListener(handler(self,self.onChangeItem))
			self.listView:pushBackCustomItem(widget)

			self.itemList[i] = widget
		end
	end
end 

function ScienceCoreView:setArmature(index)
	-- body
	--self.armature:setVisible(false)
	self.armature:stopAllActions()
    self.itemImg:stopAllActions()
    self.itemImg:setPosition(self.posx,self.posy)
    self.armature:setPosition(self.itemImg:getContentSize().width/2,self.itemImg:getContentSize().height/2)

	self.armature:getAnimation():playWithIndex(index)
	local pos = {x = 0,y = 0}
	if tonumber(index) == 1 then
	elseif tonumber(index) == 2 then
		--pos.x = 0
		--pos.y = 22
	elseif tonumber(index) == 3 then
	else
		--pos.x = -25
		--pos.y = 30
	end
	self.armature:setPosition(self.armature:getPositionX()+pos.x,self.armature:getPositionY()+pos.y)

    if self.suo1 and not tolua.isnull(self.suo1) then
		self.suo1:removeSelf()
		self.suo1 = nil 
	end

	if self.suo2 and not tolua.isnull(self.suo2) then
		self.suo2:removeSelf()
		self.suo2 = nil 
	end

	self.armature:setVisible(true)
    if self.openlv < index then
    	self.armature:setVisible(false)
    	self.suo1 = display.newSprite(res.kjhx.SUO[1])
    	self.suo1:setPosition(self.itemImg:getContentSize().width/2,self.itemImg:getContentSize().height/2)
    	self.suo1:addTo(self.itemImg)

    	self.suo2 = display.newSprite(res.kjhx.SUO[2])
    	self.suo2:setPosition(self.panel4:getContentSize().width/2,self.panel4:getContentSize().height/2)
    	self.suo2:addTo(self.panel4)

    	self.panel4:reorderChild(self.suo2, 100)
    	self.panel4:reorderChild(self.itemImg, 200)
    else
    	self.armature:setVisible(true)

    	local a1 = cc.MoveBy:create(3,cc.p(0,20))
    	local a2 = cc.MoveBy:create(3,cc.p(0,-20))
    	local sequence = cc.Sequence:create(a1,a2)
    	local a3 = cc.RepeatForever:create(sequence)
    	self.armature:runAction(a3)
    	self.itemImg:runAction(a3)
    end 
end

function ScienceCoreView:onChangeItem(sender,eventType)
	if eventType ==  ccui.TouchEventType.ended then
		--[[local params =  {id=404835, x =pwidget:getContentSize().width/2,
		y = pwidget:getContentSize().height/2,addTo = pwidget,addName = "effofname"}
		mgr.effect:playEffect(params)]]--
		if self.choosearmature and not tolua.isnull(self.choosearmature) then
			self.choosearmature:removeSelf()
			self.choosearmature = nil 
		end

		local btn = sender:getChildByName("btn_goods_3_17") 

		local armature = mgr.BoneLoad:loadArmature(404835,0)
    	armature:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
    	armature:addTo(btn)

    	self.choosearmature = armature

		local newData = sender.data
		local newIndex = newData.id
		self.awardData = newData.award
		self.currCradVal.showIndex = newIndex
		self.currCradVal.lv = newData.lv 
		self.tipsdeclv:setString(string.format(res.str.RES_GG_81,newData.lv))
		self.tipsDecTxt:setString(newData.dec)

		if newData.lv <= 1 then
			self.img_txt1:setVisible(false)
			self.img_txt2:setVisible(false)
			self.tipsdeclv:setString("")
			self.tipsDecTxt:setString("")
		else
			self.img_txt1:setVisible(true)
			self.img_txt2:setVisible(true)
		end

		--self:setSjProgress(newData.id, newData.total_exp) --进度条
		local str = checkint(self.data.starExp[newIndex..""]*100/newData.total_exp)
		self.progressTxt:setString(str.."%")
		self.progressBar:setPercent(str)
		self.itemImg:setTexture(res.kjhx.LISTITEM3[newIndex]) --宝箱
		self:setArmature(newIndex)

		self.baoxBtn:loadTexture(res.kjhx.BOX1[newIndex])
		if self.data.starSign[self.currCradVal.showIndex..""] > 0 then
			self.baoxBtn:loadTexture(res.kjhx.BOX[newIndex])
		end

		if self.armature_box then
			self.armature_box:removeSelf()
			self.armature_box = nil 
		end
		if self.awardData then
			local i = 0 -- 0 不能领取，1 可领取 2领取了
			if self.data.starSign[self.currCradVal.showIndex..""] > 0 then --2领取了
			elseif self.progressBar:getPercent() == 100 then
				self.armature_box =  mgr.BoneLoad:loadArmature(404831,2)
				self.armature_box:setPosition(self.baoxBtn:getContentSize().width/2,self.baoxBtn:getContentSize().height/2)
				self.armature_box:addTo(self.baoxBtn,-1)
			end
		end
		
	end
end

--打开吞噬窗口
function ScienceCoreView:onOpenDevourView(sender,eventType)
	if eventType ==  ccui.TouchEventType.ended then
		print(self.openlv,self.currCradVal.showIndex)
		--if tonumber(self.openlv) < tonumber(self.currCradVal.showIndex) then
			--G_TipsOfstr(res.str.RES_GG_23)
			--return
		--end

		--self.purpleCardList = {}
		--self.yellowCardList = {}
		--self.redCardList = {}
		--self.goldenCardList = {}

		mgr.ViewMgr:showView(_viewname.DEVOUR)
		local view = mgr.ViewMgr:get(_viewname.DEVOUR)
		if view then 
			local newList
			local newIndex = self.currCradVal.showIndex
			if newIndex == 1 then
				newList = self.purpleCardList
			elseif newIndex == 2 then
				newList = self.yellowCardList
			elseif newIndex == 3 then
				newList = self.redCardList
			elseif newIndex == 4 then
				newList = self.goldenCardList
			end

			table.sort(newList,function( a,b )
				-- body
				return a.id < b.id
			end)

			--每6个一组
			local nn = 6
			local newList2 = {}
   			local maxVal = math.ceil(#newList/nn)
   			for j=1, maxVal do
   				local newList3 = {}
   				local minNum = (j-1)*nn+1
   				local maxNum = minNum+nn-1
   				for i,v in ipairs(newList) do
    				if i >= minNum and i <= maxNum then
    					table.insert(newList3, v)
    				end
    			end
   				table.insert(newList2, newList3)
   			end

			view:setData(newList2, self.currCradVal,self.openlv)
		end
	end
end

--宝箱点击
function ScienceCoreView:onBxClick(sender,eventType)
	if eventType ==  ccui.TouchEventType.ended then
		if self.awardData then
			mgr.ViewMgr:showView(_viewname.DEVOURREWARD)
			local view = mgr.ViewMgr:get(_viewname.DEVOURREWARD)

			--self.currCradVal.showIndex
			local i = 0 -- 0 不能领取，1 可领取 2领取了
			if self.data.starSign[self.currCradVal.showIndex..""] > 0 then
				i = 2
			elseif self.progressBar:getPercent() == 100 then
				i = 1
			end
			if view then 
				view:setData(self.currCradVal.showIndex,i,self.awardData)
			end
		end
	end
end
--检测打开到第几个了
function ScienceCoreView:checkOpen()
	-- body
	local t = {}
	for k ,v in pairs(self.data.starExp) do 
		local key = checkint(k)
		if key > 0 then
			t[key] = v 
		end
	end

	for k , v in pairs(t) do
		local key = checkint(k)
		if key > 0 then
			local confdata = conf.ScienceCore:getAwardInfo(key)
			if tonumber(v) > 0 and cache.Player:getLevel() >= confdata.lv then
				self.openlv = key
			end
			
			local confdata_2 = conf.ScienceCore:getAwardInfo(key+1)
			if not confdata_2 then 
				confdata_2 = confdata
			end
			if self.openlv == tonumber(key) and tonumber(v) >= tonumber(confdata.total_exp) and cache.Player:getLevel() >= confdata_2.lv then
				self.openlv = key + 1 
			end
		end
	end

	print(self.openlv)
end

function ScienceCoreView:setData(data_)
	self.data = data_
	self:checkOpen()
	self:setAllCard()
	for k ,v in pairs(self.itemList) do
		if self.openlv >= k then
			v.tag = 1 --开启
			v:getChildByName("Image_144"):setVisible(false)
			v:getChildByName("img_goods_17_58"):loadTexture(res.kjhx.LISTITEM1[k])
		else
			v.tag = 2 --未开启
			v:getChildByName("Image_144"):setVisible(true)
		end
	end

	self:onChangeItem(self.itemList[1], ccui.TouchEventType.ended)
end

function ScienceCoreView:setAllCard()
	-- body
	self.purpleCardList = {}
	self.yellowCardList = {}
	self.redCardList = {}
	self.goldenCardList = {}
	local allCard = conf.ScienceCore:getMainConfig()
	for k ,v in pairs(allCard) do 
		local color = conf.Item:getItemQuality(v.id)
		if color < 5 then
			table.insert(self.purpleCardList,v)
		elseif color < 6 then
			table.insert(self.yellowCardList,v)
		elseif color < 7 then
			table.insert(self.redCardList,v)
		else
			table.insert(self.goldenCardList,v)
		end

	end

end

function ScienceCoreView:onCloseSelfView()
	-- body
	if self.maintoplayerview and  not tolua.isnull(self.maintoplayerview) then
		self.maintoplayerview:setVisible(true)
	end
	self:closeSelfView()
end

return ScienceCoreView