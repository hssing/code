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
            if (Math.abs(x - cx) < size.width * 0.2 && Math.abs(y - cy) < size.height * 0.2) {
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
            y += viewSize.height;

            let wx1 = x + viewSize.width * 1.3;
            let wy1 = y - viewSize.height * 1.3;
            let wx2 = x - viewSize.width * 0.3;
            let wy2 = y + viewSize.height * 0.3;

            let [cx1, cy1] = this.map.world2cell(wx1, wy1);
            let [cx2, cy2] = this.map.world2cell(wx2, wy2);

            [cy1, cy2] = [cy1 + 0, cy2 + 1];

            let cells = {};
            this.keyCache = [];

            for (let i = 0; i <= (cy2 + cx2) - (cy1 + cx1); i++) {
                let lx = cx1 + Math.floor((i + 1) / 2);
                let ly = cy1 + Math.floor((i + 0) / 2);
                for (let j = 0; j <= (cy2 - cx2) - (cy1 - cx1); j+=2) {
                    let cx = lx - j / 2;
                    let cy = ly + j / 2;
                    let index = this.map.cell2index(cx, cy);
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