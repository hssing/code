namespace msg {

	export class Build extends NetMsg {

		public modId: number = 130;
		public subIds = 
		{
			0 : "m_build_get_build_list_tos",
			1 : "m_build_get_build_list_toc",
			2 : "m_build_go_to_battle_tos",
			3 : "m_build_go_to_battle_toc",
			4 : "m_build_create_building_tos",
			5 : "m_build_create_building_toc",
			6 : "m_build_upgrade_building_tos",
			7 : "m_build_upgrade_building_toc",
			8 : "m_build_repair_building_tos",
			9 : "m_build_repair_building_toc",
			10 : "m_build_remove_building_tos",
			11 : "m_build_remove_building_toc",
			12 : "m_build_move_building_tos",
			13 : "m_build_move_building_toc",
			14 : "m_build_turn_building_tos",
			15 : "m_build_turn_building_toc",
			16 : "m_build_rebuild_building_tos",
			17 : "m_build_rebuild_building_toc",
			19 : "m_build_push_building_toc",
			20 : "m_build_push_res_capacity_toc",
			21 : "m_build_push_res_production_toc",
		};

		public on(name: "m_build_get_build_list_toc"|"m_build_go_to_battle_toc"|"m_build_create_building_toc"|"m_build_upgrade_building_toc"|"m_build_repair_building_toc"|"m_build_remove_building_toc"|"m_build_move_building_toc"|"m_build_turn_building_toc"|"m_build_rebuild_building_toc"|"m_build_push_building_toc"|"m_build_push_res_capacity_toc"|"m_build_push_res_production_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_build_get_build_list_tos"|"m_build_go_to_battle_tos"|"m_build_create_building_tos"|"m_build_upgrade_building_tos"|"m_build_repair_building_tos"|"m_build_remove_building_tos"|"m_build_move_building_tos"|"m_build_turn_building_tos"|"m_build_rebuild_building_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_build_get_build_list_toc = {build_list: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }[], city_list: {y: number, x: number, city_type: number, id: number, }[], };

	export type m_build_go_to_battle_tos = {build_id: number, y: number, army_id: number, x: number, };

	export type m_build_go_to_battle_toc = {ret_code: number, };

	export type m_build_create_building_tos = {y: number, city_id?: number, id: number, x: number, };

	export type m_build_create_building_toc = {map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, };

	export type m_build_upgrade_building_tos = {building_id: number, };

	export type m_build_upgrade_building_toc = {map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, };

	export type m_build_repair_building_tos = {building_id: number, };

	export type m_build_repair_building_toc = {map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, };

	export type m_build_remove_building_tos = {building_id: number, };

	export type m_build_remove_building_toc = {map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, };

	export type m_build_move_building_tos = {y: number, building_id: number, x: number, };

	export type m_build_move_building_toc = {ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }[], map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }[], };

	export type m_build_turn_building_tos = {y: number, building_id: number, x: number, };

	export type m_build_turn_building_toc = {map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, };

	export type m_build_rebuild_building_tos = {building_id: number, };

	export type m_build_rebuild_building_toc = {map_build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, city_id?: number, durability: number, ower_info: {lv: number, role_id: number, camp: number, nick: string, }, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, ret_code: number, build_info: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }, };

	export type m_build_push_building_toc = {build_info_list: {build_id: number, lv: number, build_state: number, durability_limit: number, y: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], city_id?: number, durability: number, end_time: number, type: number, start_time: number, x: number, opt_state: number, }[], };

	export type m_build_push_res_capacity_toc = {p_res_capacity: {steel: number, stone: number, redif: number, cereals: number, soil: number, }, };

	export type m_build_push_res_production_toc = {p_res_capacity_production: {stone: number, redif: number, soil: number, steel: number, cereals: number, coin: number, }, };


}