namespace logic {
	export class Soldier extends Logic {

		private mSoldierIds: number[];
        public static EVT = utils.Enum(
        [
            // "SOLDIER_TOUCH_MOVE",
			// "SOLDIER_TOUCH_BEGIN",
			// "SOLDIER_TOUCH_END",
			// "SOLDIER_FORMATION",
			"SOLIDER_INFOR",
			"SOLIDER_INTENSIFY",
			"SOLIDER_INTENSIFY_EXECUTE",
        ]);

		public constructor() {
			super();
			NetMgr.get(msg.Army).on("m_get_soldier_info_toc", this.Event("onSoldierInfo"));
			NetMgr.get(msg.Army).on("m_get_soldier_intensify_info_toc", this.Event("m_get_soldier_intensify_info_toc"));
			NetMgr.get(msg.Army).on("m_intensify_soldier_toc", this.Event("m_intensify_soldier_toc"));
			
		}

		public setSoldierIds(soldierIds) {
			this.mSoldierIds = soldierIds;
		}

        public getSoldierInfo(id: any): void {
			let _id = parseInt(id);
            NetMgr.get(msg.Army).send("m_get_soldier_info_tos", {soldier_id:_id});
			
        }		

		private onSoldierInfo(param) {
		   this.fireEvent(Soldier.EVT.SOLIDER_INFOR, param);
        }

		public m_get_soldier_intensify_info_tos (id: any) {
			let _id = parseInt(id);
			NetMgr.get(msg.Army).send("m_get_soldier_intensify_info_tos", {soldier_id:_id});
		}

		// 兵牌强化信息
		private m_get_soldier_intensify_info_toc (param) {
			this.fireEvent(Soldier.EVT.SOLIDER_INTENSIFY, param);
		}

		//强化兵牌
		public m_intensify_soldier_tos (id: any) {
			let _id = parseInt(id);
			NetMgr.get(msg.Army).send("m_intensify_soldier_tos", {soldier_id:_id});
		}

		// 兵牌强化信息
		private m_intensify_soldier_toc (param) {
			this.fireEvent(Soldier.EVT.SOLIDER_INTENSIFY_EXECUTE, param);
		}


	}
}