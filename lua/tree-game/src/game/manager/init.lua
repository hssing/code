local mgr = {}

--场景管理器
mgr.SceneMgr 	= import(".SceneMgr").new()

--网络管理(socket)
mgr.NetMgr 		= import(".NetMgr").new()

--视图管理
mgr.ViewMgr 	= import(".ViewMgr").new()

mgr.PathMgr 	= import(".PathMgr")

mgr.ConfMgr 	= import(".ConfMgr")

--动画管理
mgr.Animation   =  import(".AnimationMgr").new()

--动画加载
mgr.BoneLoad    = import(".BoneLoadMgr").new()

--战斗系统
mgr.Fight       = import(".FightMgr").new()

--角色动作
mgr.playerAction= import(".PlayerActionMgr")

--效果
mgr.effect      = import(".EffectMgr")

--引导
mgr.Guide       = import(".GuideMgr").new()

--声音
mgr.Sound       = import(".SoundMgr").new()

return mgr