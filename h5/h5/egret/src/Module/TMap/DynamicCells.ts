namespace mo {

    export class DynamicCells {

        private map: TMap;
        private viewSize: any;
        private cells: any;
        private pos: any;
        private isUpdate: any;
        private keyCache: any;
        private cellFiles: any;

        public constructor(map: TMap) {
            this.map = map;

            this.cells = {};
            this.keyCache = [];
            this.cellFiles = {};
            this.isUpdate = false;
            this.pos = {x : Infinity, y:  Infinity};
        }

        public isNeedUpdate(): boolean {
            return this.isUpdate;
        }

        public update(x: number, y: number): void {
            let size = this.map.getViewSize();
            let cx = this.pos.x;
            let cy = this.pos.y;
            if (Math.abs(x - cx) < size.width * 0.5 && Math.abs(y - cy) < size.height * 0.5) {
                this.isUpdate = false;
                this.keyCache = [];
                this.cellFiles = {};
                return;
            }
            
            this.isUpdate = true;
            [this.pos.x, this.pos.y] = [x, y];
            this.cells = this.updateCells(x, y);
        }

        public getCells(): any {
            return this.cells;
        }

        public getCellsKey(): any {
            return this.keyCache;
        }

        public getCellFiles(): any {
            return this.cellFiles;
        }

        private updateCells(x: number, y: number): any {
            let viewSize = this.map.getViewSize();
            let wx1 = x - viewSize.width * 0.5;
            let wy1 = y - viewSize.height * 0.5;
            let wx2 = x + viewSize.width * 1.5;
            let wy2 = y + viewSize.height * 1.5;

            let [cxlt, cylt] = this.map.world2cell(wx1, wy1);
            let [cxrb, cyrb] = this.map.world2cell(wx2, wy2);
            let [cxrt, cyrt] = this.map.world2cell(wx2, wy1);
            let [cxlb, cylb] = this.map.world2cell(wx1, wy2);

            let info = this.map.getInfo();
            let minX = Math.max(0, Math.min(cxlt, cxrb, cxrt, cxlb));
            let maxX = Math.min(info.rows-1, Math.max(cxlt, cxrb, cxrt, cxlb));
            let minY = Math.max(0, Math.min(cylt, cyrb, cyrt, cylb));
            let maxY = Math.min(info.cols-1, Math.max(cylt, cyrb, cyrt, cylb));

            this.keyCache = [];
            let cells = {};
            for(let i = minX; i <= maxX; i++) {
                for(let j = minY; j <= maxY; j++) {
                    let index = this.map.cell2index(i, j);
                    cells[index] = index;
                    this.keyCache.push(index);
                    let idx = this.map.getData().getResSubIdxByIndex(index);
                    if (!this.cellFiles[idx]) {
                        this.cellFiles[idx] = idx;
                    }
                }
            }

            return cells;
        }
    }
    
}