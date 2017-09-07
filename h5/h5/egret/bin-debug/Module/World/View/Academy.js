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
    var Acacdemy = (function (_super) {
        __extends(Acacdemy, _super);
        function Acacdemy() {
            return _super !== null && _super.apply(this, arguments) || this;
        }
        Acacdemy.prototype.build = function () {
            return this.createView("ziyuanyanjiusuo_png");
        };
        return Acacdemy;
    }(world.ViewBase));
    world.Acacdemy = Acacdemy;
    __reflect(Acacdemy.prototype, "world.Acacdemy");
})(world || (world = {}));
//# sourceMappingURL=Academy.js.map