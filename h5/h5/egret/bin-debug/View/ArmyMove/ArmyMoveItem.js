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
    var ArmyMoveItem = (function (_super) {
        __extends(ArmyMoveItem, _super);
        function ArmyMoveItem(custom) {
            var _this = _super.call(this, ArmyMoveItem.CUSTOM) || this;
            _this.enableTouch();
            return _this;
        }
        ArmyMoveItem.prototype.onCheckBox = function () {
            if (this.checkBox.selected) {
                LogicMgr.get(logic.World).fireEvent(logic.World.EVT.ADD_ARMY, this.armyName.text);
            }
            else {
                LogicMgr.get(logic.World).fireEvent(logic.World.EVT.DELETE_ARMY, this.armyName.text);
            }
        };
        return ArmyMoveItem;
    }(IRBase));
    ArmyMoveItem.CUSTOM = {
        skinName: "resource/ui/ArmyMove/ArmyMoveListIRSkin.exml",
        binding: (_a = {},
            _a["checkBox"] = { method: "onCheckBox" },
            _a),
    };
    ui.ArmyMoveItem = ArmyMoveItem;
    __reflect(ArmyMoveItem.prototype, "ui.ArmyMoveItem");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=ArmyMoveItem.js.map