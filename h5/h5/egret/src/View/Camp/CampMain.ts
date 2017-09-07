module ui {

	export class CampMain extends UIBase {
        
        private soldierData: any;
        private soldierList: eui.List;
        private soldierScroller: eui.Scroller;
        private isClickedItem: boolean;
        private item;
        private point: egret.Point;
        private group: eui.Group;
        private groupPoint: egret.Point;
        private selectedIndex: number;
        private data: any;
        private backGroup: eui.Group;
        private preGroup: eui.Group;
        private midGroup: eui.Group;
        private preHeadGroup: eui.Group;
        private midHeadGroup: eui.Group;
        private backHeadGroup: eui.Group;
        private labelHum: eui.Label;
        private labelChariot: eui.Label;
        private labelFighter: eui.Label;
        private labelBiochemical: eui.Label;
        private preHeadBg: eui.Image;
        private midHeadBg: eui.Image;
        private backHeadBg: eui.Image;

        private static CUSTOM = {
            skinName : "resource/ui/Camp/CampUISkin.exml",
            binding : {
                ["btn_Hum"] : { method : "onBtnHum", },
                ["btn_Chariot"] : { method : "onBtnChariot",}, 
                ["btn_Fighter"] : { method : "onBtnFighter",},
                ["btn_Biochemical"] : { method : "onBtnBiochemical",},
                ["btnClose"] : { method : "onBtnClose" ,},
            },
        }

		public constructor() {
			super(CampMain.CUSTOM);
		}

        protected onEnter(): void {
            super.onEnter();
            this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
			this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
			this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
            LogicMgr.get(logic.Camp).on(logic.Camp.EVT.SOLDIER_TOUCH_BEGIN, this.Event("onSoldierTouchBegin"));
            NetMgr.get(msg.Army).on("m_army_set_soldier_toc", this.Event("onArmySetSoldier"));

            this.soldierData = RES.getRes("SoldierConfig_json");
            let data = this.getDataByType(SoldierType.Human);
            this.refeshData(data);
            this.point = new egret.Point();
            this.initArmy();
        }

        private onArmySetSoldier(param) {

        }

        protected initArmy() {
            let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
            for(let i = 0; i < armyInfo.length; i ++) {
                this.refeshForWrdPhalanx(armyInfo[i].forward_phalanx);
                this.refeshCenterPhalanx(armyInfo[i].center_phalanx);
                this.refeshBackPhalanx(armyInfo[i].back_phalanx);
            }
        }

        private refeshForWrdPhalanx(phalanx) {
            if(phalanx.soldiers_id === 0) {
                return;
            }
            this.preHeadGroup.visible = true;
            this.preHeadBg.source = this.soldierData[phalanx.soldiers_id].portrait;
        }

        private refeshCenterPhalanx(phalanx) {  
            if(phalanx.soldiers_id === 0) {
                return;
            }
            this.midHeadGroup.visible = true;
            this.midHeadBg.source = this.soldierData[phalanx.soldiers_id].portrait;
        }

        private refeshBackPhalanx(phalanx) {
            if(phalanx.soldiers_id === 0) {
                return;
            }
            this.backHeadGroup.visible = true;
            this.backHeadBg.source = this.soldierData[phalanx.soldiers_id].portrait;
        }

        protected setSoldier(build_id: number, army_id: number, pos: number, soldier_type: number) {
                //item.armyName = armyInfo[i].army_id;
             let data = {build_id:build_id, army_id:army_id, pos:pos, soldier_type:soldier_type};
             NetMgr.get(msg.Army).send("m_army_set_soldier_tos", data);
        }

		protected onTouchBegin(e: egret.TouchEvent) {
			console.log("CampMain===onBegin");
            this.point.x = e.stageX;
            this.point.y = e.stageY;
		}	

		protected onTouchMove(e: egret.TouchEvent) {
			console.log("CampMain===onMove");
            if(this.isClickedItem == false || !this.group){
                this.point.x = e.stageX;
                this.point.y = e.stageY;
                return;
            }
			this.group.x += e.stageX - this.point.x;
			this.group.y += e.stageY - this.point.y;
			
			this.point.x = e.stageX;
			this.point.y = e.stageY;
		}

		protected onTouchEnd(e: egret.TouchEvent) {
			console.log("CampMain===onTouchEnd");
            if(this.isClickedItem == false || !this.group) {
                return;
            }
            this.isClickedItem = false;
            this.group.parent.removeChild(this.group);
            this.group = null;
   
            if(this.preGroup.hitTestPoint(e.stageX, e.stageY)) {
                console.log("====this.preGroup");
                let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
                armyInfo[0].forward_phalanx.soldiers_id = parseInt(this.data.id);
                armyInfo[0].forward_phalanx.hp = 100;
                this.refeshForWrdPhalanx(armyInfo[0].forward_phalanx);
                let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[0].army_id);
                this.setSoldier(build_id, armyInfo[0].army_id, 1, parseInt(this.data.id));
            }
            if(this.midGroup.hitTestPoint(e.stageX, e.stageY)){
                console.log("===midGroup");
                let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
                armyInfo[0].center_phalanx.soldiers_id = parseInt(this.data.id);
                armyInfo[0].center_phalanx.hp = 100;
                this.refeshCenterPhalanx(armyInfo[0].center_phalanx);
                let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[0].army_id);
                this.setSoldier(build_id, armyInfo[0].army_id, 2, parseInt(this.data.id));
            }
            if(this.backGroup.hitTestPoint(e.stageX, e.stageY)) {
                console.log("===backGroup");
                let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
                armyInfo[0].back_phalanx.soldiers_id = parseInt(this.data.id);
                armyInfo[0].back_phalanx.hp = 100;
                this.refeshBackPhalanx(armyInfo[0].back_phalanx);
                 let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[0].army_id);
                this.setSoldier(build_id, armyInfo[0].army_id, 3, parseInt(this.data.id));
            }
		}

        private onSoldierTouchBegin(group: eui.Group, data) {
            this.group = group;
            this.groupPoint = this.group.localToGlobal(0, 0);
            this.group.parent.removeChild(this.group);
            this.addChild(this.group);
            this.group.x = this.groupPoint.x;
            this.group.y = this.groupPoint.y;
            this.isClickedItem = true;
            this.data = data;
        }

        protected getDataByType(type) {
            let data = [];
            for(let key in this.soldierData) {
                if(type !== this.soldierData[key].fight_type) {
                    continue;
                }
                let item = {"id": null, 
                            "type": null, 
                            "fight_type": null, 
                            "name": null,
                            "portrait": null
                        };
                item.id = key;
                item.type = this.soldierData[key].type;
                item.fight_type = this.soldierData[key].fight_type;
                item.name = this.soldierData[key].name;
                item.portrait = this.soldierData[key].portrait
                data.push(item);
            }  

            return data;
        }

        private refeshData(data: any[]) {
            this.soldierList.dataProvider = new eui.ArrayCollection(data);
        }

        private changeColorByType(type) {
            this.labelHum.textColor = 0x5F7071;
            this.labelFighter.textColor = 0x5F7071;
            this.labelChariot.textColor = 0x5F7071;
            this.labelBiochemical.textColor = 0x5F7071;
            if(type === SoldierType.Human) {
                this.labelHum.textColor = 0xA5D0F6;
            }

            if(type === SoldierType.Biochemical) {
                this.labelBiochemical.textColor = 0xA5D0F6;
            }

            if(type === SoldierType.Chariot) {
                this.labelChariot.textColor = 0xA5D0F6;
            }

            if(type === SoldierType.Fighter) {
                this.labelFighter.textColor = 0xA5D0F6;
            }
        }

        protected onBtnHum() {
            console.log("onBtnHum");
            this.soldierData = RES.getRes("SoldierConfig_json");
            let data = this.getDataByType(SoldierType.Human);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Human);
        }

        protected onBtnChariot() {
            console.log("onBtnChariot");
            this.soldierData = RES.getRes("SoldierConfig_json");
            let data = this.getDataByType(SoldierType.Chariot);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Chariot);
        }

        protected onBtnFighter() {
            console.log("onBtnFighter");
            this.soldierData = RES.getRes("SoldierConfig_json");
            let data = this.getDataByType(SoldierType.Fighter);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Fighter);
        }

        protected onBtnBiochemical() {
            console.log("onBtnBiochemical");
            this.soldierData = RES.getRes("SoldierConfig_json");
            let data = this.getDataByType(SoldierType.Biochemical);
            this.refeshData(data);
            this.changeColorByType(SoldierType.Biochemical);
        }

        protected onBtnClose() {
            console.log("onBtnClose");
            this.removeFromParent();
        }

        public onChange(e:eui.PropertyEvent) {
        }
	}

    enum SoldierType {
		Human = 1,
		Chariot = 2,
        Fighter = 3,
        Biochemical = 4
	};
}