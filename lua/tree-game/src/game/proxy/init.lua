local proxy = {}


proxy.Login = import(".LoginProxy").new()

proxy.pack = import(".PackProxy").new()

proxy.head = import(".HeadProxy").new()

proxy.Radio = import(".RadioProxy").new()

proxy.shop = import(".ShopProxy").new()

proxy.card = import(".CardProxy").new()

proxy.lucky = import(".LuckyProxy").new()

proxy.LuckyLottery = import(".LuckyLotteryProxy").new()

proxy.copy = import(".CopyProxy").new()

proxy.Equipment = import(".EquipmentPromoteProxy").new()

proxy.Mail = import(".MailProxy").new()

proxy.adventure = import(".AdventureProxy").new() --探险

proxy.task = import(".taskProxy").new() --任务

proxy.Active = import(".ActiveProxy").new() --活动

proxy.signIn = import(".SignInProxy").new() --签到

proxy.zhaocai = import(".zhaocaiProxy").new() --招财

proxy.eatChicken = import(".EatChickenProxy").new() --吃鸡

proxy.Invatate = import(".InvitationProxy").new()--邀请码

proxy.GiftPackCode = import(".GiftPackCodeProxy").new() --礼包码

proxy.LevelGift = import(".LevelBigGiftProxy").new()--等级礼包

proxy.ChargrPerDay = import(".ChargePerDayProxy").new() --每日首充

proxy.ChargeCount = import(".ChargeCountProxy").new() --累计充值

proxy.CrazyFeedBack = import(".CrazyFeedBackProxy").new() --疯狂回馈

proxy.ComeBack 		= import(".ComeBackProxy").new() --首服回归

proxy.RichRank = import(".RichRankProxy").new() --全民土豪、公会挣榜，砸蛋，进化神殿

proxy.OpenAct =  import(".OpenActProxy").new()--------开服活动

proxy.friend = import(".FriendProxy").new() --好友

proxy.Chat = import(".ChattingProxy").new() --聊天

proxy.guild = import(".GuildProxy").new() --公会

proxy.Horn = import(".HornProxy").new() --小喇叭

proxy.Redbag = import(".RedBagProxy").new() --红包

proxy.Contest = import(".ContestProxy").new() --驯兽师大赛

proxy.Title = import(".TitleProxy").new() --称号、头像

proxy.Dig = import(".DigProxy").new() --文件岛

proxy.Double = import(".DoubleProxy").new() --双11

proxy.Camp = import(".CampProxy").new() --阵营战

proxy.Rune = import(".RuneProxy").new() --符文

proxy.DayFuben = import(".DayFubenProxy").new() --日常副本

proxy.Cross = import(".CrossProxy").new() --跨服战

proxy.ActVipShop = import(".ActiveVipShopProxy").new() --VIP商店

proxy.EveryDayGift = import(".EveryDayGiftProxy").new() --天天豪礼

proxy.ConsumeGift = import(".ConsumeGiftProxy").new() --消费豪礼

proxy.PrivateEmail = import(".PrivateEmailProxy").new() --私信
--果实合成
proxy.Fruit = import(".FruitProxy").new()

proxy.ScienceCore = import(".ScienceCoreProxy").new() --科技核心

proxy.Boss = import(".BossProxy").new() --世界boss

return proxy