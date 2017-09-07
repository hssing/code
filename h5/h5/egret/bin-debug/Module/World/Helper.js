var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var world;
(function (world) {
    var Helper = (function () {
        function Helper(mgr, mapLayer) {
            this.manager = mgr;
            this.mapLayer = mapLayer;
            this.worldMap = mgr.getWorldMap();
        }
        // 获取格子中心点
        Helper.prototype.getRectCenter = function (info) {
            var up = info.org;
            var downx = up.x + (info.width || 1) - 1;
            var downy = up.y + (info.height || 1) - 1;
            var _a = this.worldMap.cell2world(up.x, up.y), ux = _a[0], uy = _a[1];
            var _b = this.worldMap.cell2world(downx, downy), dx = _b[0], dy = _b[1];
            return { x: ux, y: (uy + dy) / 2 };
        };
        Helper.prototype.isPointInScene = function (cpos) {
            var _a = this.worldMap.cell2world(cpos.x, cpos.y), x = _a[0], y = _a[1];
            var scenePos = this.mapLayer.localToGlobal(x, y);
            var sz = this.worldMap.getViewSize();
            var rect = new egret.Rectangle(0, 0, sz.width, sz.height);
            return rect.containsPoint(scenePos);
        };
        Helper.prototype.getDisplayInfo = function (cpos) {
            var _a = this.worldMap.cell2world(cpos.x, cpos.y), x = _a[0], y = _a[1];
            var cPosCenter = this.worldMap.getCenterCPos();
            var wPosCenter = this.worldMap.getCenterWPos();
            if (this.isPointInScene(cpos)) {
                return { show: false, angle: 0, cPosCenter: cPosCenter };
            }
            var disx = x - wPosCenter[0];
            var disy = y - wPosCenter[1];
            var angle = Math.atan2(disy, disx);
            return { show: true, angle: angle, cPosCenter: cPosCenter };
        };
        Helper.prototype.getDistance = function (p1, p2) {
            return Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
        };
        return Helper;
    }());
    world.Helper = Helper;
    __reflect(Helper.prototype, "world.Helper");
})(world || (world = {}));
//# sourceMappingURL=Helper.js.map