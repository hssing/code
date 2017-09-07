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
    var BuildMenu = (function (_super) {
        __extends(BuildMenu, _super);
        function BuildMenu(world, data) {
            var _this = _super.call(this, BuildMenu.CUSTOM) || this;
            _this.world = world;
            _this.data = data;
            _this.lbPos.text = "(" + data.info.x + "," + data.info.y + ")";
            var cfg = LogicMgr.get(logic.Build).getConfig(data.info.type);
            if (!cfg) {
                return _this;
            }
            _this.lbTitle.text = cfg.name + "  (LV" + cfg.lv + ")";
            return _this;
        }
        BuildMenu.prototype.onEnter = function () {
            var _this = this;
            _super.prototype.onEnter.call(this);
            var offsetY = 100;
            this.world.getMapContainer().setPosWithAnimat(this.data.pos.x, this.data.pos.y + offsetY, 200, function () { return _this.delayShow(); });
            this.gpMainPos.visible = false;
        };
        BuildMenu.prototype.onExit = function () {
            _super.prototype.onExit.call(this);
            this.world = null;
        };
        BuildMenu.prototype.delayShow = function () {
            if (!this.world) {
                return;
            }
            var wpos = this.world.getMap().cell2world(this.data.info.x, this.data.info.y);
            var wp = this.world.getMap().getNode().localToGlobal(wpos[0], wpos[1]);
            var cp = this.globalToLocal(wp.x, wp.y);
            this.gpMainPos.x = cp.x;
            this.gpMainPos.y = cp.y;
            this.gpMainPos.visible = true;
        };
        BuildMenu.prototype.onBtnFunc = function (e) {
            Prompt.popTip("功能开发中");
        };
        BuildMenu.prototype.onBtnFinish = function (e) {
            Prompt.popTip("功能开发中");
        };
        BuildMenu.prototype.onBtnInfo = function (e) {
            Prompt.popTip("功能开发中");
        };
        return BuildMenu;
    }(UIBase));
    BuildMenu.CUSTOM = {
        closeBg: { alpha: 0 },
        skinName: "resource/ui/BuildMenuUISkin.exml",
        binding: (_a = {},
            _a["btnFunc"] = { method: "onBtnFunc", },
            _a["btnFinish"] = { method: "onBtnFinish", },
            _a["btnInfo"] = { method: "onBtnInfo", },
            _a),
    };
    ui.BuildMenu = BuildMenu;
    __reflect(BuildMenu.prototype, "ui.BuildMenu");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=BuildMenu.js.map