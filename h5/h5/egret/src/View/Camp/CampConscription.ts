module ui {
	export class CampConscription extends ResBase {

        private pageViewRoot: eui.Group;
        private conscriptionPageView: PageView;
        private curPageId: number;

        private static CUSTOM = {
            skinName : "resource/ui/Camp/CampConscriptionUISkin.exml",
            binding : {
                ["btnClose"] : { method : "onBtnClose" ,},
                ["btnForwardPage"]: {method: "onBtnForwardPage"},
                ["btnNextPage"]: {method: "onBtnNextPage"},
                ["btnConscription"]: {method: "onBtnConscription"},
            },
        }

		public constructor() {
			super(CampConscription.CUSTOM);
		}

        protected onEnter(): void {
            super.onEnter();
            this.initConscriptionPageView();
            LogicMgr.get(logic.Camp).setUsedRedifPopution(0, logic.PhalanxLocation.forward, false, 0);
            LogicMgr.get(logic.Camp).setUsedRedifPopution(0, logic.PhalanxLocation.center, false, 0);
            LogicMgr.get(logic.Camp).setUsedRedifPopution(0, logic.PhalanxLocation.back, false, 0);

            LogicMgr.get(logic.Camp).on(logic.Camp.EVT.REFESH_CONSCRIPTION, this.Event("setconscriptionPageViewData"));
        }

        protected initConscriptionPageView() {
            this.conscriptionPageView = new PageView();
            this.conscriptionPageView.setPageItem(ui.ConscriptionPageviewItem);
            this.conscriptionPageView.x = 0;
            this.conscriptionPageView.y = 0;
            this.conscriptionPageView.width = this.pageViewRoot.width;
            this.conscriptionPageView.height = this.pageViewRoot.height;
            this.conscriptionPageView.setTouchEnabled(false);
            this.pageViewRoot.addChild(this.conscriptionPageView);
            this.setconscriptionPageViewData()
        }

        private setBaseInfo() {
            this.curPageId = this.conscriptionPageView.getCurPageId();
            let data = this.conscriptionPageView.getCurPageDataById(this.curPageId);
            //this.buildName.text = data.buildName;
        }

        private setconscriptionPageViewData() {
            let armyInfos: Array<logic.ArmyInfo> = LogicMgr.get(logic.Build).getAllArmyInfo();
            let data = this.getEmBattlePageVewData(armyInfos);
            this.conscriptionPageView.setData(new eui.ArrayCollection(data));
            this.setBaseInfo();
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

		protected onBtnClose() {
			this.removeFromParent();
		}

        protected onBtnForwardPage() {
            this.conscriptionPageView.forwardPage();
            this.setBaseInfo();
        }

        protected onBtnNextPage() {
            this.conscriptionPageView.nextPage();
            this.setBaseInfo();
        }
        
        protected onBtnConscription() {
            this.curPageId = this.conscriptionPageView.getCurPageId();
            let data = this.conscriptionPageView.getCurPageDataById(this.curPageId);
            let armyInfo = data.armyInfo;
            LogicMgr.get(logic.Camp).sendMsgConscription(data.armyInfo.army_id);
        }
	}
}