_viewname = {
 	GAME     					= "GameView",
	MAIN      				= "main.MainView",
	LOGIN      				= "login.LoginView",
	CREATE_ROLE				= "login.CreateRoleView",
	--宠物选择
	CREATE_ROLE_PET				= "login.CreatePetView",
	DEBUG     				= "DebugView",
	DEBUG_TEST				= "DebugTestView",
	MAIN_TOP_LAYER 			= "main.MainTopLayerView",
	TIPS                    = "tips.TestTipsView",
	HORN 					= "main.HornView",------小喇叭输入层
	HORNTIPS 				= "horn.HornTipsView",--"horn.HornTipsLayer",---- 小喇叭提示层

	HEAD                    = "HeadView",
	-- 背包
	PACK                    = "pack.PackView",
	-- 人物
	ROLE                    = "role.RoleView",
	-- FORM                    = "FormationView",
	BATTLE                  = "BattleView",
	--SELECT_HEAD             ="role.SelectHeadView",
    --称号
    TITLE                   ="role.TitleView",
    --头像选择
    SELECT_HEAD             ="role.SelectHeadIconView",
	--任务升级
	LEVEL_UP                ="role.leveup.RoleLevelUpView",
	FIGHT 									= "fight.FightView",
	--道具信息
	PRO_TIPS              	="pack.ProMessageView",
	--商店
	SHOP        			="shop.ShopView",
	--商店2次购买
	SHOP_BUY        		="shop.ShopBuyView",
	-- 数码兽装备阵型
	FORMATION         	    ="formation.FormationView",
	--数码兽切换阵型
	CHANGE_FORMATION        ="formation.ChangeFormationView",
	--出战列表
	BATTLE_LIST     	   	="formation.BattleListView",
	--数码兽升级
	PROMOTE_LV     	   		="promote.SpirteLvUpView",
	--吞噬选择材料
	DEVOUR_MATERIAL			="promote.DevourMaterialListView",
	--抽奖
	LUCKYDRAW 				="luckydraw.LuckyView",
	--LUCKYDRAWGET 			="luckydraw.LuckygetView",
	--获得物品弹出
	PACKGETITEM 			="pack.GetItemView",
	
	--副本
    COPY                    = "copy.CopyView",    --副本选章
    COPY_CHAPTER            = "copy.ChapterView",  --章节
    CHAPTER_AWARD           = "copy.CopyAwardView",  --章节每个副本奖励
    COPY_PERFECT_VIEW       = "copy.CopyPerfectView", --章节30星通关奖励
    COPY_PASS_VIEW          = "copy.CopyPassView",  --通关章节
    COPY_WIPE               = "copy.CopyWipeView",  --章节扫荡
    --竞技场
    ATHLETICS               = "athletics.AthleticsView",  --竞技场
    ATHLETICS_ALERT         = "athletics.AthleticsAlert",  --竞技场次数不足提示框
    ATHLETICS_COMPARE       = "athletics.AthleticsCompareView",  --实力对比
    ATHLETICS_WIPE          = "athletics.AthleticsWipeView", --竞技场战五次
    --爬塔
    CLIMB_TOWER             = "climbtower.ClimbTowerView",  --爬塔副本
    TOWER_AWARD             = "climbtower.TowerRankView", --爬塔奖励
    TOWER_YQ                = "climbtower.InspireView",   --勇气鼓舞
    TOWER_HARD_ALERT        = "climbtower.TowerAlert",  --星级提示
    TOWER_REST_VIP          = "climbtower.TowerRestView", --购买vip
    TOWER_REST_TIMES        = "climbtower.TowerRest2View",  --购买次数
    TOWER_AWARD_ALERT       = "climbtower.TowerAwardAlert", --爬塔星级奖励获取界面
    TOWER_BUY_AWARD         = "climbtower.TowerBuyAlert",  --爬塔购买奖励
    TOWER_PASS_VIEW         = "climbtower.TowerPassView",  --爬塔通关100

	-- 数码兽信息
	PETDETAIL        		="promote.PetDetailView",

	--数码兽进化突破
	PROMOTE_LV_ADD        	="promote.SpirteColorUpView",
	--装备强化
	EQUIPMENT_QH            ="equipmentpromote.StrengthenView",
	--战斗
	FIGHT_WIN               = "copy.FightWinView",
	FIGHT_OVER              = "copy.FightOverView",
	--邮件	
	MAILVIEW 				= "mail.MailView",
    MAILVIEWBACK            = "mail.MainBackView",
	--装备选择佩戴
	EQUIPMENT               = "equipmentpromote.EquitmentListView",
		--装备选择佩戴
	EQUIPMENT_MESSAGE        = "equipmentpromote.EquipmentMessageView",

	--装备材料选择
	SELECT_EQUIPMENT        = "equipmentpromote.EquitmentJhListView",
	
	--vip特权界面
	VIP                     = "vip.VipView",
    VIP_TIPS                = "vip.VipTipsView",
	--规则界面
	GUIZE                   = "guize.GuizeView",
	--合成
	COMPOSE					= "compose.ComposeView",
	COMPOSELIST				= "compose.CompseChooseView",
	--成就
	ACHIEVEMENTVIEW 		= "achievenment.AchievementView",
	--任务
	TASK 					= "task.TaskView",
    TASK_GET_HY             = "task.TaskGetView",
	--探险
	ADVENTUREVIEW           ="adventure.AdventureView",
	--tips 探险 杀死boss获得
	ADVGETITEM                        ="tips.AdvgetItemview",
	--游戏次数不足 ， vip购买次数上限 ，探险今日不在提示
	NOENOUGHTVIEW                         ="tips.Noenoughtview",
	--购买体力
	ROLE_BUY_TILI          ="tips.BuyTiliView"  ,
	--系统公告
	SYS_GONGGAO          = "main.NoticesView",

	--网络重连提示
	NET_REST_TIPS		   = "tips.NetRestTipsView",

	--图鉴
	PACK_MAP                       ="pack.mapView",
	--卡牌退化 或者装备退化
	TUIVIEW                       ="formation.TuiView",
    --引导界面
    GUIDE_VIEW  = "guide.GuideView",
    --新功能开启
    OPEN_FUNC = "guide.OpenFuncView",
    
    --数码兽升级 购买道具
    PROMOTE_ITEM	="promote.SpirteLvUpAutobuyView" ,

    --副本活动入口
    FUNBENVIEW				= "main.FubenView",
    --活动,
    ACTIVITY  = "acitve.ActiveView",
    ACTIVITYZHAOCAI =    "acitve.ActiveZhaocaiView",

    SINGNIN = "signin.SignInView",

    -- 吃鸡
    EATCHICKEN = "acitve.EatChickenView",
    --等级豪礼
    LEVELBIGIFT = "acitve.LevelBigGiftView",
   
 
    --邀请好友
    INVITATEFRIEND = "acitve.InvitationView",
    --已邀请的好友
    INVITATEDFRIENDLIST = "acitve.InvitatedFriend",
    --邀请好友等级奖励
    INVITATEAWARD = "acitve.InvitateAwardView",
    ---礼包码
    GIFTPACKCODE =  "acitve.GiftPackCodeView",
    ---疯狂回馈
    CRAZYFEEDBACK = "acitve.CrazyFeedBackView",
    ---累计充值
    CHARGECOUNT = "acitve.ChargeCountView",
    ---每日首冲
    CHARGEPERDAY = "acitve.ChargePerDayView",
    --回归大礼
    COMEBACK = "acitve.ComeBackView",
     --回归大礼
    PRAISEVIEW = "acitve.PraiseView",
    --全民土豪
    RICHRANK = "acitve.RichRankView",
    --砸蛋
    HITEGG = "acitve.HitEggView",
    --进化神殿
    PALACE = "acitve.EvolutionPalaceView",
    --公会争霸
    CMPRANK = "acitve.GuildCmpRankView",

    --土豪排行点赞
    OPENACTPRAISE = "acitve.OpenPraiseView",
    OPEN_YESTERDAY_RANK = "acitve.YesterdayRankView",
    --进化圣殿
    OPENACTPALACE = "acitve.OpenEvoPalaceView",
    --活动2累充
    ACT2CHARGECOUNT = "acitve.Act2ChargCountView",
    ACT2CHARGESINGLE = "acitve.Act2ChargeSingleView",
    ACT2SIGN = "acitve.Act2SignView",
    ACT2LUCKY = "acitve.Act2LuckyView",
    ACT2MONTHCARD = "acitve.Act2MonthCardView",
    --VIP商店
    ACTIVEVIPSHOP = "acitve.ActiveVipShopView",
    --天天豪礼
    EVERYDAYGIFT = "acitve.EveryDayGiftView",
    --消费豪礼
    CONSUMEGIFT = "acitve.ConsumeGiftView",


    -- loading
    LOADING_VIEW = "main.Loading",
    --攻略一级界面
    STRATEGY = "strategy.StrategyView",
    --攻略二级界面
    STRATEGY_2 = "strategy.StrategyView_2",
    --攻略三级界面
    STRATEGY_3 = "strategy.StrategyView_3",
    STRATEGY_INTRO = "strategy.StrategyIntroView",
    --好友
    FRIEND = "friends.FriendView",
    --好友信息
    FRIENDINFO = "friends.FriendInfoView",
    --聊天
    CHATTING = "friends.ChattingView",
    --表情
    FACIALS = "friends.FacialsView",

    -----------------公会----------------
    GUILD_VIEW = "guild.GuildView",  --公会界面
    GUILD_LIST = "guild.GuildSearchView",--公会列表 
    GUILD_CREATE = "guild.GuildCreateView",--创建公会
    GUIILD_QIFU = "guild.GuildQifu",--祈福
    GUIILD_REWARAD = "guild.GuildGetitem",--获得奖励
    GUILD_BAR = "guild.GuildBar",  --按钮
    GUILD_FB_ENTER = "guild.GuildFBEnter",  --公会副本入口
    GUILD_FB = "guild.GuildFB",  --公会副本
     --公会审核
    GUIILD_SHENGHE = "guild.GuildShengheView",
    GUILD_MEMBER = "guild.GuildMemberView", --公会成员
    GUILD_RENMING = "guild.GuildRMView",--任命
    GUILD_SHOP = "guild.GuildShopView",--公会商店
    GUILD_WORLD_RANK = "guild.GuildWorldRank",--世界排行
    GUILD_GUILD_RANK = "guild.GuildFBRank",--副本排行
    GUILD_DT = "guild.GuildNoticesView",--动态
    GUILD_ZHANJI = "guild.GuildZhanjiView",--成员战绩
    GUILD_FB_REWARD =  "guild.GuildRewardView",--通关奖励
    GUILD_FB_AWARD = "guild.GuildFBAward", --副本奖励
    GUILD_CHANGE = "guild.GuildSendView", --副本奖励
    GUILD_BENQU_RANK = "guild.GuildBenQuRank",--本区排行
    GUILD_JOB = "guild.GuildSetView",--申请入会设置
    GUILD_TWO_RABK = "guild.GuildTwoRank",--副本 本区 双排行
    -------------------------------------


    UPDATE_VIEW = "login.UpdateCheckView",

    SEND_REDBAG = "redbag.SendRedBagView",--发红包界面
    RECEIVE_REDBAG = "redbag.ReceiveRedBagView",--抢红包界面
    REDBAG_DETAIL = "redbag.RedBagDetailView", --红包领取详情
    ---数码兽大赛
    CONTEST_MAIN = "contest.ContestView", --主界面
    CONTEST_REWARD = "contest.ContestRewardView",--奖励
    CONTEST_COMPARE ="contest.ContestCompareView",--竞猜
    CONTEST_VIDEO = "contest.ContestVideoView",--录像
    CONTEST_GROUP = "contest.ContestGroupView",--小组信息
    ---驯兽师之王
    CONTEST_WIN_MIAN = "contest.win.Contest_WinnerMain",
    CONTEST_WIN_RANK ="contest.win.Contest_WinnerRank" ,--排行
    CONTEST_WIN_SET = "contest.win.Contest_WinnerSet" ,--设置
    CONTEST_WIN_SET_SECOND = "contest.win.Contest_WinnerSetSecView" ,--设置

    CONTEST_SHOP = "contest.Contest_shopView",--商店
    --挖矿
    DIG_MIAN = "dig.DigMainFrame", --挖矿主界面
    DIG_FRIEND = "dig.DigFriend", --好友界面
    DIG_INNER_MAIN = "dig.DigOneFrame", --某个矿主页面
    DIG_SET = "dig.DigSetView",--设置界面
    DIG_CHOOSE ="dig.DigOneJingView" ,--设置的2级界面 ，选择消耗的数量级别
    DIG_CHALLENGE = "dig.DigChallengeView" ,--挑战
    DIG_PROGRESS = "dig.DigProgressView",--挖矿过程中
    DIG_HELPVIEW = "dig.DigHelpView",--石头剪刀布
    DIG_HELPOVER = "dig.Dig_HelpOver",
    DIG_SET_CARD = "dig.DigOneCardView",
    DIG_JIASU_SECOND = "dig.Dig_JiaSuview",--加速确认界面
    DIG_SEARCH = "dig.Dig_SearchView",--搜索界面
    ---双11活动
    DOUBLE = "acitve.Active_11MianView",
    -------------------------------究极大战
    CAMP_FIRSTR = "camp.CampView",--报名参战界面
    CAMP_SECOND = "camp.CampTips", --报名成功 提示阵营
    CAMP_MIAN = "camp.CampMain" ,--主要界面
    CAMP_OVER = "camp.CampOverView", --匹配成功
    CAMP_COMPARE = "camp.CampCompareView",--阵容界面
    RANKENTY = "acitve.RichRankEntryView",--全民土豪入口
    --------------新增命格 系统 也就是符文
    RUNE_LV = "rune.RunelvView", --符文升级界面
    RUNE_MSG = "rune.RuneMsgView",--符文信息界面
    RUNE_LIST_VIEW = "rune.RuneListView",--符文选择穿戴
    RUNE_LIST_TUNSHI = "rune.RuneDevourListView",--符文选择穿戴
    RUNE_PRO_MSG =  "rune.RuneProView" ,--神魂猎命
    --------------日常副本
    FUBEN_DAY = "acitve.DayFubenView",
    FUBEN_DAY_REWARD = "acitve.DayFubenChooseView",
    ---跨服战
    CROSS_WAR_XIN =  "cross.CrossXinView" ,--神魂猎命
    CROSS_WAR_MAIN =  "cross.CrossMainView" ,--跨服战 主界面
    CROSS_XIN_DUIHUAN ="cross.CrossXinDuiView",--神魂兑换
    CROSS_RANK = "cross.CrossRankView",--排位战绩
    CROSS_WIN_WAR = "cross.CrossWinwarView",--王者之战
    CROSS_WIN_REWARD ="cross.CrossRewardView",--王者之战奖
    CROSS_WIN_MOBAO = "cross.CrossMoBaiView",--膜拜界面
    CROSS_WIN_TIPS = "cross.CrossTipsView",--膜拜界面
    CROSS_WIN_COMPARE = "cross.CrossCompareView",--竞猜
    CROSS_WIN_WORD ="cross.CrossSendView",--留言
    CROSS_VEDIO = "cross.CrossRankZhan",--录像
    CROSS_VIDEO_TRUE = "cross.CrossVideoView", ---录像
    --
    ACTIVEMONTH = "acitve.active_month",--月卡
    SPRITE7SCAD = "promote.Sprite7sView",--月卡
    PRIVATEEMAIL = "main.PrivateEmailView", --私信
    SCIENCECORE = "sciencecore.ScienceCoreView", --科技核心主界面
    DEVOUR = "sciencecore.DevourView", --科技核心吞噬界面
    DEVOURREWARD = "sciencecore.DevourRewardView", --科技核心奖励界面
    DEVOUR_CHOOSE = "sciencecore.DevourViewChoos", 

    OTHER_VIEW = "formation.FormationOtherView",--查看他人的阵容

    --果实合成开始
    FRUIT_COMPOSE_PAGE = "fruitcompose.FruitPageView",
    FRUIT_COMPOSE = "fruitcompose.FruitComposeView",
    FRUIT_COMPOSE_SELL = "fruitcompose.FruitSellView",

    --果实合成结束
    ACTIVE100 = "acitve.Active_100_recharge",--100元充值
    ACTIVE100_1 = "acitve.Active_100_recharge_1",--100元限时
    ACTIVETIANZS = "acitve.Active_tianZS", --天降钻石
    --小伙伴
    CRADFRIEND = "formation.CardFriend",--小伙伴主界面
    CRADFRIEND_LIAS = "formation.CardFriendList",--小伙伴上阵列表
    --改名卡
    CAHNGENAME = "pack.Changename",
    --boss
    BOSS_MAIN = "boss.BossMainView", --世界boss主界面
    BOSS_GUWU = "boss.BossGuWuView", --鼓舞界面
    BOSS_GUWU_REWARD = "boss.BossGuReward", --鼓舞领取奖励
    BOSS_RANK = "boss.BossRewardView",--排行榜
    --幸运大奖
    AWARDRANK = "acitve.AwardRankView",
    AWARD_PAGE = "acitve.Award_pageView" ,--我的奖券
    MYLOTTERY = "acitve.MyLotteryView",
    MAINLOTTERY = "acitve.MainLotteryView",
    --  福袋
    ACTIVENEWABAG = "acitve.ActiveNewBag",
    -- 登陆红包
    ACTIVENEWARED = "acitve.ActiveNewRed",

    ACTIVITYTIME = "acitve.ActivityTimeView",

    Just_test = "Just_test"
 }

 

_scenename = {
	LOADING      		= "LoadingScene",
	MAIN      			= "MainScene",
	LOGIN      			= "LoginScene",
	FIGHT			    = "FightScene",
	PRE                 = "PreScene",
	ROLE                = "CreateRoleScene"
}

view_show_type = {
	UI           =       1,
	TIPS         =       2,
	OTHER        =       3,
	TOP          =       4,
    GUIDE        =       6,
    NET          =       7,
}

ui_type={
	MAIN=1,--主页
	FOM=2,--队形
	BATTLE=3,--战役
	EXPLORE=4,--探险
	FB=5,--副本
	FRIEND=6,--好友
	ACTIVITY=7,--活动
}
view_close_type={
	HIDE=1, --隐藏
	DESTROY=2,
}

platform_type ={
    windows = 0,
    mac     = 2,
    android = 3,
    iphone  = 4,
    ipad    = 5,
    winrt   = 10,
    wp8     = 11
}

user_default_keys = {
  	GAME_LOGIN_USER_ACCOUNT_KEY="game_login_user_account_key", --用户登陆账户
  	GAME_LOGIN_USER_PASSWORD_KEY="game_login_user_password_key", --用户登陆密码
  	GAME_ADVENTTURE_DAY = "game_adventture_day",     --一键探险不弹出2次界面
  	FIGHT_SPEED = "fight_speed",  --战斗加速
  	GAME_SPRITE_DAY = "game_sprite_day",     --数码兽升级不要2次界面
    OPEN_MUSIC = "open_music",  --音乐开关
    OPEN_SOUND = "open_sound",  --是否开启音效
    MUSIC_VOLUME = "music_volume",  --音乐声音大小
    SOUND_VOLUME = "sound_volume",  --音效声音大小
    GAME_ZHAICAI_DAY = "game_zhaocai_day" ,--招财是否勾选了一键招财
    SCREEN_LOCK = "screen_lock" ,-- 是否锁频
    FIRST_TOWER = "first_tower",  --标志第一次进入爬塔
    FIRST_ADV   = "first_adv", --标志第一次探险

    LAST_LOGIN   = "last_login", --最后一次选择的服务器
    KEY_OF_APPVERSION = "apk_version",

    CHATICON_POS = "chat_icon_position",---主界面聊天Icon的位置
    TOWER_INSPIRE = "TOWER_INSPIRE",  --爬塔勇气鼓舞
    REDBAG_SHOW = "redBag_show", --主界面是否显示红包
    DIG_FRIST = "dig_first",--第一次挖矿
    GAME_11CHOU_DAY = "game_11chou_day" ,--双11抽奖是否选择了转10次
    REDBAG_POS = "redbag_pos",---抢红包按钮位置
    ACT2_CHOU_CHECK = "act2_chou_check",---活动2转盘抽奖10次勾选
    CROSS_SH = "cross_sh", --今天不在提示 神魂抽奖
    TUNSHI_7S = "tunshi_7s", --今天不在提示 吞噬7s卡

}