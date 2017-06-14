local cache = {}

cache.Player = import(".PlayerCache").new()

cache.Pack   = import(".PackCache").new()
cache.Material   = import(".MaterialCache").new()--材料

cache.Fortune  = import(".FortuneCache").new()

cache.Shop = import(".ShopCache").new()

cache.Lucky = import(".LuckydrawCache").new()

cache.LuckyLottery = import(".LuckyLotteryCache").new()

cache.Copy = import(".CopyCache").new()

cache.Fight = import(".FightCache").new()


cache.Mail = import(".MailCache").new()

cache.Equipment = import(".EquipmentCache").new()

cache.Adventure = import(".AdventureCache").new()--探险

cache.Taskinfo = import(".TaskinfoCache").new()--成就 和 探险

cache.Zhaocai = import(".ZhaocaiCache").new()--招财

cache.Guild = import(".GulildCache").new()--公会

cache.Chat = import(".ChatCache").new() ----聊天

cache.Friend = import(".FriendCache").new() ----好友

cache.Horn = import(".HornContentCache").new() --主界面小喇叭

cache.Contest = import(".ContestCache").new() --驯兽师

cache.Redbag = import(".RedbagCache").new() --红包

cache.Dig = import(".DigCache").new() --红包

cache.Active = import(".activeCache").new()--活动

cache.Camp = import(".CampCache").new() --阵营战

cache.Rune = import(".RuneCache").new() --符文

cache.DayFuben = import(".DayFubenCache").new() --符文

cache.Cross = import(".CrossCache").new() --跨服战

cache.Science = import(".ScienceCoreCache").new() --科技核心

cache.Boss = import(".BossCache").new() --世界boss

function cache.clear()
	-- body
	--debugprint("清缓存信息")
	cache.Player:init()
	cache.Pack:init()
	cache.Fortune:init()
	cache.Shop:init()
	cache.Lucky:init()
	cache.Copy:init()
	cache.Fight:init()
	cache.Mail:init()
	cache.Equipment:init()
	cache.Adventure:init()
	cache.Taskinfo:init()
	cache.Zhaocai:init()
	cache.Guild:init()
	cache.Chat:init()
	cache.Friend:init()
	cache.Horn:init()
	cache.Contest:init()
	cache.Redbag:init()
	cache.Dig:init()
	cache.Active:init()
	cache.Camp:init()
	cache.Rune:init()
	cache.DayFuben:init()
	cache.Cross:init()
	cache.Material:init()
	cache.Science:init()
	cache.Boss:init()
end

return cache