namespace world {

    export class Block extends ViewBase {

        public build(): egret.DisplayObjectContainer {
            let view = new egret.DisplayObjectContainer();

            let tx: egret.Texture = RES.getRes(this.data.model);
            let bg = new eui.Image(tx);
            view.addChild(bg);
            bg.touchEnabled = false;
            bg.anchorOffsetX = tx.bitmapData.width / 2;
            bg.anchorOffsetY = tx.bitmapData.height / 2;
            let wpos = this.worldMap.cell2world(this.data.org.x, this.data.org.y);
            [view.x, view.y] = [wpos[0], wpos[1]];
            return view;
        }

        public refresh(): void {
        }
    }

}