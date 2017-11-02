namespace ui {
	
	export class ResLoadingUI extends UIBase {

		private lbProgess: eui.Label;
		private imgTip: eui.Image;

		private static CUSTOM = {
			skinName : "resource/ui/ResLoadingUISkin.exml"
		}

		public constructor() {
			super(ResLoadingUI.CUSTOM);
		}

		protected onEnter() {
            super.onEnter();
            this.visible = false;
			egret.Tween.get(this.imgTip, {loop : true}).to({rotation : 360}, 2000);
        }

		public removeFromParent(): void {
        	this.parent.removeChild(this);
    	}

		public loadGroup(name: string): Promise<any> {
			let self = this;
            let loading =  (event: RES.ResourceEvent) => {
				this.setProgress(event.itemsLoaded, event.itemsTotal)
			}

            return ResExt.loadGroup(name, 0, loading);
		}

		public setProgress(current:number, total:number): void {
			let percent = Math.floor(current / total * 100);
			this.lbProgess.text = `${percent}%`;
		}
	}
	
}