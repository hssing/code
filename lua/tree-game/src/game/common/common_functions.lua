---创建自定义类

function CreateClass(PackagePath,...)
    local PackageName="game."..PackagePath
    -- debugprint("calssPath: "..PackageName)
    local class=require(PackageName).new(...)
    return class
end

--一个全局的倒计时
function G_onesecond(dt)
    -- body
    local value = 0
    local time = os.time()
    if g_timer_com == 0 then 
        g_timer_com =  time
        value = 1 
    elseif time - g_timer_com > 0  then
        value = time - g_timer_com
        g_timer_com = time
    end  
    --debugprint("时间差： "..value) 
    if value <= 0 then
        return 
    end 

    if  cache.Player:getSeverTime() then 
        cache.Player:setSeverTime(cache.Player:getSeverTime()+value)
    end
 
    --体力
    if cache.Player:getTili() < cache.Player:getMaxtli() then 
        --getTiliTimesReset
        local lasttime = cache.Player:getTiliTimes() 
        --print("lasttime = "..lasttime)
        if lasttime == 0 then 
            lasttime = cache.Player:getTiliTimesReset() 
        end 
        lasttime = lasttime - value 
        
        if lasttime < 0 then 
            lasttime = 0 
        end 

        if lasttime == 0 then 
            local count = math.min(cache.Player:getTili()+1,cache.Player:getMaxtli())
            cache.Player:_setTli(count)
        end 
        cache.Player:_setTiliTimes(lasttime)
    end 

    --探险
    --print("cache.Player:getAdventCount() ="..cache.Player:getAdventCount())
    --print("cache.Player:getAdventMaxCount() ="..cache.Player:getAdventMaxCount())
    if cache.Player:getAdventCount() < cache.Player:getAdventMaxCount() then 
        local lasttime = cache.Player:getAdventTime() 
        if lasttime == 0 then 
            lasttime = cache.Player:getAdventresetTime() 
        end 
        lasttime = lasttime - value 
        if lasttime < 0 then 
            lasttime = 0 
        end 
        if lasttime == 0 then 
            local count = math.min(cache.Player:getAdventCount()+1,cache.Player:getAdventMaxCount())
            cache.Player:_setAdventCount(count)
            cache.Adventure:setlastCount(count)
        end 
        cache.Player:_setAdventTime(lasttime)
        cache.Adventure:_setLastTime(lasttime)
    end 

      --print("cache.Player:getAthleticsCout() "..cache.Player:getAthleticsCout())
     -- print("cache.Player:getMaxAthleticsMax() "..cache.Player:getMaxAthleticsMax())
      --print("cache.Player:getAthleticsTimerest() "..cache.Player:getAthleticsTimerest())
    --竞技
    if cache.Player:getAthleticsCout() < cache.Player:getMaxAthleticsMax() then 

        local lasttime = cache.Player:getAthleticsLastTime() 
        if lasttime == 0 then 
            lasttime = cache.Player:getAthleticsTimerest() 
        end 
        lasttime = lasttime - value 
        if lasttime < 0 then 
            lasttime = 0 
        end 
        if lasttime == 0 then 
            local count = math.min(cache.Player:getAthleticsCout()+1,cache.Player:getMaxAthleticsMax())
            cache.Player:_setAthleticsCout(count)
        end 
        cache.Player:_setAthleticsLastTime(lasttime)
    end 

    if cache.Shop:getlastTime() and cache.Shop:getRecordTime() then 
        local lasttime = cache.Shop:getlastTime()
         lasttime = lasttime - value
         if lasttime < 0 then 
            lasttime = 0 
        end 
        cache.Shop:setlastTime(lasttime)
    end 
    --数码大赛
    local t = cache.Contest:getContest()
    if t.lastTime and t.lastTime>0 then 
        t.lastTime = t.lastTime - value
        if t.lastTime<0 then 
            t.lastTime = 0
        end 
    end 
    --文件岛
    local t = cache.Dig:getMainData()
    if t and t.wkList then
        for k ,v in pairs( t.wkList) do 
            v.lastTime = v.lastTime-1
            if v.lastTime<0 then 
                v.lastTime = 0
            end 
        end 
    end
    --显示道具
    local  t = cache.Pack:getTypePackInfo(pack_type.PRO)
    for k, v in pairs(t) do 
        if v.propertys[40108] then 
            v.propertys[40108].value = v.propertys[40108].value + value
        end 
        if v.propertys[40109] then 
            v.propertys[40109].value = v.propertys[40109].value - value
            if v.propertys[40109].value <= 0 then 
                v.propertys[40109].value = 0
            end
        end
        if v.propertys[40110] then 
             v.propertys[40110].value = v.propertys[40110].value - value
            if v.propertys[40110].value <= 0 then 
                v.propertys[40110].value = 0
            end
        end
    end
    --跨服战倒计时
    local t = cache.Cross:getKFdata()
    if t and t.figthCount then
        if t.figthCount >= conf.Recharge:getVipLimit(cache.Player:getVip(),40358) then
            t.nextFightCountTime = conf.Sys:getValue("cross_time_back")
        else
            if not t.nextFightCountTime then
                t.nextFightCountTime = conf.Sys:getValue("cross_time_back")
            end
            t.nextFightCountTime = t.nextFightCountTime - 1
            if t.nextFightCountTime < 0 then
                t.figthCount = t.figthCount + 1
                t.nextFightCountTime = conf.Sys:getValue("cross_time_back")
            end
        end
    end
    --王者之站倒计时
    local t = cache.Cross:getWinData()
    if t and t.nextTime then
        t.nextTime = t.nextTime - 1
        if t.nextTime < 0 then
            t.nextTime = 0
        end
    end
    --世界boss
    local t = cache.Boss:getData()
    if t then
        if t.remainTime then
            t.remainTime = t.remainTime - 1
            if t.remainTime < 0 then
                t.remainTime = 0
            end
        end

        if t.rebornTime then
            t.rebornTime = t.rebornTime - 1
            if t.rebornTime < 0 then
                t.rebornTime = 0
            end
        end

        if t.startToEndTime then
            t.startToEndTime = t.startToEndTime - 1
            if t.startToEndTime < 0 then
                t.startToEndTime = 0
            end
        end
    end
end


function vector2table(src_,key_,val_)
    if src_ == nil or key_ == nil or type(src_) ~= "table" then 
       -- print("qqqqquitttttttt",src_,key_,type(src_))
        return {}
    end 
    local ret = {}
    for i,v in ipairs(src_) do 
        if val_ then   
            ret[v[key_]] = v[val_]
        else
            ret[v[key_]] = v
        end 
    end 
    --[[ print("------------------------------------")
     print("--      decoding vector           --")
     --test 
     for k,v in pairs(ret) do 
         print("key:",k,"value:",v)
     end ]]

    return ret
end 

--跳转到合成



--在屏幕中间跳字
function G_TipsOfstr( str )

    if str == res.str.NO_ENOUGH_PACK then 


        local data = {}
        data.sure = function( ... )
            -- body
            local view =  mgr.ViewMgr:get(_viewname.SHOP_BUY)
            if view then 
                view:onCloseSelfView()
            end 

            local view = mgr.ViewMgr:get(_viewname.GUILD_FB_REWARD)
            if view then 
                view:onCloseSelfView()
            end 

            local viewdata = {"COMPOSE",0}
            --G_View(viewdata)
            G_GoToView(viewdata)
        end
        data.cancel = function( ... )
            -- body
        end
        data.richtext  = str..","..res.str.NO_ENOUGH_COMPOSE.."?"
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
        return 
    elseif str == res.str.MAIL_NOMOREMESSAGE  then
        --todo
        return 
    elseif str == res.str.NO_ENOUGH_ZS then
        local data  = {}
        data.richtext = res.str.NO_ENOUGH_ZS
        data.sure = function( ... )
            -- body
            G_GoReCharge()
        end
        data.surestr = res.str.SURE
        data.cancel = function( ... )
            -- body
        end
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
        return
    end 
  
    local sequence = transition.sequence({
    cc.Spawn:create(cc.FadeIn:create(0.5) ,
        cc.MoveTo:create(1.0,cc.p(display.cx,display.cy+100))),
    cc.DelayTime:create(0.5),
    })
    G_TipsAction(str,sequence,{Opacity = 0})
end

--param.Opacity  如果有淡入动画 要设置透明
function  G_TipsAction( str,aciton ,param)
    -- body
    local NowShowScene = mgr.SceneMgr:getNowShowScene();
    local _img = NowShowScene:getChildByName("tips")
    if _img ~= nil then 
        _img:removeFromParent();
    end 

    local spr = display.newSprite(res.other.TISHI)

    local _img = display.newScale9Sprite(res.other.TISHI,display.cx,display.cy
        ,cc.size(500, 60),spr:getContentSize())
    _img:setName("tips")
    NowShowScene:addChild(_img)
    
    if param and param.Opacity then
        _img:setOpacity(param.Opacity)
        _img:setCascadeOpacityEnabled(true)
    end

    local label = display.newTTFLabel({
    text = str,
    font = res.ttf[1],
    size = 30,
    color = COLOR[1], 
    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
    })
    label:setAnchorPoint(cc.p(0.5,0.5))
    --label:enableOutline(cc.c4b(255,0,0,100),2)


    local x = _img:getContentSize().width/2
    local y = _img:getContentSize().height/2
    label:setPosition(x,y)   
   
    _img:addChild(label)
    local  _fun_action=cc.CallFunc:create(
        function (  )
            _img:removeFromParent()
        end)
    local _aciton=cc.Sequence:create(aciton,_fun_action)
    _img:runAction(_aciton)
end
--向上Tips移动
function G_TipsMoveUpStr( str )
    local time = 1
    local action1 = cc.MoveTo:create(time,cc.p(display.cx,800))
    local action2 = cc.FadeOut:create(time)
    local action3 = cc.Spawn:create(action1,action2)
    G_TipsAction(str,action3)
end
--主页面下面那5个按钮初始状态
function G_setMaintopinit()
    -- body
    local _view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
    if _view then 
        _view:toinitlistbtn()
    end 
end

--跳去充值
function G_GoReCharge(var)
    -- body
    if not var then
        var = 0
    end
    proxy.shop:setmoney(var)

    local _view =mgr.ViewMgr:get(_viewname.CONTEST_WIN_SET)
    if _view then
        _view:onCloseSelfView()
    end

    local _view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_SET_SECOND)
    if _view then
        _view:onCloseSelfView()
    end

   

    
   local view =  mgr.ViewMgr:get(_viewname.SHOP)
   if view then 
        view:initClickPage(4)
   else
      G_setMaintopinit()
      --[[local _view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
      if _view then 
        _view:setPageButtonIndex(1)
       end]]--
      mgr.SceneMgr:getMainScene():changeView(4,_viewname.SHOP)
   end
end

--弹出tips 金币=1，钻石=2，徽章=3 
function G_TipsForNoEnough( moneyType )
    -- body
    local  str  = "";
    if moneyType ==1 then 
        str = res.str.NO_ENOUGH_JB 
    elseif moneyType == 3 then 
        str = res.str.NO_ENOUGH_HZ 
    else
        str = res.str.NO_ENOUGH_ZS 
    end
    if moneyType == 1 or moneyType == 3  then --or moneyType == 2
        G_TipsOfstr(str);
        return 
    end 

    --[[if g_recharge then 
         G_TipsOfstr(str);
         return 
    end ]]--

    local function surecallbcak( ... )
        -- body
       G_GoReCharge()
       local view = mgr.ViewMgr:get(_viewname.GUILD_LIST)
       if view then 
            view:onCloseSelfView()
       end 
       local view = mgr.ViewMgr:get(_viewname.GUILD_CREATE)
       if view then 
            view:onCloseSelfView()
       end 
       local view = mgr.ViewMgr:get(_viewname.DIG_JIASU_SECOND)
       if view then 
            view:onCloseSelfView()
       end 

       local view = mgr.ViewMgr:get(_viewname.DIG_CHOOSE)
        if view then 
            view:onCloseSelfView()
       end 
        --debugprint("确定按钮返回")
    end 

    local function cancelcallbcak()
        --确定按钮返回
    end 

    local data = {};

    data.richtext = str;
    data.sure = surecallbcak
    data.cancel = cancelcallbcak
    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
end
--背包已经满了 跳转到背包
function G_GotoPack(str )
    -- body
    local function surecallbcak( ... )
        -- body
        debugprint("确定按钮返回")
        local _view =mgr.ViewMgr:get(_viewname.PACKGETITEM)
        if _view then
            _view:closeSelfView()
        end

        local _view =mgr.ViewMgr:get(_viewname.CONTEST_WIN_SET)
        if _view then
            _view:onCloseSelfView()
        end

        local _view =mgr.ViewMgr:get(_viewname.CONTEST_WIN_SET_SECOND)
        if _view then
            _view:onCloseSelfView()
        end


        G_setMaintopinit()
        local view = mgr.SceneMgr:getMainScene():changeView(7)
        view:selectpage(3) 
    end 

    local function cancelcallbcak()
        --确定按钮返回
       -- mgr.ViewMgr:closeView(_viewname.TIPS)
        debugprint("取消按钮返回")
    end 

    local data = {};

    data.richtext = str
    data.sure = surecallbcak
    data.cancel = cancelcallbcak
    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)

end


--打开道具详细信息(本地信息)
function G_openItem(mid,lv)
    local itemType = conf.Item:getType(mid)
    if itemType == pack_type.EQUIPMENT then
        G_OpenEquip({mId=mid},true)
    elseif itemType == pack_type.PRO then
        local data = {}
        data.mId = mid
        mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(data,true)
    elseif itemType == pack_type.SPRITE then
        local data = {}
        data.mId = mid
        G_OpenCard(data,true)
    elseif itemType ==  pack_type.RUNE then
        local data = {}
        data.mId = mid
        if not data.propertys then
            data.propertys = {}
            data.propertys[315] = {value = 0}
        end

        local t = G_CalculateRunePro(data)
        G_OpenRun(t,true)
    elseif itemType ==  pack_type.MATERIAL then
        --mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(data,true)
        G_OpenMaterial({mId = mid })
    end
end
--查看符文
function G_OpenRun( data_,flag )
    -- body
    local data = clone(data_)
    local view2 = mgr.ViewMgr:get(_viewname.RUNE_MSG)
    if view2 then
        view2:updateinfo(data,true)    
    else
        view2 = mgr.ViewMgr:showView(_viewname.RUNE_MSG)
        view2:updateinfo(data,true)    
    end

    --view:updateinfo(data,true)    
end

--查看材料
function G_OpenMaterial(data)
    --  local data = {}
    -- data.mId = mid
     mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(data,true)

end


---跳转都 对应模式。对应章节。对应关卡
function G_GotoChapter(data_)
     local index = data_.chapter
     local id = data_.level*1000+index  --章节id
     local _, data = cache.Copy:getData(id)  --获取章节数据
     cache.Copy.curHardLevel = data_.level
     cache.Fight.curFightIndex =data_.index
     print(" cache.Fight.curFightIndex===模式===",data_.index,data_.level)

     --本地有缓存
     if data then
        G_GotoChapterPrepare()
        return
     end
     --否则，请求数据
    proxy.copy:setJumpToData(data_)
    mgr.NetMgr:send(107001,{cId=id})
end

function G_GotoChapterPrepare(  )
    local viewList = {
        _viewname.PRO_TIPS,
        _viewname.FRUIT_COMPOSE,
        _viewname.FRUIT_COMPOSE_PAGE,
        -- _viewname.FORMATION,
        -- _viewname.PALACE,
        -- _viewname.RANKENTY,
         _viewname.PACK,
        -- _viewname.PACK_MAP,
        _viewname.RANKENTY,

    }

    for i,v in ipairs(viewList) do
       local view = mgr.ViewMgr:get(v)
       if view then
          view:closeSelfView()
       end
       if v ==  _viewname.RANKENTY or v == _viewname.PACK then
           mgr.SceneMgr:getMainScene():addHeadView()
       end
    end



    local view=mgr.ViewMgr:showView(_viewname.COPY_CHAPTER)
    if view then
        view:setData()
        view:gotoChapter()
    end

    local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
    if view then
        view:setOnlyPageIndex(3)
    end
end


function G_BackToMaterial( )

    local viewList = {
        _viewname.FRUIT_COMPOSE_PAGE,
        _viewname.FRUIT_COMPOSE,
        _viewname.FORMATION,
        _viewname.PRO_TIPS,
        _viewname.PALACE,
        _viewname.RANKENTY,
        _viewname.TASK,
    }

    for i,v in ipairs(viewList) do
       -- local view = mgr.ViewMgr:get(v)
       -- if view then
       --    view.showtype = view.org
       --    mgr.ViewMgr:showView(v)
       --    if v ==  _viewname.FRUIT_COMPOSE_PAGE then
       --        local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
       --        if view then
       --           view:setOnlyPageIndex(2)
       --           mgr.ViewMgr:showView(_viewname.FORMATION)
       --        end
       --    end
       -- end
    end
   -- cache.Player:releaseJumpView()

   local data = cache.Player:getJumpData()
   if data then
       if data.formationView then--合成界面跳转
           mgr.SceneMgr:getMainScene():changeView(2):jumpBack(data.fIdx)
           mgr.ViewMgr:showView(_viewname.FRUIT_COMPOSE_PAGE):jumpBack(data.selectedPage,data.fIdx,data.offset)
           mgr.ViewMgr:showView(_viewname.FRUIT_COMPOSE):setData(data.extData)
           local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
           if view then
                view:setOnlyPageIndex(2)
            end

        elseif data.packView then--背包
            G_setMaintopinit()
            mgr.SceneMgr:getMainScene():changeView(7):selectpage(data.selectedPage)
        elseif data.mapView then--图鉴
            G_setMaintopinit()
            mgr.SceneMgr:getMainScene():changeView(7):selectpage(data.selectedPage)
            mgr.ViewMgr:showView(_viewname.PACK_MAP):pageviewChange(data.selectedPage)
        elseif data.Evolution then--进化神殿
            proxy.Active:reqSwitchState(3003,3)
        elseif data.taskview  then --活跃商店
            G_setMaintopinit()
            local view  = mgr.SceneMgr:getMainScene():changeView(13)
            view:setOnlyPageIndex(3)
            mgr.Sound:playViewRW()
        end
   end




end





--[[
    moneytype 金币=1，钻石=2，徽章=3
    price 单价
    count 个数
    return 返回是否可购买
]]--
function G_BuyAnything( moneytype,price,amount)
    -- body
    local flag = true

    local amountNum = amount and amount or 1 
    local payMoney = amountNum*price           

     local curmoney = 0
    if moneytype ==3 then 
        curmoney= cache.Fortune:getFortuneInfo().moneyHz
    elseif moneytype ==2 then
        curmoney= cache.Fortune:getFortuneInfo().moneyZs
    else    
        curmoney = cache.Fortune:getFortuneInfo().moneyJb
    end

    if  tonumber(curmoney)<tonumber(payMoney) then 
         G_TipsForNoEnough(moneytype)
         flag = false
    elseif payMoney == 0 then 
        if tonumber(curmoney)<tonumber(price) then 
            G_TipsForNoEnough(moneytype)
            flag = false
        else --有钱但是次数没了
            G_TipsOfstr( res.str.NO_ENOUGH_COUT )
            flag = false
        end 
    end    
    return flag
end
--
function string.formatNumberToTimeString(nowtime)
    local hour=math.floor(nowtime/3600);

    local minute=math.floor((nowtime%3600)/60);

    local second=(nowtime%3600)%60;
    
    return string.format("%02d:%02d:%02d",hour,minute,second)
end


---------------------------
--@param params_ = {text={{"文字", {255,255,255}, size},{"文字", {255,255,255}, size},{"文字", {255,255,255}, size}}, width=100, height=100}
function G_RichText(params_)
    local richText = ccui.RichText:create()
    local text = params_.text
    for i=1, #text do
        local ary = text[i][2]
        local color = cc.c3b(ary[1],ary[2],ary[3])
        richText:pushBackElement(ccui.RichElementText:create(1,color,255,text[i][1],res.ttf[1],text[i][3]))
    end
    --richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,"训练师你已经成功通关了","Helvetica",22))
    --richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,93,5),255,"第一章：初到文件岛","Helvetica",22))
    --richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,"可以开始下一章节了","Helvetica",22))
    richText:formatText()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(params_.width,params_.height))
    --richText:setPosition(0,0)
    richText:setAnchorPoint(cc.p(0,0))
    return richText
end
--查看装备信息  flag --表示是否为本地信息
function G_OpenEquip( data_ , flag)
    -- body
    local data = clone(data_)

    local _sdata = {}
    if flag then
        _sdata.mId = data.mId
        _sdata.propertys = {}

        _sdata.propertys[303] = {}
        _sdata.propertys[303].value = 0

        _sdata.propertys[311] = {}
        _sdata.propertys[311].value = 0

    else 
        _sdata = data
    end
    local view = mgr.ViewMgr:showView(_viewname.EQUIPMENT_MESSAGE)
    view:updatePanel(_sdata,flag)
    view:setOnlySee()
end



--查看宠物信息flag --表示是否为本地信息
function G_OpenCard( data_ ,flag)
    -- body
    local data = clone(data_)

    local view=mgr.ViewMgr:showView(_viewname.PETDETAIL)
    local _sdata = {}


    local propertys = {}
    local function setpropertys(id,value)
        -- body
        propertys[id] = {}
        propertys[id].value = checkint(value) 
    end

    local cardid = conf.Item:getCardId(data.mId,1)
    if flag then 
        local lv = 1
        setpropertys(304,lv)

        local att = conf.Card:getAtt(cardid)
        
        setpropertys(102,att)

        local hp = conf.Card:getHp(cardid)
        setpropertys(105,hp)

        local def =  conf.Card:getdefence(cardid)
        setpropertys(103,def)

        local cri = conf.Card:getCri(cardid)
        setpropertys(106,cri)

        local defcir =  conf.Card:getDefCri(cardid)
        setpropertys(108,defcir)

        local power =  conf.Card:getPower(cardid)
        setpropertys(305,power)

        local mingzhong =  conf.Card:getMingzhong(cardid)
        setpropertys(110,mingzhong)

        local shangbi =  conf.Card:getShangBi(cardid)
        setpropertys(109,shangbi)

        local Pojia =  conf.Card:getPojia(cardid)
        setpropertys(116,Pojia)

        local tianfuid = conf.Item:getGiftList(data.mId)[1] --只计算第一个天赋
        local add = conf.CardGift:getProadd(tianfuid)

        if not propertys[add[1]] then 
           setpropertys(add[1],add[2])
        else
            propertys[add[1]].value = propertys[add[1]].value + add[2]
        end 



        data.propertys = propertys
    end
    table.insert(_sdata, data)
    
     view:setData(_sdata)
     view:selectUpdate(1,flag)
     view:setOnlySee()
end
--购买体力
function G_GoBuyTili()
    -- body
   proxy.Radio:send101006(40411) 
   -- mgr.ViewMgr:showView(_viewname.ROLE_BUY_TILI)
end

function G_GoToView(param)
    -- body
    if not param then 
        return 
    end 

    if type(param) ~="table" then 
        return 
    end  

    viewname =  _viewname[param[1]]
    viewpage =  param[2]
    viewother = param[3]
    --printt(viewother)

    local _view =mgr.ViewMgr:get(viewname)
    if  _view then 
        if param[1] == "COMPOSE" then
            _view:pagebtninit(1) 
            --_view:onPageButtonCallBack(1,ccui.TouchEventType.ended)
            return
        end
        
    end  
    --print(viewname)
    G_setMaintopinit()
    --要从主界面跳转的  -- 注意要和 MainScene：createUIView（） ui_Name 一直
    local mainS = mgr.SceneMgr:getMainScene() 
    if mainS then 
        --G_setMaintopinit()
        local ui_Name =  mainS:getui_Name()
        for k ,v in pairs(ui_Name) do 
            if v  == viewname then 
                if k < 6 then 
                    mainS:changePageView(k)
                else
                    if v == _viewname.ACTIVITY then
                      -- proxy.Active:reqSwitchState(1001)
                        if viewother and viewother[1] and viewother[1][2] then
                            proxy.Active:reqSwitchState(1000 +  viewother[1][2])
                        else
                            proxy.Active:reqSwitchState(1001)
                      end
                       break
                    end
                    --debugprint( " v " ..v)

                    _view = mainS:changeView(viewpage,v)
                    
                    if v == 11 then 
                        --print("dddd")
                        _view:setData()
                    end
                end 
                break 
            end 
        end 

        
        --print(viewname)
      
        if viewname == "guild.GuildView" then 
            if cache.Player:getLevel()<1 then 
                G_TipsOfstr(string.format(res.str.GUILD_DEC42,1))
                return
            end 

            proxy.guild:sendGuilmsg()
            proxy.guild:waitFor(517009)
            --G_mainView()
            --local view = mgr.ViewMgr:get(_viewname.MAIN)
            --view:NextStep("p_gh")
        end 
    end 
    --入口在别处的 特殊处理一下吧
    print("*//*/***/**/*/*")
    print(viewother)
    if viewother then 
        print("*******************")
        for i = 1 , #viewother do  
            local v = viewother[i][1]
            local p = viewother[i][2]
            debugprint(v)
            if v == "PETDETAIL" then 
                local _view =mgr.ViewMgr:get(_viewname.FORMATION)
                if  _view then 
                    _view:nextStep()
                end  
            elseif v == "PROMOTE_LV" then 
                local _view =mgr.ViewMgr:get(_viewname.PETDETAIL)
                if  _view then 
                    _view:nextStep(p)
                end  
            elseif v == "EQUIPMENT_MESSAGE" then
                --todo
                local _view =mgr.ViewMgr:get(_viewname.FORMATION)
                if  _view then 
                    _view:nextStepEquip()
                end 
            elseif v=="ACTIVITYZHAOCAI" then
                --todo
                local _view =mgr.ViewMgr:get(_viewname.ACTIVITY)
                if  _view then 
                    _view:nextStep(1001)
                end 
            elseif v == "ATHLETICS" or "CLIMB_TOWER" or "DIG_MIAN"
                or "FUBEN_DAY" == v then 
                local _view =mgr.ViewMgr:get(_viewname.FUNBENVIEW)
                print("-------")
                if  _view then 
                    _view:nextStep(p)
                end 
            elseif v == "GUIILD_QIFU" then
                 if cache.Player:getLevel()<35 then 
                    return
                end 
                proxy.guild:sendQifumsg()
                --local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
                --if view then 
                   -- _view:nextStep(11)
                --end 
            elseif v == "GUILD_FB" then 
                if cache.Player:getLevel()<35 then 
                    return
                end 
                mgr.NetMgr:send(117301)
                --local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
                --if view then 
                  --  _view:nextStep(13)
                --end 
            end  

        end 
    end 
end

--数码兽 比例变化
function G_GardChange(data)
    local src = conf.Item:getSrc(data.mId, data.propertys)
    return G_CardScale(src)
end

function G_TipsForColorEnough(str)
    -- body
    local data = {}
    data.richtext = str and str or  res.str.COLORTOOLOWER
    data.sure = function( ... )
        -- body
    end
    data.surestr = res.str.SURE
    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
end
--
function G_TipsForColorEquipEnough()
    -- body
    local data = {}
    data.richtext = res.str.COLORTOOLOWEREQUIP
    data.sure = function( ... )
        -- body
    end
    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
end

--获取卡牌基本属性 (出去其他乱七八糟 加的)
function G_getCardPro( data )
    -- body
    local t = {}
    t.base_atk =0
    t.base_hp =0
    t.base_power = 0

    local j = data.propertys[307] and data.propertys[307].value or 0
    local cardid = conf.Item:getCardId(data.mId, j+1)
    if not cardid then 
        return t
    end  
    local quality =  conf.Item:getItemQuality(data.mId)
    local base_power = conf.Card:getPower(cardid)
    if not  base_power then 
        debugprint("卡牌基本战斗没有配置..不可不配..att_114 cardid = "..cardid)
    end  
    local base_atk = conf.Card:getAtt(cardid)
    if not  base_atk then 
        debugprint("卡牌基本攻击没有配置..不可不配..att_102 cardid "..cardid)
    end 
    --print("base_atk = "..base_atk)
    local base_hp =  conf.Card:getHp(cardid)
    if not base_hp then 
        debugprint("卡牌基本生命没有配置..不可不配..att_105 cardid "..cardid)
    end 
    --print("base_hp = "..base_hp)
    local lv = data.propertys[304] and data.propertys[304].value or 1
    lv = lv <1 and 1 or lv --至少是1级的
    if lv > 1 then 
        local id = conf.Item:getItemSjPre(data.mId)
        local atk = conf.CardExp:getAtk(id,lv)
        local hp = conf.CardExp:getHp(id,lv)
        local power = conf.CardExp:getPower(id,lv)

        --计算升级后的属性
        base_atk = base_atk + atk
        base_hp = base_hp + hp
        base_power = base_power + power
    end 
    --[[print("name = "..conf.Item:getName(data.mId))
    print("----等级加后的属性-------------")
    print(base_atk)
    print(base_hp)
    print(base_power)
    print("------------------------")]]--

    local function addOnejie(param,pj)
        -- body
        if param ==0 then 
            return 
        end 

        local incardid = conf.Item:getCardId(data.mId)
        --local id =  quality*1000 + param
        local id = conf.Item:getItemJHPre(data.mId)+param
        local atk = conf.CardJinghua:getAtt(id) 
        local hp = conf.CardJinghua:getHp(id)
        local power = conf.CardJinghua:getPower(id)

        --print("jinghua id="..id)
       -- print("atk ="..atk)

        --计算进化的属性
        base_atk = base_atk + atk
        base_hp = base_hp + hp
        base_power = base_power + power
    end

    local jinghua =  data.propertys[310] and data.propertys[310].value or 0
    --print()
    for i = 0 , j   do  
        if i < j then 
            addOnejie(10,i)
        else
            print(jinghua)
            addOnejie(jinghua)
        end 
    end 

    --进化加的属性进化
   --[[ print("----等级加后的属性--+进化 -----------")
    print(base_atk)
    print(base_hp)
    print(base_power)
    print("------------------------")]]

    --print(" base_atk = "..base_atk)

    if j > 0 then 
        --local id = quality*1000 + j
       -- print("id = " ..id)
        local id = conf.Item:getItemJJPre(data.mId)+j
        local atk = conf.CardTopo:getAtt(id) 
        local hp = conf.CardTopo:getHp(id)
        local power = conf.CardTopo:getPower(id)
       -- print("atk ="..atk)
        --计算突破的属性
        base_atk = base_atk + atk
        base_hp = base_hp + hp
        base_power = base_power + power
    end 
    --print("base_atk ="..base_atk)
   --[[ print("-------------最后------------------------")
    print("base_atk = "..base_atk)
    print("base_hp = "..base_hp)
    print("base_power = "..base_power)]]
    ------------------------------------------

    
    t.base_atk =base_atk
    t.base_hp =base_hp
    t.base_power = base_power
    return t 
end
--获取装备的属性
function G_getEquipPro(data)
    -- body
    local t = {}
    t.base_atk =0
    t.base_hp =0
    t.base_power = 0

    local j = data.propertys[311] and data.propertys[311].value or 0
    local lv = data.propertys[303] and data.propertys[303].value or 0
   -- print("lv = "..lv)
    local base_atk =conf.Item:getLocalEquipAtt(data.mId)
    local base_hp =conf.Item:getLocalEquipHp(data.mId)
    local base_power =conf.Item:getloaclEquippower(data.mId)

    if not base_atk or not base_hp or not base_power then 
        return t 
    end 

    t.base_atk = base_atk
    t.base_hp = base_hp
    t.base_power = base_power

    local quality = conf.Item:getItemQuality(data.mId)

    if lv > 0 then 
        local EquipmentQhID = conf.Item:getEquipmentQhId(data.mId,lv)
        local atk = conf.EquipmentQh:getAtk(EquipmentQhID)
        local pwoer = conf.EquipmentQh:getPower(EquipmentQhID)
        local hp = conf.EquipmentQh:getHp(EquipmentQhID)

        atk = atk and atk or 0
        pwoer = pwoer and pwoer or 0
        hp = hp and hp or 0

        t.base_atk = t.base_atk + atk
        t.base_hp = t.base_hp + hp
        t.base_power = t.base_power + pwoer
    end 
   -- print("***************")
   -- printt(t)
    if j > 0 then 
        local EquipmentQhID = conf.Item:getEquipmentJLId(data.mId,j)
        --print("EquipmentQhID = "..EquipmentQhID)
        local atk = conf.EquipmentJh:getAtk(EquipmentQhID)
        local hp = conf.EquipmentJh:getHp(EquipmentQhID)
        local pp = tonumber(conf.EquipmentJh:getPower(EquipmentQhID))

        atk = atk and atk or 0
        pp = pp and pp or 0
        hp = hp and hp or 0

        --print("pwoer = "..pp)
        t.base_atk = t.base_atk + atk
        t.base_hp = t.base_hp + hp
        t.base_power = t.base_power + pp
    end 
   -- print("********---------------------*******")
   -- printt(t)
    return t 
end


---副本竞技场扫荡完成检测升级
function G_DelayRoleUp()
    --检查是否有升级
    if cache.Fight.fightLevelUp > 0 then
        local view=mgr.ViewMgr:get(_viewname.LEVEL_UP)
        if not view then
            mgr.ViewMgr:showView(_viewname.LEVEL_UP):updateUi(cache.Fight.fightLevelParams)
        end
    end
    cache.Fight.fightLevelUp = 0
    cache.Fight.fightState = 0
end

---获取卡牌缩放比例
function G_CardScale(id_)

    local scaleList = {0.55,0.7,0.85,1}
    local qua = tonumber(string.sub(id_,4,4))
    local lvl = tonumber(string.sub(id_,9,9))
    return res.card.fight[qua..""][lvl]
end

--数码兽是否已经达到人物等级  或者极限等级
function G_CardisEqualToHero( data )
    -- body
    if not data then
        return false
    end 

    local herolv = cache.Player:getLevel()
    local cardlv = mgr.ConfMgr.getLv(data.propertys)
    local maxlv = conf.Item:getCardMaxlv(data.mId)

    if cardlv>= herolv then 
        return true
    elseif  cardlv>= maxlv then 
        return true
    end 
    return false
end

--数码兽是不能做任何提升了(升级例外)
function G_CardisMax(data)
    -- body
    if not data then
        return false
    end 

    local j = data.propertys[307] and data.propertys[307].value or 0
    local maxj = conf.Item:getCardMaxjie(data.mId)
   -- print("maxj = "..maxj .. " j = "..j)
    local jinghua = data.propertys[310] and data.propertys[310].value or 0

    if jinghua < 10 then
        return false
    end 

    if j + 1 ==  maxj then 
        return true
    end 

    return false
end
--特殊用
--
--[[function G_PpecialLayer(widget,rect,order)
    -- body
    if widget:getChildByName("up") then 
        widget:getChildByName("up"):removeFromParent()
    end 

    if widget:getChildByName("down") then
         widget:getChildByName("down"):removeFromParent()
    end
end]]--

function G_FitScreen(tar_, name_)
    local bg = tar_.view:getChildByName(name_)
    local scaleH = display.height/960
    local scaleW = display.width/640
    local scale = math.max(scaleH, scaleW)
    bg:setScaleX(scale)
    bg:setScaleY(scale)
    return  scale
end


---进入新手战斗
function G_EnterNewerFight()
    fight_guide = true
    local data = cache.Fight:newerGuideFightData()
    mgr.BoneLoad:loadCache(data)
end

--------突破动画
function G_playerJingjie(data1,data2,addto, callFunc)
    local pet= require("game.things.PetUi")
    mgr.Sound:pauseMusic()
    -- body
    --404813
     --动画播放期间 不给点击
    local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(180)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    addto:addChild(layer,100) 

    local armature1
    local armature2
    local pet = pet.new(data1.mId,data1.propertys)
    pet:setPosition(layer:getContentSize().width/2, layer:getContentSize().height/2)
    pet:setScale(1.5)
    pet:addTo(layer,600)
    

    local pet1 = pet.new(data2.mId,data2.propertys)
    pet1:setPosition(layer:getContentSize().width/2, layer:getContentSize().height/2)
    pet1:setVisible(false)
    pet1:setScale(10)
    pet1:addTo(layer,600)


    local label = display.newTTFLabel({
        text = conf.Item:getName(data2.mId,data2.propertys),
        size = 64,
        align = cc.ui.TEXT_ALIGN_CENTER ,-- 文字内部居中对齐
        x = layer:getContentSize().width/2,
        y = layer:getContentSize().height/4 ,
       -- color = COLOR[conf.Item:getItemQuality(data2.mId)]
    });
    label:setOpacity(0)
    label:setVisible(false)
    label:addTo(layer,800)
    
    
    

    pet:setVisible(false)
    pet1:setVisible(false)
    label:setVisible(false)

    local function onFunction( event )
        -- body
        if event == "start" then --开始缩放
            local a1 = cc.ScaleBy:create(0.2,10)
            pet:runAction(a1)
        elseif event == "end" then --缩放结束
            pet:stopAllActions()
            pet:removeFromParent()
            pet1:setVisible(true)

            local a3 = cc.OrbitCamera:create(1.5,1,0,0,360,0,0)
            local a4 = cc.ScaleTo:create(0.3,1.5)
            local a5 = cc.CallFunc:create(function( ... )
                -- body
                layer:addTouchEventListener(function()
                    if callFunc then callFunc() end
                    mgr.Sound:resumeMusic()
                    -- body
                    layer:removeFromParent()
                end)
            end)
            local sequence = cc.Sequence:create(a4,a3,a5)
            pet1:runAction(sequence)

            label:setVisible(true)
            label:fadeIn(1.5)

            local params2 =  {id=404813, x=layer:getContentSize().width/2,
                 y=layer:getContentSize().height/2,addTo=layer,
                playIndex=2,depth = 500,loadComplete = function(var)
                -- body
                armature2 = var
            end
            }
            mgr.effect:playEffect(params2)

            local params1 =  {id=404813, x=layer:getContentSize().width/2,
             y=layer:getContentSize().height/2,addTo=layer,
                playIndex=1,depth = 700
            }
            mgr.effect:playEffect(params1)
        end 
    end

    local params =  {id=404813, x=layer:getContentSize().width/2,
    y=layer:getContentSize().height/2,
    addTo=layer,
    playIndex=0,
    addName = "effofname1",loadComplete= function(var)
            -- body
            armature1 = var
        end,retain = true
        ,triggerFun = onFunction,depth = 500 }

    --local a2 = cc.OrbitCamera:create(2.1,1,0,0,360,0,0)
    --pet:runAction(a2)
    --mgr.effect:playEffect(params)

    ---mp4
    
    if device.platform == "android" or device.platform == "ios" then
        
        local toplayer = display.newNode()
        toplayer:setContentSize(cc.size(display.width,display.height))
        toplayer:setPosition(display.cx,display.cy)
        toplayer:setAnchorPoint(cc.p(0.5, 0.5))
        mgr.SceneMgr:getNowShowScene():addChild(toplayer, 1000)

        
        local function onVideoEventCallback( sener, eventType )
            -- body
            if eventType == ccexp.VideoPlayerEvent.PLAYING then
            elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
                local video_ = toplayer:getChildByName( "video_player" )
                video_:setVisible(false)
                if device.platform == "android" then
                    pet:setVisible(true)
                    --pet1:setVisible(true)
                    label:setVisible(true)
                    mgr.Sound:playShuMaShouJinHua()
                    mgr.effect:playEffect(params)
                    local a2 = cc.OrbitCamera:create(2.1,1,0,0,360,0,0)
                    pet:runAction(a2)
                    toplayer:removeFromParent()
                end    
            elseif eventType == ccexp.VideoPlayerEvent.STOPPED then

            elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
                pet:setVisible(true)
                label:setVisible(true)
                mgr.Sound:playShuMaShouJinHua()
                mgr.effect:playEffect(params)
                local a2 = cc.OrbitCamera:create(2.1,1,0,0,360,0,0)
                pet:runAction(a2)
                --toplayer:removeFromParent()
                toplayer:performWithDelay(function(  )
                    toplayer:removeFromParent()
                end, 0.1)
            end
        end

        local videoPlayer = ccexp.VideoPlayer:create()
        videoPlayer:setVisible(true)
        videoPlayer:setName( "video_player" )
        videoPlayer:setPosition(display.cx,display.cy)
        videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
        videoPlayer:setContentSize(cc.size(display.width,display.height))
        videoPlayer:setFullScreenEnabled(true)
        videoPlayer:setKeepAspectRatioEnabled(false)
        videoPlayer:addEventListener(onVideoEventCallback)
        toplayer:addChild(videoPlayer, -2, -2)

        if device.platform == "ios" then
            local color_ = cc.LayerColor:create( cc.c4b( 0xff,0,0,0 ) )
            toplayer:addChild( color_ )
            color_:setTouchEnabled(true)
            local listener = cc.EventListenerTouchOneByOne:create()
            listener:setSwallowTouches(true)
            listener:registerScriptHandler(function(touch,event)
                local video_ = toplayer:getChildByName( "video_player" )
                print("-----------------------------",video_)
                    if video_ then
                        pet:setVisible(true)
                        label:setVisible(true)
                        mgr.Sound:playShuMaShouJinHua()
                        mgr.effect:playEffect(params)
                        local a2 = cc.OrbitCamera:create(2.1,1,0,0,360,0,0)
                        pet:runAction(a2)
                        toplayer:removeFromParent() 
                    end
                return true
            end,cc.Handler.EVENT_TOUCH_BEGAN )
            listener:registerScriptHandler(function(touch,event)
            
            end,cc.Handler.EVENT_TOUCH_ENDED)
            listener:registerScriptHandler(function(touch,event)
                return true
            end,cc.Handler.EVENT_TOUCH_MOVED)
            local eventDispatcher = color_:getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, color_)
        end
        
        --local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("shumashou.mp4")

        --[[local a1 = cc.DelayTime:create(0)
        local a2 = cc.CallFunc:create(function()
            -- body
            pet:setVisible(false)
            pet1:setVisible(false)
            label:setVisible(false)

            --videoPlayer:setFileName(videoFullPath)

            videoPlayer:setFileName("res/video/shumashou.mp4")  
            videoPlayer:play()
        end)
        local sequence = cc.Sequence:create(a1,a2) 
        
        addto:runAction(sequence)]]--

        toplayer:performWithDelay(function(  )
            -- body
            pet:setVisible(false)
            pet1:setVisible(false)
            label:setVisible(false)

            --videoPlayer:setFileName(videoFullPath)

            videoPlayer:setFileName("res/video/shumashou.mp4")  
            videoPlayer:play()
        end, 0)

    else
        pet:setVisible(true)
        --pet1:setVisible(true)
        label:setVisible(true)
        local a2 = cc.OrbitCamera:create(2.1,1,0,0,360,0,0)
        pet:runAction(a2)
        mgr.effect:playEffect(params)
    end

end

--


--数码兽 穿戴的套装被激活了吗 起码2件吧
function G_isSuitonWear(mId,pos)
    -- body
    local suit_id = conf.Item:getItemSuitId(mId)
    if not suit_id then 
        return false
    end 

    local HasEquipmentDataList = {}
    local data = cache.Equipment:getEquitpmentDataInfo()
    for k,v in pairs(data) do
        --print("k = "..k)
        local battle_index=tonumber(string.sub(k,3,3))  --数码兽 上阵位置 
        local bt=HasEquipmentDataList[battle_index]
        local part = conf.Item:getItemPart(v.mId) --装备部位
        if bt then
            HasEquipmentDataList[battle_index][part]=v
        else
            HasEquipmentDataList[battle_index]={}
            HasEquipmentDataList[battle_index][part]=v
        end
    end

    local  dataofcard = HasEquipmentDataList[pos]
    --printt(dataofcard)
    local count = 0
    if dataofcard then 
       -- print("suit_id="..suit_id)
        --print(#dataofcard)
        for k , v in pairs (dataofcard) do 
            if conf.Item:getItemSuitId(v.mId) == suit_id then 
                count  = count +1  
            end 
        end 
    end
    if count > 1 then 
        return true
    end 
    return false
end

--搜素背包中指定部位的装备列表
function G_autoSearchEquipment( part )
    --得到的数据
    local _getsearch_data = {}
    local _cache_equipment_data = cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
    for k,v in pairs(_cache_equipment_data) do
        if part == conf.Item:getItemPart(v.mId) then
            _getsearch_data[#_getsearch_data+1]=v
        end
    end
    --排序 
    table.sort(_getsearch_data,function( a,b )
        -- body
        local acolorlv = conf.Item:getItemQuality(a.mId)
        local bcolorlv = conf.Item:getItemQuality(b.mId)

        local apower = mgr.ConfMgr.getPower(a.propertys)
        local bpower = mgr.ConfMgr.getPower(b.propertys)

        if acolorlv ==  bcolorlv then 
            if apower == bpower then 
                return a.mId<b.mId
            else
                return apower > bpower
            end 
        else
            return acolorlv > bcolorlv
        end 
    end)

    return _getsearch_data
end
--主界面被打开
function G_mainView()
    -- body
    local _view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
    if _view then 
       _view:setPageButtonIndex(1)
    else
        mgr.SceneMgr:getMainScene():changePageView(1)
    end
end

---加载页面 state_：true打开，false关闭
function G_Loading(state_, func_,flag)
    if state_ == true then
        local v = mgr.ViewMgr:get(_viewname.LOADING_VIEW)
        if not v then
            mgr.SceneMgr:getNowShowScene():addLoading(flag)
        end
    else
        local v = mgr.ViewMgr:get(_viewname.LOADING_VIEW)
        if v then
            v:loadEnd(func_)
        end
    end
end


--背包里面是否有数码兽可退化
function G_TuihuaCard()
    -- body
   local cardlist =  cache.Pack:getTypePackInfo(pack_type.SPRITE)
   for k , v  in pairs(cardlist) do 
        if mgr.ConfMgr.getLv(v.propertys) > 1 or mgr.ConfMgr.getItemJJ(v.propertys) >0 
        or mgr.ConfMgr.getItemJH(v.propertys)>0 then 
            return true
        end 
   end 
   return false
end

--背包里面是否有装备可退化
function G_TuihuaEquip()
    -- body
   local cardlist =  cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
   for k , v  in pairs(cardlist) do 
        local elv = mgr.ConfMgr.getItemQhLV(v.propertys)
        local jlv = mgr.ConfMgr.getItemJh(v.propertys)
        if elv > 0 or jlv >0 then 
            return true
        end 
   end 
   return false
end

--[[
 头像——边框颜色随战斗力高低改变。白绿蓝紫橙。
 白色（0~2000）
 绿色（2000~10000）；
 蓝色（10000~50000）；
 紫色（50000~100000）
 橙色（》100000）
--]]
function G_getChatPlayerFrameIcon( power )
    -- body
    if power == nil then
        return
    end

    local iconId = 1
    if power >=0 and power <2000 then
        iconId = 1
    elseif power >=2000 and power <10000 then
        iconId = 2
    elseif power >=10000 and power <50000 then
        iconId = 3
    elseif power >=50000 and power <100000 then
        iconId = 4
    elseif power >= 100000 then
        iconId = 5
    end

    local poath = res.btn.ROLE_FRAME[iconId]
    return poath
end


---检测战斗结束退出页面
function G_FightFromEnd(fightType)
    if fightType == 1 then

        local func = function( )
            mgr.SceneMgr:getMainScene():setOnlyPageIndex(3)
            mgr.SceneMgr:getMainScene():changeView(3, _viewname.COPY_CHAPTER)
            local view = mgr.ViewMgr:get(_viewname.COPY_CHAPTER)
            view:setData({type=2})
            if cache.Fight.fightLevelUp > 0 then
                mgr.Guide:openFunc()
            end
            cache.Fight.fightLevelUp = 0
        end

        mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
            func()
        end})

    elseif fightType == 2 then
        mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
            mgr.SceneMgr:getMainScene():setOnlyPageIndex(5)
            mgr.SceneMgr:getMainScene():changeView(0, _viewname.ATHLETICS)
            local view = mgr.ViewMgr:get(_viewname.ATHLETICS)
            view:updateRank()
            if cache.Fight.fightLevelUp > 0 then
                mgr.Guide:openFunc()
            end
            cache.Fight.fightLevelUp = 0
        end})
    end
end

function G_GetRoleFrameByPower( power )
    -- body
    local icon = res.btn.ROLE_FRAME[1]
    if power < 2000 then 
    elseif power < 10000 then 
        icon = res.btn.ROLE_FRAME[2]
    elseif power < 50000 then
        icon = res.btn.ROLE_FRAME[3]
    elseif power < 100000 then
        icon = res.btn.ROLE_FRAME[4]
    else
        icon = res.btn.ROLE_FRAME[5]
    end 
    return icon
end


--打开公会主界面，这个有限制 必须是在公会功能里面才能用
function G_MainGuild( ... )
     -- body
    local data = cache.Guild:getGuildBaseInfo()

    mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_VIEW)
    local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
    if view then
        view:setData(data)
    end
end

---本地推送
function G_Init_PushMsg___()
    if device.platform == "android" or device.platform == "ios" then
        local conf = require("res.conf.push_config")
        for key, value in pairs(conf) do
            local curTime = os.time()
            local today = os.date("*t")
            local lastTime = os.time({day=value.day or today.day, month=value.mouth or today.month,
                year=today.year, hour=value.hour or 0, minute=0, second=0}) + (value.minute or 0)*60
            if lastTime > curTime then
                local jsonObj = {
                    title = value.title or "",
                    ticker = value.dec or "",
                    text = value.dec or "",
                    tag = "once",  --intervalAtMillis
                    triggerOffset = (lastTime - curTime),
                    id = tonumber(key),
                    packageName = "org.cocos2dx.lua.AppActivity",
                }
                local jsonObj2 = {
                    id = tonumber(key)
                }
                game.GameSdkHelper:getInstance():extFunc(101, json.encode(jsonObj2))
                game.GameSdkHelper:getInstance():extFunc(100, json.encode(jsonObj))
                debugprint("______________________________[添加推送]", tonumber(key), "时间差：", (lastTime - curTime),value.minute)
            end
        end
    end
end

---游戏重置
function G_RestGame()
    --清理缓存
    cache.clear()
    --移除全局定时器
    if g_timer_id ~= -1 then
        scheduler.unscheduleGlobal(g_timer_id)
    end
    g_timer_com = 0
end

---游戏资源清理
function G_ClearTexture____()
    ----------------------------------------------------------------------
    print("_________________________________________","纹理资源释放")
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    ----------------------------------------------------------------------
end

--[[
-- @function 系统公告类 文字关键字处理，将字符串位子内容
-- 组装为 table,字符串格式为:
-- 公告公告[param=1,text=关键字]公告公告[01]
-- @param dataStr 字符串格式为:公告公告[param=1,text=关键字]公告公告,[01]表示表情
-- @param params table,关键字 颜色，字体，透明度等 如{color = {255,255,255},fontName="宋体",opacity=255}
-- @return table 解析之后返回的数据的格式为，{text=文字内容，color = {255,255,255}}
--]]

function G_RenderStrKey(dataStr, params )
   local i = 1
   local j = 1
   local preX = 1
   local endX = string.len(dataStr)
   local tableData = {}

   repeat
       i = string.find(dataStr, "%[",i)
       if i then
           j = string.find(dataStr, "%]",i+1)
           if j then--匹配到 [param=1,text=XXX]

            if preX <= i - 1 then
                 local data = {}------匹配到的关键字之前的文本
                 data.text = string.sub(dataStr, preX,i - 1)
                table.insert(tableData,data)      
            end
             
              -- end
               -----------关键字
               local str = string.sub(dataStr, i,j)
               local x1,y1,param1 = string.find(str,"p=(%d*)")
               local x2,y2 = string.find(str,"t=")

               if y1  and y2 and param1 and x2 == y1 + 2 and x1 == 2 then----完全匹配,关键字
                   local param2 = string.sub(str, y2+1,string.len(str) - 1)
                   local data = {}
                   local index = tonumber(param1)
                   data.text = param2

                   if params[index]["color"] then
                      data.color = params[index]["color"]
                   end
                   if params[index]["fontName"] then
                      data.fontName = params[index]["fontName"]
                   end
                   if  params[index]["opacity"] then
                     data.opacity = params[index]["opacity"]
                   end
                   if  params[index]["size"] then
                     data.size = params[index]["size"]
                   end
                   
                   table.insert(tableData,data)

                else-------可能有表情
                    local x,y,num= string.find(str,"%[(%d+)%]")
                    if num then--处理表情
                        local  data = {}
                        data.name = num
                        table.insert(tableData,data)
                    else----其他，当普通字符处理
                        local  data = {}
                        data.text = str
                        table.insert(tableData,data)
                     end

                end

                i = j + 1--------继续处理字符串
                preX = i
            
            else---没有匹配的”]“
                if preX <= endX then
                    local data = {}
                    data.text = string.sub(dataStr, preX,endX)
                    table.insert(tableData,data)
                end
                break
            end
        else-----没有匹配的”[“
            if preX <= endX then
                local data = {}
                data.text = string.sub(dataStr, preX,endX)
                table.insert(tableData,data)
            end
            break
       end


   until false

    -- dump(tableData)
  --  printt(tableData)
     return tableData

end
function G_TaskShow(flag)
    -- body
    local data = clone(cache.Taskinfo:getCurDoneAchi())
    local scene = mgr.SceneMgr:getNowShowScene()
    if scene.name  ~= _scenename.MAIN then 
        return 
    end 
    if not data or not data.taskInfos then 
        return
    end 

    local ffshow = true
    for k , v in pairs(data.taskInfos) do 
        local id = v.taskId
        if tonumber(id) < 400000 then --是任务不是成就
            return 
        end 
        local type = conf.achieve:getType(id)
        if tonumber(type) == 201 or tonumber(type) == 208 or tonumber(type) == 210 
           or 125 == tonumber(type) or 127 == tonumber(type) then 
           if not flag then --如果是这些任务类型 必须是某个界面关闭的时候
              ffshow = false   
           end 
        end 

        if ffshow then 
            cache.Taskinfo:clearTask(id) --显示了的清除
            local posx = display.cx 
            local posy = display.cy

            local newsize = cc.size(600, 120)
            local _img = display.newScale9Sprite(res.image.LONGDI,posx,posy
                ,newsize,cc.size(546,51))


            if scene:getChildByName("imgtaskinfo") then 
                local w = scene:getChildByName("imgtaskinfo")
                w:setName("old")
                posy = w:getPositionY()+ newsize.height 
            else
                posy = posy - (#data.taskInfos-1)*newsize.height/2
            end 

            _img:setPosition(posx, posy)
            _img:addTo(scene)
            _img:setName("imgtaskinfo")

            posy = posy+_img:getContentSize().height

            local img_wancheng = display.newSprite(res.font.WANCHENG)
            img_wancheng:setScale(1.0)
            img_wancheng:setAnchorPoint(cc.p(0,0.5))
            img_wancheng:setPosition(100, newsize.height/2)
            img_wancheng:setScale(5.0)
            img_wancheng:setVisible(false)
            img_wancheng:addTo(_img)

            local label2 = display.newTTFLabel({
                text = conf.achieve:getdec(id),
                size = 20,
                color = COLOR[1], 
                align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
                x = newsize.width/2,
                y = newsize.height/2,
                font = res.ttf[1],
            })
            label2:setAnchorPoint(cc.p(0.5,0.5))
            label2:addTo(_img)


            local _frame = display.newSprite(res.btn.FRAME[1])
            _frame:setPosition(newsize.width - 100 ,newsize.height/2+10)
            _frame:setScale(0.7)
            _frame:addTo(_img)

            local spr = display.newSprite(res.icon.ZS)
            spr:setPosition(_frame:getContentSize().width/2,_frame:getContentSize().height/2)
            spr:addTo(_frame)

            local reward = conf.achieve:getReward(id)
            local label3 = display.newTTFLabel({
                text = res.str.ACHI_DEC4..":"..reward[2],
                size = 20,
                font = res.ttf[1],
                color = COLOR[2], 
                align = cc.TEXT_ALIGNMENT_LEFT, -- 文字内部居中对齐
                x = newsize.width-100 - _frame:getContentSize().width*0.7/2,
                y = newsize.height/2 - _frame:getContentSize().height*0.7/2,
            })
            label3:setAnchorPoint(cc.p(0,0.5))
            label3:addTo(_img)
 
            local sequence = transition.sequence({
                 cc.CallFunc:create(function()
                    -- body
                    img_wancheng:setVisible(true)
                end),
                cc.ScaleTo:create(0.3,1.0),
                cc.DelayTime:create(2.0),
                cc.CallFunc:create(function()
                    -- body
                    _img:removeFromParent()
                end)
                })

            img_wancheng:runAction(sequence)
        end 
    end 
end
--飘字 获取砖石
function G_TipsOfzs(str,var)
    -- body
    local newsize = cc.size(600, 51)
    local _img = display.newScale9Sprite(res.image.LONGDI,posx,posy
        ,newsize,cc.size(546,51))

    local w = 0
     local label2 = display.newTTFLabel({
        text = str,
        size = 20,
        color = COLOR[1], 
        align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
        x = 0,
        y = newsize.height/2,
        font = res.ttf[1],
    })
    label2:setAnchorPoint(cc.p(0,0.5))
    label2:addTo(_img)

    local spr = display.newSprite(res.image.ZS)
    spr:setPositionX(label2:getPositionX()+label2:getContentSize().width+spr:getContentSize().width/2)
    spr:setPositionY(newsize.height/2)
    spr:addTo(_img)

     local label3 = display.newTTFLabel({
        text = var,
        size = 20,
        font = res.ttf[1],
        color = COLOR[2], 
        align = cc.TEXT_ALIGNMENT_LEFT, -- 文字内部居中对齐
        x = spr:getPositionX()+ spr:getContentSize().width/2,
        y = newsize.height/2,
    })
    label3:setAnchorPoint(cc.p(0,0.5))
    label3:addTo(_img)

    w = w + label2:getContentSize().width + spr:getContentSize().width + label3:getContentSize().width 
    local x = (600 - w)/2

    label2:setPositionX(label2:getPositionX()+x)
    spr:setPositionX(spr:getPositionX()+x)
    label3:setPositionX(label3:getPositionX()+x)

    _img:setPosition(display.cx,display.cy) 
    mgr.SceneMgr:getNowShowScene():addChild(_img)

    local sequence = transition.sequence({
        cc.Spawn:create(cc.FadeIn:create(0.5) ,
        cc.MoveTo:create(1.0,cc.p(display.cx,display.cy+100))),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function ( ... )
            -- body
            _img:removeSelf()
        end),
    })

    _img:runAction(sequence)
end

 function G_transFormMoney(money)
    if type(money) ~= 'number' then return money end
    local w=1000000 --万
    local y=100000000 --亿
    if money >= y then
        return string.format("%.1f",money/y) ..res.str.SYS_DEC6
    elseif money >= w then
        local w = math.floor(money/(w/100))

        local q = math.floor((money-w*10000)/1000)
        if q == 0 then 
            return w..res.str.SYS_DEC7
        else   
            return w.."."..q..res.str.SYS_DEC7
        end   
    elseif money > 0 then
        return money
    end
    return 0
end


function G_FormatPower( power )
    -- body
    if type(power) ~= 'number' then return power end
    local w=10000 --万
    if power >= w then
        return string.format("%.1f",power/w) ..res.str.SYS_DEC7
    else
        return ""..power
    end 
end

function G_TipsError( id  )
    -- body
    if  id == 21090001 or id == 21090002 then 
        mgr.NetMgr:errorMsg({status = id})
    elseif id == 21400001 then -- 背包芯片已满，是否前往吞噬
        --res.str.DEC_NEW_62
        local data = {}
        data.richtext = res.str.DEC_NEW_62
        data.sure = function( ... )
            -- body
            local _view = mgr.ViewMgr:get(_viewname.CROSS_XIN_DUIHUAN)
            if _view then
                _view:onCloseSelfView()
            end

            G_mainView()
            mgr.SceneMgr:getMainScene():changeView(2)
            local view = mgr.ViewMgr:get(_viewname.FORMATION)
            if view then
                view:CallbtnFuben()
            end
        end
        data.cancel = function()
            -- body
        end
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
    elseif id == 21030001 then
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif id == 20010001 then
        G_TipsOfstr(res.str.NO_ENOUGH_JB)
    elseif id == 20010005 then
        G_TipsOfstr(res.str.NO_ENOUGH_ZS)
    elseif id == 20010006 then
        --todo
        G_TipsOfstr(res.str.NO_ENOUGH_HZ)
    elseif 21420001 == id then
        G_TipsOfstr(res.str.DEC_NEW_63) 
    elseif 21420002 == id then
        G_TipsOfstr(res.str.DEC_NEW_52) 
    elseif 21420003 == id then
        local data  = {}
        data.richtext = res.str.DEC_NEW_61
        data.sure = function( ... )
            -- body
            G_GoReCharge()
        end
        data.surestr = res.str.SURE
        data.cancel = function( ... )
            -- body
        end
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
    elseif 21420004 == id then
        G_TipsOfstr(res.str.DEC_NEW_54)
    elseif 21040005 == id then
        G_TipsOfstr(res.str.DUI_DEC_88)
    elseif 21070030 == id then
        G_TipsOfstr(res.str.RES_RES_01)
    elseif 21070031 == id then
        G_TipsOfstr(res.str.RES_RES_02)
    elseif 21420005 == id then
        G_TipsOfstr(res.str.RES_RES_16)
    elseif 21420006 == id then
        G_TipsOfstr(res.str.RES_RES_32)
    elseif 21500101 == id then
        G_TipsOfstr(res.str.RES_RES_35)
    elseif 21500102 == id then 
    	G_TipsOfstr(res.str.RES_RES_48)
    elseif 21500103 == id then
    	G_TipsOfstr(res.str.RES_RES_49)
    elseif id == 21200008 then 
        G_TipsOfstr(res.str.DIG_DEC67)
    elseif id == 21200009 then 
        G_TipsOfstr(res.str.DIG_DEC66)
    elseif 21200007 == id then
        G_TipsOfstr(res.str.DIG_DEC68)
    elseif 21200013 == id then 
        G_TipsOfstr(res.str.DEC_ERR_02)
    elseif 21200017 == id  then 
        G_TipsOfstr(res.str.DEC_ERR_20)  
    elseif 21400004 == id then 
        G_TipsOfstr(res.str.DEC_NEW_22) 
    elseif 21500104 == id then  
        G_TipsOfstr(res.str.RES_RES_67) 
    elseif 21500105 == id then 
        G_TipsOfstr(res.str.RES_RES_72) 
    elseif 21010003 == id then 
        G_TipsOfstr(res.str.CHAT_TIPS13)
    elseif 21010004 == id then 
        G_TipsOfstr(res.str.CHAT_TIPS13)
    elseif 21500106 ==id then 
        G_TipsOfstr(res.str.RES_RES_74)
    elseif id == 21200003 then 
        G_TipsOfstr(res.str.RES_RES_84)
    elseif id == 21010005 then 
        local data = {}
        data.richtext = res.str.RES_RES_92
        data.sure = function( ... )
            -- body
           mgr.NetMgr:_backToLogin()
           mgr.NetMgr:close_NotTips()
        end
        data.surestr = res.str.SURE
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
    elseif 21070029 == id then 
        G_TipsOfstr(res.str.OPEN_ACT_PRAISE_DESC1)
	elseif 21070033== id then 
		G_TipsOfstr(res.str.RES_GG_17)
	elseif 21070032== id then 
		G_TipsOfstr(res.str.RES_GG_18)
    elseif 21010002  == id then 
        G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT)
    elseif 21010003 == id  or 21010004 == id  then
        G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_NO) 
    elseif 20010203 == id then
        G_TipsOfstr(res.str.RES_GG_26)
    elseif 21600101 == id then 
        G_TipsOfstr(res.str.RES_GG_64)
    elseif 21600102 == id then 
        G_TipsOfstr(res.str.RES_GG_65) 
    elseif 21600103 == id then 
        G_TipsOfstr(res.str.RES_GG_66) 
    elseif 21600104 == id then
        G_TipsOfstr(res.str.RES_GG_67)
    elseif 21600105== id then 
        G_TipsOfstr(res.str.RES_GG_68)
    elseif 21600106== id then 
        G_TipsOfstr(res.str.RES_GG_69)
    elseif 21050006  == id or 20010009 == id  then 
        G_TipsOfstr(res.str.RES_GG_80)
    elseif 21050005 == id  then
         G_TipsOfstr(res.str.SHOP_TIME_OUT)
    elseif 21050001 == id  then
        G_TipsOfstr(res.str.SHOP_TIME_NEED)
    elseif 21030008 == id then 
        G_TipsOfstr(res.str.RES_GG_86)  
    elseif 20010111 == id then 
        G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,30)) 
    elseif 21030004 == id then 
        G_TipsOfstr(res.str.PACK_DEC2)  
    end 
    --[[local data = {}
    data.surestr = res.str.SURE

    if id == 21090001 then --封号
        data.richtext = res.str.ERROR_DEC1
        data.sure = function( ... )
            -- body
            mgr.NetMgr:close()
        end
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
    elseif id == 21090002 then --缝IP
        data.sure = function( ... )
            -- body
            mgr.NetMgr:close()
        end
        data.richtext = res.str.ERROR_DEC2
        mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
    elseif id == 21090003 then --账号为空

    elseif id == 21090004 then --渠道不能为空

    elseif id == 21090005 then 

    end ]]--
   
end
--检测背包时候有数据
function G_CheckData( ... )
    -- body

    local flag = false

    if not cache.Pack:getPackInfo()[3]   or table.nums(cache.Pack:getPackInfo()[3])  == 0 then 
        mgr.NetMgr:send(101102,{stype = 0})
        mgr.NetMgr:wait(501102)
    else
        flag = true
    end 
    return flag
end

-----是否有东西可是合成
function G_IsCompose()
    -- body

    --debugprint("来到了这里看看啊拉可能发")
    local  function getPropByid(t,id)
        return t.propertys[id] and t.propertys[id].value or 0
    end

    local dataCard = cache.Pack:getTypePackInfo(pack_type.SPRITE)
    local _diffQualityDataCard = {}
    if dataCard and table.nums(dataCard) >= 5 then 
        for k ,v in pairs(dataCard) do
            if conf.Item:getBattleProperty(v) < 1 then --出站排除
                if v.propertys[317] and v.propertys[317].value > 0 then --小伙伴排除
                else
                    local qq =  conf.Item:getItemQuality(v.mId)
                    local jie = getPropByid(v,307)
                    local jihua = getPropByid(v,310)
                    local lv = getPropByid(v,304)

                    if jie>0 or jihua>0 or lv >1 then --不能合成的排除
                    else
                        if qq < 7  then --最高星级排除
                            if not _diffQualityDataCard[qq] then 
                                _diffQualityDataCard[qq] = {}
                            end 
                            table.insert(_diffQualityDataCard[qq],v)
                            --debugprint("#_diffQualityDataCard[qq] "..#_diffQualityDataCard[qq])
                            if #_diffQualityDataCard[qq] >= 5 then --如果够5个就返回
                                return true
                            end 
                        end 
                    end
                end
            end
        end
    end 


    local dataEquip = cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
    local _diffQualityDataEquip = {}
    if dataEquip or table.nums(dataEquip) > 5 then 
        for k ,v in pairs(dataEquip) do
            local qq = conf.Item:getItemQuality(v.mId)
            local jie = getPropByid(v,311)
            local lv = getPropByid(v,303)

            if jie>0 or lv > 0  then 
            else
                if qq < 7  then --最高星级排除
                    if not _diffQualityDataEquip[qq] then 
                        _diffQualityDataEquip[qq] = {}
                    end
                    table.insert(_diffQualityDataEquip[qq],v)
                    if #_diffQualityDataEquip[qq] >= 5 then 
                        return true
                    end 
                end 
            end 
        end 
    end 

    return false
end



function G_filterChar(str,fliterLimitCharCount,filterFormat,defaultChangeStr)
	--return str
    local newlen,newstr = 0,""
    --default to filter the emoji
    for unchar in string.gfind(str,filterFormat or "[%z\48-\57\64-\126\226-\233][\128-\191]*") do    
        newstr = newstr .. unchar
        newlen = newlen + 1
    end
   -- if len ~= newlen then
     --   newstr = defaultChangeStr or "" --不管需要过滤的特殊字符被如何转码,长度不匹配直接过滤,若长度正巧匹配使用拼接后的新字符串,特殊字符会被转为无意义的乱码
    --end
    return newstr
end

---获取玩家头像 -- 性别*100000+头像Id


function G_GetHeadIcon(id)
    -- body
    local temp = G_Split_Back(id)
   
    --return "res/head/"..temp.sex..string.format("%02d",temp.icon)..".png"
    return temp.icon_img
end

--计算穿戴的 符文是否激活套装
function G_isRuneSuit(data_)
    local wearRune = {}
    local data = cache.Rune:getUseinfo()
    for k ,v in pairs(data) do 
        local card_pos = tonumber(string.sub(v.index,3,3))--数码兽 上阵位置 
        local part = tonumber(string.sub(v.index,-1,-1)) --符文的放置位置
        if not wearRune[card_pos] then
            wearRune[card_pos] ={}
        end
        if wearRune[card_pos][part] then
            wearRune[card_pos][part] = {}
        end
        wearRune[card_pos][part] = v 
    end 

    local c_pos = tonumber(string.sub(data_.index,3,3))
    local suit_id= conf.Item:getItemSuitId(data_.mId)

    local card_data =  wearRune[c_pos]
    local count = 0
    if card_data then 
        for k,v in pairs(card_data) do 
            local id = conf.Item:getItemSuitId(v.mId) 
            if id and id == suit_id then
                count = count+1
            end
        end
    end
    if count > 1 then
        return true
    end
    return false
end

--计算符文可以提供的经验
function G_ExpofRune(data)
    -- body
    local exp = 0
    local curexp =  data.propertys[316] and  data.propertys[316].value or 0
    local lv =  data.propertys[315] and  data.propertys[315].value  or 0
    local att_pre = conf.Item:getAttPre(data.mId)
    local id  = att_pre .. string.format("%03d",lv)
    --print("id "..id)
    local conf = conf.Rune:getItem( id )

    return conf.all_exp + curexp
end
--符文 参数可以提供符文升到的等级 data_ 符文信息 ， 返回值 第一个数是等级 第2个数是 提示用的 0 顶级 1 待定  2 玩家等级限制 
function G_CanUptolv( data_,exp )
    -- body
    print("exp = "..exp)
    local selfexp = G_ExpofRune(data_) --计算本身经验值
    --print("selfexp = "..selfexp)
    local allexp = selfexp + exp
    print("allexp = "..allexp)

    local att_pre = conf.Item:getAttPre(data_.mId)
    local lv =  data_.propertys[315] and  data_.propertys[315].value   or  0

    local maxlv = conf.Item:getMaxQhLv(data_.mId) --可升到的最高等级
    local herolv =  cache.Player:getLevel()
    for i = lv , maxlv do
        local id  = att_pre .. string.format("%03d",i)
        local conf_data = conf.Rune:getItem( id )

        if not conf_data then
            return i , 1
        end

        if allexp <  conf_data.all_exp then
            return i - 1 ,1
        end

        if i == maxlv then
            return i , 1
        end
    end


    --[[for i = lv, cache.Player:getLevel() do
        local id  = att_pre .. string.format("%03d",i)
        local conf = conf.Rune:getItem( id )
        print(" i ="..i )
        if not conf then --顶级
            return  i - 1 , 0
        end
        if allexp <  conf.all_exp then
            return i -1 ,1
        end
        if i == cache.Player:getLevel() then
            return i , 2
        end
    end
    return 0,2]]--
end
---计算符文属性
function G_CalculateRunePro(data)
    -- body
    local function setpro( id,value ,value2)
        -- body
        if value or value2 then
            data.propertys[id] = {}
            data.propertys[id].value = tonumber(value or 0 )+tonumber(value2 or 0 )
        end
    end

    local att_pre = conf.Item:getAttPre(data.mId)

    local lv =  data.propertys[315] and  data.propertys[315].value  or 0
    local id  = att_pre .. string.format("%03d",lv)
    local conf_data = conf.Rune:getItem( id )
    local baseinfo = conf.Item:getIteminfo(data.mId)
    if not baseinfo then
        return
    end

    setpro(102,baseinfo.att_102,conf_data.att_102)
    setpro(105,baseinfo.att_105,conf_data.att_105)
    setpro(103,baseinfo.att_103,conf_data.att_103)
    setpro(116,baseinfo.att_116,conf_data.att_116)
    setpro(106,baseinfo.att_106,conf_data.att_106)
    setpro(108,baseinfo.att_108,conf_data.att_108)
    setpro(110,baseinfo.att_110,conf_data.att_110)
    setpro(109,baseinfo.att_109,conf_data.att_109)

    setpro(202,baseinfo.att_202,conf_data.att_202)
    setpro(205,baseinfo.att_205,conf_data.att_205)
    setpro(203,baseinfo.att_203,conf_data.att_203)
    setpro(206,baseinfo.att_206,conf_data.att_206)
    setpro(208,baseinfo.att_208,conf_data.att_208)
    setpro(210,baseinfo.att_210,conf_data.att_210)
    setpro(209,baseinfo.att_209,conf_data.att_209)
    setpro(216,baseinfo.att_216,conf_data.att_216)

    setpro(119,baseinfo.att_119,conf_data.att_119)
    setpro(120,baseinfo.att_120,conf_data.att_120)
    setpro(121,baseinfo.att_121,conf_data.att_121)
    setpro(122,baseinfo.att_122,conf_data.att_122)
    setpro(123,baseinfo.att_123,conf_data.att_123)
    setpro(124,baseinfo.att_124,conf_data.att_124)
    setpro(125,baseinfo.att_125,conf_data.att_125)
    setpro(107,baseinfo.att_107,conf_data.att_107)
    
    print(baseinfo.power,conf_data.power)
    setpro(305,baseinfo.power,conf_data.power)
    return data
end 
--计算是否有符文可穿戴
function G_isRuneForCard(card_pos)
    -- body
    local data_card = cache.Rune:getUseinfoVec()
    local curdata = data_card[card_pos]
    local packinfo = cache.Rune:getPackinfo()

    if #packinfo == 0 then
        return false
    end

    local function isKey(ptype)
        -- body
        --print("ptype = "..ptype)
        if curdata then
            for k ,v in pairs(curdata) do 
                local a_type = conf.Item:getItemtypePart(v.mId)
               -- print("a_type = ".. a_type)
                if tonumber(ptype) == tonumber(a_type) then
                    return true
                end
            end 
        end

        return false
    end

    for k ,v in pairs(packinfo) do 
        local a_type = conf.Item:getItemtypePart(v.mId)
        if not isKey(a_type) then
            return true
        end
    end

    return false
end
--是否是可以变7s
function G_isNextCard( data_ )
    -- body
    --print(data_.mId)
    local conf_data = conf.Item:getItemConf(data_.mId)
   -- printt(conf_data)
    if conf_data.new_id and checkint(conf_data.new_id) > 0  then
        return true
    end
    return false
end 
--是否是7s 卡
function G_is7sCard( mId )
    -- body
    local conf_data = conf.Item:getItemConf(mId)
     if checkint(conf_data.zhuan) > 0  then
        return true
    end
    return false
end

function G_getTimeStr(timeValue)
    local left = 0
    local day = math.floor(timeValue / (60 * 60 * 24))--天
    left = timeValue - day * 60 * 60 * 24

    local hour = math.floor(left / (60 * 60))--时
    left = left - hour * 60 * 60

    local minute = math.floor(left / 60)--分
    left = left - minute * 60 --秒
    
    local timeStr
    if day == 0 and hour == 0 and minute == 0 then
        timeStr = string.format(res.str.HSUI_DESC4,left)
    elseif day == 0 and hour == 0 then
        timeStr = string.format(res.str.HSUI_DESC5, minute,left)
    elseif day == 0 then
        timeStr = string.format(res.str.HSUI_DESC6, hour,minute,left)
    else
        timeStr = string.format(res.str.HSUI_DESC43, day,hour,minute,left)
    end
    return timeStr
end
---逐个字拆
function G_SplitStr(str,filterFormat)
    --return str
    local str_table = {}
    for unchar in string.gfind(str,"[%z\48-\57\64-\126\226-\233][\128-\191]*") do   
        table.insert(str_table,unchar) 
        --newlen = newlen + 1
        --newstr = newstr .. unchar .. filterFormat
    end
    local newstr =""
    for k, v in pairs(str_table) do 
        newstr = newstr..v
        if k ~= #str_table then
            newstr = newstr..filterFormat
           
        end
    end
    return newstr
end
-----------------------------
--服务返回的数据拆分获取 性别 段位 战力 人物头像icon
function G_Split_Back(data)
    local temp = {}
    if data < 100000000 then
        print("位数不足")
        if data <200000 then
            temp.icon_img = "res/head/200.png"
             temp.icon = 00
             temp.sex = 2
        elseif data <300000 then
            temp.icon_img = "res/head/100.png"
            temp.icon = 00
            temp.sex = 1
        end
        temp.dw = 0
        temp.min_dw = 15
        return temp
    end

    local str = tostring(data)

    temp.sex = tonumber(string.sub(str,1,1))
    temp.vip = tonumber(string.sub(str,2,3))
    temp.dw = tonumber(string.sub(str,4,5))
    temp.power = tonumber(string.sub(str,6,7))
    temp.icon = tonumber(string.sub(str,8,9))
    --段位
    temp.min_dw = 15
    local conf_dw_data = conf.Cross:getDwItem(temp.dw)
    if conf_dw_data then 
        temp.dw_str = conf_dw_data.name or ""
    end
    --头像
    temp.icon_img = "res/head/"..temp.sex..string.format("%02d",temp.icon)..".png"
    --头像外框
    temp.frame_img = res.btn.ROLE_FRAME[temp.power] or res.btn.ROLE_FRAME[1]
    temp.dw_pos = cc.p(99,107)
    temp.vip_pos =  cc.p(25,100)

    return temp
end


--判断 num = 111110的第idx个位置是否有红点 
function G_getRedPointAtIdx(num, idx )
    --G_TipsOfstr(math.floor(num / (math.pow(10, idx))))
    num = num % ((math.pow(10, idx + 1)))
    return math.floor(num / (math.pow(10, idx))) == 1
end
----看看激活几个亲密  这个数码兽激活了几个亲密 --flag是否跳过小伙伴
function G_CountQM(mId,flag)
    -- body
    local t_mid = {}
    local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
    local data1 = {} --这个是小伙伴
    for k,v in pairs(data) do
        if conf.Item:getBattleProperty(v) > 0 then
            local conf_data = conf.Item:getItemConf(v.mId)
            t_mid[conf_data.type_id] = 1
        else
            if v.propertys[317] and v.propertys[317].value > 0 then
                table.insert(data1,v)
            end
        end
    end

    if flag then
    else
        
        for k ,v in pairs(data1) do 
            local conf_data = conf.Item:getItemConf(v.mId)
            t_mid[conf_data.type_id] = 1
        end
    end
    
    --亲密id
    local conf_data = conf.Item:getItemConf(mId)
    local Intimacy_id = conf.Item:getIntimacyID(conf_data.type_id) 
    if not Intimacy_id then 
        return 0
    end
    --作用在那些上
    local card_id = conf.CardIntimacy:getIntimacy(Intimacy_id)
    if not card_id then 
        return 0
    end
    local count = 0
    for k ,v in pairs(card_id.effect_ids) do 
        local confdata = conf.Item:getItemConf(v)
        if t_mid[confdata.type_id] then 
            count = count +1 
        end
    end
    return count
end
--检查是否有卡牌可激活亲密
function G_CheckFriend()
    -- body
    local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)

    local onBattle = {}
    
    for k ,v in pairs(data) do  --找出上阵的 
        local onpos = conf.Item:getBattleProperty(v)
        local type_id = conf.Item:getItemConf(v.mId).type_id
        if onpos > 0 then 
            if not onBattle[type_id] then 
                onBattle[type_id] = 1
            end 
        elseif (v.propertys[317] and v.propertys[317].value > 0)  then
            if not onBattle[type_id] then 
                onBattle[type_id] = 2
            end 
        end 
    end 

    for k , v in pairs(data) do 
        local onpos = conf.Item:getBattleProperty(v)
        local type_id = conf.Item:getItemConf(v.mId).type_id
        if onpos < 1 then -- 
            if not onBattle[type_id] then --屏蔽同类卡牌 --上阵卡牌
                return true
            end 
        end 
    end

    --[[local friend = {}
    for k ,v in pairs(onBattle) do --他们需要的小伙伴
        --k type_id
        if v == 1 then 
            local Intimacy_id = conf.Item:getIntimacyID(k)
            local card_id = conf.CardIntimacy:getIntimacy(Intimacy_id)
            for i , j in pairs(card_id.effect_ids) do 
                if not friend[j] then
                    friend[j] = 1
                end
            end
        end
    end


    local t = {}
    for k , v in pairs(data) do 
        local onpos = conf.Item:getBattleProperty(v)
        local type_id = conf.Item:getItemConf(v.mId).type_id
        if onpos < 1 then -- 
            if not onBattle[type_id] then --屏蔽同类卡牌 --上阵卡牌
                table.insert(t,v)
            end 
        end 
    end

    for k ,v in pairs(t) do 
        local type_id = conf.Item:getItemConf(v.mId).type_id
        if  friend[type_id] then
            return true
        end
    end]]--

    return false
end
--检查 这个mid  在上阵 活着小伙伴村不在
function G_CheckFriend_qm(mId)
    -- body
    local flag = false
    local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
    local oldid = conf.Item:getItemConf(mId).type_id
    for k ,v in pairs(data) do 
        local type_id = conf.Item:getItemConf(v.mId).type_id
        if v.propertys[308] and v.propertys[308].value > 0 then 
            if type_id == oldid then
                flag = true
                break
            end
        end

        if v.propertys[317] and v.propertys[317].value > 0 then
            if type_id == oldid then
                flag = true
                break
            end
        end
    end

    return flag
end
