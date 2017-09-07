namespace logic {
    
    export class Login extends Logic {

        private finishedMessages;
        private totalMessages: number = 3;
        private serverListInfo;
        private curServerInfo: ServerInfo;

        public static EVT = utils.Enum([
            "ENTER_GAME",
            "REGISTER_ROLE",
            "REFESH_SERVERINFO",
        ]);

        public constructor() {
            super();

            NetMgr.get(msg.Login).on("m_login_auth_toc", this.Event("onLogin"));
            NetMgr.get(msg.Login).on("m_login_create_role_toc", this.Event("onCreateRole"));
            NetMgr.get(msg.Login).on("m_login_get_role_detail_toc", this.Event("onGetRoleDetail"));
            NetMgr.get(msg.Build).on("m_build_get_build_list_toc", this.Event("onGetBuildGuildList"));
            NetMgr.get(msg.Army).on("m_army_get_own_soldier_toc", this.Event("onGetOwnSoldiers"));

            this.finishedMessages = 0;
            this.serverListInfo = RES.getRes("serverList_json");
            this.curServerInfo = this.serverListInfo[0];
        }

        protected onLogin(param) {
            console.log("onNetMsg", param);
            if(param["ret_code"] !== 1) {
                return;
            }

            if(param["login_info"].length !== 0) {
                LogicMgr.get(logic.Player).setRoleId(param.login_info[0].role_id);
                LogicMgr.get(logic.Player).setRoleName(param.login_info[0].nick);
                LogicMgr.get(logic.Player).setRoleLevel(param.login_info[0].lv);
                this.getRoleDetailInfo();
                this.getBuildGuildList();
                this.getOwnSoldiers();
                return;
            }

            this.fireEvent(logic.Login.EVT.REGISTER_ROLE) 
        }

        private getRoleDetailInfo() {
            let roleId = LogicMgr.get(logic.Player).getRoleId();
            let data = {role_id:roleId};
            NetMgr.get(msg.Login).send("m_login_get_role_detail_tos", data);
        }

        private getBuildGuildList() {
            NetMgr.get(msg.Build).send("m_build_get_build_list_tos");
        }

        private getOwnSoldiers() {
            NetMgr.get(msg.Army).send("m_army_get_own_soldier_tos");
        }

        protected onCreateRole(param) {
            console.log("onCreateRole = %d", param.ret_code);
            if(param.ret_code !== 1) {
                return;
            }

            LogicMgr.get(logic.Player).setRoleId(param.role_id);
            this.getRoleDetailInfo();
            this.getBuildGuildList();
            this.getOwnSoldiers();
        }

        protected onGetRoleDetail(param) {
            console.log("onGetRoleDetail = %d", param.ret_code);
            if(param.ret_code !== 1) {
                return 
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
            if(this.finishedMessages === this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
            }
        }

        protected onGetBuildGuildList(param) {
            LogicMgr.get(logic.Build).setData(param.build_list);
            this.finishedMessages = this.finishedMessages + 1;
            if(this.finishedMessages === this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
            }
        }

        protected onGetOwnSoldiers(param) {
            console.log("onGetOwnSoldiers = " + param.soldiers[0]);
            LogicMgr.get(logic.Camp).setSoldierIds(param.soldiers);
            this.finishedMessages = this.finishedMessages + 1;
            if(this.finishedMessages == this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
            }
        }

        public getServerListInfo(): any {
            return this.serverListInfo
        }

        public getCurServerInfo(): ServerInfo {
            return this.curServerInfo;
        }

        public setCurServerInfo(serverInfo) {
            this.curServerInfo = serverInfo;
        }

    }

    export class ServerInfo {
        public name: string;
        public ip: string;
        public port: number;
        public id: number;
    }
}                