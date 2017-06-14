local res = {}

res.kai = {
	adv = 12 , --探险开启等级
	achi = 5 ,	--成就开启等级
	horn = 40,  --小喇叭开启等级
	redBag = 15, --红包
	strategy = 1,--攻略
	showMainRedBag = 15,--主界面能显示红包的等级
	chat_world = 40,
}

res.audio = {
	
}
res.ttf={
	"res/fonts/FZDHTJW.TTF"
}
--屏蔽主界面按钮
res.stop = false
--[[{

	Button_9_3 = true , --成就
	Button_activity = true ,--好友
}]]--
--屏蔽版署服版本
res.banshu = false

--创建公会
res.gonghui = {
	--3个公会图片
	img = { 
		"res/itemicon/gonghui1.png",
		"res/itemicon/gonghui2.png",
		"res/itemicon/gonghui3.png",
	},
	cost_jb = 100 --消耗的金币
}

--数码兽形态大小 4星以上
res.card={
	--formationScale = 1.0 ,--队形界面 就是有6个装备框那个界面
	formationScale = {
		["7"] = {1.1,1.2,1.2,1.2}, --7星数码兽放大倍数
			["6"] = {1.0,1.1,1.2,1.2} ,--6星数码兽放大倍数
			["5"] = {0.9,1.0,1.1,1.2} ,--5星数码兽放大倍数
			["4"] = {1,1,1,1} ,--4星数码兽放大倍数
			["3"] = {1,1,1,1} ,--3星数码兽放大倍数
			["2"] = {1,1,1,1} ,--2星数码兽放大倍数
			["1"] = {1,1,1,1} ,--1星数码兽放大倍数
	},

	digScale = {
		["7"] = {0.7,0.7,0.7,0.7}, --7星数码兽放大倍数
		["6"] = {0.7,0.7,0.7,0.7} ,--6星数码兽放大倍数
		["5"] = {0.7,0.7,0.7,0.7} ,--5星数码兽放大倍数
		["4"] = {0.7,0.7,0.7,0.7} ,--4星数码兽放大倍数
		["3"] = {0.7,0.7,0.7,0.7} ,--3星数码兽放大倍数
		["2"] = {0.7,0.7,0.7,0.7} ,--2星数码兽放大倍数
		["1"] = {0.7,0.7,0.7,0.7} ,--1星数码兽放大倍数
	},


	petdetail = 0.55 ,--数码兽详细信息界
	buzhen = { -- 布阵界面数码兽大小
		["7"] = 0.8, --7星数码兽放大倍数
		["6"] = 0.7 ,--6星数码兽放大倍数
		["5"] = 0.6 ,--5星数码兽放大倍数
		["4"] = 0.6 ,--4星数码兽放大倍数
		["3"] = 0.6 ,--3星数码兽放大倍数
		["2"] = 0.6 ,--2星数码兽放大倍数
		["1"] = 0.6 ,--1星数码兽放大倍数
	},
	--数码兽升级
	jinghua = {
		["7"] = 0.6, --7星数码兽放大倍数
		["6"] = 0.6 ,--6星数码兽放大倍数
		["5"] = 0.6 ,--5星数码兽放大倍数
		["4"] = 0.6 ,--4星数码兽放大倍数
		["3"] = 0.6 ,--3星数码兽放大倍数
		["2"] = 0.6 ,--2星数码兽放大倍数
		["1"] = 0.6 ,--1星数码兽放大倍数
	},
	--数码兽抽奖获得
	choujiang = {
		["7"] = 0.6, --7星数码兽放大倍数
		["6"] = 0.6 ,--6星数码兽放大倍数
		["5"] = 0.6 ,--5星数码兽放大倍数
		["4"] = 0.6 ,--4星数码兽放大倍数
		["3"] = 0.6 ,--3星数码兽放大倍数
		["2"] = 0.6 ,--2星数码兽放大倍数
		["1"] = 0.6 ,--1星数码兽放大倍数
	},
	--战斗
	fight = {
			["7"] = {0.7,0.8,0.8,0.8}, --7星数码兽放大倍数
			["6"] = {0.6,0.7,0.8,0.8} ,--6星数码兽放大倍数
			["5"] = {0.5,0.6,0.7,0.8} ,--5星数码兽放大倍数
			["4"] = {0.5,0.5,0.5,0.5} ,--4星数码兽放大倍数
			["3"] = {0.5,0.5,0.5,0.5} ,--3星数码兽放大倍数
			["2"] = {0.5,0.5,0.5,0.5} ,--2星数码兽放大倍数
			["1"] = {0.5,0.5,0.5,0.5} ,--1星数码兽放大倍数
	},
	--副本
	copy = {
			["7"] = {0.6,0.6,0.6,0.6}, --7星数码兽放大倍数
			["6"] = {0.6,0.6,0.6,0.6} ,--6星数码兽放大倍数
			["5"] = {0.5,0.6,0.6,0.6} ,--5星数码兽放大倍数
			["4"] = {0.5,0.5,0.5,0.5} ,--4星数码兽放大倍数
			["3"] = {0.5,0.5,0.5,0.5} ,--3星数码兽放大倍数
			["2"] = {0.5,0.5,0.5,0.5} ,--2星数码兽放大倍数
			["1"] = {0.5,0.5,0.5,0.5} ,--1星数码兽放大倍数
	},
}

res.video={
	TUPO = "shumashou.mp4",
}

res.conf = {
	ITEM=require("res.conf.item"),
	BASE_PROPERTY=require("res.conf.base_property"),
	HEAD = require("res.conf.head"),
	CARD=require("res.conf.card"),
	SKILL_CONFIG=require("res.conf.skill_config"),
	EFFECT_CONFIG=require("res.conf.effect_config"),
	SHOP = require("res.conf.shop_vip_item"),
	COPY = require("res.conf.copy_config"),
}

res.skeleton = {
	
}

res.views = {
		ui = {
			Login = "LoginView",
			Loading = "LoadingView",
			main = "MainView",
			game="GameView",
			debug="DeBugView",
			test_tips="TipsView",
		},
}
res.font={
	NEWRED = {
		"res/views/ui_res/imagefont/font_newred2.png",
		"res/views/ui_res/imagefont/font_newred3.png",
	},
	CAIPIAO = {
		"res/views/ui_res/imagefont/font_benqi.png",
		"res/views/ui_res/imagefont/font_shqngqi.png",
		"res/views/ui_res/imagefont/font_benqi_num.png",
		"res/views/ui_res/imagefont/font_shqngqi_num.png",
	},
	_NEWBAG_2 = "res/views/ui_res/imagefont/font_newbag_2.png",
	_NEWBAG_5 = "res/views/ui_res/imagefont/font_newbag_5.png",
	_NEWBAG_4 = "res/views/ui_res/imagefont/font_newbag_4.png",
	_100RMB_E = "res/views/ui_res/imagefont/font_100_3.png",
	_100RMB_E_1 = "res/views/ui_res/imagefont/font_100_4.png",
	CAHNGE_NAME = {
		"res/views/ui_res/imagefont/font_gai_02.png",
		"res/views/ui_res/imagefont/font_gai_01.png",
	},

	RUNE_PRO = "res/views/ui_res/imagefont/font_rune_6.png",
	CROSS_CH = "res/views/ui_res/imagefont/font_cross_18.png",
	CROSS_CH_LAB = "res/views/ui_res/imagefont/font_cross_17.png",
	TIANFU_7S = "res/views/ui_res/imagefont/font_7s_05.png", --月卡 
	MONYH_CARD =  "res/views/ui_res/imagefont/font_month_6.png", --月卡
	MONYH_ALL_CARD =  "res/views/ui_res/imagefont/font_month_7.png", --终生卡
	DAYFUBEN = {
		"res/views/ui_res/imagefont/font_dayfuben_01.png", --X2
		"res/views/ui_res/imagefont/font_dayfuben_02.png", --X2
		"res/views/ui_res/imagefont/font_dayfuben_03.png", --X2
		"res/views/ui_res/imagefont/font_dayfuben_04.png", --X2
		"res/views/ui_res/imagefont/font_dayfuben_05.png", --X2
	},--日常副本难度选择

	FW = {
		[102] = "res/views/ui_res/imagefont/pack_font/font_atk.png", --1 攻击
		[105] = "res/views/ui_res/imagefont/pack_font/font_hp.png", --2 --血
		[103] = "res/views/ui_res/imagefont/pack_font/font_def.png", --3 --
		[116] = "res/views/ui_res/imagefont/pack_font/font_pojia.png", --4
		[106] = "res/views/ui_res/imagefont/pack_font/font_crit.png", --5
		[108] = "res/views/ui_res/imagefont/pack_font/font_jr.png", --6
		[110] = "res/views/ui_res/imagefont/pack_font/font_mz.png", --7
		[109] = "res/views/ui_res/imagefont/pack_font/font_sb.png", --8
		[119] = "res/views/ui_res/imagefont/pack_font/font_gedang.png", --9
		[120] = "res/views/ui_res/imagefont/pack_font/font_poji.png", --10
		[121] = "res/views/ui_res/imagefont/pack_font/font_gdjm.png", --11
		[122] = "res/views/ui_res/imagefont/pack_font/font_nqsh.png", --12
		[123] = "res/views/ui_res/imagefont/pack_font/font_nqjm.png", --13
		[124] = "res/views/ui_res/imagefont/pack_font/font_pjsh.png", --14
		[125] = "res/views/ui_res/imagefont/pack_font/font_bsjm.png", --15
		[107] = "res/views/ui_res/imagefont/pack_font/font_crit_sh.png", --15

		
		[202] = "res/views/ui_res/imagefont/pack_font/font_atk.png", --9 
		[205] ="res/views/ui_res/imagefont/pack_font/font_hp.png", --10
		[203] ="res/views/ui_res/imagefont/pack_font/font_def.png", --11
		[216] = "res/views/ui_res/imagefont/pack_font/font_rune_3.png", --4
		[206] ="res/views/ui_res/imagefont/pack_font/font_crit.png", --12
		[208] ="res/views/ui_res/imagefont/pack_font/font_jr.png", --13
		[210] ="res/views/ui_res/imagefont/pack_font/font_mz.png", --14
		[209] ="res/views/ui_res/imagefont/pack_font/font_sb.png", --15
	},
	

	CAMP14 = "res/views/ui_res/imagefont/font_camp_14.png", --胜
	CAMP15 = "res/views/ui_res/imagefont/font_camp_15.png", --负

	CAMP5 = "res/views/ui_res/imagefont/font_camp_5.png",
	CAMP13 = "res/views/ui_res/imagefont/font_camp_13.png",
	CAMP7 = "res/views/ui_res/imagefont/font_camp7.png",
	CAMP8 = "res/views/ui_res/imagefont/font_camp8.png",

	COMPOSE_HE = "res/views/ui_res/imagefont/rand_compose.png",
	COMPOSE_JIANG = "res/views/ui_res/imagefont/font_jiang_xin.png",

	ADV_BAOJI ={
		"res/views/ui_res/imagefont/baoji_00005.png", --X2
		"res/views/ui_res/imagefont/baoji_00006.png", --X4
		"res/views/ui_res/imagefont/baoji_00007.png", --X8
	},

	FIGHR_OVER = "res/views/ui_res/imagefont/ZHANDOUJIESHUZITI1.png", --战斗结束
	FUCHOU = "res/views/ui_res/imagefont/font_dig_fuchou.png", 
	FRIEND = "res/views/ui_res/imagefont/font_dig_haoyou_yaoqing.png",

	DOUBLE_11 = {
		"res/views/ui_res/imagefont/icon_11_a1.png",
		"res/views/ui_res/imagefont/icon_11_a2.png",
		"res/views/ui_res/imagefont/icon_11_a3.png",
	},
	
	GETDONE =  "res/views/ui_res/imagefont/font_11_qu.png", -- 已领取
	FIGHT_DEC = {
		"res/views/ui_res/imagefont/JIESUANCANBAI1.png", -- 惨败1
		"res/views/ui_res/imagefont/JIESUANXIBAI1.png", -- 惜败2
		"res/views/ui_res/imagefont/JIESUANSHENGLI1.png", -- 胜利3
		"res/views/ui_res/imagefont/JIESUANWANSHENG1.png", --完胜4
		"res/views/ui_res/imagefont/JIESUANXIANSHENG1.png", -- 险胜5
		"res/views/ui_res/imagefont/JIESUANSHENJIDAO1.png", -- 升级到	6
		"res/views/ui_res/imagefont/JIESUANWANBAI1.png", -- 完败	7
	},


	DIG_DAO = {
		"res/views/ui_res/imagefont/font_dig_csc.png", -- 创世村
		"res/views/ui_res/imagefont/font_dig_gongchang.png", --工厂
		"res/views/ui_res/imagefont/font_dig_wjc.png", --玩具城
		"res/views/ui_res/imagefont/font_dig_mlsl.png", --迷乱森林
		"res/views/ui_res/imagefont/font_dig_lddd.png", --冷冻大地
		"res/views/ui_res/imagefont/font_dig_gudai.png", --古代
	},
	DIG_XIA_JIE = "res/views/ui_res/imagefont/font_xiajieudan.png",
	DIG_LEIJI = "res/views/ui_res/imagefont/font_dig_leiji.png",
	DIG_TYPE = {
		"res/views/ui_res/imagefont/font_dig_jb.png", --古代
		"res/views/ui_res/imagefont/font_dig_zuanshi.png", --古代
		"res/views/ui_res/imagefont/font_dig_hz.png", --古代
	},

	VIP_DEC = {
		"res/views/ui_res/imagefont/font_vip_dec1.png",
		"res/views/ui_res/imagefont/font_vip_dec2.png",
		"res/views/ui_res/imagefont/font_vip_dec3.png",
	},

	DIANZHAN = {
		"res/views/ui_res/imagefont/font_dianzhan.png",
		"res/views/ui_res/imagefont/font_yidianzhan.png",
	},

	YIDOUZHU = "res/views/ui_res/imagefont/font_douzhu.png",
	WIN = "res/views/ui_res/imagefont/font_win.png",
	LOSE = "res/views/ui_res/imagefont/font_lose.png",
	WANCHENG = "res/views/ui_res/imagefont/font_achiwancheng.png",

	YAZHU = "res/views/ui_res/imagefont/font_ya.png",
	HAVEDONE =  "res/views/ui_res/imagefont/font_over.png",
	CISHU = "res/views/ui_res/imagefont/font_huifucishu.png",

	HP="res/views/ui_res/imagefont/pack_font/font_hp.png",
	ATK="res/views/ui_res/imagefont/pack_font/font_atk.png",
	DEF="res/views/ui_res/imagefont/pack_font/font_def.png",
	CRIT="res/views/ui_res/imagefont/pack_font/font_crit.png",
	--暴击伤害
	CRIT_SH="res/views/ui_res/imagefont/pack_font/font_crit_sh.png",
	--坚忍
	JR="res/views/ui_res/imagefont/pack_font/font_jr.png",
	--命中
	MZ="res/views/ui_res/imagefont/pack_font/font_mz.png",
	--闪避
	SB="res/views/ui_res/imagefont/pack_font/font_sb.png",
	--抗暴
	--DEFCRIT="res/views/ui_res/imagefont/pack_font/font_sb.png",
	--红色的减号
	REDUCE = "res/views/ui_res/imagefont/jianhao.png",
	--绿色的+号
	PLUS = "res/views/ui_res/imagefont/jiahao.png",
	--等级
	DEC_LV = "res/views/ui_res/imagefont/selectsprite_font/font_lv.png",


	ADV ={
		"res/views/ui_res/imagefont/other_x2.png", --x2
		"res/views/ui_res/imagefont/other_x4.png", --x4
		"res/views/ui_res/imagefont/other_x3.png", --x3
	},

	VIP={
	"res/views/ui_res/imagefont/V1.png", --1
	"res/views/ui_res/imagefont/V2.png", --1
	"res/views/ui_res/imagefont/V3.png", --1
	"res/views/ui_res/imagefont/V4.png", --1
	"res/views/ui_res/imagefont/V5.png", --1
	"res/views/ui_res/imagefont/V6.png", --1
	"res/views/ui_res/imagefont/V7.png", --1
	"res/views/ui_res/imagefont/V8.png", --1
	"res/views/ui_res/imagefont/V9.png", --1
	"res/views/ui_res/imagefont/V10.png", --1
	"res/views/ui_res/imagefont/V11.png", --1
	"res/views/ui_res/imagefont/V12.png", --1
	"res/views/ui_res/imagefont/V13.png", --1
	"res/views/ui_res/imagefont/V14.png", --1
	"res/views/ui_res/imagefont/V15.png", --1
	"res/views/ui_res/imagefont/V16.png", --1
	"res/views/ui_res/imagefont/V17.png", --1
	--[["res/views/ui_res/imagefont/font_vip_0.png", --vip白
	"res/views/ui_res/imagefont/font_vip_1.png", --vip绿
	"res/views/ui_res/imagefont/font_vip_2.png", --vip蓝
	"res/views/ui_res/imagefont/font_vip_3.png", --vip紫
	"res/views/ui_res/imagefont/font_vip_4.png", --vip橙]]--
	},
	NUM={
	"res/views/ui_res/imagefont/font_vip_num_0.png", --vip白
	"res/views/ui_res/imagefont/font_vip_num_1.png", --vip绿
	"res/views/ui_res/imagefont/font_vip_num_2.png", --vip蓝
	"res/views/ui_res/imagefont/font_vip_num_3.png", --vip紫
	"res/views/ui_res/imagefont/font_vip_num_4.png", --vip橙
	},
	MESSAGE={
	"res/views/ui_res/imagefont/selectsprite_font/font_4.png", --亲密
	"res/views/ui_res/imagefont/selectsprite_font/font_5.png", --天赋
	"res/views/ui_res/imagefont/font_7s_04.png", --天赋
	"res/views/ui_res/imagefont/selectsprite_font/font_skill.png", --技能
	},
	LUCKY = {
		"res/views/ui_res/imagefont/other_x2.png", --x2
		"res/views/ui_res/imagefont/other_x3.png", --x3
		"res/views/ui_res/imagefont/other_x4.png", --x4
	},
	DEVOUR = {
		"res/views/ui_res/imagefont/font_jinghua.png",
	},
	FLOAT_NUM = {
        "res/views/ui_res/imagefont/fight_float_num_a.png",--1
        "res/views/ui_res/imagefont/fight_float_num_b.png",--2
        "res/views/ui_res/imagefont/fight_float_num_c.png",--3
        "res/views/ui_res/imagefont/fight_float_num_d.png",--4
        "res/views/ui_res/imagefont/fight_float_num_e.png",--5
        "res/views/ui_res/imagefont/fight_float_num_f.png",--6
        "res/views/ui_res/imagefont/fight_float_num_i.png",--7
        "res/views/ui_res/imagefont/fight_float_num_o.png",--8
	},

	EQUIPQH_DEC = "res/views/ui_res/imagefont/fnt_e_strong.png",
	EQUIPQH = {
		"res/views/ui_res/imagefont/equipx1.png",
		"res/views/ui_res/imagefont/equipx2.png",
		"res/views/ui_res/imagefont/equipx3.png",
		"res/views/ui_res/imagefont/equipx4.png",
		"res/views/ui_res/imagefont/equipx5.png",
	},
	PET={
		BADASHOU = {
			"res/views/ui_res/imagefont/font_pet1_00.png",
			"res/views/ui_res/imagefont/font_pet1_01.png",
			"res/views/ui_res/imagefont/font_pet1_02.png",
			
		},
		JIABUSHOU = {
			"res/views/ui_res/imagefont/font_pet2_00.png",
			"res/views/ui_res/imagefont/font_pet2_01.png",
			"res/views/ui_res/imagefont/font_pet2_02.png",
		},
		YAGUSHOU = {
			"res/views/ui_res/imagefont/font_pet3_00.png",
			"res/views/ui_res/imagefont/font_pet3_01.png",
			"res/views/ui_res/imagefont/font_pet3_02.png",
		},
	},
	--服务器转态
	LOGIN_TYPE = {
		"res/views/ui_res/imagefont/font_xin.png",--新服
		"res/views/ui_res/imagefont/font_baoman.png",--爆满
		"res/views/ui_res/imagefont/font_weihu.png",----维护
		"res/views/ui_res/imagefont/font_weihu.png",--维护
	},

	XIANGZI = {
		"res/views/ui_res/imagefont/font_tongbaoxiang.png",--铜
		"res/views/ui_res/imagefont/font_tibaoxiang.png",--铁
		"res/views/ui_res/imagefont/font_yingbaixoang.png",--银
		"res/views/ui_res/imagefont/font_jinbaoxiang.png",--金
	},
	FUBENSUO = "res/views/ui_res/imagefont/font_weijiesuo.png",--未解锁

		--
	GETFONT = {
		WDC = "res/views/ui_res/imagefont/font_guild_wdc.png", --未达成
		YWC = "res/views/ui_res/imagefont/font_guild_ydc.png", --已领取
	},	
	CONTESTVIEW = {
		--"res/views/ui_res/imagefont/font_banjuesai.png", --小组赛
		"res/views/ui_res/imagefont/font_banjuesai.png", --4强
		"res/views/ui_res/imagefont/font_jueshai.png", --决赛
	},	
	CONTEST_BAOMING = {
		"res/views/ui_res/imagefont/font_baoming.png",
		"res/views/ui_res/imagefont/font_yibaoming.png",
	},

	RED_BAG_ICON = {
		"res/views/ui_res/imagefont/redbag_quanfu.png",
		"res/views/ui_res/imagefont/redbag_gonghui.png",
	},
	XUNSHOUSHIWANG = "res/views/ui_res/imagefont/xunsoushi.png",
	

}
res.other={
	OTER_JIAN = "res/views/ui_res/other/other_bar_04.png",
	BOSS_BAR = {
		"res/views/ui_res/other/other_boss_1.png",
		"res/views/ui_res/other/other_boss_2.png",
	},

	JIAHAO = "res/views/ui_res/other/other_add.png",

	CROSS_XIAN_OLD = {
		"res/views/ui_res/other/other_cross_6_1.png",
		"res/views/ui_res/other/other_cross_6_2.png",
		"res/views/ui_res/other/other_cross_6_3.png",
	},

	CROSS_XIAN ={
		"res/views/ui_res/other/other_cross_7_1.png",
		"res/views/ui_res/other/other_cross_7_2.png",
		"res/views/ui_res/other/other_cross_7_3.png",
	},

	RUNE_PRO = "res/views/ui_res/other/fenghangxian.png",
	SUO = "res/views/ui_res/other/other_suo.png",
	OTHER_HUANXIAN = "res/views/ui_res/other/other_qiangliao03.png",

	TISHI = "res/views/ui_res/bg/bg_tishi.png",
	PLUS = "res/views/ui_res/button/btn_hechenadd.png",
	WENHAO = "res/views/ui_res/button/btn_hechenwenhao.png",

	goutp = {
		"res/views/ui_res/other/other_check03.png",
		"res/views/ui_res/other/other_check02.png",
		"res/views/ui_res/other/other_check04.png",
	},
	CONTEST_WENHAO = {
		"res/views/ui_res/other/other_wenhua.png",
		"res/views/ui_res/other/other_wenwu.png",
	},
	JIANTOU = "res/views/ui_res/other/jiantou1.png",

	NUMBER = {
		"res/views/ui_res/other/number1.png",
		"res/views/ui_res/other/number2.png",
		"res/views/ui_res/other/number3.png",
		"res/views/ui_res/other/number4.png",
		"res/views/ui_res/other/number5.png",
		"res/views/ui_res/other/number6.png",
		"res/views/ui_res/other/number7.png",
		"res/views/ui_res/other/number8.png",
		"res/views/ui_res/other/number9.png",
		"res/views/ui_res/other/number0.png",
	},

	NUMBER_LV = {
		"res/views/ui_res/other/shengjishuzi1.png",
		"res/views/ui_res/other/shengjishuzi2.png",
		"res/views/ui_res/other/shengjishuzi3.png",
		"res/views/ui_res/other/shengjishuzi4.png",
		"res/views/ui_res/other/shengjishuzi5.png",
		"res/views/ui_res/other/shengjishuzi6.png",
		"res/views/ui_res/other/shengjishuzi7.png",
		"res/views/ui_res/other/shengjishuzi8.png",
		"res/views/ui_res/other/shengjishuzi9.png",
		"res/views/ui_res/other/shengjishuzi0.png",
	},

}
res.icon={
	BOSSMAIN = "res/views/ui_res/icon/icon_boss_main.png",
	DW_ICON = {
		"res/views/ui_res/icon/icon_dw_1.png",--英勇黄铜1
		"res/views/ui_res/icon/icon_dw_2.png",--英勇黄铜2
		"res/views/ui_res/icon/icon_dw_3.png",--英勇黄铜3
		"res/views/ui_res/icon/icon_dw_4.png",--英勇黄铜4
		"res/views/ui_res/icon/icon_dw_5.png",--英勇黄铜5
		"res/views/ui_res/icon/icon_dw_6.png",--不屈白银1
		"res/views/ui_res/icon/icon_dw_7.png",--不屈白银2
		"res/views/ui_res/icon/icon_dw_8.png",--不屈白银3
		"res/views/ui_res/icon/icon_dw_9.png",--不屈白银4
		"res/views/ui_res/icon/icon_dw_10.png",--不屈白银5
		"res/views/ui_res/icon/icon_dw_11.png",--荣耀黄金1
		"res/views/ui_res/icon/icon_dw_12.png",--荣耀黄金2b
		"res/views/ui_res/icon/icon_dw_13.png",--荣耀黄金3
		"res/views/ui_res/icon/icon_dw_14.png",--荣耀黄金4
		"res/views/ui_res/icon/icon_dw_15.png",--荣耀黄金5
		"res/views/ui_res/icon/icon_dw_16.png",--璀璨钻石1
		"res/views/ui_res/icon/icon_dw_17.png",--璀璨钻石2
		"res/views/ui_res/icon/icon_dw_18.png",--璀璨钻石3
		"res/views/ui_res/icon/icon_dw_19.png",--璀璨钻石4
		"res/views/ui_res/icon/icon_dw_20.png",--璀璨钻石5
		"res/views/ui_res/icon/icon_dw_21.png",--华贵白金1
		"res/views/ui_res/icon/icon_dw_22.png",--华贵白金2
		"res/views/ui_res/icon/icon_dw_23.png",--华贵白金3
		"res/views/ui_res/icon/icon_dw_24.png",--华贵白金4
		"res/views/ui_res/icon/icon_dw_25.png",--华贵白金5
		"res/views/ui_res/icon/icon_dw_26.png",--超凡大师
		"res/views/ui_res/icon/icon_dw_27.png",--最强王者
	},

	DW = {
		"res/views/ui_res/icon/icon_cross8.png",--英勇黄铜
		"res/views/ui_res/icon/icon_cross2.png",--不屈白银
		"res/views/ui_res/icon/icon_cross5.png",--荣耀黄金
		"res/views/ui_res/icon/icon_cross4.png",--华贵白金
		"res/views/ui_res/icon/icon_cross3.png",--璀璨钻石
		"res/views/ui_res/icon/icon_cross13.png",--璀璨钻石
		"res/views/ui_res/icon/icon_cross9.png",--最强王者
	},

	ZHUAN = {
		"res/views/ui_res/icon/icon_1zhuan.png",
	},
	ZHUANFRAME = {
		"res/views/ui_res/icon/icon_1frmae.png",
	},


	CAMP_MIAN = "res/views/ui_res/icon/icon_camp.png",
	
	CONTEST_WIN_ROLE = {
		"res/views/ui_res/icon/icon_win_nan.png",
		"res/views/ui_res/icon/icon_win_nv.png",
	},
	CONTEST_SHOP_ZHE = {
		"res/views/ui_res/icon/shop_icon/icon_5z.png",
		"res/views/ui_res/icon/shop_icon/icon_6z.png",
		"res/views/ui_res/icon/shop_icon/icon_7z.png",
		"res/views/ui_res/icon/shop_icon/icon_8z.png",
		--"res/views/ui_res/icon/shop_icon/font_lucky_9zhen.png",
		"res/views/ui_res/imagefont/font_lucky_9zhen.png",
	},

	DIG_BOOS = { 
		["11"] = "res/views/ui_res/icon/icon_dig_boss_1.png",
		["12"] = "res/views/ui_res/icon/icon_dig_boss_2.png",
		["13"] = "res/views/ui_res/icon/icon_dig_boss_3.png",
		["14"] = "res/views/ui_res/icon/icon_dig_boss_4.png",
	},

	DIG_ZIYUAN = {
		"res/views/ui_res/icon/icon_dig_jb.png",
		"res/views/ui_res/icon/icon_dig_zs.png",
		"res/views/ui_res/icon/icon_dig_hz.png",
	},

	VIP_LV={
		"res/views/ui_res/icon/icon_vip1.png",
		"res/views/ui_res/icon/icon_vip2.png",
		"res/views/ui_res/icon/icon_vip3.png",
		"res/views/ui_res/icon/icon_vip4.png",
		"res/views/ui_res/icon/icon_vip5.png",
		"res/views/ui_res/icon/icon_vip6.png",
		"res/views/ui_res/icon/icon_vip7.png",
		"res/views/ui_res/icon/icon_vip8.png",
		"res/views/ui_res/icon/icon_vip9.png",
		"res/views/ui_res/icon/icon_vip10.png",
		"res/views/ui_res/icon/icon_vip11.png",
		"res/views/ui_res/icon/icon_vip12.png",
		"res/views/ui_res/icon/icon_vip13.png",
		"res/views/ui_res/icon/icon_vip14.png",
		"res/views/ui_res/icon/icon_vip15.png",
		"res/views/ui_res/icon/icon_vip16.png",
		"res/views/ui_res/icon/icon_vip17.png",
	},
	PACK = {
		wear = "res/views/ui_res/icon/pack_icon/icon_wear.png",
		play = "res/views/ui_res/icon/pack_icon/icon_play.png",
		xiaohuoban = "res/views/ui_res/icon/pack_icon/icon_xiaohuoban.png",
	},
	LOGIN = {
		--亚古兽
		YAGUSHOU = "res/views/ui_res/icon/other_login_01.png",
		--加部首
		JIABUSHOU = "res/views/ui_res/icon/other_login_02.png",
		--把大手
		BADASHOU = "res/views/ui_res/icon/other_login_03.png",
	},
    BAOXIANG1 = "res/views/ui_res/icon/icon_baoxiang_4.png",
    BAOXIANG2 = "res/views/ui_res/icon/icon_baoxiang3.png",
    ROLE_ICON = {
    	BOY = "res/views/ui_res/icon/icon_role_yuanman.png",
    	GRIL = "res/views/ui_res/icon/icon_role_yuanGril.png",
	},
	FUBENSUO = "res/views/ui_res/icon/icon_suo.png",
	GUILD_LV_DI = "res/views/ui_res/icon/icon_gonghui.png",--公会等级低
	RANK = {
		"res/views/ui_res/icon/icon_rank1.png",
		"res/views/ui_res/icon/icon_rank2.png",
		"res/views/ui_res/icon/icon_rank3.png",
	},
	GONGXIANIOCN = "res/views/ui_res/icon/icon4.png",

	OPENXIANGZI = {
		"res/views/ui_res/icon/icon_opne1.png",
		"res/views/ui_res/icon/icon_opne2.png",
		"res/views/ui_res/icon/icon_opne3.png",
		"res/views/ui_res/icon/icon_opne4.png",
	},

	GIFT_VIP = {
	 V2 = "res/views/ui_res/icon/icon_gift_vip2.png",
	 V3 ="res/views/ui_res/icon/icon_gift_vip3.png",
	},
	ZS = "res/views/ui_res/icon/gl_zuanshi.png",
}
res.image={
	BOSS_IMAGE = "res/views/ui_res/bg/bg_boss_4.png",
	TITLE_DI = "res/views/ui_res/bg/bg_titile_low.png",
	CAMP_BG_LEFT1 = "res/views/ui_res/bg/bg_camp_zy.png",
	CAMP_BG_LEFT2 = "res/views/ui_res/bg/bg_camp_emo.png",

	bg_a11 = "res/views/ui_res/bg/bg_11_02.png",

	ROLE_BG = {
		"res/views/ui_res/bg/plot_role_1.png",
		"res/views/ui_res/bg/plot_role_0.png",
	},

	DAO = {
		"res/views/ui_res/bg/bg_dig_yuling.png",
		"res/views/ui_res/bg/bg_dig_gumu.png",
		"res/views/ui_res/bg/bg_dig_feixu.png",
		"res/views/ui_res/bg/bg_dig_shangf.png",
		"res/views/ui_res/bg/bg_dig_shidi.png",
		"res/views/ui_res/bg/bg_dig_shang.png",
		"res/views/ui_res/bg/bg_dig_chengbao.png",
	}  ,

	LONGDI =  "res/views/ui_res/bg/long_di.png",

	RED_PONT="res/views/ui_res/other/pack_other/other_redpoint.png",                 --红点
	STAR="res/views/ui_res/other/other_star.png",--星星
	GOLD = "res/views/ui_res/icon/figure_icon/icon_gold.png", --金币
	BADGE= "res/views/ui_res/icon/figure_icon/icon_badge.png", --徽章
	ZS = "res/views/ui_res/icon/figure_icon/icon_zs.png", -- 砖石
	SH = "res/views/ui_res/icon/figure_icon/icon_sh.png", -- 神魂
	PLAYER_BG = "res/views/ui_res/bg/player_bg.png",  --玩家底座
	PLAYER_SHADOW = "res/views/ui_res/other/player_shadow.png", --玩家影子
	TUIJIANDENGJI = "res/views/ui_res/imagefont/tuijiandengji.png", --
	EXP = "res/views/ui_res/other/other_exp.png", --EXP
	BG={
	--工厂背景
	"res/views/ui_res/bg/bg_qianghua.png",
	"res/views/ui_res/bg/bg_qh.png",
	},
	--
	ROLE_BOY = "res/views/ui_res/bg/jjc_rw_m.png",
	ROLE_GRILS = "res/views/ui_res/bg/jjc_rw_w.png",
	ROLE_EDIBOX = "res/views/ui_res/bg/bg_tanxian.png",
	--[[BG_FUBEN = {
		JJC = "res/views/ui_res/bg/bg_arean.png", --竞技场
		SMDS = "res/views/ui_res/bg/bg_shuadashang.png", --数码大赛
		WJSY = "res/views/ui_res/bg/bg_wujing.png", --无尽
	}]]--

	BG_BAOLONGJI = "res/views/ui_res/bg/bg_baolongji.png",
	TRANSPARENT =  "res/views/ui_res/bg/bg_Transparent.png", --一个透明的点 拉伸做edibox
	LOGIN_BG = {
		TOP = "res/views/ui_res/bg/bg_game_1.png",
		CENTER = "res/views/ui_res/bg/bg_game_2.png",
		BOTTOM = "res/views/ui_res/bg/bg_game_3.png",
	},
	SPEAK = "res/views/ui_res/bg/speak_bg.png",
	CONTEST_ROLE = {
		"res/views/ui_res/bg/bg_jianying_boy.png",
		"res/views/ui_res/bg/bg_jianying_boy_wu.png",
		"res/views/ui_res/bg/bg_jianying_gril.png",
		"res/views/ui_res/bg/bg_jianying_gril_wu.png",
	},
	CONTEST_DIZUO = {
		"res/views/ui_res/bg/bg_tai_hua.png",
		"res/views/ui_res/bg/bg_tai_lan.png",
		"res/views/ui_res/bg/bg_tai_jin.png",
	},
	CONTEST_GUANG = {
		"res/views/ui_res/bg/bg_di_lan.png",
		"res/views/ui_res/bg/bg_di_huang.png",
	},	
	TASK_TISHI_BG = "res/views/ui_res/bg/pack_bg/bg_1.png",  
	
}

--
res.btn={
	LUXIANG = "res/views/ui_res/button/other_cross_2.png",
	JINGCAI = "res/views/ui_res/button/btn_cross_4.png",
	COMPOSE_HE = "res/views/ui_res/button/btn_compose.png",
	COMPOSE_JIANG = "res/views/ui_res/button/btn_jiangxin.png",

	LOGIN_BTN = {
		"res/views/ui_res/button/btn_login_01.png",
		"res/views/ui_res/button/btn_login_02.png",
	},

	DIG_FUCHOU = "res/views/ui_res/button/btn_dig_fuchou.png",
	DIG_COMPARE = "res/views/ui_res/button/btn_compare.png",

	DIG_JIUYUAN = "res/views/ui_res/button/btn_dig_jiuyuan.png",
	DIG_JIUYUAN_ASK = "res/views/ui_res/button/btn_dig_jiuyuan_ask.png",
	TEST_UP = "res/views/ui_res/button/button.png",
	--主界面通用按钮(暗)
	MAIN_UNIVERSALLY_DARK="res/views/ui_res/button/btn_main_universally_down.png",
	--主界面通用按钮(亮)
	MAIN_UNIVERSALLY_BRIGHT="res/views/ui_res/button/btn_main_universally_up.png", 
	FRAME={
	"res/views/ui_res/button/btn_frame_white.png",--白
	"res/views/ui_res/button/btn_frame_green.png",--绿
	"res/views/ui_res/button/btn_frame_blue.png", --蓝
	"res/views/ui_res/button/btn_frame_purple.png",--紫
	"res/views/ui_res/button/btn_frame_orange.png",--澄
	"res/views/ui_res/button/btn_frame_red.png",--红
	"res/views/ui_res/button/btn_frame_indigo.png",--变态紫
	--"res/views/ui_res/button/btn_frame_orange.png",--深红
	},
	EQUIPMENT_FRAME = "res/views/ui_res/button/btn_frame_blue_1.png",
	BLUE_BIG="res/views/ui_res/button/btn_blue_big.png",
	BLUE="res/views/ui_res/button/btn_blue.png",
	YELLOW = "res/views/ui_res/button/btn_yellow.png",
    FIGHT_MUL_BG = "res/views/ui_res/button/fight_fast_btn.png",
    FIGHT_MUL_1 = "res/views/ui_res/button/fight_mult_1.png",
    FIGHT_MUL_2 = "res/views/ui_res/button/fight_mult_2.png",
    FIGHT_MUL_3 = "res/views/ui_res/button/fight_mult_3.png",
    SELECT_BTN = "res/views/ui_res/button/btn_select_state.png",

    ROLE_FRAME = {
		"res/views/ui_res/button/bg_rwxk1.png",
		"res/views/ui_res/button/bg_rwxk2.png",
		"res/views/ui_res/button/bg_rwxk3.png",
		"res/views/ui_res/button/bg_rwxk4.png",
		"res/views/ui_res/button/bg_rwxk5.png",
	},

    
    ISGiVEN_BTN = "res/views/ui_res/button/btn_isGive.png",----好友，已赠送
    BLUE_BTN_14 = "res/views/ui_res/button/btn_14.png",----



    FACIALICONPATH = "res/views/ui_res/icon/emotion/",--聊天表情资源路径

    DIG_BACK = "res/views/ui_res/button/btn_back_lindi.png",--回到领地
    DIG_FEIEND = "res/views/ui_res/button/btn_baihaoyou.png",----拜访好友
    
}


res.bone = {
    ["1001"] = "res/bone/1001/1001",
    ["80000"]= "res/effects/80000",
    ["80001"]= "res/effects/80001",
    ["80002"]= "res/effects/80002",
    ["80005"]= "res/effects/80005/80005",
}

res.texture = {
    ["num"] = "res/texture/num",
    ["life_bar_bg"] = "#life_bar_bg.png",
    ["life_bar"] = "#life_bar.png",
    ["pic_map_1"] = "res/maps/pic_map_4.png",
    ["chapter_map_5"] = "res/maps/chapter_map_5.png",
}

res.kjhx = {
	LISTITEM1 = {
		"res/views/ui_res/icon/kjhx_i1.png",
		"res/views/ui_res/icon/kjhx_i2.png",
		"res/views/ui_res/icon/kjhx_i3.png",
		"res/views/ui_res/icon/kjhx_i4.png",
	},
	LISTITEM2 = {
		"res/views/ui_res/icon/kjhx_ih1.png",
		"res/views/ui_res/icon/kjhx_ih2.png",
		"res/views/ui_res/icon/kjhx_ih3.png",
		"res/views/ui_res/icon/kjhx_ih4.png",
	},
	LISTITEM3 = {
		"res/views/ui_res/icon/kjhx_ib1.png",
		"res/views/ui_res/icon/kjhx_ib2.png",
		"res/views/ui_res/icon/kjhx_ib3.png",
		"res/views/ui_res/icon/kjhx_ib4.png",
	},
	LISTITEM4 = {
		"res/views/ui_res/imagefont/kjhx_title1.png",
		"res/views/ui_res/imagefont/kjhx_title2.png",
		"res/views/ui_res/imagefont/kjhx_title3.png",
		"res/views/ui_res/imagefont/kjhx_title4.png",
	},
	SUO = {
		"res/views/ui_res/other/other_kjhx1.png",
		"res/views/ui_res/other/other_kjhx2.png",
	},
	BOX = {
		"res/views/ui_res/icon/kjhx_dkbx1.png",
		"res/views/ui_res/icon/kjhx_dkbx2.png",
		"res/views/ui_res/icon/kjhx_dkbx3.png",
		"res/views/ui_res/icon/kjhx_dkbx4.png",
	},
	BOX1 = {
		"res/views/ui_res/icon/kjhx_gbbx1.png",
		"res/views/ui_res/icon/kjhx_gbbx2.png",
		"res/views/ui_res/icon/kjhx_gbbx3.png",
		"res/views/ui_res/icon/kjhx_gbbx4.png",
	},
}
--特效
res.effect={
	PACK="10000002",                 --背包特效
	LUCKY = "summonEffects",         --抽奖动画
}
--动作
res.action={
	LV_UP="10000001",                 --升级特效
}
--
res.str = {
	NO_ENOUGH_HZ = "徽章不足",
	NO_ENOUGH_JB = "金币不足",
	NO_ENOUGH_ZS = "钻石不足,是否前往充值",--钻石不够啦,快去充值吧!
	NO_ENOUGH_COUT = "次数不足",
	NO_ENOUGH_ITEM = "道具不足",

	BUY_SUCCESS = "购买成功",
	RECHARGE = "充 值",
	CLOSE = "关 闭",
	SURE = "确 定",
	CANCEL = "取 消",


	--vip礼包商店购买
	BUY_LIBAO_VIP = "花费%d钻石购买",
	BUY = "购 买",
	JUST_BUY = "已购买",

	SHOP_TIME_NEED = "时间没到不能刷新",
	SHOP_ITEM_NEED = "没有可用道具",
	SHOP_TIME_OUT = "今日刷新次数已经用完",
	SHOP_RECHARGE = "%d可成为",
	SHOP_RECHARGE_SONG = "额外赠送",
	SHOP_SUCCESS= "刷新成功",
	SHOP_DEC1= "无限",

	--money
	MONEY_JB = "金币",
	MONEY_ZS = "钻石",
	MONEY_HZ = "徽章",

	NO_ENOUGH_CHOU = "抽奖道具不足",
	NO_ENOUGH_PACK = "背包已满",

	NO_ENOUGH_COLOR = "质量不足",

	NO_ENOUGH_COMPOSE = "是否前往合成",

	PROMOTE_LAST = "最后一只不能下阵",
	PROMOTE_ENOUGH = "背包已满,不能下阵",

	PROMOTE_JINGHU = "进化+%d",
	PROMOTE_JIHUO = "突破+%d",
	PROMOTE_TOPO = "启动",
	PROMOTE_NOCARD = "你没有选择材料",
	PROMOTE_DEC6 = "不足，通关无尽深渊可获得，是否前往？",
	PROMOTE_NOCARD_DEC1 = "数码兽到顶级了",


	PROMOTE_JIN = "进化",
	PROMOTE_TU = "突破",

	PROMOTE_CARD_CLEAR = "你选择的是稀有数码兽\n确认消耗吗",

	MAILVIEW_GET = "领 取",
	MAILVIEW_GET_OVER = "已领取",
	MAILVIEW_QJJ = "去竞技",

	MAILVIEW_ARGEE = "同 意",
	MAILVIEW_REF = "拒 绝",
	MAILVIEW_MSG = "%d小时前",
	MAILVIEW_MSG_Day = "%d天前",
	MAILVIEW_MSG_NOLONG = "不久前",
	MAILVIEW_MSG_SYS = "系统奖励",
	MAILVIEW_MSG_HYXX = "好友信息",
	MAILVIEW_MSG_JJC = "竞技场",
	MAILVIEW_DEC1 = "好友已满",
	MAILVIEW_DEC2 = "查看",
	MAILVIEW_DEC3 = "已查看",
	MAILVIEW_DEC4 = "领取成功",
	MAILVIEW_DEC5 = "去设置",
	MAILVIEW_DEC6 = "回 复",
	MAILVIEW_DEC7 = "已回复",
	MAILVIEW_DEC8 = "已查看",

	PROMOTEN_DEC1 = "不能放入",
	PROMOTEN_DEC2 = "升级",
	PROMOTEN_DEC3 = "或者",
	PROMOTEN_DEC4 = "进化",
	PROMOTEN_DEC5 =  "过的数码兽,请先进行退化。",

	PROMOTEN_DEC7 =  "你将花费",
	PROMOTEN_DEC8 =  "购买",
	PROMOTEN_DEC9 =  "取 消",
	PROMOTEN_DEC10 =  "确 定",
	PROMOTEN_DEC11 =  "个",
	PROMOTEN_DEC12 =  "用于数码兽升级",
	PROMOTEN_DEC13 =  "今日不再提示",



	PACK_TUIHUA = "还 原",
	PACK_DEC1 = "获 得",
	PACK_DEC2 = "时间未到，打打副本再过来吧",
	PACK_DECS_SELL = "出 售",
	PACK_DECS_USE = "使 用",

	PACKE_MAP_TITLE = {"道具","数码兽","装备","芯片","果实材料"},


	COMPOSE_CARD = "不能放入升级或者进化过的数码\n兽",

	COMPOSE_EQUIP_DEC2 = "过的装备请先还原。",

	COMPOSE_EQUIP = "不能放入强化或者精炼过的装备\n请先还原。",
	COMPOSE_CARD_SURE = "退 化",
	COMPOSE_EQUIP_SURE = "还 原",

	ACHIEVEME_GOTO = "前 往",

	ADVENTURE_DEC = "主人，经过我们的不懈努力，战胜了强大的",
	ADVENTURE_DEC1 = "意外获得一个宝藏",
    ADVENTURE_VIP3 = "vip3或50级开启一键屠魔",
	ADVENTURE_WIPE = "VIP3或者60级才可以扫荡，是否提高VIP等级？",
	ADVENTURE_DEC2 = "使用",
	ADVENTURE_DEC3 = "恢复次数",
	ADVENTURE_DEC4 = "下一次恢复",
	ADVENTURE_DEC5 = "一键屠魔",
	ADVENTURE_DEC6 = "(vip3或者50级)",

	RECHARGE_PLEASE =  "首次充值任意金额，\n即可领取首充大礼包！",

	TIPS_BUYOVER = "今日购买次数已用完,充值成为更高",--"今日购买次数已用完",--今日购买次数已用完,充值成为更高
	TIPS_ZAOCAIOVER = "招财次数已达上限,充值成为更高",--"招财次数已达上限",--招财次数已达上限,充值成为更高
	ACTIVE_DEC1 = "招财次数已达上限",

	PACK_COUT = "还剩%d次",
	PACK_USE = "使    用",
	PACK_USE10 = "使用10次",
	PACK_STRENG = "强   化",
	PACK_REFINING = "精   炼",
	PACK_JINGHUA = "进   化",
	PACK_LVUP = "升   级",

	EQUIPMENT_NAME_TOU = "头盔",
	EQUIPMENT_NAME_WUQI = "武器",
	EQUIPMENT_NAME_YIFU = "铠甲",
	EQUIPMENT_NAME_PIFENG = "披风",
	EQUIPMENT_NAME_KUZI = "护腿",
	EQUIPMENT_NAME_TUTENG = "图腾",

	DEVOUR_DEC1 = "你选择的是",
	DEVOUR_DEC2 = "稀有数码兽",
	DEVOUR_DEC3 = "确认消耗吗",
	DEVOUR_DEC4 = "不能选取更多的！！",

	SPRITELV_UP_DEC1 = "主人，数码兽等级不能大于主角等级的哦~",

	SPRITELV_UP_DEC2 = "您当前没有蓝色以下质量的\n数码兽或晶体材料，无法添加",

	SPRITELV_UP_DEC3 = "主人，此数码兽已满级，不需要再升级了",

	LOGIN_CARD1 = "亚古兽",
	LOGIN_CARD2 = "加布兽",
	LOGIN_CARD3 = "巴达兽",
	LOGIN_CARD4 = "对",

	LOGIN_CARD5 = "前排",
	LOGIN_CARD6 = "后排",
	LOGIN_CARD7 = "一列",





	LOGIN_DEC1 = "虽然还在成长中力量弱小，但是性格确实相当勇猛无所惧畏",

	LOGIN_DEC_01 = "敌人造成大量火属性伤害",
	LOGIN_DEC_02 = "3个敌人造成大量光属性伤害",
	LOGIN_DEC_03 = "目标造成大量水属性伤害",
	LOGIN_DEC_04 = "输入邀请码可获得礼包",
	LOGIN_DEC_05 = "输入名字",
	LOGIN_DEC_06 = "请输入新名字",
	LOGIN_DEC_07 = "最近登录",
	LOGIN_DEC_08 = "全部服务器",
	LOGIN_DEC_09 = "点击切换",



	LOGIN_ACCCOUNT_EXIT_ROLE = "没有角色",
	LOGIN_ACCCOUNT_EXIT = "名字重复了",
	LOGIN_ACCCOUNT_EXIT_NO = "您的名字含有非法字符",
	LOGIN_ACCCOUNT_FAIL = "创建失败",

	ROLE_GONGHUI = "暂未开放，敬请期待。",
	ROLE_BUY_TILI = "体力",
	ROLE_BUY_TILI_MAX_VIP = "主人，今日购买次数已达上限！",
	ROLE_OPEN_DONE = "已开启",
	ROLE_OPEN = "%d级",
	ROLE_TILI_MAX = "满体力不需要购买",

	CARD_HERO_MAX = "卡牌升级不能大于人物等级",

	NOOPEN = "该功能未开启",

	LOGIN_BAOMAN = "爆满",
	LOGIN_WEIHU = "维护",
	
	PACK_USELIMIT = "主人，今日此道具使用次数达到上限。",
	PACK_USEFORTILI = "恭喜主人体力增加%d",
	PACK_USELFORAREAN= "恭喜主人竞技场挑战次数增加%d",
	PACK_USELADV = "恭喜主人屠魔次数增加%d",

	COLORTOOLOWER = "3星以上数码兽才可进化",
	COLORTOOLOWER2 = "3星以上数码兽才可升级",

	COLORTOOLOWEREQUIP = "3星以上装备才可精炼",

	LV20OPEN = "20级开启装备精炼",

	PRO_GONGJI = "攻击",
	PRO_HP = "生命",
	PRO_PROWER = "战斗力",
	PRO_CRIT = "暴击",
	PRO_CRITHUT = "暴击伤害",
	PRO_MINGZHONG = "命中",
	PRO_DECRIT = "坚韧",
	PRO_DODGE = "闪避",

	TUIHUA_QIANGHUA = "强化:%d",
	TUIHUA_DENGJI = "等级:%d",
	TUIHUA_SHENGMING = "生命:%d",
	TUIHUA_GONGJI = "攻击:%d",

	TUIHUA_CARD= "数码兽不能退化了",
	TUIHUA_EQUIP = "装备不能退化了",
	TUIHUA_DEC1 = "返回强化时花费",
	TUIHUA_DEC2 = "返回进化时花费",
	TUIHUA_DEC3 = "返回精炼时花费",
	TUIHUA_DEC4 = "返回突破时花费",
	TUIHUA_DEC5 = "返回升级时花费",
	TUIHUA_DEC6 = "将数码兽",
	TUIHUA_DEC7 = "将装备",
	TUIHUA_DEC8 = "退化到初始状态",


	EQUIPMENT_LOWER3QH= "3星以上装备开启强化",
	EQUIPMENT_LOWER3JL= "3星以上装备开启精炼",
	EQUIPMENT_SUIT= "件效果:",
	EQUIPMENT_MAXLV =  "强化等级达到上限!!!",
	EQUIPMENT_DEC1 = "强化等级",

	EQUIPMENT_DEC2 = "强化等级:",
	EQUIPMENT_DEC3 = "攻击:",
	EQUIPMENT_DEC4 = "生命:",
	EQUIPMENT_DEC5 = "战斗力:",
	EQUIPMENT_DEC6 = "精炼阶段:",
	EQUIPMENT_DEC7 = "强化等级",
	EQUIPMENT_DEC8 = "强化",
	EQUIPMENT_DEC9 = "精炼",
	EQUIPMENT_DEC10 = "更 换",
	EQUIPMENT_DEC11 = "同星级同部位",
	EQUIPMENT_DEC12 = "装备可当做材料",
	EQUIPMENT_DEC13 = "选 择",
	EQUIPMENT_DEC14 = "隐藏已穿戴的装备",
	EQUIPMENT_DEC15 = "装 备",
	EQUIPMENT_DEC16 = "还 原",
	EQUIPMENT_DEC17 = "物防:",
	EQUIPMENT_DEC18 = "暴击:",
	EQUIPMENT_DEC19 = "自动最大强化",
	EQUIPMENT_DEC20 = "强 化",






	MAIL_NOMOREMESSAGE = "没有更多的信息了",
	MAIN_VIEW_MESS = "暂未开放，敬请期待。",

	SYS_OPNE_LV = "%d级开启",

	ACTIVE_ZHAOCAI = "获得金币+%d",

	ADV_TANXIAN = "玩家50级开启",

	ADVDEC1 = "主人是否开启一键屠魔？",
	ZHAOCAI10CI = "你选择了招财%d次,可一键招财%d次。",

	ACHI_DEC1 = "恭喜你完成",
	ACHI_DEC2 = "成就"	,
	ACHI_DEC3 = "获得奖励",
	ACHI_DEC4 = "奖励",

	GUILD_DEC1 = "请输入公会的名字(3-7个字)",
	GUILD_DEC2 = "请输入公会名字(3-7个字)",
	GUILD_DEC3 = "点击输入公会名字",

	GUILD_DEC4 = "取消申请",
	GUILD_DEC5 = "申 请",
	GUILD_DEC6 = "任 命",
	GUILD_DEC7 = "踢 出",
	GUILD_DEC8 = "弹 劾",
	GUILD_DEC9 = "你没有权限",
	GUILD_DEC10 = "是否要踢出%s",
	GUILD_DEC11 = "该名称已使用，请重新输入",
	GUILD_DEC12 = "你输入的名字包含非法字符",
	GUILD_DEC13 = "你要弹劾的是",

	GUILD_DEC14 = "你是否把会长转让给%s",
	GUILD_DEC15 = "任命%s为副会长",
	GUILD_DEC16 = "任命%s为成员",
	GUILD_DEC17 = "已经有副会长",
	GUILD_DEC18 = "退出公会后24小时内不能加入其它公会（贡献保留）",
	GUILD_DEC19 = "研发进度不足",
	GUILD_DEC20 = "你已经领取过了",
	GUILD_DEC21 = "达到%d研发进度可以领取宝箱奖励哦",
	GUILD_DEC22 = "搜索不到此公会",
	GUILD_DEC23 = "已申请",
	GUILD_DEC24 = "是否消耗",
	GUILD_DEC25 = "研发一次",
	GUILD_DEC26 = "公会已经满员了哦",
	GUILD_DEC27 = "今天已经研发过了哦",
	GUILD_DEC28 = "这个玩家不存在,刷新再试试",
	GUILD_DEC29 = "新成员在24小时内不能踢出",
	GUILD_DEC30 = "会长离线7天才能弹劾",
	GUILD_DEC31 = "你不是公会成员了",
	GUILD_DEC32 = "公会%d级",
	GUILD_DEC33 = "可购买",
	GUILD_DEC34 = "玩家已加入其它公会",
	GUILD_DEC35 = "先任命一个会长才能退出",
	GUILD_DEC36 = "公会进度+%d",
	GUILD_DEC37 = "公会经验+%d",
	GUILD_DEC38 = "公会贡献+%d",
	GUILD_DEC39 = "公会贡献不足",
	GUILD_DEC40 = "通关%s",
	GUILD_DEC41 = "输入内容不能超过50个字",
	GUILD_DEC42 = "公会系统需%d级才开",
	GUILD_DEC43 = "多多研发有奖励哦",


	GUILD_DEC44 = "会    长",
	GUILD_DEC45 = "副本进度",
	GUILD_DEC46 = "战 斗 力",
	GUILD_DEC47 = "成 员 数",
	GUILD_DEC48 = "奖    励",
	GUILD_DEC49 = "未上榜",
	GUILD_DEC50 ="是否清除所有申请记录？",
	GUILD_DEC51 ="贡献排序",
	GUILD_DEC52 ="等级排序",
	GUILD_DEC53 = "输入最低战斗力",
	GUILD_DEC54 = "战力要求:%s",
	GUILD_DEC55 = "你的战力未达到要求",
	GUILD_DEC56 = "还没有人创建公会",
	GUILD_DEC57 = "%s",
	GUILD_DEC58 = "无",
	GUILD_DEC59 = "公会副本今日挑战人数已满",
	GUILD_DEC60 = "今日研发人数达到上限",
	GUILD_DEC61 = "跳过引导",


	GUILD_TEXT1 = "最高伤害排名:",
	GUILD_TEXT2 = "今日攻打次数:",
	GUILD_TEXT3 = "今日最高伤害:",
	GUILD_TEXT4 = "关 闭",
	GUILD_TEXT5 = "等     级:",
	GUILD_TEXT6 = "战     力:",
	GUILD_TEXT7 = "我的公会排名:",
	GUILD_TEXT8 = "会    长:",
	GUILD_TEXT9 = "成 员 数:",
	GUILD_TEXT10 = "副本进度:",
	GUILD_TEXT11 = "设施正在建造中",
	GUILD_TEXT12 = "公会人数:",
	GUILD_TEXT13 = "公会总战力:",
	GUILD_TEXT14 = "本区排行",
	GUILD_TEXT15 = "副本排行",
	GUILD_TEXT16 = "奖励：",
	GUILD_TEXT17 = "排名奖励将于每天24点通过邮件发送，请注意查收",
	GUILD_TEXT18 = "会    长:",
	GUILD_TEXT19 = "副本进度:",
	GUILD_TEXT20 = "每人奖励:",
	GUILD_TEXT21 = "成 员 数:",
	GUILD_TEXT22 = "贡献",
	GUILD_TEXT23 = "道 具",
	GUILD_TEXT24 = "可买",
	GUILD_TEXT25 = "次",
	GUILD_TEXT26 = "购 买",
	GUILD_TEXT27 = "成员数:",
	GUILD_TEXT28 = "同 意",
	GUILD_TEXT29 = "拒 绝",
	GUILD_TEXT30 = "购 买",
	GUILD_TEXT31 = "可申请最低战力:",
	GUILD_TEXT32 = "确 定",
	GUILD_TEXT33 = "点击输入文字",
	GUILD_TEXT34 = "公告",
	

	GUILD_DEC_POSTION_1 = "会  长",
	GUILD_DEC_POSTION_2 = "副会长",
	GUILD_DEC_POSTION_3 = "成  员",
	
	GUILD_DEC_ONLINE_1 = "在线",
	GUILD_DEC_ONLINE_2 = "离线",

	--合成界面文本
	COMPOSE_DEC1 = "没有足够的装备",
	COMPOSE_DEC2 = "没有足够的数码兽",
	COMPOSE_DEC3 = "没有足够的材料",
	COMPOSE_DEC4 = "是否确定合成6星装备？",
	COMPOSE_DEC5 = "是否确定合成7星装备？",
	COMPOSE_DEC6 = "是否确定合成6星数码兽？",
	COMPOSE_DEC7 = "是否确定合成7星数码兽？",

	
	COMPOSE_DEC8 = "合成幸运活动开启啦！",
	COMPOSE_DEC9 = "倒计时:",
	COMPOSE_DEC10 = "5个同星级",
	COMPOSE_DEC11 = "精灵/装备可随机合成",
	COMPOSE_DEC12 = "1个高一星级",
	COMPOSE_DEC13 = "的精灵/装备",
	COMPOSE_DEC14 = "自动放入装备",
	COMPOSE_DEC15 = "精灵",
	COMPOSE_DEC16 = "装备",
	COMPOSE_DEC17 = "选 择",
	COMPOSE_DEC18 = "自动放入精灵",



	
	COM_DEC = "你点的真够快的",

	BATTLE_DEC1 = "下 阵",
	BATTLE_DEC2 = "出 战",


	NET_LONG_TIME = "网络比较糟糕啊",
	MAIN_DEC1 = "首届驯兽师大赛筹办中",

	LOGIN_DEC2 = "你的网络不给力啊",

	---------------聊天------------------
	CHAT_TIPS1 = "该玩家不存在",
	CHAT_TIPS2 = "私聊玩家已下线",
	CHAT_TIPS3 = "发送消息间隔不能少于%d秒",
	CHAT_TIPS4 = "世界频道需要%d级开启噢",
	CHAT_TIPS5 = "不能和自己聊天",
	CHAT_TIPS6 = "请先加入公会",
	CHAT_TIPS7 = "你要和自己聊天？",
	CHAT_TIPS8 = "请先加入公会",
	CHAT_TIPS9 = "玩家名称不多于5个字哦",
	CHAT_TIPS10 = "文字内容不能为空",
	CHAT_TIPS11 = "文字内容不能超过%d个字",
	--CHAT_TIPS12 = "表情数目上限%d个",
	CHAT_TIPS13 = "非法字符，发送失败",
	CHAT_TIPS14 = "表情最多输入%d个哦",
	CHAT_TIPS15 = "你被禁言啦",
	CHAT_TIPS16 = "喇叭消息发送间隔不能少于30秒",
	CHAT_TIPS17 = "私信发送成功",
	CHAT_TIPS18 = "私信内容不能超过%d个字",
	CHAT_TIPS19 = "需等待5分钟才能继续发私信",
	CHAT_TIPS20 = "发言过快，你已被禁言",
	CHAT_TIPS21 = "您今日发言次数过多,已达上限",

	------------------好友--------------
	FRIEND_TIPS1 = "你已成功删除了好友%s",
	FRIEND_TIPS2 = "没有对应的角色信息",
	FRIEND_TIPS3 = "成功赠送%d点体力",
	FRINED_TIPS4 = "今日已经送过体力了",
	FRIEND_TIPS5 = "每日只能赠送20点体力",
	FRIEND_TIPS6 = "成功发送邀请,等待对方同意",
	FRIEND_TIPS7 = "已发送过邀请，请等待玩家处理",
	FRIEND_TIPS8 = "你的好友已满",
	FRIEND_TIPS9 = "已经是好友了",
	FRIEND_TIPS10 = "领取次数已用完",
	FRIEND_TIPS11 = "体力已满",
	FRIEND_TIPS12 = "请输入玩家名称",
	FRIEND_TIPS13 = "领取%d点体力",
	FRIEND_TIPS14 = "对方好友已满",
	FRIEND_TIPS15 = "世界频道发言需%d级",
	------------活动-等级礼包------------
	LEVELGIFT_TIP1 = "等级礼包等级未达到",
	LEVELGIFT_TIP2 = "等级奖励已经领取",
	------------活动-礼包码-------------
	GIFT_CODE_TIPS1 = "礼包码已经使用过了哦",
	GIFT_CODE_TIPS2 = "礼包码已经过期",
	GIFT_CODE_TIPS3 = "无效礼包码",
	GIFT_CODE_TIPS4 = "此类型礼包码已经兑换过了",
	------------活动-邀请码-----------
	INVITATE_TIPS1 = "您输入的邀请码有误",
	INVITATE_TIPS2 = "邀请码检查正确，礼包已发送至您的邮箱",

	-----------喇叭广播-----------------
	HORN_TIPS1 = "钻石不足",
	HORN_TIPS2 = "喇叭道具不足",

	------回归大礼-----------
	COMEBACK_TIPS1 = "公测1服即可领取",
	------吃鸡--------------
	EATCHICKEN_TIPS1 = "恢复%d点体力",
	----红包-------
	REDBAG_TIPS1 = "手慢了，红包被人抢光了",
	REDBAG_TIPS2 = "每日领取红包金额达上限",
	-----称号----
	TITLE_TIPS1 = "佩戴成功",
	----头像----
	HEAD_TIPS1 = "更换成功",
	--邀请码
	INVITATE_TIPS1 = "请输入邀请码",
	INVITATE_TIPS2 = "无效邀请码",
	INVITATE_TIPS3 = "无效邀请码,请到活动接口重新输入",
	INVITATE_TIPS4 = "邀请码检测正确，礼包已发送至您的邮箱",
	INVITATE_TIPS5 = "不能输入自己的邀请码",

	--攻略
	STRATEGY_TIPS1 = "%d级开放",


	--UI接口显示文字(有共享、或者会变动)
	HSUI_DESC1 = "领 取",
	HSUI_DESC2 = "已领取",
	HSUI_DESC3 = "累计充值%d元",
	HSUI_DESC4 = "%d秒",
	HSUI_DESC5 = "%d分%d秒",
	HSUI_DESC6 = "%d时%d分%d秒",
	HSUI_DESC7 = "今日已累计充值%d元",
	HSUI_DESC8 = "单笔充值%d元",
	HSUI_DESC9 = "开 餐",
	HSUI_DESC10 = "稍 后",
	HSUI_DESC11 = "等级到达%d",
	HSUI_DESC12 = "确 定",
	HSUI_DESC13 = "已开启",
	HSUI_DESC14 = "已关闭",
	HSUI_DESC15 = "开 启",
	HSUI_DESC16 = "关 闭",
	HSUI_DESC17 = "在线",
	HSUI_DESC18 = "离线",
	HSUI_DESC19 = "添加好友",
	HSUI_DESC20 = "删除好友",
	HSUI_DESC21 = "取 消",
	HSUI_DESC22 = "点击输入名字",
	HSUI_DESC23 = "离线%d分钟",
	HSUI_DESC24 = "离线%d小时",
	HSUI_DESC25 = "离线%d天",
	HSUI_DESC26 = "邀 请",
	HSUI_DESC27 = " 赠 送",
	HSUI_DESC28 = "%d个红包，共%d",
	HSUI_DESC29 = "有钱就是任性，不解释",
	HSUI_DESC30 = "明日",
	HSUI_DESC31 = "后天",
	HSUI_DESC32 = "日",
	HSUI_DESC33 = "已佩戴",
	HSUI_DESC34 = "更 换",
	HSUI_DESC35 = "未获得",
	HSUI_DESC36 = "佩 戴",
	HSUI_DESC37 = "已佩戴",
	HSUI_DESC38 = "无",
	HSUI_DESC39 = "已邀请的好友:%d人",
	HSUI_DESC41 = "发 送",
	HSUI_DESC42 = "点击输入文字",
	HSUI_DESC43 = "%d天%d时%d分%d秒",
	HSUI_DESC44 = "私信对象：",



	-----------------界面固定文本----------------
	--活动界面
	ACTIVE_TEXT1 = "本次活动倒计时",
	ACTIVE_TEXT2 = "活动期间，玩家每日充值金额累计达到指定额度即可领取丰厚大礼！每个档次每日仅限参与一次！",
	ACTIVE_TEXT3 = "剩余领取次数:",
	ACTIVE_TEXT4 = "活动期间，每天充值任意金额即可领取丰厚大礼",
	ACTIVE_TEXT5 = "活动期间，玩家每日单笔充值金额达到指定额度即可领取丰厚大礼！每个档次每日限定参与次数！",
	ACTIVE_TEXT6 = "没有充值奖励可以领取",
	ACTIVE_TEXT7 = "删档收费所有充值获得将在",
	ACTIVE_TEXT8 = "公测1服",
	ACTIVE_TEXT9 = "超值返还，详情如下",
	ACTIVE_TEXT10 = "所有充值所得钻石将在公测1服进行1.5倍返还",
	ACTIVE_TEXT11 = "每日首充，每日累计充值，每日单笔充值奖励进行全额返还",
	ACTIVE_TEXT12 = "VIP等级经验保留至公测1服，可再次购买vip礼包",
	ACTIVE_TEXT13 = "钻石累计充值",
	ACTIVE_TEXT14 = "充值活动奖励",
	ACTIVE_TEXT15 = "每次领取可恢复",
	ACTIVE_TEXT16 = "点体力",
	ACTIVE_TEXT17 = "活动时间:永久",
	ACTIVE_TEXT18 = "活动规则：主人，输入正确的礼包码就能领取一份豪华礼包哟",
	ACTIVE_TEXT19 = "请输入礼包码",
	ACTIVE_TEXT20 = "姓     名",
	ACTIVE_TEXT21 = "首充金额",
	ACTIVE_TEXT22 = "返还金额",
	ACTIVE_TEXT23 = "输入好友邀请码可获得好友邀请大礼包",
	ACTIVE_TEXT24 = "礼包内包含",
	ACTIVE_TEXT25 = "钻石X100,金币X2万",
	ACTIVE_TEXT26 = "您还没有输入邀请码！",
	ACTIVE_TEXT27 = "输 入",
	ACTIVE_TEXT28 = "已输入邀请码:",
	ACTIVE_TEXT29 = "我的邀请码：",
	ACTIVE_TEXT30 = "每个被邀请的好友首次充值，系统都赠送您好友首次额度30%的钻石奖励",
	ACTIVE_TEXT31 = "查看我邀请的好友",
	ACTIVE_TEXT32 = "活动时间，玩家等级符合标准即可领取丰厚大礼",
	ACTIVE_TEXT33 = "当前等级：",
	ACTIVE_TEXT34 = "邀请的好友升到30级，人数达到一定后，系统将\n赠送您丰厚的奖励",
	ACTIVE_TEXT35 = "查看奖励",
	ACTIVE_TEXT36 = "升级到30级邀请的好友:%d人",
	ACTIVE_TEXT37 = "%d个好友达到30级",
	ACTIVE_TEXT38 = "为我们的页面点赞，可获得超大礼包",

	--招财提示
	ACTIVE_TEXT39 = "挑战次数不足,是否花费",
	ACTIVE_TEXT40 = "购买？",
	ACTIVE_TEXT41 = "今日购买次数已用完,充值成为更高",
	ACTIVE_TEXT42 = "可增加购买次数!",
	ACTIVE_TEXT43 = "主人是否一键探险？",
	ACTIVE_TEXT44 = "今日不再提示",
	ACTIVE_TEXT45 = "本次活动结束倒计时：",

	--VIP商店
	ACTIVE_TEXT46 = "当前VIP等级：",
	ACTIVE_TEXT47 = "再充",
	ACTIVE_TEXT48 = "，享受",
	ACTIVE_TEXT49 = "特权",
	ACTIVE_TEXT50 = "仅限VIP%d购买",
	ACTIVE_TEXT51 = "重置倒计时：",
	ACTIVE_TEXT52 = "剩余购买次数：",

	--天天豪礼
	ACTIVE_TEXT53 = "今日首充倒计时：",
	ACTIVE_TEXT54 = "活动期间，玩家每日充值任意金额即可领取丰厚大礼！坚持连续每日首充，豪礼更会逐日提高！",
	ACTIVE_TEXT55 = {
		"第一天",
		"第二天",
		"第三天",
		"第四天",
		"第五天",
		"第六天",
		"第七天",
	},

	--消费豪礼
	ACTIVE_TEXT56 = "本次活动倒计时：",
	ACTIVE_TEXT57 = "今日已消费",
	ACTIVE_TEXT58 = "剩余领取次数：",
	ACTIVE_TEXT59 = "累计消费%d钻石",
	ACTIVE_TEXT60 = "活动期间，玩家每日消费钻石达到指定额度即可领取丰厚大礼！每个档次每日仅限领取一次！",

	---红包界面
	REDBAG_TEXT1 = "抢到",
	REDBAG_TEXT2 = "看看大家手气",
	REDBAG_TEXT3 = "发红包",
	REDBAG_TEXT4 = "留言",
	REDBAG_TEXT5 = "主界面不显示",

	
	--聊天、好友
	FRIEND_TEXT1 = "世界",
	FRIEND_TEXT2 = "公会",
	FRIEND_TEXT3 = "私聊",
	FRIEND_TEXT4 = "全部",
	FRIEND_TEXT5 = "对",
	FRIEND_TEXT6 = "说",
	FRIEND_TEXT7 = "发 送",
	FRIEND_TEXT8 = "我对",
	FRIEND_TEXT9 = "查看阵容",
	FRIEND_TEXT10 = "发私信",
	FRIEND_TEXT11 = "好友",
	FRIEND_TEXT12 = "邀请好友",
	FRIEND_TEXT13 = "领体力",
	FRIEND_TEXT14 = "今日还可领取:",
	FRIEND_TEXT15 = "次",
	FRIEND_TEXT16 = "一键领取",
	FRIEND_TEXT17 = "换一批",
	FRIEND_TEXT18 = "是否与",
	FRIEND_TEXT19 = "断交，你们的友谊真的走到尽头了吗？",

	--小喇叭
	HORN_TEXT1 = "消耗",
	HORN_TEXT2 = "或",

	--头像、称号
	HEAD_TEXT1 = "获得途径",
	HEAD_TEXT2 = "点击更换头像",

	--设置
	SETTING_TEXT1 = "音乐设置",
	SETTING_TEXT2 = "音效设置",
	SETTING_TEXT3 = "其他设置",
	SETTING_TEXT4 = "注销登录",
	SETTING_TEXT5 = "永不锁屏",
	SETTING_TEXT6 = "切换账号",
	SETTING_TEXT7 = "红包显示",
	SETTING_TEXT8 = "主界面显示",
	SETTING_TEXT9 = "礼包码兑换",
	SETTING_TEXT10 = "输入礼物码可以兑换各种礼物",
	SETTING_TEXT11 = "确 认",
	SETTING_TEXT12 = "客服QQ:",
	SETTING_TEXT13 = "800111308",
	SETTING_TEXT14 = "客服邮箱:",
	SETTING_TEXT15 = "kefu@gavegame.com",
	SETTING_TEXT16 = "客服电话:",
	SETTING_TEXT17 = "010-51727392",
	SETTING_TEXT18 = "个人中心",
	SETTING_TEXT19 = "退出游戏",


	--签到
	SIGNIN_TEXT1 = "登录领奖",
	SIGNIN_TEXT2 = "今日",

	--攻略 
	STRATEGY_TEXT1 = "前 往",




	----在线更新
	UPDATE_DEC1 = "去商店下载个最新版吧" ,
	UPDATE_DEC2 = "您的网络不给力，请重试。",
	UPDATE_DEC3 = "更新完成,正在重载,请稍后...",
	UPDATE_DEC4 = "加载资源",
	UPDATE_DEC5 = "有%dM更新档，完成可领取更新礼包",
	UPDATE_DEC6 = "主人,正在完美更新，更新后可领取更新大礼包！",
	UPDATE_DEC7 = "更新完成，正在重载，请稍后",
	UPDATE_DEC8 = "版本太旧了，下载一个最新的吧",
	UPDATE_DEC9 = "重试",
	UPDATE_DEC10 = "准备数据包中,不需要流量哦！",
	UPDATE_DEC11 = "■",
	UPDATE_DEC12 = "正在与数码世界建立连接",

	---
	BUY_DEC1 = "你的次数不足可以通过",
	BUY_DEC2 = "快速恢复屠魔次数",
	BUY_DEC3 = "快速恢复竞技场次数",
	BUY_DEC4 = "屠魔次数",
	BUY_DEC5 = "挑战次数",


	---数码大赛
	CONTEST_DEC1 = "倒计时",
	CONTEST_DEC2 = "我在第%d小组中的战力排名:%d",
	CONTEST_DEC3 = "本场比赛将轮空",
	CONTEST_DEC4 = "请选择押注的驯兽师",
	CONTEST_DEC5 = "请选择押注金额",
	CONTEST_DEC6 = "小组赛",
	CONTEST_DEC7 = "4强赛",
	CONTEST_DEC8 = "半决赛",
	CONTEST_DEC9 = "决赛",
	CONTEST_DEC10 = "竞 猜",
	CONTEST_DEC11 = "已竞猜",
	CONTEST_DEC12 = "录像信息",
	CONTEST_DEC13 = "我的分组",
	CONTEST_DEC14 = "恭喜%s进入下一轮",
	CONTEST_DEC15 = "录像已过期",
	CONTEST_DEC16 = "比赛正在进行中",
	CONTEST_DEC17 = "开赛倒计时",
	CONTEST_DEC18 = "竞猜倒计时",
	CONTEST_DEC19 = "比赛进行中",
	CONTEST_DEC20 = "比赛进行中",
	CONTEST_DEC21 = "比赛进行中",
	CONTEST_DEC22 = "下届报名倒计时",
	CONTEST_DEC23 = "帮我点赞，给你奖励",
	CONTEST_DEC24 = "报名成功",
	CONTEST_DEC25 = "你想成为驯兽师之王吗？",
	CONTEST_DEC26 = "你没有报名",
	CONTEST_DEC27 = "不能和自己对比",
	CONTEST_DEC28 = "恭喜%s成为冠军",
	CONTEST_DEC29 = "比赛准备中",
	CONTEST_DEC30 = "奖励将于驯兽师大赛结束后通过邮件发送，请注意查收",
	CONTEST_DEC31 = "%s的录像",
	CONTEST_DEC32 = "竞猜成功",
	CONTEST_DEC33 = "专属称号",
	CONTEST_DEC34 = "驯兽师之王",
	CONTEST_DEC35 = "点赞成功，获得金币X%d",
	CONTEST_DEC36 = "%d点赞奖励(设置立即获得)",
	CONTEST_DEC37 = "点赞人数:%d",
	CONTEST_DEC38 = "只有驯兽师之王才有设置权限",
	CONTEST_DEC39 = "设置成功",
	CONTEST_DEC40 = "已全部设置",
	CONTEST_DEC41 = "第%d/5天",
	CONTEST_DEC42 = "驯兽师大赛正在进行中",
	CONTEST_DEC43 = "点击上方按钮可查看详细设置",

	CONTEST_DEC44 = "上届驯兽师大赛冠军才可购买",
	CONTEST_DEC45 = "上届驯兽师大赛亚军才可购买",
	CONTEST_DEC46 = "上届驯兽师大赛3-4名才可购买",
	CONTEST_DEC47 = "上届驯兽师大赛5-8名才可购买",
	CONTEST_DEC48 = "上届驯兽师大赛8名以外才可购买",
	--CONTEST_DEC44 = "战斗录像超时",
	CONTEST_DEC_1 = "普通点赞",
	CONTEST_DEC_2 = "中级点赞",
	CONTEST_DEC_3 = "高级点赞",

	CONTEST_DEC_1_1 = "普通",
	CONTEST_DEC_2_1 = "中级",
	CONTEST_DEC_3_1=  "高级",

	CONTEST_TEXT1 = "刷新时间:",
	CONTEST_TEXT2 = "原价:",
	CONTEST_TEXT3 = "已投注",
	CONTEST_TEXT4 = "阵容对比",
	CONTEST_TEXT5 = "猜对获得2倍奖励，猜错损失一半竞猜金币:",
	CONTEST_TEXT6 = "预计收入：",
	CONTEST_TEXT7 = "竞  猜",
	CONTEST_TEXT8 = "我的分组",
	CONTEST_TEXT9 = "查看阵容",
	CONTEST_TEXT10 = "排名奖励",
	CONTEST_TEXT11 = "规 则",
	CONTEST_TEXT12 = "我的比赛",
	CONTEST_TEXT13 = "强者之战",
	CONTEST_TEXT14 = "录 像",
	CONTEST_TEXT15 = "倒计时",
	CONTEST_TEXT16 = "比赛录像",
	CONTEST_TEXT17 = "今日点赞",
	CONTEST_TEXT18 = "普通点赞",
	CONTEST_TEXT19 = "点赞奖励",
	CONTEST_TEXT20 = "上届排名",
	CONTEST_TEXT21 = "第%d/%d天",
	CONTEST_TEXT22 = "点击上方按钮可查看详细设置",
	CONTEST_TEXT23 = "确定设置",
	CONTEST_TEXT24 = "点赞?",
	CONTEST_TEXT25 = "当天玩家点赞可获得:",
	CONTEST_TEXT26 = "确定设置",
	CONTEST_TEXT27 = "确 定",
	CONTEST_TEXT28 = "取 消",


	--CONTEST_DEC20 = "比赛准备中",

	--
	MAP_DEC1 = "数码兽",
	MAP_DEC2 = "数码兽装备",
	MAP_DEC4 = "驯兽师装备",

	--错误号提示
	ERROR_DEC1 = "你已被封号（-1），请联系客服QQ:800111308",
	ERROR_DEC2 = "你已被封号（-2），请联系客服QQ:800111308",

	---挖矿
	DIG_DEC1 = "请先占领前一文件岛",
	DIG_DEC2 = "请不要随便进入别人的文件岛",
	DIG_DEC3 = "救援次数已用完",
	DIG_DEC4 = "你没有正在运作的文件岛，无法帮忙救援",
	DIG_DEC5 = "你没有选择探险奖励类型",
	DIG_DEC6 = "挑战胜利后，可占领此文件岛，每天都可通过此文件岛获得大量资源奖励噢",
	DIG_DEC7 = "推荐战力:%d",
	DIG_DEC8 = "%s的文件岛",
	DIG_DEC9 = "可收成",
	DIG_DEC10 = "你还没有好友占领文件岛",
	DIG_DEC11 = "救援次数:%d/抢夺次数:%d/助阵次数:%d",
	DIG_DEC12 = "请选择数码兽",
	DIG_DEC13 = "请选择探险奖励类型",
	DIG_DEC14 = "%s晶体",
	DIG_DEC15 = "选择晶体品质越高，奖励越多。历时：6小时",
	DIG_DEC16 = "收益:+%d",
	DIG_DEC17 = "免费能源",
	DIG_DEC18 = "拥有:%d",
	DIG_DEC19 = "可探险",
	DIG_DEC20 = "领 取",
	DIG_DEC21 = "加 速",
	DIG_DEC22 = "是否消耗",
	DIG_DEC23 = "%d加速?(还可加速%d次)",
	DIG_DEC24 = "暴动文件岛:%d",
	DIG_DEC25 = "是否消耗%s购买%s",
	DIG_DEC26 = "数码兽已在探险中",
	DIG_DEC27 = "今日探险次数已达到上限",
	DIG_DEC28 = "探险加速上限",
	DIG_DEC29 = "救援次数到达上限",
	DIG_DEC30 = "加速次数达到上限,充值成为更高",
	DIG_DEC31 = "暴乱已被别人救援了",
	DIG_DEC32 = "公会商店可兑换",
	DIG_DEC33 = "钻石探险材料",
	DIG_DEC34 = "取 消",
	DIG_DEC35 = "确 定",
	DIG_DEC36 = "主人，",
	DIG_DEC37 = "加速后可领取奖励：",
	DIG_DEC38 = "挑战胜利后，可占领此文件岛，每天都可通过此文件岛获得大\n量资源奖励噢",
	DIG_DEC39 = "推荐战力:",
	DIG_DEC40 = "挑 战",
	DIG_DEC41 = "前 往",
	DIG_DEC42 = "再来一次",
	DIG_DEC43 = "阵容对比",
	DIG_DEC44 = "选 择",
	DIG_DEC45 = "历时:%d小时",
	DIG_DEC46 = "选择不同的探险形式，奖励不同",
	DIG_DEC47 = "普通探险",
	DIG_DEC48 = "中级探险",
	DIG_DEC49 = "高级探险",
	DIG_DEC50 = "超级探险",
	DIG_DEC51 = "究极探险",
	DIG_DEC52 = "下次收益时间:",
	DIG_DEC53 = "基础收益:",
	DIG_DEC54 = "数码兽加成:",
	DIG_DEC55 = "救援加成:",
	DIG_DEC56 = "探险中",
	DIG_DEC57 = "数码兽战力越高，加成越高",
	DIG_DEC58 = "点击选择探险奖励",
	DIG_DEC59 = "开始探险",
	DIG_DEC60 = "助阵者:%s",
	DIG_DEC61 = "可抢夺:%d",
	DIG_DEC62 = "复   仇",
	DIG_DEC63 = "搜  索",
	DIG_DEC64 = "抢夺次数不足，请明天继续",
	DIG_DEC65 = "抢夺留一线 日后好相见",
	DIG_DEC66 = "抢夺的节奏太快了，5秒后再试试吧",
	DIG_DEC67 = "匹配对手失败",
	DIG_DEC68 = "不能抢夺自己的好友",
	DIG_DEC69 = "抢夺留一线 日后好相见",
	DIG_DEC70 = "你还没有被抢过",
	DIG_DEC71 = "抢夺你的",
	DIG_DEC72 = ":%d",
	DIG_DEC73 = "前 往",
	DIG_DEC74 = "邀 请",
	DIG_DEC75 = "已被抢夺:%d",
	DIG_DEC76 = "每日邀请助阵次数已达上限",
	DIG_DEC77 = "已邀请",
	DIG_DEC78 = "已发送私聊请求好友救援",

	DIG_DEC_BOSS11 = "捣乱的木偶兽",
	DIG_DEC_BOSS12 = "捣乱的钢铁海龙兽",
	DIG_DEC_BOSS13 = "捣乱的机械邪龙兽",
	DIG_DEC_BOSS14 = "捣乱的小丑皇",

	DIG_DEC_BOSS15 = "大胆！居然敢捣乱！",

	DIG_DEC_DAO1 = "岛岛1",
	DIG_DEC_DAO2 = "岛岛2",
	DIG_DEC_DAO3 = "岛岛3",
	DIG_DEC_DAO4 = "岛岛4",
	DIG_DEC_DAO5 = "岛岛6",
	DIG_DEC_DAO6 = "岛岛7",

	--
	SYS_DEC1 = "感受到主人的威风，恶魔兽正在冒死投奔你拉!",
	SYS_DEC2 = "   可启动甲虫兽亲密",
	SYS_DEC3 = "   投奔中:%s",
	SYS_DEC4 = "   生命+15%",
	SYS_DEC5 = "区",
	SYS_DEC6 = "亿",
	SYS_DEC7 = "万",
	SYS_DEC8 = "系统未开放",
	SYS_DEC9 = "关卡已通关",
	SYS_DEC10 = "退出游戏?",
	
	--双11 
	DOUBLE_DEC1 = "本次活动倒计时",
	DOUBLE_DEC2 = "%d时%d分%d秒",
	DOUBLE_DEC3 = "活动期间,玩家每日充值金额累计达到指定额度即可领取",
	DOUBLE_DEC4 = "丰厚大礼！每个档次每日仅限参与一次！",
	DOUBLE_DEC5 = "%d分%d秒",
	DOUBLE_DEC6 = "%d秒",
	DOUBLE_DEC7 = "累计充值%d元",
	DOUBLE_DEC8 = "剩余领取次数",
	DOUBLE_DEC9 = "未达到",
	DOUBLE_DEC10 = "领 取",
	DOUBLE_DEC11 = "已领取",
	DOUBLE_DEC12 = "累计充值不足",
	DOUBLE_DEC13 = "道具不足，战役、屠魔可掉落",
	DOUBLE_DEC14 = "活动期间,玩家每日充值金额累计达到指定额度即可领取",
	DOUBLE_DEC15 = "丰厚大礼！每个档次每日仅限参与一次！",
	SYS_DEC6 = "亿",
	SYS_DEC7 = "万",
	SYS_DEC8 = "系统未开放",
	SYS_DEC9 = "关卡已通关",
	SYS_DEC10 = "退出游戏?",
	
	--双11 
	DOUBLE_DEC1 = "本次活动倒计时",
	DOUBLE_DEC2 = "%d时%d分%d秒",
	DOUBLE_DEC3 = "活动期间,玩家每日充值金额累计达到指定额度即可领取",
	DOUBLE_DEC4 = "丰厚大礼！每个档次每日仅限参与一次！",
	DOUBLE_DEC5 = "%d分%d秒",
	DOUBLE_DEC6 = "%d秒",
	DOUBLE_DEC7 = "累计充值%d元",
	DOUBLE_DEC8 = "剩余领取次数",
	DOUBLE_DEC9 = "未达到",
	DOUBLE_DEC10 = "领 取",
	DOUBLE_DEC11 = "已领取",
	DOUBLE_DEC12 = "累计充值不足",
		---队形界面
	DUI_DEC_01 = "布\n阵",
	DUI_DEC_02 = "小\n伙\n伴",
	DUI_DEC_03 = "生命",
	DUI_DEC_04 = "攻击",
	DUI_DEC_05 = "开启",
	DUI_DEC_06 = "隐藏已出战数码兽",
	DUI_DEC_07 = "退化",
	DUI_DEC_08 = "一键退化",
	DUI_DEC_09 = "芯 片",
	DUI_DEC_10 = "替 换",
	DUI_DEC_11 = "一键换装",
	DUI_DEC_12 = "小伙伴近期即将到来!!!",

	DOUBLE_DEC16 = "活动期间，每天签到都可免费抽取豪华大礼！",
	DOUBLE_DEC17 = "奖品多多，记得每天来签到，不要错过哟！",

	DOUBLE_DEC18 = "活动期间，攻打战役、屠魔有机会掉落“1”字",
	DOUBLE_DEC19 = "集满4个不同的“1”字可抽奖1次，奖品多多哟！",


	--成就
	ACHI_DEC5 = "未完成",
	ACHI_DEC6 = "已完成",
	ACHI_DEC7 = "奖励",
	--招财
	ACTIVE_DEC2 = "今日剩余招财次数:",
	ACTIVE_DEC3 = "充值提升",
	ACTIVE_DEC4 = "VIP",
	ACTIVE_DEC5 = "等级增加每日招财次数",
	ACTIVE_DEC6 = "消耗",
	ACTIVE_DEC7 = "获得",
	ACTIVE_DEC8 = "招财",
	ACTIVE_DEC9 = "次",


	--竞技场
	ATHLET_DESC1 = "我的排名：",
	ATHLET_DESC2 = "冷却时间：",
	ATHLET_DESC3 = "挑战次数：",
	ATHLET_DESC4 = "奖励：",
	ATHLET_DESC5 = "奖励将在每天\n22:00 通过邮\n件发放，请注\n意查收！",
	ATHLET_DESC6 = "我的排名：",
	ATHLET_DESC7 = "排名：",
	ATHLET_DESC8 = "战力：",
	ATHLET_DESC9 = "已领取",
	ATHLET_DESC10 = "获得徽章%d",
	ATHLET_DESC11 = "不可以挑战自己",
	ATHLET_DESC12 = "太不自量力了，先冲到20名再来打我吧!",
	ATHLET_DESC13 = "阵容对比",
	ATHLET_DESC14 = "主人，是否花费             购买       次\n挑战次数？\n\n当前第    次购买，当前VIP等级每日\n可购买    次！",
	ATHLET_DESC15 = "取 消",
	ATHLET_DESC16 = "确 定",
	ATHLET_DESC17 = "战五次",




	---爬塔飘字提示
	CLIMB_TIPS1 = "需先通关副本",
	CLIMB_TIPS2 = "战力不足，需提升战力才可扫荡",
	CLIMB_TIPS3 = "完美通关，请重置",
	CLIMB_TIPS4 = "当前生命为%d，请重置",
	CLIMB_TIPS5 = "鼓舞成功，攻击+%d%%",
	CLIMB_TIPS6 = "鼓舞成功，生命+%d%%",
	CLIMB_TIPS7 = "购买次数用完",
	CLIMB_TIPS8 = "前方关卡危险，需提升实力才可扫荡",
	CLIMB_TIPS9 = "勇气值不足",


	---爬塔接口文字
	CLIMB_DESC1 = "%s星难度",
	CLIMB_DESC2 = "第%d关",
	CLIMB_DESC3 = "推荐战力:%d",
	CLIMB_DESC4 = "推荐战力:%d万",
	CLIMB_DESC5 = "今日最高：",
	CLIMB_DESC6 = "本次挑战：",
	CLIMB_DESC7 = "剩余生命：",
	CLIMB_DESC8 = "鼓舞加成：",
	CLIMB_DESC9 = "勇气：",
	CLIMB_DESC10 = "勇气鼓舞",
	CLIMB_DESC11 = "重置",
	CLIMB_DESC12 = "攻击",
	CLIMB_DESC13 = "血量",
	CLIMB_DESC14 = "一键五关",
	CLIMB_DESC15 = "通关关卡可获得勇气，用于增强战斗力",
	CLIMB_DESC16 = "注意：在通关过程中战败，勇气将增加30点",
	CLIMB_DESC17 = "消耗勇气：%d",
	CLIMB_DESC18 = "今日不再提示",
	CLIMB_DESC19 = "继续挑战",
	CLIMB_DESC20 = "根据你的战力，推荐挑战",
	CLIMB_DESC21 = "每天最高星数排名前%d奖励大量钻石",
	CLIMB_DESC22 = "挑  战",
	CLIMB_DESC23 = "恭喜你完成闯关，获得星级奖励",
	CLIMB_DESC24 = "领 取",
	CLIMB_DESC25 = "消耗：",
	CLIMB_DESC26 = "购买%d次",
	CLIMB_DESC27 = "开 启",
	CLIMB_DESC28 = "主人：",
	CLIMB_DESC29 = "恭喜你完美通关,\n请重置后继续游戏",
	CLIMB_DESC30 = "取 消",
	CLIMB_DESC31 = "虚以待位",
	CLIMB_DESC32 = "未上榜",
	CLIMB_DESC33 = "领 取",
	CLIMB_DESC34 = "已领取",
	CLIMB_DESC35 = "排名奖励",
	CLIMB_DESC36 = "星级奖励",
	CLIMB_DESC37 = "一",
	CLIMB_DESC38 = "二",
	CLIMB_DESC39 = "三",
	CLIMB_DESC40 = "四",
	CLIMB_DESC41 = "达到对应星数即可领取大量奖励",
	CLIMB_DESC42 = "我的排名:",

	CLIMB_DESC43 = "战绩：",
	CLIMB_DESC44 = "奖励",
	CLIMB_DESC45 = "排名奖励将在每天24:00通过邮件发放，请注意查收！",
	CLIMB_DESC46 = "今日可免费重置一次，是否重置？\n重置后生命值变为",
	CLIMB_DESC47 = "是否消耗             重置关卡\n重置后，生命值变为",
	CLIMB_DESC48 = "确 定",
	CLIMB_DESC49 = "今日重置次数已用完，提高      等级可增加\n重置次数，是否前往充值？",
	CLIMB_DESC50 = "充 值",
	

	--副本票字
	COPY_TIPS1 = "副本挑战次数不足",
	COPY_TIPS2 = "竞技场次数不足",


	--副本界面文本
	COPY_DESC1 = "暴龙兽",
	COPY_DESC2 = "扫荡%d次",
	COPY_DESC3 = "今日用尽",
	COPY_DESC4 = "领  取",
	COPY_DESC5 = "已领取",
	COPY_DESC6 = "欢迎光临",
	COPY_DESC7 = "今日可挑战次数：",
	COPY_DESC8 = "通关获得：",
	COPY_DESC9 = "有机会掉落：",
	COPY_DESC10 = "训练师你已经成功通关了",
	COPY_DESC11 = "可以开始下一章节了",
	COPY_DESC12 = "继续本章",
	COPY_DESC13 = "下一章",
	COPY_DESC14 = "%d级开启精英副本",
	COPY_DESC15 = "阵容对比",
	COPY_DESC16 = "再次挑战",
	COPY_DESC17 = "主人，您可以通过以下途径",
	COPY_DESC18 = "提升战力",
	COPY_DESC19 = "勇气:",
	COPY_DESC20 = "%d级开启噩梦副本",
	COPY_DESC21 = "勇气：",

	---VIP_DEC
	VIP_DEC_01 =  "当前等级:",
	VIP_DEC_02 =  "再充值:",
	VIP_DEC_03 =  "20可成",
	VIP_DEC_04 = "充值",
	--任务
	TASK_DEC_01 = "日常任务",
	TASK_DEC_02 = "公会任务",
	TASK_DEC_03 = "奖励:",
	TASK_DEC_04 = "进度",
	--购买体力
	BUG_DEC_01 = "主人，你的体力不足可以通过",
	BUG_DEC_02 = "快速回复体力。",
	BUG_DEC_03 = "使 用",
	BUG_DEC_04 = "取 消",
	BUG_DEC_05 = "主人，您的体力不足，主人，是否花费",
	BUG_DEC_06 = "钻石",
	BUG_DEC_07 = "购买体力药水快速回复体力。",
	BUG_DEC_08 = "主人，今日购买次数已达上限，升级VIP\n\n购买更多的体力次数",
	--商店
	SHOP_DEC_01 = "购 买",
	SHOP_DEC_02 = "关 闭",
	SHOP_DEC_03 = "请选择需要购买的数量",
	SHOP_DEC_04 = "总价:",


	SHOP_DEC_05 = "原价",
	SHOP_DEC_06 = "现价",
	SHOP_DEC_07 = "可购买次数:",
	SHOP_DEC_08 = "购 买",
	SHOP_DEC_09 = "拥有的黑市货币：",
	SHOP_DEC_10 = "可消耗1个黑市货币或10钻石快速刷新",
	SHOP_DEC_11 = "快速刷新",

	SHOP_DEC_12 = "神秘商店",
	SHOP_DEC_13 = "道具商店",
	SHOP_DEC_14 = "VIP礼包",
	SHOP_DEC_15 = "充值",
	SHOP_DEC_16 = "再充值",
	SHOP_DEC_17 = "VIP特权",
	SHOP_DEC_18 = "首次充值, 免费获得首充大礼包",
	SHOP_DEC_19 = "刷新时间",
	SHOP_DEC_20 = "今日刷新次数:",
	SHOP_DEC_21 = "次",
	SHOP_DEC_22 = "领 取",
	--
	ROLE_DEC_01 = "充值",
	ROLE_DEC_02 = "竞技场",
	ROLE_DEC_03= "下一点恢复",
	ROLE_DEC_04 = "全部恢复",
	ROLE_DEC_05 = "屠魔",
	ROLE_DEC_06 = "体力",
	ROLE_DEC_07 = "未加入",
	ROLE_DEC_08 = "设 置",
	ROLE_DEC_09 = "攻 略",
	ROLE_DEC_10 = "公 告",
	--数码兽
	PET_DEC_01 = "获得经验值：",
	PET_DEC_02 = "升级所需：",
	PET_DEC_03 = "确 定",
	PET_DEC_04 = "数码兽都可作为进化材料使用",
	PET_DEC_05= "任意同星级",

	PET_DEC_06= "攻击:",
	PET_DEC_07= "生命:",
	PET_DEC_08= "防御:",
	PET_DEC_09= "暴击:",
	PET_DEC_10= "坚韧:",
	PET_DEC_11= "战斗力  :",
	PET_DEC_12= "命中    :",
	PET_DEC_13= "闪避    :",
	PET_DEC_14= "暴击伤害:",
	PET_DEC_15= "升级",
	PET_DEC_16= "进化",
	PET_DEC_17= "更 换",
	PET_DEC_18= "下 阵",
	PET_DEC_19= "与%s组队",
	PET_DEC_20= "获得经验值:",
	PET_DEC_21= "自动添加",
	PET_DEC_22= "升级",
	PET_DEC_23= "还 原",

	PET_DEC_24= "突 破",

	---
	PACK_DEC_01 = "图鉴",
	PACK_DEC_02 = "数量",
	PACK_DEC_03 = "道具",
	PACK_DEC_04 = "装备",
	PACK_DEC_05 = "数码兽",
	PACK_DEC_06 = "人物装备",
	PACK_DEC_07 = "确定",
	PACK_DEC_08 = "再次购买",
	PACK_DEC_09 = "果实材料",
	--
	MAIL_DEC_01 = "系统",
	MAIL_DEC_02 = "战斗",
	MAIL_DEC_03 = "社交",
	MAIL_DEC_04 = "奖励",
	MAIL_DEC_05 = "知道了",
	--暴龙机
	LUCKY_DEC_01 = "充  值",
	LUCKY_DEC_02 = "抽精灵送金币",
	LUCKY_DEC_03 = "消耗:",
	LUCKY_DEC_04 = "可免费领取",
	LUCKY_DEC_05 = "后免费领取",
	--
	GUILD_DEC_01 = "退出公会",
	GUILD_DEC_02 = "成员审核",
	GUILD_DEC_03 = "发布公告",
	GUILD_DEC_04 = "入会条件",
	GUILD_DEC_05 = "我的公会排名：",
	GUILD_DEC_06 = "关 闭",
	GUILD_DEC_07 = "请选择公会头像",
	GUILD_DEC_08 = "创  建",
	GUILD_DEC_09 = "规  则",
	GUILD_DEC_10 = "挑战次数：",
	GUILD_DEC_11 = "购买已达上限",
	GUILD_DEC_12 ="需通关前一个关卡",
	GUILD_DEC_13 ="关卡已通关",
	GUILD_DEC_14 = "挑战次数不足",
	GUILD_DEC_15 = "每日通关前一个关卡后可领取",
	GUILD_DEC_16 = "领 取",
	GUILD_DEC_17 = "第%d章",
	GUILD_DEC_18 = "上一章节未通关",
	GUILD_DEC_19 = "本章节昨日已通关，无法进入",
	GUILD_DEC_20 = "公会副本需公会2级开放",
	GUILD_DEC_21 ="公会副本需30级才能攻打",
	GUILD_DEC_22 ="确 定",
	GUILD_DEC_23 ="成 员",
	GUILD_DEC_24 = "审 核" , 

	GUILD_DEC_25 = "时间排序",
	GUILD_DEC_26 = "贡献排序",
	GUILD_DEC_27 = "战力排序",
	GUILD_DEC_28 = "今日贡献:",
	GUILD_DEC_29 = "历史总贡献:",
	GUILD_DEC_30 = "一键清除",
	GUILD_DEC_31 = "等     级:",
	GUILD_DEC_32 = "战     力:",
	GUILD_DEC_33 = "同 意",
	GUILD_DEC_34 = "拒 绝",
	GUILD_DEC_35 = "成员数:",
	GUILD_DEC_36 = "规 则",
	GUILD_DEC_37 = "当前研发进度:",
	GUILD_DEC_38 = "今天研发人数:",
	GUILD_DEC_39 = "研发进度",
	GUILD_DEC_40 = "公会经验",
	GUILD_DEC_41 = "公会贡献",
	GUILD_DEC_42 = "关 闭",
	GUILD_DEC_43 = "今日最高伤害:",
	GUILD_DEC_44 = "当前进度:",
	GUILD_DEC_45 = "领 取",
	GUILD_DEC_46 = "任命会长",
	GUILD_DEC_47 = "任命副会长",
	GUILD_DEC_48 = "任命成员",
	GUILD_DEC_49 = "创建公会",
	GUILD_DEC_50 = "购 买",
	GUILD_DEC_51 = "敬请期待",

	
	--科技核心
	KJHX_DEC_1 = "完成科技核心收集，可获得丰厚奖励",
	KJHX_DEC_2 = {
		"量子力场为上阵数码兽提供属性",
		"元素解构为上阵数码兽提供属性",
		"基因秘匙为上阵数码兽提供属性",
		"地外空间为上阵数码兽提供属性"
	},
	KJHX_DEC_3 = { 
		{102, "攻     击:"}, 
		{105, "生     命:"},  
		{103, "防     御:"}, 
		{109, "闪     避:"}, 
		{107, "暴击伤害:"},
		{122, "怒气伤害:"},
		{124, "破击伤害:"},
		{119, "格挡几率:"},
		{110, "命     中:"}, 
		{116, "破     甲:"}, 
		{106, "暴     击:"},
		{108, "坚     韧:"},
		{125, "暴伤减免:"},
		{123, "怒气减免:"},
		{121, "格挡减免:"},
		{120, "破击几率:"},
	},


	FIGHT_TIPS1 = "三星才可以跳过",
	FIGHT_TIPS2 = "达到%d级或者VIP%d级才能开启%d倍加速",
	FIGHT_DESC1 = "跳 过",
	FIGHT_DESC2 = "勇气:",

	DOUBLE_DEC20 = "转10次",

	DOUBLE_DEC21 = "前   往",
	DOUBLE_DEC22 = "使用成功，金币X%d",
	DOUBLE_DEC23 = "主人是否开启一键抽奖%d次",

	
	-----------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------
	---
	DEC_ERR_01 = "该文件岛已有人帮忙守卫了",
	DEC_ERR_02 = "你要抢夺自己的资源吗？",
	DEC_ERR_03 = "已被抢完了",
	DEC_ERR_04 = "你邀请的好友助阵次数已用完",
	DEC_ERR_05 = "已发送邮件邀请好友",
	DEC_ERR_06 = "复 仇",
	DEC_ERR_07 = "你已经邀请过该好友",
	DEC_ERR_08 = "你还没有好友，快去加好友吧",
	DEC_ERR_09 = "恭喜你抢到",
	DEC_ERR_10 = "真不巧！对方已收成",
	DEC_ERR_11 = "探索中的文件岛:%d",
	DEC_ERR_12 = "你的助阵次数已达上限",
	DEC_ERR_13 = "驯兽师之王还没有产生",
	DEC_ERR_14 = "你申请太多公会了",
	DEC_ERR_15 = "你今日加入公会次数已达上限",
	DEC_ERR_16 = "对方今日加入公会次数已达上限",
	DEC_ERR_17 = "放入背包",
	DEC_ERR_18 = "领  取",
	DEC_ERR_19 = "确  定",
	DEC_ERR_20 = "不要在半夜抢夺，8点再过来吧",
	DEC_ERR_21 = "邀请好友助阵",
	DEC_ERR_22 = "抢夺次数已达上限",
	DEC_ERR_23 = "合 成",
	DEC_ERR_24 = "降 星",
	DEC_ERR_25 = "即将上线！敬请期待！ ",
	DEC_ERR_26 = "更新包%sM,更新后可领取大礼包哟，是否确认下载？",
	DEC_ERR_27 = "正在进化数码世界 (共%0.1fM) %d%%",
	DEC_ERR_28 = "版本过旧,请更新",
	DEC_ERR_29 = "vip2才可以使用降星功能,是否提高vip等级?",
	DEC_ERR_30 = "降星到上\n一星级",
	DEC_ERR_31 = "距离开战还剩:",
	DEC_ERR_32 = "战斗开始",
	DEC_ERR_33 = "%d连胜",
	DEC_ERR_34 = "20:00开启",
	DEC_ERR_35 = "<<正义>>",
	DEC_ERR_36 = "<<邪恶>>",
	DEC_ERR_37 = "本次活动你隶属于",
	DEC_ERR_38 = "阵营",
	DEC_ERR_39 = "结束时间",
	DEC_ERR_40 = "个\n人\n战\n绩",

	DEC_ERR_41 = "查看阵营",
	DEC_ERR_42 = "自动匹配",
	DEC_ERR_43 = "最高",
	DEC_ERR_44 = "当前",
	DEC_ERR_45 = "%d连杀",
	DEC_ERR_46 = "赢%d场",
	DEC_ERR_47 = "鼓舞战力+30%",
	DEC_ERR_48 = "战斗结束",
	DEC_ERR_49 = "VIP3或60级可自动匹配",
	DEC_ERR_50 = "战 力:",
	DEC_ERR_51 = "连 胜:",
	DEC_ERR_52 = "剩余血量:",
	DEC_ERR_53 = "输%d场",
	DEC_ERR_54 = "鼓舞成功，全体增加攻击+%d%%,生命+%d%%",
	DEC_ERR_55 = "积分:",
	DEC_ERR_56 = "正义",
	DEC_ERR_57 = "邪恶",
	DEC_ERR_58 = "阵营人数",
	DEC_ERR_59 = "终结对方%d连胜",
	DEC_ERR_60 = "战报过期",
	DEC_ERR_61 = "本次轮空，获得金币X5000,徽章X100",
	DEC_ERR_62 = "本次活动鼓舞次数已达上限",
	DEC_ERR_63 = "本次大战已结束",
	DEC_ERR_64 = "死亡CD未到不能匹配",
	DEC_ERR_65 = "vip3或60级可自动匹配",
	DEC_ERR_66 = "您已经参与了匹配",
	DEC_ERR_67 = "恭喜取得",
	DEC_ERR_68 = "连胜",
	DEC_ERR_69 = "终结对方",
	DEC_ERR_70 = "战斗正在进行……",
	DEC_ERR_71 = "全\n服\n战\n绩",
	DEC_ERR_72 = "降星返还一半合成金币",
	DEC_ERR_73 = "本次活动结束",
	DEC_ERR_74 = "死亡期间不能鼓舞",
	DEC_ERR_75 = "本次共取得",
	DEC_ERR_76 = "是否消耗",
	DEC_ERR_77 = "抽奖10次",
	DEC_ERR_78 = "不能重复参战",
	DEC_ERR_79 = "(已方)",
	DEC_ERR_80 = "(离线有效)",
	DEC_ERR_81 = "战斗回放",
	DEC_ERR_82 = "本次失败奖励",
	DEC_ERR_83 = "当天降星次数已达上限",
	DEC_ERR_84 = "每日限两次",

	RICH_RANK_DESC1 = "活动期间，对土豪点赞可获得钻石奖励。今日充值最高6位玩家可接受玩家点赞。排名越高可获得返利钻石越高！仅在今日！\n仅此一天！仅此一天！仅此一天！重要的事情说3遍！",
	RICH_RANK_DESC2 = "本次活动倒计时",
	RICH_RANK_DESC3 = "刷 新",
	RICH_RANK_DESC4 = "充 值",
	RICH_RANK_DESC5 = "今日已累计充值%d元",
	RICH_RANK_DESC6 = "今日剩余点赞次数:%d",
	RICH_RANK_DESC7 = "充值钻石%d",
	--RICH_RANK_DESC8 = "本次活动倒计时",
	RICH_RANK_DESC9 = "%d秒",
	RICH_RANK_DESC10 = "%d分%d秒",
	RICH_RANK_DESC11 = "%d时%d分%d秒",
	RICH_RANK_DESC12 = "%d天%d时%d分%d秒",
	RICH_RANK_DESC13 = "砸蛋十次",
	RICH_RANK_DESC14 = "砸蛋一次",
	RICH_RANK_DESC15 = "可获得奖励:",
	RICH_RANK_DESC16 = "获得木槌",
	RICH_RANK_DESC17 = "累充%d元获得",
	RICH_RANK_DESC18 = "木槌数量：%d",
	RICH_RANK_DESC19 = "（今日购买次数:",
	RICH_RANK_DESC20 = "现价",
	RICH_RANK_DESC21 = "木槌数量：%d",
	RICH_RANK_DESC22 = "会    长:",
	RICH_RANK_DESC23 = "副本进度:",
	RICH_RANK_DESC24 = "公会总战力:",
	RICH_RANK_DESC25 = "活动开始第三天晚24点，公会副本进度前十的公会，所有成员都能得到丰厚的奖励。加油冲榜吧！（排行规则等同于公会副本排行）",
	RICH_RANK_DESC26 = "今日已累计充值%0.2f万元",
	RICH_RANK_DESC27 = "限时7天,进化材料大促销",
	RICH_RANK_DESC28 = "今日结算倒计时:%s",
	RICH_RANK_DESC29 = "无限",
	RICH_RANK_DESC30 = "每日对每个名次最多可点赞3次",
	RICH_RANK_DESC31 = "木槌用完啦",
	RICH_RANK_DESC32 = "今日点赞数用完啦",
	RICH_RANK_DESC33 = "可购买次数已用完",
	RICH_RANK_DESC34 = "活动期间，每日累充达到对应标准，即可获得对应数目的木槌，砸蛋可获得：巨量金币，五星六星数码蛋，五星六星装备宝箱，更多豪礼等你来！",
	RICH_RANK_DESC35 = "活动未开启",
	RICH_RANK_DESC36 = "今日已累计充值%d钻石",
	RICH_RANK_DESC37 = "已结束",
	RICH_RANK_DESC38 = "额外获得钻石:",
	RICH_RANK_DESC39 = "%d秒后再试",
	RICH_RANK_DESC40 = "暂未上榜",
	RICH_RANK_DESC41 = "该名次点赞数已达上限",
	RICH_RANK_DESC42 = "可购买次数",

	OPEN_ACT_PRAISE_DESC1 = "参与点赞需要30级哦",

	OPEN_ACT_PRAISE_DESC2 = "名 次",
	OPEN_ACT_PRAISE_DESC3 = "姓 名",
	OPEN_ACT_PRAISE_DESC4 = "充值钻石",
	OPEN_ACT_PRAISE_DESC5 = "返还钻石",
	OPEN_ACT_PRAISE_DESC6 = "昨日排行榜",
	OPEN_ACT_PRAISE_DESC7 = "今天是活动第一天，明天再来看看吧",
	OPEN_ACT_PRAISE_DESC8 = "敬请期待",
	OPEN_ACT_PRAISE_DESC9 = "参与点赞需要30级哦",
	OPEN_ACT_PALACE_DESC1 = "描述在这里。。。。",

	OPEN_ACT_PALACE_DESC1 = "活动期间，每天可以购买限量礼包，内含巨量珍稀进化材料和7S卡碎片！购买次数每日刷新，机会不容错过！想让数码兽队伍更加强力，就趁现在！",


	ACT2_CHARGE_DESC1 = "活动期间，玩家每日充值金额累计达到指定额度即可领取丰厚大礼！每个档次每日仅限参与一次！",
	ACT2_CHARGE_DESC2 = "活动期间，玩家每日单笔充值金额达到指定额度即可领取丰厚大礼！每个档次每日限定参与次数！",
	ACT2_SIGN_DESC1 = "活动期间，每天签到都可免费抽取豪华大礼噢！\n奖品多多，记得每天来签到，不要错过哟！",
	ACT2_SIGN_DESC2 = "当前签到第%d天",
	ACT2_SIGN_DESC3 = "活动已结束",
	ACT2_LUCKY_DESC1 = "转10次",
	ACT2_LUCKY_DESC2 = "开始抽奖",
	ACT2_LUCKY_DESC3 = "攻打战役几率掉落“数”“龙”，屠魔几率掉落“码”“暴”\n集齐“数码暴龙”4个字，可抽奖一次，奖品多多噢！",
	ACT2_CHARGE_DESC3 = "剩余领取次数：",
	ACT2_CHARGE_DESC4 = "剩余领取次数：",
	

	ACT2_PALACE_DESC1 = "原价",
	ACT2_PALACE_DESC2 = "现价",
	ACT2_PALACE_DESC3 = "限时折扣大促销，不容错过！",

	ACT2_MONTH_CARD_DESC1 = "查  看",
	ACT2_MONTH_CARD_DESC2 = "每天领取",
	
	
	ACT2_AWARD_RANK_DESC10 = "本期已累计获得%d张奖券",

	-----------------------11.16
	DEC_NEW_01 = "芯 片",
	DEC_NEW_02 = "升 级",
	DEC_NEW_03 = { --符文的属性
		[102] = "攻击:", --1
		[105] = "生命:", --2
		[103] = "防御:", --3
		[116] = "破甲:", --4
		[106] = "暴击:", --5
		[108] = "坚韧:", --6
		[110] = "命中:", --7
		[109] = "闪避:", --8

		[202] = "攻击:",
		[203] = "防御:",
		--[104] = "攻击+%d"
		[205] = "生命:",
		[206] = "暴击:",
		[208] = "坚韧:",
		[209] = "闪避:",
		[210] = "命中:",
		[211] = "速度:",
		[216] = "破甲:",

		[119] = "格挡:",
		[120] = "破击:",
		[121] = "格挡减免:",
		[122] = "怒气伤害:",
		[123] = "怒气减免:",
		[124] = "破击伤害:",
		[125] = "暴伤减免:",
		[107] = "暴击伤害:",
		
	},
	DEC_NEW_04 = { --符文的属性
		102, --1 --攻击 --对应ID命名规则
		105, --2
		103, --3
		116, --4
		106, --5
		108, --6
		110, --7
		109, --8

		202, --1 --攻击 --对应ID命名规则
		205, --2
		203, --3
		216, --4
		206, --5
		208, --6
		210, --7
		209, --8

		119,120,121,122,123,124,125,107
	},
	DEC_NEW_05 = {
		[102] = "攻击+%d",
		[103] = "防御+%d",
		--[104] = "攻击+%d"
		[105] = "生命+%d",
		[106] = "暴击+%d",
		[107] = "暴击伤害+%d",

		[108] = "坚韧+%d",
		[109] = "闪避+%d",
		[110] = "命中+%d",
		[111] = "速度+%d",
		[116] = "破甲+%d",
		--百分比
		[202] = "攻击+%d%%",
		[203] = "防御+%d%%",
		--[104] = "攻击+%d"
		[205] = "生命+%d%%",
		[206] = "暴击+%d%%",
		[207] = "暴击伤害+%d%%",
		[208] = "坚韧+%d%%",
		[209] = "闪避+%d%%",
		[210] = "命中+%d%%",
		[211] = "速度+%d%%",
		[216] = "破甲+%d%%",

		[119] = "格挡几率+%d",
		[120] = "破击几率+%d",
		--[104] = "攻击+%d"
		[121] = "格挡减免+%d",
		[122] = "怒气伤害+%d",
		[123] = "怒气减免+%d",
		[124] = "破击伤害+%d",
		[125] = "减免暴伤+%d",

	},
	DEC_NEW_06 = "进化5次\n    开放",
	DEC_NEW_07 = "突破一次\n    开放",
	DEC_NEW_08 = "突破二次\n    开放",
	DEC_NEW_09 = "突破三次\n    开放",
	DEC_NEW_10 = "装 备",
	DEC_NEW_11 = "佩戴",
	DEC_NEW_12 = "脱下",
	DEC_NEW_13 = "替换",
	DEC_NEW_14 = "%d件套",
	DEC_NEW_15 = "一键领取",
	DEC_NEW_16 = "一键忽略",
	DEC_NEW_17 = "一键忽略",

	DEC_NEW_18 = "全部领取成功",
	DEC_NEW_19 = "已全部忽略",
	DEC_NEW_20 = "已全部忽略",
	DEC_NEW_21 = "你没有选择任意一个芯片",
	DEC_NEW_22 = "已升到顶级！",

	DEC_NEW_23 = "只能放5个",
	DEC_NEW_24 = "玩家等级限制",

	-------------------日常副本
	DEC_NEW_25 = "剩余次数",
	DEC_NEW_26 = "挑 战",
	DEC_NEW_27 = " 周%s\n开启",
	DEC_NEW_28 = {
		"一",
		"二",
		"三",
		"四",
		"五",
		"六",
		"日",
	},
	DEC_NEW_29 = "解锁战力",
	DEC_NEW_30 = "挑战次数不足",
	DEC_NEW_31 = "购买次数已达上限",
	DEC_NEW_32 = "今日购买次数已用完,充值成为更高",
	DEC_NEW_33 = "活动已结束，请重新刷新界面",
	DEC_NEW_34 = "不能穿戴同类型的芯片",
	DEC_NEW_35 = "剩余徽章:",
	DEC_NEW_36 = " 周%s开启",
	DEC_NEW_37 = "没有可吞噬的芯片",
	DEC_NEW_38 = "足够升到顶级了",
	DEC_NEW_39 = "需研发后才可领取奖励",
	DEC_NEW_40 = "今日还未打副本",
	DEC_NEW_41 = "数码兽",
	DEC_NEW_42 = "合成需要：",
	DEC_NEW_43 = "合 成",
	DEC_NEW_44 = "亲密小伙伴即将到来",
	DEC_NEW_45 = "亲密小伙伴即将到来",
	DEC_NEW_46 = "你选择的是自己已装备的",
	DEC_NEW_47 = "当前副本章节过低，无法领取",
	DEC_NEW_48 = "领取",
	DEC_NEW_49 = "卖出垃圾",
	DEC_NEW_50 = "召唤",
	DEC_NEW_51 = "次",
	DEC_NEW_52 = "神魂值不够",
	DEC_NEW_53 = "当前能源更高级，先召唤芯片吧！",
	DEC_NEW_54 = "当前已是银河能源，先召唤芯片吧！",
	DEC_NEW_55 = "是否消耗钻石",
	DEC_NEW_56 = "召唤银河能源(必定获得1个万能碎片）",
	DEC_NEW_57 = "是否出售全部垃圾（返还神魂）",
	DEC_NEW_58 = "没有芯片可以领取",
	DEC_NEW_59 = "卖 出",
	DEC_NEW_60 = "召 唤",
	DEC_NEW_61 = "此功能需要VIP3开启",
	DEC_NEW_62 = "背包芯片已满，是否前往吞噬",
	DEC_NEW_63 = "当前芯片过多，先领取或者出售",
	--DEC_NEW_63 = "神魂值不够",
	DUI_DEC_64 = "属性统计",

	DUI_DEC_65 = {
		{ pro = 102,sort = 1},
		{ pro = 105,sort = 2},
		{ pro = 116,sort = 3},
		{ pro = 103,sort = 4},
		{ pro = 110,sort = 5},
		{ pro = 109,sort = 6},
		{ pro = 106,sort = 7},
		{ pro = 108,sort = 8},
		{ pro = 120,sort = 9},
		{ pro = 119,sort = 10},
		{ pro = 122,sort = 11},
		{ pro = 123,sort = 12},
		{ pro = 107,sort = 13},
		{ pro = 125,sort = 14},
		{ pro = 124,sort = 15},
		{ pro = 121,sort = 16},
		--百分比
		--[[[102] = "攻击+%d",
		[103] = "防御+%d",
		--[104] = "攻击+%d"
		[105] = "生命+%d",
		[106] = "暴击+%d",
		[108] = "坚韧+%d",
		[109] = "闪避+%d",
		[110] = "命中+%d",
		[111] = "速度+%d",
		[116] = "破甲+%d",
		[202] = "攻击+%d%%",
		[203] = "防御+%d%%",
		--[104] = "攻击+%d"
		[205] = "生命+%d%%",
		[206] = "暴击+%d%%",
		[208] = "坚韧+%d%%",
		[209] = "闪避+%d%%",
		[210] = "命中+%d%%",
		[211] = "速度+%d%%",
		[216] = "破甲+%d%%",]]--
	},

	DUI_DEC_66 = {
		"命中:增加命中对方的几率",
		"闪避:增加闪避对方攻击的几率",
		"暴击:增加攻击打出暴击的几率",
		"坚韧:减少被对方暴击的几率",
		"格挡:增加格挡对方攻击部分伤害的几率",
		"破击:减少对方格挡的几率",
		"怒气伤害:增加怒气技能的伤害",
		"怒气减免:减少对方怒气技能的伤害",
		"格挡减免:增加格挡时的格挡减免伤害",
		"破击伤害:增加对方格挡时收到的伤害",
	},

	DUI_DEC_67 = "吞噬列表中有品质较高的，是否继续",
	DUI_DEC_68 = "1.充值30或者200可获赠月卡或终身卡福利(到期后可续费)。",
	DUI_DEC_69 = "2.充值月卡或终身卡可激活领取所有活动奖励以及vip经验。",
	DUI_DEC_70 = "3.限时领取，还剩",
	DUI_DEC_71 = "%d天",
	DUI_DEC_72 = "，快快领取。",
	DUI_DEC_73 = "每天领取",
	DUI_DEC_74 = "终身卡和月卡奖励可叠加，未领取的每日24点邮件发送。",
	DUI_DEC_75 = "还剩%d天",
	DUI_DEC_76 = "充值%d元",

	DUI_DEC_77 = "转    生",
	DUI_DEC_78 = "领取完毕",
	DUI_DEC_79 = "已领取",
	DUI_DEC_80 = "领  取",
	DUI_DEC_81 = "领取成功",
	DUI_DEC_82 = "转生后将:",
	DUI_DEC_83 = "拥有全新的技能、天赋继承所有属\n性并激活所有原有天赋",
	DUI_DEC_84 = "转生需达到条件:",
	DUI_DEC_85 = "通关战役%s第%d节",
	DUI_DEC_86 = "转生预览",
	DUI_DEC_87 = "转 生",
	DUI_DEC_88 = "转生条件未达成",
	DUI_DEC_89 = "3.月卡活动结束",
	DUI_DEC_90 = "%d时",
	DUI_DEC_91 = "%d分",
	DUI_DEC_92 = "%d秒",
	DUI_DEC_93 = "全部芯片领取成功，请到芯片背包查看",

	---------------------------
	RES_RES_01 = "不在购买时间",
	RES_RES_02 = "已经购买了",
	RES_RES_03 = "进 化",
	RES_RES_04 = "转生",
	RES_RES_05 = "定 级 赛",
	RES_RES_06 = "排位次数",
	RES_RES_07 = "每日奖励",
	RES_RES_08 = "拥有",
	RES_RES_09 = "奖励将在每天24点通过邮件发放!",
	RES_RES_10 = "排位赛冲刺到最强王者后，可参加每赛季的王者之战。",
	RES_RES_11 = "预计时间:",
	RES_RES_12 = "匹配时间:",
	RES_RES_13 = "拥有万能碎片:",
	RES_RES_14 = "每次使用钻石召唤银河能源，都可获得1个万能碎片",
	RES_RES_15 = "兑 换",
	RES_RES_16 = "万能碎片不足",
	RES_RES_17 = "排位战绩",
	RES_RES_18 = "跨服排名",
	RES_RES_19 = "当前段位",
	RES_RES_20 = "下个段位",
	RES_RES_21 = "上赛季段位",
	RES_RES_22 = "下段奖励",
	RES_RES_23 = {
		"白银一段",
		"白银二段",
		"白银三段",
		"白银四段",
		"白银五段",
		"最强王者",
	},
	RES_RES_24 = "我的排名:",
	RES_RES_25 = "卖出获得神魂+%d",
	RES_RES_26 = "排名奖励",
	RES_RES_27 = "排名奖励将在王者之战结束后通过邮件发送",
	RES_RES_28 = "最强王者",
	RES_RES_29 = "还不能竞猜",
	RES_RES_30 = "膜拜人数",
	RES_RES_31 = "膜拜奖励",
	RES_RES_32 = "没有垃圾可售出",
	RES_RES_33 = "胜点",
	RES_RES_34 = {"化石能源","以太能源","时空能源","银河能源","宇宙能源"},
	RES_RES_35 = "跨服战未开启",
	RES_RES_36 = "五",
	RES_RES_37 = "你在进行晋级赛，不消耗排位次数哦！努力加油吧!",
	RES_RES_38 = "你在进行定级赛，不消耗排位次数哦！努力加油吧!",
	RES_RES_39 = "很遗憾，你的排位赛段位下降至%s努力加油吧！",
	RES_RES_40 = "你已晋升%s!再接再厉!",
	RES_RES_41 = "祝贺你",
	RES_RES_42 = "晋 级 赛",
	RES_RES_43 = "背包没有比当前品质更低的,试试手动添加吧",
	RES_RES_44 = "恭喜你获得:",
	RES_RES_45 = "%d连胜",
	RES_RES_46 = "胜点加成:",
	RES_RES_47 = "你的%d连胜被终结了",
	RES_RES_48 = "跨服战正在准备中",
	RES_RES_49 = "没有排位次数",
	RES_RES_50 = "重置倒计时:",
	RES_RES_51 = "未上榜",
	RES_RES_52 = "王者组前16名可参加最终决战",
	RES_RES_53 = "王者之战还未结束",
	RES_RES_54 = "很遗憾，你的段位晋升失败,努力加油吧！",
	RES_RES_55 = "抽%d次",
	RES_RES_56 = "已投注",
	RES_RES_57 = "下届报名:",
	RES_RES_58 = "竞猜",
	RES_RES_59 = "录像",
	RES_RES_60 = "你已经竞猜过了",
	RES_RES_61 = "本场比赛还未到竞猜时间",
	RES_RES_62 = "本场比赛将轮空，无法竞猜",
	RES_RES_63 = "膜拜成功,获得神魂+%d",
	RES_RES_64 = "王者之战开始倒计时：",
	RES_RES_65 = "竞猜倒计时：",
	RES_RES_66 = "比赛进行中：",
	RES_RES_67 = "第一赛季尚未结束！",
	RES_RES_68 = "只有本人才能留言",
	RES_RES_69 = "最强王者冠军",
	RES_RES_70 = "留言:",
	RES_RES_71 = "我是最强的，压我准没错！",
	RES_RES_72 = "你已经竞猜过了",
	RES_RES_73 = "竞猜成功!",
	RES_RES_74 = "战斗进行中，不能竞猜!",
	RES_RES_75 = "暂无数据!",
	RES_RES_76 = "今日不再提示",
	RES_RES_77 = "轮空",
	RES_RES_78 = "   7星套装不是梦！首次充值单笔",
	RES_RES_79 = "1000",
	RES_RES_80 = "特别放送",
	RES_RES_81 = "7星套装",
	RES_RES_82 = ",助",
	RES_RES_83 = "你成为王者迎娶白富美走上战力巅峰，快来领取吧!",
	RES_RES_84 = "数码兽已经存在了",
	RES_RES_85 = "钻石赚钻石，福利送不不停！",
	RES_RES_86 = "今天全部兑换可赚",
	RES_RES_87 = "明天登陆更多   可赚",
	RES_RES_88 = "兑换钻石",
	RES_RES_89 = "下次兑换倒计时:",
	RES_RES_90 = "兑换完毕",
	RES_RES_91 = "兑换成功,钻石+%d",
	RES_RES_92 = "本服务器已爆满！请前往新服务器注册！",
	RES_RES_93 = "领 取",
	RES_RES_94=  "格挡    :",

	RES_VIP_VIP = "VIP", --VIP 

	---果实合成开始
	FRUIT_DESC1 = "力量果实",
	FRUIT_DESC2 = "防护果实",
	FRUIT_DESC3 = "能力果实",
	FRUIT_DESC4 = "攻击力",
	FRUIT_DESC5 = "完成进度",
	FRUIT_DESC6 = "果实属性只和阵型位置有关，与数码兽无关。",
	FRUIT_DESC7 = "合 成",
	FRUIT_DESC8 = "合成花费",
	FRUIT_DESC9 = "已合成",
	FRUIT_DESC10 = "请选择需要出售的数量",
	FRUIT_DESC11 = "总价",
	FRUIT_DESC12 = "出 售",
	FRUIT_DESC13 = "关 闭",
	FRUIT_DESC14 = "合成材料不足",
	FRUIT_DESC15 = "金币不足",
	FRUIT_DESC16 = "对应章节关卡未开启",
	FRUIT_DESC17 = "出售成功，获得%d金币",
	FRUIT_DESC18 = "合成成功",



	FRUIT_STEP_NUM = {"一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五"},
	FRUIT_PAGE_TYPE = {"%s阶力量果实", "%s阶防护果实", "%s阶能力果实"},
	FRUIT_ATTR_DESC = 
	{
	"攻击","生命","护甲","破甲","暴击","坚韧","命中",
	"闪避","破击几率","格挡几率","暴击伤害","减免暴伤",
	"怒气伤害","怒气减免","破击伤害","格挡减免","战斗力",
	},

	FRUIT_PAGE_PRO = {"攻击","生命"},

	RES_GG_01 = "   7星不是梦！活动时间内,首次充值单笔",
	RES_GG_02 = "100元",
	RES_GG_03 = "特别放送",
	RES_GG_04 = "7星数码蛋",
	RES_GG_05 = ",",
	RES_GG_06 = "助你成为王者迎娶白富美走上战力巅峰，快来领取吧!",
	RES_GG_07 = "公告",
	RES_GG_08 = "%d级可点赞",

	RES_GG_09 = "上阵小伙伴，可激活上阵数码兽的亲密",
	RES_GG_10 = "当前总亲密:",
	RES_GG_11 = "%d级\n开启",
	RES_GG_12 = "上阵小伙伴，可激活上阵数码兽的亲密",
	RES_GG_13 = "上 阵",
	RES_GG_14 = "的亲密",
	RES_GG_15 = "激活",
	RES_GG_16 = "可激活亲密+%d",
	RES_GG_17 = "活动已经结束了",
	RES_GG_18 = "还没有到兑换时间",
	RES_GG_19 = "取 出",
	RES_GG_20 = "放入%s",
	RES_GG_21 = "恭喜%s获得本轮胜利",
	RES_GG_22 = "本轮比赛晋级者:",
	RES_GG_23 = "请完成上一个科技核心",
	RES_GG_24 = "%s宝箱",
	RES_GG_25 = "还没有完成收集",
	RES_GG_26 = "你没有权限改公会名",
	RES_GG_27 = "取出数码兽会降低上阵属性，确定要取出吗？",
	RES_GG_28 = "吞噬后数码兽不可再取出，可获得宝箱奖励，确定吞噬吗？",
	RES_GG_29 = "放入全部形态后可以吞噬领取",
	RES_GG_30 = "吞噬领取",
	RES_GG_31 = "被吞噬数码兽是特殊数码兽，是否继续？",
	RES_GG_32 = "原名字:",
	RES_GG_33 = "新名字:",
	RES_GG_34 = "注:",
	RES_GG_35 = "修改次数仅限一次",
	RES_GG_36 = "改 名",
	RES_GG_38 = "7星套装",
	RES_GG_39 = "活跃商店",
	RES_GG_40 = "距离开战还剩",
	RES_GG_41 = "血量",
	RES_GG_42 = "世界战力加成:",
	RES_GG_43 = "自动参战",
	RES_GG_44 = "(vip2或60级)",
	RES_GG_45 = "战斗进行中",
	RES_GG_46 = "复活倒数计时:%d秒",
	RES_GG_47 = "普通鼓舞",
	RES_GG_48 = "特别鼓舞",
	RES_GG_49 = "鼓舞世界可以提高所有参战玩家攻击力，\n更有利于击杀BOSS，还可直接获得丰厚\n的鼓舞奖励！",
	RES_GG_50 = "花费",
	RES_GG_51 = "可获得小奖励",
	RES_GG_52 = "可获得大奖励",
	RES_GG_53 = "领取成功",
	RES_GG_54 = "领 取",
	RES_GG_55 = "如果挑战失败，则无法获得奖励",
	RES_GG_56 = "击杀奖",
	RES_GG_57 = "奖励           ",
	RES_GG_58 = "BOSS死亡奖励",
	RES_GG_59 = "总伤害： %s",
	RES_GG_60 = "我的排名:",
	RES_GG_61 = "未入榜",
	RES_GG_62 = "战斗结束后邮件统一发放",
	RES_GG_63 = "我的伤害:",
	RES_GG_64 = "VIP2或60级开启",
	RES_GG_65 = "世界Boss活动已经结束",
	RES_GG_66 = "这轮世界boss已经鼓舞过了",
	RES_GG_67 = "你已设置了自动参战，不能手动参战了",
	RES_GG_68 = "世界boss战斗冷却中",
	RES_GG_69 = "等级到达30才能参与世界boss战斗",
	RES_GG_70 = "虚位以待",
	RES_GG_71 = "造成伤害",
	RES_GG_72 = "",
	RES_GG_73 = "战斗结束",
	RES_GG_74 = "每天0点重置",
	RES_GG_75 = "可获得%d点活跃值",
	RES_GG_76 = "购 买",
	RES_GG_77 = "拥有",
	RES_GG_78 = "快速刷新",
	RES_GG_79 = "刷新消耗",
	RES_GG_80 = "活跃币不够",
	RES_GG_81 = "解锁条件1：玩家达到%d级",
	RES_GG_82 = "吞噬收集完对应系统中所有数码兽即可领取",
	RES_GG_83 = "当日活跃值达到%d即可领取",
	RES_GG_84 = " ",
	RES_GG_85 = " ",
	RES_GG_86 = "时间过期",
	RES_GG_87 = "续  费",
	RES_GG_88 = "已续费",
	RES_GG_89 = "奖励",
	RES_GG_90 = "活动结束倒计时",
	RES_GG_91 = "的私信",

	NET_MGR_DESC1 = "哎呀~~ 掉线了呢",
	NET_MGR_DESC2 = "重连",
	NET_MGR_DESC3 = "哎呀~~ 连接失败",
	NET_MGR_DESC4 = "哎呀~~ 异地登陆",
	NET_MGR_DESC5 = "确定",
	NET_MGR_DESC6 = "哎呀~~ 服务器关闭",
	NET_MGR_DESC7 = "哎呀~~ 连接失败",
	NET_MGR_DESC8 = "哎呀~~验证失败",
	NET_MGR_DESC9 = "确 定",

	SELECT_PET_DESC1 = "选择",

	TIPS_DESC_MASTER = "主人,",

	ACT2_AWARD_RANK_DESC1 = "奖金说明",
	ACT2_AWARD_RANK_DESC2 = "%d时%d分%d秒",
	ACT2_AWARD_RANK_DESC3 = "本期特奖号码：%d",
	ACT2_AWARD_RANK_DESC4 = "幸运玩家：%s",
	ACT2_AWARD_RANK_DESC5 = "所有奖项均从玩家拥有奖券中抽取，不会流空！",
	ACT2_AWARD_RANK_DESC6 = "本期奖券",
	ACT2_AWARD_RANK_DESC7 = "中奖名单",
	ACT2_AWARD_RANK_DESC8 = "本期已获得奖券：%d张",
	ACT2_AWARD_RANK_DESC9 = "活动期间内，每日累充每达到6元即可获得一张奖券，多充多得，每晚十点开奖，幸运大奖等你来中！",
	ACT2_AWARD_RANK_DESC10 = "特等奖",
	ACT2_AWARD_RANK_DESC11 = "奖金",
	ACT2_AWARD_RANK_DESC12 = "奖券号码:",
	ACT2_AWARD_RANK_DESC13 = "中奖玩家:",
	ACT2_AWARD_RANK_DESC14 = "一等奖",
	ACT2_AWARD_RANK_DESC15 = "二等奖",
	ACT2_AWARD_RANK_DESC16 = "三等奖",
	ACT2_AWARD_RANK_DESC17 = "幸运奖",
	ACT2_AWARD_RANK_DESC18 = "本期奖券：%d张",
	ACT2_AWARD_RANK_DESC19 = "上期奖券：%d张",	
	ACT2_AWARD_RANK_DESC20 = "上期奖券",
	ACT2_AWARD_RANK_DESC21 = "奖券数量不足，无人中奖",
	ACT2_AWARD_RANK_DESC40 = "活动已结束！",

	ACT_DEC_1 = "活动期间,可以花费钻石打开福袋，奖励预览显示在下方。若不满意\n其中的奖励，可以刷新重置。每日还有免费次数，来试试运气吧！",
	ACT_DEC_2 = "福袋刷新倒计时",
	ACT_DEC_3 = "福袋刷新",
	ACT_DEC_4 = "刷新花费",
	ACT_DEC_5 = "刷新次数",
	ACT_DEC_6 = "活动期间,每天登录即可抽取红包！66-666钻石，驯兽师们手气如何呢？\n每天可抽取一次，免费领钻石！不容错过！",
	ACT_DEC_7 = "领取一次",
	ACT_DEC_8 = "刷新次数已用完",
	ACT_DEC_9 = "刷新一次",
	ACT_DEC_10 = "恭喜你获得%d钻石",

	ACT2_LIMIT_DESC1 = "活动时间：",
	ACT2_LIMIT_DESC2 = "活动福利：",
	ACT2_LIMIT_DESC3 = "数码暴龙与大家共迎新年！连续14天，每天登录，精彩不断！\n活动期间，各种奖励，各种豪礼等着大家！一定不可以错过噢！",
	ACT2_LIMIT_DESC4 = "本期精彩活动日期",
	ACT2_LIMIT_DESC5 = "%d月%d日%d时-%d月%d日%d时",
}



return res