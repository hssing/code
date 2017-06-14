--
-- Author: Your Name
-- Date: 2015-08-26 21:23:35
--
local  GuildCmpRankView = class("GuildCmpRankView", base.BaseView)


function GuildCmpRankView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()


	self.headerPanel = self.view:getChildByName("Panel_1")
	self.timeTickLab = self.headerPanel:getChildByName("Text_7")
	self.RuleLab = self.headerPanel:getChildByName("Text_5")

	self.RuleLab:ignoreContentAdaptWithSize(false)
	self.RuleLab:setContentSize(600,60)
	self.RuleLab:setPosition(self.RuleLab:getPositionX(),self.RuleLab:getPositionY() - 15)

	self.clonePanel = self.view:getChildByName("Item_Panel")
	self.listView = self.view:getChildByName("ListView_item")
	self.cloneItem = self.view:getChildByName("item")

	self.timeLab = self.headerPanel:getChildByName("Text_7")
	self.view:getChildByName("Panel_footer"):setLocalZOrder(1000)
	self.view:getChildByName("Panel_footer"):setSwallowTouches(false)

	self.data = {}
	self:inittableView()


	---固定文本抽出
	local  Text_6 = self.headerPanel:getChildByName("Text_6")
	Text_6:setString(res.str.RICH_RANK_DESC2)	
	local  Text_5 = self.headerPanel:getChildByName("Text_5")
	Text_5:setString(res.str.RICH_RANK_DESC25)

	local imgPanel = self.clonePanel:getChildByName("Image_2")
	local Text_1 = imgPanel:getChildByName("Text_1")
	Text_1:setString(res.str.RICH_RANK_DESC22)

	local Text_4 = imgPanel:getChildByName("Text_1_4")
	Text_4:setString(res.str.RICH_RANK_DESC23)

	local Text_0 = imgPanel:getChildByName("Text_1_0")
	Text_0:setString(res.str.RICH_RANK_DESC24)
	

	--如果是从活动进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		headBar:setVisible(false)
	end

	--[[
	int32_t	变量名：rank	说明：排名
2	string	变量名：gName	说明：公会名称
3	int32_t	变量名：gLevel	说明：公会等级
4	string	变量名：roleName	说明：会长名称
5	int32_t	变量名：fbJindu	说明：公会进度
6	int32_t	变量名：gPower	说明：公会战力
	--]]

	local data = {}
	data.actGuildzbList = {}
	for i=1,10 do
		local item = {}
		item.rank = i
		item.gName = i
		item.gLevel = i
		item.roleName = i * 100
		item.fbJindu = i * 100
		item.gPower = i * 100
		table.insert(data.actGuildzbList, item)
	end

	
	--self:setGiftInfo(data)
	proxy.RichRank:reqGuildRank()

end



---创建每个充值奖励
function GuildCmpRankView:createitem(idx)
	-- body
	local gifts = self.data[idx .. ""]["gifts"]
	local itemPanel = self.clonePanel:clone()
	local listView = itemPanel:getChildByName("ListView_sub_item")
	local imgPanel = itemPanel:getChildByName("Image_2")
	listView:setSwallowTouches(false)
	listView:setContentSize(1000,120)
	itemPanel:setSwallowTouches(false)
	for i=1,#gifts do
		local item = self.cloneItem:clone()
		item:setSwallowTouches(false)
		listView:pushBackCustomItem(item)

		local iconFrame = item:getChildByName("btn_goods")
		local iconImg = item:getChildByName("img_goods")
		local textLb = item:getChildByName("text_goods")

		local mid = gifts[i][1]
		local num = gifts[i][2]
		local iconFrameSrc = conf.ChargeCount:getFrameIcon(mid)
		local iconImgSrc = conf.ChargeCount:getIcon(mid)
		local textLbName = conf.ChargeCount:getName(mid)
		local textColor = conf.ChargeCount:getTextColor(mid)

		iconFrame:loadTextureNormal(iconFrameSrc)
		iconImg:loadTexture(iconImgSrc)
		textLb:setString(textLbName .. "x" .. num)
		textLb:setColor(textColor)

		iconFrame.mid = mid
		iconFrame:addTouchEventListener(handler(self,self.openItem))
	end

	local rankData = self.data[idx .. ""]["rankData"]
	local rankImg = imgPanel:getChildByName("Image_4")
	local fontName = res.font.FLOAT_NUM[4]

	
	--公会等级
	if rankData.gLevel < 10 then
		 local numTxt = cc.LabelAtlas:_create(rankData.gLevel ,fontName,16,21,string.byte("."))
		 rankImg:addChild(numTxt)
		 numTxt:setAnchorPoint(0.5,0.5)
		 numTxt:setPosition(rankImg:getContentSize().width / 2, rankImg:getContentSize().height / 2)
	else
		local tenWei = math.floor(rankData.gLevel / 10) 
		local geWei = rankData.gLevel % 10
		local tenImg = cc.LabelAtlas:_create(tenWei ,fontName,16,21,string.byte("."))
		local geImg = cc.LabelAtlas:_create(geWei ,fontName,16,21,string.byte("."))
		rankImg:addChild(tenImg)
		rankImg:addChild(geImg)
		tenImg:setAnchorPoint(0.5,0.5)
		geImg:setAnchorPoint(0.5,0.5)

		tenImg:setPosition(rankImg:getContentSize().width / 2 - 6, rankImg:getContentSize().height / 2)
		geImg:setPosition(rankImg:getContentSize().width / 2 + 6, rankImg:getContentSize().height / 2)

	end

	--排名
	local rank = imgPanel:getChildByName("Image_3")
	local rankPanel = imgPanel:getChildByName("Panel_2")
	local fontName = res.font.FLOAT_NUM[3]
	if rankData.rank <= 3 then
		local icon = "res/views/ui_res/icon/icon_rank%d.png"
		rank:loadTexture(string.format(icon, rankData.rank) )
	elseif  rankData.rank < 10 then
		 rank:setVisible(false)
		 local numTxt = cc.LabelAtlas:_create(rankData.rank ,fontName,30,41,string.byte("."))
		 rankPanel:addChild(numTxt)
		 numTxt:setAnchorPoint(0.5,0.5)
		 numTxt:setPosition(rankPanel:getContentSize().width / 2, rankPanel:getContentSize().height / 2)
	else
		 rank:setVisible(false)
		local tenWei = math.floor(rankData.rank / 10) 
		local geWei = rankData.rank % 10
		local tenImg = cc.LabelAtlas:_create(tenWei ,fontName,30,41,string.byte("."))
		local geImg = cc.LabelAtlas:_create(geWei ,fontName,30,41,string.byte("."))
		rankPanel:addChild(tenImg)
		rankPanel:addChild(geImg)
		tenImg:setAnchorPoint(0.5,0.5)
		geImg:setAnchorPoint(0.5,0.5)

		tenImg:setPosition(rankPanel:getContentSize().width / 2 - 8, rankPanel:getContentSize().height / 2)
		geImg:setPosition(rankPanel:getContentSize().width / 2 + 8, rankPanel:getContentSize().height / 2)
	end

	--公会副本进度
	local id = math.floor(rankData.fbJindu/100)
	local zhanjie =  conf.guild:getGuildChapter(id)
	local str = ""
	if zhanjie then 
		str = zhanjie.title .. tostring((rankData.fbJindu%10-1) *25).."%"
	else
		str = "100%"
	end 
	--会长
	imgPanel:getChildByName("Text_1_1"):setString(rankData.roleName)
	imgPanel:getChildByName("Text_1_2"):setString(str)
	imgPanel:getChildByName("Text_1_3"):setString(rankData.gPower)
	imgPanel:getChildByName("Text_10"):setString(rankData.gName)

	
	
  

	return itemPanel
end


-----打开物品

function GuildCmpRankView:openItem( send,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then

		local data = {}
			data.mId = send.mid
		local itype=conf.Item:getType(data.mId)
		if itype ==  pack_type.PRO then
			G_openItem(data.mId)
		elseif itype  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		else	
			G_OpenCard(data,true)
		end

	end
end


-----活动倒计时
function GuildCmpRankView:timeTick( )
	self.leftTime = self.leftTime - 1
	if self.leftTime <= 0 then
		self:stopAction(self.timeSchedual)
		self.timeLab:setString(res.str.RICH_RANK_DESC37)
		return
	end
	self.timeLab:setString(self:getTimeStr())
end


function GuildCmpRankView:getTimeStr(  )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(self.leftTime / (60 * 60 * 24))--天
	left = self.leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC9,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC10, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC11, hour,minute,left)
	else
		timeStr = string.format(res.str.RICH_RANK_DESC12, day,hour,minute,left)
	end


	return timeStr
end


-------网络数据
--请求奖励信息成功返回
function GuildCmpRankView:setGiftInfo( data )
	self.data = conf.GuildCmp:getData()
	local nums = table.nums(self.data)
	local rankData = data.actGuildzbList
	local realRankNUm = #rankData
	
	if nums > realRankNUm then
		for i=nums,realRankNUm + 1,-1 do
			self.data[i .. ""] = nil
		end
	end

	for i=1,realRankNUm do
		self.data[rankData[i]["rank"] .. ""].rankData = rankData[i]
	end

	--开始倒计时
	self.leftTime = data["lastTime"]
	--显示倒计时
	self.timeLab:setString(self:getTimeStr())
	self.timeSchedual = self:schedule(self.timeTick, 1)

	self.tableView:reloadData()

end

--------------------------TableVIew

function GuildCmpRankView:numberOfCellsInTableView(iTable)
	-- body
	--local size=#self.Data[self.packindex]
	--return 0
    return table.nums(self.data)
end

function GuildCmpRankView:scrollViewDidScroll(view)

   -- print("scrollViewDidScroll")
end

function GuildCmpRankView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function GuildCmpRankView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function GuildCmpRankView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function GuildCmpRankView:tableCellAtIndex(table, idx)
	
    local strValue = string.format("%d",idx)
    -- print("index "..strValue .." time" ..os.time())
    local cell = table:dequeueCell()
    --local data= self.Data[self.packindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
    else
  		--todo
       local item = cell:getChildByName("item")
       item:removeFromParent()
    end

     local item = self:createitem(idx + 1)
     item:setTouchEnabled(false)
     item:setAnchorPoint(0,0)
     item:setPosition(5,0)
     cell:addChild(item)
     item:setName("item")
    
    --设置每条数据的信息

    return cell
end


function GuildCmpRankView:inittableView(listView,ccsize)
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








return GuildCmpRankView