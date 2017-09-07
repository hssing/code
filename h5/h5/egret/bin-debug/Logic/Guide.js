var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var logic;
(function (logic) {
    var Guide = (function (_super) {
        __extends(Guide, _super);
        function Guide() {
            var _this = _super.call(this) || this;
            _this.actions = new Array();
            return _this;
        }
        Guide.prototype.createGuideById = function (id) {
            var guidesData = RES.getRes("GuideMotherConfig_json");
            var actionsData = guidesData[id];
            for (var i = 0; i < actionsData.length; i++) {
                var actionData = actionsData[i];
                var isBottom = actionData.isBottom;
                var layer = actionData.layer;
                var btn = actionData.btn;
                var action = new GuideAction();
                action.setBtn(btn);
                action.setIsBottom(isBottom);
                action.setUi(ui);
                action.setLayer(layer);
                this.actions.push(action);
            }
            this.runGuideAction();
        };
        Guide.prototype.runGuideAction = function () {
            if (!this.actions || this.actions.length <= 0) {
                return;
            }
            var action = this.actions[0];
            action.run();
        };
        Guide.prototype.finishAction = function () {
            this.actions.shift();
            if (this.actions && this.actions.length === 0) {
                return;
            }
            this.runGuideAction();
        };
        return Guide;
    }(Logic));
    Guide.EVT = utils.Enum([
        "ACTION_FINISHED",
    ]);
    logic.Guide = Guide;
    __reflect(Guide.prototype, "logic.Guide");
    var GuideAction = (function () {
        function GuideAction() {
        }
        GuideAction.prototype.setBtn = function (btn) {
            this.btn = btn;
        };
        GuideAction.prototype.setUi = function (ui) {
            this.ui = ui;
        };
        GuideAction.prototype.setIsBottom = function (isBottom) {
            this.isBottom = isBottom;
        };
        GuideAction.prototype.setLayer = function (layer) {
            this.layer = layer;
        };
        GuideAction.prototype.run = function () {
            var ui = null;
            if (this.layer === "home") {
                ui = UIMgr.getHome();
            }
            else if (this.layer === "world") {
                ui = UIMgr.getWorld();
            }
            else {
                var panel = UIMgr.getLayer("panel");
                ui = panel.getChildAt(panel.numChildren - 1);
            }
            UIMgr.getGuide().createGuidePanel(ui[this.btn], this.isBottom);
        };
        return GuideAction;
    }());
    __reflect(GuideAction.prototype, "GuideAction");
})(logic || (logic = {}));
//# sourceMappingURL=Guide.js.map