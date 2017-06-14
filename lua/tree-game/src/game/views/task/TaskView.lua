--[[
	任务
]]

local TaskView=class("TaskView",base.BaseView)

function TaskView:init(  )
	-- body
	
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.ListGUIButton={}  --GUI按钮容器
	for i = 1 , 3 do 
		local btn=self.view:getChildByTableTag(1,i)
		if i == 2 then 
			btn:setVisible(false)
		end 
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})
		gui_btn:getInstance():setPressedActionEnabled(false) -- 默认点击会缩放
		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end	

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end

	self.clonePanle = self.view:getChildByName("Panel_Clone")

	self.ListView = self.view:getChildByName("ListView")

	self.down = self.view:getChildByName("Image_13")
	local Panel_1 = self.view:getChildByName("Panel_1")
	self.view:reorderChild(self.down,500)
	self.view:reorderChild(Panel_1,500)

	self.ListView:setTouchEnabled(false)
	self.panle_huoyue = self.view:getChildByName("Panel_14")

	self.panelshop = self.view:getChildByName("Panel_33")
	self.panelshop:setVisible(false)
	self.panelshop:getChildByName("Text_124"):setString(res.str.CONTEST_TEXT1)
	self.lab_time =  self.panelshop:getChildByName("Text_124_0")
	self.lab_time:setString("")
	local Image_174 = self.panelshop:getChildByName("Image_174")
	Image_174:getChildByName("Text_127"):setString(res.str.RES_GG_77)
	self.lab_hy  = Image_174:getChildByName("Text_127_0")
	self.lab_hy:setString("")

	local btn_shua = Image_174:getChildByName("Button_40")
	btn_shua:addTouchEventListener(handler(self, self.onbtnquick))
	btn_shua:setTitleText(res.str.RES_GG_78)

	local lab_dec = Image_174:getChildByName("Text_127_0_0")
	lab_dec:setString(res.str.RES_GG_79)
	self.lab_cost = Image_174:getChildByName("Text_127_0_0_0")
	self.lab_cost:setString("")

	self.otherline = self.view:getChildByName("other_line_3")

	self.shopclone = self.view:getChildByName("Panel_4")

	self.packindex = 1 
	
	self:setRedPoint()

	if res.banshu then 
		self.view:getChildByTableTag(1,2):setVisible(false)
	end 

	self:initDec()
	--self:initlistView()
	--self:pagebtninit(self.packindex)
	self.PageButton:initClick(self.packindex)

	self:schedule(self.schedulerlastTime,1.0,"schedulerlastTime")
end

function TaskView:setOnlyPageIndex(index)
	-- bod
	self.packindex = index or 1
	self.PageButton:initClick(self.packindex)
end

function TaskView:setCallBack()
	-- body
	if self.packindex ~= 3 then
		self:setData()
		self:initAllPanle()
	end
end

function TaskView:schedulerlastTime( ... )
	-- body
	if self.packindex ~=3 then
		return
	end

	if not self.data then
		return 
	end

	self.data.lastTime = self.data.lastTime  - 1

	if self.data.lastTime <= 0 and not self.request then
		self.request = true
		proxy.task:send_105004({mType = 1})
		return 
	elseif self.data.lastTime <= 0 then
		self.lab_time:setString("")
	end

	self.lab_time:setString(string.formatNumberToTimeString(self.data.lastTime))

end

function TaskView:initDec()
	-- body
	self.view:getChildByTableTag(1,1):setTitleText(res.str.TASK_DEC_01)
	self.view:getChildByTableTag(1,2):setTitleText(res.str.TASK_DEC_02)
	self.view:getChildByTableTag(1,3):setTitleText(res.str.RES_GG_39)
end


--设置
function TaskView:setRedPoint()
	-- bodylocal num=0
	debugprint("任务完成个数设置")
	local num= self.count and self.count or 0
	num = num + cache.Player:getGetTaskHy()
	if num >= 0 then 
		self.ListGUIButton[1]:setNumber(num)
	end
end

function TaskView:numberOfCellsInTableView(table)
	-- body
	local size = #self.ListViewItemData[self.packindex]
    return size
end

function TaskView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function TaskView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function TaskView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function TaskView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanle:getContentSize()    
    return ccsize.height,ccsize.width
end

function TaskView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.ListViewItemData[self.packindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        cell.index = idx
        widget=CreateClass("views.task.taskItem")      
		widget:init(self)
		widget:setData(data)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data)
    end

    return cell
end

function TaskView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.ListView:getPosition()
		local ccsize =  self.ListView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self:addChild(self.tableView,100)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView:reloadData()	
	end 
	self.tableView:reloadData()
end

function TaskView:initDta( )
	-- body
	self.ListViewItemData={}
	self.ListViewItemData[1] = {};--日常任务
	self.ListViewItemData[2]={}--公会任务
	self.count = 0

end

function TaskView:setData()
	-- body
	self.max_all = 0
	self:initDta()
	local data   = cache.Taskinfo:getTask()
	--printt(data)
	if data then
		for k,v in pairs(data) do
			--print(v)
			self.max_all = self.max_all + conf.task:getDayHy(v.taskId)
			if v.is_get == 1 then 
				self.count = self.count + 1
			end
			table.insert(self.ListViewItemData[1] ,v)
		end
	end
	self:setRedPoint()
	local function _sort( a,b )
		-- body
		local ais_get = a.is_get == 1 and -1 or a.is_get
		local bis_get = b.is_get == 1 and -1 or b.is_get
		
		if ais_get == bis_get then 
			if a.pass == b.pass then 
				return a.taskId<b.taskId
			else
				return a.pass > b.pass
			end 
		else
			return ais_get<bis_get
		end 
	end
	
	table.sort(self.ListViewItemData[2],_sort)
	table.sort(self.ListViewItemData[1],_sort)
end
--这个是商店
function TaskView:setData1(data)
	-- body
	self.request = false
	self.data = data 
	self:initAllPanle(3)

	local reward = conf.Shop:getValue(13)
	self.lab_cost:setString(reward.value[self.data.todayCount+1] or reward.value[#reward.value])

	self.lab_hy:setString(cache.Fortune:getMoneyHy())
end

function TaskView:updatebuy( data )
	-- body
	local widget = self.item[data.index]
	if widget then
		local _data = widget.btn.data
		_data.amount = _data.amount - 1
		if _data.amount<=0 then --不能购买
			widget.btn:setEnabled(false)
			widget.btn:setBright(false)	
		end	
	end
	self.lab_hy:setString(cache.Fortune:getMoneyHy())
end

function TaskView:update1(data)
	-- body
	local t = {0,0,0,0}
	local hySign = cache.Taskinfo:getHySign()
	t[4] = checkint(hySign/1000)
	t[3] = checkint(hySign%1000/100)
	t[2] = checkint(hySign%100/10)
	t[1] = checkint(hySign%10)
	printt(t)
	for k ,v in pairs(t) do 
		if v > 0 then
			--self.xiangzi[k]:setTouchEnabled(false)
			self.xiangzi[k].isget = 2
			self.xiangzi[k]:loadTexture(res.icon.OPENXIANGZI[k])

			if self["armature"..k] then
				self["armature"..k]:removeSelf()
				self["armature"..k]=nil 
			end
		end
	end
	self:setRedPoint()
end

function TaskView:onBuyCallBack(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local data = send.data 
		local __reqdata = {
			stype = 4,
			index =data.index,
			mId = data.mId ,
			amount = 1,
		}
		printt(__reqdata)
		proxy.shop:buySend(__reqdata)	
	end
end

function TaskView:onbtnquick( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		proxy.task:send_105004({mType = 2})
	end
end

function TaskView:initShopitem()
	-- body
	if self.item then
		for  k ,v in pairs(self.item) do
			v:removeSelf()
		end
	end
	self.item = {}
	local ccsize = self.panelshop:getContentSize()
	for k,v in pairs(self.data.hyItems) do 
		local item = self.shopclone:clone()
		v.propertys = vector2table(v.propertys,"type")

		local colorlv = conf.Item:getItemQuality(v.mId)
		item.btn = item:getChildByName("Button_buy")
		--item.btn:setTitleText(res.str.RES_GG_76)
		item.btn.data = v 
		item.btn:addTouchEventListener(handler(self,self.onBuyCallBack))

		--名字
		local name = item:getChildByName("txt_name_33")
		name:setString(conf.Item:getName(v.mId,v.propertys))
		name:setColor(COLOR[colorlv])
		--物品外框
		local frame = item:getChildByName("Button_frame_24_0_21")
		frame.mId = v.mId
		frame:loadTextureNormal(res.btn.FRAME[colorlv])
		frame:setTouchEnabled(true)
		frame:addTouchEventListener(handler(self,self.onbtnSee))
		--icon
		local image_spr = frame:getChildByName("Image_22_24_9_44")
		image_spr:loadTexture(conf.Item:getItemSrcbymid(v.mId,v.propertys))
		--价格
		local price =  v.propertys[40102] and  v.propertys[40102].value or 0
		local lab_price = item:getChildByName("txt_name_0_0_0_39")
		lab_price:setString(price)

		item.btn:setEnabled(true)
		item.btn:setBright(true)
		if v.amount<=0 then --不能购买
			item.btn:setEnabled(false)
			item.btn:setBright(false)	
		end	

		local imgyouhui = item:getChildByName("Image_13_50")
		local img_ze  = item:getChildByName("Image_6_52")

		local dec_1 = item:getChildByName("txt_name_0_35")
		local dec_2 = item:getChildByName("Image_10_46")
		local dec_3 = item:getChildByName("txt_name_0_0_37")
		local dec_4 = item:getChildByName("Image_17_54")
		
		local ze  =  v.propertys[40104] and  v.propertys[40104].value or 0
		if ze > 0 then 
			dec_1:setVisible(true)
			dec_2:setVisible(true)
			dec_3:setVisible(true)
			dec_4:setVisible(true)
			imgyouhui:setVisible(true)
			img_ze:setVisible(true)

			local oldprice = price*100/v.propertys[40104].value
			dec_3:setString(math.ceil(oldprice))
		else
			dec_1:setVisible(false)
			dec_2:setVisible(false)
			dec_3:setVisible(false)
			dec_4:setVisible(false)
			imgyouhui:setVisible(false)
			img_ze:setVisible(false)
		end
		local y  = k<=4 and 2 or 1
		local x  = k%4==0 and 4  or k%4;
		x = ccsize.width/8*(2*x-1) - item:getContentSize().width/2
		y = ccsize.height/4*(2*y-1) - item:getContentSize().height/2
		item:setPosition(x,y)
		item:addTo(self.panelshop)

		self.item[v.index] = item
	end

end

function TaskView:onbtnSee( sender_,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if conf.Item:getType(sender_.mId) == pack_type.MATERIAL then--打开材料
			local data = {}
			data.taskview = true
			data.selectedPage = 2
			cache.Player:saveMaterialJumpData(data)
		end
		G_openItem(sender_.mId)
	end
end

function TaskView:getColnePnaleItem()
	-- body
	return self.clonePanle:clone()
end

function TaskView:onbtnget( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--proxy.task:send_113004({mType = sender_.tag})
		local view = mgr.ViewMgr:showView(_viewname.TASK_GET_HY)
		view:setData(sender_.tag,sender_.isget)
	end
end

function TaskView:initHuoyue()
	-- body
	local lab_bar = self.panle_huoyue:getChildByName("LoadingBar")
	lab_bar:setPercent(0)
	local cur_hy = cache.Taskinfo:getHy()
	local reward = conf.Shop:getValue(15)
	local all = self.max_all
	print("self.max_all",self.max_all)
	local t = {0,0,0,0}

	local hySign = cache.Taskinfo:getHySign()
	t[4] = checkint(hySign/1000)
	t[3] = checkint(hySign%1000/100)
	t[2] = checkint(hySign%100/10)
	t[1] = checkint(hySign%10)

	self.xiangzi = {}
	self.jiantou = {}
	local offx = 0
	for i = 1 , 4 do 
		local img = lab_bar:getChildByName("Image_box_"..i)
		img:setTouchEnabled(true)
		img.tag = i
		img.isget = 0
		img:addTouchEventListener(handler(self, self.onbtnget))

		local jian  = lab_bar:getChildByName("Image_box_1_"..i)
		self.jiantou[i] = jian

		if self["armature"..i] then
			self["armature"..i]:removeSelf()
			self["armature"..i]=nil 
		end
		if cur_hy >= reward.value[i] and t[i] <= 0  then
			img.isget = 1
			self["armature"..i] =  mgr.BoneLoad:loadArmature(404831,2)
			self["armature"..i]:setPosition(img:getContentSize().width/2,img:getContentSize().height/2)
			self["armature"..i]:addTo(img,-1)

			jian:loadTexture(res.other.OTER_JIAN)
		end

		if t[i] > 0 then
			img.isget = 2
			--img:setTouchEnabled(false)
			img:loadTexture(res.icon.OPENXIANGZI[i])
		end

		local img_txt = lab_bar:getChildByName("Image_txt_"..i)
		local lab = img_txt:getChildByName("Text_60_"..i)
		lab:setString(reward.value[i])

		local x = 0

		x = reward.value[i]/all*lab_bar:getContentSize().width
		img:setPositionX(x)
		jian:setPositionX(x)

		img_txt:setPositionX(x+20)

		self.xiangzi[i] = img
	end

	

	local lab_value = self.panle_huoyue:getChildByName("Image_90"):getChildByName("AtlasLabel_2")
	lab_value:setString(cur_hy)

	lab_bar:setPercent(checkint(cur_hy*100/all))

	local lab_dec = self.panle_huoyue:getChildByName("Text_67")
	lab_dec:setString(res.str.RES_GG_74)

end

function TaskView:initAllPanle( index )
	-- body
	--debugprint("切换界面 ="..index)
	self.packindex = index or 1
	--[[if index then 
		self.packindex =  index
	end ]]--
	if self.tableView and not tolua.isnull(self.tableView) then
		self.tableView:removeSelf()
		self.tableView = nil 
	end
	self.panle_huoyue:setVisible(false)
	self.panelshop:setVisible(false)
	self.down:setVisible(false)
	self.otherline:setVisible(false)
	if self.packindex < 3 then
		self.down:setVisible(true)
		self:inittableView()
		self.panle_huoyue:setVisible(true)
		self:initHuoyue()
	else
		self.otherline:setVisible(false)
		self.panelshop:setVisible(true)
		self:initShopitem()
	end
	
end


function TaskView:pagebtninit( index )
	-- body
	self.PageButton:initClick(index)

end

----------------------按钮回调-------------
--页面切换
function TaskView:onPageButtonCallBack( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		if index < 3 then
			proxy.task:sendMessagetype(1)--请求任务
			--self:setData()
		else
			--请求商店
			proxy.shop:sendMessage(4)
		end
		--self:initAllPanle(index)
		return self
	end
end

--
function TaskView:onCloseSelfView()
	mgr.SceneMgr:getMainScene():changeView(1)
end

return TaskView

