namespace mo {

    const TYPE_CLS = {
        tilelayer : TileLayer,
        tileland : TileLand,
        tilegrid : TileGrid,
    };

    export class Layers {

        private map: TMap;
        private dynamicCells: DynamicCells;
        private layers: Array<Layer>;
        private nameLayers: any;
        private background: Background;

        public constructor(map: TMap, camera: Camera, data: any) {
            this.map = map;
            this.dynamicCells = new DynamicCells(map);

            this.layers = [];

            if (data.bgInfo) {
                this.background = new Background(this.map, "background", -1, camera, data);
            }

            let layerIdx = 0;
            for(let name of (data.layers || [])){
                let obj = this.createLayer(camera, name, layerIdx++, data);
                this.layers.push(obj);
            }
        }

        public dispose() {
            for(let layer of this.layers) {
                layer.dispose();
            }
        }

        public viewportChanged(x: number, y: number): void {
            if (this.background) {
                this.background.viewportChanged(x, y);
            }

            this.dynamicCells.update(x, y);
            if (!this.dynamicCells.isNeedUpdate()) { return; }

            let info = {
                cells: this.dynamicCells.getCells(),
                keys : this.dynamicCells.getCellsKey(),
            }
            this.updateLayer(x, y, info);
            this.map.callUpdateCallbackByDefault(this.dynamicCells.getCells());
        }

        private updateLayer(x: number, y: number, info: any): void {
            let files: any = this.dynamicCells.getCellFiles();
            // 短时间内刷新，移除之前的刷新请求
            this.map.cancelNextFrame();
            let update = ()=>this.update(x, y, info);
            this.map.getData().loadAllDataFiles(files, update);
        }

        private update(x: number, y: number, info: any): void {
            let updateNextFrame = ()=> {
                for(let layer of this.layers) {
                    layer.viewportChanged(x, y, info);
                }
            }
            // 短时间内刷新，移除之前的刷新请求
            this.map.callNextFrame(updateNextFrame, this);
        }

        public getLayerNames(): string[] {
            let ret = []
            for(let layer of this.layers) {
                ret.push(layer.getName());
            }
            return ret;
        }

        private createLayer(camera: Camera, name: string, layerIdx: number, data: any): Layer {
            let type = this.map.getData().getLayerType(layerIdx);
            let cls = TYPE_CLS[type];
            if (cls === undefined || cls === null){ return undefined; }
            return new cls(this.map, name, layerIdx, camera, data, this.dynamicCells);
        }
    }
    
}
