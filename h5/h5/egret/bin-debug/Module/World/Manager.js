var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var world;
(function (world) {
    var Manager = (function () {
        function Manager(listener, worldMap) {
            this.listener = listener;
            this.worldMap = worldMap;
            this.mapLayer = worldMap.getNode();
            var tabletLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(tabletLayer);
            tabletLayer.width = tabletLayer.height = 0;
            var buildLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(buildLayer);
            buildLayer.width = buildLayer.height = 0;
            var armysLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(armysLayer);
            armysLayer.width = armysLayer.height = 0;
            this.uiLayer = new egret.DisplayObjectContainer();
            this.mapLayer.addChild(this.uiLayer);
            this.mapLayer.setChildIndex(this.uiLayer, 99);
            this.uiLayer.width = this.uiLayer.height = 0;
            this.helper = new world.Helper(this, this.mapLayer);
            this.frameTask = new world.FrameTask(this, this.mapLayer);
            this.buildMgr = new world.UnitMgr(this, buildLayer);
            this.tabletMgr = new world.UnitMgr(this, tabletLayer);
            this.armyMgr = new world.ArmyMgr(this, armysLayer);
        }
        Manager.prototype.dispose = function () {
            this.buildMgr.dispose();
            this.tabletMgr.dispose();
            this.armyMgr.dispose();
        };
        Manager.prototype.getListener = function () {
            return this.listener;
        };
        Manager.prototype.getWorldMap = function () {
            return this.worldMap;
        };
        Manager.prototype.getArmyMgr = function () {
            return this.armyMgr;
        };
        Manager.prototype.getBuildMgr = function () {
            return this.buildMgr;
        };
        Manager.prototype.getTabletMgr = function () {
            return this.tabletMgr;
        };
        Manager.prototype.getHelper = function () {
            return this.helper;
        };
        Manager.prototype.getFrameTask = function () {
            return this.frameTask;
        };
        Manager.prototype.getUILayer = function () {
            return this.uiLayer;
        };
        Manager.prototype.getGridData = function (info, cpos) {
            var pos = this.worldMap.cell2world(cpos.x, cpos.y);
            var ret = {
                root: this.uiLayer,
                info: info,
                // pos  : this.helper.getRectCenter(info),
                pos: { x: pos[0], y: pos[1] },
                grid: cpos,
            };
            return ret;
        };
        return Manager;
    }());
    world.Manager = Manager;
    __reflect(Manager.prototype, "world.Manager");
})(world || (world = {}));
//# sourceMappingURL=Manager.js.map