var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var IRBase = (function (_super) {
    __extends(IRBase, _super);
    function IRBase() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    IRBase.prototype.addSizeListener = function () {
        // do nothhing
    };
    IRBase.prototype.enableTouch = function () {
        // eui.ItemRenderer
        this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this["onTouchBegin"], this);
    };
    return IRBase;
}(UIBase));
__reflect(IRBase.prototype, "IRBase", ["eui.IItemRenderer", "eui.UIComponent", "egret.DisplayObject"]);
eui.sys.mixin(IRBase, eui.ItemRenderer);
//# sourceMappingURL=IRBase.js.map