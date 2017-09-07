module logic {
	export class Build extends Logic {
		
		private data: any[] = [];

		public constructor() {
			super();
		}

		public setData(data: any[]): void {
			this.data = data;
		}

		public getInfo(id): any {
			let ret = this.data.filter(v=>v.build_id === id);
			return ret[0];
		}

		public getAllArmyInfo(): any[] {
			return this.data.reduce((p, c)=>p.concat(c.army_list), []);
		}

		public getMainBuildPos(): any {
			let build = this.data[0] || {};
			return {x : build.x || 0, y : build.y || 0};
		}

		public getBuildIdByArmyId(armyId: number): number {
			for (let build of this.data) {
				for (let army of build.army_list) {
					if (army.army_id === armyId) {
						return build.build_id;
					}
				}
			}
			return undefined;
		}

		public isBuildMenu(cellInfo: any): boolean {
			if (cellInfo.info && cellInfo.info.type > 0) {
				return true;
			}
			return false;
		}

		public getConfig(type: number): any {
			let info = RES.getRes("BuildingLevelConfig_json");
			for (let k in info) {
				if (info[k].type === type) {
					return info[k];
				}
			}
			return null;
		}
	}

}