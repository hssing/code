namespace ui {

    let defaultLoader = (thisObject, data) => {
            let w = new ui.ActionMenu(thisObject, data);
            [w.x, w.y] = [data.pos.x, data.pos.y];
            data.root.addChild(w);
            return w;
    }

    const MenuConditionMap = [
        {
            condition : (cellInfo)=>LogicMgr.get(logic.Build).isBuildMenu(cellInfo),
            loader: (thisObject, data)=>UIMgr.openOnce(ui.BuildMenu, void 0, thisObject, data),
        },
        {
            condition : (cellInfo)=>true,
            loader: defaultLoader,
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

            LogicMgr.get(logic.World).on(logic.World.EVT.ENTER_MAP, this.Event("onEnterMap"));
            LogicMgr.get(logic.World).on(logic.World.EVT.SIGHT_UPDATE, this.Event("onSightUdpate"));
            LogicMgr.get(logic.World).on(logic.World.EVT.ACTOR_MOVE, this.Event("onActorMove"));

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
            this.mapContainer.registScrollCallback(() => this.updateDisplayLabel());
		}

        public onActorMove(armyData: any): void {
            this.manager.getArmyMgr().updatePath(armyData);
        }

        public onSightUdpate(): void {
            let world = LogicMgr.get(logic.World) as logic.World;
            this.manager.getArmyMgr().updateData(world.getArmayData());
            this.manager.getBuildMgr().updateData(world.getUnitData());
            this.manager.getTabletMgr().updateData(world.getTabletData());
        }

        public onTagCell(worldPos: mo.WPoint): void {
            let [x, y] = this.map.world2cell(worldPos.x, worldPos.y);

            this.onSearchCellPos({x, y});
            this.updateSelectedNode(worldPos);
        }

        public updateSelectedNode(worldPos: mo.WPoint): void {
            let cpos = this.map.world2cell(worldPos.x, worldPos.y);
            let wpos = this.map.cell2world(cpos[0], cpos[1]);
            [this.selectedNode.x, this.selectedNode.y] = wpos;
        }

        public moveToCell(x: number, y: number, z: number = 0): void {
            let data = {target_point : {x, y, z}};
            NetMgr.get(msg.Map).send("m_map_get_view_obj_tos", data);
        }

        public onUpdateCells(indexCells: any): void {
            let cpos = this.map.getCenterCPos();
            LogicMgr.get(logic.World).getViewObjects(cpos[0], cpos[1]);
            LogicMgr.get(logic.World).setViewCells(indexCells);

            this.updateDisplayLabel();
        }

        public onSearchCellPos(cpos: mo.CPoint, param?: any): void {
            let unit = LogicMgr.get(logic.World).getUnitDataByPos(cpos);
            if (!unit) { return; }
            let data = this.manager.getGridData(unit, cpos);
            this.onClickMap(data, param);
        }

        public onClickMap(data: any, param?: any): void {
            this.closeItem();

            let node    = data.root;
            let info    = data.info;
            let pos     = data.pos;
            data.param  = param;

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
            let cpos = LogicMgr.get(logic.Build).getMainBuildPos();
            this.mapContainer.setCell2Center(cpos.x, cpos.y);
        }

        public updateDisplayLabel(): void {
            let cpos = LogicMgr.get(logic.Build).getMainBuildPos();
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