namespace mo {

    export class Background extends Layer {

        private strategy: Tile;

        public constructor(map: TMap, name: string, layerIdx: number, camera: Camera, data: any) {
            super(map, name, layerIdx, data);

			let viewSize = camera.getViewSize();
		    this.strategy = new Tile(viewSize, data.bgInfo.size, this.node, ()=>{
                let gp = new eui.Group();
                let sp = new eui.Image(data.bgInfo.url);
                gp.addChild(sp);
                gp.alpha = 0.5;
                return gp;
            })
        }

        public dispose() {
            super.dispose();
        }

        public viewportChanged(x: number, y: number, info: any): void {
            this.strategy.update(x, y);
        }
    }
}