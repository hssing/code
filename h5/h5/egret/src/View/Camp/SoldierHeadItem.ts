module ui {

	export class SoldierHeadItem extends IRBase {
		
		protected imgFrameBg: eui.Image;
		protected imgCard: eui.Image;
		protected soldierItem: eui.Group;
		protected lbName: eui.Label;

		private static CUSTOM = {
            skinName : "resource/ui/Camp/SoldierHeadItemUISkin.exml",
        }

		public constructor() {
			super(SoldierHeadItem.CUSTOM);
		}

		protected onEnter(): void {
			super.onEnter();
		}

		protected dataChanged(): void { 
			this.imgCard.source = this.data.portrait;
			this.lbName.text = this.data.name;
		}	
	}

}