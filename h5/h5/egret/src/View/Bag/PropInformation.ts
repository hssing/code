module ui {
	export class PropInformation extends IRBase {

		private imgBg: eui.Image;
		private imgIcon: eui.Image;
		private lbCount: eui.Label;
		private lbLv: eui.Label;
		private lbName: eui.Label;
		private lbDescribe: eui.Label;

        private static CUSTOM = {
            skinName : "resource/ui/Bag/PropInformationSkin.exml",
            binding : {
                ["btnUse"] : { method : "onBtnUse", },
            },
        }

		public constructor() {
			super(PropInformation.CUSTOM)
		}

		protected dataChanged(): void { 
			this.imgBg.source = this.getQualityImgKey(this.data.cfg.quality);
			this.imgIcon.source = this.data.cfg.icon;
			this.lbName.text = LTEXT(this.data.cfg.name);
			this.lbCount.text = this.data.info.num;
			this.lbDescribe.text = LTEXT(this.data.cfg.desc);
			this.lbCount.visible = true;
			if(Math.floor(this.data.info.num) === 1) {
				this.lbCount.visible = false;
			}

			if(this.data.info.type === GoodsType.Equip) {
				
			} else {
				this.lbLv.visible = false;
			}
		}

		private getQualityImgKey(quality: number) {
			let imgKey = DBRecord.fetchKey("GoodsQualityConfig_json", quality, "background");
			return imgKey;
		}

		private onBtnUse() {
			if(this.data.info.type === GoodsType.Equip) {
				
			} else {
				let data = {info: this.data.info, cfg: this.data.cfg};
				UIMgr.open(ui.PropUse, "panel", data);
			}
			LogicMgr.get(logic.Bag).fireEvent(logic.Bag.EVT.REMOVE_EXTENDITEM);
		}
	}
}