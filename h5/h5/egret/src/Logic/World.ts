namespace logic {

    type TOWNER_INFO = msg.m_map_sight_toc["city_list"][0]["ower_info"];

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
            "LOCATION",
            "TO_PHALANX",
            "TO_ARMY",
        ]);

        private armyData: any;
        private unitData: any;
        private cityData: any;
        private blockData: any;
        private ornamentData: any;
        private phalanxData: any;
        private viewCells: any;
        private mapSize: {cols, rows};
        private fightData:any;

        public constructor() {
            super();

            NetMgr.get(msg.Map).on("m_map_sight_toc", this.Event("onSightUpdate"));
            NetMgr.get(msg.Map).on("m_map_sight_enter_toc", this.Event("onSightEnter"));
            NetMgr.get(msg.Map).on("m_map_sight_leave_toc", this.Event("onSightLeave"));
            NetMgr.get(msg.Map).on("m_map_obj_move_info_toc", this.Event("onActorMove"));
            NetMgr.get(msg.Map).on("m_map_separate_to_phalanx_toc", this.Event("onToPhalanx"));
            NetMgr.get(msg.Map).on("m_map_phalanx_gather_to_army_toc", this.Event("onToArmy"));
            NetMgr.get(msg.Fight).on("m_fight_report_toc", this.Event("onFight"));

            this.armyData = {};
            this.unitData = {};
            this.phalanxData = {};
            this.cityData = {};
            this.blockData = {};
            this.ornamentData = {};

            let data = mo.TMap.getMainData().getResult();
            this.mapSize = {cols : data.info.cols, rows : data.info.rows};
        }

        public updateSight(): void {
            this.fireEvent(World.EVT.SIGHT_UPDATE);
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

        protected onFight(data: msg.m_fight_report_toc){
            this.fightData = data;
        }

        private onSightUpdate(data: msg.m_map_sight_toc): void {
            this.armyData = this.updateIdValueData(this.armyData, data.army_list, "army_id");
            this.phalanxData = this.updateIdValueData(this.phalanxData, data.phalanx_list, "id");
            this.updateUnitData(data.build_list);
            this.updateOrnamentData(data.ornament_list);

            for (let v of data.city_list) {
                let citys = this.createCitys(v);
                citys = utils.mergeObject(citys, this.cityData);
                this.cityData = utils.intersectObject(citys, this.viewCells);
            }

            for (let v of data.block_list) {
                let blocks = this.createBlocks(v);
                blocks = utils.mergeObject(blocks, this.blockData);
                this.blockData = utils.intersectObject(blocks, this.viewCells);
            }

            this.fireEvent(World.EVT.SIGHT_UPDATE);
        }

        private onSightEnter(data: msg.m_map_sight_enter_toc): void {
            for (let v of data.army_list) {
                this.armyData[v.army_id] = v;
            }

            for (let v of data.phalanx_list) {
                this.phalanxData[v.id] = v;
            }

            this.updateUnitData(data.build_list);

            for (let v of data.city_list) {
                let citys = this.createCitys(v);
                citys = utils.mergeObject(citys, this.cityData);
                this.cityData = utils.intersectObject(citys, this.viewCells);
            }
            // todo@, block_list
            this.fireEvent(World.EVT.SIGHT_UPDATE);
        }

        private onSightLeave(data: msg.m_map_sight_leave_toc): void {
            for (let id of data.amy_id) {
                delete this.armyData[id];
            }

            for (let id of data.phalanx_id) {
                delete this.phalanxData[id];
            }

            for (let id of data.building_id) {
                this.removeUnitById(id);
            }

            for (let id of data.city_id) {
                this.deleteIdValue(this.cityData, id, "city_id");
            }

            this.fireEvent(World.EVT.SIGHT_UPDATE);
        }

        public getArmayData(): any {
            return this.armyData;
        }

        public getUnitData(): any {
            return this.unitData;
        }

        public getPhalanxData(): any {
            return this.phalanxData;
        }

        public getCityData(): any {
            return this.cityData;
        }

        public getBlockData(): any {
            return this.blockData;
        }

        public getOrnamentData(): any {
            return this.ornamentData;
        }

        public getFightData(): any {
            return this.fightData;
        }

        public getCellOwnerInfo(cx: number, cy: number): TOWNER_INFO {
            let ret: TOWNER_INFO;
            let xy = this.makePos(cx, cy);
            ret = this.cityData[xy] ? this.cityData[xy].org.ower_info : undefined;
            return ret;
        }

        private onActorMove(data: msg.m_map_obj_move_info_toc): void {
            let army = this.updateMovePath(this.armyData, data, data.obj_id);
            if (army) {
                this.fireEvent(World.EVT.ACTOR_MOVE, army, data.obj_id, "army");
            }

            let phalanx = this.updateMovePath(this.phalanxData, data, data.obj_id);
            if (phalanx) {
                this.fireEvent(World.EVT.ACTOR_MOVE, phalanx, data.obj_id, "phalanx");
            }
        }

        private onToPhalanx(data:msg.m_map_separate_to_phalanx_toc): void {
            console.log("部队变换方阵 ==== id = " + data.amy_id);
            //删除部队数据
            delete this.armyData[data.amy_id];

            //加入方阵数据
            this.phalanxData = this.updateIdValueData(this.phalanxData,[data.forward_phalanx,data.center_phalanx,data.back_phalanx], "id");
            
            // this.fireEvent(World.EVT.SIGHT_UPDATE);
            this.fireEvent(World.EVT.TO_PHALANX, data);
        }

        private onToArmy(data:any): void {
            //删除方阵数据
            delete this.phalanxData[data.forward_phalanx_id];
            delete this.phalanxData[data.center_phalanx_id];
            delete this.phalanxData[data.back_phalanx_id];

            //加入部队数据
            this.armyData = this.updateIdValueData(this.armyData, [data.army], "army_id");
            this.fireEvent(World.EVT.TO_ARMY, data);
        }        

        private updateMovePath(targetData: any, data: any, id: number): any {
            let value = targetData[id];
            if (!value) { return null; }
            let aaa = data;
            value.move_path = data.path;
            value.cur_point = data.cur_point;
            value.status = data.status;
            return value;
        }

        private updateIdValueData(oldData: any, newData: any[], key: any): any {
            let data = utils.convert2Object(newData, v => v[key]);
            oldData = utils.mergeObject(data, oldData);

            // 回收不在地图视区的数据
            let ret = {};
            for (let k in oldData) {
                let v = oldData[k];
                let idx = this.makePos(v.cur_point.x, v.cur_point.y);
                if (this.viewCells[idx]) {
                    ret[k] = v;
                }
            }

            return ret;
        }

        public updateUnitData(unitData: any[]): void {
            let data = utils.convert2Object(unitData, v => this.makePos(v.x, v.y));
            data = utils.mergeObject(data, this.unitData);
            this.unitData = utils.intersectObject(data, this.viewCells);
        }

        public removeUnit(x: number, y: number): void {
            let xy = this.makePos(x, y);
            delete this.unitData[xy];
        }

        public removeUnitById(id: number): void {
            for (let k in this.unitData) {
                let v = this.unitData[k];
                if (v.build_id === id) {
                    delete this.unitData[k];
                    return;
                }
            }
        }

        public createUnit(buildInfo: any): void {
            this.unitData[buildInfo.build_id] = buildInfo;
        }

        public deleteIdValue(data: any, id: number, key: string) {
            for (let k in data) {
                let v = data[k];
                if (v[key] === id) {
                    delete data[k];
                }
            }
        }

        private createCitys(city: msg.m_map_sight_toc["city_list"][0]): any {
            let citys = {};
            let size = DBRecord.fetchKey("CityConfig_json", city.city_tid, "city_size");
            let bgPos = Math.floor(size / 2);
            let [ox, oy] = [city.x - bgPos, city.y - bgPos];
            let landCfg = this.getCellLangType(ox, oy);

            for (let i = 0; i < size; i++) {
                for (let j = 0; j < size; j++) {
                    let [x, y] = [ox + i, oy + j];
                    let k = this.makePos(x, y);
                    citys[k] = {x, y, type : -1, org : city, landCfg};
                }
            }
            return citys;
        }

        private createBlocks(block: msg.m_map_sight_toc["block_list"][0]): any {
            let ret = {};

            let blockShape = RES.getRes("config_block_shape_json");
            let blockCfg = blockShape[block.block_tid];
            if (!blockCfg) { return ret; }

            let model = DBRecord.fetchKey("BlockConfig_json", block.block_tid, "block_model");
            if (!model || model === "") { return ret; }
            let opos = {x : blockCfg.anchor.x + block.x, y : blockCfg.anchor.y + block.y};

            for (let v of blockCfg.self_shape) {
                let d = {
                    model : model,
                    block_id : block.block_id,
                    type : -2,
                    x : opos.x + v.x,
                    y : opos.y + v.y,
                    org : opos,
                    cfg: blockCfg,
                }
                let k = this.makePos(d.x, d.y);
                ret[k] = d;
            }
            return ret;
        }

        private updateOrnamentData(ornament: msg.m_map_sight_toc["ornament_list"]): any {
            let data = {};
            for (let v of ornament) {
                let model = DBRecord.fetchKey("OrnamentConfig_json", v.ornament_tid, "ornament_model");
                if (!model || model === "") { continue; }
                let k = this.makePos(v.x, v.y);
                data[k] = {
                    type : -3,
                    model : model,
                    id : v.ornament_id,
                    tid : v.ornament_tid,
                    x : v.x,
                    y : v.y,
                };
            }
            data = utils.mergeObject(data, this.ornamentData);
            this.ornamentData = utils.intersectObject(data, this.viewCells);
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

        public getIdValueDataByPos(pos: mo.CPoint, data: any, face: string, isBlock = false): any {
            for (let k in data) {
                let v = data[k];
                if (v.x === pos.x && v.y === pos.y) {
                    let r = utils.deepCopy(v);
                    r.face = face;
                    r.block = isBlock;
                    return r;
                }
            }
            return undefined;
        }

        public searchCellPos(cpos: mo.CPoint, param?: any): void {
            this.fireEvent(World.EVT.SEARCH_POS, cpos, param);
        }

        public gotoLocation(cpos: mo.CPoint): void {
            this.fireEvent(World.EVT.LOCATION, cpos);
        }

        private isDynamicBlocked(cx: number, cy: number): boolean {
            let index = this.makePos(cx, cy);
            return !!this.blockData[index];
        }

        public getCellArmyById(id: number): any {
            let data = this.armyData[id];
            if (!data) { return undefined; }

            let temp = utils.copyObject(data);
            temp.face = "army";
            temp.block = true;
            return temp;
        }

        public getCellPhalanxById(id: number): any {
            let data = this.phalanxData[id];
            if (!data) { return undefined; }

            let temp = utils.copyObject(data);
            temp.face = "phalanx";
            temp.block = true;
            return temp;
        }

        private getCellOrnamentTile(cpos: mo.CPoint): any {
            let index = this.makePos(cpos.x, cpos.y);
            let ornament = this.ornamentData[index];
            if (!ornament) { return undefined; }

            let temp = utils.copyObject(ornament);
            temp.face = "ornament";
            temp.block = false;
            return temp;
        }

        private getCellBlockCfgTile(cpos: mo.CPoint): any {
            let index = this.makePos(cpos.x, cpos.y);
            let block = this.blockData[index];
            if (!block) { return undefined; }

            let temp = utils.copyObject(block);
            temp.face = "block";
            temp.block = true;
            return temp;
        }

        private getCellCfgTile(cpos: mo.CPoint): any {
            let index = this.makePos(cpos.x, cpos.y);
            let idx = mo.TMap.getMainData().getLayerIdxByName("config_map_land_piece");
            let tileId = mo.TMap.getMainData().getTileId(index, idx);

            let lcfg = DBRecord.fetchId("LandPieceConfig_json", tileId);
            if (!lcfg) { return undefined; }

            let info: any = {
                lcfg : lcfg,
                x : cpos.x,
                y : cpos.y,
                face : "res",
                block : lcfg.is_change_appearance === 1,
            };
            return info;
        }

        public getCellInfo(cx: number, cy: number): any {
            let cpos = {x : cx, y : cy};
            let info = undefined;
            info = info || this.getIdValueDataByPos(cpos, this.unitData, "unit", true);
            info = info || this.getIdValueDataByPos(cpos, this.cityData, "city", false);
            // info = info || this.getCellOrnamentTile(cpos);
            info = info || this.getCellBlockCfgTile(cpos);
            info = info || this.getCellCfgTile(cpos);
            if (!info) {
                let block = mo.TMap.getMainData().isBlocked(cpos, config.MAP_BLOCKED_LAYER_NAME);
                info = {x : cx, y : cy, face : "empty", block : block};
            }

            return info;
        }

        public getCellTypeCfgTile(cx: number, cy: number): any {
            let index = this.makePos(cx, cy);
            return mo.TMap.getMainData().getCellTypeCfgTile(index);
        }

        public isBlocked(cx: number, cy: number): boolean {
            let cell = LogicMgr.get(logic.World).getCellInfo(cx, cy);
            return cell.block;
        }

        public getCellLangType(cx : number, cy : number) {
            let index = this.makePos(cx, cy);
            return mo.TMap.getMainData().getCellTypeCfgTile(index);
        }

        public buildUnit(cx: number, cy: number): void {
            let build_id = Math.random();
            this.unitData[build_id] = {x : cx, y : cy, type : 1, build_id : build_id};
        }

    }

}
