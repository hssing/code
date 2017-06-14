
g_var = {
  --是否启用网络
  debug_network = true,
  debug_accountId = "",
  debug_accountName="",
  debug_name = "",
  -- debug_ip = "192.168.8.207",
  -- debug_ip = "127.0.0.1",
  -- debug_port = "7501",

  debug_ip = "",
  debug_port = "",
  serverTime = os.time(),
  server_id = 0,--服务器Id
  channel_id = 101,--登陆渠道
  flag = "xxoomd5",
  time = 123456789,
  platform = "win32",
  ignore_heart = false,

  channel_bt          = 0 ,--作弊渠道Id
  server_bt           = 0 ,--作弊服务器Id
  account_bt          = 0 ,--作弊账号Id
  fight_skip_bt       = 0 ,--作弊跳过战斗
  platform_id_bt      = 0 ,--作弊渠道号
  server_list_url_bt  = "",--作弊使用
}
--是否输出消息格式
g_debug_view = false
g_msg_pint = false
---战斗加速
fight_speed = 0.9  --0.9  --1.5  2
fight_test = false
fight_guide = false
fight_newer_state = true  --是否开启新手战斗【true开启，false关闭】
no_guide = false  --是否开启新手引导【true关闭，false开启】
---标志是否在家主界面，从战斗切回到章节就不用load主界面
load_main_view = true
--是否充值
g_recharge = true
--测试更新
g_win_update = true
--全局定时器id
g_timer_id = -1
--倒计时用来计算
g_timer_com = 0
--网络环境
g_netEnvironment = false  --[true wifi环境下，false非]
--消息号版本,在msg_version.lua导入
--g_msg_version = 0

LANGUAGE = {
  CHINA = 1, --中国 简体
  CHINA_TW =2 ,--中国台湾 --繁体
}
g_language = LANGUAGE.CHINA

COLOR={
	cc.c3b(255,255,255),    -- 白
    cc.c3b(18,255,0),      -- 绿
    cc.c3b(0x2d,0xec,0xfd),     -- 蓝
    cc.c3b(0xf5,52,0xfb),     -- 紫
    cc.c3b(255,95,5),       -- 橙
    cc.c3b(240,25,25),      -- 红
    cc.c3b(255,255,20),      -- 金
    cc.c3b(240,25,25),      -- 深红
}
--经验石ID
EXP_STONE_ID={
  221061001,
  221062001,
  221063001,
  221064001,
  221065001,
}



--
--[[PRO_USE_TL = {
  221011004,
  221011003,
  221011002,
}]]--
PRO_USE_TL = {
  221011002,
  221011003,
  221011004,
}
--屠魔
PRO_USE_TM = {
  221011008,
  221011009,
  221011010,
}
--竞技场
PRO_USE_ATHELETICS = {
  221011005,
  221011006,
  221011007,
}



pack_type={
  EQUIPMENT=1,
  PRO=2,
  SPRITE=3,
  RUNE = 4, 
  MATERIAL = 5,
}

--出战坑解锁状态
battle_head={
  LOCK=1,
  UNLOCK=2,
  EQUIP=3,
}
--
NEW_ITEM_APCK_AMOUNT ={0,0,0,0,0}  --记录背包新物品数量

property_index ={
  EXP= 101,
  ATK= 102,
  DEF            = 103,
  HP            = 104,
  MAX_HP         = 105,
  POWER          =305,
  LV             =304,
  FIRST          = 40303,--首充
  VIPEXP = 40302,--VIp经验
  VIPLV = 40301, --vip等级
  VIP_REWARD = 40305 ,--vip礼包
  VIP_BUY_ADVENT = 40322,--每日可购买探险
  
  ADVENT_COUNT = 40421,--当前探险次数
  ADVENT_MAXCOUNT  = 40422,--最大探险
  ADVENT_TIMES = 40423,--下一次探险时间(秒)
  ADVENT_TIMES_RESET = 40335,--下一次探险时间(秒)

  ATHLETICS_COUT = 40431, --挑战cishu
  ATHLETICS_MAX = 40432, --挑战上限
  ATHLETICS_BUY_TIMES = 40324, --竞技场可购买次数 
  ATHLETICS_TIMES_RESET = 40336,--竞技场每次回复时间
  ATHLETICS_TIMES_LAST = 40433,--竞技场下一次回复剩余



  TILI = 40411, --当前体力
  MAX_TILI = 40412 ,--最大体力
  TILI_TIMES = 40413 ,--下一次体力恢复剩余(秒)
  TILI_TIMES_RESET = 40337,--体力每次回复时间

  TILI_BUY = 40321, --每日可购买体力
  --主界面红点
  REAND_YOUJIAN = 40201, --未读邮件个数
  REAND_QIAODAO = 40701, --是否已经签到
  REAND_VIPLIBAO = 40702, --VIP可购买礼包数
  REAND_TASK = 40703, --未领取的任务
  REAND_ACHI = 40704, --未领取的成就
  REAND_ZHAOCAI = 40441, --当前招财次数 
  REAND_CHIJI = 40601, --是否可以吃鸡
  
  REAND_HAOYOUTL = 40705, -- 好友体力
  REAND_GONGHUILJ = 40706,--公会可以研发或者可以领取奖励
  REAND_GONGHUIFUBENJL = 40707,--公会副本有奖励
  REAND_GONGHUITONGGUOJL = 40708,--公会通过奖励
  REAND_DENGJIJL = 40709, --等级奖励
  REAND_SHENHE = 40710, --成员审核
  REAND_TOWER =  40711,  --爬塔

  REAND_MEIRICHONGZHI = 40712,  --每日充值
  REAND_DANCHONG = 40713,  --单笔充值
  REAND_LEICHONG = 40714,  --累充充值
  

  REAND_XUNSHOUWANG = 40715, -- 驯兽师之王点赞
  REAND_XUNSHOUWANGSET = 40716, -- 驯兽师之王设置
  REAND_XUNSHOUBAOMING = 40717, -- 驯兽师之王报名

  REAND_DOUBLE_RECHARGE = 40718, -- 首次翻倍

  REAND_DIG = 40719, -- 挖矿
  REAND_DIG_FUCHOU = 40722, -- 挖矿复仇

  REAND_11_OPEN = 40721, --双11开关
  REAND_11_REAND = 40720, -- 双11红点
  --
  SEVER_TIME = 40203, --服务器时间
  --阵营战
  REAND_CAMP = 40723,--阵营战入口
  RICHRANK = 40724,--主界面全民土豪、进化神殿、砸蛋入口开关
  RICHRANKNUM = 40725,--主界面全民土豪、进化神殿、砸蛋入口红点
  OPEN_ACT_PRAISE = 40726,--开服活动，点赞红点
  REAND_DAYFUBEN = 40727,--日常副本

  READND_MONTH_ACIVE = 40730,--月卡活动 是否开启
  READND_MONTH_BUY = 40728,--月卡是否购买
  READND_MONTH_ALL = 40729,--终生卡 是否购买

  READND_MONTH_SHOW = 40731,-- 0 没的领，12 有领取 ，3 月卡充值活动消失

  READND_TTHL_REDP = 40732, --天天豪礼红点
  READND_XFHL_REDP = 40733, --消费豪礼红点

  READND_CROSS_COUNT = 40360,--跨服战匹配次数

  FRUIT_COMPOSE = 40801,--果实合成红点

  REAND_100 = 40738 ,--7星好礼 充100
  REAND_100_limit = 40739,--7星好礼 充100 限时
  REAND_100_limit_3010 = 40740,--7星好礼 充100 限时  
  REAND_BOSS = 40741 ,--世界boss
  REAND_TASK_GET = 40742, --  活跃度有东西
  MAX_CHAPTER_ID = 40743,--已通关的对大章节数
  NEWBAG_REAND = 40744 ,--福袋
  NEWRED = 40745, --登录红包
}

--攻击点
fight_pos = {  --对象面前1    --敌方排中2  --敌方左边3   --纵排前4  --纵排后5
    ["11"] = {{150,325+110},  {320,325},   {-100,600}, {150,325}, {150,325}},
    ["12"] = {{320,325+110},  {320,325},   {-100,600}, {320,325}, {320,325}},
    ["13"] = {{490,325+110},  {320,325},   {-100,600}, {490,325}, {490,325}},
    ["14"] = {{150,115+100},  {320,115},   {-100,600}, {150,325}, {150,325}},
    ["15"] = {{320,115+100},  {320,115},   {-100,600}, {320,325}, {320,325}},
    ["16"] = {{490,115+100},  {320,115},   {-100,600}, {490,325}, {490,325}},

    ["21"] = {{150,575-80},   {320,575},   {-100,600}, {150,480}, {150,790}},
    ["22"] = {{320,575-80},   {320,575},   {-100,600}, {320,480}, {320,790}},
    ["23"] = {{490,575-80},   {320,575},   {-100,600}, {490,480}, {490,790}},
    ["24"] = {{150,750-80},   {320,750},   {-100,600}, {150,480}, {150,790}},
    ["25"] = {{320,750-80},   {320,750},   {-100,600}, {320,480}, {320,790}},
    ["26"] = {{490,750-80},   {320,750},   {-100,600}, {490,480}, {490,790}},
}

--角色动作
player_action = {
    idle = "1001",
    atk_fall = "1005",    --攻击落下动作
    
    back_fall = "1008",   --攻击回来落下动作
    atk_scale = "1009",   --攻击放大动作
    
}

---网络连接状态
net_state = {
    none = 0,  --无
    connect = 1,  --连接状态
    break_line = 2,  --断线
    close = 3,     --服务器关闭
    mult_line = 4, --顶号
    jump = 5,  --强制跳转
    failure = 6, --连接失败
    login = 7,  --登陆
    jump_say_fenhao = 8 ,--封号
    jump_say_fenIp = 9,--封ip
    md5_lose = 10 ,--验证失败
    version_lose = 11 ,--版本验证
}

---pvp, pve类型
fight_vs_type = {
    copy = 1, --副本
    athletics = 2, --竞技场
    tower = 3, --爬塔
}


--垂直居中靠作
VERTICAL_CENTER_LIFE = 1

--水平居中靠上
HORIZONTAL_CENTER_UP = 2
--都居中
VERTICAL_HORIZONTAL_CENTER = 3

version_json_data = {
  restart           = nil,      -- "1"为需要重启
  off_server        = nil,      -- "1"为不能进入游戏
  off_tip           = nil,      -- 代替选服
  show_tip          = nil,      -- 窗口提示
  is_update         = nil,      -- 是否有更新
  test_server_list  = nil,      -- 测试服
}
debug_unzip = false
-- TISP_VERTICAL_ALIGNMENT =2

-- TISP_VERTICAL_ALIGNMENT =2