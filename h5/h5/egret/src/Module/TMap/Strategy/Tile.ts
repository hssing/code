namespace mo {

    export class Tile {

        private viewSize: Size;
        private tileSize: any;
        private node: egret.DisplayObjectContainer;

        public constructor(viewSize: any, tileSize: any, node: any, creator: any) {
            this.viewSize = viewSize;
            this.tileSize = tileSize;

            this.node = this.createTiles(creator);
            // 优化drawcall
            this.node.cacheAsBitmap = true;
            node.addChild(this.node);
        }

        public getNode(): egret.DisplayObjectContainer {
            return this.node;
        }

        public update(x: number, y: number): void {
            let [cx, cy] = [this.node.x, this.node.y];
            if (Math.abs(cx - x) < this.tileSize.w && Math.abs(cy - y) < this.tileSize.h) {
                return;
            }
  
            let ox = (cx - x) % this.tileSize.w;
            let oy = (cy - y) % this.tileSize.h;
            [this.node.x, this.node.y] = [x + ox, y + oy];
        }

        public createTiles(creator: Function): any {
            let cw = Math.ceil(this.viewSize.width / this.tileSize.w) + 6;
            let ch = Math.ceil(this.viewSize.height / this.tileSize.h) + 6;

            let ox = -this.tileSize.w * 3;
            let oy = -this.tileSize.h * 3;

            let node = new egret.DisplayObjectContainer();
            for (let i = 0; i < cw; i++) {
                for (let j = 0; j < ch; j++) {
                    let tile = creator();
                    let x = ox + this.tileSize.w * i;
                    let y = oy + this.tileSize.h * j;
                    [tile.x, tile.y] = [x, y];
                    node.addChild(tile);
                }
            }

            return node;
        }
    }
    
}
