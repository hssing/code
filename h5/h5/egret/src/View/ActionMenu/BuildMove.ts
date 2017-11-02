namespace ui {

    const RANGE = 150; // 触发拖屏的最小距离

    export class BuildMove extends UIBase {

        private static CUSTOM = {
            skinName : "resource/ui/BuildMoveUISkin.exml",
            binding : {
                ["btnOK"] : { method : "onBtnOK", },
                ["btnCancel"] : { method : "onBtnCancel", },
            },
        }

        private gpTouch: eui.Group;
        private gpBuild: eui.Group;
        private gpMenu: eui.Group;
        private imgSelected: eui.Image;
        private imgBuilding: eui.Image;

        private data: any;
        private world: ui.World;
        private targetCPos: mo.CPoint;
        private touchPos: mo.WPoint;

        public constructor(world: ui.World, data: any) {
            super(BuildMove.CUSTOM);
            this.data = data;
            this.world = world;
            this.targetCPos = null;
        }

        protected onEnter(): void {
            super.onEnter();

            let info = this.data.info;
            this.gpMenu.visible = false;
            this.imgBuilding.source = LogicMgr.get(logic.Build).getBuildingFacade(info.type, info.lv, info.build_state);

            this.gpTouch.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onStartMove, this);
            this.gpTouch.addEventListener(egret.TouchEvent.TOUCH_END, this.onStopMove, this);
        }

        private onStartMove(e: egret.TouchEvent): void {
            this.gpTouch.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
            this.gpMenu.visible = false;
        }

        private onStopMove(e: egret.TouchEvent): void {
            this.stopMoveMapTimer();
            this.gpTouch.removeEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
            if (!this.targetCPos) {
                return this.onClose();
            }
            this.gpMenu.visible = true;
        }

        private onTouchMove(e: egret.TouchEvent): void {
            this.innerTouchMove(e.stageX, e.stageY);
        }

        private innerTouchMove(x: number, y: number): void {
            let wpos = this.world.getMap().getNode().globalToLocal(x, y);
            let cpos = this.world.getMap().world2cell(wpos.x, wpos.y);
            let mpos = this.world.getMap().cell2world(cpos[0], cpos[1]);
            let spos = this.world.getMap().getNode().localToGlobal(mpos[0], mpos[1]);
            let pos = this.gpTouch.globalToLocal(spos.x, spos.y);
            [this.gpBuild.x, this.gpBuild.y] = [pos.x, pos.y];

            let player = LogicMgr.get(logic.Player);
            let cellInfo = LogicMgr.get(logic.World).getCellInfo(cpos[0], cpos[1]);
            let allow = (cellInfo.face === "city") && player.isPlayer(cellInfo.org.ower_info.role_id);

            if (allow || this.checkTargetCanMove(cellInfo)) {
                utils.resetColor(this.imgSelected);
                this.targetCPos = {x : cpos[0], y : cpos[1]};
            }else {
                utils.setColor(this.imgSelected, {r : 255});
                this.targetCPos = null;
            }
            this.startMoveMapTimer(x, y);
        }
        
        private startMoveMapTimer(x: number, y: number): void {
            this.touchPos = {x, y};
            this.stopMoveMapTimer();
            if (x < RANGE || y < RANGE || x > this.width - RANGE || y > this.height - RANGE) {
                Singleton(Timer).after(100, this.Event("AUTO_MOVE_TIMER", "onMoveMap"));
            }
        }

        private stopMoveMapTimer(): void {
            Singleton(Timer).cancel(this, "AUTO_MOVE_TIMER");
        }

        private onMoveMap(): void {
            let orgPos = this.data.info.grid;
            let [offsetX, offsetY] = [0, 0];
            if (this.touchPos.x < RANGE) {
                offsetX = -RANGE;
            }
            if (this.touchPos.x > this.width - RANGE) {
                offsetX = RANGE;
            }
            if (this.touchPos.y < RANGE) {
                offsetY = -RANGE;
            }
            if (this.touchPos.y > this.height - RANGE) {
                offsetY = RANGE;
            }

            let pos = this.world.getMap().getPos();
            this.world.getMapContainer().setPosWithCheckRange(pos[0] + offsetX, pos[1] + offsetY);
            this.innerTouchMove(this.touchPos.x, this.touchPos.y);
        }

        private checkTargetCanMove(cellInfo: any): boolean {
            if (cellInfo.face !== "unit") { return false; }
            if (cellInfo.build_id === this.data.info.build_id) { return false; }
            let move = DBRecord.fetchKey("BuildConfig_json", cellInfo.type, "move");
            return move === 1;
        }

        private onBtnOK(): void {
            this.onClose();
            if (!this.targetCPos) { return; }
            let id = this.data.info.build_id;
            LogicMgr.get(logic.Build).moveBuilding(id, this.targetCPos.x, this.targetCPos.y);
        }

        private onBtnCancel(): void {
            this.onClose();
        }

    }

}