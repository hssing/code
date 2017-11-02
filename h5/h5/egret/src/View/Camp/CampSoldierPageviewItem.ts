module ui {
	export class CampSoldierPageviewItem extends IRBase {

		private soldierList: eui.List

		private static CUSTOM = {
            skinName : "resource/ui/Camp/CampSoldierPageviewItemSkin.exml",
        }

		public constructor() {
			super(CampSoldierPageviewItem.CUSTOM);
		}

		protected dataChanged(): void { 
			let data = this.getData();
			this.soldierList.dataProvider = new eui.ArrayCollection(data);
		}

        protected getData(): any[] {
            let data = [];
			for(let i: number = 0; i < this.data.length; i ++) {
				if(this.data[i]) {
					data.push(this.data[i]);
				}
			}
			
            return data;
        }
	}
}