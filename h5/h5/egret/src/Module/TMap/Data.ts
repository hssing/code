namespace mo {
    
    export class Data {

        private data: any;
        private cellsData: any;
        private info: any;
        private coordinate: Coordinate;
        private tilesets: any;
        private islands: any;
        private layers: any;
        private cellDatas: any;
        private loadingList: any;

        public constructor(file: string) {
            this.data = RES.getRes(file);
            this.info = this.getInfo();
            this.cellDatas = {};
            this.loadingList = {};
            this.coordinate = new Coordinate(this.info);

            this.loadTilesets();
            this.loadLayers();
        }

        public getResult(): any {
            return {
                info        : this.info,
                layers      : this.layers,
                tilesets    : this.tilesets,
                bgInfo      : { url : "resource/assets/Map/zwsy.png", size : {w : 256, h : 256}, },
            };
        }

        private getInfo(): any {
            let offset = {
                x : this.data.tilewidth / 2 * ((this.data.width + 1) % 2), // 偶数偏移半个格子
                y : 0,
            };

            let info = {
                offset  : offset,
                rows    : this.data.height,
                cols    : this.data.width,
                ox      : offset.x + this.data.tilewidth * this.data.width / 2,
                oy      : offset.y + this.data.tileheight / 2,
                cw      : this.data.tilewidth,
                ch      : this.data.tileheight,
                w       : this.data.width * this.data.tilewidth,
                h       : this.data.height * this.data.tileheight,
            };
            return info; 
        }

        private getTile(tileset: any, index: number, x: number, y: number, origin: any): any {
            let tileoffset = tileset.tileoffset || {};
            let offsetX = tileoffset.x || 0;
            let offsetY = tileoffset.y || 0;
            let spacing = tileset.spacing || 0;

            let rect = {
                x : origin.x + (tileset.tilewidth + tileset.spacing) * x,
                y : origin.y + (tileset.tileheight + tileset.spacing)* y,
                width :  tileset.tilewidth,
                height : tileset.tileheight,
            };

            let tile = {
                image : tileset.image,
                rect : rect,
                offsetX : offsetX,
                offsetY : offsetY,
            };

            return tile;
        }
        
        private loadTilesets(): void {
            let tilesets = { offsets : {}, tiles : {}, };

            for (let tileset of this.data.tilesets){
                let [imagewidth, imageheight] = [tileset.imagewidth, tileset.imageheight];

                // if (tileset.tiles) { //出现了这种结构，临时提取出来处理
                //     tileset.image = tileset.tiles[0].image;
                //     imagewidth = tileset.tiles[0].imagewidth;
                //     imagewidth = tileset.tiles[0].imageheight;
                // }

                let origin = {x : 0, y : 0};
                if (tileset.margin) {
                    [imagewidth, imageheight] = [imagewidth - tileset.margin * 2, imageheight - tileset.margin * 2];
                    origin.x += tileset.margin;
                    origin.y += tileset.margin;
                }

                let cols = tileset.columns || 1;
                let rows = Math.ceil(tileset.tilecount / cols);

                for (let i = 0; i < rows; i++) {
                    for (let j = 0; j < cols; j++) {
                        let index = cols * i + j;
                        if (index >= tileset.tilecount) { continue; }
                        let id = tileset.firstgid + index;
                        tilesets.tiles[id] = this.getTile(tileset, index, j, i, origin);
                    }
                }
            }

            this.tilesets = tilesets;
        }

        public getResSubIdxByIndex(index: number): number {
            // let i = Math.floor(index / this.data.clipRange);
            let [x, y] = this.coordinate.index2cell(index);
            let x1 = Math.floor(x / this.data.clipRange);
            let y1 = Math.floor(y / this.data.clipRange);
            let cols = Math.ceil(this.data.width/this.data.clipRange);
            let i = this.coordinate.cell2index(x1, y1, cols);
            i = Math.min(this.data.subFiles.length - 1, i);
            i = Math.max(0, i);
            return i;
        }

        public getResFullPath(file: string): string {
            return `${config.MAP_CONFIG}${file}`;
        }

        public getResFullPathBySubIdx(idx: number): any {
            let f = this.data.subFiles[idx];
            if (f === "") { return null; }
            return this.getResFullPath(f);
        }

        public setCellDataBySubIdx(idx: number, value: any): void {
            this.cellDatas[idx] = value;
        }

        public getCellDataBySubIdx(idx: number): any {
            return this.cellDatas[idx];
        }

        public getCellDataByIndex(index: number): any {
            let idx = this.getResSubIdxByIndex(index);
            return this.getCellDataBySubIdx(idx);
        }

        public loadAllDataFiles(files: any, update): void {
            let keys = Object.keys(files);
            let promises = keys.map((idx) => {
                return this.loadDataFile(parseInt(idx));
            });

            Promise.all(promises).then(update, update); // 资源请求出错也进行刷新（有可能是部分出错）
        }

        // 重复资源只加载一次
        public loadDataFile(idx: number): Promise<any> {
            return new Promise((resolve) => {
                let dt = this.cellDatas[idx];
                if (dt) { return resolve(dt); }

                let loaded = (data) => {
                    this.setCellDataBySubIdx(idx, data);
                    resolve(data);
                }

                this.loadingList[idx] = this.loadingList[idx] || [];
                let isLoading = this.loadingList[idx].length > 0;
                this.loadingList[idx].push(loaded);
                if (isLoading) { return; }

                let file = this.getResFullPathBySubIdx(idx);
                RES.getResByUrl(file, (data) => {
                    for (let func of this.loadingList[idx]) {
                        func(data);
                    }
                    this.loadingList[idx] = [];
                }, this, "json");
            } );
        }

        public getCellTileByName(cpos: CPoint, layerName: string): any {
            let index = this.coordinate.cell2index(cpos.x, cpos.y);
            let idx = this.layers.indexOf(layerName);
            if (idx < 0) { return undefined; }
            return this.getCellTile(index, idx);
        }

        public getCellTile(index: number, layerIdx: number): any {
            let cellsData = this.getCellDataByIndex(index);
            if (!cellsData || !cellsData[layerIdx]) { return undefined; }
            let tileId = cellsData[layerIdx][index];
            if (!tileId || tileId === 0) { return undefined; }

            return this.tilesets.tiles[tileId];
        }

        private loadLayers(): void {
            this.layers = [];
            // this.layers.push("background");

            for (let layer of this.data.layers) {
                let name = layer["name"];
                this.layers.push(name);
            }
        }

        // 阻挡数据单独分离出一个文件
        public isBlocked(index, name: string): boolean {
            // for (let layer of this.data.layers) {
            //     if (name === layer["name"]) {
            //         return !!layer.data[index];
            //     }
            // }
            return false;
        }
    }
    
}
