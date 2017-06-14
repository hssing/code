--[[--
副本数据
]]
local CopyCache = class("CopyCache",base.BaseCache)

function CopyCache:init()
    ---副本相关
    self._chapterInfo = {}
    self._id = 0  --当前章节
    self._baseFbId = 0
    self._superFbId = 0
    self._emengId = 0
    self.hasNew = false  --是否开启了下一关
    self.hasFinish = false
    self.curHardLevel = 2
    
    ---竞技场相关
    self._jjcData = nil
    self._jjcFlag = 1
    
    ---爬塔相关
    self.towerStarLvl = 0
    self.towerData = nil 
    self.resetFlag = 0
    self.isPushInspire = 0
end



-----------------------------------------------------------------------------------------------副本
---服务端数据过来
function CopyCache:initData(data_, id_)
    if not id_ then id_ = self._id end
    self._chapterInfo[id_..""] = data_
end

---获取章节数据，记录当前章节id
--@params id_ 章节id
function CopyCache:getData(id_)
    if id_ then self._id = id_ end
    return self._id, self._chapterInfo[self._id..""]
end

function CopyCache:gotoNext()
    local tempId = self._id%(math.floor(self._id/100)*100)
    if tempId >= 50 then
        return false
    end
    self._id = self._id+1
    return true
end

---获取改章节的所有星星
function CopyCache:getChapterStars( id_ )
    local id = id_ or self._id
    local data = self._chapterInfo[self._id..""]
    local info = data.fbInfo
    local stars = 0
    for i=1, #info do
        stars = info[i].start + stars
    end
    return stars
end
---检查是否领取30星
function CopyCache:get30Award( id_ )
    local id = id_ or self._id
    local data = self._chapterInfo[self._id..""]
    return data.award
end
---设置已经领取30星
function CopyCache:set30Award( id_ )
    local id = id_ or self._id
    local data = self._chapterInfo[self._id..""]
    data.award = 1
end

---战斗数据更新副本信息
function CopyCache:updateData( data_ )
    if data_.fightReport.start > 0 then
        local zj = math.floor(data_.sId / 100)
        local maxTime = 10
        if zj > 3000 then maxTime = 5 end
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^", zj)
        local vector = self._chapterInfo[zj..""]["fbInfo"]
        for i=1, #vector do
            if vector[i].fId == data_.sId then
                if vector[i].start == 0 then  --新关卡
                    if maxTime == i then  --挑战最后一关通关
                        self.hasFinish = true
                        local newZj = (zj + 1)
                        local fbId = newZj*100+1
                        local chapterConf = conf.Copy:getFbInfo(fbId)
                        if chapterConf then  --没有配置就不更新了。比如达到最后一章
                            local data = {["fId"]=fbId,["start"]=0,["fbCount"]=chapterConf.max_count}
                            self._chapterInfo[newZj..""] = {["fbInfo"] = {data}, ["award"]=0}
                            if zj > 7000 then --噩梦
                                self._emengId = newZj*100+1
                            elseif zj > 3000 then  --精英副本
                                self._superFbId = newZj*100+1  
                            else
                                self._baseFbId = newZj*100+1
                            end
                        end  
                    else
                        local fbId = data_.sId+1
                        local chapterConf = conf.Copy:getFbInfo(fbId)
                        local data = {["fId"]=fbId,["start"]=0,["fbCount"]=chapterConf.max_count}
                        table.insert(self._chapterInfo[zj..""]["fbInfo"],data) 
                        self.hasNew = true
                    end 
                end            
                if data_.fightReport.start > vector[i].start then
                    vector[i].start = data_.fightReport.start
                end
                vector[i].fbCount = data_.maxCount
            end
        end
    end
end

function CopyCache:setZjInfo(info)
    self._baseFbId = info["2"]
    self._superFbId = info["3"]
    self._emengId = info["7"]
end

function CopyCache:getBaseFbMax()
    return self._baseFbId
end

function CopyCache:getSuperFbMax()
    return self._superFbId
end

function CopyCache:getEmengFbMax()
    return self._emengId
end


function CopyCache:getId()
    return self._id
end

-----------------------------------------------------------------------------------------------竞技场
function CopyCache:setJJCData(data_)
    self._jjcData = data_
end

function CopyCache:getJJCData()
    return self._jjcData
end

function CopyCache:updateJJCFlag(index)
  print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&", index)
    local flag = cache.Copy:getJJCFlag()
    if flag == 1 then
        if index % 2 == 1 then
            self._jjcFlag = 2
        end
    else
        if index % 2 == 1 then
            self._jjcFlag = 1
        end 
    end
end
function CopyCache:getJJCFlag()
    return self._jjcFlag
end

function CopyCache:setChapterId( id )
    self._id = id
end


return CopyCache