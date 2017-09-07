var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui) {
    var Login = (function (_super) {
        __extends(Login, _super);
        function Login() {
            return _super.call(this, Login.CUSTOM) || this;
        }
        Login.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            LogicMgr.get(logic.Login).on(logic.Login.EVT.REGISTER_ROLE, this.Event("onRegisterRole"));
            LogicMgr.get(logic.Login).on(logic.Login.EVT.ENTER_GAME, this.Event("onEnterGame"));
            LogicMgr.get(logic.Login).on(logic.Login.EVT.REFESH_SERVERINFO, this.Event("refeshServerInfo"));
            this.refeshServerInfo();
        };
        Login.prototype.refeshServerInfo = function () {
            var serverInfo = LogicMgr.get(logic.Login).getCurServerInfo();
            if (serverInfo) {
                this.serverName.text = serverInfo.name;
            }
        };
        Login.prototype.onEnterGame = function () {
            this.removeFromParent();
            this.account = null;
            this.group = null;
            UIMgr.open(ui.GameLoadingUI, "load");
        };
        Login.prototype.onRegisterRole = function () {
            this.removeFromParent();
            this.account = null;
            this.group = null;
            UIMgr.open(ui.CreateRole);
        };
        Login.prototype.onBtnLogin = function (e) {
            if (this.account.text.length == 0 || this.account.text == "") {
                alert("账号不能为空");
                return;
            }
            this.doLogin();
        };
        Login.prototype.doLogin = function () {
            var serverInfo = LogicMgr.get(logic.Login).getCurServerInfo();
            console.log("serverInfo ip = " + serverInfo.ip);
            console.log("serverInfo port = " + serverInfo.port);
            Singleton(NetCenter).connectServer(serverInfo.ip, serverInfo.port);
            var data = { aid: this.account.text };
            var playerInfo = LogicMgr.get(logic.Player);
            playerInfo.setUid(this.account.text);
            NetMgr.get(msg.Login).send("m_login_auth_tos", data);
        };
        Login.prototype.onBtnServer = function () {
            UIMgr.open(ui.ServerList);
        };
        return Login;
    }(UIBase));
    Login.CUSTOM = {
        skinName: "resource/ui/LoginUISkin.exml",
        binding: (_a = {},
            _a["btnLogin"] = { event: egret.TouchEvent.TOUCH_TAP, method: "onBtnLogin", },
            _a["btnServer"] = { event: egret.TouchEvent.TOUCH_TAP, method: "onBtnServer", },
            _a),
    };
    ui.Login = Login;
    __reflect(Login.prototype, "ui.Login");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=Login.js.map