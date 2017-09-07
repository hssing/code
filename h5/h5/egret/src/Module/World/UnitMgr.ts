namespace world {

    export class UnitMgr {

        private manager: Manager;
        private worldMap: mo.TMap;
        private root: eui.Group;
        private views: any;
        private data: any;
        // private viewPool = new Map();

        public constructor(mgr: Manager, root) {
            this.manager = mgr;
            this.root = root;
            this.worldMap = this.manager.getWorldMap();

            this.views = {};
            this.data = {};
        }

        public dispose() {
            for (let index in this.views) {
                this.views[index].dispose();
            }
        }

        public recycle(data: any): void {
            for (let k in this.views) {
                if (!data[k]) {
                    this.removeUnit(k);
                }
            }
        }

        public checkHasBuildUnit(info: any): boolean {
            // let p1 = this.manager.getListener().makePos(info.org.x, info.org.y);
    
            for (let k in this.views) {
                let unit = this.views[k];
                let data = unit.getData();
                // let p2 = this.manager.getListener().makePos(data.org.x, data.org.y);
                if (info.x === data.x && info.y === data.y) {
                    return true;
                }
            }
            return false;
        }

        public updateData(data: any): void {
            for (let k in data) {
                this.updateUnit(k, data[k]);
            }
            this.recycle(data);
        }

        private updateUnit(k: string, info: any): void {
            if (this.views[k]) {
                this.views[k].setData(info);
                this.views[k].refresh();
            }else {
                if (!this.checkHasBuildUnit(k) && info) {
                    this.buildUnit(k, info);
                }
            }
        }

        public buildUnit(k: string, info: any): void {
            let nameCls = {
                0 : Tablet,
                1 : Castle,
                2 : Camp,
                3 : Acacdemy,
                4 : Arsenal,
            }

            let cls = nameCls[info.type];
            if (!cls) { return; }

            this.views[k] = new cls(this.manager, this.root, info);
        }

        private removeUnit(k: number|string): void {
            this.views[k].dispose();
            delete this.views[k];
        }
    }

}