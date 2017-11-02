namespace world {

    export class Manager {

        private worldMap: mo.TMap;

        private listener: logic.World;
        private buildMgr: UnitMgr;
        private cityMgr: UnitMgr;
        private blockMgr: UnitMgr;
        private ornamentMgr: UnitMgr;
        private armyMgr: ArmyMgr;
        private phalanxMgr: PhalanxMgr
        private helper: Helper;
        private frameTask: FrameTask;

        private uiLayer: egret.DisplayObjectContainer;
        private buildUILayer: egret.DisplayObjectContainer;
        private mapLayer: eui.Group;

        public constructor(listener: logic.World, worldMap: mo.TMap) {
            this.listener = listener;

            this.worldMap = worldMap;
            this.mapLayer = worldMap.getNode();

            let blockLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(blockLayer);
            blockLayer.width = blockLayer.height = 0;

            let ornamenetLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(ornamenetLayer);
            ornamenetLayer.width = ornamenetLayer.height = 0;

            let cityLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(cityLayer);
            cityLayer.width = cityLayer.height = 0;

            let buildLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(buildLayer);
            buildLayer.width = buildLayer.height = 0;

            this.buildUILayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(this.buildUILayer);
            this.buildUILayer.width = this.buildUILayer.height = 0;

            let armysLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(armysLayer);
            armysLayer.width = armysLayer.height = 0;

            let phalanxLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(phalanxLayer);
            phalanxLayer.width = phalanxLayer.height = 0;

            this.uiLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(this.uiLayer);
            this.mapLayer.setChildIndex(this.uiLayer, 99);
            this.uiLayer.width = this.uiLayer.height = 0;

            this.helper     = new Helper(this, this.mapLayer);
            this.frameTask  = new FrameTask(this, this.mapLayer);
            this.buildMgr   = new UnitMgr(this, buildLayer);
            this.cityMgr  = new UnitMgr(this, cityLayer);
            this.blockMgr  = new UnitMgr(this, blockLayer);
            this.ornamentMgr  = new UnitMgr(this, ornamenetLayer);
            this.armyMgr    = new ArmyMgr(this, armysLayer);
            this.phalanxMgr = new PhalanxMgr(this, phalanxLayer);
        }

        public dispose() {
            this.buildMgr.dispose();
            this.cityMgr.dispose();
            this.blockMgr.dispose();
            this.ornamentMgr.dispose();
            this.armyMgr.dispose();
            this.phalanxMgr.dispose();
        }

        public getListener(): logic.World {
            return this.listener;
        }

        public getWorldMap(): mo.TMap {
            return this.worldMap;
        }

        public getPhalanxMgr(): PhalanxMgr {
            return this.phalanxMgr;
        }
        public getArmyMgr(): ArmyMgr {
            return this.armyMgr;
        }

        public getBuildMgr(): UnitMgr {
            return this.buildMgr;
        }

        public getCityMgr(): UnitMgr {
            return this.cityMgr;
        }

        public getBlockMgr(): UnitMgr {
            return this.blockMgr;
        }

        public getOrnamentMgr(): UnitMgr {
            return this.ornamentMgr;
        }

        public getHelper(): Helper {
            return this.helper;
        }

        public getFrameTask(): FrameTask {
            return this.frameTask;
        }

        public getBuildUILayer(): egret.DisplayObjectContainer {
            return this.buildUILayer;
        }

        public getUILayer(): egret.DisplayObjectContainer {
            return this.uiLayer;
        }

        public getGridData(info: any, cpos: mo.CPoint): any {
            let pos = this.worldMap.cell2world(cpos.x, cpos.y);
            let ret = 
            {
                root : this.uiLayer,
                info : info,
                // pos  : this.helper.getRectCenter(info),
                pos  : {x : pos[0], y : pos[1]},
                grid : cpos,
            }

            return ret;
        }
    }

}