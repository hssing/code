var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var mo;
(function (mo) {
    var Background = (function (_super) {
        __extends(Background, _super);
        function Background(map, name, layerIdx, camera, data) {
            var _this = _super.call(this, map, name, layerIdx, data) || this;
            var viewSize = camera.getViewSize();
            _this.strategy = new mo.Tile(viewSize, data.bgInfo.size, _this.node, function () {
                var gp = new eui.Group();
                var sp = new eui.Image(data.bgInfo.url);
                gp.addChild(sp);
                gp.alpha = 0.5;
                return gp;
            });
            return _this;
        }
        Background.prototype.dispose = function () {
            _super.prototype.dispose.call(this);
        };
        Background.prototype.viewportChanged = function (x, y, info) {
            this.strategy.update(x, y);
        };
        return Background;
    }(mo.Layer));
    mo.Background = Background;
    __reflect(Background.prototype, "mo.Background");
})(mo || (mo = {}));
//# sourceMappingURL=Background.js.map