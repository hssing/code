module logic {

	type CITY_LIST = msg.m_build_get_build_list_toc["city_list"];
	export class City extends Logic {

        private cityInfos: CITY_LIST;

		public constructor() {
            super();
			NetMgr.get(msg.City).on("m_city_create_toc", this.Event("onCreateCity"));
		}

        public setData(data: any[]): void {
			this.cityInfos = data;
		}

		public getCityList(): CITY_LIST {
			return this.cityInfos;
		}

		public getMainCityPos(): {x, y} {
			let v = this.cityInfos[0];
			return {x : v ? v.x : 0, y : v ? v.y : 0};
		}

		public isMyCity(cityId: number): boolean {
			for (let v of this.cityInfos) {
                if (v.id === cityId) {
                    return true;
                }
			}
			return false;
		}

		private onCreateCity(): void {
			LogicMgr.get(logic.Login).getBuildGuildList();
		}
    }

	export const enum CityType {
		MainBase = 1,   //主基地建筑
		SubBase,		//分基地建筑
		LowUnion,		//低级联盟基地建筑
		HeighUnion,		//高级联盟基地建筑
		Center,			//中央基地建筑
		Wild, 			//野外可建建筑
	}
}