namespace world {

    export class BuildBase extends ViewBase {

        private lbTime: eui.Label;
        private pgTime: eui.ProgressBar;
        private barNode: egret.DisplayObjectContainer;
        private facade: string;
        private prgBlood: eui.ProgressBar;
        private uiNode: egret.DisplayObjectContainer;

        public constructor(mgr: Manager, root: egret.DisplayObjectContainer, data: any) {
            super(mgr, root, data);
            let buildUILayer = mgr.getBuildUILayer();
            this.uiNode = new egret.DisplayObjectContainer();
            buildUILayer.addChild(this.uiNode);

            this.addDataMonitors();
            this.initRefresh();
        }

        public build(): egret.DisplayObjectContainer {
            this.facade = LogicMgr.get(logic.Build).getBuildingFacade(this.data.type, this.data.lv, this.data.build_state);
            let view = this.createView(this.facade);
            return view;
        }

        private initRefresh(): void {
            this.refreshState();
            this.refreshBuild();
            this.refreshPos();
        }

        private addDataMonitors(): void {
            this.monitor(["build_id", "build_state", "end_time", "opt_state"], this.refreshState, this);
            this.monitor(["durability_limit", "durability"], this.refreshBlood, this);
            this.monitor(["lv", "type", "build_state"], this.refreshBuild, this);
            this.monitor(["x", "y"], this.refreshPos, this);
        }

        private createBloodNode(): egret.DisplayObjectContainer {
            let gp = new egret.DisplayObjectContainer();
            [gp.x, gp.y] = [20, -10];

            let prg = new eui.ProgressBar();
            prg.skinName = BuildingProgress;
            gp.addChild(prg);

            this.prgBlood = prg;
            this.refreshBlood();
            return gp;
        }

        public setBloodVisible(visible: boolean, delay: number): void {
            let invalid = !this.prgBlood && !visible;
            if (invalid) { return; }

            if (!this.prgBlood) {
                let node = this.createBloodNode();
                this.uiNode.addChild(node);
            }
            this.prgBlood.visible = visible;

            if (delay) {
                egret.Tween.removeTweens(this.prgBlood);
                egret.Tween.get(this.prgBlood).wait(delay).to({visible: false});
            }
        }

        public refresh(): void {
            // do noting
        }

        private refreshBlood(): void {
            if (!this.prgBlood) { return; }
            this.prgBlood.maximum = this.data.durability_limit;
            this.prgBlood.value = this.data.durability;
        }

        private refreshBuild(): void {
            let facade = LogicMgr.get(logic.Build).getBuildingFacade(this.data.type, this.data.lv, this.data.build_state);
            this.updateFacade(facade);
            this.facade = facade;
        }

        private refreshPos(): void {
            let wpos = this.worldMap.cell2world(this.data.x, this.data.y);
            [this.view.x, this.view.y] = [wpos[0], wpos[1]];
            [this.uiNode.x, this.uiNode.y] = wpos;
            this.centerView(this.uiNode);
        }

        private refreshState(): void {
            this.removeBarNode();
            this.barNode = this.createBarNode();
            if (this.barNode) {
                this.uiNode.addChild(this.barNode);
            }

            // test
            // let lbId = new eui.Label();
            // lbId.text = this.data.build_id;
            // this.view.addChild(lbId);
        }

        protected createBarNode(): egret.DisplayObjectContainer {
            if (!LogicMgr.get(logic.Player).isPlayer(this.data.ower_info.role_id)
               || this.data.opt_state === msgEnum.BUILDING_STATE_NORMAL) {
                return undefined;
            }

            let container = new egret.DisplayObjectContainer();
            let node = new egret.DisplayObjectContainer();
            container.addChild(node);
            [node.x, node.y] = [15, -48];

            this.createTimeBar(node);
            container.addEventListener(egret.Event.ENTER_FRAME, this.timerCount, this);

            let offset = {x : 0, y : 0};
            let bd: egret.Texture;
            if (this.data.opt_state === msgEnum.BUILDING_STATE_BUILDING) {
                bd = RES.getRes("icon_dianjikongdi_jianzao_s2_png");
            }else
            if (this.data.opt_state === msgEnum.BUILDING_STATE_UPGRADING) {
                bd = RES.getRes("pic_jianzuxuanzhong_s1_png");
            }else
            if (this.data.opt_state === msgEnum.BUILDING_STATE_REPAIRING) {
                bd = RES.getRes("pic_jianzuxuanzhong_s14_png");
                offset = {x : 0, y : 60};
            }
            if (bd) {
                let img = new eui.Image(bd);
                [img.x, img.y] = [offset.x, offset.y];
                node.addChild(img);
            }
            
            return container;
        }

        private createTimeBar(node: egret.DisplayObjectContainer): void {
            let sec = ServerTime.getDiffTime(this.data.end_time);
            if (sec > 0) {
                this.lbTime = new eui.Label();
                this.lbTime.size = 22;
                this.lbTime.stroke = 2;
                this.lbTime.x = 45;
                node.addChild(this.lbTime);
                
                this.pgTime = new eui.ProgressBar();
                this.pgTime.skinName = BuildTimeProgress;
                node.addChild(this.pgTime);
                this.pgTime.x = 30;
                this.pgTime.y = 20;
                this.pgTime.maximum = this.data.end_time - this.data.start_time;
                this.pgTime.value = sec;
            }
        }

        private timerCount(): void {
            let sec = ServerTime.getDiffTime(this.data.end_time);
            if (sec < 0) {
                return this.removeBarNode();
            }
            this.pgTime.value = sec;
            let st = ServerTime.secToDay(sec);

            this.lbTime.text = ServerTime.formatTime(st);
        }

        private removeBarNode(): void {
            if (this.barNode) {
                this.barNode.removeEventListener(egret.Event.ENTER_FRAME, this.timerCount, this);
                this.barNode.parent.removeChild(this.barNode);
                this.barNode = null;
            }
        }

        private removeUINode(): void {
            if (this.uiNode) {
                this.uiNode.parent.removeChild(this.uiNode);
                this.uiNode = null;
            }
        }

        public destroy(): void {
            if (this.prgBlood) {
                egret.Tween.removeTweens(this.prgBlood);
            }

            this.removeBarNode();
            this.removeUINode();
            this.lbTime = null;
            this.pgTime = null;
            this.prgBlood = null;
            super.destroy();
        }
    }

}