local CopyProxy=class("CopyProxy",base.BaseProxy)

function CopyProxy:init()
    --副本相关
    self:add(507001, self.onRChapterInfo)  --领取章节30星奖励
    self:add(507002, self.onR30Award)
    self:add(502001, self.onRFightResult)  --副本战斗返回
    self:add(507003, self.onRFbWipe)       --扫荡返回
    
    --竞技场相关
    self:add(514001, self.onRAthleticsInfo) --获取竞技场信息
    self:add(502002, self.onRAthleticsFight) --竞技场战报
    self:add(514002, self.onRAthleticsCompare)  --竞技场对比信息
    self:add(514003, self.onRAthleticsAward)  --竞技场结算奖励
    self:add(514004, self.onRAthleticsWipe)  --竞技场战五次
  --  self:add(501005, self.onRAthleticsTimes)  --竞技场次数
    self:add(514005, self.onRAthleticsCompareDetail)
    
    --爬塔
    self:add(515001, self.onRTowerInfo)  --获取爬塔信息
    self:add(515002, self.onRTowerRankAward)  --获取排名奖励
    self:add(502003, self.onRTowerFight) --爬塔战斗返回
    self:add(515003, self.onRTowerYq)  --爬塔勇气返回
    self:add(515004, self.onRTowerWipe)  --爬塔一键五关
    self:add(515005, self.onRTowerAward)  --爬塔奖励
    self:add(515006, self.onRBuyAward)  --爬塔奖励
    self:add(515007, self.onRGetBuyAward)  --爬塔奖励

    --公会副本
    self:add(502004, self.onRGuildFight)  --公会副本战斗
    --数码大赛
    self:add(502005, self.onRSmdsMsg)
    --文件岛挑战
    self:add(502006, self.onWJmsgCallBack)
    --文件岛抢夺
    self:add(502007, self.onWJQdCallBack)
    --阵营战
    self:add(520106, self.onCampCallBack)
    --日常副本战斗
    self:add(502008, self.onDayFubenCallBack)
    --
    self:add(502009,self.onCrossWarCallBack)
    --跨服战录像
    self:add(523013,self.add_523013)
    --世界boss请求挑战一次
    self:add(526001,self.add_526001)
end

function CopyProxy:onSFight(msgId_, data_)
    self:send(msgId_, data_)
    self:wait(msgId_+400000, true)
end

--------------------------------------------------------------------------------副本
function CopyProxy:onRChapterInfo(data_)
    if data_.status == 0 then
        cache.Copy:initData(data_)
        --从其他地方跳转过来的
        if self.jumpData then
           G_GotoChapterPrepare()
            self.jumpData = nil
        else
            local view=mgr.ViewMgr:get(_viewname.COPY_CHAPTER)
            if view then
                view:setData()
            end
        end
        
    end
end

function CopyProxy:onR30Award(data_)
    if data_.status == 0 then
        cache.Copy:set30Award()
        local view=mgr.ViewMgr:get(_viewname.COPY_CHAPTER)
        if view then
            view:get30Award()
            view:setData()
        end
    elseif data_.status == 21030001 then
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    end
end

function CopyProxy:onRFightResult(data_)
    if data_.status == 0 then

        cache.Fight:setData(data_, 1)
        mgr.BoneLoad:loadCache(data_["fightReport"])
        cache.Copy:updateData(data_)
        local ids = {1003,1013,1014,1027,1028,1043,1044,1051,1052,1061}
        mgr.Guide:continueGuide__(ids)

        --G_ShowAchi()
    elseif data_.status == 21030001 then
        cache.Fight.isClickFight = false
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    end
end

function CopyProxy:onRFbWipe( data_ )
    if data_.status == 0 then
        local view=mgr.ViewMgr:get(_viewname.COPY_WIPE)
        if not view then
            view=mgr.ViewMgr:showView(_viewname.COPY_WIPE)
        end
        if view then
            view:setData(data_.sId, fight_vs_type.copy)
            view:rWipeInfo(data_)
        end
        local view2 = mgr.ViewMgr:get(_viewname.COPY_CHAPTER)
        if view2 then
            view2:updateCopyTimes(data_)
        end
    elseif  data_.status == 21030001 then
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    end
end


--------------------------------------------------------------------------------竞技场
function CopyProxy:onRAthleticsInfo(data_)
    if data_.status == 0 then
        mgr.Sound:playViewJJC()
        --local view = mgr.ViewMgr:get(_viewname.ATHLETICS)
        --if not view then
            view = mgr.ViewMgr:showView(_viewname.ATHLETICS)
        --end
        if view then
            view:onRAthleticsInfo(data_)
        end
        local enterView = mgr.ViewMgr:get(_viewname.FUNBENVIEW)
        if enterView then
            enterView:closeSelfView()
        end
    end
end

function CopyProxy:onRAthleticsFight(data_)
    if data_.status == 0 then
        cache.Fight:setData(data_, 2)
        mgr.BoneLoad:loadCache(data_["fightReport"])
        cache.Player:_setAthleticsCout(data_.jjcCount)
        --G_ShowAchi()
    elseif  data_.status == 21030001 then
        cache.Fight.isClickFight = false
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif data_.status == 21301001 then
        cache.Fight.isClickFight = false
        cache.Fight.fightState = 0
        mgr.NetMgr:send(114001)
    end
end

function CopyProxy:onRAthleticsCompare(data_)
    if data_.status == 0 then
        -------判断是否为当前场景
        local scene =  mgr.SceneMgr:getNowShowScene()
        if scene.name == _scenename.MAIN then
           --mgr.SceneMgr:getMainScene():changeView(0, _viewname.ATHLETICS_COMPARE):setData(data_)
           mgr.ViewMgr:showView( _viewname.ATHLETICS_COMPARE):setData(data_)
           return
        end
        mgr.SceneMgr:LoadingScene(_scenename.MAIN, {completeCallFun = function()
        mgr.SceneMgr:getMainScene():changeView(0, _viewname.ATHLETICS_COMPARE):setData(data_)
        --mgr.ViewMgr:showView( _viewname.ATHLETICS_COMPARE):setData(data_)
        end})
    end
end

function CopyProxy:onRAthleticsAward(data_)
    if data_.status == 0 then
        
    end
end

function CopyProxy:onRAthleticsWipe(data_)
    if data_.status == 0 then
        local view=mgr.ViewMgr:get(_viewname.ATHLETICS_WIPE)
        if not view then
            view = mgr.ViewMgr:showView(_viewname.ATHLETICS_WIPE)
        end
        if view then
            view:setData(data_.roleId)
            view:rWipeInfo(data_)
        end
        local view2 = mgr.ViewMgr:get(_viewname.ATHLETICS)
        if view2 then
            view2:updatejjcTimes(data_.jjcCount)
        end
    elseif  data_.status == 21030001 then
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    end
end

function CopyProxy:onRAthleticsTimes(data_)
    if data_.status == 0 then
        if data_.stype == property_index.ATHLETICS_COUT then
            local view2 = mgr.ViewMgr:get(_viewname.ATHLETICS)
            if view2 then
                view2:updateGMTimes(data_)
            end
        end
    end
end

function CopyProxy:onRAthleticsCompareDetail(data_)
    if data_.status == 0 then
        local view = mgr.ViewMgr:get(_viewname.ATHLETICS_COMPARE)
        if view then
            view:onOtherCard(data_)
        end
    end
end

--------------------------------------------------------------------------------爬塔

function CopyProxy:onRTowerInfo(data_)
    if data_.status == 0 then
        local view = mgr.ViewMgr:showView(_viewname.CLIMB_TOWER)
        mgr.Sound:playViewShenYuan()
        if view then
            view:rTowerInfo(data_)
        end
        local enterView = mgr.ViewMgr:get(_viewname.FUNBENVIEW)
        if enterView then
            enterView:closeSelfView()
        end
    end
end

---获取排名奖励
function CopyProxy:onRTowerRankAward(data_)
    if data_.status == 0 then
        local view=mgr.ViewMgr:get(_viewname.TOWER_AWARD)
        if view then
            view:rTowerAward(data_)
        end
    end
end

function CopyProxy:onRTowerFight(data_)
    if data_.status == 0 then
        cache.Copy.towerData.guts = data_.totalGuts
        cache.Fight:setData(data_, 3)
        mgr.BoneLoad:loadCache(data_["fightReport"])
        if data_.lastCount <= 0 and cache.Copy.towerData.buyCount > 0 then
            cache.Player:setTowerNumber(0)
        end
        --G_ShowAchi()
    elseif  data_.status == 21030001 then
        cache.Fight.isClickFight = false
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    end
end

function CopyProxy:onRTowerYq(data_)
    if data_.status == 0 then
        local view=mgr.ViewMgr:get(_viewname.CLIMB_TOWER)
        if view then
            view:rTowerYq(data_)
        end
    end
end

---爬塔一键五关
function CopyProxy:onRTowerWipe(data_)
    if data_.status == 0 then
        local view=mgr.ViewMgr:get(_viewname.COPY_WIPE)
        if view then
            view:rWipeInfo(data_)
        end
        local view2 = mgr.ViewMgr:get(_viewname.CLIMB_TOWER)
        if view2 then
            view2:rTowerWipeUpdata(data_)
        end
    elseif  data_.status == 21030001 then
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    end   
end

function CopyProxy:onRTowerAward(data_)
    if data_.status == 0 then
        local view = mgr.ViewMgr:get(_viewname.TOWER_AWARD)
        if view then
            view:rTowerGetAward(data_)
        end
    end  
end

---购买宝箱
function CopyProxy:onRBuyAward(data_)
    if data_.status == 0 then
        local view = mgr.ViewMgr:get(_viewname.TOWER_BUY_AWARD)
        if view then
            view:nextAward(data_)
        end
        -- if data_.canBuyCount == 0 then
        --     if view then
        --         view:onCloseSelfView()
        --     end
        -- else
        --     if view then
        --         view:nextAward(data_)
        --     end
        -- end        
    end  
end

---爬塔宝箱
function CopyProxy:onRGetBuyAward(data_)
    if data_.status == 0 then
        local view = mgr.ViewMgr:showView(_viewname.TOWER_BUY_AWARD)
        if view then
            view:OpenBox(data_)
        end
    end  
end

------------------------------------------------------------------------公会副本
function CopyProxy:onRGuildFight(data_)
    if data_.status == 0 then
        cache.Fight:setData(data_, 4)
        --更新副本数据缓存
        local data = cache.Guild:getGuildFbInfo()
        data.maxHp = data_.maxHp
        data.currHp = data_.currHp
        data.fbCount = data.fbCount - 1



       if #data.gkAwards == 0 and data.fbCount ==0  then --清除红点
            cache.Player:_setGongHFuBJLNumber(0)
        end 

        
        if data_.fightReport.win == 1 then
            local fbInfo = cache.Guild:getGuildFbInfo()
            local oldid = string.sub(fbInfo.fbId,0,4)
            local newid = string.sub(data_.fId,0,4)
            if tonumber(oldid) ~= tonumber(newid) then --通关了
                --5105 --5103
                if cache.Player:getMaxChapterId() >= tonumber(oldid) then
                   
                else
                    cache.Player:_setGongHTongGJLNumber(cache.Player:getGongHTongGJLNumber()+1)
                end
            end 

            fbInfo.fbId = data_.fId
            fbInfo.gkAwards[fbInfo.oldFbId..""] = 1

            cache.Player:_setGongHFuBJLNumber(cache.Player:getGongHFuBJLNumber()+1)
        end
        mgr.BoneLoad:loadCache(data_["fightReport"])
         --G_ShowAchi()
    elseif  data_.status == 21030001 then
        cache.Fight.isClickFight = false
        cache.Fight.fightState = 0
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif data_.status == 21200005 then
        G_TipsOfstr(res.str.GUILD_DEC59)
    else
        ---错误号再次请求副本信息刷新界面
        cache.Fight.isClickFight = false
        G_TipsOfstr(res.str.SYS_DEC9)
        mgr.NetMgr:send(117301)
    end
end


function CopyProxy:sendSmds(param )
    -- body
    self:send(102005,param)
    self.videid = param.frId
end

function  CopyProxy:getVideoid()
    -- body
    return self.videid
end

function CopyProxy:onRSmdsMsg( data_ )
    -- body
    if data_.status == 0 then 
        cache.Fight:setData(data_, 5)
        mgr.BoneLoad:loadCache(data_["fightReport"])
    elseif data_.status == 21020003 then 
        G_TipsOfstr(res.str.CONTEST_DEC15)
    else
        debugprint(" 录像 -1")
    end 
end

--[[function CopyProxy:sendWJDmsg( param)
    -- body
    self:send(102006,param)
end]]--

function CopyProxy:onWJmsgCallBack( data_ )
    -- body
    if data_.status == 0 then 
        if data_.fightReport.start > 0 then 
            local count = cache.Player:getDigNumber()
            count = count +1 
            if count < 0 then 
                count = 0
            end 
            cache.Player:_setDigNumber(count)

            --if count == 0 then
                local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
                if view then 
                    view:setFbRed()
                end
            --end
        end 

        cache.Fight:setData(data_, 6)
        mgr.BoneLoad:loadCache(data_["fightReport"])
    elseif data_.status == 21020003 then 
        G_TipsOfstr(res.str.CONTEST_DEC15)
        debugprint(" 文件岛 -1") 
    end
end

function CopyProxy:onWJQdCallBack( data_ )
    -- body
    if data_.status == 0 then 
        --红点变少
        local count = cache.Player:getDigNumber()
        count = count - 1 
        if count < 0 then 
            count = 0
        end 
        cache.Player:_setDigNumber(count)
        local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
        if view then 
            view:setFbRed()
        end
        --抢夺次数改变
        cache.Dig:setQdCount()--默认会-1

        cache.Fight:setData(data_, 7)
        mgr.BoneLoad:loadCache(data_["fightReport"])
    elseif data_.status == 21030001 then 
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif 21200016 == data_.status  then 
        G_TipsOfstr(res.str.DEC_ERR_10)   
    elseif 21200017 == data_.status  then 
        G_TipsOfstr(res.str.DEC_ERR_20)  
    elseif 21200010 ==  data_.status  then 
        G_TipsOfstr(res.str.DEC_ERR_03) 
    elseif 21200007 ==  data_.status  then
        G_TipsOfstr(res.str.DEC_ERR_22)   
    end
end

function CopyProxy:onCampCallBack(data_)
    -- body
    if data_.status == 0 then 
        print("战报返回")
        cache.Fight:setData(data_, 8)
        mgr.BoneLoad:loadCache(data_["fightReport"])
    elseif data_.status == 21030001 then 
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif data_.status == 21210001 then 
        G_TipsOfstr(res.str.DEC_ERR_60)
    end
end

function CopyProxy:onDayFubenCallBack(data_)
    -- body
    if data_.status == 0 then 
        if data_.fightReport.start > 0 then
            local count  = cache.Player:getDayFubenNumber()
            count = count - 1
            if count < 0 then
                count = 0
            end
            cache.Player:_setDayFubenNumber(count)
        end


        cache.DayFuben:setplayCount(checkint(data_.sId/100),data_.playCount) 
        cache.Fight:setData(data_, 9)
        mgr.BoneLoad:loadCache(data_["fightReport"])
    elseif data_.status == 21030001 then 
        G_TipsOfstr(res.str.NO_ENOUGH_PACK)
    elseif 21410001 == data_.status then
        G_TipsOfstr(res.str.DEC_NEW_33)
    end
end
--跨服战 个人匹配
function CopyProxy:onCrossWarCallBack( data_ )
    -- body
    if data_.status == 0 then
        --红点次数

        ---
        local  iswin = false
        if data_.fightReport.start > 0 then
            iswin = true
        end

        --判定段位是否有改变
        cache.Cross:isDwUp(data_.roleDw)
        cache.Cross:resetDjs(iswin)
        if cache.Cross:getlastDjs() then
            if cache.Cross:getisDwUp() ==0 then
                cache.Cross:setisDwUp(2)
            end
        end
        cache.Cross:resetself(data_)
        local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_MAIN)
        view:serverCallBack(data_) 
    else
    	local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_MAIN)
        view:serverCallBack(data_) 
        G_TipsError(data_.status)
    end
end


function CopyProxy:setJumpToData( data )
    self.jumpData = data
end

function CopyProxy:add_523013( data_ )
    -- body
    if data_.status == 0 then
        cache.Fight:setData(data_, 11)
        mgr.BoneLoad:loadCache(data_["fightReport"])
    else
        G_TipsError(data_.status)
    end
end

function CopyProxy:add_526001( data_ )
    -- body
    if data_.status == 0 then
        local view = mgr.ViewMgr:get(_viewname.BOSS_MAIN) 
        if view then
            cache.Boss:setBossValue(data_)
            cache.Fight:setData(data_, 12)
            if data_.autoBattle < 1 then 
                mgr.BoneLoad:loadCache(data_["fightReport"])
            end
        end
    else
        G_TipsError(data_.status)
    end
end

return CopyProxy