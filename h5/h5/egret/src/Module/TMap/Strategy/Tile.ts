namespace mo {

    export class Tile {

        private viewSize: Size;
        private tileSize: any;
        private offset: any;
        private node: eui.Group;

        public constructor(viewSize: any, tileSize: any, node: any, creator: any) {
            this.viewSize = viewSize;
            this.tileSize = tileSize;

            let tiles = this.createTiles(creator);
            this.offset = tiles.offset;
            this.node = tiles.node;
            // 优化drawcall
            this.node.cacheAsBitmap = true;
            node.addChild(this.node);
        }

        public getNode(): eui.Group {
            return this.node;
        }

        public update(x: number, y: number): void {
            x = this.offset.x + x;
            y = this.offset.y + y;

            let [cx, cy] = [this.node.x, this.node.y];
            if (Math.abs(cx - x) < this.tileSize.w && Math.abs(cy - y) < this.tileSize.h) {
                return;
            }
  
            let ox = (cx - x) % this.tileSize.w;
            let oy = (cy - y) % this.tileSize.h;
            [this.node.x, this.node.y] = [x + ox, y + oy];
        }

        public createTiles(creator: Function): any {
            let offset = {
                x : this.viewSize.width  / 2,
                y : this.viewSize.height / 2,
            };

            let cw = Math.ceil(this.viewSize.width / this.tileSize.w) + 3;
            let ch = Math.ceil(this.viewSize.height / this.tileSize.h) + 3;

            let ox = -Math.ceil(this.tileSize.w * cw / 2);
            let oy = -Math.ceil(this.tileSize.h * ch / 2);

            let node = new eui.Group();
            for (let i = 0; i < cw; i++) {
                for (let j = 0; j < ch; j++) {
                    let tile = creator();
                    let x = ox + this.tileSize.w * (i);
                    let y = oy + this.tileSize.h * (j);
                    [tile.x, tile.y] = [x, y];
                    node.addChild(tile);
                }
            }

            return { offset : offset, node : node, };
        }
    }
    
}
