module logic {
	export class Bag extends Logic {

		private goodDatas: Map<number, BagData>;

        public static EVT = utils.Enum([
            "REFRESH_BAG_DATA",
			"ITEM_CLICKED",
			"REMOVE_EXTENDITEM",
        ]);

		public constructor() {
			super();

			this.goodDatas = new Map<number, BagData>();
			NetMgr.get(msg.Goods).on("m_goods_del_toc", this.Event("onDeleteGoods"));
			NetMgr.get(msg.Goods).on("m_goods_use_toc", this.Event("onUseGoods"));
			NetMgr.get(msg.Goods).on("m_goods_update_toc", this.Event("onUpdateGoods"));
			NetMgr.get(msg.Goods).on("m_goods_add_toc", this.Event("onAddGoods"));
		}

		public sendmsgGetGoods(id: number) {
			let data = {code: id};
			NetMgr.get(msg.Goods).send("m_goods_tos", data);
		}

		public sendMsgUseGoods(id: number, num: number, code: number) {           
			let data = {id: id, num: num, code: code};
			NetMgr.get(msg.Goods).send("m_goods_use_tos", data);
		}

		public sendMsgAddGood(tid: number, num: number) {
			let data = {tid: tid, num: num};
			NetMgr.get(msg.Goods).send("m_goods_add_tos", data);
		}

		public onUseGoods(data: msg.m_goods_use_toc) {
			console.log("onUseGoods");
		}

		public onDeleteGoods(data: msg.m_goods_del_toc) {
			if(!this.goodDatas[data.code]) {
				return
			}

			for(let i: number = 0; i < data.goods.length; i ++) {
				this.goodDatas[data.code].goods = this.goodDatas[data.code].goods.filter((info) => {
					return info.id != data.goods[i].id;
				});
			}

			this.fireEvent(logic.Bag.EVT.REFRESH_BAG_DATA);
		}

		public setGoods(data: msg.m_goods_toc) {
			this.goodDatas[data.code] = {id: data.code, goods: data.goods};
			this.fireEvent(logic.Bag.EVT.REFRESH_BAG_DATA);
		}

		private onUpdateGoods(data: msg.m_goods_update_toc) {
			if(!this.goodDatas[data.code]) {
				return;
			}

			for(let i: number = 0; i < data.goods.length; i ++) {
				for(let j: number = 0; j < this.goodDatas[data.code].goods.length; j ++) {
					if(data.goods[i].id !== this.goodDatas[data.code].goods[j].id) {
						continue;
					} 

					this.goodDatas[data.code].goods[j] = data.goods[i];
				}
			}

			this.fireEvent(logic.Bag.EVT.REFRESH_BAG_DATA);
		}

		private onAddGoods(data: msg.m_goods_add_toc) {
			if(!this.goodDatas[data.code]) {
				return
			}
			this.goodDatas[data.code].goods = this.goodDatas[data.code].goods.concat(data.goods);
			this.fireEvent(logic.Bag.EVT.REFRESH_BAG_DATA);
		}

		public getBagDataById(id: number): BagGood[] {
			if(this.goodDatas[id]) {
				return this.goodDatas[id].goods;
			}
			return undefined;
		}	

	}

	export class BagGood {
		public id: number;  	//物品唯一id
		public tid: number;		//物品表里面的id
		public type: number;	
		public num: number;		//资源
	}

	export class BagData {
		public id: number; 				//这个字段是为了防止以后出现多种不同的背包而设置的字段
		public goods: Array<BagGood>;	//这个是对应的背包的数据
	}
}