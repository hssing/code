module ui {
	export class PropItem extends IRBase {

		private imgBg: eui.Image;
		private imgIcon: eui.Image;
		private lbCount: eui.Label;
		private lbLv: eui.Label;
		private lbName: eui.Label;

        private static CUSTOM = {
            skinName : "resource/ui/Bag/PropItemSkin.exml",
        }

		public constructor() {
			super(PropItem.CUSTOM)
			this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
		}

		public dataChanged(): void {
			this.imgBg.source = this.getQualityImgKey(this.data.cfg.quality);
			this.imgIcon.source = this.data.cfg.icon;
			this.lbName.text = LTEXT(this.data.cfg.name);
			this.lbCount.text = this.data.info.num;

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

		private onTouchTap() {
			let data = {info: this.data.info, cfg: this.data.cfg, row: this.data.row, column: this.data.column};
			LogicMgr.get(logic.Bag).fireEvent(logic.Bag.EVT.ITEM_CLICKED, this.data);
		}
	}
}