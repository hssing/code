var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var world;
(function (world) {
    var UnitMgr = (function () {
        // private viewPool = new Map();
        function UnitMgr(mgr, root) {
            this.manager = mgr;
            this.root = root;
            this.worldMap = this.manager.getWorldMap();
            this.views = {};
            this.data = {};
        }
        UnitMgr.prototype.dispose = function () {
            for (var index in this.views) {
                this.views[index].dispose();
            }
        };
        UnitMgr.prototype.recycle = function (data) {
            for (var k in this.views) {
                if (!data[k]) {
                    this.removeUnit(k);
                }
            }
        };
        UnitMgr.prototype.checkHasBuildUnit = function (info) {
            // let p1 = this.manager.getListener().makePos(info.org.x, info.org.y);
            for (var k in this.views) {
                var unit = this.views[k];
                var data = unit.getData();
                // let p2 = this.manager.getListener().makePos(data.org.x, data.org.y);
                if (info.x === data.x && info.y === data.y) {
                    return true;
                }
            }
            return false;
        };
        UnitMgr.prototype.updateData = function (data) {
            for (var k in data) {
                this.updateUnit(k, data[k]);
            }
            this.recycle(data);
        };
        UnitMgr.prototype.updateUnit = function (k, info) {
            if (this.views[k]) {
                this.views[k].setData(info);
                this.views[k].refresh();
            }
            else {
                if (!this.checkHasBuildUnit(k) && info) {
                    this.buildUnit(k, info);
                }
            }
        };
        UnitMgr.prototype.buildUnit = function (k, info) {
            var nameCls = {
                0: world.Tablet,
                1: world.Castle,
                2: world.Camp,
                3: world.Acacdemy,
                4: world.Arsenal,
            };
            var cls = nameCls[info.type];
            if (!cls) {
                return;
            }
            this.views[k] = new cls(this.manager, this.root, info);
        };
        UnitMgr.prototype.removeUnit = function (k) {
            this.views[k].dispose();
            delete this.views[k];
        };
        return UnitMgr;
    }());
    world.UnitMgr = UnitMgr;
    __reflect(UnitMgr.prototype, "world.UnitMgr");
})(world || (world = {}));
//# sourceMappingURL=UnitMgr.js.map