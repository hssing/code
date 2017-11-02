module ui {
	export class BagMain extends ResBase {
		
		private bagGroup: eui.Group;
		private extendList: ExtendList;
		private extendRow: number; //记录extendList中扩展项在哪一行 
		private column: number; //为ExtendList一行中正常项中按下的位置
		private currentType: number;

        private static CUSTOM = {
            closeBg : { alpha : 0, },
			resGroup : ["bag"],
            skinName : "resource/ui/Bag/BagMainUISkin.exml",
            binding : {
                ["btnClose"] : { method : "onBtnClose", },
                ["btnGoods"] : {method : "onBtnGoods", },
                ["btnResource"] : {method : "onBtnResource",}, 
                ["btnEquip"] : {method : "onBtnEquip",},
                ["btnEnhance"] : {method : "onBtnEnhance",},
				["btnFragment"] : {method : "onBtnFragment",},
            },
        }

		public constructor() {
			super(BagMain.CUSTOM);
		}

		protected onEnter() {
			super.onEnter();
			
			this.extendRow = -1;
			this.column = -1;
			this.currentType = ResourceType.Resouce;

			this.initList();
			
			LogicMgr.get(logic.Bag).on(logic.Bag.EVT.ITEM_CLICKED, this.Event("onItemClicked"));
			LogicMgr.get(logic.Bag).on(logic.Bag.EVT.REFRESH_BAG_DATA, this.Event("onRefreshBagData"));
			LogicMgr.get(logic.Bag).on(logic.Bag.EVT.REMOVE_EXTENDITEM, this.Event("onRemoveExtendItem"));
		}

		private onRefreshBagData() {
			let items = this.getItems(this.currentType);
			this.extendList.setItems(items);
		}

		private initList() {
			this.extendList = new ExtendList();
			this.extendList.width = this.bagGroup.width;
			this.extendList.height = this.bagGroup.height;
			this.bagGroup.addChild(this.extendList);
			let items = this.getItems(this.currentType);
			this.extendList.setItems(items);
		}

		private getItems(type: number): any[] {
			let bagGoods: logic.BagGood[] = LogicMgr.get(logic.Bag).getBagDataById(1);
			if(!bagGoods) {
				return;
			}

			let datas = bagGoods.filter((info) => {
				let cfg = DBRecord.fetchId("GoodsConfig_json", info.type);
				return cfg.type === type;
			});

			let items: Array<any> = new Array<any>();
			for(let i: number = 0; i < datas.length; i = i + 4) {
				let item = new ui.PropExtendListItem();
				let data1 = this.getData(datas[i], Math.ceil(i / 4), 1); 
				let data2 = this.getData(datas[i + 1], Math.ceil(i / 4), 2); 
				let data3 = this.getData(datas[i + 2], Math.ceil(i / 4), 3); 
				let data4 = this.getData(datas[i + 3], Math.ceil(i / 4), 4); 
				item.data = [data1, data2, data3, data4];
				items.push(item);
			}
			return items;
		}

		private getData(data, row: number,  column: number) {
			if(!data) {
				return undefined;
			}

			let table = DBRecord.fetchKey("GoodsConfig_json", data.type, "child_table");
			table = table + "Config_json";
			return {info: data, cfg: DBRecord.fetchId(table, data.tid), row: row, column: column};
		}

		private onBtnClose() {
			this.removeFromParent();
		}

		private onBtnGoods() {
			this.changeType(ResourceType.Other)
		}

		private onBtnResource() {
			this.changeType(ResourceType.Resouce);
		}

		private onBtnEquip() {
			this.changeType(ResourceType.Equipment);
		}

		private onBtnEnhance() {
			this.changeType(ResourceType.Enhance);
		}

		private onBtnFragment() {
			this.changeType(ResourceType.Fragment);
		}

		private changeType(type: number) {
			let items = this.getItems(type);
			this.extendList.setItems(items);
			this.currentType = type;
			this.extendRow = -1;
			this.column = -1;
		}

		private onItemClicked(data) {
			let item = this.getExtendItem(data);
			if(this.extendRow == (data.row + 1)) {
				if(this.column == data.column) {
					this.extendList.removeItem(this.extendRow);
					this.extendRow = -1;
					this.column = -1;
				} else {
					this.extendList.updateDataItem(this.extendRow, data);
				}
				this.column = data.column;
			} else {
				if(this.extendRow != -1) {
					this.extendList.removeItem(this.extendRow);
				}

				this.extendRow = data.row + 1;
				this.column = data.column;
				this.extendList.insertItem(item, data.row + 1);
			}
		}

		private getExtendItem(data: any): any {
			let item = null;
			if(this.currentType === GoodsType.Equip) {
				
			} else {
				item = new PropInformation();
				item.data = data;
			}

			return item;
		}

		private onRemoveExtendItem() {
			if(this.extendRow === -1) {
				return;
			}

			this.extendList.removeItem(this.extendRow);
			this.extendRow = -1;
			this.column = -1;
		}
	}

	 enum ResourceType { //这个对应显示的五个按钮
		Resouce = 1,
		Equipment = 2,
		Enhance = 3,
		Fragment = 4,
		Other = 5,	
	}

	export enum GoodsType { //这个对应GoodsConfig.json里面的id
		Resource = 1,
		Equip = 2,
		YieldIncrease = 3,
		TimeAcceleration = 4,
		Buff = 5,
		Sundries = 6,
		Package = 7,
	}
}