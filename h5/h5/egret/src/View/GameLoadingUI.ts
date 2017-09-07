namespace ui {
	
	export class GameLoadingUI extends UIBase {

		private progress: eui.ProgressBar;
		private bg: eui.Image;

		private static CUSTOM = {
			skinName : "resource/ui/LoadingUISkin.exml"
		}

		public constructor() {
			super(GameLoadingUI.CUSTOM);
		}

		protected onEnter() {
			super.onEnter();
			this.loadRes();
		}

		public setProgress(current:number, total:number): void {
			this.progress.minimum = current / total * 100;
		}

		private async loadRes() {
			let self = this;
			let loading:RES.PromiseTaskReporter = {
				onProgress(current: number, total: number) {
						self.setProgress(current,total);
					}
				};
			await RES.loadGroup("preload", 0, loading);
			
			for (let v of config.MAP_URLS) {
				await RES.getResAsync(v);
			}
			
			let timer = new egret.Timer(0, 1);
			timer.addEventListener(egret.TimerEvent.TIMER, ()=>this.startCreateScene(), this);
			timer.start();
		}

		private startCreateScene() {
			console.log("startCreateScene");
			UIMgr.open(ui.World, "scene");
			UIMgr.open(ui.Home, "home");
			UIMgr.open(ui.Guide, "guide")
			this.removeFromParent();
		}
		
	}
	
}