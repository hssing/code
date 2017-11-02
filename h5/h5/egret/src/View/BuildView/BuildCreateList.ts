module ui {

	export class BuildCreateList extends UIBase {

		private buildList: eui.List;
		private buildBaseData: any[];
		private info: any;
		private cityType: number;
		private cityId: number;

		private static CUSTOM = {
			closeBg : {alpha: 0.5, disable: false},
			resGroup : ["buildList"],
			skinName : "resource/ui/BuildUISkins/BuildCreateListUISkin.exml",
			binding : {
                ["btnFunction"] : { method : "onBtnFunction", },
                ["btnDefense"] : { method : "onBtnDefense",}, 
                ["btnResource"] : { method : "onBtnResource",},
                ["btnClose"] : { method : "onBtnClose" ,},
            },
        }

		public constructor(info, cityId: number, cityType: number) {
			super(BuildCreateList.CUSTOM);
			this.info = info;
			this.cityId = cityId;
			this.cityType = cityType;
		}

		protected onEnter(): void {
			super.onEnter();
			this.buildBaseData = DBRecord.fetchAll("BuildConfig_json");
			this.buildBaseData = this.buildBaseData.filter((info) => {
				let ret = info.type !== logic.BuildType.CommandCenter;
				if (this.cityType) {
					ret = ret && this.cityType === info.city_type;
				}
				return ret;
			});

			this.initBuildList();
		}

		private initBuildList() {
			let data = this.getDataByType(BuildClass.FUNCTION);
			this.buildList.dataProvider = new eui.ArrayCollection(data);
			this.buildList.addEventListener(egret.TouchEvent.CHANGE, this.onChange, this);
		}

        protected getDataByType(buildClass) {
            let data = [];
            for(let i: number = 0; i < this.buildBaseData.length; i ++ ) {
                if(buildClass !== this.buildBaseData[i].class) {
                    continue;
                }

                let item = {
							"id":null,
							"img": "camp_pic_fuyong_s1_png",
							"name": null, 
                            "describe": null, 
                            "condition": "condition", 
							"type": null,
							"create_status": null,
							"canCreateCommandLv": null,
							"count": null,
                        };
				let conditios = LogicMgr.get(logic.Build).getCreateConditionById(this.buildBaseData[i].id);
				let count = LogicMgr.get(logic.Build).getCountByBuildId(this.buildBaseData[i].id, this.cityId);
				let commandLv = LogicMgr.get(logic.Build).getCommandCenterLevel(this.cityId);
				let [canBuild, condition] = this.getCreateStatus(conditios, commandLv);
				if(canBuild && count < condition[1]) {
					item.create_status = true;
					item.condition = utils.format("可以建造，数量:%d", condition[1] - count);
				} else {
					item.create_status = false;
					item.condition = utils.format("不可建造，已达最大上限");
				}
				if(!canBuild && condition) {
					item.condition = utils.format("指挥中心等级达到LV(%d)建筑数量+%d", condition[0], condition[1]);
				}

				let info = this.buildBaseData[i];
				item.img = LogicMgr.get(logic.Build).getBuildingFacade(info.type, 1);
				item.id = this.buildBaseData[i].id;
				item.type = this.buildBaseData[i].type;
				let name = this.buildBaseData[i].name;
				item.name = LTEXT(name);
				item.describe = LTEXT(this.buildBaseData[i].describe);
                data.push(item);
            }  

            return data;
        }

		private getCreateStatus(conditios: any[], commandLv: number): any[] {
			let temp: any[] = utils.deepCopy(conditios);
			temp.sort((a, b)=> {
				return a[0] - b[0];
			})

			// 配置，返回最大值
			let rest1 = temp.filter(v => v[0] <= commandLv);
			if (rest1.length > 0) {
				return [true, rest1.pop()];
			}

			// 下一等级提示
			let rest2 = temp.filter(v => v[0] > commandLv);
			return [false, rest2[0]];
		}	

		protected onBtnFunction() {
			let data = this.getDataByType(BuildClass.FUNCTION);
			this.buildList.dataProvider = new eui.ArrayCollection(data);
		}

		protected onBtnDefense() {
			let data = this.getDataByType(BuildClass.DEFENSE);
			this.buildList.dataProvider = new eui.ArrayCollection(data);
		}

		protected onBtnResource() {
			let data = this.getDataByType(BuildClass.RESOURCE);
			this.buildList.dataProvider = new eui.ArrayCollection(data);
		}

		protected onBtnClose() {
			this.removeFromParent()
		}

		public onChange(e:eui.PropertyEvent) {
			if(this.buildList.selectedItem.create_status === false) {
				Prompt.popTip("请升级指挥中心");
				return;
			}
			let id = this.buildList.selectedItem.id;
			LogicMgr.get(logic.Build).createBuilding(parseInt(id), this.info.x, this.info.y);
			this.removeFromParent();
        }
	}

	enum BuildClass {
		FUNCTION = 1, 	//功能建筑
		DEFENSE = 2,	//防御建筑
		RESOURCE = 3,	//资源建筑
	}
}