var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui) {
    var Home = (function (_super) {
        __extends(Home, _super);
        function Home() {
            var _this = _super.call(this, Home.CUSTOM) || this;
            _this.addEventListener(egret.Event.RENDER, _this.render, _this);
            return _this;
        }
        Home.prototype.render = function () {
            this.removeEventListener(egret.Event.RENDER, this.render, this);
            this.chatText1 = new egret.TextField();
            this.chatText2 = new egret.TextField();
            var x = this.headChat1.x;
            var headChat1Y = this.headChat1.y;
            var headChat2Y = this.headChat2.y;
            var width = 25;
            this.chatText1.x = x + width;
            this.chatText1.y = headChat1Y;
            this.chatText2.x = x + width;
            this.chatText2.y = headChat2Y;
            this.chatGroup.addChild(this.chatText1);
            this.chatGroup.addChild(this.chatText2);
            this.createChatText();
        };
        Home.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
        };
        Home.prototype.onBtnHome = function (e) {
            var label = new eui.Label();
            console.log("onBtnHome");
            Prompt.popTip("This is a tip -- " + Math.random());
            //UIMgr.getGuide().createGuide(2);
        };
        Home.prototype.onBtnBag = function (e) {
            console.log("onBtnBag");
        };
        Home.prototype.onBtnHero = function (e) {
            console.log("onBtnHero");
        };
        Home.prototype.createChatText = function () {
            this.chatText1.textFlow = [
                { text: "(硬汉部队) ", style: { "size": 18, "textColor": 0xa180bc } },
                { text: "皇菜菜 ", style: { "size": 18, "textColor": 0xc89170 } },
                { text: "：通关之路又进一步", style: { "size": 18, "textColor": 0xbbb6ae } },
            ];
            this.chatText2.textFlow = [
                { text: "(硬汉部队) ", style: { "size": 18, "textColor": 0xa180bc } },
                { text: "皇菜菜 ", style: { "size": 18, "textColor": 0xc89170 } },
                { text: "：通关之路又进一步", style: { "size": 18, "textColor": 0xbbb6ae } },
            ];
        };
        Home.prototype.onBtnTroops = function () {
            Prompt.popTip("功能开发中");
            UIMgr.open(ui.CampMain);
        };
        Home.prototype.onBtnSoilder = function () {
            Prompt.popTip("功能开发中");
        };
        Home.prototype.onBtnGoods = function () {
            Prompt.popTip("功能开发中");
        };
        Home.prototype.onBtnTask = function () {
            Prompt.popTip("功能开发中");
        };
        Home.prototype.onBtnRecruit = function () {
            Prompt.popTip("功能开发中");
        };
        Home.prototype.onBtnShop = function () {
            Prompt.popTip("功能开发中");
        };
        Home.prototype.onBtnActivity = function () {
            Prompt.popTip("功能开发中a");
            var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            for (var i = 0; i < armyInfo.length; i++) {
                var build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[i].army_id);
                var army_id = armyInfo[i].army_id;
                var pos = 1;
                var soldier_type = 1;
                //item.armyName = armyInfo[i].army_id;
                var data = { build_id: build_id, army_id: army_id, pos: pos, soldier_type: soldier_type };
                NetMgr.get(msg.Army).send("m_army_set_soldier_tos", data);
            }
        };
        return Home;
    }(UIBase));
    Home.CUSTOM = {
        skinName: "resource/ui/HomeUISkin.exml",
        binding: (_a = {},
            _a["btnTroops"] = { method: "onBtnTroops", },
            _a["btnSoilder"] = { method: "onBtnSoilder", },
            _a["btnGoods"] = { method: "onBtnGoods", },
            _a["btnTask"] = { method: "onBtnTask", },
            _a["btnRecruit"] = { method: "onBtnRecruit" },
            _a["btnShop"] = { method: "onBtnShop" },
            _a["btnActivity"] = { method: "onBtnActivity" },
            _a),
    };
    ui.Home = Home;
    __reflect(Home.prototype, "ui.Home");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=Home.js.map