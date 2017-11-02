namespace mo {

    export class Layer {

        protected node: egret.DisplayObjectContainer;
        protected map: TMap;
        protected data: any;
        protected dataSource: Data;
        private name: string;
        protected layerIdx: number;
        protected isUpdate: boolean;

        public constructor(map: TMap, name: string, layerIdx: number, data: any) {
            this.map = map;
            this.name = name;
            this.layerIdx = layerIdx;
            this.data = data;
            this.dataSource = map.getData();

            this.isUpdate = (name !== config.MAP_BLOCKED_LAYER_NAME);
            if (!this.isUpdate) { return; }

            let parent = map.getNode();
            this.node = new egret.DisplayObjectContainer();
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