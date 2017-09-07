namespace ui {

	export class CampDetail extends UIBase{
		
		private mScroller: eui.Scroller;
		private group: eui.Group;
		private _iAlignMode:number;

	    private static CUSTOM = {
            skinName : "resource/ui/CampUISkin.exml"
        }

		public constructor() {
			super(CampDetail.CUSTOM);

			this.createGrideList();
		}

		private createGrideList() {
			this.group = new eui.Group();
			this.mScroller.viewport = this.group;
			
			
			for ( let i:number = 1; i <= 200; ++i ) {
				var btn:eui.Button = new eui.Button();
				btn.label = "按钮" + ( i < 10 ? "0" : "" ) + i;
				this.group.addChild( btn );
			}

			var tLayout:eui.TileLayout = new eui.TileLayout();
			tLayout.paddingTop = 30;
			tLayout.paddingLeft = 30;
			tLayout.paddingRight = 30;
			tLayout.paddingBottom = 30;
			this.group.layout = tLayout;

			this._iAlignMode = AlignMode.GAP;
			tLayout.columnAlign = eui.ColumnAlign.JUSTIFY_USING_GAP;
			tLayout.rowAlign = eui.RowAlign.JUSTIFY_USING_GAP;
		}

	}

	class AlignMode {
		public static GAP:number = 0;
		public static WH:number = 1;
	}

}