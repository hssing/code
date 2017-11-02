module ui {
	export class CommandCenterFunc extends ResBase {

		private resList: eui.List;

        private static CUSTOM = {
			closeBg : {alpha: 0.5, disable: false},
            skinName : "resource/ui/BuildUISkins/CommandCenterFuntionUISkin.exml",
			resGroup : ["commandCenter"],
            binding : {
                ["btnClose"] : { method : "onBtnClose", },
				["btnBaseBuild"] : { method : "onBtnBaseBuild" },
				["btnSpecialEffect"] : { method: "onBtnSpecialEffect"},
            },
        }
		
		public constructor() {
			super(CommandCenterFunc.CUSTOM);
		}

		public onEnter() {
			super.onEnter();
			this.setBaseBuild();
		}

		private setBaseBuild() {
			let data = this.getResData();
			this.resList.itemRenderer = ui.CommandCenterItem;
			this.resList.dataProvider = new eui.ArrayCollection(data);
		}

		private setSpecialEffect() {
			this.resList.itemRenderer = null;
			this.resList.dataProvider = null;
		}

		private getResData() {
			let data = [];
			let listData =  this.resList.dataProvider.getItemAt(0);
			let item1 = this.getResItemData(logic.ResTypeId.Cereal, listData.capacityName, listData.productionName);
			listData = this.resList.dataProvider.getItemAt(1);
			let item2 = this.getResItemData(logic.ResTypeId.Steel, listData.capacityName, listData.productionName);
			listData = this.resList.dataProvider.getItemAt(2);
			let item3 = this.getResItemData(logic.ResTypeId.Stone, listData.capacityName, listData.productionName);
			listData = this.resList.dataProvider.getItemAt(3);
			let item4 = this.getResItemData(logic.ResTypeId.Soil, listData.capacityName, listData.productionName);
			listData = this.resList.dataProvider.getItemAt(4);
			let item5 = this.getResItemData(logic.ResTypeId.Redif, listData.capacityName, listData.productionName);
			listData = this.resList.dataProvider.getItemAt(5);
			let item6 = this.getGoldItemData(listData.capacityName, listData.productionName);
			data.push(item1);
			data.push(item2);
			data.push(item3);
			data.push(item4);
			data.push(item5);
			data.push(item6);
			return data;
		}

		private getGoldItemData(productionName, capacityName) {
			let item = { type:null, img: null, 
				production: null, capacity: null, 
				surplusCount: null, allCount: null, 
				productionName: null, capacityName: null,
				coolingTime: null};
			item.img = LogicMgr.get(logic.Build).getResImgByResType(logic.ResTypeId.Coin);
			let production = LogicMgr.get(logic.Player).getCoinProduction();
			item.type = logic.ResTypeId.Coin;
			item.production =  production;
			item.productionName = productionName;
			item.capacityName = capacityName;
			return item
		}

		private getResItemData(id: number, capacityName, productionName) {
			let item = { type:null, img: null, 
				production: null, capacity: null, 
				surplusCount: null, allCount: null, 
				productionName: null, capacityName: null,
				coolingTime: null};
			item.img = LogicMgr.get(logic.Build).getResImgByResType(id);
			item.type = id;
			item.productionName = productionName;
			item.capacityName = capacityName;
			item.production = LogicMgr.get(logic.Player).getResProductionByResId(id);
			item.capacity = LogicMgr.get(logic.Player).getResCapacityByResId(id);
			return item
		}

		private onBtnBaseBuild() {
			this.setBaseBuild();
		}

		private onBtnSpecialEffect() {
			this.setSpecialEffect();
		}

		private onBtnClose() {
			this.removeFromParent();
		}
	}
}