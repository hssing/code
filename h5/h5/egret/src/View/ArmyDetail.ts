namespace ui {

    export class ArmyDetial extends UIBase {

        private static CUSTOM = {
            closeBg : {alpha: 0.5, disable: false},
            resGroup: ["armydetail"],
            skinName : "resource/ui/ArmyDetailUISkin.exml",
            binding : {
                ["btnClose"] : { method : "onClose", },
            },
        }

        protected lstArmy: eui.List;

        private data: any;

        public constructor(data) {
            super(ArmyDetial.CUSTOM);
            this.data = data;
        }

        protected onEnter(): void {
            super.onEnter();

            let arrayData = [];
            let phalanxs = [this.data.forward_phalanx, this.data.center_phalanx, this.data.back_phalanx];
            for (let v of phalanxs) {
                let cfg = LogicMgr.get(logic.Camp).getSoldierCfgById(v.soldiers_id);
                let tmp = utils.copyObject(v);
                tmp = utils.mergeObject(cfg, tmp);
                tmp.name = LTEXT(cfg.name);
                arrayData.push(tmp);
            }
            this.lstArmy.dataProvider = new eui.ArrayCollection(arrayData);
        }
    }

}