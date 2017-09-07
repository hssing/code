namespace mo {

    const NAME_CLS: any = {
        ground : TileLayer,
        background : Background,
    };

    export class Layers {

        private map: TMap;
        private dynamicCells: DynamicCells;
        private layers: Array<Layer>;
        private nameLayers: any;

        public constructor(map: TMap, camera: Camera, data: any) {
            this.map = map;
            this.dynamicCells = new DynamicCells(map);

            this.layers = [];
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
            this.map.canelNextFrame();
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
            let cls = NAME_CLS[name] || TileLayer;
            if (cls === undefined || cls === null){ return undefined; }
            return new cls(this.map, name, layerIdx, camera, data, this.dynamicCells);
        }
    }
    
}
