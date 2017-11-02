namespace ui {

    export class PlantMenu extends ActionMenuBase {

        private static CUSTOM = {
            skinName : "resource/ui/ActionMenu/PlantMenuUISkin.exml",
            binding : {},
        }

        private lbPlayerInfo: eui.Label;
        private lbPlantName: eui.Label;
        private lbPlayerName: eui.Label;
        private lbUnionName: eui.Label;
        private lbMonsterName: eui.Label;
        private lbMonsterLv: eui.Label;

        private gpMonster: eui.Group;

        private lstBuff: eui.List;
        private lstRes: eui.List;

        public constructor(world: ui.World, data: any) {
            super(PlantMenu.CUSTOM, world, data);
        }

        protected onEnter(): void {
            super.onEnter();
            this.createMenus();
            this.runMenuAction();
            this.refresh();
        }

        protected createMenus(): void {
            const OPTS = {
                goto    : {text : "前往", func : this.onGoto, icon : "build_menu_btn_png"},
                sweep   : {text : "扫荡", func : this.onSweep, icon : "build_menu_btn_png"},
                mine    : {text : "挖宝", func : this.onMine, icon : "build_menu_btn_png"},
                build   : {text : "建造", func : this.onBuild, icon : "build_menu_btn_png"},
                wbuild  : {text : "建造", func : this.onBuildWild, icon : "build_menu_btn_png"},
                bcity   : {text : "建造分城", func : this.onBuildCity, icon : "build_menu_btn_png"},
                giveup  : {text : "放弃", func : this.onGiveup, icon : "build_menu_btn_png"},
            }
            let opts = this.getOpts();
            for (let v of opts) {
                this.createMenu(OPTS[v]);
            }

            this.isShowMenu = opts.length > 0;
        }

        private getOpts(): string[] {
            let ret = [];
            if ((this.data.info.face === "empty" && this.data.info.block)
                || this.data.info.face === "block") {
                return ret;
            }
            let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            if (armyInfo.length > 0) {
                ret.push("goto");
            }
            if (this.data.info.face === "city") {
                LogicMgr.get(logic.City).isMyCity(this.data.info.org.city_id) && ret.push("build");
                return ret;
            }

            ret.push("wbuild");  // 野外建筑
            // if (this.data.info.face === "empty") {
                ret.push("bcity");
            // }

            ret.splice(1, 0, "sweep", "mine", "giveup");
            return ret;
        }

        private refresh(): void {
            this.refreshOwner();
            this.refreshLand();
            this.refreshMonster();
        }

        private refreshOwner(): void {
            let name = "没有所属";
            let camp = "中立";
            let title = "没有所属";

            let info = LogicMgr.get(logic.World).getCellOwnerInfo(this.data.info.x, this.data.info.y);
            if (info) {
                name = info.nick;
                camp = String(info.camp);
                title = `${info.nick} (Lv${info.lv})`;
            }
            this.lbPlayerName.text = name;
            this.lbUnionName.text = camp;
            this.lbPlayerInfo.text = title;
        }

        private refreshLand(): void {
            let resData = [];
            this.lbPlantName.text = "未知";

            if (this.data.info.face === "city") {
               this.lbPlantName.text = "城镇";
            }else
            if (this.data.info.face === "empty") {
                if (this.data.info.block) {
                    this.lbPlantName.text = "障碍";
                }else {
                    let typeCfg = LogicMgr.get(logic.World).getCellTypeCfgTile(this.data.info.x, this.data.info.y);
                    this.lbPlantName.text = typeCfg ? LTEXT(typeCfg.name) : "空地";
                }
            }else
            if (this.data.info.face === "res") {
                this.lbPlantName.text = `${LTEXT(this.data.info.lcfg.name)} Lv(${this.data.info.lcfg.id_lv%1000})`;
                resData = this.getResData(this.data.info.lcfg);
            }else
            if (this.data.info.face === "block") {
                this.lbPlantName.text = "阻挡";
            }

            this.lstRes.dataProvider = new eui.ArrayCollection(resData);
        }

        private refreshMonster(): void {
            this.gpMonster.visible = false;
        }

        private getResData(landCfg: any): any[] {
            let ret = [];
            for (let v of landCfg.resource) {
                let resName = LTEXT(DBRecord.fetchKey("ResourcesConfig_json", v[0], "name")); 
                let info = {name : resName, amount : v[1]};
                ret.push(info);
            }
            return ret;
        }

        private onBuild(): void {
            let cityId = this.data.info.org.city_id;
            let cityType = DBRecord.fetchKey("CityConfig_json", this.data.info.org.city_tid, "city_type") ;
            UIMgr.open(ui.BuildCreateList, "panel", this.data.info, cityId, cityType);
            this.world.closeItem();
        }

        private onBuildWild(): void {
            let cityId = 0;
            let cityType = logic.CityType.Wild;
            UIMgr.open(ui.BuildCreateList, "panel", this.data.info, cityId, cityType);
            this.world.closeItem();
        }

        private onGoto(): void {
            this.world.closeItem();

            let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            if (armyInfo.length === 0) {
                Prompt.popTip("请先从军营中配置部队！");
                return;
            } // no army

            UIMgr.open(ArmyMove, void 0, this.data);
        }

        private onBuildCity(): void {
            // TODO 分基地, 还有联盟基地之类的待做
            let cityType = logic.CityType.SubBase;
            let param = {x : this.data.info.x, y : this.data.info.y, city_type : cityType};
            NetMgr.get(msg.City).send("m_city_create_tos", param);
            this.onClose();
        }

        private onSweep(): void {
            Prompt.popTip("功能开发中");
        }

        private onMine(): void {
            Prompt.popTip("功能开发中");
        }

        private onGiveup(): void {
            Prompt.popTip("功能开发中");
        }
    }

}