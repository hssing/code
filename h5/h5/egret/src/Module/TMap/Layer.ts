namespace mo {

    export class Layer {

        protected node: eui.Group;
        protected map: TMap;
        protected data: any;
        protected dataSource: Data;
        private name: string;
        protected layerIdx: number;

        public constructor(map: TMap, name: string, layerIdx: number, data: any) {
            this.map = map;
            this.name = name;
            this.layerIdx = layerIdx;
            this.data = data;
            this.dataSource = map.getData();

            let parent = map.getNode();

            this.node = new eui.Group();
            this.node.width = parent.width;
            this.node.height = parent.height;
            parent.addChild(this.node);
            this.node.name = this.name;
        }

        public dispose() {
        }

        public viewportChanged(x: number, y: number, info: any): void {
        }

        public getName(): string {
            return this.name;
        }
    }
}