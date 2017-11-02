module ui {

	export class SoldierMain extends ResBase {
        
        // private soldierData: any;
        private soldier_own: eui.List;     
        private soldier_no:  eui.List;
        private group_01: eui.Group;
        private group_02: eui.Group;
        private group_03: eui.Group;
        private group_04: eui.Group;      
        private group_05: eui.Group;                  
        private group_cur: eui.Group;  
        private bg_img:eui.Image;

        private lable_leve:eui.Label;
        private hp:eui.Label;
        private defence:eui.Label;
        private crit:eui.Label;
        private lingneng:eui.Label;
        private attack_distance:eui.Label;
        private energy:eui.Label;

        private lv_before:eui.Label;
        private lv_after:eui.Label;
        private probability:eui.Label;

        private soldierInfo:any; //兵牌详情

        private item:any;
        private soldierData: any;                

        private soilderPageviewGroup: eui.Group;
        private soldierPageview: PageView;                

        private static CUSTOM = {
            skinName : "resource/ui/Soldier/SoldierMainSkin.exml",
            binding : {
                ["btn_atrribute"] : { method : "onAtrribute",}, 
                ["btn_intensify"] : { method : "onIntensify",}, 
                ["btn_skill"] : { method : "onSkill",},
                ["btn_shengxing"] : { method : "onShengxing",},
                ["btn_equip"] : { method : "onEquip",},
                ["btn_upgrade"] : { method : "onUpgrade",},
                ["btn_detail"] : { method : "onDetail",},
                ["btn_toIntensify"] : { method : "onToIntensify",}, 
                ["btn_toUpGrape"] : { method : "onToUpGrape",}, 
                ["btn_toChange"] : { method : "onToChange",}, 
                ["btn_toSmelt"] : { method : "onToSmelt",}, 
                ["btn_rleft"] : { method : "onBtn_rleft",}, 
                ["btn_right"] : { method : "onBtn_right",}, 
                ["btnClose"] : { method : "onBtnClose" ,},
            },
        } 

		public constructor(item,soldierData) {
           
            console.log("type === " + item.type );
            console.log("name === " + item.name );
            console.log("id   === " + item.id );
			super(SoldierMain.CUSTOM);
            this.item = item;
            this.soldierData = soldierData;

            
            LogicMgr.get(logic.Soldier).getSoldierInfo(this.item.id);    
           
		}

        protected onEnter(): void {
            super.onEnter();
            // LogicMgr.get(logic.Camp).on(logic.Camp.EVT.SOLDIER_TOUCH_BEGIN, this.Event("onSoldierTouchBegin"));
            LogicMgr.get(logic.Soldier).on(logic.Soldier.EVT.SOLIDER_INFOR, this.Event("onRefeshData"));
            LogicMgr.get(logic.Soldier).on(logic.Soldier.EVT.SOLIDER_INTENSIFY, this.Event("onIntensifyInfo"));
            LogicMgr.get(logic.Soldier).on(logic.Soldier.EVT.SOLIDER_INTENSIFY_EXECUTE, this.Event("onIntensifyInfoExecute"));
            LogicMgr.get(logic.Player).on(logic.Player.EVT.REFRESH_RES, this.Event("onRefreshRes"));
            LogicMgr.get(logic.Player).refreshRes();

            // this.soldierData = RES.getRes("SoldierConfig_json");
           
            this.group_cur = this.group_01;

            // let id = this.item.id;
            // this.bg_img.source = RES.getRes("common_pic_s" + id + "_png");

            this.initSoilderPageview();
        }


        private initSoilderPageview() {
            this.soldierPageview = new PageView();
            this.soldierPageview.setPageItem(ui.SoldierBigBgItem);
            this.soldierPageview.x = 0;
            this.soldierPageview.y = 0;
            this.soldierPageview.width = this.soilderPageviewGroup.width;
            this.soldierPageview.height = this.soilderPageviewGroup.height;
            this.soldierPageview.setTouchEnabled(false);
            this.soilderPageviewGroup.addChild(this.soldierPageview);
            let data = this.getSoldierDatasByType();
            //  this.soldierPagevie
            this.soldierPageview.setData(data);
        }

        protected getSoldierDatasByType() {
            let data = [];
 
            let index = 0;
            let returnIndex = 0;
            for (let v in this.soldierData){
                let id = this.soldierData[v].id;
                let abc  ="common_pic_s" + id + "_png" ;// RES.getRes("common_pic_s" + id + "_png");
                let item = {"bgImg": null, 
                            "numBg":null 
                        };
                item.bgImg = abc;
                data.push(item);

                index++
            }

            
            let pageDatas = [];
            for(let i: number = 0; i < data.length; i = i + 4) {
                let pageItem = [];
                pageItem.push(data[i]);
            }
            return new eui.ArrayCollection(data);
        }


        private onRefeshData(param) {
            this.soldierInfo = param.soldier_info;
            this.hp.text = this.soldierInfo.hp
            this.defence.text = this.soldierInfo.defence;
            this.crit.text = this.soldierInfo.crit;
            this.lingneng.text = this.soldierInfo.lingneng;
            this.attack_distance.text = this.soldierInfo.attack_distance;
            this.energy.text = this.soldierInfo.energy;
            this.lable_leve.text = "LV:" + this.soldierInfo.lv;
        }
	
        //请求强化信息
        private onIntensifyInfo(param) {
            this.lv_before.text = param.intensify_info.lv;
            this.lv_after.text =  param.intensify_info.lv + 1;
            this.probability.text = param.intensify_info.probability / 100 + "%";
        }

        //执行强化信息
        private onIntensifyInfoExecute(param) {
            //  this.lv_before.text = param.intensify_info.lv; 
            this.setIntensifyInfo(param)          
        }
        
        private setIntensifyInfo(param) {
            if (param.ret_code === 601) {
                Prompt.popTip("资源不足");
            }else if (param.ret_code === 602) {
                Prompt.popTip("兵牌强化成功");
                this.lv_before.text = param.intensify_info.lv;
                this.lv_after.text =  param.intensify_info.lv + 1;
                this.probability.text = param.intensify_info.probability / 100 + "%";           

                //强化成功  重新请求属性
                LogicMgr.get(logic.Soldier).getSoldierInfo(this.item.id);     
            }else if (param.ret_code === 603) {
                Prompt.popTip("兵牌强化失败");
                this.probability.text = param.intensify_info.probability / 100 + "%";                
            }
        }

        protected onAtrribute() {
            console.log("onAtrribute");
            this.group_cur.$setVisible(false);
            this.group_01.$setVisible(true);
            this.group_cur = this.group_01;
        }

        protected onIntensify() {
            // console.log("onIntensify");
            this.group_cur.$setVisible(false);
            this.group_02.$setVisible(true);
            this.group_cur = this.group_02;      

            LogicMgr.get(logic.Soldier).m_get_soldier_intensify_info_tos(this.item.id);
        }



        protected onSkill() {
            console.log("onSkill");
            this.group_cur.$setVisible(false);
            this.group_03.$setVisible(true);
            this.group_cur = this.group_03;                
        }

        protected onShengxing() {
            console.log("onShengxing");
            this.group_cur.$setVisible(false);
            this.group_04.$setVisible(true);
            this.group_cur = this.group_04;                     
        }


        protected onEquip() {
            console.log("onEquip");
            this.group_cur.$setVisible(false);
            this.group_05.$setVisible(true);
            this.group_cur = this.group_05;                  
        }

        protected onUpgrade() {
             Prompt.popTip("升级开发中....");
            //  LogicMgr.get(logic.Soldier).getSoldierInfo(this.item.id);         
        }

        protected onDetail() {
            // Prompt.popTip("onDetail....");
             UIMgr.open(SoldierInfor, "panel",this.soldierInfo);
        }

        protected onToIntensify() {
            //  Prompt.popTip("强化开发中....");
             LogicMgr.get(logic.Soldier).m_intensify_soldier_tos(this.item.id);
        }

        protected onToUpGrape() {
             Prompt.popTip("技能升级开发中....");
        }

        protected onToChange() {
             Prompt.popTip("一键更换开发中....");
        }

        protected onToSmelt() {
             Prompt.popTip("熔炼开发中....");
        }

        protected onBtn_rleft() {
            Prompt.popTip("左键.....");
            this.soldierPageview.forwardPage();
        }

        protected onBtn_right() {
            Prompt.popTip("右键.....");
            this.soldierPageview.nextPage();
        }

        protected onBtnClose() {
            console.log("onBtnClose");
            this.removeFromParent();
        }

        public onChange(e:eui.PropertyEvent) {
        }
	}
}