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
    var SoldierHeadItem = (function (_super) {
        __extends(SoldierHeadItem, _super);
        function SoldierHeadItem() {
            return _super.call(this, SoldierHeadItem.CUSTOM) || this;
        }
        SoldierHeadItem.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            console.log("=================SoilderHeadItemUISkin");
            //LogicMgr.get(logic.Build).on(logic.Build.EVT.SOLDIER_TOUCH_END, this.Event("onSoldierTouchEnded"));
            this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
            // this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
            // this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
        };
        SoldierHeadItem.prototype.onBtnClicked = function () {
            console.log("onBtnClicked");
        };
        SoldierHeadItem.prototype.onTouchBegin = function (e) {
            console.log("========onBegin");
            this.group = new eui.Group();
            this.group.x = 0;
            this.group.y = 0;
            this.soldierItem.addChild(this.group);
            this.img1 = new eui.Image(this.img_bg.texture);
            this.img1.x = this.img_bg.x;
            this.img1.y = this.img_bg.y;
            this.img1.width = this.img_bg.width;
            this.img1.height = this.img_bg.height;
            this.img1.scaleX = this.img_bg.scaleX;
            this.img1.scaleY = this.img_bg.scaleY;
            this.group.addChild(this.img1);
            this.img2 = new eui.Image(this.img_bg0.texture);
            this.img2.x = this.img_bg0.x;
            this.img2.y = this.img_bg0.y;
            this.img2.scaleX = this.img_bg0.scaleX;
            this.img2.scaleY = this.img_bg0.scaleY;
            this.group.addChild(this.img2);
            this.group.visible = true;
            LogicMgr.get(logic.Camp).fireEvent(logic.Camp.EVT.SOLDIER_TOUCH_BEGIN, this.group, this.data);
        };
        return SoldierHeadItem;
    }(IRBase));
    SoldierHeadItem.CUSTOM = {
        skinName: "resource/ui/Camp/SoilderHeadItemUISkin.exml",
    };
    ui.SoldierHeadItem = SoldierHeadItem;
    __reflect(SoldierHeadItem.prototype, "ui.SoldierHeadItem");
})(ui || (ui = {}));
//# sourceMappingURL=SoldierHeadItem.js.map