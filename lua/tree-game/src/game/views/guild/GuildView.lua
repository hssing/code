--
-- Author: Your Name
-- Date: 2015-07-31 11:27:25
--

local GuildView = class("GuildView",base.BaseView)

function GuildView:init()
   --proxy.guild:sendCallMember()--进入公会同时请求一下成员信息

    self.ShowAll=true
    self.bottomType = 2
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    --贡献
    local icon = self.view:getChildByName("Panel_25"):getChildByName("Image_83")
    icon:setScale(0.8)

    local offx = 0
    local offy = 0
    icon:setPosition(icon:getPositionX()+offx, icon:getPositionY()+offy)
    --改名
    self.btn_gai = self.view:getChildByName("Panel_25"):getChildByName("Button_close_0")
    self.btn_gai:addTouchEventListener(handler(self,self.onbtnchange))
    self.btn_gai:setTitleText(res.str.RES_GG_36)
    self.btn_gai:setVisible(false)
    --关闭
    self._closeBtn = self.view:getChildByName("Panel_25"):getChildByName("Button_close")
    self._closeBtn:addTouchEventListener(handler(self,self.onBtnCloseCallBack))
    --中部按钮
    for k=11, 14 do
        local btn = self.view:getChildByName("Panel_1"):getChildByName("Button_Guild_"..k)
        btn:addTouchEventListener(handler(self,self.onBtnBottomCallBack))
        btn:setTag(k)
    end
    --效果404826
    local effNode = self.view:getChildByName("Panel_1")
    local posList = {{317,470},{530,260},{120,260},{510,550},{317,470}}
    for j=1, 5 do  
        local params = {id=404826,playIndex=j-1,x=posList[j][1],y=posList[j][2],addTo=effNode,depth=10}
        mgr.effect:playEffect(params)

        local img = effNode:getChildByName("Image_3_"..j)
        if img then 
            effNode:reorderChild(img, 11)
        end 
    end


    --信息
    self._ghName = self.view:getChildByName("Panel_25"):getChildByName("Text_53")
    self.bar = self.view:getChildByName("Panel_25"):getChildByName("LoadingBar_1")
    self.exp = self.view:getChildByName("Panel_25"):getChildByName("exp")
    self.level = self.view:getChildByName("Panel_25"):getChildByName("Image_47")
    self.gx = self.view:getChildByName("Panel_25"):getChildByName("Text_59")  --贡献
    self.gg = self.view:getChildByName("Panel_25"):getChildByName("Text_61")  --公告
    self.people = self.view:getChildByName("Panel_25"):getChildByName("Text_56")  
    self.maxPeople = self.view:getChildByName("Panel_25"):getChildByName("Text_58")  
    self.power = self.view:getChildByName("Panel_25"):getChildByName("Text_57")
    --self.areaRank = self.view:getChildByName("Panel_25"):getChildByName("Text_63")
    --self.worldRank = self.view:getChildByName("Panel_25"):getChildByName("Text_64")
    self:setRedPoint()

    local panel25 = self.view:getChildByName("Panel_25")

    panel25:getChildByName("Text_54"):setString(res.str.GUILD_TEXT12)
    panel25:getChildByName("Text_55"):setString(res.str.GUILD_TEXT13)
    panel25:getChildByName("Text_60"):setString(res.str.GUILD_TEXT34)


    G_FitScreen(self, "Image_1")
end

function GuildView:setData(data)
    self.data = data

    self._ghName:setString(data.guildName)
    local next_exp = conf.guild:getExp(data.guildLevel)
    

    if next_exp and next_exp > 0 then 
        self.exp:setString(data.guildExp.."/"..next_exp)
        self.bar:setPercent(data.guildExp*100/next_exp)
    else
        self.bar:setPercent(100)
        self.exp:setString(data.guildExp.."/"..data.guildExp)
    end 

    --local lv_icon = conf.guild:getSrc(data.guildLevel)
    --self.level:loadTexture(lv_icon)
    self.level:loadTexture(res.icon.GUILD_LV_DI)
    self.level:ignoreContentAdaptWithSize(true)
    if not self.lab_lv then 
        self.lab_lv = cc.LabelAtlas:_create("1",res.font.FLOAT_NUM[4],16,21,string.byte("."))
        self.lab_lv:setAnchorPoint(0.5,0.5)
        self.lab_lv:setPosition(self.level:getContentSize().width/2,self.level:getContentSize().height/2)
        self.lab_lv:addTo(self.level)
    end 
    self.lab_lv:setString(data.guildLevel)




    self.gx:setString(data.guildPoint)
    
    self.power:setString(data.guildPower)
    self.gg:setString(data.guildGonggao)

    self.people:setString(data.guildCount)
    local maxcount = conf.guild:getLimitCount(data.guildLevel)
    if not  maxcount then 
        maxcount = 0
    end 
    self.maxPeople:setString("/"..maxcount)
    self.maxPeople:setPositionX(self.people:getPositionX()+self.people:getContentSize().width/2)
   
    --self.areaRank:setString(data.areaRank or 0 )
    --self.worldRank:setString(data.worldRank or 0 )
    if data.changeNameSign > 0 and  cache.Guild:getSelfJob() == 1 then
        self.btn_gai:setVisible(true) 
    else
        self.btn_gai:setVisible(false)
    end
end


function GuildView:updateName( data )
    -- body
    self.data.guildName = data.name
    self.data.changeNameSign = data.changeNameSign
    self._ghName:setString(data.name)
    if data.changeNameSign > 0 then
        self.btn_gai:setVisible(true)
    else
        self.btn_gai:setVisible(false)
    end
end


function GuildView:setRedPoint()
    -- body
    local function setRedPointPanle( ppa )
        -- body
        --printt(ppa)
        local count = ppa.num--cache.Player:getYJnumber()
        ppa.panle:removeAllChildren()
        local spr = display.newSprite(res.image.RED_PONT)


        spr:setPosition(ppa.panle:getPositionX()+ppa.panle:getContentSize().width/2+ppa.x
            , ppa.panle:getPositionY()+ ppa.y )
        spr:addTo(self.view:getChildByName("Panel_1"),12)
    end


    if cache.Player:getGongHJLNumber() > 0 then  --祈福
        local btn =  self.view:getChildByName("Panel_1"):getChildByName("Button_Guild_11")
        --
        local params = {}
        params.num = -1
        params.x = 38
        params.y = 33
        params.panle = btn

        setRedPointPanle(params)
    end 



   if  cache.Player:getGongHTongGJLNumber() > 0  or 
        (cache.Player:getGongHFuBJLNumber() > 0 and cache.Player:getLevel()>=30) then  --副本有奖励
        local btn =  self.view:getChildByName("Panel_1"):getChildByName("Button_Guild_13")
        local params = {}
        params.num = -1
        params.x = 48
        params.y = 17
        params.panle = btn

        setRedPointPanle(params)
   end 
end

function GuildView:nextStep( p )
    -- body
    local btn = self.view:getChildByName("Panel_1"):getChildByName("Button_Guild_"..p)
    if btn then 
        self:onBtnBottomCallBack(btn,ccui.TouchEventType.ended)
    end 
end

---底排按钮点击
function GuildView:onBtnBottomCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local index = send:getTag()
        print("______________________________________", index)
        if index == 11 then  --公会建筑
            mgr.Sound:playViewGonghuiYanfa()
             mgr.SceneMgr:getMainScene():changeView(2, _viewname.GUIILD_QIFU)
        elseif index == 12 then  --公会科技
            G_TipsOfstr(res.str.GUILD_TEXT11)
        elseif index == 13 then  --公会副本
            mgr.NetMgr:send(117301)
            --local lvl = cache.Player:getLevel()
            --if lvl >= 30 then
            --    mgr.NetMgr:send(117301)
            --else
            --    G_TipsOfstr("公会副本需30级才能攻打")
            --end
            
            --mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_FB_ENTER)
        elseif index == 14 then  --公会商店
            proxy.guild:sendShopMsg()
            proxy.guild:waitFor(517201)
        end
    end
end

function GuildView:onbtnchange( send,eventype )
    -- body
    if eventype == ccui.TouchEventType.ended then
        local view = mgr.ViewMgr:showView(_viewname.CAHNGENAME)
        view:setData1(self._ghName:getString())
    end
end

function GuildView:onBtnCloseCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.SceneMgr:getMainScene():changePageView(1)
        --self:onCloseSelfView()
    end
end



return GuildView