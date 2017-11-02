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
			await ResExt.loadGroup("preload", 0, (event: RES.ResourceEvent) => {
				this.setProgress(event.itemsLoaded, event.itemsTotal);
			});
			
			await ResExt.loadGroup("map");
			Singleton(Timer).after(0, this.Event("GameLoadingUI_Timer", this.startCreateScene));
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