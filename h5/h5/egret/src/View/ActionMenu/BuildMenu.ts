namespace ui {

    export class BuildMenu extends UIBase {

        private static CUSTOM = {
            closeBg : {alpha : 0},
            skinName : "resource/ui/BuildMenuUISkin.exml",
            binding : {
                ["btnFunc"] : { method : "onBtnFunc", },
                ["btnFinish"] : { method : "onBtnFinish", },
                ["btnInfo"] : { method : "onBtnInfo", },
            },
        }

        private world: ui.World;
        private gpMainPos: eui.Group;
        private gpAnchor: eui.Group;
        private lbTitle: eui.Label;
        private lbPos: eui.Label;
        private lbState: eui.Label;
        
        private data;

        public constructor(world: ui.World, data: any) {
            super(BuildMenu.CUSTOM);
            this.world = world;
            this.data = data;
            this.lbPos.text = `(${data.info.x},${data.info.y})`;

            let cfg = LogicMgr.get(logic.Build).getConfig(data.info.type);
            if (!cfg) { return; }
            this.lbTitle.text = `${cfg.name}  (LV${cfg.lv})` ;
        }

        protected onEnter(): void {
            super.onEnter();

            let offsetY = 100;
            this.world.getMapContainer().setPosWithAnimat(this.data.pos.x, this.data.pos.y + offsetY, 200, ()=>this.delayShow());
            this.gpMainPos.visible = false;
        }

        protected onExit(): void {
            super.onExit();
            this.world = null;
        }

        private delayShow() {
            if (!this.world) { return; }
            let wpos = this.world.getMap().cell2world(this.data.info.x, this.data.info.y);
            let wp = this.world.getMap().getNode().localToGlobal(wpos[0], wpos[1]);
            let cp = this.globalToLocal(wp.x, wp.y);
            this.gpMainPos.x = cp.x;
            this.gpMainPos.y = cp.y;
            this.gpMainPos.visible = true;
        }

        private onBtnFunc(e: egret.TouchEvent): void {
            Prompt.popTip("功能开发中");
        }

        private onBtnFinish(e: egret.TouchEvent): void {
            Prompt.popTip("功能开发中");
        }

        private onBtnInfo(e: egret.TouchEvent): void {
            Prompt.popTip("功能开发中");
        }
    }

}