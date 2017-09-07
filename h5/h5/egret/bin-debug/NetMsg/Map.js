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
    var Map = (function (_super) {
        __extends(Map, _super);
        function Map() {
            var _this = _super !== null && _super.apply(this, arguments) || this;
            _this.modId = 120;
            _this.subIds = {
                0: "m_map_get_view_obj_tos",
                1: "m_map_sight_toc",
                2: "m_map_sight_leave_toc",
                3: "m_map_sight_enter_toc",
                6: "m_map_obj_move_info_toc",
            };
            return _this;
        }
        Map.prototype.on = function (name, event) {
            _super.prototype.on.call(this, name, event);
        };
        Map.prototype.send = function (name, obj) {
            _super.prototype.send.call(this, name, obj);
        };
        return Map;
    }(NetMsg));
    msg.Map = Map;
    __reflect(Map.prototype, "msg.Map");
})(msg || (msg = {}));
//# sourceMappingURL=Map.js.map