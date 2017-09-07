var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui_1) {
    var Guide = (function (_super) {
        __extends(Guide, _super);
        function Guide() {
            var _this = _super.call(this) || this;
            _this.percentWidth = 100;
            _this.percentHeight = 100;
            _this.$setTouchEnabled(false);
            return _this;
        }
        Guide.prototype.createGuide = function (id) {
            var data = RES.getRes("GuideMotherConfig_json");
            var isBottom = data[id].isBottom;
            var layer = data[id].layer;
            var ui = null;
            if (layer === "Home") {
                ui = UIMgr.getHome();
            }
            else if (layer === "World") {
                ui = UIMgr.getWorld();
            }
            else {
                var pannel = UIMgr.getLayer("Pannel");
                ui = pannel.getChildAt(pannel.numChildren - 1);
            }
            var btn = ui[data[id].btn];
            this.createGuidePanel(btn, isBottom);
        };
        Guide.prototype.createGuidePanel = function (btn, isBottom) {
            var _this = this;
            var point = btn.localToGlobal(0, 0);
            var x = point.x;
            var y = point.y;
            var width = btn.width;
            var height = btn.height;
            this.guideGroup = new eui.Group();
            this.guideGroup.percentWidth = 100;
            this.guideGroup.percentHeight = 100;
            this.guideGroup.$setX(0);
            this.guideGroup.$setY(0);
            this.guideGroup.$setTouchEnabled(false);
            this.addChild(this.guideGroup);
            this.createMask(x, y, width, height, isBottom);
            var fingerGroup = new eui.Group();
            fingerGroup.percentWidth = 100;
            fingerGroup.height = 200;
            this.guideGroup.addChild(fingerGroup);
            if (isBottom) {
                fingerGroup.bottom = 0;
                fingerGroup.anchorOffsetY = 200;
                fingerGroup.$setY(this.stage.$stageHeight);
            }
            else {
                fingerGroup.anchorOffsetY = 0;
                fingerGroup.$setY(0);
            }
            fingerGroup.$setX(0);
            fingerGroup.$setTouchEnabled(false);
            var localPoint = fingerGroup.globalToLocal(x + width / 2, y + height / 2);
            var finger = new eui.Image("finger1_png");
            finger.$setX(localPoint.x + 10 * Math.cos(Math.PI / 4));
            finger.$setY(localPoint.y + 10 * Math.sin(Math.PI / 4));
            var tw = egret.Tween.get(finger, { loop: true });
            tw.to({ x: localPoint.x, y: localPoint.y }, 500)
                .to({ x: localPoint.x + 10 * Math.cos(Math.PI / 4), y: localPoint.y + 10 * Math.sin(Math.PI / 4) }, 500);
            fingerGroup.addChild(finger);
            var shape = new eui.Rect(width, height, 0x020202);
            var shapeLocalPoint = fingerGroup.globalToLocal(x, y);
            fingerGroup.addChild(shape);
            shape.fillAlpha = 0;
            shape.$setX(shapeLocalPoint.x);
            shape.$setY(shapeLocalPoint.y);
            shape.addEventListener(egret.TouchEvent.TOUCH_BEGIN, function (e) {
                btn.dispatchEvent(e);
            }, this);
            shape.addEventListener(egret.TouchEvent.TOUCH_TAP, function (e) {
                btn.dispatchEvent(e);
                _this.addEventListener(egret.Event.RENDER, _this.render, _this);
            }, this);
        };
        Guide.prototype.render = function () {
            this.removeEventListener(egret.Event.RENDER, this.render, this);
            this.finishedGuide();
        };
        Guide.prototype.createMask = function (x, y, width, height, isBottom) {
            var leftMask = new eui.Rect(x, this.stage.$stageHeight, 0x020202);
            this.guideGroup.addChild(leftMask);
            leftMask.fillAlpha = 0.5;
            leftMask.$setX(0);
            leftMask.$setY(0);
            leftMask.percentHeight = 100;
            var topMask = new eui.Rect(width, y, 0x020202);
            this.guideGroup.addChild(topMask);
            topMask.fillAlpha = 0.5;
            topMask.$setX(x);
            topMask.$setY(0);
            if (isBottom) {
                topMask.top = 0;
                topMask.bottom = this.stage.$stageHeight - y;
            }
            var rightMask = new eui.Rect(this.stage.$stageWidth - width - x, this.stage.$stageHeight, 0x020202);
            this.guideGroup.addChild(rightMask);
            rightMask.fillAlpha = 0.5;
            rightMask.$setX(x + width);
            rightMask.$setY(0);
            rightMask.percentHeight = 100;
            var bottomMask = new eui.Rect(width, this.stage.$stageHeight - height - y, 0x020202);
            this.guideGroup.addChild(bottomMask);
            bottomMask.fillAlpha = 0.5;
            bottomMask.$setX(x);
            bottomMask.$setY(y + height);
            bottomMask.bottom = 0;
            if (!isBottom) {
                bottomMask.top = y + height;
            }
        };
        Guide.prototype.finishedGuide = function () {
            if (this.guideGroup) {
                this.guideGroup.parent.removeChild(this.guideGroup);
                this.guideGroup = null;
                LogicMgr.get(logic.Guide).finishAction();
            }
        };
        return Guide;
    }(eui.Group));
    ui_1.Guide = Guide;
    __reflect(Guide.prototype, "ui.Guide");
})(ui || (ui = {}));
//# sourceMappingURL=Guide.js.map