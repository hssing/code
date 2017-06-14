--[[--
  玩家缓存数据
]]
local PlayerCache = class("PlayerCache",base.BaseCache)

function PlayerCache:init(  )
		--
		self._reTili = nil 
		self._reAdv = nil
		self._rearean = nil

		self.loginSign = nil --登陆令牌
		self.auth = nil 
		self.versionid = nil 
		self.DataInfo={}
		self.ListProperty={}
		--人物经验
		self.ListProperty[property_index.EXP]=self._setRoleExp
		--体力
		--战力
		self.ListProperty[property_index.POWER]=self._setPower
		--等级
		self.ListProperty[property_index.LV]=self._setRoleLevel
        --vip
		self.ListProperty[property_index.VIPLV]=self._setVip
		--充值
		self.ListProperty[property_index.FIRST]=self._setFirt 
		--vipexp
		self.ListProperty[property_index.VIPEXP]=self._setVIPEXP

		--每日可购买探险
		self.ListProperty[property_index.VIP_BUY_ADVENT]=self._setAdventBuy
		--当前探险次数
		self.ListProperty[property_index.ADVENT_COUNT]=self._setAdventCount
		--最大探险
		self.ListProperty[property_index.ADVENT_MAXCOUNT]=self._setAdventMaxCount
		--回复间隔
		self.ListProperty[property_index.ADVENT_TIMES_RESET]=self._setAdventresetTime
		--下一次探险时间(秒)
		self.ListProperty[property_index.ADVENT_TIMES]=self._setAdventTime
		
		--竞技场挑战上限
		self.ListProperty[property_index.ATHLETICS_MAX] = self._setAthleticsMax
		--竞技场挑战cishu
		self.ListProperty[property_index.ATHLETICS_COUT] = self._setAthleticsCout
		--竞技场回复次数时间间隔
		self.ListProperty[property_index.ATHLETICS_TIMES_RESET] = self._setAthleticsTimerest
		--下一次竞技场恢复剩余
		self.ListProperty[property_index.ATHLETICS_TIMES_LAST] = self._setAthleticsLastTime


		self.ListProperty[property_index.TILI] = self._setTli --当前体力
		self.ListProperty[property_index.MAX_TILI] = self._setMaxtli--最大体力
		self.ListProperty[property_index.TILI_TIMES] = self._setTiliTimes--下一次体力恢复剩余

		self.ListProperty[property_index.TILI_TIMES_RESET] = self._setTiliTimesReset--体力每次回复时间
		self.ListProperty[property_index.TILI_BUY] = self._setTliBuy --当前体力
		--主界面红点提示
		self.ListProperty[property_index.REAND_YOUJIAN] = self._setYJnumber --未读邮件数
		self.ListProperty[property_index.REAND_QIAODAO] = self._setQDnumber --是否已经签到
		self.ListProperty[property_index.REAND_VIPLIBAO] = self._setVIPLBnumber --VIP可购买礼包数
		self.ListProperty[property_index.REAND_TASK] = self._setRWnumber --未领取的任务
		self.ListProperty[property_index.REAND_ACHI] = self._setCJnumber --未领取的成就
		self.ListProperty[property_index.REAND_ZHAOCAI] = self._setZCnumber --当前招财次数
		self.ListProperty[property_index.REAND_CHIJI] = self._setChiJnumber --是否可以吃鸡


		self.ListProperty[property_index.REAND_HAOYOUTL] = self._setHaoYNumber --领取好友体力点数
		self.ListProperty[property_index.REAND_GONGHUILJ] = self._setGongHJLNumber --公会可以研发或者可以领取奖励
		self.ListProperty[property_index.REAND_GONGHUIFUBENJL] = self._setGongHFuBJLNumber --公会副本有奖励
		self.ListProperty[property_index.REAND_GONGHUITONGGUOJL] = self._setGongHTongGJLNumber --公会通过奖励
		self.ListProperty[property_index.REAND_DENGJIJL] = self._setDengJJLNumber --等级奖励
		self.ListProperty[property_index.REAND_SHENHE] = self._setShenHeNumber --入会申请
		self.ListProperty[property_index.REAND_TOWER] = self.setTowerNumber --爬塔

		self.ListProperty[property_index.REAND_DANCHONG] = self._setDanCNumber  --首充
		self.ListProperty[property_index.REAND_LEICHONG] = self._setLeiCNumber --累充
		self.ListProperty[property_index.REAND_MEIRICHONGZHI] = self._setMeiRiNumber --每日充值

		self.ListProperty[property_index.REAND_XUNSHOUWANG] = self._setWangNumber  --驯兽师王
		self.ListProperty[property_index.REAND_XUNSHOUWANGSET] = self._setWangSetNumber  -- 驯兽师设置
		self.ListProperty[property_index.REAND_XUNSHOUBAOMING] = self._setBaoMingNumber  --驯兽蔽塞
		self.ListProperty[property_index.REAND_DIG] = self._setDigNumber

		self.ListProperty[property_index.REAND_DOUBLE_RECHARGE] = self._setDoubleRecharge --首次充值

		self.ListProperty[property_index.REAND_11_REAND] = self._set11Redpoint --双11 红点
		self.ListProperty[property_index.REAND_11_OPEN] = self._set11OpenFunc --双11 开关

		self.ListProperty[property_index.SEVER_TIME] = self.setSeverTime --服务时间
		self.ListProperty[property_index.REAND_DIG_FUCHOU] = self._setDigFuchou -- 挖矿复仇

		self.ListProperty[property_index.REAND_CAMP] = self._setCamp -- 阵营战
		self.ListProperty[property_index.RICHRANK] = self._setRichRank -- 主界面全民土豪、进化神殿、砸蛋入口
		self.ListProperty[property_index.RICHRANKNUM] = self._setRichRankNumber -- 主界面全民土豪、进化神殿、砸蛋入口
		self.ListProperty[property_index.OPEN_ACT_PRAISE] = self._setOpenActPraiseNumber -- 开服活动点赞红点
		
		self.ListProperty[property_index.REAND_DAYFUBEN] = self._setDayFubenNumber -- 日常副本红点
			
		self.ListProperty[property_index.READND_MONTH_ACIVE] = self._setMonthactiveNumber -- 月卡活动
		self.ListProperty[property_index.REAND_DAYFUBEN] = self._setMonthCard -- 月卡购买
		self.ListProperty[property_index.REAND_DAYFUBEN] = self._setMonthAllCard -- 终生卡
		self.ListProperty[property_index.READND_MONTH_SHOW] = self._setMonth-- 

		self.ListProperty[property_index.READND_TTHL_REDP] = self._setTthlRedpoint --天天豪礼红点
		self.ListProperty[property_index.READND_XFHL_REDP] = self._setXfhlRedpoint --消费豪礼红点

		self.ListProperty[property_index.READND_CROSS_COUNT] = self._setCrossRedpoint --跨服战红点
		self.ListProperty[property_index.FRUIT_COMPOSE] = self._setFruitRedpoint --果实合成

		self.ListProperty[property_index.REAND_100] = self._set100--7星充值100元
		self.ListProperty[property_index.REAND_100_limit] = self._set100_limite--7星充值100元
		self.ListProperty[property_index.REAND_100_limit_3010] = self._set100_limite_3010--7星充值100元

		self.ListProperty[property_index.REAND_BOSS] = self._setBoss--世界boss
		self.ListProperty[property_index.REAND_TASK_GET] = self._setGetTaskHy --任务活跃度
		self.ListProperty[property_index.MAX_CHAPTER_ID] = self._setMaxChapterId --已通关最公会大副本ID

		self.ListProperty[property_index.NEWBAG_REAND] = self._setRednewBag --福袋
		self.ListProperty[property_index.NEWRED] = self._setNewRed --登录红包

		self.gonggao = ""	
end

function PlayerCache:_setNewRed( value )
	if self.DataInfo.Property[property_index.NEWRED] == nil then 
		self.DataInfo.Property[property_index.NEWRED] = {} 
	end
	self.DataInfo.Property[property_index.NEWRED].value = value
end

function PlayerCache:getNewRed( )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.NEWRED] then 
		return self.DataInfo.Property[property_index.NEWRED].value
	end 
	return 0
end

function PlayerCache:_setRednewBag( value )
	if self.DataInfo.Property[property_index.NEWBAG_REAND] == nil then 
		self.DataInfo.Property[property_index.NEWBAG_REAND] = {} 
	end
	self.DataInfo.Property[property_index.NEWBAG_REAND].value = value
end

function PlayerCache:getRednewBag( )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.NEWBAG_REAND] then 
		return self.DataInfo.Property[property_index.NEWBAG_REAND].value
	end 
	return 0
end

function PlayerCache:_setMaxChapterId( value )
	if self.DataInfo.Property[property_index.MAX_CHAPTER_ID] == nil then 
		self.DataInfo.Property[property_index.MAX_CHAPTER_ID] = {} 
	end
	self.DataInfo.Property[property_index.MAX_CHAPTER_ID].value = value
end

function PlayerCache:getMaxChapterId( )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.MAX_CHAPTER_ID] then 
		return self.DataInfo.Property[property_index.MAX_CHAPTER_ID].value
	end 
	return 0
end



function PlayerCache:_setGetTaskHy(value)
	-- body
	if self.DataInfo.Property[property_index.REAND_TASK_GET] == nil then 
		self.DataInfo.Property[property_index.REAND_TASK_GET] = {} 
	end
	self.DataInfo.Property[property_index.REAND_TASK_GET].value = value
end

function PlayerCache:getGetTaskHy()
	-- body
		if self.DataInfo.Property and  self.DataInfo.Property[property_index.REAND_TASK_GET] then 
		return self.DataInfo.Property[property_index.REAND_TASK_GET].value
	end 
	return 0
end

--7星充值100元 限时
function PlayerCache:_setBoss( value )
	if self.DataInfo.Property[property_index.REAND_BOSS] == nil then 
		self.DataInfo.Property[property_index.REAND_BOSS] = {} 
	end
	self.DataInfo.Property[property_index.REAND_BOSS].value = value
end	

function PlayerCache:getBoss()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.REAND_BOSS] then 
		return self.DataInfo.Property[property_index.REAND_BOSS].value
	end 
	return 0
end	

--7星充值100元 限时
function PlayerCache:_set100_limite_3010( value )
	if self.DataInfo.Property[property_index.REAND_100_limit_3010] == nil then 
		self.DataInfo.Property[property_index.REAND_100_limit_3010] = {} 
	end
	self.DataInfo.Property[property_index.REAND_100_limit_3010].value = value
end	

function PlayerCache:get100_limite_3010()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.REAND_100_limit_3010] then 
		return self.DataInfo.Property[property_index.REAND_100_limit_3010].value
	end 
	return 0
end	

--7星充值100元 限时
function PlayerCache:_set100_limite( value )
	if self.DataInfo.Property[property_index.REAND_100_limit] == nil then 
		self.DataInfo.Property[property_index.REAND_100_limit] = {} 
	end
	self.DataInfo.Property[property_index.REAND_100_limit].value = value
end	

function PlayerCache:get100_limite()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.REAND_100_limit] then 
		return self.DataInfo.Property[property_index.REAND_100_limit].value
	end 
	return 0
end	

--7星充值100元
function PlayerCache:_set100( value )
	if self.DataInfo.Property[property_index.REAND_100] == nil then 
		self.DataInfo.Property[property_index.REAND_100] = {} 
	end
	self.DataInfo.Property[property_index.REAND_100].value = value
end	

function PlayerCache:get100()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.REAND_100] then 
		return self.DataInfo.Property[property_index.REAND_100].value
	end 
	return 0
end	


--跨服战排位次数
function PlayerCache:_setCrossRedpoint( value )
	if self.DataInfo.Property[property_index.READND_CROSS_COUNT] == nil then 
		self.DataInfo.Property[property_index.READND_CROSS_COUNT] = {} 
	end
	self.DataInfo.Property[property_index.READND_CROSS_COUNT].value = value
end	

function PlayerCache:getCrossRedpoint()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.READND_CROSS_COUNT] then 
		return self.DataInfo.Property[property_index.READND_CROSS_COUNT].value
	end 
	return 0
end	
--消费豪礼红点
function PlayerCache:_setTthlRedpoint( value )
	if self.DataInfo.Property[property_index.READND_TTHL_REDP] == nil then 
		self.DataInfo.Property[property_index.READND_TTHL_REDP] = {} 
	end
	self.DataInfo.Property[property_index.READND_TTHL_REDP].value = value
end	

function PlayerCache:getTthlRedpoint()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.READND_TTHL_REDP] then 
		return self.DataInfo.Property[property_index.READND_TTHL_REDP].value
	end 
	return 0
end	

function PlayerCache:_setXfhlRedpoint( value )
	if self.DataInfo.Property[property_index.READND_XFHL_REDP] == nil then 
		self.DataInfo.Property[property_index.READND_XFHL_REDP] = {} 
	end
	self.DataInfo.Property[property_index.READND_XFHL_REDP].value = value
end

function PlayerCache:getXfhlRedpoint()
	if self.DataInfo.Property and  self.DataInfo.Property[property_index.READND_XFHL_REDP] then 
		return self.DataInfo.Property[property_index.READND_XFHL_REDP].value
	end 
	return 0
end

--果实合成红点
function PlayerCache:_setFruitRedpoint( value )
	-- body
	if self.DataInfo.Property[40801] == nil then self.DataInfo.Property[40801] = {} end
		self.DataInfo.Property[40801].value = value
end

function PlayerCache:getFruitRedpoint( )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40801] then 
		return self.DataInfo.Property[40801].value
	end 
	return 0
end




function PlayerCache:_setMonth( value )
	-- body
	if self.DataInfo.Property[40731] == nil then self.DataInfo.Property[40731] = {} end
		self.DataInfo.Property[40731].value = value
end

function PlayerCache:getMonth( )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40731] then 
		return self.DataInfo.Property[40731].value
	end 
	return 0
end

--月卡活动 红点
function PlayerCache:_setMonthactiveNumber( value )
	-- body
	if self.DataInfo.Property[40730] == nil then self.DataInfo.Property[40730] = {} end
		self.DataInfo.Property[40730].value = value
end

function PlayerCache:getMonthactiveNumber(  )

	if self.DataInfo.Property and  self.DataInfo.Property[40730] then 
		return self.DataInfo.Property[40730].value
	end 
	return 0
end

--月卡购买 红点
function PlayerCache:_setMonthCard( value )
	-- body
	if self.DataInfo.Property[40728] == nil then self.DataInfo.Property[40728] = {} end
		self.DataInfo.Property[40728].value = value
end

function PlayerCache:getMonthCard(  )

	if self.DataInfo.Property and  self.DataInfo.Property[40728] then 
		return self.DataInfo.Property[40728].value
	end 
	return 0
end

--终生卡 红点
function PlayerCache:_setMonthAllCard( value )
	-- body
	if self.DataInfo.Property[40729] == nil then self.DataInfo.Property[40729] = {} end
		self.DataInfo.Property[40729].value = value
end

function PlayerCache:getMonthAllCard(  )

	if self.DataInfo.Property and  self.DataInfo.Property[40729] then 
		return self.DataInfo.Property[40729].value
	end 
	return 0
end


--豪礼大放送 红点
function PlayerCache:_setDayFubenNumber( value )
	-- body
	if self.DataInfo.Property[40727] == nil then self.DataInfo.Property[40727] = {} end
		self.DataInfo.Property[40727].value = value
end

function PlayerCache:getDayFubenNumber(  )

	if self.DataInfo.Property and  self.DataInfo.Property[40727] then 
		return self.DataInfo.Property[40727].value
	end 
	return 0
end

--豪礼大放送 红点
function PlayerCache:_setOpenActPraiseNumber( value )
	-- body
	if self.DataInfo.Property[40726] == nil then self.DataInfo.Property[40726] = {} end
		self.DataInfo.Property[40726].value = value
end

function PlayerCache:getOpenActPraiseNumber(  )

	if self.DataInfo.Property and  self.DataInfo.Property[40726] then 
		return self.DataInfo.Property[40726].value
	end 
	return 0
end




--豪礼大放送 红点
function PlayerCache:_setRichRankNumber( value )
	-- body
	if self.DataInfo.Property[40725] == nil then self.DataInfo.Property[40725] = {} end
		self.DataInfo.Property[40725].value = value
end

function PlayerCache:getRichRankNumber(  )

	if self.DataInfo.Property and  self.DataInfo.Property[40725] then 
		return self.DataInfo.Property[40725].value
	end 
	return 0
end


----豪礼大放送入口开关
function PlayerCache:_setRichRank( value )
	-- body
	if self.DataInfo.Property[40724] == nil then self.DataInfo.Property[40724] = {} end
		self.DataInfo.Property[40724].value = value
end

function PlayerCache:getRichRank(  )
		if self.DataInfo.Property and  self.DataInfo.Property[40724] then 
		return self.DataInfo.Property[40724].value
	end 
	return 0
end


--阵营战
function PlayerCache:_setCamp( value )
	-- body
	if self.DataInfo.Property[40723] == nil then self.DataInfo.Property[40723] = {} end
		self.DataInfo.Property[40723].value = value
end

function PlayerCache:getCamp()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40723] then 
		return self.DataInfo.Property[40723].value
	end 
	return 0
end
--挖矿复仇
function PlayerCache:_setDigFuchou( value )
	-- body
	if self.DataInfo.Property[40722] == nil then self.DataInfo.Property[40722] = {} end
		self.DataInfo.Property[40722].value = value
end

function PlayerCache:getDigFuchou()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40722] then 
		return self.DataInfo.Property[40722].value
	end 
	return 0
end
--服务时
function PlayerCache:setSeverTime( value )
	-- body
	if self.DataInfo.Property[40203] == nil then self.DataInfo.Property[40203] = {} end
		self.DataInfo.Property[40203].value = value
end

function PlayerCache:getSeverTime()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40203] then 
		return self.DataInfo.Property[40203].value
	end 
	return 0
end
--双11
function PlayerCache:_set11Redpoint(value)
	-- body
	if self.DataInfo.Property[40720] == nil then self.DataInfo.Property[40720] = {} end
		self.DataInfo.Property[40720].value = value
end

function PlayerCache:get11Redpoint()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40720] then 
		return self.DataInfo.Property[40720].value
	end 
	return 0
end

function PlayerCache:_set11OpenFunc(value)
	-- body
	if self.DataInfo.Property[40721] == nil then self.DataInfo.Property[40721] = {} end
		self.DataInfo.Property[40721].value = value
end

function PlayerCache:get11OpenFunc()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40721] then 
		return self.DataInfo.Property[40721].value
	end 
	return 0
end
---------------------
function PlayerCache:keepGongGao(data )
	-- body
	self.gonggao = data
end

function PlayerCache:getGongGao()
	-- body
	return self.gonggao
end


function PlayerCache:_setDoubleRecharge(value)
	-- body
	if self.DataInfo.Property[40718] == nil then self.DataInfo.Property[40718] = {} end
		self.DataInfo.Property[40718].value = value
end

function PlayerCache:getDoubleRecharge()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40718] then 
		return self.DataInfo.Property[40718].value
	end 
	return 0
end

--点赞
function PlayerCache:_setWangNumber( value )
	-- body
	if self.DataInfo.Property[40715] == nil then self.DataInfo.Property[40715] = {} end
		self.DataInfo.Property[40715].value = value
end

function PlayerCache:getWangNumber( ... )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40715] then 
		return self.DataInfo.Property[40715].value
	end 
	return 0
end

--驯兽师设置
function PlayerCache:_setWangSetNumber( value )
	-- body
	if self.DataInfo.Property[40716] == nil then self.DataInfo.Property[40716] = {} end
		self.DataInfo.Property[40716].value = value
end

function PlayerCache:getWangSetNumber( ... )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40716] then 
		return self.DataInfo.Property[40716].value
	end 
	return 0
end

--挖矿设置
function PlayerCache:_setDigNumber( value )
	-- body
	if self.DataInfo.Property[40719] == nil then self.DataInfo.Property[40719] = {} end
		self.DataInfo.Property[40719].value = value
end

function PlayerCache:getDigNumber()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40719] then 
		return self.DataInfo.Property[40719].value
	end 
	return 0
end

--驯兽师大赛 报名
function PlayerCache:_setBaoMingNumber( value )
	-- body
	if self.DataInfo.Property[40717] == nil then self.DataInfo.Property[40717] = {} end
		self.DataInfo.Property[40717].value = value
end

function PlayerCache:getBaoMingNumber( ... )
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40717] then 
		return self.DataInfo.Property[40717].value
	end 
	return 0
end



--单笔充值
function PlayerCache:_setDanCNumber( value )
	if self.DataInfo.Property[40713] == nil then self.DataInfo.Property[40713] = {} end
		self.DataInfo.Property[40713].value = value
end

function PlayerCache:getDanCNumber(  )
	if self.DataInfo.Property and  self.DataInfo.Property[40713] then 
		return self.DataInfo.Property[40713].value
	end 
	return 0
end



--累充
function PlayerCache:_setLeiCNumber( value )
	if self.DataInfo.Property[40714] == nil then self.DataInfo.Property[40714] = {} end
		self.DataInfo.Property[40714].value = value
end

function PlayerCache:getLeiCNumber(  )
	if self.DataInfo.Property and  self.DataInfo.Property[40714] then 
		return self.DataInfo.Property[40714].value
	end 
	return 0
end


--每日充值
function PlayerCache:_setMeiRiNumber( value )
	if self.DataInfo.Property[40712] == nil then self.DataInfo.Property[40712] = {} end
		self.DataInfo.Property[40712].value = value
end

function PlayerCache:getMeiRiNumber(  )
	if self.DataInfo.Property and  self.DataInfo.Property[40712] then 
		return self.DataInfo.Property[40712].value
	end 
	return 0
end



function PlayerCache:setTowerNumber(value)
		if self.DataInfo.Property[40711] == nil then self.DataInfo.Property[40711] = {} end
		self.DataInfo.Property[40711].value = value
end
function PlayerCache:getTowerNumber()
		if self.DataInfo.Property and  self.DataInfo.Property[40711] then 
				return self.DataInfo.Property[40711].value
		end 
		return 0
end

function PlayerCache:_setShenHeNumber(value )
	-- body
	if self.DataInfo.Property[40710] == nil then self.DataInfo.Property[40710] = {} end
	self.DataInfo.Property[40710].value = value
end

function PlayerCache:getShenHeNumber()
	-- body
	if self.DataInfo.Property and  self.DataInfo.Property[40710] then 
		return self.DataInfo.Property[40710].value
	end 
	return 0
end


--好友体力
function PlayerCache:_setHaoYNumber( value )
	-- body
	if self.DataInfo.Property[40705] == nil then self.DataInfo.Property[40705] = {} end
	self.DataInfo.Property[40705].value = value
end

function PlayerCache:getHaoYNumber(  )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40705] then 
		return self.DataInfo.Property[40705].value
	end 
	return 0
end


--公会可以研发或者可以领取奖励
function PlayerCache:_setGongHJLNumber( value )
	-- body
	if self.DataInfo.Property[40706] == nil then self.DataInfo.Property[40706] = {} end
	self.DataInfo.Property[40706].value = value
end

function PlayerCache:getGongHJLNumber(  )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40706] then 
		return self.DataInfo.Property[40706].value
	end 
	return 0
end

--公会副本有奖励
function PlayerCache:_setGongHFuBJLNumber( value )
	-- body
	if self.DataInfo.Property[40707] == nil then self.DataInfo.Property[40707] = {} end
	self.DataInfo.Property[40707].value = value
end

function PlayerCache:getGongHFuBJLNumber(  )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40707] then 
		return self.DataInfo.Property[40707].value
	end 
	return 0
end


--公会通过奖励
function PlayerCache:_setGongHTongGJLNumber( value )
	-- body
	if self.DataInfo.Property[40708] == nil then self.DataInfo.Property[40708] = {} end
	self.DataInfo.Property[40708].value = value
end

function PlayerCache:getGongHTongGJLNumber(  )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40708] then 
		return self.DataInfo.Property[40708].value
	end 
	return 0
end


--等级奖励
function PlayerCache:_setDengJJLNumber( value )
	-- body
	if self.DataInfo.Property[40709] == nil then self.DataInfo.Property[40709] = {} end
	self.DataInfo.Property[40709].value = value
end

function PlayerCache:getDengJJLNumber(  )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40709] then 
		return self.DataInfo.Property[40709].value
	end 
	return 0
end



---聊天
function PlayerCache:_setChatNumber( value )
	-- body
	self.chatNumber = value
	local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if view then
		--todo
		view:setChatNumber(value)
	end
end

function PlayerCache:getChatNumber(  )
	if self.chatNumber == nil then
		--todo
		return 0
	end
	return self.chatNumber
end


--邮件
function PlayerCache:_setYJnumber( value )
	-- body
	if self.DataInfo.Property[40201] == nil then self.DataInfo.Property[40201] = {} end
	self.DataInfo.Property[40201].value = value
end

function PlayerCache:getYJnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40201] then 
		return self.DataInfo.Property[40201].value
	end 
	return 0
end
--签到
function PlayerCache:_setQDnumber( value )
	-- body
	if self.DataInfo.Property[40701] == nil then self.DataInfo.Property[40701] = {} end
	self.DataInfo.Property[40701].value = value
end

function PlayerCache:getQDnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40701] then 
		return self.DataInfo.Property[40701].value
	end 
	return 0
end
--vip礼包个数
function PlayerCache:_setVIPLBnumber( value )
	-- body
	if self.DataInfo.Property[40702] == nil then self.DataInfo.Property[40702] = {} end
	self.DataInfo.Property[40702].value = value
end

function PlayerCache:getVIPLBnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40702] then 
		return self.DataInfo.Property[40702].value
	end 
	return 0
end
--任务
function PlayerCache:_setRWnumber( value )
	-- body
	if self.DataInfo.Property[40703] == nil then self.DataInfo.Property[40703] = {} end
	self.DataInfo.Property[40703].value = value
end

function PlayerCache:getRWnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40703] then 
		return self.DataInfo.Property[40703].value
	end 
	return 0
end
--成就
function PlayerCache:_setCJnumber( value )
	-- body
	if self.DataInfo.Property[40704] == nil then self.DataInfo.Property[40704] = {} end
	self.DataInfo.Property[40704].value = value
end

function PlayerCache:getCJnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40704] then 
		return self.DataInfo.Property[40704].value
	end 
	return 0
end
--招财
function PlayerCache:_setZCnumber( value )
	-- body
	if self.DataInfo.Property[40441] == nil then self.DataInfo.Property[40441] = {} end
	self.DataInfo.Property[40441].value = value
end

function PlayerCache:getZCnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40441] then 
		return self.DataInfo.Property[40441].value
	end 
	return 0
end
--吃鸡
function PlayerCache:_setChiJnumber( value )
	-- body
	if self.DataInfo.Property[40601] == nil then self.DataInfo.Property[40601] = {} end
	self.DataInfo.Property[40601].value = value
end

function PlayerCache:getChiJnumber()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40601] then 
		return self.DataInfo.Property[40601].value
	end 
	return 0
end



-------------------------
--设置属性
--@param index序列号， value数值
function PlayerCache:updateProperty( index,value )
    local fun=self.ListProperty[index]
    if fun  then
    	if not self.DataInfo.Property then self.DataInfo.Property = {} end 
    	if self.DataInfo.Property[index] == nil then self.DataInfo.Property[index] = {} end
        fun(self,value)
    else  --无需更新界面的不用写set函数
        if self.DataInfo.Property[index] == nil then self.DataInfo.Property[index] = {} end
        self.DataInfo.Property[index].value = value
    end
end

---------------------------
--获取属性值
--@param index序列号
function PlayerCache:getProperty(index_)
    local data = self.DataInfo.Property
    if data then
        if data[index_] then
            return data[index_].value
        end
    end
    return 0
end

---------------------------
--更新指定属性的值
function PlayerCache:updateAllProperty(data)
    for k,v in pairs(data) do
        self:updateProperty(k, v.value)
    end
end

---------------------------
--功能开启
function PlayerCache:openFuncData(data_)
    self.unOpenList = {}
    local lvl = data_.roleInfo.roleLevel
    local conf = conf.guide:getOpenFunc()
    for key, value in pairs(conf) do
        if value.level > lvl then
            self.unOpenList[value.win_name] = value
            print("____________________________________未开启功能",value.win_name)
        end
    end
end

--获取登陆令牌
function PlayerCache:getLoginSign() 
	return self.loginSign
end


function PlayerCache:setLoginSign(value)
	-- body
	self.loginSign = value
end

--登录角色信息初始化
function PlayerCache:setRoleInfo(data_)
	--debugprint("找到了对应的位置")
	--self.DataInfo=data_.roleInfo
	if self.DataInfo then
			for key, value in pairs(data_.roleInfo) do
					self.DataInfo[key] = value
			end
	else
			self.DataInfo=data_.roleInfo
	end
	--self.DataInfo.roleIdStr = data_.roleIdStr --玩家Id,字符串形式
	self.DataInfo.Property = vector2table(self.DataInfo.roleProperty,"type")
	--[[if data_.loginSign then 
		
	end ]]--
end

function PlayerCache:_setTliBuy( value )
	-- body
	if self.DataInfo.Property[40321] == nil then self.DataInfo.Property[40321] = {} end
	self.DataInfo.Property[40321].value = value
end

function PlayerCache:getTliBuy()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40321] then 
		return self.DataInfo.Property[40321].value
	end 

	return 0
end
--当前购买次数
function PlayerCache:setBuycount(value)
	-- body
	self.DataInfo.buyCount = value
end

function PlayerCache:getBuycount()
	-- body
	local count = self.DataInfo.buyCount and self.DataInfo.buyCount or 0
	return count
end

function PlayerCache:setreTili()
	-- body
	self._reTili = os.time() --每次回复后也要改变回复时间
end

--当前体力
function PlayerCache:_setTli( value )
	-- body
	--计算接受到体力信息的时间
	
	if self.DataInfo.Property[40411] == nil then self.DataInfo.Property[40411] = {} end
	self.DataInfo.Property[40411].value = value
end
--体力
function PlayerCache:getTili( )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40411] then
		return self.DataInfo.Property[40411].value
	end 
	return 0
end
--最大体力
function PlayerCache:_setMaxtli( value )
	-- body
	if self.DataInfo.Property[40412] == nil then self.DataInfo.Property[40412] = {} end
	self.DataInfo.Property[40412].value = value
end
function PlayerCache:getMaxtli( )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40412] then
		return self.DataInfo.Property[40412].value
	end 
	return 0
end

function PlayerCache:getRecordtime()
	-- body
	return self._reTili
end

function PlayerCache:_setTiliTimes( value )
	-- body
	if self.DataInfo.Property[40413] == nil then self.DataInfo.Property[40413] = {} end
	self.DataInfo.Property[40413].value = value
	

	--self._reTili = os.time()
end

function PlayerCache:_setTiliTimesReset( value )
	-- body
	if self.DataInfo.Property[40337] == nil then self.DataInfo.Property[40337] = {} end
	self.DataInfo.Property[40337].value = value
end

function PlayerCache:getTiliTimesReset()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40337] then 
		return self.DataInfo.Property[40337].value
	end 
	return 0
end

function PlayerCache:getTiliTimes()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40413] then 
		return self.DataInfo.Property[40413].value
	end 
	return 0
end


--当前探险
function PlayerCache:_setAdventCount( value )
	-- body
	if self.DataInfo.Property[40421] == nil then self.DataInfo.Property[40421] = {} end
	self.DataInfo.Property[40421].value = value

	--刷新红点
	local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if view then 
		view:setRedPoint()
	end 
end
--探险上次回复时间
function PlayerCache:getAdvrecordTime()
	-- body
	return self._reAdv
end

function PlayerCache:setAdvrecordTime()
	-- body
	self._reAdv = os.time() --记录上次回复时间
end

function PlayerCache:getAdventCount( )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40421] then
		return self.DataInfo.Property[40421].value
	end
	return 0
end

function PlayerCache:_setAdventresetTime( value )
	-- body
	if self.DataInfo.Property[40335] == nil then self.DataInfo.Property[40335] = {} end
	self.DataInfo.Property[40335].value = value
end

function PlayerCache:getAdventresetTime()
	-- body
	return self.DataInfo.Property[40335].value
end

--最大探险
function PlayerCache:_setAdventMaxCount( value )
	-- body
	if self.DataInfo.Property[40422] == nil then self.DataInfo.Property[40422] = {} end
	self.DataInfo.Property[40422].value = value
end

function PlayerCache:getAdventMaxCount( )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40422] then
		return self.DataInfo.Property[40422].value
	else
		debugprint("最大探险 未发吧")
		return nil
	end
end

--每天可以购买的次数 --  探险
function PlayerCache:_setAdventBuy( value )
	-- body
	if self.DataInfo.Property[40322] == nil then self.DataInfo.Property[40322] = {} end
	self.DataInfo.Property[40322].value = value
end
function PlayerCache:getAdventBuy( )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40322] then
		--todo
		return self.DataInfo.Property[40322].value
	end
	return 0
end
--已经购买的次数
function PlayerCache:setDoneBuy(value )
	-- body
	self.DataInfo.advbuyCount = value
end

function PlayerCache:getDoneBuy(  )
	-- body
	if self.DataInfo.advbuyCount then 
		return self.DataInfo.advbuyCount
	end  
	return 0 
end

--下一次探险时间(秒)
function PlayerCache:_setAdventTime( value )
	-- body
	if self.DataInfo.Property[40423] == nil then self.DataInfo.Property[40423] = {} end
	self.DataInfo.Property[40423].value = value
end

function PlayerCache:getAdventTime( )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40423] then 
		return self.DataInfo.Property[40423].value
	end 
	return 0
end
--竞技上限
function PlayerCache:_setAthleticsMax(value)
    if self.DataInfo.Property[40432] == nil then self.DataInfo.Property[40432] = {} end
    self.DataInfo.Property[40432].value = value
end

function PlayerCache:set_rearean()
	-- body
	 self._rearean=os.time()
end

--竞技次数
function PlayerCache:_setAthleticsCout( value )
 	-- body
 	 if self.DataInfo.Property[40431] == nil then self.DataInfo.Property[40431] = {} end
    self.DataInfo.Property[40431].value = value

   
 end 

 function PlayerCache:getRearean()
 	-- body
 	return self._rearean
 end

 function PlayerCache:getAthleticsCout()
 	-- body
 	if self.DataInfo.Property and self.DataInfo.Property[40431] then 
 		return self.DataInfo.Property[40431].value
 	end 
 	return 0
 end

 --竞技场 回复时间间隔
 function PlayerCache:_setAthleticsTimerest( value )
 	-- body
 	 if self.DataInfo.Property[40336] == nil then self.DataInfo.Property[40336] = {} end
    self.DataInfo.Property[40336].value = value
 end

 function PlayerCache:getAthleticsTimerest()
 	-- body
 	if self.DataInfo.Property and self.DataInfo.Property[40336] then 
 		return self.DataInfo.Property[40336].value
 	end 
 	return 0
 end
--竞技场 下一次回复剩余
function PlayerCache:_setAthleticsLastTime(value)
 	-- body
 	if self.DataInfo.Property[40433] == nil then self.DataInfo.Property[40336] = {} end 
 	self.DataInfo.Property[40433].value = value	
end 

function PlayerCache:getAthleticsLastTime()
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40433] then 
		return self.DataInfo.Property[40433].value
	end 
	return 0
end


--是否首冲 0 不可领取 1 可领取 2 已经领取
function PlayerCache:getFirst40303()
	-- body
	local data = self.DataInfo.Property
	if data then
		if data[40303] then
			return data[40303].value
		end
	end
	return 0
end

function PlayerCache:_setFirt(value)
	-- body
	if self.DataInfo.Property[40303] == nil then self.DataInfo.Property[40303] = {} end
	self.DataInfo.Property[40303].value = value
end

function PlayerCache:getRoleInfo()
	 return self.DataInfo
end

--男女
function PlayerCache:getRoleSex()
	 return self.DataInfo.sex
end
--当前体力
function PlayerCache:getNowTl()
	local data = self.DataInfo.Property
	if data then
		if data[40401] then
			return data[40401].value
		end
	end
	 return 0
end
--当前最大体力
function PlayerCache:getMaxTl()
	local data = self.DataInfo.Property
	if data then
		if data[40402] then
			return data[40402].value
		end
	end
	 return 0
end

function PlayerCache:getNowTxd()
	local data = self.DataInfo.Property
	if data then
		if data[40404] then
			return data[40404].value
		end
	end
	 return 0
end
function PlayerCache:getMaxTxd()
	local data = self.DataInfo.Property
	if data then
		if data[40405] then
			return data[40405].value
		end
	end
	 return 0
end
function PlayerCache:getNowSprite()
	local data = self.DataInfo.Property
	if data then
		if data[40407] then
			return data[40407].value
		end
	end
	 return 0
end
function PlayerCache:getMaxSprite()
	local data = self.DataInfo.Property
	if data then
		if data[40408] then
			return data[40408].value
		end
	end
	 return 0
end

--竞技场挑战上限
function PlayerCache:getMaxAthleticsMax()
    local data = self.DataInfo.Property
    if data then
        if data[40432] then
            return data[40432].value
        end
    end
    return 0
end

--竞技场可购买次数上限
function PlayerCache:getAthleticsBuyTime()
    local data = self.DataInfo.Property
    if data then
        if data[40432] then
            return data[40432].value
        end
    end
    return 0
end



--称号
function PlayerCache:setRoleTitle( value )
	self.DataInfo.titleId = value
end

function PlayerCache:getRoleTitle(  )
	return self.DataInfo.titleId
end

function PlayerCache:setHead( index )
	self.DataInfo.vipIcon=index
end

function PlayerCache:getHead()
	-- body
	return self.DataInfo.vipIcon
end

function PlayerCache:getVip()
	return self.DataInfo.vip
end
function PlayerCache:_setRoleExp( vlaue )
		self.DataInfo.roleExp=vlaue
end
function PlayerCache:_setRoleLevel(  vlaue)
		self.DataInfo.roleLevel=vlaue
end
function PlayerCache:_setPower( vlaue)
		self.DataInfo.power=vlaue
end
function PlayerCache:getPower(  )
	-- body
	return self.DataInfo.power
end

function PlayerCache:_setVip( value )
	self.DataInfo.vip = value
	if self.DataInfo.Property[40301] then 
		self.DataInfo.Property[40301].value = value
	end 
	local __view = mgr.ViewMgr:get(_viewname.SHOP)
	if __view then 
		__view:initRecharge()
	end

	local _view =  mgr.ViewMgr:get(_viewname.ROLE)
	if _view then 
		_view:updateUi()
	end
end

function PlayerCache:_setVIPEXP( value )
	-- body
	if self.DataInfo.Property[40302] == nil then self.DataInfo.Property[40302] = {} end
	self.DataInfo.Property[40302].value = value
	local __view = mgr.ViewMgr:get(_viewname.SHOP)
	if __view then 
		__view:initRecharge()
	end
	
end

function PlayerCache:getVipExp(  )
	-- body
	if self.DataInfo.Property and self.DataInfo.Property[40302] then
		return self.DataInfo.Property[40302].value 
	end 
	return 0

end

function PlayerCache:getRoleId( ... )
	-- body
	return self.DataInfo.roleId
end

--更新指定属性的值
function PlayerCache:getLevel()
	return self.DataInfo.roleLevel
end

--玩家Id, 字符串形式64位数字
function PlayerCache:getRoleIdStr()
	return self.DataInfo.roleIdStr
end

--玩家名称
function PlayerCache:getName()
	return self.DataInfo.roleName
end

function PlayerCache:setPlayerName( value )
	-- body
	self.DataInfo.roleName = value
end

--改变玩家的公会ID 如果ID 为0 则表示这个人不是公会成员了
function PlayerCache:setGuildId(value)
	-- body
	self.DataInfo.guildId = value

end

------返回玩家公会ID
function PlayerCache:getGuildId(  )
	-- body
	return self.DataInfo.guildId
end

function PlayerCache:setguildName( value )
	-- body
	self.DataInfo.guildName = value
end

function PlayerCache:getguildName( ... )
	-- body
	return self.DataInfo.guildName 
end

---------------------------------------修改协议以后

function PlayerCache:setRoleIdStr( value )
	-- body
	self.DataInfo.roleIdStr = value
end
--权限
function PlayerCache:setAuth( value )
	-- body
	self.auth = value 
		
end
function PlayerCache:getAuth( ... )
	-- body
	return self.auth 
end
--版本Id
function PlayerCache:setVersionId( value )
	-- body
	self.versionid = value 
end

function PlayerCache:getVersionId( ... )
	-- body
	return self.versionid
end

function PlayerCache:setInfo( data_ )
	-- body
	self:setLoginSign(data_.loginSign)
	self:setRoleIdStr(data_.roleIdStr)
	self:setAuth(data_.auth)
	self:setVersionId(data_.versionId)
end

----------红包屏蔽信息
function PlayerCache:setShowRedBag( str )
	--判断是否是当天，以及开关状态，默认关闭

	if str and str ~= "" then
	 	local nowDate = os.date("*t",os.time())
		local oldDate = os.date("*t",tonumber(str))
		print("月，日",nowDate.month,nowDate.day,oldDate.month,oldDate.day)
	 	if nowDate.day == oldDate.day and nowDate.month == oldDate.month then--如果是当天
			self.showRedBag = false
		else
			self.showRedBag = true
	 	end
	else
		self.showRedBag = true
	end

end

function PlayerCache:getShowRedbag(  )
	if self.showRedBag == nil then
		self.showRedBag = true
	end

	return self.showRedBag
end

----保存 玩家创号是输入的邀请码，
function PlayerCache:setCode( code )
	self.code = code
end

function PlayerCache:getCode(  )
	return self.code
end


--材料合成跳转使用
function PlayerCache:saveMaterialJumpData( data )
	self.jumpData = data
end

function PlayerCache:getJumpData(  )
	-- body
	return self.jumpData
end







return PlayerCache