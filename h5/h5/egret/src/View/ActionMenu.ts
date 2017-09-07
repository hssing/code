namespace ui {

    export class ActionMenu extends UIBase {

        private static CUSTOM = {
            skinName : "resource/ui/ActionMenuUISkin.exml",
            binding : {
                ["btnBack"] : { method : "onBtnBack", },
                ["btnAction"] : { method : "onBtnAction", },
                ["btnBuild"] : { method : "onBtnBuild", },
            },
        }

        private world: ui.World;
        private btnBuild: eui.Button;

        public constructor(world: ui.World, data: any) {
            super(ActionMenu.CUSTOM);
            this.world = world;
            this.data = data;
            this.lbInfo.text = `${data.info.x}, ${data.info.y}`;

            this.btnBuild.visible = false;
            if (LogicMgr.get(logic.World).isBlocked(data.info.x, data.info.y)){
                this.lbInfo.text = "阻挡！";
            }else {
                this.btnBuild.visible = true;
            }
        }

        protected onExit(): void {
            super.onExit();
            this.world = null;
        }

        private onBtnBack(e: egret.TouchEvent): void {
            console.log("onBtnBack");
            this.world.closeItem();
        }

        private onBtnBuild(e: egret.TouchEvent): void {
            console.log("onBtnBuild");
            LogicMgr.get(logic.World).buildUnit(this.data.info.x, this.data.info.y);
            this.world.onSightUdpate();
            this.world.closeItem();
        }

        private onBtnAction(e: egret.TouchEvent): void {
            console.log("onBtnAction");
            this.world.closeItem();

            let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            if (armyInfo.length === 0) { return; } // no army

            UIMgr.open(ArmyMove, void 0, this.data);
        }

        private btnAction: eui.Button;
        private lbInfo: eui.Label;
        private data;

    }

}