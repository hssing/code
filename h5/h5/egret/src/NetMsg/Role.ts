namespace msg {

	export class Role extends NetMsg {

		public modId: number = 190;
		public subIds = 
		{
			0 : "m_role_assets_toc",
		};

		public on(name: "m_role_assets_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: string, obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_role_assets_toc = {p_res: {stone?: number, soil_base?: number, ingot?: number, redif?: number, steel_base?: number, stone_base?: number, cereals_base?: number, steel?: number, cereals?: number, energy?: number, soil?: number, coin?: number, }, };


}