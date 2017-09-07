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
    var ActionMenu = (function (_super) {
        __extends(ActionMenu, _super);
        function ActionMenu(world, data) {
            var _this = _super.call(this, ActionMenu.CUSTOM) || this;
            _this.world = world;
            _this.data = data;
            _this.lbInfo.text = data.info.x + ", " + data.info.y;
            _this.btnBuild.visible = false;
            if (LogicMgr.get(logic.World).isBlocked(data.info.x, data.info.y)) {
                _this.lbInfo.text = "阻挡！";
            }
            else {
                _this.btnBuild.visible = true;
            }
            return _this;
        }
        ActionMenu.prototype.onExit = function () {
            _super.prototype.onExit.call(this);
            this.world = null;
        };
        ActionMenu.prototype.onBtnBack = function (e) {
            console.log("onBtnBack");
            this.world.closeItem();
        };
        ActionMenu.prototype.onBtnBuild = function (e) {
            console.log("onBtnBuild");
            LogicMgr.get(logic.World).buildUnit(this.data.info.x, this.data.info.y);
            this.world.onSightUdpate();
            this.world.closeItem();
        };
        ActionMenu.prototype.onBtnAction = function (e) {
            console.log("onBtnAction");
            this.world.closeItem();
            var armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            if (armyInfo.length === 0) {
                return;
            } // no army
            UIMgr.open(ui.ArmyMove, void 0, this.data);
        };
        return ActionMenu;
    }(UIBase));
    ActionMenu.CUSTOM = {
        skinName: "resource/ui/ActionMenuUISkin.exml",
        binding: (_a = {},
            _a["btnBack"] = { method: "onBtnBack", },
            _a["btnAction"] = { method: "onBtnAction", },
            _a["btnBuild"] = { method: "onBtnBuild", },
            _a),
    };
    ui.ActionMenu = ActionMenu;
    __reflect(ActionMenu.prototype, "ui.ActionMenu");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=ActionMenu.js.map