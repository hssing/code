namespace ui {

    export class SelectMenu extends UIBase {

        private static CUSTOM = {
            closeBg : {alpha : 0},
            skinName : "resource/ui/ActionMenu/SelectMenuUISkin.exml",
            binding : {},
        }

        private lstInfo: eui.List;
        private data: any;
        private world: ui.World;
        private cpos: mo.CPoint;

        public constructor(world: ui.World, cpos: mo.CPoint, data: any) {
            super(SelectMenu.CUSTOM);
            this.data = data;
            this.world = world;
            this.cpos = cpos;
        }

        protected onEnter(): void {
            super.onEnter();
            this.refresh();
        }

        private getArmyName(data: any): string {
            let name = "部队";
            let phalanx = data.forward_phalanx || data.center_phalanx || data.back_phalanx;
            if (phalanx) {
                let cfg = LogicMgr.get(logic.Camp).getSoldierCfgById(phalanx.soldiers_id);
                name = LTEXT(cfg.name);
            }
            
            return `${data.ower_info.nick}-${name}`;
        }

        private getPhalanxName(data: any): string {
            let name = "方阵";
            let cfg = LogicMgr.get(logic.Camp).getSoldierCfgById(data.soldier_type);
            name = LTEXT(cfg.name);

            return `${data.ower_info.nick}-${name}`;
        } 

        private refresh() {
            let dataList = [];

            for (let id of this.data.armys) {
                let data = LogicMgr.get(logic.World).getCellArmyById(id);
                data.name = this.getArmyName(data);
                [data.x, data.y] = [this.cpos.x, this.cpos.y];
                dataList.push(data);
            }
            for (let id of this.data.phalanxs) {
                let data = LogicMgr.get(logic.World).getCellPhalanxById(id);
                data.name = this.getPhalanxName(data);
                [data.x, data.y] = [this.cpos.x, this.cpos.y];
                dataList.push(data);
            }
      
            this.data.cell.name = this.data.cell.face;
            if (this.data.cell.face === "res") {
                this.data.cell.name = "土地";
            }else
            if (this.data.cell.face === "unit") {
                this.data.cell.name = "建筑";
            }

            dataList.push(this.data.cell);
            dataList = dataList.reverse();
            
            this.lstInfo.dataProvider = new eui.ArrayCollection(dataList);
            this.lstInfo.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.onChange, this);
        }

        private onChange(e:eui.PropertyEvent): void {
            console.log(this.lstInfo.selectedItem, this.lstInfo.selectedIndex);
            this.world.onClickMap(this.lstInfo.selectedItem, this.cpos);
            this.onClose();
        }
    }

}