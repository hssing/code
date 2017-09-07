var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ProgressBar = (function (_super) {
    __extends(ProgressBar, _super);
    function ProgressBar() {
        var _this = _super.call(this) || this;
        /**
         * 反向进度条
         * */
        _this.reverse = false;
        var _bg = 'xuetiao_back_png';
        var _bar = 'xuetiao01_png';
        _this.background = new egret.Bitmap(RES.getRes(_bg));
        _this.bar = new egret.Bitmap(RES.getRes(_bar));
        _this.addChild(_this.background);
        _this.addChild(_this.bar);
        _this.bar.x = (_this.background.width - _this.bar.width) / 2;
        _this.bar.y = (_this.background.height - _this.bar.height) / 2;
        _this.barMask = new egret.Rectangle(0, 0, _this.bar.width, _this.bar.height);
        _this.bar.mask = _this.barMask;
        return _this;
    }
    ProgressBar.prototype.setProgress = function (_p) {
        this.barMask = new egret.Rectangle(0, 0, (this.reverse ? (1 - _p) : _p) * this.bar.width, this.bar.height);
        this.bar.mask = this.barMask;
    };
    return ProgressBar;
}(egret.Sprite));
__reflect(ProgressBar.prototype, "ProgressBar");
//# sourceMappingURL=ProgressBar.js.map