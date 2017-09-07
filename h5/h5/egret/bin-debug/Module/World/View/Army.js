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
    var Army = (function (_super) {
        __extends(Army, _super);
        function Army(mgr, root, data) {
            return _super.call(this, mgr, root, data) || this;
        }
        Army.prototype.build = function () {
            var role = new RoleView();
            role.anchorOffsetX = 30;
            role.anchorOffsetY = 10;
            // let army:ArmyView = new ArmyView();
            return role;
        };
        Army.prototype.refresh = function () {
            var wpos = this.worldMap.cell2world(this.data.cur_point.x, this.data.cur_point.y);
            var vo = new PlayerVO();
            vo.setXY(wpos[0], wpos[1]);
            this.view.updateVO(vo);
            if (this.data.status === 1) {
                this.view.updatePath(this.data);
            }
        };
        return Army;
    }(world.ViewBase));
    world.Army = Army;
    __reflect(Army.prototype, "world.Army");
})(world || (world = {}));
//# sourceMappingURL=Army.js.map