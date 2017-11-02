module ui {
	export class ConscriptionListInfoItem extends IRBase {

		private headGroup: eui.Group;
		private headBg: eui.Image;
		private soldierName: eui.Label;
		private numBg: eui.Image;
		private frameBg: eui.Image;
		private squareName: eui.Label;
		private existingCount: eui.Label;
		private inscreasedCount: eui.Label;
		private existingPopulation: eui.Label;
		private increasedPopulation: eui.Label;
		private time: eui.Label;
		private redifCount: eui.Label;
		private infoGroup: eui.Group;
		private hintInfo: eui.Label;
		private btnChoseRedif: eui.CheckBox;
		private sliderAddRedif: eui.HSlider;
		private cmpCfg: any;
		private soldierCfg: any;

		private static interval: number =  500;
		private static event: string = "refeshTimer";

		private static CUSTOM = {
            skinName : "resource/ui/Camp/CampConscriptionListItemUISkin.exml",
            binding : {
				["btnAdd"] : {method: "onBtnAdd"},
				["btnSub"] : {method: "onBtnSub"},
            },
        }

		public constructor() {
			super(ConscriptionListInfoItem.CUSTOM);
		}

		public onEnter() {
			super.onEnter();
		}

		protected dataChanged(): void { 
			let data = this.data.soldierInfo as logic.SoldierInfo;
			this.setPhalanx(data, this.data.name)
			this.initTimer();
		}

		private initTimer() {
			let enroolInfo = LogicMgr.get(logic.Camp).getEnroolInfoByAmyId(this.data.army_id);
			if(!enroolInfo) {
				return
			}

			let army_enrolling = enroolInfo.army_enrolling;
			for(let i: number = 0; i < army_enrolling.length; i++) {
				if(army_enrolling[i].pos === this.data.pos) {
					Singleton(Timer).cancel(this, ConscriptionListInfoItem.event);
					Singleton(Timer).repeat(ConscriptionListInfoItem.interval, this.Event(ConscriptionListInfoItem.event, this.refeshStatus));
				}
			}
		}

		private setPhalanx(phalanx: logic.SoldierInfo, name: string) {
            if(phalanx.soldiers_id === 0) {
                this.headGroup.visible = false;
				this.infoGroup.visible = false;
				this.hintInfo.text = "请先部署部队";
				this.hintInfo.visible = true;
                return;
            }

			this.soldierCfg = LogicMgr.get(logic.Camp).getSoldierCfgById(phalanx.soldiers_id);
			
			this.hintInfo.visible = false;
            this.headGroup.visible = true;
			this.squareName.text = name;
            this.headBg.source = this.soldierCfg.portrait;
            this.soldierName.text = this.soldierCfg.name;
            this.numBg.source = this.soldierCfg.numBg;
            this.frameBg.source = this.soldierCfg.frameBg;

			this.existingCount.text = phalanx.num.toString();
			this.existingPopulation.text = (this.soldierCfg.population * phalanx.num).toString();
			this.redifCount.text = LogicMgr.get(logic.Player).getRedidf().toString();
			this.time.text = "00:00:00";

			this.cmpCfg = LogicMgr.get(logic.Camp).getCampCfg(this.data.army_id);
			this.sliderAddRedif.minimum = 0;
			this.sliderAddRedif.maximum = this.cmpCfg.population_lim / this.soldierCfg.population;
			this.sliderAddRedif.addEventListener(eui.UIEvent.CHANGE, this.changeHandler, this);
			this.refeshStatus()
        }

		private refeshStatus() {
			let enroolInfo = LogicMgr.get(logic.Camp).getEnroolInfoByAmyId(this.data.army_id);
			if(!enroolInfo) {
				return
			}

			let army_enrolling = enroolInfo.army_enrolling;
			for(let key in army_enrolling) {
				if(army_enrolling[key].pos === this.data.pos) {
					let end_time = enroolInfo.start_time + this.soldierCfg.conscription_time * 0.1 * army_enrolling[key].enroll_num;
					let sec = ServerTime.getDiffTime(end_time);
					
					if(sec < 0) {
						return;
					}
					
					if(sec === 0) {
						Singleton(Timer).cancel(this, ConscriptionListInfoItem.event);
						this.refeshData();
					}

					let st = ServerTime.secToDay(sec);
					this.time.text = ServerTime.formatTime(st);
				}
			}
		}

		private refeshData() {
			let enroolInfo = LogicMgr.get(logic.Camp).getEnroolInfoByAmyId(this.data.army_id);
			if(!enroolInfo) {
				return
			}

			let army_enrolling = enroolInfo.army_enrolling;
			for(let i: number = 0; i < army_enrolling.length; i++) {
				if(army_enrolling[i].pos === this.data.pos) {
					 let armyInfos = LogicMgr.get(logic.Build).getAllArmyInfo();
					 let info = armyInfos.filter((info) => {
						 return this.data.army_id === info.army_id;
					 })[0] as logic.ArmyInfo;
		
					 if(this.data.pos === logic.PhalanxLocation.forward) {
						info.forward_phalanx.num += army_enrolling[i].enroll_num;
					 }

					 LogicMgr.get(logic.Build).setArmyInfo([info]);
					 army_enrolling.splice(i, 1)
					 enroolInfo.army_enrolling = army_enrolling;
					 LogicMgr.get(logic.Camp).setEnroolInfoByArmyId(this.data.army_id, enroolInfo);
					 LogicMgr.get(logic.Camp).fireEvent(logic.Camp.EVT.REFESH_CONSCRIPTION);
				}
			}

		}

		private changeHandler(evt: eui.UIEvent): void {
			this.setData();
		}

		private onBtnAdd() {
			if(this.sliderAddRedif.value === this.sliderAddRedif.maximum) {
				return;
			}
			this.sliderAddRedif.value = this.sliderAddRedif.value + 1;
			this.setData();
		}

		private onBtnSub() {
			if(this.sliderAddRedif.value === 0) {
				return;
			} 
			this.sliderAddRedif.value = this.sliderAddRedif.value - 1;
			this.setData();
		}
		
		private setData() {
			let count1 =  LogicMgr.get(logic.Camp).getUsedRedifPopulation(logic.PhalanxLocation.forward);
			let count2 = LogicMgr.get(logic.Camp).getUsedRedifPopulation(logic.PhalanxLocation.center);
			let count3 = LogicMgr.get(logic.Camp).getUsedRedifPopulation(logic.PhalanxLocation.back);
			let count = LogicMgr.get(logic.Camp).getHavedPopulation(this.data.army_id);
			let curPosCount = LogicMgr.get(logic.Camp).getUsedRedifPopulation(this.data.pos);
			let total: number = count1 + count2 + count3 + count + this.soldierCfg.population * this.sliderAddRedif.value - curPosCount;
			if(total > parseInt(this.cmpCfg.population_lim)) {
				this.sliderAddRedif.value = Math.floor((this.cmpCfg.population_lim - count2 
								- count3 - count - count1 + curPosCount) / this.soldierCfg.population)
			}
			this.increasedPopulation.text = "+" + (this.sliderAddRedif.value * this.soldierCfg.population).toString();
			this.inscreasedCount.text = "+" + (this.sliderAddRedif.value).toString();
			let usedPopulation = this.sliderAddRedif.value * this.soldierCfg.population;
			LogicMgr.get(logic.Camp).setUsedRedifPopution(usedPopulation, parseInt(this.data.pos), this.btnChoseRedif.selected, this.soldierCfg.population);
		}
	}
}