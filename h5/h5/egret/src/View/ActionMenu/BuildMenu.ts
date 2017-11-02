namespace ui {

    export class BuildMenu extends ActionMenuBase {

        private static CUSTOM = {
            skinName : "resource/ui/ActionMenu/BuildMenuUISkin.exml",
            binding : {},
        }

        protected imgRange: eui.Image;
        protected lbTitle: eui.Label;
        protected lbState: eui.Label;
        protected imgState: eui.Image;

        public constructor(world: ui.World, data: any) {
            super(BuildMenu.CUSTOM, world, data);
        }

        protected onEnter(): void {
            super.onEnter();

            this.imgState.visible = false;
            this.lbState.visible = false;
            this.imgRange.visible = false;
            this.isShowMenu = true;

            let cfg = LogicMgr.get(logic.Build).getBuildConfig(this.data.info.type);
            if (!cfg) { return; }

            this.lbTitle.text = `${LTEXT(cfg.name)}  (LV${this.data.info.lv})`;
            
            let isPlayer = LogicMgr.get(logic.Player).isPlayer(this.data.info.ower_info.role_id);
            if (isPlayer) {
                this.focusCenter();
                this.createPlayerMenus();
                this.updateState();
                return;
            }

            this.createOtherMenus();
            this.runMenuAction();
        }

        protected onExit(): void {
            this.world.showBuildBlood(this.data.info.x, this.data.info.y, false);
            super.onExit();
        }

        protected createOtherMenus(): void {
            const OPTS = {
                spyon     : {text : "侦查", func : this.onSpyon, icon : "build_menu_btn_png"},
            }
            for (let k in OPTS) {
                this.createMenu(OPTS[k]);
            }
        }

        protected createPlayerMenus(): void {
            const OPTS = {
                info     : {text : "信息", func : this.onInfo, icon : "build_menu_btn_png"},
                complete : {text : "立即完成", func : this.onComplete, icon : "build_menu_btn_png"},
                upgrade  : {text : "升级", func : this.onUpgrade, icon : "build_menu_btn_png"},
                reform   : {text : "重建", func : this.onReform, icon : "build_menu_btn_png"},
                repair   : {text : "维修", func : this.onRepair, icon : "build_menu_btn_png"},
                remove   : {text : "拆除", func : this.onRemove, icon : "build_menu_btn_png"},
                move     : {text : "移动", func : this.onMove, icon : "build_menu_btn_png"},
                func     : {text : "功能", func : this.onFunc, icon : "build_menu_btn_png"},
            }
            let opts = LogicMgr.get(logic.Build).getOpts(this.data.info.build_id);
            for (let v of opts) {
                this.createMenu(OPTS[v]);
            }
        }

        protected updateState(): void {
            const STATE = {
                [msgEnum.BUILDING_STATE_BUILDING] : "建造中",
                [msgEnum.BUILDING_STATE_REPAIRING] : "维修中",
                [msgEnum.BUILDING_STATE_UPGRADING] : "升级中",
            }
            let stText = STATE[this.data.info.opt_state];
            this.imgState.visible = this.lbState.visible = !!stText;
            if (stText) {
                this.lbState.text = stText;
            }
        }

        protected delayShow(): void {
            super.delayShow();

            if (!this.world) { return; }
            
            let isPlayer = LogicMgr.get(logic.Player).isPlayer(this.data.info.ower_info.role_id);
            this.imgRange.visible = isPlayer && LogicMgr.get(logic.Build).canTurn(this.data.info.build_id);
            this.world.showBuildBlood(this.data.info.x, this.data.info.y, true);
        }

        private onInfo(): void {
            UIMgr.open(BuildInfo, "panel", this.data.info.build_id);
            this.onClose();
        }

        private onMove(): void {
            UIMgr.open(ui.BuildMove, "panel", this.world, this.data);
            this.onClose();
        }

        private onComplete(): void {
            Prompt.popTip("功能开发中");
        }

        private onSpyon(): void {
            Prompt.popTip("功能开发中");
        }

        private onFunc(): void {
            let uiMap = {
                [logic.BuildType.CommandCenter]: ui.CommandCenterFunc,
                [logic.BuildType.Camp]: ui.CampMain,
            }

            let buildConfig = LogicMgr.get(logic.Build).getBuildConfig(this.data.info.type)
            UIMgr.open(uiMap[buildConfig.type] || ui.CommandCenterFunc);
        }

        private onUpgrade(): void {
            UIMgr.open(BuildUpgrade, "panel", this.data.info.build_id);
            this.onClose();
        }

        private onReform(): void {
            LogicMgr.get(logic.Build).rebuildBuilding(this.data.info.build_id);
            this.onClose();
        }

        private onRemove(): void {
            LogicMgr.get(logic.Build).removeBuilding(this.data.info.build_id);
            this.onClose();
        }

        private onRepair(): void {
            LogicMgr.get(logic.Build).repairBuilding(this.data.info.build_id);
            this.onClose();
        }
    }

}