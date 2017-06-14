--
-- Author: Your Name
-- Date: 2015-07-31 20:04:14
--
 
local GuildBar = class("GuildBar",base.BaseView)

function GuildBar:init()
    self.showtype=view_show_type.OTHER
    self.view=self:addSelfView()
    self:setTouchEnabled(false)

    local img = self.view:getChildByName("Panel_41"):getChildByName("Image_87_10")
    img:setVisible(false)
    local img = self.view:getChildByName("Panel_41"):getChildByName("Image_87_0_12")
    img:setVisible(false)
    local img = self.view:getChildByName("Panel_41"):getChildByName("Text_64_4")
    img:setVisible(false)

    --底排按钮
    for i=1, 6 do
        local btn = self.view:getChildByName("Panel_41"):getChildByName("Button_Guild_"..i)
        btn:addTouchEventListener(handler(self,self.onBtnBottomCallBack))
        btn:setTag(i)
    end
    --管理
    self._glNode = self.view:getChildByName("Panel_41"):getChildByName("Panel_45")
    self._glNode:setVisible(false)



    for m=21, 24 do
        local btn = self.view:getChildByName("Panel_41"):getChildByName("Panel_45"):getChildByName("Button_Guild_"..m)
        btn:addTouchEventListener(handler(self,self.onBtnBottomCallBack))
        btn:setTag(m)


    end
    self:initDec()

    self.areaRank = self.view:getChildByName("Panel_41"):getChildByName("Text_63_2")
    self.worldRank = self.view:getChildByName("Panel_41"):getChildByName("Text_64_4")

    self.blackLayer = cc.LayerColor:create(cc.c4b(0,0,0,0),display.width,display.height)
    self:addChild(self.blackLayer)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(function(touch,event)
        debugprint("_____________________________[GuildBar]")
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(function(touch,event)
        if self._glNode:isVisible() == true then
            self._glNode:setVisible(false)
        end
    end,cc.Handler.EVENT_TOUCH_ENDED)
    listener:registerScriptHandler(function(touch,event)
    end,cc.Handler.EVENT_TOUCH_MOVED)
    local eventDispatcher = self.blackLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.blackLayer)

    self:setData()
    self:setRedPoint()

   
end

function GuildBar:initDec( ... )
    -- body
    local Panel_45 = self.view:getChildByName("Panel_41"):getChildByName("Panel_45")
    Panel_45:getChildByName("Button_Guild_21"):setTitleText(res.str.GUILD_DEC_01)
    Panel_45:getChildByName("Button_Guild_23"):setTitleText(res.str.GUILD_DEC_03)
    Panel_45:getChildByName("Button_Guild_22"):setTitleText(res.str.GUILD_DEC_02)
    Panel_45:getChildByName("Button_Guild_24"):setTitleText(res.str.GUILD_DEC_04)
end


function GuildBar:setRedPoint()
    -- body

    local function setRedPointPanle( ppa )
        -- body
        --printt(ppa)
        local count = ppa.num--cache.Player:getYJnumber()
        ppa.panle:removeAllChildren()
        local spr = display.newSprite(res.image.RED_PONT)
        spr:setPosition(ppa.panle:getContentSize().width/2+ppa.x,ppa.panle:getContentSize().height/2+ppa.y)
        
        if count > 0 then 
            spr:addTo(ppa.panle)
            local label = display.newTTFLabel({
                text = count,
                size = 20,
                align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
            })
            label:setPosition(spr:getContentSize().width/2,spr:getContentSize().height/2)
            label:addTo(spr)
        elseif count == -1 then 
            spr:addTo(ppa.panle)            
        end 
    end

    if cache.Player:getShenHeNumber()>0 and cache.Guild:getSelfJob()<3 then
        local params = {}
        params.num = -1 
        params.x = 33
        params.y = 36
        params.panle = self.view:getChildByName("Panel_41"):getChildByName("Button_Guild_4")
        setRedPointPanle(params)

        local params = {}
        params.num = -1 
        params.x = 50
        params.y = 10
        params.panle = self.view:getChildByName("Panel_41"):getChildByName("Panel_45"):getChildByName("Button_Guild_22")
        --setRedPointPanle(params)
    end  
end

function GuildBar:setData()
    -- body
    local _job = cache.Guild:getSelfJob()
     -- _job = 2 --2015 8 25 更新特殊屏蔽
    if _job > 1 then 
        --self._glNode:removeChildByName("Button_Guild_24", true)
        local btn = self._glNode:getChildByName("Button_Guild_24")
        local _btn_size = btn:getContentSize()
        local img =self._glNode:getChildByName("Image_104_30") 
        local _img_size = img:getContentSize()
        img:setContentSize(_img_size.width,_img_size.height-_btn_size.height)

        btn:removeFromParent()
    end   

    self.data = cache.Guild:getGuildBaseInfo()
    self.areaRank:setString(self.data.areaRank or 0 )
    self.worldRank:setString(self.data.worldRank or 0 )
end

--退出公会
function GuildBar:outGuild()
    -- body
     if cache.Guild:getSelfJob() == 1 and cache.Guild:getGuildCount() > 1 then 
        G_TipsOfstr(res.str.GUILD_DEC35)
        return 
    end 

    local data = {}
    data.richtext = res.str.GUILD_DEC18
    data.surestr = res.str.SURE
    data.sure = function ()
        -- body
        local data = cache.Player:getRoleInfo()
        local params = {roleId = data.roleId }
        proxy.guild:sendTuichu(params)
    end
    data.cancel = function( ... )
        -- body
    end
    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
end

---底排按钮点击
function GuildBar:onBtnBottomCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local index = send:getTag()
        print("______________________________________", index)
        if index == 1 then  --本区排行
            local view = mgr.ViewMgr:get(_viewname.GUILD_TWO_RABK)
            if not view then 
                view = mgr.ViewMgr:showView(_viewname.GUILD_TWO_RABK)
                view:pageviewChange(1)
            end 
            --[[proxy.guild:sendBenQuguildRank(1)
            proxy.guild:waitFor(517304)]]--
        elseif index == 2 then  --世界排行
            G_TipsOfstr(res.str.ROLE_GONGHUI)
            --mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_WORLD_RANK)
        elseif index == 3 then  --管理
            local v = not self._glNode:isVisible()
            self._glNode:setVisible(v)
        elseif index == 4 then  --成员
            mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_MEMBER)
        elseif index == 5 then  --动态
           -- proxy.guild:sendDongtai()
            mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_DT)
            local view = mgr.ViewMgr:get(_viewname.GUILD_DT)
            if view then 
               proxy.guild:sendDongtai()
            end 
        elseif index == 6 then  --返回
            local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
            if view then 
                G_mainView()
            else
                G_MainGuild()
            end 
        elseif index == 21 then  --退出公会
            self:outGuild()
        elseif index == 22 then  --成员审核
            mgr.SceneMgr:getMainScene():changeView(2, _viewname.GUILD_MEMBER)
        elseif index == 23 then  --发布公告
            if cache.Guild:getSelfJob() <3 then 
                mgr.ViewMgr:showView(_viewname.GUILD_CHANGE)
            else
                G_TipsOfstr(res.str.GUILD_DEC9)
            end 
        elseif index == 24 then 
            -- mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_JOB)
            mgr.ViewMgr:showView(_viewname.GUILD_JOB)
        end
    end
end

function GuildBar:onBtnCloseCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.SceneMgr:getMainScene():changePageView(1)
    end
end

return GuildBar