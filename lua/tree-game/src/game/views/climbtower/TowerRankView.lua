local TowerRankView=class("TowerRankView",base.BaseView)

function TowerRankView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    --数据
    self.data = nil
    self.pageIndex = 1
    self.starIndex = 1
    self.rankData = {}
    self.starAwardData = {}
    
    --初始化界面
    local panel1 = self.view:getChildByName("Panel_4")
    local panel2 = self.view:getChildByName("Panel_3")
    panel1:setVisible(false)
    panel2:setVisible(true)
    --关闭
    self._closebtn = self.view:getChildByName("Panel_7"):getChildByName("Button_2")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    --listView
    self.rankList = self.view:getChildByName("Panel_3"):getChildByName("ListView_1")
    self.rankList:setTouchEnabled(true)
    self.rankList:setBounceEnabled(true)
    --self.rankList:setGravity(ccui.ListViewGravity.centerVertical)
    self.starList = self.view:getChildByName("Panel_4"):getChildByName("ListView_2")
    self.starList:setVisible(false)
    --self.starList:setTouchEnabled(true)
    --self.starList:setBounceEnabled(true)
    --self.starList:setBounceEnabled(true)
    self.clonePane = self.view:getChildByName("Panel_Clone")
    local posx ,posy = self.starList:getPosition()
    local ccsize =  self.starList:getContentSize() 
    self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setPosition(cc.p(posx, posy))
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    panel1:addChild(self.tableView,100)
    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)               --放大                      --点击    
    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)              --xiao  
    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
    --self.tableView:reloadData()
    
    --pageBtn
    self.PageButton=gui.PageButton.new()
    self.PageButton:setBtnCallBack(handler(self,self.listButtonCallBack))
    for i=1,2 do
        local btn = self.view:getChildByName("Panel_7"):getChildByName("Button_3_"..i)
        self.PageButton:addButton(btn)
    end
    self.PageButton:setSelectButton(1)
    --星级btn
    self.starPageBtn = gui.PageButton.new()
    self.starPageBtn:setBtnCallBack(handler(self,self.starButtonCallBack))
    for i=1,5 do
        local btn = self.view:getChildByName("Panel_3"):getChildByName("StarButton_"..i)
        self.starPageBtn:addButton(btn)
    end
    --我的信息
    self.myRank = self.view:getChildByName("Panel_3"):getChildByName("Panel_2"):getChildByName("Text_7")
    self.myStar = self.view:getChildByName("Panel_3"):getChildByName("Panel_2"):getChildByName("Text_6_1")
    self.myAward = self.view:getChildByName("Panel_3"):getChildByName("Panel_2"):getChildByName("Text_6_2")

    --获取数据115002
    local data = cache.Copy.towerData
    self.hard = tonumber(string.sub(data.currPass,2,2))
    self.starPageBtn:initClick(self.hard)
    --mgr.NetMgr:send(115002, {startType=self.hard})

    --界面固定文本
     self.view:getChildByName("Panel_7"):getChildByName("Button_3_"..1):setTitleText(res.str.CLIMB_DESC35)
     self.view:getChildByName("Panel_7"):getChildByName("Button_3_"..2):setTitleText(res.str.CLIMB_DESC36)

    local panel_3 =  self.view:getChildByName("Panel_3")
    panel_3:getChildByName("StarButton_1"):getChildByName("Text_1"):setString(string.format(res.str.CLIMB_DESC1,res.str.CLIMB_DESC37))
    panel_3:getChildByName("StarButton_2"):getChildByName("Text_1_3"):setString(string.format(res.str.CLIMB_DESC1,res.str.CLIMB_DESC38))
    panel_3:getChildByName("StarButton_3"):getChildByName("Text_1_5"):setString(string.format(res.str.CLIMB_DESC1,res.str. CLIMB_DESC39))
    panel_3:getChildByName("StarButton_4"):getChildByName("Text_1_5_29"):setString(string.format(res.str.CLIMB_DESC1,res.str.CLIMB_DESC40))
    panel_3:getChildByName("StarButton_5"):getChildByName("Text_1_5_29_21"):setString(string.format(res.str.CLIMB_DESC1,res.str.RES_RES_36))
     
     panel1:getChildByName("Text_18"):setString(res.str.CLIMB_DESC41)
     local panel_3_2 = panel2:getChildByName("Panel_2")
     panel_3_2:getChildByName("Text_6"):setString(res.str.CLIMB_DESC42)
     panel_3_2:getChildByName("Text_6_0"):setString(res.str.CLIMB_DESC43)
     panel_3_2:getChildByName("Text_6_3"):setString(res.str.CLIMB_DESC44)
     panel_3_2:getChildByName("Text_12"):setString(res.str.CLIMB_DESC45)

     local panel_1 =  self.view:getChildByName("Panel_1")
     panel_1:getChildByName("Text_6_0_0"):setString(res.str.CLIMB_DESC43)
     panel_1:getChildByName("Text_6_3_0"):setString(res.str.CLIMB_DESC44)

      self.clonePane:getChildByName("Button_Using_17"):setTitleText(text)

end

function TowerRankView:listButtonCallBack(index,eventtype,noClick)
    local panel1 = self.view:getChildByName("Panel_4")
    local panel2 = self.view:getChildByName("Panel_3")
    self.pageIndex = index
    if index == 2 then
        panel1:setVisible(true)
        panel2:setVisible(false)
        self:setData(index)
    elseif index == 1 then
        panel1:setVisible(false)
        panel2:setVisible(true)
        self.starPageBtn:initClick(self.hard)
    end  
    return true 
end

function TowerRankView:starButtonCallBack(index,eventtype,noClick)
    debugprint("____________________________________________[爬塔]", index)
    self.starIndex = index
    self.rankList:removeAllItems()
    if self.rankData[index] then
        self:setData(1, self.starIndex)
    else
        mgr.NetMgr:send(115002, {startType=index})
    end
    return true 
end

function TowerRankView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

function TowerRankView:setData(index_, stars_)
    local info
    local list
    if index_ == 2 then  --星级奖励
        info = self.starAwardData
        local curTimes = cache.Copy.towerData.start
        local config = conf.Copy:getTowerStarAward(cache.Copy.towerStarLvl)
        local ary = config.start_awards
        self.tableList = {}
        local getList = {}
        for p=1, #info do
            getList[info[p]] = 1
        end
        local tempTable = {}
        for i=1, #ary do
            if not getList[i] and curTimes >= ary[i][1] then
                table.insert(tempTable, {info=ary[i], get=1, index=i})
            else
                table.insert(self.tableList, {info=ary[i], get=0, index=i})
            end        
        end
        for j=1, #tempTable do
            table.insert(self.tableList, tempTable[j])
        end
        self.tableView:reloadData()
        --[[self.starList:removeAllItems()
        info = self.starAwardData
        local config = conf.Copy:getTowerStarAward(cache.Copy.towerStarLvl)
        local ary = config.start_awards
        local curTimes = cache.Copy.towerData.start
        function addCell(data__, i__, state__)
            local cell = self.view:getChildByName("Panel_Clone"):clone()
            local totalTxt = cell:getChildByName("Text_41")
            totalTxt:setString("/"..data__[1])
            local curTxt = cell:getChildByName("Text_40")
            curTxt:setString(curTimes)
            local btn = cell:getChildByName("Button_Using_17")
            if state__ == 1 then
                if curTimes < data__[1] then
                    curTxt:setColor(cc.c3b(255,0,0))
                    btn:setEnabled(false)
                    btn:setBright(false)
                else
                    btn:setTag(i__)
                    btn:setTitleText("领取")
                    btn:setEnabled(true)
                    btn:setBright(true)
                    btn:addTouchEventListener(handler(self,self.onGetClickHandler))
                end 
            else
                btn:setEnabled(false)
                btn:setBright(false)
                btn:setTitleText("已领取")
            end       
            local len = (#data__-1)/2
            for k=1, 3 do
                local item = cell:getChildByName("ItemAward_"..k)
                if k<=len then
                    local index = 2+(k-1)*2
                    local img = item:getChildByName("ItemImg_"..k)
                    local path = conf.Item:getItemSrcbymid(data__[index])
                    img:loadTexture(path)   
                    local nameTxt = item:getChildByName("ItemName_1_"..k)
                    local str = conf.Item:getName(data__[index]).."x"..data__[index+1]
                    nameTxt:setString(str)
                    local lv=conf.Item:getItemQuality(data__[index])
                    nameTxt:setColor(COLOR[lv])
                    local framePath=res.btn.FRAME[lv]
                    item:loadTextureNormal(framePath)
                else
                    item:setVisible(false)
                end
            end
            self.starList:pushBackCustomItem(cell)
        end

        local getList = {}
        for p=1, #info do]]
            --getList[info[p]] = 1
        --[[end

        local getCells = {}
        for i=1, #ary do
            if not getList[i] and curTimes >= ary[i][1] then
                table.insert(getCells, ary[i])             
            else
                addCell(ary[i], i, 1)
            end        
        end
        for j=1, #getCells do
            addCell(getCells[j], j, 2)
        end
        self.starList:refreshView()
        self.starList:jumpToPercentVertical(0)]]
    elseif index_ == 1 then  --排名奖励
        info = self.rankData[stars_] or {}
        local len = #info
        if len < 10 then len = 10 end
        local hasMe = false
        for i=1, len do
            local cellInfo
            local cell = self.view:getChildByName("Panel_1"):clone()
            local rankImg = cell:getChildByName("Image_17")
            local rankTxt = cell:getChildByName("Text_13")
            if i <= 3 then
                rankTxt:setVisible(false)
                rankImg:loadTexture("res/views/ui_res/icon/icon_rank"..i..".png")
            else
                rankImg:setVisible(false)
                rankTxt:setString(i)
            end
            local nameTxt = cell:getChildByName("Text_14")
            local starTxt = cell:getChildByName("Text_6_1_0")
            local awardTxt = cell:getChildByName("Text_6_2_0")
            if i > #info then
                nameTxt:setString(res.str.CLIMB_DESC31)
                starTxt:setString("--")
                local zs = conf.Copy:getTowerAward(stars_, i)
                awardTxt:setString(zs)
            else
                cellInfo = info[i]
                nameTxt:setString(cellInfo.uName)
                starTxt:setString(cellInfo.totalStart)
                awardTxt:setString(cellInfo.moneyZs)  
            end
            
            if cellInfo and cellInfo.isSelf == 1 then
                hasMe = true
                if cellInfo.index <= 10 then
                    self.myRank:setString(cellInfo.index)
                    self.myStar:setString(cellInfo.totalStart)
                    self.myAward:setString(cellInfo.moneyZs)
                else
                    self.myRank:setString(res.str.CLIMB_DESC32)
                    self.myStar:setString(cellInfo.totalStart)
                    self.myAward:setString("--")
                end
                
            end
            if i<=10 then
                self.rankList:pushBackCustomItem(cell)
            end          
        end
        if hasMe == false then
            self.myRank:setString("--")
            self.myStar:setString("--")
            self.myAward:setString("--")
        end
        self.rankList:refreshView()
        self.rankList:jumpToPercentVertical(0)
    end
end

---领取奖励
function TowerRankView:onGetClickHandler( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local index = send:getTag() - 1
        -----
        mgr.NetMgr:send(115005, {startIndex=index})
    end
end

function TowerRankView:rTowerGetAward(data_)
    local cell = self.tableView:cellAtIndex(data_.startIndex-1):getChildByName("item")
    local btn = cell:getChildByName("Button_Using_17")
    btn:setTitleText(res.str.CLIMB_DESC33)
    btn:setEnabled(false)
    btn:setBright(false)
end

---数据返回
function TowerRankView:rTowerAward(data_)
    if data_ and #data_.rankInfos>0 then
        self.rankData[data_.rankInfos[1].start] = data_.rankInfos
    end
    self.starAwardData = data_.startInfos
    self:setData(self.pageIndex, self.starIndex)
end

function TowerRankView:onCloseSelfView()
    self.super.onCloseSelfView(self)
end

---------------------------------------------------------------table
function TowerRankView:numberOfCellsInTableView(table)
    local size=#self.tableList
    return size
end
function TowerRankView:scrollViewDidScroll(view)
   
end
function TowerRankView:scrollViewDidZoom(view)
   
end
function TowerRankView:tableCellTouched(table,cell)
    
end
function TowerRankView:cellSizeForTable(table,idx) 
    --local ccsize = self.clonePane:getContentSize()    
    return 160,630
end
function TowerRankView:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local item
    if nil == cell then
        item = self.clonePane:clone()
        cell = cc.TableViewCell:new()
        cell:addChild(item)
        item:setName("item")
        item:setPosition(0, 0)
    else
        item = cell:getChildByName("item")
    end
    print("________________________________", idx)
    local curTimes = cache.Copy.towerData.start
    local data = self.tableList[idx+1]
    local data__ = data.info
    local totalTxt = item:getChildByName("Text_41")
    totalTxt:setString("/"..data__[1])
    local curTxt = item:getChildByName("Text_40")
    curTxt:setString(curTimes)
    local btn = item:getChildByName("Button_Using_17")
    if data.get == 0 then
        if curTimes < data__[1] then
            curTxt:setColor(cc.c3b(255,0,0))
            btn:setEnabled(false)
            btn:setBright(false)
            btn:setTitleText(res.str.CLIMB_DESC33)
        else
            curTxt:setColor(cc.c3b(24,255,0))
            btn:setTag(data.index)
            btn:setTitleText(res.str.CLIMB_DESC33)
            btn:setEnabled(true)
            btn:setBright(true)
            btn:addTouchEventListener(handler(self,self.onGetClickHandler))
        end 
    else
        curTxt:setColor(cc.c3b(24,255,0))
        btn:setEnabled(false)
        btn:setBright(false)
        btn:setTitleText(res.str.CLIMB_DESC34)
    end       
    local len = (#data__-1)/2
    for k=1, 3 do
        local item__ = item:getChildByName("ItemAward_"..k)
        if k<=len then
            local index = 2+(k-1)*2
            local img = item__:getChildByName("ItemImg_"..k)
            local path = conf.Item:getItemSrcbymid(data__[index])
            img:loadTexture(path)   
            local nameTxt = item__:getChildByName("ItemName_1_"..k)
            local str = conf.Item:getName(data__[index]).."x"..data__[index+1]
            nameTxt:setString(str)
            local lv=conf.Item:getItemQuality(data__[index])
            nameTxt:setColor(COLOR[lv])
            local framePath=res.btn.FRAME[lv]
            item__:loadTextureNormal(framePath)
            item__:setVisible(true)
        else
            item__:setVisible(false)
        end
    end
    return cell
end

return TowerRankView