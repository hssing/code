namespace msg {

	export class City extends NetMsg {

		public modId: number = 180;
		public subIds = 
		{
			0 : "m_city_create_tos",
			1 : "m_city_create_toc",
		};

		public on(name: "m_city_create_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_city_create_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_city_create_tos = {y: number, x: number, city_type: number, };

	export type m_city_create_toc = {ret_code: number, };


}