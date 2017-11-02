namespace msg {

	export class Fight extends NetMsg {

		public modId: number = 150;
		public subIds = 
		{
			0 : "m_fight_report_toc",
			1 : "m_fight_land_piece_monster_tos",
		};

		public on(name: "m_fight_report_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_fight_land_piece_monster_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_fight_report_toc = {attacker_x: number, is_normal_attack_skill: number, attacker_type: number, attacker_y: number, attack_info_list: {defender_id: number, damage_info_list: {defender_hp: number, state: number, damage: number, }[], defender_x: number, defender_y: number, defender_type: number, }[], attacker_id: number, attacker_hp: number, skill_id: number, };

	export type m_fight_land_piece_monster_tos = {y: number, x: number, };


}