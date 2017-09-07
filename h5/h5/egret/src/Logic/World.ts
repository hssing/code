namespace logic {

    export class World extends Logic {

        public static EVT = utils.Enum(
        [
            "ENTER_MAP",
            "SIGHT_UPDATE",
            "SIGHT_LEAVE",
            "SIGHT_ENTER",
            "ACTOR_MOVE",
            "SEARCH_POS",
            "ADD_ARMY",
            "DELETE_ARMY",
        ]);

        private armyData: any;
        private unitData: any;
        private tabletData: any
        private viewCells: any;
        private mapSize: {cols, rows};

        public constructor() {
            super();

            NetMgr.get(msg.Map).on("m_map_sight_toc", this.Event("onSightUpdate"));
            NetMgr.get(msg.Map).on("m_map_sight_enter_toc", this.Event("onSightEnter"));
            NetMgr.get(msg.Map).on("m_map_sight_leave_toc", this.Event("onSightLeave"));
            NetMgr.get(msg.Map).on("m_map_obj_move_info_toc", this.Event("onActorMove"));

            this.armyData = {};
            this.unitData = {};
            this.tabletData = {};

            let data = mo.TMap.getMainData().getResult();
            this.mapSize = {cols : data.info.cols, rows : data.info.rows};
        }

        public getViewObjects(x: number, y: number, z: number = 0): void {
            let data = {point: {x, y, z}, width : config.MAP_UPDATE_COLS, height : config.MAP_UPDATE_ROWS};
            NetMgr.get(msg.Map).send("m_map_get_view_obj_tos", data);
        }

        public moveArmyToCell(armyId: number, x: number, y: number): void {
            let buidlId = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyId);
            if (!buidlId) { return; }
            let data = {build_id : buidlId, army_id : armyId, x : x, y : y};
            NetMgr.get(msg.Build).send("m_build_go_to_battle_tos", data);
        }

        private onSightUpdate(data: any): void {
            this.updateArmyData(data.army_list);
            this.updateUnitData(data.build_list);
            this.updateTabletData(this.unitData);
            this.fireEvent(World.EVT.SIGHT_UPDATE);
        }

        private onSightEnter(data: any): void {
            for (let v of data.army_list) {
                this.updateArmy(v);
            }

            this.fireEvent(World.EVT.SIGHT_UPDATE);
        }

        private onSightLeave(data: any): void {
            for (let id of data.amy_id) {
                this.removeArmy(id);
            }

            this.fireEvent(World.EVT.SIGHT_UPDATE);
        }

        public getArmayData(): any {
            return this.armyData;
        }

        public getUnitData(): any {
            return this.unitData;
        }

        public getTabletData(): any {
            return this.tabletData;
        }

        private onActorMove(data: any): void {
            let army = this.armyData[data.obj_id];
            if (!army) { return; }
            army.move_path = data.path;
            army.status = data.status;
            this.fireEvent(World.EVT.ACTOR_MOVE, army);
        }

        public removeArmy(id: string): void {
            delete this.armyData[id];
        }

        private updateArmy(data: any): void {
            this.armyData[data.army_id] = data;
        }

        private updateArmyData(armyData: any): void {
            let data = utils.convert2Object(armyData, v => v.army_id);
            this.armyData = utils.mergeObject(data, this.armyData);

            // 回收不在地图视区的数据
            let armys = {};
            for (let k in this.armyData) {
                let v = this.armyData[k];
                let idx = this.makePos(v.cur_point.x, v.cur_point.y);
                if (this.viewCells[idx]) {
                    armys[k] = v;
                }
            }
            this.armyData = armys;
        }

        private updateUnitData(unitData: any): void {
            let data = utils.convert2Object(unitData, v => this.makePos(v.x, v.y));
            data = utils.mergeObject(data, this.unitData);
            this.unitData = utils.intersectObject(data, this.viewCells);
        }

        public removeUnit(x: number, y: number): void {
            let xy = this.makePos(x, y);
            delete this.unitData[xy];
        }

        private updateTabletData(unitData) {
            this.tabletData = {};
            for (let k in unitData) {
                let v = unitData[k];
                if (v.type === 1) {
                    this.tabletData[k] = { x : v.x, y : v.y, type : 0, };
                }
            }
        }

        public setViewCells(cells): void {
            this.viewCells = cells;
        }

        public parsePos(xy: number): mo.CPoint {
            let x = xy % this.mapSize.cols;
            let y = Math.floor(xy / this.mapSize.cols);
            return {x, y};
        }

        public makePos(x: number, y: number): number {
            return y * this.mapSize.cols + x;
        }

        public getUnitDataByPos(pos: mo.CPoint): any {
            for (let k in this.unitData) {
                let v = this.unitData[k];
                if (v.x === pos.x && v.y === pos.y) {
                    return v;
                }
            }

            return {x : pos.x, y : pos.y};
        }

        public searchCellPos(cpos: mo.CPoint, param: any): void {
            this.fireEvent(World.EVT.SEARCH_POS, cpos, param);
        }

        public isDynamicBlocked(index: number): boolean {
            return !!this.unitData[index];
        }

        public isBlocked(cx: number, cy: number): boolean {
            let index = this.makePos(cx, cy);
            let block1 = this.isDynamicBlocked(index);
            return block1 || mo.TMap.getMainData().isBlocked(index, config.MAP_BLOCKED_LAYER_NAME);
        }

        public buildUnit(cx: number, cy: number): void {
            let build_id = Math.random();
            this.unitData[build_id] = {x : cx, y : cy, type : 1, build_id : build_id};
        }


    }

}