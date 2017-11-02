module ui {
	export class PropUse extends UIBase {

		private lbLv: eui.Label;
		private lbCount: eui.Label;
		private lbName: eui.Label;
		private lbUseCount: eui.Label;
		private hsScope: eui.HSlider;
		private lbUsePropCount: eui.Label;
		private lbMaxPropCount: eui.Label;
		private imgBg: eui.Image;
		private imgIcon: eui.Image;

		private data: any;
		
        private static CUSTOM = {
			closeBg : { alpha : 0.5, },
            skinName : "resource/ui/Bag/PropUseSkin.exml",
            binding : {
                ["btnClose"] : { method : "onBtnClose", },
				["btnOk"] : { method : "onBtnOK", },
				["btnSub"] : { method : "onBtnSub", },
				["btnAdd"] : { method : "onBtnAdd", },
            },
        }

		public constructor(data: any) {
			super(PropUse.CUSTOM);	

			this.data = data;
		}

 		protected onEnter(): void {
			super.onEnter();

			this.hsScope.minimum = 0;
			this.hsScope.maximum = this.data.info.num;
			this.hsScope.addEventListener(eui.UIEvent.CHANGE, this.changeHandler, this);

			this.lbUsePropCount.text = String(0);
			this.lbMaxPropCount.text = String(this.data.info.num);
			this.imgBg.source = this.getQualityImgKey(this.data.cfg.quality);
			this.imgIcon.source = this.data.cfg.icon;
			this.lbName.text = LTEXT(this.data.cfg.name);
		 }

		private getQualityImgKey(quality: number) {
			let imgKey = DBRecord.fetchKey("GoodsQualityConfig_json", quality, "background");
			return imgKey;
		}

		 private changeHandler() {
			this.refreshData();
		 }

		 private onBtnSub() {
			 if(this.hsScope.value <= 0) {
				 return;
			 }

			 this.hsScope.value = this.hsScope.value - 1;
			 this.refreshData();
		 }

		 private onBtnAdd() {
			 if(this.hsScope.value >= this.data.info.num) {
				 return;
			 }

			 this.hsScope.value = this.hsScope.value + 1;
			 this.refreshData();
		 }

		 private refreshData() {
			 this.lbUsePropCount.text = String(this.hsScope.value);
		 }

		 private onBtnOK() {
			 LogicMgr.get(logic.Bag).sendMsgUseGoods(parseInt(this.data.info.id), this.hsScope.value, 1);
			 this.removeFromParent();
		 }

		 private onBtnClose() {
			this.removeFromParent();
		 }
	}
}