namespace msg {

	export class Map extends NetMsg {

		public modId: number = 120;
		public subIds = 
		{
			0 : "m_map_get_view_obj_tos",
			1 : "m_map_sight_toc",
			2 : "m_map_sight_leave_toc",
			3 : "m_map_sight_enter_toc",
			6 : "m_map_obj_move_info_toc",
		};

		public on(name: "m_map_sight_toc"|"m_map_sight_leave_toc"|"m_map_sight_enter_toc"|"m_map_obj_move_info_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_map_get_view_obj_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

}