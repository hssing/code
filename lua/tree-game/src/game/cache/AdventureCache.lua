--[[--
探险
]]
local AdventureCache = class("AdventureCache",base.BaseCache)

function AdventureCache:init()
	-- body
	self.bossId = 0 --bossId
	self.txCount = 0 --boss当前血量
	self.lastCount = 0 --剩余探险次数(可探险次数)
	self.isCrit = 0 --是否暴击
	self.items ={} -- 探险获得的物品
	self.lastTime = 120 --下一次恢复回复倒计时
	self._recordTime = 0 -- 受到信息的本地时间
	self.exp = 0 
	self.money_jb = 0
	self.countTime = 0 --每次回复时间
	self.canBuyCount = 0 --探险可购买次数
	self.maxBuyCount = 0 -- 探险最大购买次数
end

function AdventureCache:KeepBossinfo( data_ )
	-- body
	self:_setbossId(data_.bossId)
	self:_setBossCurrHP(data_.txCount)
	self:_setLastTime(data_.lastTime)
	self._recordTime = os.time()
	if data_.lastCount then 
		self:setlastCount(data_.lastCount)
	end
	self:_setCountTime(data_.countTime)
	self:_setCanBuyCount(data_.canBuyCount)
end

function AdventureCache:Refreshinfo( data_ )
	-- body
	self:_setbossId(data_.bossId)
	self:_setBossCurrHP(data_.txCount)
	self:setlastCount(data_.lastCount)
	self:_setisCrit(data_.isCrit)
	self:_setItems(data_.items)
	self:_setExp(data_.exp)
	self:_setJb(data_.money_jb)
end
--最大购买次数
function AdventureCache:setmaxBuyCount( value )
	-- body
	self.maxBuyCount = value
end

function AdventureCache:getmaxBuyCount()
	-- body
	return self.maxBuyCount
end

--探险可购买次数
function AdventureCache:_setCanBuyCount( value )
	-- body
	self.canBuyCount = value/120
end

function AdventureCache:getCanBuyCount()
	-- body
	return self.canBuyCount
end

----每次回复时间
function AdventureCache:_setCountTime( value )
	-- body
	self.countTime = value 
end

function AdventureCache:getCountTime(  )
	-- body
	return self.countTime
end


----获得经验
function AdventureCache:_setExp( value)
	-- body
	self.exp = value
end

function AdventureCache:getExp( )
	-- body
	return self.exp
end
--获得金币
function AdventureCache:_setJb(value )
	-- body
	self.money_jb = value
end
function AdventureCache:getjB( )
	-- body
	return self.money_jb
end

function AdventureCache:getbossId()
	-- body
	return self.bossId
end
--刷新时间 
function AdventureCache:getLastTime()
	-- body
	return self.lastTime 
end
--收到消息的时间
function AdventureCache:getRecordtime(  )
	-- body
	return self._recordTime
end

--当前血量
function AdventureCache:getBossCurrHP(  )
	-- body
	return self.txCount
end
--剩余次数
function AdventureCache:getlastCount(  )
	-- body
	return self.lastCount
end
--是否暴击
function AdventureCache:getisCrit(  )
	-- body
	return self.isCrit
end
--获得列表
function AdventureCache:getItems()
	-- body
	return self.items
end

-------
function AdventureCache:_setLastTime(value)

	self.lastTime = value 
end

function AdventureCache:_setbossId( id )
	-- body
	self.bossId = id 
end

function AdventureCache:_setBossCurrHP( value )
	-- body
	self.txCount = value
end


function AdventureCache:_setrecordTime()
	-- body
	self._recordTime = os.time() 
end

function AdventureCache:setlastCount( value )
	-- body
	
	self.lastCount = value
end

function AdventureCache:_setisCrit( value )
	-- body
	self.isCrit = value
end

function AdventureCache:_setItems( value )
	-- body
	self.items = value 
end


return AdventureCache