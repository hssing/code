namespace mo {

    export class TMap {

        private data: any;
        private rootNode: eui.Group;
        private coordinate: Coordinate;
        private camera: Camera;
        private layers: Layers;
        private dataSource: Data;
        private tapCallback: (wordPos: egret.Point) => void;
        private updateCallback: any;
        private timer: egret.Timer;

        public constructor(mapData: Data, viewSize: Size) {
            this.dataSource = mapData;
            this.data = mapData.getResult();

            this.rootNode = new eui.Group();
            this.rootNode.width = this.data.info.w;
            this.rootNode.height = this.data.info.h;
            this.rootNode.addEventListener(egret.Event.ENTER_FRAME,this.update, this);

            this.coordinate = new Coordinate(this.data.info);
            this.camera = new Camera(this, viewSize);
            this.layers = new Layers(this, this.camera, this.data);
        }

        public dispose() {
            this.rootNode.removeEventListener(egret.Event.ENTER_FRAME,this.update, this);
            this.layers.dispose();
            this.camera.dispose();
            this.layers = null;
            this.camera = null;
            this.updateCallback = null;
            this.tapCallback = null;
        }

        public world2cell(x: number, y: number): number[] {
            return this.coordinate.world2cell(x, y);
        }

        public cell2world(cx: number, cy: number): number[] {
            return this.coordinate.cell2world(cx, cy);
        }

        public cell2index(x: number, y: number): number {
            return this.coordinate.cell2index(x, y);
        }

        public index2cell(index: number): number[] {
            return this.coordinate.index2cell(index);
        }

        public get x(): number {
            return this.camera.x;
        }

        public get y(): number {
            return this.camera.y;
        }

        public set x(v: number){
            this.camera.x = v;
        }

        public set y(v: number){
            this.camera.y = v;
        }

        public get width(): number {
            return this.rootNode.width;
        }

        public get height(): number {
            return this.rootNode.height;
        }

        // data: {tilewidth, tileheight, width, height,} 格子宽高， 地图行列
        public static createCoordinate(data: any): Coordinate {
            let offset = {
                x : data.tilewidth / 2 * ((data.width + 1) % 2), // 偶数偏移半个格子
                y : 0,
            };

            let info = {
                rows    : data.height,
                cols    : data.width,
                ox      : offset.x + data.tilewidth * data.width / 2 + (data.ox || 0),
                oy      : offset.y + data.tileheight / 2 + (data.oy || 0),
                cw      : data.tilewidth,
                ch      : data.tileheight,
                w       : data.width * data.tilewidth,
                h       : data.height * data.tileheight,
            };
            return new Coordinate(info); 
        }

        // data: {matrix, ox, oy} 格子相对当前地图百分比， 地图行列
        public createCoordinate(matrix: number, ox: number = 0, oy: number = 0): Coordinate {
            let data: any = {};
            matrix = Math.floor(matrix);
            data.tilewidth = this.data.info.cw / matrix;
            data.tileheight = this.data.info.ch / matrix;
            data.height = data.width = matrix;
            data.ox = ox;
            data.oy = oy;
            return TMap.createCoordinate(data); 
        }

        public getNode(): eui.Group {
            return this.rootNode;
        }

        public setViewSize(sz: Size): void {
            this.camera.setViewSize(sz);
        }

        public getViewSize(): Size {
            return this.camera.getViewSize();
        }

        public setPos(x: number, y: number): void {
            this.camera.setPos(x, y);
        }

        public getPos(): number[] {
            return this.camera.getPos();
        }

        public getCenterCPos(): number[] {
            let wp = this.getCenterWPos();
            return this.world2cell(wp[0], wp[1]);
        }

        public getCenterWPos(): number[] {
            let sz = this.camera.getViewSize();
            let wp = this.camera.getPos();
            wp = [wp[0] + sz.width / 2, wp[1] + sz.height / 2];
            return wp;
        }

        public update(): void {
            if (this.camera.update()) {
                let [x, y] = this.camera.getPos();
                this.layers.viewportChanged(x, y);
            }
        }

        public getInfo(): any {
            return this.data.info;
        }

        public getData(): Data {
            return this.dataSource;
        }

        // callback 使用 => 函数
        public registTapCallback(c): void {
            this.tapCallback = c;
        }

        // callback 使用 => 函数
        public registUpdateCallback(c: Function, layerName: string = "default"): void {
            this.updateCallback = this.updateCallback || {}
            this.updateCallback[layerName] = c;
        }

        public callUpdateCallback(cells: any, layerName: string): void {
            if (!this.updateCallback || !this.updateCallback[layerName]) {
                return;
            }
            this.updateCallback[layerName](cells);
        }

        public callUpdateCallbackByDefault(cells: any): void {
            this.callUpdateCallback(cells, "default");
        }

        public touchTap(event: egret.TouchEvent): any {
            if (!this.tapCallback) { return; }
            let wpos = this.rootNode.globalToLocal(event.stageX, event.stageY);
            this.tapCallback(wpos);
        }

        public static getMainData(): mo.Data {
            return Singleton(Data, config.MAP_URLS[0]);
        }

        public callNextFrame(func: Function, thisObject: Object): void {
            this.canelNextFrame();
            this.timer = utils.after(0, func, thisObject);
        }

        public canelNextFrame(): void {
            if (!this.timer) { return; }
            this.timer.stop();
            this.timer = null;
        }
    }

}