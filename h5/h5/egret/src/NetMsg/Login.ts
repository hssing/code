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

}