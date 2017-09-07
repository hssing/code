namespace ui {

    export class ServerList extends UIBase {

		private serverList: eui.List;
    
        private static CUSTOM = {
            closeBg : {alpha: 0.5, disable: false},
            skinName : "resource/ui/ServerListUISkin.exml",
        }

        private param: any;

        public constructor(param) {
			super(ServerList.CUSTOM)
        }

        protected onEnter(): void {
			super.onEnter()
			let serverListData = LogicMgr.get(logic.Login).getServerListInfo();
			this.serverList.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.onItemTouch, this);
			let data = this.getData(serverListData);
			this.refresh(data);
        }

        private getData(serverListData: any[]) {
            let data = []
            for(let i = 0; i < serverListData.length; i ++) {
				let item = new logic.ServerInfo();
                item.name = serverListData[i].name;
                item.ip = serverListData[i].ip;
                item.port = serverListData[i].port;
                item.id = serverListData[i].id;

                data.push(item);
            }
            return data;
        }

        public refresh(data: any[]): void {
            this.serverList.dataProvider = new eui.ArrayCollection(data);
        }

		protected onItemTouch(e: eui.PropertyEvent) {
			this.removeFromParent();
			LogicMgr.get(logic.Login).setCurServerInfo(this.serverList.selectedItem as logic.ServerInfo);
			LogicMgr.get(logic.Login).fireEvent(logic.Login.EVT.REFESH_SERVERINFO);
		}

    }

}