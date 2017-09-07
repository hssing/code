namespace mo {

    export class TileLayer extends Layer {

        private strategy: Dynamic;
        private dynamicCells: DynamicCells;
        private pool: any;

        public constructor(map: TMap, name: string, layerIdx: number, camera: Camera, data: any, dynamicCells: any) {
            super(map, name, layerIdx, data);

            let self = this;
			this.dynamicCells = dynamicCells;
            this.pool = {};

            this.strategy = new Dynamic(map, this.node, this.dynamicCells, (index) => {
                let tile = this.dataSource.getCellTile(index, this.layerIdx);
                if (tile === undefined) {
                    return undefined;
                }
                let key = this.getTileKey(tile);
                if (this.pool[key] && this.pool[key].length > 0) {
                    return this.pool[key].pop();
                }

                let sp = this.getSprite(tile, key, index, self.data.info);
                sp.y += self.data.info.ch - sp.height;

                let gp = new eui.Group();
                gp.addChild(sp);
                gp.width = self.data.info.cw;
                gp.height = self.data.info.ch;
                gp.anchorOffsetX = gp.width / 2;
                gp.anchorOffsetY = gp.height / 2;
                gp.name = key;
                return gp;

            }, (node, index) => {
                let key = node.name;
                this.pool[key] = this.pool[key] || []
                this.pool[key].push(node);
            });
        }

        public dispose() {
        	super.dispose();
        }

        public getTileKey(tile: any): any {
            let rect = tile.rect;
            return `${tile.image}:${rect.x}-${rect.y}`;
        }

        public getSprite(tile: any, key: string, index: number, info: any): any {
            let url = (tile.image as string).replace(".", "_");
            let bitmapData = RES.getRes(url);
            
            //let bitmapData = RES.getRes(`resource/assets/Map/${tile.image}`);
            let bm = new egret.Bitmap(bitmapData);
            let spriteSheet = new egret.SpriteSheet(bm.texture);
            //创建一个新的 Texture 对象
            let rect = tile.rect;
            let tx = spriteSheet.getTexture(key);
            if (!tx) {
                tx = spriteSheet.createTexture(key, rect.x, rect.y, rect.width, rect.height);
            }
            
            let sp = new eui.Image(tx);
            [sp.x, sp.y] = [tile.offsetX, tile.offsetY];
            [sp.width, sp.height] = [rect.width, rect.height];
            return sp;
        }

        public viewportChanged(x: number, y: number, info: any): void {
            this.strategy.update(x, y, info);
            if (!this.dynamicCells.isNeedUpdate()) { return; }
            this.map.callUpdateCallback(this.dynamicCells.getCells(), this.getName());
        }

        public getCellNode(cx: number, cy: number): eui.Group {
            return this.strategy.getCellNode(cx, cy);
        }
    }
}