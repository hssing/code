namespace logic {
	export class Camp extends Logic {

		private mSoldierIds: number[];

        public static EVT = utils.Enum(
        [
            "SOLDIER_TOUCH_MOVE",
			"SOLDIER_TOUCH_BEGIN",
			"SOLDIER_TOUCH_END",
        ]);


		public constructor() {
			super();
		}

		public setSoldierIds(soldierIds) {
			this.mSoldierIds = soldierIds;
		}

	}
}