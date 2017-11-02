namespace ui {

    export class ArmyMenu extends ActionMenuBase {

        private static CUSTOM = {
            closeBg : {alpha : 0},
            skinName : "resource/ui/ActionMenu/ArmyMenuUISkin.exml",
            binding : {},
        }

        private lbArmyName: eui.Label;

        public constructor(world: ui.World, data: any) {
            super(ArmyMenu.CUSTOM, world, data);
        }

        protected onEnter(): void {
            super.onEnter();

            this.createMenus();
            this.runMenuAction();
            this.refresh();
        }

        protected createMenus(): void {
            const OPTS = {
                info     : {text : "军队详情", func : this.onArmyInfo, icon : "build_menu_btn_png"},
                look     : {text : "查看玩家", func : this.onPlayerInfo, icon : "build_menu_btn_png"},
                spyon    : {text : "侦查", func : this.onSpyon, icon : "build_menu_btn_png"},
                attack   : {text : "进攻", func : this.onAttack, icon : "build_menu_btn_png"},
            }
            let opts = this.getOpts();
            for (let v of opts) {
                this.createMenu(OPTS[v]);
            }

            this.isShowMenu = opts.length > 0;
        }

        private getOpts(): string[] {
            let ret = [];
            if (this.data.info.face === "army") {
                ret.push("info");
            }

            if (LogicMgr.get(logic.Player).isPlayer(this.data.info.ower_info.role_id)) {
                return ret;
            }
            ret.splice(1, 0, "look", "spyon", "attack");
            return ret;
        }

        private refresh(): void {
            this.lbArmyName.text = this.data.info.name;
        }

        private onArmyInfo(): void {
            UIMgr.open(ui.ArmyDetial, "panel", this.data.info);
            this.onClose();
        }

        private onPlayerInfo(): void {
            UIMgr.open(ui.PlayerDetial, "panel", this.data.info.ower_info);
            this.onClose();
        }

        private onSpyon(): void {
            Prompt.popTip("功能开发中");
            this.onClose();
        }

        private onAttack(): void {
            LogicMgr.get(logic.World).moveArmyToCell(this.data.info.army_id, this.data.info.x, this.data.info.y);
            this.onClose();
        }
    }

}