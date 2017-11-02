namespace mo {

    export class Background extends Layer {

        private strategy: Tile;

        public constructor(map: TMap, name: string, layerIdx: number, camera: Camera, data: any) {
            super(map, name, layerIdx, data);

            let viewSize = {width : 1000, height: 2000};
		    this.strategy = new Tile(viewSize, data.bgInfo.size, this.node, ()=>{
                let sp = new eui.Image(data.bgInfo.url);
                return sp;
            })
        }

        public dispose() {
            super.dispose();
        }

        public viewportChanged(x: number, y: number, info?: any): void {
            this.strategy.update(x, y);
        }
    }
}