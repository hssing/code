var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var logic;
(function (logic) {
    var World = (function (_super) {
        __extends(World, _super);
        function World() {
            var _this = _super.call(this) || this;
            NetMgr.get(msg.Map).on("m_map_sight_toc", _this.Event("onSightUpdate"));
            NetMgr.get(msg.Map).on("m_map_sight_enter_toc", _this.Event("onSightEnter"));
            NetMgr.get(msg.Map).on("m_map_sight_leave_toc", _this.Event("onSightLeave"));
            NetMgr.get(msg.Map).on("m_map_obj_move_info_toc", _this.Event("onActorMove"));
            _this.armyData = {};
            _this.unitData = {};
            _this.tabletData = {};
            var data = mo.TMap.getMainData().getResult();
            _this.mapSize = { cols: data.info.cols, rows: data.info.rows };
            return _this;
        }
        World.prototype.getViewObjects = function (x, y, z) {
            if (z === void 0) { z = 0; }
            var data = { point: { x: x, y: y, z: z }, width: config.MAP_UPDATE_COLS, height: config.MAP_UPDATE_ROWS };
            NetMgr.get(msg.Map).send("m_map_get_view_obj_tos", data);
        };
        World.prototype.moveArmyToCell = function (armyId, x, y) {
            var buidlId = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyId);
            if (!buidlId) {
                return;
            }
            var data = { build_id: buidlId, army_id: armyId, x: x, y: y };
            NetMgr.get(msg.Build).send("m_build_go_to_battle_tos", data);
        };
        World.prototype.onSightUpdate = function (data) {
            this.updateArmyData(data.army_list);
            this.updateUnitData(data.build_list);
            this.updateTabletData(this.unitData);
            this.fireEvent(World.EVT.SIGHT_UPDATE);
        };
        World.prototype.onSightEnter = function (data) {
            for (var _i = 0, _a = data.army_list; _i < _a.length; _i++) {
                var v = _a[_i];
                this.updateArmy(v);
            }
            this.fireEvent(World.EVT.SIGHT_UPDATE);
        };
        World.prototype.onSightLeave = function (data) {
            for (var _i = 0, _a = data.amy_id; _i < _a.length; _i++) {
                var id = _a[_i];
                this.removeArmy(id);
            }
            this.fireEvent(World.EVT.SIGHT_UPDATE);
        };
        World.prototype.getArmayData = function () {
            return this.armyData;
        };
        World.prototype.getUnitData = function () {
            return this.unitData;
        };
        World.prototype.getTabletData = function () {
            return this.tabletData;
        };
        World.prototype.onActorMove = function (data) {
            var army = this.armyData[data.obj_id];
            if (!army) {
                return;
            }
            army.move_path = data.path;
            army.status = data.status;
            this.fireEvent(World.EVT.ACTOR_MOVE, army);
        };
        World.prototype.removeArmy = function (id) {
            delete this.armyData[id];
        };
        World.prototype.updateArmy = function (data) {
            this.armyData[data.army_id] = data;
        };
        World.prototype.updateArmyData = function (armyData) {
            var data = utils.convert2Object(armyData, function (v) { return v.army_id; });
            this.armyData = utils.mergeObject(data, this.armyData);
            // 回收不在地图视区的数据
            var armys = {};
            for (var k in this.armyData) {
                var v = this.armyData[k];
                var idx = this.makePos(v.cur_point.x, v.cur_point.y);
                if (this.viewCells[idx]) {
                    armys[k] = v;
                }
            }
            this.armyData = armys;
        };
        World.prototype.updateUnitData = function (unitData) {
            var _this = this;
            var data = utils.convert2Object(unitData, function (v) { return _this.makePos(v.x, v.y); });
            data = utils.mergeObject(data, this.unitData);
            this.unitData = utils.intersectObject(data, this.viewCells);
        };
        World.prototype.removeUnit = function (x, y) {
            var xy = this.makePos(x, y);
            delete this.unitData[xy];
        };
        World.prototype.updateTabletData = function (unitData) {
            this.tabletData = {};
            for (var k in unitData) {
                var v = unitData[k];
                if (v.type === 1) {
                    this.tabletData[k] = { x: v.x, y: v.y, type: 0, };
                }
            }
        };
        World.prototype.setViewCells = function (cells) {
            this.viewCells = cells;
        };
        World.prototype.parsePos = function (xy) {
            var x = xy % this.mapSize.cols;
            var y = Math.floor(xy / this.mapSize.cols);
            return { x: x, y: y };
        };
        World.prototype.makePos = function (x, y) {
            return y * this.mapSize.cols + x;
        };
        World.prototype.getUnitDataByPos = function (pos) {
            for (var k in this.unitData) {
                var v = this.unitData[k];
                if (v.x === pos.x && v.y === pos.y) {
                    return v;
                }
            }
            return { x: pos.x, y: pos.y };
        };
        World.prototype.searchCellPos = function (cpos, param) {
            this.fireEvent(World.EVT.SEARCH_POS, cpos, param);
        };
        World.prototype.isDynamicBlocked = function (index) {
            return !!this.unitData[index];
        };
        World.prototype.isBlocked = function (cx, cy) {
            var index = this.makePos(cx, cy);
            var block1 = this.isDynamicBlocked(index);
            return block1 || mo.TMap.getMainData().isBlocked(index, config.MAP_BLOCKED_LAYER_NAME);
        };
        World.prototype.buildUnit = function (cx, cy) {
            var build_id = Math.random();
            this.unitData[build_id] = { x: cx, y: cy, type: 1, build_id: build_id };
        };
        return World;
    }(Logic));
    World.EVT = utils.Enum([
        "ENTER_MAP",
        "SIGHT_UPDATE",
        "SIGHT_LEAVE",
        "SIGHT_ENTER",
        "ACTOR_MOVE",
        "SEARCH_POS",
        "ADD_ARMY",
        "DELETE_ARMY",
    ]);
    logic.World = World;
    __reflect(World.prototype, "logic.World");
})(logic || (logic = {}));
//# sourceMappingURL=World.js.map