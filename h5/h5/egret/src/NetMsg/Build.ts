namespace msg {

	export class Build extends NetMsg {

		public modId: number = 130;
		public subIds = 
		{
			0 : "m_build_get_build_list_tos",
			1 : "m_build_get_build_list_toc",
			2 : "m_build_go_to_battle_tos",
			3 : "m_build_go_to_battle_toc",
		};

		public on(name: "m_build_get_build_list_toc"|"m_build_go_to_battle_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_build_get_build_list_tos"|"m_build_go_to_battle_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

}