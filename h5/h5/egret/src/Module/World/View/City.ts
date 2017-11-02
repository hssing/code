namespace world {

    export class City extends ViewBase {

        public build(): egret.DisplayObjectContainer {
            let view = new egret.DisplayObjectContainer();

            let cement =  this.data.landCfg && this.data.landCfg.cement;
            let tx: egret.Texture = RES.getRes(cement || "dasset_cao_shuinidi_png");
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