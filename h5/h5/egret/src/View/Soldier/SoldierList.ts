module ui {

	export class SoldierList extends ResBase { 
        
        private soldierData: any = new Array();
        private soldier_own: eui.List;     
        private soldier_no:  eui.List;

        private mSoldierIds: number[];
 
        private static CUSTOM = {
            skinName : "resource/ui/Soldier/SoldierListSkin.exml",
            binding : {
                ["btn_All"] : { method : "onBtnAll", },
                ["btn_Human"] : { method : "onBtnHum",}, 
                ["btn_Chariot"] : { method : "onBtnChariot",}, 
                ["btn_Mutants"] : { method : "onBtnFighter",},
                ["btn_Zombie"] : { method : "onBtnBiochemical",},
                ["btn_sort"] : { method : "onBtnSort",},
                ["btnClose"] : { method : "onBtnClose" ,},
            },
        }

		public constructor() {
			super(SoldierList.CUSTOM);
		}

        protected onEnter(): void {
            super.onEnter();
            this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
			this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
			this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);

            this.soldier_own.addEventListener(egret.TouchEvent.CHANGE, this.onChange, this);

            let temp_soldierData = RES.getRes("SoldierConfig_json");
                
            this.mSoldierIds = LogicMgr.get(logic.Camp).getSoldierIds();             

            for (let k in temp_soldierData ) {
                for (let i = 0 ; i < this.mSoldierIds.length ; i++) {
                    if (k === i + "" ) {
                        this.soldierData[k] = temp_soldierData[k];
                    }
                }
            }
            this.onBtnAll();
        }

        protected onChange(e:eui.PropertyEvent) {
			let type = this.soldier_own.selectedItem.type;
			let name = this.soldier_own.selectedItem.name;
            console.log("name === " + name);
            UIMgr.open(SoldierMain,"panel",this.soldier_own.selectedItem,this.soldierData);
        }

        protected getDataByType(type) {
            let data = [];
            for(let key in this.soldierData) {
                if(type && type !== this.soldierData[key].type) {
                    continue;
                } 
                let item = {"id": null, 
                            "type": null, 
                            "fight_type": null, 
                            "name": null,
                            "portrait": null,
                            "frameBg":null,
                            "numBg":null
                        };
                item.id = key;
                item.type = this.soldierData[key].type;
                item.fight_type = this.soldierData[key].fight_type;
                
                let cfg = RES.getRes("TextConfig_json");
                let info = cfg[this.soldierData[key].name];
                item.name = info.zhCHS;
                item.portrait = this.soldierData[key].portrait;
                item.frameBg = this.soldierData[key].frameBg;
                item.numBg = this.soldierData[key].numBg;
                data.push(item);
            }  

            return data;
        }

        private refeshData(data: any[]) {
            this.soldier_own.dataProvider = new eui.ArrayCollection(data);
            this.soldier_no.dataProvider = new eui.ArrayCollection(data);
        }

		protected onTouchBegin(e: egret.TouchEvent) {
			// console.log("CampMain===onBegin");
            // this.point.x = e.stageX;
            // this.point.y = e.stageY;
            // UIMgr.open(SoldierMain);
		}	

		protected onTouchMove(e: egret.TouchEvent) {
			// console.log("CampMain===onMove");
            // if(this.isClickedItem == false || !this.group){
            //     this.point.x = e.stageX;
            //     this.point.y = e.stageY;
            //     return;
            // }
			// this.group.x += e.stageX - this.point.x;
			// this.group.y += e.stageY - this.point.y;
			
			// this.point.x = e.stageX;
			// this.point.y = e.stageY;
		}

		protected onTouchEnd(e: egret.TouchEvent) {
			// console.log("CampMain===onTouchEnd");
            // if(this.isClickedItem == false || !this.group) {
            //     return;
            // }
            // this.isClickedItem = false;
            // this.group.parent.removeChild(this.group);
            // this.group = null;
   
            // if(this.preGroup.hitTestPoint(e.stageX, e.stageY)) {
            //     console.log("====this.preGroup");
            //     this.curFormationPos = SoldierPos.Pre;
            //     this.setSoldier(1);
            // }
            // if(this.midGroup.hitTestPoint(e.stageX, e.stageY)){
            //     console.log("===midGroup");
            //     this.curFormationPos = SoldierPos.Mid;
            //     this.setSoldier(2);
            // }
            // if(this.backGroup.hitTestPoint(e.stageX, e.stageY)) {
            //     console.log("===backGroup");
            //     this.curFormationPos = SoldierPos.Back;
            //     this.setSoldier(3);
            // }
		}

        private onSoldierTouchBegin(group: eui.Group, data) {
            // this.group = group;
            // this.groupPoint = this.group.localToGlobal(0, 0);
            // this.group.parent.removeChild(this.group);
            // this.addChild(this.group);
            // this.group.x = this.groupPoint.x;
            // this.group.y = this.groupPoint.y;
            // this.isClickedItem = true;
            // this.data = data;
        }

        protected onBtnAll() {
            console.log("onBtnAll");
            let data = this.getDataByType(undefined);
            this.refeshData(data);
            // this.soldier_own.height +=30
            console.log("this.soldier_own.height 000=== " + this.soldier_own.height);
        }

        protected onBtnHum() {
            console.log("onBtnHum");
            let data = this.getDataByType(SoldierType.Human);
            this.refeshData(data);
            // this.changeColorByType(SoldierType.Human);
        }

        protected onBtnChariot() {
            console.log("onBtnChariot");
            let data = this.getDataByType(SoldierType.Chariot);
            this.refeshData(data);
            // this.changeColorByType(SoldierType.Chariot);
            console.log("this.soldier_own.height 111=== " + this.soldier_own.height);
        }

        protected onBtnFighter() {
            console.log("onBtnFighter");
            let data = this.getDataByType(SoldierType.Fighter);
            this.refeshData(data);
            // this.changeColorByType(SoldierType.Fighter);
        }

        protected onBtnBiochemical() {
            console.log("onBtnBiochemical");
            let data = this.getDataByType(SoldierType.Biochemical);
            this.refeshData(data);
            // this.changeColorByType(SoldierType.Biochemical);
        }

        protected onBtnSort() {
             Prompt.popTip("功能开发中....");
        }

        protected onBtnClose() {
            console.log("onBtnClose");
            this.removeFromParent();
        }
	}
}