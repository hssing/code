
namespace world {

    export class Manager {
        private worldMap;

        private listener: logic.World;
        private buildMgr: UnitMgr;
        private tabletMgr: UnitMgr;
        private armyMgr: ArmyMgr;
        private helper: Helper;
        private frameTask: FrameTask;

        private uiLayer: egret.DisplayObjectContainer;
        private mapLayer: eui.Group;

        public constructor(listener: logic.World, worldMap: mo.TMap) {
            this.listener = listener;

            this.worldMap = worldMap;
            this.mapLayer = worldMap.getNode();

            let tabletLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(tabletLayer);
            tabletLayer.width = tabletLayer.height = 0;

            let buildLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(buildLayer);
            buildLayer.width = buildLayer.height = 0;

            let armysLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(armysLayer);
            armysLayer.width = armysLayer.height = 0;

            this.uiLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(this.uiLayer);
            this.mapLayer.setChildIndex(this.uiLayer, 99);
            this.uiLayer.width = this.uiLayer.height = 0;

            this.helper   = new Helper(this, this.mapLayer);
            this.frameTask = new FrameTask(this, this.mapLayer);
            this.buildMgr  = new UnitMgr(this, buildLayer);
            this.tabletMgr  = new UnitMgr(this, tabletLayer);
            this.armyMgr  = new ArmyMgr(this, armysLayer);
        }

        public dispose() {
            this.buildMgr.dispose();
            this.tabletMgr.dispose();
            this.armyMgr.dispose();
        }

        public getListener(): logic.World {
            return this.listener;
        }

        public getWorldMap(): mo.TMap {
            return this.worldMap;
        }

        public getArmyMgr(): ArmyMgr {
            return this.armyMgr;
        }

        public getBuildMgr(): UnitMgr {
            return this.buildMgr;
        }

        public getTabletMgr(): UnitMgr {
            return this.tabletMgr;
        }

        public getHelper(): Helper {
            return this.helper;
        }

        public getFrameTask(): FrameTask {
            return this.frameTask;
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