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
    var Login = (function (_super) {
        __extends(Login, _super);
        function Login() {
            var _this = _super.call(this) || this;
            _this.totalMessages = 3;
            NetMgr.get(msg.Login).on("m_login_auth_toc", _this.Event("onLogin"));
            NetMgr.get(msg.Login).on("m_login_create_role_toc", _this.Event("onCreateRole"));
            NetMgr.get(msg.Login).on("m_login_get_role_detail_toc", _this.Event("onGetRoleDetail"));
            NetMgr.get(msg.Build).on("m_build_get_build_list_toc", _this.Event("onGetBuildGuildList"));
            NetMgr.get(msg.Army).on("m_army_get_own_soldier_toc", _this.Event("onGetOwnSoldiers"));
            _this.finishedMessages = 0;
            _this.serverListInfo = RES.getRes("serverList_json");
            _this.curServerInfo = _this.serverListInfo[0];
            return _this;
        }
        Login.prototype.onLogin = function (param) {
            console.log("onNetMsg", param);
            if (param["ret_code"] !== 1) {
                return;
            }
            if (param["login_info"].length !== 0) {
                LogicMgr.get(logic.Player).setRoleId(param.login_info[0].role_id);
                LogicMgr.get(logic.Player).setRoleName(param.login_info[0].nick);
                LogicMgr.get(logic.Player).setRoleLevel(param.login_info[0].lv);
                this.getRoleDetailInfo();
                this.getBuildGuildList();
                this.getOwnSoldiers();
                return;
            }
            this.fireEvent(logic.Login.EVT.REGISTER_ROLE);
        };
        Login.prototype.getRoleDetailInfo = function () {
            var roleId = LogicMgr.get(logic.Player).getRoleId();
            var data = { role_id: roleId };
            NetMgr.get(msg.Login).send("m_login_get_role_detail_tos", data);
        };
        Login.prototype.getBuildGuildList = function () {
            NetMgr.get(msg.Build).send("m_build_get_build_list_tos");
        };
        Login.prototype.getOwnSoldiers = function () {
            NetMgr.get(msg.Army).send("m_army_get_own_soldier_tos");
        };
        Login.prototype.onCreateRole = function (param) {
            console.log("onCreateRole = %d", param.ret_code);
            if (param.ret_code !== 1) {
                return;
            }
            LogicMgr.get(logic.Player).setRoleId(param.role_id);
            this.getRoleDetailInfo();
            this.getBuildGuildList();
            this.getOwnSoldiers();
        };
        Login.prototype.onGetRoleDetail = function (param) {
            console.log("onGetRoleDetail = %d", param.ret_code);
            if (param.ret_code !== 1) {
                return;
            }
            LogicMgr.get(logic.Player).setRoleId(param.role_info.role_id);
            LogicMgr.get(logic.Player).setRoleName(param.role_info.nick);
            LogicMgr.get(logic.Player).setRoleLevel(param.role_info.lv);
            LogicMgr.get(logic.Player).setRoleExp(param.role_info.cur_exp);
            LogicMgr.get(logic.Player).setNextLevelExp(param.role_info.next_lv_exp);
            LogicMgr.get(logic.Player).setCoin(param.role_info.coin);
            LogicMgr.get(logic.Player).setIngot(param.role_info.ingot);
            LogicMgr.get(logic.Player).setVipLevel(param.role_info.vip_lv);
            LogicMgr.get(logic.Player).setCamp(param.role_info.camp);
            this.finishedMessages = this.finishedMessages + 1;
            if (this.finishedMessages === this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
            }
        };
        Login.prototype.onGetBuildGuildList = function (param) {
            LogicMgr.get(logic.Build).setData(param.build_list);
            this.finishedMessages = this.finishedMessages + 1;
            if (this.finishedMessages === this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
            }
        };
        Login.prototype.onGetOwnSoldiers = function (param) {
            console.log("onGetOwnSoldiers = " + param.soldiers[0]);
            LogicMgr.get(logic.Camp).setSoldierIds(param.soldiers);
            this.finishedMessages = this.finishedMessages + 1;
            if (this.finishedMessages == this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
            }
        };
        Login.prototype.getServerListInfo = function () {
            return this.serverListInfo;
        };
        Login.prototype.getCurServerInfo = function () {
            return this.curServerInfo;
        };
        Login.prototype.setCurServerInfo = function (serverInfo) {
            this.curServerInfo = serverInfo;
        };
        return Login;
    }(Logic));
    Login.EVT = utils.Enum([
        "ENTER_GAME",
        "REGISTER_ROLE",
        "REFESH_SERVERINFO",
    ]);
    logic.Login = Login;
    __reflect(Login.prototype, "logic.Login");
    var ServerInfo = (function () {
        function ServerInfo() {
        }
        return ServerInfo;
    }());
    logic.ServerInfo = ServerInfo;
    __reflect(ServerInfo.prototype, "logic.ServerInfo");
})(logic || (logic = {}));
//# sourceMappingURL=Login.js.map