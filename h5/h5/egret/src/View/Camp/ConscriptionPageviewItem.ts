module ui {
	export class ConscriptionPageviewItem extends IRBase {

		private conscriptionList: eui.List;

		private static CUSTOM = {
            skinName : "resource/ui/Camp/CampConscriptionPageViewItemUISkin.exml",
        }

		public constructor() {
			super(ConscriptionPageviewItem.CUSTOM);
		}

		public onEnter() {
			super.onEnter();
			this.conscriptionList.itemRenderer = ui.ConscriptionListInfoItem;
		}

		protected dataChanged(): void { 
			let armyInfo = this.data.armyInfo as logic.ArmyInfo;
			let data = this.getData(armyInfo);
			this.refeshData(data);
		}

        private refeshData(data: any[]) {
            this.conscriptionList.dataProvider = new eui.ArrayCollection(data);
        }

        protected getData(armyInfo: logic.ArmyInfo) {
            let data = [];
			data.push(this.getItem(armyInfo.forward_phalanx, "前军部队", armyInfo.army_id, logic.PhalanxLocation.forward));
			data.push(this.getItem(armyInfo.center_phalanx, "中军部队", armyInfo.army_id, logic.PhalanxLocation.center));
			data.push(this.getItem(armyInfo.back_phalanx, "后军部队", armyInfo.army_id, logic.PhalanxLocation.back));
            return data;
        }

		private getItem(soldierInfo: logic.SoldierInfo, name: string, army_id:number, pos: number) {
			let item = {soldierInfo: soldierInfo, name: name, army_id: army_id, pos: pos}
			return item;
		}

	}
}