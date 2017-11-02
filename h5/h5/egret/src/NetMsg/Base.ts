namespace msg {

	export class Base extends NetMsg {

		public modId: number = 160;
		public subIds = 
		{
			0 : "m_base_tax_tos",
			1 : "m_base_tax_toc",
			2 : "m_base_tax_buy_count_tos",
			3 : "m_base_tax_buy_count_toc",
		};

		public on(name: "m_base_tax_toc"|"m_base_tax_buy_count_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_base_tax_tos"|"m_base_tax_buy_count_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_base_tax_toc = {ret_code: number, base_tax: {next_timestamp: number, buy_count_used: number, today_tax_count: number, today_buy_count: number, }, };

	export type m_base_tax_buy_count_toc = {ret_code: number, base_tax: {next_timestamp: number, buy_count_used: number, today_tax_count: number, today_buy_count: number, }, };


}