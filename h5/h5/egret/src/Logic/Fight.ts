namespace logic {
    
    export class Fight extends Logic {

        public static EVT = utils.Enum([
            "START_FIGHT",
        ]);

        public constructor() {
            super();
            NetMgr.get(msg.Fight).on("m_fight_report_toc", this.Event("onFight"));
        }

        protected onFight() {
            this.fireEvent(logic.Fight.EVT.START_FIGHT) 
        }
    }
}                