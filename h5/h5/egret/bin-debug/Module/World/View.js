var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var world;
(function (world) {
    var ViewBase = (function () {
        function ViewBase(mgr, root, data) {
            this.manager = mgr;
            this.data = data;
            this.root = root;
            this.worldMap = mgr.getWorldMap();
            var info = this.worldMap.getInfo();
            this.cellSize = { width: info.cw, height: info.ch, };
            this.view = this.build();
            this.root.addChild(this.view);
            this.refresh();
        }
        ViewBase.prototype.dispose = function () {
            this.destroy();
        };
        ViewBase.prototype.createView = function (imgPath) {
            var view = new egret.DisplayObjectContainer();
            this.centerView(view);
            var bd = RES.getRes(imgPath);
            var img = new eui.Image(bd);
            view.addChild(img);
            img.touchEnabled = false;
            img.width = bd.bitmapData.width;
            img.height = bd.bitmapData.height;
            this.alignLeftBottom(img);
            return view;
        };
        ViewBase.prototype.centerView = function (view) {
            _a = [this.cellSize.width, this.cellSize.height], view.width = _a[0], view.height = _a[1];
            view.anchorOffsetX = view.width / 2;
            view.anchorOffsetY = view.height / 2;
            var _a;
        };
        ViewBase.prototype.alignLeftBottom = function (child) {
            var parent = child.parent;
            child.y += parent.height - child.height;
        };
        ViewBase.prototype.refresh = function () {
            var wpos = this.worldMap.cell2world(this.data.x, this.data.y);
            _a = [wpos[0], wpos[1]], this.view.x = _a[0], this.view.y = _a[1];
            var _a;
        };
        ViewBase.prototype.build = function () {
            return null;
        };
        ViewBase.prototype.destroy = function () {
            this.root.removeChild(this.view);
            this.view = null;
        };
        ViewBase.prototype.setData = function (data) {
            this.data = data;
        };
        ViewBase.prototype.getData = function () {
            return this.data;
        };
        ViewBase.prototype.getView = function () {
            return this.view;
        };
        return ViewBase;
    }());
    world.ViewBase = ViewBase;
    __reflect(ViewBase.prototype, "world.ViewBase", ["IView"]);
})(world || (world = {}));
//# sourceMappingURL=View.js.map