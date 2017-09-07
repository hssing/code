namespace ui {

    export class ArmyMoveItem extends IRBase {

        private checkBox: eui.CheckBox;
        private armyName: eui.Label;
        
        private static CUSTOM = {
            skinName : "resource/ui/ArmyMove/ArmyMoveListIRSkin.exml",
            binding : {
                ["checkBox"]: { method : "onCheckBox"}
            },
        }

        public constructor(custom) {
            super(ArmyMoveItem.CUSTOM);
            this.enableTouch();
        }

        protected onCheckBox(): void {
            if(this.checkBox.selected) {
                LogicMgr.get(logic.World).fireEvent(logic.World.EVT.ADD_ARMY, this.armyName.text);
            } else {
                LogicMgr.get(logic.World).fireEvent(logic.World.EVT.DELETE_ARMY, this.armyName.text);
            }
            
        }

        private lbText: eui.Label;
    }

}