module ui {
	export class BuyTax extends UIBase {
        private ignot_count: eui.Label;
        private count: eui.Label;
        private btnOK: eui.Button;
        private btnCancel: eui.Button;

        private static CUSTOM = {
            skinName : "resource/ui/BuildUISkins/BuyTaxUISkin.exml",
            binding : {
                ["btnCancel"] : { method : "onBtnCancel", },
                ["btnOK"] : { method : "onBtnOK",},
            },
        }

		public constructor() {
			super(BuyTax.CUSTOM);
		}

		public onEnter() {
			super.onEnter();
            let baseTax = LogicMgr.get(logic.Player).getBaseTax();
            let ingot_spend = LogicMgr.get(logic.Build).getUsedIngotToBuyTaxTime(baseTax.today_buy_count + 1);
            let taxUpLimit = LogicMgr.get(logic.Build).getBuyUpLimitTax();
            this.count.text = (taxUpLimit - baseTax.today_buy_count) + "";
            this.ignot_count.text = ingot_spend + "";

            if(taxUpLimit === baseTax.today_buy_count) {
                this.btnOK.touchEnabled = false;
                utils.setGray(this.btnOK);
            } else {
                this.btnOK.touchEnabled = true;
                utils.resetColor(this.btnOK);
            }
		}
        
        private onBtnCancel() {
            this.removeFromParent();
        }

        private onBtnOK() {
            this.removeFromParent();
            LogicMgr.get(logic.Build).buyTax();
        }
	}
}