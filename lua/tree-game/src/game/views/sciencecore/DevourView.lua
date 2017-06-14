--
-- Author: chenlu_y
-- Date: 2015-12-12 10:37:21
-- 吞噬界面
local pet=require("game.things.PetUi")
local DevourView=class("DevourView",base.BaseView)

function DevourView:ctor()
	-- body
	self.card_mid = {}
end

function DevourView:init()
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self:initPanel1()

	self.cloneitem = self.view:getChildByName("Panel_clone")
	self.panel = self.view:getChildByName("Panel_21")

	G_FitScreen(self,"Image_bg")
end

function DevourView:initPanel1()
	local rootPanel = self.view:getChildByName("Panel_19")
	self.tipsTxt1 = rootPanel:getChildByName("Text_31") --量子力场为上阵数码兽提供属性
	local panel22 = rootPanel:getChildByName("Panel_22")
	self.tipsTxt2 = panel22:getChildByName("Text_32") --宝箱名字
	self.tipsTxt2:setString("")
	self.wancTag = panel22:getChildByName("Image_36") --完成标记
	self.wancTag:setVisible(false)
	self.baoxiang = panel22:getChildByName("Button_1") --宝箱
	self.baoxiang:addTouchEventListener(handler(self,self.onbtnBoxCall))


	self.sxTxtList = {} --key 是属性 v 是要填写的值 
	local newList = res.str.KJHX_DEC_3
	for i,v in ipairs(newList) do
		rootPanel:getChildByName("Text_33_a"..i):setString(v[2])
		self.sxTxtList[v[1]] = rootPanel:getChildByName("Text_33_b"..i)
	end

		
	
	self.armature_g = mgr.BoneLoad:loadArmature(404831,2)
	self.armature_g:setPosition(self.baoxiang:getContentSize().width/2,self.baoxiang:getContentSize().height/2)
	self.armature_g:addTo(self.baoxiang)
	self.armature_g:setVisible(false)
	self.baoxiang:reorderChild(self.armature_g, -1)


end

--点击放入单个卡牌
function DevourView:onPushCrad(sender,eventType)
	if eventType ==  ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.DEVOUR_CHOOSE)
		view:setData(self.packdata[sender.jie] or {})
	end
end

--下方单个卡牌点击
function DevourView:onOpenItem(sender,eventType)
	if eventType ==  ccui.TouchEventType.ended then
		self:setCurrShow(sender.data.id)
	end
end

function DevourView:initSpr(index)
	-- body
	self.sprlist = {}
	local colorlv = index + 3

	local size = 4
	if colorlv < 5 then
		size = 1
	end

	for i = 1 , size do 
		local item = self.cloneitem:clone()
		--加号
		item.jia = item:getChildByName("Image_63_0")
		item.jia:setTouchEnabled(true)
		item.jia:addTouchEventListener(handler(self,self.onPushCrad))
		item.jia:setVisible(false)
		self:_runBilk(item.jia,0.5)
		--名字
		item.name = item:getChildByName("Text_90")
		item.name:setString("")
		item.name:setColor(COLOR[colorlv])
		--属性
		item.pro1 = item:getChildByName("Text_91")
		item.pro2 = item:getChildByName("Text_91_0")
		item.pro1:setString("")
		item.pro2:setString("")
		--取出按钮
		item.btn = item:getChildByName("Button_5_0")
		item.btn:setVisible(false)
		item.btn:setTitleText(res.str.RES_GG_19)
		item.btn:addTouchEventListener(handler(self, self.onbtnGetOut))
		--放入一只%s兽
		item.text = item:getChildByName("Text_158")
		item.text:setString("") 
		--箭头
		item.jiantou = item:getChildByName("Image_37")
		item.jiantou:setVisible(false)

		item.tai = item:getChildByName("Image_63")

		if size ==  1 then
			item:setPosition(self.panel:getContentSize().width/2-item:getContentSize().width/2,0)
		else
			item:setPosition(item:getContentSize().width*(i-1),0)
		end
		item:addTo(self.panel)

		table.insert(self.sprlist,item)
	end

end

--设置卡牌信息
function DevourView:setData(cardList_, cardInfo_,lv )
	local newIndex = cardInfo_.showIndex 
	local tolv = cardInfo_.lv
	self.tolv = tolv
	self.newIndex = newIndex
	self.cardList = cardList_
	self.view:getChildByName("Panel_18"):getChildByName("Image_27"):loadTexture(res.kjhx.LISTITEM4[newIndex])
	self.tipsTxt1:setString(res.str.KJHX_DEC_2[newIndex])
	--卡牌信息
	self:initCradList()
	self:checkCradList()
	--
	self:initSpr(newIndex)


	self.openlv = lv
	--printt(cardList_)
	self:setCurrShow(cardList_[1][1].id)
end

function DevourView:initCradList()
	self.cloneItem = self.view:getChildByName("item")
	self.clonePanel = self.view:getChildByName("Panel_5") 

	local listView = self.view:getChildByName("Panel_20"):getChildByName("ListView_item")
	local posx ,posy = listView:getPosition()
	local ccsize =  listView:getContentSize() 

	self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.tableView:setPosition(cc.p(posx, posy))
	self.tableView:setDelegate()
	self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.view:getChildByName("Panel_20") :addChild(self.tableView,100)
	--self.tableView:setVisible(false)
	
	self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加

	self.tableView:reloadData()
end

function DevourView:numberOfCellsInTableView(iTable)
    return #self.cardList
end

function DevourView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function DevourView:tableCellAtIndex(table, idx)
    local data = self.cardList[idx+1]
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
        local widget=self.clonePanel:clone()
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        cell:addChild(widget)
        self:initEverone(data,widget)
    else
    	local widget = cell:getChildByName("widget")
        self:initEverone(data,widget)
    end
    return cell
end

function DevourView:initEverone(data,widget)
	local w = widget:getContentSize().width/6
	for i,v in ipairs(data) do
		local item =  self.cloneItem:clone()
		widget:addChild(item)
		item:setPosition((i-1)*w, 0)
		local mid = v.id
		local iconImgSrc = conf.bigGift:getIcon(mid)
		local iconFrameSrc = conf.bigGift:getFrameIcon(mid)
		local goodBtn = item:getChildByName("btn_goods_38")
		item:getChildByName("img_goods_101"):loadTexture(iconImgSrc)
		goodBtn.data = v
		goodBtn:loadTextureNormal(iconFrameSrc)
		goodBtn:addTouchEventListener(handler(self, self.onOpenItem))

		local redpoint = item:getChildByName("Image_110")
		redpoint:setVisible(false) --红点

		self.card_mid[mid] = {}
		self.card_mid[mid].redpoint = redpoint
		self.card_mid[mid].step = {}
		self.card_mid[mid].stepdi = {}
		for i = 1 , 4 do 
			local sgz = item:getChildByName("Image_103_"..i)
			sgz:setVisible(false)

			local sdi = item:getChildByName("Image_102_"..i)
			
			if i == 1 and self.newIndex == 1 then
				sgz:setContentSize(sgz:getContentSize().width*3.5,sgz:getContentSize().height)
				sdi:setContentSize(sdi:getContentSize().width*3.5,sdi:getContentSize().height)
			end
				
			table.insert(self.card_mid[mid].step,sgz)
			table.insert(self.card_mid[mid].stepdi,sdi)
		end

		self:setIteminfo(mid)
	 end
end

function DevourView:checkIsOpen( ... )
	-- body
	if tonumber(self.openlv) < tonumber(self.newIndex) or cache.Player:getLevel() < self.tolv then
		--G_TipsOfstr(res.str.RES_GG_23)
		return false
	end
	return true
end

function DevourView:onbtnBoxCall( sender,eventType )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		debugprint("宝箱领取")
		if not self.mId then
			return
		end
		--proxy.ScienceCore:send_127003({mid = self.mId}) 
		local view = mgr.ViewMgr:showView(_viewname.DEVOURREWARD)
		view:setData1(self.baoxiang.data,self.baoxiang.reward,self.newIndex,self.baoxiang:getTag())
	end
end

function DevourView:onbtnGetOut( sender,eventType )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		local data = {}
		data.richtext = res.str.RES_GG_27
		data.sure = function( ... )
			-- body
			proxy.ScienceCore:send_127004({mid = self.mId}) 
		end
		data.surestr = res.str.SURE

		data.cancel = function( ... )
			-- body
		end

		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
        return
	end
end
--一闪一闪的动画
function DevourView:_runBilk( lab,tiem )
	-- body
	local  a1=cc.FadeIn:create(tiem)
	local  a2=cc.FadeOut:create(tiem)

	local a3 = cc.DelayTime:create(tiem)
	local sequence = cc.Sequence:create(a1,a2)
	lab:runAction(cc.RepeatForever:create(sequence))
end


--设置当前显示
function DevourView:setCurrShow(cId_)
	self.armature_g:setVisible(false)
	local mId = cId_
	self.mId = mId
	local data = {mId = mId,propertys={}} 
	for k ,v in pairs(self.sprlist) do 
		if v.pet and not tolua.isnull(v.pet) then 
			v.pet:removeSelf()
			v.pet = nil 
		end
	end
	local step = cache.Science:getallStepOneByMid(mId) --当前数码兽进化到第几步
	local conf_data= conf.ScienceCore:getInfo(mId)
	self.packdata = self:getCardMjdNum(mId,conf_data.cons) --当前数码兽各个阶段 可以
	self.baoxiang.reward = conf_data.award

	self.tipsTxt2:setColor(COLOR[conf.Item:getItemQuality(self.mId)])
	for k , v in pairs(self.sprlist) do 
		data.propertys[307] = {}
		data.propertys[307].value = k - 1 
		data.propertys[310] = {}
		data.propertys[310].value = 0

		v.text:setString("")

		local node=pet.new(data.mId,data.propertys)
		node.node:setScale(res.card.petdetail)
		node:setAnchorPoint(cc.p(0.5,0))
		node:setPosition(v.tai:getContentSize().width/2,
			v.tai:getContentSize().height/2 - node:getContentSize().height*res.card.petdetail/2 )
		node:addTo(v.tai)
		node.node:setOpacity(90)

		v.pet = node

		v:reorderChild(node, 100)
		v:reorderChild(v.jia, 101)
		local name = conf.Item:getName(data.mId,data.propertys)
		v.name:setString(name)
		v.name:setColor(COLOR[conf.Item:getItemQuality(data.mId)])
			
		for i , j in pairs(conf_data.property_before[k]) do 
			local str = string.gsub(res.str.DEC_NEW_03[j[1]]," ","")
			v["pro"..i]:setString(str..j[2])
			--
			v["pro"..i]:setColor(cc.c3b(0xaf,0xac,0xac))
		end

		v.jia:setVisible(false)	
		if k < 4  and #self.sprlist~=1 then
			v.jiantou:setVisible(true)
		end
		v.jia.jie  = k
		--下一阶段
		if  k == step + 1  then
			v.jia:setVisible(true)	
			v.text:setString(string.format(res.str.RES_GG_20,name))		
		end

		--这个已经放入了
		if k <= step then 
			node.node:setOpacity(255)
			v.jia:setVisible(false)

			v.text:setString("")

			v.pro1:setColor(COLOR[2])
			v.pro2:setColor(COLOR[2])
		end
		
		--取出
		v.btn:setVisible(false)
		if step  < 5  and k == step then
			v.btn:setVisible(true)
		end

		if k == #self.sprlist then
			local str = string.format(res.str.RES_GG_24,name)
			self.tipsTxt2:setString(str)
			self.baoxiang.data = data
		end
	end
	self.baoxiang:setTag(step)
	self.baoxiang:loadTexture(res.kjhx.BOX1[self.newIndex])
	if step > 4 then
		self.baoxiang:loadTexture(res.kjhx.BOX[self.newIndex])
		self.wancTag:setVisible(true)
	else
		self.wancTag:setVisible(false)
	end

	if not self:checkIsOpen() then
		for k , v in pairs(self.sprlist) do
			v.jia:setVisible(false) 
			v.text:setString("")
		end

		for k,v in pairs(self.card_mid) do 
			v.redpoint:setVisible(false)
		end
	end

	if self.newIndex == 1 and  step > 0 and step < 5 then
		self.armature_g:setVisible(true)
	else
		if step == 4 then
			self.armature_g:setVisible(true)
		end
	end  


end
--根据服务器返回信息更新数码兽信息
function DevourView:updateCurrshow(data_)
	-- body
	self:setCurrShow(data_.mid)
	self:setIteminfo(data_.mid)
	self:checkCradList()
end


function DevourView:setIteminfo(mId)
	-- body
	local widget = self.card_mid[mId]
	if not widget then 
		return
	end
	
	widget.redpoint:setVisible(false)
	for k,v in pairs(widget.step) do 
		v:setVisible(false)
	end

	local step = cache.Science:getallStepOneByMid(mId) 
	if self.newIndex == 1 then
		if step > 0 then
			for k,v in pairs(widget.step) do 
				v:setVisible(true)
			end
			if step < 5 then
				widget.redpoint:setVisible(true)
			end
		else

			--检测有没有数码兽可以放入
			local conf_data= conf.ScienceCore:getInfo(mId)
			local packdata = self:getCardMjdNum(mId,conf_data.cons)
			if #packdata[1] > 0 then
				widget.redpoint:setVisible(true)
			end
		end

		for i = 2 , 4 do 
			widget.stepdi[i]:setVisible(false)
			widget.step[i]:setVisible(false)
		end

		
		
	else
		local pos = step > 4 and 4 or step
		for i = 1 , pos do
			widget.step[i]:setVisible(true)
		end

		local nextstep = pos + 1
		if nextstep > 4 then
			--return 
		end

		--检测有没有数码兽可以放入
		print(conf.Item:getName(mId),step)

		local conf_data= conf.ScienceCore:getInfo(mId)
		local packdata = self:getCardMjdNum(mId,conf_data.cons)
		if packdata[nextstep] and  #packdata[nextstep]>0 then
			widget.redpoint:setVisible(true)
		elseif step == 4 then
			widget.redpoint:setVisible(true) 
			--todo
		end
	end

	

end

function DevourView:checkCradList()
	--body
	local newList = res.str.KJHX_DEC_3
	for i,v in ipairs(newList) do
		self.sxTxtList[v[1]]:setString(0)
	end
	
	local t = {}
	for k ,v in pairs(self.card_mid) do 
		frist_mid = k 
		self:setIteminfo(k)	

		local step = cache.Science:getallStepOneByMid(k) 
		local pos = step > 4 and 4 or step
		if self.newIndex == 1 then
			pos = pos > 1 and 1 or pos
		end
		local conf_data= conf.ScienceCore:getInfo(k)
		if conf_data.property[pos] then
			for k , v in pairs(conf_data.property[pos]) do 
				if not t[v[1]] then
					t[v[1]] = v[2]
				else
					t[v[1]] = t[v[1]] + v[2]
				end
			end
		end
	end

	for k , v in pairs(t) do 
		if self.sxTxtList[k] then
			self.sxTxtList[k]:setString(v)
		end
	end

	
	
end

--310 进化等级     --304 等级     --307 阶数
function DevourView:getCardMjdNum(mid, cons)
	local newList = {}
	for i,vv in ipairs(cons) do
		newList[vv+1] = {}
	end
	local newDataInfo = cache.Pack:getTypePackInfo(pack_type.SPRITE)

	for k ,v in pairs(newDataInfo) do
		local p304 = v.propertys[304] and v.propertys[304].value or 1 --是否升级过
		local p310 = v.propertys[310] and v.propertys[310].value or 0 --是否进化过
		local p307 = v.propertys[307] and v.propertys[307].value or 0 --当前第几阶段
		local p317 = v.propertys[317] and v.propertys[317].value or 0 --当前是不是小伙伴
		local ppos = v.propertys[308] and v.propertys[308].value or 0 --是不是上阵的
		if v.mId == mid then
			if newList[p307+1] and ppos ==0 then --收藏的阶段相同
				if p317 == 0 and p310 == 0 and p304 == 1 then
					table.insert(newList[p307+1],v)
				end 
			end
		end
	end

	return newList
end

return DevourView