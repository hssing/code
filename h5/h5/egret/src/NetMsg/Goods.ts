namespace msg {

	export class Goods extends NetMsg {

		public modId: number = 170;
		public subIds = 
		{
			0 : "m_goods_tos",
			1 : "m_goods_toc",
			2 : "m_goods_del_toc",
			3 : "m_goods_add_toc",
			4 : "m_goods_update_toc",
			5 : "m_goods_use_tos",
			6 : "m_goods_use_toc",
			7 : "m_goods_add_tos",
		};

		public on(name: "m_goods_toc"|"m_goods_del_toc"|"m_goods_add_toc"|"m_goods_update_toc"|"m_goods_use_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_goods_tos"|"m_goods_use_tos"|"m_goods_add_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

	export type m_goods_tos = {code: number, };

	export type m_goods_toc = {code: number, goods: {tid: number, type: number, num: number, id: number, }[], };

	export type m_goods_del_toc = {code: number, goods: {tid: number, type: number, num: number, id: number, }[], };

	export type m_goods_add_toc = {code: number, goods: {tid: number, type: number, num: number, id: number, }[], };

	export type m_goods_update_toc = {code: number, goods: {tid: number, type: number, num: number, id: number, }[], };

	export type m_goods_use_tos = {code: number, num: number, id: number, };

	export type m_goods_use_toc = {ret_code: number, num?: number, id?: number, code?: number, };

	export type m_goods_add_tos = {tid: number, num: number, };


}