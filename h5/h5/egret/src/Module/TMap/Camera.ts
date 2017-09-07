namespace mo {

    export class Camera {

        private map: TMap;
        private viewSize: Size;
        private node: eui.Group;
        private lastPos: CPoint;

        public constructor(map: any, viewSize: Size) {
            this.map = map;
            this.viewSize = viewSize;
            this.node = map.getNode();
            this.lastPos = { x : Infinity, y : Infinity, };
        }

        public dispose() {}

        public setPos(x, y): void {            
            [this.node.x, this.node.y] = [-x, -y]
        }

        public getPos(): number[] {
            return [-this.node.x, -this.node.y];
        }

        public getViewSize(): Size {
            return this.viewSize;
        }

        public setViewSize(sz: Size): void {
            this.viewSize = sz;
        }

        public get x(): number {
            return -this.node.x;
        }

        public get y(): number {
            return -this.node.y;
        }

        public set x(v: number){
            this.node.x = -v;
        }

        public set y(v: number){
            this.node.y = -v;
        }

        public update(): boolean {
            let [x, y] = [this.node.x, this.node.y];
            if (x === this.lastPos.x && y === this.lastPos.y) {
                return false;
            }

            this.lastPos.x, this.lastPos.y = x, y;
            return true;
        }
    }

}
