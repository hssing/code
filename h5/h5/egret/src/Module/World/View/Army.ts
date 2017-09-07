namespace world {

    export class Army extends ViewBase {

        public constructor(mgr: Manager, root: egret.DisplayObjectContainer, data: any) {
            super(mgr, root, data);
        }

        public build(): egret.DisplayObjectContainer {
            let role: RoleView = new RoleView();
            role.anchorOffsetX = 30;
            role.anchorOffsetY = 10;
            // let army:ArmyView = new ArmyView();

            return role;
        }

        public refresh(): void {
            let wpos = this.worldMap.cell2world(this.data.cur_point.x, this.data.cur_point.y);

            let vo: PlayerVO = new PlayerVO();
            vo.setXY(wpos[0], wpos[1]);
            
            (this.view as RoleView).updateVO(vo);
            if (this.data.status === 1) {
                this.view.updatePath(this.data);
            }
        }
    }
}