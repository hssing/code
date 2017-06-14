
local MainScene = class("MainScene",base.BaseScene)

function MainScene:ctor()
  	self.ListLayer  =  nil   --层列表
  	self.prvView = nil  --记录上一个view
  	self:_initTabView()
end

function MainScene:init(  )
  	self.ListLayer={}
  	self:addLayer()    --UI 层
  	self:addLayer()    --提示层
  	self:addLayer()    --其他层
  	self:addLayer()    --最上层UI
  	self:addLayer()    --DEBUG
  	self:addLayer()    --引导层	
  	self:addLayer()    --net顶层	
    self:addHornTipsView() ------小喇叭提示层
    mgr.Sound:playMainMusic()
    
end

function MainScene:addLayer()
 	local layer = display.newNode()
 	layer:setContentSize(display.width, display.height)
 	layer:setPosition(0,0)
 	layer:setAnchorPoint(cc.p(0,0))
 	self.ListLayer[#self.ListLayer+1]=layer
 	self:getRootLayer():addChild(layer,#self.ListLayer)
 end


 --------小喇叭消息显示层
 function MainScene:addHornTipsView(  )
   -- body
   -- local layer = mgr.ViewMgr:createView(_viewname.HORNTIPS)
   -- layer:setTouchEnabled(true)
   -- self:getRootLayer():addChild(layer,4)
   -- layer:setTag(9999)
   local view = mgr.ViewMgr:createView(_viewname.HORNTIPS)
   self:addView(view, 8)
 end

 function MainScene:getHornTipsLayer( )
   -- body
   return self:getLayer(#self.ListLayer):getChildByTag(9999)
 end

--override
function MainScene:addView(view,top)
	if top and top > #self.ListLayer then
      if not view:getParent() then
          self.ListLayer[#self.ListLayer]:addChild(view)
      end
		  return
	end
	if not view.showtype  then
		  debugprint("[Error]:  "..view.name.."没有初始化showtype")
	end
  if not view:getParent() then
      self.ListLayer[view.showtype]:addChild(view)
  end
end

--override
function MainScene:loading(callback)
	self:init()
	self:loadingView()
	callback()
end

function MainScene:addHeadView()
	if not self.headview then
		self.headview=mgr.ViewMgr:createView(_viewname.HEAD) --头像
		self:addView(self.headview)
	end
end

function MainScene:closeHeadView()
	if self.headview then
		self.headview:closeSelfView()
		self.headview=nil
	end
end

function MainScene:loadingView()
	--self:addHeadView()
	self.maintoplayerview=mgr.ViewMgr:createView(_viewname.MAIN_TOP_LAYER) --主场景最外按钮层
	self:addView(self.maintoplayerview)
  if g_debug_view ~= false then
      self:addView(mgr.ViewMgr:createView(_viewname.DEBUG),99)
      cc.Director:getInstance():setDisplayStats(true)
	end
end

---添加引导view
function MainScene:addGuideView()
    local view = mgr.ViewMgr:createView(_viewname.GUIDE_VIEW)
    self:addView(view)
    return view
end

---添加loading
function MainScene:addLoading(flag)
    local view = mgr.ViewMgr:createView(_viewname.LOADING_VIEW)
    view:setData(flag)
    self:addView(view)
    return view
end

--防止没有UI层
function MainScene:addUi()
	if self:getUiSize()==0 then
		self:changeView(1)
	end
end

--获得UI层大小
function MainScene:getLayer( type )
	if type > #self.ListLayer or type < 1 then
		debugprint("参数错误！！！"..type)
		return nil
	end
	local layer=self.ListLayer[type]
	return layer
end

function MainScene:closeAllUiView(  )
	for k,v in pairs(self:getLayer(view_show_type.UI):getChildren()) do
		mgr.ViewMgr:closeView(v:getPathName())
	end
end

function MainScene:changePageView(index_)
    self.maintoplayerview:setPageButtonIndex(index_)
end

function MainScene:setOnlyPageIndex(index_)
    self.maintoplayerview:setOnlyPageIndex(index_)
end

function MainScene:closeAllTisView()
  	for k,v in pairs(self:getLayer(view_show_type.TIPS):getChildren()) do
  		  mgr.ViewMgr:closeView(v:getPathName())
  	end
end

--替换UI层view 
function MainScene:changeView( index ,viewname_)
    local __name = viewname_ or self.ui_Name[index]
    --检测功能是否开启
    local isopen , value = mgr.Guide:checkOpen(__name)
    if not isopen and  __name~="pack.PackView" then 
        G_TipsOfstr(string.format(res.str.SYS_OPNE_LV, value.level))
        return nil
    end
  	self:closeAllUiView()
  	self:closeAllTisView()
  	local view
    if __name then
        view = mgr.ViewMgr:createView(__name,nil,__name,index)
  	end
  	self:addView(view)

    print("============",__name)

    -----------------------聊天ICON
    if __name == _viewname.MAIN then
      --todo
      if  self.maintoplayerview then
        --todo
        self.maintoplayerview.btnChat:setVisible(true)
      end

    else

      if  self.maintoplayerview then
        --todo
        self.maintoplayerview.btnChat:setVisible(false)
      end
        
    end

    --------------聊天ICON 结束

  	if view.ShowAll then
  		  self:closeHeadView()
  	else
  		  self:addHeadView()
  	end

    if not view.ShowBottom then 
       if self.maintoplayerview then
        self.maintoplayerview:setVisible(true)
        end 
    else
       if self.maintoplayerview then
        self.maintoplayerview:setVisible(false)
        end 
    end 

    ---底部按钮显示
    if view.bottomType == 2 then  --显示公会
        if self.maintoplayerview then
            self.maintoplayerview:bottomBtnsState(false)
        end
        self:_addGuildBar(true)
    elseif view.bottomType == 1 then 
        if self.maintoplayerview then
            self.maintoplayerview:bottomBtnsState(false)
        end
        self:_addGuildBar(false)
    else
        if self.maintoplayerview then
            self.maintoplayerview:bottomBtnsState(true)
        end
        self:_addGuildBar(false)
    end
  	return view
end

function MainScene:_addGuildBar(state_)
    if state_ == true then
        if not self.guildBar then
            self.guildBar = mgr.ViewMgr:createView(_viewname.GUILD_BAR)
        end
        self:addView(self.guildBar)
    else
        if self.guildBar then
            self.guildBar:removeSelf()
            self.guildBar = nil
        end
    end   
end

function MainScene:_initTabView()
    self.ui_Name={
        _viewname.MAIN, -- 主界面
        _viewname.FORMATION, -- 宠物信息
        _viewname.COPY,  --3副本
        _viewname.ADVENTUREVIEW,--4探险
        _viewname.FUNBENVIEW ,--副本活动入口
        _viewname.ACTIVITY,
        _viewname.PACK,
        _viewname.SHOP,  --8  商店
        _viewname.LUCKYDRAW,--9 抽奖
        _viewname.MAILVIEW,--10 邮件
        _viewname.COMPOSE,--11 装备合成
        _viewname.ACHIEVEMENTVIEW,--12 成就
        _viewname.TASK,--13 任务
        _viewname.SINGNIN, --签到 --14
        _viewname.FRIEND, --好友 --15
        _viewname.CHATTING, --聊天 --16
        _viewname.HORN,--小喇叭--17
        _viewname.CONTEST_WIN_MIAN,--驯兽师大赛
        _viewname.DOUBLE,--双11 --19
        _viewname.RANKENTY,--全民土豪
    }
end

function MainScene:getui_Name()
    return self.ui_Name
end

function MainScene:onEnter()
  	self.super.onEnter(self)
  	if proxy.Login:getLoginBool() then --是否是第一次 开启公告界面
      --跑马灯信息
      proxy.Login:send101103()
      ------------隐藏聊天ICON
        if  self.maintoplayerview then
           self.maintoplayerview.btnChat:setVisible(false)
       end
  		  mgr.ViewMgr:showView(_viewname.SYS_GONGGAO):setData()

        mgr.ViewMgr:needPreAdd()
    end
  	mgr.NetMgr:showNetTips(-3)
end

function MainScene:onExit()
	self.super.onExit(self)
end

return MainScene
