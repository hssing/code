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
    var Arsenal = (function (_super) {
        __extends(Arsenal, _super);
        function Arsenal() {
            return _super !== null && _super.apply(this, arguments) || this;
        }
        Arsenal.prototype.build = function () {
            return this.createView("leiyansuo_png");
        };
        return Arsenal;
    }(world.ViewBase));
    world.Arsenal = Arsenal;
    __reflect(Arsenal.prototype, "world.Arsenal");
})(world || (world = {}));
//# sourceMappingURL=Arsenal.js.map