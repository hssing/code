local GuideMgr = class("GuideMgr")

function GuideMgr:ctor()
    self.guideId = 1001
    self.lastGuideId = 0
end

function GuideMgr:initGuideId(id_)
    --if self.guideId ~= 1001 then return end
    if id_ == 0 then
        self.guideId = 1001
        self.lastGuideId = 1001
    elseif id_ == 9999 then
        self.guideId = 9999
        self.lastGuideId = 9999
    else
        self.lastGuideId = id_
        local config = conf.guide:getGuideById(id_)
        self.guideId = config.start
    end
end

---开始引导
function GuideMgr:startGuide()
    if no_guide == true then return end
    if self.guideId ~= 9999 then
        local view = mgr.SceneMgr:getMainScene():addGuideView()
        view:enterGuide({id=self.guideId})
    end
end

---继续引导
function GuideMgr:continueGuide()
    if no_guide == true then return end
    --当前引导配置
    local config = conf.guide:getGuideById(self.guideId)
    --下一个引导
    self:_checkNowGuide()   
    if config.pause == 1 then
        return
    elseif config.pause == 2 then
        self:killGuide()
        return 
    end 
    
    local view=mgr.ViewMgr:get(_viewname.GUIDE_VIEW)
    if view then
        view:enterGuide({id=self.guideId})
    end
end

---继续引导方式2
function GuideMgr:continueGuide__(ids_)
    if no_guide == true then return end
    if self.guideId == 9999 then return end
    for i=1, #ids_ do
        if ids_[i] == self.guideId then
            self:continueGuide()
            return
        end
    end
end

---暂停引导
function GuideMgr:pauseGuide()
    --关闭引导view
    local view=mgr.ViewMgr:get(_viewname.GUIDE_VIEW)
    if view then
        view:onCloseSelfView()
    end
end

function GuideMgr:checkGuideEnd()
    --当前引导配置
    local config = conf.guide:getGuideById(self.guideId)
    if config and config.pause == 2 then
        self.guideId = 9999
        self.lastGuideId = 9999
        --发送服务端保存id
        mgr.NetMgr:send(101010,{guideId=9999})
        return 
    end
end

---结束引导
function GuideMgr:killGuide()
    self.guideId = 9999
    self.lastGuideId = 9999
    --发送服务端保存id
    mgr.NetMgr:send(101010,{guideId=9999})
    
    --关闭引导view
    local view=mgr.ViewMgr:get(_viewname.GUIDE_VIEW)
    if view then
        view:onCloseSelfView()
    end
end

---获取当前引导
function GuideMgr:_checkNowGuide()
    self.guideId = self.guideId + 1
    local config = conf.guide:getGuideById(self.guideId)
    local multi = config.no_multi
    if (self.guideId < self.lastGuideId and multi and multi==1) or (multi and multi==2)  then
        self:_checkNowGuide()
        return
    end
    --最新的引导发送服务器
    if self.guideId > self.lastGuideId then
        mgr.NetMgr:send(101010,{guideId=self.guideId})
    end
end

---剧情对话
function GuideMgr:startFightPlot(params_)
    local view = mgr.SceneMgr:getNowShowScene():addGuideView()
    --剧情对话
    view:enterGuide(params_)
    --首次出现效果
    if params_.id == 1904 then
        view:playNewerEffect()
    end
end

---新功能开启
function GuideMgr:openFunc()
    if mgr.SceneMgr:checkCurScene() ~= _scenename.MAIN then
        return
    end
    local roleLvl = cache.Player:getLevel()
    local unOpenList = cache.Player.unOpenList
    for key, value in pairs(unOpenList) do
        if roleLvl>=value.level then
            local check = mgr.ViewMgr:get(_viewname.OPEN_FUNC)
            if not check then
                local view = mgr.ViewMgr:showView(_viewname.OPEN_FUNC)
                view:setData(value)
            end
            unOpenList[key] = nil
        end
    end    
end

function GuideMgr:checkOpen(name_)
    local unOpenList = cache.Player.unOpenList
    if unOpenList[name_..""] then
        return false , unOpenList[name_..""]
    end
    return true
end

return GuideMgr