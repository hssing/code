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
    var Camp = (function (_super) {
        __extends(Camp, _super);
        function Camp() {
            return _super !== null && _super.apply(this, arguments) || this;
        }
        Camp.prototype.build = function () {
            return this.createView("junxing_png");
        };
        return Camp;
    }(world.ViewBase));
    world.Camp = Camp;
    __reflect(Camp.prototype, "world.Camp");
})(world || (world = {}));
//# sourceMappingURL=Camp.js.map