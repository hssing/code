module ui {
	export class BuildInfo extends UIBase {

		private buildName: eui.Label;
		private hp: eui.Label;
		private attackPower: eui.Label;
		private defense: eui.Label;
		private psionic: eui.Label;
		private range: eui.Label;
		private attackRate: eui.Label;
		private describe: eui.Label;
		private resourceGroup: eui.Group;
		private energy: eui.Label;
		private resource: eui.Label;
		private portrait: eui.Image;

		private buildId: number;
		private buildLevelCfg: any;

        private static CUSTOM = {
			closeBg : {alpha: 0.5, disable: false},
			resGroup : ["buildInfo"],
            skinName : "resource/ui/BuildUISkins/BuildInfoUISkin.exml",		
            binding : {
                ["btnClose"] : { method : "onBtnClose", },
            },
        }

		public constructor(buildId: number) {
			super(BuildInfo.CUSTOM);

			this.buildId = buildId;
		}

		public onEnter() {
			super.onEnter();
			let info: logic.BuildBaseInfo = LogicMgr.get(logic.Build).getInfo(this.buildId);
			this.buildLevelCfg = DBRecord.fetchKvs("BuildingLevelConfig_json", {type: info.type, lv: info.lv})[0]; 
			this.initBuildInfo()
		}

		private initBuildInfo() {
			let info = this.buildLevelCfg;
			this.portrait.source = LogicMgr.get(logic.Build).getBuildingFacade(info.type, info.lv, info.build_state);

			let nameTextId = this.buildLevelCfg.name;
			let name = LTEXT(nameTextId);
			this.buildName.text = name;			
			this.hp.text = this.buildLevelCfg.hp;
			this.attackPower.text = this.buildLevelCfg.strength;
			this.defense.text = this.buildLevelCfg.defence;
			this.psionic.text = this.buildLevelCfg.spirit;
			this.range.text = this.buildLevelCfg.attack_distance;
			this.attackRate.text = this.buildLevelCfg.attack_speed;
			let describeId = this.buildLevelCfg.describe;
			let describe = LTEXT(describeId);
			this.describe.text = describe;
			this.describe.visible = true;

			let type = DBRecord.fetchKey("BuildingConfig_json", this.buildLevelCfg.type, "type");
			switch(type) {
				case logic.BuildType.CommandCenter: 
					this.resourceGroup.visible = false;
					this.describe.visible = true;
					break;
				default:
					break;
			}
		}

		protected onBtnClose() {
			this.removeFromParent();
		}
	}
}