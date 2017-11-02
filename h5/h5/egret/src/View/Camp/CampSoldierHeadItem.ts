module ui {
	export class CampSoldierHeadItem extends SoldierHeadItem {
		
		private group: eui.Group;
		private img1: eui.Image;
		private img2: eui.Image;

		public constructor() {
			super();
		}

		protected onEnter(): void {
			super.onEnter();
			this.scaleX = 0.65;
			this.scaleY = 0.65;
			
			this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
		}

		protected onTouchBegin(e: egret.TouchEvent) {
			this.group = new eui.Group();
			this.group.x = 0;
			this.group.y = 0;
			this.soldierItem.addChild(this.group);
			this.img1 = new eui.Image(this.imgFrameBg.texture);
			this.img1.x = this.imgFrameBg.x;
			this.img1.y = this.imgFrameBg.y;
			this.img1.width = this.imgFrameBg.width;
			this.img1.height = this.imgFrameBg.height;
			this.img1.scaleX = 0.65;
			this.img1.scaleY = 0.65;
			this.group.addChild(this.img1);

			this.img2 = new eui.Image(this.imgCard.texture);
			this.img2.x = this.imgCard.x;
			this.img2.y = this.imgCard.y;
			this.img2.scaleX = 0.65;
			this.img2.scaleY = 0.65;
			this.group.addChild(this.img2);
			this.group.visible = true;

			LogicMgr.get(logic.Camp).fireEvent(logic.Camp.EVT.SOLDIER_TOUCH_BEGIN, this.group, this.data);
		}
	}
}