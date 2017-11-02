module ui {
	export class CommandCenterItem extends IRBase {

        private group: eui.Group;
        private allCount: eui.Label;
		private coolingTime: eui.Label;
        private surplusCount: eui.Label;
        private imgClock: eui.Image;
        private btnAdd: eui.Button;
		private btnTax: eui.Button;
		private lbTime: eui.Label;

		private static interval: number =  500;
		private static event: string = "refeshTimer";
        
        private static CUSTOM = {
            skinName : "resource/ui/BuildUISkins/CommandCenterResItemUISkin.exml",
            binding : {
				["btnAdd"] : { method : "onBtnAdd" },
				["btnTax"] : { method: "onBtnTax"},
            },
        }

		public constructor() {
			super(CommandCenterItem.CUSTOM);
		}

		public onEnter() {
			super.onEnter();
		}

        protected dataChanged():void {
            if(this.data.type === logic.ResTypeId.Coin ) {
                LogicMgr.get(logic.Build).on(logic.Build.EVT.USE_TAX, this.Event("onUseTax"));
                LogicMgr.get(logic.Build).on(logic.Build.EVT.BUY_TAX, this.Event("onBuyTax"));
                Singleton(Timer).repeat(CommandCenterItem.interval, this.Event(CommandCenterItem.event, this.refeshStatus));
                this.group.visible = true;
				this.lbTime.visible = false;
                this.refeshStatus();
            } else {
                this.group.visible = false;
				this.lbTime.visible = true;
            }
        }

		private refeshStatus() {
			let baseTax = LogicMgr.get(logic.Player).getBaseTax();
			let sec = ServerTime.getDiffTime(baseTax.next_timestamp);
			let taxCount = LogicMgr.get(logic.Build).getTaxUpLimit();
			let surplusCount = LogicMgr.get(logic.Build).getCurTaxCount();

			this.allCount.text = LogicMgr.get(logic.Build).getTaxUpLimit() + "";
			this.surplusCount.text = LogicMgr.get(logic.Build).getCurTaxCount() + "";
			
			if(baseTax.next_timestamp > 0 && sec > 0) {
				this.coolingTime.visible = true;
				this.imgClock.visible = true;
				let st = ServerTime.secToDay(sec);
				this.coolingTime.text = ServerTime.formatTime(st);
			} else {
				this.coolingTime.visible = false;
				this.imgClock.visible = false;
			}

			if(taxCount === surplusCount) {
				this.btnAdd.touchEnabled = false;
				utils.setGray(this.btnAdd);
				
			} else {
				this.btnAdd.touchEnabled = true;
				utils.resetColor(this.btnAdd);
			}

			if(sec > 0) {
				this.btnTax.touchEnabled = false;
				utils.setGray(this.btnTax);
			} else {
				this.btnTax.touchEnabled = true;
				utils.resetColor(this.btnTax);
			}
		}

        private onBtnAdd() {
            if(this.data.type === logic.ResTypeId.Coin) {
                UIMgr.open(BuyTax);
            }
		}

		private onBtnTax() {
            if(this.data.type === logic.ResTypeId.Coin) {
                LogicMgr.get(logic.Build).useBaseTax();
            }
		}

        private onUseTax() {
            if(this.data.type === logic.ResTypeId.Coin) {
                this.refeshStatus();
            }
		}

		private onBuyTax() {
            if(this.data.type === logic.ResTypeId.Coin) {
                this.refeshStatus();
            }
		}
	}
}