namespace logic {
    
    export class Login extends Logic {

        private finishedMessages: number;   //此字段为每收到一条消息就加1
        private totalMessages: number = 6;  //登录注册成功后需要收到的消息条数
        private serverListInfo;
        private curServerInfo: ServerInfo;

        private isGameStarted = false;

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
            NetMgr.get(msg.Build).on("m_build_push_res_capacity_toc", this.Event("onResCapacity"));
			NetMgr.get(msg.Build).on("m_build_push_res_production_toc", this.Event("onResProduction"));
            NetMgr.get(msg.Goods).on("m_goods_toc", this.Event("onGetGoods"));
            NetMgr.get(msg.Role).on("m_role_assets_toc", this.Event("onUpdateRes"));

            this.finishedMessages = 0;
            this.serverListInfo = RES.getRes("serverList_json");
            this.curServerInfo = this.serverListInfo[0];
        }

        protected onLogin(param) {
            console.log("onNetMsg", param);
            if(param["ret_code"] !== 1) {
                return;
            }

            ServerTime.setTime(param.server_time);
            if(param["login_info"].length !== 0) {
                LogicMgr.get(logic.Player).setRoleId(param.login_info[0].role_id);
                LogicMgr.get(logic.Player).setRoleName(param.login_info[0].nick);
                LogicMgr.get(logic.Player).setRoleLevel(param.login_info[0].lv);
                this.getBaseDataBeforeEnterGame();
                return;
            }

            this.isGameStarted = false;
            this.fireEvent(logic.Login.EVT.REGISTER_ROLE);
        }

        public getRoleDetailInfo() {
            let roleId = LogicMgr.get(logic.Player).getRoleId();
            let data = {role_id:roleId};
            NetMgr.get(msg.Login).send("m_login_get_role_detail_tos", data);
        }

        public getBuildGuildList() {
            NetMgr.get(msg.Build).send("m_build_get_build_list_tos");
        }

        public getOwnSoldiers() {
            NetMgr.get(msg.Army).send("m_army_get_own_soldier_tos");
        }

        protected onCreateRole(param) {
            console.log("onCreateRole = %d", param.ret_code);
            if(param.ret_code !== 1) {
                return;
            }

            LogicMgr.get(logic.Player).setRoleId(param.role_id);
            this.getBaseDataBeforeEnterGame();
        }

        private getBaseDataBeforeEnterGame() {
            this.getRoleDetailInfo();
            this.getBuildGuildList();
            this.getOwnSoldiers();
            LogicMgr.get(logic.Bag).sendmsgGetGoods(1);
        }

        protected checkFinish(): void {
            if (this.isGameStarted) { return; }
            this.finishedMessages = this.finishedMessages + 1;
            if(this.finishedMessages === this.totalMessages) {
                this.fireEvent(logic.Login.EVT.ENTER_GAME);
                this.finishedMessages = 0;
                this.isGameStarted = true;
            }
        }
        
        protected onGetRoleDetail(param: msg.m_login_get_role_detail_toc) {
            console.log("onGetRoleDetail = %d", param.ret_code);
            if(param.ret_code !== 1) {
                return 
            }

            LogicMgr.get(logic.Player).setRoleId(param.role_info.role_id);
            LogicMgr.get(logic.Player).setRoleName(param.role_info.nick);
            LogicMgr.get(logic.Player).setRoleLevel(param.role_info.lv);
            LogicMgr.get(logic.Player).setRoleExp(param.role_info.cur_exp);
            LogicMgr.get(logic.Player).setNextLevelExp(param.role_info.next_lv_exp);
            LogicMgr.get(logic.Player).setVipLevel(param.role_info.vip_lv);
            LogicMgr.get(logic.Player).setCamp(param.role_info.camp);
            LogicMgr.get(logic.Player).setBaseTax(param.role_info.base_tax);
            LogicMgr.get(logic.Player).setRes(param.role_info.p_res);
            LogicMgr.get(logic.Player).setArmyEnrollInfos(param.role_info.army_enroll_info);
            
            this.checkFinish();
        }

        protected onGetBuildGuildList(param) {
            LogicMgr.get(logic.Build).setData(param.build_list);
            LogicMgr.get(logic.City).setData(param.city_list);

            this.checkFinish();
        }

        protected onGetOwnSoldiers(param) {
            console.log("onGetOwnSoldiers = " + param.soldiers[0]);
            LogicMgr.get(logic.Camp).setSoldierIds(param.soldiers);

            this.checkFinish();
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

        public onResCapacity(data: msg.m_build_push_res_capacity_toc) {
			console.log("onResCapacity");
            LogicMgr.get(logic.Player).setResCapacity(data.p_res_capacity);
            this.checkFinish();
		}

		public onResProduction(data: msg.m_build_push_res_production_toc) {
			console.log("onResProduction");
            LogicMgr.get(logic.Player).setResProduction(data.p_res_capacity_production);
            this.checkFinish();
		}

		private onGetGoods(data: msg.m_goods_toc) {
            LogicMgr.get(logic.Bag).setGoods(data);
            this.checkFinish();
		}

        private onUpdateRes(data: msg.m_role_assets_toc) {
            let res: Res =  LogicMgr.get(logic.Player).getRes();
            for(let key in res) {
                if(!data.p_res[key]) {
                    continue;
                }

                res[key] = data.p_res[key];
            }

            LogicMgr.get(logic.Player).setRes(res);
        }

    }

    export class ServerInfo {
        public name: string;
        public ip: string;
        public port: number;
        public id: number;
    }
}                