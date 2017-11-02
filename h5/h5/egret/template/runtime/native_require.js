
var game_file_list = [
    //以下为自动修改，请勿修改
    //----auto game_file_list start----
	"libs/modules/egret/egret.js",
	"libs/modules/egret/egret.native.js",
	"libs/modules/eui/eui.js",
	"libs/modules/game/game.js",
	"resourcemanager/resourcemanager.js",
	"libs/modules/tween/tween.js",
	"libs/modules/socket/socket.js",
	"libs/modules/protobuf/protobuf.js",
	"polyfill/polyfill.js",
	"bin-debug/Module/Event.js",
	"bin-debug/Module/TMap/Layer.js",
	"bin-debug/Module/UIBase.js",
	"bin-debug/Module/Animat.js",
	"bin-debug/Module/World/View.js",
	"bin-debug/Module/IRBase.js",
	"bin-debug/Module/Logic.js",
	"bin-debug/Module/NetMsg.js",
	"bin-debug/Module/Actor/Base/PlayerView.js",
	"bin-debug/Module/TMap/Layer/Background.js",
	"bin-debug/Module/TMap/Layer/TileLayer.js",
	"bin-debug/Module/Actor/VO/PlayerVO.js",
	"bin-debug/Module/Utils/Color.js",
	"bin-debug/Module/Utils/Misc.js",
	"bin-debug/Module/World/ArmyMgr.js",
	"bin-debug/Module/TMap/MapReader.js",
	"bin-debug/Analyzer/ProtoAnalyzer.js",
	"bin-debug/Module/Actor/Base/ProgressBar.js",
	"bin-debug/Module/Actor/MonsterView.js",
	"bin-debug/Module/Actor/RoleView.js",
	"bin-debug/Module/Actor/VO/PhalanxVO.js",
	"bin-debug/Component/MapScroller.js",
	"bin-debug/Module/Actor/VO/RoleVO.js",
	"bin-debug/Component/TouchScroll.js",
	"bin-debug/Config.js",
	"bin-debug/Module/Fight/Bullet.js",
	"bin-debug/Module/Fight/FightMgr.js",
	"bin-debug/Module/Fight/FightTest.js",
	"bin-debug/LoadingUI.js",
	"bin-debug/Logic/Build.js",
	"bin-debug/Module/LogicMgr.js",
	"bin-debug/Module/NetCenter.js",
	"bin-debug/Module/NetMgr.js",
	"bin-debug/Logic/Camp.js",
	"bin-debug/Module/Prompt.js",
	"bin-debug/Module/ServerTime.js",
	"bin-debug/Module/Singleton.js",
	"bin-debug/Module/Timer.js",
	"bin-debug/Module/TMap.js",
	"bin-debug/Module/TMap/Camera.js",
	"bin-debug/Module/TMap/Coordinate.js",
	"bin-debug/Module/TMap/Data.js",
	"bin-debug/Module/TMap/DynamicCells.js",
	"bin-debug/Logic/Fight.js",
	"bin-debug/Logic/Guide.js",
	"bin-debug/Logic/Home.js",
	"bin-debug/Module/TMap/Layers.js",
	"bin-debug/AssetAdapter.js",
	"bin-debug/Module/TMap/Strategy/Dynamic.js",
	"bin-debug/Module/TMap/Strategy/Tile.js",
	"bin-debug/Logic/Login.js",
	"bin-debug/Module/UIMgr.js",
	"bin-debug/Logic/Player.js",
	"bin-debug/Logic/World.js",
	"bin-debug/Module/Utils/Tool.js",
	"bin-debug/Main.js",
	"bin-debug/Module/World/FrameTask.js",
	"bin-debug/Module/World/Helper.js",
	"bin-debug/Module/World/Manager.js",
	"bin-debug/Module/World/PhalanxMgr.js",
	"bin-debug/Module/World/UnitMgr.js",
	"bin-debug/Module/Actor/Base/PlayerSinger.js",
	"bin-debug/Module/World/View/Academy.js",
	"bin-debug/Module/World/View/ArmyView.js",
	"bin-debug/Module/World/View/Arsenal.js",
	"bin-debug/Module/World/View/Camp.js",
	"bin-debug/Module/World/View/Castle.js",
	"bin-debug/Module/World/View/Phalanx.js",
	"bin-debug/Module/World/View/Radar.js",
	"bin-debug/Module/World/View/Resource.js",
	"bin-debug/Module/World/View/Tablet.js",
	"bin-debug/NetMsg/Army.js",
	"bin-debug/NetMsg/Build.js",
	"bin-debug/NetMsg/Fight.js",
	"bin-debug/NetMsg/Login.js",
	"bin-debug/NetMsg/Map.js",
	"bin-debug/Struct.js",
	"bin-debug/ThemeAdapter.js",
	"bin-debug/View/ActionMenu.js",
	"bin-debug/View/ActionMenu/BuildMenu.js",
	"bin-debug/View/ArmyMove/ArmyMove.js",
	"bin-debug/View/ArmyMove/ArmyMoveItem.js",
	"bin-debug/View/Camp/CampMain.js",
	"bin-debug/View/Camp/SoldierHeadItem.js",
	"bin-debug/View/CampDetail.js",
	"bin-debug/View/CreateRole.js",
	"bin-debug/View/GameLoadingUI.js",
	"bin-debug/View/Guide.js",
	"bin-debug/View/Home.js",
	"bin-debug/View/Location.js",
	"bin-debug/View/Login.js",
	"bin-debug/View/LoginLoadingUI.js",
	"bin-debug/View/NetTip.js",
	"bin-debug/View/ServerList.js",
	"bin-debug/View/World.js",
	//----auto game_file_list end----
];

var window = this;

egret_native.setSearchPaths([""]);

egret_native.requireFiles = function () {
    for (var key in game_file_list) {
        var src = game_file_list[key];
        require(src);
    }
};

egret_native.egretInit = function () {
    if(egret_native.featureEnable) {
        //控制一些优化方案是否开启
        var result = egret_native.featureEnable({
            
        });
    }
    egret_native.requireFiles();
    //egret.dom为空实现
    egret.dom = {};
    egret.dom.drawAsCanvas = function () {
    };
};

egret_native.egretStart = function () {
    var option = {
        //以下为自动修改，请勿修改
        //----auto option start----
		entryClassName: "Main",
		frameRate: 30,
		scaleMode: "fixedWidth",
		contentWidth: 720,
		contentHeight: 1140,
		showPaintRect: false,
		showFPS: true,
		fpsStyles: "x:0,y:0,size:12,textColor:0xffffff,bgAlpha:0.9",
		showLog: true,
		logFilter: "",
		maxTouches: 2,
		textureScaleFactor: 1
		//----auto option end----
    };

    egret.native.NativePlayer.option = option;
    egret.runEgret();
    egret_native.Label.createLabel("/system/fonts/DroidSansFallback.ttf", 20, "", 0);
    egret_native.EGTView.preSetOffScreenBufferEnable(true);
};