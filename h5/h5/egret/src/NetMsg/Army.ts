namespace msg {

	export class Army extends NetMsg {

		public modId: number = 140;
		public subIds = 
		{
			1 : "m_army_get_own_soldier_tos",
			2 : "m_army_get_own_soldier_toc",
			3 : "m_army_set_soldier_tos",
			4 : "m_army_set_soldier_toc",
			5 : "m_army_get_own_map_army_pos_tos",
			6 : "m_army_get_own_map_army_pos_toc",
			7 : "m_army_enroll_soldier_tos",
			8 : "m_army_enroll_soldier_toc",
			9 : "m_get_soldier_info_tos",
			10 : "m_get_soldier_info_toc",
			11 : "m_get_soldier_intensify_info_tos",
			12 : "m_get_soldier_intensify_info_toc",
			13 : "m_intensify_soldier_tos",
			14 : "m_intensify_soldier_toc",
		};

		public on(name: "m_army_get_own_soldier_toc"|"m_army_set_soldier_toc"|"m_army_get_own_map_army_pos_toc"|"m_army_enroll_soldier_toc"|"m_get_soldier_info_toc"|"m_get_soldier_intensify_info_toc"|"m_intensify_soldier_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_army_get_own_soldier_tos"|"m_army_set_soldier_tos"|"m_army_get_own_map_army_pos_tos"|"m_army_enroll_soldier_tos"|"m_get_soldier_info_tos"|"m_get_soldier_intensify_info_tos"|"m_intensify_soldier_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_army_get_own_soldier_toc = {soldiers: number[], };

	export type m_army_set_soldier_tos = {build_id: number, army_id: number, soldier_type: number, pos: number, };

	export type m_army_set_soldier_toc = {redif?: number, ret_code: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], };

	export type m_army_get_own_map_army_pos_toc = {army_pos_list: {y: number, army_id: number, x: number, }[], };

	export type m_army_enroll_soldier_tos = {building: number, army_enroll_list: {use_ready: number, enroll_num: number, pos: number, }[], };

	export type m_army_enroll_soldier_toc = {ret_code: number, army_list: {forward_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, army_id: number, center_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, back_phalanx: {soldiers_id: number, num?: number, max_hp: number, hp: number, }, is_out: number, }[], army_enrolling: {building: number, army_enrolling: {enroll_num: number, pos: number, }[], end_time: number, start_time: number, }, ready_soldier: number, };

	export type m_get_soldier_info_tos = {soldier_id: number, };

	export type m_get_soldier_info_toc = {soldier_info: {lv: number, crit: number, strength: number, hp: number, defence: number, move_speed: number, energy: number, armor_penetration: number, attack_speed: any, soldier_id: number, lingneng: number, attack_distance: number, }, };

	export type m_get_soldier_intensify_info_tos = {soldier_id: number, };

	export type m_get_soldier_intensify_info_toc = {intensify_info: {lv: number, probability: number, }, };

	export type m_intensify_soldier_tos = {soldier_id: number, };

	export type m_intensify_soldier_toc = {ret_code: number, intensify_info: {lv: number, probability: number, }, };


}