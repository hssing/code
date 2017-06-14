--[[--
加载模型/效果
]]
local BoneLoadMgr=class("BoneLoadMgr")

function BoneLoadMgr:ctor()
    self._isLoad                  = false --加载状态
    self._currLoadCache           = {}    --当前加载
    self._completeLoadCache       = {}    --加载完成
    self._ignoreList = {}
    self.coolTime = 0
    -- self.coolHandler = scheduler.scheduleGlobal(function()
    --     self:_timeLoadRes()
    -- end,1/30)
end

function BoneLoadMgr:addIgnore()
    self._ignoreList["70301801"] = 1
end

---------------------
---- public
---------------------

---------------------------
--添加资源加载
--@param id_ 资源名
--@param onCallFun_ 加载完成后的回掉 
function BoneLoadMgr:addLoad(id_, onCallFun_)
    local id = id_ .. ""
    if self._completeLoadCache[id] then
        onCallFun_()
    else
        local info = self._currLoadCache[id]
        if info then
            table.insert(info.funcList, onCallFun_)
        else
            self._currLoadCache[id] = {
                key = id,
                funcList = {onCallFun_}
            }
        end
    end
    self:_startLoad()
end

---------------------------
--删除动画资源
--@param key_ 资源名
function BoneLoadMgr:removeArmatureFileInfo(key_)
    local key = key_ .. ""
    local newInfo = self._completeLoadCache[key] 
    if newInfo then
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(newInfo.configPath)
        self._completeLoadCache[key] = nil
    end
end

---------------------------
--删除所有加载的动画对象
function BoneLoadMgr:removeAllArmature()
    for key, var in pairs(self._completeLoadCache) do
        if var and not self._ignoreList[key..""] then
            if var.configPath then
                ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(var.configPath)
            end
        end
    end
    self._completeLoadCache = {}
    self._isLoad = false
    self._currLoadCache = {}
end

---------------------
---- private
---------------------

---------------------------
--开始加载
function BoneLoadMgr:_startLoad()
    if not self._isLoad then
        local currLoadInfo
        for key, var in pairs(self._currLoadCache) do
            if var then
                currLoadInfo = var
            end
            break
        end
        if currLoadInfo then
            self._isLoad = true
            local name = currLoadInfo.key
            local configPath = self:_getBoneCsb(name)
            --print("configPath = "..configPath)
            --TODO 目前无法知道该效果所加载的纹理，清理工作待处理
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(configPath, function(percent)
                if percent == 1 then    
                    local funList = currLoadInfo.funcList
                    for key, var in ipairs(funList) do
                        if type(var) == "function" then
                            var()
                        end
                    end   
                    self._currLoadCache[name] = nil
                    local newInfo = {}
                    newInfo.configPath = configPath
                    self._completeLoadCache[name] = newInfo                  
                    self._isLoad = false
                    self:_startLoad()
                end
            end)
        end
    end
end

---直接加载效果
function BoneLoadMgr:loadArmature(id_,index)
    if not index then 
        index = 0
    end 

    local effConfig = conf.Effect:getInfoById(id_)
    if not effConfig then
        print("无效果ID：", id)
    end 
    local sName = effConfig.effect_id
    local configPath = self:_getBoneCsb(sName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(configPath)
    local armature = ccs.Armature:create(sName)
    armature:getAnimation():playWithIndex(index)
    local newInfo = {}
    newInfo.configPath = configPath
    self._completeLoadCache[sName] = newInfo  
    return armature
end
--只创建 不播放
function BoneLoadMgr:createArmature(id_)
    -- body
    local effConfig = conf.Effect:getInfoById(id_)
    if not effConfig then
        print("无效果ID：", id)
    end 

    local sName = effConfig.effect_id
    local configPath = self:_getBoneCsb(sName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(configPath)
    local armature = ccs.Armature:create(sName)

    local newInfo = {}
    newInfo.configPath = configPath
    self._completeLoadCache[sName] = newInfo  

    return armature
end

function BoneLoadMgr:_getBoneCsb(id_)
    print("id_ "..id_)
    local type = math.floor(tonumber(id_)/10000000)
    if type == 7 then  --技能特效
        local dir = math.floor(tonumber(id_)/10).."0"
        return "res/effects/"..dir.."/"..id_..".csb"
    else
        print(" = "..res.bone[id_..""]..".csb")
        return res.bone[id_..""]..".csb"
    end
    return ""
end

------------------------------------------------------------------------------------------------
---进入战斗缓存处理
function BoneLoadMgr:loadCache( skillData_ )
    --清理效果资源
    mgr.BoneLoad:removeAllArmature()
    --加载动画
    G_Loading(true)
    --私有函数，递归获取效果配置id
    local function effectLoadLoop(effId_)
        local effectConf = conf.Effect:getInfoById(effId_)
        local xiaoguo = effectConf.effect_id
        if xiaoguo then
            if not self.effectList[xiaoguo..""] then
                self.effectList[xiaoguo..""] = 1
                self.loadCacheNum = self.loadCacheNum + 1
            end       
            local effectId2 = effectConf.trigger_fun
            if effectId2 and effectId2 ~= 1 then
                effectLoadLoop(effectId2)
            end
        end      
    end

    local addEffNum
    if cache.Fight:getType() ~= fight_vs_type.copy then --不是副本
        addEffNum = 5
    end

    --解析技能数据
    local data = skillData_["bouts"]
    self.loadCacheNum = 0
    self.effectList = {}
    for i=1, #data do
        local newBout = data[i].bout ---创建角色的时候开场战斗，竟然会有nil出现...
        if addEffNum and newBout and newBout > addEffNum then
            break
        end

        local skillId = data[i]["skillId"]
        local skillConf = conf.Skill:getInfoById(skillId)
        local effectId = skillConf.attack_effect
        local hitId = skillConf.smitten_effect
        if effectId then 
            effectLoadLoop(effectId)
        end
        if hitId then
            effectLoadLoop(hitId[1])
        end

    end

    --添加怒气
    self.effectList["70104001"] = 1
    self.loadCacheNum = self.loadCacheNum + 1

    --预加载所有效果
    print("____________________________________加载战斗效果：", self.loadCacheNum)
    for key, value in pairs(self.effectList) do
        self:addLoad(key,function()
            self:loadFinish()
        end)
    end
end

function BoneLoadMgr:_timeLoadRes()
    if self.effectList then
        for key, value in pairs(self.effectList) do
            self.effectList[key] = nil

            self:addLoad(key,function()
                self:loadFinish()
            end)
        end
    end 
end

function BoneLoadMgr:loadFinish()
    self.loadCacheNum = self.loadCacheNum - 1
    if self.loadCacheNum <= 0 then
        G_Loading(false, function()
            if mgr.SceneMgr:checkCurScene() == _scenename.FIGHT then
                mgr.SceneMgr:getNowShowScene():fight(true)
            else
                mgr.SceneMgr:LoadingScene(_scenename.FIGHT)
            end
        end)
    end
end

return BoneLoadMgr