namespace msg {

	export class Map extends NetMsg {

		public modId: number = 120;
		public subIds = 
		{
			0 : "m_map_get_view_obj_tos",
			1 : "m_map_sight_toc",
			2 : "m_map_sight_leave_toc",
			3 : "m_map_sight_enter_toc",
			4 : "m_map_separate_to_phalanx_toc",
			5 : "m_map_phalanx_gather_to_army_toc",
			6 : "m_map_obj_move_info_toc",
		};

		public on(name: "m_map_sight_toc"|"m_map_sight_leave_toc"|"m_map_sight_enter_toc"|"m_map_separate_to_phalanx_toc"|"m_map_phalanx_gather_to_army_toc"|"m_map_obj_move_info_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_map_get_view_obj_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_map_get_view_obj_tos = {point: {y: number, z: number, x: number, }, height: number, width: number, };

	export type m_map_sight_toc = {city_list: {city_tid: number, city_id: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, y: number, type: number, x: number, }[], phalanx_list: {hp: number, end_point: {y: number, z: number, x: number, }, max_hp: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, soldier_type: number, status: number, army_id: number, soldier_num: number, move_path: {y: number, z: number, x: number, }[], id: number, }[], build_list: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }[], block_list: {y: number, block_id: number, block_tid: number, x: number, }[], ornament_list: {y: number, ornament_id: number, ornament_tid: number, x: number, }[], army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, target_point: {y: number, z: number, x: number, }, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, status: number, army_id: number, move_path: {y: number, z: number, x: number, }[], }[], };

	export type m_map_sight_leave_toc = {building_id: number[], city_id: number[], amy_id: number[], phalanx_id: number[], block_id: number[], ornament_id: number[], };

	export type m_map_sight_enter_toc = {city_list: {city_tid: number, city_id: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, y: number, type: number, x: number, }[], phalanx_list: {hp: number, end_point: {y: number, z: number, x: number, }, max_hp: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, soldier_type: number, status: number, army_id: number, soldier_num: number, move_path: {y: number, z: number, x: number, }[], id: number, }[], build_list: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }[], block_list: {y: number, block_id: number, block_tid: number, x: number, }[], ornament_list: {y: number, ornament_id: number, ornament_tid: number, x: number, }[], army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, target_point: {y: number, z: number, x: number, }, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, status: number, army_id: number, move_path: {y: number, z: number, x: number, }[], }[], };

	export type m_map_separate_to_phalanx_toc = {amy_id: number, center_phalanx: {hp: number, end_point: {y: number, z: number, x: number, }, max_hp: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, soldier_type: number, status: number, army_id: number, soldier_num: number, move_path: {y: number, z: number, x: number, }[], id: number, }, forward_phalanx: {hp: number, end_point: {y: number, z: number, x: number, }, max_hp: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, soldier_type: number, status: number, army_id: number, soldier_num: number, move_path: {y: number, z: number, x: number, }[], id: number, }, back_phalanx: {hp: number, end_point: {y: number, z: number, x: number, }, max_hp: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, soldier_type: number, status: number, army_id: number, soldier_num: number, move_path: {y: number, z: number, x: number, }[], id: number, }, };

	export type m_map_phalanx_gather_to_army_toc = {army: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, target_point: {y: number, z: number, x: number, }, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, cur_point: {y: number, z: number, x: number, }, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, status: number, army_id: number, move_path: {y: number, z: number, x: number, }[], }, center_phalanx_id: number, forward_phalanx_id: number, back_phalanx_id: number, };

	export type m_map_obj_move_info_toc = {path: {y: number, z: number, x: number, }[], end_point: {y: number, z: number, x: number, }, cur_point: {y: number, z: number, x: number, }, obj_id: number, status: number, obj_type: number, };


}