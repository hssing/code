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
    var CampMain = (function (_super) {
        __extends(CampMain, _super);
        function CampMain() {
            return _super.call(this, CampMain.CUSTOM) || this;
        }
        CampMain.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
            this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
            this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
            LogicMgr.get(logic.Camp).on(logic.Camp.EVT.SOLDIER_TOUCH_BEGIN, this.Event("onSoldierTouchBegin"));
            NetMgr.get(msg.Army).on("m_army_set_soldier_toc", this.Event("onArmySetSoldier"));
            this.soldierData = RES.getRes("SoldierConfig_json");
            var data = this.getDataByType(SoldierType.Human);
            this.refeshData(data);
            this.point = new egret.Point();
            this.initArmy();
        };
        CampMain.prototype.onArmySetSoldier = function (param) {
        };
        CampMain.prototype.initArmy = function () {
            var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            for (var i = 0; i < armyInfo.length; i++) {
                this.refeshForWrdPhalanx(armyInfo[i].forward_phalanx);
                this.refeshCenterPhalanx(armyInfo[i].center_phalanx);
                this.refeshBackPhalanx(armyInfo[i].back_phalanx);
            }
        };
        CampMain.prototype.refeshForWrdPhalanx = function (phalanx) {
            if (phalanx.soldiers_id === 0) {
                return;
            }
            this.preHeadGroup.visible = true;
            this.preHeadBg.source = this.soldierData[phalanx.soldiers_id].portrait;
        };
        CampMain.prototype.refeshCenterPhalanx = function (phalanx) {
            if (phalanx.soldiers_id === 0) {
                return;
            }
            this.midHeadGroup.visible = true;
            this.midHeadBg.source = this.soldierData[phalanx.soldiers_id].portrait;
        };
        CampMain.prototype.refeshBackPhalanx = function (phalanx) {
            if (phalanx.soldiers_id === 0) {
                return;
            }
            this.backHeadGroup.visible = true;
            this.backHeadBg.source = this.soldierData[phalanx.soldiers_id].portrait;
        };
        CampMain.prototype.setSoldier = function (build_id, army_id, pos, soldier_type) {
            //item.armyName = armyInfo[i].army_id;
            var data = { build_id: build_id, army_id: army_id, pos: pos, soldier_type: soldier_type };
            NetMgr.get(msg.Army).send("m_army_set_soldier_tos", data);
        };
        CampMain.prototype.onTouchBegin = function (e) {
            console.log("CampMain===onBegin");
            this.point.x = e.stageX;
            this.point.y = e.stageY;
        };
        CampMain.prototype.onTouchMove = function (e) {
            console.log("CampMain===onMove");
            if (this.isClickedItem == false || !this.group) {
                this.point.x = e.stageX;
                this.point.y = e.stageY;
                return;
            }
            this.group.x += e.stageX - this.point.x;
            this.group.y += e.stageY - this.point.y;
            this.point.x = e.stageX;
            this.point.y = e.stageY;
        };
        CampMain.prototype.onTouchEnd = function (e) {
            console.log("CampMain===onTouchEnd");
            if (this.isClickedItem == false || !this.group) {
                return;
            }
            this.isClickedItem = false;
            this.group.parent.removeChild(this.group);
            this.group = null;
            if (this.preGroup.hitTestPoint(e.stageX, e.stageY)) {
                console.log("====this.preGroup");
                var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
                armyInfo[0].forward_phalanx.soldiers_id = parseInt(this.data.id);
                armyInfo[0].forward_phalanx.hp = 100;
                this.refeshForWrdPhalanx(armyInfo[0].forward_phalanx);
                var build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[0].army_id);
                this.setSoldier(build_id, armyInfo[0].army_id, 1, parseInt(this.data.id));
            }
            if (this.midGroup.hitTestPoint(e.stageX, e.stageY)) {
                console.log("===midGroup");
                var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
                armyInfo[0].center_phalanx.soldiers_id = parseInt(this.data.id);
                armyInfo[0].center_phalanx.hp = 100;
                this.refeshCenterPhalanx(armyInfo[0].center_phalanx);
                var build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[0].army_id);
                this.setSoldier(build_id, armyInfo[0].army_id, 2, parseInt(this.data.id));
            }
            if (this.backGroup.hitTestPoint(e.stageX, e.stageY)) {
                console.log("===backGroup");
                var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
                armyInfo[0].back_phalanx.soldiers_id = parseInt(this.data.id);
                armyInfo[0].back_phalanx.hp = 100;
                this.refeshBackPhalanx(armyInfo[0].back_phalanx);
                var build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[0].army_id);
                this.setSoldier(build_id, armyInfo[0].army_id, 3, parseInt(this.data.id));
            }
        };
        CampMain.prototype.onSoldierTouchBegin = function (group, data) {
            this.group = group;
            this.groupPoint = this.group.localToGlobal(0, 0);
            this.group.parent.removeChild(this.group);
            this.addChild(this.group);
            this.group.x = this.groupPoint.x;
            this.group.y = this.groupPoint.y;
            this.isClickedItem = true;
            this.data = data;
        };
        CampMain.prototype.getDataByType = function (type) {
            var data = [];
            for (var key in this.soldierData) {
                if (type !== this.soldierData[key].fight_type) {
                    continue;
                }
                var item = { "id": null,
                    "type": null,
                    "fight_type": null,
                    "name": null,
                    "portrait": null
                };
                item.id = key;
                item.type = this.soldierData[key].type;
                item.fight_type = this.soldierData[key].fight_type;
                item.name = this.soldierData[key].name;
                item.portrait = this.soldierData[key].portrait;
                data.push(item);
            }
            return data;
        };
        CampMain.prototype.refeshData = function (data) {
            this.soldierList.dataProvider = new eui.ArrayCollection(data);
        };
        CampMain.prototype.changeColorByType = function (type) {
            this.labelHum.textColor = 0x5F7071;
            this.labelFighter.textColor = 0x5F7071;
            this.labelChariot.textColor = 0x5F7071;
            this.labelBiochemical.textColor = 0x5F7071;
            if (type === SoldierType.Human) {
                this.labelHum.textColor = 0xA5D0F6;
            }
            if (type === SoldierType.Biochemical) {
                this.labelBiochemical.textColor = 0xA5D0F6;
            }
            if (type === SoldierType.Chariot) {
                this.labelChariot.textColor = 0xA5D0F6;
            }
            if (type === SoldierType.Fighter) {
                this.labelFighter.textColor = 0xA5D0F6;
            }
        };
        CampMain.prototype.onBtnHum = function () {
            console.log("onBtnHum");
            this.soldierData = RES.getRes("SoldierConfig_json");
            var data = this.getDataByType(SoldierType.Human);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Human);
        };
        CampMain.prototype.onBtnChariot = function () {
            console.log("onBtnChariot");
            this.soldierData = RES.getRes("SoldierConfig_json");
            var data = this.getDataByType(SoldierType.Chariot);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Chariot);
        };
        CampMain.prototype.onBtnFighter = function () {
            console.log("onBtnFighter");
            this.soldierData = RES.getRes("SoldierConfig_json");
            var data = this.getDataByType(SoldierType.Fighter);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Fighter);
        };
        CampMain.prototype.onBtnBiochemical = function () {
            console.log("onBtnBiochemical");
            this.soldierData = RES.getRes("SoldierConfig_json");
            var data = this.getDataByType(SoldierType.Biochemical);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Biochemical);
        };
        CampMain.prototype.onBtnClose = function () {
            console.log("onBtnClose");
            this.removeFromParent();
        };
        CampMain.prototype.onChange = function (e) {
        };
        return CampMain;
    }(UIBase));
    CampMain.CUSTOM = {
        skinName: "resource/ui/Camp/CampUISkin.exml",
        binding: (_a = {},
            _a["btn_Hum"] = { method: "onBtnHum", },
            _a["btn_Chariot"] = { method: "onBtnChariot", },
            _a["btn_Fighter"] = { method: "onBtnFighter", },
            _a["btn_Biochemical"] = { method: "onBtnBiochemical", },
            _a["btnClose"] = { method: "onBtnClose", },
            _a),
    };
    ui.CampMain = CampMain;
    __reflect(CampMain.prototype, "ui.CampMain");
    var SoldierType;
    (function (SoldierType) {
        SoldierType[SoldierType["Human"] = 1] = "Human";
        SoldierType[SoldierType["Chariot"] = 2] = "Chariot";
        SoldierType[SoldierType["Fighter"] = 3] = "Fighter";
        SoldierType[SoldierType["Biochemical"] = 4] = "Biochemical";
    })(SoldierType || (SoldierType = {}));
    ;
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=CampMain.js.map