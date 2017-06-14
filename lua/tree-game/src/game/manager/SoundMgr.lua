--[[
音乐与音效播放
]]

local SoundMgr = class("SoundMgr")

function SoundMgr:ctor()
    SoundMgr._isOpenMusic = true
    SoundMgr._isOpenSound = true
    SoundMgr._musicVolume = 0.5
    SoundMgr._soundVolume = 0.5
    self.coolTime = 0
    self.soundCool = scheduler.scheduleGlobal(function()
        if self.coolTime>0 then
            self.coolTime = self.coolTime - 1
        end
    end,1.0)

    self.sdkSoundOpen = true
    --self.sdkMusicState = MyUserDefault.getIntegerForKey(user_default_keys.OPEN_MUSIC)
    --self.sdkSoundState = MyUserDefault.getIntegerForKey(user_default_keys.OPEN_SOUND)
end


function  SoundMgr:init(  )
    local musicState = MyUserDefault.getIntegerForKey(user_default_keys.OPEN_MUSIC)
    if musicState == 2 then
        self._isOpenMusic = false
        self:openMusic(false)
    else
        self._isOpenMusic = self.sdkSoundOpen
    end
    local soundState = MyUserDefault.getIntegerForKey(user_default_keys.OPEN_SOUND)
    if soundState == 2 then
        self._isOpenSound = false
    else
        self._isOpenSound = self.sdkSoundOpen
    end
    local vol = MyUserDefault.getIntegerForKey(user_default_keys.SOUND_VOLUME)
    if vol == 2 then
        audio.setSoundsVolume(0)
    end
    print("___________________________________________________________声音状态:",musicState, soundState)
end

--------------------------------
-- 17waa音效管理state_==true 恢复  
function SoundMgr:sdkSound(state_)
    self.sdkSoundOpen = state_

    local musicState = MyUserDefault.getIntegerForKey(user_default_keys.OPEN_MUSIC)
    if state_ and musicState~=2 then
        self:openMusic(true)
        self._isOpenSound = true
    else
        SoundMgr:stopMusic()
        self._isOpenSound = false
        self._isOpenMusic = false
    end
end

--------------------------------
-- 是否开启音乐
function SoundMgr:openMusic(isopen)
    self._isOpenMusic = isopen  
    if self._isOpenMusic then
        if not audio.isMusicPlaying() and self._curMusic then
            SoundMgr:playMusic(self._curMusic.id, self._curMusic.isLoop)
        end
        MyUserDefault.setIntegerForKey(user_default_keys.OPEN_MUSIC, 1)
    else
        SoundMgr:stopMusic()
        MyUserDefault.setIntegerForKey(user_default_keys.OPEN_MUSIC, 2)
    end
end

--------------------------------
-- 是否开启音效
function SoundMgr:openSound(isopen)
    self._isOpenSound = isopen
    if self._isOpenSound then
        audio.setSoundsVolume(1)
        MyUserDefault.setIntegerForKey(user_default_keys.SOUND_VOLUME, 1)
        MyUserDefault.setIntegerForKey(user_default_keys.OPEN_SOUND, 1)
    else
        audio.setSoundsVolume(0)
        MyUserDefault.setIntegerForKey(user_default_keys.SOUND_VOLUME, 2)
        MyUserDefault.setIntegerForKey(user_default_keys.OPEN_SOUND, 2)
    end
end

--------------------------------
-- 音乐音量
function SoundMgr:setMusicVolume(volume)
    if self._musicVolume ~= volume then
        self._musicVolume = volume
        audio.setMusicVolume(volume)
        MyUserDefault.setIntegerForKey(user_default_keys.MUSIC_VOLUME, volume)
    end
end

--------------------------------
-- 音效音量
function SoundMgr:setSoundVolume(volume)
    if self._soundVolume ~= volume then
        self._soundVolume = volume
        audio.setSoundsVolume(volume)
        MyUserDefault.setIntegerForKey(user_default_keys.SOUND_VOLUME, volume)
    end
end

--------------------------------
-- 播放音乐（背景音乐）
function SoundMgr:playMusic(id, isLoop)
    if self._curMusic and self._curMusic.id == id and audio.isMusicPlaying() then
        return
    else
        self._curMusic = {id = id, isLoop = isLoop}
    end  

    if self._isOpenMusic then
        local url = "res/audio/"..id..".mp3"
        audio.playMusic(url,isLoop)
    end
end

--------------------------------
-- 停止音乐
function SoundMgr:stopMusic()
    audio.stopMusic()
end

--------------------------------
-- 暂停音乐
function SoundMgr:pauseMusic()
    if self._isOpenMusic==true then
        audio.pauseMusic()
    end
end

--------------------------------
--恢复暂停音乐
function SoundMgr:resumeMusic()

    if self._isOpenMusic==true then
        audio.resumeMusic()
    end
end

--------------------------------
-- 播放音效
function SoundMgr:playSound(id, isLoop)
    if self._isOpenSound then
        local url = "res/audio/"..id..".mp3"
        self[id..""] = audio.playSound(url,isLoop)
    end   
end

--------------------------------
-- 停止音效
function SoundMgr:stopSound(id)
    if self[id..""] then
        audio.stopSound(self[id..""])
        self[id..""] = nil
    end
end

--------------------------------
-- 暂停音效
function SoundMgr:pauseSound(id)
    if self[id..""] then
        audio.pauseSound(self[id..""])
    end 
end

--=======================================================================================背景
---登陆背景音乐
function SoundMgr:playLoginMusic()
    self:playMusic("bg_login",true)
end
---主城背景音乐
function SoundMgr:playMainMusic()
    self:playMusic("bg_zhuchengbeijingyinyue",true)
end
---战斗背景音乐
function SoundMgr:playFightMusic()
    self:playMusic("bg_zhandoubeijingyinyue",true)
end
---新手战斗音乐|boss关卡音乐
function SoundMgr:playFightHardMusic()
    self:playMusic("bg_zhandou_hard",true)
end

--=======================================================================================UI
---胜利
function SoundMgr:playFightSuccess()
    self:playMusic("ui_guanqiashengli",false)
end
---失败
function SoundMgr:playFightFailture()
    self:playMusic("ui_guanqiashibai",false)
end
---升级
function SoundMgr:playRoleLevelUp()
    self:playMusic("ui_shengji",false)
end
---数码进化
function SoundMgr:playShuMaShouJinHua()
    self:playMusic("ui_shumajinhua",false)
end
---获得物品
function SoundMgr:playGetGood()
    self:playSound("ui_huodewuping",false)
end
---强化
function SoundMgr:playQianghua()
    self:playSound("ui_qianghua",false)
end
---抽奖
function SoundMgr:playChoujiang()
    self:playCoolSound("ui_choujiang",1)
end
---探险1
function SoundMgr:playTanxian()
    local r = math.random(0,1)
    local url 
    if r > 0.5 then
        url = "ui_tangxian_1"
    else
        url = "ui_tangxian_2"
    end
    self:playSound(url, false)
end

--=======================================================================================战斗
---战斗准备
function SoundMgr:playFightPrepare()
    self:playSound("fight_zhunbei",false)
end

function SoundMgr:playNpcSpeak(name)
    self:playSound(name,false)
end

--=======================================================================================界面语音
---界面语音
function SoundMgr:playCoolSound(name, time)
    if self.coolTime > 0 then
        return
    end
    if self.viewSound then
        self:stopSound(self.viewSound)
    end
    self:playSound(name,false)
    self.viewSound = name
    self.coolTime = time or 1
end
---vip
function SoundMgr:playViewVip()
    self:playCoolSound("view_vip")
end
---暴龙机
function SoundMgr:playViewBLJ()
    self:playSound("view_baolongji", false)
end
---充值
function SoundMgr:playViewCZ()
    self:playCoolSound("view_chongzhi")
end
---每日登陆
function SoundMgr:playViewDL()
    self:playCoolSound("view_denglu")
end
---好友
function SoundMgr:playViewHY()
    self:playCoolSound("view_haoyou")
end
---合成
function SoundMgr:playViewHC()
    self:playCoolSound("view_hecheng")
end
---任务
function SoundMgr:playViewRW()
    self:playCoolSound("view_renwu")
end
---探险
function SoundMgr:playViewTX()
    self:playCoolSound("view_tanxian")
end
---战役
function SoundMgr:playViewZY()
    self:playCoolSound("view_zhanyi")
end
---队形
function SoundMgr:playViewDuiXing()
    self:playCoolSound("view_duixing")
end
---强化
function SoundMgr:playViewQianghua()
    self:playCoolSound("view_qianghua")
end
---竞技场
function SoundMgr:playViewJJC()
    self:playCoolSound("view_jingjichang")
end
---无尽深渊
function SoundMgr:playViewShenYuan()
    self:playCoolSound("view_shenyuan")
end
--招财
function SoundMgr:playViewZhaoCai()
    self:playSound("view_zaocai", false)
end
--成就
function SoundMgr:playViewChengjiu()
    self:playCoolSound("view_chengjiu")
end
--道具商店
function SoundMgr:playViewDaojushangdian()
    self:playCoolSound("view_daojushangdian")
end
--公会
function SoundMgr:playViewGonghui()
    self:playCoolSound("view_gonghui")
end
--公会Pvp
function SoundMgr:playViewGonghuiPvp()
    self:playCoolSound("view_gonghui_pvp")
end
--公会副本
function SoundMgr:playViewGonghuiFuben()
    self:playCoolSound("view_gonghuifuben")
end
--公会科技
function SoundMgr:playViewGonghuiKeji()
    self:playCoolSound("view_gonghuikeji")
end
--公会商店
function SoundMgr:playViewGonghuiShangdian()
    self:playCoolSound("view_gonghuishangdian")
end
--公会研发
function SoundMgr:playViewGonghuiYanfa()
    self:playCoolSound("view_gonghuiyanfa")
end
--神秘商店
function SoundMgr:playViewShenmishangdian()
    self:playCoolSound("view_shenmishangdian")
end
--驯兽师大赛
function SoundMgr:playViewXunshoushidasai()
    self:playCoolSound("view_xunshoushidasai")
end
--驯兽师之王
function SoundMgr:playViewXunshoushizhiwang()
    self:playCoolSound("view_xunshoushizhiwang")
end
--招财说话
function SoundMgr:playViewZhaocaiShuohua()
    self:playCoolSound("view_zhaocai_shuohua")
end

return SoundMgr