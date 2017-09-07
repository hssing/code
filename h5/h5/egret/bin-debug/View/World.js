var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui) {
    var defaultLoader = function (thisObject, data) {
        var w = new ui.ActionMenu(thisObject, data);
        _a = [data.pos.x, data.pos.y], w.x = _a[0], w.y = _a[1];
        data.root.addChild(w);
        return w;
        var _a;
    };
    var MenuConditionMap = [
        {
            condition: function (cellInfo) { return LogicMgr.get(logic.Build).isBuildMenu(cellInfo); },
            loader: function (thisObject, data) { return UIMgr.openOnce(ui.BuildMenu, void 0, thisObject, data); },
        },
        {
            condition: function (cellInfo) { return true; },
            loader: defaultLoader,
        }
    ];
    var World = (function (_super) {
        __extends(World, _super);
        function World() {
            return _super.call(this, World.CUSTOM) || this;
        }
        World.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            LogicMgr.get(logic.World).on(logic.World.EVT.ENTER_MAP, this.Event("onEnterMap"));
            LogicMgr.get(logic.World).on(logic.World.EVT.SIGHT_UPDATE, this.Event("onSightUdpate"));
            LogicMgr.get(logic.World).on(logic.World.EVT.ACTOR_MOVE, this.Event("onActorMove"));
            this.createMap(config.MAP_URLS);
            this.manager = new world.Manager(LogicMgr.get(logic.World), this.map);
            this.onReSize();
            var tx = RES.getRes("frame_jianzuxuanzhong_s1_png");
            this.selectedNode = new eui.Image(tx);
            this.selectedNode.touchEnabled = false;
            this.selectedNode.alpha = 0.3;
            this.map.getNode().addChild(this.selectedNode);
            this.selectedNode.anchorOffsetX = tx.bitmapData.width / 2;
            this.selectedNode.anchorOffsetY = tx.bitmapData.height / 2;
            this.onGpRest2MainCell();
        };
        World.prototype.onExit = function () {
            _super.prototype.onExit.call(this);
            this.map = null;
            this.mapContainer.dispose();
            this.mapContainer = null;
        };
        World.prototype.createMap = function (files) {
            var _this = this;
            this.mapContainer = new MapScroller();
            this.mapContainer.buildMap(files[0], files.slice(1), this.gpMap);
            this.map = this.mapContainer.getMap();
            this.map.registTapCallback(function (wpos) { return _this.onTagCell(wpos); });
            this.map.registUpdateCallback(function (cells) { return _this.onUpdateCells(cells); });
            this.mapContainer.registScrollCallback(function () { return _this.updateDisplayLabel(); });
        };
        World.prototype.onActorMove = function (armyData) {
            this.manager.getArmyMgr().updatePath(armyData);
        };
        World.prototype.onSightUdpate = function () {
            var world = LogicMgr.get(logic.World);
            this.manager.getArmyMgr().updateData(world.getArmayData());
            this.manager.getBuildMgr().updateData(world.getUnitData());
            this.manager.getTabletMgr().updateData(world.getTabletData());
        };
        World.prototype.onTagCell = function (worldPos) {
            var _a = this.map.world2cell(worldPos.x, worldPos.y), x = _a[0], y = _a[1];
            this.onSearchCellPos({ x: x, y: y });
            this.updateSelectedNode(worldPos);
        };
        World.prototype.updateSelectedNode = function (worldPos) {
            var cpos = this.map.world2cell(worldPos.x, worldPos.y);
            var wpos = this.map.cell2world(cpos[0], cpos[1]);
            this.selectedNode.x = wpos[0], this.selectedNode.y = wpos[1];
        };
        World.prototype.moveToCell = function (x, y, z) {
            if (z === void 0) { z = 0; }
            var data = { target_point: { x: x, y: y, z: z } };
            NetMgr.get(msg.Map).send("m_map_get_view_obj_tos", data);
        };
        World.prototype.onUpdateCells = function (indexCells) {
            var cpos = this.map.getCenterCPos();
            LogicMgr.get(logic.World).getViewObjects(cpos[0], cpos[1]);
            LogicMgr.get(logic.World).setViewCells(indexCells);
            this.updateDisplayLabel();
        };
        World.prototype.onSearchCellPos = function (cpos, param) {
            var unit = LogicMgr.get(logic.World).getUnitDataByPos(cpos);
            if (!unit) {
                return;
            }
            var data = this.manager.getGridData(unit, cpos);
            this.onClickMap(data, param);
        };
        World.prototype.onClickMap = function (data, param) {
            this.closeItem();
            var node = data.root;
            var info = data.info;
            var pos = data.pos;
            data.param = param;
            for (var _i = 0, MenuConditionMap_1 = MenuConditionMap; _i < MenuConditionMap_1.length; _i++) {
                var v = MenuConditionMap_1[_i];
                if (v.condition(data)) {
                    this.worldItem = v.loader(this, data);
                    return;
                }
            }
        };
        World.prototype.closeItem = function () {
            if (this.worldItem) {
                this.closeWorldItem();
                return true;
            }
            return false;
        };
        World.prototype.closeWorldItem = function () {
            if (!this.worldItem) {
                return;
            }
            if (this.worldItem.parent) {
                this.worldItem.parent.removeChild(this.worldItem);
            }
            this.worldItem = null;
        };
        World.prototype.getMap = function () {
            return this.map;
        };
        World.prototype.getMapContainer = function () {
            return this.mapContainer;
        };
        World.prototype.onReSize = function () {
            _super.prototype.onReSize.call(this);
            this.mapContainer.setViewSize({ width: this.width, height: this.height });
        };
        World.prototype.onGpRest2MainCell = function () {
            var cpos = LogicMgr.get(logic.Build).getMainBuildPos();
            this.mapContainer.setCell2Center(cpos.x, cpos.y);
        };
        World.prototype.updateDisplayLabel = function () {
            var cpos = LogicMgr.get(logic.Build).getMainBuildPos();
            var info = this.manager.getHelper().getDisplayInfo(cpos);
            this.gpDis.visible = info.show;
            if (!info.show) {
                return;
            }
            var dis = this.manager.getHelper().getDistance(cpos, { x: info.cPosCenter[0], y: info.cPosCenter[1] });
            var degreeAngle = Math.round(info.angle / Math.PI * 180);
            this.gpDis.rotation = degreeAngle;
            dis = Math.floor(dis);
            this.lbDis.text = dis + "\u516C\u91CC";
            this.lbDis.rotation = ((degreeAngle < 90 && degreeAngle > -90) ? 0 : 180);
            var pos = this.updateDistancePos(degreeAngle);
            _a = [pos.x, pos.y], this.gpDis.x = _a[0], this.gpDis.y = _a[1];
            var _a;
        };
        World.prototype.updateDistancePos = function (degreeAngle) {
            var maxX = Math.round(this.width - this.gpDis.width / 2);
            var minX = Math.round(this.gpDis.width / 2);
            var maxY = Math.round(this.height - this.gpDis.width / 2);
            var minY = Math.round(this.gpDis.width / 2);
            var realHeight = maxY - minY;
            var realWidth = maxX - minX;
            var currentPos = { x: 0, y: 0 };
            if (degreeAngle <= 45 && degreeAngle >= -45) {
                currentPos.x = maxX;
                currentPos.y = maxY - (45 - degreeAngle) * realHeight / 90;
            }
            else if (degreeAngle <= 135 && degreeAngle > 45) {
                currentPos.x = (135 - degreeAngle) * realWidth / 90 + minX;
                currentPos.y = maxY;
            }
            else if (degreeAngle < -45 && degreeAngle >= -135) {
                currentPos.x = (135 + degreeAngle) * realWidth / 90 + minX;
                currentPos.y = minY;
            }
            else if (degreeAngle < -135 && degreeAngle >= -180) {
                currentPos.x = minX;
                currentPos.y = maxY - (225 + degreeAngle) * realHeight / 90;
            }
            else if (degreeAngle <= 180 && degreeAngle > 135) {
                currentPos.x = minX;
                currentPos.y = maxY - (degreeAngle - 135) * realHeight / 90;
            }
            return currentPos;
        };
        return World;
    }(UIBase));
    World.CUSTOM = {
        skinName: "resource/ui/WorldUISkin.exml",
        binding: (_a = {},
            _a["gpDis"] = { method: "onGpRest2MainCell", },
            _a),
    };
    ui.World = World;
    __reflect(World.prototype, "ui.World");
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=World.js.map