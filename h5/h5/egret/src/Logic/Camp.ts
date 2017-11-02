namespace logic {
	export class Camp extends Logic {

		private mSoldierIds: number[];

        public static EVT = utils.Enum(
        [
            "SOLDIER_TOUCH_MOVE",
			"SOLDIER_TOUCH_BEGIN",
			"SOLDIER_TOUCH_END",
			"SOLDIER_FORMATION",
			"EMBATTLE_END",
			"REFESH_CONSCRIPTION"
        ]);

		public constructor() {
			super();
			
			NetMgr.get(msg.Army).on("m_army_set_soldier_toc", this.Event("onArmySetSoldier"));
			NetMgr.get(msg.Army).on("m_army_enroll_soldier_toc", this.Event("onArmyEnrollSoldier"));
		}

		public setSoldierIds(soldierIds) {
			this.mSoldierIds = soldierIds;
		}

		public getSoldierIds() {
			return this.mSoldierIds;
		}

		private onArmySetSoldier(param: msg.m_army_set_soldier_toc) {
			if(param.ret_code === 1) {
				LogicMgr.get(logic.Build).setArmyInfo(param.army_list);
				this.fireEvent(logic.Camp.EVT.SOLDIER_FORMATION);
				LogicMgr.get(logic.Player).setRedif(param.redif);
			}
		}

		private onArmyEnrollSoldier(param: msg.m_army_enroll_soldier_toc) {
			if(param.ret_code === 1) {
				LogicMgr.get(logic.Player).setRedif(param.ready_soldier);
				LogicMgr.get(logic.Build).setArmyInfo(param.army_list);
				let army_enrollings = LogicMgr.get(logic.Player).getArmyEnroolInfos();
				let i: number = 0;
				for(i = 0; i < army_enrollings.length; i ++) {
					if(army_enrollings[i].building === param.army_enrolling.building) {
						army_enrollings[i] = param.army_enrolling;
					} 
				}

				if(i === army_enrollings.length) {
					army_enrollings.push(param.army_enrolling);
				}
				LogicMgr.get(logic.Player).setArmyEnrollInfos(army_enrollings);
				this.fireEvent(logic.Camp.EVT.REFESH_CONSCRIPTION);
			}
		}

        public SendMsgEmbattle(build_id: number, army_id: number, pos: number, soldier_type: string) {
			 let data: msg.m_army_set_soldier_tos = {build_id:build_id, army_id, pos:pos, soldier_type:parseInt(soldier_type)};
             NetMgr.get(msg.Army).send("m_army_set_soldier_tos", data);
        }

		public getSoldierCfgById(id: number): any {
			let cfg = DBRecord.fetchId("SoldierConfig_json", id);
			return cfg;
		}

		public getCampCfg(army_id: number): any {
			let id = LogicMgr.get(logic.Build).getBuildIdByArmyId(army_id);
			let info = LogicMgr.get(logic.Build).getInfo(id);
			let buildCfg = LogicMgr.get(logic.Build).getBuildConfig(info.type);
			let cfg = DBRecord.fetchKvs("BuildingLevelConfig_json", {type: buildCfg.type, lv:  info.lv});
			let campCfg =  DBRecord.fetchId("BuildCampConfig_json", cfg[0].id);
			return campCfg;
		}

		public getHavedPopulation(army_id: number): number{
			let armyInfos: Array<logic.ArmyInfo> = LogicMgr.get(logic.Build).getAllArmyInfo();
			let info: ArmyInfo;
			for(let i: number = 0; i < armyInfos.length; i++) {
				if(army_id === armyInfos[i].army_id) {
					info = armyInfos[i]
					break;
				}
			}
			let count = 0;
			count += this.getPhalanxPopulation(info.forward_phalanx);
			count += this.getPhalanxPopulation(info.center_phalanx);
			count += this.getPhalanxPopulation(info.back_phalanx);
			return count;
		}

		public getPhalanxPopulation(phalanx: logic.SoldierInfo): number {
			if(phalanx.soldiers_id ===0 ){
				return 0;
			}

			let cfg = this.getSoldierCfgById(phalanx.soldiers_id);
			return cfg.population * phalanx.num;
		}

		private redifUsedStatus = {
			1:{population: 0,  ratio: 0, isUseReady: false},
			2:{population: 0,  ratio: 0, isUseReady: false},
			3:{population: 0,  ratio: 0, isUseReady: false},
		};
		public setUsedRedifPopution(population: number, pos: number, isUseReady: boolean, ratio: number) {
			this.redifUsedStatus[pos].population = population;
			this.redifUsedStatus[pos].isUseReady = isUseReady;
			this.redifUsedStatus[pos].ratio = ratio;
		}

		public getUsedRedifPopulation(pos: number): number {
			return this.redifUsedStatus[pos].population;
		}

		public getEnroolInfoByBuidId(build_id: number) {
			let enroolInfos = LogicMgr.get(logic.Player).getArmyEnroolInfos();
			let infos = enroolInfos.filter((info) => {
				return build_id === info.building;
			})
			if(infos.length === 0) {
				return undefined;
			}

			return infos[0];
		}
		
		public sendMsgConscription(army_id: number) {
			let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(army_id);
			let enroolInfo = this.getEnroolInfoByBuidId(build_id);
			if(enroolInfo) {
				let sec = ServerTime.getDiffTime(enroolInfo.end_time);
				if(sec > 0) {
					Prompt.popTip("现在征兵中");
					return;
				}
			}
			let data: msg.m_army_enroll_soldier_tos = {building: build_id, army_enroll_list: [] };
			let farword_data = this.getMsgPhalanxData(PhalanxLocation.forward);
			if(farword_data) {
				data.army_enroll_list.push(farword_data);
			}
			let center_data = this.getMsgPhalanxData(PhalanxLocation.center);
			if(center_data) {
				data.army_enroll_list.push(center_data);
			}
			let back_data = this.getMsgPhalanxData(PhalanxLocation.back);
			if(back_data){
				data.army_enroll_list.push(back_data);
			}

			if(data.army_enroll_list.length === 0) {
				return;
			}

			NetMgr.get(msg.Army).send("m_army_enroll_soldier_tos", data);
	
	    	this.setUsedRedifPopution(0, logic.PhalanxLocation.forward, false, 0);
            this.setUsedRedifPopution(0, logic.PhalanxLocation.center, false, 0);
            this.setUsedRedifPopution(0, logic.PhalanxLocation.back, false, 0);
		}

		private getMsgPhalanxData(pos: number): any {
			let item =  {pos : null, enroll_num: null, use_ready: null};
			if(this.redifUsedStatus[pos].population !== 0) {
				item.pos = pos;
				item.enroll_num = this.redifUsedStatus[pos].population / this.redifUsedStatus[pos].ratio;
				item.use_ready = this.redifUsedStatus[pos].isUseReady ? 1: 0; 
				return item;
			}
			return undefined;
		}

		public getEnroolInfoByAmyId(army_id: number): logic.ArmyEnrollInfo {
			let enroolInfos =LogicMgr.get(logic.Player).getArmyEnroolInfos();
			let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(army_id);
			let infos = enroolInfos.filter((info) => {
				return build_id === info.building;
			});

			if(infos.length === 0) {
				return undefined;
			}

			return infos[0];
		}

		public setEnroolInfoByArmyId(army_id: number, enroolInfo: ArmyEnrollInfo){
			let enroolInfos =LogicMgr.get(logic.Player).getArmyEnroolInfos();
			let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(army_id);
			for(let i: number = 0; i < enroolInfos.length; i ++) {
				if(enroolInfos[i].building === build_id) {
					enroolInfos[i] = enroolInfo;
				}
			}
		}
	}
	
	export enum PhalanxLocation {
		forward = 1,
		center,
		back,
	}
}