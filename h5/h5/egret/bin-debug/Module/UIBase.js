var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UIBase = (function (_super) {
    __extends(UIBase, _super);
    function UIBase(custom) {
        var _this = _super.call(this) || this;
        _this.custom = custom;
        _this.includeInLayout = true;
        _this.addEventListener(eui.UIEvent.COMPLETE, _this.createCompleteEvent, _this);
        _this.skinName = custom.skinName;
        return _this;
    }
    UIBase.prototype.createCompleteEvent = function (event) {
        this.removeEventListener(eui.UIEvent.COMPLETE, this.createCompleteEvent, this);
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onEnter, this);
        this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onExit, this);
        this.bindControl();
    };
    UIBase.prototype.removeFromParent = function () {
        this.parent.removeChild(this);
    };
    UIBase.prototype.onClose = function () {
        this.removeFromParent();
    };
    UIBase.prototype.onEnter = function () {
        this.initTracer();
        this.addSizeListener();
        this.buildCloseBg();
    };
    UIBase.prototype.addSizeListener = function () {
        this.parent.addEventListener(egret.Event.RESIZE, this.onReSize, this);
        _a = [this.parent.width, this.parent.height], this.width = _a[0], this.height = _a[1];
        var _a;
    };
    UIBase.prototype.onExit = function () {
        this.parent.removeEventListener(egret.Event.RESIZE, this.onReSize, this);
        this.disposeTracer();
    };
    UIBase.prototype.onReSize = function () {
        _a = [this.parent.width, this.parent.height], this.width = _a[0], this.height = _a[1];
        var _a;
    };
    UIBase.prototype.fireUIEvent = function (name, data) {
        UIMgr.fireUIEvent(name, data);
    };
    UIBase.prototype.bindUIEvent = function (name, method) {
        this.addEventListener(name, method, this);
    };
    UIBase.prototype.bindControl = function () {
        for (var name_1 in (this.custom.binding || {})) {
            var proto = this.custom.binding[name_1];
            if (!this[proto.method]) {
                console.log("### Not Found Method: " + proto.method + " -- SkinName: " + this.custom.skinName);
                continue;
            }
            var nameArray = name_1.split(".");
            var controller = this;
            for (var _i = 0, nameArray_1 = nameArray; _i < nameArray_1.length; _i++) {
                var v = nameArray_1[_i];
                if (!controller)
                    break;
                controller = controller[v];
            }
            if (!controller) {
                console.log("### Not Found Binding: " + name_1 + " -- SkinName: " + this.custom.skinName);
                continue;
            }
            var event_1 = proto.event || egret.TouchEvent.TOUCH_TAP;
            controller.addEventListener(event_1, this[proto.method], this);
        }
    };
    UIBase.prototype.buildCloseBg = function () {
        if (!this.custom.closeBg) {
            return;
        }
        var bgGp = new eui.Group();
        bgGp.top = bgGp.bottom = bgGp.left = bgGp.right = 0;
        this.addChildAt(bgGp, 0);
        if (!this.custom.closeBg.disable) {
            bgGp.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onClose, this);
        }
        if (this.custom.closeBg.alpha === 0) {
            return;
        }
        var rect = new eui.Rect(bgGp.width, bgGp.height);
        rect.top = rect.bottom = rect.left = rect.right = 0;
        rect.alpha = this.custom.closeBg.alpha || 0.5;
        bgGp.addChild(rect);
    };
    return UIBase;
}(eui.Component));
__reflect(UIBase.prototype, "UIBase");
eui.sys.mixin(UIBase, events.Tracer);
//# sourceMappingURL=UIBase.js.map