module logic {

		// 后端定义的建筑状态
		enum STATE {
			BUILDING_SELF_STATE_NORMAL,
			BUILDING_SELF_STATE_DESTROY,
			BUILDING_SELF_STATE_DAMAGE,
		};

		// BuildingLevelConfig 字段
		const FACASE = {
			[STATE.BUILDING_SELF_STATE_NORMAL]  : "normal_model",
			[STATE.BUILDING_SELF_STATE_DESTROY] : "destroy_model",
			[STATE.BUILDING_SELF_STATE_DAMAGE]  : "damage_model",
		};

	export class Build extends Logic {
		
		private buildInfos: Array<BuildBaseInfo>;

        public static EVT = utils.Enum([
            "BUY_TAX",
            "USE_TAX",
			"REFRESH",
        ]);

		public constructor() {
			super();
            NetMgr.get(msg.Build).on("m_build_create_building_toc", this.Event("onCreateBuilding"));
			NetMgr.get(msg.Build).on("m_build_upgrade_building_toc", this.Event("onUpgradeBuilding"));
			NetMgr.get(msg.Build).on("m_build_repair_building_toc", this.Event("onRepairBuilding"));
			NetMgr.get(msg.Build).on("m_build_remove_building_toc", this.Event("onRemoveBuilding"));
			NetMgr.get(msg.Build).on("m_build_move_building_toc", this.Event("onMoveBuilding"));
			NetMgr.get(msg.Build).on("m_build_rebuild_building_toc", this.Event("onRebuildBuilding"));
			NetMgr.get(msg.Build).on("m_build_push_building_toc", this.Event("onUpdateBuilding"));
			NetMgr.get(msg.Base).on("m_base_tax_toc", this.Event("onBaseTax"));
			NetMgr.get(msg.Base).on("m_base_tax_buy_count_toc", this.Event("onBaseTaxBuyCount"));
			this.buildInfos = new Array<BuildBaseInfo>();
		}

		public getBuildingFacade(buildId: number, lv = 1, buildState = 0): string {
			let facase = DBRecord.fetchKvs("BuildingLevelConfig_json", {type: buildId, lv: lv});
			let normal = FACASE[STATE.BUILDING_SELF_STATE_NORMAL];
			let key = FACASE[buildState] || normal;  //key容错
			//value为空，尝试取normal的value，都为空则取默认字符串
			return facase && (facase[key] || facase[normal]) || "yinbenzhongxin_png";
		}

        public createBuilding(id: number, x: number, y: number): void {
			let cellInfo = LogicMgr.get(logic.World).getCellInfo(x, y);
			let cityId = 0;
			if (cellInfo.face === "city") {
				cityId = cellInfo.org.city_id;
			}

            NetMgr.get(msg.Build).send("m_build_create_building_tos", {id, x, y, city_id : cityId});
        }

        private onCreateBuilding(data: any): void {
			this.buildInfos.push(data.build_info);
			LogicMgr.get(logic.World).createUnit(data.map_build_info);
			LogicMgr.get(logic.World).updateSight();
        }

		public rebuildBuilding(id: number): void {
            NetMgr.get(msg.Build).send("m_build_rebuild_building_tos", {building_id : id});
		}

		private onRebuildBuilding(data: msg.m_build_rebuild_building_toc): void {
			this.updateBuilding(data.build_info);
			LogicMgr.get(logic.World).updateUnitData([data.map_build_info]);
			LogicMgr.get(logic.World).updateSight();
        }

		public upgradeBuilding(id: number): void {
            NetMgr.get(msg.Build).send("m_build_upgrade_building_tos", {building_id : id});
		}

		private onUpgradeBuilding(data: any): void {
			this.updateBuilding(data.build_info);
			LogicMgr.get(logic.World).updateUnitData([data.map_build_info]);
			LogicMgr.get(logic.World).updateSight();
        }

		public repairBuilding(id: number): void {
            NetMgr.get(msg.Build).send("m_build_repair_building_tos", {building_id : id});
		}

		private onRepairBuilding(data: any): void {
			this.updateBuilding(data.build_info);
			LogicMgr.get(logic.World).updateUnitData([data.map_build_info]);
			LogicMgr.get(logic.World).updateSight();
        }

		public removeBuilding(id: number): void {
            NetMgr.get(msg.Build).send("m_build_remove_building_tos", {building_id : id});
		}

		private onRemoveBuilding(data: any): void {
			let buildInfo = data.build_info;
			for (let i = this.buildInfos.length - 1; i >= 0; i--) {
				let v = this.buildInfos[i];
				if (buildInfo.build_id === v.build_id) {
					this.buildInfos.splice(i, 1);
					break;
				}
			}
			LogicMgr.get(logic.World).removeUnitById(buildInfo.build_id);
			LogicMgr.get(logic.World).updateSight();
        }

		public moveBuilding(id: number, x: number, y: number): void {
            NetMgr.get(msg.Build).send("m_build_move_building_tos", {building_id : id, x, y});
        }

		private onMoveBuilding(data: any): void {
			for (let v of data.build_info) {
				this.updateBuilding(v);
			}
		}

		private onUpdateBuilding(data: any): void {
			for (let v of data.build_info_list) {
				this.updateBuilding(v);
			}
		}

		private updateBuilding(buildInfo: any): void {
			for (let i = this.buildInfos.length - 1; i >= 0; i--) {
				let v = this.buildInfos[i];
				if (buildInfo.build_id === v.build_id) {
					this.buildInfos[i] = buildInfo;
					this.fireEvent(Build.EVT.REFRESH, buildInfo.build_id);
					break;
				}
			}
		}

		public canTurn(id: number): boolean {
			let info = this.getInfo(id);
			if (!info) { return false; }

			let cfg = this.getBuildConfig(info.type);
			return cfg.turn === 1;
		}

		public getOpts(id: number): string[] {
			let info = this.getInfo(id);
			if (!info) { return []; }

			let cfg = this.getBuildConfig(info.type);
			let ret = ["info"];
			if (info.opt_state !== msgEnum.BUILDING_STATE_NORMAL) {
				ret.push("complete");
				return ret;
			}

			if (cfg.dismantle === 1) {
				ret.push("remove");
			}

			if (cfg.move === 1) {
				ret.push("move");
			}

			if(cfg.function ===1) {
				ret.push("func");
			}

			if (cfg.upgrade === 1 && info.durability === info.durability_limit) {
				if (cfg.level_limit > info.lv) {
					ret.push("upgrade");
				}
			}else
			if (cfg.damage === 1 && info.build_state === STATE.BUILDING_SELF_STATE_DESTROY) {
				ret.push("reform");
			}else
			if (cfg.damage === 1 && info.build_state === STATE.BUILDING_SELF_STATE_DAMAGE) {
				ret.push("repair");
			}
			return ret.reverse();
		}

		public setData(data: any[]): void {
			this.buildInfos = data;
		}

		public getInfo(id): BuildBaseInfo {
			let ret = this.buildInfos.filter(v=>v.build_id === id);
			return ret[0];
		}

		public getAllArmyInfo(): any[] {
			return this.buildInfos.reduce((p, c)=>p.concat(c.army_list), []);
		}

		public getBuildIdByArmyId(armyId: number): number {
			for (let build of this.buildInfos) {
				for (let army of build.army_list) {
					if (army.army_id === armyId) {
						return build.build_id;
					}
				}
			}
			return undefined;
		}

		public setArmyInfo(army_list) {
			for(let build of this.buildInfos) {
				for(let army of build.army_list) {
					if(army.army_id === army_list[0].army_id) {
						build.army_list = army_list;
					}
				}
			}
		}

		public isBuildMenu(cellInfo: any): boolean {
			if (cellInfo.info && cellInfo.info.type > 0) {
				return true;
			}
			return false;
		}

		public getBuildConfig(id: number): any {
			return DBRecord.fetchId("BuildConfig_json", id);
		}

		public getCommandCenterLevel(cityId: number): number {
			for (let info of this.buildInfos) {
				let type = DBRecord.fetchKey("BuildConfig_json", info.type, "type");
				if(info.type === type && info.city_id === cityId) {
					return info.lv;
				}
			}
			return 1;  //至少1级，用于解锁条件的判断
		}
		
		public getCountByBuildId(id: number, cityId: number) {
			let infos = this.buildInfos.filter((info) => {
				return (info.type === id) && (cityId === info.city_id);
			});

			return infos.length;
		}

		public getCreateConditionById(id: string) {
			return DBRecord.fetchKey("BuildConfig_json", id, "unlock");
		}

		public getResImgByResType(type: number) {
			let icon_square = DBRecord.fetchKey("ResourcesConfig_json", type, "icon");
			return icon_square;
		}

		private onBaseTax(data: msg.m_base_tax_toc) {
			if(data.ret_code === 1) {
				LogicMgr.get(logic.Player).setBaseTax(data.base_tax);
			} 
		}

		public useBaseTax() {
			NetMgr.get(msg.Base).send("m_base_tax_tos");
		}

		private onBaseTaxBuyCount(data: msg.m_base_tax_buy_count_toc) {
			if(data.ret_code ===1) {
				LogicMgr.get(logic.Player).setBaseTax(data.base_tax);
			}
		}

		public buyTax() {
			NetMgr.get(msg.Base).send("m_base_tax_buy_count_tos");
		}

		public getTaxUpLimit(): number {
			return DBRecord.fetchKey("SystemConfig_json", "taxation_times", "value")
		}

		public getCurTaxCount(): number {
			let baseTax = LogicMgr.get(logic.Player).getBaseTax();
			if(!baseTax) {
				return 0;
			}
			let upLimit = this.getTaxUpLimit();
			let count = upLimit + baseTax.today_buy_count - baseTax.today_tax_count - baseTax.buy_count_used; 
			return count;
		}

		public getBuildUpgradeCondition(type: number, lv: number) {
			let data = {type: type, lv: lv + 1};
			let buildConfigs = DBRecord.fetchKvs("BuildingLevelConfig_json", data);
			return buildConfigs[0].upgrade_condition;
		}

		public getNameById(id: number): string {
			let nameId = DBRecord.fetchKey("BuildConfig_json", id, "name");
			return LTEXT(nameId);
		}

		public getUsedIngotToBuyTaxTime(time: number): number {
			let taxation_spends = DBRecord.fetchKey("SystemConfig_json", "taxation_spend", "value")
			let taxation_additional_times = this.getBuyUpLimitTax();
			if(time > taxation_additional_times) {
				time = taxation_additional_times;
			}
			return taxation_spends[time -1];
		}

		public getBuyUpLimitTax(): number {
			let taxation_additional_times = DBRecord.fetchKey("SystemConfig_json", "taxation_additional_times", "value");
			return taxation_additional_times;
		}

		public getUnlockBuildNextLVCommandCenter(cityId: number) {
			let lv = this.getCommandCenterLevel(cityId);
			lv = lv + 1;
			let unLockData = [];
			let buildConfigs = DBRecord.fetchAll("BuildConfig_json");
			for(let i: number = 0; i < buildConfigs.length; i ++) {
				let item = {"buildType": null, "addCount": null, "isFirstCreate": null, "buildName": null};
				let unlocks = buildConfigs[i].unlock;
				for(let j = 0; j < unlocks.length; j ++) {
					if(unlocks[j][0] !== lv) {
						continue;
					}

					if(j === 0) {
						item.addCount = unlocks[j][1];
						item.isFirstCreate = true;
					} else {
						item.addCount = unlocks[j][1] - unlocks[j -1][1]
						item.isFirstCreate = false;
					}
					
					item.buildType = buildConfigs[i].type;
					item.buildName = LTEXT(buildConfigs[i].name); 
					unLockData.push(item);
					break;
				}
			}
			return unLockData;
		}
	}

	export class BuildBaseInfo {
		public x: number;				 // 坐标点x
		public y: number;                // 坐标点y
		public end_time: number;         // 操作结束时间
		public start_time: number        // 操作开始时间间
		public lv: number;               // 等级
		public opt_state: number;        // 操作状态
		public type: number;             // 建筑类型
		public build_id: number;         // 建筑id
		public durability: number;       // 耐久度
		public durability_limit: number; // 耐久上限
		public army_list: ArmyInfo[];    // 部队列表
		public city_id: number;          //城池id
		public build_state: number;      //建筑状态
	}

	export class ArmyInfo {
		public army_id: number;               //部队id
		public forward_phalanx: SoldierInfo ; //前锋部队
		public center_phalanx: SoldierInfo;   //中锋部队
		public back_phalanx: SoldierInfo;     //后卫部队
		public is_out: number;                // 是否已经出战
	}

	// 士兵信息
	export class SoldierInfo {
		public soldiers_id: number;  // 士兵id
		public hp: number;           //当前血量
		public max_hp: number;       //最大血量
		public num: number;
	}

	export const enum BuildType { 
		CommandCenter = 1,         //指挥中心类型
		Camp,                  	   //军营
		ScientificInstitute,       //科研所
		ArmyScientificInstitute,   //军事研究所
		Warehouse,                 //仓库
		AdvancedStorehouse,        //高级仓库
		Barracks,              	   //兵营
		MissileLaunchCenter,       //导弹发射中心
		Radar,	                   //雷达
		Residence,                 //民居 
		Cropland,                  //农田
		Steelworks,				   //钢铁厂
		Stonm, 				   	   //石矿
		Refinery,                  //提炼厂
	}
}
