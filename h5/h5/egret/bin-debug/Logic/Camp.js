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
    var Camp = (function (_super) {
        __extends(Camp, _super);
        function Camp() {
            return _super.call(this) || this;
        }
        Camp.prototype.setSoldierIds = function (soldierIds) {
            this.mSoldierIds = soldierIds;
        };
        return Camp;
    }(Logic));
    Camp.EVT = utils.Enum([
        "SOLDIER_TOUCH_MOVE",
        "SOLDIER_TOUCH_BEGIN",
        "SOLDIER_TOUCH_END",
    ]);
    logic.Camp = Camp;
    __reflect(Camp.prototype, "logic.Camp");
})(logic || (logic = {}));
//# sourceMappingURL=Camp.js.map