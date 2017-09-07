var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var logic;
(function (logic) {
    var Build = (function (_super) {
        __extends(Build, _super);
        function Build() {
            var _this = _super.call(this) || this;
            _this.data = [];
            return _this;
        }
        Build.prototype.setData = function (data) {
            this.data = data;
        };
        Build.prototype.getInfo = function (id) {
            var ret = this.data.filter(function (v) { return v.build_id === id; });
            return ret[0];
        };
        Build.prototype.getAllArmyInfo = function () {
            return this.data.reduce(function (p, c) { return p.concat(c.army_list); }, []);
        };
        Build.prototype.getMainBuildPos = function () {
            var build = this.data[0] || {};
            return { x: build.x || 0, y: build.y || 0 };
        };
        Build.prototype.getBuildIdByArmyId = function (armyId) {
            for (var _i = 0, _a = this.data; _i < _a.length; _i++) {
                var build = _a[_i];
                for (var _b = 0, _c = build.army_list; _b < _c.length; _b++) {
                    var army = _c[_b];
                    if (army.army_id === armyId) {
                        return build.build_id;
                    }
                }
            }
            return undefined;
        };
        Build.prototype.isBuildMenu = function (cellInfo) {
            if (cellInfo.info && cellInfo.info.type > 0) {
                return true;
            }
            return false;
        };
        Build.prototype.getConfig = function (type) {
            var info = RES.getRes("BuildingLevelConfig_json");
            for (var k in info) {
                if (info[k].type === type) {
                    return info[k];
                }
            }
            return null;
        };
        return Build;
    }(Logic));
    logic.Build = Build;
    __reflect(Build.prototype, "logic.Build");
})(logic || (logic = {}));
//# sourceMappingURL=Build.js.map