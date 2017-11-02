module ui {
	export class BuildUpgrade extends UIBase {

		private lbNeedTime: eui.Label;
		private buildName: eui.Label;
		private hp: eui.Label;
		private attackPower: eui.Label;
		private defense: eui.Label;
		private psionic: eui.Label;
		private range: eui.Label;
		private attackRate: eui.Label;
		private portrait: eui.Image;
		private describeBg: eui.Image;
		private maskObj: eui.Image;
		private down: egret.tween.TweenGroup;
		private up: egret.tween.TweenGroup;
		private btnDetail: eui.CheckBox;
		private unLockList: eui.List;
		private group: eui.Group;
		private upgradeResList: eui.List;
		private describe: eui.Label;
		private updateCondition: eui.Label;
		
		private buildId: number;
		private buildLevelCfg: any;
		private buildInfo: logic.BuildBaseInfo;
		private isInAnimation: boolean;

        private static CUSTOM = {
			closeBg : {alpha: 0.5, disable: false},
            skinName : "resource/ui/BuildUISkins/BuildUpgradeLevelUISkin.exml",
			resGroup : ["buildUpgrade"],
            binding : {
                ["btnClose"] : { method : "onBtnClose", },
				["btnDetail"] : { method : "onBtnDetail"},
				["btnRightUpLv"] : { method : "onBtnRightUpLv"},
				["btnUpLv"] : { method : "onBtnUpLv"},
            },
        }

		public constructor(buildId: number) {
			super(BuildUpgrade.CUSTOM);

			this.buildId = buildId;
			this.isInAnimation = false;
		}

		public onEnter() {
			super.onEnter();
			this.buildInfo = LogicMgr.get(logic.Build).getInfo(this.buildId);
			let buildLevelCfgs = DBRecord.fetchKvs("BuildingLevelConfig_json", {type: this.buildInfo.type, lv: this.buildInfo.lv});
			this.buildLevelCfg = buildLevelCfgs[0];

			this.initBaseInfo();
			this.initUnlockList();
			this.initUpgradeResList();
			this.setUpgradeCDTime();
			let condition = LogicMgr.get(logic.Build).getBuildUpgradeCondition(this.buildInfo.type, this.buildInfo.lv);
			this.setBuildCondtion(condition);
		}

		private setUpgradeCDTime() {
			let kvs = {lv : this.buildInfo.lv + 1, type : this.buildInfo.type, };
			let buildLvCfg = DBRecord.fetchKvs("BuildingLevelConfig_json", kvs);
			let st = ServerTime.secToDay(buildLvCfg[0].upgrade_time);
            this.lbNeedTime.text = ServerTime.formatTime(st);
		}

		private initUpgradeResList() {
			let data: any[] = this.getUpgradeResListData();
			this.upgradeResList.dataProvider = new eui.ArrayCollection(data);
		}

		private initUnlockList() {
			let listData = this.getunLockListData();
			this.unLockList.dataProvider = new eui.ArrayCollection(listData); 
			this.group.mask = this.maskObj;
			this.up.addEventListener('complete', this.onTweenGroupComplete, this);
			this.down.addEventListener('complete', this.onTweenGroupComplete, this);
			this.unLockList.visible = false;
		}

		private initBaseInfo() {
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
		}

		private setBuildCondtion(condition) {
			if(condition[0][0] === 2) {
				this.updateCondition.text = "升级需要玩家" + condition[0][1] + "级";
			} else {
				this.updateCondition.text = "升级需要指挥中心" + condition[0][1] + "级";
			}
		}

		private getUpgradeResListData(): any[] {
			let buildConfigs = DBRecord.fetchKvs("BuildingLevelConfig_json", {type: this.buildInfo.type, lv: (this.buildInfo.lv + 1)});
			if(!buildConfigs || buildConfigs.length === 0) {
				return;
			}

			let updateRes =  buildConfigs[0].upgrade_consume;
			let data = [];
			for(let i: number = 0; i < updateRes.length; i++) {
				let item = {img: null, count: null};
				item.count = updateRes[i][1];
				item.img =   LogicMgr.get(logic.Build).getResImgByResType(updateRes[i][0])
				data.push(item);
			}
			return data;
		}
		
		private getunLockListData() {
			let unLockData = LogicMgr.get(logic.Build).getUnlockBuildNextLVCommandCenter(this.buildInfo.city_id);
			let data = [];
			for(let i: number = 0; i < unLockData.length; i ++) {
				let item = {"unLockLabel": null};
				if(unLockData[i].isFirstCreate) {
					item.unLockLabel = "解锁" + unLockData[i].buildName;
				} else {
					item.unLockLabel = unLockData[i].buildName + "+" + unLockData[i].addCount;
				}
				data.push(item);
			}
			return data;
		}

		private onTweenGroupComplete(event: egret.Event) {
			if(event.target === this.up) {
				this.unLockList.visible = false;
			}

			this.isInAnimation = false;
			this.btnDetail.touchEnabled = true;
		}

		protected onBtnClose() {
			this.removeFromParent();
		}

		protected onBtnDetail() {
			this.btnDetail.touchEnabled = false;
			if(this.isInAnimation) {
				this.btnDetail.touchEnabled = true;
				return;
			}

			this.isInAnimation = true;
			if(this.btnDetail.selected === false) {
				this.up.play(0);
			} else {
				this.down.play(0);
				this.unLockList.visible = true;
			}
		}

		protected onBtnRightUpLv() {
			Prompt.popTip("功能在开发中");
		}

		protected onBtnUpLv() {
			LogicMgr.get(logic.Build).upgradeBuilding(this.buildId);
			this.onClose();
		}
	}
}