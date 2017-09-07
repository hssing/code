var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var world;
(function (world) {
    var Tablet = (function (_super) {
        __extends(Tablet, _super);
        function Tablet(mgr, root, data) {
            return _super.call(this, mgr, root, data) || this;
        }
        Tablet.prototype.build = function () {
            var view = new egret.DisplayObjectContainer();
            var tx = RES.getRes("shuinidi_png");
            var bg = new eui.Image(tx);
            view.addChild(bg);
            bg.touchEnabled = false;
            bg.anchorOffsetX = tx.bitmapData.width / 2;
            bg.anchorOffsetY = tx.bitmapData.height / 2;
            return view;
        };
        Tablet.prototype.refresh = function () {
            var wpos = this.worldMap.cell2world(this.data.x, this.data.y);
            _a = [wpos[0], wpos[1]], this.view.x = _a[0], this.view.y = _a[1];
            var _a;
        };
        return Tablet;
    }(world.ViewBase));
    world.Tablet = Tablet;
    __reflect(Tablet.prototype, "world.Tablet");
})(world || (world = {}));
//# sourceMappingURL=Tablet.js.map