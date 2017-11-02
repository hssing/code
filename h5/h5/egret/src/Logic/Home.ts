namespace logic {

    export class Home extends Logic {

        public static EVT = utils.Enum(
        [
            "REFRESH_ARMY_INFO",
        ]);

        private armyInfos = {};

        public constructor() {
            super();

            NetMgr.get(msg.Army).on("m_army_get_own_map_army_pos_toc", this.Event("onGetArmyInfo"));
        }

        public udpateArmyInfo() {
            NetMgr.get(msg.Army).send("m_army_get_own_map_army_pos_tos");
        }

        protected onGetArmyInfo(data) {
            this.armyInfos = data.army_pos_list;
            this.fireEvent(Home.EVT.REFRESH_ARMY_INFO, this.armyInfos);
        }

        public getArmyInfos(): any {
            return this.armyInfos;
        }

    }
}