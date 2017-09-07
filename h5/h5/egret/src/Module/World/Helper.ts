namespace world {

    export class Helper {

        private manager: Manager;
        private worldMap: mo.TMap;
        private mapLayer: eui.Group;

        public constructor(mgr: Manager, mapLayer: eui.Group) {
            this.manager = mgr;
            this.mapLayer = mapLayer;
            this.worldMap = mgr.getWorldMap();
        }

        // 获取格子中心点
        public getRectCenter(info: any): mo.CPoint {
            let up = info.org;
            let downx = up.x + (info.width || 1) - 1;
            let downy = up.y + (info.height || 1) - 1;
            let [ux, uy] = this.worldMap.cell2world(up.x, up.y);
            let [dx, dy] = this.worldMap.cell2world(downx, downy);

            return {x : ux, y : (uy + dy) / 2};
        }

        public isPointInScene(cpos: mo.CPoint): boolean {
            let [x, y] = this.worldMap.cell2world(cpos.x, cpos.y);
            let scenePos = this.mapLayer.localToGlobal(x, y);

            let sz = this.worldMap.getViewSize();
            let rect = new egret.Rectangle(0, 0, sz.width, sz.height);

            return rect.containsPoint(scenePos);
        }

        public getDisplayInfo(cpos: mo.CPoint): any {
            let [x, y] = this.worldMap.cell2world(cpos.x, cpos.y);
            let cPosCenter = this.worldMap.getCenterCPos();
            let wPosCenter = this.worldMap.getCenterWPos();
            
            if (this.isPointInScene(cpos)) {
                return { show : false, angle : 0, cPosCenter : cPosCenter };
            }

            let disx = x - wPosCenter[0];
            let disy = y - wPosCenter[1];
            let angle = Math.atan2(disy, disx);
            return { show : true, angle : angle, cPosCenter : cPosCenter };
        }

        public getDistance(p1: {x, y}, p2: {x, y}): number {
            return Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
        }
    }

}