module ui {
	export class PropExtendListItem extends IRBase {
		
		private propList: eui.List

        private static CUSTOM = {
            skinName : "resource/ui/Bag/PropExtendListItemSkin.exml",
        }

		public constructor() {
			super(PropExtendListItem.CUSTOM);
		}

		protected onEnter() {
			super.onEnter();
		}

		protected dataChanged(): void { 
			let data = this.getData();
			this.propList.dataProvider = new eui.ArrayCollection(data);
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