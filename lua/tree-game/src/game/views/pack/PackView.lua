local PackView=class("PackView",base.BaseView)


function PackView:ctor( ... )
	-- body
	self.equipClick =false
	self.cardClick =false
end


function PackView:init()
	self.ShowAll=true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.ListGUIButton={}  --GUI按钮容器
	local size=5 
	
	 self.topList = self.view:getChildByName("ListView_1")
	local cloneBtn = self.view:getChildByName("Button_2")
	for i=1,size do
		self.topList:pushBackCustomItem(cloneBtn:clone())
	end



	for i=1,size do
		--local btn=self.view:getChildByTableTag(1,i)
		local btn=self.topList:getItem(i - 1)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

		gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放

		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end
	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end
	--
	self.ListView=self.view:getChildByName("ListView")
	self.ListView:setTouchEnabled(false)
	--listView item
	self.clonePnale=self.view:getChildByName("Panel_Clone") --克隆对象

	local bg=self.view:getChildByName("bg_2")
	--某一类型 道具总数量
	self.Num=bg:getChildByName("Text_Num")
	--图鉴按钮
	local Btn_Pokedex=bg:getChildByName("Button")
	Btn_Pokedex:addTouchEventListener(handler(self,self.onPokedexButtonCallBack))
	self.packindex=1
	--背包数据
	self:setData(cache.Pack:getPackInfo())

	-- local Panel_1 = self.view:getChildByName("Panel_1")
	 self.view:reorderChild(self.topList,500)
	
    self.pageindex = 1
	self:selectpage(self.pageindex)

    G_FitScreen(self,"bg_factory")

	self:performWithDelay(function()
		-- body
		local effConfig = conf.Effect:getInfoById(404084)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
			
		end)
	end, 0.1)	

	self:initDec()

end

function PackView:initDec()
	-- body
	self.view:getChildByName("bg_2"):getChildByName("Button"):setTitleText(res.str.PACK_DEC_01)
	self.view:getChildByName("bg_2"):getChildByName("Text_1"):setString(res.str.PACK_DEC_02)

	local Panel_1 = self.view:getChildByName("Panel_1")
	self.topList:getItem(0):setTitleText(res.str.PACK_DEC_03)
	self.topList:getItem(1):setTitleText(res.str.PACK_DEC_04)
	self.topList:getItem(2):setTitleText(res.str.PACK_DEC_05)
	self.topList:getItem(3):setTitleText(res.str.DEC_NEW_01)
	self.topList:getItem(4):setTitleText(res.str.PACK_DEC_09)
end

function PackView:numberOfCellsInTableView(table)
	-- body
	local size=#self.ListViewItemData[self.packindex]
    return size
end

function PackView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
   self.offex = view:getContentOffset()
end

function PackView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function PackView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function PackView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePnale:getContentSize()    
    return ccsize.height+5,ccsize.width
end

function PackView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.ListViewItemData[self.packindex][idx+1]
    --print("strValue = " .. strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.pack.PackPanle")
        --[[if self.packindex  > 3 then 
        	widget=CreateClass("views.pack.runePanle")
        else
        	widget=CreateClass("views.pack.PackPanle")
        end   ]]--   

		widget:init(self)
		if self.packindex  == 5 then
			widget:setData(data)
			
		elseif self.packindex  > 3 then
			widget:setDataFw(data)
		else
			widget:setData(data)
		end
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
    	if self.packindex  == 5 then
			widget:setData(data)
       	elseif self.packindex  > 3 then
			widget:setDataFw(data)
		else
			widget:setData(data)
		end
    end
    return cell
end

function PackView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.ListView:getPosition()
		local ccsize =  self.ListView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView,100)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView:reloadData()
	    --self:loadInRunAction()
	else
		self.tableView:reloadData()
		--self:loadInRunAction()
	end 


end


function PackView:keepOffset( hehe )
	-- body
	self.movepos = clone(self.offex) 
end

function PackView:scrolltoindex(idx)
	-- body
	local num = math.ceil(self.ListView:getContentSize().height/self.clonePnale:getContentSize().height)
	local y  = self.clonePnale:getContentSize().height*num  - self.tableView:getContentSize().height

	if self.movepos then
		--self.tableView:setContentOffset(self.movepos)
		if self.movepos.y > y then
			self.tableView:setContentOffset(self.movepos)
		else
			self.tableView:setContentOffset(cc.p(self.movepos.x,y))
		end
	end
	--[[if self.idx then 
		local num = math.ceil(self.ListView:getContentSize().height/self.clonePnale:getContentSize().height)
		if  idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (idx+1) * self.clonePnale:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		self.tableView:setContentOffset(offset)
	end ]]--
end

--item 出现动画 弃用
function PackView:loadInRunAction( )
	local size=7

	local time = 0.2
	local starX=-400
	local offset = 200
	local moveItem_={}
	
	for i=1,size do
		local item=self.tableView:cellAtIndex(i-1)
		if item  then
			item:setPositionX(starX-i*offset)
			moveItem_[#moveItem_+1]=item
		end
	end
	local item_size=#moveItem_
	if item_size > 0 then
		for i=1,item_size do
			local act1=cc.MoveTo:create(time,cc.p(0,moveItem_[i]:getPositionY()))
			local act2=cc.CallFunc:create(function ( ... )
				if i == item_size then
					--self:setTouchEnabled(false) 
				end 
				end)
			local seq=cc.Sequence:create(act1,act2)
			moveItem_[i]:runAction(seq)
		end 
	end
end
--清除标示 新物品标示
function PackView:onCloseHandler()
	for k,v in pairs(self.data) do
		for k1,v1 in pairs(v) do
			if  k == 2 then 
				v1.new = nil
			elseif k == 1 and self.equipClick then 
				v1.new = nil
			elseif k == 3 and self.cardClick  then 
				v1.new = nil
			elseif k == 4 then 
				v1.new = nil
			end 
		end
	end
	for k ,v in pairs(self.ListViewItemData[4]) do
		v.new = nil 
	end
	for k ,v in pairs(self.ListViewItemData[5]) do
		v.new = nil
	end
	--cache.Material:init()
	self.super.onCloseHandler(self)
end

---
function PackView:initDta( )
	-- body
	self.ListViewItemData={}
	self.ListViewItemData[1]={} --宠物装备
	self.ListViewItemData[2]={} -- 道具
	self.ListViewItemData[3]={} -- 卡牌
	self.ListViewItemData[4]={} -- 命格
	self.ListViewItemData[5]={} -- 材料 

	self.newCoutFordata1 = 0 --宠物新装备数量
	self.newCoutFordata4 = 0 --人物新装备数量
	self.newCoutFordata5 = 0
end


function PackView:setData(data)
	self:initDta()
	self.data=data
	self:packSort(self.data)
end

function PackView:initPageData( page )
	--果实合成材料
	self.ListViewItemData[5]={} -- 材料 
	local material = cache.Material:getMaterialData()
	if material then 
		for k ,v in pairs(material) do
			if v.new  then 
				self.newCoutFordata5 = self.newCoutFordata5 + 1
			end	
			--v.propertys = vector2table(v.propertys,"type")
			table.insert(self.ListViewItemData[5],v)
		end
	end
	--NEW_ITEM_APCK_AMOUNT[5] = 0
	--dump(self.ListViewItemData[5])
	--材料
	self:itemSort(self.ListViewItemData[5])

end


--蛋疼的排序
function PackView:packSort( data )
	for k,v in pairs(data) do
		for k1,v1 in pairs(v) do
			v1.sort = conf.Item:getSort(v1.mId)
			if k == 1 then  --装备类型
				--print("v1.sort "..v1.sort)
				if v1.sort == 0 then --人物装备
					--if v1.new  then 
					--	self.newCoutFordata4 = self.newCoutFordata4 + 1
					--end
					--table.insert(self.ListViewItemData[4],v1)
				else
					if v1.new then 
						self.newCoutFordata1 = self.newCoutFordata1 + 1
					end 
					table.insert(self.ListViewItemData[1],v1)
				end
			else
				table.insert(self.ListViewItemData[k],v1)
			end	
		end
	end
	--符文信息
	local info = cache.Rune:getUseinfo()

	if info then
		for k ,v in pairs(info) do
			--v.propertys = vector2table(v.propertys,"type")
			table.insert(self.ListViewItemData[4],v)
		end
	end 

	local info1 = cache.Rune:getPackinfo()

	if info1 then 
		for k ,v in pairs(info1) do
			if v.new  then 
				self.newCoutFordata4 = self.newCoutFordata4 + 1
			end	
			--v.propertys = vector2table(v.propertys,"type")
			table.insert(self.ListViewItemData[4],v)
		end
	end

	--果实合成材料
	local material = cache.Material:getMaterialData()
	self.ListViewItemData[5] = {}
	if material then 
		for k ,v in pairs(material) do
			if v.new  then 
				self.newCoutFordata5 = self.newCoutFordata5 + 1
			end	
			--v.propertys = vector2table(v.propertys,"type")
			table.insert(self.ListViewItemData[5],v)
		end
	end


	--装备添加
	--print("-------------------------------------------")
	local Equipmentdata = cache.Equipment:getEquitpmentDataInfo()
	for k,v in pairs(Equipmentdata) do
		--olditemlist[1][#olditemlist[1]+1]=v
		table.insert(self.ListViewItemData[1],v)
	end
	--装备
	self:equipmentSort(self.ListViewItemData[1])
	--self:equipmentSort(self.ListViewItemData[4])
	----道具
	self:itemSort(self.ListViewItemData[2])
	--卡牌
	self:spriteSort(self.ListViewItemData[3])
	--符文
	self:runeSort(self.ListViewItemData[4])
	--材料
	--dump(self.ListViewItemData[5])
	self:itemSort(self.ListViewItemData[5])

end

function PackView:runeSort(itemdata)
	-- body
	table.sort( itemdata, function ( a,b )
		-- body
		local anew = a.new and 0 or 1
		local bnew = b.new and 0 or 1

		--品质
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		local alv = a.propertys[304] and a.propertys[304].value

		local blv = b.propertys[304] and b.propertys[304].value

		--是否穿戴
		local awear = a.index >=600000 and 0 or 1 
		local bwear = b.index >=600000 and 0 or 1 

		if anew == bnew then
			if awear == bwear then
				if acolor == bcolor then 
					if alv == blv then
						return a.mId<b.mId
					else
						return alv > blv
					end
				else
					return acolor>bcolor
				end
			else
				return awear < bwear
			end	
		else
			return anew < bnew
		end

		--[[if anew == bnew then 
			if a.sort == b.sort then 
				if acolor == bcolor then 
					return a.mId<b.mId
				else
					return acolor>bcolor
				end
			else
				return a.sort < b.sort
			end
		else
			return anew < bnew
		end	]]--
	end )
end


--物品排序
function PackView:itemSort( itemdata )
	table.sort( itemdata, function ( a,b )
		-- body
		local anew = a.new and 0 or 1
		local bnew = b.new and 0 or 1

		--品质
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		if anew == bnew then 
			if a.sort == b.sort then 
				if acolor == bcolor then 
					return a.mId<b.mId
				else
					return acolor>bcolor
				end
			else
				return a.sort < b.sort
			end
		else
			return anew < bnew
		end	
	end )
end
--装备排序
function PackView:equipmentSort( equipmentdata )
	--已经装备的物品
	table.sort(equipmentdata,function (a,b)
		-- body
		--是否新物品
		local anew = a.new and 0 or 1
		local bnew = b.new and 0 or 1
		--是否穿戴
		local awear = a.index >=400000 and 0 or 1 -->4000表示已经装备
		local bwear = b.index >=400000 and 0 or 1 
		--部位
		local apart = conf.Item:getItemPart(a.mId)
		local bpart = conf.Item:getItemPart(b.mId)
		--品质
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		if a.new == b.new then 
			 if awear  == bwear then  --穿戴在前
			 	if apart == bpart then --部位排序
			 		if acolor == bcolor then --品质高的在前
			 			return a.mId<b.mId
			 		else
			 			return acolor>bcolor
			 		end
			 	else
			 		return apart<bpart
			 	end
			 	--[[if a.sort == b.sort then 

			 	else
			 		return a.sort<b.sort --配置表 人的装备在前 宠物的装备在后
			 	end]]--
			 else
			 	return awear<bwear
			 end
		else
			return anew < bnew --新装备在前
		end
	end)

end
--精灵排序
function PackView:spriteSort( spritetdata,isNew)

	table.sort( spritetdata, function(a,b)
		-- body
		--是否新物品
		local anew = a.new == true and 0 or 1
		local bnew = b.new == true and 0 or 1

		--是否上阵
		local apos = conf.Item:getBattleProperty(a) 
		apos = apos ==0 and apos or -1  
		local bpos =  conf.Item:getBattleProperty(b) 
		bpos = bpos ==0 and bpos or -1 
		--品质
		local acolor =  conf.Item:getItemQuality(a.mId)
		local bcolor =  conf.Item:getItemQuality(b.mId)

		if anew == bnew then 
			if apos == bpos   then 
				if acolor == bcolor then 
					return a.mId<b.mId
				else
					return acolor>bcolor
				end
			else
				return apos<bpos
			end
		else
			return anew<bnew
		end	
	end )
end

function PackView:updateUi()
	local ItemTye={2,1,3,4,5} --分别代表道具  装备  精灵 ,人物装备
	self:initAllPanle(ItemTye[self.packindex])
end
function PackView:initAllPanle(type)
	local ItemTye={2,1,3,4,5} --分别代表道具  装备  精灵  材料
	type=ItemTye[type]
	self.packindex=type
	self:inittableView()
	--[[self.lv:removeAllItems()
	self.lv:onCleanup()--释放所有的空闲列表项
	self.lv:reload()]]--


	
	NEW_ITEM_APCK_AMOUNT[type]=0
	if type == 1 then 
		self.equipClick = true 
		self.newCoutFordata1 = 0
	elseif 4 == type then 
		self.newCoutFordata4 = 0
	elseif type == 3  then
		--todo
		self.cardClick = true 
	end


	self.Num:setString(#self.ListViewItemData[type])
	for i=1,#self.ListGUIButton do
		--self.ListGUIButton[i]:setNumber(NEW_ITEM_APCK_AMOUNT[ItemTye[i]]) 
		if i== 2 then
			
			self.ListGUIButton[i]:setNumber(self.newCoutFordata1)
		elseif i== 4  then
		 	--todo i == 4 then 

		 	self.ListGUIButton[i]:setNumber(self.newCoutFordata4)
		 	
		else
			self.ListGUIButton[i]:setNumber(NEW_ITEM_APCK_AMOUNT[ItemTye[i]])
		end
	end

	--self:loadInRunAction()
end
function PackView:onCloseSelfView()
	G_mainView()
	--mgr.SceneMgr:getMainScene():changeView(1)
end
function PackView:getColnePnale( )
	return self.clonePnale:clone()
end
--图鉴回调
function PackView:onPokedexButtonCallBack(index,eventype)
	if eventype == ccui.TouchEventType.ended then
		--self:loadInRunAction()

		local view = mgr.ViewMgr:showView(_viewname.PACK_MAP)
		if self.pageindex==1 then 
			view:pageviewChange(1)
		elseif self.pageindex==2 then  
			view:pageviewChange(3)
		elseif self.pageindex==3 then 
			view:pageviewChange(2)
		elseif self.pageindex==4 then 
			view:pageviewChange(4)
		elseif self.pageindex==5 then
			view:pageviewChange(5)
		end 
	end
end
--按钮位置变动
function PackView:changePageBtnpos( index )
	-- body
	local  posy = self.ListGUIButton[1]:getInstance():getPositionY()
	local posy2 = self.ListGUIButton[2]:getInstance():getPositionY()
	local posy = math.max(posy,posy2)
	for i = 1 , 4 do 
		self.ListGUIButton[i]:getInstance():setPositionY(posy)
		if i == index then 
			self.ListGUIButton[i]:getInstance():setPositionY(posy-10)
		end
	end 
end

function PackView:onPageButtonCallBack(index,eventype)
	if eventype == ccui.TouchEventType.ended then
		self.pageindex = index
		self:setTouchEnabled(true)
		--self:changePageBtnpos(index)
		if index == 5 then--材料
			--self.tableView:removeAllItems()
			--没有缓存，请求网络数据
			local data = cache.Material:getMaterialData()
			if cache.Material.isFirst then
				proxy.Radio:reqMaterialInfo(1)--没法知道哪些是新的
				return self
			end
			self.ListViewItemData[5] = data
			self:itemSort(self.ListViewItemData[5])
			--dump(self.ListViewItemData[5])
			--return self
		end

		self:initAllPanle(index)
		return self
	end
end

function PackView:selectpage( idnex  )
	-- body
	self.pageindex = idnex
	self.PageButton:initClick(idnex)
end



return PackView