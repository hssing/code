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
    var ArmyMove = (function (_super) {
        __extends(ArmyMove, _super);
        function ArmyMove(param) {
            var _this = _super.call(this, ArmyMove.CUSTOM) || this;
            _this.param = param;
            _this.seletedArmys = new Map();
            return _this;
        }
        ArmyMove.prototype.onDeleteArmy = function (data) {
            console.log("===onDeleteArmy" + data);
            if (this.seletedArmys.get(data)) {
                this.seletedArmys.delete(data);
            }
        };
        ArmyMove.prototype.onAddArmy = function (data) {
            console.log("===onAddArmy" + data);
            if (this.seletedArmys.get(data)) {
                return;
            }
            this.seletedArmys.set(data, parseInt(data));
        };
        ArmyMove.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            this.lstArmy.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.onChange, this);
            var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            var data = this.getData(armyInfo);
            this.refresh(data);
            LogicMgr.get(logic.World).on(logic.World.EVT.ADD_ARMY, this.Event("onAddArmy"));
            LogicMgr.get(logic.World).on(logic.World.EVT.DELETE_ARMY, this.Event("onDeleteArmy"));
        };
        ArmyMove.prototype.getData = function (armyInfo) {
            var data = [];
            for (var i = 0; i < armyInfo.length; i++) {
                var item = { "armyName": null,
                    "strength": null,
                    "speed": null,
                    "status": null,
                    "dis": null,
                    "time": null,
                    "icon": null,
                    "selected": false,
                };
                item.armyName = armyInfo[i].army_id;
                item.strength = armyInfo[i].forward_phalanx.hp + armyInfo[i].center_phalanx.hp + armyInfo[i].back_phalanx.hp;
                item.speed = 70;
                item.status = "空闲";
                item.dis = 0;
                item.time = "00:00:00";
                item.icon = "chuzheng_icon_buduichuzheng_s4_png";
                data.push(item);
            }
            return data;
        };
        ArmyMove.prototype.refresh = function (data) {
            this.lstArmy.dataProvider = new eui.ArrayCollection(data);
        };
        ArmyMove.prototype.onChange = function (e) {
        };
        ArmyMove.prototype.onBtnClose = function () {
            console.log("onBtnClose");
            this.removeFromParent();
        };
        ArmyMove.prototype.onBtnOK = function () {
            this.removeFromParent();
            console.log("onBtnOK");
            var iterator = this.seletedArmys.values()[Symbol.iterator](), step;
            while (!(step = iterator.next()).done) {
                console.log(step.value);
                LogicMgr.get(logic.World).moveArmyToCell(step.value, this.param.info.x, this.param.info.y);
            }
        };
        return ArmyMove;
    }(UIBase));
    ArmyMove.CUSTOM = {
        closeBg: { alpha: 0.5, disable: false },
        skinName: "resource/ui/ArmyMove/ArmyMoveUISkin.exml",
        binding: (_a = {}, _a["btnClose"] = { method: "onBtnClose" }, _a["btnOK"] = { method: "onBtnOK" }, _a)
    };
    ui.ArmyMove = ArmyMove;
    __reflect(ArmyMove.prototype, "ui.ArmyMove");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=ArmyMove.js.map