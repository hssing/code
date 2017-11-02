module ui {

	export class SoldierInfor extends UIBase {

        private soldierInfo:any;

        private hp:eui.Label;
        private energy:eui.Label;
        private lingneng:eui.Label;
        private defence:eui.Label;
        private strength:eui.Label;
        private crit:eui.Label;
        private attack_speed:eui.Label;
        private armor_penetration:eui.Label;
        private move_speed:eui.Label;
        private attack_distance:eui.Label;

        private static CUSTOM = {
            skinName : "resource/ui/Soldier/SoldierInforSkin.exml",
            binding : {
                ["btnClose"] : { method : "onBtnClose" ,},

            },
        }

		public constructor(soldierInfo) {
			super(SoldierInfor.CUSTOM);
            // console.log("tt == " + tt);
            this.soldierInfo = soldierInfo;
            this.resetInfo();
		}

        protected onEnter(): void {
            super.onEnter();
        }

        protected resetInfo () {
            this.hp.text = this.soldierInfo.hp;
            this.energy.text = this.soldierInfo.energy;
            this.lingneng.text = this.soldierInfo.lingneng;
            this.defence.text = this.soldierInfo.defence;
            this.strength.text = this.soldierInfo.strength;
            this.crit.text = this.soldierInfo.crit;
            this.attack_speed.text = this.soldierInfo.attack_speed.toFixed(2);
            this.armor_penetration.text = this.soldierInfo.armor_penetration.toFixed(2); 
            this.move_speed.text = this.soldierInfo.move_speed;
            this.attack_distance.text = this.soldierInfo.attack_distance;
        }

        protected onBtnClose() {
            console.log("onBtnClose");
            this.removeFromParent();
        }
	}
}