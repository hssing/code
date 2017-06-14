--[[--
技能配置
]]
local CopyConf=class("CopyConf",base.BaseConf)

function CopyConf:init(  )
    --获取副本的信息
    self._confChapter = require("res.conf.fb_chapter")
    self._confBase = require("res.conf.base_fuben")
    
    --获取竞技场的配置信息
    self._jjcConf = require("res.conf.arena_speak")
    
    --获取爬塔副本的配置
    self._towerConf = require("res.conf.pata_fuben")
    self._towerStarConf = require("res.conf.pata_config")
    self._towerAward = require("res.conf.pata_award")
end

---------------------------
--@param id_ 技能id
--@return 技能数据
function CopyConf:getChapterInfo( id_ )
    return self._confChapter[id_..""]
end

---------------------------
--@param id_ 关卡id，获取该关卡的信息
function CopyConf:getFbInfo(id_)
    return self._confBase[id_..""]
end

function CopyConf:get30AwardItems( id_ )
    local data = self._confChapter[id_..""]
    return data.award
end

---获取竞技场说话数据
function CopyConf:getJJCSpeak()
    return self._jjcConf["1"]["speak"]
end

---爬塔副本信息
function CopyConf:getTowerInfo(id_)
    return self._towerConf[id_..""]
end

---爬塔星级奖励
function CopyConf:getTowerStarAward(star_)
    return self._towerStarConf[star_..""]
end

function CopyConf:getTowerAward(star, rank)
    local index = (star-1)*10+rank
    local awards = self._towerAward[index..""]["rank_awards"]
    for i = 1, #awards do
        if awards[i][1] == 221051002 then
            return awards[i][2]
        end
    end
end

-----------util
---获取爬塔关数
function CopyConf:getTowerGq(id_)
    return tonumber(string.sub(id_ ,3,5))
end


return CopyConf
