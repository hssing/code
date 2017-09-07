var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var Camera = (function () {
        function Camera(map, viewSize) {
            this.map = map;
            this.viewSize = viewSize;
            this.node = map.getNode();
            this.lastPos = { x: Infinity, y: Infinity, };
        }
        Camera.prototype.dispose = function () { };
        Camera.prototype.setPos = function (x, y) {
            _a = [-x, -y], this.node.x = _a[0], this.node.y = _a[1];
            var _a;
        };
        Camera.prototype.getPos = function () {
            return [-this.node.x, -this.node.y];
        };
        Camera.prototype.getViewSize = function () {
            return this.viewSize;
        };
        Camera.prototype.setViewSize = function (sz) {
            this.viewSize = sz;
        };
        Object.defineProperty(Camera.prototype, "x", {
            get: function () {
                return -this.node.x;
            },
            set: function (v) {
                this.node.x = -v;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Camera.prototype, "y", {
            get: function () {
                return -this.node.y;
            },
            set: function (v) {
                this.node.y = -v;
            },
            enumerable: true,
            configurable: true
        });
        Camera.prototype.update = function () {
            var _a = [this.node.x, this.node.y], x = _a[0], y = _a[1];
            if (x === this.lastPos.x && y === this.lastPos.y) {
                return false;
            }
            this.lastPos.x, this.lastPos.y = x, y;
            return true;
        };
        return Camera;
    }());
    mo.Camera = Camera;
    __reflect(Camera.prototype, "mo.Camera");
})(mo || (mo = {}));
//# sourceMappingURL=Camera.js.map