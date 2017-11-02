namespace mo {
    
    export class Dynamic {

        private map: TMap;
        private dynamicCells: DynamicCells;
        private creator: Function;
        private collector: Function;
        private pos: CPoint;
        private cells: any;
        private node: egret.DisplayObjectContainer;

        public constructor(map: TMap, node: egret.DisplayObjectContainer, dynamicCells: any, creator: Function, collector: Function) {
            this.map = map;
            this.dynamicCells = dynamicCells;

            this.creator = creator;
            this.collector = collector;
            this.pos = { x : Infinity, y : Infinity, };
            this.cells = {};

            this.node = node;

            //this.node.cacheAsBitmap = true;
        }

        public getCellNode(cx: number, cy: number): any {
            let index = this.map.cell2index(cx, cy);
            return this.cells[index];
        }

        public update(x: number, y: number, info: any): void  {
            let indices = info.cells;
            this.updateTiles(info);
        }

        private updateTiles(info: any): void {
            let indices = info.cells;
            let cellsKeys = Object.keys(this.cells);
            for (let i = cellsKeys.length-1; i >= 0; i--){
                let index = cellsKeys[i];
                let node = this.cells[index];
                if (indices[index] === undefined) {
                    if (this.collector) {
                        this.collector(node, index);
                    }

                    this.node.removeChild(node);
                    delete this.cells[index];
                }
            }

            let indicesKeys = info.keys;// this.dynamicCells.getCellsKey();
            for (let i = indicesKeys.length-1; i >= 0; i--){
                let index = indicesKeys[i];
                if (index !== undefined && this.cells[index] === undefined) {
                    let node = this.creator(index);
                    if (!node) {
                        continue;
                    }

                    let pos = this.map.index2cell(parseInt(index));
                    let wpos = this.map.cell2world(pos[0], pos[1]);

                    [node.x, node.y] = wpos;
                    this.node.addChild(node);
                    this.cells[index] = node;
                }
            }
        }
    }

}
