module ui {

	export class CampMain extends ResBase {
        
        private soldierData: any[];
        private soilderPageviewGroup: eui.Group;
        private soldierPageview: PageView;
        private soldierScroller: eui.Scroller;
        private isClickedItem: boolean;
        private point: egret.Point;
        private group: eui.Group;
        private groupPoint: egret.Point;
        private selectedIndex: number;
        private data: any;
        private labelHum: eui.Label;
        private labelChariot: eui.Label;
        private labelFighter: eui.Label;
        private labelBiochemical: eui.Label;
        private curFormationPos: string;
        private pageViewGroup: eui.Group;
        private embattlePageView: PageView
        private curEmbattlePageId: number;
        private imgName: eui.Image;
        private buildName: eui.Label;

        private static CUSTOM = {
            skinName : "resource/ui/Camp/CampUISkin.exml",
            resGroup : ["camp"],
            binding : {
                ["btn_Hum"] : {method : "onBtnHum", },
                ["btn_Chariot"] : {method : "onBtnChariot",}, 
                ["btn_Fighter"] : {method : "onBtnFighter",},
                ["btn_Biochemical"] : {method : "onBtnBiochemical",},
                ["btnClose"] : {method : "onBtnClose" ,},
                ["btnForwardPage"] : {method: "onBtnForwardPage"},
                ["btnNextPage"] : {method : "onBtnNextPage"},
                ["btnConscription"] : {method : "onBtnConscription"},
                ["btnSoldierForward"] : {method : "onBtnSoldierForward"},
                ["btnSoldierNext"] : {method : "onBtnSoldierNext"},
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
            LogicMgr.get(logic.Camp).on(logic.Camp.EVT.SOLDIER_FORMATION, this.Event("setEmbattlePageViewData"));

            this.point = new egret.Point();
            this.soldierData = this.getSoldierData();
            this.curEmbattlePageId = 0;
            this.initEmBattlePageview();
            this.setBaseInfo();
            this.initSoilderPageview();
        }

        private initSoilderPageview() {
            this.soldierPageview = new PageView();
            this.soldierPageview.setPageItem(ui.CampSoldierPageviewItem);
            this.soldierPageview.x = 0;
            this.soldierPageview.y = 0;
            this.soldierPageview.width = this.soilderPageviewGroup.width;
            this.soldierPageview.height = this.soilderPageviewGroup.height;
            this.soldierPageview.setTouchEnabled(false);
            this.soilderPageviewGroup.addChild(this.soldierPageview);
            let data = this.getSoldierDatasByType(SoldierType.Human);
            this.soldierPageview.setData(data);
        }

        private getSoldierData(): any[] {
            let soldierData: any[] = new Array<any>();
            let ids: number[] =LogicMgr.get(logic.Camp).getSoldierIds();
            for(let i: number = 0; i < ids.length; i ++) {
                let cfg = LogicMgr.get(logic.Camp).getSoldierCfgById(ids[i]);
                soldierData.push(cfg);
            }
            return soldierData;
        }

        private setBaseInfo() {
            this.curEmbattlePageId = this.embattlePageView.getCurPageId();
            let data = this.embattlePageView.getCurPageDataById(this.curEmbattlePageId);
            this.buildName.text = data.buildName;
        }

        protected initEmBattlePageview() {
            this.embattlePageView = new PageView();
            this.embattlePageView.setPageItem(ui.EmbattlePageViewItem);
            this.embattlePageView.x = 0;
            this.embattlePageView.y = 0;
            this.embattlePageView.width = this.pageViewGroup.width;
            this.embattlePageView.height = this.pageViewGroup.height;
            this.embattlePageView.setTouchEnabled(false);
            this.pageViewGroup.addChild(this.embattlePageView);
            this.setEmbattlePageViewData()
        }

        private setEmbattlePageViewData() {
            let armyInfos: Array<logic.ArmyInfo> = LogicMgr.get(logic.Build).getAllArmyInfo();
            let data = this.getEmBattlePageVewData(armyInfos);
            this.embattlePageView.setData(new eui.ArrayCollection(data));
        }

        private getEmBattlePageVewData(armyInfos: Array<logic.ArmyInfo>) {
            let data = [];
            for(let i = 0; i < armyInfos.length; i ++) {
                let buildId = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfos[i].army_id);
                let buildInfo = LogicMgr.get(logic.Build).getInfo(buildId);
                let name = LogicMgr.get(logic.Build).getNameById(buildInfo.type);
                let item = {armyInfo: armyInfos[i], pageId: i, buildName: name};
                data.push(item);
            }
            return data;
        }

        private onBtnForwardPage() {
            this.embattlePageView.forwardPage();
            this.setBaseInfo();
        }

        private onBtnNextPage() {
            this.embattlePageView.nextPage();
            this.setBaseInfo();
        }

		protected onTouchBegin(e: egret.TouchEvent) {
            this.point.x = e.stageX;
            this.point.y = e.stageY;
		}	

		protected onTouchMove(e: egret.TouchEvent) {
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
            if(this.isClickedItem == false || !this.group) {
                return;
            }
            this.isClickedItem = false;
            this.group.parent.removeChild(this.group);
            this.group = null;
            
            let curPageid = this.embattlePageView.getCurPageId();
            LogicMgr.get(logic.Camp).fireEvent(logic.Camp.EVT.EMBATTLE_END, e.stageX, e.stageY, curPageid, this.data.id);
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

        protected getSoldierDatasByType(type) {
            let data = [];
            for(let i: number = 0; i < this.soldierData.length; i ++) {
                if(!this.soldierData[i]) {
                    continue;
                }

                if(type !== this.soldierData[i].type) {
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
                item.id = this.soldierData[i].id;
                item.type = this.soldierData[i].type;
                item.fight_type = this.soldierData[i].fight_type;
                item.name = this.soldierData[i].name;
                item.portrait = this.soldierData[i].portrait;
                item.frameBg = this.soldierData[i].frameBg;
                item.numBg = this.soldierData[i].numBg;
                data.push(item);
            }  
            
            let pageDatas = [];
            for(let i: number = 0; i < data.length; i = i + 4) {
                let pageItem = [];
                pageItem.push(data[i]);
                pageItem.push(data[i + 1]);
                pageItem.push(data[i + 2]);
                pageItem.push(data[i + 3]);
                pageDatas.push(pageItem);
            }
            return new eui.ArrayCollection(pageDatas);
        }

        protected onBtnHum() {
            let data = this.getSoldierDatasByType(SoldierType.Human);
            this.soldierPageview.setCurPageId(0);
            this.soldierPageview.setData(data);
        }

        protected onBtnChariot() {
            let data = this.getSoldierDatasByType(SoldierType.Chariot);
            this.soldierPageview.setCurPageId(0);
            this.soldierPageview.setData(data);
        }

        protected onBtnFighter() {
            let data = this.getSoldierDatasByType(SoldierType.Fighter);
            this.soldierPageview.setCurPageId(0);
            this.soldierPageview.setData(data);
        }

        protected onBtnBiochemical() {
            let data = this.getSoldierDatasByType(SoldierType.Biochemical);
            this.soldierPageview.setCurPageId(0);
            this.soldierPageview.setData(data);
        }

        protected onBtnClose() {
            this.removeFromParent();
        }

        protected onBtnConscription() {
            UIMgr.open(ui.CampConscription);
        }

        protected onBtnSoldierForward() {
            this.soldierPageview.forwardPage();
        }

        protected onBtnSoldierNext() {
            this.soldierPageview.nextPage();
        }
	}

    export enum SoldierType {
		Human = 1, 
		Chariot = 2,
        Fighter = 3,
        Biochemical = 4
	};
}