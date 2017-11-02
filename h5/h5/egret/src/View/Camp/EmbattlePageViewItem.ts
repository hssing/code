module ui {

	export class EmbattlePageViewItem extends IRBase {

        private forwardGroup: eui.Group;
        private forwardFrameBg: eui.Image;
        private forwardHeadGroup: eui.Group;
        private forwardCard: eui.Component;
        private forwardSoilderCount: eui.Label;

        private centerGroup: eui.Group;
        private centerFrameBg: eui.Image;
        private centerHeadGroup: eui.Group;
        private centerCard: eui.Component;
        private centerSoilderCount: eui.Label;

        private backGroup: eui.Group;
        private backFrameBg: eui.Image;
        private backHeadGroup: eui.Component;
        private backCard: eui.Component;
        private backSoilderCount: eui.Label;

		private soldierData;

		private static CUSTOM = {
            skinName : "resource/ui/Camp/CampEmbattleItemUISkin.exml",
        }

		public constructor(data) {
			super(EmbattlePageViewItem.CUSTOM);
		}

		protected onEnter(): void {
			super.onEnter();
			//this.soldierData = RES.getRes("SoldierConfig_json");

			LogicMgr.get(logic.Camp).on(logic.Camp.EVT.EMBATTLE_END, this.Event("onEmbattleEnd"));
		}

	   protected dataChanged():void { 
		   this.refeshPhalanx(this.data.armyInfo.forward_phalanx, SoldierPos.Forward);
		   this.refeshPhalanx(this.data.armyInfo.center_phalanx, SoldierPos.Center);
		   this.refeshPhalanx(this.data.armyInfo.back_phalanx, SoldierPos.Back);
	   }

        private refeshPhalanx(phalanx, pos: string) {
            if(phalanx.soldiers_id === 0) {
                this[pos + "HeadGroup"].visible = false;
                return;
            }
            this[pos + "HeadGroup"].visible = true;
            this[pos + "SoilderCount"].text = phalanx.num;
            this[pos + "Card"]["lbName"].text =  LTEXT(DBRecord.fetchKey("SoldierConfig_json",  phalanx.soldiers_id, "name")); 
            this[pos + "Card"]["imgCard"].source =  DBRecord.fetchKey("SoldierConfig_json",  phalanx.soldiers_id, "portrait");
        }

        private getQualityImgKey(quality: number) {
			let imgKey = DBRecord.fetchKey("SoldierQualityConfig_json", quality, "background");
			return imgKey;
		}

		private onEmbattleEnd(x, y, curPageId, soildier_type) {
			if(!this.data || this.data.pageId != curPageId) {
				return;
			}
			
			let armyInfo = this.data.armyInfo as logic.ArmyInfo
			let buildId = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo.army_id);

            if(this.forwardGroup.hitTestPoint(x, y)) {
				LogicMgr.get(logic.Camp).SendMsgEmbattle(buildId, armyInfo.army_id, 1, soildier_type);
            }
            
            if(this.centerGroup.hitTestPoint(x, y)){
				LogicMgr.get(logic.Camp).SendMsgEmbattle(buildId, armyInfo.army_id, 2, soildier_type);
            }

            if(this.backGroup.hitTestPoint(x, y)) {
				LogicMgr.get(logic.Camp).SendMsgEmbattle(buildId, armyInfo.army_id, 3, soildier_type);
            }
		}
		
	}

	class SoldierPos  {
        public static Forward: string = "forward";
        public static Center: string = "center";
        public static Back: string  = "back";
    }
}