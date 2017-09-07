module ui {
	export class SoldierHeadItem extends IRBase {
		
		private onBtn: eui.Button;
		private img2: eui.Image;
		private img1: eui.Image;
		private group: eui.Group;
		private img_bg: eui.Image;
		private img_bg0: eui.Image;
		private soldierItem: eui.Group;

		private static CUSTOM = {
            skinName : "resource/ui/Camp/SoilderHeadItemUISkin.exml",
        }

		public constructor() {
			super(SoldierHeadItem.CUSTOM);
			
		}

		protected onEnter(): void {
			super.onEnter();
			console.log("=================SoilderHeadItemUISkin");
			//LogicMgr.get(logic.Build).on(logic.Build.EVT.SOLDIER_TOUCH_END, this.Event("onSoldierTouchEnded"));
			this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
			// this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
			// this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
		}

		protected onBtnClicked() {
			console.log("onBtnClicked");
		}

		protected onTouchBegin(e: egret.TouchEvent) {
			console.log("========onBegin");
			this.group = new eui.Group();
			this.group.x = 0;
			this.group.y = 0;
			this.soldierItem.addChild(this.group);
			this.img1 = new eui.Image(this.img_bg.texture);
			this.img1.x = this.img_bg.x;
			this.img1.y = this.img_bg.y;
			this.img1.width = this.img_bg.width;
			this.img1.height = this.img_bg.height;
			this.img1.scaleX = this.img_bg.scaleX;
			this.img1.scaleY = this.img_bg.scaleY;
			this.group.addChild(this.img1);

			this.img2 = new eui.Image(this.img_bg0.texture);
			this.img2.x = this.img_bg0.x;
			this.img2.y = this.img_bg0.y;
			this.img2.scaleX = this.img_bg0.scaleX;
			this.img2.scaleY = this.img_bg0.scaleY;
			this.group.addChild(this.img2);
			this.group.visible = true;

			LogicMgr.get(logic.Camp).fireEvent(logic.Camp.EVT.SOLDIER_TOUCH_BEGIN, this.group, this.data);
		}	

		// protected onTouchMove(e: egret.TouchEvent) {
		// 	console.log("=======onMove");
		// 	this.group.x += e.stageX - this.point.x;
		// 	this.group.y += e.stageY - this.point.y;
			
		// 	this.point.x = e.stageX;
		// 	this.point.y = e.stageY;
		// }

		// protected onTouchEnd(e: egret.TouchEvent) {
		// 	console.log("+++onTouchEnd");
		// 	this.group.x = 0;
		// 	this.group.y = 0;
		// }
	}
}