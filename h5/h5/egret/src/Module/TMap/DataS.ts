namespace mo {
    
    export class DataS extends Data {

        public getResSubIdxByIndex(index: number): number {
            return index;
        }

        public getCellDataBySubIdx(idx: number): any {
            return this.data.layers;
        }

        public getCellTile(index: number, layerIdx: number): any {
            let cellsData = this.getCellDataByIndex(index);
            if (!cellsData || !cellsData[layerIdx]) { return undefined; }
            let tileId = cellsData[layerIdx].data[index];
            if (!tileId || tileId === 0) { return undefined; }

            return this.tilesets.tiles[tileId];
        }

        public loadAllDataFiles(files: any, update): void {
            update();
        }
    }
    
}
