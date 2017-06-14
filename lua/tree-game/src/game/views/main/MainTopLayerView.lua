local MainTopLayerView=class("MainTopLayerView",base.BaseView)


function MainTopLayerView:init()
  	self.showtype=view_show_type.OTHER
  	self.view=self:addSelfView()
  	self:setTouchEnabled(false)
  	self.Panel_down=self.view:getChildByTag(1001)
  	self.PageButton=gui.PageButton.new()
  	self.PageButton:setBtnCallBack(handler(self,self.ListButtonCallBack))
  	self.Panel_up=self.view:getChildByTag(1002)
  	self.c_height=self.Panel_up:getContentSize().height/2

  	self.ListGUIButton={}  --GUI按钮容器
  	local size=3
  	for i=1,size do
  		 local btn=self.Panel_down:getChildByTag(1):getChildByTag(i)
  		 self.PageButton:addButton(btn)
  		 local gui_btn
       if i == 2 then
          gui_btn =gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=40,y=10})
       else
         gui_btn =gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})
       end
      
  		 gui_btn:getInstance():setPressedActionEnabled(false)
  		 self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
  	end
  	for i=1,size do
  		 local btn=self.Panel_down:getChildByTag(2):getChildByTag(i)
  		 self.PageButton:addButton(btn)
  		 local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})
  		 gui_btn:getInstance():setPressedActionEnabled(false)
  		 self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
  	end

      ------聊天按钮
     self.btnChat = self.view:getChildByName("Button_chat")
     self.btnChatRedPoint = self.btnChat:getChildByName("other_redpoint")
     self.btnChatRedPoint:setVisible(true)
     self.btnChat:setTouchEnabled(true)
     self.btnChat:setSwallowTouches(true)
     
     
    ---触摸拖动层
    self.btnChat:addTouchEventListener(handler(self,self.chatCallback))
    self.btnChat:retain()
    self.btnChat.showtype = view_show_type.GUIDE
    self.btnChat:removeFromParent()
    mgr.SceneMgr:getMainScene():addView(self.btnChat,5)
    self.view:reorderChild(self.btnChat,0)
    self.btnChat:setLocalZOrder(0)
    self.btnChat:release()
    
    ---读取坐标
    local x,y = self:readChatIconPos()
   
    if x and y then

       self.btnChat:setPosition(x,y)

     else
       self.btnChat:setPosition(self.btnChat:getPositionX(),self.btnChat:getPositionY())
    end


  	self:createMarquee()
  	self:setPageButtonIndex(1)
  	self:setRedPoint()
  	self.guideList = {{1004,1015,1029,1053},{1008,1020,1038,1041,1045,1056},{1001,1011,1025,1041,1049,1059}}
end
--双11活动的时候有个东西
function MainTopLayerView:initActive11( ... )
  -- body
    if self.a11 then 
        return 
    end

    --[[self.a11 =  display.newSprite(res.image.bg_a11)
    self.a11:setPositionX(display.cx)
    self.a11:setPositionY(self.Panel_down:getChildByTag(1):getContentSize().height)
    self.a11:addTo(self.view) ]]--
end

function MainTopLayerView:clearAcitve11()
  -- body
  if self.a11 then 
    self.a11:removeFromParent()
    self.a11 = nil 
  end
end



function MainTopLayerView:setRedPoint()
    --活动
  	local num = 0 
  	num = num + cache.Player:getZCnumber() 
   -- print("=========getZCnumber===========",num)
    num = num+ cache.Player:getChiJnumber()
   -- print("=========getChiJnumber===========",num)
    num = num + cache.Player:getDengJJLNumber()
   --  print("=========getDengJJLNumber===========",num)
    num = num + cache.Player:getDanCNumber()--单笔
   --  print("=========getDanCNumber===========",num)
    num = num + cache.Player:getLeiCNumber()--累充
   --  print("=========getLeiCNumber===========",num)
    num = num + cache.Player:getMeiRiNumber()--首充
   --   print("=========getMeiRiNumber===========",num)
    num = num + cache.Player:getOpenActPraiseNumber()--开服活动点赞
   --  print("=========getOpenActPraiseNumber===========",num)
    num = num + cache.Player:getTthlRedpoint()--天天豪礼
   --  print("=========getTthlRedpoint===========",num)
    --num = num + cache.Player:getXfhlRedpoint()--消费豪礼
    -- print("=========getXfhlRedpoint===========",num)

    if cache.Player:getMonth()~=3 then
        num = num + cache.Player:getMonth()--月卡活动红点
       --  print("=========getMonth===========",num)
    end

    if cache.Player:get100() == 2 then 
        num = num +1 
     --    print("=========get100===========",num)
    end
  	self.ListGUIButton[6]:setNumber(num)
  	--战役 按体力提示
  	self.ListGUIButton[3]:setNumber(cache.Player:getTili())
    --屠魔
    local count = cache.Player:getAdventCount()
    self.ListGUIButton[4]:setNumber(count)
    --检测功能的是佛开启
    local isopen , value = mgr.Guide:checkOpen(_viewname.ADVENTUREVIEW)
    if not isopen then 
        self.ListGUIButton[4]:setNumber(0)
    end


    ---队形
    self:setDuiXingRedPoint()

   

    --副本
    self:setFbRed()
    
    --聊天
    self:setChatNumber(cache.Player:getChatNumber())
end

--队形红点
function MainTopLayerView:setDuiXingRedPoint(  )
    local BattleData = {}
    local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
    local num = cache.Player:getFruitRedpoint()
    local red = 0
    for k,v in pairs(data) do
       local index = conf.Item:getBattleProperty(v)
       if index > 0 and G_getRedPointAtIdx(num,index) then
         red = -1
         break
       end
    end

    self.ListGUIButton[2]:setNumber(red)
end





---------设置聊天红点
function MainTopLayerView:setChatNumber( value )
  -- body
  if value <= 0 then
    --todo
    self.btnChatRedPoint:setVisible(false)

  elseif value > 0 then
    self.btnChatRedPoint:setVisible(true)
  end
end

function MainTopLayerView:setFbRed()
    --副本
    local count = cache.Player:getAthleticsCout()
    local isOpen = true
    local lv = cache.Player:getLevel()
    if cache.Player:getLevel() < conf.active:getFBOpenLevel() then
        isOpen = false
    end

    --文件岛
    local c = cache.Player:getDigNumber()
    local countcross =  cache.Player:getCrossRedpoint()
    if (count > 0 and lv >=17) or (cache.Player:getTowerNumber()==1 and lv >=35) 
      or (cache.Player:getBaoMingNumber()>0 and lv >= 25) or (c > 0 and lv >=32) and  isOpen
      or cache.Player:getDayFubenNumber()>0 and (lv >= 50 and  countcross > 0) then 
      self.ListGUIButton[5]:setNumber(-1)
    else
      self.ListGUIButton[5]:setNumber(0)
    end

   --[[if (count > 0 or cache.Player:getTowerNumber()==1 or cache.Player:getBaoMingNumber()>0 or c > 0) and isOpen then
        self.ListGUIButton[5]:setNumber(-1)
    else
        self.ListGUIButton[5]:setNumber(0)
    end]]
end

---------------聊天按钮移动点击处理,长按0.8秒可拖动
function MainTopLayerView:longMove(  )
  -- body
  if  self.timer == nil then
    --todo
    self.timer = 0
  end

  self.timer = self.timer +1
  if self.timer > 1 then
    self:stopAllActions()
  end

end

--聊天按

function MainTopLayerView:chatCallback( send,etype )
  -- body
  if etype == ccui.TouchEventType.moved then
      local x = send:getTouchMovePosition().x
      local y = send:getTouchMovePosition().y
      local px = self.btnChat:getPositionX()
     local py = self.btnChat:getPositionY()
     local w = self.btnChat:getContentSize().width/4
     local h = self.btnChat:getContentSize().height/4

       if x - w <= 0 or x + w >= display.width  then
         return
       end
       if y - h <= 0 or y + h >= display.height then
         return
       end


    if self.timer == nil then
       -- self:stopAllActions()
       -- self.timer = nil
    elseif self.timer >= 1 then
      --todo
       self.btnChat:setPosition(x,y)
    end

  elseif etype == ccui.TouchEventType.began then
    local timeTick = self:schedule(self.longMove, 1)
  elseif etype == ccui.TouchEventType.ended then
     self:stopAllActions()
    if self.timer and self.timer >= 1 then
       self:saveChatIconPos(self.btnChat:getPosition())
    else
        local view = mgr.SceneMgr:getMainScene():changeView(16)
        view:EnterChattingView()
    end
    self.timer = nil
   
  end
  
end

-----保存聊天icon位置
function MainTopLayerView:saveChatIconPos( x,y )
  -- body
  local key = g_var.debug_accountId .."_".. user_default_keys.CHATICON_POS
  local posStr = x .. "_"..y
  MyUserDefault.setStringForKey(key,posStr)

end

----读取聊天Icon的位置
function MainTopLayerView:readChatIconPos(  )
  -- body
  local key = g_var.debug_accountId .."_".. user_default_keys.CHATICON_POS
  local posStr = MyUserDefault.getStringForKey(key)
  if posStr == nil or posStr == "" then
    --todo
    return nil
  end

  local starX,endX = string.find(posStr,"_")
  print(posStr)
  
  local x = tonumber(string.sub(posStr,1,starX-1))
  local y = tonumber(string.sub(posStr,endX+1,string.len(posStr)))

  return x,y
end


function MainTopLayerView:setPageButtonIndex(i)
  	self:toinitlistbtn()

    if load_main_view == true then
       
        self.PageButton:initClick(i)
    end
   
end

function MainTopLayerView:setOnlyPageIndex(i)
    self:toinitlistbtn()
    self.PageButton:setSelectButton(i)
end

function MainTopLayerView:createRichText(i)
  	local richText = ccui.RichText:create()
  	richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,"欢迎来到究极数码暴龙，次日登录即领酷炫【六星狮子兽】，七日登录即领狂拽【七星机械暴龙兽X】",res.ttf[1],20))
  	--richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(0,255,0),255,"跑马灯!","Helvetica",20))
  	--richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(0,0,255),255,"end","Helvetica",20))
  	richText:formatText()
  	--richText:setPosition(640+richText:getVirtualRendererSize().width/2,self.c_height-2)
  	richText:setAnchorPoint(cc.p(0.5,0.5))
  	return richText
end

---显示/隐藏下面按钮
function MainTopLayerView:bottomBtnsState(state_)
    local btnBar = self.view:getChildByName("Panel_Main_down")
    if btnBar:isVisible() ~= state_ then
        btnBar:setVisible(state_)
    end  
end

--跑马灯
function MainTopLayerView:createMarquee()
    local top_img = self.Panel_up:getChildByTag(149)
    top_img:removeAllChildren()

    local richText = ccui.RichText:create()
    local str_rich= cache.Player:getGongGao()
    --print(str_rich)
    --[[ {
      "欢迎来到究极数码暴龙,首充送炫酷#255,255,255#20|【6星大地暴龙兽】#255,0,0#20"
      ,"【6星大地暴龙兽】#255,0,0#20"
      ,",七日登陆即送狂拽#255,255,255#20"
      ,"【6星狮子兽】#255,0,0#20"
      ,",更多活动请关注右下角#255,255,255#20"
      ,"【活动】#255,95,5#20"
      ,"按钮。#255,255,255#20"
      ,"     切勿相信任何出售钻石,送首充,进YY等欺骗信息！！！。#255,255,255#20"
    }]]
    local _str = string.split(str_rich,"|")
   -- printt(_str)

    local str_richtext = {}
    for k , v in pairs(_str) do 
        table.insert(str_richtext,v)
    end


    for i = 1 , #str_richtext do 
        --print(str_richtext[i])
        local strtable = string.split(str_richtext[i],"#")
       -- print(strtable[1]) 
        if not strtable[2] then 
            strtable[2] = 1
        end

        if not strtable[3] then 
          strtable[3] = 20
        else
          if checknumber(strtable[3]) == 0 then 
             strtable[3] = 20
          end
        end
        --print( strtable[3] .. " strtable[3]")

        --local colortable = string.split(strtable[2],",")
        local color = COLOR[tonumber(strtable[2])]  --cc.c3b(colortable[1],colortable[2],colortable[3])
        local fontSize = strtable[3]

        richText:pushBackElement(ccui.RichElementText:create(1,color,255,
        strtable[1],res.ttf[1],fontSize))
    end 

    --[[richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,
    "欢迎来到究极数码暴龙,次日登录即领酷炫",res.ttf[1],20))
    richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,95,5),255,
    "【六星狮子兽】",res.ttf[1],20))-- cc.c3b(255,95,5),       -- 橙
     richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,
    "七日登录即领狂拽",res.ttf[1],20))
     richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,0,0),255,
    "【七星机械暴龙兽X】",res.ttf[1],20))]]--
   
    richText:formatText()
    richText:setAnchorPoint(0.5,0.5)

    
    richText:setPositionX(display.width+richText:getVirtualRendererSize().width/2)
    richText:setPositionY(top_img:getContentSize().height/2)
    richText:addTo(top_img)

  
    local time=display.width/30

    local a1 = cc.MoveTo:create(time,cc.p(-richText:getVirtualRendererSize().width/2,top_img:getContentSize().height/2))
    local a2 = cc.CallFunc:create(function( ... )
      -- body
       richText:setPositionX(display.width+richText:getVirtualRendererSize().width/2)
    end)
    local a3 = cc.DelayTime:create(10)

    local sequence =cc.Sequence:create(a1,a2,a3)
    local forver = cc.RepeatForever:create(sequence)

    richText:runAction(forver)
  	--[[local distance=display.width 
  	local speed=40
  	local time=distance/speed
  	local i= 1
  	local function run(i)
    		local richtext=self:createRichText(i)
    		self.Panel_up:getChildByTag(149):addChild(richtext)
    		local action1=cc.MoveTo:create(time,cc.p(-richtext:getVirtualRendererSize().width/2,richtext:getPositionY()))
    		local action2=cc.CallFunc:create(function ()
		        richtext:removeFromParent()
    				i=i+1
    				run(i)
    		end)
       
    		richtext:stopAllActions()
       
        --transition.playAnimationForever(richtext, cc.Sequence:create(action1,action2), 5)
    	  richtext:runAction(  cc.Sequence:create(action1,action2,action3))
  	end
  	run(i)	]]--
end

function MainTopLayerView:ListButtonCallBack(index,eventtype,noClick)
    self:checkGuide(index)
    self:clearAcitve11()
    G_ClearTexture____()
    --活动界面等网络请求返回后在播音效
    if not noClick and index ~= 6 then
        self:playSound(index)
    end
    if index == 2 then 
       if not G_CheckData() then 
         return 
       end 
    end   
    --G_ClearTexture____()
    --活动，请求活动开关
    if index == 6 then

      local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
      if view then
        --播放招财音效
        mgr.Sound:playViewZhaocaiShuohua()
         return self
      end
      proxy.Active:reqSwitchState(1001)
      return
    end

    --检查是否有升级
    G_DelayRoleUp()

    return mgr.SceneMgr:getMainScene():changeView(index)	
end

function MainTopLayerView:checkGuide(index)
    if not self.guideList then return end
    local ids = self.guideList[index]
    if ids then
        mgr.Guide:continueGuide__(ids)
    end
end

function MainTopLayerView:playSound(index)
    if index == 1 then
        
    elseif index == 2 then
        mgr.Sound:playViewDuiXing()
    elseif index == 3 then
        mgr.Sound:playViewZY()
    elseif index == 4 then
        mgr.Sound:playViewTX()
    elseif index == 6 then
        mgr.Sound:playViewZhaocaiShuohua()
    end
end

function MainTopLayerView:toinitlistbtn()
    self:clearAcitve11()
  	if self.PageButton.ListButton then 
    		self.PageButton.prvButton = nil 
    		for k ,v in pairs(self.PageButton.ListButton) do 
    			v:setHighlighted(false)
    			v:setTouchEnabled(true)
    		end 
  	end
end




return MainTopLayerView