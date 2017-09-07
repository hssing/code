namespace world {

    export class Tablet extends ViewBase {

        public constructor(mgr: Manager, root: egret.DisplayObjectContainer, data: any) {
            super(mgr, root, data);
        }

        public build(): egret.DisplayObjectContainer {
            let view = new egret.DisplayObjectContainer();

            let tx: egret.Texture = RES.getRes("shuinidi_png");
            let bg = new eui.Image(tx);
            view.addChild(bg);
            bg.touchEnabled = false;
            bg.anchorOffsetX = tx.bitmapData.width / 2;
            bg.anchorOffsetY = tx.bitmapData.height / 2;
            
            return view;
        }

        public refresh(): void {
            let wpos = this.worldMap.cell2world(this.data.x, this.data.y);
            [this.view.x, this.view.y] = [wpos[0], wpos[1]];
        }
    }

}