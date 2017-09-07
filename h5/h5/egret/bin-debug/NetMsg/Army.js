var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var msg;
(function (msg) {
    var Army = (function (_super) {
        __extends(Army, _super);
        function Army() {
            var _this = _super !== null && _super.apply(this, arguments) || this;
            _this.proto = "net/proto.proto";
            _this.modId = 140;
            _this.subIds = {
                1: "m_army_get_own_soldier_tos",
                2: "m_army_get_own_soldier_toc",
                3: "m_army_set_soldier_tos",
                4: "m_army_set_soldier_toc",
            };
            return _this;
        }
        Army.prototype.on = function (name, event) {
            _super.prototype.on.call(this, name, event);
        };
        Army.prototype.send = function (name, obj) {
            _super.prototype.send.call(this, name, obj);
        };
        return Army;
    }(NetMsg));
    msg.Army = Army;
    __reflect(Army.prototype, "msg.Army");
})(msg || (msg = {}));
//# sourceMappingURL=Army.js.map