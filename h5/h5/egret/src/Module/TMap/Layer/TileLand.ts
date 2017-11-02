namespace mo {

    export class TileLand extends TileLayer {

        protected getCellTile(index: number, layerIdx: number): any {
            return this.dataSource.getCellCfgTile(index, layerIdx);
        }

        protected getSprite(tile: any, key: string, index: number, info: any): any {
            let image: string = tile.lcfg[tile.tcfg.img];
            let url = image.replace(".", "_");
            let bitmapData = RES.getRes(url);
            
            let sp = new egret.Bitmap(bitmapData);
            [sp.width, sp.height] = [bitmapData.width, bitmapData.height];
            sp.anchorOffsetX = sp.width / 2;
            sp.anchorOffsetY = sp.height / 2;
            [sp.x, sp.y] = [info.cw / 2, info.ch / 2];
            return sp;
        }
    }
}