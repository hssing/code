namespace msg {

	export class Login extends NetMsg {

		public modId: number = 100;
		public subIds = 
		{
			0 : "m_login_auth_tos",
			1 : "m_login_auth_toc",
			2 : "m_login_create_role_tos",
			3 : "m_login_create_role_toc",
			4 : "m_login_get_role_detail_tos",
			5 : "m_login_get_role_detail_toc",
		};

		public on(name: "m_login_auth_toc"|"m_login_create_role_toc"|"m_login_get_role_detail_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_login_auth_tos"|"m_login_create_role_tos"|"m_login_get_role_detail_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_login_auth_tos = {aid: string, };

	export type m_login_auth_toc = {ret_code: number, login_info: {lv: number, role_id: number, nick: string, }[], server_time: number, };

	export type m_login_create_role_tos = {sex: number, camp: number, nick: string, };

	export type m_login_create_role_toc = {ret_code: number, role_id: number, };

	export type m_login_get_role_detail_tos = {role_id: number, };

	export type m_login_get_role_detail_toc = {ret_code: number, role_info: {lv: number, role_id: number, base_tax?: {next_timestamp: number, buy_count_used: number, today_tax_count: number, today_buy_count: number, }, next_lv_exp: number, camp: number, vip_lv: number, p_res: {stone?: number, soil_base?: number, ingot?: number, redif?: number, steel_base?: number, stone_base?: number, cereals_base?: number, steel?: number, cereals?: number, energy?: number, soil?: number, coin?: number, }, army_enroll_info: {building: number, army_enrolling: {enroll_num: number, pos: number, }[], end_time: number, start_time: number, }[], nick: string, cur_exp: number, }, };


}