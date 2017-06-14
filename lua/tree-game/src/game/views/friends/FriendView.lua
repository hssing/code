--
-- Author: Your Name
-- Date: 2015-07-27 15:19:33
--

local FriendView = class("FriendView", base.BaseView)


function FriendView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.ListGUIButton={}  --GUI按钮容器
	local size=3
	self.btn_panle = self.view:getChildByName("Panel_header")
	self.view:reorderChild(self.btn_panle,200)
	for i=1,size do
		local btn=self.btn_panle:getChildByTag(i+100)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

		gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放

		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn

	end

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end

	

	self.view:getChildByName("Panel_footer"):setLocalZOrder(1000)
	self.view:getChildByName("Panel_middle"):setLocalZOrder(10000)
	self.view:getChildByName("Button_close"):setLocalZOrder(100000)
	self.panle_info = self.view:getChildByName("Panel_middle"):getChildByName("Panel_info")
	self.panel_search = self.view:getChildByName("Panel_middle"):getChildByName("Panel_search")
	self.panel_leftTime = self.view:getChildByName("Panel_middle"):getChildByName("Panel_leftTime")
	self.listView = self.view:getChildByName("ListView")
	self.cloneItem = self.view:getChildByName("Panel_item")

	self.panle_info:getChildByName("Text_162"):setString("/20")

	local input = self.panel_search:getChildByName("TextField_searh")
	-------输入框事件监听
	self.input_search = cc.ui.UIInput.new({
		    image = res.image.TRANSPARENT,
		    x = input:getPositionX(),
		    y = input:getPositionY(),
		    size = cc.size(input:getContentSize().width,input:getContentSize().height + 10)
		})

	self.panel_search:addChild(self.input_search)
	self.input_search:setPlaceHolder(res.str.HSUI_DESC22)
	input:removeFromParent()
	

	--------一键领取按钮
	 self.btnOneKeyGet = self.panel_leftTime:getChildByName("Button_oneKey")
	 self.btnOneKeyGet:addTouchEventListener(handler(self,self.btnOneKeyGetCallbacl))
	----换一批
	local btnChangeABatch = self.panel_search:getChildByName("Button_switch")
	btnChangeABatch:addTouchEventListener(handler(self,self.btnChangeABatchCallback))
	btnChangeABatch:setSwallowTouches(true)
	---搜索
	local btnSearch =  self.panel_search:getChildByName("Button_search")
	btnSearch:addTouchEventListener(handler(self,self.btnSearchCallback))

	
	self.data = cache.Friend:readFriendData()
	self.showData = self.data[1]-------当前显示的数据

	self.proxy = proxy.friend
	self:inittableView()
	self.selectedIdx = 1

	self.ListGUIButton[1]:getInstance():setTitleText(res.str.FRIEND_TEXT11)
	self.ListGUIButton[2]:getInstance():setTitleText(res.str.FRIEND_TEXT12)
	self.ListGUIButton[3]:getInstance():setTitleText(res.str.FRIEND_TEXT13)
	self.panle_info:getChildByName("Text_160"):setString(res.str.FRIEND_TEXT11)

	self.panel_leftTime:getChildByName("Text_160_164"):setString(res.str.FRIEND_TEXT14)
	self.panel_leftTime:getChildByName("Text_162_168"):setString(res.str.FRIEND_TEXT15)
	self.btnOneKeyGet:getChildByName("Text_1"):setString(res.str.FRIEND_TEXT16)

	btnChangeABatch:setTitleText(res.str.FRIEND_TEXT17)
	
	--btnSearch:setTitleText(res.str.FRIEND_TEXT18)

	self.PageButton:initClick(1)

end



function FriendView:initAllPanle( index )
	-- body

	----跟新头部显示
	if index == 1 then
		self.panle_info:setVisible(true)
		self.panel_leftTime:setVisible(false)
	    self.panel_search:setVisible(false)
	    self.proxy:reqFriendList()
	elseif index == 2 then
			--todo
		self.panle_info:setVisible(false)
		self.panel_leftTime:setVisible(false)
	    self.panel_search:setVisible(true)
	    self.proxy:reqSysRecommandFriend("")
	elseif index == 3 then
		--todo
		self.panle_info:setVisible(false)
		self.panel_leftTime:setVisible(true)
	    self.panel_search:setVisible(false)
	    self.proxy:reqGetMenualList()
	end


end

--------------------------TableVIew

function FriendView:numberOfCellsInTableView(table)
    return #self.showData
end

function FriendView:scrollViewDidScroll(view)

end

function FriendView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function FriendView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function FriendView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneItem:getContentSize()
    return ccsize.height,ccsize.width
end

function FriendView:tableCellAtIndex(table, idx)
	
    local strValue = string.format("%d",idx)
    -- print("index "..strValue .." time" ..os.time())
    local cell = table:dequeueCell()
    local item
    --local data= self.Data[self.packindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        item = self.cloneItem:clone()
        cell:addChild(item)
        item:setTouchEnabled(false)
	    item:setName("item")
	    item:setPosition(5,0)
    else
  		--todo
        item = cell:getChildByName("item")
    end

    self:setItemsData(item, idx)
    
    --设置每条数据的信息

    return cell
end

function FriendView:setItemsData( item,index )
	-- body
	local info = self.showData[index+1]


	local roleIcon = item:getChildByName("img_face")
	local btnFace = item:getChildByName("btn_face")
	local toleLevelLb = item:getChildByName("Text_lv")
	local rolePower = item:getChildByName("Text_power")
	local roleGuild = item:getChildByName("text_guild")
	local roleVipIcon = item:getChildByName("Image_vip")
	local roleName = item:getChildByName("Text_name")
	roleName:ignoreContentAdaptWithSize(true)
	local roleState = item:getChildByName("Text_state")
	local btn = item:getChildByName("Button")
	local btnIcon = item:getChildByName("Image_icon") 
	local guildIcon = item:getChildByName("Image_guild") 
	--guildIcon:setVisible(false)

	local temp = G_Split_Back(info.roleIcon)
	if roleIcon:getChildByName("dw") then 
		roleIcon:getChildByName("dw"):removeSelf()
	end

	if temp.dw >= temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setPosition(temp.dw_pos)
		spr:addTo(roleIcon)
		spr:setName("dw")
	end

	roleIcon:loadTexture(temp.icon_img)

	--roleIcon:loadTexture(facePath..info.roleIcon)
	toleLevelLb:setString(info.roleLevel)
	rolePower:setString(info.power)
	roleVipIcon:loadTexture(res.icon.VIP_LV[info.vipLevel])
	roleName:setString(info.roleName)
	roleName:setFontName(display.DEFAULT_TTF_FONT)
	roleName:setFontSize(display.DEFAULT_TTF_FONT_SIZE)

	btnFace:loadTextureNormal( G_getChatPlayerFrameIcon(info.power))
	--local path = info["roleIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	--roleIcon:loadTexture(G_GetHeadIcon(info["roleIcon"]))
	--roleIcon:loadTexture(path)

	if info.guildName == nil or info.guildName == "" then
		roleGuild:setString(res.str.HSUI_DESC38)
	else
		roleGuild:setString(info.guildName)
	end

	roleGuild:setFontName(display.DEFAULT_TTF_FONT)
	roleGuild:setFontSize(display.DEFAULT_TTF_FONT_SIZE)


	------根据时间显示 在线 或者离线时间
	if info.listTime == 0 then--在线
		--todo
		roleState:setString(res.str.HSUI_DESC17)
	else

		local time = ""
		if info.listTime / (60 * 60) <1 then------小于一小时
			--todo
			local minute = math.ceil(info.listTime / 60)
			time = string.format(res.str.HSUI_DESC23, minute)

		elseif info.listTime / (60 * 60 * 24) < 1 then-------小于一天
				--todo
				print(info.listTime)
			local hour = math.round(info.listTime / (60 * 60))
			time = string.format(res.str.HSUI_DESC24, hour)

		else
			local day = math.round(info.listTime / (60 * 60 * 24))
			time = string.format(res.str.HSUI_DESC25, day)
		end
		roleState:setString(time)
	end

	btn:loadTextureNormal(res.btn.BLUE_BTN_14)
	if self.selectedIdx == 1 then-----------好友列表
		if info.isTl == 0 then
			--todo
			btn:setTitleText(res.str.HSUI_DESC27)
			btnIcon:setVisible(true)
			btn:setEnabled(true)
		else
			btn:setTitleText("")
			btnIcon:setVisible(false)
			btn:loadTextureNormal(res.btn.ISGiVEN_BTN)
			btn:setEnabled(false)
		end

	elseif self.selectedIdx == 2 then ------邀请好友列表
		--todo
		btn:setTitleText(res.str.HSUI_DESC26)
		btnIcon:setVisible(false)
		btn:setEnabled(true)

	elseif self.selectedIdx == 3 then--------领体力列表
			--todo
		if info.isTl == 0 then
			--todo
			btn:setTitleText(res.str.HSUI_DESC1)
			btnIcon:setVisible(true)
			btn:setEnabled(true)
		else
			btn:setTitleText("")
			btn:loadTextureNormal(res.btn.ISGiVEN_BTN)
			btnIcon:setVisible(false)
			btn:setEnabled(false)
		end
	end



------跟新按钮事件
	    btnFace:addTouchEventListener(handler(self,self.onItemFaceBtnClickUp))----头像按钮
	    btnFace:setTag(index+1)

	    btn:addTouchEventListener(handler(self,self.onBtnGetClickUp))-----------领取体力，邀请好友，赠送体力
	    btn:setTag(index+1+100)

end

------计算在线好友数量
function FriendView:countOnlineFriendNum(  )
	-- body



end

-------对按钮连续点击做限制，按钮被点击后，如果没有
-------网络数据返回，则 1 秒内按钮不能再被点击
function FriendView:onButtonClickFastDelay(  )
	-- body
	local delay = cc.DelayTime:create(1)
	local callFunc = cc.CallFunc:create(function( )
		 self.btnOneKeyGet:setEnabled(true)
		 if self.clickedBtn then
		 	--todo
		 	self.clickedBtn:setEnabled(true)
		 end
	end)

	local seq = cc.Sequence:create({delay,callFunc})
	self:runAction(seq)

end

----------分页按钮
function FriendView:onPageButtonCallBack( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.selectedIdx = index
		self:initAllPanle(index)
		self.tableView:reloadData()
		return self
	end
end

------关闭按钮
function FriendView:onCloseSelfView(  )
    --关闭
    local ids = {1034}
    self:closeSelfView()
    G_mainView()
end

------头像按钮点击
function FriendView:onItemFaceBtnClickUp( sender,eventType )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		---获得玩家Id
		local id = self.showData[sender:getTag()]["roleId"]
		proxy.Chat:reqFriendInfo(id)
	end
end


-----------点击按钮，进行 赠送体力、领取体力，邀请好友
function FriendView:onBtnGetClickUp( sender,eventType )
	-- body

	if eventType ==  ccui.TouchEventType.ended then

		local index = sender:getTag() - 100
		local rId = self.showData[index]["roleId"]
		if self.selectedIdx == 1 then--赠送体力
			--todo
			self.proxy:reqGiveMenual(rId)

		elseif self.selectedIdx == 2 then--邀请好友
				--todo
			self.proxy:reqInvitationFriend(  rId)
		elseif self.selectedIdx == 3 then --领取体力
			if self.countTl <= 0 then
				G_TipsOfstr(res.str.FRIEND_TIPS10)
				return
			end

			self.proxy:reqGetMenual(rId)
			-- sender:setEnabled(false)
			-- if self.clickedBtn then
			-- 	self.clickedBtn:setEnabled(true)
			-- end
			-- self.clickedBtn = sender
			-- self:onButtonClickFastDelay()
		end

	end

end



------一件领取体力
function FriendView:btnOneKeyGetCallbacl(  sender,eventType )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		-- local roleId = {}
		-- roleId.high = 0
		-- roleId.low = 0
		-- roleId.key = "0_0"
		if #self.showData <= 0 then
			return
		end
		if self.countTl <= 0 then
			G_TipsOfstr(res.str.FRIEND_TIPS10)
			return
		end
		 self.maxTL = cache.Player:getMaxtli()
		 self.nowTL = cache.Player:getTili()

		 if self.maxTL ==  self.nowTL  then
		 	--todo
		 	G_TipsOfstr(res.str.FRIEND_TIPS11)
		 	return
		 end

		  -- self.btnOneKeyGet:setEnabled(false)
		  -- self:onButtonClickFastDelay()
		self.proxy:reqGetMenual(0)------- 0 为一键领取
	end
end

----换一批
function FriendView:btnChangeABatchCallback( sender,eventType  )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		self.proxy:reqSysRecommandFriend("")
	end
end

----按名字搜索
function FriendView:btnSearchCallback( sender,eventType  )
	-- body
	if eventType ==  ccui.TouchEventType.ended then
		local text = string.trim(self.input_search:getText())

		if string.utf8len(text) <= 0 then
			G_TipsOfstr(res.str.FRIEND_TIPS12)
			return
		end

		self.proxy:reqSysRecommandFriend(text)
	end
end

---------请求网络数据返回
function FriendView:setListData( data,countTl )
	-- body
	----------取消网络请求定时
	--self:stopAllActions()

	self.showData = data
	self.data[self.selectedIdx] = data
	------保存好友数据缓存
	cache.Friend:saveFriendData(self.data)
	--更新头部
	if self.selectedIdx == 1 then--好友
		--todo
		self.panle_info:getChildByName("Text_friendCount"):setString(#self.showData .. "")
	elseif self.selectedIdx == 3 then---领体力
			--todo
		self.countTl = countTl
		if countTl then
			if countTl < 0 then
				self.countTl = 0
			end
			local textCount = self.panel_leftTime:getChildByName("Text_count")
			textCount:setString(self.countTl)
		end
		
	end
	self:setRedPoint(3)--------领体力红点
	self.tableView:reloadData()
end


-------点击按钮，赠送体力数据返回
function FriendView:reqGiveMenualSucc( data )
	-- body
		self:pushBackItem(data.roleId)
end

---领取体力返回
function FriendView:getMenualSucc( data )
	-- body

	if data.roleId["key"] == "0_0" then
		--todo
		 self.btnOneKeyGet:setEnabled(true)

		if  self.maxTL <= self.nowTL then
			G_TipsOfstr(res.str.FRIEND_TIPS11)
			return
		end

		if self.maxTL - self.nowTL < #self.showData then
			--todo
			G_TipsOfstr(string.format(res.str.FRIEND_TIPS13, self.maxTL - self.nowTL))

		elseif self.maxTL - self.nowTL >= #self.showData then
			G_TipsOfstr(string.format(res.str.FRIEND_TIPS13, #self.showData))
		end
	else
		self.clickedBtn = nil
		G_TipsOfstr(string.format(res.str.FRIEND_TIPS13, 1))
	end
	self.proxy:reqGetMenualList()
end


------删除好友
function FriendView:delFriendSucc( data )
	-- body
	for i=1,#self.showData do
		local roleId = self.showData[i].roleId
		if roleId["key"] == data.roleId["key"]  then
			--todo
			local roleName = self.showData[i].roleName

			G_TipsOfstr(string.format(res.str.FRIEND_TIPS1,roleName ))
			break
		end
	end
	
	self.proxy:reqFriendList()
end


function FriendView:setRedPoint( index )
	self.ListGUIButton[index]:setNumber(cache.Player:getHaoYNumber())
end




---------将id玩家移动到最后 
function FriendView:pushBackItem( id )
	-- body
	for i=1,#self.showData do
			local roleId = self.showData[i].roleId
		if roleId["key"] == id["key"] then
			local playerInf = self.showData[i]
			playerInf.isTl = 1
			table.remove(self.showData,i)
			--table.insert(self.showData,playerInf)
			self.showData[#self.showData+1] = playerInf
			self.tableView:reloadData()
			break
		end
	end
end

----移除 id 玩家
function FriendView:removeItem( id )
	-- body
	for i=1,#self.showData do
		if self.showData[i].roleId["key"] == id["key"] then
			table.remove(self.showData,i)
			self.tableView:reloadData()
			break
		end
	end
end



function FriendView:inittableView(listView,ccsize)
	-- body
	--print("kaishi ="..os.time())
	if not self.tableView then 
		local posx ,posy = self.listView:getPosition()
		local ccsize =  self.listView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView,100)
	
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	end 
	--print("end ="..os.time())
	self.tableView:reloadData()
end


return FriendView