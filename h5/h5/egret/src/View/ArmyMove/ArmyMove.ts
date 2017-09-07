namespace ui {

    export class ArmyMove extends UIBase {

        private btnClose: eui.Button;
        private btnOK: eui.Button;
        private seletedArmys: Map<string, number>;
    
        private static CUSTOM = {
            closeBg : {alpha: 0.5, disable: false},
            skinName : "resource/ui/ArmyMove/ArmyMoveUISkin.exml",
            binding: {["btnClose"]: { method : "onBtnClose"}, ["btnOK"]: { method : "onBtnOK"}}
        }

        private param: any;

        public constructor(param) {
            super(ArmyMove.CUSTOM);
            this.param = param;
            this.seletedArmys = new Map<string, number>();
        }

        protected onDeleteArmy(data) {
            console.log("===onDeleteArmy"+ data);
            if(this.seletedArmys.get(data)) {
                this.seletedArmys.delete(data);
            }
        }

        protected onAddArmy(data) {
            console.log("===onAddArmy" + data);
            if(this.seletedArmys.get(data)) {
                return;
            }

            this.seletedArmys.set(data, parseInt(data));
        }

        protected onEnter(): void {
            super.onEnter();
            this.lstArmy.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.onChange, this);
            let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            let data = this.getData(armyInfo);
            this.refresh(data);

            LogicMgr.get(logic.World).on(logic.World.EVT.ADD_ARMY, this.Event("onAddArmy"));
            LogicMgr.get(logic.World).on(logic.World.EVT.DELETE_ARMY, this.Event("onDeleteArmy"));
        }

        private getData(armyInfo: any[]) {
            let data = []
            for(let i = 0; i < armyInfo.length; i ++) {
                let item = {"armyName": null, 
                            "strength": null, 
                            "speed": null, 
                            "status": null, 
                            "dis": null, 
                            "time": null, 
                            "icon": null,
                            "selected" : false,
                        };
                item.armyName = armyInfo[i].army_id;
                item.strength = armyInfo[i].forward_phalanx.hp + armyInfo[i].center_phalanx.hp + armyInfo[i].back_phalanx.hp;
                item.speed = 70;
                item.status = "空闲";
                item.dis = 0;
                item.time = "00:00:00";
                item.icon = "chuzheng_icon_buduichuzheng_s4_png";

                data.push(item);
            }
            return data;
        }

        public refresh(data: any[]): void {
            this.lstArmy.dataProvider = new eui.ArrayCollection(data);
        }

        public onChange(e:eui.PropertyEvent) {
    
        }

        protected onBtnClose() {
            console.log("onBtnClose");
            this.removeFromParent();
        }

        protected onBtnOK() {
            this.removeFromParent();
            console.log("onBtnOK");
            let iterator = this.seletedArmys.values()[Symbol.iterator](), step;
            while(!(step = iterator.next()).done){
                console.log(step.value);
                LogicMgr.get(logic.World).moveArmyToCell(step.value, this.param.info.x, this.param.info.y);
            }
        }

        private lstArmy: eui.List;
    }

}