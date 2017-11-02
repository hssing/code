namespace ui {

    export class ActionMenuBase extends UIBase {

        protected world: ui.World;
        protected gpMainPos: eui.Group;
        protected gpMenuBg: eui.Group;
        protected gpMenu: eui.Group;
        protected lbPos: eui.Label;
        
        protected data;
        protected isShowMenu;

        public constructor(custom: any, world: ui.World, data: any) {
            super(custom);
            this.world = world;
            this.data = data;
            this.isShowMenu = false;
        }

        protected onEnter(): void {
            super.onEnter();

            this.gpMenuBg.visible = false;
            this.gpMenu.layout = new uilayout.RingLayout(20);

            this.lbPos.text = `(${this.data.info.x},${this.data.info.y})`;
        }

        protected onExit(): void {
            super.onExit();
            this.world = null;
        }

        protected focusCenter(): void {
            let offsetY = 100;
            this.world.getMapContainer().setPosWithAnimat(this.data.pos.x, this.data.pos.y + offsetY, 200, ()=>this.delayShow());
        }

        protected delayShow(): void {
            if (!this.world) { return; }

            let wpos = this.world.getMap().cell2world(this.data.info.x, this.data.info.y);
            let wp = this.world.getMap().getNode().localToGlobal(wpos[0], wpos[1]);
            let cp = this.globalToLocal(wp.x, wp.y);
            this.gpMainPos.x = cp.x;
            this.gpMainPos.y = cp.y;
            this.runMenuAction();
        }

        protected runMenuAction(): void {
            if (!this.isShowMenu) { return; }

            this.gpMenuBg.scaleX = this.gpMenuBg.scaleY = 0;
            this.gpMenuBg.visible = true;
            egret.Tween.get(this.gpMenuBg).to({scaleX : 1, scaleY : 1}, 200, egret.Ease.backOut);
        }

        protected createMenu(opt: any): egret.DisplayObjectContainer {
            let gp = new eui.Group();
            let bg = new eui.Image();
            bg.source = opt.icon;
            let lb = new eui.Label();
            lb.text = opt.text;
            lb.size = 23;
            lb.stroke = 3;
            gp.addChild(bg);
            gp.addChild(lb);
            bg.horizontalCenter = bg.verticalCenter = 0;
            lb.horizontalCenter = lb.verticalCenter = 0;
            this.gpMenu.addChild(gp);
            gp.addEventListener(egret.TouchEvent.TOUCH_TAP, opt.func, this);
            return gp;
        }
    }

}