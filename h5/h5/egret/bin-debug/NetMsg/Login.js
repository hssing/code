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
    var Login = (function (_super) {
        __extends(Login, _super);
        function Login() {
            var _this = _super !== null && _super.apply(this, arguments) || this;
            _this.modId = 100;
            _this.subIds = {
                0: "m_login_auth_tos",
                1: "m_login_auth_toc",
                2: "m_login_create_role_tos",
                3: "m_login_create_role_toc",
                4: "m_login_get_role_detail_tos",
                5: "m_login_get_role_detail_toc",
            };
            return _this;
        }
        Login.prototype.on = function (name, event) {
            _super.prototype.on.call(this, name, event);
        };
        Login.prototype.send = function (name, obj) {
            _super.prototype.send.call(this, name, obj);
        };
        return Login;
    }(NetMsg));
    msg.Login = Login;
    __reflect(Login.prototype, "msg.Login");
})(msg || (msg = {}));
//# sourceMappingURL=Login.js.map