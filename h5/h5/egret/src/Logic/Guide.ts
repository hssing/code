namespace logic {
    export class Guide extends Logic {
        
        private actions: Array<GuideAction>;

        public static EVT = utils.Enum([
            "ACTION_FINISHED",
        ]);

        public constructor() {
            super();
            this.actions = new Array<GuideAction>();
        }

        public createGuideById(id) {
            let guidesData = RES.getRes("GuideMotherConfig_json");
            let actionsData = guidesData[id];

            for(let i = 0; i < actionsData.length; i ++ ) {
                let actionData = actionsData[i]
                let isBottom = actionData.isBottom;
                let layer = actionData.layer;
                let btn: string = actionData.btn;

                let action = new GuideAction();
                action.setBtn(btn);
                action.setIsBottom(isBottom);
                action.setUi(ui);
                action.setLayer(layer);
                this.actions.push(action);
            }			
            this.runGuideAction();
        }

        private runGuideAction() {
            if(!this.actions || this.actions.length <= 0) {
                return;
            }
            let action = this.actions[0];
            action.run();
        }

        public finishAction() {
            this.actions.shift();
            if(this.actions && this.actions.length === 0) {
                return;
            }

            this.runGuideAction();
        }
    }

    class GuideAction {

        private btn: string;
        private ui: any;
        private isBottom: boolean;
        private layer: string;
        
        public constructor() {
        }

        public setBtn(btn: string) {
            this.btn = btn;
        }

        public setUi(ui) {
            this.ui = ui;
        }

        public setIsBottom(isBottom: boolean) {
            this.isBottom = isBottom;
        }

        public setLayer(layer: string) {
            this.layer = layer;
        }

        public run() {
            let ui = null;
            if(this.layer === "home") {
                ui = UIMgr.getHome();
            }else if(this.layer === "world") {
                ui = UIMgr.getWorld();
            }else {
                let panel = UIMgr.getLayer("panel");
                ui = panel.getChildAt(panel.numChildren - 1);
            }
            UIMgr.getGuide().createGuidePanel(ui[this.btn], this.isBottom);
        }
    }

}