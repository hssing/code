local conf={}

conf.Role   =     import(".RoleConf").new()

conf.Item   =     import(".ItemConf").new()

conf.Card   =     import(".CardConf").new()

conf.Effect =     import(".EffectConf").new()

conf.Skill  =     import(".SkillConf").new()

conf.CardGift=	  import(".CardGift").new()

conf.Open=	 	  import(".OpenConf").new()

conf.CardIntimacy = import(".CardIntimacy").new()

conf.CardExp  =    import(".CardExp").new()

conf.Copy = import(".CopyConf").new()

conf.CardJinghua = import(".CardJinghuaConf").new()

conf.CardTopo = import(".CardTopoConf").new()

conf.Recharge = import(".RechargeConf").new()

conf.Suit = import(".SuitConf").new()

conf.EquipmentQh = import(".EquipmentQhConf").new()

conf.EquipmentJh = import(".EquipmentJhConf").new()

--系统配置
conf.Sys 			= import(".SysConf").new()
--探险BOSS
conf.Adventure 			= import(".AdventureConf").new()
--任务
conf.task 			= import(".taskConf").new()
--成就
conf.achieve 			= import(".achieveConf").new()
--购买次数价格
conf.buyprice =  import(".buypriceConf").new()
--人物头像
conf.head = import(".headConf").new()
--引导
conf.guide = import(".GuideConf").new()
--achieveConf
--限时活动变量配置
conf.ActiveVar = import(".ActiveVarConf").new()
--开服活动变量配置
conf.OpenActVar = import(".OpenActVarConf").new()
--活动配置
conf.active = import(".activeConf").new()

--开服活动 进化圣殿
conf.OpenActJHSD = import(".OpenActJHSDConf").new()

--签到配置
conf.qiandao = import(".QiandaoConf").new()

--活动2 累计充值，单笔充值奖励配置
conf.Act2Charge = import(".Act2ChargeConf").new()


--招财
conf.zhaocai = import(".zhaocaiConf").new()
--吃鸡
conf.eatChicken = import(".EatChickenConf").new()
--等级豪礼
conf.bigGift = import(".LevelBigGiftConf").new()
--累计充值
conf.ChargeCount = import(".ChargeCountConf").new()
--每日首充
conf.ChargePerDay = import(".ChargePerDayConf").new()
--疯狂回馈
conf.CrazyFeedBack = import(".CrazyFeedBackConf").new()
--邀请好友等级奖励
conf.Invitate =  import(".InvitateAwardConf").new()
--砸蛋
conf.HitEgg = import(".HitEggConf").new()
--进化神殿
conf.Palace = import(".PalaceConf").new()
--公会挣榜
conf.GuildCmp = import(".GuildCmpConf").new()
--攻略
conf.strategy = import(".StrategyConf").new()

--公会
conf.guild = import(".GuildConf").new()

---敏感词
conf.SensitiveWords = import(".ChatSensitiveWordsConf").new()
--数码大赛
conf.Contest = import(".SMDSawardsconf").new()

--称号
conf.Title = import(".TitleConf").new()

--公告--gonggao
conf.Gonggao = import(".GonggaoConf").new()
--规则
conf.Guize = import(".GuizeConf").new()
--通用副本配置、
conf.Tong = import(".TongConf").new()

--商品编号
conf.Waresid = import(".WaresidConf").new()

--挖矿
conf.Dig = import(".DigConf").new()
--双11
conf.Double = import(".DoubleConf").new()
--合成将星
conf.Compose = import(".ComposeConf").new()
--阵营战
conf.Camp = import(".CampConf").new() 
--符文
conf.Rune = import(".RuneConf").new()
--日常副本
conf.DayFuben = import(".DayFubenConf").new()
--跨服战
conf.Cross = import(".CrossConf").new()
--vip商店
conf.VipShop = import(".VipShopConf").new()

--果实合成
conf.Fruit = import(".FruitConf").new()
--科技核心
conf.ScienceCore = import(".ScienceCoreConf").new()
--世界boss
conf.Boss = import(".BossConf").new()
--商店全局
conf.Shop = import(".ShopConf").new()



return conf