namespace ui {

    export let g_pos = [];

    let defaultLoader = (view, thisObject, data) => {
            let w = new view(thisObject, data);
            [w.x, w.y] = [data.pos.x, data.pos.y];
            data.root.addChild(w);
            return w;
    }

    const MenuConditionMap = [
        {
            condition : (cellInfo)=>LogicMgr.get(logic.Build).isBuildMenu(cellInfo),
            loader: (thisObject, data)=>defaultLoader(ui.BuildMenu, thisObject, data),
        },
        {
            condition : (data)=>(data.info.face === "army" || data.info.face === "phalanx"),
            loader: (thisObject, data)=>defaultLoader(ui.ArmyMenu, thisObject, data),
        },
        {
            condition : (cellInfo)=>true,
            loader: (thisObject, data)=>defaultLoader(ui.PlantMenu, thisObject, data),
        }
    ]

    export class World extends UIBase {

        private static CUSTOM = {
            skinName : "resource/ui/WorldUISkin.exml",
            binding : {
                ["gpDis"] : { method : "onGpRest2MainCell", },
            },
        }

        private mapContainer: MapScroller;
        private map: mo.TMap;
        private manager: world.Manager;
        private worldItem;
        private selectedNode: eui.Image;

        private gpMap: eui.Group;
        private gpDis: eui.Group;
        private lbDis: eui.Label;

        public constructor() {
            super(World.CUSTOM);
        }

        protected onEnter(): void {
            super.onEnter();

            // LogicMgr.get(logic.World).on(logic.World.EVT.ENTER_MAP, this.Event("onEnterMap"));
            LogicMgr.get(logic.World).on(logic.World.EVT.SIGHT_UPDATE, this.Event("onSightUdpate"));
            LogicMgr.get(logic.World).on(logic.World.EVT.TO_PHALANX, this.Event("onToPhalanx")); //部队变方阵
            LogicMgr.get(logic.World).on(logic.World.EVT.TO_ARMY, this.Event("onToArmy")); //方阵变部队 
            LogicMgr.get(logic.World).on(logic.World.EVT.ACTOR_MOVE, this.Event("onActorMove"));
            LogicMgr.get(logic.World).on(logic.World.EVT.LOCATION, this.Event("onLocation"));
            LogicMgr.get(logic.Fight).on(logic.Fight.EVT.START_FIGHT, this.Event("onFight"));

            this.createMap(config.MAP_URLS);
            this.manager = new world.Manager(LogicMgr.get(logic.World), this.map);
            this.onReSize();
            
            let tx: egret.Texture = RES.getRes("frame_jianzuxuanzhong_s1_png");
            this.selectedNode = new eui.Image(tx);
            this.selectedNode.touchEnabled = false;
            this.selectedNode.alpha = 0.3;

            this.map.getNode().addChild(this.selectedNode);
            this.selectedNode.anchorOffsetX = tx.bitmapData.width / 2;
            this.selectedNode.anchorOffsetY = tx.bitmapData.height / 2;

            this.onGpRest2MainCell();
        }

        private label: eui.Label;

        protected onExit(): void {
            super.onExit();
            this.map = null;
            this.mapContainer.dispose();
            this.mapContainer = null;
        }

        private createMap(files: string[]): void {
            this.mapContainer = new MapScroller();
            this.mapContainer.buildMap(files[0], files.slice(1), this.gpMap);
            this.map = this.mapContainer.getMap();

            this.map.registTapCallback(wpos => this.onTagCell(wpos));
            this.map.registUpdateCallback(cells => this.onUpdateCells(cells));
            // this.mapContainer.registScrollCallback(() => this.updateDisplayLabel());
		}

        public onActorMove(data: any, id: number, type: string): void {
            if (type === "army") {
                this.manager.getArmyMgr().updatePath(data, id);
            }else if (type === "phalanx") {
                this.manager.getPhalanxMgr().updatePath(data, id);
            }
        }

        public onToPhalanx(data: any): void {
            console.log(" army_id == " + data.amy_id);
            let world = LogicMgr.get(logic.World) as logic.World;
            // let phalanxData = world.getPhalanxData();

            let views = this.manager.getArmyMgr().getViews();
            let retainView = views[data.amy_id];

            if (!retainView){
                return ;
            }

            let roleViews = retainView.getRoleViews();
            
            let phalanxPoints = this.manager.getPhalanxMgr().getPhalanxPoints();
            let phalanxData = []
            if (data.forward_phalanx){
                if (data.forward_phalanx.id > 0) {
                    data.forward_phalanx.status = 0;
                    phalanxData.push(data.forward_phalanx.id);
                }
            }

            if (data.center_phalanx){
                if (data.center_phalanx.id > 0) {
                    data.center_phalanx.status = 0;
                    phalanxData.push(data.center_phalanx.id);
                }
            }

            if (data.back_phalanx){
                if (data.back_phalanx.id > 0) {
                     data.back_phalanx.status = 0;
                     phalanxData.push(data.back_phalanx.id);
                }
            }            

            let _tempIndex = 0;
            for (let v in roleViews) {
                if (_tempIndex < phalanxData.length){
                     let _xy = (roleViews[v] as RoleView).getVO().getXY();
                     phalanxPoints[phalanxData[_tempIndex]] = _xy;
                     _tempIndex++;
                }else{
                    break;
                }
            }

            this.onSightUdpate();


            let _useTime = 1000;
            //更新完成， 0.5秒的移动时间
            let temp_data = {obj_id:data.forward_phalanx.id,
                             cur_point:data.forward_phalanx.cur_point,
                             status:1,
                             useTime:_useTime, //0.5秒的行走时间
                             move_path:[{x:data.forward_phalanx.cur_point.x,y:data.forward_phalanx.cur_point.y,z:data.forward_phalanx.cur_point.z}]};
            this.manager.getPhalanxMgr().updatePath(temp_data, data.forward_phalanx.id);

            //更新完成， 0.5秒的移动时间
            temp_data = {obj_id:data.center_phalanx.id,
                             cur_point:data.center_phalanx.cur_point,
                             status:1,
                             useTime:_useTime, //0.5秒的行走时间
                             move_path:[{x:data.center_phalanx.cur_point.x,y:data.center_phalanx.cur_point.y,z:data.center_phalanx.cur_point.z}]};
            this.manager.getPhalanxMgr().updatePath(temp_data, data.center_phalanx.id);

            //更新完成， 0.5秒的移动时间
            temp_data = {obj_id:data.back_phalanx.id,
                             cur_point:data.back_phalanx.cur_point,
                             status:1,
                             useTime:_useTime, //0.5秒的行走时间
                             move_path:[{x:data.back_phalanx.cur_point.x,y:data.back_phalanx.cur_point.y,z:data.back_phalanx.cur_point.z}]};
            this.manager.getPhalanxMgr().updatePath(temp_data, data.back_phalanx.id);
        }

        //方阵变部队
        public onToArmy(data: any): void {
            console.log(" army_id == " + data.army);
            

            let views = this.manager.getPhalanxMgr().getViews();


            let phalanxPoints = this.manager.getArmyMgr().getPhalanxPoints();

            let phalanxP = [];
            let forward_phalanx = views[data.forward_phalanx_id];
            if (forward_phalanx) {
                let [x,y] = forward_phalanx.getMainViews().getVO().getXY();
                phalanxP.push([x,y]);
            }

            let center_phalanx = views[data.center_phalanx_id];
            if (center_phalanx) {
                let [x,y] = center_phalanx.getMainViews().getVO().getXY();
                phalanxP.push([x,y]);
            }

            let back_phalanx = views[data.back_phalanx_id];
            if (back_phalanx) {
                let [x,y] = back_phalanx.getMainViews().getVO().getXY();
                phalanxP.push([x,y]);
            }

            phalanxPoints[data.army.army_id] = phalanxP;

            this.onSightUdpate();
        }



        public onSightUdpate(): void {
            let world = LogicMgr.get(logic.World) as logic.World;
            this.manager.getArmyMgr().updateData(world.getArmayData(),this);
            this.manager.getBuildMgr().updateData(world.getUnitData());
            this.manager.getCityMgr().updateData(world.getCityData());
            this.manager.getBlockMgr().updateData(world.getBlockData());
            this.manager.getPhalanxMgr().updateData(world.getPhalanxData(),this);
            this.manager.getOrnamentMgr().updateData(world.getOrnamentData());
        }

        private onFight() {
            // console.log("测试战斗......................................");
            let world = LogicMgr.get(logic.World) as logic.World;
            this.manager.getPhalanxMgr().updataFight(world.getFightData());
        }

        public onTagCell(worldPos: mo.WPoint): void {
            let [x, y] = this.map.world2cell(worldPos.x, worldPos.y);

            this.onSearchCellPos({x, y});
            this.updateSelectedNode(worldPos);
        }

        public onLocation(cpos: mo.CPoint): void {
            // this.mapContainer.setCell2Center(cpos.x, cpos.y);
            let pos = this.map.cell2world(cpos.x, cpos.y);
            this.mapContainer.setPosWithAnimat(pos[0], pos[1], 1000);
        }

        public updateSelectedNode(worldPos: mo.WPoint): void {
            let cpos = this.map.world2cell(worldPos.x, worldPos.y);
            let wpos = this.map.cell2world(cpos[0], cpos[1]);
            [this.selectedNode.x, this.selectedNode.y] = wpos;
        }

        public showBuildBlood(cx: number, cy: number, visible: boolean, delay?: number): void {
            this.manager.getBuildMgr().setBloodVisible(cx, cy, visible, delay);
        }

        public moveToCell(x: number, y: number, z: number = 0): void {
            let data = {target_point : {x, y, z}};
            NetMgr.get(msg.Map).send("m_map_get_view_obj_tos", data);
        }

        public onUpdateCells(indexCells: any): void {
            let cpos = this.map.getCenterCPos();
            LogicMgr.get(logic.World).getViewObjects(cpos[0], cpos[1]);
            LogicMgr.get(logic.World).setViewCells(indexCells);

            // this.updateDisplayLabel();
        }

        public onSearchCellPos(cpos: mo.CPoint, param?: any): void {
            this.closeItem();

            let wpos = this.map.cell2world(cpos.x, cpos.y);
            let pt = this.map.getNode().localToGlobal(wpos[0], wpos[1]);
            let armys = this.manager.getArmyMgr().hitTestPoint(pt.x, pt.y);
            let phalanxs = this.manager.getPhalanxMgr().hitTestPoint(pt.x, pt.y);
            // let monster = ??? // todo

            let info = LogicMgr.get(logic.World).getCellInfo(cpos.x, cpos.y);

            if (armys.length > 0 || phalanxs.length > 0) {
                UIMgr.open(ui.SelectMenu, "panel", this, cpos, {armys : armys, phalanxs : phalanxs, cell : info});
                return;
            }
            this.onClickMap(info, cpos, param);
        }

        public onClickMap(info: any, cpos: mo.CPoint, param?: any): void {
            let data = this.manager.getGridData(info, cpos)

            for (let v of MenuConditionMap) {
                if (v.condition(data)) {
                    this.worldItem = v.loader(this, data);
                    return;
                }
            }
        }

        public closeItem(): boolean {
            if (this.worldItem) {
                this.closeWorldItem();
                return true;
            }
            return false;
        }

        public closeWorldItem(): void {
            if (!this.worldItem) { return; }
            if (this.worldItem.parent) {
                this.worldItem.parent.removeChild(this.worldItem);
            }
            this.worldItem = null;
        }

        public getMap(): mo.TMap {
            return this.map;
        }

        public getMapContainer(): MapScroller {
            return this.mapContainer;
        }

        public onReSize(): void {
            super.onReSize();
            this.mapContainer.setViewSize({width : this.width, height : this.height});
        }

        public onGpRest2MainCell(): void {
            let cpos = LogicMgr.get(logic.City).getMainCityPos();
            this.mapContainer.setCell2Center(cpos.x, cpos.y);
        }

        public updateDisplayLabel(): void {
            let cpos = LogicMgr.get(logic.City).getMainCityPos();
            let info = this.manager.getHelper().getDisplayInfo(cpos);
            this.gpDis.visible = info.show;
            if (!info.show) { return; }

            let dis = this.manager.getHelper().getDistance(cpos, {x : info.cPosCenter[0], y : info.cPosCenter[1]});

            let degreeAngle = Math.round(info.angle / Math.PI * 180);
            this.gpDis.rotation = degreeAngle;
            dis = Math.floor(dis);
            this.lbDis.text = `${dis}公里`;

            this.lbDis.rotation = ((degreeAngle < 90 && degreeAngle > -90) ? 0 : 180);
            let pos = this.updateDistancePos(degreeAngle);
            [this.gpDis.x, this.gpDis.y] = [pos.x, pos.y];
        }

        private updateDistancePos(degreeAngle: number): {x, y} {
            let maxX = Math.round(this.width - this.gpDis.width / 2);
            let minX = Math.round(this.gpDis.width / 2);
            let maxY = Math.round(this.height - this.gpDis.width / 2);
            let minY = Math.round(this.gpDis.width / 2);

            let realHeight = maxY - minY;
            let realWidth = maxX - minX;
            let currentPos = {x : 0, y : 0};
            if (degreeAngle <= 45 && degreeAngle >= -45) {
                currentPos.x = maxX;
                currentPos.y = maxY - (45 - degreeAngle) * realHeight / 90;
            }
            else if (degreeAngle <= 135 && degreeAngle > 45) {
                currentPos.x = (135 - degreeAngle) * realWidth / 90 + minX;
                currentPos.y = maxY;
            }
            else if (degreeAngle < -45 && degreeAngle >= -135) {
                currentPos.x = (135 + degreeAngle) * realWidth /90 + minX;
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
        }
    }

}