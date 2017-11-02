namespace ui {

    export class BuildQueue extends UIBase {

        private static CUSTOM = {
            closeBg : {alpha : 0},
            skinName : "resource/ui/BuildQueue/BuildQueueUISkin.exml",
            binding : {},
        }

        private lstInfo: eui.List;

        public constructor() {
            super(BuildQueue.CUSTOM);
        }

        protected onEnter(): void {
            super.onEnter();
            this.refresh();
        }

        private refresh() {
            let citys = LogicMgr.get(logic.City).getCityList();
            let dataList = [];
            for (let v of citys) {
                dataList.push({name : `${v.id} - ${v.x}:${v.y}`, x : v.x, y : v.y, id : v.id});
            }
            dataList.sort((a, b)=> a.id - b.id);
            
            this.lstInfo.dataProvider = new eui.ArrayCollection(dataList);
            this.lstInfo.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.onChange, this);
        }

        private onChange(e:eui.PropertyEvent): void {
            this.onClose();
            let pt = {x : this.lstInfo.selectedItem.x, y : this.lstInfo.selectedItem.y};
            UIMgr.getWorld().onLocation(pt);
        }
    }

}