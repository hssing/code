namespace logic {

    export class Home extends Logic {

        public constructor() {
            super();

            LogicMgr.get(logic.Login).on(logic.Login.EVT.START, this.Event("onLogic"));
        }

       protected onLogic(param1, param2) {
            console.log("onLogic Home", param1, param2);
        }

    }
}