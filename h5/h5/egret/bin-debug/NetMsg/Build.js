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
    var Build = (function (_super) {
        __extends(Build, _super);
        function Build() {
            var _this = _super !== null && _super.apply(this, arguments) || this;
            _this.modId = 130;
            _this.subIds = {
                0: "m_build_get_build_list_tos",
                1: "m_build_get_build_list_toc",
                2: "m_build_go_to_battle_tos",
                3: "m_build_go_to_battle_toc",
            };
            return _this;
        }
        Build.prototype.on = function (name, event) {
            _super.prototype.on.call(this, name, event);
        };
        Build.prototype.send = function (name, obj) {
            _super.prototype.send.call(this, name, obj);
        };
        return Build;
    }(NetMsg));
    msg.Build = Build;
    __reflect(Build.prototype, "msg.Build");
})(msg || (msg = {}));
//# sourceMappingURL=Build.js.map